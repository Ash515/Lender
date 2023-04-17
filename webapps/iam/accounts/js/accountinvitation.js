//$Id: $
(function($) {
	var params = Util.parseParameter(location.search);
	$.fn.zaAccountInvitation = function(options) {
		var args = null;
		if (!options || typeof options == "object") { // First Time
			args = [ $.extend(true, {}, $.fn.zaAccountInvitation.defaults, options) ];
			this.attr({
				novalidate : true,
				autocomplete : "off" // No I18N
			});
		}
		return this.form.apply(this, args || arguments);
	};
	// Default Values
	$.fn.zaAccountInvitation.defaults = {
		url : function() {
			return ZAConstants.contextpath + (params.r ? "/rejectinvite.ac" : "/accinvite.ac"); // No I18N	
		},
		params : {
			servicename : params.servicename,
			digest : params.digest,
			redirecturl : params.redirecturl,
			is_ajax : true
		},
		onsubmit : function() {
			if(!params.r) {
				var f = this.element.get(0);
				if(f.firstname && !Validator.isValid(f.firstname.value)) {
					Form.Message.error(f.firstname, I18N.get("IAM.ERROR.ENTER.CONTACTNAME")); // No I18N
					f.firstname.focus();
					return false;
				} else if(f.lastname && !Validator.isValid(f.lastname.value)) {
					Form.Message.error(f.lastname, I18N.get("IAM.ERROR.LASTNAME.MANDATORY")); // No I18N
					f.lastname.focus();
					return false;
				} else if (f.password.value.length < 1) {
					$(".pwderror").hide();
					Form.Message.error(f.password, I18N.get("IAM.ERROR.ENTER.LOGINPASS")); // No I18N
					f.password.focus();
					return false;
				} else if (f.captcha && !f.captcha.disabled && !Validator.isValid(f.captcha.value)) {
					Form.Message.error(f.captcha, I18N.get("IAM.ERROR.INVALID_IMAGE_TEXT")); //No I18N
					return false;
				}
			}
		},
		success : function(data) {
			var ar = new AjaxResponse(data);
			if(ar.error) { //security exp response error handling
				this.showErrors(I18N.get(ar.error));
				return;
			}
			var data = ar.data, _this = this;
			if(data.reject === true){
				var redirect = data.redirect;
				if(redirect){
					$("#beforeclick").hide(); // No I18N
					$("#afterclick").show(); // No I18N
					$("#invtitle").hide(); // No I18N
					$("#afterclick").children("a")[0].href = data.url; // No I18N
					setTimeout(function() {
						window.location.href = data.url;
					}, 5000);
				}else{
					$("#beforeclick").hide(); // No I18N
					$("#afterclick").show(); // No I18N
					$("#invtitle").hide(); // No I18N
					$("#continueto ").hide();// No I18N
				}
			} else{
				var statusCode = data.httpResponseCode, isSuccess = (statusCode >= 200 && statusCode < 300), representation = data.representation[0];
				var f = _this.element.get(0), $f = $(f);
				if(!isSuccess) {
					if (data.httpResponseCode == "400" && representation.redirect_uri) {
						window.location.href = representation.redirect_uri;
					} else if (!data.errorCode) {
						Form.Message.error($f, I18N.get("IAM.ERROR.GENERAL")); // No I18N
					} else {
						var errorObj = {}, errorCode = data.errorCode;
						if (errorCode == "A110") {
							toggleField($f.find(".za-captcha-container"), true); // No I18N
							errorObj.captcha = I18N.get("IAM.ERROR.INVALID_IMAGE_TEXT");
							reloadCaptcha(f);
						} else if (errorCode == "U110") { // No I18N
							errorObj.password = data.localizedMessage;
						} else if(errorCode === "PP101") { //No I18N
							errorObj.password = data.localizedMessage;
						} else if(errorCode === "PP106") { //No I18N
							errorObj.password = data.localizedMessage;
						} else if(errorCode === "Z112") { //No I18N
							errorObj = data.localizedMessage || I18N.get("IAM.ERROR.SIGNUP.DIFFERENT.REGION");
						} else {
							errorObj = data.localizedMessage || I18N.get("IAM.ERROR.GENERAL");
						}
						if (typeof errorObj == "string") {
							Form.Message.error($f, errorObj);
						} else {
							// Error Message received form Captcha field even it is disabled/not required, Captcha might have been enabled on runtime after loading the page.
							$.each([ "captcha", "password", "firstname", "lastname"], function(i, v) { // No I18N
								if (errorObj[v] && f[v] && f[v].disabled) {
									toggleField($f.find(".za-" + v + "-container"), true); // No I18N
								}
							});
							_this.showErrors(errorObj);
						}
					}
				} else {
					if(data.forceRedirect) {
						window.location.href = representation.redirect_uri;
						return false;
					}
					$("#beforeclick").hide(); // No I18N
					$("#afterclick").show(); // No I18N
					$("#invtitle").hide(); // No I18N
					$("#afterclick").children("a")[0].href = representation.redirect_uri; // No I18N
					var timeout = setTimeout(function() {
						window.location.href = representation.redirect_uri;
					}, 5000);
					
					$("#afterclick").children("a").click(function(){
						clearTimeout(timeout);
					});
				}
			}
		},
		
		error : function() {
			Form.Message.error(this.element.get(0), I18N.get("IAM.ERROR.GENERAL")); // No I18N
		}
	};
})(jQuery);
function togglePasswordField(pl) {
    var password = $('#password'),
        type="",
        showpasswordicon = $('#show-password-icon');
    if (showpasswordicon.hasClass('uncheckedpass')) {
        type = 'text';//no i18n
        showpasswordicon.removeClass('uncheckedpass').addClass('checkedpass');
    } else {
        type = 'password';//no i18n
        showpasswordicon.removeClass('checkedpass').addClass('uncheckedpass');
    }
    var input = $("<input>").val(password.val()).attr({"id": "password", "tabindex": "1", "autocomplete": "off", "type": type,"placeholder":I18N.get("IAM.PASSWORD"), "class": password.attr("class"), "name": "password", "spellcheck": "false", "maxlength":"250","onkeyup":"checkPasswordStrength("+pl+")"});//no i18n
    password.before(input);
    selectTextEnd(input[0], input.val().length);
    password.remove();
    input.focus();
}
function toggleNewsletterField(){
   var showpasswordicon = $('#signup-newsletter');
    if (showpasswordicon.hasClass('unchecked')) {
        showpasswordicon.removeClass('unchecked').addClass('checked');
        $('#newsletter').val(true);
    } else {
        showpasswordicon.removeClass('checked').addClass('unchecked');
        $('#newsletter').val(false);
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
function checkPasswordStrength(pl){
	$(".show-password").show();
	$(".password-strength div").hide();
	var p_word = $("#password").val(); //No I18N
	var len = p_word.length;
	var score = Form.PasswordStrength.getScore("",p_word);
	var status = len<=pl ?"weak" : Form.PasswordStrength.getStatus(score);//No I18N
	$("#pwdstrength").removeClass();
	var bgColor = status ==="weak"? "#D21C2B" : status === "good" || status === "fair"?"#2489d0":status === "strong"?"#21b100": "#D21C2B";//No I18N
	$(".pwdtext").css("color",bgColor);//No I18N
	if(len>=pl){
		$(".pwderror").hide();
		$(".pwdparent").css("marginTop","-7px");
		$(".pwdparent").css("marginBottom","3px");
	}else if(len<pl){
		$(".pwderror").show();
		$(".pwdparent").css("marginTop","0");
		$(".pwdparent").css("marginBottom","0");
	}
	if(len >= pl && status==='weak') {
		$(".pwdtext").html(status === "fair" ? "good" : status);//No I18N
		$("#pwdstrength").addClass("weak");
	} else if(status ==="fair"||status ==="good") {//No I18N
		$(".pwdtext").html(status);//No I18N
		$("#pwdstrength").addClass("good");
	} else if(status==="strong"){//No I18N
		$(".pwdtext").html(status);//No I18N
		$("#pwdstrength").addClass("strong");
	}else{
		$(".pwdtext").html("");//No I18N	
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
	if(t.value.length>=1){
		Form.Message.hideError(t);	
	}
}