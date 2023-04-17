// $Id: $
var formvalidated = false;
var _za_serviceurl = undefined;
var customFieldData = undefined;
(function($) {
	$.fn.zaSignUp = function(options) {
		var args = null;
		if (!options || typeof options == "object") { // First Time
			var formOptions = $.extend(true, {}, $.fn.zaSignUp.defaults, options);
			// Swapping the `options.oncomplete` property under `options.x_signup.oncomplete`.
			// In SignUp, we trigger updateFields request to Service's App Server asynchronously, So, Signup is completed only after completing that request.
			// Then only we have to trigger oncomplete function, which can't be done if oncomplete property passed to $.form.
			if (options && options.oncomplete) {
				formOptions.x_signup.oncomplete = formOptions.oncomplete;
				formOptions.oncomplete = null;
			}
			args = [ formOptions ];
		}
		return this.form.apply(this, args || arguments);
	};
	// Constants
	$.fn.zaSignUp.SIGNUP_STATE = {
		ERROR : 0, // if any input / server error occurred while signup.
		ACCOUNT_CREATED : 1, // Account created in ZOHO Accounts
		UPDATE_SERVICE_FIELDS : 2, // ~za~/../updateFields request sent to service to update service specific fields.
		SIGNUP_COMPLETED : 3 // Sign Up completed, before redirecting to service url.
	};
	// Default Values
	$.fn.zaSignUp.defaults = {
		initError : function(errorCode, msg) {
			if (errorCode == "SIGNUP101") {
				Form.Message.error(this.element, msg);
				// Disable input fields
				this.element.find(":input").attr("disabled", "true"); // No I18N
			}
		},
		// Function : first argument ($.fn.zaSignUp.SIGNUP_STATE) and jqXHR (optional)
		oncomplete : function(){
			$(".loadingImg").hide();
		},
		handleSignuptracking : function(data) {
			 try 
            {
                  $zoho.livedesk.visitor.customaction('{"op":"'+data.operation+'","e":"'+data.email+'","sn":"'+data.servicename+'","cp":'+data.clientportal+',"n":"'+data.name+'","zuid":"'+data.zuid+'"}');
             }
            catch(exp){}  
		},
		getRedirectSignUpParams : function() {
			return null;
		},
		getConfirmationTemplate : function() {
			$(".inner-container").css("display","none");
			var sb = new StringBuilder('<section class="za-confirm">');
			sb.append('<div class="za-confirm-container">');
			sb.append('<div class="za-confirm-title">').append(I18N.get("IAM.REGISTER.ACCOUNT.CONFIRMATION")).append('</div>');
			sb.append('<p class="za-confirm-msg">').append(I18N.get("IAM.SIGNUP.CONFIRMATION.VERIFY.EMAIL")).append('</p>');
			sb.append('<p class="za-confirm-note">').append(I18N.get("IAM.SIGNUP.CONFIRMATION.RIGHT.TO.DEACTIVATE")).append(I18N.get("IAM.EMAIL.TIP")).append('</p>');
			sb.append('<div class="za-confirm-btn"><input type="button" class="signupbtn" value="').append(I18N.get("IAM.BUTTON.CONTINUE.SIGNIN")+"&#8594;").append('">');
			sb.append('</div></div></section>');
			return sb.toString();
		},
		handleConfirmation : function(data) {// Function: Override to customize account confirmation page displayed after successful sign up.
			// Load Template 
			if(!data.show_confirmation){
				data.doAction();
				return;
			}
			if (!$(".za-confirm").length) {
				var confirmTpl = this.options.getConfirmationTemplate().replace("$EMAIL", data.email); // No I18N
				$("body").append(confirmTpl);
			}
			$(".za-confirm").height($(document).height()).show().find("input").focus().click(data.doAction);
			// Users might miss to click Continue button. On invitation cases for CRM..., signed up user will be added to an account
			// If, he access the page passed on the serviceurl. Hence, auto redirecting to serviceurl.
			setTimeout(function() {
				data.doAction();
			}, 5000);
		},
		create : function() {
			var $f = this.element.attr("autocomplete", "off"), options = this.options, signupOptions = options.x_signup; // No I18N

			// Normalize SignUp params
			var requestParams = Util.parseParameter(location.search);
			signupOptions.params = signupOptions.params || {};
			signupOptions.params.is_ajax = true;
			for ( var i = 0, len = signupOptions.paramsNames.length; i < len; i++) {
				var paramName = signupOptions.paramsNames[i], paramValue;
				if (!signupOptions.params[paramName] && (paramValue = requestParams[paramName])) {
					signupOptions.params[paramName] = paramValue;
				}
			}

			// To avoid sharing confidential data (password) to other Zoho App while validating Custom Fields
			$f.find("input[name='password'], input[name='repassword'], input[name='captcha']").data("secret", "true"); // No I18N

			// Hide Optional fields && throw error if mandatory field is not present
			$.each([ "captcha", "password", "email", "username","newsletter","emailormobile", "mobile", "rmobile","tos","otp"], function(i, v) { // No I18N
				var $container = $f.find(".za-" + v + "-container");
				var isRequired = signupOptions[v + "_required"] === true;

				var isClientPortal = signupOptions.client_portal === true;
				// Check whether the page contains mandatory fields Ex: captcha
				if ((isRequired || v == "captcha") && !$container.find("input[name='" + v + "']").length) {
					if(v==="newsletter" && isClientPortal){
						return;
					}
					if(v === "tos") { 
						$f.append('<input type="hidden" name="tos_required" value="true">'); // No I18N
						return;
					}
					alert(I18N.get("IAM.ERROR.GENERAL"));
					throw '"' + v + '" field is not present'; // No I18N
				}

				// Hide Optional fields
				toggleField($container, isRequired); // No I18N
			});
			//$(".za-otp-container").hide();
			$(".signupotpcontainer").hide();
			// Disable the form if Signup not allowed
			if (signupOptions.allow_signup === false) {
				options.initError.call(this, "SIGNUP101", I18N.get("IAM.ERROR.SIGNUP.NOT.ALLOWED")); // No I18N
			}

			//Load Countries
			if(loadCountryOptions !== 'false') {
				loadCountries(ZACountryCodeDetails);
			}

			// Load Captcha
			var captchaDigest = signupOptions.captchaDigest;
			$f.each(function(idx, ele) {
				reloadCaptcha(idx, ele, idx == 0 ? captchaDigest : null);
			});
			if(signupOptions.doZLocHandling){
				injectLocationForm(options, this);
			}else{
				$('.za-region-container').css('display','none');//No I18N
			}
		},
		url : function() {
			if($.fn.zaSignUp.defaults.x_signup.otp_required){
					return ZAConstants.getAbsoluteURL("/accounts/register/otp/initiate"); // No I18N
			}else{
				return ZAConstants.getAbsoluteURL("/accounts/register.ac"); // No I18N
			}
			
		},
		params : function() {
			if(!this.options.x_signup.params.stop_ufields || this.options.x_signup.params.stop_ufields !== "true") {
				customFieldData = CrossServiceRequest.toJSON("za_signup", this.element.get(0)); // No I18N
			}
			//return this.options.x_signup.params;
			//Used below function to add signup form field values as queryparameter for given serviceurl (if any services enabled getRedirectSignUpParams configuration)
			return checkAndUpdateServiceUrl(this.options);
		},
		crossdomain : true,
		csrf : false,
		success : signupResponse,
		error : function(jqXHR) {
			Form.Message.error(this.element, I18N.get("IAM.ERROR.GENERAL")); // No I18N
			if (this.options.x_signup.oncomplete) {
				this.options.x_signup.oncomplete.call(this, $.fn.zaSignUp.SIGNUP_STATE.ERROR, jqXHR); // No I18N
			}
		},
		validator : {
			rules : {
				captcha : "required",// No I18N
				portalname : {
					portalname : true,
					validateRemote : true
				},
				username : {
					username : true,
					validateRemote : true
				},
				lastname : "required",// No I18N
				password : "password",// No I18N
				tos : "tos",// No I18N
				emailormobile : {
					emailormobile : true,
					validateRemote : {
						params : function() {
							var signupParams = $(this.currentForm).zaSignUp("options").x_signup.params;
							return {
								portal : signupParams.portal,
								service_language : signupParams.service_language,
								country_code:  $('.za-emailormobile-container').find('select[name="country_code"]').val()  // No I18N
							};
						}
					}
				},
				mobile : {
					mobile : true,
					validateRemote : {
						params : function() {
							var signupParams = $(this.currentForm).zaSignUp("options").x_signup.params;
							return {
								portal : signupParams.portal,
								service_language : signupParams.service_language,
								country_code:  $('.za-mobile-container').find('select[name="country_code"]').val()  // No I18N
							};
						}
					}
				},
				password : {
					password : true,
					validateRemote : {
						params : function(){
							var signupParams = $(this.currentForm).zaSignUp("options").x_signup.params;
							return {
								portal : signupParams.portal,
								service_language : signupParams.service_language
							};
						}
					}
				},
				rmobile : {
					rmobile : true,
					validateRemote : {
						params : function() {
							var signupParams = $(this.currentForm).zaSignUp("options").x_signup.params;
							return {
								portal : signupParams.portal,
								service_language : signupParams.service_language,
								country_code:  $('.za-rmobile-container').find('select[name="country_code"]').val()  // No I18N
							};
						}
					}
				},
				email : {
					email : true,
					validateRemote : {
						params : function() {
							var signupParams = $(this.currentForm).zaSignUp("options").x_signup.params;
							return {
								portal : signupParams.portal,
								service_language : signupParams.service_language,
								country_code:  $('.za-country_code-container').find('select[name="country_code"]').val()  // No I18N
							};
						}
					}
				},
				repassword : "confirmPassword"// No I18N
			},
			messages : {
				captcha : {
					required : function() {
						return I18N.get('IAM.ERROR.WORD.IMAGE');
					}
				},
				lastname : {
					required : function() {
						return I18N.get('IAM.ERROR.LASTNAME.MANDATORY');
					}
				}
			},
			ignore:'.ignore-validation'//No I18N
		},
		passwordStrength : ".za-password-container input", // No I18N
		checkEmail : ".za-email-container input", // No I18N
		disableSubmit : function() {
			try {
				var $btn = this.element.find(this.options.submitButton);
				//var $btnStatus = $btn.attr('disabled'); //No I18N
				if(!$btnStatus || ($btnStatus !== 'disabled' && $btnStatus !== 'true' && $btnStatus !== true)) {
					//method triggered to disable the submit button.
					formvalidated = true;
				}
			} catch(exp){}
			presignupTracker();
			$(".loadingImg").show();
			$("footer").hide();
			if($(".idpform").is(":visible")){
				$(".idpform").hide();
			}
		}
	};
	/* ############ Custom Validation starts ############ */
	$.validator.addMethod("confirmPassword", function(value, element) { // No I18N
		if (this.currentForm.password && value.trim() != this.currentForm.password.value.trim()) {
			this.settings.messages[element.name] = I18N.get("IAM.ERROR.WRONG.CONFIRMPASS");// No I18N
			return false;
		}
		return true;
	});
	/**
	 * @param param -
	 *            Object. `success` option will triggered after receiving response from server.
	 */
	$.validator.addMethod("validateRemote", function(value, element, param) { // No I18N
		var validator = this;
		var options = null, formOptions = $(validator.currentForm).zaSignUp("options"), signupOptions = formOptions.x_signup; // No I18N
		if (element.name.indexOf(CrossServiceRequest.CONSTANTS.CUSTOM_FIELD) == 0) {
			var customFieldData = undefined;
			if(!signupOptions.params.stop_ufields || signupOptions.params.stop_ufields !== "true") {
				customFieldData = CrossServiceRequest.toJSON("za_signup", this.currentForm, { // No I18N
					validate : element.name
				});
			}
			if (customFieldData) {
				options = CrossServiceRequest.getAjaxOptions(signupOptions.appName, "vfields"); // No I18N
				options.data = $.zaParam({
					data : JSON.stringify(customFieldData)
				});
			}
		} else {
			var pdata = (param && Util.valueOf(param.params, validator)) || {};
			options = {
				url : ZAConstants.getAbsoluteURL("/accounts/validate/register.ac"), // No I18N
				type : "POST", // No I18N
				data : pdata
			};
			options.data[element.name] = $(element).val();
			options.data.loginurl = signupOptions.loginurl;
			options.data.m_redirect = signupOptions.m_redirect;
			if(signupOptions.params && signupOptions.params.servicename) {
				options.data.servicename  = signupOptions.params.servicename;
			} else {
				options.data.servicename = signupOptions.appName;
			}
			if(signupOptions.params && signupOptions.params.serviceurl) {
				options.data.serviceurl  = signupOptions.params.serviceurl;
			}
			if(signupOptions.params && signupOptions.params.m_redirect) {
				options.data.m_redirect = signupOptions.params.m_redirect;
			}
			if(signupOptions.params && signupOptions.params.stop_mredirect) {
				options.data.stop_mredirect = signupOptions.params.stop_mredirect;
			}
		}
		if (options) {
			// Below piece of the code in this block is copied from jquery.validator's remote method to support custom remote method option and cross domain support.
			if (validator.optional(element)) {
				return "dependency-mismatch"; // No I18N
			}

			var previous = validator.previousValue(element,"remote");
			if (!validator.settings.messages[element.name]) {
				validator.settings.messages[element.name] = {};
			}
			previous.originalMessage = this.settings.messages[element.name].remote;
			validator.settings.messages[element.name].remote = previous.message;

			param = typeof param == "string" && { // No I18N
				url : param
			} || param;

			if (validator.pending[element.name]) {
				return "pending"; // No I18N
			}
			if (previous.old === value) {
				return previous.valid;
			}

			previous.old = value;
			validator.startRequest(element);
			CrossServiceRequest.send($.extend(true, { // Our Change
				url : param,
				mode : "abort", // No I18N
				port : "validate" + element.name, // No I18N
				dataType : "json", // No I18N
				success : function(json) { // Our Change
					validator.settings.messages[element.name].validateRemote = previous.originalMessage;
					var valid = json.error == null; // Our Change
					if (valid) {
						var submitted = validator.formSubmitted;
						validator.prepareElement(element);
						validator.formSubmitted = submitted;
						validator.successList.push(element);
						validator.showErrors();
					} else {
						var errors = I18N.get(json.error); // Our Change
						validator.settings.messages[element.name].validateRemote = previous.message = errors[element.name];
						validator.showErrors(errors);
						if (element.name.slice(0, 2) == "x_") {
							customFieldAudit(element.name, errors[element.name]);
						}
					}
					previous.valid = valid;
					validator.stopRequest(element, valid);

					if (param && $.isFunction(param.success)) {
						param.success.call(validator, json, element);
					}
				}
			}, options), formOptions.usePostMessage);
			return "pending"; // No I18N
		} else {
			return true;
		}
	});
	/* ############ Custom Validation ends ############ */
})(jQuery);
var isOtpInitiated=false;
function signupResponse(json, textStatus, jqXHR) {
	var invitation_signup = false;
	var ar = new AjaxResponse(json);
	if(typeof _this === "undefined") {
		_this = this;	
	}
	if($.fn.zaSignUp.defaults.x_signup.otp_required && !isOtpInitiated){
		otpInitiateResponse(ar);
		isOtpInitiated=true;
		return false;
	}
	if(ar.error) { //security exp response error handling
		var f = this.element.get(0);
		Form.Message.error(this.element, ar.error.msg);
		reloadCaptcha(f);
		return false;
	}
	var data = ar.data;
	var statusCode = data.httpResponseCode, isSuccess = (statusCode >= 200 && statusCode < 300), representation = data.representation[0];
	var f = _this.element.get(0), $f = $(f), signupOptions = _this.options.x_signup; // No I18N
	if (!isSuccess) {
		if (data.httpResponseCode == "400" && representation.redirect_uri) {
			window.location.href = representation.redirect_uri;
		} else if (!data.errorCode) {
			Form.Message.error($f, I18N.get("IAM.ERROR.GENERAL")); // No I18N
		} else {
			var errorObj = {}, errorCode = data.errorCode;
			if (errorCode == "A110") {
				errorObj.captcha = I18N.get("IAM.ERROR.INVALID_IMAGE_TEXT");
			} else if (errorCode == "U110") { // No I18N
				if(data.errorCause.indexOf("Invalid Mobile Number") > 0){
					errorObj.emailormobile = I18N.get("IAM.MOBILE.ENTER.INVALID.MOBILE");
					errorObj.mobile = I18N.get("IAM.PHONE.ENTER.VALID.MOBILE");
				}else{
					errorObj.username = data.localizedMessage;
				}
			} else if (errorCode == "U104") { // No I18N
				errorObj.email = data.localizedMessage;
			} else if (errorCode == "U110" || errorCode === "PP101" ||errorCode ==="PP110"||errorCode ==="PP111"||errorCode ==="PP104"||errorCode ==="PP107"||errorCode ==="PP109"||errorCode ==="PP108" ||errorCode === "PP106") { //No I18N
				errorObj.password = data.localizedMessage;
			} else if(errorCode == "Z114"){	//No I18N
				errorObj.emailormobile = I18N.get("IAM.ERROR.PHONENUMBER.MOBILE.ALREADY.EXISTS");// No I18N
				errorObj.mobile = I18N.get("IAM.ERROR.PHONENUMBER.MOBILE.ALREADY.EXISTS");// No I18N
			} else if (errorCode == "Z102") { // No I18N
				if (data.errorResource == "useremail" || data.errorResource == "emaild") {
					errorObj.email = I18N.get("IAM.ERROR.EMAIL.EXISTS");
				} else if (data.errorResource == "username" || data.errorResource == "screenname") { // No I18N
					errorObj.username = I18N.get("IAM.ERROR.USERNAME.NOT.AVAILABLE");
				} else { 
					errorObj.portal = I18N.get("IAM.ERROR.PORTAL.EXISTS");
				}
			}else if(errorCode == "U130"){  // No I18N
				errorObj.email = I18N.get("IAM.ERROR.SIGNUP.DOMAIN.RESTRICTED.MESSAGE");
			} 
			else if (errorCode == "INPUT_ERROR_102") { // No I18N
				if (data.errorColumn) {
					for ( var i in data.errorColumn) {
						var column = data.errorColumn[i];
						var field = f[column] || f[CrossServiceRequest.CONSTANTS.RESOURCE_FIELD + column];
						if (field) {
							errorObj[field.name] = I18N.get("IAM.ERROR.VALID.VALUE");
						}
					}
				}
			} else if(errorCode == "Z112") { //No I18N
				errorObj = data.errorCause ? data.errorCause : I18N.get("IAM.ERROR.DIFFERENT.REGION", data.errorResource);
			} else if(errorCode == "U142") { //No I18N				
				errorObj.email = I18N.get("IAM.ERROR.EMAIL.EXISTS");
			} else if(errorCode == "U131") { //No I18N				
				errorObj.email = I18N.get("IAM.ERROR.EMAIL.SPECIAL.CHARACTER");
			} else {
				errorObj = data.localizedMessage || I18N.get("IAM.ERROR.GENERAL");
			}
			if (typeof errorObj == "string") {
				Form.Message.error($f, errorObj);
			} else {
				// Error Message received form Catcha field even it is disabled/not required, Captcha might have been enabled on runtime after loading the page.
				$.each([ "captcha", "password", "email", "username"], function(i, v) { // No I18N
					if (errorObj[v] && f[v] && f[v].disabled) {
						toggleField($f.find(".za-" + v + "-container"), true); // No I18N
					}
				});
				_this.showErrors(errorObj);
			}
		}
		reloadCaptcha(f);
		if (signupOptions.oncomplete) {
			signupOptions.oncomplete.call(_this, $.fn.zaSignUp.SIGNUP_STATE.ERROR, jqXHR); // No I18N
		}
	} else {
		if(data.invitation_signup) {
			invitation_signup = data.invitation_signup;
		}
		if (signupOptions.oncomplete) {
			signupOptions.oncomplete.call(_this, $.fn.zaSignUp.SIGNUP_STATE.ACCOUNT_CREATED, jqXHR); // No I18N
		}
		var otheader = data.ott;
		if (customFieldData) {
			var url = representation.redirect_uri, qs = representation.token_params, idx = url.indexOf(qs);
			var params = "";
			if(otheader != null) {
				params += "ott=" + Util.euc(otheader) + "&"; //No I18N				
			}
			params += "data=" + Util.euc(JSON.stringify(customFieldData));	// No I18N
			if(representation.oauthorize_uri) {
				var options = {
						url : representation.oauthorize_uri,
						type : "post",	// No I18N
						data : {
							is_ajax : true
						}
				};
				CrossServiceRequest.send(options, _this.options.usePostMessage);
				var ouri = representation.oauthorize_uri;
				var stateParam = "state=";	//No I18N
				var allParams = ouri.slice(ouri.indexOf(stateParam) + stateParam.length);
				url = decodeURIComponent(allParams.slice(0, allParams.indexOf("&")));
			} else {
				params += (qs ? "&" + qs : ""); // No I18N
			}
			
			return CrossServiceRequest.sendToApp(signupOptions.appName, "ufields", params, { // No I18N
				complete : function() {
					if (signupOptions.oncomplete) {
						signupOptions.oncomplete.call(_this, $.fn.zaSignUp.SIGNUP_STATE.UPDATE_SERVICE_FIELDS, jqXHR); // No I18N
					}

					// `tmpticket` is passed in url as a separate parameter. So, cookie in updateFields url is not enough, as agent expects it to be tmpticket. Hence, tmpticket param has to be passed in updateFields.
					if (idx != -1) {
						var tmpqs = (url.indexOf("?" + qs) != -1 ? "?" : "&") + qs; // No I18N
						url = url.replace(tmpqs, ""); // No I18N
					}
					representation.redirect_uri = url;
					signupSucceed(_this, representation,invitation_signup);
				}
			}, _this.options.usePostMessage);
		} else {
			signupSucceed(_this, representation,invitation_signup);
		}
	}
}
function signupSucceed(signup, representation,invitation_signup) {
	if (signup.options.x_signup.oncomplete) {
		signup.options.x_signup.oncomplete.call(signup, $.fn.zaSignUp.SIGNUP_STATE.SIGNUP_COMPLETED);
	}
	signup.options.handleSignuptracking.call(signup, {
		email : representation.email,
		zuid : representation.zuid,
		name : fsname,
		servicename : signup.options.x_signup.appName,
		clientportal:signup.options.x_signup.client_portal,
		operation : "SIGN_UP" // No I18N
	});
	if(!invitation_signup){
		formvalidated = false;
	}
	// email not present in the representation which means Email Address might not be mandatory to Sign Up. So, no need to show Confirmation Page.
	if (!representation.email) {
		window.location.href = representation.redirect_uri;
		return;
	}
	// doAction (redirecting to serviceurl) must be called only once.
	var doActionCalled = false;
	var mobile_url;
	if(Validator.isMobile(representation.email)){
		mobile_url = representation.redirect_uri;		// No I18N
	}
	var showConfirmation = representation.showconfirmpage==true;;
	var fsname=$( "input[name='firstname']" ).val();
	signup.options.handleConfirmation.call(signup, {
		email : representation.email,
		mobile_redirect_url: mobile_url,
		show_confirmation : showConfirmation,
		doAction : function() {
			if (!doActionCalled) {
				doActionCalled = true;
				if(invitation_signup){
				   formvalidated = false;
				}
				window.location.href = representation.redirect_uri;
			}
		}
	});
}
function customFieldAudit(field, error) {
	$.post(ZAConstants.getAbsoluteURL("/accounts/regaudit/customfield"), { // No I18N
		field : field,
		error : error
	});
}
function showPassword(t,isMobile) {
	var passwordEle = $(".form .za-password-container input")[0];
	if (passwordEle.type == "password") {
		if(isMobile){
			$(t).removeClass("showpassword").addClass('hidepassword');
		}else{
			$(t).html(I18N.get("IAM.PASSWORD.HIDE"));	
		}
		passwordEle.type = "text";

		passwordEle._zhide_timeout_ = setTimeout(function() {
			showPassword(t);
		}, 5000);
	} else {
		clearTimeout(passwordEle._zhide_timeout_);
		if(isMobile){
			$(t).removeClass("hidepassword").addClass('showpassword');
		}else{
			$(t).html(I18N.get("IAM.PASSWORD.SHOW"));	
		}
		passwordEle.type = "password";
	}
};

function validateGApp(e) {
	var val = this.domain.value;
	if (!val || val.length < 1) {
		Util.stopEvents(e);
		Form.Message.error(this, I18N.get("IAM.ERROR.IDP.VALID.DOMAIN")); // No I18n
	}
}
var FederatedSignIn = {
		GO : function(idp) {
			var zaOptionsParam = $.fn.zaSignUp.defaults;
			var servicename = zaOptionsParam.x_signup.appName;
			var serviceurl = zaOptionsParam.x_signup.redirectAppUrl;
			var csrfparam = zaOptionsParam.x_signup.csrfParamName;
			var csrfValue = Cookie.get(ZAConstants.csrfCookie);
			var signupParams = zaOptionsParam.x_signup.params;

			var newurl = ZAConstants.getAccountsServer();
			var oldurl = newurl;
			var idpClass = $(".idpform").is(":visible");
			var openid_val="/openid";//No i18N
			if(!idpClass){
				if(idp=="g" || idp=="ga"){
					openid_val ="/goauth";//No i18N
				}
				FederatedSignIn.crete(oldurl+openid_val);
			}
			var $f = $(document.idpform);
			$f.find(":input").remove(); // No I18n
			if (signupParams.scopes) {
				$f.append('<input type="hidden" name="scopes" value="' + signupParams.scopes + '">'); // No I18n
			}
			if (signupParams.appname) {
				$f.append('<input type="hidden" name="appname" value="' + signupParams.appname + '">'); // No I18n
			}
			if (signupParams.getticket) {
				$f.append('<input type="hidden" name="getticket" value="' + signupParams.getticket + '">'); // No I18n
			}
			if (servicename) {
				$f.append('<input type="hidden" name="servicename" value="' + servicename + '">'); // No I18n
			}
			if (serviceurl) {
				$f.append('<input type="hidden" name="serviceurl" value="' + serviceurl + '">'); // No I18n
			}

			var action = "/accounts/fsr?provider=YAHOO"; //No i18N
			     if (idp == "f") { action = "/accounts/fsr?provider=FACEBOOK";       }
			else if (idp == "t") { action = "/accounts/fsr?provider=TWITTER";  }
			else if (idp == "l") { action =  "/accounts/fsr?provider=LINKEDIN";}
			else if (idp == "a") { action =  "/accounts/fsr?provider=AZURE"; }    
			else if(idp=="g"||idp=="ga"){action ="/accounts/fsr?provider=GOOGLE";  }
			else if (idp == "sl") { action = "/accounts/fsr?provider=SLACK";  }
			else if (idp == "y") { action = "/accounts/fsr?provider=YAHOO";  }
			else if(idp){ action = "/accounts/fsr?provider="+idp.toUpperCase();}
			/*if (action.lastIndexOf("/accounts/fsrequest", 0) === 0 && csrfparam) {
				$f.append('<input type="hidden" name="'+ csrfparam + '" value="' + csrfValue + '">'); // No I18n
			}*/
			$f.attr({
				action : oldurl+action, // No I18N
				method : "post", // No I18N
				novalidate : "true" // No I18N
			});
				document.idpform.submit();
		},
		crete:function(url){
			var idp_form = document.createElement("form");
			idp_form.name = "idpform";
			idp_form.method ="post"; //no i18N
			idp_form.action = url;
			idp_form.className = "idpform";
			$("body").append(idp_form);
		}
	};


function togglePasswordField(pl) {
    var password = $('#password'),
        type="",
        showpasswordicon = $('#show-password-icon');
    if (showpasswordicon.hasClass('uncheckedpass')) {
        type = 'text';//no i18n
        showpasswordicon.removeClass('uncheckedpass').addClass('checkedpass');
        $("#show-password-label").text(I18N.get("IAM.PASSWORD.HIDE"));
    } else {
        type = 'password';//no i18n
        showpasswordicon.removeClass('checkedpass').addClass('uncheckedpass');
        $("#show-password-label").text(I18N.get("IAM.PASSWORD.SHOW"));
    }
    var input = $("<input>").val(password.val()).attr({"id": "password", "tabindex": "1", "autocomplete": "off", "type": type,"placeholder":I18N.get("IAM.PASSWORD"), "class": password.attr("class"), "name": "password", "spellcheck": "false","onkeyup":"checkPasswordStrength()"});//no i18n
    password.before(input);
    selectTextEnd(input[0], input.val().length);
    password.remove();
    input.focus();
}
function toggleNewsletterField(){
   var showpasswordicon = $('#signup-newsletter');
    if (showpasswordicon.hasClass('unchecked')) {
        showpasswordicon.removeClass('unchecked').addClass('checked');
        $('#newsletter').prop('checked', true);
    } else {
        showpasswordicon.removeClass('checked').addClass('unchecked');
        $('#newsletter').prop('checked', false);
    }
}
function toggleTosField(){
	var showpasswordicon = $('#signup-termservice');
    if (showpasswordicon.hasClass('unchecked')) {
        showpasswordicon.removeClass('unchecked').addClass('checked');
        $('#tos').prop('checked', true);
    } else {
        showpasswordicon.removeClass('checked').addClass('unchecked');
        $('#tos').prop('checked', false);
    }
}

function selectTextEnd(input,inputLen) {
    if (input.setSelectionRange) {
        input.setSelectionRange(inputLen, inputLen);
    } else if (input.createTextRange) {
        var range = input.createTextRange();
        range.collapse(true);
        range.moveStart('character', inputLen);//no i18n
        range.moveEnd('character', inputLen);//no i18n
        range.select();
    }
}
function checkPasswordStrength(){
	$("#password-error").remove();
	$(".za-password-container dd").removeClass("field-error");
	var f = document.forms.signupform;
	var value = f && f.password && f.password.value.trim();
	if(typeof value === "undefined") { //password field is not present in signup form
		return false;
	}
	var msg = null;
	var passInfoCode = null;
	if (value.length < 1 ) {
		msg = I18N.get("IAM.ERROR.ENTER.LOGINPASS"); // No I18N
	} else if(typeof PasswordPolicyInfo !=="undefined") { //No I18N
		for (var i=0;i<PasswordPolicyInfo.length;i++) {
			var passInfo = PasswordPolicyInfo[i];
			passInfoCode = passInfo.ErrorCode;
			if(passInfoCode === "PP101" && (value.length < passInfo.minLength)) {
				msg =  passInfo.message; //Password length is less than minimum required length
				break;
			} else if(passInfoCode === "PP104") { //No I18N
				var id = f.email && f.email.value.trim().toLocaleLowerCase();
				id = id ? id : f.mobile && f.mobile.value.trim().toLocaleLowerCase();
				var passVal = value.toLocaleLowerCase();
				if(id && (id.indexOf(passVal) !== -1 || passVal.indexOf(id) !== -1)) {
					msg = passInfo.message; //Password is same as email
					break;
				}
			} else if(passInfoCode === "PP106" && (value.length > passInfo.maxLength)) { //No I18N
				msg =  passInfo.message; //Password length is greater than maximum required length
				break;
			} else if(passInfoCode === "PP107" && (passInfo.minSplChar>=1 && value.length<=passInfo.ignoreLength && !Validator.isSpecialCharecterContains(value))) { //No I18N
				msg =  passInfo.message; //Special characters in password is less than the required length
				break;
			} else if(passInfoCode === "PP108" && (passInfo.minNUmChar>=1 && value.length<=passInfo.ignoreLength && !Validator.isNumberContains(value))) { //No I18N
				msg =  passInfo.message; //Numeric characters in password is less than the required length
				break;
			} else if(passInfoCode === "PP109" && (passInfo.isEnabled === true && value.length<=passInfo.ignoreLength && !Validator.isMixedCase(value))) { //No I18N
				msg =  passInfo.message; //Password should be in mixed case
				break;
			}/*else if(passInfoCode === "PP113") { //No I18N
				//Password should not contain continuous characters
				if((passInfo.isEnabled === true && Validator.isContinuousChars(value)) && value.length<=passInfo.ignoreLength) {
					msg =  passInfo.message;
					break;
				}
			}*/
		}
	}
	if(msg!=null){
		if(passInfoCode !== "PP104" && typeof PasswordPolicyInfo !=="undefined") {
			for (var i=0;i<PasswordPolicyInfo.length;i++) {
				var passInfo = PasswordPolicyInfo[i];
				if(passInfo.ErrorCode == "PP100") {
					msg = passInfo.message;
					break;
				}
			}
		}
		$(".pwderror").text(msg);// No I18N
		$(".pwderror").show();
	}else{
		$(".pwderror").text("");// No I18N
	}
}
$("#newsletter").focusin( function () {
    $('#signup-newsletter').addClass("focus");
    $(document).on("keydown.tabindex", function(e) {
        if (e.keycode === 9) {
            $("#submitBtn").focus();
            e.preventDefault();
            return false;
        }
    });
}).focusout(function() {
    $('#signup-newsletter').removeClass("focus");
    $(document).off("keydown.tabindex");
});
function hideMsg(t){
	Form.Message.hideError(t);
	if($(".za-email-suggestion").is(":visible")){
		 $(".za-email-suggestion").remove();
	}
}
function hideLenError(t,n) {
	Form.Message.hideError(t);
	var p_word = $("#password").val(); //No I18N
	var len = p_word.length;
	if(len >= 1 && len < n ){
		$("#errormg").removeClass("pwderror");
		$("#errormg").addClass("dummyerror");
		Form.Message.create($(t), "error", "").addClass("jqval-error"); // No I18N
		$("#password").addClass("temperror");
	}
}
function showPwdMsg() {
	$("#errormg").removeClass("dummyerror");
	$("#errormg").addClass("pwderror");
	$(".captchaCnt").css("marginTop","0");
	$("#password").removeClass("temperror");
	if(!$("#errormg").is(":visible")){
		$("#errormg").slideDown(100);
		$(".za-newsletter-container label").css("marginTop","2px");
	}
}

function injectLocationForm(options, currentForm){
	if(isEu(options)){
		var select = document.createElement("select");//No I18N
		if(select.classList){
            select.classList.add('za-region-select');//No I18N
            select.classList.add('ignore-validation');//No I18N
		}else{
            //added for support in IE < 9 
            select.className+=' za-region-select ignore-validation';//No I18N
		}
		select.dclpfxcookiename = options.x_signup.dclCookieName;
		$(select).css('width','150px');//No I18N
		var depMap = options.x_signup.zLocations;
		for(var dep in depMap){
			var option = document.createElement("option");//No I18N
			option.value = depMap[dep].url;
			option.text = dep;
			option.code = depMap[dep].code;
			if(options.x_signup.zCurLoc==dep){
				option.selected = 'selected';//No I18N
			}
			select.add(option);
		}
		select.onchange = function(e){
			  var form = currentForm;
              if(!form){
                      form = document.getElementsByName('signupform')[0];//No I18N
              }
              var selectedOption = this.getElementsByTagName('option')[this.selectedIndex];//No I18N
              setCookie(this.dclpfxcookiename, selectedOption.code);//No I18N
              var acc_url = e.target.value;
              currentForm.options.ajax.url = acc_url+'/accounts/register.ac';//No I18N
              currentForm.options.url = acc_url+'/accounts/register.ac';//No I18N
              ZAConstants.setAccountsServer(acc_url);
              $(form).validate().resetForm();
		};
		if($('.za-region-container').length>0){
			$('.za-region-container').append(select);
		}else{
			$($(currentForm)[0].element).prepend(select);
		}
	}else{
		$('.za-region-container').css('display','none');//No I18N
	}
}

function loadCountries(countryCodeDetails) {
	var select = $('.za-country-container select[name=country]').toArray();
	var selectboxes = $('.za-country_code-container select[name=country_code]').length>0 ? select.concat($('.za-country_code-container select[name=country_code]').toArray()) : select ;
	var option="";//No I18N
	var isdoption="";//No I18N
	if(selectboxes.length >0 && countryCodeDetails && countryCodeDetails.length > 0) {
		for(var countryCodeIdx in countryCodeDetails){
			var countryCodeDetail = countryCodeDetails[countryCodeIdx];
			option += "<option value=\""+countryCodeDetail.country_code+"\" newsletter_mode=\""+countryCodeDetail.newsletter_subscription_mode+"\">" + countryCodeDetail.country_name + "</option>";//No I18N
			isdoption += "<option value=\""+countryCodeDetail.country_code+"\" data_number=\"+"+countryCodeDetail.dialling_code+"\">" + countryCodeDetail.country_name +" (+"+countryCodeDetail.dialling_code+")"+ "</option>";//No I18N
		}
		for ( var index in selectboxes) {
				selectboxes[index].innerHTML = selectboxes[index].name==="country" ? option : isdoption;
		}
	}
	if($('.za-country_code-container select[name=country_code]').length>0 && ZADefaultCountry && $('.za-country_code-container select[name=country_code] option[value='+ZADefaultCountry+']').length > 0){//No I18N
		$('.za-country_code-container select[name=country_code]').val(ZADefaultCountry);
		var cnCode = $("#country-code option:selected").attr("data_number");
		$(".ccdiv,.ccdiv1").text(cnCode);
	}
	if($('.za-country-container select[name=country]').length > 0) {
		 select = $('.za-country-container select[name=country]')[0];
		select.onchange = function(e) {
			handleNewsletterField(this);
			toggleCountryStates(this);
		};
		$('.za-country-container').show();
		if($('.za-newsletter-container #newsletter')){
			$('.za-newsletter-container #newsletter').val('true');
		}
		if(ZADefaultCountry && $('.za-country-container select[name=country] option[value='+ZADefaultCountry+']').length>0){//No I18N
			$('.za-country-container select[name=country]').val(ZADefaultCountry);
		}
		handleNewsletterField(select);
		toggleCountryStates(select);
	}else {
        $('#newsletter').prop('checked', false);
		$('.za-newsletter-container').css('display','none'); //No I18N
		$('.za-country-container').css('display','none'); //No I18N
	}
}
function toggleCountryStates(selectCountryElement) {
	var select = $('.za-country_state-container select[name=country_state]');
	if(select.length > 0 && ZACountryStateDetails && ZACountryStateDetails.length > 0) {
		var countryOptionEle = selectCountryElement.options[selectCountryElement.selectedIndex];//.selectedOptions[0];
		var countryCode = countryOptionEle.value;
		var countryStates = ZACountryStateDetails[0];
		var stateOptios = countryStates[countryCode.toLowerCase()];
		if(stateOptios != undefined) {
			select[0].innerHTML = stateOptios;
			$('.za-country_state-container').css('display',''); //No I18N
		} else {
			select[0].innerHTML = "";
			$('.za-country_state-container').css('display','none'); //No I18N
		}
	}
}
function handleNewsletterField(selectElement) {
	if(selectElement) {
		var optionEle = selectElement.options[selectElement.selectedIndex];//.selectedOptions[0];
		var countryCode = optionEle.value;
		var newsletter_mode = optionEle.getAttribute("newsletter_mode");
		var newsletterEle = $('#signup-newsletter');
		if(newsletter_mode == NewsLetterSubscriptionMode.SHOW_FIELD_WITH_CHECKED) {
			newsletterEle.removeClass('unchecked').addClass('checked');
	        $('#newsletter').prop('checked', true)
	        $('.za-newsletter-container').css('display',''); //No I18N
		} else if(newsletter_mode == NewsLetterSubscriptionMode.SHOW_FIELD_WITHOUT_CHECKED || newsletter_mode == NewsLetterSubscriptionMode.DOUBLE_OPT_IN) {
			newsletterEle.removeClass('checked').addClass('unchecked');
	        $('#newsletter').prop('checked', false)
	        $('.za-newsletter-container').css('display',''); //No I18N
		} else {
			newsletterEle.removeClass('unchecked').addClass('checked');
	        $('#newsletter').prop('checked', true)
	        $('.za-newsletter-container').css('display','none'); //No I18N
		}
	}
}
function setCookie(name, value){
	var host = document.location.host;
	host = host.substring(host.indexOf("."));//No I18N
    var cookieStr = name+"="+value+";Path=/;";//No I18N
    cookieStr += "domain="+host;//No I18N
    document.cookie = cookieStr;
}

function isEu(options){ 
	var date = new Date();
	if(date.getTimezoneOffset()<=0 && date.getTimezoneOffset()>=-180){
		var euTZ = ['(CEST)','(WEST)','(WET)','(EET)','(WEST)','(EEST)','(CET)'];//No I18N
		var thisTZ = date.toString().toUpperCase();
		for(var i in euTZ){
			if(thisTZ.indexOf(euTZ[i])>-1){
				return true;
			}
		}
	}
	return options.x_signup.isEU || false;
}
function checkmblbox(id){
	var check=de(id);
	if(check.checked){
		$("#checkbx").removeClass("checkedBox");
		$("#checkbx").addClass("uncheckBox");
	}else{
		$("#checkbx").removeClass("uncheckBox");
		$("#checkbx").addClass("checkedBox");
	}
	
}
function presignupTracker(){
	var email = $( "input[name='email']" ).val();
	var zuid = "";
	var name = $( "input[name='firstname']" ).val();
	var servicename = $.fn.zaSignUp.defaults.x_signup.appName;
	var clientportal = $.fn.zaSignUp.defaults.x_signup.client_portal;
	var operation ="PRE_SIGN_UP"; // No I18N
	try 
    {
          $zoho.livedesk.visitor.customaction('{"op":"'+operation+'","e":"'+email+'","sn":"'+servicename+'","cp":'+clientportal+',"n":"'+name+'","zuid":"'+zuid+'"}');
     }
    catch(exp){} 
}
function validateOTP(){
	var otpfield = $("#otpfield").val();
	var validator = this;
	var formOptions = $(validator.currentForm).zaSignUp("options");
	$(".loadingImg").show();
	if(otpfield===""|| !Validator.isValidOTP(otpfield)){
		Form.Message.error("#otpfield", I18N.get("IAM.ERROR.VALID.OTP"));//no i18N
		$(".loadingImg").hide();
		return;
	}
	var params = $('form[name="signupform"]').serialize();
	var validateParams = $.fn.zaSignUp.defaults.x_signup.params;
	if(validateParams && validateParams.mode){
		params += "&mode="+validateParams.mode;// No I18N
	}
	if(validateParams && validateParams.serviceurl){
		params += "&serviceurl="+Util.euc(validateParams.serviceurl);// No I18N
	}
	if(validateParams && validateParams.servicename){
		params += "&servicename="+validateParams.servicename;// No I18N
	}
	var validateoptions = {
			url : ZAConstants.getAbsoluteURL("/accounts/register/otp/validate"), // No I18N
			type : "POST", // No I18N
			data : params,
			success:function(data){
		    	  	if(data.error){
		    	  		Form.Message.error("#otpfield", data.error.otp);//no i18N
		    	  		$(".loadingImg").hide();
		    	  		return;
		    	  	}
		    	  	signupResponse(data)
	    	 }
	};
	CrossServiceRequest.send(validateoptions, formOptions.usePostMessage);
	$(".loadingImg").hide();
}
function resendOTP(){
	var validator = this;
	var formOptions = $(validator.currentForm).zaSignUp("options");
	$(".loadingImg").show();
	var params = $('form[name="signupform"]').serialize();// No I18N
	var validateoptions = {
			url : ZAConstants.getAbsoluteURL("/accounts/register/otp/resend"), // No I18N
			type : "POST", // No I18N
			data : params,
			success:function(data){
		    	  	if(data.error){
		    	  		Form.Message.error("#otpfield", data.error.otp);//no i18N
		    	  		$(".loadingImg").hide();
		    	  		return;
		    	  	}
		    	  	showResendMessage(data);
	    	 }
	};
	CrossServiceRequest.send(validateoptions, formOptions.usePostMessage);
	$(".loadingImg").hide();
}
$('#country-code,#country-coderecovery').on('change', function() {
	var cnCode = $("#country-code option:selected").attr("data_number");
	var cnCode1 = $("#country-coderecovery option:selected").attr("data_number");
	$(".ccdiv").text(cnCode);
	$(".ccdiv1").text(cnCode1);
});
function otpInitiateResponse(ar){
	if(ar.json){
		if(ar.json.status=="success"){
			$(".signupcontainer").hide();
			$(".signupotpcontainer").show();
			$(".loadingImg").hide();
			$('form[name="signupform"]').attr("action",ZAConstants.getAbsoluteURL("/accounts/register/otp/validate"));
		}
	}
}

//This function is using to check and add signup form custom field values(like x_name, x_address ect) as query parameter for given serviceurl
//This is mainly added for the signup via mobile app(oauth api) and the team can utilize this by impl
function checkAndUpdateServiceUrl(signupOptions) {
	try {
		var redirectSignUpParams = signupOptions.getRedirectSignUpParams.call();
		if(redirectSignUpParams && redirectSignUpParams !== null) {
			if(typeof redirectSignUpParams == "string") {
				redirectSignUpParams = redirectSignUpParams.split(",");
			}
			var serviceurl = signupOptions.x_signup.params.serviceurl;
			if(_za_serviceurl === undefined) {
				_za_serviceurl = signupOptions.x_signup.params.serviceurl;
			}
			var serviceurl = _za_serviceurl;
			if(Array.isArray(redirectSignUpParams) && (serviceurl && serviceurl !== '')) {
				var tmpSignUpFieldParams = "";
				for(var redirectSignUpParamsIdx in redirectSignUpParams) {
					var signupFormParamName = redirectSignUpParams[redirectSignUpParamsIdx];
					if(signupFormParamName && signupFormParamName.slice(0, 2) == "x_") {
						var signupFormParamValue = $( "input[name='"+signupFormParamName+"']" ).val();
						if(signupFormParamValue) {
							tmpSignUpFieldParams += "&za_" + signupFormParamName + "=" + encodeURIComponent(signupFormParamValue); //No I18N
						}	
					}
				}
				if(tmpSignUpFieldParams !== "") {
					if(serviceurl.indexOf("?") === -1) {
						serviceurl += "?" + tmpSignUpFieldParams.slice(1, tmpSignUpFieldParams.length);
					} else {
						serviceurl += tmpSignUpFieldParams
					}
					signupOptions.x_signup.params.serviceurl = serviceurl;
				}
			}
		}
	} catch(exp){}
	return signupOptions.x_signup.params;
}