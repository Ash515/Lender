<%-- $Id$ --%>
<%@ include file='../CommonIncludes.jspf'%>
<%@ taglib uri = "http://www.adventnet.com/webclient/clientcomponents" prefix="cc" %>
<%@ page import = "com.adventnet.client.components.layout.table.web.*"%>
<%@ page import = "com.adventnet.clientcomponents.*"%>
<%@ page import = "com.adventnet.client.view.web.WebViewAPI"%>
<%@ page import = "com.adventnet.client.components.util.web.PersonalizationUtil"%>
<%@ page import="com.adventnet.iam.xss.IAMEncoder" %>
<%
  TableLayoutModel model = (TableLayoutModel)viewContext.getViewModel();
  TableLayoutModel.TableLayoutIterator iter = model.getIterator();
%>

  <%@ include file='TableLayoutCustomizationLink.jspf'%>
     <table cellspacing="5" cellpadding="0" class="tableLayout">
        <%int count=0;while(iter.next()){%>
        <%if(iter.isRowStart()){ %> <tr> <%}%>
           <td colspan='<%out.print(iter.get(ACTABLELAYOUTCHILDCONFIG.COLSPAN_IDX));//NO OUTPUTENCODING%>' rowspan='<%out.print(iter.get(ACTABLELAYOUTCHILDCONFIG.ROWSPAN_IDX));//NO OUTPUTENCODING%>' width='<%out.print(iter.get(ACTABLELAYOUTCHILDCONFIG.WIDTH_IDX));//NO OUTPUTENCODING%>' height='<%out.print(iter.get(ACTABLELAYOUTCHILDCONFIG.HEIGHT_IDX));//NO OUTPUTENCODING%>' class='tableLayoutCell' valign="top"><%--NO OUTPUTENCODING --%>
		<client:showView viewName="<%=IAMEncoder.encodeHTMLAttribute(WebViewAPI.getViewName((Long)iter.get(ACTABLELAYOUTCHILDCONFIG.CHILDVIEWNAME_IDX)))%>"/> 
	</td>
        <%if(iter.isRowEnd()){%> </tr> <%}count++;%><%--NO OUTPUTENCODING --%>
        <%}%>
	</table>

