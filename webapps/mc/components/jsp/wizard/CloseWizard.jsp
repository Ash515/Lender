<%-- $Id$ --%>
<%@page import="com.adventnet.iam.xss.IAMEncoder"%>
<script src='<%out.print(request.getContextPath());//NO OUTPUTENCODING%>/components/javascript/Utils.js'></script><%--NO OUTPUTENCODING --%>
<script>
var WIZARD_FINISH=true;
var paramsToPass = '<%=IAMEncoder.encodeJavaScript((String)request.getAttribute("ADDITIONAL_PARAMS"))%>';

if("<%=IAMEncoder.encodeJavaScript(request.getParameter("WINDOWTYPE"))%>" == "STANDALONE")
{
   reloadAndCloseWindow(paramsToPass);
}
else
{
   popContentArea(-1,null);
}
</script>
