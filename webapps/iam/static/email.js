//$Id$
function addnewEmail(f) {
    var emailid = f.eid.value.trim();
    var password = f.pwd.value.trim();
    if(!isEmailId(emailid)) {
	showerrormsg(err_validemail);
	f.eid.focus();
    }
    else if(emailid.length > 100) {
	showerrormsg(err_email_maxlen);
        f.eid.focus();
    }
    else if(isEmpty(password)) {
	showerrormsg(err_enter_pass);
        f.pwd.focus();
    }
    else if(password.length > f.pass_maxlen.value.trim()) {
    	showerrormsg(formatMessage(err_password_maxlen, f.pass_maxlen.value.trim()));
        f.pwd.focus();
    }
    else {
	var params = "email="+euc(emailid.toLowerCase())+"&PASSWORD="+euc(password)+"&"+csrfParam; //No I18N
        if(de("sname")) {
            params += "&servicename=" + de("sname").value.trim(); //No I18N
        }
        if(de("surl")) {
            params += "&serviceurl=" + de("surl").value.trim(); //No I18N
        }
        sendRequestWithCallback(contextpath+"/u/em/a", params, true, handleUserEmailResponse); //No I18N
    }
    return false;
}

function getDropDownList(){
	getDropDown();
	 $("#contNameprefAdd_chzn ,#countNameAddDiv_chzn").css("width","32%");
}

function showPhonenumberForm(fedSignIn){
if(fedSignIn){
	$('#addphonenumbtn').hide();
	$("#federatedwrng").show();	
} else {
	$("#addemailid").fadeIn(100);
	$("#opacity").fadeIn("fast");
	$('#countNameAddDiv').prop('disabled', false);
	$('#phonenumberlabel').show();
	$("#mobileno").removeAttr('disabled');	
	$('#passwdfield').hide();
	$('#verifyfield').hide();
	$('#addphone').val(iam_add_phone_number);	
	$('#addphone').attr('onclick', 'addNewPhoneNumber(document.addemailid)');
    if($("#addToRecovery").length){
		$("#addToRecovery").show();
		$("#addnewphone").hide();
		$("#passwd").focus();
		return;	
	}
	document.addemailid.mobileno.value = "";	
	document.addemailid.mobileno.focus();
}
}


function editMobile(mobile){
	showPhonenumberForm();
	$('#editedmobile').val(mobile);
	$('#addnewphone').show();
	$('#addToRecovery').hide();
	document.addemailid.mobileno.value = mobile;	
}


function addNewPhoneNumber(f){
    var mobile = f.mobileno.value.trim();
    mobile = mobile.replace(/[+ \[\]\(\)\-\.\,]/g,'');
    var code = f.countNameAddDiv.value.trim();
    if(!isPhoneNumber(mobile)) {
    	showerrormsg(err_enter_valid_mobile);
    	document.addemailid.mobileno.focus();
    	return;
    } 
    var params = "mobile="+euc(mobile)+"&code="+euc(code)+"&"+csrfParam+"&"+"selectedupdate=usermobile"+(de("editedmobile") && de("editedmobile").value!=""?("&oldmobile="+de("editedmobile").value):"");//No I18N
    res = getPlainResponse("/u/updateMobile", params);//No I18N
	try{
		var obj = JSON.parse(res);
		if(obj.status == "success"){    
			$('#verifyfield').show();
			$('#phonenumberlabel').hide();
			$('#countNameAddDiv').prop('disabled', 'disabled');
			$(f.otp).removeAttr('disabled');
			$('#addphone').attr('onclick', 'verifyPhoneNumber(document.addemailid)');
			$('#addphone').val(iam_verify_phone_number);
			$('#otpcode').val('');
			document.addemailid.otp.focus();
		}else{
	    	showerrormsg(obj.message);
	    	document.addemailid.mobileno.focus();
		}
	}catch(e){
		showerrormsg(err_cnt_error_occurred);
	}
}

function editAddNewPhone(){
	$(".addnewemail").fadeOut(100);
	showPhonenumberForm();
	$("#addToRecovery").hide();
	$("#addnewphone").fadeIn();
	document.addemailid.mobileno.focus();
}

function verifyPhoneNumber(f){
	var code = f.otp.value.trim();
    var mobile = f.mobileno.value.trim();
    var countrycode = f.countNameAddDiv.value.trim();

	code = code.trim();
    var codeRegExp = /^([0-9]{5,7})$/;
    if(!codeRegExp.test(code)) {
    	showerrormsg(err_invalid_verify_code);
    	document.addemailid.otp.focus();
    	return;
    }
    var params = "otpcode="+euc(code)+"&"+csrfParam+"&mobile="+mobile+"&countrycode="+countrycode;//No I18N
    res = getPlainResponse("/u/verifyotp", params);//No I18N
	var obj = JSON.parse(res);
	if(obj.status == "success"){        
		$('#passwdfield').show();
		$('#verifyfield').hide();
		$('#addphone').attr('onclick', 'confirmaddmobile(document.addemailid)');
		$('#addphone').val(err_addphone_confirm);
		$('#passwod').val('');
		document.addemailid.pwd.focus();
	}else{
    	showerrormsg(obj.message);
    	document.addemailid.otp.focus();
	}
}

function confirmaddmobile(f){
	var passwd = f.pwd.value.trim();
    var mobile = f.mobileno.value.trim();
    var countrycode = f.countNameAddDiv.value.trim();
    var oldMobile = f.emobile.value.trim();

	passwd = passwd.trim();
	if(passwd.length <= 3) {
		showerrormsg(err_invalid_password);
		document.addemailid.pwd.focus();
		return;
	}

	var params = "passwd="+euc(passwd)+"&"+csrfParam+"&mobile="+mobile;//No I18N
    if(oldMobile){
    	params += "&oldmobile="+oldMobile;//No I18N
    }
	res = getPlainResponse("/u/confirmaddmobile", params);//No I18N
	var obj = JSON.parse(res);
	if(obj.status == "success"){ 
		loadui('/ui/profile/phonenumbers.jsp'); //No I18N
		$("#opacity").fadeOut();
		showsuccessmsg(err_update_success);		
	}else{
    	showerrormsg(obj.message);
    	document.addemailid.pwd.focus();
	}
}

function deleteMobile(mobile,screenname) {
	var alertmsg = err_mobile_sure_delete1;
    if(mobile.trim() == screenname.trim()) {
    	alertmsg = err_mobile_screenname_sure_delete;
    }
    if(confirm(formatMessage(alertmsg, mobile))) {
    	var params = "mobile="+euc(mobile.trim())+"&"+csrfParam;//No I18N
    	res = getPlainResponse("/u/deleteMobile", params);//No I18N
    	var obj = JSON.parse(res);
    	if(obj.status == "success"){ 
    		loadui('/ui/profile/phonenumbers.jsp'); //No I18N
    		$("#opacity").fadeOut();
    		showsuccessmsg(err_update_success);    		
    		return;
    	}
    	showerrormsg(obj.message);
    }
    return false;
}

function editLoginName(f){
    var mobile =$( "#editscreenname").val();
    var passwd =$( "#passwd_editlogin").val(); 
    if(!isPhoneNumber(mobile)) {
    	showerrormsg(err_enter_valid_mobile);
    	document.editPrimary.pwd.focus();
    	return;
    } 
    var params = "mobile="+euc(mobile)+"&"+csrfParam+"&"+"selectedupdate=screenname&passwd="+euc(passwd);//No I18N
    res = getPlainResponse("/u/updateMobile", params);//No I18N
	var obj = JSON.parse(res);
	if(obj.status == "success"){    
		loadui('/ui/profile/phonenumbers.jsp'); //No I18N
		$("#opacity").fadeOut();
		showsuccessmsg(err_update_success);
	}else{
    	showerrormsg(obj.message);
    	document.editPrimary.pwd.focus();
	}
}

function switchBackupNoForRecovery(f){
    var mobile =$( "#backupnumber").val();
    var passwd =$( "#passwd").val(); 
    if(!isPhoneNumber(mobile)) {
    	showerrormsg(err_enter_valid_mobile);
    	return;
    } 
    var params = "mobile="+euc(mobile)+"&"+csrfParam+"&passwd="+euc(passwd);//No I18N
    res = getPlainResponse("/u/addbackupnoasrecovery", params);//No I18N
	var obj = JSON.parse(res);
	if(obj.status == "success"){    
		loadui('/ui/profile/phonenumbers.jsp'); //No I18N
		$("#opacity").fadeOut();
		showsuccessmsg(err_update_success);
	}else{
    	showerrormsg(obj.message);
	}
}

function handleUserEmailResponse(resp) {
	if(!resp) {
		return;
	}

	resp = resp.trim();
	if(resp.indexOf('SUCCESS_') !== -1) {
		var respArr = (resp.split("SUCCESS_")[1]).split("_IAM_");
		if(respArr.length < 4) {
			if(isPhoneNumber(userPrimaryEmailAddress)){
				userPrimaryEmailAddress = $('#inputemail').val();
			}
			useremail_success(respArr[0]);
		} else {
			//useremail_success(msg, isPrimary, jsemail,htmlemail);
			useremail_success(respArr[0], respArr[1], respArr[2],respArr[3]);
		}
	    //    userPrimaryEmailAddress
	} else {
		if(resp.indexOf('HOSTED_') !== -1){
			$("#messagepopupmsg").html(resp.split("HOSTED_")[1]);
			$("#messagepopup,#opacity").show();
		}else{
			showerrormsg(resp);	
		}
	}
}

function editEmail(f) {
    var newemail = f.eeid.value.trim();
    var oldemail = f.eeoid.value.trim();
    var emailpassword = f.pwd.value.trim();
    if(!isEmailId(newemail)) {
	showerrormsg(err_validemail);
	f.eeid.focus();
	return false;
    }
    else if(newemail.length > 100) {
	showerrormsg(err_email_maxlen);
	f.eeid.focus();
	return false;
    }
    else if(isEmpty(emailpassword)) {
	showerrormsg(err_enter_currpass);
	f.pwd.focus();
	return false;
    }
    else if(emailpassword.length > f.pass_maxlen.value.trim()) {
    showerrormsg(formatMessage(err_password_maxlen, f.pass_maxlen.value.trim()));
	f.pwd.focus();
	return false;
    }
    var params = "CURRPASSWORD="+euc(emailpassword)+"&newemail="+euc(newemail.toLowerCase())+"&oldemail="+euc(oldemail.toLowerCase())+"&"+csrfParam; //No I18N
    if(de("sname")) {
        params += "&servicename=" + de("sname").value.trim(); //No I18N
    }
    if(de("surl")) {
        params += "&serviceurl=" + de("surl").value.trim(); //No I18N
    }
    sendRequestWithCallback(contextpath+"/u/em/e", params, true, handleUserEmailResponse); //No I18N
    return false;
}

function deleteEmail(emailid,priemail) {
    if(priemail.trim() == emailid.trim()) {
	alert(err_email_primary_notdlt);
    }
    else if(confirm(formatMessage(err_email_sure_delete1, emailid))) {
        var params = "email="+euc(emailid.toLowerCase())+"&"+csrfParam; //No I18N
        sendRequestWithCallback(contextpath+"/u/em/d", params, true, handleUserEmailResponse); //No I18N
    }
    return false;
}

function setAsPrimary(f) {
    var email = f.email.value.trim();
    var pwd = f.pwd.value.trim();
    if(isEmpty(pwd)) {
	showerrormsg(err_enter_currpass);
	f.pwd.focus();
	return false;
    }
    else if(pwd.length > f.pass_maxlen.value.trim()) {
    showerrormsg(formatMessage(err_password_maxlen, f.pass_maxlen.value.trim()));
	f.pwd.focus();
	return false;
    }
    var params = "email="+euc(email.toLowerCase())+"&CURRPASSWORD="+euc(pwd)+"&"+csrfParam; //No I18N
    sendRequestWithCallback(contextpath+"/u/em/mkprimary", params, true, handleUserEmailResponse); //No I18N
    return false;
}

function resendConfirmation(id, isConfirm) {
    if(isConfirm) {
	var params = "email="+euc(id.toLowerCase())+"&"+csrfParam; //No I18N
	sendRequestWithCallback(contextpath+"/u/em/confirm", params, true, handleUserEmailResponse); //No I18N
	mailReqPopUp('hide'); //No I18N
    }
    else {
	if(de('mailreqpopup')) {
	    de('mailpopuptitle').innerHTML = mailpopup_email_title;
	    de('mailpopupmsg').innerHTML = formatMessage(mailpopup_email_msg, id);
	    de('mailtip').innerHTML = "<div style='padding-left:15px;'><ul>"+mailpopup_email_tip+"</ul></div>"; //No I18N
	    de('confirmBtn').onclick = function() {resendConfirmation(id, true);};
	    mailReqPopUp('show'); //No I18N
	}
	else {
	    resendConfirmation(id, true);
	}
    }
    return false;
}


/*-----email common script -----*/
function useremail_success(msg, isPrimary, email,htmlemail) {
	$("#opacity").fadeOut();
    showsuccessmsg(msg);
    if(fromService) {
	loadui('/ui/profile/email.jsp?service=true');//No I18N
    }
    else {
	loadui('/ui/profile/email.jsp'); //No I18N
	if(isPrimary) {
	    de('logoutid').innerHTML = htmlemail;//no i18N
	    userPrimaryEmailAddress = email;
	}
    }
}

function closeDivId(id,f) {
    de(id).style.display='none';
    f.reset();
}

function closeEmailDiv(id,f,fedSignIn){
	 de(id).style.display='none';
	 if(!fedSignIn){
	    f.reset();
	 }
	 $('#opacity').hide();
}

function closeMobileDiv(id,f) {
    de(id).style.display='none';
    $('#opacity').hide();
	$('#editedmobile').val("");
    if($("#addToRecovery").length){
		$("#addToRecovery").show();
		$("#addnewphone").hide()
	}
}


function showEmailDiv(id1, id2) {
	$(".editsecondaryemail").hide();
    if (de(id1)){
    	$("#"+id1).slideToggle("fast");
        de(id1).style.display = "block";
    }
    if (de(id2)){
    	$("#"+id2).slideToggle("fast");
        de(id2).style.display = "none";
    }
}

function showDivId(id) {$("#opacity").show();de(id).style.display = "block";}
function hideDivId(id) {$("#opacity").hide();de(id).style.display='none';}
function unlinkFacebook() {
    if (confirm(confirm_fb_delete)) {
        sendRequestWithCallback(contextpath+"/u/em/fbdl", csrfParam, true, handleUserEmailResponse); //No I18N
    }
    return false;
}
function setFBPrimary(frm) {
    var qs;
    qs = "CURRPASSWORD=" + euc(frm.pwd.value.trim()); //No I18N
    qs += "&" + csrfParam;
    sendRequestWithCallback(contextpath+"/u/em/fbpr", qs, true, handleUserEmailResponse); //No I18N
    return false;
}

function hidePrimaryEmail() {
    if(fromService) {
	loadui('/ui/profile/personal-details.jsp?service=true'); //No I18N
    }
    else {
	loadPage('personal','/ui/profile/personal-details.jsp'); //No I18N
    }
}
function showEmailForm(){
	$("#addemailid").fadeIn(100);
	$("#opacity").fadeIn("fast");
	 document.addemailid.eid.focus();
}


$(document).keydown(function(e) {
    if (e.keyCode === 27) {
    	if($("#addemailid").is(":visible")){
    		$("#addemailid").fadeOut(100);	
    	}else if($("#primid").is(":visible")){
    		$("#primid").fadeOut(100);
    	}else{
    		if($(".photodefault").is(":visible")){
    			closePhotoPopUp($(".photodefault").is(":visible"));	
    		}
    	}
		$("#opacity").fadeOut("fast");
		if(de('addnewip')){
			addnew('hide');//No i18N	
		}
    }
});