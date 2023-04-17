//$Id$

var resend_timer=undefined;

function de(id) {
    return document.getElementById(id);
}

function euc(i) {
    return encodeURIComponent(i);
}
function popup_blurHandler(zin,opc){
	$(".blur").css({"z-index":zin,"opacity":opc});
	$('body').css({
	    overflow: "hidden" //No I18N
	});
}
function popupBlurHide(ele,callback){
	
	if($("#new_notification").hasClass("warning_msg")){
		Hide_Main_Notification();
	}
	$(ele).removeClass("pop_anim");
	$(ele).fadeOut(200,function(){
		$('body').css({
		    overflow: 'auto'//No i18N
		});
		$(".blur").css("z-index","-1");
		if(callback != undefined){
			callback();
		}
	});
	$(".blur").css("opacity","0");
	$(".blur").unbind();
	$(ele).unbind();
}
function watchHash() {
    var newHash = window.location.hash;
    if($._data(window, "events") && $._data(window, "events").beforeunload) {
		if(previousHash === "#setting/authentication") {
			window.location.hash = "#setting/authentication"; //No i18N
			return;
		}
	}
    
    if(previousHash != newHash) //if ythe page is opened for the first time or forward/back button is clicked in the browser
    { 
    	var prevMenu=previousHash!=""?previousHash.split("#")[1].split("/")[0]:"";
    	var currMenu=newHash!=""?newHash.split("#")[1].split("/")[0]:"";
    	if(prevMenu!=currMenu)
    	{
    		de('zcontiner').innerHTML="";
    	}
    	
    	loadHash();
    	previousHash = window.location.hash;
    }
}

function openUploadPhoto(_src,id) 
{
	if(_src=="user"){
		
		$("#picsrc").click();
		//$(".photopopup").load(contextpath+'/ui/profile/photo.jsp?clicked_option=upload');//No I18N
	
	}else if(_src="group")//No I18N
	{
		if(id=="new")//new photo for a group
		{
			$("#picsrc_grp").attr("onchange","upload_grp_pic(this)");//adding the group id
			$("#picsrc_grp").click();
		}
		else//existing photo chnage
		{
			$("#picsrc_grp").attr("onchange","change_grp_pic(this,'"+id+"')");//adding the group id
			$("#picsrc_grp").click();
		}
		
	}
}


var previousHash = window.location.hash;
function assignHash(hashValue, urlid) {
    if(hashValue == 'admin') {
	hashValue = '#admin/' + urlid; //No I18N
    }
    else if(hashValue == 'profile') {
	hashValue = '#profile/' + urlid; //No I18N
    }
    else if(hashValue == 'setting') {
	hashValue = '#setting/' + urlid; //No I18N
    }
    else if(hashValue == 'multiTFA') {
    hashValue = '#multiTFA/' + urlid; //No I18N
    }
    else if(hashValue == 'security') {
	hashValue = '#security/' + urlid; //No I18N
    }
    else if(hashValue == 'sessions') {
	hashValue = '#sessions/' + urlid; //No I18N
    }
    else if(hashValue == 'groups') {
    	if(urlid)
    	{
    		hashValue = '#groups/' + urlid; //No I18N
    	}
    	else
    	{
    		hashValue = '#groups'; //No I18N
    		previousHash = window.location.hash;
    	}
    }
    else if(hashValue == 'privacy') 
    {
    /*	if(urlid == 'dpa'){
    		if(window.location.hash.split('/')[2] == 'ccpa' ){
    			urlid = urlid+'/ccpa';	//No I18N
    		}
    		else{
    			urlid = 'dpa';			//No I18N
    			urlid = urlid+'/gdpr';	//No I18N
    		}
    	} else if(urlid == 'certifications') { //No I18N
    		urlid = urlid+'/certifications'; //No I18N
    	}*/
    	hashValue = '#privacy/' + urlid; //No I18N
    }
    else if(hashValue == "compliance"){
    	hashValue = '#compliance/' + urlid; //No I18N
    }
    else if(hashValue == "org"){
    	hashValue = '#org/' + urlid; //No I18N
    }
    else {
	hashValue = '#profile/personal'; //No I18N
    }
	if(hashValue !== window.location.hash) {
		window.location.assign(hashValue);
		previousHash = window.location.hash;
	}
}


function clicked_tab(hashValue, urlid)
{
	$(window).unbind("scroll");
	if(hashValue == 'privacy' && urlid=='dpa'){
		if( $('#ccpa_toggle').is(':checked')){
			hashValue = '#privacy/dpa/ccpa';	//No I18N
		}
		else{
			hashValue = '#privacy/dpa/gdpr';	//No I18N
		}
		if(hashValue !== window.location.hash) {
			window.location.assign(hashValue);			
		}
		previousHash = window.location.hash;
	}
	else{
		assignHash(hashValue, urlid);
	}
	highlight_tab(urlid);
	scroll_change();
//	scroll_tab(urlid,scroll_change);
}
var pre_random = undefined;
function gen_random_value(){
	do{
		var random_num_val = Math.floor(Math.random() * (10));
	}
	while(random_num_val==pre_random)
	pre_random=random_num_val;
	
	return random_num_val;
}

function setPhotoSize(ele){
	$("#dp_pic,#headder_thumb_pic,#info_thumb_pic").css({"width":"auto","height":"auto"});
	if($(ele).height()>$(ele).width()){
		$("#dp_pic,#headder_thumb_pic,#info_thumb_pic").css({"width":"auto","height":"100%"});
	}
	else if($(ele).height()<$(ele).width()){
		$("#dp_pic,#headder_thumb_pic,#info_thumb_pic").css({"width":"100%","height":"auto"});
	}
	else{
		$("#dp_pic,#headder_thumb_pic,#info_thumb_pic").css({"width":"100%","height":"100%"});
	}
}

function scroll_change()
{

	$(window).scroll(function() 
	{
	   if($(window).scrollTop()<10)
	   {   
		   if(!$($(".submenu_div:visible .submenu")[0]).hasClass("submenu_selected"))
		   {
			   args=$($('.box')[0]).parent().attr("onclick").split("(")[1].split(")")[0].split(",");//No I18N
			   assignHash(args[0].split("'")[1],args[1].split("'")[1]);
			   highlight_tab(args[1].split("'")[1]);
		   }
	   }
	 //index.jsp page converted to tpl file so document.height method is not return original value, we get height from zcontainer div
	   else if($(window).scrollTop() + window.innerHeight >= ($('#zcontiner').height() + parseInt($('#zcontiner').css('margin-top'))) - 10)
	   {
		   if(!$($(".submenu_div:visible .submenu:last")).hasClass("submenu_selected"))
		   {
			   args=$($('.box:last')).parent().attr("onclick").split("(")[1].split(")")[0].split(",");//No I18N
			   assignHash(args[0].split("'")[1],args[1].split("'")[1]);
			   highlight_tab(args[1].split("'")[1]);
		   }
	   }
	   else
	   {
			var scrollTop     = $(window).scrollTop();
			var distance=[];
			var index;
			var neg_min=-99999999;//some max value;
	        for(var i=0;i<$(".box").length;i++)
	        {
	        	if($($(".box")[i]).is(":visible"))
	        	{
		            elementOffset = $($(".box")[i]).offset().top-$('#zcontiner')[0].offsetTop;
		        	distance[i]  = Math.round(elementOffset - scrollTop);
		        	
		        	if(distance[i]<=0)
		        	{
		        		if(neg_min<distance[i])
		        		{
		        			neg_min=distance[i];
		        		}	
		        	}
	        	}
	        }
	        if(neg_min==-99999999)//if all distances are positive
	        {
	        	index=0;
	        }
	        else
	        {
	        	index=distance.indexOf(neg_min);
	        }
	
	        if(!$($(".submenu_div:visible .submenu")[index+1]).hasClass("submenu_selected"))//index plus one to go to the next tab
			{
				args=$($('.box')[index]).parent().attr("onclick").split("(")[1].split(")")[0].split(",");//No I18N
				assignHash(args[0].split("'")[1],args[1].split("'")[1]);
				highlight_tab(args[1].split("'")[1]);
			}
	   }
	});	
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
    			assignHash('profile', 'personal'); //No I18N
    		}catch (e) {
    			assignHash('profile', 'personal'); //No I18N
    		}
    	}
    	$(".menuicon").removeClass("menuicon_click");
		$(".submenu_div").removeClass("menu_click");
		$(".menu").removeClass("menu_click");
		$(".submenu_div").slideUp(200);
    	$('#profile').click();
    	return false;
    }
    if(currunt_hash == '#admin') {
    	assignHash('admin', 'user_panel'); //No I18N
    	$('#admin').click();
    	return false;
    }
    else
    {
		var mainMenuNameId = currunt_hash.split('/')[0];
		mainMenuNameId = mainMenuNameId.substring(1, mainMenuNameId.length);
		var hashMainMenu = de(mainMenuNameId);
		var subMenuNameId = currunt_hash.split('/')[1];
		var param = '';
		if((!hashMainMenu || !de(subMenuNameId))	&&subMenuNameId!=undefined) 
		{
			if(hashMainMenu && subMenuNameId.indexOf('?') != -1) 
		    {
		    	param = subMenuNameId.substring(subMenuNameId.indexOf('?')+1, subMenuNameId.length);
		    	subMenuNameId = subMenuNameId.substring(0, subMenuNameId.indexOf('?'));
		    	if(!de(subMenuNameId)) 
		    	{
		    	    assignHash('home',''); //No I18N
		    	    loadHash();
		    	    return false;
		    	}
		    } 
			else if(mainMenuNameId=="groups" && subMenuNameId=="creategroup")
			{
				param="creategroup"; //No I18N
			}
			else if(mainMenuNameId=="compliance" && subMenuNameId=="certifications"){
				$compliance.load();
			}
		    else 
		    {
		    	assignHash('profile','personal'); //No I18N
		    	loadHash();
		    	return false;
		    }
		}
		mainmenu = mainMenuNameId;
		if(param) 
		{
		    if(mainMenuNameId == 'groups') 
		    {
		    	de('portfolio-wrap').style.display='none';
			    de('zcontiner').style.display='block';
			    $("#groups .menuicon").addClass("menuicon_click");
				$("#groups").addClass("menu_click");
				
//		    	$groups.load().then(function()
//		    	{
			    	if(param == 'creategroup') 
			    	{
			    		$groups.load(param)
			    	}
			    	else//groupinfo , groupedit , groupinvite
			    	{
			    		$groups.load(subMenuNameId, param)
			    	}
//		    	});;
		    	
		    } 
		    else if(mainMenuNameId == 'privacy'){
		    	show_submenu("privacy","myc"); //No I18N
		    	$privacy.load(subMenuNameId,param);
		    }
		    else 
		    {
		    	$('#'+subMenuNameId).click();
		    }
		} 
		else 
		{
			if(de(subMenuNameId))
			{
				if(mainMenuNameId!="groups")
				{
					$('#'+subMenuNameId).click();
					return false;
				}

			}
			if(de(mainMenuNameId))
			{
				$('#'+mainMenuNameId).click();
				return false;
			}
			assignHash('profile','personal'); //No I18N
	    	loadHash();
		}
    }
    return false;
}


function show_submenu(id,panel_id,same_tab)
{
		$(".menuicon").removeClass("menuicon_click");
		$(".submenu_div").removeClass("menu_click");
		$(".menu").removeClass("menu_click");
		$("#"+id).find(".menuicon").addClass("menuicon_click");
		$("#"+id).addClass("menu_click");
		$(".submenu_div").slideUp(200,function(){
			setHeightForCover(id);
		});
		sub_id=id+"submenu";//No I18N
		if(panel_id!="")
		{
			$("#"+sub_id).slideDown(200,function(){
				setHeightForCover(id);
			});
			setHeightForCover(id);
			$("#"+sub_id).addClass("menu_click");
			highlight_tab(panel_id)
		}
}	

function highlight_tab(panel_id)
{
	$(".submenu").removeClass("submenu_selected");
	if(panel_id.indexOf("?") != -1){
		$("#"+panel_id.substring(0,panel_id.indexOf('?'))).addClass("submenu_selected");
	}
	else{
		$("#"+panel_id).addClass("submenu_selected");
	}
}




function loadTab(tabid, panel_id) 
{
	if($("#"+tabid).hasClass("menu_click") && tabid != 'admin') 
	{
		if(tabid == 'multiTFA')
		{
			if(panel_id=="settings")
			{
				$('#'+panel_id).click();
			}
		}
	    return false;
    }
    if($._data(window, "events") && $._data(window, "events").beforeunload) //TFA Setup is in progress. So confirm and proceed
    {
		show_confirm(err_tfa_setup_incomplete,
			    function() 
			    {
			    	if(tabid == 'groups') //No I18N
			        {
			        	show_submenu(tabid,"");	// show pending notification alert for any join group msgs
			    		assignHash('groups','');//No I18N
			        }
			    	loadPage(tabid,panel_id);
			    	return false;
			    },
			    function() 
			    {
			    	return false;
			    }
			);
	}
    else
    {
	    if(tabid == 'home') 
	    {
	    	mainmenu=tabid;
	        de('zcontiner').style.display='none';
	    	de('portfolio-wrap').style.display='block';
	    	$(".nav_bar").hide();
	    	assignHash(mainmenu, "");
	    	show_submenu(tabid,"");
	    	return false;
	    }
	    else if(tabid == 'groups' || tabid == "compliance")
	    {
	    	show_submenu(tabid,"");	// show pending notification alert for any join group msgs
			assignHash(tabid,panel_id);//No I18N
	    }
	    loadPage(tabid,panel_id);
	    if((tabid == 'groups') || tabid == "compliance"){
	    	mob_nav_close();
	    }
	    return false;
    }
}

function loadPage(tabid,panel_id)
{		

	if(	(! /^\s*$/.test(de('zcontiner').innerHTML)))
		{
			if(tabid!="groups")
			{
				if(mainmenu == tabid)//check if already existing in the same tab
				{
					$(window).unbind("scroll");//remove scoll shift
					submenu = panel_id;
					mainmenu = tabid;
					assignHash(mainmenu, submenu);
					mob_nav_close();
					highlight_tab(panel_id);//only highlight the new tab
					scroll_tab(panel_id,scroll_change);
					return false;
				}
			}
		}
		mainmenu = tabid;
		de('portfolio-wrap').style.display='none';
		//de('zcontiner').style.display='block';
		de('zcontiner').innerHTML='';//No I18N
		$(".content").show();
		if(mainmenu!="groups" && mainmenu!="compliance")
	    {
	    	if($("#"+panel_id).parent().prev().attr('id')!=mainmenu)
	    	{
	    		mainmenu=$("#"+panel_id).parent().prev().attr('id'); //No I18N
	    	}
	    	if(!$("#"+mainmenu).hasClass("menu_click")&&mainmenu!="privacy")
	    	{
	    		show_submenu(mainmenu,panel_id);//No I18N
	    	}
	    }
	    if(		$("#"+panel_id).hasClass('submenu')	)
	    {
	    	submenu = panel_id;
	    	loadui(tabid,panel_id) ;
	    	assignHash(mainmenu, submenu);
	    	return false;
	    } 
	    else
	    {
	    	loadui(tabid,panel_id) ;
	    }
}

function scroll_tab(panel_id,callback) 
{
	if(panel_id)
	{
	 	var id = panel_id+"_space" //No I18N
	 	$(document.scrollingElement).animate({
	        scrollTop: ($("#"+id).offset().top)-95
	    }, 200, function() 
	    {
	    	mob_nav_close();
	    	if(callback)
	    	{
		    	callback();
	    	}
	    });
	 	
	}
}

function loadui(template_id,panel_id) 
{
	$(".blur").css({"z-index":"-1","opacity":"0"});
	$('body').css({
	    overflow: 'auto' //No I18N
	});
		if(template_id=="profile")
		{
			$profile.load(panel_id);
		}
		else if(template_id=="security")
		{
			$security.load(panel_id);
		}
		else if(template_id=="multiTFA")
		{
			$MFA.load(panel_id);
		}
		else if(template_id=="setting")
		{
			$settings.load(panel_id);
		}
		else if(template_id=="sessions")
		{
			$sessions.load(panel_id);
		}
		else if(template_id=="groups")
		{
			$groups.load(panel_id);
		}
		else if(template_id=="privacy")
		{
			$privacy.load(panel_id);
		}
		else if(template_id=="compliance"){
			$compliance.load();
		}
		else if(template_id=="org")
		{
			$org.load(panel_id);
		}
    //	$(document).ztooltip();

	//	tippy(".action_icon");

		$(window).unbind('beforeunload');
    return true;
}


function set_popupinfo(heading,description)
{	
	$("#common_popup").addClass("default_popup");
	if(heading!=""	&& description!="")
	{
		$('#common_popup .popup_header').show();
		$('#common_popup .popuphead_text').html(heading);
		$('#common_popup .popuphead_define').html(description);
	}
	else
	{
		$('#common_popup .popup_header ').hide();
	}

	$("#common_popup").show(0,function(){
		$("#common_popup").addClass("pop_anim");
	});
	popup_blurHandler("6",".5");
}
function close_popupscreen(callback)
{
	clearInterval(resend_timer);
	popupBlurHide("#common_popup",function(){		//No I18N
		$("#common_popup #pop_action").html("");
		if(callback){
			callback();
		}
	});
	remove_error();
	$("#pop_action select").unbind();
	$(".photo_radio").unbind();
	$("#sign_in_notification").unbind();
	$(".suscription_radio").unbind();
}


var setTime=""; //this variable used for stop previous settime out function

function relogin_warning()
{
	$(".error_msg").show();
	$(".error_msg").removeClass("sucess_msg");
	$(".error_msg").addClass("warning_msg");
	$("#succ_or_err").html("");
	$("#succ_or_err_msg").html(relogin_warning_msg);
	$(".error_msg_cross").html("");
	$(".error_msg_cross").append("<span class='warnline1'></span><span class='warnline2'></span>");

	
	var height =($(".error_msg_text")[0].clientHeight/2)-18;
	
	
	if(setTime!=""){
		clearTimeout(setTime);
	}
	
		setTime = setTimeout(function() {
	$(".error_msg").css("top","-100px");
	}, 10000);	
	
$(".error_msg").css("top","60px");
	$("#new_notification").click(function(){
		$(".error_msg").css("top","-100px");
		$(".error_msg").hide();
		$("#succ_or_err_msg").html("");
		$("#new_notification").attr("onclick","Hide_Main_Notification()");
		$("#new_notification").unbind();
	});
}

function showErrorMessage(msg) 
{
	if(msg!=""	&& msg!=undefined)
	{
		$(".error_msg").show();
		$(".error_msg").removeClass("sucess_msg");
		$(".error_msg").removeClass("warning_msg");
		$("#succ_or_err").html("");
		$("#succ_or_err_msg").html(msg);
		$(".error_msg_cross").html("");
		$(".error_msg_cross").append("<span class='crossline1'></span><span class='crossline2'></span>");
	
		
		var height =($(".error_msg_text")[0].clientHeight/2)-18;
    
		
		
		$(".error_msg").css("top","60px");
		

		if(setTime!=""){
			clearTimeout(setTime);
		}
		
		setTime = setTimeout(function() {
			$(".error_msg").css("top","-100px");
		}, 5000);		

	}

}

function getErrorMessage(response) 
{
	if(response.cause && response.cause.trim() === "throttles_limit_exceeded") 
	{
		return thottle_reached_msg;
	}
	if(response.localized_message) 
	{
		return response.localized_message;
	}
	if(response.message) 
	{
		return response.message;
	}
	return err_try_again;
}


function SuccessMsg(msg, time_msec) 
{
	if(!time_msec) {
		time_msec = 3000;
	}
	if(msg!=""	&& msg!=undefined)
	{
		$(".error_msg").show();
		$(".error_msg").addClass("sucess_msg");
		$(".error_msg").removeClass("warning_msg");
		$("#succ_or_err").html("");
		$("#succ_or_err_msg").html(msg);
		$(".error_msg_cross").html("");
		$(".error_msg_cross").append("<span class='tick'></span>");
	
    
    
		var height =($(".error_msg_text")[0].clientHeight/2)-18;
		
		
    $(".error_msg").css("top","60px");
		
    if(setTime!=""){
			clearTimeout(setTime);
		}
    
    setTime = setTimeout(function() {
    $(".error_msg").css("top","-100px");
    }, time_msec);
    
	}

}
function Hide_Main_Notification()
{
	$(".error_msg").css("top","-100px");
}

function show_confirm(msg, yesCallback, noCallback)
{
	popup_blurHandler("6",".5");
	
	$(".confirm_text").html(msg);
	$("#confirm_popup").show(0,function(){
		$("#confirm_popup").addClass("pop_anim");
	});
	$("#confirm_popup").focus();
   // var dialog = $('#confirm_popup').dialog();
	
    $('#return_true').click(function() {
     //   dialog.dialog('close');
	 	popupBlurHide("#confirm_popup");	//No I18N
	    yesCallback();
	    $('#return_false').unbind();
		$('#return_true').unbind();
    });
    
    $('#return_false').click(function() {
    //    dialog.dialog('close');
    	popupBlurHide("#confirm_popup");	//No I18N
	 	noCallback();
	 	$('#return_false').unbind();
		$('#return_true').unbind();
		$('.blue').unbind();

    });
    $("#confirm_popup").keydown(function(e) {   
	    if (e.keyCode == 27) {
	    	$('#return_false').click();
	    }
	});
    $(".blur").click(function(){
    	$('#return_false').click();
    	$(".blur").unbind();
    });

}



function resend_countdown(ele_id)
{
	$(ele_id+" a").html(resend_otp_countdown);
	$(ele_id+" a").addClass("resend_otp_blocked")
	var time_left=59;
	resend_timer=undefined;
	resend_timer = setInterval(function()
	{
		$(ele_id+" a span").text(time_left);
		time_left-=1;
		if(time_left<=0)
		{
			clearInterval(resend_timer);
			$(ele_id+" a").removeClass("resend_otp_blocked");
			$(ele_id+" a").html(resend_otp);
		}
	}, 1000);
}


function goToForgotPwd()
{
	window.location.href = contextpath+'/password?email='+euc(userPrimaryEmailAddress); //No I18N    
}


function show_resetpassword() //not cureently used
{
	if($(".close_btn").is(":visible"))
	{
		$(".close_btn").click();
	}
	else if($(".expand_closebtn").is(":visible"))
	{
		$(".expand_closebtn").click();
	}
	set_popupinfo(mailpopup_password_title,formatMessage(mailpopup_password_msg, userPrimaryEmailAddress));
	$('#pop_action').append("<div class='note_container'><b>"+note+"</b><ul>"+mailpopup_email_tip+"</ul></div>"); 

	
	$('#pop_action').append("<button  class='primary_btn_check' onclick='resetZohoPassword();'>"+sendMail_butt+"</button>");  //No I18N
	$('#pop_action .primary_btn_check').focus();
	closePopup(close_popupscreen,"common_popup");//No I18N
}


function openInNewTab(url) 
{
  var win = window.open(url, '_blank');
  win.focus();
}

function go_to_link(link,is_newtab)
{
	if(!is_newtab)
	{
		window.open(link,"_self");
		return;
	}
	window.open(link,"_blank");
}

function remove_error(ele)
{
	if(ele){
		$(ele).siblings(".field_error").remove();
	}
	else{
		$(".field_error").remove();	
	}
}

function isIP(str) 
{
    str = str.trim();
    var pattern =/^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/;
    return pattern.test(str);
}
function isEmailId(str) 
{
    if(!str) 
    {
        return false;
    }
    str = str.trim();
    var objRegExp  = /^[\w]([\w\-\.\+\']*)@([\w\-\.]*)(\.[a-zA-Z]{2,22}(\.[a-zA-Z]{2}){0,2})$/i;
    return objRegExp.test(str);
}

function isPhoneNumber(str) 
{
    if(!str) 
    {
        return false;
    }
    str = str.replace(/[+ \[\]\(\)\-\.\,]/g,'');
    var objRegExp = /^([0-9]{7,14})$/;
    return objRegExp.test(str);
}

function escapeHTML(value) 
{
	if(value) {
		value = value.replace("<", "&lt;");
		value = value.replace(">", "&gt;");
		value = value.replace("\"", "&quot;");
		value = value.replace("'", "&#x27;");
		value = value.replace("/", "&#x2F;");
    }
    return value;
}
function formatMessage() {
    var msg = arguments[0];
    if(msg != undefined) {
	for(var i = 1; i < arguments.length; i++) {
	    msg = msg.replace('{' + (i-1) + '}', escapeHTML(arguments[i].toString()));
	}
    }
    return msg;
}
function getPlainResponse(action, params) 
{
	if (typeof contextpath !== 'undefined') {
		action = contextpath + action;
	}
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
	if (typeof contextpath !== 'undefined') {
		action = contextpath + action;
	}
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

function sendRequestWithCallback(action, params, async, callback) {
	if (typeof contextpath !== 'undefined') {
		action = contextpath + action;
	}
    var objHTTP = xhr();
    objHTTP.open('POST', action, async);
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
function xhr() {
    var xmlhttp;
    if (window.XMLHttpRequest) {
	xmlhttp=new XMLHttpRequest();
    }
    else if(window.ActiveXObject) 
    {
		try 
		{
		    xmlhttp=new ActiveXObject("Msxml2.XMLHTTP");
		}
		catch(e) 
		{
		    xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
		}
    }
    return xmlhttp;
}
function isEmpty(str) 
{
    return str ? false : true;
    
}

/***************************** clipboard copy *********************************/

function clipboard_copy()
{	
	
    var range = document.createRange();
    range.selectNode(document.getElementById("password_key"));
    window.getSelection().removeAllRanges();
    window.getSelection().addRange(range);
    document.execCommand("copy");//No I18N
    window.getSelection().removeAllRanges();
    if($(".app_password_grid").attr("data-original-title")==err_app_pass_click_text){
    	$(".app_password_grid")[0]._tippy.destroy();
    }   
    if(document.querySelector('.app_password_grid[data-tippy]')==null){
    	$(".app_password_grid").attr("title",err_app_pass_copied);
    	tippy(".app_password_grid",{//No I18N
    		trigger:"click mouseenter",//No I18N
    		arrow:true,
    		onHidden:tooltip_outFunc
    	});
    }
	document.querySelector('.app_password_grid[data-tippy]')._tippy.show();//No I18N
	
}

function tooltip_outFunc()
{
		document.querySelector('.app_password_grid[data-tippy]')._tippy.destroy();//No I18N
		$(".app_password_grid").attr("title",err_app_pass_click_text); //No I18N
		tippy(".app_password_grid",{//No I18N
    		trigger:"mouseenter",	//No I18N	
    		arrow:true
		});
}

/***************************** From Validation *********************************/

$("input").keyup(function() 
		{
			remove_error();
		});


function isBlank(str) 
{
    return (/^\s*$/.test(str));
}


function validateForm(form,callback)
{
	remove_error();
	var toSubmit = true;
	var re;
	//var url=form.getAttribute("action");
	$.each($("#"+form.id).serializeArray(), function(i, field) 
	{
	  var input = $('#'+form.id+' [name='+field.name+']');
	  var type=input.attr("type"); //No i18N
	  field.value = $.trim(field.value);
	  if(input.attr("data-validate")=="zform_field"&&(input.is(":visible")||$(input).is("select")))
	  {
		  if(!input.attr("data-optional"))
		  {
			  if(isEmpty(input.val())	||	isBlank(input.val()) )
			  {
				  if(input.parent().is(":visible"))
				  {
					  input.parent().append( '<div class="field_error">'+empty_field+'</div>' );
				  }
				  else
				  {
					  showErrorMessage(empty_field);
				  }
				  toSubmit=false;
			  }
			  else if(input.attr("data-limit"))
			  {
				  if(input.val().length>input.attr("data-limit"))
				  {
					  if(input.parent().is(":visible"))
					  {
						  input.parent().append( '<div class="field_error">'+max_size_field+'</div>' );
					  }
					  else
					  {
						  showErrorMessage(max_size_field);
					  }
					  toSubmit=false;
				  }
			  }
			  else if($(input).is("select")	&&	input.prop('selectedIndex')==-1)
			  {
				  if(input.parent().is(":visible"))
				  {
					  input.parent().append( '<div class="field_error">'+empty_field+'</div>' );
				  }
				  else
				  {
					  showErrorMessage(empty_field);
				  }
				  toSubmit=false;
			  }
		  }
		  
		  if(toSubmit)
		  {
			  
		
			  if((type=="tel")&& input.attr("data-type")=="phonenumber" )
			  {
				  if(!isPhoneNumber(input.val()))
				  {
					  if(input.parent().is(":visible"))
					  {
						  input.parent().append( '<div class="field_error">'+err_enter_valid_mobile+'</div>' );
					  }
					  else
					  {
						  showErrorMessage(err_enter_valid_mobile);
					  }
					  toSubmit=false;
				  }
			  }
			  else if(type=="password")
			  { 
				  if(input.val().length>euserPassMaxLen)
				  {
					  if(input.parent().is(":visible"))
					  {
						  input.parent().append( '<div class="field_error">'+formatMessage(err_password_maxlen, euserPassMaxLen)+'</div>' );
					  }
					  else
					  {
						  showErrorMessage(formatMessage(err_password_maxlen, euserPassMaxLen));
					  }
					  toSubmit=false;
				  }
			  }
			  else if(type=="email")
			  {
				  if(!isEmailId(input.val()))
				  {
					  if(input.parent().is(":visible"))
					  {
						  input.parent().append( '<div class="field_error">'+err_validemail+'</div>' );
					  }
					  else
					  {
						  showErrorMessage(err_validemail);
					  }
					  toSubmit=false;
				  }
				  
			  }
			  else if(type=="url")
			  {
				  if(false)
				  {
					  if(input.parent().is(":visible"))
					  {
						  input.parent().append( '<div class="field_error">'+err_url_pattern+'</div>' );
					  }
					  else
					  {
						  showErrorMessage(err_url_pattern);
					  }
					  toSubmit=false;
				  }
			  }
		  }
	  }  
	 })
	 if(toSubmit)
	 {
		 return toSubmit;
//		 var parms;
//		 if($("#"+form.id).find("input[type='file']").length > 0) //if any file upload exists.
//		{
//			 parms=getParamsForFile(form);
//			 sendRequestURIForFiles(url,parms,callback);
//		}
//		 else
//		{
//			 parms=getparams(form);
//			 sendRequestURI(url,parms,callback)
//			 
//		}
	 }
}


function clear_loading()
{
	$(".tfa_blur").hide();//tfa
	$(".loader").hide();//tfa
	
	
}



//for closing all popups including the view all popups using keys

function closePopup(func,id,prevent_closing)
{
	$(".blur").unbind();
	$("#"+id).keydown(function(e) {   
		
		if(e.keyCode == 27) {
			
		    if((id=="phonenumber_web_more")||(id=="emails_web_more")||(id=="tfa_phonenumber_web_more")){
		    	if($("#"+id+" .inline_action" ).length > 0){
		    		$("#"+id+" .inline_action" ).slideUp(300,function(){
		    			$("#"+id+" .inline_action").remove();
		    		});
		    		if(id=="emails_web_more"){
		    			$(".action_icons_div").removeClass("show_icons");
		    			$(".action_icons_div span").removeClass("selected_icons");
			    		$(".field_email").removeClass("web_email_specific_popup");
		    		}
		    		else if(id=="phonenumber_web_more"){
		    			$(".action_icons_div_ph").removeClass("show_icons");
			    		$(".field_mobile").removeClass("web_email_specific_popup");		    			
		    		}
		    		else if((id=="tfa_phonenumber_web_more")){
		    			$(".email_hover").removeClass("show_icons");
		    			$(".tfa_backupnumber").removeClass("web_email_specific_popup");
		    		}
		    		$(".action_icon").removeClass("selected_icons");
		    		$("#"+id).focus();
				}
		    	else{
		    		func();
		    		$('#'+id).unbind();
		    	}
		    }
		    else if((id=="connected_apps_web_more")||(id=="app_password_web_more")||(id=="authorized_linked_more")||(id=="allow_ip_web_more")||(id=="history_web_more")||(id=="api_tokens_more")||(id=="sessions_web_more")||(id=="authorized_web_more")||(id=="Device_logins_web_more")||(id=="App_logins_web_more")){
		    	var hide_Check=false;
		    	for(var i=0; i<($("#"+id+" .aw_info" ).length);i++ ){
		    		if($($("#"+id+" .aw_info_rename" )[i]).is(":visible")){
		    			hide_Check=true;
		    			break;
		    		}
		    		else if($($("#"+id+" .aw_info" )[i]).is(":visible")){
		    			hide_Check=true;
		    			break;
		    		}
		    	}	
		    	if(hide_Check){
		    		$("#"+id+" .Field_session").addClass("autoheight");
		    		$("#"+id+" .aw_info" ).slideUp(300);
		    		$("#"+id+" .aw_info_rename" ).slideUp(300);
		    		setTimeout(function(){
		    			$(".allowed_ip_entry,.Field_session").removeClass("Active_ip_showall_hover");
		    			$(".Field_session").removeClass("web_email_specific_popup");
		    		},300)
		    		$(".activesession_entry_info").show();
		    		$("#"+id).focus();
		    	}
		    	else{
		    		func();
		    		$('#'+id).unbind();
		    	}
		    	$("#"+id+" .Field_session").removeClass("autoheight");
		    }
		    else{
		    	func();
		    	$('#'+id).unbind();
		    }
	    }
	});
	if(!prevent_closing)
	{
		$(".blur").click(function(){
			func();
			$('#'+id).unbind();
		});
	}

}

function phoneSelectformat(option) {		//use to country flag structure in select2
    var spltext;
	if (!option.id) { return option.text; }
	spltext=option.text.split("(");
	var num_code = $(option.element).attr("data-num");
	var string_code = $(option.element).attr("value");

	var ob = '<div class="pic flag_'+string_code+'" ></div><span class="cn">'+spltext[0]+"</span><span class='cc'>"+num_code+"</span>" ;
	return ob;
};

function selectFlag(e){
    var flagpos = "flag_"+$(e).val().toUpperCase();//No i18N
    $(".select2-selection__rendered").attr("title","");
    e.parent().siblings(".select2").find("#selectFlag").attr("class","");//No i18N
    e.parent().siblings(".select2").find("#selectFlag").addClass("selectFlag");//No i18N
    e.parent().siblings(".select2").find("#selectFlag").addClass(flagpos);//No i18N
}

function codelengthChecking(length_id,changeid){
	var code_len=$(length_id).attr("data-num").length;
	var length_ele = $(length_id).parent().siblings("#"+changeid);
	length_ele.removeClass("textindent58");
	length_ele.removeClass("textindent66");
	length_ele.removeClass("textindent78");
	if(code_len=="3"){
		length_ele.addClass("textindent66");
    }
    else if(code_len=="2"){
    	length_ele.addClass("textindent58");
    }
    else if(code_len=="4"){
    	length_ele.addClass("textindent78");
    }
	length_ele.focus();
}
function tooltipSet(arg){
	tippy(arg, {
		  animation: 'scale',//No I18N
		  arrow: true
		});
	}
function sessiontipSet(arg){
	tippy(arg, {
		  animation: 'scale', //No I18N
		  arrow: true,
		  distance: 30,
		  placement:'bottom'//No I18N
		});
	}
function closeNotification(){
	$(".notifications_div").removeClass("show_notifications");
	setTimeout(function(){
		$("html").removeClass("donnotscroll");
	},300);
}
function close_pro_expand(){
	$(".header_pp_expand").removeClass("header_pp_expand_show");
	setTimeout(function(){
		$("html").removeClass("donnotscroll");
	},300);
}

function setDefault_dp(ele){
	if($(ele).parents().hasClass("select2-results")||$(ele).parents().hasClass("selection")){
		ele.src=imgurl+"/user_2.png";		
	}
	else{
		ele.src=imgurl+"/group_2.png";	
	}	
}
function show_notification()
{
	$(".notifications_div").addClass("show_notifications");
	slideClose(".notifications_div", ".notification_close");// No I18N
	$(".notifications_div").focus();
	$(".topbar_notification .notification_on").hide();
	$("html").addClass("donnotscroll");
}

function slideClose(ele_id, func_id) 
{
	$(ele_id).keydown(function(e) {
		if (e.keyCode == 27) {
			$(func_id).click();
		}
	});
}

function mob_nav_close(){
	$(".navbar").removeClass("shownav_formobile");
	$(".nav_blur").removeClass("showblur");
	$("html").removeClass("scrolloff");
}
$(document).ready(function() {
	/*--------------moblile view navigation bar function-------------*/
	

	$(".showallmenu_formobile").click(function() 
	{
		Hide_Main_Notification();
		if ($(".navbar").hasClass("shownav_formobile") == "1") {
			mob_nav_close();
		} else {
			$(".navbar").addClass("shownav_formobile");
			$(".nav_blur").addClass("showblur");
			$("html").addClass("scrolloff");
		}

	});
	$(".topbar_pp").click(function(event) {
		mob_nav_close();
		$(".header_pp_expand").addClass("header_pp_expand_show");
		slideClose(".header_pp_expand", "#close_pp_expand");// No I18N
		$(".header_pp_expand").focus();
		$("html").addClass("donnotscroll");
		event.stopPropagation();
	});

	$(".nav_blur").click(function() {
		mob_nav_close();
	});

	$(".topbar_notification").click(function() {
		mob_nav_close();
		$(".notifications_div").addClass("show_notifications");
		slideClose(".notifications_div", ".notification_close");// No I18N
		$(".notifications_div").focus();
		$(".topbar_notification .notification_on").hide();
		$("html").addClass("donnotscroll");
	});
	
	function slideClose(ele_id, func_id) {
		$(ele_id).keydown(function(e) {
			if (e.keyCode == 27) {
				$(func_id).click();
			}
		});
	}
	$(document).click(function(e){
		if(!$(e.target).hasClass("menu_more")&&!$(e.target).parents().hasClass("menu_more")){
			$('.menu_more').removeClass("show_after");//for nav overflow popup
 			$(".hidden_popup").hide();
		}
		if($(".header_pp_expand").hasClass("header_pp_expand_show")&&!$(e.target).hasClass("topbar_pp")){
			if((!$(e.target).hasClass("header_pp_expand")&&!$(e.target).parents().hasClass("header_pp_expand"))){
				close_pro_expand();
			}
		}
		if($(".notifications_div").hasClass("show_notifications")&&!$(e.target).hasClass("topbar_notification")){
			if((!$(e.target).hasClass("notifications_div")&&!$(e.target).parents().hasClass("notifications_div")&&!$(e.target).parents().hasClass("topbar_notification"))){
				closeNotification();
			}
		}
	});
});
function control_Enter(tag){
	$(tag).keypress(function(event){
		if(event.keyCode==13){
			this.click();
		}
	});
}
function tooltip_Des(ele){
	if((document.querySelector(ele)!=null)&&(document.querySelector(ele)._tippy!=undefined)){
		for(var i=0;i<$(ele).length;i++){
			if($(ele)[i]._tippy!=undefined){
				$(ele)[i]._tippy.destroy();
			}
		}
	}
}

function phonecodeChangeForMobile(ele)
{
	$(ele).css({'opacity':'0','width':'50px'});
	$(ele).siblings(".phone_code_label").html($(ele).children("option:selected").attr("data-num"));// No I18N
	$(ele).change(function(){
		$(ele).siblings(".phone_code_label").html($(ele).children("option:selected").attr("data-num"));// No I18N
	})
}
function disabledButton(form_ele){
	$(form_ele).find("button").attr("disabled", "disabled");
	$(form_ele).find("button:visible:not(.browse_btn):first").addClass("button_disable");
	$(form_ele).find("button:visible:not(.browse_btn):first").removeClass("primary_btn_check");
}
function removeButtonDisable(form_ele){
	$(form_ele).find("button").removeAttr("disabled");
	$(form_ele).find(".button_disable").addClass("primary_btn_check");
	$(form_ele).find(".primary_btn_check").removeClass("button_disable");
}

function validatelabel(val)
{
	var regex = /^[0-9a-zA-Z_\s\-\.\$@\?\,\:\'\/\!]+$/; //No I18N
	if(val.search(regex) == -1){
		return false; //No I18N
	}
	return true; //No I18N
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

function DeleteCookie(name, callback, path, domain)
{
    path = (path ? ";path=" + path : "");// No I18N
    domain = (domain ? ";domain=" + domain : "");// No I18N
    var expiration = "Thu, 01-Jan-1970 00:00:01 GMT";// No I18N
    document.cookie = name + "=" + path + domain + ";expires=" + expiration;
    if(callback!=undefined)
    {
    	callback();
    }
}
function downloadFile(filename, text) {
	  var element = document.createElement('a');
	  element.setAttribute('href', 'data:text/plain;charset=utf-8,' + encodeURIComponent(text));
	  element.setAttribute('download', filename);
	
	  element.style.display = 'none';
	  document.body.appendChild(element);
	
	  element.click();
	
	  document.body.removeChild(element);
}

function decodeHTML(t){
	return t != "" ? $('<div />').html(t).text() : "";
}
function go_to_oldui()
{
	window.location.href=window.location.origin+'/u/h';
}