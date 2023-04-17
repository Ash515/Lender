//$Id$
var valid_sec_email_id, secondary_email_digest;
$(document).ready(function() {
	var cookieArr = document.cookie.split(";");
	for(var i = 0; i < cookieArr.length; i++) {
		var cookiePair = cookieArr[i].split("=");
		if(csrfCookieName == cookiePair[0].trim()) {
			var csrf_cookie_value = cookiePair[1];
			csrf_token = csrfParamName+"="+csrf_cookie_value;
		}
	}
	$("#sec_email").blur().focus();
	$("#changeemail").unbind("click").click(function() {
		$("#sec_email_div").show();
		remove_warning('sec_email', 'sec_email_div');//NO I18N
		$("#sec_email").blur().focus();
		$("#otpdiv").hide();
	});
	$(".resend").unbind("click").click(function() {
		resend_verification_code(valid_sec_email_id, i18nkeys["IAM.SECONDARY.EMAIL.OTP.RESEND.SUCCESS"]);
	});
	$("#addemail").unbind("click").click(function() {
		get_emailid();
	});
	
	jQuery.extend(jQuery.expr[':'], {
		focusable : function(el, index, text) {
			return $(el).is('button');}}
	);
	$('body').unbind("keypress").keypress(function (e) {
		 var key = e.which;
		 if(key == 13)  // the enter key code
		  {
			e.preventDefault();
			if($("#sec_email_div").css("display") !== "none") {
				get_emailid();
			} else if($("#otpdiv").css("display") !== "none") { //NO I18N
				verify_otp();
			}
		  }
		}); 
	
});

function formatMessage() {
	var msg = arguments[0];
	if(msg != undefined) {
		for(var i = 1; i < arguments.length; i++) {
			msg = msg.replace('{' + (i-1) + '}', arguments[i]);
		}
	}
	return msg;
}

function get_emailid() {
	var sec_email_val = $("#sec_email").val().trim();
	$(this).find(".loading_gif").css("display", "inline-block"); //NO I18N
	if(sec_email_val === '' ||  !isValidEmail(sec_email_val)) {
		$("#sec_email").blur().focus();
		$("#sec_email").next().removeClass().addClass("wrong_input");
		$("#sec_email_div").find(".error_msg").text(i18nkeys["IAM.ERROR.ENTER.SIGNUP.EMAIL"]).css("visibility", "visible");//NO I18N
		$(this).find(".loading_gif").css("display", "none"); //NO I18N
	} else {
		if(valid_sec_email_id !== sec_email_val) {
			send_verification_code(sec_email_val, i18nkeys["IAM.VERIFY.SECONDARY.EMAIL.OTP.TEXT"]);
			$(this).find(".loading_gif").css("display", "none"); //NO I18N
		} else {
			show_verifycode_page();
		}
	}
}

function show_verifycode_page() {
	$("#otp_input").val("");
	$(".emailchange").text(valid_sec_email_id); //No I18N
	$("#otpdiv").show();
	remove_warning('otp_input', 'otpdiv'); //NO I18N
	$("#otpdiv").find(".description").text(i18nkeys["IAM.VERIFY.SECONDARY.EMAIL.OTP.TEXT"]);//NO I18N
	$("#otp_input").focus();
	$("#sec_email_div").hide();
}

function remove_warning(input_ele, input_ele_parent) {
	$("#" + input_ele).next().removeClass().addClass("textbox_line");
	$("#" + input_ele_parent).find(".error_msg").css("visibility", "hidden");
}

function isValidEmail(email) {
	var pat = new XRegExp("^[\\p{L}\\p{N}\\p{M}\\_]([\\p{L}\\p{N}\\p{M}\\_\\+\\-\\.\\'\\&]*)@(?=.{4,256}$)(([\\p{L}\\p{N}\\p{M}]+)(([\\-\\_]*[\\p{L}\\p{N}\\p{M}])*)[\\.])+[\\p{L}\\p{M}]{2,22}$","i"); //NO I18N
	if(XRegExp.test(email, pat)) { //NO I18N
		return true;
	} else {
		return false;
	}
}

function isValidCode(code) {
	if(code.trim().length != 0){
		var codePattern = new RegExp("^([0-9]{5,7})$");
		if(codePattern.test(code)){
			return true;
		} else {
			return false;
		}
	} else {
		return false;
	}
}

function send_verification_code(emailid, alert_msg_text) {
	var params = {"email": emailid}; //NO I18N
	params = JSON.stringify({"email": params}); //NO I18N
	var xhr=$.ajax({
		"beforeSend": function(xhr) { //NO I18N
			xhr.setRequestHeader("Z-Authorization", temp_token);
			xhr.setRequestHeader("X-ZCSRF-TOKEN", csrf_token);
		},
		type: "POST",// No I18N
		url: cPath+"/webclient/v1/ssokit/email", //NO I18N
		data: params,// No I18N
		dataType : "json", // No I18N
		success: function(obj){
			if(obj.status_code == 201) {
				valid_sec_email_id = emailid;
				secondary_email_digest = obj.email.email;
				show_verifycode_page();
			} else {
				wrong_emailid(obj);	
			}
		}
	});
}

function resend_verification_code(emailid, alert_msg_text) {
	var xhr=$.ajax({
		"beforeSend": function(xhr) { //NO I18N
			xhr.setRequestHeader("Z-Authorization", temp_token);
			xhr.setRequestHeader("X-ZCSRF-TOKEN", csrf_token);
		},
		type: "PUT",// No I18N
		url: cPath+"/webclient/v1/ssokit/email/"+secondary_email_digest, //NO I18N
		dataType : "json", // No I18N
		success: function(obj){
			if(obj.status_code == 200) {
				valid_sec_email_id = emailid;
				$("#message_icon").removeClass().addClass("tick_icon");
				$(".alert_message").text(i18nkeys["IAM.SECONDARY.EMAIL.OTP.RESEND.SUCCESS"]); //NO I18N
				$(".Alert").addClass("showalert");
				setTimeout(function() {
					$(".Alert").removeClass("showalert");
				}, 3000);
				show_verifycode_page();
			} else {
				wrong_emailid(obj);	
			}
		}
	});
}

function wrong_emailid(obj) {
	if(obj.errors) {
		var errorObj = obj.errors[0];
		if(errorObj.field === "email") {
			$("#sec_email").blur().focus();
			$("#sec_email").next().removeClass().addClass("wrong_input");
			$("#sec_email_div").find(".error_msg").text(obj.errors[0].message).css("visibility", "visible");//NO I18N
			return false;
		} else if(errorObj.message) {
			show_alert_message(errorObj.message, "cross_icon"); //NO I18N
			return false;
		}
	}
	if(obj.message) {
		show_alert_message(obj.message, "cross_icon"); //NO I18N
	} else {
		show_alert_message(i18nkeys["IAM.SECONDARY.EMAIL.ERROR.GENERAL"], "cross_icon");//NO I18N
	}
}

function show_alert_message(message_text, msg_icon_class) {
	$(".Alert").addClass("showalert");
	$("#message_icon").removeClass().addClass(msg_icon_class);
	$(".alert_message").text(message_text);//NO I18N
	setTimeout(function() {
		$(".Alert").removeClass("showalert");
	}, 3000);
	return;
}

function verify_otp() {
	var user_otp = $("#otp_input").val().trim();
	$(this).find(".loading_gif").css("display", "inline-block"); //NO I18N
	if(!isValidCode(user_otp)) {
		$("#otp_input").blur().focus();
		$("#otp_input").next().removeClass().addClass("wrong_input");
		$("#otpdiv").find(".error_msg").text(i18nkeys["IAM.ERROR.VALID.OTP"]).css("visibility", "visible"); //NO I18N
		$(this).find(".loading_gif").css("display", "none"); //NO I18N
	} else {
		var params = {
				"code": user_otp //NO I18N
		}
		params = JSON.stringify({"email" : params}); //NO I18N
		var xhr=$.ajax({
			"beforeSend": function(xhr) { //NO I18N
				xhr.setRequestHeader("Z-Authorization", temp_token);
				xhr.setRequestHeader("X-ZCSRF-TOKEN", csrf_token);
			},
			type: "PUT",// No I18N
			url: cPath+"/webclient/v1/ssokit/email/"+secondary_email_digest, //NO I18N
			data: params,// No I18N
			dataType : "json", // No I18N
			success: function(obj) {
				if(obj.status_code == 200) {
					$("#sec_email_div, #otpdiv, #error_page").css("display", "none"); //NO I18N
					$("#email_addition_success").css("display", "block");
					$(".zoho_logo").css("margin", "auto");
					$("#email_addition_success").find(".discription").text(formatMessage(i18nkeys["IAM.SECONDARY.EMAIL.ADDITION.SUCCESS"], valid_sec_email_id));//NO I18N
					$("#redirect_uri_btn").unbind("click").click(function(){
						window.location.replace(obj.redirect_url);
					});
				} else {
					if(obj.errors) {
						var errorObj = obj.errors[0];
						if(errorObj.field && errorObj.field === "code") {
							$("#otp_input").blur().focus();
							$("#otp_input").next().removeClass().addClass("wrong_input");
							$("#otpdiv").find(".error_msg").text(errorObj.message).css("visibility", "visible"); //NO I18N
							return false;
						} else if(errorObj.message) {
							show_alert_message(errorObj.message, "cross_icon"); //NO I18N
							return false;
						}
					}
					if(obj.message) {
						show_alert_message(obj.message, "cross_icon");//NO I18N
					} else {
						show_alert_message(i18nkeys["IAM.SECONDARY.EMAIL.ERROR.GENERAL"], "cross_icon"); //NO I18N
					}
				}
			}
		});
		$(this).find(".loading_gif").css("display", "none"); //NO I18N		 				 	
	}
}	