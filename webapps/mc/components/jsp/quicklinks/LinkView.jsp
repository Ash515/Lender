<%-- $Id$ --%>
<%@ include file='/components/jsp/CommonIncludes.jspf'%>
<%@ page import="com.adventnet.client.components.quicklinks.web.*" %>
<%@ page import = "com.adventnet.client.components.util.web.*"%>

<% 
LinkModel model = (LinkModel)viewContext.getViewModel();
%>
<table cellspacing="0" class="qLinkTable">
<% 
String showImage = request.getParameter("showImage"); 
showImage = (showImage != null) ? showImage : "true";
while(model.next()){
	%>
		<tr>
			<td class="qLinkMIPane"><act:ShowMenuItem menuItemId="<%=IAMEncoder.encodeJavaScript(model.getCurrentMenuItemId())%>" showImage="<%=IAMEncoder.encodeHTMLAttribute(showImage)%>"/></td> 
			<td class="qLinkRemovePane"><%if(model.canDelete()){%><input type="button" name="dellink" class="qLinkRemoveBtn" onClick="deleteLink('<%=IAMEncoder.encodeJavaScript(uniqueId)%>','<%=IAMEncoder.encodeJavaScript(model.getCurrentMenuItemId())%>');"/><%}else{%>&nbsp;<%}%></td>
		</tr> 
		<%}%>
</table>
