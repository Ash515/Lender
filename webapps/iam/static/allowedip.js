// $Id$ 
function addnew(param) {
    if(param == 'show') {
    $(".cautionnote").hide();
    $("#allowedipform").show();
	de('addnewip').style.display='';
	de('addnewipbutton').style.display='none';
	$("#opacity").fadeIn("fast");
	document.addip.fromip.focus();
	
    }
    else if(param == 'hide') {
	de('addnewip').style.display='none';
	de('addnewipbutton').style.display='';
	$("#opacity").fadeOut("fast");
	document.addip.reset();
    }
}

function addipaddress(f) {
    var fip = f.fromip.value.trim();
    var tip = f.toip.value.trim();
    if(isEmpty(fip)) {
	showerrormsg(err_empty_fromip);
	f.fromip.focus();
    }
    else if(!isIP(fip)) {
	showerrormsg(err_enter_fromip);
	f.fromip.focus();
    }
    else if(!isEmpty(tip) && !isIP(tip)) {
	showerrormsg(err_enter_toip);
	f.toip.focus();
    }
    else {
    	showCautionBanner(fip,tip);
    }
    return false;
}
function showCautionBanner(from,to){
	$("#allowedipform").hide();
	$(".cautionnote").show();
	var button = "<div class='label'><div class='inlineLabel'></div><button onclick='addIpRange(\""+from+"\",\""+to+"\")' class='saveBtn' >"+iam_yes+"</button>";//No i18N
	button += "<button onclick=addnew('hide') class='cancelBtn' >"+iam_cancel+"</button></div>";//No I18N
	var maincont;
	var notecont;
	if(to==""){
		maincont=iam_alert_message_fromonly.replace("__FROMIP__",from);
		notecont=iam_alert_message_notefrom;
	}
	else{
		maincont=iam_alert_message_fromto.replace("__FROMIP__",from).replace("__TOIP__",to);
		notecont=iam_alert_message_note;
	}
	$(".cautionnote").html(maincont+"<pre  class='pretextip'>"+notecont+"</pre>"+button);
}
function addIpRange(from, to) {
    var params = "fip="+euc(from) +"&tip="+euc(to)+"&"+csrfParam; //No I18N
    var resp = getPlainResponse(contextpath+"/u/allowedip", params); //No I18N
    var res = resp.trim();
    if(res == "invalidfromip") {
	showerrormsg(err_enter_fromip);
	de('fromip').focus();
    }
    else if(res == "invalidtoip") {
	showerrormsg(err_enter_toip);
	de('toip').focus();
    }
    else if(res == "SUCCESS") {
	showsuccessmsg(err_update_success);
	$('#opacity').hide();
	if(fromService) {
            window.location.href = contextpath+'/ui/settings/allowed-ip.jsp?service=true'; //No I18N
        }
	else {
            loadui('/ui/settings/allowed-ip.jsp'); //No I18N
        }
    }
    else if(res == "alreadyexist") {
	showerrormsg(ip_address_exist);
    }
    else if(res == "WRITE_OPERATION_NOT_ALLOWED") {
	showerrormsg(write_operation_not_allowed);
    }
    else {
	showerrormsg(err_cnt_error_occurred);
    }
    
    return false;
}

function deleteip(fromip,toip){
    if(confirm(formatMessage(err_allowedips_sure_delete))) {
	var params = "fip="+euc(fromip) +"&tip="+euc(toip)+"&"+csrfParam; //No I18N
	var resp = getPlainResponse(contextpath+"/u/deleteallowip", params); //No I18N
	var res = resp.trim();
	if(res == "SUCCESS"){
	    showsuccessmsg(ip_delete_success);
	    if(fromService) {
                window.location.href = contextpath+'/ui/settings/allowed-ip.jsp?service=true'; //No I18N
            }
	    else {
                loadui('/ui/settings/allowed-ip.jsp'); //No I18N
            }
	} else if (res == "WRITE_OPERATION_NOT_ALLOWED"){ //No I18N
	    showerrormsg(write_operation_not_allowed);
	} else {
	    showerrormsg(err_cnt_error_occurred);
	}
    }
    return false;
}

/***************************** authorized websites *********************************/
function revokeAccess(domain){
    var param = "domain="+euc(domain)+"&"+csrfParam; //No I18N
    var resp = getPlainResponse(contextpath+"/u/revoked", param); //No I18N
    if(resp.trim()=="SUCCESS"){
	showsuccessmsg(revoke_access_success);
	if(fromService) {
            window.location.href = contextpath+'/ui/settings/authorized-websites.jsp?service=true'; //No I18N
        }
	else {
            loadui("/ui/settings/authorized-websites.jsp"); //No I18N
        }
    }
    else if(resp.trim()=="FAILED"){
	showerrormsg(err_revoke_access_failed);
    }
    else if(resp.trim()=="WRITE_OPERATION_NOT_ALLOWED"){ //No I18N
	showerrormsg(write_operation_not_allowed);
    }
    else {
	showerrormsg(err_cnt_error_occurred);
    }
}
/***************************** login history *********************************/
function userAgent(ele, agent) {
	var agent_ele = de('agent');//No I18N
	agent_ele.style.top = jQuery(ele).offset().top+'px';
	
	var ele_width = jQuery(ele).width();
	agent_ele.style.left = ((jQuery(ele).offset().left+(ele_width/2)))+'px';
	jQuery('#agent').text(agent); //No I18N
	de('agent').style.display='block';
}

function hideUserAgent() {
	de('agent').style.display='none';
	de('agent').innerHTML='';//No I18N
}

/***************************** User Sessinos *********************************/
function deleteTicket(t, isOther) {
    var param = "";
    if(isOther) {
        param += "isOther=true"; //No I18N
    }
    else {
        param += "isOther=false"; //No I18N
    }
    param += "&closeticket="+euc(t)+"&"+csrfParam; //No I18N
    var resp = getPlainResponse(contextpath+"/u/sessions", param); //No I18N
    if(resp.trim() == "SUCCESS") {
	if(isOther) {
            showsuccessmsg(err_allother_session_closed);
        }
	else {
            showsuccessmsg(err_session_closed);
        }
	if(fromService) {
            window.location.href = contextpath+'/ui/settings/user-sessions.jsp?service=true&mobile=true'; //No I18N
        }
	else {
            loadui('/ui/settings/user-sessions.jsp'); //No I18N
        }
    } else {
	showerrormsg(err_cnt_error_occurred);
    }
    return false;
}

/***************************** close accounts *********************************/
function closeaccount(f) {
    var currentpass = f.pwd.value.trim();
    if(isEmpty(currentpass)) {
        showerrormsg(err_enter_pass);
        f.pwd.focus();
    }
    else if(currentpass.length > f.pass_maxlen.value.trim()) {
    	showerrormsg(formatMessage(err_password_maxlen, f.pass_maxlen.value.trim()));
        f.pwd.focus();
    }
    else if(confirm(err_closeaccount_userconfirm)) {
    	var reaaa = "NOT_HAPPY"; //No I18N
    	for (i=0; i<3; i++) {
    	    if(f.reason[i].checked) {
                reaaa =  f.reason[i].value;
            }
    	}
        var comments = f.comments.value.trim();
        if(comments.length > 250) {
            showerrormsg(err_closeaccount_comments_length);
            return false;
        }
    	var params = "pwd="+euc(f.pwd.value) +"&reason="+euc(reaaa)+"&comments="+euc(comments)+"&"+csrfParam; //No I18N
    	var resp = getPlainResponse(contextpath+"/u/close", params); //No I18N
	resp = resp.trim();
	if(resp == "SUCCESS") {
	    showsuccessmsg(err_update_success);
	    window.location.href="/";
	}
	else if(resp == "INVALID_CURRPASS") {
	    showerrormsg(err_invalid_pass);
	}
	else if(resp == "HTTP_NOT_ALLOWED") {
            showerrormsg(err_http_access_not_allowe);
        }
	else if(resp == "WRITE_OPERATION_NOT_ALLOWED") { //No I18N
            showerrormsg(write_operation_not_allowed);
        }
	else {
	    showerrormsg(err_cnt_error_occurred);
	}
    }
    else {
        f.reset();
    }
    return false;
}

/***************************** API Tokens *********************************/
function selectAuthTokenEle(e) {
	if(!e) {
		return false;
	}
	if(e.className === 'apitoken-checked') {
		e.className = 'apitoken-unchecked';
		checkAndUpdateAllSelection(false);
	} else {
		e.className = 'apitoken-checked';
		checkAndUpdateAllSelection(true);
	}
}
function checkAndUpdateAllSelection(checked) {
	if(!de('apitoken_check_all')) {
		return false;
	}
	if(checked) {
		var unCheckedElems = jQuery('#apitokenstbl').find('a.apitoken-unchecked'); //No I18N
		if(unCheckedElems && unCheckedElems.size() < 1) {
			de('apitoken_check_all').className = 'apitoken-checked';
		}
	} else {
		de('apitoken_check_all').className = 'apitoken-unchecked';
	}
}
function checkallauthtokens() {
	if(!de('apitoken_check_all')) {
		return false;
	}
	if(de('apitoken_check_all').className === 'apitoken-checked') {
		processAllAuthtokensSelection(false);
		de('apitoken_check_all').className = 'apitoken-unchecked';
	} else {
		processAllAuthtokensSelection(true);
		de('apitoken_check_all').className = 'apitoken-checked';
	}
}
function processAllAuthtokensSelection(checked) {
	if(!de('apitokenstbl')) {
		return false;
	}
	if(checked) {
		jQuery('#apitokenstbl').find('a.apitoken-unchecked').attr('class', 'apitoken-checked'); //No I18N
	} else {
		jQuery('#apitokenstbl').find('a.apitoken-checked').attr('class', 'apitoken-unchecked'); //No I18N
	}
}
function deleteSelectedAPITokens(isConfirm) {
	if(!de('apitokenstbl') || !de('apitoken_check_all')) {
		return false;
	}
	var params;
	var checkedElems = '';
	var totalTokens = 0;
	if(de('apitoken_check_all').className === 'apitoken-checked') {
	    if(!isConfirm) {
	        if(de('alertpopupbtn')) {
	            showAlertMsg(authtoken_revoke_all_alert_msg);
	            de('alertpopupbtn').onclick = function() {deleteSelectedAPITokens(true);}; //No I18N
	        } else {
	        	deleteSelectedAPITokens(true);
	        }
	        return false;
	    }
	    params = "action=delete_all&"+csrfParam; //No I18N
	} else {
		totalTokens = jQuery('#apitokenstbl').find('table.scopetbl').size(); //No I18N
		checkedElems = jQuery('#apitokenstbl').find('a.apitoken-checked'); //No I18N
		if(!checkedElems || checkedElems.size() < 1) {
			showerrormsg(err_select_authtoken_todelete);
			return false;
		}
	    if(!isConfirm) {
	        if(de('alertpopupbtn')) {
	        	if(checkedElems.size() === 1) {
	        		showAlertMsg(authtoken_revoke_alert_msg);
	            }else {
	            	showAlertMsg(authtoken_revoke_all_alert_msg);
	            }
	            de('alertpopupbtn').onclick = function() {deleteSelectedAPITokens(true);}; //No I18N
	        } else {
	        	deleteSelectedAPITokens(true);
	        }
	        return false;
	    }
	        var tokens = '';
		    checkedElems.each(function() {tokens += jQuery(this).data("enctoken") + ",";});
		    params = "action=delete_selected&authtokens="+ euc(tokens) +"&"+ csrfParam; //No I18N
	}
	if(de('alertpopupbtn')) {
    	de('alertpopupmsg').innerHTML = err_authtokens_removal_process; //No I18N
    	de('alertpopupbtn').parentNode.className='hide'; //No I18N
	}
    var resp = getPlainResponse(contextpath+"/u/authtoken", params); //No I18N
    resp = resp.trim();
    if(de('alertpopupbtn')) {
        hideAlertMsg();
        de('alertpopupbtn').parentNode.className='mrpBtn'; //No I18N
    }
    if(resp === "SUCCESS_SELECTED") {
    	showsuccessmsg(err_authtokens_removed_success);
    	if(totalTokens < 1000 && checkedElems && checkedElems.size() > 0) {
    		checkedElems.each(function() {
    			var tokenElement = this.parentNode.parentNode;
    			tokenElement.parentNode.removeChild(tokenElement);
    		});
    	} else {
    		refreshTokens();
    	}
    } else if(resp === "SUCCESS_ALL") { //No I18N
    	showsuccessmsg(err_authtokens_removed_success);
    	refreshTokens();
    } else if(resp === "INVALID_TOKEN") { //No I18N
    	showerrormsg(err_authtoken_invalid_token_specified);
    } else {
    	showerrormsg(err_cnt_error_occurred);
    }
}
function deleteToken(ele, token, isConfirm, maskedtkn) {
    if(!isConfirm) {
        if(de('alertpopupbtn')) {
            showAlertMsg(authtoken_revoke_alert_msg);
            de('alertpopupbtn').onclick = function() {deleteToken(ele, token, true);showsuccessmsg(formatMessage(authtoken_revoke_success, maskedtkn));};//no i18N
        } else {
            deleteToken(ele, token, true);
        }
        return false;
    }
    var params = "action=delete&token="+euc(token)+"&"+csrfParam; //No I18N
    var resp = getPlainResponse(contextpath+"/u/authtoken", params); //No I18N
    resp = resp.trim();
    if(de('alertpopupbtn')) {
        hideAlertMsg();
    }
    if(resp.indexOf("SUCCESS") != -1) {
        showsuccessmsg(formatMessage(authtoken_revoke_success, maskedtkn));
        if(resp == "SUCCESS") {
            var tokenParent = ele.parentNode.parentNode.parentNode;
            var tokenEles = $(tokenParent).siblings();
            if(tokenEles.length <= 1) {
                refreshTokens();
            } else {
                tokenParent.parentNode.removeChild(tokenParent);
            }
        } else {
            refreshTokens();
        }
    } else if(resp == "INVALID_TOKEN") { //No I18N
        showerrormsg(err_authtoken_invalid_token);
    } else {
        showerrormsg(err_cnt_error_occurred);
    }
    return false;
}
function regenerateToken(token, isConfirm) {
    if(!isConfirm) {
        if(de('alertpopupbtn')) {
            showAlertMsg(authtoken_regenerate_alert_msg);
            de('alertpopupbtn').onclick = function() {regenerateToken(token, true)};
        } else {
            regenerateToken(token, true)
        }
        return false;
    }
    var params = "action=regenerate&authtoken="+euc(token)+"&"+csrfParam; //No I18N
    var resp = getPlainResponse(contextpath+"/u/authtoken", params); //No I18N
    resp = resp.trim();
    if(de('alertpopupbtn')) {
        hideAlertMsg();
    }
    if(resp == "SUCCESS") {
        showsuccessmsg(authtoken_regenerate_success);
        refreshTokens();
    } else if(resp == "INVALID_TOKEN") { //No I18N
        showerrormsg(err_authtoken_invalid_token);
    } else if(resp == "URL_ROLLING_THROTTLES_LIMIT_EXCEEDED") { //No I18N
        showerrormsg(err_http_access_not_allowed);
    } else {
        showerrormsg(err_cnt_error_occurred);
    }
    return false;
}
function refreshTokens() {
    if(fromService) {
        window.location.href = contextpath+'/ui/settings/api-tokens.jsp?service=true'; //No I18N
    } else {
        loadui('/ui/settings/api-tokens.jsp'); //No I18N
    }
    return false;
}
function focusauthtoken(trEle, actionId) {
	trEle.className = 'focusapitokentr';
	de(actionId).style.display='';
}
function focusoutauthtoken(trEle, actionId) {
	trEle.className = '';
	de(actionId).style.display='none';
}
function showauthtokenmodedetails(id, show) {
	if(show) {
		$("#"+id).fadeIn(100);
		$("#opacity").fadeIn("fast");
	} else {
		de(id).style.display='none';
		$('#opacity').hide();
	}
}
$(document).keydown(function(e) {
    if (e.keyCode === 27) {
    	$(".authtokenmoredetails").fadeOut(100);
    	$("#alertpopup").fadeOut(100);
		$("#opacity").fadeOut("fast");
    }
});
/***************************** User Sessinos *********************************/
function removelinkedaccount(emailID, idp) {
    var param = "";
    param += "&emailID="+euc(emailID)+"&idp="+idp+"&"+csrfParam; //No I18N
    var resp = getPlainResponse(contextpath+"/u/unlinkopenid", param); //No I18N
    if(resp.trim() == "SUCCESS") {
    	showsuccessmsg(linked_account_remove_sucess);
    	loadui('/ui/settings/linked-accounts.jsp'); //No I18N
    } else {
    	showerrormsg(linked_account_remove_error);
    }
    return false;
}
$(document).keydown(function(e) {
    if (e.keyCode === 27) {
    	if($(".photopopup").is(":visible")||$(".photomain").is(":visible")){
    		closePhotoPopUp($(".photodefault").is(":visible"));//No I18N
    	}else if($(".confirmpop").is(":visible")){
    		$('#opacity').hide();$('.confirmpop').hide();
    	}
    	else if($("#merge_org").is(":visible")){
    		$("#merge_org").fadeOut(100);	
    	}
    }
});
function checkRadioclose(id){
	if(id==="nh"){//No I18N
		$("#"+id+"-radio").removeClass("radio-unchecked").addClass("radio-checked");
		$("#ma-radio ,#nu-radio").removeClass("radio-checked").addClass("radio-unchecked");
		$("#"+id+"-radio").removeClass("radio-unchecked").addClass("radio-checked");
		de(id).checked=true;
	}else if(id==="ma"){//No I18N
		$("#"+id+"-radio").removeClass("radio-unchecked").addClass("radio-checked");
		$("#nh-radio ,#nu-radio").removeClass("radio-checked").addClass("radio-unchecked");
		de(id).checked=true;
	}else if(id==="nu"){ //No I18N
		$("#"+id+"-radio").removeClass("radio-unchecked").addClass("radio-checked");
		$("#ma-radio ,#nh-radio").removeClass("radio-checked").addClass("radio-unchecked");
		de(id).checked=true;
	}
}
function sortAuthtoken(icon){
	var iconcls=$(icon).find("span");
	var iconname=$(iconcls).attr("class");
	if(iconname==="sorticon"){
		$(iconcls).removeClass("sorticon");
		$(iconcls).addClass("upicon");
	}else if(iconname==="upicon") {	//No i18N
		$(iconcls).removeClass("upicon");
		$(iconcls).addClass("downicon");
	}else if(iconname==="downicon") { //No i18N
		$(iconcls).removeClass("downicon");
		$(iconcls).addClass("upicon");
	}
	var headerrow = $("#headerrow");
	var authtokensrow = $('#apitokenstbl #trow');
	$('#apitokenstbl #trow').remove();
	var tableRows="";
	for (i=authtokensrow.size(); i>=0; i--) {
		if(authtokensrow[i]){
			$("#apitokenstbl").append(authtokensrow[i]);	
		}
	}
}
/***************************** Connected Apps *********************************/
function deleteApp(clientZid,clientID,id){
	var param = "";
    param += "&clientZid="+clientZid+"&clientID="+clientID+"&"+ csrfParam; //No I18N
    var resp = getPlainResponse(contextpath+"/u/deleteconnectedapp", param); //No I18N
    if(resp.trim() == "SUCCESS") {
    	var parent_id = $(id).parent().parent();
    	if($(parent_id).siblings().length<=1){
    		loadui('/ui/settings/connected-apps.jsp'); //No I18N
    	}else{
    		$(parent_id).remove();
    	}	
    } else {
    	showerrormsg(connected_app_remove_error);
    }
    return false;
}

function deleteMobileApp(clientZid,clientID, hs, id){
	var param = "";
    param += "&clientZid="+clientZid+"&clientID="+ clientID + "&hs=" + hs + "&"+ csrfParam; //No I18N
    var resp = getPlainResponse(contextpath+"/u/deleteconnectedmobileapp", param); //No I18N
    if(resp.trim() == "SUCCESS") {
    	var parent_id = $(id).parent().parent();
    	if($(parent_id).siblings().length<=1){
    		loadui('/ui/settings/connected-mobileapps.jsp'); //No I18N
    	}else{
    		$(parent_id).remove();
    	}	
    } else {
    	showerrormsg(connected_app_remove_error);
    }
    return false;
}
/------------------------------------------gdpr functions------------------------------------------------/ 

function initiateDPA() {

			var zid = $("#not_init_orgs").val();
			var service_name = $("#not_init_orgs option:selected").attr("data-service");
			var org_name = $("#not_init_orgs option:selected").attr("data-org_name");
			getForm_details(zid,org_name,service_name);
			$("#gdpr_dpa_initiate_req_container").hide();
			$(".form_for_dpa").show();	
	
}
function getForm_details(zid, org_name, service_name){
	
	// service invalid send org name or else servicename
	var params = "on="+euc(org_name)+"&sn="+euc(service_name)+"&"+csrfParam;//No I18N
	var result = getPlainResponse(contextpath+"/dpa/"+zid, params); //No I18N
	result = JSON.parse(result);
	var org_n = result.data.org_name;
	document.gdpr_info_form.cname.value=result.data != undefined && result.data.company_name != undefined ? result.data.company_name : "";
	document.gdpr_info_form.caddress.value=result.data != undefined && result.data.address != undefined ? result.data.address : "";
	$(document.gdpr_info_form).find(".saveBtn")[0].setAttribute("onclick","saveGDPRdetails(document.gdpr_info_form,"+zid+",'"+org_n+"')");
	//return result;
}
function load_cn(){
	var cntxt=cns;
	var cn = de('Dpa_Cn');//No I18N
	cn.options.length = 0;
    if(isEmpty(icountry.trim())) {
        cn.appendChild(new Option());
    }
    
    var current_country="";
    for(var c in cntxt) {
    	option = document.createElement("option");
    	option.innerHTML = cntxt[c][0];
    	option.value = cntxt[c][1];
    	cn.appendChild(option);
    	if(cntxt[c][1] == icountry.toLowerCase()){
    		option.selected = true;
    		current_country = cntxt[c][1];
    	}
    }
    getDropDown();
}
function saveGDPRdetails(f,zid,orgname){
	var fName = f.fullname.value.trim();
	var cName = f.cname.value.trim();
	var ccountry = f.dpaCn.value.trim();
	var cRegNumber = f.regNum.value.trim();
	var cAddress = f.caddress.value.trim();
	var data = f.cdata.value.trim();
	
	if(isEmpty(fName)){
    	showerrormsg(err_fname);
    	f.fullname.focus();
    	return false;
	}
	else if(isEmpty(ccountry)){
		showerrormsg(iam_gdpr_dpa_country_err);
    	f.dpaCn.focus();
    	return false;
	}
    else if(isEmpty(cName)){
    	showerrormsg(iam_gdpr_dpa_cname_err);//companu name error
    	f.cname.focus();
    	return false;
	}
    else if(isEmpty(cRegNumber)){
    	showerrormsg(iam_gdpr_dpa_com_reg_num_err);//reg number name error
    	f.regNum.focus();
    	return false;
	}
    else if(isEmpty(cAddress)){
    	showerrormsg(iam_gdpr_dpa_com_address_err);//com address number name error
    	f.caddress.focus();
    	return false;
	}
    else if(isEmpty(data)){
    	showerrormsg(iam_gdpr_dpa_data_err);//data number name error
    	f.cdata.focus();
    	return false;
	}
	else{
		de('progress-cont').style.display='block';
		var params = "fn=" + euc(fName) + "&cn="+euc(cName)+"&cc=" + euc(ccountry) + "&rn=" + euc(cRegNumber) + "&ca=" + euc(cAddress)+ "&szid=" + zid+"&cd=" + euc(data)+"&on="+euc(orgname)+"&"+csrfParam; //No I18N
		var result = getResponse(contextpath+"/dpa/add", params); //No I18N
		result = JSON.parse(result);
		if(result.status=="success") {
			de('progress-cont').style.display='none';
			loadui('/ui/settings/gdpr-dpa.jsp',"",'dpa');
		}
		else{
			showerrormsg(err_http_access_not_allowed);
			de('progress-cont').style.display='none';
		}
	}
}
function showMerge(zid){
	$('#merge_org').fadeIn(100);
	$("#opacity").fadeIn("fast");
	$('#merge_org .saveBtn').attr("onclick","mergeFunc('"+zid+"')");
	getDropDown();
}
function mergeFunc(merge_id){
	var parent_id = $("#comp_orgs").val();
	var param ="szid=" + euc(merge_id) + "&pzid=" + euc(parent_id) +"&"+csrfParam; //No I18N
	var res = getResponse(contextpath+"/dpa/merge", param); //No I18N
	res = JSON.parse(res);
	if(res.status == "success"){
		showsuccessmsg(err_update_success)
		loadui('/ui/settings/gdpr-dpa.jsp',"",'dpa');
	}
	else{
		showerrormsg(err_http_access_not_allowed);
	}
	$("#merge_org").hide();
	$("#opacity").fadeOut("fast");
}
function showAddForm(zid,service_name,org_name){
	$(".gdpr_detail_container").hide();
	$(".form_for_dpa").show();
	getForm_details(zid,org_name,service_name);
	$("#gdpr_dpa_initiate_req_container").hide();
	$(".form_for_dpa").show();	
	
}
function backToStatus()
{
	$(".form_for_dpa").hide();
	$(".gdpr_dpa_container").show();
	$(".gdpr_detail_container").show();
}
function securitynotifiCheck(){
	var param = "signin_alert_subscription="+de("signin_alert_option").checked + "&" + csrfParam; //No I18N
	var res = getPlainResponse(contextpath+"/u/security/notification", param); //No I18N
	if(res.trim() == "SUCCESS"){
		showsuccessmsg(err_update_success)
	}
	else{
		showerrormsg(err_cnt_error_occurred);
	}
	return false;
}
function deleteTrustedDevice(zuid,deviceid){
	var param = "device_id="+deviceid+"&"+csrfParam; //No I18N
	var res = getPlainResponse(contextpath+"/u/security/deletedevice", param); //No I18N
	if(res.trim() == "SUCCESS"){
		showsuccessmsg(iam_device_delete_msg);
		if($(".devicesession").length===1){
			$("#addeddevicelist").remove();
		}else{
			$("#deviceid"+deviceid).remove();	
		}
		return;
	}
	else{
		showerrormsg(linked_account_remove_error);
		return;
	}
}
function deleteFetchedDevice(deviceid){
	var param = "device_id="+deviceid+"&"+csrfParam; //No I18N
	var res = getPlainResponse(contextpath+"/u/security/deletefetchdevice", param); //No I18N
	if(res.trim() == "SUCCESS"){
		showsuccessmsg(iam_mail_client_terminate_msg);
		if($(".fetchsession").length===1){
			$("#fetchdevicelist").remove();
			if($(".devicesession").length===0){$(".defaultnodata").css("display","block")};
		}else{
			$("#fetchid"+deviceid).remove();	
		}
		return;
	}
	else{
		showerrormsg(linked_account_remove_error);
		return;
	}
}
function mapTrustedDevice(hash) {
	hash = hash.split('/')[2];
	var dev = de('deviceid'+hash);//No I18N
	if (typeof(dev) == 'undefined' || dev == null) {
		dev = de('fetchid'+hash);//No I18N
	}
	dev.style.fontWeight = 'bold';//No I18N
	dev.style.fontSize = '14px';//No I18N
}