
<%
response.sendRedirect(request.getAttribute("redirectURL") != null ? (String) request.getAttribute("redirectURL") : "/");
%>