<!-- $Id$ -->
<%@page import="com.zoho.accounts.internal.util.AccountsInternalConst.OAuthProvider"%>
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
String email = ActionContext.getContext() != null? (String) ActionContext.getContext().get("EMAIL") : ""; //No I18N
%>
<html>
<head>
<meta name="viewport" content="width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=no" />
<title><%=IAMEncoder.encodeHTML(Util.getI18NMsg(request, "IAM.ZOHO.ACCOUNTS"))%></title>
 <link href="<%=cssurl_st%>/mobilelogin.css" type="text/css" rel="stylesheet" /><%-- NO OUTPUTENCODING --%>
 <script src="<%=jsurl%>/jquery-1.12.2.min.js" type="text/javascript"></script><%-- NO OUTPUTENCODING --%>
 <script src="<%=jsurl%>/common.js" type="text/javascript"></script> <%-- NO OUTPUTENCODING --%>
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
		document.getElementById('msgpanel').className = "msg1";//No i18N
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
		    url: "<%=IAMEncoder.encodeJavaScript(request.getContextPath())%>/oauth/v2/approve/internal", //NO I18N
		    data: "<s:property escapeHtml="false" value="queryParams"/>&" + getcsrfParams()+"&is_ajax=true&cPass=" + euc(paswd),//NO I18N
		    //data: getcsrfParams()+"&is_ajax=true&cPass=" + paswd,//NO I18N
		    dataType  : "json",//NO I18N
		    success: function(data, status, xnr) {
		        if(data.redirect_uri) {
		        	window.location.replace(data.redirect_uri);
		        } else {
		        	showmsg(data.message);
		        }
		    },
		    error: function(data, textStatus, errorThrown){
		    	showmsg('<%=Util.getI18NMsg(request, "IAM.ERROR.GENERAL")%>');
		    }

		});
}
	
	function createandSubmitOpenIDForm(idpProvider) {
    	if(idpProvider != null) {
    		var form = document.createElement("form");
    		var action =  "<%=IAMEncoder.encodeJavaScript(request.getContextPath())%>/oauth/v2/approve/internal?"; //NO I18N
    		var param = "<s:property escapeHtml="false" value="queryParams"/>&" + getcsrfParams()+"&fs_request=true"; //NO I18N
    		action = action  + param;
    		form.setAttribute("id", idpProvider + "form");
    		form.setAttribute("method", "POST");
    	    form.setAttribute("action", action);
    	    form.setAttribute("target", "_parent");
    	    
			if(isValid(idpProvider)) {

				var hiddenField = document.createElement("input");
	            hiddenField.setAttribute("type", "hidden");
	            hiddenField.setAttribute("name", "provider");
	            hiddenField.setAttribute("value", idpProvider);
	            form.appendChild(hiddenField);
	            
        	   	document.documentElement.appendChild(form);
        	  	form.submit();
			}        	    
    	}
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

function isValid(instr) {
    return instr != null && instr != "" && instr != "null";
}

function de(id) {
	return document.getElementById(id);
}

function hideError() {
	document.getElementById('msgpanel').className = "hide";//No i18N
}

function switchSignInOptions() {
	if(de('openidcontainer').style.display !== 'none') {
		if(de('zlogin_container_title')) {
			de('zlogin_container_title').style.display='none';
		}
		if(de('fslogin_container_title')) {
			de('fslogin_container_title').style.display='';
		}
		
		if(de('openidcontainer')) {
			de('openidcontainer').style.display='none';
		}
		
		$('#zlogin_field_container').slideUp(300);
		$('#fslogin_field_container').slideDown(300);
		
		if(de('signuplink')) {
			de('signuplink').style.display='none';
		}
		//clearmsg();
	} else {
		if(de('zlogin_container_title')) {
			de('zlogin_container_title').style.display='';
		}
		if(de('fslogin_container_title')) {
			de('fslogin_container_title').style.display='none';
		}
		
		if(de('openidcontainer')) {
			de('openidcontainer').style.display='';
		}

		$('#zlogin_field_container').slideDown(300);
		$('#fslogin_field_container').slideUp(300);
		
		if(de('signuplink')) {
			de('signuplink').style.display='';
		}
	}
}

function showModeFSOptions(ele) {
	if(de('fs-twitter-icon')){
		$('#fs-twitter-icon').slideDown(150);
	}
	if(de('fs-yahoo-icon')) {
		$('#fs-yahoo-icon').slideDown(150);
	}
	ele.style.display='none';
}
</script>

<style>
body {
background-color: #f7f7f7;
}

.msg1 {
    color: #f62217;
    float: left;
    font-size: 12px;
    padding-bottom: 11px;
    padding-top: 1px;
}
.hide {
    display: none;
}
.forgot_sub {
    font-size: 12px;
    line-height: 16px;
    padding: 5px 10px 23px 16px;
    text-align: left;
}

#fslogin_container_title {
	font-size: 18px;
	margin: 10px 0px;
	color: #666;
}
#fslogin_field_container {
	width: 270px;
	position: relative;
	margin:25px auto 20px;
	text-align:center; 
}
.fs-google-icon {
	background: url("../../../images/Signinusing-Icons.png") no-repeat scroll -5px -187px;
	cursor: pointer;
	display: inline-block;
	height: 46px;
	margin: 6px auto;
	width: 191px;
}
.fs-twitter-icon {
	background: url("../../../images/Signinusing-Icons.png") no-repeat scroll -5px -405px;
	cursor: pointer;
	display: inline-block;
	height: 43px;
	margin: 6px auto;
	width: 191px;
}
.fs-linkedin-icon {
	background: url("../../../images/Signinusing-Icons.png") no-repeat scroll -5px -244px;
	cursor: pointer;
	display: inline-block;
	margin: 6px auto;
	height: 43px;
	width: 191px;
}
.fs-facebook-icon {
	background: url("../../../images/Signinusing-Icons.png") no-repeat scroll -5px -352px;
	cursor: pointer;
	display: inline-block;
	height: 43px;
	margin: 6px auto;
	width: 191px;
}
.fs-azure-icon {
	background: url("../../../images/Signinusing-Icons.png") no-repeat scroll -5px -298px;
	cursor: pointer;
	display: inline-block;
	height: 46px;
	margin: 6px auto;
	width: 191px;
}
.fs-yahoo-icon {
	background: url("../../../images/Signinusing-Icons.png") no-repeat scroll -5px -457px;
	cursor: pointer;
	display: inline-block;
	height: 43px;
	margin: 6px auto;
	width: 191px;
}
</style>
</head>
<body>
	<div style="text-align:center;margin:0px auto 0px;" class="for-mobile">
		<div class="logocolor logoadjust">
			<span class="colorred"></span><span class="colorgreen"></span><span class="colorblue"></span><span class="coloryellow"></span>
		</div>
		<div class="mobilelogo"></div>
		<div id="zlogin_container_title" >
		<div style="font-size: 14px; margin:10px 0px 20px 0px;"><%=Util.getI18NMsg(request, "IAM.USER.EMAIL.ADD.CONFIRM.PASSWORD.PLACEHOLDER")%></div>
	 	<div>
			<div id="password" style="width:80%; margin:0px auto; background-color:#fff;padding-bottom: 20px; padding-top: 10px;">
				<div style="padding:5px 0px 10px 0px;">
					<img src="<s:property escapeHtml="false" value="PHOTO_URL"/>" id="circle" alt="Smiley face" height="100" width="100">
				</div>
				<div class="forgot_sub"><%=Util.getI18NMsg(request,"IAM.TFA.HI.USERNAME", email)%>, </div>
				<span id="msgpanel" class="hide"><%=Util.getI18NMsg(request, "IAM.ERROR.GENERAL")%></span>
				<div class="field_label">
					<input type="password" name="pwd" id="pwd" class="input_forgot passbx" autocorrect="off" autocomplete="off" autocapitalize="off" placeholder="Password" value="" size="30" onkeypress="hideError()">
				</div>
				<div style="margin-top:10px;">
					<div class="desctd"></div>
					<div class="descRtd">
						<span onclick="submitAppriveForm()" class="bluebutton"><%=Util.getI18NMsg(request, "IAM.CONFIRM")%></span> 
					</div>
				</div>
				</div>
				</div>
				</div>
				<div id="fslogin_field_container" style="margin-left:20px;display:none;">
									<div class="label1">
									<%if(!"true".equals(request.getParameter("hidegooglesignin")) && Util.isCommonFSEnabledFor(OAuthProvider.google.name())) {%>
									<div id="fs-google-icon" class="fs-google-icon" onclick="createandSubmitOpenIDForm('google');"></div>
									<%} if(!"true".equals(request.getParameter("hideazure")) && Util.isCommonFSEnabledFor("azure")){ %>
									<div id="fs-azure-icon" class="fs-azure-icon" onclick="createandSubmitOpenIDForm('azure');"></div>
									<%} if (!"true".equals(request.getParameter("hidelinkedin")) && Util.isCommonFSEnabledFor("linkedin")) {%>
									<div id="fs-linkedin-icon" class="fs-linkedin-icon" onclick="createandSubmitOpenIDForm('linkedin');"></div>
									<%} if (!"true".equals(request.getParameter("hidefbconnect")) && Util.isCommonFSEnabledFor(OAuthProvider.facebook.name())) {%>
									<div id="fs-facebook-icon" class="fs-facebook-icon" onclick="createandSubmitOpenIDForm('facebook');"></div>
									<%} if (!"true".equals(request.getParameter("hidetwitter")) && Util.isCommonFSEnabledFor("twitter")) {%>
									<div id="fs-twitter-icon" class="fs-twitter-icon"  onclick="createandSubmitOpenIDForm('twitter');" style="display:none;"></div>
									<%} if(!"true".equals(request.getParameter("hideyahoosignin")) && Util.isCommonFSEnabledFor(OAuthProvider.yahoo.name())) {%>
									<div id="fs-yahoo-icon" class="fs-yahoo-icon" onclick="createandSubmitOpenIDForm('yahoo');" style="display:none;"></div>
									<%} %>
									
									<div class="fs_signin_more_options" onclick="showModeFSOptions(this)"><%=Util.getI18NMsg(request, "IAM.FEDERATED.SIGNIN.MORE.OPTIONS")%></div>
									<div class="ortextfromfs"><%=Util.getI18NMsg(request, "IAM.OR")%></div>
									<div class="fs_signin_options_txt" onclick="switchSignInOptions()"><%=Util.getI18NMsg(request, "IAM.SIGNIN.WITH.ZOHO")%></div>
									</div>
								</div>
								<div class="openidcontainer" id="openidcontainer">
									<div class="ortext" style="margin-bottom: 13px;"><%=Util.getI18NMsg(request, "IAM.OR")%></div>
									<div class="fs_signin_options_txt" onclick="switchSignInOptions()"><%=Util.getI18NMsg(request, "IAM.SIGNIN.WITH.FEDERATED.IDP")%></div>
								</div>
				
			
		
    </div>
</body>
</html>