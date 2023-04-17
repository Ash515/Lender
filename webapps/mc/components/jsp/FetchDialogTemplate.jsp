<%-- $Id$ --%>

<%@ page import="com.adventnet.client.tpl.TemplateAPI"%>
<%@page import="com.adventnet.iam.xss.IAMEncoder"%>
<%
String dialogBox = request.getParameter("dialogBoxType");
String okhandler = request.getParameter("okhandler");
String cancelhandler = request.getParameter("cancelhandler");
String prompthandler = request.getParameter("prompthandler");
String title = request.getParameter("title");
if(title == null)
{
	title = "&nbsp;";
}
if(okhandler == null)
{
	okhandler = "closeDialog";
}
if(cancelhandler == null)
{
	cancelhandler = "closeDialog";
}
if(prompthandler == null)
{
	prompthandler = "prompthandler";
}
out.println(TemplateAPI.givehtml(dialogBox+"_Prefix",null, new Object[][]{{"TITLE", IAMEncoder.encodeHTML(title)},{"PROMPTHANDLER", IAMEncoder.encodeHTML(prompthandler)}}));//NO OUTPUTENCODING
out.println(IAMEncoder.encodeHTML(request.getParameter("message")));
out.println(TemplateAPI.givehtml(dialogBox+"_Suffix",null,new Object[][]{{"OKHANDLER",  IAMEncoder.encodeHTML(okhandler)},{"CANCELHANDLER",  IAMEncoder.encodeHTML(cancelhandler)},{"PROMPTHANDLER", IAMEncoder.encodeHTML(prompthandler)}}));//NO OUTPUTENCODING
%>
