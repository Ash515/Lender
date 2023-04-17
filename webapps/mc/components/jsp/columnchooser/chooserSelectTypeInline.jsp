<%-- $Id$ --%>
<%@ include file='../CommonIncludes.jspf'%>
<%@ page import = "com.adventnet.client.components.table.web.*, com.adventnet.client.util.web.*,java.util.*"%>
<%@page import="com.adventnet.client.util.web.WebClientUtil"%>
<%@page import="com.adventnet.persistence.*"%>
<%@page import="com.adventnet.i18n.I18N"%>
<%@ page isELIgnored="false" %>
<%
	String tableViewId = IAMEncoder.encodeHTMLAttribute(request.getParameter("TABLEVIEWID"));
%>
<html>
<head>
<title><%=IAMEncoder.encodeHTML(I18N.getMsg("mc.components.Table_Column_Customization"))%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<%
if(request.getParameter("View_Name") != null){
	TablePersonalizationUtil.updateColumnsListForView(request.getParameter("View_Name"), WebClientUtil.getAccountId(), request.getParameterValues("SHOW_LIST"), request.getParameterValues("HIDE_LIST"));
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
<div id="chooserTable">
  <form name="tableview" method="post">
    <table border="0" class="ccListTableInline" cellpadding="7" cellspacing="0">
	  <tr> 	  
	    <td> 		
		<input type = "hidden" name = "View_Name" value = '<%=IAMEncoder.encodeHTMLAttribute(request.getParameter("viewName"))%>'>
          <input type = "hidden" name = "TABLEVIEWID" value = '<%out.print(tableViewId);//NO OUTPUTENCODING%>'> <table width="100%" border="0" cellpadding="0" cellspacing="0"><%--NO OUTPUTENCODING --%>
            <tr> 
              <td class="bodyText" nowrap><%=IAMEncoder.encodeHTML(I18N.getMsg("mc.components.Non_Visible_Columns"))%>: <br> <select name="HIDE_LIST" size="8" multiple class="listStyle ">
                  <%
								int hideSize = hideList.size();
								for(int i = 0; i<hideSize; i++){
									String[] values = (String[]) hideList.get(i);
									%>
                  <option value="<%=IAMEncoder.encodeHTMLAttribute(values[0])%>"><%=IAMEncoder.encodeHTML(I18N.getMsg(values[1]))%></option>
                  <%	
								}
							%>
                </select> </td>
              <td valign="middle" width="10%" nowrap> <table width="100%" border="0" cellspacing="2" cellpadding="4">
                  <tr> 
                    <td align="center" nowrap><input type="button" onClick='return updateLists(document.forms["tableview"].HIDE_LIST,document.forms["tableview"].SHOW_LIST)' class="add"/></td>
                  </tr>
                  <tr> 
                    <td align="center" nowrap><input type="button" onClick='return moveAll(document.forms["tableview"].HIDE_LIST,document.forms["tableview"].SHOW_LIST)' class="addAll"/></td>
                  </tr>
                  <tr> 
                    <td align="center" nowrap><input type="button" onClick='return updateLists(document.forms["tableview"].SHOW_LIST,document.forms["tableview"].HIDE_LIST)' class="removeColumn"/></td>
                  </tr>
                  <tr> 
                    <td align="center" nowrap><input type="button" onClick='return moveAll(document.forms["tableview"].SHOW_LIST,document.forms["tableview"].HIDE_LIST)' class="removeAll"/></td>
                  </tr>
                </table></td>
              <td class="bodyText" nowrap> <%out.print(IAMEncoder.encodeHTML(I18N.getMsg("mc.components.Visible_Columns")));//NO OUTPUTENCODING%>: <br> <select name="SHOW_LIST" multiple class="listStyle" size="8"><%--NO OUTPUTENCODING --%>
                  <%
					int showSize = showList.size();
					for(int i = 0; i<showSize; i++){
						String[] values = (String[]) showList.get(i);
						%>
                  <option value="<%=IAMEncoder.encodeHTMLAttribute(values[0])%>"><%=IAMEncoder.encodeHTML(I18N.getMsg(values[1]))%></option>
                  <%
					}
				%>
                </select> </td>
              <td width="10%" nowrap> <table width="100%" border="0" cellspacing="1" cellpadding="5">
                  <tr> 
                    <td align="center" nowrap><input type="button" onClick='return moveUp(document.forms["tableview"].SHOW_LIST)' class="moveUp"/></td>
                  </tr>
                  <tr> 
                    <td align="center" nowrap><input type="button" onClick='return moveDown(document.forms["tableview"].SHOW_LIST)' class="moveDown"/></td>
                  </tr>
                </table></td>
            </tr>
          </table></td>
      </tr>
	</table>
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
	  <tr> 
        <td class="ccBtnPanel" nowrap> <input name="Submit" type="button" class="btn" value='<%out.print(IAMEncoder.encodeHTMLAttribute(I18N.getMsg("mc.components.Save")));//NO OUTPUTENCODING%>' onClick="return submitCCSelectForm(this.form);return false;"><%--NO OUTPUTENCODING --%>
          <input name="Submit2" type="button" class="btn" value='<%=IAMEncoder.encodeHTMLAttribute(I18N.getMsg("mc.components.Cancel"))%>' onClick="closeDialog();">
        </td>
      </tr>
    </table>
    <input type="hidden" name="USER_VAR" value="IAMEncoder.encodeHTMLAttribute(${param.USER_VARIABLE})" />
	</form>
  </div>
<%
}
%>
</body>
</html>

