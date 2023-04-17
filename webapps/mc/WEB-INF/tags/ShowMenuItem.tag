<%-- $Id$ --%>
<%@ taglib uri = "http://www.adventnet.com/webclient/menu-tags" prefix="menu" %>
<%@ tag import="com.adventnet.client.components.action.web.MenuItemProperties" %>
<%@ tag import="com.adventnet.persistence.DataObject" %>
<%@ tag import="com.adventnet.client.action.web.MenuActionConstants" %>
<%@ tag import="com.adventnet.client.themes.web.ThemesAPI" %>
<%@ tag import="com.adventnet.iam.xss.IAMEncoder"%>
<%@ attribute name="menuItemId" required="true"%>
<%@ attribute name="uniqueId" required="false"%>
<%@ attribute name="displayName" required="false"%>
<%@ attribute name="reqParams" required="false"%>
<%@ attribute name="showImage" required="false"%>
<%@ attribute name="showDisplayName" required="false"%>
<%@ attribute name="menuButtonItem" required="false"%>

<menu:MenuItem menuItemId='<%= menuItemId%>'>
<%
boolean showDispName=true;
if("false".equals(showDisplayName))
{
showDispName=false;
}
MenuItemProperties p = (MenuItemProperties)((PageContext)jspContext).getAttribute(MenuActionConstants.CURRENT_MENUITEM);
String imgSrc = p.getImageSrc();

String imageCSSClass = null; 
if(imgSrc != null) 
{ 
String themeDir = ThemesAPI.getThemeDirForRequest (request); 
imgSrc = ThemesAPI.handlePath(imgSrc,request,themeDir); 
} 
if(displayName == null) { 
displayName = p.getDisplayName(); 
} 
if(displayName == null) 
{ 
displayName =""; 
}
if(p.getImageCSSClass() != null) 
{ 
imageCSSClass = p.getImageCSSClass(); 
}
if(reqParams != null) 
{ 
reqParams = "'" + reqParams + "'"; 
}
%>  
<a href="javascript:invokeMenuAction('<%= IAMEncoder.encodeJavaScript(p.getMenuItemId())%>', <%= (uniqueId != null)? "'" + IAMEncoder.encodeJavaScript(uniqueId) + "'" :"null" %>, <%=IAMEncoder.encodeJavaScript(reqParams)%>)">
<%if(menuButtonItem != null){%><span class="hmleft_btn"></span><span class="hmmiddle_btn"><%}%>
<% if(showImage == null || showImage.equalsIgnoreCase("true")){if(imgSrc != null){%><img src="<%=IAMEncoder.encodeHTMLAttribute(imgSrc)%>"><% }else{%>
<span  class="<%=IAMEncoder.encodeHTMLAttribute(imageCSSClass)%>" ></span><% }}%><%=(showDispName?IAMEncoder.encodeHTML(displayName):"")%><%if(menuButtonItem != null){%></span><span class="hmright_btn"></span><%}%></a> 
</menu:MenuItem>

