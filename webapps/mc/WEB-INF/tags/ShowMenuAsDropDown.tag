<%-- $Id$ --%>
<%@ taglib uri = "http://www.adventnet.com/webclient/menu-tags" prefix="menu" %>
<%@ tag import="com.adventnet.client.components.action.web.*" %>
<%@ tag import="com.adventnet.client.action.web.*" %>
<%@ tag import="com.adventnet.persistence.DataObject" %>
<%@ tag import="com.adventnet.client.action.web.MenuActionConstants" %>

<%@ attribute name="menuId" required="true"%>
<%@ attribute name="uniqueId" required="false"%>
<%@ attribute name="reqParams" required="false"%>
<%@ attribute name="contentOnly" required="false"%>

<%
String isContentOnly="false";
String classname="dropDownMenu";
if(contentOnly!=null)
{
	isContentOnly=contentOnly;
	classname="menuDropDownTab";
}
if(isContentOnly.equals("false"))
{
%>

 <table cellspacing="0" cellpadding="0" border="0"><tr><td><input type="button" class="menuDropDownBtn"
 id="<%=menuId%>_BTN" onClick="showDropDownMenu('<%=menuId%>',this,event)"
 value="<%= MenuVariablesGenerator.getMenuDisplayName(menuId)%>"/></td>
  <td><input type="button" class="menuDropDownBtnPull" onClick="showDropDownMenu('<%=menuId%>',this,event)"/></td></tr></table>
<%
}
String ctxPath = ((HttpServletRequest)((PageContext)jspContext).getRequest()).getContextPath();
if(reqParams != null)
{
	reqParams = "'" + reqParams + "'";
}
else
{
   reqParams = "null";
}
if(isContentOnly.equals("false"))
{
%>
<div id="<%=menuId%>_PDM"  style='display:none;'>
<%}
else{
%>
<div id="<%=menuId%>_PDM">

<%} %>
<div class=<%=classname %>>
<ul class="menudropdown">
    <menu:MenuIterator menuId="<%= menuId%>" uniqueId="<%=uniqueId%>">
    <%
    DataObject obj =  (DataObject)((PageContext)jspContext).getAttribute(MenuActionConstants.MENUITEM_DATA);
    		if(obj != null) 
    		{
    %>    
        <menu:MenuItem menuItem='<%= obj%>'>
        <%
    	DataObject menuObj = MenuVariablesGenerator.getCompleteMenuData(menuId);
    	String displayType = (String) menuObj.getFirstValue("Menu","DISPLAYTYPE");
    	
        if(displayType == null){
            displayType = "BOTH";
        }        

        MenuItemProperties p = (MenuItemProperties)((PageContext)jspContext).getAttribute(MenuActionConstants.CURRENT_MENUITEM);        
	    String str = p.getDisplayName(); 
		if(str == null)
		{
		str = "";
		}	
		

            String imgSrc = p.getImageSrc();
            if(imgSrc != null)
            {
                imgSrc = (imgSrc.charAt(0) == '/')?ctxPath + imgSrc:imgSrc;
            }
            String jsMethod="javascript:invokeMenuAction('"+ p.getMenuItemId()+"'," 
              + ((uniqueId != null)? ("'" + uniqueId + "'") :"null") + " ," + reqParams +")";
        %>
        <%
            if(p.getViewType() == MenuActionConstants.HIDE_MENUITEM)
            {//Do Nothing.
            }
            else if(p.getViewType() == MenuActionConstants.DISABLE_MENUITEM)
            {
        %>
            <li>
                <%
                if(imgSrc != null && ("IMAGE".equals(displayType) || "BOTH".equals(displayType)))
                {
				%>            
              <%if(imgSrc != null){%><img src="<%=imgSrc%>"><%}%>
				<%
                }
                if(str != null && ("TEXT".equals(displayType) || "BOTH".equals(displayType)))
                {
                %>	              
              <%=str%>
                <%
                } 
                %>              
            </li>
        <%
            }
            else
            {
        %>
            <li>

                <%
                if(imgSrc != null && ("IMAGE".equals(displayType) || "BOTH".equals(displayType)))
                {
			%>	            
             <%if(imgSrc != null){%><a href="#" onclick="<%=jsMethod+""%>;closeMenuDropDown(this)"><img src="<%=imgSrc%>"></a><%}%>
				<%
                }
                if(str != null && ("TEXT".equals(displayType) || "BOTH".equals(displayType)))
                {
                %>	                           
             <a href="#" onclick="<%=jsMethod+""%>;closeMenuDropDown(this)"><%=str%></a>
                <%
                } 
                %>                           
            </li>
        <%
            }
        %>            
        </menu:MenuItem>
        <%
    		}
        %>        
    </menu:MenuIterator>
   </ul>
</div>
</div>