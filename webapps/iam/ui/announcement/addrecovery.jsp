<%-- $Id$ --%>
<%@page import="com.zoho.accounts.internal.announcement.Announcement"%>
<%@page import="com.adventnet.iam.internal.PhoneUtil"%>
<%@page import="com.adventnet.iam.servlet.Password"%>
<%@page import="com.zoho.accounts.AccountsProto.Account.User.UserMobile"%>
<%@page import="com.zoho.accounts.SystemResourceProto.ISDCode"%>
<%@page import="com.zoho.accounts.phone.SMSUtil"%>
<%@page import="com.zoho.accounts.TokenPairManager.TokenPairAuthHeader"%>
<%@page import="com.zoho.accounts.TokenPairManager"%>
<%@page import="com.zoho.accounts.AccountsUtil"%>
<%@ page import="java.util.*, java.text.DateFormat, java.text.SimpleDateFormat" %>
<%@ include file="../../static/includes.jspf" %>

<!DOCTYPE html> <%-- No I18N --%>
<html>
<head>

<%
User user = IAMUtil.getCurrentUser();

List<UserEmail> userEmails = Password.getOtherDomainUserEmails(user);
 if(userEmails.size() > 0 || PhoneUtil.hasRecoveryNumbers(user)){
	response.sendRedirect(Announcement.getVisitedNextURL(request));
	return;
}


String userCountry = Util.getCountryCodeFromRequestUsingIP(request);
int dCode = SMSUtil.getISDCode(userCountry);
List<ISDCode> countryList = SMSUtil.getAllowedISDCodes();
String learnMoreLink = AccountsConfiguration.getConfiguration("backup.phone.help.link", "https://www.zoho.com/accounts/help/tfa-thingstoknow.html#Backup%20Phone%20Number"); //No I18N

%>
<script src="<%=jsurl%>/jquery-1.12.2.min.js" type="text/javascript"></script><%-- NO OUTPUTENCODING --%>
<script src="<%=jsurl%>/common.js" type="text/javascript"></script> <%-- NO OUTPUTENCODING --%>
<script src="<%=jsurl%>/xregexp-all.js" type="text/javascript"></script> <%-- NO OUTPUTENCODING --%>
    <link href="<%=cssurl%>/style.css" type="text/css" rel="stylsheet" /> <%-- NO OUTPUTENCODING --%>

 <link href="<%=cssurl%>/chosen.css" type="text/css" type="text/css" rel="stylesheet" /> <%-- NO OUTPUTENCODING --%>
    <link href="../../static/configureMobile.css" rel="stylesheet" type="text/css">
    	<script src="<%=jsurl%>/chosen.jquery.js" type="text/javascript"></script> <%-- NO OUTPUTENCODING --%>
    

<script>
var oldmobile= null;
var csrfParam = '<%=SecurityUtil.getCSRFParamName(request)+"="+SecurityUtil.getCSRFCookie(request)%>';<%-- NO OUTPUTENCODING --%>
var contextpath = "<%=request.getContextPath()%>"; //NO OUTPUTENCODING	

function AddRecovery(emailOrMobile){
	try{
	if(isEmailId(emailOrMobile)){
		var resp;
		if(oldmobile != null){
			params = "new_email_or_mobile=" + euc(emailOrMobile.toLowerCase().trim()); //No I18N
			resp = getPutResponse("/rest/announcement/recovery/" + oldmobile, params);	//No I18N
		} else {
			params = "email_or_mobile=" + euc(emailOrMobile.toLowerCase().trim()) + "&" + csrfParam;	//No I18N
			resp = getPlainResponse(contextpath + "/rest/announcement/recovery", params); //No I18N
		}
		 var obj = JSON.parse(resp);
		if(obj.status == "success"){ //No I18N
			showmsg(obj.message);
 			lock_text(1);
 	        document.getElementById("get_ver_code").style.display="block";
 	        document.getElementById("resend_code").style.display="block";   
 	        document.getElementById("send_ver").style.display="none";   
 	        document.getElementById("ver_id").style.display="inline-block";
 			return true;
		} else if(obj.status=='exceeded'){	//No I18N
 			showErrMsg('<%=Util.getI18NMsg(request,"IAM.MANY.ATTEMPTS")%>');
 		} else {
			showErrMsg(obj.message);	
		}
 	} else if(isValidMobile(emailOrMobile)){
 		var country_code=$("#country_code_select").val();
        if(country_code=="")
    	{
        	country_code= "<%=IAMEncoder.encodeJavaScript(userCountry)%>";  
    	}
        var resp;
        if(oldmobile != null){
        	 params = "new_country_code="+ country_code + "&new_email_or_mobile=" + euc(emailOrMobile.toLowerCase().trim()) + "&mobile_mode=0"; <%-- NO I18N --%>
        	 resp = getPutResponse(contextpath + "/rest/announcement/recovery/" + oldmobile, params); //No I18N
		} else {
			 params = "country_code="+ country_code + "&email_or_mobile=" + euc(emailOrMobile.toLowerCase().trim()) + "&" +csrfParam; <%-- NO I18N --%>
			 resp = getPlainResponse(contextpath + "/rest/announcement/recovery", params); //No I18N
		}
	    var obj = JSON.parse(resp);
 		if(obj.status == "success"){ //No I18N
 			showmsg('<%=Util.getI18NMsg(request, "IAM.ERROR.UPDATE.SUCCESS")%>');
 			lock_text(0);
 	        document.getElementById("get_ver_code").style.display="block";
 	        document.getElementById("resend_code").style.display="block";   
 	        document.getElementById("send_ver").style.display="none";   
 	        document.getElementById("ver_id").style.display="inline-block";
 			return true;
 		} else if(obj.status=='exceeded'){	//No I18N
 			showErrMsg('<%=Util.getI18NMsg(request,"IAM.MANY.ATTEMPTS")%>');
 		} else {
 			showErrMsg(obj.message);
 		}
 	} else {
 		showErrMsg('<%=Util.getI18NMsg(request,"IAM.ERROR.EMAIL.OR.MOBILE.INVALID")%>');
 	}
}catch(e){
	showErrMsg(obj.message);	
}
}

function lock_text(arg)
{
	$("#mobileno").prop("disabled",true);//No I18N
	$("#mobileno_lab").css("top","-50px");		//No I18N
	$(".country_code").css("display","block");//No I18N
	if(arg==0)
	{
		$("#get_mob_no .text_box").css("text-indent" ,"71px");//No I18N
		$('#country_code_select').prop('disabled', true).trigger("liszt:updated");
	}
	$(".edit_icon").css("display","block"); //No I18N
	$("#countrycodeid").prop("disabled",true); //No I18N
	$("#countrycodeid").css("color","grey"); //No I18N
	$("#mobileno").css("color","grey"); //No I18N
	$('#country_code_select').prop('disabled', true).trigger("liszt:updated");
	if($( "#country_code_select option:selected" ).text())
		{
			$('.chzn-single span').text($( "#country_code_select option:selected" ).text().split('(')[1].slice(0,-3));
		}
	else
		{
			$('.chzn-single span').text("+"+<%=dCode%>);
		}
		$('.chzn-single span').css("color","grey");	//No I18N
}
function resendCode()
{
    var mobile = de("mobileno").value;//No I18N
    var country_code=$("#country_code_select").val();
    if(country_code=="")
	{
    	country_code= "<%=IAMEncoder.encodeJavaScript(userCountry)%>";  
	}
    var resp = getPlainResponse(contextpath + "/rest/announcement/recovery/" + mobile.toLowerCase().trim() + "/resend", csrfParam); //No I18N
    try{
    var obj = JSON.parse(resp);
    if(obj.status == "success"){
        showmsg('<%=Util.getI18NMsg(request, "IAM.USER.ACTIONS.CODE.SENT")%>');
        }else{
            showErrMsg(obj.message);
        }
    }catch(e){
        showErrMsg(obj.message);
    }
}
function edit(){
	oldmobile = $('#mobileno').val().trim();
    document.getElementById("get_ver_code").style.display="none";
    document.getElementById("resend_code").style.display="none";   
    document.getElementById("send_ver").style.display="inline-block";
    document.getElementById("ver_id").style.display="none";
    $('.edit_icon').hide();
    $('#down_arrowid').hide();
    $("#mobileno").prop("disabled",false); //No I18N
    $("#countrycodeid").prop("disabled",false); //No I18N
    $("#mobileno_lab").removeAttr("style");	//No I18N
    $(".country_code").removeAttr("style"); //No I18N
    //$("#get_mob_no .text_box").removeAttr("style");
    $("#mobileno").css("color","black"); //No I18N
    $('#country_code_select').prop('disabled', false).trigger("liszt:updated");
    if($( "#country_code_select option:selected" ).text())
	{
		$('.chzn-single span').text($( "#country_code_select option:selected" ).text().split('(')[1].slice(0,-3));
	}
	else
	{
		$('.chzn-single span').text("+"+<%=dCode%>);
	}
	$('.chzn-single span').css("color","grey");	//No I18N
    $('.chzn-single span').css("color","black");	//No I18N
    $('#mobileno').focus();
}

function VerifyCode(v){
	var otp = v;
	var emailOrMobile = $('#mobileno').val();
	if(!isValidCode(otp)){
		showErrMsg('<%=Util.getI18NMsg(request, "IAM.PHONE.INVALID.VERIFY.CODE")%>');
		return;
    }
	var params = "code="+ euc(otp.trim()) +"&action=pwdauth" + "&" +csrfParam; <%-- NO I18N --%>
	try{
	var res = getPlainResponse(contextpath + "/rest/announcement/recovery/" + emailOrMobile.toLowerCase().trim() + "/verify", params);  <%-- NO OUTPUTENCODING --%>  //No I18N
    var obj = JSON.parse(res);
    var ar = obj.cause;
	if(obj.status=='success') {
		showmsg(obj.message);	
		setTimeout(function(){window.location.href = '<%=IAMEncoder.encodeJavaScript(Announcement.getVisitedNextURL(request))%>'},4000);
	}else if(obj.status=='error'){//No I18N
		showErrMsg(obj.message);
		return;
	} else if(obj.status=='exceeded'){	//No I18N
		showErrMsg('<%=Util.getI18NMsg(request, "IAM.REMOTEIP.TOOMANY.WRONG.ATTEMPTS")%>');
	} else if(!isEmpty(ar)){
		ar = ar.trim();
	    if(ar === "invalid_password_token") {   //No I18N
	    	window.location.reload();
			return;
	    }
	}
	else {
		showErrMsg('<%=Util.getI18NMsg(request, "IAM.ERROR.GENERAL")%>');
	}
	}catch(e){
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

function skipAnnouncement(){
	window.location.href = '<%=IAMEncoder.encodeJavaScript(Announcement.getSkipNextURL(request))%>';
}

function isValidMobile(mobile){
 	if(mobile.trim().length != 0){
 		var mobilePattern = new RegExp("^([0-9]{8,12})$");
 		if(mobilePattern.test(mobile)){
 			return true;
 		}
 	}
 	return false;
 }

$(function()
		{
			
			$(".chosen-select").chosen();
			
			$('.chzn-single span').text("+<%=dCode %>");

			$("#country_code_select_chzn").css("display","none");	//No I18N
			
			if($("#mobileno").val()!="")
			{
					$("#mobileno_lab").css("top","-50px");	//No I18N
			}
			
			$('.chzn-search input').attr('tabindex',1);		//No I18N
			
			$('#get_mob_no_conf').bind("cut copy paste",function(e) {
			     e.preventDefault();
			 });
			 

			 $('#get_mob_no').bind("cut copy paste",function(e) {
			     e.preventDefault();
			 });
			 	 
			 	

		    	
		    
		    $("#mobileno").keyup(function(evt)
		    	     {
		    	         evt = (evt) ? evt : window.event; var charCode = (evt.which) ? evt.which : evt.keyCode;

		    	         if($("#mobileno").val()=="")
		    	         {
		    	             $("#country_code_select_chzn").css("display","none");    //No I18N
		    	             $("#mobileno").css("text-indent","0px"); //No I18N
		    	         }   
		    	         if(	((((	$('#mobileno').val().match(new RegExp("[0-9]","g")) || []).length) > 0)) && (((($('#mobileno').val().match(new RegExp("[a-zA-Z]","g")) || []).length) == 0)) && (((($('#mobileno').val().match(new RegExp("[^a-zA-Z0-9]","g")) || []).length) ==0 ))) //No I18N 
		    	        {
		    	             $("#country_code_select_chzn").css("display","inline-block");    //No I18N
		    	             $("#mobileno").css("text-indent","71px"); //No I18N
		    	        }
		    	         else 
		    	         {
		    	             $("#country_code_select_chzn").css("display","none"); //No I18N
		    	             $("#mobileno").css("text-indent","0px"); //No I18N
		    	         }

		    	    });
	
// 		    $("#mobileno").blur(function()
// 		    		{
// 		    			if($("#mobileno").val()!="")
// 		    				{
// 		    						$("#mobileno_lab").css("top","-50px");	//No I18N
// 		    						$("#mobileno").css("color","#666");    	//No I18N
// 		    				}
// 						else
// 							$("#mobileno_lab").css("top","-25px");		//No I18N
// 		    		});
// 		    $("#mobileno").focus(function()
// 		    		{
// 							$("#mobileno_lab").css("top","-50px");	//No I18N
// 							$("#mobileno").css("color","#666");    	//No I18N			
// 		    		});
			
			$(document).on('change', 'select', function() {
				
				$('.chzn-single span').text($( "#country_code_select option:selected" ).text().split('(')[1].slice(0,-3));
				$("#mobileno").focus();
			});
				
				
			$('.chzn-results').click(function(){
				$('.chzn-single span').text($( "#country_code_select option:selected" ).text().split('(')[1].slice(0,-3));$("#mobileno").focus();
				return false;
				});

			$(".chzn-container").bind('keyup',function(e) {
			    if(e.which === 13) {
			    	$('.chzn-single span').text($( "#country_code_select option:selected" ).text().split('(')[1].slice(0,-3));$("#mobileno").focus();
			    	return false;
			    }
			});
			 	 
		});

		function showErrMsg(msg) { $(".top_div").css({"border-right": "3px solid #ef4444", "color": "#ef4444"});   $(".cross_mark").css("background-color","#ef4444");      $(".crossline1").css({"top": "18px", "left": "0px", "width":"20px"});     $(".crossline2").css("left","0px");   $('.top_msg').html(msg); //No I18N 
		$( ".top_div" ).fadeIn("slow");  setTimeout(function() {  $( ".top_div" ).fadeOut("slow"); }, 3000); //No I18N

		}

		function showmsg(msg) { $(".top_div").css({"border-right": "3px solid #50BF54", "color": "#50BF54"});   $(".cross_mark").css("background-color","#50BF54");      $(".crossline1").css({"top": "22px", "left": "-6px", "width":"12px"});     $(".crossline2").css("left","4px");   $('.top_msg').html(msg); //No I18N 
		$( ".top_div" ).fadeIn("slow");  setTimeout(function() {  $( ".top_div" ).fadeOut("slow"); }, 3000); //No I18N

		}
</script>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

   <style type="text/css">
/* new style */


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
    margin-bottom:10px;
    margin-top: 5px;
}
.name
{
    font-size: .9em;
    font-weight: bold;
    display: block;
}
.announcement_text
{
    line-height: 1.5;
    font-size: .9em;
    display: block;
    padding-top: 5px
}

.msg_head 
{
    display: block;
    font-size: 0.8em;
    margin: 30px 0 -30px;
 }
 .btn
 {
 	padding: 10px 30px;
 }
.skip_btn
{
    background-color: #eeeeee;
    color: #000;
    border:1px solid #eee;
   }
   .skip_btn:hover
{
    background-color: #eeeeee;
    color: #000;
   }
input:focus
{
    outline: none;
}
.time
{
    display: block;
    margin: 4% 0px;
    font-weight: bold;
    font-size: .8em;
}
.update_btn
{
    margin-top: 20px;
    cursor: pointer;
    font-size: .8em;
    border: none;
    background-color: #1ab2f1;
    padding: 10px 20px;
    color: #fff;
    display: block;
}
.update_btn:hover
{
    background-color: #18a9e5;
}
.btns
{
    display: block;
}
.spacing
{
    line-height: 2.5;
}
.accept_btn
{
    cursor: pointer;
    font-size: 1em;
    font-weight: 100;
    margin-top: 20px;
    width: 300px;
    height: 35px;
    display: block;
    color: #fff;
    background-color: #00b1f4;
    border: none;
}
.accept_btn:hover
{
    background-color: #00a5e4;
}



/* new style end */


/*---------------Top message-----------------*/ 
.top_div 
{
 left: 0;
 right: 0;
 margin-left: auto; 
 margin-right: auto; 
 top: 0px; 
 position: absolute; 
 height: 40px; 
 width: 400px; 
 background: rgba(221, 221, 221, 0.22); 
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
.error_notif , .captcha_error_notif 
{ 
 color: #ff6164;
 margin-left: 5px;   
 font-size: 12px;   
 margin-top: -25px; 
}
    </style>

<style type="text/css">
            #errmsg{
              margin-left: 28%;
  			  font-size: 12px;
  			  margin-bottom: 1%;
  			  width: 38%;
  			  color:white;
  			  text-align: center;
            }

</style>

</head>

<!--     <body> -->
<!-- 		<div class="maincontent"> -->
<!-- 			<div id="errmsg" class="hide"></div>	 -->
<!-- 		    <div class="menucontent"> -->
<!-- 		    <div class="Hari"> -->
<%-- 			<div class="topcontent"><div class="contitle"><%=Util.getI18NMsg(request, "IAM.HOSTED.EMAIL.PREANNOUNCEMENT.TITLE")%></div></div> --%>
		
<!-- 		<input type="text" id="emailormobile" placeholder="Add email or mobile"  /> -->
<!-- 		<input type="button" value="Add Recovery" onclick="AddRecovery(document.getElementById('emailormobile').value)"></button>	 -->
<!-- 				<input type="text" id="verificationcode" placeholder="Enter verification code"  /> -->
<!-- 		<input type="button" value="Verify Code" onclick="VerifyCode(document.getElementById('verificationcode').value)"></button> -->
<!-- 		    </div> -->
<!-- 		    </div> -->
<!-- 		    </div> -->
	    

	
	
	
<!-- </body> -->


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
     
     
        <div class="container">
        <img class="zoho_logo" src="<%=imgurl%>/zlogo.png">  <%-- NO OUTPUTENCODING --%>
        <span class="head_text"><%=Util.getI18NMsg(request, "IAM.HOSTED.EMAIL.PREANNOUNCEMENT.TITLE")%></span>
        <span class="name"><%=Util.getI18NMsg(request, "IAM.HI.USERNAME",user.getFullName() == null ? "" : IAMEncoder.encodeHTMLAttribute(user.getFullName()))%></span>
        <span class="announcement_text"><%=Util.getI18NMsg(request, "IAM.HOSTED.EMAIL.PREANNOUNCEMENT.DESCRIPTION", learnMoreLink)%></span>
        <br />
    
    
    <div class="form_field" id="get_mob_no" Style="margin-top: 30px;display:block;">
        <input class="text_box" id="mobileno"   type="text" required="" autocomplete="off">
         <span class="edit_icon" onclick=edit();></span>
	   <select class="chosen-select" id="country_code_select">
		    <option></option>
		    <% 
		    for(ISDCode isdCode : countryList)
		    {
				String display=IAMEncoder.encodeHTMLAttribute(isdCode.getCountryName())   +"&nbsp;(+"+IAMEncoder.encodeHTMLAttribute(String.valueOf(isdCode.getDialingCode()))+") ";
			%>
			<option data-num="+<%=IAMEncoder.encodeHTMLAttribute(String.valueOf(isdCode.getDialingCode()))%>" value="<%=IAMEncoder.encodeHTMLAttribute(isdCode.getCountryCode()) %>"><%= display %> </option>
			<% 
			}%>
		</select> 
        <span id="mobileno_lab_bar"class="bar"></span>
        <label id="mobileno_lab"><%=Util.getI18NMsg(request,"IAM.ENTER.EMAIL.OR.MOBILE")%></label>        
	</div>
	
    <div class="form_field" id="get_ver_code">
        <input class="text_box"  id="verify_code" type="text" required="">
        <span class="bar"></span>
        <label><%=Util.getI18NMsg(request,"IAM.TFA.ENTER.VERIFICATION.CODE")%></label>
    </div>    
        
    <div class="medium_text blue" id="resend_code" onclick="resendCode();"><%=Util.getI18NMsg(request,"IAM.TFA.RESEND.CODE")%></div>
    
    
        <div class="btns">
<%--         	<input class="verify_btn" type="button"  value="<%=Util.getI18NMsg(request, "IAM.HOSTED.EMAIL.PREANNOUNCEMENT.TITLE")%>"> --%>
		    <button class="btn" id="send_ver" style="display:inline-block;"onclick="AddRecovery(document.getElementById('mobileno').value)"><%=Util.getI18NMsg(request,"IAM.ADD")%></button> 
		    <button class="btn" id="ver_id" onclick="VerifyCode(document.getElementById('verify_code').value)"><%=Util.getI18NMsg(request,"IAM.VERIFY")%></button>    
			<button class="btn skip_btn" id="skip" style="display:inline-block;"onclick="skipAnnouncement()"><%=Util.getI18NMsg(request,"IAM.SKIP")%></button>
        </div>
        </div>        
    </body>

</html>