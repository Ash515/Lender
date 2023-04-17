<%-- $Id$ --%>
<%@ page import="com.adventnet.iam.xss.IAMEncoder" %>
<div part="REPONSE_STATUS" class="hide">
<%= (Boolean.TRUE.equals(request.getAttribute("RESPONSE_STATUS")))? "__SUCCESS__":"__ERROR__"%>
</div>
<%-- Using "part" attribute instead of "id" in order to avoid clashes!! --%>
<% Object respParams = request.getAttribute("RESPONSE_PARAMS");
 if(respParams != null){%>
<div part="RESPONSE_PARAMS" class='hide'>
 {<%out.print(respParams);//NO OUTPUTENCODING%><%--NO OUTPUTENCODING --%>}
</div>
<%}%>
<% Object respMessage = request.getAttribute("STATUS_MESSAGE");
 if(respMessage != null){%>
<div part="STATUS_MESSAGE" class='hide'>
<%=IAMEncoder.encodeHTML((String)request.getAttribute("STATUS_MESSAGE"))%>
</div>
<%}%>

