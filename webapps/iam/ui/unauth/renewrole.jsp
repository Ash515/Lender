<%--$Id$--%>
<%@page import="org.json.JSONArray"%>
<%@page import="java.util.Arrays"%>
<%@page import="com.zoho.accounts.mail.SendMail.MailType"%>
<%@page import="java.util.concurrent.TimeUnit"%>
<%@page import="com.zoho.resource.Criteria.Comparator"%>
<%@page import="com.zoho.accounts.mail.MailUtil.MailConstants"%>
<%@page import="com.zoho.resource.URI"%>
<%@page import="com.zoho.accounts.AppResource"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="com.zoho.accounts.AppResource.UserSystemRolesURI"%>
<%@page import="com.zoho.accounts.AppResource.RESOURCE.USERSYSTEMROLES"%>
<%@page import="com.zoho.accounts.AppResourceProto.App.AppSystemRole.UserSystemRoles"%>
<%@page import="com.adventnet.iam.security.SecurityUtil"%>
<%@page import="java.util.logging.Level"%>
<%@page import="java.util.logging.Logger"%>
<%@page import="com.zoho.accounts.AccountsProto.Account.Digest"%>
<%@page import="com.zoho.accounts.Accounts.RESOURCE.DIGEST"%>
<%@page import="org.json.JSONObject"%>
<%@page import="com.zoho.resource.Criteria"%>
<%@page import="com.adventnet.iam.User"%>
<%@page import="com.adventnet.iam.internal.Util"%>
<%@page import="com.adventnet.iam.IAMUtil"%>
<%@page import="com.zoho.accounts.AccountsConstants"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../../static/includes.jspf"%>
<%!private static Logger logger = Logger.getLogger("RENEW_ROLE");// No I18N %>
<%
boolean is_static = "true".equals(com.zoho.accounts.AccountsConfiguration.getConfiguration("iam.static", "false"));
String imgURL = is_static ? Util.getIMGURL(request) : request.getContextPath()+"/images";//No I18N
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title><%=Util.getI18NMsg(request,"IAM.ROLE.RENEW.TEXT")%></title>
<meta name="viewport" content="width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=no" />
<script src="<%=jsurl%>/jquery-1.12.2.min.js" type="text/javascript"></script> <%-- NO OUTPUTENCODING --%>
<link href="<%=cssurl%>/accountsstyle.css" rel="stylesheet" type="text/css" /> <%-- NO OUTPUTENCODING --%>
<script>
function go_to_main_homepage(){
	window.location.href= '/'; // NO I18N
}
</script>
<style type="text/css">
@font-face {
	font-family: 'Open Sans';
	font-weight: 400;
	font-style: normal;
	src: local('Open Sans'), url('<%=imgURL%>/opensans/font.woff') format('woff'); <%-- NO OUTPUTENCODING --%>
}

body {
	display: block;
	margin: 0;
	font-family: 'Open Sans', sans-serif;
}

.content {
	display: block;
	width: 50%;
	max-width: 600px;
	margin-right: 100px;
	margin-left: 50%;
	padding-top: 80px;
}

.zoho_logo {
	display: block;
	height: 27px;
	width: auto;
	background: url('<%=imgURL%>/Zoho_logo.png') no-repeat transparent; <%-- NO OUTPUTENCODING --%>
	background-size: auto 100%;
	margin-bottom: 10px;
}

.heading {
	display: block;
	margin-bottom: 10px;
	font-size: 24px;
	line-height: 40px;
	font-weight: 600;
}

.discription {
	display: block;
	margin-bottom: 30px;
	font-size: 16px;
	line-height: 30px;
	font-weight: 400;
}

.servicelist {
	display: block;
	height: auto;
	width: 414px;
	margin-bottom: 30px;
	cursor: pointer;
	border: 2px solid transparent;
	transition: all .2s ease;
}

.service_head {
	position: relative;
	padding-right: 0px;
	height: 24px;
}

.service_name {
	display: inline-block;
	font-size: 16px;
	font-weight: 600;
	margin-left: 10px;
}

.box {
	display: block;
	height: auto;
	border-radius: 4px;
	cursor: auto;
}

.roles_div {
	display: block;
	position: relative;
	margin-left: 30px;
}

.checkbox_div {
	display: inline-block;
    height: 20px;
    width: 165px;
    margin-top: 15px;
    cursor: pointer;
}

.checkall {
	display: block;
	margin-right: 20px;
}

.realcheckbox {
	display: inline-block;
	position: absolute;
	height: 15px;
	width: 15px;
	margin: 0px;
	margin-left: -15px;
	opacity: 0;
	cursor: pointer;
	z-index: 1;
}

.checkall .realcheckbox {
	margin-left: 0px;
}

.checkbox_style {
	display: inline-block;
	height: 12px;
	width: 12px;
	border: 2px solid #dddddd;
	border-radius: 2px;
	float: left;
	margin: 2px 0px;
}

.checkbox_style_tick:after {
	content: "";
	display: block;
	height: 3px;
	width: 7px;
	border-bottom: 2px solid #fff;
	border-left: 2px solid #fff;
	transform: rotate(-45deg);
	margin: 3px 2px;
}

.selectall_style_tick:after {
	content: "";
	display: block;
	height: 3px;
	width: 7px;
	border-bottom: 2px solid #e7f2ff;
	border-left: 2px solid #e7f2ff;
	transform: rotate(-45deg);
	margin: 3px 2px;
}

.realcheckbox:hover ~ .checkbox_style {
	border: 2px solid #54B772;
}

.realcheckbox:checked ~ .checkbox_style {
	border: 2px solid #54B772;
	background-color: #54B772;
}

.checbox_indeterminate:after {
	content: "";
	display: block;
	height: 1px;
	width: 8px;
	border-bottom: 2px solid #fff;
	margin: 4px 2px;
}

.checkbox_label {
	display: inline-block;
	font-size: 14px;
	line-height: 20px;
	margin-left: 10px;
	width: 136px;
	overflow-x: hidden;
	text-overflow: ellipsis;
	cursor: pointer;
}

input, button {
	outline: none;
}

.buttons {
	margin-top: 10px;
	margin-bottom: 30px;
}

.btn {
	display: inline-block;
	height: 36px;
	margin-right: 20px;
	border: none;
	border-radius: 2px;
	font-size: 13px;
	font-weight: 600;
	padding: 0px 30px;
	cursor: pointer;
}

.green {
	background-color: #54B772;
	color: #fff;
}

.green:hover {
	background-color: #3CA85C;
}

.grey {
	background-color: #EEEEEE;
	color: #686868;
}

.grey:hover {
	background-color: #E1E1E1;
}

.showall {
	display: inline-block;
	height: 30px;
	background-color: #F1F7FF;
	width: auto;
	min-width: 80px;
	color: #4A90E2;
	font-size: 14px;
	font-weight: 600;
	border-radius: 15px;
	padding: 5px 15px;
	box-sizing: border-box;
	margin-bottom: 10px;
	cursor: pointer;
}

.showall:hover {
	background-color: #E5F0FE;
}

.showall:after {
	content: "";
	display: inline-block;
	height: 5px;
	width: 5px;
	margin-left: 5px;
	border-left: 2px solid #4A90E2;
	border-bottom: 2px solid #4A90E2;
	transform: rotate(-45deg);
	position: relative;
	top: -4px;
}

.darkbg {
	display: none;
	height: 100%;
	width: 100%;
	position: fixed;
	background-color: #000;
	opacity: .6;
	z-index: 2;
	top: 0;
}

.body_bg {
	display: block;
	height: 100%;
	width: 100%;
	position: fixed;
	z-index: -1;
	top: 0;
	font-family: 'Open Sans', sans-serif;
	background: url('<%=imgURL%>/Group.png') no-repeat transparent; <%-- NO OUTPUTENCODING --%>
	background-size: 100%;
}

.popup {
	display: none;
	width: 500px;
	height: auto;
	max-height: 720px;
	position: fixed;
	top: 80px;
	bottom: 80px;
	left: 0;
	right: 0;
	background-color: #fff;
	border-radius: 4px;
	z-index: 3;
	margin: auto;
	overflow: hidden;
	transition: all .2s ease;
}

.popup_heading_text {
	display: inline-block;
	font-size: 18px;
	line-height: 30px;
	font-weight: 600;
}

.popup_heading {
	display: block;
	height: 30px;
	width: 440px;
	padding: 30px;
	padding-bottom: 0px;
}

.services_div {
	padding: 10px 30px;
	height: calc(100% - 220px);
	overflow-y: scroll;
}

.services_div .servicelist {
	width: 436px;
}

.pu_bottom {
	display: block;
	padding: 30px;
	width: 100%;
	box-sizing: border-box;
	background-color: #F7F7F7;
	position: relative;
	bottom: 0;
}

.pu_close {
	display: inline-block;
	float: right;
	height: 30px;
	width: 30px;
	border-radius: 15px;
	background-color: #EEEEEE;
	box-sizing: border-box;
	padding: 8px 12px;
	cursor: pointer;
	transition: all .2s ease;
}

.pu_close:after {
	display: inline-block;
	content: "";
	height: 14px;
	width: 2px;
	background-color: #C8C8C8;
	border-right: 1px;
	transform: rotate(-45deg);
}

.pu_close:before {
	display: inline-block;
	content: "";
	height: 14px;
	width: 2px;
	background-color: #C8C8C8;
	border-right: 1px;
	transform: rotate(45deg);
	position: relative;
	left: 2px;
}

.pu_close:hover {
	background-color: #E8E8E8;
	transform: scale(1.2);
}

.close_popup {
	display: none;
	transform: scale(.8);
}

.select_all_option {
	position: relative;
	width: 100%;
	height: 40px;
	color: #4A90E2;
	padding: 10px 30px;
	box-sizing: border-box;
	background-color: #e7f2ff;
	font-weight: 600;
}

.no_of_services {
	float: right;
	font-size: 14px;
}

.realcheckbox:checked ~ .select_all_box {
	background-color: #4A90E2;
}

/* EEROR PAGE */
.whitebg {
	background: none;
}

.center_logo {
	display: block;
	margin: auto;
	width: 80px;
}

.center_text {
	display: block;
	text-align: center;
	width: 380px;
	padding: 0px 40px;
}

.center_btn {
	display: block;
	margin: auto;
}

.errorbox {
	display: block;
	width: 460px;
	height: auto;
	margin: auto;
	margin-top: 120px;
	box-shadow: 0px 0px 8px 0px #00000020;
	padding-bottom: 40px;
	border-radius: 2px;
}

.logo_bg {
	display: block;
	background-color: #FFF7F7;
	height: 140px;
	box-sizing: border-box;
	padding: 40px;
}

.error_icon {
	display: block;
	background-color: #FFDFDF;
	height: 60px;
	width: 60px;
	border-radius: 30px;
	margin: auto;
	margin-bottom: 20px;
	margin-top: -30px;
	background-size: 24px;
}

.warn_msg {
    display: none;
	font-size: 13px;
	color: #E96C6C;
}

.warning_slide {
	font-size: 14px;
	color: #E96C6C;
	background-color: #FFE6E6;
}

.popup_bottom_content {
	position: absolute;
	width: 100%;
	bottom: 0px;
}

.service_icon {
    margin-left: 10px;
}

/* --------------------------- MEDIA QUERY ----------------------------  */
@media only screen and (max-width: 800px) {
	.body_bg {
		background: none;
	}
	.errorbox {
		width: 80%;
	}
	.center_text {
		width: auto;
	}
	.content {
		display: block;
		width: 90%;
		max-width: 600px;
		margin: auto;
		padding-top: 80px;
	}
	.servicelist {
		width: 100%;
	}
	.popup {
		width: 90%;
	}
	.services_div .servicelist {
		width: 100%;
	}
	.popup_heading {
		width: auto;
	}
	.content {
	    padding-top: 20px;
	}
}
</style>
</head>

<body>
	<%!private static final Logger LOGGER = Logger.getLogger("ui.unauth.renewrole.jsp"); //No I18N%>
	<%
	String reqdigest = request.getParameter("DIGEST");
	if (!Util.isValid(reqdigest)) {
%>
	<div class="errorbox">
		<div class="logo_bg">
			<div class="zoho_logo center_logo"></div>
		</div>
		<div class="error_icon" style="background: url('<%=imgURL%>/Link.png') no-repeat #FFDFDF 18px 18px; background-size: 24px;"></div> <%-- NO OUTPUTENCODING --%>
		<div class="heading center_text"><%=Util.getI18NMsg(request,"IAM.ROLE.RENEW.LINK.INVALID")%></div>
		<div class="discription center_text"><%=Util.getI18NMsg(request,"IAM.ROLE.RENEW.LINK.INVALID.TEXT")%>
		</div>
		<button class="btn green center_btn" onclick="go_to_main_homepage();"><%=Util.getI18NMsg(request,"IAM.ROLE.RENEW.GO.TO.HOME")%></button>
	</div>
	<%
		return;
		}
		String zuid = null;
		String digest_val;
		JSONObject jroles = new JSONObject();
		Digest digest = null;
		String email = "";
		try {
			digest = com.zoho.accounts.internal.util.Util.getDigest(reqdigest, new Criteria(DIGEST.DIGEST_TYPE, AccountsConstants.DigestType.ROLE_EXPIRY.dbValue()));
			if (Util.isValid(digest)) {
				digest_val = digest.getDigest();
				zuid = digest.getZid(); 
				email = digest.getEmailId();
				if (Util.isValid(zuid) && zuid.equals(""+IAMUtil.getCurrentUser().getZUID())) {
					long currentTime = System.currentTimeMillis();
					if (digest.getExpiryTime() > System.currentTimeMillis()) {
						int reminderDays = AccountsConfiguration.getConfigurationTyped("no.of.days.reminder.for.role.expiry", 10);	//No I18N
						Criteria criteria_expired = new Criteria(USERSYSTEMROLES.EXPIRY_TIME, Comparator.LESS_THAN, currentTime);
						Criteria criteria1 = new Criteria(USERSYSTEMROLES.EXPIRY_TIME, Comparator.LESS_THAN, currentTime + TimeUnit.DAYS.toMillis(reminderDays));
						UserSystemRolesURI userSystemRolesURI = AppResource.getUserSystemRolesURI(URI.JOIN, URI.JOIN, zuid).getQueryString().setCriteria(criteria1.or(criteria_expired)).build();
						UserSystemRoles[] userSystemRoles = userSystemRolesURI.GETS();
						if(userSystemRoles != null && userSystemRoles.length > 0){
							for(UserSystemRoles userSystemRole : userSystemRoles) {
								String appName = userSystemRole.getParent().getAppName();
								String roleName = userSystemRole.getParent().getSystemRoleName();
								 JSONArray roleList;
								if(jroles.opt(appName) == null){
									roleList = new JSONArray();
								} else {
									roleList = (JSONArray) jroles.opt(appName);
								}
							roleList.put(roleName);
							jroles.put(appName, roleList);
						}
					}
				} else {
					%>
					 <div class="errorbox">
		                  <div class="logo_bg">
								<div class="zoho_logo center_logo"></div>
						   </div>
						   <div class="error_icon" style="background: url('<%=imgURL%>/Expire.png') no-repeat #FFDFDF 18px 18px; background-size: 24px;"></div> <%-- NO OUTPUTENCODING --%>
						   <div class="heading center_text"><%=Util.getI18NMsg(request,"IAM.ROLE.RENEW.LINK.INVALID")%></div>
						   <div class="discription center_text"><%=Util.getI18NMsg(request,"IAM.ROLE.RENEW.LINK.EXPIRED")%></div>
						   <button class="btn green center_btn" onclick="go_to_main_homepage();"><%=Util.getI18NMsg(request,"IAM.ROLE.RENEW.GO.TO.HOME")%></button>
	                  </div>					 
					<%
					return;
				}
			} else {
				%>
				<div class="errorbox">
					<div class="logo_bg">
						<div class="zoho_logo center_logo"></div>
					</div>
					<div class="error_icon" style="background: url('<%=imgURL%>/Link.png') no-repeat #FFDFDF 18px 18px; background-size: 24px;"></div> <%-- NO OUTPUTENCODING --%>
					<div class="heading center_text"><%=Util.getI18NMsg(request,"IAM.ROLE.RENEW.LINK.INVALID")%></div>
					<div class="discription center_text"><%=Util.getI18NMsg(request,"IAM.ROLE.RENEW.INVALID.USER", email)%>
					</div>
					<button class="btn green center_btn" onclick="go_to_main_homepage();"><%=Util.getI18NMsg(request,"IAM.ROLE.RENEW.GO.TO.HOME")%></button>
				</div>
				<%
				return;
			}
			} else {
	%>
	<div class="errorbox">
		<div class="logo_bg">
			<div class="zoho_logo center_logo"></div>
		</div>
		<div class="error_icon"
			style="background: url('<%=imgURL%>/Expire.png') no-repeat #FFDFDF 18px 18px; background-size: 24px;"></div> <%-- NO OUTPUTENCODING --%>
		<div class="heading center_text"><%=Util.getI18NMsg(request,"IAM.ROLE.RENEW.LINK.INVALID")%></div>
		<div class="discription center_text"><%=Util.getI18NMsg(request,"IAM.ROLE.RENEW.LINK.EXPIRED")%></div>
		<button class="btn green center_btn" onclick="go_to_main_homepage();"><%=Util.getI18NMsg(request,"IAM.ROLE.RENEW.GO.TO.HOME")%></button>
	</div>
	<%
	return;
	}
} catch(Exception e){
	logger.log(Level.SEVERE, "@@@Excpetion while showing roles and services in JSP", e);%>
	<div class="errorbox">
		<div class="logo_bg">
			<div class="zoho_logo center_logo"></div>
		</div>
		<div class="error_icon"
			style="background: url('<%=imgURL%>/Link.png') no-repeat #FFDFDF 18px 18px; background-size: 24px;"></div> <%-- NO OUTPUTENCODING --%>
		<div class="heading center_text"><%=Util.getI18NMsg(request,"IAM.ERROR.GENERAL")%>!
		</div>
		<div class="discription center_text"><%=Util.getI18NMsg(request,"IAM.ROLE.RENEW.LINK.GENERAL.ERROR")%>
		</div>
		<button class="btn green center_btn" onclick="go_to_main_homepage();"><%=Util.getI18NMsg(request,"IAM.ROLE.RENEW.GO.TO.HOME")%></button>
	</div>
	<% 
	return;
}
%>
	<script>
var csrfParam = '<%=SecurityUtil.getCSRFParamName(request)+"="+SecurityUtil.getCSRFCookie(request)%>'; //NO OUTPUTENCODING
var resp_obj =  '<%=jroles%>';
resp_obj = JSON.parse(resp_obj);
var totalRoles = '<%=jroles.length()%>';
var service_names = Object.keys(resp_obj);
var digest = '<%=digest_val%>';//NO OUTPUTENCODING
 $(document).ready(function() {
	if(Object.keys(resp_obj).length <= 3) {
		$("#showall").css("display", "none");//NO I18N
		$("#select_all_btn").css("display", "inline-block");//NO I18N
	} else {
		$("#showall").css("display", "inline-block");//NO I18N
		$("#select_all_btn").css("display", "none");//NO I18N
	}
	list_all_Services(".all_services", false);//NO I18N
	if(totalRoles <= 1){
		$("#select_all_btn").css("display", "none");//NO I18N
	}
	$(document).mouseup(function(e) {
		var container = $(".servicelist");//NO I18N
		// if the target of the click isn't the container nor a descendant of the container
		if (!container.is(e.target) && container.has(e.target).length === 0) {
		    hide_all_roles();
	    }
	});
	$(".checkbox_label").unbind("click").click(function() {
		var is_checked = $(this).siblings(".realcheckbox").prop("checked");  // NO I18N
		if(is_checked == false) {
			$(this).siblings(".realcheckbox").prop("checked", true); // NO I18N
		} else {
			$(this).siblings(".realcheckbox").prop("checked", false); // NO I18N
		}
	});
	$(document).keyup(function(e){
		if(e.key === "Escape") {
			$(".popup").fadeOut(100);//NO I18N
			$(".darkbg").hide();//NO I18N
			$(".popup").addClass("close_popup");//NO I18N
		}
	});
	
	$(".service_head").unbind("click").click(function(){
		show_roles(this);
	});

	$(".showall").unbind("click").click(function() {
		$(".warning_slide, .warn_msg").css("display", "none"); //NO I18N
		$(".popup").fadeIn(100);		
		var existing_list = $(".popup_heading").siblings(".all_services").length;
		if(existing_list > 0) {
			$(".popup_heading").siblings(".all_services").remove();
		}
		var all_services_list = $(".all_services").clone();
		$(all_services_list).addClass("services_div");
		$(all_services_list).insertAfter(".popup_heading"); //NO I18N
		list_all_Services(".services_div", true);//NO I18N
		$(".darkbg").show();
		$(".popup").removeClass("close_popup");//NO I18N
		$(".no_of_services").text(service_names.length+" Services");//NO I18N	
		$(".service_head").unbind("click").click(function(){
			show_roles(this);
		});
		$(".realcheckbox").unbind("click").click(function(){
			$(".warn_msg, .warning_slide").slideUp(200);
			check_services_roles(this);
		});	
		$(".checkbox_label").click(function() {
			var is_checked = $(this).siblings(".realcheckbox").prop("checked");  // NO I18N
			if(is_checked == false) {
				$(this).siblings(".realcheckbox").prop("checked", true); // NO I18N
			} else {
				$(this).siblings(".realcheckbox").prop("checked", false); // NO I18N
			}
		});
	});
	$(".pu_close").click(function() {
		$(".popup").fadeOut(100);//NO I18N
		$(".darkbg").hide();//NO I18N
		$(".popup").addClass("close_popup");//NO I18N
	});
	$(".realcheckbox").unbind("click").click(function(){
		$(".warn_msg, .warning_slide").slideUp(200);
		check_services_roles(this);
	});
});

function show_roles(this_element){
	$(".servicelist").removeClass("box");
	$(this_element).parent(".servicelist").addClass("box");//NO I18N
}

function check_services_roles(this_ele){
	if($(this_ele).hasClass("roles")) {//NO I18N
		if($(this_ele).prop("checked") == true) {
           var parent_id = $(this_ele).closest(".servicelist").attr("id");//NO I18N
           var child_class = $("#"+parent_id).children(":eq(1)");//NO I18N
           var total_child_length = $("#"+parent_id).children(":eq(1)").children().length;//NO I18N
           var checked_len = $(child_class).find("input:checkbox:checked").length;//NO I18N
           if(checked_len == total_child_length) {
        	   var main_checkbox = $("#"+parent_id).children(":eq(0)");//NO I18N
        	   $(main_checkbox).find("input.realcheckbox").prop("checked", true);//NO I18N
        	   $(main_checkbox).find("div.checkbox_style").addClass("checkbox_style_tick").removeClass("checbox_indeterminate");//NO I18N
           } else if (checked_len > 0 && checked_len < total_child_length) {
        	   var main_checkbox = $(this_ele).parents().siblings(".service_head");//NO I18N
				   $(main_checkbox).find(".realcheckbox").prop("checked", true);//NO I18N
				   $(main_checkbox).find(".checkbox_style").removeClass("checkbox_style_tick").addClass("checbox_indeterminate");//NO I18N
           }
		} else {
			$(".selectall").prop("checked", false); //NO I18N
			var parent_id = $(this_ele).closest(".servicelist").attr("id");//NO I18N
               var child_class = $("#"+parent_id).children(":eq(1)");//NO I18N
               var total_child_length = $("#"+parent_id).children(":eq(1)").children().length;//NO I18N
               var checked_len = $(child_class).find("input:checkbox:checked").length;//NO I18N
               if(checked_len == 0) {
            	   var main_checkbox = $("#"+parent_id).children(":eq(0)");//NO I18N
            	   $(main_checkbox).find("input.realcheckbox").prop("checked", false);//NO I18N
            	   $(main_checkbox).find("div.checkbox_style").removeClass("checkbox_style_tick").addClass("checbox_indeterminate");//NO I18N
               } else if (checked_len > 0 && checked_len < total_child_length) {
            	   var main_checkbox = $(this_ele).parents().siblings(".service_head");//NO I18N
   				   $(main_checkbox).find(".realcheckbox").prop("checked", true);//NO I18N
   				   $(main_checkbox).find(".checkbox_style").removeClass("checkbox_style_tick").addClass("checbox_indeterminate");//NO I18N
               }
               $(".selectall").prop("checked", false);//NO I18N
		}
	} else if($(this_ele).hasClass("selectall") == false) {
		var is_checked = $(this_ele).prop("checked");//NO I18N
		var is_all_checked = $(this_ele).parent().attr("class"); //NO I18N
		if(is_all_checked == "checkall") {
			var parent_box = $(this_ele).parent();
			if(is_checked == true) {
				if($(this_ele).hasClass("selectall")) {
					$(".all_services").find(".checkbox_style").addClass("checkbox_style_tick");//NO I18N
					$(".all_services").find(".realcheckbox").prop("checked", true);//NO I18N
				} else {
					$(this_ele).siblings(".checkbox_style").addClass("checkbox_style_tick");//NO I18N
					var grandparent = $(parent_box).parents(":eq(1)");//NO I18N
					$(grandparent).find(".realcheckbox").prop("checked", true);//NO I18N
				}
			} else {
				var grandparent = $(parent_box).parents(":eq(1)");//NO I18N
				$(grandparent).find(".realcheckbox").prop("checked", false);//NO I18N
				$(".selectall").prop("checked", false);//NO I18N
			}
		}
	}
}

function renew_services(main_list) {
	var all_services_count = $(".all_services").children().length;//NO I18N
	var renew_services = new Array();
	var selected_services_array = new Array();
	var all_selected_services = new Object();
	for(var i=0; i< all_services_count; i++) {
		var nth_service = $(".all_services").children(":eq("+i+")");//NO I18N
		var is_checked = $(nth_service).children().find(".checkbox_div input:checkbox:checked").length;//NO I18N
		if(is_checked > 0) {
			renew_services = [];
			var service_name = $(nth_service).attr("id");//NO I18N
			var service_name_val = $("#"+service_name).find(".service_name").text();
			var all_roles_of_this_service_count = $("#"+service_name).find(".roles_div").children().length;//NO I18N
			for( var j=0; j<all_roles_of_this_service_count; j++) {
				var is_role_checked = $("#"+service_name).find(".roles_div").children(":eq("+j+")").find(".realcheckbox").prop("checked");//NO I18N
				if(is_role_checked == true) {
					var role_name = $("#"+service_name).find(".roles_div").children(":eq("+j+")").find(".checkbox_label").text();//NO I18N
					renew_services.push(role_name);
				}
			}
			all_selected_services[service_name_val] = renew_services;
		}
	}	
	selected_services_array.push(all_selected_services);
	if(Object.keys(all_selected_services).length > 0) {
		var services = JSON.stringify(all_selected_services);
		$.ajax({
		      type: "POST",// No I18N
		      url: "/u/renewroles",//NO I18N
		      data: "ap_ros="+services+"&dg="+digest+"&"+csrfParam,//NO I18N
		      success: function(){
		    	  $("body").css("background", "none"); //NO I18N
		    	  $("body").children().css("display", "none");//NO I18N
		    	  $("body").find("#renew_success").css("display", "block"); //NO I18N
		      }});
	} else {
 	   if(main_list == "services_div") {
 		  $(".all_services").siblings().find(".warning_slide").slideDown(200); 		  
 	   } else {
 		  $(".all_services").siblings(".warn_msg").slideDown(200);
 	   }
	}
}

function list_all_Services(services_parent_div, is_show_all_services) {
	var roles_set = resp_obj[service_names[i]];
		var all_serivecs_child = $(services_parent_div).children().length;
		var default_service_div = $(services_parent_div).children(":eq(0)"); //NO I18N	
		if(is_show_all_services == false) {
			for (var i = 0; i < Object.keys(resp_obj).length; i++) {
				if (i == 0) {
					$(default_service_div).css("display", "block");//NO I18N
					$(services_parent_div).find(".service_name").text(service_names[i]);
					$(default_service_div).attr("id", service_names[i]);
					select_service(service_names[i], i, default_service_div, services_parent_div);
					create_role_element(services_parent_div, i);
				} else {
					var new_service = $(default_service_div).clone().appendTo(services_parent_div);
					$(new_service).find(".service_name").text(service_names[i]);//NO I18N
					$(new_service).attr("id", service_names[i]);
					select_service(service_names[i], i, new_service, services_parent_div);
					create_role_element(services_parent_div, i);
				}
				var listed_services_count = $(".all_services").children().length;//NO I18N
				if (listed_services_count > 3) {
					$(".all_services").children(":eq("+i+")").css("display", "none"); //NO I18N
				}
			}
		} else {
			$(".popup").find(".servicelist").css("display", "block"); //NO I18N
		}
}

function check_all_services(this_ele, select_All) {
	var is_select_all_checked = $(this_ele).find("input:checkbox").prop("checked"); //NO I18N
	$("." + select_All).find(".checkbox_style").addClass("checkbox_style_tick").removeClass("checbox_indeterminate");
	if (is_select_all_checked == true) {
		var select_all_cehecked = $("." + select_All).find(".realcheckbox").prop("checked", true);//NO I18N
	} else {
		var select_all_cehecked = $("." + select_All).find(".realcheckbox").prop("checked", false);//NO I18N
	}
}

function create_role_element(services_parent_div, i) {
	var roles_set = resp_obj[service_names[i]];
	var default_role = $(services_parent_div).children(":eq(" + i + ")").find(".roles_div").children(":eq(0)");//NO I18N
	$(services_parent_div).children(":eq(" + i + ")").find(".roles_div").children().not(':first').remove();//NO I18N
	for (var role_no = 0; role_no < roles_set.length; role_no++) {
		if (role_no == 0) {
			$(default_role).find(".checkbox_label").text(roles_set[role_no]);//NO I18N
		} else {
			var last_child = $(services_parent_div).children(":eq(" + i + ")").find(".roles_div").last();//NO I18N
			var new_role = $(default_role).clone().appendTo(last_child);
			$(new_role).find(".checkbox_label").text(roles_set[role_no]);//NO I18N
		}
	}
}

function delete_all_service_elements(parent_ele) {
	var total_children = $("#" + parent_ele).children().length;
	var parent_element = document.getElementById(parent_ele);
	while (parent_element.hasChildNodes()) {
		if ($("#" + parent_ele).children().length == 1) {
			break;
		} else {
			parent_element.removeChild(parent_element.lastChild);
		}
	}
}

function reset_form() {
	$(".realcheckbox:checkbox").prop("checked", false); //NO I18N
		hide_all_roles();
}

function hide_all_roles() {
	$(".servicelist").removeClass("box");//NO I18N
}

function select_service(service_name, i, this_service, services_parent_div) {
	var service_class = service_name.toLowerCase();
	$(this_service).find(".service_icon").addClass(service_class + "_icon");//NO I18N
}
</script>
<div class="body_bg"></div>
<div class="darkbg"></div>
<div class="popup close_popup">
	<div class="popup_heading">
		<span class="popup_heading_text"><%=Util.getI18NMsg(request,"IAM.ROLE.RENEW.TEXT")%></span>
		<span class="pu_close"></span>
	</div>
	<div class="popup_bottom_content">
		<div class="select_all_option" onclick="check_all_services(this, 'all_services');" style="font-size: 14px;">
			<div class="checkall" style="float: left; margin-right: 5px; transform: scale(.8);">
				<input class="realcheckbox selectall" type="checkbox">
				<div class="checkbox_style selectall_style_tick select_all_box" style="border: 2px solid #4A90E2;"></div>
			</div>
			<span> <%=Util.getI18NMsg(request,"IAM.ROLE.RENEW.SELECT.ALL")%></span>
			<span class="no_of_services"></span>
		</div>
		<div class="select_all_option warning_slide" style="display: none;"><%=Util.getI18NMsg(request,"IAM.ROLE.RENEW.WARNING.TEXT")%></div>
			<div class="pu_bottom">
				<button class="btn green" onclick="renew_services('services_div');"><%=Util.getI18NMsg(request,"IAM.ROLE.RENEW.RENEW.BUTTON")%></button>
				<button class="btn grey" onclick="reset_form();" style="text-transform: capitalize;"><%=Util.getI18NMsg(request,"IAM.CLEAR")%></button>
			</div>
	</div>
</div>
<div class="content">
	<div class="zoho_logo"></div>
	<div class="heading"><%=Util.getI18NMsg(request,"IAM.ROLE.RENEW.TEXT")%></div>
	<div class="discription"><%=Util.getI18NMsg(request,"IAM.ROLE.RENEW.CONTENT")%>
	<%if(Util.isValid(email)){ %>
		<%=Util.getI18NMsg(request,"IAM.ROLE.RENEWING.ACCOUNT.CONTENT", email)%>
	<%} %>
	</div>
	<div class="all_services">
		<div class="servicelist" style="display: none;">
			<div class="service_head">
				<span class="service_icon"></span> <span class="service_name"></span>
			</div>
			<div class="roles_div">
				<div class="checkbox_div">
					<input class="realcheckbox roles" type="checkbox">
					<div class="checkbox_style checkbox_style_tick"></div>
					<label class="checkbox_label"></label>
				</div>
			</div>
			<span style="clear: left; display: block;"></span>
		</div>
	</div>
	<div class="showall" id="showall"><%=Util.getI18NMsg(request,"IAM.ROLE.RENEW.SHOW.ALL")%></div>
	<div id="select_all_btn" onclick="check_all_services(this, 'all_services');" class="select_all_option" style="width: auto; font-size: 14px; position: static; border-radius: 15px; padding: 5px 15px; height: 30px; margin-top: 10px; margin-bottom: 10px;">
		<div class="checkall" style="float: left; margin-right: 5px; transform: scale(.8);">
			<input class="realcheckbox selectall" type="checkbox">
			<div class="checkbox_style selectall_style_tick select_all_box" style="border: 2px solid #4A90E2;"></div>
		</div><%=Util.getI18NMsg(request,"IAM.ROLE.RENEW.SELECT.ALL")%>
		<span class="no_of_services"></span>
	</div>
	<div class="warn_msg"><%=Util.getI18NMsg(request,"IAM.ROLE.RENEW.WARNING.TEXT")%></div>
	<div class="buttons">
		<button class="btn green" onclick="renew_services('all_services');"><%=Util.getI18NMsg(request,"IAM.ROLE.RENEW.RENEW.BUTTON")%></button>
		<button class="btn grey" onclick="reset_form('all_services');" style="text-transform: capitalize;"><%=Util.getI18NMsg(request,"IAM.CLEAR")%></button>
	</div>
</div>
<div id="renew_success" class="errorbox" style="display: none;">
	<div class="logo_bg" style="background-color: #E3F8DE;">
		<div class="zoho_logo center_logo"></div>
	</div>
	<div class="error_icon" style="background: url('<%=imgURL%>/plain_tick.png') no-repeat #CEEEC7  18px 21px; background-size: 24px;"></div> <%-- NO OUTPUTENCODING --%>
	<div class="heading center_text"><%=Util.getI18NMsg(request,"ICREST.SUCCESS.MESSAGE")%>!</div>
	<div class="discription center_text"><%=Util.getI18NMsg(request,"IAM.ROLE.RENEW.SUCCESS.MSG")%></div>
	<button class="btn green center_btn" onclick="go_to_main_homepage();"><%=Util.getI18NMsg(request,"IAM.ROLE.RENEW.GO.TO.HOME")%></button>
</div>
</body>
</html>