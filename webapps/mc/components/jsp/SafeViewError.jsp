<%-- $Id$ --%>
<%
	boolean isXMLHTTP = com.adventnet.client.view.web.WebViewAPI.isAjaxRequest(request);
%>

<%@ page import="org.apache.struts.*,org.apache.struts.action.*,java.util.*,org.apache.struts.util.*" %>
<%@ page import="java.io.*,javax.servlet.*" isErrorPage="true" %>
<%@page import="com.adventnet.client.themes.web.ThemesAPI"%>
<%@page import="com.adventnet.client.util.web.ExceptionUtils"%>
<%@ page import="com.adventnet.iam.xss.IAMEncoder" %>
<%
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
<%}%>
<table width="60%"  border="0" align="center" cellpadding="0" cellspacing="0" class="errorBg">
  <tr>
    <td><table width="100%"  border="0" cellspacing="0" cellpadding="4">
      <tr>
        <td rowspan="2" valign="top" class="errorImage">&nbsp;</td>
        <td nowrap class="errorTitle">Error Occurred ! </td>
      </tr>
      <tr>
        <td height="60" valign="top" class="errorContent">An error when processing the request... </td>
      </tr>
      <tr>
        <td valign="top">&nbsp;</td>
        <td align="right" nowrap><input type="button" name="Submit" value="&lt; Go Back" onClick="window.history.back()">
&nbsp;&nbsp;&nbsp;
&nbsp;</td>
      </tr>
    </table></td>
  </tr>
</table>

<%if(isXMLHTTP){%>
</div>
</div>
<%}%>

