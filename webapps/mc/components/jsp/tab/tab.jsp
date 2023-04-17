<%-- $Id$ --%>
<%@ include file='../CommonIncludes.jspf'%>
<%@ page import="com.adventnet.client.components.tab.web.*" %>
<%@ page import = "com.adventnet.client.components.util.web.*"%>
<%@ page import = "java.util.*"%>
<%@ page import = "com.adventnet.client.components.table.template.*"%>
<%@ page import = "com.adventnet.client.view.web.*"%>

<%
  TabModel model = (TabModel)viewContext.getViewModel();
  TabModel.TabIterator ite = model.getIterator();
  String ctxPath = ((HttpServletRequest)pageContext.getRequest()).getContextPath();
  HttpServletRequest req=(HttpServletRequest)pageContext.getRequest();
  boolean isVerticalTab=false;
  String  selectedIndex="";
  if(model.getViewType().equals("verticaltab")|| model.getViewType().equals("droptab")){
	  isVerticalTab=true;
  }
  boolean isAjax=false;
  boolean isAjaxAndBackSupport=false;
  int refreshLevel=0;
  refreshLevel=(Integer)request.getAttribute("refreshLevel");
  if(refreshLevel==-3)
  {
	  isAjax=true;
  }
  if(refreshLevel==-4)
  {
	  isAjaxAndBackSupport=true;
  
%>
<script type="text/javascript">

  Event.observe(window, "load", function(event) {new app()});
</script>



<%
  }
if(!(FillTable.tabhtmlmap.containsKey(viewContext.getUniqueId()))) {%>
	<table cellspacing=0 cellpadding=0 border=0 width="100%">
		<tr>
		<% if(model.getChildConfigList().size() > 0){ %>
		<td>
           	<ul class=<%=IAMEncoder.encodeHTMLAttribute(model.getViewType())%>>
		<%  while(ite.next()) {       
			if((ite.getCurrentClass().indexOf("notSelected"))==-1)
			{
				selectedIndex=ite.getCurrentIndex();
			}
		%>
         		<li class='<%out.print(((ite.getTabAction()!=null)?"":"drop ") );//NO OUTPUTENCODING%>notselected' cref='<%out.print(IAMEncoder.encodeHTMLAttribute(ite.getCurrentRefId()));//NO OUTPUTENCODING%>' tabid="<%out.print(IAMEncoder.encodeHTMLAttribute(viewContext.getReferenceId())+"t"+IAMEncoder.encodeHTMLAttribute(ite.getCurrentIndex()));//NO OUTPUTENCODING%>" <%--NO OUTPUTENCODING --%>      
         	    <%if(model.getViewType().equals("droptab")){ %>
         		 onmouseover="changeClass(this,'<%=IAMEncoder.encodeJavaScript(viewContext.getUniqueId())%>')" onmouseout="replaceClass(this,'<%=IAMEncoder.encodeJavaScript(viewContext.getUniqueId())%>')"
         		 <%} %>
      
         		  >
                          <%if(ite.getTabAction()!=null){ %>
                          <a viewName='<%=IAMEncoder.encodeHTMLAttribute(viewContext.getUniqueId()) %>'   id='<%=IAMEncoder.encodeHTMLAttribute(viewContext.getUniqueId())+"_"+IAMEncoder.encodeHTMLAttribute(ite.getCurrentIndex())%>' index='<%=IAMEncoder.encodeHTMLAttribute(ite.getCurrentIndex()) %>'
                          <%if(isAjaxAndBackSupport){%>
                          onfocus='registerTabEvent("<%=IAMEncoder.encodeJavaScript(viewContext.getReferenceId())%>",<%=IAMEncoder.encodeJavaScript(ite.getCurrentIndex())%>,"<%=IAMEncoder.encodeJavaScript(viewContext.getUniqueId()) %>")'
            			onmouseover='registerTabEvent("<%=IAMEncoder.encodeJavaScript(viewContext.getReferenceId())%>",<%=IAMEncoder.encodeJavaScript(ite.getCurrentIndex())%>,"<%=IAMEncoder.encodeJavaScript(viewContext.getUniqueId()) %>")'
                          href='javascript:void(0)'
                           >
                          <%}else {%>
                          href='<%out.print(ite.getTabAction());//NO OUTPUTENCODING%>' ><%--NO OUTPUTENCODING --%>
                          <%} }
                      
                          
		 	    String icoFile = ite.getChildIconFile(); if(icoFile != null) { %>
          			<img src='<%= IAMEncoder.encodeHTMLAttribute(icoFile)%>'/>
        		     <%}
        		      %>
        		      
          		     <%if(!model.getViewType().equals("icontab")){%><%=IAMEncoder.encodeHTML(ite.getTitle())%><%}%> </a>
			
			<%if(ite.dropDownExists()){
				if(ite.isButtonDropDown())
				{
			%>
			<input id='<%out.print(viewContext.getUniqueId()+"_dropbutton_"+ite.getCurrentIndex());//NO OUTPUTENCODING%>'index='<%out.print(ite.getCurrentIndex() );//NO OUTPUTENCODING%>' viewName='<%out.print(viewContext.getUniqueId() );//NO OUTPUTENCODING%>' class=<%out.print(isVerticalTab?"dropDownTabVerticalButton" :"dropDownTabButton");//NO OUTPUTENCODING%>></input><%--NO OUTPUTENCODING --%>
			
			<%} %>
			<script>addToOnLoadScripts("<%out.print(ite.handleDropDowns());//NO OUTPUTENCODING%>",window);<%out.print(ite.handleFeatureParams());//NO OUTPUTENCODING%></script> <%--NO OUTPUTENCODING --%>
			<%
			}
			if(ite.isMenuDropDown()){
			String menuid=ite.getMenuId();
			%>
				
			<div style="display:none" id="<%out.print(viewContext.getUniqueId()+"_div_hide_"+ite.getCurrentIndex());//NO OUTPUTENCODING%>"><%--NO OUTPUTENCODING --%> 
			
			 <act:ShowMenuAsDropDown menuId='<%=IAMEncoder.encodeHTMLAttribute(ite.getMenuId()) %>' contentOnly="true"/>
			
			</div>
			<%}
			%>
			</li>
		
		<%}%>
		</ul>
	
		</td>
                <%@ include file="TabVertPersLink.jspf" %>
                <% } else {%>
                    <%@ include file="EmptyTabPers.jspf"%>
                <%}%>
		</tr>
	</table>	
	<%}	
	else
		{
	
		String tabHtml="";
		tabHtml=com.adventnet.client.components.table.template.GetModelGiveoutput.getFilledTabHtml(viewContext);
		%>
		<%out.print(tabHtml );//NO OUTPUTENCODING%><%--NO OUTPUTENCODING --%>
		<%} %>

<%@ include file="TabPersLink.jspf" %> 
 <%if(isAjaxAndBackSupport && !(WebViewAPI.isAjaxRequest(req))){%>
 <script>
 window["AjaxBackSupport"]=true;
 </script>
 <%} else if(isAjaxAndBackSupport){%>
 <script defer>addToURLHash('<%out.print(IAMEncoder.encodeJavaScript(selectedIndex));//NO OUTPUTENCODING%>','<%out.print(viewContext.getReferenceId() );//NO OUTPUTENCODING%>');</script><%--NO OUTPUTENCODING --%>
 <%} else{%>
 <script>window["AjaxBackSupport"]=false;</script>
 
 <%} %>
<script defer><%out.print(model.getTabSelectionJS());//NO OUTPUTENCODING%></script><%--NO OUTPUTENCODING --%>

 

