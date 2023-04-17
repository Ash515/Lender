<%@ taglib tagdir="/WEB-INF/tags" prefix="h" %>

<%@ tag import="com.adventnet.persistence.DataObject" %>
<%@ tag import="com.adventnet.clientframework.VIEWCONFIGURATION" %>
<%@ tag import="com.adventnet.client.view.web.ViewContext" %>
<%@ tag import="com.adventnet.client.view.dynamiccontentarea.web.DynamicContentAreaAPI" %>

<script language="JavaScript" src="framework/javascript/MenuAPI.js"></script>

<%@ attribute name="contentAreaName" required="true"%>
<%@ attribute name="type" required="false"%>
<%@ attribute name="orientation" required="false"%>

<%
HttpServletRequest req = ((HttpServletRequest)((PageContext)jspContext).getRequest());
ViewContext currVC = DynamicContentAreaAPI.getViewCtxForCurrentContent(req, contentAreaName);
String uniqueId = currVC.getUniqueId();
DataObject viewConfig = currVC.getModel().getViewConfiguration();
String menuId = (String)viewConfig.getFirstValue(VIEWCONFIGURATION.TABLE, VIEWCONFIGURATION.MENUID);
%>
<h:ShowMenu menuId="<%=menuId%>" uniqueId="<%=uniqueId%>" type="<%=type%>" orientation="<%=orientation%>"/>
