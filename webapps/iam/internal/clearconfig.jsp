<%-- $Id$ --%>
<%@page import="com.adventnet.iam.IAMUtil,com.adventnet.iam.Service,com.adventnet.iam.internal.Util"%>
<%@page import="java.util.Collection"%>
<%
    //clear LB related configuration cache in the respective service instance
    //URL pattern ::: http://<servicedomain>/grid/login/URLInvoker?type=url&url_param=clearconfig=<boolean>"
    Collection<Service> ss = Util.SERVICEAPI.getAllServices();
    StringBuffer successURL = new StringBuffer();
    StringBuffer failedURL = new StringBuffer();
    String redisStatus;
    for (Service service : ss) {
    	if(service == null || service.getServiceName().equalsIgnoreCase(Util.getIAMServiceName())) {
    		continue;
    	}
        String invokeUrl = service.getWebUrl() + "/grid/login/URLInvoker?type=url&url_param=clearconfig=true";//No I18N
        String li = "<li>" + invokeUrl + "</li>";
        if(IAMUtil.isURLExist(invokeUrl)) {
            successURL.append(li);
        } else {
            failedURL.append(li);
        }
    }
    long count  =0;
    if((count = Util.notifyViaRedisMessage(null, "clearconfig", true)) >= 0){//No I18N
    	redisStatus = "Broadcast via redis succesfull. Sent Count : "  + count; //No I18N
    }
    else {
    	redisStatus = "Broadcast via redis failed. Count : " + count;//No I18N
    }
    	
    if(successURL.length() > 0 || failedURL.length() > 0) {
%>
<html>
    <head>
        <title><%=Util.getI18NMsg(request,"IAM.ZOHO.ACCOUNTS")%></title><%-- NO OUTPUTENCODING --%>
        <style type="text/css">
            body {
                font-size: 12px;
            }
            div {
                font-weight: bold;
            }
        </style>
    </head>
    <body>
        <% if(successURL.length() > 0) { %>
            <div>Cleared URLs :-</div><%-- No I18N --%>
            <ul><%=successURL%></ul><%-- NO OUTPUTENCODING --%>
        <% } %>
        <% if(failedURL.length() > 0) { %>
            <div>Failed URLs :-</div><%-- No I18N --%>
            <ul><%=failedURL%></ul><%-- NO OUTPUTENCODING --%>
        <% } %>
            <div>Redis Broadcast Status :-</div><%-- No I18N --%>
            <ul><%=redisStatus%></ul><%-- NO OUTPUTENCODING --%>
    </body>
</html>
<%
    }
%>