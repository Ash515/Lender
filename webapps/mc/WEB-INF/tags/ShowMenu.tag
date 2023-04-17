<%-- $Id$ --%>
<%@ taglib uri = "http://www.adventnet.com/webclient/menu-tags" prefix="menu" %>
<%@ tag import="com.adventnet.client.components.action.web.MenuItemProperties" %>
<%@ tag import="com.adventnet.clientframework.*" %>
<%@ tag import="com.adventnet.persistence.DataObject" %>
<%@ tag import="com.adventnet.client.action.web.MenuActionConstants" %>
<%@ tag import="com.adventnet.persistence.*"%>
<%@ tag import="com.adventnet.client.action.web.MenuVariablesGenerator" %>
<%@ tag import="com.adventnet.client.themes.web.ThemesAPI" %>
<%@ taglib tagdir="/WEB-INF/tags" prefix="act" %>

<%@ attribute name="menuId" required="true"%>
<%@ attribute name="uniqueId" required="false"%>
<%@ attribute name="type" required="false"%>
<%@ attribute name="orientation" required="false"%>
<%@ attribute name="reqParams" required="false"%>
<%@ attribute name="menuButtonItem" required="false"%>

<%
String ctxPath = ((HttpServletRequest)((PageContext)jspContext).getRequest()).getContextPath();
String classId = null;
String imageCSSClass = null;
if (type == null || type.equals("button"))
{
    if(orientation == null || orientation.equals("horizontal"))
    {
        classId = "hmenubutton";
    }
    else if(orientation.equals("vertical"))
    {
        classId = "vmenubutton";
    }
}
else if(type.equals("link"))
{
    if(orientation == null || orientation.equals("horizontal"))
    {
        classId = "hmenu";
    }
    else if(orientation.equals("vertical"))
    {
        classId = "vmenu";
    }
}
if(reqParams != null){
	reqParams = "'" + reqParams + "'";
}
else
{
   reqParams = "null";
}

%>
<%
DataObject menuObj = null;
		try
		{
            menuObj = MenuVariablesGenerator.getCompleteMenuData(menuId);
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
        	String displayType = (String) menuObj.getFirstValue("Menu","DISPLAYTYPE");
        	
            if(displayType == null){
                displayType = "BOTH";
            }


%>
<ul class="<%= classId%>" id="menu_<%=menuId%>">
    <menu:MenuIterator menuId="<%= menuId%>" uniqueId="<%=uniqueId%>">
    <%
     
     String showImage="true";
     String showDisplayName="true";
     
     if(displayType.equals("IMAGE"))
     {
         showDisplayName="false";
     }
     if(displayType.equals("TEXT"))
     {
         showImage="false";
     }
     
     
    DataObject obj =  (DataObject)((PageContext)jspContext).getAttribute(MenuActionConstants.MENUITEM_DATA);
    if(obj != null)
     {
		String menuitemid=null;
		if(obj.containsTable(MENUITEM.TABLE))
         {
			
              menuitemid=obj.getFirstRow(MENUITEM.TABLE).get(MENUITEM.MENUITEMID).toString();
         }
    %>
        <act:ShowMenuItem menuItemId="<%=menuitemid%>" menuButtonItem="<%=menuButtonItem%>" 
        uniqueId="<%=uniqueId%>" showImage="<%=showImage%>" showDisplayName="<%=showDisplayName%>"></act:ShowMenuItem>
        <%
    		}
        %>
    </menu:MenuIterator>
</ul>

