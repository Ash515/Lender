<%-- $Id$ --%>
<%@ page import="java.sql.Timestamp"%>
<%@ include file="includes.jsp" %>
<%@ include file="../../static/includes.jspf" %>
<%
    long zuid = IAMUtil.getLong(request.getParameter("zuid"));
    String operation = request.getParameter("operation");
    String action = request.getParameter("action");
    int start = Integer.parseInt(request.getParameter("start"));
    int limit = 100;
	
    List<Map> accessAudit = "I".equals(operation) ? CSPersistenceAPIImpl.getAccessAudit(zuid, start, limit)  : CSPersistenceAPIImpl.getAccessAudit(zuid, operation, start, limit);	//No I18n
	
    int size = 0;
    if(accessAudit !=null && !accessAudit.isEmpty()){
	size =  accessAudit.size();
    }
%>
<table width="98%" style="font-size:11px;margin:10px auto 0px;">
    <tr>
	<td valign="top">
<%if("I".equals(operation)) {%>
    <span style="margin-right:5px;">SignIn</span> <%--No I18N--%>
<%} else {%>
    <a href="javascript:;" style="margin-right:5px;" onclick="showlogindetails('<%=zuid%>','I','SignIn',0)">SignIn</a> <%--No I18N--%>
<%} %>
    <span>|</span>
<%if("O".equals(operation)) {%>
    <span style="margin-right:5px;">SignOut</span> <%--No I18N--%>
<%} else {%>
    <a href="javascript:;" style="margin-right:5px;" onclick="showlogindetails('<%=zuid%>','O','SignOut',0)">SignOut</a> <%--No I18N--%>
<%} %>
    <span>|</span>
<%if("V".equals(operation)) {%>
    <span>Validate</span> <%--No I18N--%>
<%} else {%>
    <a href="javascript:;" onclick="showlogindetails('<%=zuid%>','V','Validate',0)">Validate</a> <%--No I18N--%>
<%}%>
	</td>
	<td valign="top" style="font-weight:bold;color:#8b0000;"><%=IAMEncoder.encodeHTML(Util.USERAPI.getUser(zuid).getLoginName()+"'s "+action+" Details")%></td>
	<td valign="top" align="right">
	    <%if(start == 0) {%><a href="javascript:;" style="color:#c3c3c3;" class="disabletxt"><%} else {%>
	    <a href="javascript:;" onclick="search_more('<%=zuid%>','<%=IAMEncoder.encodeJavaScript(operation)%>','<%=IAMEncoder.encodeJavaScript(action)%>','previous')"><%}%>Previous</a>
	    <span><%=start+"-"+(start+size)%></span>
	    <%if((size%limit) != 0 || size==0) {%><a href="javascript:;" style="color:#c3c3c3;" class="disabletxt"><%} else {%>
	    <a href="javascript:;" onclick="search_more('<%=zuid%>','<%=IAMEncoder.encodeJavaScript(operation)%>','<%=IAMEncoder.encodeJavaScript(action)%>','next')"><%}%>Next</a>
	    <input type="hidden" id="hide_next" value="<%=start+size%>"/>
	    <input type="hidden" id="hide_prev" value="<%=start%>"/>
	</td>
    </tr>
</table>

<%if(accessAudit !=null && ! accessAudit.isEmpty()) {%>
<table class="usremailtbl" cellpadding="4" style="margin-top:0px;">
    <tr>
	<td class="usrinfoheader">Service Name</td> <%--No I18N--%>
	<td class="usrinfoheader">Ip Address</td> <%--No I18N--%>
	<td class="usrinfoheader">Created Time</td> <%--No I18N--%>
	<%if("I".equals(operation)) {%><td class="usrinfoheader">Login IDP</td><%}%>
	<td class="usrinfoheader">Referrer</td> <%--No I18N--%>
    </tr>
<%
	ServiceAPI sapi = Util.SERVICEAPI;
	for(Map map : accessAudit) {
	    Timestamp time = new Timestamp(IAMUtil.getLong(map.get("TIMESTAMP").toString()));
	    String serviceName = sapi.getService(Integer.parseInt(map.get("SERVICE_ID").toString())).getServiceName();
%>
    <tr>
	<td class="usremailtd"><%=serviceName%></td> <%-- NO OUTPUTENCODING --%>
	<td class="usremailtd"><%=IAMEncoder.encodeHTML((String)map.get("IP_ADDRESS"))%></td>
	<td class="usremailtd"><%=time%></td> <%-- NO OUTPUTENCODING --%>
<%
	    if("I".equals(operation)) {
                String loginidp = "G".equals(map.get("OPERATION")) ? "GOOGLE" : "Y".equals(map.get("OPERATION")) ? "YAHOO" : "A".equals(map.get("OPERATION")) ? "AOL" : "L".equals(map.get("OPERATION")) ? "LIVE" : "F".equals(map.get("OPERATION")) ? "FACEBOOK" : "S".equals(map.get("OPERATION")) ? "SAML" :"I".equals(map.get("OPERATION")) ? "ZOHO": (String)(map.get("OPERATION")); //No I18N
%>
	<td class="usremailtd"><%=loginidp%></td> <%-- NO OUTPUTENCODING --%>
	    <%}%>
	<td class="usremailtd"><%=IAMEncoder.encodeHTML((String)map.get("REFERRER"))%></td>
    </tr>
	<%}%>
</table>
<%
    }
    else {
%>
<div class="nosuchusr">
    <p align="center"><%="O".equals(operation) ? "Logout" : "V".equals(operation) ? "Validate" : "Loging"%> history is not availbale for this user.</p> <%--No I18N--%>
</div>
    <%}%>
