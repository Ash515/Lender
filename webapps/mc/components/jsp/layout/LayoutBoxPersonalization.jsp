<%-- $Id$ --%>
<%@ page import = "com.adventnet.client.components.table.web.*, com.adventnet.client.util.web.*,com.adventnet.client.view.web.*, com.adventnet.persistence.*, java.util.*, com.adventnet.client.view.*"%>
<%
String viewName = request.getParameter("VIEWNAME");
String childViewName = request.getParameter("CHILDVIEWNAME");
String layout = request.getParameter("LAYOUT");
String state = request.getParameter("STATE");
ViewContext viewCtx = ViewContext.getViewContext(viewName, viewName, request);
DataObject dataObject = UserPersonalizationAPI.getPersonalizedView(viewName, WebClientUtil.getAccountId());
if("ACGrid".equals(layout)){
	Iterator ite = dataObject.getRows("ACGridLayoutChildConfig");
	while(ite.hasNext()){
		Row row = (Row) ite.next();
		String child = (String) row.get("CHILDVIEWNAME");
		if(child.equals(childViewName)){
			row.set("ISOPEN", new Boolean(state));
			dataObject.updateRow(row);
		}
	}
}
if("ACTableLayout".equals(layout)){
	Iterator ite = dataObject.getRows("ACTableLayoutChildConfig");
	while(ite.hasNext()){
		Row row = (Row) ite.next();
		String child = (String) row.get("CHILDVIEWNAME");
		if(child.equals(childViewName)){
			row.set("ISOPEN", new Boolean(state));
			dataObject.updateRow(row);
		}
	}
}
UserPersonalizationAPI.updatePersonalizedView((WritableDataObject)dataObject, WebClientUtil.getAccountId());
%>
