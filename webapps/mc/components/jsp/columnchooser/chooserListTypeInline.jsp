<%-- $Id$ --%>
<%@ include file='../CommonIncludes.jspf'%>
<%@ page import = "com.adventnet.client.components.table.web.*, com.adventnet.client.util.web.*,java.util.*"%>
<%@page import="com.adventnet.client.util.web.WebClientUtil"%>
<%@page import="com.adventnet.persistence.*"%>
<%@page import="com.adventnet.i18n.I18N"%>
<%@ page isELIgnored="false" %>
<%
	String tableViewId = IAMEncoder.encodeHTMLAttribute(request.getParameter("TABLEVIEWID"));

if(request.getParameter("View_Name") != null){
	TablePersonalizationUtil.updateColumnsListForView(request.getParameter("View_Name"), WebClientUtil.getAccountId(), request.getParameterValues("SHOW_LIST"), request.getParameterValues("HIDE_LIST"));
}
else {
	ArrayList showList = new ArrayList();
	ArrayList hideList = new ArrayList();
	TablePersonalizationUtil.setColumnsListForView(request.getParameter("viewName"), WebClientUtil.getAccountId(), showList, hideList, request);
%></head><div id="chooserTable">
<form name="tableview" method="post">
  <input type = "hidden" name = "View_Name" value = '<%out.print(IAMEncoder.encodeHTMLAttribute(request.getParameter("viewName")));//NO OUTPUTENCODING%>'><%--NO OUTPUTENCODING --%>
  <input type = "hidden" name = "TABLEVIEWID" value = '<%out.print(tableViewId);//NO OUTPUTENCODING%>'><%--NO OUTPUTENCODING --%>
  <table border="0" align="center" cellpadding="0" cellspacing="0" class="ccListTableInline">
    <tr> 
      <td width="80%"> <div id='ccTable'></div></td>
      <td class="ccMovePanel"> <table width="100%" border="0" cellspacing="1" cellpadding="5">
          <tr> 
            <td align="center"><button onClick="return moveColumnUp()" value="^" class="moveUp" title="<%=IAMEncoder.encodeHTMLAttribute(I18N.getMsg("mc.components.columnchooser.button.title.Move_Up")) %>"></button></td>
          </tr>
          <tr> 
            <td align="center"><button onClick="return moveColumnDown()" value="^" class="moveDown" title="<%=IAMEncoder.encodeHTMLAttribute(I18N.getMsg("mc.components.columnchooser.button.title.Move_Down")) %>"></button></td>
          </tr>
        </table></td>
    </tr>
    <script>
	var list = new Array();
	<%
	int count = 0;
	for(int i=0; i<showList.size();i++){
		String[] values = (String[]) showList.get(i);
                values[0] = values[0].replaceAll("'","\\\\'");
                values[1] = values[1].replaceAll("'","\\\\'");
		%>list[<%out.print(i);//NO OUTPUTENCODING%>] = new Array('<%out.print(IAMEncoder.encodeJavaScript(values[0]));//NO OUTPUTENCODING%>','<%out.print(IAMEncoder.encodeJavaScript(I18N.getMsg(values[1])));//NO OUTPUTENCODING%>','true');<%--NO OUTPUTENCODING --%>
		<%
		count++;
	}
	for(int i=0; i<hideList.size();i++){
		String[] values = (String[]) hideList.get(i);
                values[0] = values[0].replaceAll("'","\\\\'");
                values[1] = values[1].replaceAll("'","\\\\'");
		%>
		list[<%out.print(count);//NO OUTPUTENCODING%>] = new Array('<%out.print(IAMEncoder.encodeJavaScript(values[0]));//NO OUTPUTENCODING%>','<%out.print(IAMEncoder.encodeJavaScript(I18N.getMsg(values[1])));//NO OUTPUTENCODING%>','false');<%--NO OUTPUTENCODING --%>
		<%
		count++;
	}
	%>
	initColumnChooser(list,document, true);
</script>
    <select name="SHOW_LIST" multiple class="hide">
    </select>
    <select name="HIDE_LIST" multiple class="hide">
    </select>
    <tr> 
      <td colspan="2" class="ccBtnPanel"> <input name="Submit" type="button" class="btn" value='<%=IAMEncoder.encodeHTMLAttribute(I18N.getMsg("mc.components.Save"))%>' onClick="return submitCCListForm(this.form);return false;">
        <input name="Submit2" type="button" class="btn" value='<%=IAMEncoder.encodeHTMLAttribute(I18N.getMsg("mc.components.Cancel"))%>' onClick="closeDialog(null,this);"> 
      </td>
    </tr>
  </table>
</form>
</div> 
<%
}
%></body>
</html> 

