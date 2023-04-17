// $Id: $
/*-
 * Sends request to other/cross domain and returns a response on callback.
 * 
 * If the browser supports CORS (HTTP access control (CORS) <https://developer.mozilla.org/en/docs/HTTP_access_control>), an Ajax request with HTTP Access Control Headers will be send. 
 * 
 * If the browser doesn't supports CORS,
 * Either postMessage <https://developer.mozilla.org/en-US/docs/Web/API/window.postMessage> will be used or  
 * Same origin policy for JavaScript <https://developer.mozilla.org/en-US/docs/Same_origin_policy_for_JavaScript> will be used.
 *
 * To support other trusted domain such as manageengine.com etc. The form will be submitted in an iFrame and postMessage will be used to listen for the response. 
 * 
 * 
 * For even older browsers, The form will be submitted in an iFrame alone with function_name in args. Response of the must call the passed function(parent.funtion_name) with the response.
 */
var CrossServiceRequest = {
	CONSTANTS : {
		RESOURCE_FIELD : "r_", // No I18N
		CUSTOM_FIELD : "x_" // No I18N
	},
	appURLs : {},
	currentForm : null,
	corsOptions : {
		type : "POST", // No I18N
		crossDomain : true,
		xhrFields : {
			withCredentials : true
		}
	},
	postMessageOptions : {
		data : {
			_pmsg : true // No I18N
		}
	},
	jsSameOriginOptions : {
		data : {
			_corsfn : "CrossServiceRequest.handleFrameCallback" // No I18N
		}
	},
	send : function(url, _options, usePostMessage) {
		// Normalize Options
		var options = options || {}; // No I18N
		if ($.type(url) == "object") {
			usePostMessage = _options;
			options = url;
		} else if ($.isFunction(options)) { // url, callback (options)
			options = {
				url : url,
				success : options
			};
		} else {
			options.url = url;
			usePostMessage = options;
		}

		// URL must be provided as Absolute URLs
		if (options.url && options.url.indexOf("http") != 0 && options.url && options.url.indexOf("//") != 0) {
			options.url = ZAConstants.getAbsoluteURL(options.url);
		}
		if ($.support.cors && !usePostMessage) { // CORS supported browser
			options = $.extend(true, {}, options, this.corsOptions);
			$.ajax(options);
		} else { // Submit in iFrame, If postMessage supported listen for 'message' event. else for older browsers use same origin policy of Javascript.
			usePostMessage = usePostMessage && !!window.postMessage;

			// Construct `form` with required parameters.
			var iframeOptions = usePostMessage ? this.postMessageOptions : this.jsSameOriginOptions;
			var isDataInString = options.data && $.type(options.data) == "string"; // No I18N
			if (isDataInString) { // Append the data if the data in `options` is string
				var actualData = options.data;
				options = $.extend(true, {}, options, iframeOptions);
				options.data = actualData + "&" + $.zaParam(iframeOptions.data);
			} else {
				options = $.extend(true, {}, options, iframeOptions);
			}

			this.currentIFrame = CrossServiceRequest.insertCORSFrame();

			// Creating Form element and submit
			var $form = $("<form></form>", {
				action : options.url,
				method : "POST", // No I18N
				autocomplete : "off", // No I18N
				target : "corsFrame" // No I18N
			});
			$.each(isDataInString ? options.data.split("&") : options.data, function(k, v, i) {
				if (isDataInString) {
					i = k;
					var vArr = v.split("=");
					k = Util.duc(vArr[0]);
					v = Util.duc(vArr[1]);
				}
				$("<input>", {
					type : "hidden", // No I18N
					name : k,
					value : v
				}).appendTo($form);
			});
			this.currentForm = $form.appendTo(document.body).data("__cors_options__", options);

			// Pre-submit actions
			if (usePostMessage) {
				$(window).one('message', { // No I18N
					requestURL : options.url
				}, CrossServiceRequest.handleReceiveMessage);
			} else { // update document.domain with Subdomain.
				Util.updateOrigin();
			}

			this.currentForm.submit();
		}
	},
	insertCORSFrame : function() {
		var $frame = $("iframe[name='corsFrame']");
		if (!$frame.length) { // Not present in the document
			$frame = $('<iframe src="' + ZAConstants.img_url + '/images/spacer.gif' + '" name="corsFrame" frameborder="0" scrolling="no" style="display:none;border: none;margin: 0;width: 0;"></iframe>').appendTo(document.body); // No I18N
		}
		return $frame;
	},
	handleResponse : function(data) {
		var options = CrossServiceRequest.currentForm.data("__cors_options__");

		// Delete the Form from the document
		CrossServiceRequest.currentForm.remove();
		CrossServiceRequest.currentForm = null;

		if (options.complete) {
			options.complete.call(options.context || this, data);
		}
		if (options.success) {
			options.success.call(options.context || this, data);
		}
	},
	handleFrameCallback : function(data) {
		CrossServiceRequest.handleResponse(data);
	},
	handleReceiveMessage : function(_ev) {
		var ev = _ev.originalEvent;
		if (!ev.origin || Util.getServerURL(_ev.data.requestURL) !== ev.origin) {
			throw new Error('Message recevied from invalid origin. Origin : ' + ev.origin + ', Expected : ' + _ev.data.requestURL); // No I18N
		}
		if (!ev.source || ev.source !== CrossServiceRequest.currentIFrame.get(0).contentWindow) {
			throw new Error('Message recevied from invalid source'); // No I18N
		}
		var data;
		try {
			data = $.parseJSON(ev.data);
		} catch (e) {
			data = ev.data;
		}
		CrossServiceRequest.handleResponse(data);
	},
	toJSON : function(screen, f, extraParams) {
		var params = {}, hasCustomParam = false, fields = $(f).serializeArray();
		for (var i = 0; i < fields.length; i++) {
			var field = fields[i], name = field.name;
			if (!hasCustomParam && name.indexOf(CrossServiceRequest.CONSTANTS.CUSTOM_FIELD) == 0) {
				hasCustomParam = true;
			}
			if ($(f[name]).data("secret") != "true") { // To avoid sharing password to other App. // No I18N
				params[name] = field.value;
			}
		}

		if (!hasCustomParam) {
			return null;
		} else {
			return {
				v1 : $.extend(true, {
					screen : screen,
					params : params
				}, extraParams)
			};
		}
	},
	getAjaxOptions : function(appName, method, data, callback) {
		var url = this.appURLs[appName] + "/~za~/" + appName + "/" + method; // No I18N
		var options = {
			url : url,
			data : data,
			type : "POST", // No I18N
			dataType : "json" // No I18N
		};
		if ($.isFunction(callback)) { // No I18N
			options.success = callback;
		} else if (callback) {
			$.extend(true, options, callback);
		}
		return options;
	},
	getAjaxOptionsWithHeader : function(appName, method, data, callback,customDataToken) {
		var url = this.appURLs[appName] + "/~za~/" + appName + "/" + method; // No I18N
		var options = $.ajax({
			"beforeSend": function(xhr) { //NO I18N
				xhr.setRequestHeader("Z-Authorization", 'Zoho-temptoken '+customDataToken);
			},
			url : url,
			data : data,
			type : "POST", // No I18N
			dataType : "json" // No I18N
		});
		if ($.isFunction(callback)) { // No I18N
			options.success = callback;
		} else if (callback) {
			$.extend(true, options, callback);
		}
		return options;
	},
	sendToApp : function(appName, method, data, callback, usePostMessage) {
		var options = this.getAjaxOptions(appName, method, data, callback);
		return CrossServiceRequest.send(options, usePostMessage); // No I18N
	},
	sendToAppWithHeader : function(appName, method, data, callback, usePostMessage,customDataToken) {
		var options = this.getAjaxOptionsWithHeader(appName, method, data, callback,customDataToken);
		return CrossServiceRequest.send(options, usePostMessage); // No I18N
	}
};