<%-- // $Id: $ --%>
<%@page import="com.adventnet.iam.xss.IAMEncoder"%>
<%@page import="com.opensymphony.xwork2.ActionContext"%>
<%@page import="com.zoho.accounts.internal.OAuthException.OAuthErrorCode"%>
<%@page import="com.zoho.accounts.internal.OAuthException"%>
<%
OAuthException oathExp =  ActionContext.getContext().get("OAuthException") != null ? (OAuthException) ActionContext.getContext().get("OAuthException") :  new OAuthException(OAuthErrorCode.invalid_client); //No I18N
String errorCode = (oathExp != null && oathExp.getErrorCode() != null) ? oathExp.getErrorCode().name() : OAuthErrorCode.general_error.name();
out.println(IAMEncoder.encodeHTML("ERROR_"+errorCode)); //No I18N
%>