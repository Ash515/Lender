<%-- $Id$ --%>
<%@ page import = "java.util.*"%>

<%@ include file='/components/jsp/CommonIncludes.jspf'%>
<%@ include file='InitTableVariables.jspf'%>
<%@ include file="/components/jsp/table/IncludeFrmAndTblDec.jspf"%>
 <%@ include file='../rangenavigator/ListNavigateByPageX.jspf'%>
  <% String enableRowSelection = (String) viewModel.getTableViewConfigRow().get("ENABLEROWSELECTION");%>
  <tr>
    <td align="center" class="viewList"> <components:row viewContext="<%=viewContext%>" javaScriptRow = "true"><components:column viewContext="<%=viewContext%>"><components:cell viewContext="<%=viewContext%>">
      <% props = transformerContext.getRenderedAttributes();%>
      <table cellspacing='0' cellpadding='0' width='100%' id='LV<%out.print(transformerContext.getRowIndex());//NO OUTPUTENCODING%>' class='cursor viewNotSelected' onMouseDown="startDrag(event,'LV<%out.print(transformerContext.getRowIndex());//NO OUTPUTENCODING%>')" viewName='<%out.print(transformerContext.getAssociatedPropertyValue("ViewName"));//NO OUTPUTENCODING%>' title='<%out.print(props.get("VALUE"));//NO OUTPUTENCODING%>' desc='<%out.print(transformerContext.getAssociatedPropertyValue("Description"));//NO OUTPUTENCODING%>' onMouseOver='showDescription(this)' onMouseOut='hideDescription()'><%--NO OUTPUTENCODING --%>
	  	<tr>
        	<td class="smTopLeft">&nbsp;</td><td class="smTopBg"><button class="smDragButton" onClick='return false;'></button></td>
        	<td class="smTopRight">&nbsp;</td></tr>
        <tr>
			<td colspan="3" class="smContent"><%out.print(props.get("VALUE"));//NO OUTPUTENCODING%>&nbsp;</td><%--NO OUTPUTENCODING --%>
        </tr>
      </table>
      <br>
      </components:cell></components:column></components:row> </td>
  </tr>
<%@ include file="/components/jsp/table/EndFrmAndTblDec.jspf"%>
<%@ include file = "DisplayNoRowsMessage.jspf" %>
<script>disableSelectedViews(document);</script>

