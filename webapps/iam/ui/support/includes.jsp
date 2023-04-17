<%@page import="com.zoho.accounts.AccountsConfiguration"%>
<%@ page import="java.util.*"%>
<%@ page import="com.adventnet.zoho.*,com.adventnet.iam.*,com.adventnet.iam.internal.Util,java.util.regex.Pattern,com.adventnet.iam.xss.IAMEncoder,com.zoho.iam2.rest.CSPersistenceAPIImpl"%>

<%
if((!request.isUserInRole("IAMAdmininistrator")) && (!request.isUserInRole("IAMSupportAdmin"))) {
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

%>