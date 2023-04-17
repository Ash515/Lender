<%-- $Id$ --%>
<%@ page import="com.adventnet.clientcomponents.*"%>
<%@ page import="com.adventnet.client.action.web.MenuVariablesGenerator"%>
<%@ page import="com.adventnet.client.components.table.template.FillTable"%>
<%@ include file='../CommonIncludes.jspf'%>
<%@ include file='InitTableVariables.jspf'%>
<%
   	String html="";
    Object secondFetch=viewContext.getStateParameter("_SF");
   	String templateViewName="";
   	if((viewModel.getTableViewConfigRow().get("TEMPLATEVIEWNAME"))!=null){
   		templateViewName=(String)(viewModel.getTableViewConfigRow().get("TEMPLATEVIEWNAME"));
   	}
   	boolean hideHeaderNavig=false;
   	int rowcount = tableModel.getRowCount();
   	boolean hide = (((Boolean)(viewModel.getTableViewConfigRow().get("SHOWNAVIG")))).booleanValue();
   	if((((tableModel instanceof TableNavigatorModel) &&  rowcount<=0) && hide))
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
 <% }%>   	

	<%if((!ajaxTableUpdate)&&(!(FillTable.tablehtmlmap.containsKey(viewContext.getUniqueId()))) && (!(FillTable.tablehtmlmap.containsKey(templateViewName))))
	{
		if(!hideHeaderNavig)
		{
		%>
	  		<%@ include file='DisplayMenu.jspf'%>
		  	<%if(WebClientUtil.isRequiredUrl(viewContext)){%>
	        	<%@ include file="/components/jsp/table/IncludeNavigation.jspf"%>
	        <%}%>
			<%@ include file="/components/jsp/table/IncludeFrmAndTblDec.jspf"%> 
			<% 
			String displayType = (String) viewModel.getTableViewConfigRow().get("DISPLAYTYPE");
	        if(displayType.equals("Horizontal")){
		  	%>
		    <%@ include file = "DisplayTableHorizontally.jspf" %>
		  	<%
	 		}
			 else if(displayType.equals("Vertical")){
			 %>
			      <%@ include file = "DisplayTableVertically.jspf" %>
			 <%
			}
			 else if(displayType.equals("PropertySheet")){
			 %>
			      <%@ include file = "DisplayTableAsRecords.jspf" %>
			 <%
			 }
			 %>
		  	<%@ include file="/components/jsp/table/EndFrmAndTblDec.jspf"%>
			<%if(!isScrollEnabled){ %>
		  		<%@ include file = "/components/jsp/table/DisplayNoRowsMessage.jspf" %>
		  	<%}
		  	if(WebClientUtil.isRequiredUrl(viewContext)){%>
		        <%@ include file="/components/jsp/table/IncludeNavigation.jspf"%>
		    <%}%>
			  <%
		}
		else if(!isScrollEnabled)
		{
			%>
			<%@ include file = "/components/jsp/table/DisplayNoRowsMessage.jspf" %>
			<%
		}
	}
	else if(!ajaxTableUpdate )
	{
		
  %>
  <%@ include file = "/components/jsp/table/SearchCheck.jspf"%>
  <%  boolean navigationPresent = true;
      String Html="";
 	 if((!(FillTable.tablehtmlmap.containsKey(templateViewName))) || ((FillTable.tablehtmlmap.containsKey(viewContext.getUniqueId()))))
		{
		templateViewName="";
		}	
  	Html=com.adventnet.client.components.table.template.GetModelGiveoutput.produceFilledHtmlOutput(viewModel,viewContext,pageContext,templateViewName,false);
  	navigationPresent =  "true".equals(viewContext.getStateParameter("NAVIGATIONPRESENT"));
  %>  
   <div class="hide">
    <%@ include file='DisplayMenu.jspf'%>
	</div>
  <%if(!navigationPresent){ %>
   
  <%@ include file="/components/jsp/table/IncludeNavigation.jspf"%>
  <%} 
if(!hideHeaderNavig)
{
%>
<%out.print(Html);//NO OUTPUTENCODING%><%--NO OUTPUTENCODING --%>
<%
}
%>
 <%@ include file = "/components/jsp/table/DisplayNoRowsMessage.jspf" %>
 <%if((!(navigationPresent))&& !hideHeaderNavig){ %>
  <%@ include file="/components/jsp/table/IncludeNavigation.jspf"%>
  <%}%>
 <%
   }
	else if(!"true".equals(secondFetch)) 
	{
		%><%@ include file="/components/jsp/table/AjaxUpdate.jspf"%><%
	}
	else
	{
		%><%@ include file = "DisplayTableHorizontally.jspf" %><%
	  	
	}
	
	if(isScrollEnabled && !ajaxTableUpdate){
		
 %>
  
  <script defer>
   handleWidthOfScrollTable("<%out.print(uniqueId);//NO OUTPUTENCODING%>","<%out.print(colCount);//NO OUTPUTENCODING%>");<%--NO OUTPUTENCODING --%>
   addToOnLoadScripts("updateStatus",window,"<%=IAMEncoder.encodeJavaScript(uniqueId)%>","<%=IAMEncoder.encodeJavaScript((String)request.getAttribute("initialFetchedRows"))%>");
   <%if(isDynamicTable){%>
   clearWindowObjects("<%out.print(uniqueId);//NO OUTPUTENCODING%>") ;<%--NO OUTPUTENCODING --%>
   handleDynamicTable("<%out.print(uniqueId);//NO OUTPUTENCODING%>","<%out.print(colCount);//NO OUTPUTENCODING%>",'<%out.print(IAMEncoder.encodeJavaScript((String)request.getAttribute("initialFetchedRows")));//NO OUTPUTENCODING%>');<%--NO OUTPUTENCODING --%>
   <%
   }%>
  </script>
<%}if(!("true".equals(request.getParameter("ajaxReplace")))){%>

<div id="<%out.print(uniqueId);//NO OUTPUTENCODING%>_hidden" class="hide"></div><%--NO OUTPUTENCODING --%>
<%}
if(request.getParameter("OpenRow")!=null)
{
	%> <script defer>invokeActionForACTable('<%=IAMEncoder.encodeJavaScript(viewContext.getUniqueId())%>','<%=IAMEncoder.encodeJavaScript(request.getParameter("OpenRow"))%>'); </script>
	<%
}
%>


