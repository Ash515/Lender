<%-- $Id$ --%>
<%@ page import = "com.adventnet.client.components.table.web.*, com.adventnet.client.util.web.*"%>
<%
String viewName = request.getParameter("VIEWNAME");
String sortColumn = request.getParameter("SORTCOLUMN");
String order = request.getParameter("SORTORDER");
String pageLength = request.getParameter("PAGELENGTH");
if(sortColumn != null){
	TablePersonalizationUtil.updateSortForView(viewName, WebClientUtil.getAccountId(), sortColumn, order);
}
if(pageLength != null){
	TablePersonalizationUtil.updatePageLengthForView(viewName, WebClientUtil.getAccountId(), Integer.parseInt(pageLength));
}
%>
