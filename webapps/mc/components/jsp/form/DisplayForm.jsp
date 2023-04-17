<%-- $Id$ --%>
<%@ page import="com.adventnet.client.components.form.web.FormCreator"%>
<%@ include file='../CommonIncludes.jspf'%>
<div id="messageDiv"></div>
<%
	FormCreator formCreator = new FormCreator(viewContext, pageContext);
%>
<%out.print(formCreator.getFormUI());//NO OUTPUTENCODING%><%--NO OUTPUTENCODING --%>

<div id="customAlertMessage" class='hide'
	style="position: absolute; cursor: default;"></div>

