<%-- $Id$ --%>
<%@page import="com.adventnet.iam.xss.IAMEncoder"%>
<SCRIPT language="javascript" src="<%out.print(request.getContextPath());//NO OUTPUTENCODING%>/components/javascript/Utils.js"></SCRIPT><%--NO OUTPUTENCODING --%>
<SCRIPT>
var paramsToPass = '<%=IAMEncoder.encodeJavaScript((String)request.getAttribute("ADDITIONAL_PARAMS"))%>';
</SCRIPT>
<body onload="reloadAndCloseWindow(paramsToPass)">
</body>

