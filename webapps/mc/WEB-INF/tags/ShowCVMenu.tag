<%-- $Id$ --%>
<%@ taglib uri = "http://www.adventnet.com/webclient/menu-tags" prefix="menu" %>
<%@ tag import="com.adventnet.client.components.action.web.MenuItemProperties" %>
<%@ tag import="com.adventnet.persistence.DataObject" %>
<%@ tag import="com.adventnet.client.action.web.MenuActionConstants" %>
<%@ tag import="com.adventnet.iam.xss.IAMEncoder"%>

<%@ attribute name="menuId" required="true"%>
<%@ attribute name="uniqueId" required="true"%>
<%@ attribute name="index" required="true"%>

<%
String ctxPath = ((HttpServletRequest)((PageContext)jspContext).getRequest()).getContextPath();
%>
    <menu:MenuIterator menuId="<%= menuId%>" uniqueId="<%=uniqueId%>">
        <menu:MenuItem menuItem='<%= (DataObject)((PageContext)jspContext).getAttribute(MenuActionConstants.MENUITEM_DATA)%>'>
        <%
            MenuItemProperties p = (MenuItemProperties)((PageContext)jspContext).getAttribute(MenuActionConstants.CURRENT_MENUITEM);
            String imgSrc = p.getImageSrc();
            imgSrc = (imgSrc.charAt(0) == '/')?ctxPath + imgSrc:imgSrc;
        %>
          <td width="20px">
                <a href="javascript:invokeMenuAction('<%= IAMEncoder.encodeJavaScript(p.getMenuItemId())%>', '<%= IAMEncoder.encodeJavaScript(uniqueId)%>', null,<%= IAMEncoder.encodeJavaScript(index)%>)">
                <img src="<%=IAMEncoder.encodeHTMLAttribute(imgSrc)%>"></a>
         </td>
        </menu:MenuItem>
    </menu:MenuIterator>
