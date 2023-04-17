<%-- $Id$ --%>
<%@page import="com.zoho.accounts.ajax.AjaxResponse"%>
<%@page import="java.util.regex.Pattern"%>
<%@page import="com.zoho.iam.rest.exception.ICRESTErrorCode"%>
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
<%@ page isErrorPage="true" %>
<%
response.setContentType("text/html;charset=UTF-8"); //No I18N
IAMSecurityException ex =  (IAMSecurityException) request.getAttribute(IAMSecurityException.class.getName());
if(ex != null && ex.getErrorCode() != null) {
    String errorCode = ex.getErrorCode();
   	if(errorCode.equals(IAMErrorCode.Z113.getErrorCode())){
		String serviceUrl  = Util.getBackToURL(request.getParameter("servicename"), request.getParameter("serviceurl"));
		if(!IAMUtil.isTrustedDomain(serviceUrl)) {
			serviceUrl = Util.getRefererURL(request);
		}
		response.sendRedirect(serviceUrl); 
        return;
   	}

   	if(errorCode.equals(IAMErrorCode.Z223.getErrorCode())){
		JSONObject jsonresp = new JSONObject();
		jsonresp.put("response", "error"); // No I18N
		jsonresp.put("code", IAMErrorCode.PP112); //No I18N
		jsonresp.put("cause", "invalid_password_token"); // No I18N
		jsonresp.put("redirect_url", "/account/relogin"); // No I18N
		response.getWriter().print(jsonresp); // NO OUTPUTENCODING
   		return;
   	}
   	
   	if(errorCode.equals(IAMErrorCode.Z114.getErrorCode())){
		JSONObject jsonresp = new JSONObject();
		jsonresp.put("response", "error"); // No I18N
		jsonresp.put("code", IAMErrorCode.PP112); //No I18N
		jsonresp.put("cause", "invalid_password_token"); // No I18N
		jsonresp.put("redirect_url", "/account/relogin"); // No I18N
		jsonresp.put("message", Util.getI18NMsg(request, "IAM.ERROR.RELOGIN.REFRESH")); // No I18N
		response.getWriter().print(jsonresp); // NO OUTPUTENCODING
   		return;
   	}
	ActionRule rule = null;
   	try {
		SecurityRequestWrapper secRequest = SecurityRequestWrapper.getInstance(request);
		rule = secRequest.getURLActionRule();
   	} catch(Exception e) {
   		Logger.getLogger("Error_JSP").log(Level.INFO, "exception in error page", e);//No I18N
   	}
   	if(rule != null) {
   		String rulePath = rule.getPath();

		if (rulePath != null && (rulePath.contains("/api/v1/") || rulePath.contains("/ssokit/v1/"))) {
			ICRESTRepresentation representation = ICRESTManager.getErrorResponse(request);
			if (representation != null) {
				response.setStatus(200);
				ICRESTMetaData metaData = ICRESTManager.getResourceMetaData(request);
				ICRESTManager.writeResponse(request, response, metaData, representation);
				return;
			}
		}

	    if(("/accounts/addpass.ac".equals(rulePath) || Pattern.matches("/cu/[a-zA-Z0-9]+/addpass.ac",rulePath) || ("/accounts/adduser.ac".equals(rulePath))  || ("/accounts/password.ac".equals(rulePath))) && errorCode.equals(IAMSecurityException.BROWSER_COOKIES_DISABLED))
	    {
	    	AjaxResponse ar = new AjaxResponse(AjaxResponse.Type.JSON).setResponse(response);
	    	ar.addError(Util.getI18NMsg(request, "IAM.ERROR.COOKIE.DISABLED")).print();//No I18N
	    	return;
	
	    }
	    
   		if(IAMSecurityException.PATTERN_NOT_MATCHED.equals(errorCode))
   		{
   	   		if("/password".equals(rulePath) && "captcha".equals(ex.getParameterName())) {// forgot password uses old UI so no resource obj
   		    	response.setStatus(HttpServletResponse.SC_OK);
   		    	out.println("invalid_hip"); //No I18N
   		    	return;
   		    }
   			if("/webclient/v1/account/self/user/self/allowedip".equals(rulePath)	&&	"ip_name".equals(ex.getEmbedParameterName())) 
   			{
   				JSONObject jsonresp = new JSONObject();
   	   			jsonresp.put("response", "error"); // No I18N
   	   			jsonresp.put("message", Util.getI18NMsg(request, "IAM.ALLOWEDIP.NAME.NOTVALID")); // No I18N
	   	   		response.getWriter().print(jsonresp); // NO OUTPUTENCODING
	   	   		return;
   		    }
   	   		else if("/webclient/v1/account/self/user/self/groups".equals(rulePath))
   	   		{
   	   			if("grpname".equals(ex.getEmbedParameterName()))
   	   			{
	   	   			JSONObject jsonresp = new JSONObject();
	   	   			jsonresp.put("response", "error"); // No I18N
	   	   			jsonresp.put("message", Util.getI18NMsg(request, "IAM.GROUP.CREATE.ERROR.INVALID.GROUP")); // No I18N
		   	   		response.getWriter().print(jsonresp); // NO OUTPUTENCODING
		   	   		return;
   	   			}
   	   		}
   	   		else if("/webclient/v1/account/self/user/self".equals(rulePath)){
	   	   		JSONObject jsonresp = new JSONObject();
	   			jsonresp.put("response", "error"); // No I18N
	   			if("first_name".equals(ex.getEmbedParameterName())){
	   				jsonresp.put("message",Util.getI18NMsg(request, "IAM.ERROR.FNAME.INVALID.CHARACTERS")); // No I18N
	   			}
				else if("last_name".equals(ex.getEmbedParameterName())){
					jsonresp.put("message",Util.getI18NMsg(request, "IAM.ERROR.LNAME.INVALID.CHARACTERS")); // No I18N
	   			}
	   			else if("display_name".equals(ex.getEmbedParameterName())){
	   				jsonresp.put("message",Util.getI18NMsg(request, "IAM.ERROR.DNAME.INVALID.CHARACTERS")); // No I18N
	   			}
	   			else{
	   				jsonresp.put("message",Util.getI18NMsg(request, "IAM.ERROR.INVALID.INPUT")); // No I18N
	   			}
	   	   		response.getWriter().print(jsonresp); // NO OUTPUTENCODING
	   	   		return;
   	   		}
   	   		else if(("/webclient/v1/account/self/user/self/mfa/mode/otp/${iambase64}".equals(rulePath)	&&	"code".equals(ex.getEmbedParameterName()))	)
   	   		{
   	   			JSONObject jsonresp = new JSONObject();
	   			jsonresp.put("response", "error"); // No I18N
	   			jsonresp.put("message", Util.getI18NMsg(request, "IAM.PHONE.INVALID.BACKUP.CODE")); // No I18N
	   	   		response.getWriter().print(jsonresp); // NO OUTPUTENCODING
	   	   		return;
   	   		}
   	   		else if(("/webclient/v1/account/self/user/self/securityquestion".equals(rulePath)	&&	"secA".equals(ex.getEmbedParameterName()))	)
	   		{
	   			JSONObject jsonresp = new JSONObject();
	   			jsonresp.put("response", "error"); // No I18N
	   			jsonresp.put("cause", "inavlid_answer"); // No I18N
	   			jsonresp.put("message", Util.getI18NMsg(request, "IAM.SECURITY.QUEST.INAVLID_ANSWER")); // No I18N
	   	   		response.getWriter().print(jsonresp); // NO OUTPUTENCODING
   	   		return;
	   		}
		   	else if(	(	"/webclient/v1/account/self/user/self/phone/${oz-phoneno}".equals(rulePath)	||	"/webclient/v1/account/self/user/self/email/${email}".equals(rulePath))		&&	("otp_code".equals(ex.getEmbedParameterName()))	)
			{
				JSONObject jsonresp = new JSONObject();
				jsonresp.put("response", "error"); // No I18N
				jsonresp.put("message", Util.getI18NMsg(request, "IAM.GENERAL.ERROR.INVALID.OTP")); // No I18N
		   		response.getWriter().print(jsonresp); // NO OUTPUTENCODING
	 			return;
			}
   		}
   		if(	IAMSecurityException.INVALID_FILE_EXTENSION.equals(errorCode) &&	"/webclient/v1/account/self/user/self/photo".equals(rulePath)		&&	("photo".equals(ex.getEmbedParameterName()))	)
   		{
   			JSONObject jsonresp = new JSONObject();
			jsonresp.put("response", "error"); // No I18N
			jsonresp.put("message", Util.getI18NMsg(request, "IAM.UPLOAD.PHOTO.INVALID.IMAGE")); // No I18N
	   		response.getWriter().print(jsonresp); // NO OUTPUTENCODING
 			return;
   		}
   		
   		if(errorCode.equals(IAMSecurityException.URL_ROLLING_THROTTLES_LIMIT_EXCEEDED)) {
   			String urlThrottleMessage = null;
   			if("/signin".equals(rulePath)) {
   				urlThrottleMessage = Util.getI18NMsg(request, "IAM.NEW.SIGNIN.URL.THOTTLE.ERROR");// No I18N
   			} else {
   				urlThrottleMessage = Util.getI18NMsg(request, "IAM.NEW.URL.THOTTLE.ERROR");// No I18N
   			}
   			JSONObject jsonresp = new JSONObject();
   			jsonresp.put("response", "error"); // No I18N
   			jsonresp.put("code", IAMErrorCode.Z101); //No I18N
   			jsonresp.put("cause", "throttles_limit_exceeded"); // No I18N
   			jsonresp.put("localized_message", urlThrottleMessage); // No I18N
   			response.getWriter().print(jsonresp); // NO OUTPUTENCODING
   			return;
   	    }

   	}
  request.getRequestDispatcher("/v2/ui/unauth/ui-error.jsp").forward(request, response);//No I18N
}
%>