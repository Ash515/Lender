<%-- $Id$ --%>
<%@page import="com.zoho.accounts.internal.util.AccountsInternalConst"%>
<%@page import="com.zoho.accounts.AccountsConfiguration"%>
<%@ page import="java.util.*"%>
<%@ page import="com.adventnet.zoho.*,com.adventnet.iam.*,com.adventnet.iam.internal.Util,java.util.regex.Pattern,com.adventnet.iam.xss.IAMEncoder,com.zoho.iam2.rest.CSPersistenceAPIImpl"%>
<%
if((!request.isUserInRole("IAMAdmininistrator")) && (!request.isUserInRole("IAMUser")) && (!request.isUserInRole("MarketingAdmin")) && (!request.isUserInRole("IAMOperator")) && (!request.isUserInRole("SupportAdmin")) && (!request.isUserInRole(Role.IAM_SERVICE_ADMIN)) && (!request.isUserInRole("LegalAdmin")) && (!request.isUserInRole("SDAdmin") && (!request.isUserInRole("OAuthAdmin")) && (!request.isUserInRole("IAMSupportAdmin")) && (!request.isUserInRole("IAMCacheAdmin")) && (!request.isUserInRole("IAMSystemAdmin")) && (!request.isUserInRole("IAMTemplateAdmin")))) {
    response.sendError(401, "Permission Denied");
    return;
}

String ipaddress = request.getRemoteAddr();
Pattern adminip = Pattern.compile(AccountsConfiguration.getConfiguration("admin.ip", ".*"));	//No I18N
if(!adminip.matcher(ipaddress).matches()){
 response.sendError(401, "Permission Denied");
 return;
}

String conPath = request.getContextPath();
if(!request.isUserInRole("IAMAdmininistrator")) {
    String uri = request.getRequestURI();
    boolean isAllowedIAMUser = false;
    
    isAllowedIAMUser = AccountsInternalConst.SystemRolesVsURL.validateRole(request, uri);
	
    if(!isAllowedIAMUser) {
    	response.sendError(401, "Permission Denied");
    	return;
    } 
}

User user = IAMUtil.getCurrentUser();
ArrayList<Service> ss = Util.SERVICEAPI.getAllServicesByOrder();
String iamservie = Util.getIAMServiceName();
%>
