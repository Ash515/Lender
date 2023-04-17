<!-- $Id$ -->
<%@ include file='/components/jsp/CommonIncludes.jspf'%>
<%
String menuId=(String)request.getAttribute("MENU_ID");
String displayStyle=(String)request.getAttribute("MENU_ID_DISPLAYSTYLE");
String templateName=(String)request.getAttribute("MENU_ID_TEMPLATENAME");
String viewuniqueid = (String) request.getAttribute("VIEWUNIQUEID");

if(("DROPDDOWN").equals(displayStyle))
{
	%>
	<div class="hide" id="<%=IAMEncoder.encodeHTMLAttribute("dropDownMenu_hidden_"+menuId)%>">
	<act:ShowMenuAsDropDown menuId='<%=menuId%>' uniqueId='<%=viewuniqueid%>'/>
	</div><%	
}
else
{
	if(templateName.equals("null"))
	{
		throw new Exception("Specify proper templatename for menu:"+menuId);
	}
	%>
	<div class="hide" id="<%=IAMEncoder.encodeHTMLAttribute("dropDownMenu_hidden_"+menuId)%>">
	<act:ShowDropDownTemplateMenu menuId='<%=menuId%>' menuTemplate='<%=templateName%>' uniqueId='<%=viewuniqueid%>'/>
	</div>
	<%	

}
%>
