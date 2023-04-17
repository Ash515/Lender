<!-- $Id$ -->
<%@ include file='/components/jsp/CommonIncludes.jspf'%>
<%@ page import="com.adventnet.client.components.chart.web.ChartConstants" %><% String imgFile = (String)viewContext.getViewModel(); String imMap = (String)viewContext.getTransientState(ChartConstants.IMAGE_MAP); if(imMap != null) {%>
<%@ include file='/components/jsp/chart/toolTip.jspf'%>
<%=IAMEncoder.encodeHTML(imMap)%>
<img src="<%out.print(request.getContextPath());//NO OUTPUTENCODING%>/test.chart?filename=<%out.print(imgFile);//NO OUTPUTENCODING%>" border="0" USEMAP="#<%out.print(imgFile);//NO OUTPUTENCODING%>" /><%--NO OUTPUTENCODING --%>

<% } else {%>
<img src="<%out.print(request.getContextPath());//NO OUTPUTENCODING%>/test.chart?filename=<%out.print(imgFile);//NO OUTPUTENCODING%>" border="0"/><%--NO OUTPUTENCODING --%>
<% }%>

