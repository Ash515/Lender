// $Id: $
// TODO:
// * Move validateRemote from register.js to here ???

var __za_r20 = /\+/g;
// Jquery Bug: //bugs.jquery.com/ticket/3400
// In jquery they are replacing Spaces with `+` after encoding the data in their serializing method.
$.zaParam = function(obj) {
	if(obj.constructor === Array && obj.length>0)
	{
		if((obj[0].name=="username") || (obj[0].name=="email") || (obj[0].name=="mobile")   ){
			obj[0].value=obj[0].value.trim();
		}
	}
	var str = $.param(obj);
	return str ? str.replace(__za_r20, "%20") : str;
}

$.fn.zaSerialize = function() {
	return $.zaParam(this.serializeArray());
}

$.fn.form = function(options) {
	if (!this.length) { // Nothing selected
		return this;
	}
	var f = this.data("__form_obj__"); // No I18N
	if (!f) {
		f = new Form(this, options);
		this.data("__form_obj__", f); // No I18N
	} else if (typeof options === "string" && options.charAt(0) !== "_") { // No I18N
		var value = f[options];
		if ($.isFunction(f[options])) {
			return value.apply(f, Array.prototype.slice.apply(arguments).splice(1));
		} else if (value !== undefined) {
			return value;
		}
	}
	return this;
};
/* Define all the options used */
$.fn.form.defaults = {
	create : null, // Function: Triggered on creating Form instance
	url : null,
	method : "post", // No I18N
	// Object : Value of params will be appended with Form field values and send to the server.
	params : null,
	// Function : Function should handle parameters sent to the server completely.
	handleParams : null,

	// Boolean : True to use CrossDomainRequest to send request. Avoid Ajax specific options while using crossdomain, as the request can be form submitted in an iFrame where we can set ajax specific options like 'header', extra
	crossdomain : false,
	// Use postMessage option for CORS Unsupported browsers. 
	usePostMessage : false, 
		
	// By default, CSRF Param will be added if method is POST.
	csrf : true,
	// common error display
	commonerror : false,
	// Function : Callback function called after receiving response from server.
	success : null,
	error : null,

	// Options : ajaxOptions @ htt p://api.jquery.com/jQuery.ajax/
	ajax : {},
	// Options : Options of Validator plugin @ htt p://docs.jquery.com/Plugins/Validation/validate#options
	validator : {},

	// Function : Triggered before sending the request, can return false to cancel the form submition.
	onsubmit : null,
	// Function : Triggered after receiving response, called the Form context with jqXHR and textStatus
	oncomplete : null,

	// Selector : Password strength meter will be enabled for the matched fields if password_strength.js included in the document.
	passwordStrength : null,
	// {Object} : Key = Field Name / Selector, Value : String / Function
	hints : null,
	// Boolean : Fade Toggle the error field on submit if Same error fields marked before and after validating, So, adding some visual effects to make user notice the error field.
	animateError : true,
	submitButton : ":submit", // No I18N
	// Boolean / String : To disable submit button after submitting the form, to restrict user click submit again. Pass `String` argument to replace the value of the button on disabled state.
	disableSubmit : true,
	// Boolean: Insert Fallback element in the browser which does't supports placeholder attribute.
	zplaceholder_fallback : true
};
// htt p://docs.jquery.com/Plugins/Validation/validate#options
$.fn.form.validatorOptions = {
	debug : true,
	errorElement : "span", // No I18N
	onsubmit : false,
	// onkeyup will be overwritten to false on initialization for backward compatibility. Pass onkeyup = true on init to use below function.
	onkeyup : function(element, event) {
		var validator = this, args = arguments;
		var timeoutKey = element.name + "_timeout"; // No I18N
		if (!validator.za) {
			validator.za = {};
		}

		clearTimeout(validator.za[timeoutKey]);
		validator.za[timeoutKey] = setTimeout(function() {
			if (element.name in validator.submitted || $(element).val() != "") {
				validator.element(element);
			}
		}, (validator.settings.onkeyupdelay || 500));
	},
	showErrors : function(errorMap, errorList) {
		var $form = $(this.currentForm);
		var options = $form.zaSignUp("options"); // No I18N
		if (options.commonerror) {
			if ($.isEmptyObject(errorMap)) {
				$form.zaSignUp("hideErrors", $form);// No I18N
			} else {
				$form.zaSignUp("showErrors", errorMap);// No I18N
			}
		} else {
			this.defaultShowErrors();
		}
	},
	errorPlacement : function(error, $input) {
		Form.Message.create($input, "error", error).addClass("jqval-error"); // No I18N
	},
	highlight : function(input) {
		Form.Message.error(input);
	},
	unhighlight : function(input, errorClass) {
		Form.Message.hideError(input);
	},
	success : function($error) {
		Form.Message.valid($error.parent().parent());
	}
};
function Form($form, options) {
	var _this = this;

	_this.element = $form;
	_this.options = options = $.extend(true, {}, $.fn.form.defaults, options);
	_this._normalizeOptions();

	// Update Form Attributes
	_this.element.attr({
		action : options.url,
		method : options.method
	});

	_this._initHints();

	// Jquery Validator
	if (options.validator) {
		this.validator = this.element.validate(options.validator);
	}

	if (options.passwordStrength) {
		var pwdlen="";
		if(options.x_signup && options.x_signup.minpwdlen){
			pwdlen = options.x_signup.minpwdlen;
		}
		Form.PasswordStrength.init(options.passwordStrength, _this.element,pwdlen);
	}
	if(options.checkEmail){
		Form.checkEmailDomain.init(options.checkEmail,_this.element , options.x_signup.domains,options.x_signup.isEmailCheck);
	}
	_this.element.submit(function(event) {
		_this.submit(event);
	});

	// Create Handler
	options.create && options.create.call(this);

	if ($.fn.zPlaceHolder && options.zplaceholder_fallback) {
		_this.element.find("input[placeholder]").zPlaceHolder();
	}
};
// ********************
// $PRIVATE_METHODS
// ********************
Form.prototype._normalizeOptions = function() {
	var _this = this, options = _this.options;

	options.url = _this._val(options.url) || _this.element.attr("action"); // No I18N
	options.method = options.method || _this.element.attr("method"); // No I18N

	if ($.isEmptyObject(options.validator)) {
		options.validator = null;
	} else {
		var oldKeyUp = options.validator.onkeyup;
		options.validator = $.extend(true, {}, $.fn.form.validatorOptions, options.validator);
		// Disable onkeyup by default. User must pass onkeyup = true to enable it.
		options.validator.onkeyup = oldKeyUp === true ? $.fn.form.validatorOptions.onkeyup : (oldKeyUp || false);
	}
	
	var isChrome = /Chrome/.test(navigator.userAgent) && /Google Inc/.test(navigator.vendor);
	if(isChrome){
		options.usePostMessage = false;
	}

	options.ajax = $.extend(true, {
		url : options.url,
		type : options.method,
		context : _this,
		complete : _this._complete,
		success : options.success,
		error : options.error
	}, options.ajax);
};
Form.prototype._val = function(value) {
	return $.isFunction(value) ? value.call(this) : value;
};
Form.prototype._initHints = function() {
	var _this = this, hints = _this.options.hints;
	for ( var k in hints) {
		var formEle = _this.element[0][k], $input = (formEle && formEle.nodeType === Node.ELEMENT_NODE) ? $(formEle) : _this.element.find(k);

		Form.Message.element($input, "note").html(_this._val(hints[k])); // No I18N
	}
	return this;
};
Form.prototype._complete = function(jqXHR, textStatus) {
	var _this = this, options = this.options;

	// Enable Submit Button
	_this.updateSubmitState(false);

	if (options.oncomplete) {
		options.oncomplete.call(this, jqXHR, textStatus);
	}
};
// ********************
// $PUBLIC_METHODS
// ********************
Form.prototype.validate = function() {
	return this.validator ? this.element.valid() : true;
};
/**
 * 
 * @param errorObj
 *            {fieldName : ErrorValue}
 */
Form.prototype.showErrors = function(errorObj) {
	if (this.options.commonerror) {
		for ( var i in errorObj) {
			Form.Message.error(this.element, errorObj[i]);
			return false;
		}
	}
	if (this.validator) {
		this.validator.showErrors(errorObj);
		this.validator.focusInvalid();
	} else {
		Form.Message.errors(this.element, errorObj);
		var f = this.element.get(0);
		for ( var i in errorObj) {
			if (f[i]) {
				f[i].focus();
				break;
			}
		}
	}
};
Form.prototype.hideErrors = function(fields) {
	Form.Message.hideErrors(this.element, fields);
};
Form.prototype.submit = function(event) {
	Util.stopEvents(event);

	var _this = this, options = _this.options;
	var $errorFields = options.animateError && _this.element.find(".field-error");

	// Hide Form error message
	Form.Message.hideError(_this.element);

	// Validate the form
	if (!_this.validate()) {
		_this.validator.focusInvalid();
		// Same error fields marked before and after validating, So, adding some visual effects to make user notice the error field.
		if (options.animateError && $errorFields.size() == _this.element.find(".field-error").size()) {
			$errorFields.fadeOut(function() {
				$(this).fadeIn();
			});
		}
		return false;
	}
	
	// Stop Form Submition as Remote Validation is Pending. On receiving the resonse, form will be resubmitted automatically.
	if (_this.validator && _this.validator.pendingRequest) {
		_this.validator.formSubmitted = true;
		return;
	}
	
	var params = null;
	if (options.handleParams) {
		params = options.handleParams.call(this);
	} else {
		params = _this.element.zaSerialize();
		if (options.csrf && options.method == "post") {
			params += "&" + Util.getCSRFValue(); // No I18N
		}
		if (options.params) {
			var optParams = this._val(options.params);
			params += "&" + (typeof optParams == "object" ? Util.serializeParams(optParams) : optParams); // No I18N
		}
	}
	var ajaxOptions = $.extend(true, {
		data : params
	}, options.ajax);
	// Submit handler
	var onSubmitValue = (options.onsubmit && options.onsubmit.call(this, ajaxOptions)); // Due to a bug in iOS7 Safari value of the condition is stored in a separate variable before checking. 
	if (onSubmitValue === false) {
		return false;
	} 

	// Disable Submit Button
	_this.updateSubmitState(true);

	// Send Request
	if (options.crossdomain === true) {
		CrossServiceRequest.send(ajaxOptions, options.usePostMessage);
	} else {
		$.ajax(ajaxOptions);
	}
};
Form.prototype.updateSubmitState = function(disable) {
	var options = this.options;
	if (options.submitButton && options.disableSubmit) {
		var $btn = this.element.find(options.submitButton), disableValue = this._val(options.disableSubmit);
		if (disable) {
			$btn.attr("disabled", "true").addClass("disable-btn"); // No I18N
			if (typeof disableValue == "string") {
				$btn.data("za_form_original_value", $btn.val()).val(disableValue); // No I18N
			}
		} else {
			$btn.removeAttr("disabled").removeClass("disable-btn"); // No I18N
			if (typeof disableValue == "string") {
				$btn.val($btn.data("za_form_original_value") || $btn.val()); // No I18N
			}
		}
	}
};
// ********************
// $STATIC_METHODS
//
// Should work independently without depending on Form object.
// ********************
Form.Message = {
	valid : function(selector) {
		var $input = $(selector);
		if (this.isForm($input)) {
			this.element($input, "error").hide(); // No I18N
		} else {
			$input.parent().addClass("field-valid"); // No I18N
		}
		return $input;
	},
	errors : function($f, obj) {
		for ( var k in obj) {
			this.error($f.find("[name='" + k + "']"), obj[k]); // No I18N
		}
	},
	hideErrors : function($f, fields) {
		for ( var i = 0; i < fields.length; i++) {
			var v = fields[i];
			this.hideError(typeof v == "string" ? $f.find("[name='" + v + "']") : v); // No I18N
		}
	},
	error : function(selector, msg) {
		var $input = $(selector);
		if (msg) {
			this.element($input, "error").html(msg); // No I18N
		}
		if (this.isForm($input)) {
			this.element($input, "error").css("display", "block"); // No I18N
		} else {
			$input.parent().addClass("field-error").removeClass("field-valid"); // No I18N
		}
		return $input;
	},
	hideError : function(selector) {
		var $input = $(selector);
		if (this.isForm($input)) {
			this.element($input, "error").hide(); // No I18N
		} else {
			$input.parent().removeClass("field-error"); // No I18N
		}
		return $input;
	},
	isForm : function($e) {
		return $e.is("form") || $e.is(".form"); // No I18N
	},
	element : function($input, type) {
		var $msg = this.isForm($input) ? $input.find("> .field-msg ." + type) : $input.parent().find(".field-msg ." + type);
		return $msg.length ? $msg : this.create($input, type);
	},
	create : function($input, type, msg) {
		var isForm = this.isForm($input);
		var $fieldMsg = isForm ? $input.children(".field-msg") : $input.siblings(".field-msg"), $msgobj; // No I18N
		if (!$fieldMsg.length) {
			$fieldMsg = $("<div class='field-msg'></div>")[isForm ? "prependTo" : "insertAfter"]($input); // No I18N
		}
		if (msg && typeof msg != "string") {
			$msgobj = $(msg);
		} else {
			$msgobj = $("<span class='" + type + "'></span>").html(msg);
		}
		if($fieldMsg.find("span."+type+"").length > 0){
			$fieldMsg.find("span."+type+"").remove();
		}
		return $msgobj.appendTo($fieldMsg);
	}
};
Form.PasswordStrength = {
	UI : '<div class="password-strength"><div></div></div>', // No I18N
	COLORS : {
		weak : "#EA0206", // No I18N
		fair : "#F2E148", // No I18N
		good : "#90EE90", // No I18N
		strong : "#1DB232" // No I18N
	},
	_create : function($input) {
		return $(Form.PasswordStrength.UI).appendTo($input.parent().css("position", "relative"));
	},
	init : function(selector, context,pwdlen) {
		$(selector, context).each(function() {
			var $input = $(this);
			if (!$input.siblings(".password-strength").length) {
				Form.PasswordStrength._create($input);
				$input.keyup(function() {
					var username = this.form && this.form.username && this.form.username.value;
					if ($input.attr("ps-username")) {
						username = $($input.attr("ps-username"), this.form).val();
					}
					Form.PasswordStrength.check(this, username,pwdlen);
				});
			}
		});
	},
	getStatus : function(score) {
		if (score < 30) {
			return "weak"; // No I18N
		} else if (score >= 30 && score < 60) {
			return "fair"; // No I18N
		} else if (score >= 60 && score < 80) {
			return "good"; // No I18N
		}
		return "strong"; // No I18N
	},
	getScore: function(username,value) {
		return PasswordStrength.test(username, value).score;
	},
	check : function(passwordEle, username,pwdlen) {
		var $password = $(passwordEle), value = $password.val().trim(), $ps = $password.siblings(".password-strength"); // No I18N
		if (value.length >= 1) {
			var score = pwdlen && value.length < pwdlen ? "10" : Form.PasswordStrength.getScore(username,value);
			var bgColor = Form.PasswordStrength.COLORS[Form.PasswordStrength.getStatus(score)] || Form.PasswordStrength.COLORS.good;
			if (!$ps.length) {
				$ps = Form.PasswordStrength._create($password);
			}
			var defaultWidth = score === 0 ? 5 : score;
			$ps.show().find("div").width(defaultWidth + "%").css("background-color", bgColor); // No I18N
		} else {
			$ps.hide();
		}
	}
};
Form.checkEmailDomain = {
		UI : '<div class="za-email-suggestion"><div></div></div>', // No I18N
		_create:function( $input ) {
			return $(Form.checkEmailDomain.UI).appendTo($input.parent().css("position", "relative"));
		},
		init : function(selector, context , domains,isEmailCheck) {
			if(!isEmailCheck){
				return false;
			}
			$(selector, context).each(function() {
				var $input = $(this);
				if (!$input.siblings(".za-email-suggestion").length) {
					Form.checkEmailDomain._create($input);
					$input.blur(function() {
						Form.checkEmailDomain.check($input,domains.split(","));
					});
			}
			});
		},
		check :function(id,domains){
			var $suggest = id.siblings(".za-email-suggestion"); // No I18N
			if (!$suggest.length) {
				Form.checkEmailDomain._create(id);
			}
			var suggestion = Form.checkEmailDomain.getSuggestedDomain(id,domains);
			var oldemail = $('input[name="email"]').val();
			var domain = oldemail.split("@");
            var domainpart = domain[1];
            var dvallength = 0;
            if(domainpart){
            	var dval = domainpart.split(".");
            	dvallength =dval.length;
            	var domval = dval[dvallength];
            	length = domval ? domval.trim().length : 0;
            }
            var whitelist ="ymail.com,yahoo\.co\.,yahoo\.com\.,hotmail\.co\.,hotmail\.com\.,gmx\.net,gmx\.at,gmx\.ch,gmx\.com,mail\.com,web\.com";//no i18N
            var whitelist_regex = whitelist.split(",");
            var containInWhiteList = false;
            for(var i=0;i<whitelist_regex.length;i++){
            	if(domainpart && domainpart.match(whitelist_regex[i].trim())){
            		containInWhiteList = true;
   					break;
            	}
            }
            if(dvallength > 2){
            	return false;
            }
            if(containInWhiteList){
            	return false;
            }
			if(suggestion){
				var emailAddress = '<a onclick = "Form.checkEmailDomain.replaceDomain(\''+suggestion.full.trim()+'\')"><span>'+suggestion.address+'</span>@<span class="za-email-domain">'+suggestion.domain+'</span></a>';
				var message = I18N.get("IAM.DOMAIN.CHECK_MESSAGE",emailAddress);//No I18N
				if(id.siblings(".field-msg").children().is(":visible")){
					Form.Message.hideError(id);
					message = "<span class='za-domain-error'>"+I18N.get("IAM.EMAIL.DOMAIN.SUGGESTION.FULL",emailAddress)+"</span>";//No I18N
				}
	            $(".za-email-suggestion").html(message); //No I18N
			}
			else{
				$(".za-email-suggestion").remove();
			}
            	
        },
		replaceDomain:function(email){
            $('input[name="email"]').val(email);
            $(".za-email-suggestion").remove();
		},
		getSuggestedDomain : function (id , domains){
			var suggestedValue = "";
			$(id).mailcheck({
				domains: domains,//No I18n
                suggested: function(element, suggestion) {
	                if(suggestion.domain.indexOf(".") !== -1){
	                	suggestedValue = suggestion;
	                }
                },
				empty: function(element) {
				}
			});
			return suggestedValue;
		}
};
