<%-- $Id$ --%>
<%
	boolean isXMLHTTP = com.adventnet.client.view.web.WebViewAPI.isAjaxRequest(request);
%>

<%@ page import="org.apache.struts.*,org.apache.struts.action.*,java.util.*,org.apache.struts.util.*" %>
<%@ page import="java.io.*,javax.servlet.*" isErrorPage="true" %>
<%@page import="com.adventnet.client.themes.web.ThemesAPI"%>
<%@page import="com.adventnet.client.util.web.ExceptionUtils"%>
<%@page import="com.adventnet.client.tpl.TemplateAPI"%>
<%@ page import="com.adventnet.iam.xss.IAMEncoder"%>
<%
try{
	String themesDir = ThemesAPI.getThemeDirForRequest(request);
if(!isXMLHTTP){

%>
<html>
<head>
   <link href="<%out.print(themesDir);//NO OUTPUTENCODING%>/styles/style.css" rel="stylesheet" type="text/css"/><%--NO OUTPUTENCODING --%>
   <script src='<%out.print(request.getContextPath());//NO OUTPUTENCODING%>/framework/javascript/IncludeJS.js' type='text/javascript'></script><%--NO OUTPUTENCODING --%>
   <script>includeMainScripts('<%out.print(request.getContextPath());//NO OUTPUTENCODING%>');</script><%--NO OUTPUTENCODING --%>
</head>
<%}%>
 <SCRIPT src='<%out.print(request.getContextPath());//NO OUTPUTENCODING%>/components/javascript/error.js'></SCRIPT><%--NO OUTPUTENCODING --%>
<%if(isXMLHTTP){%>
<div part="RESPONSE_STATUS" style="display:none">__ERROR__PAGE</div>
<div part="STATUS_MESSAGE">
An error when processing the request.... <a
href="javascript:showCompError();">Click Here</a> for more Details
<div id="completeErrorDiv" class="hide">	
<%
out.println(TemplateAPI.givehtml("DialogBox1_Prefix",null,new Object[][]{{"TITLE","Error"}}));//NO OUTPUTENCODING%>
<%}%>
		<!-- start template -->	
		<%
		out.println(TemplateAPI.givehtml("ErrorDialog_Prefix",null,new Object[][]{}));//NO OUTPUTENCODING%>
       <div id="StackTrace" style="overflow:auto;">
         <table>
          <% initErrorListing(request,response,exception); %>
          <% while(base != null){ %>
        <tr>
           <td>
              caused by
           </td>
        </tr>
        <tr> 
           <td>
             <a href="javascript:hideShowError('<%out.print(counter);//NO OUTPUTENCODING%>')"><%--NO OUTPUTENCODING --%>
                 <img id="bullet<%out.print(counter);//NO OUTPUTENCODING%>" width="8" height="8" border="0" src="<%out.print(request.getContextPath());//NO OUTPUTENCODING%>/themes/common/images/arrow_up.png"></img><%--NO OUTPUTENCODING --%>
                  <%out.print(IAMEncoder.encodeHTML(base.toString())); %>
             </a>
           </td>
           </tr>
           <tr  id="exception<%out.print(counter);//NO OUTPUTENCODING%>" class="hide"><%--NO OUTPUTENCODING --%>
             <td>
                <%out.print( ExceptionUtils.getStackTrace(base));//NO OUTPUTENCODING%><%--NO OUTPUTENCODING --%>
             </td>
           </tr>
           
        <% nextException();}%>
         
         </table>
        </div>
        <%
		out.println(TemplateAPI.givehtml("ErrorDialog_Suffix",null,new Object[][]{}));//NO OUTPUTENCODING
        %>
       
		<!--  end template -->

<%if(isXMLHTTP){
	out.println(TemplateAPI.givehtml("DialogBox1_Suffix",null,new Object[][]{}));//NO OUTPUTENCODING
%>
</div>
</div>
<%}%>

<%
}
catch(Exception ex){
	ex.printStackTrace();
}
%>


<%!
  Throwable base;
  int counter=0;
  public void initErrorListing(HttpServletRequest request,HttpServletResponse
  resp,Throwable exception)
  {
       base = exception;
       if(base == null)
       {
           base  = (Throwable)request.getAttribute(Globals.EXCEPTION_KEY);
       } 
  }
  

  public void nextException()
  {
    base = ExceptionUtils.getCause(base);        
    counter++;
  }

%>

