<%-- $Id$ --%>
<%@page import="java.util.*,com.adventnet.client.*"%>
<%@page import="com.adventnet.client.view.web.*"%>
<%@ page import="com.adventnet.iam.xss.IAMEncoder" %>
<%
  ClientException ce = (ClientException)request.getAttribute("CLIENT_ERROR");
  ViewContext viewCtx = (ViewContext)ce.getErrorProperty("VIEWCONTEXT");
  ViewContext parentCtx = (ViewContext)ce.getErrorProperty("PARENTCONTEXT");
  ArrayList viewNames = new ArrayList();
  viewNames.add(parentCtx.getModel().getViewName());
  while(parentCtx.getParentContext() != null)
  {     
     parentCtx = parentCtx.getParentContext();
     viewNames.add(parentCtx.getModel().getViewName());
  }
  String viewName = viewCtx.getModel().getViewName();
%>

<table>
 <tr>
  <td rowspan="2"><img src="/themes/opmanager/images/warning_ico.gif"></img></td>
  <td><b>Recursive Layout Error</b></td>  
 </tr>
 <tr>
  <td>Wrong layout configuration. The same view <%= IAMEncoder.encodeHTML(viewName) %> has been added twice in the same layout
    heirarchy</td>
 </tr>  
 <tr>
  <td>The Errored View Heirarchy is 
    <ul>
     <% for(int i= viewNames.size() -1; i >=0; i--){ %>
          <li><%= IAMEncoder.encodeHTML((String)viewNames.get(i)) %> </li>
       <%}%>   
          <li><%= IAMEncoder.encodeHTML(viewName) %> </li>
     </ul>     
  </td>
 </tr>
</table>
