//$Id: $
(function($) {
	$.fn.zaSignIn = function(options) {
		var args = null;
		if (!options || typeof options == "object") { // First Time
			args = [ $.extend(true, {}, $.fn.zaSignIn.defaults, options) ];
			this.attr({
				novalidate : true,
				autocomplete : "off" // No I18N
			});
		}
		return this.form.apply(this, args || arguments);
	};

	// Default Values
	$.fn.zaSignIn.defaults = {
		create : function() {
			// Normalize SignIn params
			var signinOptions = this.options.x_signin;
			var requestParams = Util.parseParameter(location.search);
			signinOptions.params = signinOptions.params || {};
			signinOptions.params.is_ajax = true;
			signinOptions.params.grant_type = "password"; // No I18N
			for ( var i = 0, len = signinOptions.paramsNames.length; i < len; i++) {
				var paramName = signinOptions.paramsNames[i], paramValue;
				if (!signinOptions.params[paramName] && (paramValue = requestParams[paramName])) {
					signinOptions.params[paramName] = paramValue;
				}
			}
		},
		url : function() {
			return ZAConstants.getAbsoluteURL("/accounts/signin.ac"); // No I18N
		},
		params : function() {
			return this.options.x_signin.params;
		},
		crossdomain : true,
		csrf : false,
		success : signinResponse,
		error : function() {
			Form.Message.error(this.element, I18N.get("IAM.ERROR.GENERAL")); // No I18N
		},
		commonerror : false,
		onsubmit : function() {
			var f = this.element.get(0), errorMsg = {};
			var username = f.username.value.trim();
			f.username.value=username;
			if (!Validator.isValid(username) || (!Validator.isUserName(username) && !Validator.isEmail(username))) {
				errorMsg.username = I18N.get("IAM.ERROR.EMAIL.INVALID"); // No I18N
			}
			if (f.password.value.length < 1) {
				errorMsg.password = I18N.get("IAM.ERROR.ENTER.LOGINPASS"); // No I18N
			}
			if (f.captcha && !f.captcha.disabled && !Validator.isValid(f.captcha.value)) {
				errorMsg.captcha = I18N.get("IAM.ERROR.INVALID_IMAGE_TEXT"); // No I18N
			}
			var validFields = [];
			$.each([ "username", "password", "captcha" ], function(i, v) { // No I18N
				if (!errorMsg[v] && f[v]) {
					validFields.push(f[v]);
				}
			});
			if (validFields.length) {
				this.hideErrors(validFields);
			}
			if (!$.isEmptyObject(errorMsg)) {
				this.showErrors(errorMsg);
				return false;
			}
		}
	};
	function signinResponse(data, jqXHR, f) {
		var ar = new AjaxResponse(data), f = this.element.get(0), $f = $(f);
		$("#sigin_in").removeClass('changeloadbtn');
		$("#sigin_in span").removeClass('buttontexthide');
		if (ar.error) {
			if (ar.error.msg) {
				Form.Message.error($f, I18N.get(ar.error.msg));
			} else if(ar.error.url) {
				window.top.location.href = ar.error.url;
				return;
			} else {
				try {
					var errorMsg = ar.error[Object.keys(ar.error)[0]];
					Form.Message.error($f, errorMsg);
				}catch (e) {
					Form.Message.error(f, I18N.get("IAM.ERROR.INVALID.CREDENTIAL")); // No I18N
				}
			}
		} else if (ar.data && ar.data.url) {
			if(ar.data.redirectThroughFrame){
				window.location.href = ar.data.url;
				return;
			}
			window.top.location.href = ar.data.url;
			return;
		} else if(!ar.data){
			Form.Message.error(this.element, I18N.get("IAM.ERROR.GENERAL")); // No I18N
		}
		if (ar.data && ar.data.show_captcha) {
			toggleField($f.find(".za-captcha-container"), true); // No I18N
			reloadCaptcha(f);
			f.captcha.focus();
		}
	}
})(jQuery);
function validateGApp(e) {
	var val = this.domain.value;
	if (!val || val.length < 1) {
		Util.stopEvents(e);
		Form.Message.error(this, I18N.get("IAM.ERROR.IDP.VALID.DOMAIN")); // No I18n
	}
}
function openIdSignIn(idp, provider, isClient) {
	var $f = $(document.idpform);
	$f.find(":input").remove(); // No I18n
	var qs = location.search;
	if (qs.charAt(0) == "?") {
		qs = qs.substring(1);
	}
	var params = Util.parseParameter(location.search);
	if (provider) {
		$f.append('<input type="hidden" name="provider" value="' + provider + '">'); // No I18n
	}
	var action = isClient ? "/accounts/extoauth/clientrequest?" + qs : "/accounts/fsrequest?" + qs; // No I18n
	$f.attr({
		action : ZAConstants.getAbsoluteURL(action), // No I18N
		method : "post", // No I18N
		novalidate : "true", // No I18N
		target : "_parent" //No I18N
	});

	if (idp == "ga") { // No I18n
		$f.submit(validateGApp);
		$f.append('<input type="text" class="small-input" placeholder="' + I18N.get("IAM.SIGNIN.IDP.GAPPS.DOMAIN") + '" name="domain" autofocus/>'); // No I18n
		$f.append('<input type="submit" class="btn" value="Submit">'); // No I18n
		
	} else {
		document.idpform.submit();
	}
}