<%@page import="com.adventnet.iam.xss.IAMEncoder"%>
<%@page import="com.zoho.accounts.internal.OAuthException.OAuthErrorCode"%>
<%@page import="com.opensymphony.xwork2.ActionContext"%>
<%@page import="com.zoho.accounts.internal.OAuthException"%>
<%@page import="com.zoho.accounts.AccountsConfiguration"%>
<%OAuthException oathExp =  ActionContext.getContext().get("oauthExp") != null ? (OAuthException) ActionContext.getContext().get("oauthExp") :  null; //No I18N
 if(oathExp != null ){
	 if(oathExp.getErrorCode() == OAuthErrorCode.invalid_user || oathExp.getErrorCode() == OAuthErrorCode.already_verified){
	 	out.println(IAMEncoder.encodeHTML(oathExp.getErrorCode().name()));
	 }
 } else{
	out.println(com.adventnet.iam.internal.Util.getI18NMsg(request, "IAM.VERIFY.APP.RETRY.ERROR", (String)AccountsConfiguration.SUPPORT_EMAILID.getValue()));
 }
 
 %>