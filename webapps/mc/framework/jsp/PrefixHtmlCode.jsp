<%-- $Id$ --%>
<%@page import="com.adventnet.client.view.web.ViewContext" %>
<%@page import="com.adventnet.client.properties.ClientProperties" %>
<%@ page import="com.adventnet.iam.xss.IAMEncoder" %>
<%@ page import="com.adventnet.client.themes.web.ThemesAPI" %>
<%
response.setContentType("text/html;charset=utf-8");
response.setCharacterEncoding("UTF-8");
request.setCharacterEncoding("UTF-8");

String csspath = System.getProperty("css.path", ""+ThemesAPI.getThemeDirForRequest(request));
String jspath = System.getProperty("js.path", request.getContextPath());
String contextpath=request.getContextPath();
String staticpath = System.getProperty("static.path", contextpath);
ViewContext vc=(ViewContext)(request.getAttribute("ROOT_VIEW_CTX"));
%>

<%if(System.getProperty("use.compression") == null){%> 

<%if(((String)(request.getAttribute("SUBREQUEST"))).equals("false")){%> 
<html><head>
<link href='<%out.print(csspath);//NO OUTPUTENCODING%>/styles/style.css' rel='stylesheet' type='text/css'><%--NO OUTPUTENCODING --%>
<script src="<%out.print(jspath);//NO OUTPUTENCODING%>/framework/javascript/IncludeJS.js" type='text/javascript'></script><%--NO OUTPUTENCODING --%>
<script>includeMainScripts("<%out.print(contextpath);//NO OUTPUTENCODING%>");</script></head><%--NO OUTPUTENCODING --%>
<%}%>
<%}else{%>

<%if(((String)(request.getAttribute("SUBREQUEST"))).equals("false")){%> 
<html><head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%=IAMEncoder.encodeHTML((String)request.getAttribute("cssSnippet"))%>
<%=IAMEncoder.encodeHTML((String)request.getAttribute("jsSnippet"))%></head>
<%}%>
<%}%>

<%if(request.getUserPrincipal() == null){%>
<script>_GEN_ISUSER_CREDENTIAL_PRESENT=false</script>
<%}else{%>
<script>_GEN_ISUSER_CREDENTIAL_PRESENT=true</script>
<%}%>
<%if(((String)(request.getAttribute("SUBREQUEST"))).equals("false")){%>
<title><%out.print((vc).getTitle());//NO OUTPUTENCODING%></title><body><%--NO OUTPUTENCODING --%>
<iframe class='responseframe' src='<%out.print(staticpath);//NO OUTPUTENCODING%>/framework/html/blank.html'  name='<%out.print((vc).getUniqueId());//NO OUTPUTENCODING%>_RESPONSEFRAME' onsuccessfunc='updateView' onLoad='AjaxAPI.handleIframeResponse(this)'></iframe><%--NO OUTPUTENCODING --%>
<%}%>







