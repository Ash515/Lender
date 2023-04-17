<%-- $Id$ --%>
<%@ page import="com.adventnet.client.components.tab.web.*" %>
<%@page import="com.adventnet.client.themes.web.ThemesAPI"%>
<%@page import="com.adventnet.client.util.web.WebClientUtil"%>
<%@page import="com.adventnet.persistence.*"%>
<%@page import="com.adventnet.iam.xss.IAMEncoder"%>
<%
	String themeDir = ThemesAPI.getThemeDirForRequest(request);
	String viewName  = request.getParameter("NewViewName");
	String type = request.getParameter("TYPE");
	String count = request.getParameter("COUNT");
	if(type == null){
		type = "Tab";
	}
	if(viewName != null){
		%>
		<script>
			function windowClose() {
			var type = '<%=IAMEncoder.encodeJavaScript(type)%>';
			if(type != "Box"){
				window.opener.stateData["<%out.print(IAMEncoder.encodeJavaScript(request.getParameter("UNIQUEID")));//NO OUTPUTENCODING%>"]["VIEW_NAME"] = '<%out.print(IAMEncoder.encodeJavaScript(request.getParameter("UNIQUEID")));//NO OUTPUTENCODING%>' + '_PERSVIEW_' + <%out.print(WebClientUtil.getAccountId());//NO OUTPUTENCODING%>;<%--NO OUTPUTENCODING --%> 
//				window.opener.updateState(window.opener.ROOT_VIEW_ID,'_D_RP','PERSONALIZE=true');
				window.opener.tabSelected('<%=IAMEncoder.encodeJavaScript(request.getParameter("UNIQUEID"))%>', '<%=IAMEncoder.encodeJavaScript(count)%>',-1);
			}
			else{
				window.opener.refreshSubView('<%=IAMEncoder.encodeJavaScript(request.getParameter("UNIQUEID"))%>');
			}
			window.close();
			}
		</script>
		<%
                try
                {

		if(type != null && type.equals("Box")){
			TabPersonalizationUtil.addNewViewToGrid(request.getParameter("VIEWNAME"), WebClientUtil.getAccountId(), viewName);
		}else {
			String url = request.getSession().getServletContext().getInitParameter("TabUrl");
                                TabPersonalizationUtil.addNewTab(request.getParameter("VIEWNAME"), WebClientUtil.getAccountId(), viewName, url);

		}
                 %>
           	      <script>windowClose();</script>
                 <%
                }
                catch(Exception ex)
                {
                     %> 
                           <script>alert("Error : " + '<%out.print(ex.getMessage() );//NO OUTPUTENCODING%>');</script><%--NO OUTPUTENCODING --%>
	 	     <%
                }   
	}
%>
<link href="<%out.print(themeDir);//NO OUTPUTENCODING%>/styles/style.css" rel="stylesheet" type="text/css"><%--NO OUTPUTENCODING --%>
<table width="100%" cellpadding="0" cellspacing="0" class="logoBar" height="30">
  <tr>
    <td class="titleText">New <%=IAMEncoder.encodeHTML(type)%> Creation</td>
  </tr>
</table>
<script src='<%out.print(request.getContextPath());//NO OUTPUTENCODING%>/components/javascript/FormHandling.js' type='text/javascript'></script><%--NO OUTPUTENCODING --%>			
<script>
function validateData(formObj){
	if(isNotEmpty(formObj.NewViewName.value)){
		return true;		
	}
	alert("Please enter a name for new tab");
	return false;
}
</script>

<form method = "form" onSubmit="return validateData(this)">
	<input type = "hidden" name = "VIEWNAME"  value = '<%=IAMEncoder.encodeHTMLAttribute(request.getParameter("VIEWNAME"))%>'>
	<input type = "hidden" name = "UNIQUEID"  value = '<%=IAMEncoder.encodeHTMLAttribute(request.getParameter("UNIQUEID"))%>'>
	<input type = "hidden" name = "TYPE"  value = '<%=IAMEncoder.encodeHTMLAttribute(type)%>'>
	<input type = "hidden" name = "COUNT"  value = '<%=IAMEncoder.encodeHTMLAttribute(request.getParameter("COUNT"))%>'>
	<br>
	<table cellspacing = "0" cellpadding = "10" border = "0" width = "100%">
		<tr>
			<td nowrap > <%=IAMEncoder.encodeHTML(type)%> Name </td>
			<td> <input type = "text" name = "NewViewName" value = ""></td>
		</tr>
		<tr>
			<td colspan = "2" align = "center"> <input type = "submit" value = "Create" name = "AddNewTab"> </td>
		</tr>
	</table>	
</form>

