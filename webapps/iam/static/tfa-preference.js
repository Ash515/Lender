//$Id$

/***********************************TFA Setup******************************************/
var disableApproved;
var disableVerifyCount = 0;
var yubName;
var isWentBack=true;
function selectMode(){
	if($(".oneauthapp").is(":visible")){
		$(".oneauthapp").hide();	
	}
	if(arguments.length==1){
		if(arguments[0]=='false'){
			showerrormsg(err_tfa_confirm_account);
			return;
		}
	}
	var authtype = $('[name=modepref]:checked').val(); //No i18N		
	if(authtype == "gauth") {
		de('modediv').style.display ="none";
		de('gauth').style.display ="";
		if(de('displayqr').style.display =="none"){
			loadtotp();			
		}
	}else if(authtype == "smscall"){
		de('modediv').style.display ="none";
		de('getPhNodiv').style.display ="";
		de('prefmob').focus(); //No i18N
		$('#prefmob').siblings('.error').hide(); 
		if(de('verifiedmobiles').value){
		popup('show','set_as_tfa_msgpopup');//No I18N
		}
	}else if(authtype == "exoauth"){
		de('modediv').style.display ="none";
		de('exoauth').style.display="";
	}
	$('#mode').removeClass('selected').addClass('unselected');//No I18N
	$('#modetext').removeClass('selectedtext').addClass('unselectedtext');//No I18N
	$('#mode').removeClass('unselected').addClass('active-mode');//No I18N
	$('#first').removeClass('unselected-setup').addClass('selected-setup');//No I18N
	$('#firsttext').removeClass('unselectedtext').addClass('selectedtext');//No I18N
}

function selectMFAMode(modeType, modeIdentifier){
	if(modeType == "oneauthmodepref") {
		openOneAuthWindow(modeIdentifier);
		return false;
	}
	if(modeType == "authmodepref") {
		if(modeIdentifier=="false"){
			showerrormsg(err_tfa_confirm_account);
			return;
		}
		de('gauth').style.display ="";
		if(de('displayqr').style.display =="none"){
			loadtotp();			
		}
	} else if(modeType == "smsmodepref") { //No I18N
		if(modeIdentifier=="false"){
			showerrormsg(err_tfa_confirm_account);
			return;
		}
		de('getPhNodiv').style.display ="";
		de('prefmob').focus(); //No i18N
		$('#prefmob').siblings('.error').hide(); 
		if(de('verifiedmobiles').value){
			popup('show','set_as_tfa_msgpopup');//No I18N
		}
	} else if(modeType == "exomodepref") { //No I18N
		de('exoauth').style.display="";
	} else if(modeType == "yubikeypref"){ //No I18N
		de('yudevname').style.display="";				
	}
	$('#mode').removeClass('selected').addClass('unselected');//No I18N
	$('#modetext').removeClass('selectedtext').addClass('unselectedtext');//No I18N
	$('#mode').removeClass('unselected').addClass('active-mode');//No I18N
	$('#first').removeClass('unselected-setup').addClass('selected-setup');//No I18N
	$('#firsttext').removeClass('unselectedtext').addClass('selectedtext');//No I18N
	if(de(modeType)) {
		de(modeType).checked=true;
	}
	de('rulertab').style.display='';
	de('tfasetup-mode-tbl').style.display='none';
}

function cancelMFAMode(isTFAAlreadyEnabled, redirectURL) {
	if(isTFAAlreadyEnabled == 'true') {
		popup('show','warningalert_popup'); //No I18N
	} else {
		tfaredirect(redirectURL);
	}
}

function openOneAuthWindow(modeIdentifier) {
	var modeTitle = $('#' + modeIdentifier).find('div.tfasetup-mode-title').text()
	$('#mfa_oneauthwindow_title').text(modeTitle);
	$('#mfa_oneauthwindow_mgs1').text(iam_mfasetup_oneauth_window_msg1.replace("$_ONEAUTH_MODE", modeTitle));
	$('#mfa_oneauthwindow_mgs2').text(iam_mfasetup_oneauth_window_msg2.replace("$_ONEAUTH_MODE", modeTitle));
	de('tfaopacity').style.display='';
	de('mfa_oneauthwindow').style.display='';
}

function closeOneAuthWindow() {
	de('tfaopacity').style.display='none';
	de('mfa_oneauthwindow').style.display='none';
}

function isDisableApproved(){
	clearInterval(disableApproved);
	if(disableVerifyCount > 10) {
			return false;
	}
	var res = getPlainResponse("/tfapref/disable/verify",csrfParam); //No I18N
	if (res.indexOf("success") != -1) {
		popup('hide','disable_confirm_popup'); //No I18N
		showTFAPref = "false";
		tfaenabled = -1;
		$('#disablesuccessbutton').focus();
		loadui((showTFAPref === 'true') ?'/ui/settings/tfapreference.jsp':'/ui/settings/tfasetup.jsp'+(fromService ? '?service=true' : ''));//no i18n
		clearInterval(disableApproved);
		return false;
	}
	disableVerifyCount++;
	disableApproved = setInterval(function () {isDisableApproved();}, 10000);
}

function addPrefMobile(isSetUp, mobile){
	var mobVal = de('prefmob').value.trim();  //No I18N
	if(mobVal == ""){
		showTFAErrorMsg("prefmob",err_enter_valid_mobile);//No i18N
		return;
	}
	var countryCode = de('contNameprefAdd').value.trim(); //No I18N
	var option = (de('prefaddcall') && de('prefaddcall').checked) ? 2 : 1;//No I18N

	if(validateMobile(mobVal) != true) {
		showTFAErrorMsg("prefmob",err_enter_valid_mobile); //No I18N
		de("prefmob").focus(); //No i18N
		return;	
	}
	if(isSetUp=='false' && mobile && mobVal == mobile) {
		showerrormsg(err_already_configured_mobile);
		de("prefmob").focus(); //No i18N
		return;
	}
	var _p = "mobile="+euc(mobVal)+"&countrycode="+euc(countryCode)+"&verifytype="+option+"&"+csrfParam; //No I18N
	var resp;
	if(isSetUp == 'true') {
		resp = getPlainResponse("/p/setup", _p); //No I18N
	} else {
		resp = getPlainResponse("/p/update", _p); //No I18N
	}
	resp = resp.trim();
	if(IsJsonString(resp)){
		var obj = JSON.parse(resp);
		showerrormsg(obj.message); 
		return;
	}
	if(resp == "success") {//No I18N
		var dialingCode = isdCodes[countryCode];
		var displayPhone = "(+"+dialingCode+")"+" "+ mobVal;
		$('#first').removeClass('selected selected-setup').addClass('active-setup');//No I18N
		$('#firsttext').removeClass('selectedtext').addClass('unselectedtext');//No I18N
		$('#second').removeClass('unselected unselected-verify').addClass('selected-verify');//No I18N
		$('#secondtext').removeClass('unselectedtext').addClass('selectedtext');//No I18N
		$('#getPhNodiv').hide();//No I18N
		if(option == "2") {
			de('veridyheading').innerHTML = formatMessage(err_verify_call_message,displayPhone); //No i18N
		}else {
			de('veridyheading').innerHTML = formatMessage(err_verify_sms_message,displayPhone);	//No i18N		
		}
		$('#verifyphdiv').show();//No I18N
		$('#resendCode').show();
		de('prefcode').focus();//No I18N
		setWindowCloseEvent();
		return;
	}else if(resp == "EXIST") { //No I18N
		showTFAErrorMsg("prefmob",err_mobile_already_exist);//No I18N
	}else if(resp == "invalid_mobile"){  //No I18N
		showTFAErrorMsg("prefmob",err_enter_valid_mobile);//No I18N
	}else if(resp == "NOT_EXIST"){ //No I18N
		showTFAErrorMsg("prefmob",formatMessage(err_old_mob_nt_exist,oldMobile));//No I18N
	}else if(resp == "ro_update_not_allowed"){ //No I18N
		showTFAErrorMsg("prefmob",write_operation_not_allowed);//No I18N
	}else if(resp == "EXIST_IN_ORG") { //No I18N
		showTFAErrorMsg("prefmob",err_exist_in_org);//No I18N
	}else if(resp == "mobile_configured_for_recovery"){//No I18N
		showerrormsg(err_mobile_configured_for_recovery);
	}else if(resp == "err_tfa_confirm_account"){	//No I18N
		showerrormsg(err_tfa_confirm_account);
	}else if(resp == "err_phone_unverified_block"){//No I18N
		showerrormsg(err_phone_unverified_block);
	}else if(resp == "err_tfa_remote_ip_lock"){//No I18N
		showTFAErrorMsg("prefmob",err_tfa_remote_ip_lock);//No I18N
	}else if(resp == "err_phone_max_linked_block"){//No I18N
		showTFAErrorMsg("prefmob",err_phone_max_linked_block);//No I18N
	}else if(resp == "err_already_configured_mobile"){//No I18N
		showerrormsg(err_already_configured_mobile);
	}else {
		showTFAErrorMsg("prefmob",err_cnt_error_occurred);//No I18N
	}
	de('prefmob').focus();//No I18N
}

function setWindowCloseEvent() {
	if(!$._data(window, "events") || !$._data(window, "events").beforeunload) {
		$(window).bind('beforeunload', function() {
			if(!$.browser.msie) {
				return err_tfa_setup_incomplete;		
			}
		});
	}
}

function verifyPrefCode() {
	var val = $('#prefcode').val().trim();//No I18N
	var mobileVal = $('#prefmob').val().trim();//No I18N
	if(isEmpty(val) || isNaN(val)) {
		showTFAErrorMsg("prefcode",err_invalid_verify_code); //No i18N
		return;
	}
	var _p = "code="+euc(val)+"&mobile="+mobileVal+"&"+csrfParam; //No I18N
	var resp = getPlainResponse("/p/prefverify", _p); //No I18N
	resp = resp.trim();
	if(resp == "success") {
		$('#second').removeClass('selected selected-verify').addClass('active-verify');//No I18N
		$('#secondtext').removeClass('selectedtext').addClass('unselectedtext');//No I18N
		$('#third').removeClass('unselected').addClass('selected');//No I18N
		$('#thirdtext').removeClass('unselectedtext').addClass('selectedtext');//No I18N
		$('#verifyphdiv').hide();//No I18N
		$('#getpassword').show();//No I18N
		de('enabletfa').focus(); //No i18N
		return;
	}else if(resp == "invalid_code") { //No i18N
		showTFAErrorMsg("prefcode",err_invalid_verify_code); //No i18N
		$('#prefcode').val("").focus();
		return;
	}else if(resp == "ro_update_not_allowed"){ //No I18N
		showTFAErrorMsg("prefcode",write_operation_not_allowed);//No I18N
		return;
	}else if(resp == "err_tfa_remote_ip_lock"){//No I18N
		showTFAErrorMsg("prefcode",err_tfa_remote_ip_lock);//No i18N
	}else { //No i18N
		showTFAErrorMsg("prefcode",err_cnt_error_occurred); //No i18N
		return;
	}
}

function resendcode(){
	var mobVal= de('prefmob').value.trim(); //No I18N
	var countryCode = de('contNameprefAdd').value; //No I18N
	if(mobVal == ""){ //No I18N
		return;
	}
	if(validateMobile(mobVal) != true) {
		showTFAErrorMsg("prefcode",err_enter_valid_mobile); //No i18N
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
		de('veridyheading').innerHTML = formatMessage(err_verify_code_resent, displayPhone); //No i18N
		de('prefcode').focus();//No I18N
	}else if(resp == "ro_update_not_allowed"){ //No I18N
		showTFAErrorMsg("prefcode",write_operation_not_allowed);//No I18N
	}else if(resp == "err_tfa_remote_ip_lock"){//No I18N
		showTFAErrorMsg("prefcode",err_tfa_remote_ip_lock);//No I18N
	} else{
		showTFAErrorMsg("prefcode",err_cnt_error_occurred); //No i18N
	}
}

function saveTFAValue(){
	var tfapref = 0; //No I18N
	var isYub=false;
	if(de('authmodepref') && de('authmodepref').checked == true) {
		tfapref = 1;
	}else if(de('exomodepref') && de('exomodepref').checked ) {tfapref=6;}//No i18N
	else if(de('yubikeypref') && de('yubikeypref').checked){
		isYub=true;
		tfapref=8;
	}
	var trust = de('tfaremember_field').checked;//No I18N
	var pass = de('enabletfa').value.trim(); //No I18N
	if(pass == ""){
		showTFAErrorMsg("enabletfa",err_invalid_password); //No I18N
		return;
	}
	params = "tfapref=" + euc(tfapref)+ "&password="+ euc(pass) + "&trust="+ trust +"&"+csrfParam; //No I18N
	if(isYub){
		params+="&yubName="+euc(yubName);//No I18N
	}
	if(tfapref == 0) { //SMS mode
		var mobile = de('prefmob').value.trim();  //No I18N
		var oldMobile = de('oldmobile').value; //No I18N
		params += "&mobile="+ mobile; //No i18N
		if((showTFAPref=="true") && (oldMobile != "null" && oldMobile != "")){
			params += "&oldmobile="+oldMobile; //No I18N
		} 
	}
	
    var resp = getPlainResponse("/tfapref/activate",params); //No I18N
    
    if(resp !== null) {
    	if(resp.indexOf("switchto") !== -1) { //un authenticated page.
    		$(window).unbind('beforeunload');
    		new Function( 'return ' + resp.trim())(); // jshint ignore:line
    		return;
    	}
    	if(!IsJsonString(resp)){
        	showTFAErrorMsg("enabletfa",err_cnt_error_occurred); //No i18N
    		return;
    	}
    	var obj = $.parseJSON(resp);
    	var result = obj.result;
    	if(result == "SUCCESS"){
    		showTFAPref = "true";
			tfaenabled = tfapref;
			if(obj.isEdit) {
				loadui((showTFAPref === 'true') ?'/ui/settings/tfapreference.jsp':'/ui/settings/tfasetup.jsp'+(fromService ? "?service=true" : "")); //No I18N
			}else {
				loadui('/ui/settings/tfaconfigure.jsp');//No I18N			
			}
    	}else if(result == "ERROR") { //No i18N
    		var cause = obj.cause;
    		if(cause == "invalid_password"){ //No I18N
    			showTFAErrorMsg("enabletfa",err_invalid_password); //No I18N
    			de('enabletfa').value = ""; //No I18N
    			de('enabletfa').focus(); //No i18N
    			return;
    		}else if(cause == "update_not_allowed"){ //No I18N
    			showTFAErrorMsg("enabletfa",update_not_allowed); //No I18N
    		}else if(resp == "err_tfa_remote_ip_lock"){//No I18N
    			showTFAErrorMsg("enabletfa",err_tfa_remote_ip_lock);//No I18N
    		}else{
    			showTFAErrorMsg("enabletfa",err_cnt_error_occurred); //No I18N
    		}
    	}else{
    		showTFAErrorMsg("enabletfa",err_cnt_error_occurred); //No I18N
    	}
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

function switchto(url){
	window.parent.location.href=url;
}

function showsuccess(url, warning, llt, getUserName, pe) {
	//Used for backward compatibility from signin servlet
	window.parent.location.href=url;
}

function showGauthVerify() {
	$('#first').removeClass('selected selected-setup').addClass('active-setup');//No I18N
	$('#firsttext').removeClass('selectedtext').addClass('unselectedtext');//No I18N
	$('#second').removeClass('unselected-verify unselected').addClass('selected-verify');//No I18N
	$('#secondtext').removeClass('unselectedtext').addClass('selectedtext');//No I18N
	$('#gauth').hide();//No I18N
	$('#resendCode').hide();
	de('veridyheading').innerHTML = formatMessage(err_gauth_verify_message); //No i18N
	$('#verifyphdiv').show();//No I18N
	de('prefcode').focus();//No I18N
}

function verifytotp(){
	var code = de('prefcode').value; //No I18N
	if(code == ""){
		showTFAErrorMsg("prefcode",err_invalid_verify_code); //No I18N
		return;
	}

	var params = "code="+euc(code)+"&"+csrfParam; //No I18N
	var resp = getPlainResponse("/tfapref/totp/verify",params); //No I18N

	if(!IsJsonString(resp)){ //No I18N
		if(resp == "ro_update_not_allowed") {
			showTFAErrorMsg("prefcode",write_operation_not_allowed);//No I18N
			return;	
		} else {
			showTFAErrorMsg("prefcode",err_cnt_error_occurred);//No I18N
			return;
		}
	}
	var obj = $.parseJSON(resp);
	var result = obj.result;
	if(result == "success"){
		$('#second').removeClass('selected selected-verify').addClass('active-verify');//No I18N
		$('#secondtext').removeClass('selectedtext').addClass('unselectedtext');//No I18N
		$('#third').removeClass('unselected unselected-confirm').addClass('selected-confirm');//No I18N
		$('#thirdtext').removeClass('unselectedtext').addClass('selectedtext');//No I18N
		$('#verifyphdiv').hide();//No I18N
		$('#getpassword').show();//No I18N
		de('enabletfa').focus(); //No i18N
		return;
	}else if(result == "error"){ //No I18N
		showTFAErrorMsg("prefcode",err_invalid_verify_code);//No I18N
		$('#prefcode').val("").focus();
		return;
	}else{
		showTFAErrorMsg("prefcode",err_cnt_error_occurred);//No I18N
	}
}

function showExoAuthVerify(){
	$('#first').removeClass('selected selected-setup').addClass('active-setup');//No I18N
	$('#firsttext').removeClass('selectedtext').addClass('unselectedtext');//No I18N
	$('#second').removeClass('unselected-verify unselected').addClass('selected-verify');//No I18N
	$('#secondtext').removeClass('unselectedtext').addClass('selectedtext');//No I18N
	$('#exoauth').hide();
	$('#resendCode').hide();
	if(de('hardmodepref').checked){ 
		de('veridyheading').innerHTML = formatMessage(err_exoauth_verify_message);//No i18N
	}else{ 
		de('veridyheading').innerHTML = formatMessage(err_exoauth_verify_message1); //No i18N 
	}
	$('#verifyphdiv').show();//No I18N
	de('prefcode').focus();//No I18N
}

function resynExoSession(url){
	var mgmg = window.open(url,"_blank","toolbar=no,location=no,directories=no,status=no,menubar=1,scrollbars=yes,resizable=no,width=1024,height=720,top=50,left=50");
}

function verifyExoCode(){
	var type;
	if(de('hardmodepref').checked == true) {//No i18N
		type = 'hardtok';//No i18N
	}else if(de('softmodepref').checked == true) {//No i18N
		type = 'softtok';//No i18N
	}
	var code = de('prefcode').value;
	if(code == ""){
		showTFAErrorMsg("prefcode",err_invalid_verify_code); //No I18N
		return;
	}
	
	var params = "code="+euc(code)+"&type="+euc(type)+"&"+csrfParam; //No I18N
	var resp = getPlainResponse("/tfapref/exo/verify",params); //No I18N

	if(!IsJsonString(resp)){ //No I18N
		if(resp == "ro_update_not_allowed") {
			showTFAErrorMsg("prefcode",write_operation_not_allowed);//No I18N
			return;	
		} else {
			showTFAErrorMsg("prefcode",err_cnt_error_occurred);//No I18N
			return;
		}
	}
	var obj = $.parseJSON(resp);
	var result = obj.result;
	if(result == "success"){
		$('#second').removeClass('selected selected-verify').addClass('active-verify');//No I18N
		$('#secondtext').removeClass('selectedtext').addClass('unselectedtext');//No I18N
		$('#third').removeClass('unselected unselected-confirm').addClass('selected-confirm');//No I18N
		$('#thirdtext').removeClass('unselectedtext').addClass('selectedtext');//No I18N
		$('#verifyphdiv').hide();//No I18N
		$('#getpassword').show();//No I18N
		de('enabletfa').focus(); //No i18N
		return;
	}else {
		result=obj.error;
		if(result == "unknown_user"){ //No I18N
			showTFAErrorMsg("prefcode",exo_err_unknow_user);//No I18N
			$('#prefcode').val("").focus();
			return;
		}else if(result == "otp_fail_max_hit"){ //No I18N
			showTFAErrorMsg("prefcode",exo_err_max_attempt);//No I18N
			$('#prefcode').val("").focus();
			return;
		}else if(result == "otp_fail"){ //No I18N
			showTFAErrorMsg("prefcode",err_invalid_verify_code);//No I18N
			$('#prefcode').val("").focus();
			return;
		}else{
			showTFAErrorMsg("prefcode",err_cnt_error_occurred);//No I18N
		}
	}
}

function checkradioandChangeClass(option){
	checkRadioButtonStatus(option);
	de('prefcode').value = ""; //No I18N
	if(option == "smsmodepref") {
		$('#authmode').removeClass('modeselect');
		$('#smsmode').addClass('modeselect');
	}else {
		$('#smsmode').removeClass('modeselect');
		$('#authmode').addClass('modeselect');
	}
}

function backoper(option){
	if(option == "second"){//No I18N
		$('#second').removeClass('selected').addClass('unselected-verify');//No I18N
		$('#secondtext').removeClass('selectedtext').addClass('unselectedtext');//No I18N
		$('#first').removeClass('unselected active-setup').addClass('selected-setup');//No I18N
		$('#firsttext').removeClass('unselectedtext').addClass('selectedtext');//No I18N
		$('#verifyphdiv').hide();//No I18N
		$('#yuverify').hide();//No I18N
		$('#prefcode').siblings('.error').hide();
		if(de('authmodepref') && de('authmodepref').checked == true) {
			$('#gauth').show();
		}else if(de('exomodepref') && de('exomodepref').checked == true){//No i18N
			$('#exoauth').show();
		}else if(de('yubikeypref') && de('yubikeypref').checked == true){//No i18N
			isWentBack=true;
			$('#yudevname').show();
		}else{
			$('#getPhNodiv').show();//No I18N
		}
		return;
	}else if(option == "third"){//No I18N
		de('enabletfa').value = ""; //No I18N
		$('#third').removeClass('selected selected-confirm').addClass('unselected-confirm');//No I18N
		$('#thirdtext').removeClass('selectedtext').addClass('unselectedtext');//No I18N
		$('#second').removeClass('unselected active-verify').addClass('selected-verify');//No I18N
		$('#secondtext').removeClass('unselectedtext').addClass('selectedtext');//No I18N
		$('#getpassword').hide();//No I18N
		if(de('yubikeypref') && de('yubikeypref').checked == true){//No i18N
			$('#yuverify').show();
		}else{
			$('#verifyphdiv').show();//No I18N
			$('#prefcode').val('');//No I18N
			if(de('smsmodepref') && de('smsmodepref').checked==true){//No I18N
				resendcode();
			}
		}
		$('#enabletfa').siblings('.error').hide();	
	}
	else if(option == "mode") { //No I18N
		if(!$(".oneauthapp").is(":visible")){
			$(".oneauthapp").show();	
		}
		$('#first').removeClass('selected-setup').addClass('unselected-setup');//No I18N
		$('#firsttext').removeClass('selectedtext').addClass('unselectedtext');//No I18N
		$('#mode').removeClass('unselected').addClass('selected');//No I18N
		$('#modetext').removeClass('unselectedtext').addClass('selectedtext');//No I18N
		var authmode = de('authmodepref');//No i18N
		if(authmode && authmode.checked == true) {
			$('#gauth').hide();
		}else if(de('exomodepref') && de('exomodepref').checked == true){//No i18N
			$('#exoauth').hide();
		}else{
			$('#getPhNodiv').hide();
		}
		$('#modediv').show();//No I18N
		$('#prefmob').siblings('.error').hide();
	} else if(option == "mfa_mode") { //No I18N
		if(!$(".oneauthapp").is(":visible")){
			$(".oneauthapp").show();	
		}
		$('#first').removeClass('selected-setup').addClass('unselected-setup');//No I18N
		$('#firsttext').removeClass('selectedtext').addClass('unselectedtext');//No I18N
		$('#mode').removeClass('unselected').addClass('selected');//No I18N
		$('#modetext').removeClass('unselectedtext').addClass('selectedtext');//No I18N

		if(de('rulertab')) {
			de('rulertab').style.display='none';
		}
		if(de('getPhNodiv')) {
			de('getPhNodiv').style.display='none';
		}
		if(de('gauth')) {
			de('gauth').style.display='none';
		}
		if(de('exoauth')) {
			de('exoauth').style.display='none';
		}
		if(de('verifyphdiv')) {
			de('verifyphdiv').style.display='none';
		}
		if(de("yudevname")){
			de('yudevname').style.display='none';
		}
		$('#prefmob').siblings('.error').hide();
		de('tfasetup-mode-tbl').style.display='';
	}
}

function loadtotp() {
	var resp = getPlainResponse('/tfapref/totp/secret', "&"+csrfParam); //No I18N
	if(resp != "error" && resp != "ro_update_not_allowed" &&resp != "err_tfa_confirm_account") {
		de('displayqr').style.display ="";
		de('gauthimg').src="/tfapref/totp/qrbarcode?nocache=" + new Date().getMilliseconds();
		var displaykey = "<span>"+resp.substring(0, 4)+"</span>"+"<span style='margin-left:5px'>"+resp.substring(4, 8)+"</span>"+"<span style='margin-left:5px'>"+resp.substring(8,12)+"</span>"+"<span style='margin-left:5px'>"+resp.substring(12)+"</span>"; //No I18N
		de('skey').innerHTML = displaykey; //No i18N
	}else if(resp == "err_tfa_confirm_account"){	//No I18N
		showerrormsg(err_tfa_confirm_account);
		backoper('mfa_mode'); //No I18N
	}
	setWindowCloseEvent();
}

function registerYK(data) {
	if(!isWentBack){
		if(data.errorCode) {
	        document.getElementById('sky').textContent = "U2F failed with error: " + data.errorCode; //No I18N
	    } else {
	        data.value=JSON.stringify(data);
	        params = "appId="+ euc(data.appId)+"&challenge="+ euc(data.challenge)+"&clientData="+ euc(data.clientData)+"&registrationData="+ euc(data.registrationData)+"&yubName="+yubName+"&"+csrfParam; //No I18N
	        var resp = getPlainResponse('/tfapref/yubikey/register',params); //No I18N
	        if(resp!=null){
	        	var obj = JSON.parse(resp);
	        	if(obj.status=="success"){
	        		$('#second').removeClass('selected selected-verify').addClass('active-verify');//No I18N
	        		$('#secondtext').removeClass('selectedtext').addClass('unselectedtext');//No I18N
	    			$('#third').removeClass('unselected unselected-confirm').addClass('selected-confirm');//No I18N
	    			$('#thirdtext').removeClass('unselectedtext').addClass('selectedtext');//No I18N
	    			$('#verifyphdiv').hide();//No I18N
	    			$('#yuverify').hide();//No I18N
	    			$('#getpassword').show();//No I18N
	    			de('enabletfa').focus(); //No i18N
	        	}/*else{
	        		//show error
	        	}*/
		        
	        }
	        else{
	        	document.getElementById('sky').textContent = "Error Occured"; //No I18N
	        }
	        	
	    }
	}
    
}

function showYubikeyVerify() {
	$('#first').removeClass('selected selected-setup').addClass('active-setup');//No I18N
	$('#firsttext').removeClass('selectedtext').addClass('unselectedtext');//No I18N
	$('#yubikey').hide();//No I18N
	$('#resendCode').hide();
	$('#yudevname').hide();//No I18N
	$('#yuverify').show();//No I18N
	var resp = getPlainResponse('/tfapref/yubikey/challenge',csrfParam); //No I18N
	if(resp != null){
		var obj = JSON.parse(resp);
		u2f.register(obj.appId,[obj],[],registerYK,3000);
	}
}

function setYubName(){
	$('#first').removeClass('selected selected-setup').addClass('active-setup');//No I18N
	$('#firsttext').removeClass('selectedtext').addClass('unselectedtext');//No I18N
	$('#second').removeClass('unselected-verify unselected').addClass('selected-verify');//No I18N
	$('#secondtext').removeClass('unselectedtext').addClass('selectedtext');//No I18N
	if(document.getElementById('yuname').value!=""){
		yubName= document.getElementById('yuname').value;
	}else{
		showTFAErrorMsg("yuname",yu_err_valid_name);//No i18N
		return;
	}
	//dont know whether it is need or what since we are using only one yubikey support
	//since we'll support two or more in new ui no need to check here
	var resp = getPlainResponse('/tfapref/yubikey/challenge',"yubName="+yubName+"&"+csrfParam); //No I18N
	var obj = JSON.parse(resp);
	var result = obj.result;
	if(result == "SUCCESS"){
		$('#first').removeClass('selected selected-setup').addClass('active-setup');//No I18N
		$('#firsttext').removeClass('unselectedtext').addClass('selectedtext');//No I18N
		$('#yudevname').hide();
		$('#yubretrybtn').hide();
		$('#regierr').hide();
		$('#yubikey').show();
		$('#yubretrybtn').delay(5000).fadeIn(1000);
		$('#regierr').delay(12000).fadeIn(1000);
		isWentBack=false;
		showYubikeyVerify();
	}else { //No I18N
        showTFAErrorMsg("yuname",yu_err_alredy_exist);//No i18N
        return;
	}
}

function setTFAValue(countryCode,mobile,isUnAuthenticatedPage){
	try
	{
	if(isUnAuthenticatedPage == 'true') {
		if(de('authmodepref'))
		{
			de('authmodepref').checked = true; //No I18N
		}
	}else if(showTFAPref == 'true'){
		if(mobile != "null" && mobile !="") { //No i18N
			if(de('contNameprefAdd')) {
				de('contNameprefAdd').value = countryCode;  //No I18N
			}
			if(de('prefmob')) {
				de('prefmob').value = mobile; //No i18N
			}
		}
	}else if(mobile != "null" && mobile !="") { //No i18N
		if(de('contNameprefAdd')) {
			de('contNameprefAdd').value = countryCode;  //No I18N
		}
		if(de('prefmob')) {
			de('prefmob').value = mobile; //No i18N
		}
		if(de('authmodepref'))
		{
			de('authmodepref').checked = true; //No I18N
		}
	}
	}catch(e)
	{
		alert(e);
		
	}
}

function validateMobile(val){
	var regex = /^\d{5,14}$/; //No I18N
	if(val.search(regex) == -1){
		return false; //No I18N
	}
	return true; //No I18N
}

function checkRadioandChangeButton(option) {
	if(option == "prefaddsms") {
		de('callme').style.display = "none";
		de('textme').style.display = "";
	}else {
		de('textme').style.display = "none";
		de('callme').style.display = "";
	}
	checkRadioButtonStatus(option);
}

/******************************TFA Preference*******************************/
function gotoSetUpPage(option){
	if($('[name=changeprefradio]:checked').val() === option) {
		return;
	}
	
	loadui('/ui/settings/tfasetup.jsp'); //No i18N
	if(option === 'prefsmscall') {
		checkradioandChangeClass('smsmodepref'); //No i18N
	}
}

function disableTFA(){
	var pass = de('tfapass').value.trim(); //No I18N
	if(pass==""){
		showTFAErrorMsg("tfapass",err_invalid_password);  //No I18N
		de('tfapass').focus(); //No I18N
		return;
	}
	params = "password="+ euc(pass) +"&"+csrfParam; //No I18N
	var resp = getPlainResponse("/tfapref/deactivate",params); //No I18N
	resp = resp.trim();
	if (resp == "SUCCESS") { //No I18N
		popup('hide','disable_confirm_popup'); //No I18N
		showTFAPref = "false";
		tfaenabled = -1;
		$('#disablesuccessbutton').focus();
		loadui((showTFAPref === 'true') ?'/ui/settings/tfapreference.jsp':'/ui/settings/tfasetup.jsp'+(fromService ? '?service=true' : ''));//no i18n
	}else if(resp == "invalid_password"){ //No I18N
		showTFAErrorMsg("tfapass",err_invalid_password); //No I18N
		de('tfapass').value = ""; //No I18N
		de('tfapass').focus(); //No I18N
	} else if(resp == "update_not_allowed"){ //No I18N
		showTFAErrorMsg("tfapass",update_not_allowed); //No I18N
		popup('hide','tfapassword_popup'); //No I18N
		return;
	}else if(resp == "ro_update_not_allowed"){ //No I18N
		showTFAErrorMsg("tfapass",write_operation_not_allowed);//No I18N
		return;
	}else if(resp == "err_tfa_remote_ip_lock"){//No I18N
		showTFAErrorMsg("tfapass",err_tfa_remote_ip_lock);//No I18N
	}else{
		showTFAErrorMsg("tfapass",err_cnt_error_occurred); //No I18N
	}
}
function disableMFA(){
	var pass = de('tfapass').value.trim(); //No I18N
	if(pass==""){
		showTFAErrorMsg("tfapass",err_invalid_password);  //No I18N
		de('tfapass').focus(); //No I18N
		return;
	}
	params = "password="+ euc(pass) +"&"+csrfParam; //No I18N
	var resp = getPlainResponse("/tfapref/mfa/deactivate",params); //No I18N
	resp = resp.trim();
	var obj = JSON.parse(resp);
  	if (obj.status == "success") {
		$("#disable_confirm_popup .contentpadding").hide();
		disableApproved = setInterval(function () {isDisableApproved();}, 40000);
		$(".showmfaicons").show();
		showsuccessmsg(iam_push_notify_success);
	}
	else if(obj.status == "invalid_password"){ //No I18N
		showTFAErrorMsg("tfapass",err_invalid_password); //No I18N
		de('tfapass').value = ""; //No I18N
		de('tfapass').focus(); //No I18N
	} else if(obj.status == "update_not_allowed"){ //No I18N
		showTFAErrorMsg("tfapass",update_not_allowed); //No I18N
		popup('hide','tfapassword_popup'); //No I18N
		return;
	}else if(obj.status == "ro_update_not_allowed"){ //No I18N
		showTFAErrorMsg("tfapass",write_operation_not_allowed);//No I18N
		return;
	}else{
		showTFAErrorMsg("tfapass",err_cnt_error_occurred); //No I18N
	}
}
function generateRecoveryCode(userFullName){
	// IMPORTANT : Same JS method used in TFA Recovery update(in announcement) also. So, check there also before any changes done. 
	// DOM alone replicated outside in this case.
	de("gen_new_button").innerHTML = err_generating_new; //No I18N
	sendRequestWithCallback("/p/genbackup","&"+csrfParam,true, //No I18N
	function(resp) {
		de("gen_new_button").innerHTML = err_generate_new; //No I18N
		if(!IsJsonString(resp)) {
			if(resp == "ro_update_not_allowed"){ //No I18N
				de('generrordiv').style.display = ""; //No i18N
				de('generrordiv').innerHTML = write_operation_not_allowed; //No i18N
				return;
			}else{
				de('generrordiv').style.display = ""; //No i18N
				de('generrordiv').innerHTML = err_cnt_error_occurred; //No i18N
				return;	
			}
		}
		de('generrordiv').style.display = "none"; //No i18N
		obj = $.parseJSON(resp);
		var result = obj.result;
		if(result == "success"){
			var codes = obj.recoveryCode;
			var recoverycodes = codes.split(":");
			var createdtime = obj.createdtime;
			var res ="<ol>"; //No I18N
			var recCodesForPrint = "";
			for(idx in recoverycodes){
				var recCode = recoverycodes[idx];
				if(recCode != ""){
					res += "<li><b><span style='margin-left:5px'>"+recCode.substring(0, 4)+"</span><span style='margin-left:5px'>"+recCode.substring(4, 8)+"</span><span style='margin-left:5px'>"+recCode.substring(8) + "</span></b></li>"; //No I18N
					recCodesForPrint += recCode + ":";
					
				}
			}
			recCodesForPrint = recCodesForPrint.substring(0, recCodesForPrint.length -1); // Remove last ":"
			$("#printcodesbutton").attr('onclick','').unbind('click');
			$("#printcodesbutton").click(function(){ 
				printDoc(userFullName,recCodesForPrint);
			});
			
			res += "</ol>";
			de('displaycode').innerHTML = res; //No i18N
			de('createdtime').innerHTML = createdtime; //No i18N
		}else{
			de('generrordiv').style.display = ""; //No i18N
			de('generrordiv').innerHTML = err_cnt_error_occurred; //No i18N
		}
	});
}

function showAlertBox(msg) {
	de('alertBoxmsg').innerHTML=msg;//No I18N
	popup("show","alert_popup");//No I18N
	de('proceedbutton').focus(); //No I18n
}

function deletePrimaryMobile(mobile) {
	var pass = de('tfaph_rem_pass').value.trim(); //No I18N
	if(pass==""){
		showTFAErrorMsg("tfaph_rem_pass",err_invalid_password);  //No I18N
		return;
	}
	params = "password="+ euc(pass) +"&mobile="+ mobile +"&"+csrfParam; //No I18N
	var resp = getPlainResponse("/p/delete",params); //No I18N
	resp = resp.trim();
	if(resp == "success") { //No I18N
		popup('hide','tfapassword_popup'); //No I18N
		showTFAPref = 'false';
		tfaenabled = -1;
		loadui((showTFAPref === 'true') ?'/ui/settings/tfapreference.jsp':'/ui/settings/tfasetup.jsp'+(fromService ? "?service=true" : "")); //No I18N
		return;
	}else if(resp == "ro_update_not_allowed"){ //No I18N
		showTFAErrorMsg("tfaph_rem_pass",write_operation_not_allowed);//No I18N
		return;
	}else if(resp == "update_not_allowed"){ //No I18N
		showTFAErrorMsg("tfaph_rem_pass",update_not_allowed);//No I18N
		return;
	}else if(resp =="invalid_password"){//No I18N
		showTFAErrorMsg("tfaph_rem_pass",err_invalid_password);//No I18N
		return;
	}
	showTFAErrorMsg("tfaph_rem_pass",err_cnt_error_occurred); //No i18N
}

function generateAppPassword(){
	var label = de('applabel').value.trim(); //No i18N
	if(label == ""){
		showTFAErrorMsgNew("messagepanel",err_enter_valid_label); //No i18N
		$('#applabel').focus();
		return;
	}
	if(validatelabel(label) != true) {
		showTFAErrorMsgNew("messagepanel",err_invalid_label); //No i18N
		$('#applabel').focus();
		return;	
	}

	if(label.length > 45){
		showTFAErrorMsgNew("messagepanel",err_label_length_exceeded); //No i18N
		$('#applabel').focus();
		return;
	}
	pass = de('passapp').value.trim(); //No i18N
	if(pass==""){
		showTFAErrorMsgNew("messagepanel",err_invalid_password); //No i18N
		$('#passapp').focus();
		return;
	}

	var param = "password="+euc(pass)+"&keylabel="+euc(label)+"&"+csrfParam; //No I18N
	de('generateButton').innerHTML = err_generating; //No I18N
	sendRequestWithCallback("/tfapref/apppwd/generate", param, true, //No I18N 
	function(resp){
		de('generateButton').innerHTML = err_generate; //No I18N
		if(!IsJsonString(resp)){
			if(resp == "ro_update_not_allowed"){ //No I18N
				showTFAErrorMsgNew("messagepanel",write_operation_not_allowed);//No I18N
				$('#applabel').focus();
				return;
			}else{
				showTFAErrorMsgNew("messagepanel",err_cnt_error_occurred); //No i18N
				$('#applabel').focus();
				return;	
			}
		}

		var obj = $.parseJSON(resp);
		var result = obj.result;
		if(result == "success"){
			var password = obj.password;
			loadui((showTFAPref === 'true') ?'/ui/settings/tfapreference.jsp':'/ui/settings/tfasetup.jsp'); //No I18N
			popup("show","manageapp_popup"); //No i18N
			var displayPass = "<span>"+password.substring(0, 4)+"</span>"+"<span style='margin-left:5px'>"+password.substring(4, 8)+"</span>"+"<span style='margin-left:5px'>"+password.substring(8)+"</span>"; //No I18N
			de('displaypass').innerHTML = displayPass; //No I18N
			de('displaypassmsg').innerHTML = formatMessage(err_password_message,label); //No i18N
			de('showpassdiv').style.display="";
			$('#applabel').focus();
			return;
		}else if(result == "keylabel_exists"){  //No I18N
			showTFAErrorMsgNew("messagepanel",err_label_exist); //No i18N
			$('#applabel').focus();
			return;
		}else if(result == "invalid_password"){ //No I18N
			showTFAErrorMsgNew("messagepanel",err_invalid_password); //No i18N
			$('#passapp').focus();
			return;
		}else if(result == "limit_exceeded"){ //No I18N
			showTFAErrorMsgNew("messagepanel",err_tfa_limit_exceeded); //No i18N
			$('#passapp').focus();
			return;
		}
		showTFAErrorMsgNew("messagepanel",err_cnt_error_occurred); //No i18N
	});
}

function validatelabel(val){
	var regex = /^[0-9a-zA-Z_\s\-\.\$@\?\,\:\'\/\!]+$/; //No I18N
	if(val.search(regex) == -1){
		return false; //No I18N
	}
	return true; //No I18N
}

function deleteTFATicket(ticket, closeAll,listsize,eleId) {
	var param = "";
	if(closeAll) {
		param += "closeall=true"; //No I18N
	}
	else {
		param += "closeall=false"; //No I18N
	}
	param += "&closeticket="+euc(ticket)+"&"+csrfParam; //No I18N
	var resp = getPlainResponse("/tfapref/sessions", param); //No I18N
	if(resp.trim() == "SUCCESS") {
		loadui((showTFAPref === 'true') ?'/ui/settings/tfapreference.jsp':'/ui/settings/tfasetup.jsp'); //No I18N
		popup('show','managetfasessions_popup'); //No i18N
	} else if(resp == "ro_update_not_allowed"){ //No I18N
		if(closeAll){
			for(var i=1;i<=listsize;i++) {
				de("ticket"+i).style.color="#CDCDCD";
				showTFAErrorMsg("ticket"+i,write_operation_not_allowed);//No I18N
			}
		}else{
			de(eleId).style.color="#CDCDCD";
			showTFAErrorMsg(eleId,write_operation_not_allowed);//No I18N
			return;	
		}
	}else {
		if(closeAll) {
			for(var j=1;j<=listsize;j++) {
				de("ticket"+j).style.color="#CDCDCD";
				showTFAErrorMsg("ticket"+j,err_cnt_error_occurred);//No I18N
			}
		}else{
			de(eleId).style.color="#CDCDCD";
			showTFAErrorMsg(eleId,err_cnt_error_occurred);	
		}
	}
	return;
}


function removeAppPassword(label,pwdid,eleId){
	var param = "&pwdid="+pwdid+"&"+csrfParam; //No I18N
	var resp = getPlainResponse("/tfapref/apppwd/revoke", param); //No I18N
	if(resp == "success"){
		loadManageApp();
	}else if(resp == "ro_update_not_allowed"){ //No I18N
		de(eleId).style.color="#CDCDCD";
		showTFAErrorMsg(eleId,write_operation_not_allowed);//No I18N
		return;
	}else{
		de(eleId).style.color="#CDCDCD";
		showTFAErrorMsg(eleId,err_cnt_error_occurred);
	}
}

function popup(func,divEleName) {
	if(func == "show") {
		document.getElementById('tfaopacity').setAttribute('data-name', divEleName);
		$("#"+divEleName).show();
		de('tfaopacity').style.display=''; //No I18N
		if(de('bknumverdiv')) {
			hideBackUpNumbers();
		}
		if(de('bkdevicediv')) {
			hideBackUpDevices();
		}
	} else {
		$('#'+divEleName).hide();
		document.getElementById('tfaopacity').removeAttribute('data-name');
		de('tfaopacity').style.display='none'; //No I18N
	}
}

function closeDiv() {
	var divEleName = document.getElementById('tfaopacity').getAttribute('data-name'); //No I18N
	if(divEleName === "disablemsgpopup") {
		return;
	}
	popup("hide",divEleName); //No I18N	
	if(divEleName == "manageapp_popup") {
		$('div#displaypass').html('');//No I18N
		$('#showpassdiv').hide();
		$('#applabel').siblings('.error').hide(); 
		de('applabel').value=""; 
		$('#passapp').siblings('.error').hide();
		de('passapp').value="";
		$('#appwdtable').hide();
		$('#showapppwdLink').show();
		if(de('appwdno') != null){
			var appwdsize = de('appwdno').value;//No i18N
			for(var i=1;i<=appwdsize;i++){
				de('pwd'+i).style.color="#1155CC";
				$('#pwd'+i).siblings('.error').hide();
			}
		}
	}else if(divEleName == "tfapassword_popup") {//No I18N
		$('#tfaph_rem_pass').siblings('.error').hide(); 
		de('tfaph_rem_pass').value='';//No I18N
	}else if(divEleName == "password_popup") {//No I18N
		$('#pass_confirm').siblings('.error').hide(); 
		de('pass_confirm').value='';//No I18N
	}else if(divEleName == "alert_popup"){ //No I18N
		de('alertBoxmsg').innerHTML="";//No I18N
	}else if(divEleName == "managereccodes_popup") { //No I18N
		de('generrordiv').style.display = "none"; //No i18N
	}else if(divEleName == "managetfasessions_popup"){ //No i18N
		var size = de('size').value;//No i18N
		for(var j=1;j<=size;j++){
			$('#ticket'+j).siblings('.error').hide();
			de('ticket'+j).style.color="#1155CC";
		}
	}else if(divEleName == "phonenumbers_popup") { //No i18N
		de('verifyphNoDiv').style.display = "none";
		de('addphNoDiv').style.display = "";
		de('codeSentMsg').value = "";
		de("mobileno").value = ""; //No i18N
		$("#mobileno").siblings('.error').hide();
		de("vcode").value = ""; //No i18N
		$("#vcode").siblings('.error').hide();
		de("phpass_tfapref").value = ""; //No i18N
		$("#phpass_tfapref").siblings('.error').hide();
		checkRadioandChangeButton("prefaddsms"); //No i18N
		if($('#selectexisting').length){
			$('.tfa_popup_content').show();
			$('#addphNoDiv').hide();	
		}
	} else if(divEleName == "disable_confirm_popup"){ //No I18N
		$(".showmfaicons").hide();
		$("#disable_confirm_popup .contentpadding").show();
		$('#tfapass').val('').siblings('.error').hide();
	} else if(divEleName == "sendbkp_email_popup"){ //No I18N
		popup('hide','sendbkp_email_popup'); //No I18N
		$('#pref_recovery_email').val('').siblings('.error').hide();
		$('#pref_recovery_pass').val('').siblings('.error').hide();
		popup('show','managereccodes_popup'); //No I18N
	} else if(divEleName == "bkp_email_popup") { //No I18N
		$('#recovery_email').val('').siblings('.error').hide();
		$('#recovery_pass').val('').siblings('.error').hide();	
	}
}

function loadManageApp(){
	loadui((showTFAPref === 'true') ?'/ui/settings/tfapreference.jsp':'/ui/settings/tfasetup.jsp'); //No I18N
	popup("show","manageapp_popup"); //No i18N
	$('#appwdtable').show();
	$('#showapppwdLink').hide();
}

function toggleElement(id) {
	$('#'+id).slideToggle(function(){
		de(id).scrollIntoView(); //No I18N
	});
}

function phoneOperation(operation,phoneNo) {
	popup('show','tfapassword_popup'); //No i18N
	$('#confirmbutton').unbind('click');
	$('#tfaph_rem_pass').unbind("keyup");
	
	if(operation == "del_prim") {
		de('warnmsg').innerHTML = formatMessage(err_tfadeletion_warning_msg,phoneNo); //No I18N
		de('prim_msg').style.display="none";
		$("#confirmbutton").click(function() {
			deletePrimaryMobile(phoneNo);
		});
		$('#tfaph_rem_pass').keyup(function(event) {
			$(this).siblings('.error').hide();
			if(event.keyCode == 13) {
				deletePrimaryMobile(phoneNo);				
			}
		});
	}else if(operation == "del_back") { //No i18N
		de("warnmsg").innerHTML= formatMessage(err_backup_warn,phoneNo); //No I18N
		de('prim_msg').style.display="none";
		$("#confirmbutton").click(function() {
			deleteBackupMobile(phoneNo);
		});
		$('#tfaph_rem_pass').keyup(function(event) {
			$(this).siblings('.error').hide();
			if(event.keyCode == 13) {
				deleteBackupMobile(phoneNo);				
			}
		});
		if($('#bknumverdiv')) {
			hideBackUpNumbers();
		}
	}else if(operation == "chan_prim") { //No I18N
		de("warnmsg").innerHTML=formatMessage(err_mkp_msg,phoneNo); //No I18N
		de('prim_msg').style.display="";
		$("#confirmbutton").click(function() {
			changePrimary(phoneNo);
		});
		$('#tfaph_rem_pass').keyup(function(event) {
			$(this).siblings('.error').hide();
			if(event.keyCode == 13) {
				changePrimary(phoneNo);				
			}
		});
		if($('#bknumverdiv')) {
			hideBackUpNumbers();
		}
	}
	de('tfaph_rem_pass').focus(); //No I18N
}

function hideErrordiv(element) {
	if(element.previousSibling !=null && element.previousSibling.className == 'error_top') {
		element.previousSibling.style.display = "none";
	}
}

function getScrollbarWidthandPrefValue(appwdsize,sessionsize) 
{
	var div = $('<div style="width:50px;height:50px;overflow:hidden;position:absolute;top:-200px;left:-200px;"><div style="height:100px;"></div></div>'); 
	$('body').append(div); 
	var w1 = $('div', div).innerWidth(); 
	div.css('overflow-y', 'auto'); //No I18N 
	var w2 = $('div', div).innerWidth(); 
	$(div).remove(); 
	var width = w1 - w2;
	if(appwdsize > 3 && width > 0) {
		var alteredWidth = 201 - width;
		$('.alterpass').width(alteredWidth);
	}
	if(sessionsize > 7 && width > 0) {
		var alteredWidth = 154 - width;
		$('.altersess').width(alteredWidth);
	}
	de('tfaopacity').setAttribute("onclick", "closeDiv()");
	//$('#disablescrolldiv').disableSelection();
	return;	
}

function showTFAElementSuccessMsg(elementName,msg) {
	var position =  $("#"+elementName).position();
	var element = $("#ele_successmsg_top");
	element.css({top: position.top - 36, left: position.left + 8});
	de('ele_successcontent').innerHTML = msg; //No I18N
	element.show();
	setTimeout(function(){
		element.fadeOut();
	},3000);

	$("#overflowdiv").scroll(function(){
		element.fadeOut();
	});

	setTimeout(function(){
		$("#overflowdiv").unbind('scroll');
	},5000);
}

function showTFAPopupMsg(msg) {
	de('msgpopup_panel').innerHTML = msg; //No I18N
	var msgDiv = $('#msgpopup_div'); 
	msgDiv.show();
	msgDiv.fadeOut(3000);
}

function tfaredirect(serviceUrl) {
	getPlainResponse("redirect", "&" + csrfParam); //No i18N
	window.parent.location.href = serviceUrl;
	return;
}

/***************** TFA  Configure Page ************************/
function gotostep(stepnumber) {
	var configure_step = "configure-" + stepnumber; //No i18N
	$('#stepcontainer').addClass(configure_step);
	de('bodycontainer').className = stepnumber;
	if(stepnumber==="s2"){
		$("#first-s1").removeClass('progress-s1');
		$("#first-s2").addClass('progress-s1');
	}
	if(stepnumber==="s3"){
		$("#first-s2").removeClass('progress-s1');
		$("#first-s3").addClass('progress-s1');	
	}
	setWindowCloseEvent();
}

function goback(stepnumber) {
	var currentstep = stepnumber + 1;
	var remove_configure_step = "configure-s" + currentstep; //No i18N
	de('bodycontainer').className = "s" + stepnumber;
	if(stepnumber==1){
		$("#first-s1").addClass('progress-s1');
		$("#first-s2").removeClass('progress-s1');
	}if(stepnumber===2){
		$("#first-s2").addClass('progress-s1');
		$("#first-s3").removeClass('progress-s1');
	}
	$('#stepcontainer').removeClass(remove_configure_step);
}

var saved_backup_codes = false;
function validateBackup() {
	if(saved_backup_codes) {
		gotostep('s3'); //No i18N
	}else {
		popup('show', 'backup_codes'); //No i18N
	}
}

function addBackupMobile(tfaNumber){
	$('#addph_gen_err').hide();
	$('#backup_phno').attr("placeholder", err_enter_verification_code);
	
	var mobVal = de('backup_phno').value.trim();  //No I18N
	if(mobVal === ""){
		showTFAErrorMsgNew('addph_gen_err', err_enter_valid_mobile); //No I18N
		de('backup_phno').focus(); //No I18N
		return;
	}
	if(mobVal == tfaNumber){
		showTFAErrorMsgNew('addph_gen_err', err_mobile_already_configured_for_tfa_short); //No I18N
		de('backup_phno').focus(); //No I18N
		return;
	}
	var countryCode = de('cont_name_bkp').value.trim(); //No I18N
	var option = $('input[name=backup_config]').length ? $("input[name=backup_config]:checked").val() : 1;//No I18N
	
	if(validateMobile(mobVal) !== true) {
		showTFAErrorMsgNew('addph_gen_err', err_enter_valid_mobile); //No I18N
		de('backup_phno').focus(); //No I18N
		return;	
	} 
	var _p = "mobile="+euc(mobVal)+"&countrycode="+euc(countryCode)+"&verifytype="+option+"&"+csrfParam; //No I18N
	var resp = getPlainResponse("/p/update", _p); //No I18N
	resp = resp.trim();
	if(IsJsonString(resp)){
		var obj = JSON.parse(resp);
		showTFAErrorMsgNew("addph_gen_err",obj.message);//No I18N
		return;
	}
	if(resp === "success") {//No I18N
		var dialingCode = isdCodes[countryCode];
		var displayPhone = "(+"+dialingCode+")"+" "+ mobVal;
		de('phonediv').className = "verph";
		if(option === "2") {
			de('configure_verifymsg').innerHTML = formatMessage(err_verify_call_message,displayPhone); //No i18N
		}else {
			de('configure_verifymsg').innerHTML = formatMessage(err_verify_sms_message,displayPhone);	//No i18N		
		}
		de('backup_ver').focus();//No I18N
		$('#backup_phno').attr("placeholder", err_enter_verification_code);
		return;
	}else if(resp === "EXIST") { //No I18N
		showTFAErrorMsgNew('addph_gen_err', err_mobile_already_exist); //No I18N
		de('backup_phno').focus(); //No I18N
	}else if(resp === "invalid_mobile"){  //No I18N
		showTFAErrorMsgNew('addph_gen_err', err_enter_valid_mobile); //No I18N
		de('backup_phno').focus(); //No I18N
	}else if(resp == "err_phone_unverified_block"){//No I18N
		showTFAErrorMsgNew('addph_gen_err',err_phone_unverified_block);//No I18N
	}else if(resp === "NOT_EXIST"){ //No I18N
		showTFAErrorMsgNew('addph_gen_err', formatMessage(err_old_mob_nt_exist,oldMobile)); //No I18N
		de('backup_phno').focus(); //No I18N
	}else if(resp === "ro_update_not_allowed"){ //No I18N
		showTFAErrorMsgNew('addph_gen_err', write_operation_not_allowed); //No I18N
		de('backup_phno').focus(); //No I18N
	}else if(resp === "EXIST_IN_ORG") { //No I18N
		showTFAErrorMsgNew('addph_gen_err', err_exist_in_org); //No I18N
		de('backup_phno').focus(); //No I18N
	}else if(resp === "err_tfa_remote_ip_lock"){ //No I18N
		showTFAErrorMsgNew('addph_gen_err', err_tfa_remote_ip_lock); //No I18N
	}else if(resp == "err_phone_max_linked_block"){//No I18N
		showTFAErrorMsgNew("addph_gen_err",err_phone_max_linked_block);//No I18N
	}else if(resp == "err_already_configured_mobile"){//No I18N
		showTFAErrorMsgNew("addph_gen_err",err_already_configured_mobile);//No I18N
	}else {
		$('#addph_gen_err').html("&nbsp;" +err_cnt_error_occurred + "&nbsp;").show(); //No I18N
		return;
	}
}


function resendBackupPhoneCode(){
	var mobVal= de('backup_phno').value.trim(); //No I18N
	var countryCode = de('cont_name_bkp').value; //No I18N
	var errorJson = {};
	if(mobVal === ""){ //No I18N
		return;
	}
	if(validateMobile(mobVal) !== true) {
		errorJson.backup_ver = err_enter_valid_mobile;
		showConfigureError(errorJson);
		return;
	}
	var resp = getPlainResponse("/p/resend","mobile="+mobVal+ "&"+ csrfParam); //No I18N
	resp = resp.trim();
	if(IsJsonString(resp)){
		var obj = JSON.parse(resp);
		showerrormsg(obj.message); 
		return;
	}
	if(resp === "success") { //No I18N
		var dialingCode = isdCodes[countryCode];
		var displayPhone = "(+"+dialingCode+")"+" "+ mobVal; //No I18N
		de('configure_verifymsg').innerHTML = formatMessage(err_verify_code_resent, displayPhone); //No i18N
		de('backup_ver').focus();//No I18N
	}else if(resp === "ro_update_not_allowed"){ //No I18N
		$("#backup_ver").animate({width:"240px"},200);
		errorJson.backup_ver = write_operation_not_allowed;
		showConfigureError(errorJson);
	} else{
		errorJson.backup_ver = err_cnt_error_occurred;
		showConfigureError(errorJson);
	}
}

function showConfigureError(errorJson) {
	if(errorJson !== null) {
		var clearError = function(event) {
			if($(this).val().trim() === "") {
				$(this).attr('class', 'configure_err');
			}else{
				$(this).attr('class', 'unauthinputText');	
			}
		};
		for( var key in errorJson) {
			$('#' + key).attr('class', 'configure_err');
			$('#' + key).attr("placeholder", errorJson[key]);
			$('#' + key).val("").focus();
			$('#' + key).unbind("keyup");
			$('#' + key).keyup(clearError);
		}			
	}
}

function verifyBackupPhone() {
	$('#verph_gen_err').hide();
	$('#backup_ver').attr("placeholder", err_enter_verification_code);
	$('#configure_pass').attr("placeholder", err_enter_password);
	
	var code = $('#backup_ver').val().trim(); //No I18N
	var errorJson = {};

	if(isEmpty(code) || isNaN(code)) {
		showTFAErrorMsgNew('verph_gen_err', err_invalid_verify_code); //No I18N
		$('#backup_ver').focus(); //No I18N
		return;
	}
	var password = $("#configure_pass").val().trim();
	if(password === "") {
		showTFAErrorMsgNew('verph_gen_err', err_invalid_password); //No I18N
		$("#configure_pass").focus(); //No I18N
		return;
	}
	
	var mobileVal = $('#backup_phno').val().trim(); //No I18N
	var _p = "code="+euc(code)+"&password="+ euc(password)+"&mobile="+mobileVal+"&"+csrfParam; //No I18N
	var resp = getPlainResponse("/p/verify", _p); //No I18N
	resp = resp.trim();
	if(resp === "success") { //No I18N
		gotostep('s2'); //No I18N
		cancelOper();
		return;
	}else if(resp === "NOT_EXIST"){  //No I18N
		$("#backup_ver").animate({width:"260px"},200);
		showTFAErrorMsgNew('verph_gen_err', formatMessage(err_old_mob_nt_exist,old_mobile)); //No I18N
		return;
	}else if(resp === "invalid_password"){ //No I18N
		showTFAErrorMsgNew('verph_gen_err', err_invalid_password); //No I18N
		$("#configure_pass").focus(); //No I18N
		return;
	}else if(resp === "ro_update_not_allowed"){ //No I18N
		showTFAErrorMsgNew('verph_gen_err', write_operation_not_allowed); //No I18N
        return;
    }else if(resp === "invalid_code") { //No i18N
    	$('#configure_pass').val('');
    	showTFAErrorMsgNew('verph_gen_err', err_invalid_verify_code); //No I18N
		return;
	}else {
		$('#verph_gen_err').html("&nbsp;" + err_cnt_error_occurred + "&nbsp;").show(); //No i18N
		return;
	}
}

function cancelOper() {
	$('#backup_ver').attr('placeholder', err_enter_verification_code).val('').removeClass('configure_err').unbind("keyup");
	$('#configure_pass').attr('placeholder', err_enter_password).val('').removeClass('configure_err').unbind("keyup");
	de('phonediv').className='addph'; //No i18N
	$('#backup_phno').attr('placeholder', err_enter_phone_number).val('').removeClass('configure_err').unbind("keyup");
	$('#backup_phno').focus(); //No i18N
}

function redirectService(isUnAuthenticatedPage) {
	$(window).unbind('beforeunload');
	if(isUnAuthenticatedPage) {
		var res = getPlainResponse("/tfa/redirect","&"+csrfParam); //No I18N
		if(res.indexOf("switchto") !== -1 || res.indexOf("showsuccess") !== -1) {
			new Function( 'return ' + res)(); // jshint ignore:line
			return;
		}
	}else {
		loadui((showTFAPref === 'true') ?'/ui/settings/tfapreference.jsp':'/ui/settings/tfasetup.jsp'+ (fromService ? "?service=true" : "")); //No I18N		
	}
}

function printDoc(userName,codes) {
	var recoverycodes = codes.split(":");
	saved_backup_codes=true;
	var html = "<body><div style='font-size: 20px;'>" + err_backup_verification_codes + "&nbsp;-&nbsp;"+ userName + "</div>";
	html += "<div style='background-color: #EEECED;border: 1px solid #E1E1E1;padding: 4px;width: 220px;margin-top:10px;'>";
	html +="<ol style='line-height:25px;'>"; //No I18N
	if(recoverycodes !== null) {
		for(idx in recoverycodes) {
			var recCode = recoverycodes[idx];
			if(recCode !== ""){
				html += "<li><b><span style='margin-left:5px'>"+recCode.substring(0, 4)+"</span><span style='margin-left:5px'>"+recCode.substring(4, 8)+"</span><span style='margin-left:5px'>"+recCode.substring(8) + "</span></b></li>"; //No I18N
			}
		}		
	}
	html += "</ol></div>";
	html += "<div style='margin-top:20px;font-size:12px;'>" + err_backup_recommend_notes + "</div>"; 
	var printWindow = window.open('printdoc.html', saveTxtParams.printcodes.tagetWindowName, 'letf=0,top=0,width=400,height=400,toolbar=0,scrollbars=0,status=0');
	printWindow.document.write(html);
	printWindow.document.close();
	printWindow.focus();
	printWindow.print();
	saveCodes('printcodes'); //No i18N
}

var saveTxtParams = {
	savetxt : {
		option : 1,
		tagetWindowName : "savetxtwindow" //No I18N 
	},
	printcodes : {
		option : 2,
		tagetWindowName : "printwindow" //No I18N
	},
	sendemail : {
		option : 3,
		tagetWindowName : "sendemailwindow", //No I18N
		validate : function() {
			return validateEmailField();
		}
	}
};

function saveAsText() {
	saveCodes('savetxt'); //No I18N
}


function sendBackupCodesEmail(type) {
	// IMPORTANT : Same JS method used in TFA Recovery update(in announcement) also. So, check there also before any changes done. 
	// DOM alone replicated outside in this case.
	var ele_id = (type === "setup") ? "recovery_email" : "pref_recovery_email"; //No I18N
	var email_id = $('#' + ele_id).val().trim();
	if(!isEmailId(email_id)) {
		showTFAErrorMsg(ele_id, err_validemail);
		de(ele_id).focus(); //No I18N
		return;
	}
	
	var pass_id = (type === "setup") ? "recovery_pass" : "pref_recovery_pass"; //No I18N
	var pass = $('#' + pass_id).val().trim();
	if(pass==""){
		showTFAErrorMsg(pass_id, err_invalid_password);
		de(pass_id).focus(); //No I18N
		return;
	}
	
	var params = "&email=" + euc(email_id.toLowerCase()) + "&pass=" + euc(pass) + "&savepref=3" + "&" + csrfParam; //No I18N
	var res = getPlainResponse("/tfapref/savetext", params); //No i18N
	if(res === "success") {
		saved_backup_codes=true;
		if(type === "setup") {
			popup('hide','bkp_email_popup'); //No I18N
			$(ele_id).val('').siblings('.error').hide();
			$(pass_id).val('').siblings('.error').hide();
			showTFAPopupMsg(err_tfa_bkp_email_success);	
		} else {
			showTFAPopupMsg(err_tfa_bkp_email_success);
			closeDiv();
		}
	} else if(res == "invalid_password"){ //No I18N
		showTFAErrorMsg(pass_id, err_invalid_password);
		de(pass_id).focus(); //No I18N
		return;
	} else if(res === "curr_user_email") { //No i18N
		showTFAErrorMsg(ele_id, err_tfa_bkp_email);
		de(ele_id).focus(); //No I18N
		return;
	} else if(res === "blocked_domain") { //No i18N
		showTFAErrorMsg(ele_id, err_blocked_domain);
		de(ele_id).focus(); //No I18N
		return;
	} else {
		showTFAErrorMsg(ele_id, err_cnt_error_occurred);
		de(ele_id).focus(); //No I18N
		return;
	}	
}

function saveCodes(preference) {
	saved_backup_codes=true;
	var csrf = csrfParam.split("=");
	var csrfCkName = csrf[0];
	var csrfCkValue = csrf[1];
 	if(csrfCkName !== null && csrfCkValue !== null && saveTxtParams[preference] !== null) {
 		var formName = "savecodesform"; //No I18N
 		$("form[name="+formName+"]").remove();
 		$form = $("<form></form>");
 		$form.attr({
 			method : "post", //No I18N
 			action : "/tfapref/savetext", //No I18N
 			name : formName //No I18N
 		});
 		$form.append('<input type="hidden" name='+csrfCkName+' value='+ csrfCkValue +' />');
 		$form.append('<input type="hidden" name="savepref" value='+ saveTxtParams[preference].option +' />');
 		$('body').append($form);
 		if(saveTxtParams[preference].option == 2) {
 			$form.attr('target','printwindow'); //No I18N
 		}
		$form.submit();
	}
}

function makePrimaryInRecoveryUpdate(mobile){
	pass = de('pass_confirm').value.trim();//No I18N 
	if(pass==""){
		showTFAErrorMsg("pass_confirm",err_invalid_password);  //No I18N
		return;
	}
	var resp = getPlainResponse("/p/primary","password="+euc(pass)+"&mobile="+mobile+"&"+ csrfParam); //No I18N
	resp = resp.trim();
	if(resp == "success") { //No I18N
		switchto(window.parent.location.href);
		return;
	}else if(resp == "invalid_password"){ //No I18N
		showTFAErrorMsg("pass_confirm",err_invalid_password); //No I18N
		de('pass_confirm').focus(); //No I18N
		return;
	}else if(resp =="ro_update_not_allowed"){ //No I18N
		showTFAErrorMsg("pass_confirm",write_operation_not_allowed); //No I18N
		de('pass_confirm').focus(); //No I18N
        return;
    }
	showTFAErrorMsg("pass_confirm",err_cnt_error_occurred); //No I18N
}

function confirmMakePrimary(mobile) {
	popup('show','password_popup'); //No i18N
	de('pass_confirm').focus(); //No i18N
	$("#mkprim_confirm").click(function() {
		makePrimaryInRecoveryUpdate(mobile);
	});
	
	$('#pass_confirm').keyup(function(event) {
		$(this).siblings('.error').hide();
		if(event.keyCode == 13) {
			makePrimaryInRecoveryUpdate(mobile);				
		}
	});
}

function checkRecoveryskip(url) {
	if(saved_backup_codes) {
		window.parent.location.href = url;
	} else {
		popup('show','backup_codes'); //No I18N
	}
}
function checktfa(id){
	var isChecked =de('tfaremember_field').checked;//No I18N
	if(isChecked){
		$("#tfaprefcheck").removeClass('check-checked').addClass('check-unchecked');
		de('tfaremember_field').checked=false;//No i18N
	}else{
		$("#tfaprefcheck").removeClass('check-unchecked').addClass('check-checked');
		de('tfaremember_field').checked=true;//No i18N
	}
}
function setTFACodeType(id) {
	if(id == "backup_config_sms") {
		$("#backup_config_sms_icon").removeClass('radio-unchecked').addClass('radio-checked');
		$("#backup_config_call_icon").removeClass('radio-checked').addClass('radio-unchecked');
		$("#backup_config_call").prop('checked', false);
		$("#backup_config_sms").prop('checked', true);
	}else{
		$("#backup_config_call_icon").removeClass('radio-unchecked').addClass('radio-checked');
		$("#backup_config_sms_icon").removeClass('radio-checked').addClass('radio-unchecked');
		$("#backup_config_sms").prop('checked', false);
		$("#backup_config_call").prop('checked', true);
	}
}
function getDropDownISTCode(){
	 $(".chosen-select").chosen();
	 $(".chzn-single").css("borderRadius","0px");
	 $(".chzn-container,.chzn-results").css("maxHeight","140px");
	 $(".chzn-container-single .chzn-single").css("height","26px");
	 $(".chzn-container-single .chzn-single").css("lineHeight","21px");
	 $(".chzn-single").css("border","none");
	 $(".chzn-single").css("background","#fff");
	 $(".chzn-single").css("fontSize","13px");
	 $(".chzn-single").css("color","#888");
	 $(".chzn-single").css("boxShadow","none");
	 $("#cont_name_bkp_chzn").css("width","140px");
}
function oldchecksetupStatus(radioEleName){
	var radioEle = de(radioEleName);
	if(radioEleName==="smsmodepref"){
		if($(".tfa-nextbutton-auth").is(":visible")){
			$(".tfa-nextbutton-auth").css("marginLeft","374px");	
		}else{
			$(".tfa-nextbutton-unauth").css("marginLeft","344px");
		}
		if(de('rememberdiv'))
		{
			$('#rememberdiv').show();
		}
	}else if(radioEleName==="authmodepref"){//No i18N
		if($(".tfa-nextbutton-auth").is(":visible")){
			$(".tfa-nextbutton-auth").css("marginLeft","100px");
		}else{
			$(".tfa-nextbutton-unauth").css("marginLeft","70px");
		}
		if(de('rememberdiv'))
		{
			$('#rememberdiv').show();
		}
	}else if(radioEleName==="exomodepref"){//No i18N
		if($(".tfa-nextbutton-auth").is(":visible")){
			$(".tfa-nextbutton-auth").css("marginLeft","100px");
		}else{
			$(".tfa-nextbutton-unauth").css("marginLeft","70px");
		}
		if(de('rememberdiv'))
		{
			$('#rememberdiv').hide();
		}
	}else if(radioEleName==="hardmodepref"){//No i18N
		if($(".buttonposition").is(":visible")){
			$(".exo-btn").css("marginLeft","78px");
		}
	}else if(radioEleName==="softmodepref"){//No i18N
		if($(".buttonposition").is(":visible")){
			$(".exo-btn").css("marginLeft","480px");
		}
	}
	if(radioEle) {
		radioEle.checked=true;
		var radioEleList = document.getElementsByName(radioEle.name);
		for(var i=0;i<radioEleList.length;i++){
			spanEle = de("span"+radioEleList[i].id);
			if(spanEle.id == "span"+radioEle.id){
				spanEle.className = "oldselect-option";
				
			}else{
				spanEle.className = "olddeselect-option";
			}
		}		
	}
}
function checksetupStatus(radioEleName,id){
	$('#'+id+ ' [name=modepref]').attr("checked",true);
	$(".authmode-icon").removeClass("active-authmode-icon");
	$(".smsmode-icon").removeClass("active-smsmode-icon");
	$("."+id+"-icon").addClass('active-'+id+'-icon');
	$(".select-option ,.modename ,.modedesc,.continue-option").hide();
	$("#"+id+" .modename").css('display','block');
	$("#"+id+" .modedesc").css('display','block');
	$("#"+id+" .select-option").css('display','inline-block');
	$("#"+id+" .continue-option").css('display','inline-block');
}
$(document).keydown(function(e) {
    if (e.keyCode === 27) {
    	closeDiv();
    }
  });

function setAsTFANumber(){
	var passwd = de('passwd_to_set_tfa').value;//No I18N
	var mobileNo = de('verifiedmobiles').value;//No I18N
	sendRequestWithCallback("/p/setastfano","password="+euc(passwd)+"&mobileNo="+mobileNo+"&"+csrfParam,true, //No I18N
			function(resp) {
		if(IsJsonString(resp)){
			var obj = $.parseJSON(resp);
			if(obj.status == "error"){
				showerrormsg(obj.message);//No I18N
				return;
			}
			popup('hide','set_as_tfa_msgpopup');//No I18N
			de('getPhNodiv').style.display ="none";//No I18N
			showTFAPref='true';
			loadui('/ui/settings/tfapreference.jsp');//No I18N
		}
	});	
}

function addAsBackupNumber(){
	var passwd = de('passwd_to_set_tfa').value;//No I18N
	var mobileNo = de('verifiedmobilesbackup').value;//No I18N
	sendRequestWithCallback("/p/addasbackupno","password="+euc(passwd)+"&mobileNo="+mobileNo+"&"+csrfParam,true, //No I18N
			function(resp) {
		if(IsJsonString(resp)){
			var obj = $.parseJSON(resp);
			if(obj.status == "error"){
				showerrormsg(obj.message);//No I18N
				return;
			}
			popup('hide','phonenumbers_popup');//No I18N
			loadui('/ui/settings/tfapreference.jsp');//No I18N
		}
	});	
}


function addNewBackupNumbers(){
	$('.tfa_popup_content').hide();
	$('#addphNoDiv').show();
}

function showHideBackUpNumbers() {
	if(de('bknumverdiv')) {
		if(de('bknumverdiv').style.display === 'none') {
			de('bknumverdiv').style.display='';
			if(de('ele_bknumdropdown')) {
				de('ele_bknumdropdown').className = 'dropupicon';
			}
		} else {
			de('bknumverdiv').style.display='none';
			if(de('ele_bknumdropdown')) {
				de('ele_bknumdropdown').className = 'dropdownicon';
			}
		}
	}
}

function hideBackUpNumbers() {
	if(de('bknumverdiv')) {
		de('bknumverdiv').style.display='none';
	}
	if(de('ele_bknumdropdown')) {
		de('ele_bknumdropdown').className = 'dropdownicon';
	}
}

function showHideBackUpDevices() {
	if(de('bkdevicediv')) {
		if(de('bkdevicediv').style.display === 'none') {
			de('bkdevicediv').style.display='';
			if(de('ele_bkdevicedropdown')) {
				de('ele_bkdevicedropdown').className = 'dropupicon';
			}
		} else {
			de('bkdevicediv').style.display='none';
			if(de('ele_bkdevicedropdown')) {
				de('ele_bkdevicedropdown').className = 'dropdownicon';
			}
		}
	}
}

function hideBackUpDevices() {
	if(de('bkdevicediv')) {
		de('bkdevicediv').style.display='none';
	}
	if(de('ele_bkdevicedropdown')) {
		de('ele_bkdevicedropdown').className = 'dropdownicon';
	}
}