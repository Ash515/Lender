// $Id: $
(function($) {
	var params = Util.parseParameter(location.search);
	$.fn.zaForgotPwd = function(options) {
		var args = null;
		if (!options || typeof options == "object") { // First Time
			args = [ $.extend(true, {}, $.fn.zaForgotPwd.defaults, options) ];

			this.attr({
				novalidate : true,
				autocomplete : "off" // No I18N
			});
			this.each(reloadCaptcha);
		}
		return this.form.apply(this, args || arguments);
	};
	
	// Default Values
	$.fn.zaForgotPwd.defaults = {
		url : function() {
			return ZAConstants.contextpath + "/password.ac"; // No I18N
		},
		params : {
			servicename : params.servicename,
			serviceurl : params.serviceurl,
			client_portal : params.client_portal,
			portal : params.portal,
			zaaid : params.zaaid
		},
		onsubmit : function() {
			var f = this.element.get(0), errorMsg = {};
			if (!Validator.isValid(f.recovery.value) || (!Validator.isUserName(f.recovery.value) && !Validator.isEmail(f.recovery.value))) {
				errorMsg.recovery = I18N.get("IAM.ERROR.RECOVERY.MANDATORY"); // No I18N
			}
			if (!Validator.isValid(f.captcha.value)) {
				errorMsg.captcha = I18N.get("IAM.ERROR.WORD.IMAGE"); // No I18N
			}
			var validFields = [];
			$.each("recovery,captcha".split(","), function(i, v) { // No I18N
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
		},
		success : forgotResponse,
		
		error : function(data) {
			var ar = new AjaxResponse(data), f = this.element.get(0), $f = $(f);
			if(ar.json.responseJSON.error && ar.json.responseJSON.error.msg) {
				Form.Message.error($f, ar.json.responseJSON.error.msg);
			} 	
		}
	};
})(jQuery);

function forgotResponse(data, jqXHR, f) {
	var ar = new AjaxResponse(data), f = this.element.get(0), $f = $(f);
	if(ar.error && ar.error.msg){
		Form.Message.error($f, ar.error.msg);
	} else if (ar.error) {
		this.showErrors(I18N.get(ar.error));
		reloadCaptcha(f);
	} else if(ar.data) {
		if(ar.data.msg === 'email_success') {
			resetResponse(data, jqXHR, f);
		} else {
			ar.data.mobile_no ? $("#phone").html(ar.data.mobile_no) : $("#phone").parent().hide();// No I18N
			$('.forgotoutersection').hide();
			$('.recoverymainpage').show();
		}
		return;
	} else {
		Form.Message.error(this.element, I18N.get("IAM.ERROR.GENERAL")); // No I18N
		reloadCaptcha(f);
	}
}

$(document).ready(function() {
	$(".fcontainer input[placeholder]").zPlaceHolder();
});

function validateReset() {
	var params = Util.parseParameter(location.search);
	var portal = params.portal;
	var client_portal = params.client_portal;
	var r_val = $('[name=radio-box]:checked').val();
	var field = r_val == "1" ? "mobile" : "email";// No I18N
	var passwordhistory = "";
	var f1 = document.passwordoptionform;
	var f = document.passwordform;
	$f1 = $(f1);
	var params1 = $f1.serialize() + "&" + Util.getCSRFValue(); // No I18N
	var recovery = $("[name='recovery']").val();
	params1 += "&" + "field=" + field;// No I18N
	params1 += "&" + "recovery=" + encodeURIComponent(recovery);// No I18N
	if (portal != undefined) {
		params1 += "&" + "portal=" + portal;// No I18N
	}
	if (client_portal != undefined) {
		params1 += "&" + "client_portal=" + client_portal;// No I18N
	}
	if (params.servicename != undefined) {
		params1 += "&" + "servicename=" + params.servicename;// No I18N
	}
	if (params.serviceurl != undefined) {
		params1 += "&" + "serviceurl=" + params.serviceurl;// No I18N
	}
	if (params.zaaid) {
		params1 += "&" + "zaaid=" + params.zaaid;// No I18N
	}
	$.post(f1.action, params1, function(data, textStatus, jqXHR) {
		resetResponse(data, jqXHR, f);
	});
}

function resetResponse(data, jqXHR, ff) {
	var ar = new AjaxResponse(data);
	var f = document.passwordoptionform
	var resultObj = ar.data;
	if (resultObj != null) {
		var message = resultObj.msg;
		if (message == "email_success") {// No I18N
			$(".email_notify").html(I18N.get("IAM.FORGOTPASS.SUCCESS.TXT.NEW"));// No I18N
			$('.recoveryoptions').show();
			$(".email_field").show();
			$(".forgotoutersection").hide();
			$('.recoverymainpage').hide();
			return;
		} else if (message == "mobile_success") {// No I18N
			$('.recoverymainpage').hide();
			var m = $("#phone").html();// No I18N
			$(".mobile_notify").html(I18N.get("IAM.MOBILE.VERIFICATION.CODE.NOTES", m));// No I18N
			$('.recoveryoptions').show();
			$(".mobile_field").show();
			return;
		}
	} else if(ar.error.msg == "email_failed" || ar.error.msg == "mobile_failed") {	// No I18N
		Form.Message.error(f, I18N.get("IAM.FORGOT.ERROR.SENDING"));	// No I18N
		return;
	}
	Form.Message.error(f, I18N.get("IAM.ERROR.GENERAL"));	// No I18N
}

function resetPasswordTemplateView() {
	var val = $(".verification_mobile").val();
	var ele = $(".verification_mobile");
	if (val == "") {
		Form.Message.error(ele, I18N.get("IAM.ERROR.MOBILEVERIFY.EMPTY"));// No I18N
		$(".verification_mobile").focus();
	} else {
		$(".verification_mobile").focus();
	}
}