<%-- $Id$ --%>
<%@page import="com.zoho.accounts.internal.announcement.Announcement"%>
<%@page import="com.zoho.accounts.AccountsProto.Account.User.UserMobile"%>
<%@page import="com.adventnet.iam.internal.PhoneUtil"%>
<%@page import="com.zoho.accounts.AccountsProto.Account.User.UserMobile"%>
<%@page import="org.apache.jasper.tagplugins.jstl.core.ForEach"%>
<%@page import="com.zoho.accounts.Accounts"%>
<%@page import="com.zoho.accounts.AccountsProto.Account.User.UserMobile"%>
<%@page import="com.adventnet.iam.internal.Util"%>
<%@page import="com.adventnet.iam.security.SecurityUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>  <!-- No I18N -->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Frameset//EN" "http://www.w3.org/TR/REC-html40/frameset.dtd">
<%@ include file="../../static/includes.jspf" %>

<%
User user =  IAMUtil.getCurrentUser();
String serviceUrl = request.getParameter("serviceurl");

UserMobile []ums = PhoneUtil.getUserUnVerifiedNumber(user);

List <UserEmail> ueList = user.getEmails();
boolean unconfirmedEmail = false;
if(ueList != null){
	for(UserEmail ue : ueList) 
		{
			if(!ue.isConfirmed() && ue.isEmailId())
			{
				unconfirmedEmail = true;
				break;
			}
		}
}
if(!unconfirmedEmail && ums == null) {
	if(serviceUrl != null){
		response.sendRedirect(serviceUrl);
	} else {
		response.sendRedirect(Util.getIAMURL());
	}
    return;
}

%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
</head>

<style>


@font-face {
  font-family: 'Accounts-Font-Icons';
  src:  url('../images/fonts/Accounts-Font-Icons.eot?xhwetj');
  src:  url('../images/fonts/Accounts-Font-Icons.eot?xhwetj#iefix') format('embedded-opentype'),
    url('../images/fonts/Accounts-Font-Icons.ttf?xhwetj') format('truetype'),
    url('../images/fonts/Accounts-Font-Icons.woff?xhwetj') format('woff'),
    url('../images/fonts/Accounts-Font-Icons.svg?xhwetj#Accounts-Font-Icons') format('svg');
  font-weight: normal;
  font-style: normal;
}

[class^="icon-"], [class*=" icon-"] {
  /* use !important to prevent issues with browser extensions that change fonts */
  font-family: 'Accounts-Font-Icons' !important;
  speak: none;
  font-style: normal;
  font-weight: normal;
  font-variant: normal;
  text-transform: none;
  line-height: 1;

  /* Better Font Rendering =========== */
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

body
{
    font-family: 'Open Sans', sans-serif;
    margin: 0;
}
.container
{
    margin-top: 4%;
    width: 60%;
    margin-left: auto;
    margin-right: auto;
}
.zoho_logo
{
    height: auto;
    width: auto;
}
.head_text
{
    display: block;
    font-size: 1.4em;
    margin-bottom:20px;
    margin-top: 5px;
}
.name
{
    font-size: 1em;
    display: block;
}
.announcement_text
{
    line-height: 1.5;
    font-size: 1em;
    display: block;
        margin-bottom: 30px;
}
.innerbox_head 
{
    font-size: 18px;
    padding: 5px 0px;
    font-weight: 600;
    display: inline-block;
    width: 75%;
        margin-bottom: 10px;
        margin-top: 10px;
}

.email_address ,.red_field_value 
{
    display: inline-block;
    width: auto;
    max-width: 400px;
    font-size: 14px;
    width:300px;
    line-height: 24px;
    padding: 0px 10px;
    text-indent: 0px !important;
}
.red_field_value
{
	color:#0783c5;
	cursor:pointer;
}
.blue_field_value
{
	color:#1c974a;
}
.hide
{
	display:none;
}
#save_cancel_btn 
{
    margin-top: 10px;
}
.primary_btn 
{
    font-size: 14px;
    border: none;
    background-color: #58b748;
    color: #fff;
    cursor: pointer;
    padding: 8px 20px;
    margin: 10px 10px 10px 0px;
}
.cancel_btn 
{
    background-color: #eeeeee;
    color: #000;
    margin: auto;
}
		.popup
		{
			z-index: 101;
			background: #fff !important;
			position: fixed !important;
			left: 0;
			right: 0;
			top: 25%;
			height: auto;
			width: 600px !important;
			box-sizing: border-box;
			padding: 30px !important;
			margin: auto;
			border-radius: 8px;
		}
	  .blur
      {
          height: 100%;
          width: 100%;
          position: fixed;
          z-index: -1;
          background-color: #000;
          opacity: 0;
          top: 0px;
          left: 0px;
      }
      
.close_btn
{
    cursor: pointer;
    height: 20px;
    width: 20px;
    float: right;
    transform: rotate(135deg);
    margin: 3px;
}
.close_btn:before
{
    display: block;
    content: "";
    height: 100%;
    width: 2px;
    background-color: #000;
    margin: auto;
}
.close_btn:after
{
    display: block;
    content: "";
    height: 2px;
    width: 100%;
    background-color: #000;
    position: relative;
    margin: auto;
    top: calc(-50% - 1px);
}    
      
 .form_field
    {
    padding: 5px 0px;
    display: block;
    width: 300px;
    height: 40px;
    margin-top: 20px;
    position: relative;
    }
    .text_box
    {
        text-indent: 5px;
    background:none;
    font-size: 100%;
    padding: 5px 0px 5px 0px;
    display: block;
    width: 300px;
    border: none;
   
    border-bottom: 1px solid #CCC;
    }
    
    label
    {
        left: 5px;
        color: #666;
        font-size: 90%;
        font-weight: 400;
        position: relative;
        pointer-events: none;
        top: -25px;
        transition:0.3s ease all;
        -moz-transition:0.3s ease all;
        -webkit-transition:0.2s ease all;
    }
    
    input:focus
    {
        outline:none;
    }
    
    .text_box:focus ~ label , .text_box:valid ~ label ,.fixed_label
    {   
          top:-50px;
          color:#666;
          font-size:12px;
    }
    
    
    .bar
    {
        background:#999;
        position:relative;
        display:block;
        width:300px;
        top:-1px;
    }
    .bar:before, .bar:after
    {
        content:'';
        top: -1px;
        height:1.2px;
        width:0;
        border-bottom:none;
        position:absolute;
        background:#999;
        transition:0.2s ease all;
        -moz-transition:0.2s ease all;   
        -webkit-transition:0.2s ease all;
    }
    .bar:before
    {
        left:50%;
    }
    .bar:after
    {
        right:50%;
    }

    .text_box:focus ~ .bar:before, .text_box:focus ~ .bar:after
    {
        width:50%;
    }
    
.popuphead_details
{
	display: inline-block;
	margin-left:5px;
	width:calc(100% - 40px);
}
.popuphead_text
{

	display: block;
	padding: 3px 0px;
}
.popuphead_define
{
    font-size: 14px;
    padding: 3px 0px;
    width: 500px;
    display: block;
    font-weight:100;
    margin-bottom: 10px;
	
}
.popup_header
{
	display: block;
	width: 100%;
	height: auto;
	margin-bottom: 10px;
	
}   

/*---------------Top message-----------------*/ 
.top_div 
{
    z-index: 2;
 left: 0;
 right: 0;
 margin-left: auto; 
 margin-right: auto; 
 top: 0px; 
 position: absolute; 
 height: 40px; 
 width: 400px; 
    background: #f7f7f7; 
 border-right: 3px solid #ef4444; 
 color: #ef4444; 
 display:none; 
 }
.cross_mark 
{
 position: relative;
 display: inline-block; 
 background-color: #ef4444; 
 height: 40px; 
 width: 40px; 
 } 
.crossline1 
{ 
 top: 18px; 
 margin: auto; 
 position: relative; 
 border-radius: 2px; 
 height: 4px; 
 width: 20px; 
 display: block; 
 background-color: #fff; 
 transform: rotate(45deg); 
 }
.crossline2 
{ 
 top: 14px; 
 border-radius: 2px; 
 height: 4px; 
 width: 20px; 
 display: block; 
 background-color: #fff; 
 transform: rotate(-45deg); 
 position: relative; 
 margin: auto; 
 }
.top_msg 
{   
 position: relative;   
 font-size: 13px;   
 display: inline-block;   
 text-align: center;   
 color: #000;   
 width: 86%;   
 height: 100%;   
 box-sizing: border-box;   
 float: right;   
 padding: 10px;   
 left: -15px;    
 }  
.error_notif 
{ 
 color: #ff6164;
 margin-left: 5px;   
 font-size: 12px;   
 margin-top: -25px; 
}
.resend_link a
{
	font-size:14px;
	text-decoration:none;
	color:#0783c5;
	
}
.email_icon {
    font-size: 24px;
    float: left;
    height: 24px;
}
.icon-email:before {
  content: "\e902";
}
.icon-mobile:before {
  content: "\e907";
}
.single_cell
{
	padding:7px;
}
</style>

 <script src="<%=jsurl%>/jquery-1.12.2.min.js" type="text/javascript"></script><%-- NO OUTPUTENCODING --%>
<script src="<%=jsurl%>/jquery.ztooltip.js" type="text/javascript"></script> <%-- NO OUTPUTENCODING --%>
<script src="<%=jsurl%>/common.js" type="text/javascript"></script> <%-- NO OUTPUTENCODING --%>

<link href="<%=cssurl_st%>/ui.ztooltip.css" type="text/css" rel="stylesheet"  /><%-- NO OUTPUTENCODING --%>
  <script type="text/javascript">
	var csrfParam = "<%=SecurityUtil.getCSRFParamName(request)+"="+SecurityUtil.getCSRFCookie(request)%>"; //NO OUTPUTENCODING    
	var contextpath = "<%=request.getContextPath()%>"; //NO OUTPUTENCODING	
	
	function sendVerifyCode_show(emailOrMobile,isMob,id)
	{
		$("#for_id").val(id);
		$("#verify_pop").show();
		$("#1st_step").show();
		$("#2nd_step").hide();
		$("#first_define").show();
		$("#second_define").hide();
		$(".blur").css({"z-index":"1","opacity":".5"});//No I18N
		$('html, body').css({
		    overflow: 'hidden',//No i18N
		    height: '100%'
		});
		if(isMob)
		{
			$("#mob_mail_lable").html("<%=Util.getI18NMsg(request,"IAM.PHONE.NUMBER")%>");//No I18N
			$(".popuphead_text").html("<%=Util.getI18NMsg(request,"IAM.PHONE.NUMBER")%>");//No I18N
		}
		else
		{
			$("#mob_mail_lable").html("<%=Util.getI18NMsg(request,"IAM.EMAIL.ADDRESS")%>");//No I18N
			$(".popuphead_text").html("<%=Util.getI18NMsg(request,"IAM.EMAIL.ADDRESS")%>");//No I18N
		}
		$("#unconfirmed").val(emailOrMobile);

	}
	function sendVerifyCode()
	{
		var emailOrMobile = $("#unconfirmed").val();
		var res = getPlainResponse(contextpath + "/rest/announcement/recovery/" + emailOrMobile.trim() + "/resend", csrfParam); //No I18N
		var obj = JSON.parse(res);	
		if(obj.status=='success') //NO I18N
		{ 
			//showmsg(obj.message);
			$("#1st_step").hide();
			$("#2nd_step").show();
			$("#unconfirmed_2").val(emailOrMobile);
			$("#get_headder label").html($(".popuphead_text").html());
			$("#first_define").hide();
			$("#second_define").show();
			
			showmsg(obj.message);
		} else 
		{
			showErrMsg(obj.message);
			return;
		}
	}
	
	function closeview_verify_pop()
	{
		$("#verify_pop").hide();
		$("#1st_step").show();
		$("#2nd_step").hide();
		$("#first_define").show();
		$("#second_define").hide();
		$(".blur").css({"z-index":"-1","opacity":"0"});//No I18N
		$('html, body').css({
		    overflow: 'auto',//No i18N
		    height: 'auto'//No i18N
		});
	}
	function back_step1()
	{
		$("#1st_step").show();
		$("#2nd_step").hide();
	}
	function resendCode()
	{
		var emailOrMobile=$("#unconfirmed").val();
		var res = getPlainResponse(contextpath + "/rest/announcement/recovery/" + emailOrMobile.trim() + "/resend", csrfParam);	//No I18N
		var obj = JSON.parse(res);
		if(obj.status == 'success'){
			showmsg(obj.message);
		} else {
			showErrMsg(obj.message);
		}
	}
	
	function isValidCode(code){
		if(code.trim().length != 0){
			var codePattern = new RegExp("^([0-9]{5,7})$");
			if(codePattern.test(code)){
				return true;
			}
		}
		return false;
	}
	
	function verifyCode()
	{
		var code = $("#code_2").val().trim();
		if(!isValidCode(code))
		{
			showErrMsg("<%=Util.getI18NMsg(request,"IAM.PHONE.INVALID.VERIFY.CODE")%>");//No I18N
			return;	
		}
		
		var i=$("#for_id").val();
		var emailOrMobile=$("#unconfirmed").val();
		
		params = "code=" + code + "&action=auth" + "&" + csrfParam; //No I18N
		var res = getPlainResponse(contextpath + "/rest/announcement/recovery/" + emailOrMobile.trim() + "/verify", params );	//No I18N
		var obj = JSON.parse(res);	
		if(obj.status=='success') {
				//showmsg(obj.message);
				$("#ver"+i).hide();
				$("#done"+i).show();
				if(!$(".red_field_value").is(":visible") )
				{
					$("#edi-del").hide();
					$("#skip").hide();
					$("#continue").show();
				}
				closeview_verify_pop();
				showmsg(obj.message);
			} else {
				showErrMsg(obj.message);
				return;
			}
	}
	
	function showNextAnnouncement(){
		window.location.href = '<%=IAMEncoder.encodeJavaScript(Announcement.getVisitedNextURL(request))%>';
	}
	
	function skippedShowNextAnnouncement(){
		window.location.href = '<%=IAMEncoder.encodeJavaScript(Announcement.getSkipNextURL(request))%>';	
	}
	
	
	function showErrMsg(msg) { $(".top_div").css({"border-right": "3px solid #ef4444", "color": "#ef4444"});   $(".cross_mark").css("background-color","#ef4444");      $(".crossline1").css({"top": "18px", "left": "0px", "width":"20px"});     $(".crossline2").css("left","0px");   $('.top_msg').html(msg); //No I18N 
	$( ".top_div" ).fadeIn("slow");  setTimeout(function() {  $( ".top_div" ).fadeOut("slow"); }, 3000); //No I18N

	}

	function showmsg(msg) { $(".top_div").css({"border-right": "3px solid #50BF54", "color": "#50BF54"});   $(".cross_mark").css("background-color","#50BF54");      $(".crossline1").css({"top": "22px", "left": "-6px", "width":"12px"});     $(".crossline2").css("left","4px");   $('.top_msg').html(msg); //No I18N 
	$( ".top_div" ).fadeIn("slow");  setTimeout(function() {  $( ".top_div" ).fadeOut("slow"); }, 3000); //No I18N

	}

	function gotoedit()
	{
		window.location.href = '<%=cPath%>'+'/u/h#profile/useremails'; <%-- NO OUTPUTENCODING --%>
	}
	
	
</script>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<body>
     <div id="error_space">  
     	<div class="top_div">   
     		<span class="cross_mark">   
	     		<span class="crossline1"></span>   
	     		<span class="crossline2"></span>    
     		</span>   
     		<span class="top_msg"></span>  
     	</div>  
     </div>
     
<div class="blur"></div>
		
		
		
		<div class=" hide popup" id="verify_pop">
			<div class="popup_header ">
				<div class="popuphead_details">
					<span class="popuphead_text"></span>
					<span id="first_define" class="popuphead_define"><%=Util.getI18NMsg(request,"IAM.ANNOUNCEMENT.DIV.CONTENT")%></span><%--No I18N--%>
					<span id="second_define"  class="hide popuphead_define"><%=Util.getI18NMsg(request,"IAM.ANNOUNCEMENT.PLEASE.ENTER.CODE")%> </span>
				</div>
				<div class="close_btn" onclick="closeview_verify_pop()"></div>
			</div>
					<input type="hidden" id="for_id" />
			<div id="1st_step">
			
				     <div class="form_field" id="get_password">
				        <input class="text_box"   id="unconfirmed" type="text" readonly required="" autocomplete="off">
				        <span class="bar"></span>
				        <label  class="fixed_label" id="mob_mail_lable"></label>
				    </div>
				    
				    <button class="primary_btn" onclick="sendVerifyCode();"><%=Util.getI18NMsg(request,"IAM.SEND.VERIFY")%></button><%--No I18N--%>
			</div>
			
			<div id="2nd_step">
					
					<div class="form_field" id="get_headder">
				        <input class="text_box"   id="unconfirmed_2" type="text" readonly required="" autocomplete="off">
				        <span class="bar"></span>
				        <label  class="fixed_label" id="mob_mail_lable"></label>
				    </div>
				    
				    <div class="form_field" id="get_password">
				        <input class="text_box"   id="code_2" type="text" required="" autocomplete="off">
				        <span class="bar"></span>
				        <label  id="mob_mail_lable"><%=Util.getI18NMsg(request,"IAM.TFA.ENTER.VERIFICATION.CODE")%></label><%--No I18N--%>
				    </div>
				    <div class="resend_link" onclick="resendCode();"><a href="javascript:;"><%=Util.getI18NMsg(request, "IAM.TFA.RESEND.CODE")%></a></div>
				    
				    <button class="primary_btn" onclick="verifyCode();"><%=Util.getI18NMsg(request,"IAM.VERIFY")%></button><%--No I18N--%>
				    <input class="primary_btn  cancel_btn" onclick="back_step1()" type="button" value="<%=Util.getI18NMsg(request,"IAM.BACK")%>">
			</div>
		</div>
		
		
		
		
		
        <div class="container">
	        <img class="zoho_logo" src="<%=imgurl%>/zlogo.png"> <%-- NO OUTPUTENCODING --%>
	        <span class="head_text"><%=Util.getI18NMsg(request,"IAM.ANNOUNCEMENT.CONFIRM.RECOVERY.TITLE")%></span><%--No I18N--%>
	        <span class="name"><%=Util.getI18NMsg(request, "IAM.HI.USERNAME",user.getFullName() == null ? "" : IAMEncoder.encodeHTMLAttribute(user.getFullName()))%></span> <!-- No I18N -->
	        <span class="announcement_text"><%=Util.getI18NMsg(request,"IAM.ANNOUNCEMENT.CONFIRM.RECOVERY.CONTENT")%></span><%--No I18N--%>
	   
	        
	        <div class="addemail emailID_sec">
			<div id="overflowdiv" style="width:100%;">
	             <%
	             int i=1;
	             List <UserEmail> userEmailList = user.getEmails();
				   if(userEmailList != null) { %>
	              
				    <% 
				 	for(UserEmail ue : userEmailList) 
				 	{
				  		if(!ue.isConfirmed() && ue.isEmailId())
				  		{
				  			if(i == 1){ %>
					    	<div class="innerbox_head"><%=Util.getI18NMsg(request,"IAM.ANNOUNCEMENT.EMAILS.UNCONFIRMED")%></div> <!-- No I18N --><%--No I18N--%>
					   <%}%>
									<div class="single_cell">
										<span class="email_icon icon-email"></span>
										<span class="field_value email_address" id="<%=IAMEncoder.encodeHTMLAttribute(ue.getEmailId()) %>"><%=IAMEncoder.encodeHTML(ue.getEmailId()) %></span>
										<span class="red_field_value" id="ver<%=i%>" onclick="sendVerifyCode_show('<%=IAMEncoder.encodeHTMLAttribute(ue.getEmailId())%>',false,<%=i %>)" ><%=Util.getI18NMsg(request,"IAM.DEVICEOAUTH.VERIFY")%></span><%--No I18N--%>
										<span class="blue_field_value hide" id="done<%=i%>"><%=Util.getI18NMsg(request,"IAM.VERIFIED")%></span><%--No I18N--%>
									</div>
					<%	
						i++;
						}
				 	}
				   }
				 	%>
				 	</div>
				 	<%UserMobile []userMobiles = PhoneUtil.getUserUnVerifiedNumber(user);
				 	if(userMobiles != null){ %>
				 	<div class="innerbox_head"><%=Util.getI18NMsg(request,"IAM.ANNOUNCEMENT.MOBILES.UNCONFIRMED")%></div><br/> <!-- No I18N --><%--No I18N--%>
				 	<%
					for(UserMobile um : userMobiles)
					{
					%> 
									<div class="single_cell">
										<span class="email_icon icon-mobile"></span>
										<span class="field_value email_address" id="<%=IAMEncoder.encodeHTMLAttribute(um.getMobile())%>"><%=IAMEncoder.encodeHTML(um.getMobile())%></span>
										<span class="red_field_value" id="ver<%=i%>" onclick="sendVerifyCode_show('<%=IAMEncoder.encodeHTMLAttribute(um.getMobile())%>',true,<%=i %>)" ><%=Util.getI18NMsg(request,"IAM.DEVICEOAUTH.VERIFY")%></span><%--No I18N--%><%-- NO OUTPUTENCODING --%>
										<span class="blue_field_value hide" id="done<%=i%>"><%=Util.getI18NMsg(request,"IAM.VERIFIED")%></span><%--No I18N--%>
									</div>
					<%
						i++;
						}
				 	}
					%>
	
	                    <div id="save_cancel_btn">
	                   		<input class="primary_btn " onclick="gotoedit();" id="edi-del" type="button" value="Edit/Delete">
	                    	<input class="primary_btn  cancel_btn" id="skip" type="button" onclick="skippedShowNextAnnouncement()" value="<%=Util.getI18NMsg(request,"IAM.SKIP")%>">
	                   		<input class="primary_btn hide" onclick="showNextAnnouncement()" id="continue" type="button" value="<%=Util.getI18NMsg(request,"IAM.CONTINUE")%>">
	            		</div>
	        </div>        

	</div>


</body>
</html>