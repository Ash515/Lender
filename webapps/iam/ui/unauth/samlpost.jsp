<%-- $Id$ --%>
<%@page import="com.zoho.accounts.internal.util.ClientPortalUtil"%>
<%@ include file="../../static/includes.jspf" %>
<html>
<head></head>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
    <table width="100%" cellpadding="0" cellspacing="0">
    <%if(!ClientPortalUtil.isClientServer())  {%>
	<tr><td><%@ include file="header.jspf" %></td></tr>
	<%  } else {%>
	<tr><td><%=Util.getI18NMsg(request, "IAM.LOADING")%></td></tr>
	<%  } %>
	<tr><td align="center" style="visibility:hidden;">
<%
    String action = (String)request.getAttribute("ACTION");
    if("LOGOUT_REQUEST".equals(action)) {
%>
<form id="submitform" name="logoutpost" action="<%=IAMEncoder.encodeHTMLAttribute((String)request.getAttribute("LOGOUT_URL"))%>" method="post" enctype="application/x-www-form-urlencoded" >
        <textarea name="SAMLRequest"><%=IAMEncoder.encodeHTML((String)request.getAttribute("LOGOUT_REQUEST"))%></textarea>
        <input name="RelayState" type="hidden" value="<%=IAMEncoder.encodeHTMLAttribute((String)request.getAttribute("RELAY_STATE_URL"))%>" />
		<input type="submit" value="submit"/>
	    </form>
	    <script>
		window.onload = function() {
		    var form = document.getElementById("submitform");
		    form.submit();
		}
	    </script>
<%
    }
    else if("LOGOUT_RESPONSE".equals(action)) {
%>
	    <form id="submitform" name="logoutpost" action="<%=IAMEncoder.encodeHTMLAttribute((String)request.getAttribute("LOGOUT_URL"))%>" method="post" enctype="application/x-www-form-urlencoded" >
		<textarea name="SAMLResponse"><%=IAMEncoder.encodeHTML((String)request.getAttribute("LOGOUT_RESPONSE"))%></textarea>
		<input name="RelayState" type="hidden" value="<%=IAMEncoder.encodeHTMLAttribute((String)request.getAttribute("RELAY_STATE_URL"))%>" />
		<input type="submit" value="submit"/>
	    </form>
	    <script>
		window.onload = function() {
		    var form = document.getElementById("submitform");
		    form.submit();
		}
	    </script>
<%
    }
%>
	</td></tr>
    </table>
</body>
</html>
