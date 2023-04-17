//$Id$
function addMobile(){
	// IMPORTANT : Same JS method used in TFA Recovery update(in announcement) also. So, check there also before any changes done. 
	// DOM alone replicated outside in this case.
	
	var mobVal = de('mobileno').value;  //No I18N
	if(mobVal == ""){
		showTFAErrorMsg("mobileno",err_enter_valid_mobile);//No i18N
		return;
	}
	if(validateMobile(mobVal) != true) {
		showTFAErrorMsg("mobileno",err_enter_valid_mobile);//No i18N
		return;	
	} 

	var option = (de('prefaddcall') && de('prefaddcall').checked) ? 2 : 1;//No I18N
	var countryCode = de('countNameAddDiv').value; //No I18N
	var _p = "mobile="+euc(mobVal)+"&countrycode="+euc(countryCode)+"&verifytype="+option+"&is_ph_pg=true"+"&"+csrfParam; //No I18N
	var resp = getPlainResponse("/p/update", _p); //No I18N
	resp = resp.trim();
	if(IsJsonString(resp)){
		var obj = JSON.parse(resp);
		showerrormsg(obj.message); 
		return;
	}
	if(resp == "success") { //No I18N
		var dialingCode = isdCodes[countryCode];
		var displayPhone = "(+"+dialingCode+")"+" "+ mobVal;
		de("codeSentMsg").innerHTML =formatMessage(err_verification_sent_success,displayPhone); //No I18N
		$('#addphNoDiv, #verifyphNoDiv').toggle(); //No I18N
		de('vcode').focus(); //No I18N
	}else if(resp == "EXIST") { //No I18N
		showTFAErrorMsg("mobileno",err_mobile_already_exist); //No I18N
	}else if(resp == "invalid_mobile"){  //No I18N
		showTFAErrorMsg("mobileno",err_enter_valid_mobile); //No I18N
	}else if(resp == "NOT_EXIST"){ //No I18N
		showTFAErrorMsg("mobileno",formatMessage(err_old_mob_nt_exist,old_mobile)); //No I18N
	}else if(resp =="ro_update_not_allowed"){ //No I18N
		showTFAErrorMsg("mobileno",write_operation_not_allowed); //No I18N
    }else if(resp == "EXIST_IN_ORG") { //No I18N
    	showTFAErrorMsg("mobileno",err_exist_in_org);//No I18N
	}else if(resp == "err_phone_unverified_block"){//No I18N
		showTFAErrorMsg("mobileno",err_phone_unverified_block);//No I18N
		de("mobilenoerr").style="position: absolute;";
	}else if(resp == "err_tfa_remote_ip_lock"){//No I18N
		showTFAErrorMsg("mobileno",err_tfa_remote_ip_lock);//No I18N
		de("mobilenoerr").style="position: absolute;";
	}else if(resp == "err_phone_max_linked_block"){//No I18N
		showTFAErrorMsg("mobileno",err_phone_max_linked_block);//No I18N
		de("mobilenoerr").style="position: absolute;";
	}else{
		showTFAErrorMsg("mobileno",err_cnt_error_occurred); //No I18N
	}
}

function isJson(response){
	try{
		var obj = JSON.parse(res);
		return true;
	}catch(Exception){
		return false;
	}
}

function verifyCode(type) {
	// IMPORTANT : Same JS method used in TFA Recovery update(in announcement) also. So, check there also before any changes done. 
	// DOM alone replicated outside in this case.
	
	var code = $('#vcode').val().trim(); //No I18N
	if(isEmpty(code) || isNaN(code)) {
		showTFAErrorMsg("vcode",err_invalid_verify_code); //No I18N
		return;
	}
	var password = $("#phpass_tfapref").val().trim();
	if(password == "") {
		showTFAErrorMsg("phpass_tfapref",err_invalid_password); //No I18N
		return;
	}
	
	var mobileVal = $('#mobileno').val().trim(); //No I18N
	var _p = "code="+euc(code)+"&password="+ euc(password)+"&mobile="+mobileVal+"&"+csrfParam; //No I18N
	var resp = getPlainResponse("/p/verify", _p); //No I18N
	resp = resp.trim();
	if(resp == "success") { //No I18N
		if(type === "rec_update") {
			switchto(window.parent.location.href);
		}else {
			de('tfaopacity').style.display='none'; //No I18N
			loadui('/ui/settings/tfapreference.jsp'); //No I18N
			showsuccessmsg(err_mob_added); //No i18N			
		}
		return;
	}else if(resp == "NOT_EXIST"){  //No I18N
		showTFAErrorMsg("vcode",formatMessage(err_old_mob_nt_exist,old_mobile)); //No i18N
		return;
	}else if(resp == "invalid_password"){ //No I18N
		showTFAErrorMsg("phpass_tfapref",err_invalid_password); //No I18N
		de('phpass_tfapref').value = ""; //No I18N
		de('phpass_tfapref').focus(); //No I18N
		return;
	}else if(resp =="ro_update_not_allowed"){ //No I18N
		showTFAErrorMsg("vcode",write_operation_not_allowed); //No I18N
        return;
    }else if(resp == "invalid_code") { //No i18N
		showTFAErrorMsg("vcode",err_invalid_verify_code); //No i18N
		$('#vcode').val("").focus();
		de('phpass_tfapref').value = ""; //No I18N
		return;
	}else {
		showTFAErrorMsg("vcode",err_cnt_error_occurred); //No i18N
		return;
	}
}

function deleteBackupMobile(mobile) {
	pass = de('tfaph_rem_pass').value.trim();//No I18N 
	if(pass==""){
		showTFAErrorMsg("tfaph_rem_pass",err_invalid_password);//no I18N 
		return;
	}
	var resp = getPlainResponse("/p/delete","password="+ euc(pass) + "&mobile="+mobile+"&"+ csrfParam); //No I18N
	resp = resp.trim();
	if(resp == "success") { //No I18N
		popup('hide','tfapassword_popup'); //No I18N
		loadui('/ui/settings/tfapreference.jsp'); //No I18N
		showsuccessmsg(err_mob_removed);
		return;
	}else if(resp == "update_not_allowed"){ //No I18N
		showTFAErrorMsg("tfaph_rem_pass",update_not_allowed); //No I18N
		de('tfaph_rem_pass').focus(); //No I18N
		return;
	}else if(resp =="ro_update_not_allowed"){ //No I18N
		showTFAErrorMsg("tfaph_rem_pass",write_operation_not_allowed);//No I18N
		de('tfaph_rem_pass').focus(); //No I18N
		return;
	}else if(resp == "invalid_password") { //No I18N
		showTFAErrorMsg("tfaph_rem_pass",err_invalid_password); //No I18N
		de('tfaph_rem_pass').focus(); //No I18N
		return;
	}
	showTFAErrorMsg("tfaph_rem_pass",err_cnt_error_occurred); //No I18N
}

function changePrimary(mobile){
	pass = de('tfaph_rem_pass').value.trim();//No I18N 
	if(pass==""){
		showTFAErrorMsg("tfaph_rem_pass",err_invalid_password);  //No I18N
		return;
	}
	var resp = getPlainResponse("/p/primary","password="+euc(pass)+"&mobile="+mobile+"&"+ csrfParam); //No I18N
	resp = resp.trim();
	if(resp == "success") { //No I18N
		popup('hide','tfapassword_popup'); //No I18N
		loadui('/ui/settings/tfapreference.jsp'); //No I18N
		showTFAElementSuccessMsg("prim_number",err_primary_success); //No i18N
		return;
	}else if(resp == "invalid_password"){ //No I18N
		showTFAErrorMsg("tfaph_rem_pass",err_invalid_password); //No I18N
		de('tfaph_rem_pass').focus(); //No I18N
		return;
	}else if(resp =="ro_update_not_allowed"){ //No I18N
		showTFAErrorMsg("tfaph_rem_pass",write_operation_not_allowed); //No I18N
		de('tfaph_rem_pass').focus(); //No I18N
        return;
    }
	showTFAErrorMsg("tfaph_rem_pass",err_cnt_error_occurred); //No I18N
}

function resendVerificationCode() {
	// IMPORTANT : Same JS method used in TFA Recovery update(in announcement) also. So, check there also before any changes done. 
	// DOM alone replicated outside in this case.
	var mobVal= de('mobileno').value; //No I18N
	var countryCode = de('countNameAddDiv').value; //No I18N
	if(validateMobile(mobVal) != true) {
		showTFAErrorMsg("vcode",err_cnt_error_occurred); //No I18N
		return;
	}
	var resp = getPlainResponse("/p/resend","mobile="+mobVal+ "&"+ csrfParam); //No I18N
	resp = resp.trim();
	if(IsJsonString(resp)){
		var obj = JSON.parse(resp);
		showerrormsg(obj.message); 
		return;
	}
	if(resp == "success") { //No I18N
		var dialingCode = isdCodes[countryCode];
		var displayPhone = "(+"+dialingCode+")"+" "+ mobVal; //No I18N
		showTFAPopupMsg(formatMessage(err_verify_code_sent, displayPhone));
	} else if(resp =="ro_update_not_allowed"){ //No I18N
		showTFAErrorMsg("vcode",write_operation_not_allowed); //No I18N
        return;
    } else if(resp == "err_tfa_remote_ip_lock"){ //No I18N
    	showTFAErrorMsg("vcode",err_tfa_remote_ip_lock); //No I18N
    	de("vcodeerr").style="position: absolute;";
    } else{
    	showTFAErrorMsg("vcode",err_cnt_error_occurred); //No I18N
	}
}

function confirmPasswordBox(func) {
	if(func == "show"){ //No I18N
		de('verifyuserpassword').style.display = ''; //No I18N
		de('verifyuserpwd').value ="";
		de('verifyuserpwd').focus(); //No i18N
		de('opacity').style.display=''; //No I18N
	}else{
		de('verifyuserpassword').style.display = 'none'; //No I18N
		de('verifyuserpwd').value ="";
		de('opacity').style.display='none'; //No I18N
	}
}

