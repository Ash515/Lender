// $Id: $
var formvalidated = false;
var _za_serviceurl = undefined;
var customFieldData = undefined;
var temp_token=undefined;
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
			$(".signupbtn span").removeClass('loadingtext');
	  		$(".signupbtn").removeClass('changeloadbtn');
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
			var sb = new StringBuilder('<section class="za-confirm">');//no i18n
			sb.append('<div class="za-confirm-container">');
			sb.append('<div class="zoho_logo"></div>');
			sb.append('<div class="za-confirm-title">').append(I18N.get("IAM.REGISTER.ACCOUNT.CONFIRMATION")).append('</div>');
			sb.append('<p class="za-confirm-msg">').append(I18N.get("IAM.SIGNUP.CONFIRMATION.VERIFY.EMAIL")).append('</p>');
			sb.append('<div class="noteparent">');
			sb.append('<p class="za-confirm-note">').append(I18N.get("IAM.SIGNUP.CONFIRMATION.RIGHT.TO.DEACTIVATE.NEW")).append(I18N.get("IAM.SIGNUP.CONFIRMATION.EMAIL.TIP")).append('</p>');
			sb.append('</div>');
			sb.append('<div class="za-confirm-btn"><input type="button" class="signupbtn" value="').append(I18N.get("IAM.BUTTON.CONTINUE.SIGNIN")).append('">');
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
				var confirmTpl = this.getConfirmationTemplate().replace("$EMAIL", data.email); // No I18N
				$("body").append(confirmTpl);
				$(".main").hide();
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
			for ( var i = 0, len = signupOptions.paramsNames.length; i < len; i++) {
				var paramName = signupOptions.paramsNames[i], paramValue;
				if (!signupOptions.params[paramName] && (paramValue = requestParams[paramName])) {
					signupOptions.params[paramName] = paramValue;
				}
			}
			// To avoid sharing confidential data (password) to other Zoho App while validating Custom Fields
			$f.find("input[name='password'], input[name='repassword'], input[name='captcha']").data("secret", "true"); // No I18N

			// Hide Optional fields && throw error if mandatory field is not present
			$.each([ "captcha", "password", "email", "username","newsletter","emailormobile", "mobile", "rmobile","otp"], function(i, v) { // No I18N
				var $container = $f.find(".za-" + v + "-container");
				var isRequired = signupOptions[v + "_required"] === true;

				var isClientPortal = signupOptions.client_portal === true;
				// Check whether the page contains mandatory fields Ex: captcha
				if ((isRequired || v == "captcha") && !$container.find("input[name='" + v + "']").length) {
					if(v==="newsletter" && isClientPortal){
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
				changeHip(idx, ele, idx == 0 ? captchaDigest : null);
			});
			$('.za-region-container').css('display','none');//No I18N
		},
		url : function() {
			return ZAConstants.getAbsoluteURL("/webclient/v1/register/initiate"); // No I18N
			
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
			$(".signupbtn span").addClass('loadingtext');
	  		$(".signupbtn").addClass('changeloadbtn');
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
				customFieldData = CrossServiceRequest.toJSON("za_signup_new", this.currentForm, { // No I18N
					validate : element.name
				});
			}
			if (customFieldData) {
				options = CrossServiceRequest.getAjaxOptions(signupOptions.service_name, "vfields"); // No I18N
				options.data = $.zaParam({
					data : JSON.stringify(customFieldData)
				});
			}
		} else {
			var pdata = (param && Util.valueOf(param.params, validator)) || {};
			options = {
				url : ZAConstants.getAbsoluteURL("/webclient/v1/register/field/validate"), // No I18N
				type : "POST", // No I18N
				contentType: 'application/json',// No I18N
				data : pdata
			};
			options.data[element.name] = $(element).val();
			if(signupOptions.params && signupOptions.params.servicename) {
				options.data.servicename  = signupOptions.params.servicename;
			} else {
				options.data.servicename = signupOptions.service_name;
			}
			if(signupOptions.params && signupOptions.params.serviceurl) {
				options.data.serviceurl  = signupOptions.params.serviceurl;
			}
			var elemntName = element.name;
			if(elemntName==="email"){
				var json=  {"signupvalidate":{"country_code":pdata.country_code,"email":$(element).val(),"servicename":pdata.servicename}};//no i18N	
			}
			else if(elemntName==="emailormobile"){
				var json=  {"signupvalidate":{"country_code":pdata.country_code,"emailormobile":$(element).val(),"servicename":pdata.servicename}};//no i18N	
			}
			else if(elemntName==="password"){//No i18N
				var json=  {"signupvalidate":{"country_code":pdata.country_code,"password":$(element).val(),"servicename":pdata.servicename}};//no i18N
			}else if(elemntName==="rmobile"){//No i18N
				var json=  {"signupvalidate":{"country_code":pdata.country_code,"rmobile":$(element).val(),"servicename":pdata.servicename}};//no i18N
			}else if(elemntName==="mobile"){//No i18N
				var json=  {"signupvalidate":{"country_code":pdata.country_code,"mobile":$(element).val(),"servicename":pdata.servicename}};//no i18N
			}else if(elemntName==="username"){//No i18N
				var json=  {"signupvalidate":{"country_code":pdata.country_code,"username":$(element).val(),"servicename":pdata.servicename}};//no i18N
			}
			 
			 options.data = JSON.stringify(json);
		}
		if (options) {
			// Below piece of the code in this block is copied from jquery.validator's remote method to support custom remote method option and cross domain support.
			if (validator.optional(element)) {
				return "dependency-mismatch"; // No I18N
			}

			var previous = validator.previousValue(element,"remote");// No I18N
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
					var valid = json.errors == null; // Our Change
					if (valid) {
						var submitted = validator.formSubmitted;
						validator.prepareElement(element);
						validator.formSubmitted = submitted;
						validator.successList.push(element);
						validator.showErrors();
					} else {
						var fieldname=element.name;
						var errors={};
						errors[fieldname]=json.localized_message;
						validator.settings.messages[element.name].validateRemote = previous.message = json.localized_message;
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
function signupResponse(json, textStatus, jqXHR) {
	var ar = new AjaxResponse(json);
	if(typeof _this === "undefined") {
		_this = this;	
	}
	if(ar.json.cause==="throttles_limit_exceeded"){
		$('.za-captcha-container').show();
		changeHip(document.signupform);
		if (signupOptions.oncomplete) {
			signupOptions.oncomplete.call(_this, $.fn.zaSignUp.SIGNUP_STATE.ERROR, jqXHR); // No I18N
		}
	}
	if(json.errors&&json.errors[0]&&json.errors[0].code==="IN107" || json.errors&&json.errors[0]&&json.errors[0].code==="IN108"){
		Form.Message.error("#captchafield", json.localized_message ? json.localized_message  : json.message);//no i18N
  		$(".signupbtn span").removeClass('loadingtext');
  		$(".signupbtn").removeClass('changeloadbtn');
  		$('.za-captcha-container').show();
		$('.za-captcha-container input').removeAttr("disabled");
		var $captcha = $(document.signupform).find(".za-captcha").attr("src", ZAConstants.getAccountsServer()+"/showcaptcha?digest="+json.data.cdigest); // No I18N
		if (!document.signupform.cdigest) {
			$("<input type='hidden' name='cdigest' value='" + json.data.cdigest + "'>").insertAfter($captcha); // No I18n
		}
		document.signupform.cdigest.value = json.digest;
		document.signupform.captcha.value = "";
		document.signupform.captcha.autocomplete = "off"; //No i18N
		if (signupOptions.oncomplete) {
			signupOptions.oncomplete.call(_this, $.fn.zaSignUp.SIGNUP_STATE.ERROR, jqXHR); // No I18N
		}
		return false;
	}else if(json.errors && json.errors[0]) {
		var errorField = $.fn.zaSignUp.defaults.x_signup.otp_required ? "#otpfield" : "#emailfield";//no i18N
		Form.Message.error(errorField,  json.localized_message ? json.localized_message  : json.message);//no i18N
  		$(".signupbtn span").removeClass('loadingtext');
  		$(".signupbtn").removeClass('changeloadbtn');
  		changeHip(document.signupform);
  		if (signupOptions.oncomplete) {
			signupOptions.oncomplete.call(_this, $.fn.zaSignUp.SIGNUP_STATE.ERROR, jqXHR); // No I18N
		}
		return false;
	}
	if(ar.json.signup && ar.json.signup.otptoken){
		otpInitiateResponse(ar,true);
		return false;
	}
	if(ar.json.code==="SIGNUP202"){
		otpInitiateResponse(ar);
		isOtpInitiated=true;
		return false;
	}
	if(ar.json.code==="SIGNUP201"){
		var signup_options = $.fn.zaSignUp.defaults;
		var signupOptions = signup_options.x_signup; // No I18N
		if (signup_options.oncomplete) {
			signup_options.oncomplete.call(_this, $.fn.zaSignUp.SIGNUP_STATE.ACCOUNT_CREATED, jqXHR); // No I18N
		}
		if (customFieldData) {
			var currentDetails = json.signupotpverify ? json.signupotpverify : json.signup;
			var isOtherDomain = currentDetails.isOtherDomain;
			var url = currentDetails.redirecturl;
			var params = "";
			params += "data=" + Util.euc(JSON.stringify(customFieldData));	// No I18N
			if(isOtherDomain) {
				var options = {
						url : url,
						type : "post",	// No I18N
						data : {
							is_ajax : true
						}
				};
				CrossServiceRequest.send(options, _this.options.usePostMessage);
				var ouri = url;
				var stateParam = "state=";	//No I18N
				var allParams = ouri.slice(ouri.indexOf(stateParam) + stateParam.length);
				url = decodeURIComponent(allParams.slice(0, allParams.indexOf("&")));
			} 
			
			return CrossServiceRequest.sendToAppWithHeader(signupOptions.service_name, "ufields", params, { // No I18N
				complete : function() {
					if (signup_options.oncomplete) {
						signup_options.oncomplete.call(_this, $.fn.zaSignUp.SIGNUP_STATE.UPDATE_SERVICE_FIELDS, jqXHR); // No I18N
					}
					signupSucceed(ar,signup_options);
				}
			}, _this.options.usePostMessage,currentDetails.CustomDataToken);
		}else{
			signupSucceed(ar,signup_options);	
		}
	}
}
function signupSucceed(ar,signup_options){
	var doActionCalled = false;
	if (signup_options.oncomplete) {
		signup_options.oncomplete.call($.fn.zaSignUp, $.fn.zaSignUp.SIGNUP_STATE.SIGNUP_COMPLETED);
	}
	var fsname=$( "input[name='firstname']" ).val();
	var emailfield=$( "input[name='email']" ).val();
	var signupdetails = ar.json.signupotpverify ? ar.json.signupotpverify : ar.json.signup;
	signup_options.handleSignuptracking.call($.fn.zaSignUp, {
		email : emailfield,
		zuid : signupdetails.zuid,
		zaid : signupdetails.zaid,
		name : fsname,
		servicename : signup_options.x_signup.service_name,
		operation : "SIGN_UP" // No I18N
	});
	var showConfirmation = signupdetails.showconfirmpage==true;
	if(!emailfield){
		window.location.href = signupdetails.redirecturl;
		return;
	}
	signup_options.handleConfirmation.call(signup_options, {
		email : emailfield,
		show_confirmation : showConfirmation,
		doAction : function() {
			if (!doActionCalled) {
				doActionCalled = true;
				window.location.href = signupdetails.redirecturl;
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
		GO : function(idpProvider) {
			var zaOptionsParam = $.fn.zaSignUp.defaults;
			var serviceName = zaOptionsParam.x_signup.service_name;
			var serviceUrl = zaOptionsParam.x_signup.redirectAppUrl;
			var csrfParam = zaOptionsParam.x_signup.csrfParamName;
			var csrfValue = Cookie.get(ZAConstants.csrfCookie);
			var signupParams = zaOptionsParam.x_signup.params;
			var accountsUrl = ZAConstants.getAccountsServer();


			if(idpProvider != null) 
			{
				var oldForm = document.getElementById(idpProvider + "form");
				if(oldForm) 
				{
					document.documentElement.removeChild(oldForm);
				}
				var form = document.createElement("form");
				var action = encodeURI(accountsUrl+"/accounts/fsr?provider="+idpProvider.toUpperCase()); //No I18N
				var hiddenField = document.createElement("input");
		   	    hiddenField.setAttribute("type", "hidden");
		   	    hiddenField.setAttribute("name", csrfParam);
		        hiddenField.setAttribute("value", csrfValue);
		        form.appendChild(hiddenField);
				form.setAttribute("id", idpProvider + "form");
				form.setAttribute("method", "POST");
			    form.setAttribute("action", action);
			    form.setAttribute("target", "_parent");
			    var openIDProviders = 
			    {
		       		commonparams : 
		       		{
		       			servicename : serviceName,
		    			serviceurl : serviceUrl
		       		}
		       	};
				if(idpProvider) 
				{
		    	    var params = openIDProviders.commonparams;
		    	   	for(var key in params) 
		    	   	{
		    	   		if(params[key]) 
		    	   		{
		    	   			var hiddenField = document.createElement("input");
		    	   			hiddenField.setAttribute("type", "hidden");
		    	   			hiddenField.setAttribute("name", key);
		    	   			hiddenField.setAttribute("value", params[key]);
		    	   			form.appendChild(hiddenField);
		    	   		}
		    	   	}
		    	   	document.documentElement.appendChild(form);
		    	  	form.submit();
				}
			}
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
    if (showpasswordicon.hasClass('icon-hide')) {
        type = 'text';//no i18n
        showpasswordicon.removeClass('icon-hide').addClass('icon-show');
        $("#show-password-label").text(I18N.get("IAM.PASSWORD.HIDE"));
    } else {
        type = 'password';//no i18n
        showpasswordicon.removeClass('icon-show').addClass('icon-hide');
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


function loadCountries(countryCodeDetails) {
	var select = $('.za-country-container select[name=country]').toArray();
	var selectboxes = $('.za-country_code-container select[name=country_code]').length>0 ? select.concat($('.za-country_code-container select[name=country_code]').toArray()) : select ;
	var option="";//No I18N
	var isdoption="";//No I18N
	if(selectboxes.length >0 && countryCodeDetails && countryCodeDetails.length > 0) {
		for(var countryCodeIdx in countryCodeDetails){
			var countryCodeDetail = countryCodeDetails[countryCodeIdx];
			option += "<option value=\""+countryCodeDetail.ISO2_CODE+"\" newsletter_mode=\""+countryCodeDetail.NEWSLETTER_MODE+"\">" + countryCodeDetail.DISPLAY_NAME + "</option>";//No I18N
			isdoption += "<option value=\""+countryCodeDetail.ISO2_CODE+"\" data_number=\"+"+countryCodeDetail.DIALING_CODE+"\">" + countryCodeDetail.DISPLAY_NAME +" (+"+countryCodeDetail.DIALING_CODE+")"+ "</option>";//No I18N
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
	var servicename = $.fn.zaSignUp.defaults.x_signup.service_name;
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
	$(".signupbtn span").addClass('loadingtext');
	$(".signupbtn").addClass('changeloadbtn');
	if(otpfield===""|| !Validator.isValidOTP(otpfield)){
		Form.Message.error("#otpfield", I18N.get("IAM.ERROR.VALID.OTP"));//no i18N
		$(".signupbtn span").removeClass('loadingtext');
  		$(".signupbtn").removeClass('changeloadbtn');
		return false;
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
	var queryparams = params.slice(0).split('&');
	var result = {};
	queryparams.forEach(function(pair) {
        pair = pair.split('=');
        result[pair[0]] = decodeURIComponent(pair[1] || '');
    });
	var signupParams = JSON.parse(JSON.stringify(result));
	var jsonData = {'signupotpverify':signupParams};//no i18N
	var validateoptions=$.ajax({
		"beforeSend": function(xhr) { //NO I18N
			xhr.setRequestHeader("Z-Authorization", temp_token);
		},
		url : ZAConstants.getAbsoluteURL("/webclient/v1/register/otp/verify"), // No I18N
		type : "POST", // No I18N
		dataType: "json",//no i18N
	    data: JSON.stringify(jsonData),
	    contentType: "application/json", //no i18N
		success:function(data){
				if(data.errors){
	    	  		Form.Message.error("#otpfield", data.localized_message);//no i18N
	    	  		$(".signupbtn span").removeClass('loadingtext');
	    	  		$(".signupbtn").removeClass('changeloadbtn');
	    	  		return false;
	    	  	}
	    	  	signupResponse(data);
	    	  	return false;
    	 }
	});
	CrossServiceRequest.send(validateoptions, formOptions.usePostMessage);
	$(".signupbtn span").removeClass('loadingtext');
	$(".signupbtn").removeClass('changeloadbtn');
	return false;
}
function resendOTP(){
	var validator = this;
	var formOptions = $(validator.currentForm).zaSignUp("options");
	$(".signupbtn span").addClass('loadingtext');
	$(".signupbtn").addClass('changeloadbtn');
	var validateoptions = $.ajax({
			"beforeSend": function(xhr) { //NO I18N
				xhr.setRequestHeader("Z-Authorization", temp_token);
			},
			url : ZAConstants.getAbsoluteURL("/webclient/v1/register/otp/resend"), // No I18N
			type : "POST", // No I18N
			success:function(data){
		    	  	if(data.error){
		    	  		Form.Message.error("#otpfield", data.error.otp);//no i18N
		    	  		$(".signupbtn span").removeClass('loadingtext');
		    	  		$(".signupbtn").removeClass('changeloadbtn');
		    	  		return;
		    	  	}
		    	  	showResendMessage(data);
	    	 }
	});
	CrossServiceRequest.send(validateoptions, formOptions.usePostMessage);
	$(".signupbtn span").removeClass('loadingtext');
	$(".signupbtn").removeClass('changeloadbtn');
}
function showResendMessage(ar){
	if(ar.code==="SIGNUP202" || ar.code==="SIGNUP201"){
		$(".alert_message").text(I18N.get("IAM.SIGNIN.SUCCESS.OTP.SENT"));
		$(".Alert").css("top","20px");//No i18N
		window.setTimeout(function(){$(".Alert").css("top","-100px")},5000);
	}
	$(".signupbtn span").removeClass('loadingtext');
	$(".signupbtn").removeClass('changeloadbtn');
	return false;
}
function otpInitiateResponse(ar){
	if(ar.json){
			if(ar.json.signupotpverify){
				window.location.href=ar.json.signupotpverify.redirecturl;
				return;
			}
			formvalidated = false;
			temp_token=ar.json.signup.otptoken;
			$(".signupcontainer,.signuptitle").hide();
			$(".signupotpcontainer").show();
			$(".za-otp-container").show();
			if($( "input[name='email']" ).val() && !$( "input[name='rmobile']" ).val()){
				$(".verifyheader").text(I18N.get("IAM.NEW.SIGNUP.EMAIL.VERIFY.DESC"));
			}
			$("#mobileotp").text($( "input[name='mobile']" ).val()?$( "input[name='mobile']" ).val():$( "input[name='rmobile']" ).val()?$( "input[name='rmobile']" ).val():$( "input[name='email']" ).val()?$( "input[name='email']" ).val():$( "input[name='emailormobile']" ).val()?$( "input[name='emailormobile']").val():"");
			$(".signupbtn span").removeClass('loadingtext');
	  		$(".signupbtn").removeClass('changeloadbtn');
	  		$("#otpfield").removeAttr('disabled');
			$('form[name="signupform"]').attr("action",ZAConstants.getAbsoluteURL("accounts/webclient/v1/register/field/validate"));
		}
}
function gobacktosignup(){
	$(".signupcontainer,.signuptitle").show();
	$(".signupotpcontainer").hide();
	if($( "input[name='rmobile']" ).is(":visible")){
		$( "input[name='rmobile']" ).focus();
	}
	if($( "input[name='mobile']" ).is(":visible")){
		$( "input[name='mobile']" ).focus();
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
function checking(){
	if($('.za-emailormobile-container').is(":visible")){
		var a=$( "input[name='emailormobile']").val()
		var check=/^(?:[0-9] ?){2,1000}[0-9]$/.test(a);
		if((check==true)&&(a)){
			$('.select2').show();
			$("#phonenumber").addClass("textintent52");	
		}else{
			$('.select2').hide();
			$("#phonenumber").removeClass("textintent52");
		}
		
	}else{
		$('.select2').show();
		$("#mobilefield,#rmobilefield").addClass("textintent52");	
	}
}
function format (option) {
	var spltext;
      if (!option.id) { return option.text; }
         spltext=option.text.split("(");
         var cncode = $(option.element).attr("data_number");//no i18N 
		 var cnnumber = $(option.element).attr("value");//no i18N
		 var cnnum = cncode.substring(1);
		 var flagcls="flag_"+cnnum+"_"+cnnumber.toUpperCase();//no i18N
      var ob = '<div class="pic '+flagcls+'" ></div><span class="cn">'+spltext[0]+"</span><span class='cc'>"+cncode+"</span>" ;
      return ob;
};
function changeHip(idx, f, cdigest) {
	f = f || idx;
	var accountsUrl = ZAConstants.getAccountsServer();
	if (!f.captcha.disabled) {
		var captchaCallback = function(json) { // No I18N
			var $captcha = $(f).find(".za-captcha").attr("src", accountsUrl+"/showcaptcha?digest="+json.digest); // No I18N
			if (!f.cdigest) {
				$("<input type='hidden' name='cdigest' value='" + json.digest + "'>").insertAfter($captcha); // No I18n
			}
			f.cdigest.value = json.digest;
			f.captcha.value = "";
			f.captcha.autocomplete = "off"; // No I18N
		};
        cdigest = cdigest ? cdigest : f.cdigest && f.cdigest.value;
        var zaOptionsParam = $.fn.zaSignUp.defaults;
        var data = '{"captcha":{"digest":"'+cdigest+'","usecase":"signup","servicename":"'+zaOptionsParam.x_signup.service_name+'"}}'; // no i18n
		var options = {
			url : accountsUrl+"/webclient/v1/captcha", // No I18N
			type : "POST", // No I18N
			data : data,
             headers: {
                "X-ZCSRF-TOKEN": zaOptionsParam.x_signup.csrfParamName+"="+Cookie.get(ZAConstants.csrfCookie) // no i18n
            },
			success : captchaCallback
		};
		var validator = this;
		var formOptions = $(validator.currentForm).zaSignUp("options");
		CrossServiceRequest.send(options, formOptions.usePostMessage);
	}
}
function validateFirstName(selector){
	if(!($("#firstname").val())){
		Form.Message.error($("#lastname"), I18N.get("IAM.NEW.SIGNUP.FIRSTNAME.VALID"));
		return false;
	}else if((Validator.isSpecialCharecterContains(selector.value))){
		Form.Message.error($("#lastname"), I18N.get("IAM.NEW.SIGNUP.FIRSTNAME.VERIFY.SPL.CHARACTER"));
		return false;
	}
}
function validateLastName(selector){
	if(!($("#lastname").val())){
		Form.Message.error(selector, I18N.get("IAM.NEW.SIGNUP.LASTNAME.VALID"));
		return false;
	}else if((Validator.isSpecialCharecterContains(selector.value))){
		Form.Message.error(selector, I18N.get("IAM.NEW.SIGNUP.LASTNAME.VERIFY.SPL.CHARACTER"));
		return false;
	}
}
function validateInputFeilds(){
	if(!($("#firstname").val())){ 
		Form.Message.error($("#lastname"), I18N.get("IAM.NEW.SIGNUP.FIRSTNAME.VALID"));
		return false;
	}else if((Validator.isSpecialCharecterContains($("#firstname").val()))){ 
		Form.Message.error($("#lastname"), I18N.get("IAM.NEW.SIGNUP.FIRSTNAME.VERIFY.SPL.CHARACTER"));
		return false;
	}else if(!($("#lastname").val())){
		Form.Message.error($("#lastname"), I18N.get("IAM.NEW.SIGNUP.LASTNAME.VALID"));
		return false;
	}else if((Validator.isSpecialCharecterContains($("#firstname").val()))){ 
		Form.Message.error($("#lastname"), I18N.get("IAM.NEW.SIGNUP.LASTNAME.VERIFY.SPL.CHARACTER"));
		return false;
	}
	return true;
}
(function($) {
  if($.fn.select2){
    var Defaults = $.fn.select2.amd.require('select2/defaults');//no i18n
    $.extend(Defaults.defaults, {
        searchInputPlaceholder: ''
    });
    var SearchDropdown = $.fn.select2.amd.require('select2/dropdown/search');//no i18N
    var _renderSearchDropdown = SearchDropdown.prototype.render;
    SearchDropdown.prototype.render = function(decorated) {
        var $rendered = _renderSearchDropdown.apply(this, Array.prototype.slice.apply(arguments));
        this.$search.attr('placeholder', this.options.get('searchInputPlaceholder'));//no i18N
        return $rendered;
    };
  }
 })(window.jQuery);