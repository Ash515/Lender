<%-- $Id$ --%>
<%@page import="com.zoho.accounts.AccountsProto.Account.User.UserMobile"%>
<%@page import="com.zoho.accounts.AccountsProto.Account.User.UserVerificationCode"%>
<%@page import="com.zoho.accounts.AccountsProto.Account.User.AuthToken"%>
<%@page import="com.zoho.accounts.internal.util.AccountsInternalConst.MobileSMSUseCase"%>
<%@page import="org.json.JSONObject"%>
<%@page import="com.zoho.accounts.phone.SMS.SMSType"%>
<%@page import="com.zoho.accounts.Accounts"%>
<%@page import="com.zoho.accounts.phone.SMS"%>
<%@page import="com.zoho.accounts.mail.MailUtil.Generator"%>
<%@page import="com.adventnet.iam.internal.PhoneUtil"%>
<%@page import="com.adventnet.iam.servlet.Password"%>
<%@page import="com.zoho.accounts.AccountsProto.Account.User.UserMobile"%>
<%@page import="com.zoho.accounts.internal.util.IPInfo"%>
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
<meta name="viewport" content="width=device-width, initial-scale=1.0,user-scalable=no"></meta>
<%
User user = IAMUtil.getCurrentUser();

AuthToken at = Util.getTempAuthTokenFromThreadLocal();
if(at == null || user.isConfirmed()){
	String serviceurl = request.getParameter("serviceurl") != null ? request.getParameter("serviceurl") : Util.getIAMURL();
	serviceurl = Util.getTrustedURL(user.getZUID(), serviceurl);
	response.sendRedirect(serviceurl);
	return;
}
String details = at.getAuthTokenDetails().getDetails();
JSONObject json = new JSONObject(details);
String vcid = json.optString("vcid");	//No I18N
UserVerificationCode vcode = null;
String email_mobile=IAMUtil.isValidIAMMobileFormat(user.getPrimaryEmail())?new UserPhone(user.getPrimaryEmail()).getPhoneNumber():user.getPrimaryEmail();
if(!Util.isValidPhone(email_mobile) && email_mobile.endsWith(Util.getBlockedEmailIdDomain()) ){
	email_mobile=user.getMobileScreenName()!=null && !user.getMobileScreenName().isConfirmed()?new UserPhone(user.getMobileScreenName().getEmailId()).getPhoneNumber():email_mobile;
}

boolean isEmailBlock=!Util.isValidPhone(email_mobile);
if(Util.isValid(vcid)){
	vcode =   Util.getValidUserVerificationCode(user.getZaid(), user.getZUID()+"", vcid);
}
UserMobile um=null;

String userCountry=null;
int dCode = -1;
List<ISDCode> countryList = SMSUtil.getAllowedISDCodes();
if(!isEmailBlock){
	um = Accounts.getUserMobileURI(user.getZaid(), user.getZUID(), new UserPhone(email_mobile).getPhoneNumber()).GET();
	userCountry = um.getCountryCode();
	dCode = SMSUtil.getISDCode(userCountry);
}

if(vcode == null) {
	String verCode = Generator.VerificationCode.generate();
	vcid = SMS.addVerificationCode(user.getZaid(), String.valueOf(user.getZUID()), email_mobile, verCode);
	if(!isEmailBlock){
		SMS.sendUserPhoneVerification(user.getZaid(), String.valueOf(user.getZUID()), um.getMobile(), verCode, SMSType.sms.getIntegerValue(), um.getCountryCode() , user.getLanguage(), null, null,MobileSMSUseCase.blockunconfirmed);
	} else {
		Util.sendMailWithCode(user, email_mobile, verCode);
	}
	json.put("vcid", vcid); //No I18N
	CSPersistenceAPIImpl.updateTempTokenDetails(user, at.getToken(), json.toString());
}


%>
<script src="<%=jsurl%>/jquery-1.12.2.min.js" type="text/javascript"></script><%-- NO OUTPUTENCODING --%>
<script src="<%=jsurl%>/common.js" type="text/javascript"></script> <%-- NO OUTPUTENCODING --%>
<script src="<%=jsurl%>/xregexp-all.js" type="text/javascript"></script> <%-- NO OUTPUTENCODING --%>
    <link href="<%=cssurl%>/style.css" type="text/css" rel="stylsheet" /> <%-- NO OUTPUTENCODING --%>

 <link href="<%=cssurl%>/chosen.css" type="text/css" type="text/css" rel="stylesheet" /> <%-- NO OUTPUTENCODING --%>
    	<script src="<%=jsurl%>/chosen.jquery.js" type="text/javascript"></script> <%-- NO OUTPUTENCODING --%>

<script>





var oldmobile= null;
var csrfParam = '<%=SecurityUtil.getCSRFParamName(request)+"="+SecurityUtil.getCSRFCookie(request)%>';<%-- NO OUTPUTENCODING --%>
var contextpath = "<%=request.getContextPath()%>"; //NO OUTPUTENCODING	

function AddRecovery(emailOrMobile){
	try{
		var resp;
		var blockDomain='@<%=IAMEncoder.encodeJavaScript(Util.getBlockedEmailIdDomain())%>';
		<%if(isEmailBlock){%>
			<%if(AccountsConfiguration.BLOCK_PLUS_CHARACTER_IN_EMAIL.toBooleanValue()){%>
			if(emailOrMobile.indexOf('+')!==-1){
				showErrMsg('<%=Util.getI18NMsg(request,"IAM.ERROR.EMAIL.SPECIAL.CHARACTER")%>');
				return false;
			}
			<%}%>
			if(isEmailId(emailOrMobile) && emailOrMobile.indexOf(blockDomain)===-1){
				changeLoading("#send_ver");//No I18N
				params = "new_email_or_mobile=" + euc(emailOrMobile.toLowerCase().trim()); //No I18N
				resp = getPutResponse("/rest/announcement/recovery/" + oldmobile, params);	//No I18N
			}else if(emailOrMobile.indexOf(blockDomain)!==-1){
				showErrMsg('<%=Util.getI18NMsg(request,"IAM.ERROR.CODE.U112")%>');
				return false;
			}else {
				showErrMsg('<%=Util.getI18NMsg(request,"IAM.ERROR.EMAIL.INVALID")%>');
				return false;
			}	 
		<%}else{%>
			if(isValidMobile(emailOrMobile)){
				var country_code=$("#country_code_select").val();
			    if(country_code==""){
			      	country_code= "<%=IAMEncoder.encodeJavaScript(userCountry)%>";  
			  	}
 			     changeLoading("#send_ver");//No I18N
				 params = "new_country_code="+ country_code + "&new_email_or_mobile=" + euc(emailOrMobile.trim()) + "&mobile_mode=0"; <%-- NO I18N --%>
	        	 resp = getPutResponse(contextpath + "/rest/announcement/recovery/" + oldmobile, params); //No I18N
			}else {
				showErrMsg('<%=Util.getI18NMsg(request,"IAM.PHONE.ENTER.VALID.MOBILE")%>');
				return false;
			}
		<%}%>
		var obj = JSON.parse(resp);
		if(obj.status == "success"){ //No I18N
			showmsg(obj.message);
				lock_text(1);
		        document.getElementById("get_ver_code").style.display="block";
		        document.getElementById("resend_code").style.display="block";   
		        document.getElementById("send_ver").style.display="none";   
		        document.getElementById("ver_id").style.display="inline-block";
		        $(document.confirm_form).attr("onsubmit","return VerifyCode(document.getElementById('verify_code').value)");//No I18N
		        $("#mobileno").css("padding-right","30px");//No I18N
		        removeLoading("#send_ver");//No I18N
				return false;
		} else if(obj.status=='exceeded'){	//No I18N
			showErrMsg('<%=Util.getI18NMsg(request,"IAM.MANY.ATTEMPTS")%>');
		}else if(obj.status=='blockdomain'){	//No I18N
			showErrMsg('<%=Util.getI18NMsg(request,"IAM.ERROR.CODE.U112")%>');
		} else {
			showErrMsg(obj.message);	
		}
		 removeLoading("#send_ver");//No I18N
		 return false;
	}catch(e){
		showErrMsg('<%=Util.getI18NMsg(request,"IAM.ERROR.CODE.Z101")%>');	
		 removeLoading("#send_ver");//No I18N
		 return false;
	}
}

function lock_text(arg)
{
	$("#mobileno").prop("disabled",true);//No I18N
	$("#mobileno_lab").css({"top":"-23px","font-size":"13px"});		//No I18N
	$(".country_code").css("display","block");//No I18N
	if(arg==0)
	{	var countrycode = $('#country_code_select').val();
		if(countrycode != ""){
			$("#get_mob_no .text_box").css("text-indent" ,"71px");//No I18N
			$('#country_code_select').prop('disabled', true).trigger("liszt:updated");
		}
	}
	$(".edit_icon").css("display","block"); //No I18N
	$("#countrycodeid").prop("disabled",true); //No I18N
	$("#countrycodeid").css("color","grey"); //No I18N
	//$("#mobileno").css("color","#000"); //No I18N
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
 	$("#get_ver_code").hide();
    $("#resend_code").hide();   
    $("#send_ver").show();
    $("#ver_id").hide();
    $('.edit_icon').hide();
    $('#down_arrowid').hide();
    $("#mobileno").prop("disabled",false); //No I18N
    $("#countrycodeid").prop("disabled",false); //No I18N
    if(isEmailId(oldmobile)) {
    	$("#get_mob_no .text_box").css("text-indent" ,"0px");//No I18N
    }
    $("#mobileno").css("padding-right","0px")//No I18N
    $("#mobileno_lab").removeAttr("style");	//No I18N
    $(".country_code").removeAttr("style"); //No I18N
    //$("#get_mob_no .text_box").removeAttr("style");
    $("#mobileno").css("color","black"); //No I18N
    $('#country_code_select').prop('disabled', false).trigger("liszt:updated");
    $(document.confirm_form).attr("onsubmit","return AddRecovery(document.getElementById('mobileno').value)");//No I18N
    if($( "#country_code_select option:selected" ).text())
	{
		$('.chzn-single span').text($( "#country_code_select option:selected" ).text().split('(')[1].slice(0,-3));
	}
	else
	{	
			$('.chzn-single span').text("+"+<%=dCode%>);
		if(isValidMobile(oldmobile)){
			$("#country_code_select_chzn").css("display","block"); //No I18N
		}
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
		return false;
    }
	changeLoading("#ver_id");//No I18N
	var params = "code="+ euc(otp.trim()) + "&action=unauth" +"&" +csrfParam; <%-- NO I18N --%>
	var res = getPlainResponse(contextpath + "/rest/announcement/recovery/" + emailOrMobile.toLowerCase().trim() + "/verify", params);  <%-- NO OUTPUTENCODING --%>  //No I18N
	try{
    var obj = JSON.parse(res);	
	if(obj.status=='success') {
		showmsg(obj.message);
		$('#ver_id').prop('disabled', true); //No I18N
		setTimeout(function(){window.location.href = '<%=IAMEncoder.encodeJavaScript(Util.getNextPreAnnouncementUrl("add-recovery"))%>'},3000);
	}else if(obj.status=='error'){//No I18N
		showErrMsg(obj.message);
		removeLoading("#ver_id");//No I18N
	} else if(obj.status=='exceeded'){	//No I18N
		showErrMsg('<%=Util.getI18NMsg(request, "IAM.REMOTEIP.TOOMANY.WRONG.ATTEMPTS")%>');
		removeLoading("#ver_id");//No I18N
	}
	else {
		showErrMsg('<%=Util.getI18NMsg(request, "IAM.ERROR.GENERAL")%>');
		removeLoading("#ver_id");//No I18N
	}
	return false;
	}catch(e){
		showErrMsg(obj.message);
		removeLoading("#ver_id");//No I18N
		return false;
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

function isValidMobile(mobile){
 	if(mobile.trim().length != 0){
 		var mobilePattern = new RegExp("^([0-9]{3,14})$");
 		if(mobilePattern.test(mobile)){
 			return true;
 		}
 	}
 	return false;
 }

window.onload=function()
		{
			
			$(".chosen-select").chosen();
			
			$('.chzn-single span').text("+<%=dCode %>");
			

			$("#country_code_select_chzn").css("display","none");	//No I18N
			
			if($("#mobileno").val()!="")
			{
					$("#mobileno_lab").css({"top":"-23px","font-size":"13px"});	//No I18N
			}
			
			$('.chzn-search input').attr('tabindex',1);		//No I18N
			
			$('#get_mob_no_conf').bind("cut copy paste",function(e) {
			     e.preventDefault();
			 });
			 

			 $('#get_mob_no').bind("cut copy paste",function(e) {
			     e.preventDefault();
			 });
			<%if(!isEmailBlock){%>
			 $("#mobileno").keyup(function(evt){
    	         evt = (evt) ? evt : window.event; var charCode = (evt.which) ? evt.which : evt.keyCode;
    	         if(isValidMobile($("#mobileno").val())) //No I18N 
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
			<%}%>
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
			  
			<%if(!isEmailBlock){ %>

			$("#country_code_select_chzn").show();
			lock_text(0);
			$("#get_ver_code").show();
			$("#resend_code").show();   
			$("#send_ver").hide();
			$("#ver_id").show();


			<%} else {%>

			lock_text(1);
			$("#get_ver_code").show();
			$("resend_code").show();   
			document.getElementById("send_ver").style.display="none";   
			document.getElementById("ver_id").style.display="inline-block";

			<%} %> 
			 	 
		};

		function showErrMsg(msg) { $(".top_div").css({"border-right": "3px solid #ef4444", "color": "#ef4444"});   $(".cross_mark").css("background-color","#ef4444");      $(".crossline1").css({"top": "18px", "left": "0px", "width":"20px"});     $(".crossline2").css("left","0px");   $('.top_msg').html(msg); //No I18N 
		$( ".top_div" ).fadeIn("slow");  setTimeout(function() {  $( ".top_div" ).fadeOut("slow"); }, 3000); //No I18N

		}

		function showmsg(msg) { $(".top_div").css({"border-right": "3px solid #50BF54", "color": "#50BF54"});   $(".cross_mark").css("background-color","#50BF54");      $(".crossline1").css({"top": "22px", "left": "-6px", "width":"12px"});     $(".crossline2").css("left","4px");   $('.top_msg').html(msg); //No I18N 
		$( ".top_div" ).fadeIn("slow");  setTimeout(function() {  $( ".top_div" ).fadeOut("slow"); }, 3000); //No I18N

		}
		function changeLoading(ele){
			$(ele).addClass("loading_change");
			$(ele).attr("disabled", "disabled");//No I18N
		}
		function removeLoading(ele){
			$(ele).removeClass("loading_change");	
			$(ele).removeAttr("disabled")//No I18N
		}

</script>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

   <style type="text/css">
/* new style */


input[type="text"]:disabled {   
 color: #000;
 opacity:0.7;
}

body
{
    font-family: 'Open Sans', sans-serif;
    margin: 0;
}
.zoho_logo
{
    height: auto;
    width: auto;
}
.name
{
    font-weight: bold;
    display: block;
    padding:0px;
    margin-top:0px !important;
}

.msg_head 
{
    display: block;
    font-size: 0.8em;
    margin: 30px 0 -30px;
 }

.verify_btn , .skip_btn
{
    margin-right: 10px;
    cursor: pointer;
    font-size: .8em;
    border: none;
    background-color: #1ab2f1;
    padding: 10px 10px;
    color: #fff;
    display: inline-block;
    font-weight: 100;
}
.verify_btn:hover
{
    background-color: #18a9e5;
}
.skip_btn
{
    margin-top: 10px;
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


.container {
    display: block;
    height: auto;
    width: 50%;
    max-width: 800px;
    padding-top: 130px;
    margin-right: 5%;
    margin-left: 50%;
    padding-bottom: 30px;
}
.zoho_logo
{   
    display: block;
    height: 28px;
    width: auto;
}
.head_text {
    font-size: 24px;
    line-height: 40px;
    margin-top: 30px;
    font-weight: 500;
}
.normal_text,.description{
	font-size:16px;
	line-height:30px;
	margin-top:10px;
}
.btn
{
    display: inline-block;
    height: 36px;
    box-sizing: border-box;
    border: none;
    border-radius: 2px;
    font-size: 13px;
    padding: 0px 30px;
    margin-top: 30px;
    font-weight: 600;
    margin-right: 20px;
    background:#eeeeee;
    outline: none;
    cursor: pointer;
    text-transform: uppercase;
    transition: all .1s ease-in-out
}
.grey_btn		
{		
	color:#7f7f7f;		
	background:#eeeeee;		
}		
.grey_btn:hover		
{		
	background: #e2e2e2;		
}
.green_btn
{
	background-color: #69C585;
	color: #fff;
}
.green_btn:hover
{
	background-color: #54B772;
}
.textbox_label
{
	display: block;
	font-size: 15px;
	position: absolute;
	top: 2px;
	margin-left: 1px;
	letter-spacing: 0.3;
	transition: all .2s ease;
	cursor: text;
	max-width: 340px;
	line-height:32px;
    color: #AAAAAA;
}
.textbox_div
{
	display: block;
	width: 340px;
	position:relative;
	margin-top: 45px;
}
.text_box
{
	display: block;
	border: none;
	outline: none;
	width: 100%;
	border-bottom: 2px solid #EFEFEF;
	height: 36px;
	font-size: 15px;
	max-width: 340px;
	position: relative;
	z-index: 1;
	padding:0px;
	background-color: transparent !important;
}
.textbox_line
{
	display: block;
	height: 2px;
	width: 0%;
	background-color: #69C585;
	position: absolute;
    top: 34px;
	margin: auto;
	transition: all .2s ease;
	max-width: 340px;
	z-index: 2;
}
.text_box:focus ~ .textbox_label, .text_box:valid ~ .textbox_label
{
    font-size: 13px;
    top: -23px !important;
}
.blue
{
	color: #2196F3;
    cursor: pointer;
    font-size: 14px;
    margin-top: 10px;
	display: inline-block;
}
.edit_icon {
    width: 25px;
    height: 25px;
    position: absolute;
    background: url(<%=imgurl%>/edit.png) no-repeat;
    background-size: 15px;
    background-position: center;
    top: 5px;
    right: 0px;
    cursor: pointer;
    display: none;
    z-index:1;
}
.acc_confirm_bg{
	background: url(<%=imgurl%>/verifyaccount.png) no-repeat;
	background-size: auto 100%;
	width: 100%;
    position: fixed;
    z-index: -1;
    top: 0px;
    left: 0px;
    height: 100%;
    min-height: 800px;
    max-height: 1500px;
}
.loading_change:after
{
	content: "";
    border: 2px solid white;
    border-top: 2px solid transparent;
    border-radius: 50%;
    width: 12px;
    display: inline-block;
    height: 12px;
    background: transparent;
    position: relative;
    left: 5px;
    top: 1px;
    box-sizing: border-box;
    animation: spin 1s linear infinite;
}
@-webkit-keyframes spin
{
	0% {-webkit-transform: rotate(0deg);}
100% {-webkit-transform:rotate(360deg);}
}
@keyframes spin
{
	0% {transform: rotate(0deg);}
	100% {transform:rotate(360deg);}
}
/*---------------Top message-----------------*/ 
.top_div 
{
 left: 0;
 right: 0;
 margin-left: auto; 
 margin-right: auto; 
 top: 0px; 
 position: fixed; 
 height: 40px; 
 width: 400px; 
 background: rgb(248, 248, 248);
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

#country_code_select_chzn
{
    top: -28px;
    width: 340px !important;
    height: 30px;
}
#country_code_select_chzn .chzn-single
{
    width: 56px;
    z-index:2;
}
.chzn-container .chzn-results
{
    max-height: 160px;
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
@media 
    only screen and (-webkit-min-device-pixel-ratio: 2), 
    only screen and ( min--moz-device-pixel-ratio: 2), 
    only screen and ( -o-min-device-pixel-ratio: 2/1), 
    only screen and ( min-device-pixel-ratio: 2), 
    only screen and ( min-resolution: 192dpi), 
    only screen and ( min-resolution: 2dppx) {
		.acc_confirm_bg{
			background: url(<%=imgurl%>/verifyaccount@2x.png) no-repeat  ;
			background-size: auto 100%;
		}
    }
@media only screen and (max-width: 1300px) {
   .acc_confirm_bg{ 
     display:none; 
   } 
   .container{
   	width:70%;
   	margin:auto;
   }
 }
@media only screen and (max-width: 420px) {
  .container{
    width: 100%;
    padding: 0px 30px;
    padding-top: 30px;
    margin: auto;
    box-sizing: border-box;
    float: none;
  }
  .textbox_div
  {
  	width:100%;
  }
  #country_code_select_chzn
	{
	    width: 100% !important;
	}
 }
</style>

</head>
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
     
     	<div style="">
     		<div class="acc_confirm_bg"></div>
     		<div class="container">
     			<div class="header" id="header">
     				<img class="zoho_logo" src="<%=imgurl%>/zlogo.png">  <%-- NO OUTPUTENCODING --%>
     			</div>
     			<div class="wrap">  
	    			<div class="info">
	    				<div class="head_text"><%=Util.getI18NMsg(request, "IAM.BLOCK.UNCONFIRMED.TITLE")%></div>
	    				<span class="name normal_text"><%=Util.getI18NMsg(request, "IAM.HI.USERNAME",user.getFullName() == null ? "" : IAMEncoder.encodeHTMLAttribute(user.getFullName()))%></span>
        				<span class="announcement_text normal_text"><%=Util.getI18NMsg(request, "IAM.BLOCK.UNCONFIRMED.CONTENT")%></span>
	    				<form name="confirm_form" class="" novalidate onsubmit="return VerifyCode(document.getElementById('verify_code').value)">
	    				   <div class="textbox_div" id="get_mob_no" Style="display:block;">
							   <input class="text_box" id="mobileno" value="<%=IAMEncoder.encodeHTMLAttribute(email_mobile)%>" type="text" style="padding-right:30px;box-sizing:border-box;" required="" autocomplete="off">
							   <span class="edit_icon" onclick=edit();></span>
							   <%if(!isEmailBlock){%>
							   <select class="chosen-select" id="country_code_select">
								    <option></option>
								    <% 
								    for(ISDCode isdCode : countryList)
								    {
										String display=IAMEncoder.encodeHTMLAttribute(isdCode.getCountryName())   +"&nbsp;(+"+IAMEncoder.encodeHTMLAttribute(String.valueOf(isdCode.getDialingCode()))+") ";
									if(dCode==(isdCode.getDialingCode()))
									{
									%>
										<option data-num="+<%=IAMEncoder.encodeHTMLAttribute(String.valueOf(isdCode.getDialingCode()))%>" value="<%=IAMEncoder.encodeHTMLAttribute(isdCode.getCountryCode()) %>" selected><%= display %> </option>
									<%
									}
									else
									{
									%>
									<option data-num="+<%=IAMEncoder.encodeHTMLAttribute(String.valueOf(isdCode.getDialingCode()))%>" value="<%=IAMEncoder.encodeHTMLAttribute(isdCode.getCountryCode()) %>"><%= display %> </option>
									<%
									}
									}%>
								</select>
							   <%}%>
						        <span id="mobileno_lab_bar"class="bar"></span>
						        <label id="mobileno_lab" class="textbox_label"><%=isEmailBlock?Util.getI18NMsg(request,"IAM.ENTER.EMAIL"):Util.getI18NMsg(request,"IAM.ENTER.PHONE.NUMBER")%></label>        
							</div>
	
						    <div class="textbox_div" id="get_ver_code">
						        <input class="text_box"  id="verify_code" type="text" required="">
						        <span class="bar"></span>
	        					<label class="textbox_label"><%=Util.getI18NMsg(request,"IAM.TFA.ENTER.VERIFICATION.CODE")%></label>
	    					</div>    
        
	    					<span class="medium_text blue" id="resend_code" onclick="resendCode();"><%=Util.getI18NMsg(request,"IAM.TFA.RESEND.CODE")%></span>
	        				<div class="btns">
							    <button class="btn green_btn" id="send_ver" style="display:block;"><%=Util.getI18NMsg(request,"IAM.ADD")%></button>
							    <button class="btn green_btn" id="ver_id" ><%=Util.getI18NMsg(request,"IAM.VERIFY")%></button>    
					      	</div>
	    				</form>
	    			</div>
	    		</div>
     		</div>
     	</div>   
    </body>
</html>