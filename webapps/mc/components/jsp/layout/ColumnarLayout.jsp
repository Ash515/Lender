<%-- $Id$ --%>
<%@ include file='../CommonIncludes.jspf'%>
<%@ page import="com.adventnet.client.components.layout.grid.web.*" %>
<%@ page import = "com.adventnet.client.components.util.web.*"%>
<%
int count = 0;
%>

<%
  GridModel model = (GridModel)viewContext.getViewModel();
  GridModel.GridIterator ite = model.getIterator();
  count = model.getChildCount();
%>

<table  id="<%=IAMEncoder.encodeHTMLAttribute(uniqueId)%>_TABLE" class="columnedLytTable">
  <tr>
  <%while(ite.next()){%>
    <td class="gridLytCell" valign="top">
   		<client:showView viewName="<%=IAMEncoder.encodeHTMLAttribute(ite.getCurrentView())%>"/>
      </td>
   <%}%>
  </tr>
</table>
