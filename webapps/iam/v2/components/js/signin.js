//$Id$
//  ******JS 2.0******     New Signin second cut functions added  /
var signinathmode = "lookup";//No i18N
var reload_page ="";
var isFormSubmited = isPasswordless = isSecondary = isPrimaryDevice = isTroubleSignin = isRecovery = isCountrySelected = false;
var allowedmodes,digest,rmobile,zuid,temptoken,mdigest,deviceid,prefoption,devicename,yubname,emobile,deviceauthdetails,cdigest,isResend,redirectUri,secondarymodes,prev_showmode,qrtempId,mobposition,bioType,restrictTrustMfa,resendTimer,trustMfaDays;
var callmode="primary";//no i18N
var oadevicepos = mzadevicepos =  0;
function submitsignin(frm){
	$(".signin_head .fielderror").removeClass("errorlabel");
	$(".signin_head .fielderror").text("");//no i18n
	if(isFormSubmited) {
		return false;
	}
	$("#nextbtn span").addClass("zeroheight");
	$("#nextbtn").addClass('changeloadbtn');
	$("#nextbtn").attr("disabled", true);
	if($('#totpverifybtn').is(":visible")){
		$('#totpverifybtn .loadwithbtn').show();
		$('#totpverifybtn .waittext').addClass('loadbtntext');
	}
	var isCaptchaNeeded = $("#captcha_container").is(":visible");
	var captchavalue = frm.captcha.value.trim();
	if(isCaptchaNeeded){
		if(!isValid(captchavalue)) {
			changeHip();
			showCommonError("captcha",I18N.get("IAM.SIGNIN.ERROR.CAPTCHA.REQUIRED"));//no i18n
			return false;
		}
		if( /[^a-zA-Z0-9\-\/]/.test( captchavalue ) ) {
			changeHip();
			showCommonError("captcha",I18N.get("IAM.SIGNIN.ERROR.CAPTCHA.INVALID"));//no i18n
			return false;
		}
    }
	if(signinathmode === "lookup"){
		var LOGIN_ID = frm.LOGIN_ID.value.trim();
		if(!isValid(LOGIN_ID)) {
			showCommonError("login_id",I18N.get("IAM.NEW.SIGNIN.ENTER.EMAIL.OR.MOBILE"));//no i18n
			return false;
		}
		if(($(".showcountry_code").is(":visible") || $("#country_code_select").is(":visible") ) && !isPhoneNumber(LOGIN_ID)){
			showCommonError("login_id",I18N.get("IAM.PHONE.ENTER.VALID.MOBILE_NUMBER"));//no i18n
			return false;
		}
		if(!isUserName(LOGIN_ID) && !isEmailId(LOGIN_ID) && !isPhoneNumber(LOGIN_ID.split('-')[1])) {
			showCommonError("login_id",I18N.get("IAM.SIGNIN.ERROR.USEREMAIL.NOT.EXIST"));//no i18n
			return false;
		}
		LOGIN_ID = ($(".showcountry_code").is(":visible") || $("#country_code_select").is(":visible") ) ? $( "#country_code_select" ).val().split("+")[1]+'-'+LOGIN_ID : LOGIN_ID;
		var loginurl = uriPrefix +"/signin/v2/lookup/"+LOGIN_ID ;//: "/signin/v2/lookup/"+LOGIN_ID; //no i18N
		var params = "mode=primary"+ "&" + signinParams; //no i18N
		if(isCaptchaNeeded){params += "&captcha=" +captchavalue+"&cdigest="+cdigest;}
		sendRequestWithCallback(loginurl, params ,true, handleLookupDetails);//No I18N
		return false;
	}else if(signinathmode === "passwordauth"){//no i18N
		var PASSWORD = frm.PASSWORD.value.trim();
		if(!isValid(PASSWORD)) {
			showCommonError("password",I18N.get("IAM.ERROR.ENTER_PASS")); //no i18n
			return false;
		}
		var jsonData = {'passwordauth':{'password':PASSWORD }};//no i18n
		var loginurl = uriPrefix + "/signin/v2/"+callmode+"/"+zuid+"/password?";// : "/signin/v2/"+callmode+"/"+zuid+"/password?";//no i18N
		loginurl += "digest="+digest+ "&" + signinParams; //no i18N
		if(isCaptchaNeeded){loginurl += "&captcha=" +captchavalue+"&cdigest="+cdigest;}
		sendRequestWithCallback(loginurl,JSON.stringify(jsonData),true,handlePasswordDetails);
		return false;
		
	}else if(signinathmode === "totpsecauth" || (signinathmode==="oneauthsec" && prefoption==="ONEAUTH_TOTP") ){//no i18N
		var TOTP = frm.TOTP.value.trim();
		if( !isValid(TOTP)){
			showCommonError("mfa_totp",I18N.get("IAM.NEW.SIGNIN.INVALID.OTP.MESSAGE.EMPTY"));//No I18N
			return false;
		}
		if( /[^0-9\-\/]/.test( TOTP ) ) {
			showCommonError("mfa_totp",I18N.get("IAM.SIGNIN.ERROR.INVALID.VERIFICATION.CODE"));//No I18N
			return false;
		}
		callmode="secondary";//no i18n
		var loginurl= prefoption==="ONEAUTH_TOTP" ? "/signin/v2/"+callmode+"/"+zuid+"/oneauth/"+deviceid+"?": "/signin/v2/"+callmode+"/"+zuid+"/totp?";//no i18N
		loginurl += "digest="+digest+ "&" + signinParams; //no i18N
		if(isCaptchaNeeded){loginurl += "&captcha=" +captchavalue+"&cdigest="+cdigest;}
		var jsonData = prefoption==="ONEAUTH_TOTP" ? {'oneauthsec':{'devicepref':prefoption,'code':TOTP }} : {'totpsecauth':{'code':TOTP }};//no i18N
		var method = prefoption==="ONEAUTH_TOTP" ? "PUT": "POST";//NO i18N
		loginurl = prefoption==="ONEAUTH_TOTP" ? loginurl+"&polling="+false : loginurl; // no i18n
		sendRequestWithTemptoken(loginurl,JSON.stringify(jsonData),true,handleTotpDetails,method);
		return false;
	}else if(signinathmode === "mobilesecauth"){//No I18N
		var TFA_OTP_CODE = frm.MFAOTP.value.trim();
		if(!isValid(TFA_OTP_CODE)){
				showCommonError("mfa_otp",I18N.get("IAM.NEW.SIGNIN.INVALID.OTP.MESSAGE.EMPTY"));//No I18N
				return false;	
		}
		if(isNaN(TFA_OTP_CODE) || TFA_OTP_CODE.length != 7) {
				showCommonError("mfa_otp",I18N.get("IAM.NEW.SIGNIN.INVALID.OTP.MESSAGE.NEW"));//no i18n
				return false;
		}
		if( /[^0-9\-\/]/.test( TFA_OTP_CODE ) ) {
			showCommonError("mfa_otp",I18N.get("IAM.SIGNIN.ERROR.INVALID.VERIFICATION.CODE"));//No I18N
			return false;
		}
		callmode="secondary";//no i18n
		var loginurl="/signin/v2/"+callmode+"/"+zuid+"/otp/"+emobile+"?";//no i18N
		loginurl += "digest="+digest+ "&" + signinParams; //no i18N
		if(isCaptchaNeeded){loginurl += "&captcha=" +captchavalue+"&cdigest="+cdigest;}
		var jsonData = { 'mobilesecauth' : { 'mdigest' : mdigest, 'code' : TFA_OTP_CODE } };//no i18N
		sendRequestWithTemptoken(loginurl,JSON.stringify(jsonData),true,handleTotpDetails,"PUT");//no i18n
		return false;
	}else if(signinathmode === "mobileauth" ){ //no i18n 
		var OTP_CODE = frm.OTP.value.trim();
		if(!isValid(OTP_CODE)){
				showCommonError("otp",I18N.get("IAM.NEW.SIGNIN.INVALID.OTP.MESSAGE.EMPTY"));//No I18N
				return false;	
		}
		if(isNaN(OTP_CODE) || OTP_CODE.length != 7) {
				showCommonError("otp",I18N.get("IAM.NEW.SIGNIN.INVALID.OTP.MESSAGE.NEW"));//no i18n
				return false;
		}
		if( /[^0-9\-\/]/.test( OTP_CODE ) ) {
			showCommonError("otp",I18N.get("IAM.SIGNIN.ERROR.INVALID.VERIFICATION.CODE"));//No I18N
			return false;
		}
		var loginurl = "/signin/v2/"+callmode+"/"+zuid+"/otp/"+emobile+"?";//no i18N
		loginurl += "digest="+digest+ "&" + signinParams; //no i18N
		if(isCaptchaNeeded){loginurl += "&captcha=" +captchavalue+"&cdigest="+cdigest;}
		var jsonData = { 'mobileauth' : { 'mdigest' : mdigest, 'code' : OTP_CODE } };//no i18N
		sendRequestWithCallback(loginurl,JSON.stringify(jsonData),true,handlePasswordDetails,"PUT");//no i18n
		return false;
	}
	else if(signinathmode=== "deviceauth" || signinathmode=== "devicesecauth"){ 
		var myzohototp;
		if(prefoption==="totp"){
			myzohototp = isTroubleSignin ? frm.MFATOTP.value.trim() : frm.TOTP.value.trim();
			if( !isValid(myzohototp)){
				var container = isTroubleSignin ? "verify_totp" : "mfa_totp"; // no i18n
				showCommonError(container,I18N.get("IAM.NEW.SIGNIN.INVALID.OTP.MESSAGE.EMPTY"));//No I18N
				return false;
			}
		}
		var loginurl="/signin/v2/"+callmode+"/"+zuid+"/device/"+deviceid+"?";//no i18N
		loginurl += "digest="+digest+ "&" + signinParams; //no i18N
		isResend = prefoption === "push" ? true : false; // no i18N
		var jsonData = prefoption==="totp" ? {'devicesecauth':{ 'devicepref' : prefoption, 'code' : myzohototp } } :{'devicesecauth':{'devicepref':prefoption }}; ;//no i18N
		if(signinathmode === "deviceauth"){
			jsonData = prefoption==="totp" ? {'deviceauth':{ 'devicepref' : prefoption, 'code' : myzohototp } } :{'deviceauth':{'devicepref':prefoption }}; ;//no i18N
		}
		var method = "POST"; // no i18n
		var invoker = handleMyZohoDetails;
		if(prefoption==="totp"){
			method = "PUT"; // no i18n
			loginurl+= "&polling="+false; // no i18n
			invoker = handleTotpDetails;
		}
		sendRequestWithTemptoken(loginurl,JSON.stringify(jsonData),true,invoker,method);
		return false;
		//Resend push for myzohoapp
	}else if(signinathmode=== "oneauthsec"){ //No i18N   
		var loginurl="/signin/v2/"+callmode+"/"+zuid+"/oneauth/"+deviceid+"?";//no i18N
		loginurl += "digest="+digest+ "&" + signinParams; //no i18N
		var jsonData = {'oneauthsec':{'devicepref':prefoption }};//no i18N
		isResend= prefoption === "totp" || prefoption === "scanqr" ? false : true;// no i18N
		sendRequestWithTemptoken(loginurl,JSON.stringify(jsonData),true,handleOneAuthDetails);
		return false;
	}else if(signinathmode==="yubikeysecauth"){ //no i18n 
		clearCommonError("yubikey");//no i18N
		var loginurl="/signin/v2/"+callmode+"/"+zuid+"/yubikey/"+yubname+"?"+signinParams;//no i18n
		sendRequestWithTemptoken(loginurl,"",true,handleYubikeyDetails);
		return false;
		//Resend Yubikey
	}
	isFormSubmited = true;
	return false;
}
function sendRequestWithTemptoken(action, params, async, callback,method) {
	if (typeof contextpath !== 'undefined') {
		action = contextpath + action;
	}
    var objHTTP = xhr();
    objHTTP.open(method?method:'POST', action, async);
    objHTTP.setRequestHeader('Content-Type','application/x-www-form-urlencoded;charset=UTF-8');
    if(isValid(temptoken)){
    	objHTTP.setRequestHeader('Z-Authorization','Zoho-ticket '+temptoken); // no i18n
    }
    objHTTP.setRequestHeader('X-ZCSRF-TOKEN',csrfParam+'='+euc(getCookie(csrfCookieName)));
    if(async){
	objHTTP.onreadystatechange=function() {
	    if(objHTTP.readyState==4) {
	    	if (objHTTP.status === 0 ) {
				handleConnectionError();
				return false;
			}
	    	if(callback) {
			    callback(objHTTP.responseText);
			}
	    }
	};
    }
    objHTTP.send(params);
    if(!async) {
	if(callback) {
            callback(objHTTP.responseText);
        }
    }
} 
function showCommonError(field,message){ 	
	$('.fielderror').val('');
	if($(".changeloadbtn").is(":visible")){
		var btnvalue = field==="login_id" ? I18N.get("IAM.NEXT") : field==="password" ? I18N.get("IAM.SIGNIN") : I18N.get("IAM.VERIFY"); //No i18n
		changeButtonAction(btnvalue,false);
	}
	if($("#captcha_container").is(":visible")){changeHip();}
	if($("#bcaptcha_container").is(":visible")){changeHip('bcaptcha_img','bcaptcha');};
	var container=field+"_container";//no i18N
	$("#"+field).addClass("errorborder");
	$("#"+container+ " .fielderror").addClass("errorlabel");
	$("#"+container+ " .fielderror").html(message);
	$("#"+container+ " .fielderror").slideDown(200);
	$("#"+field).focus();
	if($('#totpverifybtn').is(":visible")){
		$('#totpverifybtn .loadwithbtn').hide();
		$('#totpverifybtn .waittext').removeClass('loadbtntext');
	}
	return false;
}
function callback_signin_lookup(msg) {
	showCommonError("login_id",msg);//No I18N
	$("#nextbtn span").removeClass("zeroheight");
	$("#nextbtn").removeClass("changeloadbtn");
	$("#nextbtn").attr("disabled", false);
	$("#nextbtn span").text(I18N.get("IAM.NEXT"));
	isFormSubmited = false;
	return false;
}
function changeButtonAction(textvalue,isSubmitted){
	$("#nextbtn span").removeClass("zeroheight");
	$("#nextbtn").removeClass("changeloadbtn");
	$("#nextbtn").attr("disabled", false);
	$("#nextbtn span").text(textvalue); //No I18N
	isFormSubmited = isSubmitted;
	return false;
}
function enablePassword(loginId,isOTP, isSaml, isFederated,isNoPassword,isJwt) {
	changeButtonAction(I18N.get('IAM.SIGNIN'),false);//no i18n
	$("#login_id_container,#showIDPs").slideUp(200);
	$("#password_container").removeClass("zeroheight");
	$("#password_container").slideDown(200);
	$(".backbtn").show();
	$("#captcha_container,.line").hide();
	$('.username').text(loginId);
	$("#forgotpassword").hide();
	if(!isFederated && isNoPassword && isOTP){
		$("#password_container .textbox_div,#nextbtn").hide()
		$(".nopassword_container").css("position","unset");
		$(".nopassword_container").css("width","100%");
		$(".nopassword_container").show();
		return false;
	}
	$("#password").focus();
	signinathmode="passwordauth";//no i18N
	if(isOTP){
		$("#enableotpoption").show();
		emobile=deviceauthdetails.lookup.modes.otp.data[0].e_mobile;
		rmobile=deviceauthdetails.lookup.modes.otp.data[0].r_mobile;
	}if(isSaml){//no i18N
		$("#enablesaml").show();
		var redirectURI = deviceauthdetails.lookup.modes.saml.redirect_uri;
		$("#signinwithsaml").attr("href",redirectURI);
	}if (isFederated){
		$(".fed_2show").show();
		$(".fed_div").hide();
		if(!isOTP && !isSaml){ $("#enableforgot").show()};
		var idps = deviceauthdetails.lookup.modes.federated.data;
		idps.forEach(function(idps){
			if(isValid(idps)){
				idp = idps.idp.toLowerCase();
				$("."+idp+"_fed").attr("style","display:block !important");
            }
		});
		if($(".apple_fed").is(":visible")){
			var isSafari = /^((?!chrome|android).)*safari/i.test(navigator.userAgent) || /Mac|iPad|iPhone|iPod/.test(navigator.platform || "");
			if(isSafari) {
				$(".apple_fed").hide();
				$("#macappleicon").show();
				$(".small_box .fed_center_google").css("width","35px");
		    	$(".small_box .googleIcon").css("margin-left","6px");
				return false;
			}
			$("#macappleicon").hide();
		}
		if(isNoPassword && isFederated){
			$("#password_container .textbox_div,#nextbtn").hide()
			$(".nopassword_container").css("position","absolute");
			$(".nopassword_container").show();
		}
	}if(!isNoPassword){
		$("#signinwithpass").show();
	}
	if(isJwt){
		$("#enablejwt").show();
		var redirectURI = deviceauthdetails.lookup.modes.jwt.redirect_uri;
		$("#signinwithjwt").attr("href",redirectURI);
	}
	if(isOTP && isSaml && !isNoPassword){
		$('#enablemore').show();
		$('#enableforgot').hide();
	}
	return false;
}
function enableOTP() {
	showAndGenerateOtp();
	return false;
}
function enableMfaField(mfamode){
	callmode="secondary";//no i18N
	if(mfamode==="totp"){
		$("#password_container,#captcha_container,.fed_2show,#otp_container").hide();
		$("#headtitle").text(I18N.get("IAM.NEW.SIGNIN.TOTP"));
		$(".service_name").text(I18N.get("IAM.NEW.SIGNIN.MFA.TOTP.HEADER"));
		$(".product_text,.product_head").hide();
		$("#product_img").removeClass($("#product_img").attr('class'));
		$("#product_img").addClass("tfa_totp_mode")
		$("#forgotpassword").hide();
		$("#nextbtn span").removeClass("zeroheight");
		$("#nextbtn").removeClass("changeloadbtn");
		$("#nextbtn").attr("disabled", false);
		$("#nextbtn span").text(I18N.get("IAM.VERIFY"));
		$("#mfa_totp_container").show();
		$(".service_name").addClass("extramargin");
		$('#mfa_totp').focus();
		isFormSubmited = false;
		callmode="secondary";//no i18n
		signinathmode = "totpsecauth";//No i18N	
	}else if(mfamode==="otp"){//No i18N
		$("#password_container,#captcha_container,.fed_2show,#otp_container").hide();
		$("#headtitle").text(I18N.get("IAM.NEW.SIGNIN.SMS.MODE"));
		$(".service_name").text(formatMessage(I18N.get("IAM.NEW.SIGNIN.MFA.SMS.HEADER"),rmobile));
		var mobileSentInfo = formatMessage(I18N.get("IAM.NEW.SIGNIN.OTP.SENT"),rmobile);
		$("#product_img").removeClass($("#product_img").attr('class'));
		$("#product_img").addClass("tfa_otp_mode");
		$(".alert_message").text(mobileSentInfo);
		$(".Alert").css("top","20px");//No i18N
		window.setTimeout(function(){$(".Alert").css("top","-100px")},5000);
		$("#mfa_otp_container,#mfa_otp_container .textbox_actions").show();//no i18N
		$("#forgotpassword").hide();
		$(".service_name").addClass("extramargin");
		$("#nextbtn span").removeClass("zeroheight");
		$("#nextbtn").removeClass("changeloadbtn");
		$("#nextbtn").attr("disabled", false);
		$("#nextbtn span").text(I18N.get("IAM.VERIFY"));
		$('#mfa_otp').focus();
		isFormSubmited = false;
		callmode="secondary";//no i18n
		signinathmode = "mobilesecauth";//No i18N
	}
	if (!isRecovery) {allowedModeChecking();}
	return false;
}
function enableMyZohoDevice(jsonStr,trymode)
{
	jsonStr = isValid(jsonStr) ? jsonStr : deviceauthdetails;
	$(".loader,.blur").show();
	signinathmode = jsonStr.resource_name;
	var devicedetails = jsonStr[signinathmode].modes.mzadevice.data[parseInt(mzadevicepos)];
	deviceid= devicedetails.device_id;
	isSecondary = allowedmodes.length > 1  && (allowedmodes.indexOf("recoverycode") === -1 && allowedmodes.indexOf("passphrase") === -1 )? true : false;
	isSecondary = (allowedmodes.length > 2 && allowedmodes.indexOf("recoverycode") === -1 && allowedmodes.indexOf("passphrase") === -1) ? true : isSecondary; // no i18n
	isSecondary = (allowedmodes.indexOf("recoverycode") === -1 && allowedmodes.indexOf("passphrase") === -1) && allowedmodes.length === 3 ? false : isSecondary;
	prefoption = trymode ? trymode : devicedetails.prefer_option;
	devicename = devicedetails.device_name;
	bioType = devicedetails.bio_type;
	var loginurl="/signin/v2/"+callmode+"/"+zuid+"/device/"+deviceid+"?";//no i18N
	loginurl += "digest="+digest+ "&" + signinParams; //no i18N
	var jsonData = callmode==="primary" ? {'deviceauth':{'devicepref':prefoption }}: {'devicesecauth':{'devicepref':prefoption }};//no i18N
	sendRequestWithTemptoken(loginurl,JSON.stringify(jsonData),true,handleMyZohoDetails);
	signinathmode = callmode==="primary" ?"deviceauth":"devicesecauth";//no i18N
	return false;
}function enableOneauthDevice(jsonStr,index){
	index = isValid(index) ? index : parseInt(oadevicepos);
	jsonStr = isValid(jsonStr) ? jsonStr : deviceauthdetails;
	var devicedetails = jsonStr[deviceauthdetails.resource_name].modes.oadevice.data[index];
	deviceid= devicedetails.device_id;
	prefoption = devicedetails.prefer_option;
	devicename = devicedetails.device_name;
	if(prefoption==="ONEAUTH_TOTP"){
		enableTOTPdevice(jsonStr,false,true);
		return false;
	}
	var loginurl="/signin/v2/"+callmode+"/"+zuid+"/oneauth/"+deviceid+"?";//no i18N
	loginurl += "digest="+digest+ "&" + signinParams; //no i18N
	var jsonData = {'oneauthsec':{'devicepref':prefoption }};//no i18N
	sendRequestWithTemptoken(loginurl,JSON.stringify(jsonData),true,handleOneAuthDetails);
	signinathmode = "oneauthsec";//no i18N
	return false;
}
function enableYubikeyDevice(jsonStr){
	signinathmode = jsonStr.resource_name;
	yubname = jsonStr[signinathmode].modes.yubikey["yub-name"];//no i18n
	var loginurl="/signin/v2/"+callmode+"/"+zuid+"/yubikey/"+yubname+"?"+signinParams;//no i18n
	sendRequestWithTemptoken(loginurl,"",true,handleYubikeyDetails);
	signinathmode = "yubikeysecauth";//no i18n
	if (!isRecovery) {allowedModeChecking();}
	return false;
	
}
function enableTOTPdevice(resp,isMyZohoApp,isOneAuth){
	$("#password_container,#login_id_container,#captcha_container,.fed_2show,#otp_container").hide();
	$("#headtitle").text(I18N.get("IAM.NEW.SIGNIN.TOTP"));
	$(".service_name").text(I18N.get("IAM.NEW.SIGNIN.MFA.TOTP.HEADER"));
	$(".product_text,.product_head").hide();
	$("#product_img").removeClass($("#product_img").attr('class'));
	$("#product_img").addClass("tfa_totp_mode");
	$("#forgotpassword").hide();
	$("#nextbtn span").removeClass("zeroheight");
	$("#nextbtn").removeClass("changeloadbtn");
	$("#nextbtn").attr("disabled", false);
	$("#nextbtn span").text(I18N.get("IAM.VERIFY"));
	if(isMyZohoApp){
		$(".deviceparent .devicetext").text(devicename);
		$(".devicedetails .devicetext").text(devicename);
		$("#mfa_device_container").show();
		$(".tryanother").show();
		$(".service_name").text(I18N.get("IAM.NEW.SIGNIN.TOTP.HEADER"));
		$("#problemsignin,#recoverybtn,.loader,.blur,.deviceparent").hide();
		clearCommonError("mfa_totp"); // no i18n
		$('.signin_container').removeClass('mobile_signincontainer');
	}	
	else if(isOneAuth){ $(".service_name").text(I18N.get("IAM.NEW.SIGNIN.TOTP.HEADER"));}
	$("#mfa_totp_container").show();
	$("#mfa_totp").focus();
	$(".service_name").addClass("extramargin");
	$('#mfa_totp').val("");
	isFormSubmited = false;
	var mzauth = callmode==="primary" ?"deviceauth":"devicesecauth";//no i18N
	signinathmode = isMyZohoApp ? mzauth : "oneauthsec";//No i18N
	if(!isMyZohoApp && !isRecovery){allowedModeChecking()};
	return false;
}
function enableOneAuthBackup(){
	changeRecoverOption(allowedmodes[0]);
	$('#backup_container .backoption,#recovery_passphrase,#recovery_backup').hide();
	allowedmodes.indexOf("passphrase") != -1 ? $('#recovery_passphrase').show() : $('#recovery_passphrase').hide();
	allowedmodes.indexOf("recoverycode") != -1 ? $('#recovery_backup').show() : $('#recovery_backup').hide();
} // no i18n
function handleYubikeyDetails(resp){ // no i18n
	if(IsJsonString(resp)) {
		var jsonStr = JSON.parse(resp); // no i18n
		var statusCode = jsonStr.status_code;
		if (!isNaN(statusCode) && statusCode >= 200 && statusCode <= 299) {
			var successCode = jsonStr.code;
			if(successCode==="SI203"){
				var challenge = jsonStr[signinathmode].challenge;
			    var appId = jsonStr[signinathmode].appid;
			   	var keyHandle =jsonStr[signinathmode].keyhandle;
			   	var version = jsonStr.yubikeysecauth.version;
			   	u2f.sign(appId,challenge,[{"version":version,"challenge":challenge,"appId":appId,"keyHandle":keyHandle}],u2fverify,10); //No i18N
			   	showYubikeyDetails(yubname,jsonStr.localized_message);
			}	
		}
		else{
			if(jsonStr.cause==="throttles_limit_exceeded"){
				showCommonError("yubikey",jsonStr.localized_message); //no i18n
				return false;
			}
			showCommonError("password",jsonStr.localized_message); //no i18n
			return false;
		}
		return false;
	   	
	}else{
		 var errorcontainer = signinathmode ==="passwordauth"? "password":"login_id";//no i18n
		 showCommonError(errorcontainer,I18N.get(jsonStr.localized_message)); //no i18n
		return false;	
	}
	return false;
}
function showYubikeyDetails(yubname){
	var headtitle="IAM.NEW.SIGNIN.YUBIKEY.TITLE";//no i18n
	var headerdesc="IAM.NEW.SIGNIN.YUBIKEY.HEADER.NEW";//no i18n
	$("#password_container,#login_id_container,#captcha_container,.fed_2show,#otp_container").hide();
	$("#headtitle").text(I18N.get(headtitle));
	$(".service_name").text(I18N.get(headerdesc));
	$(".product_text,.product_head").hide();
	$("#product_img").removeClass($("#product_img").attr('class'));
	$("#product_img").addClass("tfa_yubikey_mode");
	$("#forgotpassword").hide();
	$("#nextbtn").hide();
	$(".service_name").addClass("extramargin");
	$(".deviceparent .devicetext").text(yubname);
	$(".devicedetails .devicetext").text(yubname);
	$('.deviceparent').removeClass('hide');
	$('.deviceparent').css('display','');
	$("#mfa_device_container,.devicedetails").show();
	window.setTimeout(function(){$(".Alert").css("top","-100px")},5000);
	$("#waitbtn").show();
	$(".loadwithbtn").show();
	$(".waitbtn .waittext").text(I18N.get("IAM.NEW.SIGNIN.WAITING.APPROVAL"));
	$("#waitbtn").attr("disabled", true);
	if (!isRecovery) {allowedModeChecking();}
	return false;
}
function handleLookupDetails(resp){
	if($(".blur,.loader").is(":visible")){
		$(".blur,.loader").hide();	
	}
	if(IsJsonString(resp)) {
		var jsonStr = JSON.parse(resp);
		var statusCode = jsonStr.status_code;
		if (!isNaN(statusCode) && statusCode >= 200 && statusCode <= 299) { 
			$(".fed_2show,.line,#signuplink,.banner_newtoold").hide();
			digest = jsonStr[signinathmode].digest;
			zuid = jsonStr[signinathmode].identifier;
			if(isPhoneNumber(de("login_id").value)){
				$('#login_id').val($("#country_code_select").val().split('+')[1]+ "-" + $('#login_id').val());
			}
			var isOTP = isSaml = isFederated = isNoPassword = isJwt = false;
			if(isEmpty(jsonStr[signinathmode].modes) || !isValid(jsonStr[signinathmode].modes)){
                changeButtonAction(I18N.get('IAM.SIGNIN'),false);//no i18n
                $("#forgotpassword").hide();
				var loginId = jsonStr[signinathmode].loginid?jsonStr[signinathmode].loginid:de("login_id").value;//no i18n
				$("#login_id_container,#showIDPs").slideUp(200);
				$("#password_container").removeClass("zeroheight");
				$("#password_container").slideDown(200);
				$('.username').text(loginId);
				$("#password_container .textbox_div,#nextbtn").hide()
				$(".nopassword_container").css("position","absolute");
				$(".nopassword_container").show();
				return false;
			}
			allowedmodes = jsonStr[signinathmode].modes.allowed_modes;
			prev_showmode = allowedmodes[0];
			var altmode = allowedmodes[1];
			var isothermodeavailable = typeof altmode != "undefined";//no i18n
			deviceauthdetails=jsonStr;
			if( allowedmodes[0] === "password" || allowedmodes[0] === "federated"){
				if(isothermodeavailable){
					if(allowedmodes.indexOf("otp") != -1 && allowedmodes.indexOf("saml") != -1){
						$('#enablemore').show();
						$('#enableforgot').hide();
					}else if(allowedmodes.indexOf("otp") != -1 && allowedmodes.indexOf("jwt") != -1){
						$('#enablemore').show();
						$('#enableforgot').hide();
					}
					else if(allowedmodes.length >= 2){
						allowedmodes.forEach(function(usedmodes){
							switch(usedmodes){
								case "otp": //no i18n
									isOTP = true;
									break;
								case "saml": //no i18n
									isSaml = true;
									break;
								case "jwt": //no i18n
									isJwt = true;
									break;
								case "federated": //no i18n
									isFederated =true;
							}
						});
						isNoPassword =  false;
						enablePassword(jsonStr[signinathmode].loginid,isOTP, isSaml, isFederated,isNoPassword,isJwt);
						return false;
					}
					
				}else{
					if(allowedmodes[0]==="federated"){
						isFederated =true;
						isNoPassword = true;
					}
					$("#enableforgot").show();
				}
				enablePassword(jsonStr[signinathmode].loginid,isOTP, isSaml, isFederated, isNoPassword,isJwt);
				return false;
			}else if( allowedmodes[0] === "otp" ){
				emobile = jsonStr[signinathmode].modes.otp.data[0].e_mobile;
				rmobile = jsonStr[signinathmode].modes.otp.data[0].r_mobile;
				$('#signinwithpass').hide();
				isNoPassword = true;
				if(allowedmodes.length >= 2){
					allowedmodes.forEach(function(usedmodes){
						switch(usedmodes){
							case "otp": //no i18n
								isOTP = true;
								break;
							case "password": //no i18n
								isNoPassword = false;
								break;
							case "saml": //no i18n
								isSaml = true;
								break;
							case "jwt": //no i18n
								isJwt = true;
								break;
							case "federated": //no i18n
								isFederated =true;
						}
					});
				}
				enablePassword(jsonStr[signinathmode].loginid,isOTP, isSaml, isFederated,isNoPassword,isJwt);
				enableOTP();
				return false;
			}else if(allowedmodes[0]==="mzadevice"){
				isPasswordless=true;
				secondarymodes = allowedmodes;
				enableMyZohoDevice(jsonStr);
				handleSecondaryDevices();
				return false;
			}else if(allowedmodes[0]==="saml"){
				var redirecturi = jsonStr[signinathmode].modes.saml.redirect_uri;
				switchto(redirecturi);
				return false;
			}else if(allowedmodes[0]==="jwt"){
				var redirecturi = jsonStr[signinathmode].modes.jwt.redirect_uri;
				switchto(redirecturi);
				return false;
			}
			
		}else{
			if(jsonStr.cause==="throttles_limit_exceeded"){
				callback_signin_lookup(jsonStr.localized_message);
				return false;
			}
			var error_resp = jsonStr.errors[0];
			var errorCode=error_resp.code;
			var errorMessage = jsonStr.localized_message;
			if(errorCode === "U400"){ //no i18N
				var loginid = jsonStr.data.loginid;
		    	var deploymentUrl = jsonStr.data.redirect_uri;
		    	var loginurl = deploymentUrl+"/signin?LOGIN_ID="+euc(loginid); //no i18n
		    	if(isValid(queryString)) {
		    		if(isValid(loginID)) {
						loginurl += "&"+removeParamFromQueryString('LOGIN_ID'); //No I18N
			    	} else {
			    		loginurl += "&"+queryString; //No I18N
			    	}
		    	}
		    	switchto(loginurl);
		    	return false;
			}else if(errorCode==="U201"){ //no i18n
				switchto(error_resp.redirect_uri);
				return false;
			}
			else if(errorCode==="IN107" || errorCode === "IN108"){
				$(".fed_2show,.line").hide();
				cdigest=jsonStr.cdigest;
				showHip(cdigest); //no i18N 
				showCaptcha(I18N.get("IAM.NEXT"),false,"login_id");//no i18N
				if( errorCode === "IN107"){
					showCommonError("captcha",errorMessage); //no i18n	
				}
				return false;
			}
			else if(errorCode === "U401"){ //no i18N
				callback_signin_lookup(errorMessage);
				return false;
			}else if(errorCode === "R303"){ //no i18N
				$('#signin_div,.rightside_box,.banner_newtoold').hide();
				$('#restict_signin').show();
				$(".zoho_logo").addClass('applycenter');
				$('.signin_container').addClass('mod_container');
				return false;
			}else{
				callback_signin_lookup(errorMessage);
				return false;
			}
		}
	}else {
		callback_signin_lookup(I18N.get("IAM.ERROR.USER.ACTION"));
		return false;
	}
	return false;
}
function showmoresigininoption(){
	$('#enablemore').hide();
	allowedmodes.splice(allowedmodes.indexOf(prev_showmode), 1);
	allowedmodes.unshift(prev_showmode);
	var problemsignin_con = "";
	var i18n_msg = {"otp":["IAM.NEW.SIGNIN.OTP.TITLE","IAM.NEW.SIGNIN.OTP.HEADER"],"saml":["IAM.NEW.SIGNIN.SAML.TITLE","IAM.NEW.SIGNIN.SAML.HEADER"], "password":["IAM.NEW.SIGNIN.PASSWORD.TITLE","IAM.NEW.SIGNIN.PASSWORD.HEADER"],"jwt":["IAM.NEW.SIGNIN.JWT.TITLE","IAM.NEW.SIGNIN.SAML.HEADER"]}; //No I18N
	var problemsigninheader = "<div class='problemsignin_head'><span class='icon-backarrow backoption' onclick='hideSigninOptions()'></span>"+I18N.get("IAM.NEW.SIGNIN.CHOOSE.OTHER.WAY")+"</div>";
	allowedmodes.forEach(function(prob_mode,position){
		if(position != 0 && prob_mode != 'federated'){
				var secondary_header = I18N.get(i18n_msg[prob_mode][0]);
				var secondary_desc = I18N.get(i18n_msg[prob_mode][1]);
				if(prob_mode==="otp"){
					emobile=deviceauthdetails.lookup.modes.otp.data[0].e_mobile;
					rmobile=deviceauthdetails.lookup.modes.otp.data[0].r_mobile;
					secondary_desc = formatMessage(I18N.get(i18n_msg[prob_mode][1]),rmobile);
				}
				if(prob_mode==="saml"){
					var domainname = deviceauthdetails.lookup.modes.saml.domain;
					secondary_desc = formatMessage(I18N.get(i18n_msg[prob_mode][1]),domainname);
				}
				if(prob_mode==="jwt"){
					var domainname = deviceauthdetails.lookup.modes.jwt.domain;
					secondary_desc = formatMessage(I18N.get(i18n_msg[prob_mode][1]),domainname);
				}
				var prefer_icon =  prob_mode;
				var secondary_con = "<div class='optionstry options_hover' id='secondary_"+prob_mode+"' onclick=showallowedmodes('"+prob_mode+"')>\
										<div class='img_option_try img_option icon-"+prefer_icon+"'></div>\
										<div class='option_details_try decreasewidth'>\
											<div class='option_title_try'>"+secondary_header+"</div>\
											<div class='option_description'>"+secondary_desc+"</div>\
										</div>\
									</div>"
				problemsignin_con += secondary_con;
		}
	});
	$('#problemsigninui').html(problemsigninheader +"<div class='problemsignincon'>"+ problemsignin_con+"</div>");
	$('#password_container,#nextbtn,.signin_head,#otp_container,#captcha_container,.fed_2show').hide();
	$('#problemsigninui').show();
	return false;
}
function handlePasswordDetails(resp){
	if(IsJsonString(resp)) {
		var jsonStr = JSON.parse(resp);
		signinathmode = jsonStr.resource_name;
		var statusCode = jsonStr.status_code;
		if (!isNaN(statusCode) && statusCode >= 200 && statusCode <= 299) { 
			zuid = zuid ? zuid : jsonStr[signinathmode].identifier;
			restrictTrustMfa = jsonStr[signinathmode].restrict_trust_mfa;
			if(!restrictTrustMfa) {
				trustMfaDays = ''+jsonStr[signinathmode].trust_mfa_days;
			}
			var successCode = jsonStr.code;
			if(successCode === "SI302"|| successCode==="SI200" ||successCode === "SI300" || successCode === "SI301" || successCode === "SI303"){
				switchto(jsonStr[signinathmode].redirect_uri);
				return false;
			}else if(successCode==="P500"||successCode==="P501"){//No i18N
				temptoken = jsonStr[signinathmode].token;
				showPasswordExpiry(jsonStr[signinathmode].pwdpolicy);
				return false;
			}
			else if(successCode === "MFA302"){//No i18N
				$("#enablemore").hide();
				if(!isValid(digest)){
					digest = jsonStr[signinathmode].digest;
				}
				allowedmodes = jsonStr[signinathmode].modes.allowed_modes;
				if(allowedmodes.length < 1){
					showCantAccessDevice();
					$("#product_img").removeClass($("#product_img").attr('class'));
					$("#product_img").addClass("tfa_ga_mode");
					$('#recovery_container .backoption').hide();
					return false;
				}
				deviceauthdetails=jsonStr;
				isSecondary = allowedmodes.length > 1 && allowedmodes.indexOf("recoverycode") === -1 ? true : false;//no i18n
				temptoken = jsonStr[signinathmode].token;
				emobile = allowedmodes[0]==="otp" ? jsonStr[signinathmode].modes.otp.data[0].e_mobile : "";
				rmobile = allowedmodes[0]==="otp" ? jsonStr[signinathmode].modes.otp.data[0].r_mobile : "";
				secondarymodes = allowedmodes;
				prev_showmode = allowedmodes[0];
				handleSecondaryDevices();
				if(isPasswordless){
					callmode="secondary";//no i18n
					showMoreSigninOptions();
					$("#product_img").removeClass($("#product_img").attr('class'));
					$("#product_img").addClass("tfa_ga_mode");
					return false;
				}
				if(allowedmodes[0]==="otp"){
					callmode="secondary";//no i18n
					generateOTP();
					return false;
				}
				else if(allowedmodes[0]==="mzadevice"){
					callmode="secondary";//no i18n
					enableMyZohoDevice(jsonStr);
					return false;
				}
				else if(allowedmodes[0]==="oadevice"){
					callmode="secondary";//no i18n
					enableOneauthDevice(jsonStr, oadevicepos);
					return false;
				}
				else if(allowedmodes[0]==="yubikey"){
					callmode="secondary";//no i18N
					enableYubikeyDevice(jsonStr);
					return false;
				}
				else if(allowedmodes[0]==="recoverycode" || allowedmodes[0]==="passphrase"){
					callmode="secondary";//no i18N
					enableOneAuthBackup();
					return false;
				}
				enableMfaField(allowedmodes[0]);
				return false;
			}
		}else{
			if(jsonStr.cause==="throttles_limit_exceeded"){
				showCommonError(signinathmode==="mobileauth"?"otp":"password",jsonStr.localized_message); //no i18n
				return false;
			}
			var error_resp = jsonStr.errors[0];
			var errorCode=error_resp.code;
			var errorMessage = jsonStr.localized_message;
			if(errorCode==="IN107" || errorCode === "IN108"){
				cdigest=jsonStr.cdigest;
				showHip(cdigest); //no i18N 
				showCaptcha(I18N.get("IAM.NEXT"),false,"password");//no i18N
				if( errorCode === "IN107"){
					showCommonError("captcha",errorMessage); //no i18n	
				}
				return false;
			}else{
				showCommonError(signinathmode==="mobileauth"?"otp":"password" ,errorMessage); //no i18n
				return false;	
			}
		}
	}else{
		showCommonError(signinathmode==="mobileauth"?"otp":"password",I18N.get("IAM.ERROR.USER.ACTION")); //no i18n
		return false;
	}
	return false;
}
function handleTotpDetails(resp){
	if(IsJsonString(resp)) {
		var jsonStr = JSON.parse(resp);
		signinathmode = jsonStr.resource_name;
		var statusCode = jsonStr.status_code;
		var container = signinathmode==="mobilesecauth"?"mfa_otp": signinathmode==="mobileauth" ? "otp" :"mfa_totp";//no i18n
		if (!isNaN(statusCode) && statusCode >= 200 && statusCode <= 299) {
			var successCode = jsonStr.code;
			var statusmsg = jsonStr[signinathmode].status;
			if(successCode === "SI302"|| successCode==="SI200" ||successCode === "SI300" || successCode === "SI301" || successCode === "SI303"){
				switchto(jsonStr[signinathmode].redirect_uri);
				return false;
			}
			else if(statusmsg==="success"){
				if(restrictTrustMfa){
					updateTrustDevice(false);
					return false;
				}
				showTrustBrowser();
				return false;
			}
			else if(successCode==="P500"||successCode==="P501"){
				temptoken = jsonStr[signinathmode].token;
				showPasswordExpiry(jsonStr[signinathmode].pwdpolicy);
				return false;
			}
		}else{
			container = isTroubleSignin ? 'verify_totp' : container; // no i18n
			if(jsonStr.cause==="throttles_limit_exceeded"){
				showCommonError(container,jsonStr.localized_message); //no i18n
				return false;
			}
			var error_resp = jsonStr.errors[0];
			var errorCode = error_resp.code;
			var errorMessage = jsonStr.localized_message;
			if(errorCode==="IN107" || errorCode === "IN108"){
				cdigest=jsonStr.cdigest;
				showHip(cdigest); //no i18N 
				showCaptcha(I18N.get("IAM.NEXT"),false,container);//no i18N
				if( errorCode === "IN107"){
					showCommonError("captcha",errorMessage); //no i18n	
				}
				return false;
			}else{
				showCommonError(container,errorMessage); //no i18n
				return false;	
			}
			return false;
		}
	}else{
		var container = signinathmode==="mobilesecauth"?"mfa_otp": signinathmode==="mobileauth" ? "otp" :"mfa_totp";//no i18n
		container = isTroubleSignin ? 'verify_totp' : container; // no i18n
		showCommonError(container,I18N.get("IAM.ERROR.USER.ACTION")); //no i18n
		return false;
	}
	return false;
}
function handleMyZohoDetails(resp){
	if(IsJsonString(resp)) {
		var jsonStr = JSON.parse(resp);
		signinathmode = jsonStr.resource_name;
		var statusCode = jsonStr.status_code;
		if (!isNaN(statusCode) && statusCode >= 200 && statusCode <= 299) {
			var successCode = jsonStr.code;
			if(successCode === "SI202"||successCode==="MFA302" || successCode==="SI302" || successCode==="SI201"){
				temptoken = jsonStr[signinathmode].token;
				if(isResend){
					showResendPushInfo();
					return false;
				}
				isTroubleSignin = false;
				if(prefoption==="totp"){
					$('.step_two').html(I18N.get("IAM.NEW.SIGNIN.RIGHT.PANEL.VERIFY.TOTP"));
					$('.step_three').html(I18N.get("IAM.NEW.SIGNIN.RIGHT.PANEL.ALLOW.TOTP"));
					$('.approved').css('background','url("../images/TOTP_Verify.svg") no-repeat transparent');
					$("#mfa_scanqr_container,#mfa_push_container,#waitbtn,#openoneauth").hide();
					enableTOTPdevice(jsonStr,true,false);
					return false;
				}
				var headtitle = prefoption ==="push" ? "IAM.NEW.SIGNIN.VERIFY.PUSH" : prefoption === "totp" ? "IAM.NEW.SIGNIN.TOTP" : prefoption === "scanqr" ? "IAM.NEW.SIGNIN.QR.CODE" : "";//no i18N
				var headerdesc = prefoption ==="push" ? "IAM.NEW.SIGNIN.MFA.PUSH.HEADER" : prefoption === "totp" ? "IAM.NEW.SIGNIN.TOTP.HEADER" : prefoption === "scanqr" ? "IAM.NEW.SIGNIN.QR.HEADER":"";//no i18N
				$("#password_container,#login_id_container,#captcha_container,.fed_2show,#recoverybtn,#otp_container,.deviceparent").hide();
				$("#headtitle").text(I18N.get(headtitle));
				$('.devices .selection').css('display','');
				$(".service_name").text(I18N.get(headerdesc));
				$(".product_text,.product_head").hide();
				$("#product_img").removeClass($("#product_img").attr('class'));
				$("#product_img").addClass("tfa_"+prefoption+"_mode");
				$("#forgotpassword,#problemsignin,#recoverybtn").hide();
				$("#nextbtn").hide();
				$("#mfa_"+prefoption+"_container").show();
				$(".service_name").addClass("extramargin");
    			$("#mfa_device_container").show();
    			$('.signin_container').removeClass('mobile_signincontainer');
    			if(prefoption === "push" || prefoption==="scanqr" ){
    				var wmsid = jsonStr[signinathmode].WmsId && jsonStr[signinathmode].WmsId.toString();
    				isVerifiedFromDevice(prefoption,true,wmsid);
    			}
    			if(prefoption==="push"){
    				$("#waitbtn,.loadwithbtn").show();
    				$(".waitbtn .waittext").text(I18N.get("IAM.NEW.SIGNIN.WAITING.APPROVAL"));
    				$("#waitbtn").attr("disabled", true);
    				$("#mfa_scanqr_container,#mfa_totp_container,#openoneauth").hide();
    				$(".loader,.blur").hide();
    				window.setTimeout(function (){
        				$(".waitbtn .waittext").text(I18N.get("IAM.PUSH.RESEND.NOTIFICATION"));
        				$(".loadwithbtn").hide();
        				$("#waitbtn").attr("disabled", false);
        				isFormSubmited = false;
        				return false;
        				
    				},20000);
    			}
    			if(prefoption==="scanqr"){
    				$('.step_two').html(I18N.get("IAM.NEW.SIGNIN.RIGHT.PANEL.ALLOW.SCANQR"));
    				$('.step_three').html(I18N.get("IAM.NEW.SIGNIN.RIGHT.PANEL.VERIFY.SCANQR"));
    				$('.approved').css('background','url("../images/SCANQR_Verify.svg") no-repeat transparent');
    				signinathmode = jsonStr.resource_name;
    				$("#waitbtn").hide();
    				var qrcodeurl = jsonStr[signinathmode].img;
    				qrtempId =  jsonStr[signinathmode].temptokenid;
    				isValid(qrtempId) ? $("#openoneauth").show() : $("#openoneauth").hide();
    				$("#mfa_push_container,#mfa_totp_container").hide();
    				$("#qrimg").attr("src",qrcodeurl);//no i18n
    				$(".checkbox_div").addClass("qrwidth");
    			}
    			$(".tryanother").show();
				isFormSubmited = false;
				signinathmode = callmode === "primary" ? "deviceauth" : "devicesecauth";//no i18N
				$(".loader,.blur").hide();
				return false;
			}
		}else{
			var errorcontainer= isPasswordless ? "login_id" : prefoption==="totp"? "mfa_totp": $("#password_container").is(":visible") ? "password" : $("#otp_container").is(":visible") ?"otp" : "yubikey";//no i18n
			errorcontainer = isResend ? "yubikey" : errorcontainer;//no i18N
			errorcontainer === "yubikey" ? $("#yubikey_container").show() : $("#yubikey_container").hide();//no i18N
			var error_resp = jsonStr.errors && jsonStr.errors[0];
			var errorCode = error_resp && error_resp.code;
			if(errorCode === "D105"){
				$('.fed_2show').hide();
				showCommonError(errorcontainer,jsonStr.localized_message); //no i18n
				if (!isRecovery) {allowedModeChecking();}
				return false;
			}
			$('#problemsignin,#recoverybtn').hide();
			if(jsonStr.cause==="throttles_limit_exceeded"){
				showCommonError(errorcontainer,jsonStr.localized_message); //no i18n
				$(".loader,.blur").hide();
				return false;
			}

			if(jsonStr.cause==="pattern_not_matched"){
				changeHip();
				showCommonError("captcha",jsonStr.localized_message);//no i18n
				$(".loader,.blur").hide();
				return false;
			}
			var error_resp = jsonStr.errors[0];
			var errorCode=error_resp.code;
			var errorMessage = jsonStr.localized_message;
			showCommonError(errorcontainer,errorMessage); //no i18n
			$(".loader,.blur").hide();
			return false;
	   }
		
	}else{
		var errorcontainer = signinathmode ==="passwordauth"? "password":"login_id";//no i18n
		showCommonError(errorcontainer,I18N.get("IAM.ERROR.USER.ACTION")); //no i18n
		return false;
	}
	return false;
}
function handleOneAuthDetails(resp){
	if(IsJsonString(resp)) {
		var jsonStr = JSON.parse(resp);
		signinathmode = jsonStr.resource_name;
		var statusCode = jsonStr.status_code;
	if (!isNaN(statusCode) && statusCode >= 200 && statusCode <= 299) {
		var successCode = jsonStr.code;
		if(successCode==="SI302"||successCode==="MFA302"||successCode==="SI202"|| successCode==="SI201"){
			temptoken = jsonStr[signinathmode].token;
			var devicemode = prefoption ==="ONEAUTH_PUSH_NOTIF" ? "push" : prefoption === "ONEAUTH_TOTP" ? "totp" : prefoption === "ONEAUTH_SCAN_QR" ? "scanqr" : prefoption === "ONEAUTH_FACE_ID" ? "faceid": prefoption === "ONEAUTH_TOUCH_ID" ? "touch" : "";//no i18N
			if(isResend){
				showResendPushInfo();
				return false;
			}
			var headtitle = prefoption ==="ONEAUTH_PUSH_NOTIF" ? "IAM.NEW.SIGNIN.VERIFY.PUSH" : prefoption === "ONEAUTH_TOTP" ? "IAM.NEW.SIGNIN.TOTP" : prefoption === "ONEAUTH_SCAN_QR" ? "IAM.NEW.SIGNIN.QR.CODE" : prefoption === "ONEAUTH_FACE_ID" ? "IAM.NEW.SIGNIN.FACEID.TITLE": prefoption === "ONEAUTH_TOUCH_ID" ? "IAM.NEW.SIGNIN.TOUCHID.TITLE" : "";//no i18N
			var headerdesc = prefoption ==="ONEAUTH_PUSH_NOTIF" ? "IAM.NEW.SIGNIN.MFA.PUSH.HEADER" : prefoption === "ONEAUTH_TOTP" ? "IAM.NEW.SIGNIN.ONEAUTH.TOTP.HEADER" : prefoption === "ONEAUTH_SCAN_QR" ? "IAM.NEW.SIGNIN.QR.HEADER" : prefoption === "ONEAUTH_FACE_ID" ? "IAM.NEW.SIGNIN.FACEID.HEADER": prefoption === "ONEAUTH_TOUCH_ID" ? "IAM.NEW.SIGNIN.TOUCHID.HEADER":"";//no i18N
			$("#password_container,#login_id_container,#captcha_container,.fed_2show,#otp_container,.deviceparent").hide();
			$("#headtitle").text(I18N.get(headtitle));
			$(".service_name").text(I18N.get(headerdesc));
			$(".product_text,.product_head").hide();
			$("#product_img").removeClass($("#product_img").attr('class'));
			$('.devices .selection').css('display','');
			$("#product_img").addClass("tfa_"+devicemode+"_mode");
			$("#forgotpassword").hide();
			$("#nextbtn").hide();
			$("#mfa_"+devicemode+"_container").show();
			$(".service_name").addClass("extramargin");
			$("#mfa_device_container").show();
			if (!isRecovery) {allowedModeChecking();}
			if(devicemode==="push"||devicemode==="touch"|| devicemode==="faceid" ||devicemode === "scanqr"){
				var wmsid = jsonStr[signinathmode].WmsId && jsonStr[signinathmode].WmsId.toString();
				callmode="secondary";//no i18n
				isVerifiedFromDevice(prefoption,false,wmsid);
			}
			if(devicemode==="push"||devicemode==="touch"|| devicemode==="faceid"){
				$("#waitbtn").attr("disabled", true);
				$(".waitbtn .waittext").text(I18N.get("IAM.NEW.SIGNIN.WAITING.APPROVAL"));
				$(".loadwithbtn").show();
				$("#waitbtn").show();
				$("#openoneauth").hide();
				window.setTimeout(function (){
					$(".waitbtn .waittext").text(I18N.get("IAM.PUSH.RESEND.NOTIFICATION"));
					$("#waitbtn").attr("disabled", false);
					$(".loadwithbtn").hide();
					isFormSubmited = false;
					return false;
					
				},20000);
			}
			if(devicemode==="scanqr"){
				var qrcodeurl = jsonStr[signinathmode].img;
				qrtempId =  jsonStr[signinathmode].temptokenid;
				isValid(qrtempId) ? $("#openoneauth").show() : $("#openoneauth").hide();
				$("#qrimg").attr("src",qrcodeurl);//no i18n
				$(".checkbox_div").addClass("qrwidth");
			}
			isFormSubmited = false;
			return false;
			}
		}
		else{
			var errorcontainer= (prefoption==="totp"||prefoption==="ONEAUTH_TOTP") ? "mfa_totp": "yubikey";//no i18n
			errorcontainer === "yubikey" ? $("#yubikey_container").show() : $("#yubikey_container").hide();//no i18N
			var error_resp = jsonStr.errors[0];
			var errorCode = error_resp.code;
			if(errorCode === "D105"){
				showCommonError(errorcontainer,jsonStr.localized_message); //no i18n
				$('.fed_2show').hide();
				if (!isRecovery) {allowedModeChecking();}
				return false;
			}
			if(jsonStr.cause==="throttles_limit_exceeded"){
				showCommonError(errorcontainer,jsonStr.localized_message); //no i18n
				return false;
			}
			showCommonError(errorcontainer,jsonStr.localized_message); //no i18n
			return false;
		}
		return false;
	}else{
		var errorcontainer = signinathmode ==="passwordauth"? "password":"login_id";//no i18n
		showCommonError(errorcontainer,I18N.get("IAM.ERROR.USER.ACTION")); //no i18n
		return false;
	}
	return false;
}
function handlePassphraseDetails(resp){
	if(IsJsonString(resp)) {
		var jsonStr = JSON.parse(resp);
		signinathmode = jsonStr.resource_name;
		var statusCode = jsonStr.status_code;
		if (!isNaN(statusCode) && statusCode >= 200 && statusCode <= 299) {
			var successCode = jsonStr.code;
			var statusmsg = jsonStr.passphrasesecauth.status;
			if(statusmsg==="success"){
				if(restrictTrustMfa){
					updateTrustDevice(false);
					return false;
				}
				showTrustBrowser();
				return false;
			}else if(successCode==="P500"||successCode==="P501"){//no i18N
				temptoken = jsonStr[signinathmode].token;
				showPasswordExpiry(jsonStr[signinathmode].pwdpolicy);
				return false;
			}
			else{
				showCommonError("passphrase",jsonStr.localized_message);//no i18n
				return false;
			}
		}else{
			if(jsonStr.cause==="throttles_limit_exceeded"){
				showCommonError("passphrase",jsonStr.localized_message); //no i18n
				return false;
			}
			var error_resp = jsonStr.errors && jsonStr.errors[0];
			var errorCode= error_resp && error_resp.code;
			if(errorCode==="IN107" || errorCode === "IN108"){
				$(".fed_2show,.line").hide();
				cdigest=jsonStr.cdigest;
				showHip(cdigest, 'bcaptcha_img'); //no i18N
				$("#bcaptcha_container").show();
				$("#bcaptcha").focus();
				clearCommonError('bcaptcha');//no i18N
				changeButtonAction(I18N.get("IAM.VERIFY"),false);
				if( errorCode === "IN107"){
					showCommonError("bcaptcha",errorMessage); //no i18n	
				}
				return false;
			}
			showCommonError("passphrase",jsonStr.localized_message);//no i18n
			return false;
		}
	}
}
function handleRightPanelAnimation(){
	$('.mfa_panel').addClass('hide');
	$('.oneauth_panel').removeClass('hide');
	$('#mfa_device_container .selection').show();
	var whichstep = 1;
    imageloader = setInterval(function(){
        ClickStep(whichstep,false);
        whichstep++;
        if(whichstep > 3){
            whichstep = 1;
        }
    },2000);
}
var wmscount =0;
var _time;
var verifyCount = 0;
var totalCount = 0;
var isWmsRegistered=false;
var wmscallmode,wmscallapp,wmscallid;
function isVerifiedFromDevice(prefmode,isMyZohoApp,WmsID) {
	if(isWmsRegistered === false && isValid(WmsID) && WmsID != "undefined" ){
		wmscallmode=prefmode;wmscallapp=isMyZohoApp;wmscallid=WmsID;
		try {
			WmsLite.setNoDomainChange();
	 		WmsLite.registerAnnon('AC', WmsID ); //No I18N
	 		isWmsRegistered=true;
	 		
	 	} catch (e) {
		//no need to handle failure
	 	}
	}
	prefmode = prefmode === undefined ? wmscallmode:prefmode;
    isMyZohoApp = isMyZohoApp === undefined ? wmscallapp : isMyZohoApp;
    WmsID = WmsID === undefined ? wmscallid : WmsID;
	clearInterval(_time);
	if(isValid(WmsID) && WmsID!="undefined"){
		wmscount++;
		if(verifyCount > 15) {
			return false;
			}
	}else{
		if(verifyCount > 25) {
   			return false;
   			}
	}
	var loginurl = isMyZohoApp ? "/signin/v2/"+callmode+"/"+zuid+"/device/"+deviceid+"?":"/signin/v2/"+callmode+"/"+zuid+"/oneauth/"+deviceid+"?";//no i18N
	loginurl += "digest="+digest+ "&" + signinParams+"&polling="+true ; //no i18N
	var jsonData = {'oneauthsec':{'devicepref':prefmode }};//no i18N
	if(isMyZohoApp){
		jsonData = callmode==="primary" ? {'deviceauth':{'devicepref':prefmode }} : {'devicesecauth':{'devicepref':prefmode }};//no i18N
	}
	sendRequestWithTemptoken(loginurl,JSON.stringify(jsonData),true,VerifySuccess,"PUT");//No i18N
	verifyCount++;
	if(isValid(WmsID) && WmsID!="undefined"){
		if(wmscount < 6){
			_time = setInterval("isVerifiedFromDevice(\""+prefmode+"\","+isMyZohoApp+",\""+WmsID+"\")", 5000);//No I18N

		}else{
			_time = setInterval("isVerifiedFromDevice(\""+prefmode+"\","+isMyZohoApp+",\""+WmsID+"\")", 25000);//No I18N
		}
	}else{
		_time = setInterval("isVerifiedFromDevice(\""+prefmode+"\","+isMyZohoApp+",\""+WmsID+"\")", 5000);//No I18N
	}
	return false;
}
function VerifySuccess(res) {
	if(IsJsonString(res)) {
		var jsonStr = JSON.parse(res);
		signinathmode = jsonStr.resource_name;
		var statusCode = jsonStr.status_code;
		if (!isNaN(statusCode) && statusCode >= 200 && statusCode <= 299) {
			var successCode = jsonStr.code;
			var statusmsg = jsonStr[signinathmode].status;
			if(successCode === "SI302"|| successCode==="SI200" ||successCode === "SI300" || successCode === "SI301" || successCode === "SI303"){
				switchto(jsonStr[signinathmode].redirect_uri);
				return false;
			}
			else if(statusmsg==="success"){
				clearInterval(_time);
				if(restrictTrustMfa){
					updateTrustDevice(false);
					return false;
				}
				showTrustBrowser();
				return false;
			}
			else if(successCode==="P500"||successCode==="P501"){
				temptoken = jsonStr[signinathmode].token;
				showPasswordExpiry(jsonStr[signinathmode].pwdpolicy);
				return false;
			}
		}
	}
	return false;
}
function handleSecondaryDevices(){
	$('.secondary_devices_right,.secondary_devices').find('option').remove().end();
	var deviceDetails = deviceauthdetails[deviceauthdetails.resource_name].modes;
	var isSecondaryDevice = false;
	if(deviceDetails.mzadevice){
		var mzadevice = deviceDetails.mzadevice.data;
		var optionElem = '';
		mzadevice.forEach(function(data,index){
			optionElem += "<option value="+index+" version='"+data.app_version+"'>"+data.device_name+"</option>";
			isSecondaryDevice = true;
		});
	}
	if(deviceDetails.oadevice){
		var oadevice = deviceDetails.oadevice.data;
		oadevice.forEach(function(data,index){
			optionElem += "<option value="+index+" version='"+data.app_version+"'>"+data.device_name+"</option>";
			isSecondaryDevice = true;
		});
	}
	document.getElementsByClassName('secondary_devices')[0].innerHTML = optionElem; // no i18n
	document.getElementsByClassName('secondary_devices_right')[0].innerHTML = optionElem; // no i18n
	if(isSecondaryDevice){
		try { 
			$(".secondary_devices,.secondary_devices_right").select2({
		        allowClear: true,
		        templateResult: secondaryFormat,
		        minimumResultsForSearch: Infinity,
		        templateSelection: function (option) {
		              return "<div><span class='icon-device select_icon'></span><span class='select_con options_selct' value="+$(option.element).attr("value")+" version="+$(option.element).attr("version")+">"+option.text+"</span><span class='downarrow'></span></div>";
		        },
		        escapeMarkup: function (m) {
		          return m;
		        }
		      });
			window.setTimeout(function(){
				$('.devices .select2').addClass("device_select");
				$('.devices .select2').show();
				$('.devices .select2-selection--single').addClass('device_selection');
				$('.devicedetails').hide();
				if(!($('.secondary_devices option').length > 1 )){
					$('.downarrow').hide();
					$('.devices .selection').css("pointer-events", "none");
				}
			},100);
		}catch(err){
			isMobile ? $('.secondary_devices').css('display','block') : $('.secondary_devices_right').css('display','block');
			if(!($('.secondary_devices option').length > 1 )){
				$('.secondary_devices,.secondary_devices_right').css("pointer-events", "none");
			}
			$('option').each(function() {
				if(this.text.length > 20){
					var optionText = this.text;
					var newOption = optionText.substring(0, 20);
					$(this).text(newOption + '...');
				}
			});
		}
	}
}
function secondaryFormat(option){
	return "<div><span class='icon-device select_icon'></span><span class='select_con' value="+$(option.element).attr("value")+" version="+$(option.element).attr("version")+">"+option.text+"</span></div>";
}
function showMoreSigninOptions(){
	showproblemsignin(true);
	showCantAccessDevice();
	$('.problemsignin_head,.recoveryhead .backoption').hide();
	allowedmodes.indexOf("recoverycode") != -1 ? $('#recoverOption').show() : $('#recoverOption').hide();
	allowedmodes.indexOf("passphrase") != -1 ? $('#passphraseRecover').show() : $('#passphraseRecover').hide();
	$('.rec_head_text').text(I18N.get("IAM.NEW.SIGNIN.FEDERATED.LOGIN.TITLE"));
	$(".signin_head").prepend( "<span class='icon-backarrow backoption' onclick='showCantAccessDevice()'></span>" );
	$('.backuphead .backoption,.greytext').hide();
	$('.recoveryhead .backoption').css("cssText", "display: none !important;");
	$('#recoverymodeContainer').html($('.problemsignincon').html()+$('.recoverymodes').html());
	$('.recoverymodes').hide();
	if($('#recoverymodeContainer').children().length - !$('#recoverOption').is(":visible") - !$('#passphraseRecover').is(":visible")  > 3 && !isMobile){
		$('#recoverymodeContainer').addClass('problemsignincontainer');
	}
	isRecovery= true; // no i18n
	isPasswordless = false;
}

function generateOTP(isResendOnly)
{
	var loginurl="/signin/v2/"+callmode+"/"+zuid+"/otp/"+emobile;//no i18N
	if(isResendOnly){
		loginurl += "?digest="+digest+ "&" + signinParams; //no i18N
		var method = signinathmode === "mobileauth" ? "POST" : "PUT"; // no i18n
		var jsonData = signinathmode === "mobileauth" ? { "mobileauth" : { 'mdigest' : mdigest} } : { "mobilesecauth" : { 'mdigest' : mdigest} };//no i18N
		sendRequestWithTemptoken(loginurl,JSON.stringify(jsonData),true,showResendInfo,method);//no i18n
		return false;		
	}else{
		var params = "digest="+digest+ "&" + signinParams //no i18N
		sendRequestWithTemptoken(loginurl, params ,true,enableOTPDetails );//No I18N	
	}
	
	return false;
}

function showResendInfo(resp){
	if(IsJsonString(resp)) {
		var jsonStr = JSON.parse(resp);
		signinathmode = jsonStr.resource_name;
		var statusCode = jsonStr.status_code;
		if (!isNaN(statusCode) && statusCode >= 200 && statusCode <= 299) {
			var successCode = jsonStr.code;
			if(successCode === "SI201"|| successCode==="SI200" ){
				mdigest = jsonStr[signinathmode].mdigest;
				var mobileSentInfo = formatMessage(I18N.get("IAM.NEW.SIGNIN.OTP.SENT"),rmobile);
				$(".alert_message").text(mobileSentInfo);
				$(".Alert").css("top","20px");//No i18N
				window.setTimeout(function(){$(".Alert").css("top","-100px")},5000);
				resendotp_checking();
				return false;
			}
		}else{
			if(jsonStr.cause==="throttles_limit_exceeded"){
				if(isPrimaryDevice){
					$(".error_message").html(jsonStr.localized_message);
					$(".Errormsg").css("top","20px");//No i18N
					window.setTimeout(function(){$(".Errormsg").css("top","-100px")},5000);
					return false;
				}
				showCommonError("otp_container",jsonStr.localized_message); //no i18n
				return false;
			}
			var error_resp = jsonStr.errors && jsonStr.errors[0];
			var errorCode= error_resp && error_resp.code;
			var errorMessage = jsonStr.localized_message;
			if(errorCode==="IN107" || errorCode === "IN108"){
				cdigest=jsonStr.cdigest;
				showHip(cdigest); //no i18N 
				showCaptcha(I18N.get("IAM.NEXT"),false,"otp");//no i18N
				if( errorCode === "IN107"){
					showCommonError("captcha",errorMessage); //no i18n	
				}
				return false;
			}
			else{
				showCommonError("otp_container",errorMessage); //no i18n
				return false;	
			}
			
		}
	}
	return false;
	
}
function enableOTPDetails(resp){
	if(IsJsonString(resp)) {
		var jsonStr = JSON.parse(resp);
		signinathmode = jsonStr.resource_name;
		var statusCode = jsonStr.status_code;
		if (!isNaN(statusCode) && statusCode >= 200 && statusCode <= 299) {
			var successCode = jsonStr.code;
			if(successCode === "SI201"|| successCode==="SI200" ){
				mdigest = jsonStr[signinathmode].mdigest;
				var tempsigninathmode = mobposition === 0 ? signinathmode : "passwordauth"; //no i18n
				isSecondary = deviceauthdetails.passwordauth && deviceauthdetails.passwordauth.modes.otp.count > 1 || (allowedmodes.length >1 && allowedmodes.indexOf("recoverycode") === -1) ? true : false; // no i18n
				if(signinathmode === "mobileauth"){
					var mobileSentInfo = formatMessage(I18N.get("IAM.NEW.SIGNIN.OTP.SENT"),rmobile);
					$(".alert_message").text(mobileSentInfo);
					$(".Alert").css("top","20px");//No i18N
					window.setTimeout(function(){$(".Alert").css("top","-100px")},5000);
					resendotp_checking();
					return false;	
				}
				if(!isValid(digest)){
					digest = jsonStr[signinathmode].mdigest;					
				}
				enableMfaField("otp");//no i18N
				resendotp_checking();
				return false;
			}
			return false;
		}
		else{
			if(jsonStr.cause==="throttles_limit_exceeded"){
				showCommonError("password",jsonStr.localized_message); //no i18n
				return false;
			}
			var errorMessage = jsonStr.localized_message;
			showCommonError("password",errorMessage); //no i18n
			return false;
		}
	}
	return false;
}

function resendotp_checking(){
	var resendtiming = 60;
	clearInterval(resendTimer);
	$('.resendotp').addClass('nonclickelem');
	$('.resendotp span').text(resendtiming);
	$('.resendotp').html(I18N.get('IAM.TFA.RESEND.OTP.COUNTDOWN'));
	resendTimer = setInterval(function(){
		resendtiming--;
		$('.resendotp span').text(resendtiming);
		if(resendtiming === 0) {
			clearInterval(resendTimer);
			$('.resendotp').html(I18N.get('IAM.NEW.SIGNIN.RESEND.OTP'));
			$('.resendotp').removeClass('nonclickelem');
		}
	},1000);
}
function u2fverify(data) {
	    if(data.errorCode) {
	    	$("#yubikey_container").show();
	        switch (data.errorCode) {
		        case 1:
		        case 5:
	            	showError(); //No I18N
	                break;
	            case 2:
	            	showCommonError("yubikey",I18N.get('IAM.NEW.SIGNIN.YUBIKEY.ERROR.BADREQUEST')); //No I18N
	            	break;
	        	case 3:
	        		showCommonError("yubikey",I18N.get('IAM.NEW.SIGNIN.YUBIKEY.ERROR.UNSUPPORTED')); //No I18N
	                break;
	            case 4:
	            	showCommonError("yubikey",I18N.get('IAM.NEW.SIGNIN.YUBIKEY.ERROR.DEVICEINELIGIBLE')); //No I18N
	            	break;
	            default:
	            	showCommonError("yubikey",I18N.get('IAM.MFA.YUBIKEY.ERROR.INVALID.REQUEST')); //No I18N
	      }
	        return;
	    } else {
	        data.value = JSON.stringify(data);
	        var loginurl = "/signin/v2/"+callmode+"/"+zuid+"/yubikey/"+yubname+"?"+signinParams;//no i18N
	        var jsonData = { 'yubikeysecauth': { 'keyHandle': data.keyHandle, 'clientData': data.clientData, 'signatureData': data.signatureData } };//no i18N
	        sendRequestWithTemptoken(loginurl,JSON.stringify(jsonData),true,VerifySuccess,"PUT");//no i18N
	        return false;
	     	
	    }
	    return false;
}
function changeRecoverOption(recoverOption){
	recoverOption === "passphrase" ? showPassphraseContainer() : showBackupVerificationCode(); //no i18n
	if(recoverOption === "passphrase"){
		recoverTitle = I18N.get("IAM.NEW.SIGNIN.PASSPHRASE.RECOVER.TITLE");
		recoverHeader = I18N.get("IAM.NEW.SIGNIN.PASSPHRASE.RECOVER.HEADER");
	}else if(recoverOption === "recoverycode"){ // no i18n
		recoverTitle = I18N.get("IAM.BACKUP.VERIFICATION_CODE");
		recoverHeader = I18N.get("IAM.NEW.SIGNIN.BACKUP.RECOVER.HEADER");
	}
	$('#backup_container #backup_title').text(recoverTitle);
	$('#backup_container .backup_desc').text(recoverHeader);
	$("#backup_container .backoption").hide();
}
function showError(){
	$(".waitbtn .waittext").text(I18N.get("IAM.NEW.SIGNIN.RETRY.YUBIKEY"));
	$(".loadwithbtn").hide();
	$("#waitbtn").attr("disabled", false);
	isFormSubmited = false;
	return false;
}
function showMoreIdps(){
	$("#login,.line").hide();
	$(".small_box").removeClass("small_box");
    $(".fed_div").addClass("large_box")
    $(".fed_text").show();
	$(".zohosignin").removeClass("hide");
	$("#showIDPs").hide();
	$(".fed_div").show();
	$(".more").hide();
	$(".signin_fed_text").addClass("signin_fedtext_bold");
	$(".signin_container").css("height","auto");//no i18n
	var isSafari = /^((?!chrome|android).)*safari/i.test(navigator.userAgent) || /Mac|iPad|iPhone|iPod/.test(navigator.platform || "");
	if(isSafari) {
		$(".fed_center_google").css("width","max-content");
		$(".apple_fed").hide();
		$("#macappleicon").show();
		return false;
	}
	$("#macappleicon").hide();
 }
function showZohoSignin(){
	$("#login,.line").show();
	$(".zohosignin").addClass("hide");
	$(".fed_text,.fed_div").hide();
	$(".signin_fed_text").removeClass("signin_fedtext_bold");
	$(".more,.show_fed").show();
	if(de("login_id")){
   		$('#login_id').focus();
   	 }
	$(".large_box").removeClass("large_box");
    $(".fed_div").addClass("small_box");
    fediconsChecking();
 }
function showHidePassword(){
	var passwordField = $("#new_password").is(":visible") ? "#new_password" :"#password";//no i18N
	 var passType = $(passwordField).attr("type");//no i18n
	$(passwordField).focus();
	 if(passType==="password"){
		$(passwordField).attr("type","text");//no i18n
		$(".show_hide_password").addClass("icon-show");
	 }else{
		$(passwordField).attr("type","password");//no i18n
		$(".show_hide_password").removeClass("icon-show");
	 }
}
function changeCountryCode(){
	$('.select_country_code').text($('#country_code_select').val());
}
function fediconsChecking(){
	$(".large_box").removeClass("large_box");
    $(".fed_div").addClass("small_box");
    $(".fed_text,.fed_div").hide();
    var isSafari = /^((?!chrome|android).)*safari/i.test(navigator.userAgent) || /Mac|iPad|iPhone|iPod/.test(navigator.platform || "");
    if(isSafari){
    	$(".small_box .fed_center_google").css("width","35px");
    	$(".small_box .googleIcon").css("margin-left","6px");
    }
	if(document.getElementsByClassName('fed_div').length > 0){
		document.getElementsByClassName('fed_div')[0].style.display = "inline-block";
		document.getElementsByClassName('fed_div')[0].classList.add("show_fed"); // no i18n
		var googleVisible = $('.google_fed').is(":visible") || $('.google_fed').length > 0;
	    var fed_all_width = googleVisible ? $('.signin_box').width() - $('.google_fed').outerWidth() : $('.signin_box').width();
	    var show_fed_length =(fed_all_width % 50 === 0) ?  Math.floor(fed_all_width / 50) - 1 : Math.floor(fed_all_width / 50);
	    if($('.fed_div').length -1 > show_fed_length){
	    	show_fed_length = isSafari ? show_fed_length -1 : show_fed_length;
	    	for(var i= 0; i < show_fed_length; i++){
	    		document.getElementsByClassName('fed_div')[i].style.display = "inline-block";
	    		document.getElementsByClassName('fed_div')[i].classList.add("show_fed"); // no i18n
	    	}
	        $('.more').show();
	    }else{
	    	$('.fed_div').show();
	    	$('.more').hide()
	    }
		if($('.fed_div').length <= 1){
			$('.fed_2show').hide();
		}
		$("#macappleicon").hide();
		if(isSafari){
	    	$(".apple_normal_icon").hide();
	    	$("#macappleicon").show();
	    }
	}
}
function onSigninReady(){
	$(".blur,.loader").hide();
	clearInterval(_time);
	reload_page =setInterval(checkCookie, 5000); //No I18N
	isMobileonly = false;
	if(isMobile && isDarkMode){
		$('body').addClass('darkmode');
	}
	if(istlsEnabled){checkTls();}
	setCookie(24);
    if(document.cookie.indexOf("IAM_TEST_COOKIE") != -1){ // cookie is Enabled
        setCookie(0);
        $('#enableCookie').hide();
    } else { // cookie is disabled
        $('.signin_container,#signuplink,.banner_newtoold').hide();
        $('#enableCookie').show();
    }
	if(!isMobile){$('#login_id').focus()};
	if(isClientPortal){
		return false;
	}
	if(isCaptchaNeeded === "true"){
		changeHip();
		$("#captcha_container").show();
		$(".signin_container,.rightside_box").css("height","600px");
	}
	if(isValid(reqCountry)){
      	reqCountry = "#"+reqCountry.toUpperCase();
      	$('#country_code_select option:selected').removeAttr('selected');
      	$("#country_code_select "+reqCountry).attr('selected','selected');
      	$("#country_code_select "+reqCountry).trigger('change');
      }
	$(".select_country_code").html($("#country_code_select").val());
	$("#country_code_select").select2({
        allowClear: true,
        templateResult: format,
        searchInputPlaceholder: 'Search',//no i18n
        templateSelection: function (option) {
              return option.text;
        },
        escapeMarkup: function (m) {
          return m;
        }
      });
      $("#select2-country_code_select-container").html($("#country_code_select").val());
      $("#country_code_select").change(function(){
        $(".country_code").html($("#country_code_select").val());
        $("#select2-country_code_select-container").html($("#country_code_select").val());
        $("#login_id").removeClass("textindent62");
        $("#login_id").removeClass("textintent52");
        $("#login_id").removeClass("textindent42");
        if($("#select2-country_code_select-container").html().length=="3"){
            $("#login_id").addClass("textintent52");
        }
        if($("#select2-country_code_select-container").html().length=="2"){
            $("#login_id").addClass("textindent42");
        }
        if($("#select2-country_code_select-container").html().length=="4"){
            $("#login_id").addClass("textindent62");
        }
      });
}
 (function($) {
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
 })(window.jQuery);
function changeSecDevice(elem){
	var version = $(elem).children("option:selected").attr('version');
	var device_index = $(elem).children("option:selected").val();
	version === "2.0" ? mzadevicepos = device_index : oadevicepos = device_index;
	version === "2.0" ? enableMyZohoDevice() : enableOneauthDevice();
	hideTryanotherWay();
}
function format (option) {
	var spltext;
      if (!option.id) { return option.text; }
         spltext=option.text.split("(");
         var cncode = $(option.element).attr("data-num");//no i18N 
		 var cnnumber = $(option.element).attr("value");//no i18N
		 var cnnum = cnnumber.substring(1);
		 var flagcls="flag_"+cnnum+"_"+cncode;//no i18N
      var ob = '<div class="pic '+flagcls+'" ></div><span class="cn">'+spltext[0]+"</span><span class='cc'>"+cnnumber+"</span>" ;
      return ob;
 };
function handleRequestCountryCode(resp){
	if(IsJsonString(resp)){resp=JSON.parse(resp) }
	if(resp.isd_code){
		reqCountry = resp.country_code;
		reqCountry = "#"+reqCountry.toUpperCase();
      	$('#country_code_select option:selected').removeAttr('selected');
      	$("#country_code_select "+reqCountry).attr('selected','selected');
      	$("#country_code_select "+reqCountry).trigger('change');
      	$("#login_id").removeClass("textindent62");
        $("#login_id").removeClass("textintent52");
        $("#login_id").removeClass("textindent42");
	}
}
function checking(){
	var a=$("#login_id").val();
	var check=/^(?:[0-9] ?){2,1000}[0-9]$/.test(a);
	$(".select2-selection--single").attr("tabindex","-1");//no i18N
	if(!isCountrySelected){
		var reqUrl = "/accounts/public/api/locate"; // no i18n
		sendRequestWithCallback(reqUrl,signinParams,true,handleRequestCountryCode); // no i18n
		isCountrySelected = true;
	}
	if((check==true)&&(a)){
		try{
	        if($("#select2-country_code_select-container").html().length=="3"){
	            $("#login_id").addClass("textintent52");
	        }
	        if($("#select2-country_code_select-container").html().length=="2"){
	            $("#login_id").addClass("textindent42");
	        }
	        if($("#select2-country_code_select-container").html().length=="4"){
	            $("#login_id").addClass("textindent62");
	        }
			$(".selection").addClass("showcountry_code");
			if(isMobile){
		  		$('.select_country_code,#country_code_select').show();
		  	}
			else{
				$('.select2').show();
			}
		}catch(err){
			$('.select_country_code,#country_code_select').css("display","block");
			$("#login_id").addClass("textindent62");
		}
	}
	else if(check==false){
        $("#login_id").removeClass("textindent62");
        $("#login_id").removeClass("textintent52");
        $("#login_id").removeClass("textindent42");
		$(".selection").removeClass("showcountry_code");
		$('.select_country_code,#country_code_select,.select2').hide();
	}
}
function IsJsonString(str) {
	try {
		$.parseJSON(str);
	} catch (e) {
		return false;
	}
	return true;
}
function isValid(instr) {
	return instr != null && instr != "" && instr != "null";
}

function de(id) {
	return document.getElementById(id);
}

function euc(i) {
	return encodeURIComponent(i);
}

function getCookie(cookieName) {
	var nameEQ = cookieName + "=";
	var ca = document.cookie.split(';');
	for(var i=0;i < ca.length;i++) {
		var c = ca[i].trim();
		if (c.indexOf(nameEQ) == 0){ 
			return c.substring(nameEQ.length,c.length)
		};
	}
	return null;
}
function clearCommonError(field){
	var container=field+"_container";//no i18N
	$("#"+field).removeClass("errorborder");
	$("#"+container+ " .fielderror").slideUp(100);
	$("#"+container+ " .fielderror").removeClass("errorlabel");
	$("#"+container+ " .fielderror").text("");
}
var I18N = {
		data : {},
		load : function(arr) {
			$.extend(this.data, arr);
			return this;
		},
		get : function(key, args) {
			// { portal: "IAM.ERROR.PORTAL.EXISTS" }
			if (typeof key == "object") {
				for ( var i in key) {
					key[i] = I18N.get(key[i]);
				}
				return key;
			}
			var msg = this.data[key] || key;
			if (args) {
				arguments[0] = msg;
				return Util.format.apply(this, arguments);
			}
			return msg;
		}
	};
function resetForm() {
	$("#login_id_container").slideDown(200);
	$("#captcha_container,.textbox_actions,#mfa_device_container,#backupcode_container,#recoverybtn,#waitbtn,.textbox_actions_more,#openoneauth,.textbox_actions_saml,#problemsignin,.nopassword_container").hide();
	$("#password_container").addClass("zeroheight");
	$("#password_container,#otp_container").slideUp(200);
	$("#forgotpassword,#nextbtn,#password_container .textbox_div").show();
	$(".fed_div_text span").text("");
	$(".facebook_fed").removeClass("fed_div_text");
	$(".signin_fed_text").show();
	$("#nextbtn span").text(I18N.get("IAM.NEXT"));
	$(".backbtn").hide();
	$(".fielderror").removeClass("errorlabel");
	$(".fielderror").text("");
	var userId = $("#login_id").val();
	if(userId.indexOf("-") != -1){
		var phoneId = userId.split("-");
		if(isPhoneNumber(phoneId[1])){
			$("#login_id").val(phoneId[1]);
			$("#select2-country_code_select-container").html("+"+phoneId[0]);
			$( "#country_code_select").val("+"+phoneId[0])
			checking();
		}
	}
	$(".line ,.fed_2show,#signuplink,#showIDPs,.banner_newtoold,.show_fed").show();
	if(de('forgotpassword')) {
		$("#forgotpassword").removeClass("nomargin");
	}
	de("password").value=""; //No I18N
	$("#login_id").focus();
	isFormSubmited = false;
	signinathmode = "lookup";//No i18N
	callmode="primary"; // No i18n
	if(isClientPortal){
		return false;
	}
	de("otp").value=""; //No I18N
	fediconsChecking();
}
function switchto(url){
	clearTimeout(reload_page);
	if(url.indexOf("http") != 0) { //Done for startsWith(Not supported in IE) Check
		var serverName = window.location.origin;
		if (!window.location.origin) {
			serverName = window.location.protocol + "//" + window.location.hostname + (window.location.port ? ':' + window.location.port: '');
		}
		if(url.indexOf("/") != 0) {
			url = "/" + url;
		}
		url = serverName + url;
	}
	window.top.location.href=url;
}
function showAndGenerateOtp(){
	$("#password_container").slideUp(300);
	var loginId = deviceauthdetails && deviceauthdetails.lookup.loginid?deviceauthdetails.lookup.loginid:de("login_id").value;//no i18n
	$('.textbox_actions').show();
	$('#otp_container .username').text(loginId);
	$("#otp_container").slideDown(300);
	$("#captcha_container,#enableforgot").hide();
	$("#otp").val("");
	$("#otp").focus();
	changeButtonAction(I18N.get('IAM.VERIFY'),false);//no i18n
	generateOTP();
	if(isPasswordless){
		$('#signinwithpass').hide();
		$('.signin_head').css('margin-bottom','10px');
		$('.service_name').html(formatMessage(I18N.get("IAM.NEW.SIGNIN.SERVICE.NAME.TITLE"),displayname));
		$('#headtitle').text(I18N.get("IAM.SIGNIN"));
		$("#nextbtn span").text(I18N.get('IAM.SIGNIN'));
		$('.username').text(deviceauthdetails.lookup.loginid);
		resendotp_checking();
		if (!isRecovery) {allowedModeChecking();}
	}
	return false;
}
function showPassword(){
	$("#otp_container").slideUp(300);
	$("#password_container").slideDown(300);
	changeButtonAction(I18N.get('IAM.SIGNIN'),false);//no i18n
	signinathmode="passwordauth";//no i18N
	$(".mobile_message").hide();
	$("#captcha_container").hide();
	$("#password").focus();
	$(".service_name").show();
}
function showTryanotherWay(){
	clearInterval(_time);
	clearCommonError("yubikey"); // no i18n
	$('.optionmod').show();
	if(isMobileonly && prev_showmode === "mzadevice"){
		$('.signin_container').addClass('mobile_signincontainer');
		$("#try"+prefoption).hide();
		$('.blur').show();
		$('.blur').addClass('dark_blur');
		allowedModeChecking_mob();
		return false;
	}
	$('.signin_head').css('margin-bottom','10px');
	$(".addaptivetfalist,.borderlesstry,#trytitle").show(); // no i18n
	$("#nextbtn,.service_name,.fieldcontainer,#headtitle,#problemsignin,#recoverybtn_mob,#problemsignin_mob,.verify_title,.tryanother,#totpverifybtn .loadwithbtn").hide();
	$("#trytitle").html("<span class='icon-backarrow backoption' onclick='hideTryanotherWay()'></span>"+I18N.get('IAM.NEW.SIGNIN.TRY.ANOTHERWAY.HEADER')+"");//no i18n
	var preferoption = deviceauthdetails[deviceauthdetails.resource_name].modes.mzadevice.data[mzadevicepos].prefer_option;
	if(preferoption === "totp") { $('#trytotp').hide();}
	if(preferoption === "scanqr") { $('#tryscanqr').hide();}
	preferoption === "totp" ? tryAnotherway('qr') : tryAnotherway('totp'); //no i18n
	if (!isRecovery) {allowedModeChecking();}
	isTroubleSignin =  true;
	return false;
}
function allowedModeChecking_mob(){
	$('.addaptivetfalist').addClass('heightChange')
	$("#recoverybtn,#recoverybtn_mob,#recoverybtn_mob,#recoverybtn").hide();
	allowedmodes.indexOf("recoverycode")!=-1 ? $('#recoverOption').show() : $('#recoverOption').hide();
	isSecondary = deviceauthdetails[deviceauthdetails.resource_name].modes.otp && deviceauthdetails[deviceauthdetails.resource_name].modes.otp.count > 1 ? true : isSecondary;
	!isSecondary ? $('#recoverybtn_mob').show() : $('#problemsignin_mob').show();
	!isSecondary ? $('#problemsignin_mob').hide(): $('#recoverybtn_mob').hide();
	return false;
}
function showmzadevicemodes(){
	$('.devices .selection').css('display','');
	showTryanotherWay();
	$('#problemsigninui,#recoverybtn').hide();
	if (!isRecovery) {allowedModeChecking();}
}
function showproblemsignin(isBackup){
	$('.devices .selection').hide();
	clearInterval(_time);
	$('.signin_container').removeClass('mobile_signincontainer');
	window.setTimeout(function(){
		$(".blur").hide();
		$('.blur').removeClass('dark_blur');
	},100);
	isMobileonly ? $(".addaptivetfalist").removeClass("heightChange") : $(".addaptivetfalist").hide();
	$('#trytitle').html('');
	secondarymodes.splice(secondarymodes.indexOf(prev_showmode), 1);
	var currentmode = (prev_showmode === "mzadevice" && !isMobileonly) ? "showmzadevicemodes()" : "goBackToCurrentMode()"; //no i18n
	secondarymodes.unshift(prev_showmode);
	var i18n_msg = {"totp":["IAM.NEW.SIGNIN.VERIFY.VIA.AUTHENTICATOR","IAM.NEW.SIGNIN.VERIFY.VIA.AUTHENTICATOR.DESC"],"otp": ["IAM.NEW.SIGNIN.VERIFY.VIA.OTP","IAM.NEW.SIGNIN.OTP.HEADER"],"yubikey":["IAM.NEW.SIGNIN.VERIFY.VIA.YUBIKEY","IAM.NEW.SIGNIN.VERIFY.VIA.YUBIKEY.DESC"], "password":["IAM.NEW.SIGNIN.MFA.PASSWORD.HEADER","IAM.NEW.SIGNIN.MFA.PASSWORD.DESC"],"saml":["IAM.NEW.SIGNIN.SAML.TITLE","IAM.NEW.SIGNIN.SAML.HEADER"],"jwt":["IAM.NEW.SIGNIN.JWT.TITLE","IAM.NEW.SIGNIN.SAML.HEADER"]}; //No I18N
	var problemsigninheader = "<div class='problemsignin_head'><span class='icon-backarrow backoption' onclick=\""+currentmode+"\"></span><span class='rec_head_text'>"+I18N.get("IAM.NEW.SIGNIN.PROBLEM.SIGNIN")+"</span></div>";
	var allowedmodes_con = "";
	var noofmodes = 0;
	var jsonPackage = deviceauthdetails[deviceauthdetails.resource_name];
	secondarymodes.forEach(function(prob_mode,position){
		var listofmob = jsonPackage.modes.otp && jsonPackage.modes.otp.data;
		if(isValid(listofmob) && listofmob.length > 1 && position === 0 && prob_mode === "otp"){
			listofmob.forEach(function(data, index){
				if(index != mobposition){
					rmobile = data.r_mobile;
					var secondary_header = I18N.get(i18n_msg[prob_mode][0]);
					var secondary_desc = formatMessage(I18N.get(i18n_msg[prob_mode][1]),rmobile);
					allowedmodes_con += problemsigninmodes(prob_mode,secondary_header,secondary_desc,index);
					noofmodes++;
				}
			});
		}
		if(position != 0 || isBackup){
			if(prob_mode != "recoverycode" && prob_mode != "passphrase"){
				if(prob_mode === "oadevice"){
					var oadevice_modes = jsonPackage.modes.oadevice.data;
					oadevice_modes.forEach(function(data,index){
						var oadevice_option = data.prefer_option;
						var device_name = data.device_name;
						var oneauthmode = oadevice_option ==="ONEAUTH_PUSH_NOTIF" ? "push" : oadevice_option === "ONEAUTH_TOTP" ? "totp" : oadevice_option === "ONEAUTH_SCAN_QR" ? "scanqr" : oadevice_option === "ONEAUTH_FACE_ID" ? "faceid": oadevice_option === "ONEAUTH_TOUCH_ID" ? "touchid" : "";//no i18N
						var secondary_header = I18N.get("IAM.NEW.SIGNIN.VERIFY.VIA.ONEAUTH");
						var secondary_desc = formatMessage(I18N.get("IAM.NEW.SIGNIN.VERIFY.VIA.ONEAUTH.DESC"),oneauthmode,device_name);
						allowedmodes_con += problemsigninmodes(prob_mode,secondary_header,secondary_desc,index);
						noofmodes++;
					});
				}else if(prob_mode==="mzadevice"){ // no I18N
					var mzadevice_modes = jsonPackage.modes.mzadevice.data;
					mzadevice_modes.forEach(function(data,index){
						var mzadevice_option = data.prefer_option;
						var device_name = data.device_name;
						var secondary_header = I18N.get("IAM.NEW.SIGNIN.VERIFY.VIA.ONEAUTH");
						var secondary_desc = formatMessage(I18N.get("IAM.NEW.SIGNIN.VERIFY.VIA.ONEAUTH.DESC"),mzadevice_option,device_name);
						allowedmodes_con += problemsigninmodes(prob_mode,secondary_header,secondary_desc,index);
						noofmodes++;
					});
				}else if(prob_mode==="otp"){//no i18n
					listofmob.forEach(function(data,index){
						rmobile = data.r_mobile;
						var secondary_header = I18N.get(i18n_msg[prob_mode][0]);
						var secondary_desc = formatMessage(I18N.get(i18n_msg[prob_mode][1]),rmobile);
						allowedmodes_con += problemsigninmodes(prob_mode,secondary_header,secondary_desc,index);
						noofmodes++;
					});
				}else if(prob_mode==="federated"){ // no i18n
					var count = jsonPackage.modes.federated.count;
					var idp = jsonPackage.modes.federated.data[0].idp.toLocaleLowerCase();
					var secondary_header = count > 1 ? I18N.get("IAM.NEW.SIGNIN.MORE.FEDRATED.ACCOUNTS.TITLE") : "<span style='text-transform: capitalize;'>"+idp+"</span>";
					var secondary_desc =  count > 1 ? I18N.get("IAM.NEW.SIGNIN.MORE.FEDRATED.ACCOUNTS.DESC") : formatMessage(I18N.get("IAM.NEW.SIGNIN.IDENTITY.PROVIDER.TITLE"),idp);
					allowedmodes_con += problemsigninmodes(prob_mode,secondary_header,secondary_desc,count);
					noofmodes++;
				}
				else{
					if(i18n_msg[prob_mode]){
						var samlDesc,jwtDesc;
						if(prob_mode==="saml"){
							var domainname = deviceauthdetails[deviceauthdetails.resource_name].modes.saml.domain;
							samlDesc = formatMessage(I18N.get(i18n_msg[prob_mode][1]),domainname);
						}
						else if(prob_mode==="jwt"){
							var domainname = deviceauthdetails[deviceauthdetails.resource_name].modes.jwt.domain;
							jwtDesc = formatMessage(I18N.get(i18n_msg[prob_mode][1]),domainname);
						}
						var secondary_header = I18N.get(i18n_msg[prob_mode][0]);
						var secondary_desc = prob_mode==="saml" ? samlDesc :prob_mode==="jwt" ? jwtDesc : I18N.get(i18n_msg[prob_mode][1]);
						allowedmodes_con += problemsigninmodes(prob_mode,secondary_header,secondary_desc);
						noofmodes++;
					}
				}
			}
			else if(prob_mode === "recoverycode"){
				$('#recoverOption').show();
			}
		} 
	});
	$('#problemsigninui').html(problemsigninheader +"<div class='problemsignincon'>"+ allowedmodes_con+"</div>");
	if($(".tryanother").is(":visible")){
		$('.tryanother').hide();
	}
	if(noofmodes > 3 && !isMobile && !isBackup){
		$('.problemsignincon').addClass('problemsignincontainer');
	}
	$('.optionstry').addClass('optionmod')
	$('#recoverybtn').show();
	var problemmode = allowedmodes[0];//no i18N
	$('#problemsignin,#headtitle,.service_name,.fieldcontainer,#nextbtn').hide();
	$('#problemsigninui').show();
}
function problemsigninmodes(prob_mode,secondary_header,secondary_desc,index){
	return  "<div class='optionstry options_hover' id='secondary_"+prob_mode+"' onclick=showCurrentMode('"+prob_mode+"',"+index+")>\
			<div class='img_option_try img_option icon-"+prob_mode+"'></div>\
			<div class='option_details_try'>\
				<div class='option_title_try'>"+secondary_header+"</div>\
				<div class='option_description'>"+secondary_desc+"</div>\
			</div>\
			</div>"
}
function showallowedmodes(enablemode){
	$('#enablemore').show();
	prev_showmode=enablemode;
	if(enablemode === 'saml'){
		$(".blur,.loader").show();
		var redirectURI = deviceauthdetails.lookup.modes.saml.redirect_uri;
		switchto(redirectURI);
		$(".blur,.loader").hide();
		return false;
		
	}
	else if(enablemode === 'jwt'){
		$(".blur,.loader").show();
		var redirectURI = deviceauthdetails.lookup.modes.jwt.redirect_uri;
		switchto(redirectURI);
		$(".blur,.loader").hide();
		return false;
		
	}
	else if(enablemode === 'otp'){ //no i18n
		$("#resendotp").show();
		showAndGenerateOtp();
		$('.textbox_actions,.blueforgotpassword').hide();
		goBackToCurrentMode(true);
		return false;
	}
	else if(enablemode === 'password'){
		$('#enableotpoption,#resendotp').hide();
		$(".blueforgotpassword").show();
		showPassword();
		goBackToCurrentMode(true);	
	}
	return false;
}
function goBackToCurrentMode(isLookup){
	$('#headtitle,.signin_head,.service_name,.fieldcontainer,#nextbtn').show();
	$('#problemsigninui,#recoverybtn').hide();
	if(prev_showmode === "mzadevice"){$(".tryanother,.devices .selection").show();}
	if(!isLookup && !$(".addaptivetfalist").is(":visible") && !isRecovery){
		allowedModeChecking();
	}
	if($("#waitbtn").is(":visible")||$("#mfa_scanqr_container").is(":visible")){
		$("#nextbtn").hide();
	}
	
}
function hideTryanotherWay(){
   		$("#trytitle,.borderlesstry,#recoverybtn,#problemsignin,#verify_totp_container,#verify_qr_container").hide();
   		isMobileonly ? $(".addaptivetfalist").removeClass("heightChange") : $(".addaptivetfalist").hide();
   		$(".service_name,.fieldcontainer,#headtitle").show();
   		prefoption = deviceauthdetails[deviceauthdetails.resource_name].modes.mzadevice.data[mzadevicepos].prefer_option;
   		if(prefoption==="totp"){$("#nextbtn").show();}
   		$(".tryanother").show();
   		$('.signin_container').removeClass('mobile_signincontainer');
   		window.setTimeout(function(){
   			$(".blur").hide();
   			$('.blur').removeClass('dark_blur');
   		},250);
   		isTroubleSignin = false;
   		$('#verify_qrimg').attr('src','');
   		return false;
}
function showCaptcha(btnstatus,isSubmitted,submit_id){
	$("#captcha_container").show();
	$("#captcha").focus();
	if($(".fed_div").is(":visible")){
		$(".signin_container,.rightside_box").css("height","600px");
	}
	clearCommonError('captcha');//no i18N
	changeButtonAction(btnstatus,isSubmitted);
	$("#"+submit_id).attr("tabindex", 1);
	$("#captcha").attr("tabindex", 2);
	$("#nextbtn").attr("tabindex", 3)
	return false;
}
function changeHip(cImg,cId) {
	cId = isValid(cId) ? cId : "captcha"; //no i18N
	var captchaReqUrl = 'webclient/v1/captcha?';//no i18n
	sendRequestWithCallback(captchaReqUrl, '{"captcha":{"digest":"'+cdigest+'","usecase":"signin"}}', false, handleChangeHip); //No I18N
	showHip(cdigest, cImg);
    de(cId).value = ''; //No I18N
}
function showHip(cdigest, cImg) {
	 var captcha_resp = isValid(cdigest) ? doGet('webclient/v1/captcha/'+cdigest) : "";//no i18n
	 if(IsJsonString(captcha_resp)) {
		 captcha_resp = JSON.parse(captcha_resp);
	 }
	 var captchimgsrc = captcha_resp.cause==="throttles_limit_exceeded" || !isValid(cdigest) ? imgurl+"/hiperror.gif": captcha_resp.captcha.image_bytes;//no i18N
	 cImg = isValid(cImg) ? cImg : "captcha_img"; //No I18N
	 de("captcha").value = '';//no i18n
	 var hipRow = de(cImg); //No I18N
	 var captchaImgEle = document.createElement("img");
	 captchaImgEle.setAttribute("name", "hipImg");
	 captchaImgEle.setAttribute("id", "hip");
	 $('.reloadcaptcha').attr("title", I18N.get("IAM.NEW.SIGNIN.TITLE.RANDOM"));
	 captchaImgEle.setAttribute("align", "left");
	 captchaImgEle.setAttribute("src", captchimgsrc);
	 if(!isMobile){ $(captchaImgEle).css("mix-blend-mode","multiply");}//no i18N
	 $(hipRow).html(captchaImgEle);
}
function handleChangeHip(resp){
	if(IsJsonString(resp)) {
		var jsonStr = JSON.parse(resp);
		var statusCode = jsonStr.status_code;
		if(jsonStr.cause==="throttles_limit_exceeded"){
			cdigest = '';
			showHip(cdigest); //no i18N 
			showCaptcha(I18N.get("IAM.NEXT"),false);;//no i18N
			return false;
		}
		cdigest = jsonStr.digest;
	}
	return false;
}

function handleMfaForIdpUsers(idpdigest){
	if(isValid(idpdigest)){
		$(".blur,.loader").show();
		window.setTimeout(function(){$(".blur,.loader").hide();},1000);
		var loginurl = "signin/v2/lookup/"+idpdigest+"?mode=secondary";//no i18N
		var params = signinParams; //no i18N
		if(isValid(csrfParam)){
			params = params + '&' + csrfParam+'=' + getCookie(csrfCookieName);
		}
		var resp = getPlainResponse(loginurl,params);
		if(IsJsonString(resp)) {
			var jsonStr = JSON.parse(resp);
			var statusCode = jsonStr.status_code;
			if (!isNaN(statusCode) && statusCode >= 200 && statusCode <= 299) {
				$(".fed_2show,.line,#signuplink,#login_id").hide();
				$("#login_id_container,#showIDPs").slideUp(200);
				signinathmode = jsonStr.resource_name;
				restrictTrustMfa = jsonStr[signinathmode].restrict_trust_mfa;
				if(!restrictTrustMfa) {
					trustMfaDays = ''+jsonStr[signinathmode].trust_mfa_days;
				}
				allowedmodes = jsonStr[signinathmode].modes.allowed_modes;
				if(allowedmodes[0]==="mzadevice"){
					prev_showmode = allowedmodes[0];
					secondarymodes = allowedmodes;
					callmode = "secondary";	//no i18n
					zuid = jsonStr.lookup.identifier;
					temptoken = jsonStr.lookup.token;
					deviceauthdetails=jsonStr;
					enableMyZohoDevice(jsonStr);
					handleSecondaryDevices();
					return false;
				}else{
					handlePasswordDetails(resp);
					return false;
				}
			}else{
				if(jsonStr.cause==="throttles_limit_exceeded"){
					showCommonError("login_id",jsonStr.localized_message); //no i18n
					return false;
				}
				showCommonError("login_id",jsonStr.localized_message); //no i18n
				return false;
			}
		}
		return false;
	}
	return false;
}
function tryAnotherway(trymode){
	if(!($('#verify_'+trymode+'_container').is(":visible"))){
		$('#verify_totp').val('');
		clearCommonError('verify_totp'); // no i18n
		prefoption = trymode === 'qr' ? 'scanqr' : trymode; // no i18n
		$('.verify_totp,.verify_qr').slideUp(200);
		$('.verify_'+trymode).slideDown(200);
		$('.optionstry').removeClass("toggle_active");
		$('.verify_'+trymode).parent().addClass("toggle_active");
		$('#verify_totp').focus();
		if(trymode === 'qr' &&  $('#verify_qrimg').attr('src') === ""){
			$('.verify_qr .loader,.verify_qr .blur').show();
			enableQRCodeimg();
		}
	}
	return false;
}
function showResendPushInfo(){
	$(".loadwithbtn").show();
	$(".waitbtn .waittext").text(I18N.get("IAM.NEW.SIGNIN.WAITING.APPROVAL"));
	$("#waitbtn").attr("disabled", true);
	var pushinfo = formatMessage(I18N.get("IAM.RESEND.PUSH.MSG"));
	$(".alert_message").text(pushinfo);
	$(".Alert").css("top","20px");//No i18N
	window.setTimeout(function(){$(".Alert").css("top","-100px")},5000);
	window.setTimeout(function (){
		$(".waitbtn .waittext").text(I18N.get("IAM.PUSH.RESEND.NOTIFICATION"));
		$(".loadwithbtn").hide();
		$("#waitbtn").attr("disabled", false);
		isFormSubmited = false;
		return false;
		
	},25000);
	return false;
}
function showTrustBrowser(){
	prefoption = prefoption ==="ONEAUTH_PUSH_NOTIF" ? "push" : prefoption === "ONEAUTH_TOTP" ? "totp" : prefoption === "ONEAUTH_SCAN_QR" ? "scanqr" : prefoption === "ONEAUTH_FACE_ID" ? "faceid": prefoption === "ONEAUTH_TOUCH_ID" ? "touchid" : prefoption;//no i18N
	prefoption = isValid(prefoption) ? prefoption : allowedmodes[0];//no i18n
	$(".mod_sername").html(formatMessage(I18N.get("IAM.NEW.SIGNIN.TRUST.HEADER."+prefoption.toUpperCase()),trustMfaDays)); // no i18n
	$("#signin_div,.rightside_box,.zoho_logo,.loadwithbtn").hide();
	$(".trustbrowser_ui,.zoho_logo,.mod_sername").show();
	$(".signin_container").addClass("trustdevicebox");
	$(".signin_box").css("minHeight","auto");
	$(".signin_box").css("padding","40px");
	return false;
}
function updateTrustDevice(trust){
	trust ? $('.trustbtn .loadwithbtn').show() : $('.notnowbtn .loadwithbtn').show()
	trust ? $('.trustbtn .waittext').addClass('loadbtntext') : $('.notnowbtn .waittext').addClass('loadbtntext');
	$(".trustdevice").attr("disabled", true);
	var loginurl="/signin/v2/secondary/"+zuid+"/trust?";//no i18N
	var jsonData = {'trustmfa':{'trust':trust }};//no i18n
	sendRequestWithTemptoken(loginurl,JSON.stringify(jsonData),true,handleTrustDetails);
	return false;
}
function handleTrustDetails(resp){
	if(IsJsonString(resp)) {
		var jsonStr = JSON.parse(resp);
		var statusCode = jsonStr.status_code;
		if (!isNaN(statusCode) && statusCode >= 200 && statusCode <= 299) {
			signinathmode = jsonStr.resource_name;
			var successCode = jsonStr.code;
			if(successCode === "SI302"|| successCode==="SI200" ||successCode === "SI300" || successCode === "SI301" || successCode === "SI303"){
				switchto(jsonStr[signinathmode].redirect_uri);
				return false;
			}
			return false;
		}else{
			$(".trustdevice").attr("disabled", false);
			$('.trustbtn .loadwithbtn,.notnowbtn .loadwithbtn').hide();
			$('.trustbtn .waittext,.notnowbtn .waittext').removeClass('loadbtntext');
			$(".error_message").html(jsonStr.localized_message);
			$(".Errormsg").css("top","20px");//No i18N
			window.setTimeout(function(){$(".Errormsg").css("top","-100px")},5000);
			return false;
		}
		return false;
	}
}

function getQueryParams(queryStrings){
	var vars={};
	queryStrings=queryStrings.substring(queryStrings.indexOf('?')+1);
	var params = queryStrings.split('&');
	for (var i = 0; i < params.length; i++) {
        var pair = params[i].split('=');
        if(pair.length==2){
        	vars[pair[0]] = decodeURIComponent(pair[1]);        	
        }else{
        	vars[pair[0]] = ""; 
        }
    }
	return vars;
}

function createandSubmitOpenIDForm(idpProvider) 
{
	if(isValid(idpProvider)) {
		var oldForm = document.getElementById(idpProvider + "form");
		if(oldForm) {
			document.documentElement.removeChild(oldForm);
		}
		var form = document.createElement("form");
		form.setAttribute("id", idpProvider + "form");
		form.setAttribute("method", "POST");
	    form.setAttribute("action", "/accounts/fsrequest");
	    form.setAttribute("target", "_parent");
		
		var hiddenField = document.createElement("input");
		hiddenField.setAttribute("type", "hidden");
		hiddenField.setAttribute("name", "provider");
		hiddenField.setAttribute("value", idpProvider.toUpperCase()); 
		form.appendChild(hiddenField);
        
		hiddenField = document.createElement("input");
		hiddenField.setAttribute("type", "hidden");
		hiddenField.setAttribute("name", csrfParam);
		hiddenField.setAttribute("value", getCookie(csrfCookieName)); 
		form.appendChild(hiddenField);
        
		var params=getQueryParams(location.search);
		for(var key in params) {
			if(isValid(params[key])) {
				hiddenField = document.createElement("input");
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
function goToForgotPassword(){
	if(de('login_id') && isEmailId(de('login_id').value.trim())){
		resetPassUrl = resetPassUrl + "&email="+euc(de('login_id').value.trim()); //No I18N
	}
	window.location.href = resetPassUrl;
}
function register(){
	window.location.href= signup_url;
	return false;
}
function showBackupVerificationCode(){
	$('#login,.fed_2show,#recovery_container,#passphrase_container,#bcaptcha_container').hide();
	$('#backup_container,.backuphead,#backupcode_container').show();
	$("#backupcode").focus();
	$('#backup_title').html("<span class='icon-backarrow backoption' onclick='showCantAccessDevice()'></span>"+I18N.get('IAM.TFA.USE.BACKUP.CODE'));
	$('.backup_desc').html(I18N.get("IAM.NEW.SIGNIN.BACKUP.HEADER"));
	signinathmode = "recoverycodesecauth"; // no i18n
	allowedmodes.indexOf("passphrase") != -1 ? $('#recovery_passphrase').show() : $('#recovery_passphrase').hide();
	return false;
}
function goBackToProblemSignin(){
	$('.devices .selection').css('display','');
	$('.fed_2show,#recovery_container,#backup_container').hide();
	if(isSecondary){
		isMobileonly ? $(".addaptivetfalist").removeClass("heightChange") : $(".addaptivetfalist").hide();
	}
	$('#login').show();
	return false;
}
function showCantAccessDevice(){
	$('.devices .selection').hide();
	$('.signin_container').removeClass('mobile_signincontainer');
	allowedmodes.indexOf('passphrase') === -1 ? $('#passphraseRecover').hide() : $('#passphraseRecover').show();
	window.setTimeout(function(){
		$(".blur").hide();
		$('.blur').removeClass('dark_blur');
	},100);
	$('#login,.fed_2show,#backup_container,.backuphead').hide();
	$('#recovery_container,#recoverytitle,.recoveryhead').show();
	return false;
}
function verifyBackupCode(){
	var isBcaptchaNeeded = $("#bcaptcha_container").is(":visible");
	if(isBcaptchaNeeded){
		var bcaptchavalue = de('bcaptcha').value.trim();//no i18N
		if(!isValid(bcaptchavalue)) {
			showCommonError("bcaptcha",I18N.get("IAM.SIGNIN.ERROR.CAPTCHA.REQUIRED"));//no i18n
			return false;
		}
		if( /[^a-zA-Z0-9\-\/]/.test( bcaptchavalue ) ) {
			changeHip('bcaptcha_img','bcaptcha');// no i18n
			showCommonError("bcaptcha",I18N.get("IAM.SIGNIN.ERROR.CAPTCHA.INVALID"));//no i18n
			return false;
		}
    }
	if(signinathmode=== "passphrasesecauth"){
		var passphrase = $("#passphrase").val().trim();
		if(!isValid(passphrase)) {
			showCommonError("passphrase",I18N.get("IAM.NEW.SIGNIN.ENTER.VALID.PASSPHRASE.CODE"));//no i18n
			return false;
		}
		var loginurl="/signin/v2/secondary/"+zuid+"/passphrase?"+signinParams; // no i18n
		if(isBcaptchaNeeded){loginurl += "&captcha=" +bcaptchavalue+"&cdigest="+cdigest;}
		var jsonData =  {'passphrasesecauth':{'pass_phrase':passphrase }} // no i18n
		sendRequestWithTemptoken(loginurl,JSON.stringify(jsonData),true,handlePassphraseDetails);
		return false;
	}
	var backupcode = $("#backupcode").val().trim();
	backupcode = backupcode.replace(/\s/g, "");
	var objRegExp = /^([a-zA-Z0-9]{12})$/;
	if(!objRegExp.test(backupcode)){
		showCommonError("backupcode",I18N.get("IAM.NEW.SIGNIN.ENTER.VALID.BACKUP.CODE"));//no i18n
		return false;
	}
	var loginurl="/signin/v2/secondary/"+zuid+"/recovery?"+signinParams;//no i18n
	if(isBcaptchaNeeded){loginurl += "&captcha=" +bcaptchavalue+"&cdigest="+cdigest;}
	var jsonData = {'recoverycodesecauth':{'code':backupcode }};//no i18n
	sendRequestWithTemptoken(loginurl,JSON.stringify(jsonData),true,handleBackupVerificationDetails);	
	return false;
}
function handleBackupVerificationDetails(resp){
		if(IsJsonString(resp)) {
			var jsonStr = JSON.parse(resp);
			var statusCode = jsonStr.status_code;
			signinathmode = jsonStr.resource_name;
			if (!isNaN(statusCode) && statusCode >= 200 && statusCode <= 299) {
				var successCode = jsonStr.code;
				var statusmsg = jsonStr.recoverycodesecauth.status;
				if(statusmsg==="success"){
					if(restrictTrustMfa){
						updateTrustDevice(false);
						return false;
					}
					showTrustBrowser();
					return false;
				}else if(successCode==="P500"||successCode==="P501"){//no i18N
					temptoken = jsonStr[signinathmode].token;
					showPasswordExpiry(jsonStr[signinathmode].pwdpolicy);
					return false;
				}
				else{
					showCommonError("backupcode",jsonStr.localized_message);//no i18n
					return false;
				}
			}else{
				if(jsonStr.cause==="throttles_limit_exceeded"){
					showCommonError("backupcode",jsonStr.localized_message); //no i18n
					return false;
				}
				var error_resp = jsonStr.errors[0];
				var errorCode=error_resp.code;
				var errorMessage = jsonStr.localized_message;
				if(errorCode==="IN107" || errorCode === "IN108"){
					$(".fed_2show,.line").hide();
					cdigest=jsonStr.cdigest;
					showHip(cdigest, 'bcaptcha_img'); //no i18N
					$("#bcaptcha_container").show();
					$("#bcaptcha").focus();
					clearCommonError('bcaptcha');//no i18N
					$(".signin_container,.rightside_box").css("height","600px");
					changeButtonAction(I18N.get("IAM.VERIFY"),false);
					if( errorCode === "IN107"){
						showCommonError("bcaptcha",errorMessage); //no i18n	
					}
					return false;
				}else{
					showCommonError("backupcode",errorMessage);//no i18n
					return false;					
				}
			}
		return false;
		}
}
function removeParamFromQueryString(param){
	if(isValid(queryString)) {
		var prefix = encodeURIComponent(param);
		var pars = queryString.split(/[&;]/g);
		for (var i = pars.length; i-- > 0;) {
    		var paramObj = pars[i].split(/[=;]/g);
    		if(prefix === paramObj[0]) {
				pars.splice(i, 1);
			}
		}	
		if (pars.length > 0) {
			return pars.join('&');
		}
	}
	return "";
}
function allowedModeChecking(){
	if(secondarymodes.length == 1 || (secondarymodes[1] == "recoverycode" && secondarymodes.length == 2)){
		if(secondarymodes[1] == "recoverycode"){
			$('#recoverOption').show();	
		}
		$('#recoverybtn').show();
		$('#problemsignin').hide();
	}
	else{
		$('#problemsignin').show();
		$('#recoverybtn').hide();
	}
	if(isSecondary){
		$('#problemsignin').show();
		$('#recoverybtn').hide();
	}
	return false;

}
function showCurrentMode(pmode,index){
	goBackToProblemSignin();
	$('.devices .selection').hide();
	$("#mfa_totp_container,#mfa_otp_container,#waitbtn,#nextbtn,#mfa_scanqr_container,#mfa_push_container,#openoneauth,#yubikey_container").hide();
	clearInterval(_time);
	$(".tryanother").hide();
	prev_showmode = pmode === "federated" ? prev_showmode : pmode; // no i18n
	clearCommonError(pmode)
	var authenticatemode = deviceauthdetails.passwordauth === undefined ? "lookup" : "passwordauth"; // No I18n
	if(pmode==="otp"){
		var jsonPack = deviceauthdetails[deviceauthdetails.resource_name];
		emobile=jsonPack.modes.otp.data[index].e_mobile;
		rmobile=jsonPack.modes.otp.data[index].r_mobile;
		if(isPasswordless){showAndGenerateOtp();}
		else{generateOTP();}
		$("#mfa_otp").val("");
		mobposition = index;
		isPrimaryDevice = true;
	}else if(pmode==="totp"){//No i18N
		enableTOTPdevice(deviceauthdetails,false,false);
		signinathmode="totpsecauth";//no i18N
	}else if(pmode==="oadevice"){//No i18N
		isResend = false;
		signinathmode =authenticatemode;
		oadevicepos = index;
		enableOneauthDevice(deviceauthdetails,oadevicepos);
	}else if(pmode==="yubikey"){//No i18N
		signinathmode =authenticatemode;
		enableYubikeyDevice(deviceauthdetails);
	}else if(pmode === "mzadevice"){//No i18N
		isResend = false;
		mzadevicepos = index;
		prefoption = deviceauthdetails[deviceauthdetails.resource_name].modes.mzadevice.data[mzadevicepos].prefer_option;
		enableMyZohoDevice(deviceauthdetails, prefoption);
		if(prefoption === 'totp'){
			goBackToCurrentMode(true);
			if (isRecovery) { $('#problemsignin,#recoverybtn,.tryanother').hide();}
			return false;
		}
	}else if(pmode === "password"){//No i18N
		showPasswordContainer();
	}else if(pmode === "federated"){//No i18N
		var idp = deviceauthdetails.lookup.modes.federated.data[0].idp.toLowerCase();
		index === 1 ? createandSubmitOpenIDForm(idp) : showMoreFedOptions();
		return false;
	}else if(pmode === "saml"){ // no i18n
		var redirectURI = deviceauthdetails[deviceauthdetails.resource_name].modes.saml.redirect_uri;
		switchto(redirectURI);
	}
	else if(pmode === "jwt"){ // no i18n
		var redirectURI = deviceauthdetails[deviceauthdetails.resource_name].modes.jwt.redirect_uri;
		switchto(redirectURI);
	}
	if(pmode != 'mzadevice' && pmode != 'oadevice'){
		$('.deviceparent').addClass('hide');
	}
	goBackToCurrentMode();
	if(isRecovery) {$('#problemsignin,#recoverybtn,.tryanother').hide();}
	return false;
}
function showPasswordContainer(){
	$("#nextbtn").attr("disabled", false);
	$("#password").val("");
	$('#password_container,#enableforgot').show();
	$('#enablesaml,#enableotpoption,.textbox_actions,#otp_container').hide();
	$('#password_container').removeClass('zeroheight');
	$('#nextbtn').removeClass('changeloadbtn');
	$('#headtitle').text(I18N.get("IAM.SIGNIN"));
	$('.service_name').removeClass('extramargin');
	$('.service_name').html(formatMessage(I18N.get("IAM.NEW.SIGNIN.SERVICE.NAME.TITLE"),displayname));
	$("#nextbtn span").removeClass("zeroheight");
	$("#nextbtn span").text(I18N.get('IAM.SIGNIN'));
	$('.username').text(deviceauthdetails.lookup.loginid);
	if(isPasswordless && !isRecovery)  { allowedModeChecking() };
	$('.signin_head').css('margin-bottom','30px');
	$('#password').focus();
	signinathmode = "passwordauth";// No i18n
	isFormSubmited = false;
}
function showMoreFedOptions(){
	var idps = deviceauthdetails[deviceauthdetails.resource_name].modes.federated.data;
	var problemsigninheader = "<div class='problemsignin_head'><span class='icon-backarrow backoption' onclick='showproblemsignin()'></span><span class='rec_head_text'>"+I18N.get("IAM.NEW.SIGNIN.FEDERATED.LOGIN.TITLE")+"</span></div>";
	var idp_con = "";
	idps.forEach(function(idps){
		if(isValid(idps)){
			idp = idps.idp.toLowerCase();
			idp_con += "<div class='optionstry options_hover' id='secondary_"+idp+"' onclick=createandSubmitOpenIDForm('"+idp+"')>\
							<div class='img_option_try img_option icon-federated'></div>\
							<div class='option_details_try'>\
								<div class='option_title_try'><span style='text-transform: capitalize;'>"+idp+"<span></div>\
								<div class='option_description'>"+formatMessage(I18N.get("IAM.NEW.SIGNIN.IDENTITY.PROVIDER.TITLE"),idp)+"</div>\
							</div>\
							</div>"
        }
	});	
	$('#problemsigninui').html(problemsigninheader +"<div class='problemsignincon'>"+ idp_con+"</div>");
	return false;
}
function enableQRCodeimg(){
	var prefoption = "scanqr"; // no i18n
	var deviceid = deviceauthdetails[deviceauthdetails.resource_name].modes.mzadevice.data[mzadevicepos].device_id;
	var loginurl="/signin/v2/"+callmode+"/"+zuid+"/device/"+deviceid+"?";//no i18N
	loginurl += "digest="+digest+ "&" + signinParams; //no i18N
	var jsonData = callmode==="primary" ? {'deviceauth':{'devicepref':prefoption }}: {'devicesecauth':{'devicepref':prefoption }};//no i18N
	sendRequestWithTemptoken(loginurl,JSON.stringify(jsonData),true,handleQRCodeImg);
	signinathmode = callmode==="primary" ?"deviceauth":"devicesecauth";//no i18N
}
function handleQRCodeImg(resp){
	if(IsJsonString(resp)) {
		var jsonStr = JSON.parse(resp);
		signinathmode = jsonStr.resource_name;
		var statusCode = jsonStr.status_code;
		if (!isNaN(statusCode) && statusCode >= 200 && statusCode <= 299) {
			var successCode = jsonStr.code;
			if(successCode === "SI202"||successCode==="MFA302" || successCode==="SI302" || successCode==="SI201"){
				temptoken = jsonStr[signinathmode].token;
				var qrcodeurl = jsonStr[signinathmode].img;
				qrtempId =  jsonStr[signinathmode].temptokenid;
				isValid(qrtempId) ? $("#verify_qr_container #openoneauth").show() : $("#verify_qr_container #openoneauth").hide();
				var wmsid = jsonStr[signinathmode].WmsId && jsonStr[signinathmode].WmsId.toString();
				isVerifiedFromDevice(prefoption,true,wmsid);
				$("#verify_qrimg").attr("src",qrcodeurl);//no i18n
				$('.verify_qr .loader,.verify_qr .blur').hide();
			}
		}else{
			if(jsonStr.cause==="throttles_limit_exceeded"){
				$(".error_message").html(jsonStr.localized_message);
				$(".Errormsg").css("top","20px");//No i18N
				window.setTimeout(function(){$(".Errormsg").css("top","-100px")},5000);
				return false;
			}
			var error_resp = jsonStr.errors && jsonStr.errors[0];
			var errorCode = error_resp && error_resp.code;
			$(".error_message").html(jsonStr.localized_message);
			$(".Errormsg").css("top","20px");//No i18N
			window.setTimeout(function(){$(".Errormsg").css("top","-100px")},5000);
			return false;
	   }
		
	}else{
		$(".error_message").html(I18N.get("IAM.ERROR.USER.ACTION"));
		$(".Errormsg").css("top","20px");//No i18N
		window.setTimeout(function(){$(".Errormsg").css("top","-100px")},5000);
		return false;
	}
	return false;
}
function showPassphraseContainer(){
	$('#login,.fed_2show,#backupcode_container,#recovery_container,#bcaptcha_container').hide();
	$('#passphrase_container,#backup_container,.backuphead').show();
	signinathmode =  "passphrasesecauth"; //no i18n
	$('#backup_title').html("<span class='icon-backarrow backoption' onclick='showCantAccessDevice()'></span>"+I18N.get('IAM.NEW.SIGNIN.PASS.PHRASE.TITLE'));
	$('.backup_desc').html(I18N.get("IAM.NEW.SIGNIN.PASS.PHRASE.DESC"));
	allowedmodes.indexOf("recoverycode") != -1 ? $('#recovery_backup').show() : $('#recovery_backup').hide();
}
function hideSigninOptions(){
	$('#enablemore').show();
	$('#nextbtn,.signin_head').show();
	$("#"+prev_showmode+"_container").show();
	$('#problemsigninui').hide();
	return false;
} 
function QrOpenApp() {
	//Have to handle special case!!!
	var qrCodeString = "code="+qrtempId+"&zuid="+zuid+"&url="+iamurl; //No I18N
	document.location= UrlScheme+"://?"+qrCodeString;
	return false;
}
function setCookie(x){
	var dt=new Date();
	dt.setDate(dt.getYear() * x);
	var cookieStr = "IAM_TEST_COOKIE=IAM_TEST_COOKIE;expires="+dt.toGMTString()+";path=/;"; //No I18N
	if(cookieDomain != "null"){
		cookieStr += "domain="+cookieDomain; //No I18N
	}
	document.cookie = cookieStr;
}
function submitbackup(event){
	if(event.keyCode === 13){
		verifyBackupCode();
	}
}
function setPassword(event){
	if(event.keyCode === 13){
		updatePassword();
	}
}
function updatePassword(min_Len,max_Len,login_name) {
	remove_error();
    var newpass = $('#new_password').val().trim();
    var confirmpass = $('#new_repeat_password').val().trim()
    if(isEmpty(newpass)) {
    	$('#npassword_container').append( '<div class="field_error">'+I18N.get('IAM.ERROR.ENTER.NEW.PASS')+'</div>' );
    	$('#new_password').val("");
    	$('#new_repeat_password').val("");
    	$('#new_password').focus();
        $(".pass_policy").hide();
    	$(".pass_policy_error").hide();
    	return false;
    } else if(newpass.length < min_Len){
    	$('#npassword_container').append( '<div class="field_error">'+formatMessage(I18N.get('IAM.ERROR.PASS.LEN'), min_Len)+'</div>' );
    	$('#new_password').val("");
    	$('#new_repeat_password').val("");
    	$('#new_password').focus();
    	$(".pass_policy").hide();
    	$(".pass_policy_error").hide();
    	return false;
    } else if(newpass.length > max_Len){
    	$('#npassword_container').append( '<div class="field_error">'+formatMessage(I18N.get('IAM.ERROR.PASSWORD.MAXLEN'), max_Len)+'</div>' );
    	$('#new_password').val("");
    	$('#new_repeat_password').val("");
    	$('#new_password').focus();
    	$(".pass_policy").hide();
    	$(".pass_policy_error").hide();
    	return false;
    } else if(newpass == login_name) {
    	$('#npassword_container').append( '<div class="field_error">'+I18N.get('IAM.PASSWORD.POLICY.LOGINNAME')+'</div>' );
    	$('#new_password').focus();
    	$(".pass_policy").hide();
    	$(".pass_policy_error").hide();
    	return false;
    } else if(isEmpty(confirmpass) || newpass != confirmpass){
    	$('#rpassword_container').append( '<div class="field_error">'+I18N.get('IAM.ERROR.WRONG.CONFIRMPASS')+'</div>' );
    	$('#new_repeat_password').val("");
    	$('#new_repeat_password').focus();
    	return false;
    }
    var loginurl = "/signin/v2/password/"+zuid+"/expiry?";//no i18N
    var jsonData = {'expiry':{'newpwd':newpass,'clear_app_sessions':de('termin_mob').checked,'clear_web_sessions':de('termin_web').checked, 'clear_api_tokens':de('termin_api').checked }};//no i18N
    sendRequestWithTemptoken(loginurl,JSON.stringify(jsonData),true,handlePasswordExpiry);
    return false;
}
function handlePasswordExpiry(resp){
	if(IsJsonString(resp)) {
		var jsonStr = JSON.parse(resp);
		var statusCode = jsonStr.status_code;
		if (!isNaN(statusCode) && statusCode >= 200 && statusCode <= 299) {
			if(jsonStr.expiry.status === "success"){
				$(".passexpsuccess").show();
				$("#npassword_container,#rpassword_container,.checkbox_div").hide();
				$("#password_desc").html(I18N.get("IAM.NEW.SIGNIN.PASS.EXPIRY.SUCCESS.DESC"));
				$(".password_expiry_container #headtitle").text(I18N.get("IAM.NEW.SIGNIN.PASS.EXPIRY.SUCCESS.TITLE"));
				$("#password_desc,.signin_head").css("text-align","center");//no i18N
				$("#changepassword").text(I18N.get("IAM.NEW.SIGNIN.PASS.EXPIRY.SUCCESS.BUTTON"));
				$(".zoho_logo").addClass("passlogo");
				$("#changepassword").attr("onclick","window.location.reload()");
			}
		}else{
			if(jsonStr.cause==="throttles_limit_exceeded"){
				showCommonError("npassword",jsonStr.localized_message); //no i18n
				return false;
			}
			showCommonError("npassword",jsonStr.localized_message); //no i18n
			return false;
		}
	return false;
	}
}
function ClickStep(step,isUserClick){
    if(isUserClick) {
    	clearInterval(imageloader);
    	$('.active_border').css('transition','none');
    }
    if(step === 1) { ClickFirstStep(isUserClick);return false;}
    if(step === 2) { ClickSecStep(isUserClick);return false;}
    if(step === 3) { ClickThirdStep(isUserClick);return false;}
}

var imageloader;
function ClickFirstStep(isUserClick){
    if(isUserClick){
        $(".animate_line").removeClass('active_border');
        $("#Step3 .step_values,#Step2 .step_values").removeClass("active_step");
        $("#Step1  .step_values").addClass("active_step");
        $(".MFA_illustration").removeClass("prompt");
        $(".MFA_illustration").addClass("PushCame");
        $(".MFA_illustration").removeClass("approved");
        $(".overlap_div").css("margin-left","0px");
        $("#Step1 .animate_line,#Step2 .animate_line").removeClass('active_border');
        $("#Step1 .step_values,#Step2 .step_values").removeClass('active_circle');
        return false;
    }
    $("#Step1 .animate_line").addClass('active_border');
    setTimeout( function() {
        $("#Step1  .step_values").removeClass("active_step");
        $("#Step2 .step_values").addClass("active_step");
        $("#Step1 .step_values").addClass('active_circle');
        $(".MFA_illustration").addClass("prompt");
        $(".MFA_illustration").removeClass("PushCame");
        $(".MFA_illustration").removeClass("approved");
        $(".overlap_div").css("margin-left","-260px");
    },1400);
}
function ClickSecStep(isUserClick){
    if(isUserClick){ 
        $("#Step3 .step_values,#Step1 .step_values").removeClass("active_step");
        $("#Step2 .animate_line").removeClass('active_border');
        $("#Step1 .animate_line").addClass('active_border');
        $("#Step2  .step_values").addClass("active_step");
        $("#Step1 .step_values").addClass('active_circle');
        $(".MFA_illustration").removeClass("approved");
        $(".MFA_illustration").removeClass("PushCame");
        $(".MFA_illustration").addClass("prompt");
        $(".overlap_div").css("margin-left","-260px");
        return false;
    }
    $("#Step2 .animate_line").addClass('active_border');
    $("#Step3 .step_values,#Step1 .step_values").removeClass("active_step");
    $("#Step2  .step_values").addClass("active_step");
    setTimeout( function() {
        $("#Step2 .animate_line,#Step1 .animate_line").addClass('active_border');
        $(".MFA_illustration").removeClass("prompt");
        $(".MFA_illustration").removeClass("PushCame");
        $(".MFA_illustration").addClass("approved");
        $(".overlap_div").css("margin-left","-520px");
        $("#Step1 .step_values,#Step2 .step_values").addClass('active_circle');
        $("#Step2 .step_values,#Step1 .step_values").removeClass("active_step");
        $("#Step3 .step_values").addClass("active_step");
    },1400);
}
function ClickThirdStep(isUserClick){   
    if(isUserClick){
        $("#Step1 .step_values,#Step2 .step_values").addClass('active_circle');
        $(".overlap_div").css("margin-left","-520px");
        $(".MFA_illustration").removeClass("prompt");
        $(".MFA_illustration").removeClass("PushCame");
        $(".MFA_illustration").addClass("approved");
        $("#Step2 .animate_line,#Step1 .animate_line").addClass('active_border');
        $("#Step3 .step_values").addClass("active_step");     
        $("#Step2 .step_values,#Step1 .step_values").removeClass("active_step");
        return false;
    }
    setTimeout( function() {
        $(".animate_line").removeClass('active_border'); 
        $("#Step1 .animate_line").removeClass('active_border');
        $("#Step2 .step_values").removeClass("active_step");
        $("#Step3 .step_values").removeClass("active_step");
        $("#Step1  .step_values").addClass("active_step");
        $(".MFA_illustration").removeClass("prompt");
        $(".MFA_illustration").addClass("PushCame");
        $(".MFA_illustration").removeClass("approved");
        $(".overlap_div").css("margin-left","0px");
        $("#Step1 .animate_line,#Step2 .animate_line").removeClass('active_border');
        $("#Step1 .step_values,#Step2 .step_values").removeClass('active_circle');
    },1000);
}
function showPasswordExpiry(pwdpolicy){
	$("#signin_div,.rightside_box").hide();
	$(".password_expiry_container").show();
	$(".signin_container").addClass("mod_container");
	if(pwdpolicy!=undefined)
	{
		var policy = I18N.get("IAM.PASSWORD.POLICY.HEADING") +" ";
		if(pwdpolicy.expiry_days!=undefined	&& 	pwdpolicy.expiry_days!=-1){
			$("#password_desc").html(formatMessage(I18N.get("IAM.NEW.SIGNIN.PASSWORD.EXPIRED.ORG.DESC"),pwdpolicy.expiry_days.toString()));
		}else{
			$("#password_desc").html(I18N.get("IAM.NEW.SIGNIN.PASSWORD.EXPIRED.ORG.DESC.NOW"));
		}
		if(pwdpolicy.min_length!=0)
		{
			policy += formatMessage(I18N.get("IAM.RESETPASS.PASSWORD.MIN"),(pwdpolicy.min_length.toString()));
		}
		if(pwdpolicy.min_spl_chars!=0)
		{
			policy+=" "+formatMessage(I18N.get("IAM.RESET.PASSWORD.POLICY.MINSPECIALCHAR.ONLY"),(pwdpolicy.min_spl_chars.toString()));
		}
		if(pwdpolicy.min_numeric_chars!=0)
		{
			policy+=", "+formatMessage(I18N.get("IAM.RESET.PASSWORD.POLICY.MINNUMERICCHAR.ONLY"),(pwdpolicy.min_numeric_chars.toString()));
		}
		if(pwdpolicy.mixed_case)
		{
			policy+=", "+I18N.get("IAM.RESET.PASSWORD.POLICY.CASE.BOTH");
		}
		$("#pass_policy").html(policy);
		$("#npassword_container").attr("onkeyup","check_pp("+pwdpolicy.mixed_case+","+pwdpolicy.min_spl_chars+","+pwdpolicy.min_numeric_chars+","+pwdpolicy.min_length+")");
		var loginName = de("login_id").value;//no i18N
		$("#changepassword").attr("onclick",'updatePassword('+pwdpolicy.min_length+','+pwdpolicy.max_length+',"'+loginName+'")');
	}
	return false;
}
function checkCookie() {
	if(isValid(getCookie(iam_reload_cookie_name))) {
        window.location.reload();
    }
}
function check_pp(cases, spl, num, minlen) {
	remove_error();
	if ($("#npassword_container input").val() == "") {
		$(".pass_policy").show();
		$(".pass_policy_error").hide();
	} else {
		var err_str = I18N.get("IAM.PASSWORD.POLICY.HEADING") +" ";
		var done = false;
		var pp_done = true;
		$(".pass_policy").hide();
		var str = $("#npassword_container input").val();
		if (str.length < minlen) {
			if (cases || (spl != 0) || (num != 0)) {
				err_str += formatMessage(I18N.get("IAM.RESETPASS.PASSWORD.MIN"), minlen.toString());
			} else {
				err_str += formatMessage(I18N.get("IAM.RESETPASS.PASSWORD.MIN.NO.WITH"), minlen.toString());
				pp_done = true;
			}
			done = false;
		} else {
			done = true;
		}
		if (spl != 0) {
			if (((str.match(new RegExp("[^a-zA-Z0-9]", "g")) || []).length) < spl) {
				err_str += " ";
				err_str += formatMessage(I18N.get("IAM.RESET.PASSWORD.POLICY.MINSPECIALCHAR.ONLY"), spl.toString());
				pp_done = false;
			} else if (pp_done) {
				pp_done = true;
			}
		}
		if (num != 0) {
			if (((str.match(new RegExp("[0-9]", "g")) || []).length) < num) {
				if ((str.length < minlen) || (((str.match(new RegExp("[^a-zA-Z0-9]", "g")) || []).length) < spl)) {
					err_str += ", ";
				} else {
					err_str += " ";
				}
				err_str += formatMessage(I18N.get("IAM.RESET.PASSWORD.POLICY.MINNUMERICCHAR.ONLY"), num.toString());
				pp_done = false;
			} else if (pp_done) {
				pp_done = true;
			}
		}
		if (cases) {
			if (!((new RegExp("[A-Z]", "g").test(str)) && (new RegExp("[a-z]","g").test(str)))) {
				if ((str.length < minlen)|| (((str.match(new RegExp("[^a-zA-Z0-9]", "g")) || []).length) < spl)|| (((str.match(new RegExp("[0-9]", "g")) || []).length) < num)) {
					err_str += ", " + I18N.get("IAM.RESET.PASSWORD.POLICY.CASE.BOTH"), minlen;
				} else {
					err_str = I18N.get("IAM.INCLUDE") + " " + I18N.get("IAM.RESET.PASSWORD.POLICY.CASE.BOTH"), minlen;
				}
				pp_done = false;
			} else if (pp_done) {
				pp_done = true;
			}
		}
		$(".pass_policy_error").show();
		$(".pass_policy_error").html(err_str);
		if ((done) && (pp_done)) {
			$(".pass_policy_error").hide();
		} else if ((!done) && (pp_done)) {
			err_str = I18N.get("IAM.PASSWORD.POLICY.HEADING") + " "+ formatMessage(I18N.get("IAM.RESETPASS.PASSWORD.MIN.NO.WITH"), minlen.toString());
			$(".pass_policy_error").html(err_str);
		}
	}
}
function remove_error()
{
	$(".field_error").remove();
	clearCommonError("npassword");//no i18N
}
function handleCrossDcLookup(loginID){ 
	$(".blur,.loader").show();
	var loginurl = "/signin/v2/lookup/"+loginID; //no i18N
	var params = "mode=primary"+ "&" + signinParams; //no i18N
	sendRequestWithCallback(loginurl, params ,true, handleLookupDetails);//No I18N
	return false;
}
function handleConnectionError(){
	$("#nextbtn span").removeClass("zeroheight");
	$("#nextbtn").removeClass("changeloadbtn");
	$("#nextbtn").attr("disabled", false);
	isFormSubmited = false;
	$(".error_message").html(I18N.get('IAM.PLEASE.CONNECT.INTERNET'));
	$(".Errormsg").css("top","20px");//No i18N
	window.setTimeout(function(){$(".Errormsg").css("top","-100px")},5000);
	return false;
}
function isEmailId(str) {
    if(!str) {
        return false;
    }
    var objRegExp = new XRegExp("^[\\p{L}\\p{N}\\p{M}\\_]([\\p{L}\\p{N}\\p{M}\\_\\+\\-\\.\\'\\&]*)@(?=.{4,256}$)(([\\p{L}\\p{N}\\p{M}]+)(([\\-\\_]*[\\p{L}\\p{N}\\p{M}])*)[\\.])+[\\p{L}\\p{M}]{2,22}$","i"); // No I18N
    return XRegExp.test(str.trim(), objRegExp);
}
function isPhoneNumber(str) {
    if(!str) {
        return false;
    }
    str = str.trim();
    var objRegExp = /^([0-9]{7,14})$/;
    return objRegExp.test(str);
}
function formatMessage() {
    var msg = arguments[0];
    if(msg != undefined) {
	for(var i = 1; i < arguments.length; i++) {
	    msg = msg.replace('{' + (i-1) + '}', escapeHTML(arguments[i]));
	}
    }
    return msg;
}
function escapeHTML(value) {
	if(value) {
		value = value.replace("<", "&lt;");
		value = value.replace(">", "&gt;");
		value = value.replace("\"", "&quot;");
		value = value.replace("'", "&#x27;");
		value = value.replace("/", "&#x2F;");
    }
    return value;
}
function isEmpty(str) {
    return str ? false : true;
}
function getPlainResponse(action, params) {
	if (typeof contextpath !== 'undefined') {
		action = contextpath + action;
	}
    if(params.indexOf("&") === 0) {
	params = params.substring(1);
    }
    var objHTTP,result;
    objHTTP = xhr();
    objHTTP.open('POST', action, false);
    objHTTP.setRequestHeader('Content-Type','application/x-www-form-urlencoded;charset=UTF-8');
    objHTTP.setRequestHeader('Content-length', params.length);
    objHTTP.send(params);
    return objHTTP.responseText;
}
function xhr() {
    var xmlhttp;
    if (window.XMLHttpRequest) {
	xmlhttp=new XMLHttpRequest();
    }
    else if(window.ActiveXObject) {
	try {
	    xmlhttp=new ActiveXObject("Msxml2.XMLHTTP");
	}
	catch(e) {
	    xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
	}
    }
    return xmlhttp;
}
function sendRequestWithCallback(action, params, async, callback,method) {
	if (typeof contextpath !== 'undefined') {
		action = contextpath + action;
	}
    var objHTTP = xhr();
    objHTTP.open(method?method:'POST', action, async);
    objHTTP.setRequestHeader('Content-Type','application/x-www-form-urlencoded;charset=UTF-8');
    objHTTP.setRequestHeader('X-ZCSRF-TOKEN',csrfParam+'='+euc(getCookie(csrfCookieName)));
    if(async){
	objHTTP.onreadystatechange=function() {
	    if(objHTTP.readyState==4) {
	    	if (objHTTP.status === 0 ) {
				handleConnectionError();
				return false;
			}
			if(callback) {
			    callback(objHTTP.responseText);
			}
	    }
	};
    }
    objHTTP.send(params);
    if(!async) {
	if(callback) {
            callback(objHTTP.responseText);
        }
    }
} 
function isUserName(str) {
	if(!str) {
        return false;
    }
	var objRegExp = new XRegExp("^[\\p{L}\\p{N}\\p{M}\\_\\.]+$","i"); // No I18N
    return XRegExp.test(str.trim(), objRegExp);
}
function doGet(action, params) {
	if (typeof contextpath !== 'undefined') {
		action = contextpath + action;
	}
    var objHTTP;
    objHTTP = xhr();
    if(isEmpty(params)) {
        params = "__d=e"; //No I18N
    }
	objHTTP.open('GET', action + "?" + params, false);	//No I18N
    objHTTP.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded;charset=UTF-8');	//No I18N
    objHTTP.send(params);
    return objHTTP.responseText;
}
function checkTls(){
	 try{
	 $.ajax({
	      type: "GET",// No I18N
	      url: "https://tlstest.zoho.com/api",//NO I18N
	      async: "true",
	      success: function(data){
	    	if(data && data.message !== "Connection Success"){
	    		$(".tls_announce_banner").show();
	    	}
	      }
	   });}
	 catch(e){}
}
function hideTlsbanner(){
	$(".tls_announce_banner").hide();
}