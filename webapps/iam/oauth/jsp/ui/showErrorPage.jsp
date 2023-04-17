<%-- // $Id: $ --%>
<%@page import="com.zoho.accounts.actions.oauth2.OAuthUserAction"%>
<%@page import="com.adventnet.iam.xss.IAMEncoder"%>
<%@page import="com.opensymphony.xwork2.ActionContext"%>
<%@page import="com.zoho.accounts.internal.OAuthException.OAuthErrorCode"%>
<%@page import="com.zoho.accounts.internal.OAuthException"%>
<%@page import="com.zoho.accounts.webclient.util.WebClientUtil"%>
<%@page import="com.zoho.accounts.AccountsConfiguration"%>
<%@page import="com.adventnet.iam.Org"%>
<%@page import="com.zoho.accounts.internal.IAMStatusCode.StatusCode"%>
<%@page import="com.adventnet.iam.IAMException.IAMErrorCode"%>
<%@page import="com.zoho.iam.rest.metadata.ICRESTMetaData"%>
<%@page import="com.adventnet.iam.security.SecurityRequestWrapper"%>
<%@page import="com.adventnet.iam.security.ActionRule"%>
<%@page import="org.json.JSONObject"%>
<%@page import="com.adventnet.iam.internal.Util"%>
<%@page import="com.adventnet.iam.IAMUtil"%>
<%@page import="com.adventnet.iam.security.IAMSecurityException"%>
<%@page import="com.zoho.iam.rest.ICRESTManager"%>
<%@page import="com.zoho.iam.rest.representation.ICRESTRepresentation"%>
<%@page import="java.util.logging.Level"%>
<%@page import="java.util.logging.Logger"%>
<%@ page isErrorPage="true"%>
<%!
static final Logger LOGGER = Logger.getLogger("oauthErrorPage_jsp");//No I18N
%>
<%
	response.setContentType("text/html;charset=UTF-8"); //No I18N
	String errorTitle = null;
	String errorDescryption = null;
	OAuthException oathExp =  ActionContext.getContext().get("OAuthException") != null ? (OAuthException) ActionContext.getContext().get("OAuthException") :  new OAuthException(OAuthErrorCode.invalid_client); //No I18N
	boolean isMobile = ActionContext.getContext().get("isMobile") != null ? (Boolean) ActionContext.getContext().get("isMobile") : false; //No I18N
	//Log out the user on exception as well.
	OAuthUserAction.forceLogoutUser(request, response, isMobile);
	switch (oathExp.getErrorCode()) {
	case invalid_client: {
		errorTitle = Util.getI18NMsg(request, "IAM.OAUTH.INVALID.CLIENT");//No I18N
		errorDescryption = Util.getI18NMsg(request, "IAM.OAUTH.INVALID.CLIENT.DESC", AccountsConfiguration.getConfiguration("api.console.url", "https://api-console.zoho.com"));//No I18N
		break;
	}
	case invalid_response_type: {
		errorTitle = Util.getI18NMsg(request, "IAM.OAUTH.INVALID.RESPONSE.TYPE");//No I18N
		errorDescryption = Util.getI18NMsg(request, "IAM.OAUTH.INVALID.RESPONSE.TYPE.DESC");//No I18N
		break;
	}
	case access_denied: {
		errorTitle = Util.getI18NMsg(request, "IAM.OAUTH.ACCESS.DENIED");//No I18N
		errorDescryption = Util.getI18NMsg(request, "IAM.OAUTH.ACCESS.DENIED.DESC");//No I18N
		break;
	}
	case invalid_timestamp: {
		errorTitle = Util.getI18NMsg(request, "IAM.OAUTH.INVALID.TIME.STAMP");//No I18N
		errorDescryption = Util.getI18NMsg(request, "IAM.OAUTH.INVALID.TIME.STAMP.DESC");//No I18N
		break;
	}
	case invalid_operation_type: {
		errorTitle = Util.getI18NMsg(request, "IAM.OAUTH.INVALID.OPERATION.TYPE");//No I18N
		errorDescryption = Util.getI18NMsg(request, "IAM.OAUTH.INVALID.OPERATION.TYPE.DESC");//No I18N
		break;
	}
	case invalid_redirect_uri:{
		errorTitle = Util.getI18NMsg(request, "IAM.OAUTH.INVALID.REDIRECT.URI");//No I18N
		errorDescryption = Util.getI18NMsg(request, "IAM.OAUTH.INVALID.REDIRECT.URI.DESC");//No I18N
		break;
	}
	case invalid_scope:{
		errorTitle = Util.getI18NMsg(request, "IAM.OAUTH.INVALID.SCOPE");//No I18N
		errorDescryption = Util.getI18NMsg(request, "IAM.OAUTH.INVALID.SCOPE.DESC");//No I18N
		break;
	}
	case inactive_client:{
		errorTitle = Util.getI18NMsg(request, "IAM.OAUTH.INACTIVE.CLIENT");//No I18N
		errorDescryption = Util.getI18NMsg(request, "IAM.OAUTH.INACTIVE.CLIENT.DESC");//No I18N
		break;
	}
	case restricted_client:{
		errorTitle = Util.getI18NMsg(request, "IAM.OAUTH.RESTRICTED.CLIENT");//No I18N
		errorDescryption = Util.getI18NMsg(request, "IAM.OAUTH.RESTRICTED.CLIENT.DESC");//No I18N
		break;
	}
	case restricted_scope:{
		errorTitle = Util.getI18NMsg(request, "IAM.OAUTH.RESTRICTED.SCOPE");//No I18N
		errorDescryption = Util.getI18NMsg(request, "IAM.OAUTH.RESTRICTED.SCOPE.DESC");//No I18N
		break;
	}
	case unauthorized_device:{
		errorTitle = Util.getI18NMsg(request, "IAM.OAUTH.UNAUTORIZED.DEVICE");//No I18N
		errorDescryption = Util.getI18NMsg(request, "IAM.OAUTH.UNAUTORIZED.DEVICE.DESC");//No I18N
		break;
	}
	default: {
		LOGGER.log(Level.INFO, "Exception unhandled {0}", oathExp.getErrorCode());
		errorTitle = Util.getI18NMsg(request, "IAM.OAUTH.GENERAL.ERROR");//No I18N
		errorDescryption = Util.getI18NMsg(request, "IAM.OAUTH.GENERAL.ERROR.DESC");//No I18N
		break;
	}
	}
%>
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link
	href="https://fonts.googleapis.com/css?family=Open+Sans:400,600,700"
	rel="stylesheet">
<%
	boolean isStatic = "true".equals(AccountsConfiguration.getConfiguration("iam.static.newui", "false"));
	String imgurl = isStatic ? WebClientUtil.getIMGURL(request) : request.getContextPath() + "/v2/components/images"; //No I18N
%>
</head>
<style>
body {
	width: 100%;
	font-family: 'Open Sans', sans-serif;
	margin: 0;
}

.container {
	display: block;
	width: 70%;
	margin: auto;
	margin-top: 120px;
}

.zoho_logo {
	display: block;
	margin: auto;
	height: 34px;
	width: 100px;
	background: url("<%=imgurl%>/zoho.png") no-repeat transparent;
	background-size: auto 100%;
	margin-bottom: 40px;
}

.error_img {
	display: block;
	height: 300px;
	margin-bottom: 40px;
	width: 100%;
}

.raodblock {
	background: url(<%=imgurl%>/roadblock.png) no-repeat transparent;
	background-size: auto 100%;
	background-position: center;
}

.heading {
	display: block;
	text-align: center;
	font-size: 24px;
	margin-bottom: 10px;
	line-height: 34px;
	font-weight: 600;
}

.discrption {
	display: block;
	width: 500px;
	margin: auto;
	text-align: center;
	font-size: 16px;
	margin-bottom: 10px;
	line-height: 24px;
	color: #444;
}

.faqURL{
    text-align: center;
}
.question_icon
{
    width: 16px;
    height: 16px;
    border: 1px solid #0091FF;
    border-radius: 50%;
    line-height: 14px;
    color: #0091FF;
    box-sizing: border-box;
    font-size: 10px;
    margin-right: 5px;
    display: inline-block;
    float: left;
}

.question_button{
    font-weight: 400;
    color: #0091FF;
    border: 1px solid #0091FF;
    box-sizing: border-box;
    padding: 7px 8px;
    font-size: 14px;
    display:inline-block;
    height: 32px;
    border-radius: 16px;
    line-height: 16px;
    cursor: pointer;
    background: #F0F8FF;
 }

@media only screen and (-webkit-min-device-pixel-ratio: 2) , only screen and (
		min--moz-device-pixel-ratio: 2) , only screen and (
		-o-min-device-pixel-ratio: 2/1) , only screen and (
		min-device-pixel-ratio: 2) , only screen and ( min-resolution: 192dpi)
		, only screen and ( min-resolution: 2dppx) {
	.raodblock {
		background: url(<%=imgurl%>/roadblock@2x.png) no-repeat transparent;
		background-size: auto 100%;
		background-position: center;
	}
}

@media only screen and (max-width: 420px) {
	.container {
		width: 90%;
		margin-top: 50px;
	}
	.discrption {
		width: 100%;
	}
	.error_img {
		display: block;
		max-width: 340px;
		background-size: 100% auto;
		margin: auto;
		margin-bottom: 40px;
	}
	.heading {
		display: block;
		text-align: center;
		font-size: 20px;
		margin-bottom: 10px;
		line-height: 30px;
		font-weight: 600;
	}
	.discrption {
		display: block;
		margin: auto;
		text-align: center;
		font-size: 14px;
		margin-bottom: 10px;
		line-height: 24px;
		color: #444;
	}
}
</style>
<script>
function redirectTo(url){
	window.open(url,"_blank");
}
</script>
<body>
	<div class="container">
		<div class="zoho_logo"></div>
		<div class="error_img raodblock"></div>
		<div class="heading" id="errorTitle"><%=errorTitle%></div>
		<div class="discrption" id="errorDescription"><%=errorDescryption%></div>
		<%String faqUrl = AccountsConfiguration.getConfiguration("oauth.faq.page.url", null); 
		if(faqUrl != null){
			%>
			<div class="faqURL">
				<span class="question_button" onclick='redirectTo("<%=faqUrl+"#"+oathExp.getErrorCode()%>")'><span class="question_icon">?</span><%=Util.getI18NMsg(request, "IAM.TFA.LEARN.MORE") %></span>
			</div>
			<% 
		}
		%>
	</div>
</body>
</html>