<%-- $Id$ --%>
<title>View Customization</title>
<%@ include file='/components/jsp/CommonIncludes.jspf'%>
<%@ include file='/framework/jsp/StatusMsg.jspf'%>
<%@ page import = "com.adventnet.client.components.util.web.*,com.adventnet.client.util.web.*,java.util.*,com.adventnet.persistence.*,com.adventnet.client.view.*"%>
<%@ page import = "com.adventnet.client.components.rangenavigator.web.NavigationConfig" %>
<%@ page import = "com.adventnet.client.view.web.WebViewAPI" %>
<%@ include file="GTIncludes.jspf" %>
<%
boolean isNewView = false;
String custView = request.getParameter("VIEWNAME");
if(custView == null){
	isNewView = true;
	custView = PersonalizationUtil.getFromReqOrFeatureParams(viewContext,"VIEWNAME");
}
%>
	<%@ include file='viewTemplates.html'%>
	<%@ include file='../table/InitTableVariables.jspf'%>
	<table width="100%" border="0" cellpadding="0" cellspacing="0" class="layoutArea">
	<tr>
		<td valign="top" nowrap><br>
			<%@ include file='HowToPers.jspf'%>
			<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="editAreaBorder">
				<tr>
					<td nowrap class="editAreaMenuBar">Grid Layout - <%=IAMEncoder.encodeHTML(custView)%> Page</td>
					<td align="right" class="editAreaMenuBar">&nbsp;</td>
				</tr>
				<tr>
					<td height="400px" colspan="2" class="editAreaBg" id='layoutDAC'>&nbsp;</td>
				</tr>
				<tr>
					<td class="editAreaMenuBar">&nbsp;</td>
					<td align="right" class="editAreaMenuBar">
						<form name="TableLayoutForm">
							<select name="selectedViewList" class="hide" multiple></select>
							<input type="hidden" name="VIEWNAME" value='<%=IAMEncoder.encodeHTMLAttribute(custView)%>'/>
							<input type = "hidden" name = "UNIQUEID"  value = '<%=IAMEncoder.encodeHTMLAttribute(request.getParameter("UNIQUEID"))%>'>
							<input type = "hidden" name = "ISNEWVIEW"  value = '<%out.print(isNewView);//NO OUTPUTENCODING%>'><%--NO OUTPUTENCODING --%>
							<input type = "hidden" name = "TITLE"  value = ''>
						</form>
						<br>
						<script>
							var currentViewNames = new Array();
						</script>
						<components:row>
							<components:column>
								<script>
								    <%
								     Object viewnameno = transformerContext.getAssociatedPropertyValue("ChildViewName");
								    %>
									currentViewNames[<%out.print(transformerContext.getRowIndex());//NO OUTPUTENCODING%>] = new Array('<%out.print(IAMEncoder.encodeJavaScript((String)WebViewAPI.getViewName(viewnameno)));//NO OUTPUTENCODING%>','<%out.print(IAMEncoder.encodeJavaScript((String)transformerContext.getAssociatedPropertyValue("Title")));//NO OUTPUTENCODING%>','<%out.print(IAMEncoder.encodeJavaScript((String)transformerContext.getAssociatedPropertyValue("Description")));//NO OUTPUTENCODING%>');<%--NO OUTPUTENCODING --%>
								</script>
							</components:column>
						</components:row>
						<script>
							var data = initLayout(currentViewNames, 'layoutDAC', 'Grid');
						</script>
					</td>
				</tr>
			</table>
			<table align='center'><tr><td align='center'><br>
                                        <%@ include file='RestoreFrm.jspf'%>
				</td>
				<td>
					<br>
               	<%@ include file='CntrlBtns.jspf'%>

			</td></tr></table>
		</td>
		<%@ include file='RightBar.jspf'%>
	</tr>
</table>

<div id="movableDiv" class='hide' style="width:250px;background-color:transparent; position: absolute; cursor: default;filter:alpha(opacity=25);-moz-opacity:0.5;opacity: 0.5;">
	<table cellspacing='0' cellpadding='0' width='250px'>
		<tr>
			<td class="smTopLeft">&nbsp;</td>
			<td  class="smTopBg">&nbsp;</td>
			<td class="smTopRight">&nbsp;</td>
		</tr>
		<tr>
			<td colspan="3" class="smContent" id='movableDivContent'></td>
		</tr>
	</table>
</div>	


