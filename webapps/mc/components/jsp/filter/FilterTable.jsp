<%-- $Id$ --%>
<%@ page import="com.adventnet.client.components.filter.web.*"%>
<%@ page import="com.adventnet.i18n.*"%>
<%@ page import="com.adventnet.clientcomponents.*"%>
<%@ page import="com.adventnet.client.view.web.WebViewAPI"%>
<%@ page import="com.adventnet.client.action.web.MenuVariablesGenerator"%>
<%@ page import="com.adventnet.client.properties.*" %>
<%@ page import="com.adventnet.client.components.table.template.FillTable"%>
<%@ page import="com.adventnet.client.properties.*"%>
<%@ include file='/components/jsp/CommonIncludes.jspf'%>
<%@ include file='/components/jsp/table/InitTableVariables.jspf'%>

<%if(!ClientProperties.useCompression){%>

<script src="<%out.print(request.getContextPath());//NO OUTPUTENCODING%>/components/javascript/Filter.js"></script><%--NO OUTPUTENCODING --%>

<%}%>

<%
        // Object secondFetch=viewContext.getStateParameter("_SF");
	FilterModel fm = (FilterModel)viewContext.getTransientState("FILTERMODEL");
 	Row filterRow = viewContext.getModel().getViewConfiguration().getRow(ACTABLEFILTERLISTREL.TABLE);
    String filterType = (String)filterRow.get(ACTABLEFILTERLISTREL.FILTERUITYPE_IDX);
 	boolean isLinkEnabled = "LEFT".equals(filterType);
 	String linkedViewName = (String)filterRow.get(ACTABLEFILTERLISTREL.LINKEDVIEWNAME_IDX);
 	boolean isCentreView = "CENTER".equals(filterType);
	viewContext.setURLStateParameter("linkedView",linkedViewName);
	
	String html="";
   	String templateViewName="";
   	if((viewModel.getTableViewConfigRow().get("TEMPLATEVIEWNAME"))!=null){
   		templateViewName=(String)(viewModel.getTableViewConfigRow().get("TEMPLATEVIEWNAME"));
   	}
   	boolean hideHeaderNavig=false;
   	int rowcount = tableModel.getRowCount();
   	if((((tableModel instanceof TableNavigatorModel) &&  rowcount<=0) && (((Boolean)(viewModel.getTableViewConfigRow().get("SHOWNAVIG")))).booleanValue()))
   	{
   		hideHeaderNavig=true;
   	}
   	if(((Boolean)(viewModel.getTableViewConfigRow().get("ENABLEEXPORT"))).booleanValue())
	{
	html=com.adventnet.client.tpl.TemplateAPI.givehtml("Table_Export",null,new Object[][] {{"VIEWNAME",viewContext.getUniqueId()}});
	}
	boolean ajaxTableUpdate=false;
	if(request.getParameter("ajaxTableUpdate")!=null)
	{
		if(request.getParameter("ajaxTableUpdate").equals("true"))
		{
			ajaxTableUpdate=true;
		}
	}	
	if(!hideHeaderNavig)
	{
	%>
	<%out.print(html);//NO OUTPUTENCODING%><%--NO OUTPUTENCODING --%>
	<%
	}
	%>
	
	
	<%if((!ajaxTableUpdate)&&(!(FillTable.tablehtmlmap.containsKey(viewContext.getUniqueId()))) && (!(FillTable.tablehtmlmap.containsKey(templateViewName))))
	{
	%>
	
	<table width="100%">
	<tr><td>

<%if(!isLinkEnabled && !isCentreView){%>
	<%=IAMEncoder.encodeHTML(I18N.getMsg("mc.components.filter.Filter"))%> :
	<%}%>
	
	<%if(!isCentreView){%>
	 <%@ include file='FilterCombo.jspf'%> 
	 <%}%>
	</td>
	
		<% String editDelete = (String)request.getAttribute("EDITDELETE");    
		   boolean bool =  ((Boolean)request.getAttribute("ISEDIT")).booleanValue();
           String controllerViewName =(String) request.getAttribute("controllerViewName");%>

<% if(bool && !("LEFT".equals(filterType))) {%>
<td>
<input type="button" name="EVENT_TYPE" <%out.print((fm.isEditable())?"":"disabled");//NO OUTPUTENCODING%> value="<%out.print(IAMEncoder.encodeHTMLAttribute(I18N.getMsg("mc.components.filter.Edit")));//NO OUTPUTENCODING%>"  onclick="createFilter('<%out.print(IAMEncoder.encodeJavaScript(uniqueId));//NO OUTPUTENCODING%>','Edit','<%out.print(fm.getListId());//NO OUTPUTENCODING%>','<%out.print(IAMEncoder.encodeJavaScript(fm.getSelectedFilter()));//NO OUTPUTENCODING%>','<%out.print(IAMEncoder.encodeJavaScript(controllerViewName));//NO OUTPUTENCODING%>');"/><%--NO OUTPUTENCODING --%>
</td>
<td>
<input type="button" name="EVENT_TYPE" <%out.print((fm.isDeleteable())?"":"disabled");//NO OUTPUTENCODING%> value="<%out.print(IAMEncoder.encodeHTMLAttribute(I18N.getMsg("mc.components.filter.Delete")));//NO OUTPUTENCODING%>" onclick="deleteFilter('<%out.print(IAMEncoder.encodeJavaScript(uniqueId));//NO OUTPUTENCODING%>','<%out.print(fm.getListId());//NO OUTPUTENCODING%>','<%out.print(IAMEncoder.encodeJavaScript(fm.getSelectedFilter()));//NO OUTPUTENCODING%>','<%out.print(IAMEncoder.encodeJavaScript(controllerViewName));//NO OUTPUTENCODING%>');"/><%--NO OUTPUTENCODING --%>
</td>
<td>
<input type="button" name="EVENT_TYPE" value="<%out.print(IAMEncoder.encodeHTMLAttribute(I18N.getMsg("mc.components.Create")));//NO OUTPUTENCODING%>" onclick="createFilter('<%out.print(IAMEncoder.encodeJavaScript(uniqueId));//NO OUTPUTENCODING%>','Add','<%out.print(fm.getListId());//NO OUTPUTENCODING%>','','<%out.print(IAMEncoder.encodeJavaScript(controllerViewName));//NO OUTPUTENCODING%>');"/><%--NO OUTPUTENCODING --%>
</td>
<%}%>
</tr>
	<tr>
		<td colspan="4"><%@ include file='/components/jsp/table/IncludeNavigation.jspf'%></td>
	
	</tr>
</table>

	
	<div style="display:none;width:100%" class="criteriaDiv" id="<%=IAMEncoder.encodeHTMLAttribute(uniqueId)%>_FILTERPOS"> </div>  

<%if(!hideHeaderNavig && !"LEFT".equals(filterType)){%>
<%@ include file='/components/jsp/table/DisplayMenu.jspf'%>
<%@ include file="/components/jsp/table/IncludeFrmAndTblDec.jspf"%>
<%@ include file = "/components/jsp/table/DisplayTableHorizontally.jspf" %>
<%@ include file="/components/jsp/table/EndFrmAndTblDec.jspf"%>
<%@ include file = "/components/jsp/table/DisplayNoRowsMessage.jspf" %>
<%if(WebClientUtil.isRequiredUrl(viewContext)){%>
        <%@ include file="/components/jsp/table/IncludeNavigation.jspf"%>
        <%}%>

		<%
	}
		else
		{%>
			<%@ include file = "/components/jsp/table/DisplayNoRowsMessage.jspf" %>
		<%
		}
	
		}
	
 else
	{
	 String controllerViewName =(String) request.getAttribute("controllerViewName");
	 
  %>
  <%@ include file = "/components/jsp/table/SearchCheck.jspf"%>
  <%  String Html="";
 	 if((!(FillTable.tablehtmlmap.containsKey(templateViewName))) || ((FillTable.tablehtmlmap.containsKey(viewContext.getUniqueId()))))
		{
		templateViewName="";
		}	
  	
  	
  %>  
   <div class="hide">
    <%@ include file='/components/jsp/table/DisplayMenu.jspf'%>
	</div>
 
 
  <%
 if(!hideHeaderNavig)
{ %>
 <%out.print(com.adventnet.client.components.table.template.GetModelGiveoutput.produceFilledHtmlOutput(viewModel,viewContext,pageContext,templateViewName,false));//NO OUTPUTENCODING%><%--NO OUTPUTENCODING --%>
 <%}else{ %>
 <%out.print(com.adventnet.client.components.table.template.GetModelGiveoutput.produceFilledHtmlOutput(viewModel,viewContext,pageContext,templateViewName,true));//NO OUTPUTENCODING%><%--NO OUTPUTENCODING --%>
 <%} %>
 <%@ include file = "/components/jsp/table/DisplayNoRowsMessage.jspf" %>
 <%
	boolean navigationPresent =  "true".equals(viewContext.getStateParameter("NAVIGATIONPRESENT"));
        if(!hideHeaderNavig && !navigationPresent){ %>
  <%@ include file="/components/jsp/table/IncludeNavigation.jspf"%>
  <%} %>
 <%
   }
 %>
   <%if(isScrollEnabled && !ajaxTableUpdate){%>
  <script defer>
   handleWidthOfScrollTable("<%=IAMEncoder.encodeJavaScript(uniqueId)%>","<%=colCount%>");
   addToOnLoadScripts("updateStatus",window,"<%=IAMEncoder.encodeJavaScript(uniqueId)%>","<%=IAMEncoder.encodeJavaScript((String)request.getAttribute("initialFetchedRows"))%>");
   <%if(isDynamicTable){%>
   clearWindowObjects("<%=IAMEncoder.encodeJavaScript(uniqueId)%>") ;
   handleDynamicTable("<%=IAMEncoder.encodeJavaScript(uniqueId)%>","<%=colCount%>",'<%=IAMEncoder.encodeJavaScript((String)request.getAttribute("initialFetchedRows"))%>');
   <%
   }%>
  </script>
  <%}%>	

