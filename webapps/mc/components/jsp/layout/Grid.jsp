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
  String currentView = request.getParameter("VIEWNAME");
  count = model.getChildCount();
%>

<%@ include file='GridCustomizationLink.jspf'%>
	<table  id="<%=IAMEncoder.encodeHTMLAttribute(uniqueId)%>_TABLE" class="gridLytTable">
              <tr><td class="gridColumn">
   		<%while(ite.next()){%>
		  <div childView="<%=IAMEncoder.encodeHTMLAttribute(ite.getCurrentView())%>" class="gridLytCell">
          		<client:showView viewName="<%=IAMEncoder.encodeHTMLAttribute(ite.getCurrentView())%>"/>
		  </div>
		<%}%>
              </td></tr>
	</table>
