<%-- $Id$ --%>
<%@page import="com.adventnet.iam.internal.audit.IAMKafkaPartitioner"%>
<%
	String[] ip = request.getParameterValues("ips");
	if (ip != null) {
		String actionUrl = "internal/refreshKafkaAudit.jsp?action=clear&iscsignature="+com.adventnet.iam.security.SecurityUtil.sign(); //No I18N
		for (String i : ip) {
			i = i.trim();
			if (!i.contains(":")) {
				i += ":8080"; //No I18N
			}
			if (!i.endsWith("/")) {
				i += "/";//No I18N
			}
			response.getWriter().println(i + "::::" + com.adventnet.iam.internal.Util.getResponseAsProperties("http://" + i + actionUrl)); //NO OUTPUTENCODING //No I18N
			response.getWriter().println("<br>"); //No I18N //NO OUTPUTENCODING
		}
	} else {
		IAMKafkaPartitioner.refreshMessageRate();
		out.println("Producer Refreshed"); //No I18N
	}	
%>