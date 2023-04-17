<%-- $Id$ --%>
<%@ include file='/components/jsp/CommonIncludes.jspf'%>
<%@ page import="java.util.*"%>
<%@ page import="com.adventnet.persistence.Row"%>
<%@ page import="com.adventnet.i18n.*"%>
<%@ page import="com.adventnet.client.tpl.*"%>

<link href='<%out.print(themeDir);//NO OUTPUTENCODING%>/styles/cvcriteria.css' rel='stylesheet' type='text/css'><%--NO OUTPUTENCODING --%>

<%String templateHTML = TemplateAPI.givehtml("CriteriaTemplates", null, new Object[][]{{"contains",I18N.getMsg("contains")},  
		{"doesn't contain", I18N.getMsg("doesn't contain")}, {"ends with", I18N.getMsg("ends with")},
		{"starts with", I18N.getMsg("starts with")}, {"is", I18N.getMsg("is")}, 
		{"isn't", I18N.getMsg("isn't")}, {"is higher than", I18N.getMsg("is higher than")}, 
		{"is lower than", I18N.getMsg("is lower than")}, {"is after", I18N.getMsg("is after")},
		{"is before", I18N.getMsg("is before")}, {"Yes", I18N.getMsg("Yes")}, {"No", I18N.getMsg("No")}, 
		{"True", I18N.getMsg("True")}, {"False", I18N.getMsg("False")},{"Context_Path",request.getContextPath()}});%>
<%out.print(templateHTML);//NO OUTPUTENCODING%><%--NO OUTPUTENCODING --%>

<%Row filterRow = (Row)request.getAttribute("FILTER");  %>
<script src="<%out.print(request.getContextPath());//NO OUTPUTENCODING%>/components/javascript/Criteria.js"></script><%--NO OUTPUTENCODING --%>
<script>

<%out.print(request.getAttribute("CRITERIA_DEFN"));//NO OUTPUTENCODING%><%--NO OUTPUTENCODING --%>
var crList = <%out.print(request.getAttribute("RELCRITERIALIST"));//NO OUTPUTENCODING%>;<%--NO OUTPUTENCODING --%>
cr.matchVal = <%out.print(request.getAttribute("LOGICALOP"));//NO OUTPUTENCODING%>;<%--NO OUTPUTENCODING --%>

</script>
<%
String row="";
Object dispalyName=(filterRow!=null)?filterRow.get("DISPLAYNAME"):"";
if(filterRow!=null)
{
row=(String)(filterRow.get("FILTERNAME"));
}
String html=com.adventnet.client.tpl.TemplateAPI.givehtml("FilterCreateForm",null,new Object[][] {{"UNIQUEID",uniqueId},
		{"VIEWNAME",request.getParameter("VIEWNAME")},{"EVENTTYPE",request.getParameter("EVENT_TYPE")},
		{"LISTID",request.getParameter("LISTID")},{"FILTERNAME",row},{"DISPLAYNAME",IAMEncoder.encodeHTML((String)dispalyName)}});
%>
<%out.print(html);//NO OUTPUTENCODING%><%--NO OUTPUTENCODING --%>


