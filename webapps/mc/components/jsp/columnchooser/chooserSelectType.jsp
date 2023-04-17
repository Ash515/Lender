<%-- $Id$ --%>
<%@ include file='../CommonIncludes.jspf'%>

<%@ page import = "com.adventnet.client.components.table.web.*, com.adventnet.client.util.web.*,java.util.*"%>
<%@page import="com.adventnet.client.themes.web.ThemesAPI"%>
<%@page import="com.adventnet.client.util.web.WebClientUtil"%>
<%@page import="com.adventnet.persistence.*"%>
<%@page import="com.adventnet.i18n.I18N"%>
<%@ page isELIgnored="false" %>
<%
	String tableViewId = request.getParameter("TABLEVIEWID");
%>
<html>
<head>
<title><%=IAMEncoder.encodeHTML(I18N.getMsg("mc.components.Table_Column_Customization"))%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="<%out.print(themeDir);//NO OUTPUTENCODING%>/styles/style.css" rel="stylesheet" type="text/css"><%--NO OUTPUTENCODING --%>
<script src='<%out.print(request.getContextPath());//NO OUTPUTENCODING%>/framework/javascript/IncludeJS.js' type='text/javascript'></script><%--NO OUTPUTENCODING --%>
<script src='<%out.print(request.getContextPath());//NO OUTPUTENCODING%>/components/javascript/ListUtils.js'></script><%--NO OUTPUTENCODING --%>
<script language="JavaScript" type="text/JavaScript">
var formClicked = false;
function submitForm(form)
{
    var i=0,opt;
    var selectedValues="";
    
    if (form.SHOW_LIST.options.length ==0)
    {
        form.HIDE_LIST.focus();
				alert("Atleast one value should be selected");
        return false;
    }
		// Only when atleast a single value present, the form is considered as
		// submitted. In that case only the formClicked variable should be set to
		// true 
		formClicked = true;
		for(i=0;i<form.SHOW_LIST.options.length;i++)
		{
				opt = form.SHOW_LIST.options[i];
				opt.selected = true;
		}
		for(i=0;i<form.HIDE_LIST.options.length;i++)
		{
				opt = form.HIDE_LIST.options[i];
				opt.selected = true;
		}
    form.submit;
    return true;
}

function windowClose()
{
		window.close();
		self.window.opener.stateData['<%=IAMEncoder.encodeJavaScript(tableViewId)%>']["_VMD"] = 1;
		self.window.opener.refreshSubView('<%=IAMEncoder.encodeJavaScript(tableViewId)%>');
}

</script>
</head>
<%
if(request.getParameter("View_Name") != null){
	TablePersonalizationUtil.updateColumnsListForView(request.getParameter("View_Name"), WebClientUtil.getAccountId(), request.getParameterValues("SHOW_LIST"), request.getParameterValues("HIDE_LIST"));
	%>
<script>
		windowClose();
	</script>
<%
}
else {
 
ArrayList showList = new ArrayList();
ArrayList hideList = new ArrayList();
TablePersonalizationUtil.setColumnsListForView(request.getParameter("viewName"), WebClientUtil.getAccountId(), showList, hideList, request);
%>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="100%" cellpadding="0" cellspacing="0" class="productLogo" height="30">
  <tr> 
    <td class="titleText"><%=IAMEncoder.encodeHTML(I18N.getMsg("mc.components.Table_Column_Customization"))%></td>
  </tr>
</table>
<form name="tableview" method="post">
  <input type = "hidden" name = "View_Name" value = '<%=IAMEncoder.encodeHTMLAttribute(request.getParameter("viewName"))%>'>
  <input type = "hidden" name = "TABLEVIEWID" value = '<%=IAMEncoder.encodeHTMLAttribute(request.getParameter("TABLEVIEWID"))%>'>
  <table class="columnchooser" align="center">
    <tr> 
      <td class="bodyText" width="40%"><%=IAMEncoder.encodeHTML(I18N.getMsg("mc.components.Non_Visible_Columns"))%>: <br> <select name="HIDE_LIST" size="8" multiple class="listStyle ">
          <%
								int hideSize = hideList.size();
								for(int i = 0; i<hideSize; i++){
									String[] values = (String[]) hideList.get(i);
									%>
          <option value="<%=values[0]%>"><%=IAMEncoder.encodeHTML(I18N.getMsg(values[1]))%></option>
          <%	
								}
							%>
        </select> </td>
      <td valign="middle" width="10%"> <table width="100%" border="0" cellspacing="2" cellpadding="4">
          <tr> 
            <td align="center"><button onClick='return updateLists(document.forms[0].HIDE_LIST,document.forms[0].SHOW_LIST)' class="add"></button></td>
          </tr>
          <tr> 
            <td align="center"><button onClick='return moveAll(document.forms[0].HIDE_LIST,document.forms[0].SHOW_LIST)' class="addAll"></button></td>
          </tr>
          <tr> 
            <td align="center"><button onClick='return updateLists(document.forms[0].SHOW_LIST,document.forms[0].HIDE_LIST)' class="removeColumn"></button></td>
          </tr>
          <tr> 
            <td align="center"><button onClick='return moveAll(document.forms[0].SHOW_LIST,document.forms[0].HIDE_LIST)' class="removeAll"></button></td>
          </tr>
        </table></td>
      <td class="bodyText" width="40%"><%=IAMEncoder.encodeHTML(I18N.getMsg("mc.components.Visible_Columns"))%>: <br>
        <select name="SHOW_LIST" multiple class="listStyle" size="8">
          <%
					int showSize = showList.size();
					for(int i = 0; i<showSize; i++){
						String[] values = (String[]) showList.get(i);
						%>
          <option value="<%=values[0]%>"><%=IAMEncoder.encodeHTML(I18N.getMsg(values[1]))%></option>
          <%
					}
				%>
        </select> </td>
      <td width="10%"> <table width="100%" border="0" cellspacing="1" cellpadding="5">
          <tr> 
            <td align="center"><button onClick='return moveUp(document.forms[0].SHOW_LIST)' class="moveUp"></button></td>
          </tr>
          <tr> 
            <td align="center"><button onClick='return moveDown(document.forms[0].SHOW_LIST)' class="moveDown"></button></td>
          </tr>
        </table></td>
	</tr>
	<tr>
		<td class="btnPanel" align="center" colspan="3" style="height:40"> <input name="Submit" type="submit" class="btn" value='<%=IAMEncoder.encodeHTMLAttribute(I18N.getMsg("mc.components.Save"))%>' onClick="return submitForm(this.form)"> 
        <input name="Submit2" type="button" class="btn" value='<%=IAMEncoder.encodeHTMLAttribute(I18N.getMsg("mc.components.Cancel"))%>' onClick="window.close()">
      </td>
	</tr>
  </table>
  <input type="hidden" name="USER_VAR" value="IAMEncoder.encodeHTMLAttribute(${param.USER_VARIABLE})" />
</form>
<%
}
%>
</body>
</html>

