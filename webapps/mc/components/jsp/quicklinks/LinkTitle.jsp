<%-- $Id$ --%>
<%@ include file='/components/jsp/CommonIncludes.jspf'%>

<%
 String viewName = request.getParameter("VIEWNAME");
 String menuItemId = request.getParameter("MENUITEMID");
%>
<form  onSubmit="addLink('<%=IAMEncoder.encodeJavaScript(menuItemId)%>','<%=IAMEncoder.encodeJavaScript(viewName)%>',this);return false;" alerttype='Complete' >
<table width="100%" border="0" align="center" cellpadding="3" cellspacing="0">
  <tr> 
    <td width="9%" align="right" nowrap>Link Name</td>
    <td width="91%"><input name="textfield" id="favTitleField" type="text" class="inputStyleFav" size="30" 
                      validatemethod='isAlphaNumeric' errormsg='Special Characters not allowed.'>
    </td>
  </tr>
  <tr>
    <td width="9%" align="right" nowrap>&nbsp;</td>
    <td width="91%"><div id="favTitleField_DIV"></div></td>
  </tr>
  <tr> 
    <td>&nbsp;</td>
    <td><input type="button" name="Submit" value="Add" onClick="return addLink('<%=IAMEncoder.encodeJavaScript(menuItemId)%>','<%=IAMEncoder.encodeJavaScript(viewName)%>',this.form);" class="btnStyleFav"> <input type="button" name="Submit2" value="Cancel" class="btnStyleFav" onClick="closeDialog();"></td>
  </tr>
</table>
</form>