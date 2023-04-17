<!-- $Id$ -->
<%@page import="com.zoho.accounts.AccountsConstants"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="com.adventnet.iam.PhotoAPI"%>
<%@page import="com.adventnet.iam.IAMUtil"%>
<%@page import="com.adventnet.iam.IAMProxy"%>
<%@page import="com.opensymphony.xwork2.ActionContext"%>
<%@page import="com.adventnet.iam.internal.Util"%>
<%@page import="com.zoho.accounts.AccountsConfiguration"%>
<%@page import="com.zoho.accounts.internal.util.AccountsInternalConst"%>
<%@page import="com.adventnet.iam.security.SecurityUtil"%>
<%@page import="com.adventnet.iam.xss.IAMEncoder"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<%
boolean isStatic = "true".equals(AccountsConfiguration.getConfiguration("iam.static", "false"));
String cPath = request.getContextPath();
String cssurl_st = isStatic ? Util.getCSSURL(request) : cPath+"/static";//No I18N
String jsurl = isStatic ? Util.getJSURL(request) : cPath+"/static";//No I18N
String email = IAMUtil.getCurrentUser().getPrimaryEmail();
String serviceUrl=request.getParameter("serviceurl");
serviceUrl=Util.getRedirectURLWithTrustedDomainCheck(IAMUtil.getCurrentUser().getZUID(), request,request.getParameter("servicename"), serviceUrl);
%>
<html>
<head>
<meta name="viewport"content="width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=no" />
<title><%=IAMEncoder.encodeHTML(Util.getI18NMsg(request, "IAM.ZOHO.ACCOUNTS"))%></title>
 <link href="<%=cssurl_st%>/mobile-app-screen.css" type="text/css" rel="stylesheet" /><%-- NO OUTPUTENCODING --%>
<script src="<%=jsurl%>/jquery-1.12.2.min.js" type="text/javascript"></script><%-- NO OUTPUTENCODING --%>
<script>

function getcsrfParams() {
	var csrfParam = "<%=SecurityUtil.getCSRFParamName(request)%>"; //NO OUTPUTENCODING
	var csrfCookieName = "<%=SecurityUtil.getCSRFCookieName(request)%>"; //NO OUTPUTENCODING
		var params = csrfParam + "=" + getCookie(csrfCookieName);
		return params;

	}

	function showError(data) {
		alert("error Occred"); //NO I18N
	}
	
	function showmsg(msg) {
		$('#msgpanel').fadeIn('slow');//No i18N
		document.getElementById('msgpanel').innerHTML = msg;
	}

	function submitAppriveForm() {
		var paswd = document.getElementById("pwd").value.trim();
		if (paswd == "") {
			$("#lid").removeClass('error-border');
			$("#pwd").addClass('error-border');
			showmsg('<%=Util.getI18NMsg(request, "IAM.ERROR.ENTER.LOGINPASS")%>');
			document.getElementById("pwd").focus();
        	return false;
    	}
	$.ajax({
		
		type: "POST",//NO I18N
		    url: "<%=IAMEncoder.encodeJavaScript(request.getContextPath())%>/oauth/v2/token/relogin", //NO I18N
		    data: getcsrfParams()+"&cPass=" + paswd,//NO I18N
		    //data: getcsrfParams()+"&is_ajax=true&cPass=" + paswd,//NO I18N
		    dataType  : "json",//NO I18N
		    success: function(data, status, xnr) {
		        if(data.message == "SUCESS") { //NO I18N
		        	window.location.replace('<%=IAMEncoder.encodeJavaScript(serviceUrl)%>');
		        } else {
		        	showmsg(data.message);
		        }
		    },
		    error: function(data, textStatus, errorThrown){
		    	showmsg('<%=Util.getI18NMsg(request, "IAM.ERROR.GENERAL")%>');
		    }

		});
}

function getCookie(cookieName) {
    var nameEQ = cookieName + "=";
    var ca = document.cookie.split(';');
    for(var i=0;i < ca.length;i++) {
        var c = ca[i].trim();
        if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length,c.length);
    }
    return null;
}

function hideError() {
	document.getElementById('msgpanel').className = "hide";//No i18N
}

function logoutandRelogin() {
	window.location.replace('/logout?serviceurl=<%=IAMEncoder.encodeJavaScript(URLEncoder.encode(serviceUrl, AccountsConstants.CharacterEncoding.UTF_8.getValue())) %>');
}

$(".primary_btn").click(function(){
	$(".form_error").slideDown(300);
});

</script>

</head>
<body>



<div class="container">
			<div class="zlogo"></div>
			<div class="profile_picture"> <img src="<%=IAMProxy.getPhotoServerURL(true)%>/file" > </div>  <%-- NO OUTPUTENCODING --%>
			<div class="invite_user"><%=Util.getI18NMsg(request,"IAM.TFA.HI.USERNAME", email)%> !</div>

			<div class="form">
				<input type="password" name="pwd" id ="pwd" required="" >
				<label><%=Util.getI18NMsg(request, "IAM.USER.EMAIL.ADD.PASSWORD.PLACEHOLDER")%></label>
			</div>
			
			<div class="form_error" id="msgpanel" ><%=Util.getI18NMsg(request, "IAM.ERROR.GENERAL")%></div>
			
			<button class="primary_btn" onclick="submitAppriveForm()"><%=Util.getI18NMsg(request, "IAM.CONFIRM")%></button>
			
			<div class="link" onclick="logoutandRelogin()"><%=Util.getI18NMsg(request, "IAM.GENERAL.LOGIN.DIFFERENT.ACCOUNT")%></div>
		</div>
</body>
</html>