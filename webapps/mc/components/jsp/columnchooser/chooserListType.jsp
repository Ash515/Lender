<%-- $Id$ --%>
<%@ include file='../CommonIncludes.jspf'%>
<%@ page import = "com.adventnet.client.components.table.web.*, com.adventnet.client.util.web.*,java.util.*"%>
<%@page import="com.adventnet.client.util.web.WebClientUtil"%>
<%@page import="com.adventnet.persistence.*"%>
<%@page import="com.adventnet.i18n.I18N"%>
<%@ page isELIgnored="false" %>
<%
	String tableViewId = request.getParameter("TABLEVIEWID");
%>
<link href="<%out.print(themeDir);//NO OUTPUTENCODING%>/styles/style.css" rel="stylesheet" type="text/css"><%--NO OUTPUTENCODING --%>
<script src='<%out.print(request.getContextPath());//NO OUTPUTENCODING%>/framework/javascript/IncludeJS.js' type='text/javascript'></script><%--NO OUTPUTENCODING --%>
<script src='<%out.print(request.getContextPath());//NO OUTPUTENCODING%>/components/javascript/listColumnChooser.js' type='text/javascript'></script><%--NO OUTPUTENCODING --%>
<script>
function submitForm(form)
{
	var showIndex = 0;
	var hideIndex = 0;
    var count = _viewObjects.length;
		for(var i = 0; i < count; i++){
			var curObj = _viewObjects[i];
			if(curObj[2] == 'true'){
				form.SHOW_LIST.options[showIndex] = new Option(curObj[0], curObj[0]);
				form.SHOW_LIST.options[showIndex].selected = true;
				showIndex++;
			}
			else {
				form.HIDE_LIST.options[hideIndex] = new Option(curObj[0], curObj[0]);
				form.HIDE_LIST.options[hideIndex].selected = true;
				hideIndex++;
			}
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
</head>
<form name="tableview" method="post">
  <input type = "hidden" name = "View_Name" value = '<%=IAMEncoder.encodeHTMLAttribute(request.getParameter("viewName"))%>'>
  <input type = "hidden" name = "TABLEVIEWID" value = '<%=IAMEncoder.encodeHTMLAttribute(request.getParameter("TABLEVIEWID"))%>'>
  <table>
    <tr> 
      <td> <div id='ccTable'></div></td>
      <td> <button onClick="return moveColumnUp()" value="^" class="moveUp"></button>
        <br> <button onClick="return moveColumnDown()" value="^" class="moveDown"></button></td>
    </tr>
    <script>
	var list = new Array();
	<%
	int count = 0;
	for(int i=0; i<showList.size();i++){
		String[] values = (String[]) showList.get(i);
		%>list[<%out.print(i);//NO OUTPUTENCODING%>] = new Array('<%out.print(values[0]);//NO OUTPUTENCODING%>','<%out.print(IAMEncoder.encodeHTML(I18N.getMsg(values[1])));//NO OUTPUTENCODING%>','true');<%--NO OUTPUTENCODING --%>
		<%
		count++;
	}
	for(int i=0; i<hideList.size();i++){
		String[] values = (String[]) hideList.get(i);
		%>
		list[<%out.print(count);//NO OUTPUTENCODING%>] = new Array('<%out.print(values[0]);//NO OUTPUTENCODING%>','<%out.print(IAMEncoder.encodeHTML(I18N.getMsg(values[1])));//NO OUTPUTENCODING%>','false'); <%--NO OUTPUTENCODING --%>
		<%
		count++;
	}
	%>
	initColumnChooser(list);
</script>
    <select name="SHOW_LIST" multiple class="hide">
    </select>
    <select name="HIDE_LIST" multiple class="hide">
    </select>
    <tr> 
      <td align="center"> <input name="Submit" type="submit" class="btn" value='<%out.print(IAMEncoder.encodeHTMLAttribute(I18N.getMsg("mc.components.Save")));//NO OUTPUTENCODING%>' onClick="return submitForm(this.form)"> </td><%--NO OUTPUTENCODING --%>
      <td>&nbsp;</td>
    </tr>
  </table>
</form>
<%
}
%>
</body>
</html>

