// $Id: $
// ********************
// $Validator
// ********************

var Validator = {
	PATTERN : {
		STARTS_ALPHA_NUMERIC : new XRegExp("^[\\p{L}\\p{N}\\p{M}]"), // No I18N
		ENDS_ALPHA_NUMERIC : new XRegExp("[\\p{L}\\p{N}\\p{M}]$"), // No I18N
		CONTINUE_DOT : /([._][._])+/, // No I18N
		VALID_CHARS : new XRegExp("^[\\p{L}\\p{N}\\p{M}\\_\\.]+$"), // No I18N
		ONLY_NUMERIC : /^[0-9]+$/, // No I18N
		EMAIL : new XRegExp("^[\\p{L}\\p{M}\\p{N}\\_]([\\p{L}\\p{M}\\p{N}\\_\\+\\-\\.\\'\\&]*)@(?=.{4,256}$)(([\\p{L}\\p{M}\\p{N}]+)(([\\-\\_]*[\\p{L}\\p{M}\\p{N}])*)[\\.])+[\\p{L}\\p{M}]{2,22}$","i"), // No I18N
		USERNAME : new XRegExp("^[\\p{L}\\p{M}\\p{N}\\_\\.]+$","i"), // No I18N
		SPECIAL_CHARS : /[^A-Za-z\d]/,
		UPPER_CHAR : /[A-Z]/,
		LOWER_CHAR : /[a-z]/,
		CONTAIN_NUMBER : /[0-9]/,
		MOBILE : /^([0-9]{5,14})$/,
		OTP : /^([0-9]{7})$/
	},
	isValid : function(value) {
		return value && value.trim().length > 0;
	},
	isEmail : function(value) {
		return value && XRegExp.test(value.trim(), Validator.PATTERN.EMAIL);
	},
	isUserName : function(value) {
		return value && XRegExp.test(value.trim(), Validator.PATTERN.USERNAME);
	},
	isMobile : function(value) {
		return value.trim().length != 0 && Validator.PATTERN.MOBILE.test(value); // No I18N
	},
	isSpecialCharecterContains: function(value){
		return value.trim().length != 0 && Validator.PATTERN.SPECIAL_CHARS.test(value); 
	},
	isMixedCase: function (value){
		return value.trim().length != 0 && (Validator.PATTERN.LOWER_CHAR.test(value) && Validator.PATTERN.UPPER_CHAR.test(value)) ;
	},
	isNumberContains : function (value){
		return value.trim().length != 0 && Validator.PATTERN.CONTAIN_NUMBER.test(value);
	},
	isValidOTP : function(value) {
		return value.trim().length != 0 && Validator.PATTERN.OTP.test(value); // No I18N
	},
	setJQueryMessage : function($validator, msg, element) {
		if (msg) {
			$validator.settings.messages[element.name] = I18N.get(msg);
			return false;
		}
		return true;
	}
};
Validator.newPortal = function(value, element) {
	value = value.trim();
	var msg = null;
	if (value.length < 1) {
		msg = 'IAM.ERROR.PORTAL.MANDATORY'; // No I18N
	} else if (value.length < 6 || value.length > 30) {
		msg = 'IAM.ERROR.PORTAL.NOOF.CHARS'; // No I18N
	} else if (!XRegExp.test(value, Validator.PATTERN.STARTS_ALPHA_NUMERIC)) {
		msg = 'IAM.ERROR.PORTAL.STARTSWITH'; // No I18N
	} else if (!XRegExp.test(value, Validator.PATTERN.VALID_CHARS)) {
		msg = 'IAM.ERROR.PORTAL.NAME.RESTRICTION'; // No I18N
	} else if (Validator.PATTERN.CONTINUE_DOT.test(value)) {
		msg = 'IAM.ERROR.PORTAL.CONSECUTIVE.DOTS'; // No I18N
	} else if (!XRegExp.test(value, Validator.PATTERN.ENDS_ALPHA_NUMERIC)) {
		msg = 'IAM.ERROR.PORTAL.ENDSWITH'; // No I18N
	} else if (Validator.PATTERN.ONLY_NUMERIC.test(value)) {
		msg = 'IAM.ERROR.PORTAL.ONLYNUMBERS'; // No I18N
	}
	return this.settings ? Validator.setJQueryMessage(this, msg, element) : I18N.get(msg);
};
Validator.newUsername = function(value, element) {
	value = value.trim();
	var msg = null;
	if (value.length < 1) {
		msg = 'IAM.ERROR.USERNAME.MANDATORY'; // No I18N
	} else if (value.length < 6 || value.length > 30) {
		msg = 'IAM.ERROR.USERNAME.NOOF.CHARS'; // No I18N
	} else if (!XRegExp.test(value, Validator.PATTERN.STARTS_ALPHA_NUMERIC)) {
		msg = 'IAM.ERROR.USERNAME.STARTSWITH'; // No I18N
	} else if (!XRegExp.test(value, Validator.PATTERN.VALID_CHARS)) {
		msg = 'IAM.ERROR.USERNAME.ONLY.ALPANUMERIC'; // No I18N
	} else if (Validator.PATTERN.CONTINUE_DOT.test(value)) {
		msg = 'IAM.ERROR.USERNAME.CONSECUTIVE.DOTS'; // No I18N
	} else if (!XRegExp.test(value, Validator.PATTERN.ENDS_ALPHA_NUMERIC)) {
		msg = 'IAM.ERROR.USERNAME.ENDSWITH'; // No I18N
	} else if (Validator.PATTERN.ONLY_NUMERIC.test(value)) {
		msg = 'IAM.ERROR.USERNAME.ATLEAST.ONEALPHA'; // No I18N
	}
	return this.settings ? Validator.setJQueryMessage(this, msg, element) : I18N.get(msg);
};
Validator.newPassword = function(value, element) {
	var msg = null, f = (element && element.form) || this.currentForm;
	value = value.trim();
	if(typeof PasswordPolicyInfo !=="undefined"){
		var passInfoCode = null;
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
		if(msg !== null && passInfoCode !== "PP104") {
			for (var i=0;i<PasswordPolicyInfo.length;i++) {
				var passInfo = PasswordPolicyInfo[i];
				if(passInfo.ErrorCode == "PP100") {
					msg = passInfo.message;
					break;
				}
			}
		}
	}else {
		if (value.length < 1) {
			msg = "IAM.ERROR.ENTER.LOGINPASS"; // No I18N
		} else if (value.length < userPasswordMinLen) {
			msg = "IAM.ERROR.PASS.LEN"; // No I18N
		} else if (value.length > userPasswordMaxLen) {
			msg = "IAM.ERROR.PASSWORD.MAXLEN"; // No I18N
		} else if (f && f.username && value.trim() == f.username.value.trim()) {
			msg = "IAM.PASSWORD.POLICY.LOGINNAME"; // No I18N
		}
	}
	if($("#errormg").is(":visible")){
		$(".pwderror").hide();
	}
	if(msg != null && !$("#password-error").length == 0){
		$("#password-error").remove();		
	}
	return this.settings ? Validator.setJQueryMessage(this, msg, element) : I18N.get(msg);
};
Validator.newTermsOfService = function(value, element) {
	var msg = null;
	if(!element.checked){
		msg = 'IAM.ERROR.TERMS.POLICY'; // No I18N	
		
	}
	return this.settings ? Validator.setJQueryMessage(this, msg, element) : I18N.get(msg);
}
Validator.addDefaultMethods = function() {
	if ($.validator) {
		$.validator.addMethod("portalname", Validator.newPortal); // No I18N
		$.validator.addMethod("username", Validator.newUsername); // No I18N
		$.validator.addMethod("password", Validator.newPassword); // No I18N
		$.validator.addMethod("tos", Validator.newTermsOfService); // No I18N
		$.validator.addMethod("email", function(value, element) { // No I18N
			if (!Validator.isEmail(value)) {
					return Validator.setJQueryMessage(this, "IAM.ERROR.EMAIL.INVALID", element); // No I18N
			}
			return true;
		});
		$.validator.addMethod("emailormobile", function(value, element) { // No I18N
			var validator = this;
			if (!Validator.isMobile(value) && !Validator.isEmail(value)) {
				return Validator.setJQueryMessage(this, "IAM.ERROR.EMAIL.OR.MOBILE.INVALID", element); // No I18N
			}
			return true;
		});
		$.validator.addMethod("rmobile", function(value, element) { // No I18N
			var validator = this;
			if (!Validator.isMobile(value)) {
				return Validator.setJQueryMessage(this, "IAM.MOBILE.ENTER.INVALID.MOBILE", element); // No I18N
			}
			return true;
		});
		$.validator.addMethod("mobile", function(value, element) { // No I18N
			var validator = this;
			if (!Validator.isMobile(value)) {
				return Validator.setJQueryMessage(this, "IAM.MOBILE.ENTER.INVALID.MOBILE", element); // No I18N
			}
			return true;
		});
	}
};
Validator.addDefaultMethods();