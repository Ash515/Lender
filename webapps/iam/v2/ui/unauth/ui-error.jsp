<%-- $Id$ --%>
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
<%
	response.setContentType("text/html;charset=UTF-8"); //No I18N
	String errorTitle = null;
	String errorDescryption = null;
	StatusCode code = (StatusCode) request.getAttribute("statuscode") != null ? (StatusCode) request.getAttribute("statuscode") : StatusCode.GENERAL_ERROR;//No I18N
	switch (code) {
	case INVALID_SAML_RESPONSE: {
		errorTitle = Util.getI18NMsg(request, "IAM.SAML.SP.ERROR.INVALID.RESPONSE.TITLE");//No I18N
		errorDescryption = Util.getI18NMsg(request, "IAM.SAML.SP.ERROR.INVALID.RESPONSE.DESC");//No I18N
		break;
	}
	case INVALID_SAML_STATUS_CODE: {
		errorTitle = Util.getI18NMsg(request, "IAM.SAML.SP.ERROR.INVALID.STATUSCODE.TITLE");//No I18N
		errorDescryption = Util.getI18NMsg(request, "IAM.SAML.SP.ERROR.INVALID.STATUSCODE.DESC");//No I18N
		break;
	}
	case SAML_RESPONDER_LOGIN_FAILED: {
		errorTitle = Util.getI18NMsg(request, "IAM.ERRORJSP.ERROR.OCCURED.TITLE");//No I18N
		errorDescryption = Util.getI18NMsg(request, "IAM.SAML.SP.RESPONDER.LOGIN.FAILED.DESC");//No I18N
		break;
	}
	case SAML_REQUESTER_LOGIN_FAILED: {
		errorTitle = Util.getI18NMsg(request, "IAM.ERRORJSP.ERROR.OCCURED.TITLE");//No I18N
		errorDescryption = Util.getI18NMsg(request, "IAM.SAML.SP.REQUESTER.LOGIN.FAILED.DESC");//No I18N
		break;
	}
	case SAML_NOT_CONFIGURED: {
		errorTitle = Util.getI18NMsg(request, "IAM.SAML.ERROR.NOT.CONFIGURED.TITLE");//No I18N
		errorDescryption = Util.getI18NMsg(request, "IAM.SAML.ERROR.NOT.CONFIGURED.DESC");//No I18N
		break;
	}
	case SAML_NOT_ENABLED: {
		errorTitle = Util.getI18NMsg(request, "IAM.SAML.ERROR.DISABLED.TITLE");//No I18N
		errorDescryption = Util.getI18NMsg(request, "IAM.SAML.ERROR.DISABLED.DESC");//No I18N
		break;
	}
	case SAML_SIGNATURE_FAILED: {
		errorTitle = Util.getI18NMsg(request, "IAM.SAML.SP.ERROR.SIGNATURE.FAILED.TITLE");//No I18N
		errorDescryption = Util.getI18NMsg(request, "IAM.SAML.SP.ERROR.SIGNATURE.FAILED.DESC");//No I18N
		break;
	}
	case SAML_CONDITIONS_FAILED: {
		errorTitle = Util.getI18NMsg(request, "IAM.SAML.ERROR.AUTHENTICATION.FAILED.TITLE");//No I18N
		errorDescryption = Util.getI18NMsg(request, "IAM.SAML.ERROR.AUTHENTICATION.FAILED.DESC");//No I18N
		break;
	}
	case INVALID_SAML_DESTINATION_ATTRIBUTE: {
		errorTitle = Util.getI18NMsg(request, "IAM.SAML.ERROR.INCORRECT.DESTINATION.TITLE");//No I18N
		errorDescryption = Util.getI18NMsg(request, "IAM.SAML.ERROR.INCORRECT.DESTINATION.DESC");//No I18N
		break;
	}
	case INVALID_SAML_SUBJECT_CONFIRMATION: {
		errorTitle = Util.getI18NMsg(request, "IAM.SAML.ERROR.INCORRECT.SUBJECT.CONFIRMATION.TITLE");//No I18N
		errorDescryption = Util.getI18NMsg(request, "IAM.SAML.ERROR.INCORRECT.SUBJECT.CONFIRMATION.DESC");//No I18N
		break;
	}
	case INVALID_SAML_EMAILID: {
		String email = String.valueOf(request.getAttribute("email"));
		errorTitle = Util.getI18NMsg(request, "IAM.ERROR.INVALID.EMAIL.TITLE");//No I18N
		errorDescryption = Util.getI18NMsg(request, "IAM.SAML.ERROR.INVALID.EMAIL.DESC", email);//No I18N
		break;
	}
	case SAML_AUTHDOMAIN_MISMATCH: {
		errorTitle = Util.getI18NMsg(request, "IAM.SAML.ERROR.AUTHENTICATION.FAILED.TITLE");//No I18N
		errorDescryption = Util.getI18NMsg(request, "IAM.SAML.ERROR.MISMATCH.AUTHDOMAIN.DESC");//No I18N
		break;
	}
	case SAML_EXCLUDED_USER: {
		errorTitle = Util.getI18NMsg(request, "IAM.SAML.ERROR.EXCLUDED.USER.TITLE");//No I18N
		errorDescryption = Util.getI18NMsg(request, "IAM.SAML.ERROR.EXCLUDED.USER.DESC");//No I18N
		break;
	}
	case SAML_NO_SUCH_USER: {
		Org org = (Org) request.getAttribute("org");
		String adminEmail = org != null ? Util.USERAPI.getUserFromZUID(String.valueOf(org.getOrgContact())).getContactEmail() : "";
		String email = String.valueOf(request.getAttribute("email"));
		errorTitle = Util.getI18NMsg(request, "IAM.SAML.ERROR.USER.NOT.EXIST.TITLE");//No I18N
		errorDescryption = Util.getI18NMsg(request, "IAM.SAML.ERROR.DISABLED.USER.PROVISIONING.DESC", email, adminEmail);//No I18N
		break;
	}
	case SAML_USER_PROVISIONING_FAILED: {
		errorTitle = Util.getI18NMsg(request, "IAM.SAML.ERROR.FAILED.USER.PROVISIONING.TITLE");//No I18N
		errorDescryption = Util.getI18NMsg(request, "IAM.SAML.ERROR.FAILED.USER.PROVISIONING.DESC");//No I18N
		break;
	}
	case SAML_USER_LIMIT_EXCEEDED: {
		Org org = (Org) request.getAttribute("org");
		String adminEmail = org != null ? Util.USERAPI.getUserFromZUID(String.valueOf(org.getOrgContact())).getContactEmail() : "";
		errorTitle = Util.getI18NMsg(request, "IAM.SAML.ERROR.EXCEEDED.USER.LIMIT.TITLE");//No I18N
		errorDescryption = Util.getI18NMsg(request, "IAM.SAML.ERROR.EXCEEDED.USER.LIMIT.DESC", adminEmail);//No I18N
		break;
	}
	case SAML_ORG_DOMAIN_MISMATCH: {
		Org org = (Org) request.getAttribute("org");
		String adminEmail = org != null ? Util.USERAPI.getUserFromZUID(String.valueOf(org.getOrgContact())).getContactEmail() : "";
		errorTitle = Util.getI18NMsg(request, "IAM.SAML.ERROR.UNVERIFIED.ORG.DOMAIN.TITLE");//No I18N
		errorDescryption = Util.getI18NMsg(request, "IAM.SAML.ERROR.UNVERIFIED.ORG.DOMAIN.DESC", adminEmail);//No I18N
		break;
	}
	case SAML_ORG_DOMAIN_NOT_VERIFIED: {
		errorTitle = Util.getI18NMsg(request, "IAM.SAML.ERROR.UNVERIFIED.ORG.DOMAIN.TITLE");//No I18N
		errorDescryption = Util.getI18NMsg(request, "IAM.SAML.ERROR.UNVERIFIED.ORG.DOMAIN.DESC");//No I18N
		break;
	}
	case SAML_PARTNER_ORG_MISMATCH: {
		errorTitle = Util.getI18NMsg(request, "IAM.SAML.ERROR.INVALID.AUTHENTICATION.TITLE");//No I18N
		errorDescryption = Util.getI18NMsg(request, "IAM.SAML.ERROR.INVALID.AUTHENTICATION.DESC");//No I18N
		break;
	}
	case INVALID_SAML_USER: {
		errorTitle = Util.getI18NMsg(request, "IAM.ERRORJSP.ERROR.OCCURED.TITLE");//No I18N
		errorDescryption = Util.getI18NMsg(request, "IAM.SAML.ERROR.INVALID.USER.DESC");//No I18N
		break;
	}
	case SAML_GENERAL_ERROR: {
		errorTitle = Util.getI18NMsg(request, "IAM.ERRORJSP.ERROR.OCCURED.TITLE");//No I18N
		errorDescryption = Util.getI18NMsg(request, "IAM.SAML.ERROR.GENERAL.DESC");//No I18N
		break;
	}
	case SAML_NO_SUCH_ORG: {
		errorTitle = Util.getI18NMsg(request, "IAM.ORG.ERROR.NOT.EXIST.TITLE");//No I18N
		errorDescryption = Util.getI18NMsg(request, "IAM.ORG.ERROR.NOT.EXIST.DESC");//No I18N
		break;
	}
	case INVALID_SAML_LOGOUT_REQUEST: {
		errorTitle = Util.getI18NMsg(request, "IAM.SAML.ERROR.SIGNOUT.TITLE");//No I18N
		errorDescryption = Util.getI18NMsg(request, "IAM.SAML.IDP.ERROR.SIGNOUT.DESC");//No I18N
		break;
	}
	case USER_NOT_ACTIVE: {
		errorTitle = Util.getI18NMsg(request, "IAM.ERRORJSP.ERROR.OCCURED.TITLE");//No I18N
		errorDescryption = Util.getI18NMsg(request, "IAM.SIGNIN.ERROR.USER.NOT.ACTIVE");//No I18N
		break;
	}
	case USER_NOT_ACTIVE_IN_SERVICE: {
		errorTitle = Util.getI18NMsg(request, "IAM.ERRORJSP.ERROR.OCCURED.TITLE");//No I18N
		errorDescryption = Util.getI18NMsg(request, "IAM.SIGNIN.ERROR.USER.NOT.ACTIVE.IN.SERVICE");//No I18N
		break;
	}
	case DAILY_SIGNIN_LIMIT_REACHED: {
		errorTitle = Util.getI18NMsg(request, "IAM.ERRORJSP.ERROR.OCCURED.TITLE");//No I18N
		errorDescryption = Util.getI18NMsg(request, "IAM.SIGNIN.ERROR.USER.DAILY.SIGNIN.LIMIT.EXCEEDED",AccountsConfiguration.getConfiguration("iam.login.limit.learnwhy.link", "https://help.zoho.com/portal/en/kb/accounts/troubleshooting/sign-in/articles/troubleshoot-sign-in-related-issues#What_is_a_daily_sign-in_limit"));//No I18N
		break;
	}
	case UNAUTHORIZED_ORG_NETWORK_ACCESS: {
		errorTitle = Util.getI18NMsg(request, "IAM.ERRORJSP.ERROR.OCCURED.TITLE");//No I18N
		errorDescryption = Util.getI18NMsg(request, "IAM.SIGNIN.ERROR.ORG.NETWORK.BLOCKED");//No I18N
		break;
	}
	case RESTRICT_SIGNIN_ENABLED: {
		errorTitle = Util.getI18NMsg(request, "IAM.ERRORJSP.ERROR.OCCURED.TITLE");//No I18N
		errorDescryption = Util.getI18NMsg(request, "IAM.SIGNIN.ERROR.RESTRICT.SIGNIN.ENABLED");//No I18N
		break;
	}
	case USER_NOT_ALLOWED_IP: {
		errorTitle = Util.getI18NMsg(request, "IAM.ERRORJSP.ERROR.OCCURED.TITLE");//No I18N
		errorDescryption = Util.getI18NMsg(request, "IAM.SIGNIN.ERROR.USER.NOT.ALLOWED.IP");//No I18N
		break;
	}
	case GENERAL_ERROR: {
		errorTitle = Util.getI18NMsg(request, "IAM.ERRORJSP.ERROR.OCCURED.TITLE");//No I18N
		errorDescryption = Util.getI18NMsg(request, "IAM.ERROR.GENERAL.REQUEST.PROCESSING");//No I18N
		break;
	}
	default: {
		errorTitle = Util.getI18NMsg(request, "IAM.ERRORJSP.ERROR.OCCURED.TITLE");//No I18N
		errorDescryption = code.getMessage();
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

<body>
	<div class="container">
		<div class="zoho_logo"></div>
		<div class="error_img raodblock"></div>
		<div class="heading"><%=errorTitle%></div>
		<div class="discrption"><%=errorDescryption%>
		</div>
	</div>
</body>
</html>