<%@page import="org.json.JSONException"%>
<%@page import="org.json.JSONObject"%>
<%@page import="com.zoho.accounts.internal.util.AccountsInternalConst.OAuthConstants.OAuthClientType"%>
<%@page import="com.zoho.accounts.internal.util.AccountsInternalConst.OAuthClientPropertiesConstants"%>
<%@page import="com.zoho.accounts.internal.oauth2.OAuthScopeDetails"%>
<%@page import="java.util.List"%>
<%@page import="com.zoho.accounts.actions.oauth2.OAuthUserAction"%>
<%@page import="com.adventnet.iam.xss.IAMEncoder"%>
<%@page import="com.zoho.accounts.internal.util.AccountsInternalConst.OAuthConstants"%>
<%@page import="com.adventnet.iam.internal.Util"%>
<%@page import="java.util.logging.Level"%>
<%@page import="com.zoho.accounts.internal.OAuthResponse"%>
<%@page import="com.zoho.accounts.internal.util.AccountsInternalConst.OAuthConstants.OAuthAccessGrantType"%>
<%@page import="com.zoho.accounts.internal.oauth2.OAuth2Util"%>
<%@page import="com.adventnet.iam.IAMUtil"%>
<%@page import="java.util.logging.Logger"%>
<%@page import="com.zoho.resource.ResourceException"%>
<%@page import="com.zoho.accounts.internal.OAuthException"%>
<%@page import="com.zoho.accounts.internal.OAuthParams"%>
<%! public static final Logger LOGGER =  Logger.getLogger("showImplicitTokenRefresh._jsp");%>
<%
OAuthParams params = new OAuthParams(request);
String exception = null;
JSONObject sessiongrant = null;
String bwdcmpty = null;
try{
	params.validateParams();
	try{
	bwdcmpty = Util.oAuthInternalAPI.isImplicitGranted(IAMUtil.getCurrentUser(), IAMUtil.getCurrentTicket(), params.getOAuthClientObject().getClientZid());
	sessiongrant = new JSONObject(bwdcmpty);
	} catch(JSONException e){
		LOGGER.log(Level.SEVERE,"Backward compatibility in use in implicit grant for user: "+IAMUtil.getCurrentUser().getZuid()+" client: "+params.getOAuthClientObject().getClientId());
	}
	if("false".equalsIgnoreCase(bwdcmpty) || (sessiongrant!=null && !sessiongrant.getBoolean("status"))){
		exception = "client_not_granted";//No I18N
	}
} catch(OAuthException e){
	exception = e.getMessage();
} catch(Exception e){
	LOGGER.log(Level.SEVERE,"Exception in implicit grant ",e);
	exception = "general_error";//No I18N
}
if(exception == null){
	try{
		List<OAuthScopeDetails> missedScopes = OAuthUserAction.getMissedScopesForUser(params);
		if(missedScopes == null){
			OAuthResponse oAuthResponse = null;
			if(("true".equalsIgnoreCase(bwdcmpty)) || (sessiongrant!=null && sessiongrant.getBoolean("status"))){
			if(sessiongrant!=null && sessiongrant.has("orgInfo")){
				oAuthResponse = OAuth2Util.generateAccessForClientSideOAuth(params, String.valueOf(IAMUtil.getCurrentUser().getZuid()), IAMUtil.getCurrentUser().getZaid(), OAuth2Util.ACCESS_TOKEN_EXPIRY, sessiongrant.getString("orgInfo").split(","));
			} else {
			oAuthResponse = OAuth2Util.generateAccessForClientSideOAuth(params, String.valueOf(IAMUtil.getCurrentUser().getZuid()), IAMUtil.getCurrentUser().getZaid(), OAuth2Util.ACCESS_TOKEN_EXPIRY);
			}
			}
			if(oAuthResponse.hasError()){
				exception = oAuthResponse.getErrorMessage();
			}else{
				String propValue = OAuth2Util.getClientPropertyValue(params.getOAuthClientObject(), OAuthClientPropertiesConstants.EXPIRES_IN_MILLI_SEC.getOAuthClientProperty());
				oAuthResponse.isExpiresInMilliSeconds(Boolean.parseBoolean(propValue));
				String redirectUrl = oAuthResponse.getTokenRedirectURL(false);
				response.sendRedirect(redirectUrl);
				return;
			}
		} else {
			exception = "prompt_required";//No I18N
		}
	} catch(Exception e){
		LOGGER.log(Level.SEVERE,"Exception in implicit grant ",e);
		exception = "general_error";//No I18N
	}
}
response.sendRedirect(params.getRedirectUri()+"?error="+exception);//No I18N
%>