//$Id$
var isIE = /msie/i.test(navigator.userAgent);
var _time;
var isJquery = window.jQuery;
function setWindowSize() {
	var windowH = $('#tempwin').outerHeight();
	var menupanelH = $('#mainmenupanel .wrapper').outerHeight();
	var logoH = de('ztb-logo').offsetHeight; //No I18N
	var pageH = 0;
	if(windowH > menupanelH) {
		pageH = windowH-logoH;
	} else {
		pageH = menupanelH-logoH;
	}
	pageH = pageH-7;
	de('mainmenupanel').style.height=pageH+"px";
	de('submenupanel').style.height=pageH+"px";
    de('zcontiner').style.height=pageH+"px";
}

function showFeedback() {
    var ele = de('feedbackdiv');//No I18N
    if(ele.childNodes.length <= 0) {
        $("#feedbackdiv").load("/commonfeedback.ui", {to:feedback_toAddress, parentid:"feedbackdiv"});
	de('feedbackdiv').style.display = 'block';
    }
    else {
	de('feedbackdiv').style.display = 'block';
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

/*----------- index.jsp ------------*/
function loadTab(id, panel_id, url) {
	if(de(id).className == 'active' && (id != 'admin') && id!='supportadmin') {
	    return false;
    }
    
    if($._data(window, "events") && $._data(window, "events").beforeunload) {
    	//TFA Setup is in progress. So confirm and proceed
		if(!confirm(err_tfa_setup_incomplete)) {
			return;
		}
	}
    
    de(mainmenu).className = '';
    de(id).className = 'active';
    mainmenu = id;
    if(id == 'home') {
        de('submenupanel').style.display='none';
        de('zcontiner').style.display='none';
        de('mainmenupanel').style.display='none';
    	de('portfolio-wrap').style.display='';
    	if(!fromService) {assignHash(mainmenu, submenu);}
    	return false;
    }
    else if(id == 'profile') {
    	de('ssubmenu').style.display='none';
    	de('stsubmenu').style.display='none';
    	de('sessionmgmtsubmenu').style.display='none';
    	if(de('gsubmenu')) {
    		de('gsubmenu').style.display='none';
    	}
    	if(de('privacysubmenu')) {
    		de('privacysubmenu').style.display='none';
    	}
    	de('psubmenu').style.display='';
    	de('mainmenupanel').style.display='';
    }
    else if(id=='security') {
    	de('psubmenu').style.display='none';
    	de('ssubmenu').style.display='none';
    	de('sessionmgmtsubmenu').style.display='none';
    	if(de('gsubmenu')) {
    		de('gsubmenu').style.display='none';
    	}
    	if(de('privacysubmenu')) {
    		de('privacysubmenu').style.display='none';
    	}
    	de('stsubmenu').style.display='';
    	de('mainmenupanel').style.display='';
    }
    else if(id=='sessions') {
    	de('psubmenu').style.display='none';
    	de('ssubmenu').style.display='none';
    	de('stsubmenu').style.display='none';
    	if(de('gsubmenu')) {
    		de('gsubmenu').style.display='none';
    	}
    	if(de('privacysubmenu')) {
    		de('privacysubmenu').style.display='none';
    	}
    	de('sessionmgmtsubmenu').style.display='';
    	de('mainmenupanel').style.display='';
    }
    else if(id=='setting') {
    	de('psubmenu').style.display='none';
    	de('stsubmenu').style.display='none';
    	de('sessionmgmtsubmenu').style.display='none';
    	if(de('gsubmenu')) {
    		de('gsubmenu').style.display='none';
    	}
    	if(de('privacysubmenu')) {
    		de('privacysubmenu').style.display='none';
    	}
    	de('ssubmenu').style.display='';
    	de('mainmenupanel').style.display='';
    }
    else if(de('gsubmenu') && id == 'groups') {
    	de('psubmenu').style.display='none';
    	de('ssubmenu').style.display='none';
    	de('stsubmenu').style.display='none';
    	de('sessionmgmtsubmenu').style.display='none';
    	if(de('privacysubmenu')) {
    		de('privacysubmenu').style.display='none';
    	}
    	de('gsubmenu').style.display='';
    	de('mainmenupanel').style.display='';
    }
    else if(de('privacysubmenu') && id == 'privacy') {
    	de('psubmenu').style.display='none';
    	de('ssubmenu').style.display='none';
    	de('stsubmenu').style.display='none';
    	de('sessionmgmtsubmenu').style.display='none';
    	if(de('gsubmenu')) {
    		de('gsubmenu').style.display='none';
    	}
    	de('privacysubmenu').style.display='';
    	de('mainmenupanel').style.display='';
    }
    de('portfolio-wrap').style.display='none';
    de('submenupanel').style.display='';
    de('zcontiner').style.display='';
    loadPage(panel_id,url);
    return false;
}

function loadPage(panel_id,url) {
	de('mainmenupanel').style.display='';
	hideFeeds();
    if('activespantitle' == de(panel_id).className) {
    	if(!fromService && (mainmenu=='profile' && window.location.hash=='#home')) {
    		assignHash(mainmenu, submenu);
    	}
    	return false;
    }
    if($._data(window, "events") && $._data(window, "events").beforeunload) {
		//TFA Setup is in progress. So confirm and proceed
		if(!confirm(err_tfa_setup_incomplete)) {
			return;
		}
	}
    de(submenu).className = 'spantitle';
    de(submenu).getElementsByTagName('div')[0].className = 'menutitle';
    de(panel_id).className = 'activespantitle';
    if(de(panel_id).getElementsByTagName('div')[0]){
    	de(panel_id).getElementsByTagName('div')[0].className = 'activemenutitle';
    	submenu = panel_id;
    	loadui(url,"",panel_id);
    	if(!fromService) {
    		assignHash(mainmenu, submenu);
    	}
    	return false;
    } else{
    	loadui(url,"",panel_id);
    }
}

function loadPageviaPOST(panel_id,url) {
	de('mainmenupanel').style.display='';
	hideFeeds();
    if('activespantitle' == de(panel_id).className) {
    	if(!fromService && (mainmenu=='profile' && window.location.hash=='#home')) {
    		assignHash(mainmenu, submenu);
    	}
    	return false;
    }
    if($._data(window, "events") && $._data(window, "events").beforeunload) {
		//TFA Setup is in progress. So confirm and proceed
		if(!confirm(err_tfa_setup_incomplete)) {
			return;
		}
	}
    de(submenu).className = 'spantitle';
    de(submenu).getElementsByTagName('div')[0].className = 'menutitle';
    de(panel_id).className = 'activespantitle';
    if(de(panel_id).getElementsByTagName('div')[0]){
    	de(panel_id).getElementsByTagName('div')[0].className = 'activemenutitle';
    	submenu = panel_id;
    	loaduiviaPOST(url,"",panel_id);
    	if(!fromService) {
    		assignHash(mainmenu, submenu);
    	}
    	return false;
    } else{
    	loaduiviaPOST(url,"",panel_id);
    }
}

function loadui(url, fnctName,panel_id) {
    de('progress-cont').style.display='block';
    if(fromService) {
    	window.location.href = contextpath+url;
    } else {
    	var resp = getOnlyGetPlainResponse(contextpath+url,"");
    	    if(panel_id && IsJsonString(resp.trim())){
    	        var json = JSON.parse(resp.trim());
    	        if(json.cause && json.cause.trim() === "invalid_password_token") {
    	            var serviceurl = window.location.origin + window.location.pathname+"#"+mainmenu+"/"+panel_id;
    	            var redirecturl = json.redirect_url;
    	            var ismobile=json.mobile;
     	            window.location.href =contextpath + redirecturl +'?serviceurl='+euc(serviceurl)+"&ismobile="+ismobile; //No I18N
    	            return false;
    	        }
    	    }

    	de('zcontiner').innerHTML = resp;  //No I18N
    }
    $(window).unbind('beforeunload');
    de('progress-cont').style.display='none';
    $('#zcontiner input[placeholder]').zPlaceHolder();
    if(fnctName) {
    	this[fnctName]();
    }
}

function loaduiviaPOST(url, fnctName,panel_id) {
    de('progress-cont').style.display='block';
    if(fromService) {
    	window.location.href = contextpath+url;
    } else {
    	
    	var resp = getPlainResponse(contextpath+url,csrfParam);
    	    if(panel_id && IsJsonString(resp.trim())){
    	        var json = JSON.parse(resp.trim());
    	        if(json.cause && json.cause.trim() === "invalid_password_token") {
    	            var serviceurl = window.location.origin + window.location.pathname+"#"+mainmenu+"/"+panel_id;
    	            var redirecturl = json.redirect_url;
    	            var ismobile=json.mobile;
     	            window.location.href =contextpath + redirecturl +'?serviceurl='+euc(serviceurl)+"&ismobile="+ismobile; //No I18N
    	            return false;
    	        }
    	    }

    	de('zcontiner').innerHTML = resp;  //No I18N
    }
    $(window).unbind('beforeunload');
    de('progress-cont').style.display='none';
    $('#zcontiner input[placeholder]').zPlaceHolder();
    if(fnctName) {
    	this[fnctName]();
    }
}

function stopEvents(e) {
    if (e.stopPropagation) {
    	e.preventDefault();
    	e.stopPropagation();
    } else {
    	e.cancelBubble = true;
    	e.returnValue = false;
    }
}
function viewConfirm(message) {
	$(".pcontentconfirm").html(message);// no i18n
	$("#opacity").show();
	$('.confirmpop').show();
}
/*----------- response message ------------*/
function showsuccessmsg(msg, id) {
	var msgDiv = $('#msg_div');
	msgDiv.stop(true,true);
	de('msgspan').className = "successmsg";
	de("tickicon").style.display="";
	if(de(id)) {
		de(id).innerHTML = msg;
	} else {
		de('msgpanel').innerHTML = msg; //No I18N
	}
	msgDiv.show();
	msgDiv.fadeOut(5000);
}

function showerrormsg(msg, id, istextmsg) {
	var msgDiv = $('#msg_div');
	msgDiv.stop(true,true);
	de('msgspan').className = "errormsg";
	de("tickicon").style.display="none";
	if(istextmsg){
		if(de(id)) {
			de(id).innerText = msg;	
		} else {
			de('msgpanel').innerText = msg; //No I18N
		}
	} else {
		if(de(id)) {
			de(id).innerHTML = msg;	
		} else {
			de('msgpanel').innerHTML = msg; //No I18N
		}
	}
	msgDiv.show();
	msgDiv.fadeOut(8000);
	if($("#progress-cont").css("display").indexOf("block")!==-1){
		$("#progress-cont").css("display","none");
	}
}

function show_field_error(cause, field, clasName) {
	if(field) {
		field.className = clasName;
	}
	showerrormsg(cause);
}

function reset_field_class(field, clasName) {
	if(field) {
		field.className = clasName;
	}
}

function openPopUp() {
    $('#msg_div').animate({top:"0"},1000);
}

function hideFeeds() {
    $('#feed_win').animate({top:"-28"},1000);
}

function viewPendingGrpReuest() {
    if(de('groups').className == 'active') {
        loadPage('invitedgroups','/ui/groups/pending-request.jsp'); //No I18N
    } else {
        loadTab('groups','invitedgroups','/ui/groups/pending-request.jsp'); //No I18N
    }
}
/*----------- end new scripts ------------*/

String.prototype.trim = function(){return this.replace(/^\s+|\s+$/g, '');};

function formatMessage() {
    var msg = arguments[0];
    if(msg != undefined) {
	for(var i = 1; i < arguments.length; i++) {
	    msg = msg.replace('{' + (i-1) + '}', escapeHTML(arguments[i]));
	}
    }
    return msg;
}

function de(id) {
    return document.getElementById(id);
}

function euc(i) {
    return encodeURIComponent(i);
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

function sendRequest(action, params, async) {
    if(params.indexOf("&") === 0) {
	params = params.substring(1);
    }
    var objHTTP = xhr();
    objHTTP.open('POST', action, async);
    objHTTP.setRequestHeader('Content-Type','application/x-www-form-urlencoded;charset=UTF-8');
    if(isEmpty(params)) {
        params = "__d=e"; //No I18N
    }
    objHTTP.setRequestHeader('Content-length', params.length);
    if(async) {
	objHTTP.onreadystatechange=function() {
	    if(objHTTP.readyState==4) {
		if(objHTTP.responseText) {
		    JSON.parse(JSON.stringify(objHTTP.responseText));
		}
	    }
	};
    }
    objHTTP.send(params);
    if(!async) {
    	JSON.parse(JSON.stringify(objHTTP.responseText));
    }
}

function getResponse(action, params) {
    if(params.indexOf("&") === 0) {
	params = params.substring(1);
    }
    var objHTTP,result;objHTTP = xhr();
    objHTTP.open('POST', action, false);
    objHTTP.setRequestHeader('Content-Type','application/x-www-form-urlencoded;charset=UTF-8');
    if(isEmpty(params)) {
        params = "__d=e"; //No I18N
    }
    objHTTP.setRequestHeader('Content-length', params.length);
    objHTTP.send(params);
    return JSON.parse(JSON.stringify(objHTTP.responseText));
}

function getPlainResponse(action, params) {
    if(params.indexOf("&") === 0) {
	params = params.substring(1);
    }
    var objHTTP,result;objHTTP = xhr();
    objHTTP.open('POST', action, false);
    objHTTP.setRequestHeader('Content-Type','application/x-www-form-urlencoded;charset=UTF-8');
    if(isEmpty(params)) {
        params = "__d=e"; //No I18N
    }
    objHTTP.setRequestHeader('Content-length', params.length);
    objHTTP.send(params);
    return objHTTP.responseText;
}

function getOnlyGetPlainResponse(action, params) {
    if(params.indexOf("&") === 0) {
	params = params.substring(1);
    }
    var objHTTP,result;objHTTP = xhr();
    objHTTP.open('GET', action, false);
    objHTTP.setRequestHeader('Content-Type','application/x-www-form-urlencoded;charset=UTF-8');
    if(isEmpty(params)) {
        params = "__d=e"; //No I18N
    }
    objHTTP.setRequestHeader('Content-length', params.length);
    objHTTP.send(params);
    return objHTTP.responseText;
}
function getDeleteResponse(action, params){
   if(params.indexOf("&") === 0) {
	   params = params.substring(1);
   }
   var objHTTP,result;objHTTP = xhr();
   objHTTP.open('DELETE', action, false);
   objHTTP.setRequestHeader('Content-Type','application/x-www-form-urlencoded;charset=UTF-8');
   objHTTP.setRequestHeader("X-ZCSRF-TOKEN",csrfParam);
   objHTTP.setRequestHeader('Content-length', params.length);
   objHTTP.send(params);
   return objHTTP.responseText;
}

function getPutResponse(action, params){
	   if(params.indexOf("&") === 0) {
		   params = params.substring(1);
	   }
	   var objHTTP,result;objHTTP = xhr();
	   objHTTP.open('PUT', action, false);
	   objHTTP.setRequestHeader('Content-Type','application/x-www-form-urlencoded;charset=UTF-8');
	   objHTTP.setRequestHeader("X-ZCSRF-TOKEN",csrfParam);
	   objHTTP.setRequestHeader('Content-length', params.length);
	   objHTTP.send(params);
	   return objHTTP.responseText;
	}

function sendRequestWithCallback(action, params, async, callback,method) {
    var objHTTP = xhr();
    objHTTP.open(method?method:'POST', action, async);
    objHTTP.setRequestHeader('Content-Type','application/x-www-form-urlencoded;charset=UTF-8');
    if(async){
	objHTTP.onreadystatechange=function() {
	    if(objHTTP.readyState==4) {
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

function isEmailId(str) {
    if(!str) {
        return false;
    }
    var objRegExp = new XRegExp("^[\\p{L}\\p{N}\\p{M}\\_]([\\p{L}\\p{N}\\p{M}\\_\\+\\-\\.\\'\\&]*)@(?=.{4,256}$)(([\\p{L}\\p{N}\\p{M}]+)(([\\-\\_]*[\\p{L}\\p{N}\\p{M}])*)[\\.])+[\\p{L}\\p{M}]{2,22}$","i"); // No I18N
    return XRegExp.test(str.trim(), objRegExp);
}

function isUserName(str) {
	if(!str) {
        return false;
    }
	var objRegExp = new XRegExp("^[\\p{L}\\p{N}\\p{M}\\_\\.]+$","i"); // No I18N
    return XRegExp.test(str.trim(), objRegExp);
}

function isPhoneNumber(str) {
    if(!str) {
        return false;
    }
    str = str.replace(/[+ \[\]\(\)\-\.\,]/g,'');
    var objRegExp = /^([0-9]{5,14})$/;
    return objRegExp.test(str);
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

function isNull(value){
    if(value === null || value.trim() === "") {
	return true;
    }
    return false;
}

function closeDivmgs(id) {
    de(id).className="hide";
}

function resetZohoPassword(isConfirm) {
    if(isConfirm) {
    	$(".hostid").hide();//No I18N
        var params = "a=b&" + csrfParam; //No I18N
        if(de("sname") && de("sname").value.trim() != "") {
            params += "&servicename=" + de("sname").value.trim(); //No I18N
        }
        if(de("surl") && de("surl").value.trim() != "") {
            params += "&serviceurl=" + de("surl").value.trim(); //No I18N
        }
	var res = getPlainResponse(contextpath+"/u/rpw", params);//No I18N
	var index = res.indexOf("success:");
	res = index === 0 ? res.substring(8) : res;
	if(index === 0) {
            showsuccessmsg(formatMessage(msg_link_to_reset_password, res));
            mailReqPopUp('hide'); //No I18N
        }
	else {
		de('hosterrorparent').style.display='block';
		$("#hostedeamilmessage").html(res);
        }
    }
    else {
	if(de('mailreqpopup')) {
	    de('mailpopuptitle').innerHTML = mailpopup_password_title;
	    de('mailpopupmsg').innerHTML = formatMessage(mailpopup_password_msg, userPrimaryEmailAddress);
	    de('mailtip').innerHTML = "<div style='padding-left:15px;'><ul>"+mailpopup_email_tip+"</ul></div>"; //No I18N
	    de('confirmBtn').onclick = function() {resetZohoPassword(true);};
	    mailReqPopUp('show'); //No I18N
	}
	else {
	    resetZohoPassword(true);
	}
    }
    return false;
}

function mailReqPopUp(p) {
    if(de('mailreqpopup')) {
	if(p == 'show') {
	    de('mailreqpopup').style.display='';
	    de('opacity').style.display='';
	}
	else {
	    de('mailreqpopup').style.display='none';
	    de('opacity').style.display='none';
	    de('hosterrorparent').style.display='none';
	    $(".hostid").show();
	}
    }
}

function checkRadioButtonStatus(radioEleName){
	var radioEle = de(radioEleName);
	if(radioEle) {
		radioEle.checked=true;
		var radioEleList = document.getElementsByName(radioEle.name);
		for(var i=0;i<radioEleList.length;i++){
			spanEle = de("span"+radioEleList[i].id);
			if(spanEle.id == "span"+radioEle.id){
				spanEle.className = "icon-medium radio-checked";
			}else{
				spanEle.className = "icon-medium radio-unchecked";
			}
		}
	}
}

function checkCheckBox(eve, ele, id) {
    if(isIE) {
	if(eve.keyCode == 32) {checkCheckBoxStatus(ele, id);}
    }
    else {
	if(eve.charCode == 32) {checkCheckBoxStatus(ele, id);}
    }
}

function checkCheckBoxStatus(ele, id) {
    if(ele.className == 'checkbox-uncheck') { ele.className = 'checkbox-checked'; }
    else { ele.className = 'checkbox-uncheck'; }
    if(de(id).checked == true) { de(id).checked=false; }
    else { de(id).checked=true; }
}

var previousHash = window.location.hash;
function assignHash(hashValue, urlid) {
    if(hashValue == 'admin') {
	hashValue = '#admin/' + urlid; //No I18N
    }
    else if(hashValue == 'supportadmin'){
    hashValue = '#supportadmin/' + urlid; //No I18N
    }
    else if(hashValue == 'profile') {
	hashValue = '#profile/' + urlid; //No I18N
    }
    else if(hashValue == 'setting') {
	hashValue = '#setting/' + urlid; //No I18N
    }
    else if(hashValue == 'security') {
	hashValue = '#security/' + urlid; //No I18N
    }
    else if(hashValue == 'sessions') {
	hashValue = '#sessions/' + urlid; //No I18N
    }
    else if(hashValue == 'groups') {
	hashValue = '#groups/' + urlid; //No I18N
    }
    else if(hashValue == 'privacy') {
    	hashValue = '#privacy/' + urlid; //No I18N
    }
    else {
	hashValue = '#home'; //No I18N
    }
    window.location.assign(hashValue);
    previousHash = window.location.hash;
}

function loadHash() {
    var currunt_hash = location.hash;
    if(currunt_hash == '#home/upload'){
    	openUploadPhoto('user','0'); //No I18N
    }   
    if(isEmpty(currunt_hash) || currunt_hash == '#home' || currunt_hash == '#home/upload') {
    	if(currunt_hash!='#home') {
    		try {
    			if(location.pathname.indexOf('/admin') != -1) {
    				assignHash('admin', 'user_panel'); //No I18N
    				$('#admin').click();
    				return false;
    			}
    			if(location.pathname.indexOf('/supportadmin') != -1) {
    				assignHash('supportadmin', 'appaccountrole_panel'); //No I18N
    				$('#supportadmin').click();
    				return false;
    			}
    			assignHash('home', ''); //No I18N
    		}catch (e) {
    			assignHash('home', ''); //No I18N
    		}
    	}
    	$('#home').click();
    	return false;
    }
    if(currunt_hash == '#admin') {
    	assignHash('admin', 'user_panel'); //No I18N
    	$('#admin').click();
    	return false;
    }
    if(currunt_hash == '#supportadmin') {
    	assignHash('supportadmin', 'appaccountrole_panel'); //No I18N
    	$('#supportadmin').click();
    	return false;
    }
    if(currunt_hash != '#home') {
	var mainMenuNameId = currunt_hash.split('/')[0];
	mainMenuNameId = mainMenuNameId.substring(1, mainMenuNameId.length);
	var hashMainMenu = de(mainMenuNameId);
	var subMenuNameId = currunt_hash.split('/')[1];

	var param = '';
	if(!hashMainMenu || !de(subMenuNameId)) {
	    if(hashMainMenu && subMenuNameId.indexOf('?') != -1) {
		param = subMenuNameId.substring(subMenuNameId.indexOf('?')+1, subMenuNameId.length);
		subMenuNameId = subMenuNameId.substring(0, subMenuNameId.indexOf('?'));
		if(!de(subMenuNameId)) {
	    	    assignHash('home',''); //No I18N
	    	    loadHash();
		    return false;
		}
	    } else {
	    	assignHash('home',''); //No I18N
	    	loadHash();
		return false;
	    }
	}
	
	de(mainmenu).className = '';
	hashMainMenu.className = 'active';
	mainmenu = mainMenuNameId;
	
	if(mainMenuNameId == 'profile') {
    	de('ssubmenu').style.display='none';
    	de('stsubmenu').style.display='none';
    	de('sessionmgmtsubmenu').style.display='none';
    	if(de('gsubmenu')) {
    		de('gsubmenu').style.display='none';
    	}
    	if(de('privacysubmenu')) {
    		de('privacysubmenu').style.display='none';
    	}
    	de('psubmenu').style.display='';
    }
    else if(mainMenuNameId=='security') {
    	de('psubmenu').style.display='none';
    	de('ssubmenu').style.display='none';
    	de('sessionmgmtsubmenu').style.display='none';
    	if(de('gsubmenu')) {
    		de('gsubmenu').style.display='none';
    	}
    	if(de('privacysubmenu')) {
    		de('privacysubmenu').style.display='none';
    	}
    	de('stsubmenu').style.display='';
    }
    else if(mainMenuNameId=='sessions') {
    	de('psubmenu').style.display='none';
    	de('ssubmenu').style.display='none';
    	de('stsubmenu').style.display='none';
    	if(de('gsubmenu')) {
    		de('gsubmenu').style.display='none';
    	}
    	if(de('privacysubmenu')) {
    		de('privacysubmenu').style.display='none';
    	}
    	de('sessionmgmtsubmenu').style.display='';
    }
    else if(mainMenuNameId=='setting') {
    	de('psubmenu').style.display='none';
    	de('stsubmenu').style.display='none';
    	de('sessionmgmtsubmenu').style.display='none';
    	if(de('gsubmenu')) {
    		de('gsubmenu').style.display='none';
    	}
    	if(de('privacysubmenu')) {
    		de('privacysubmenu').style.display='none';
    	}
    	de('ssubmenu').style.display='';
    }
    else if(de('gsubmenu') && mainMenuNameId == 'groups') {
    	de('psubmenu').style.display='none';
    	de('ssubmenu').style.display='none';
    	de('stsubmenu').style.display='none';
    	de('sessionmgmtsubmenu').style.display='none';
    	if(de('privacysubmenu')) {
    		de('privacysubmenu').style.display='none';
    	}
    	de('gsubmenu').style.display='';
    } else if(de('privacysubmenu') && mainMenuNameId == 'privacy') { //No I18N
    	de('psubmenu').style.display='none';
    	de('stsubmenu').style.display='none';
    	de('sessionmgmtsubmenu').style.display='none';
    	de('ssubmenu').style.display='none';
    	if(de('gsubmenu')) {
    		de('gsubmenu').style.display='none';
    	}
    	de('privacysubmenu').style.display='';
    }
	de('portfolio-wrap').style.display='none';
    de('portfolio-wrap').style.display='none';
    de('submenupanel').style.display='';
    de('zcontiner').style.display='';

	//Below check for FX requirement for showing a specific ui in account page
	if(!fromService && param) {
	    if(mainMenuNameId == 'groups') {
		if(param == 'creategroup') {
	    	    loadPage(subMenuNameId,'/ui/groups/creategroup.jsp'); //No I18N
		} else {
                    var paramArr = param.split('&');
                    param = "";
                    var isEditGroup = false;
                    for(var i=0; i<paramArr.length; i++) {
                        var tmpParamName = paramArr[i].split("=")[0];
                        if(tmpParamName != "ZGID" && tmpParamName != "showmem") { continue; }
                        if(tmpParamName == "ZGID") {isEditGroup = true;}
                        if(param == "") {
                            param += "?" + paramArr[i];
                        } else {
                            param += "&" + paramArr[i];
                        }
                    }
                    if(isEditGroup && param != "") {
                        loadPage(subMenuNameId,'/ui/groups/editGroups.jsp'+param); //No I18N
                    } else {
                        loadPage(subMenuNameId,'/ui/groups/creategroup.jsp'); //No I18N
                    }
		}
	    } else {
		$('#'+subMenuNameId).children().click();
	    }
	} else {
	    $('#'+subMenuNameId).children().click();
	}
    }
    return false;
}

function watchHash() {
    var newHash = window.location.hash;
    if($._data(window, "events") && $._data(window, "events").beforeunload) {
		if(previousHash === "#setting/authentication") {
			window.location.hash = "#setting/authentication"; //No i18N
			return;
		}
	}
    
    if(previousHash != newHash) { 
    	loadHash();
    }
}

function isEmpty(str) {
    return str ? false : true;
}
function helpPopUp(eve, ele) {
    stopEvents(eve);
    var helpEle = de('helppopup');
    var eleArr = ele.parentNode.getElementsByTagName('a');
    helpEle.style.right = (eleArr[0].offsetWidth + eleArr[1].offsetWidth) + 'px'; //No I18N
    helpEle.style.display = 'block';
    document.onclick = function(){
	helpEle.style.display = 'none';
    }
}
function changeOver(ele) {
    ele.style.backgroundColor = '#c3d1ff';
}
function changeOut(ele) {
    ele.style.backgroundColor = '#e4ebfa';
}

function isIP(str) {
    str = str.trim();
    var pattern =/^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/;
    return pattern.test(str);
}

function isDomain(str) {
    str = str.trim();
    var pattern = new XRegExp("^([\\p{L}\\p{M}\\p{N}_\\-\\.]*)(\\.[\\p{L}\\p{M}]{2,22}(\\.[\\p{L}\\p{M}]{2}){0,2})$"); // No I18N
    return XRegExp.test(str.trim(), pattern);
}

function showAlertMsg(cause) {
    de('alertpopupmsg').innerHTML = cause;
    de('alertpopup').style.display = ''; //No I18N
    de('opacity').style.display=''; //No I18N
}
function hideAlertMsg() {
    de('alertpopupmsg').innerHTML = ''; //No I18N
    de('alertpopup').style.display = 'none'; //No I18N
    de('opacity').style.display='none'; //No I18N
}
function doGet(action, params) {
    var objHTTP;
    objHTTP = xhr();
	objHTTP.open('GET', action + "?" + params, false);	//No I18N
    objHTTP.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded;charset=UTF-8');	//No I18N
    objHTTP.send(params);
    return objHTTP.responseText;
}

function showTFAErrorMsg(elementName,errormsg) {
	if($('#'+elementName).siblings('.error').length) {
		child = $('#'+elementName).siblings('.error');
		child.html(errormsg);
		child.css("display","inline"); //No I18N
		return;
	}else {
		child = document.createElement('span');
		child.className = "error";
		child.setAttribute("id", elementName + "err");
		child.innerHTML = errormsg;
		$('#'+elementName).after(child);
	}
}
function showTFAErrorMsgNew(respanelid,errormsg){
	$("#"+respanelid).html(errormsg);//No i18N
	$("#"+respanelid).addClass("errormsgnew");
	de(respanelid).style.display="block";
}

function showTFATopError(EleName, msg) {
	if (de(EleName).previousSibling !=null && de(EleName).previousSibling.className == 'error_top') {
			var element = de(EleName).previousSibling;
			element.innerHTML = msg;
			element.style.display="";
	} else {
		var newElement = document.createElement('div');
		newElement.className = "error_top";
		newElement.setAttribute("id", EleName + "err");
		newElement.innerHTML = msg;
		de(EleName).parentNode.insertBefore(newElement, de(EleName));
	}
}
function openUploadPhoto(_src,id) {
	if(_src=="user"){
		$(".photopopup").load(contextpath+'/ui/profile/photo.jsp');//No I18N
	}else if(_src="group"){//No I18N
		$(".photopopup").load(contextpath+'/ui/profile/photo.jsp?fs=thumb&type=group&EID='+euc(id));//No I18N
	}
	openPhotoPopUp();
}
function openPhotoPopUp(){
	$(".photopopup").css("cursor","auto"); //No I18N
	$(".photopopup").css("height","auto"); //No I18N
	$('#opacity,.photopopup').show(); //No I18N
	try {
		hideBackUpNumbers();
		hideBackUpDevices();
	}catch(e) {
		return false;
	}
}
//********************
//$ZPLACEHOLDER
//********************
if(isJquery){
	(function($) {
	$.support.zplaceholder = ("placeholder" in document.createElement("input")); // No I18N
	/**
	 * jQuery Plugin to stop hiding placeholder value on focus of the field, Placeholder value will be hided only after user types.
	 */
	$.fn.zPlaceHolder = function() {
		// Placeholder supported and Webkit browser (as it already hides placeholder value only after typing).
		if ($.support.zplaceholder && (!$.browser || !$.browser.msie || parseInt($.browser.version) < 10)) {
			return;
		}
		this.each(processField);
	};
	function processField(idx, input) {
		var $input = $(input), placeholder = $input.attr("placeholder"); // No I18N
		if (!$input.attr("title")) {
			$input.attr("title", placeholder); // No I18N
		}
		var $overlay = $("<span />").addClass("zph-overlay").html(placeholder).css("font-size", $(input).css("font-size")); // No I18N
		$input.removeAttr("placeholder").keydown(toggleClass).before($overlay); // No I18N
		$overlay.click(function() {
			$input.focus();
		});
		toggleClass(null, $input);
	}
	function toggleClass(e, t) {
		var $input = $(t || this);
		setTimeout(function() {
			var value = $input.val();
			if (value == 0) {
				$input.parent().removeClass("zph-hide").addClass("zph-show"); // Show Overlay // No I18N
			} else {
				$input.parent().removeClass("zph-show").addClass("zph-hide"); // Hide Overlay // No I18N
			}
		}, 0);
	}
	})(jQuery);
}
function checkSignOut(id){
	if(id.checked){
		$("#signoutall").removeClass('check-unchecked').addClass('check-checked');
	}else{
		$("#signoutall").removeClass('check-checked').addClass('check-unchecked');
	}
}
function hidetipMessage(cls){
	if($('.'+cls).is(":visible")){
		$('.'+cls).fadeOut();
		$('#tipm').removeClass("tipmessage").addClass("tipmessage_hide");
	}else{
		$('.'+cls).fadeIn();
		$('#tipm').removeClass("tipmessage_hide").addClass("tipmessage");
	}

}
function animatePlaceHolder(inputObj, isSelectOption,animate) {
	  var value = $(inputObj).val();
	  var labelElem = $(inputObj).parent().find('.inlineLabel');
	  if(value.length > 0 || isSelectOption) {
		  $(labelElem).css({display: 'block'});//No i18N
		  $(labelElem).stop(!0);
		  $(labelElem).animate({marginLeft: animate, opacity: '1'}, {queue: !1, duration: 200});//No i18N
	  } else {
		  if(value.length == 0 || isSelectOption) {
		  	if($(labelElem).hasClass('showInlineLabel')) {
		  		$(labelElem).removeClass('showInlineLabel');//No i18N
		  		$(labelElem).css({ display: 'block', marginLeft: animate, opacity: '1'});//No i18N
		  	}
		  	$(labelElem).animate({marginLeft: '3px', opacity: '0'}, {queue: !1, duration: 200, complete: function () {$(this).hide(0)}});//No i18N
		  }
	  }
}
function checkMobileWeb(inputEleId, iconEleId){
	removeFocus(inputEleId, iconEleId);
	if(de(iconEleId).className == 'icon-medium check-unchecked') {
		de(iconEleId).className = 'icon-medium check-checked';
	} else {
		de(iconEleId).className = 'icon-medium check-unchecked';
	}
    if(de(inputEleId).checked == true) {
    	de(inputEleId).checked=false;
    	if($("#signoutinfo").is(":visible")){
    		iconEleId==="signoutweb"? "" :$("#signoutinfo").slideUp("fast");//No i18N
		}
    } else {
    	de(inputEleId).checked=true;
    	if(!$("#signoutinfo").is(":visible")){
    		iconEleId==="signoutweb" ? "" : $("#signoutinfo").slideDown("fast");//No i18N
		}
    }
}
function hideLoadinginButton(pr){
	if($(".loadingImg").is(":visible")){//no i18N
    	$(".loadingImg").hide(function(){
    		$("#buttonloader").css("paddingRight",pr+"px");//no i18N
    	});
    }
}
function showLoadingButton(pr){
    $(".loadingImg").show();
    $('#buttonloader').css("paddingRight",pr+"px");//no i18n
};
function changeChoosenDropDown(id) {
    var ele = de(id);
    if(!ele) {
        return false;
    }
    if(ele.className.indexOf('chzn-with-drop')!=-1) {
        ele.className = "chzn-container chzn-container-single chzn-container-active";
    } else {
        ele.className = "chzn-container chzn-container-single chzn-container-active chzn-with-drop";
        $('#'+id+' input')[0].focus(); //No I18N
    }
}
function setFocus(check,id){
	if(check.checked){
		$("#"+id).addClass('focus-check');	
	}else{
		$("#"+id).addClass('focus-uncheck');
	}
//	
}
function removeFocus(check,id){
	if(check.checked){
		$("#"+id).removeClass('focus-check');
	}else{
		$("#"+id).removeClass('focus-uncheck');
	}
}
function setFocusRadio(check,id){
	if(check.checked){
		$("#"+id).addClass('focus-radio');
	}else{
		$("#"+id).addClass('unfocus-radio');
	}
}
function removeFocusRadio(check,id){
	if(check.checked){
		$("#"+id).removeClass('focus-radio');
	}else{
		$("#"+id).removeClass('.unfocus-radio');
	}
}
function setOverflowHeight() {
    if(de('overflowdiv')) {
        var val1 = de('zcontiner').offsetHeight+$('#zcontiner').offset().top;//No I18N
        var val2 = (de('headerdiv').offsetHeight+$('#headerdiv').offset().top)+8;//No I18N
        de('overflowdiv').style.height = (val1 - val2)+'px';
    }
}

function hideMsgPop() {
    de('messagepopupmsg').innerHTML = ''; //No I18N
    de('messagepopup').style.display = 'none'; //No I18N
    de('opacity').style.display='none'; //No I18N
    closeDivId('primid',document.editPrimary); //No I18N
}

function getIAMCookie(cn) {
	if (document.cookie.length > 0) {
		var beginIdx = document.cookie.indexOf(cn + "=");
		if (beginIdx != -1) {
			beginIdx = beginIdx + cn.length + 1;
			var endIdx = document.cookie.indexOf(";", beginIdx);
			if (endIdx == -1) {
				endIdx = document.cookie.length;
			}
			return unescape(document.cookie.substring(beginIdx, endIdx));
		}
	}
	return "";
}
function notifictionCheck(inputId,iconId){
	removeFocus(inputId, iconId);
	if(de(iconId).className == 'icon-medium check-unchecked') {
		de(iconId).className = 'icon-medium check-checked';
	} else {
		de(iconId).className = 'icon-medium check-unchecked';
	}
	if(de(inputId).checked == true) {de(inputId).checked=false;} else {de(inputId).checked=true;}
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
