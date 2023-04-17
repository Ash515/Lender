<%-- $Id$ --%>
<%@ taglib uri = "http://www.adventnet.com/webclient/menu-tags" prefix="menu" %>
<%@ tag import="com.adventnet.client.components.action.web.*" %>
<%@ tag import="com.adventnet.client.action.web.*" %>
<%@ tag import="com.adventnet.persistence.DataObject" %>
<%@ tag import="com.adventnet.client.action.web.MenuActionConstants" %>
<%@ tag import="com.adventnet.client.tpl.TemplateAPI" %>

<%@ attribute name="menuId" required="true"%>
<%@ attribute name="menuTemplate" required="true"%>
<%@ attribute name="showActivator" required="false"%>
<%@ attribute name="uniqueId" required="false"%>
<%@ attribute name="reqParams" required="false"%>

<%
String ctxPath = ((HttpServletRequest)((PageContext)jspContext).getRequest()).getContextPath();
if(reqParams != null)
{
	reqParams = "'" + reqParams + "'";
}
else
{
   reqParams = "null";
}

if(showActivator == null|| showActivator.equals("true"))
{
	out.println(TemplateAPI.givehtml(menuTemplate + "Activator_Prefix", 
			null, new Object[][] { { "MENUID", menuId } , {"DISPLAYNAME",MenuVariablesGenerator.getMenuDisplayName(menuId)}}));
}
%>




<%
out.println(TemplateAPI.givehtml(menuTemplate + "Content_Prefix",
		null, new Object[][] { { "MENUID", menuId } }));
%>
    <menu:MenuIterator menuId="<%= menuId%>" uniqueId="<%=uniqueId%>">
        <%
    DataObject obj =  (DataObject)((PageContext)jspContext).getAttribute(MenuActionConstants.MENUITEM_DATA);
    		if(obj != null) 
    		{
    %>    
        <menu:MenuItem menuItem='<%= obj%>'>
        <%MenuItemProperties p = (MenuItemProperties) ((PageContext) jspContext)
							.getAttribute(MenuActionConstants.CURRENT_MENUITEM);
					String imgSrc = p.getImageSrc();
					if (imgSrc != null) {
						imgSrc = (imgSrc.charAt(0) == '/') ? ctxPath + imgSrc
								: imgSrc;
					}
					String jsMethod = "javascript:invokeMenuAction('"
							+ p.getMenuItemId()
							+ "',"
							+ ((uniqueId != null) ? ("'" + uniqueId + "'")
									: "null") + " ," + reqParams + ")";
					
			    	DataObject menuObj = MenuVariablesGenerator.getCompleteMenuData(menuId);
			    	String displayType = (String) menuObj.getFirstValue("Menu","DISPLAYTYPE");
			    	
			        if(displayType == null){
			            displayType = "BOTH";
			        }        
			        
				    String str = p.getDisplayName(); 
					if(str == null)
					{
					str = "";
					}				        

					%>
        <%if (p.getViewType() == MenuActionConstants.HIDE_MENUITEM) {//Do Nothing.
				} else if (p.getViewType() == MenuActionConstants.DISABLE_MENUITEM) {
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
				} else {
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
        <%}

				%>            
        </menu:MenuItem>
        <%
    		}
        %>                
    </menu:MenuIterator>
<%
out.println(TemplateAPI.givehtml(menuTemplate + "Content_Suffix", null,  null));
%>