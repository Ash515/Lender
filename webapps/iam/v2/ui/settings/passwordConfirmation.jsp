<%-- $Id: $ --%>
<%@page import="com.zoho.accounts.AccountsProto.Account.User.OpenId"%>
<%@page import="com.zoho.accounts.AccountsConfiguration"%>
<%@page import="com.adventnet.iam.security.SecurityUtil"%>
<%@page import="com.adventnet.iam.xss.IAMEncoder"%>
<%@page import="com.zoho.accounts.AccountsConstants.IdentityProvider"%>
<%@page import="java.util.Set"%>
<%@page import="java.util.HashSet"%>
<%@page import="com.zoho.iam2.rest.CSPersistenceAPIImpl"%>
<%@page import="com.adventnet.iam.CryptoUtil"%>
<%@page import="java.net.URL"%>
<%@page import="java.net.URI"%>
<%@page import="java.util.regex.Pattern"%>
<%@page import="com.zoho.accounts.AccountsProto.Account.AuthDomain.Saml"%>
<%@page import="com.zoho.accounts.AccountsProto.Account.User.Password"%>
<%@page import="com.zoho.accounts.Accounts"%>
<%@page import="com.adventnet.iam.internal.Util"%>
<%@page import="com.adventnet.iam.User"%>
<%@page import="com.adventnet.iam.IAMUtil"%>
<%@page import="com.zoho.accounts.webclient.util.WebClientUtil"%>
<%
boolean isStatic = "true".equals(AccountsConfiguration.getConfiguration("iam.static.newui", "false"));
String cPath = request.getContextPath();
String cssurl = isStatic ? WebClientUtil.getCSSURL(request) : cPath+"/v2/components/css"; //No I18N
String jsurl = isStatic ? WebClientUtil.getJSURL(request) : cPath+"/v2/components/js"; //No I18N
String tpkgurl = isStatic ? WebClientUtil.getTPJSURL(request) : cPath+"/v2/components/tp_pkg"; //No I18N
String wmsjsurl = isStatic ? WebClientUtil.getWMSJSURL(request) : "/wms/javascript"; //No I18N
boolean isAuth=Util.getTempAuthTokenFromThreadLocal()==null;
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta name="viewport" content="width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=no" />
		<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title><%= Util.getI18NMsg(request,"IAM.ZOHO.ACCOUNTS")%></title>
		<link href="<%=cssurl%>/passwordConfirmation.css" type="text/css" rel="stylesheet" /><%-- NO OUTPUTENCODING --%> 
		<script src="<%=tpkgurl%>/jquery-3_5_1.min.js" type="text/javascript"></script> <%--NO OUTPUTENCODING --%>
		<%if(isAuth){ %>
		<script src="<%=wmsjsurl%>/wmsliteapi.js" type="text/javascript"></script> <%-- NO OUTPUTENCODING --%>
		<script src="<%=jsurl%>/wmsliteimpl.js" type="text/javascript"></script>
		<%} %>
	</head>
<body>

<script src="<%=jsurl%>/common_unauth.js" type="text/javascript"></script> <%-- NO OUTPUTENCODING --%><%
User user = IAMUtil.getCurrentUser();
String email = IAMUtil.getCurrentUser().getDisplayId();
boolean ispasswordexists = false;
long zuId = -1;
Saml saml= null;
String primay_mail = null;
//No need to check user null or not since user needed is set in filter level
zuId = user.getZUID();
Password passwordUri = Accounts.getPasswordURI(user.getZaid(), user.getZUID()).GET();
ispasswordexists= passwordUri != null ? passwordUri.hasPassword() : false;
saml =Util.getSAMLAuthDomainForUser(user);
primay_mail = user.getPrimaryEmail();

String serviceurl = request.getParameter("serviceurl");
boolean post_action = Boolean.parseBoolean(request.getParameter("post")); 
String userid = CryptoUtil.encryptWithSalt("photo", zuId+"", ":", IAMUtil.getCurrentTicket(), true); //No I18N
String resetPassUrl = request.getContextPath() + "/password"; //No I18N
boolean isMobile=Boolean.parseBoolean(request.getParameter("ismobile"));
%>
<script>
var csrfParam = "<%=SecurityUtil.getCSRFParamName(request)%>"; //NO OUTPUTENCODING   
var csrfCookieName= "<%=SecurityUtil.getCSRFCookieName(request)%>";
var contextpath = "<%=request.getContextPath()%>"; //NO OUTPUTENCODING	
var call_back_args="<%=IAMEncoder.encodeJavaScript(request.getParameter("argumnets"))%>"; //NO OUTPUTENCODING	
var call_back="<%=IAMEncoder.encodeJavaScript(request.getParameter("callback"))%>";//NO OUTPUTENCODING	


function checkpassword(f){
	remove_err();
	var passwd = f.current.value.trim();
	var serviceurl='<%=IAMEncoder.encodeJavaScript(serviceurl)%>';
	var post_action=<%=post_action%>;
	if(isEmpty(passwd)){
		$('#relogin #pwd').focus();
 		checkPwdVal('<%=Util.getI18NMsg(request, "IAM.PASSWORD.ERROR.PASS_NOT_EMPTY")%>');
    	return false;
	}
	var params = "&password="+euc(passwd)+"&serviceurl="+euc(serviceurl)+"&"+csrfParam+"="+euc(getCookie(csrfCookieName)); //No I18N
	var resp = getPlainResponse("/rest/user/password/verify", params); //No I18N
	var obj = JSON.parse(resp);
	if(obj.cause =="ip_locked"){
		checkPwdVal(obj.localized_message);
		  document.getElementById("pwd").value="";
	      $('#relogin #pwd').focus();
	}
	else if(obj.status == "success")//No I18N
	{   
		if(post_action)
		{
			window.close();
		}
		else if(call_back!=""	&&	call_back!="null"	&& call_back!=null)
		{
// 			window.opener.parent.is_reauth_required=false;
			window.opener.parent.mandate_reauth=false;
			var args=call_back_args.split(',');//No I18N
			window.opener.parent[call_back](...args);
			window.close();
		}
		else
		{
			window.location.href=obj.serviceurl; 
		}
    }else{  
       checkPwdVal(obj.cause);
       document.getElementById("pwd").value="";
       $('#relogin #pwd').focus();
    } 
	return false;	
}
function goToForgotPassword(){
	var resetPassUrl = '<%=IAMEncoder.encodeJavaScript(resetPassUrl)%>';
	var email = '<%=IAMEncoder.encodeJavaScript(primay_mail)%>';
	var serviceurl='<%=IAMEncoder.encodeJavaScript(serviceurl)%>';
	resetPassUrl = resetPassUrl + "?email="+euc(email) + "&serviceurl="+euc(serviceurl); //No I18N
	window.location.href = resetPassUrl;
}


function logoutFuntion(){
	var serviceurl='<%=IAMEncoder.encodeJavaScript(serviceurl)%>';
	window.location.href = contextpath+"/logout?serviceurl="+euc(serviceurl);
	return false;
}


function checkPwdVal(msg){
	if(!isEmpty(msg)){
		$('#relogin .forms').append('<div class="error_msg">'+msg+'</div>');
		//.css("color", "red").show();//No I18N
	}else{
		$('#relogin .forms').append('<div class="error_msg">'+'<%=Util.getI18NMsg(request, "IAM.ENTER.PASS")%>'+'</div>');
		//.css("color", "#666");//No I18N
	}
	return;
}
function remove_err(){
	
		$(".error_msg").remove();
	
}

function pass_show_hide(){
	if($("#pwd").attr("type")=="password"){
		$("#pwd").attr("type","text");//No I18N
		$(".pass_icon").addClass("pass_hide");
	}	
	else{
		$("#pwd").attr("type","password"); //No I18N
		$(".pass_icon").removeClass("pass_hide");
	}
	
}
$(document).ready(function(){
	$("#pwd").focus();
	setFooterPosition();
})
function samlUser(){
	var servcurl='<%=IAMEncoder.encodeJavaScript(Util.encode(request.getParameter("serviceurl")))%>';
	//saml method must always have relative url as its param to be compatible with cross dcl impl
	var sb = "/samlauthrequest/relogin?serviceurl="+servcurl;	//No I18N
	window.location.href='<%=Util.getIAMURL()%>'+sb; //NO OUTPUTENCODING
	return false;
}
$(window).resize(function(){
	setFooterPosition();
});
function setFooterPosition(){
	var top_value = window.innerHeight-60;	
	if(30+$(".container")[0].offsetTop+$(".container")[0].offsetHeight<top_value){
		$("#footer").css("top",top_value+"px"); // No I18N
	}
	else{
		$("#footer").css("top",30+$(".container")[0].offsetTop+$(".container")[0].offsetHeight+"px"); // No I18N
	}
}

function getCookie(cookieName) 
{
	var nameEQ = cookieName + "=";
	var ca = document.cookie.split(';');
	for(var i=0;i < ca.length;i++) {
		var c = ca[i].trim();
		if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length,c.length);
	}
	return null;
}

function isValid(instr) 
{
    return instr != null && instr != "" && instr != "null";
}


function createandSubmitOpenIDForm(idpProvider) 
{
	if(idpProvider != null) 
	{
		var oldForm = document.getElementById(idpProvider + "form");
		if(oldForm) 
		{
			document.documentElement.removeChild(oldForm);
		}
		var form = document.createElement("form");
		var action = encodeURI("/accounts/sl/relogin/fs?provider="+idpProvider.toUpperCase()); //No I18N
		var hiddenField = document.createElement("input");
   	    hiddenField.setAttribute("type", "hidden");
   	    hiddenField.setAttribute("name", "<%=SecurityUtil.getCSRFParamName(request)%>");//NO OUTPUTENCODING
        hiddenField.setAttribute("value", getCookie("<%=SecurityUtil.getCSRFCookieName(request)%>")); //NO OUTPUTENCODING
        form.appendChild(hiddenField);
		form.setAttribute("id", idpProvider + "form");
		form.setAttribute("method", "POST");
	    form.setAttribute("action", action);
	    form.setAttribute("target", "_parent");
	    var openIDProviders = 
	    {
       		commonparams : 
       		{
       			servicename : '<%=IAMEncoder.encodeJavaScript(request.getParameter("servicename"))%>',
    			serviceurl : '<%=IAMEncoder.encodeJavaScript(request.getParameter("serviceurl"))%>'
       		}
       	};
		if(isValid(idpProvider)) 
		{
    	    var params = openIDProviders.commonparams;
    	   	for(var key in params) 
    	   	{
    	   		if(isValid(params[key])) 
    	   		{
    	   			var hiddenField = document.createElement("input");
    	   			hiddenField.setAttribute("type", "hidden");
    	   			hiddenField.setAttribute("name", key);
    	   			hiddenField.setAttribute("value", params[key]);
    	   			form.appendChild(hiddenField);
    	   		}
    	   	}
    	   	document.documentElement.appendChild(form);
    	  	form.submit();
		}
	}
}

function show_ip_logins()
{	
		$(".invisible").show();
		$("#lineseparator").hide();
		$("#relogin_password").hide();
        $(".fed_text").show();
   		if(de("hide_ipds"))
   		{
   			$("#hide_ipds").removeClass("hide");
   		}
   		$("#showIDPs").hide();
   		$(".fed_div").removeClass("hide");
   		$(".signin_fed_text").addClass("signin_fedtext_bold");
   		$(".signin_container").css("height","auto");//no i18n
   		$(".Linkedin_fed,.Twitter_fed").removeClass("mobilehide");
	
}


function go_backtopassword()
{
		$(".invisible").hide();
		
		$("#lineseparator").show();
   		$("#relogin_password").show();
   		$("#signin_div").show();
   		if(de("hide_ipds"))
   		{
   			$("#hide_ipds").addClass("hide");
   		}
   		$(".fed_div").removeClass("applynormal");
   		$(".yahoo_icon").addClass("yahoodefault");
   		$(".facebook_icon").addClass("facebookdefault");
   		$(".fed_text").hide();
   		$(".signin_fed_text").removeClass("signin_fedtext_bold");
   		$(".Linkedin_fed,.Twitter_fed").addClass("mobilehide");
   		$(".yahoo_fed,.baidu_fed,.Wechat_fed,.Douban_fed,.qq_fed,.slack_fed,.Weibo_fed").addClass("hide");
   		$(".more").show();
}

$(function() 
 {	
	var totalwidth=$("#signin_fed_text").width();
	var ipd_width=$("#all_idps").width();
	
	var google_present=false;
	var count=$(".fed_div").length-1;//minus one for view more
	if($(".google_fed").is(":visible"))
	{
		google_present=true;
	}
	if((count>3	&&	google_present)	||	(!google_present	&&	count>5))
	{
		$("#showIDPs").show();
		var count=5;
		if(google_present)
		{
			count=4;
		}
		for(var i=count;i<$(".fed_div").length;i++)
		{
			$($(".fed_div")[i]).addClass("invisible");
			
		}
	}
	
	
	if(!<%=ispasswordexists%>	&&	<%=	user.getIDP() != com.adventnet.iam.IdentityProvider.ZOHO%>	)
	{
		show_ip_logins();
	}
	if(call_back!=""	&&	call_back!="null")
	{
		$(".announcement_text").html('<%=Util.getI18NMsg(request, "IAM.ERROR.RELOGIN.DESCRIPTION")%>'); 
	}
	else
	{
		$(".announcement_text").remove();
	}

 });
<%if(isAuth){ //registering with wms only when user is web-signed-in
%>
window.onload=function() {
	if(!$('.fed_div').is(":visible") && $('.fed_div').length === 1){
		$('.fed_2show,.line').hide();
	}
	try {
		WmsLite.setNoDomainChange();
		WmsLite.setConfig(64);//64 is value of WMSSessionConfig.CROSS_PRD
		WmsLite.registerZuid('AC',"<%=zuId%>","<%=IAMEncoder.encodeJavaScript(user.getLoginName())%>", true);
	}catch(e){}
}
<%} %>
</script>
<div class="bg"></div>
<div class="container">

<form class="zform"  name="pcform"id="relogin" novalidate="novalidate" method="post">  
       
        <div class="zoho_logo"></div>
        
        
	        <span class="head_text"><%=Util.getI18NMsg(request, "IAM.VERIFY.IDENTITY")%></span>

			<span class="announcement_text"></span>
			
	        <div class="mail_id">
	        	<span class="name"><%=primay_mail %> </span>
	        	<span class="notyoulink"  onclick="return logoutFuntion();"><%=Util.getI18NMsg(request, "IAM.NOT_YOU")%></span></span> 
	        	        
	        </div>
		
		
		<div id="relogin_password">
		<%
		if(ispasswordexists)//todo try another way for saml users with password
		{
		%>
			<div class="forms" id="forms_error" >
				<input class="text_box" type="password"name="current" onkeydown="remove_err();" placeholder="<%=Util.getI18NMsg(request, "IAM.ENTER.PASS")%>" id ="pwd" required="">
				<span class="pass_icon" onclick="pass_show_hide()"></span>
			</div>
			<%
			if(saml != null && saml.getIsSamlEnabled() && !Util.isSAMLExcludedUser(user)) 
			{
			%>
			<span class="bluetext_action" onclick="return samlUser()"><%=Util.getI18NMsg(request, "IAM.SIGNIN.SAML.USER")%></span>
			<%
			}
			%>
			<button class="btn" onclick="return checkpassword(document.pcform)"><%=Util.getI18NMsg(request, "IAM.CONFIRM.PASS")%></button>
		<%
				if (!"true".equals(request.getParameter("hide_fp"))) 
				{
		%>
					<div class="forgotpasslink" onclick="goToForgotPassword();"><%=Util.getI18NMsg(request, "IAM.FORGOT.PASSWORD")%></div>
		<%		}
		}
		if(saml != null && saml.getIsSamlEnabled() && !Util.isSAMLExcludedUser(user) && !ispasswordexists) 
		{
		%>
		<button class="btn" onclick="return samlUser()"><%=Util.getI18NMsg(request, "IAM.SIGNIN.SAML.USER")%></button>
		<%
		}
		%>	
	 		</div>

			
			<%//todo check this section
				OpenId[] openids = CSPersistenceAPIImpl.getOpenIdByZuid(user.getZUID());
				if (openids != null && openids.length > 0) 
				{
					Boolean is_google=false;
					Set<Integer> idpCodes = new HashSet<Integer>();
					for (OpenId openId : openids) 
					{
						if (openId.getIdp() != IdentityProvider.ZOHO.dbValue()) 
						{
							idpCodes.add(openId.getIdp()); //To Get Distinct value
						}
					}
					int idp_size=idpCodes.size();
			%>
					 		
				<div class="line" id="lineseparator"></div>
				<div class="fed_2show">
					<span class="signin_fed_text"><%=Util.getI18NMsg(request, "IAM.NEW.SIGNIN.FEDERATED.VERIFY.TITLE")%></span>
					<div id="all_idps">
			<% 
					int count=0;
					for (Integer idpCode : idpCodes) 
					{
						IdentityProvider provider = IdentityProvider.valueOfInt(idpCode);
						if (provider != null) 
						{
							if (Util.isCommonFSEnabledFor(provider.name().toLowerCase())) 
							{
								if (provider == IdentityProvider.GOOGLE) 
								{
									is_google=true;
			%>
							<span class="fed_div small_box google_icon" onclick="createandSubmitOpenIDForm('google');" title="<%=Util.getI18NMsg(request, "IAM.FEDERATED.SIGNIN.GOOGLE")%>" > 
					            <div class="fed_center_google">
					                <span class="fed_icon"></span>
					                <span class="fed_text_avoid">Google</span> <%-- NO I18N --%>
					            </div>
					        </span>
			<%
								}
								else
								if(provider == IdentityProvider.AZURE)
								{
			%>
							<span class="fed_div small_box MS_icon" onclick="createandSubmitOpenIDForm('azure');" title="<%=Util.getI18NMsg(request, "IAM.FEDERATED.SIGNIN.MICROSOFT")%>">
					            <div class="fed_center">
					                <span class="fed_icon"></span>
					                <span class="fed_text">Microsoft</span> <%-- NO I18N --%>
					            </div>
					        </span>	
			<%	
								}
								if(provider == IdentityProvider.LINKEDIN)
								{
			%>
							 <span class="fed_div small_box linkedin_icon linkedin_fed" onclick="createandSubmitOpenIDForm('linkedin');" title="<%=Util.getI18NMsg(request, "IAM.FEDERATED.SIGNIN.LINKEDIN")%>">
                             	<div class="fed_center">
                               	<span class="fed_icon linked_fed_icon"></span> <%-- NO I18N --%>
                                </div>
                             </span>

			
			<%
								}
								if(provider == IdentityProvider.FACEBOOK)
								{
			%>
							<span class="fed_div small_box fb_icon" onclick="createandSubmitOpenIDForm('facebook');" title="<%=Util.getI18NMsg(request, "IAM.FEDERATED.SIGNIN.FACEBOOK")%>">
						        <div class="fed_center">
                              	<div class="fed_icon fb_fedicon"></div>
                                   <span class="fed_text">Facebook</span> <%-- NO I18N --%>
                                </div>

					        </span>
					        
			<%
								}
								if(provider == IdentityProvider.TWITTER)
								{
			%>
							 <span class="fed_div small_box twitter_icon"  onclick="createandSubmitOpenIDForm('twitter');" title="<%=Util.getI18NMsg(request, "IAM.FEDERATED.SIGNIN.TWITTER")%>">
					            <div class="fed_center">
					                <span class="fed_icon"></span>
					                <span class="fed_text">Twitter</span> <%-- NO I18N --%>
					            </div>
					        </span>
			<%
								}
								if(provider == IdentityProvider.YAHOO)
								{
			%>
							<span class="fed_div small_box yahoo_icon" onclick="createandSubmitOpenIDForm('yahoo');" title="<%=Util.getI18NMsg(request, "IAM.FEDERATED.SIGNIN.YAHOO")%>">
					            <div class="fed_icon yahoo_fedicon"></div>
					        </span>
			<%
								}
								if(provider == IdentityProvider.SLACK)
								{
			%>
							<span class="fed_div small_box slack_icon" onclick="createandSubmitOpenIDForm('slack');" title="<%=Util.getI18NMsg(request, "IAM.FEDERATED.SIGNIN.SLACK")%>">
					            <div class="fed_icon slack_fedicon"></div>
					        </span>
			<%
								}
								if(provider == IdentityProvider.DOUBAN)
								{
			%>
							<span class="fed_div small_box douban_icon" onclick="createandSubmitOpenIDForm('douban');" title="<%=Util.getI18NMsg(request, "IAM.FEDERATED.SIGNIN.DOUBAN")%>">
					            <div class="fed_icon douban_fedicon"></div>
					        </span>
			<%
								}
								if(provider == IdentityProvider.QQ)
								{
			%>
							<span class="fed_div small_box qq_icon" onclick="createandSubmitOpenIDForm('qq');" title="<%=Util.getI18NMsg(request, "IAM.FEDERATED.SIGNIN.QQ")%>">
					            <div class="fed_icon qq_fedicon"></div>
					        </span>
			<%
								}
								if(provider == IdentityProvider.WECHAT)
								{
			%>
							<span class="fed_div small_box wechat_icon" onclick="createandSubmitOpenIDForm('wechat');" title="<%=Util.getI18NMsg(request, "IAM.FEDERATED.SIGNIN.WECHAT")%>">
					            <div class="fed_center">
					                <span class="fed_icon"></span>
					                <span class="fed_text">WeChat</span> <%-- NO I18N --%>
					            </div>
					        </span>
			<%
								}
								if(provider == IdentityProvider.WEIBO)
								{
			%>
							<span class="fed_div small_box weibo_icon" onclick="createandSubmitOpenIDForm('weibo');" title="<%=Util.getI18NMsg(request, "IAM.FEDERATED.SIGNIN.WEIBO")%>">
					            <div class="fed_center">
					                <span class="fed_icon"></span>
					                <span class="fed_text weibo_text">Weibo</span> <%-- NO I18N --%>
					            </div>
					        </span>
			<%
								}
								if(provider == IdentityProvider.BAIDU)
								{
			%>
							<span class="fed_div small_box baidu_icon" onclick="createandSubmitOpenIDForm('baidu');" title="<%=Util.getI18NMsg(request, "IAM.FEDERATED.SIGNIN.BAIDU")%>">
					            <div class="fed_icon baidu_fedicon"></div>
					        </span>
			<%
								}
								if(provider == IdentityProvider.APPLE)
								{
			%>
							        <span class="fed_div small_box apple_normal_icon apple_fed" onclick="createandSubmitOpenIDForm('apple');" title="<%=Util.getI18NMsg(request, "IAM.FEDERATED.SIGNIN.APPLE")%>">
							            <div class="fed_icon apple_normal_large"></div>
							        </span>
			<%
								}
								if(provider == IdentityProvider.INTUIT)
								{
			%>
									<span class="fed_div small_box intuit_icon"  onclick="createandSubmitOpenIDForm('intuit');" title="<%=Util.getI18NMsg(request, "IAM.FEDERATED.SIGNIN.INTUIT")%>">
							            <div class="fed_icon intuit_fedicon"></div>
							        </span>
			<%
								}
								if(provider == IdentityProvider.ADP)
								{
			%>
							         <span class="fed_div small_box adp_icon" onclick="createandSubmitOpenIDForm('adp');" title="<%=Util.getI18NMsg(request, "IAM.FEDERATED.SIGNIN.ADP")%>">
							            <div class="fed_icon adp_fedicon"></div>
							        </span>
			<%
								}
							}
						}
					}
					
			%>
	
					<div class="fed_div more hide" id="showIDPs" onclick="show_ip_logins()"> 
						<span class="morecircle"></span> <span class="morecircle"></span> 
						<span class="morecircle"></span>
					</div>
					
				</div>
			<%
				if(ispasswordexists)
				{
			%>
					<div class="zohosignin hide" id="hide_ipds" onclick="go_backtopassword()"><%=Util.getI18NMsg(request, "IAM.NEW.SIGNIN.WITH.ZOHO")%></div>	<%-- NO I18N --%>
				</div>
			<%
				}
			}
			%>
			
</form>  
</div> 
			<footer id="footer"> <%--No I18N--%>
				<div>
					<span class="footer_spacing _copy">
						<%=Util.getCopyRightYear()%>,
					</span>
					<span class="footer_spacing">
						<a href="<%=Util.getI18NMsg(request,"IAM.ZOHOCORP.LINK")%>" title="<%=Util.getI18NMsg(request,"IAM.ZOHOCORP")%>" target="_blank" ><%=Util.getI18NMsg(request,"IAM.ZOHOCORP")%></a>
					</span>
					<span class="footer_spacing">
						<%=Util.getI18NMsg(request,"IAM.ADVENTNET.ALL.RIGHTS.RESERVED")%>
					</span>
				</div>
			</footer> <%--No I18N--%>
</body>
</html>