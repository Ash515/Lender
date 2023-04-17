
<%@page import="com.zoho.accounts.internal.util.Util"%>
<%@page import="com.opensymphony.xwork2.ActionContext"%>

<%
String red_url = (String) ActionContext.getContext().get("red_url"); //No I18N
if(Util.isValid(red_url)) {
	response.sendRedirect(red_url);
	return;
}
	String url = (String) ActionContext.getContext().get("url"); //No I18N
	String SAMLResponse = (String)ActionContext.getContext().get("SAMLResponse"); //No I18N
	String relayState = (String)ActionContext.getContext().get("RelayState"); //No I18N
	if(url == null || SAMLResponse == null) {
		return;
	}
%>
<form method="post" action="<%=url%>" > <%-- NO OUTPUTENCODING --%>
   <input type="hidden" name="SAMLResponse" value="<%=SAMLResponse%>" /> <%-- NO OUTPUTENCODING --%>
   <%if(relayState != null) { %>
   <input type="hidden" name="RelayState" value="<%=relayState%>" /> <%-- NO OUTPUTENCODING --%>
   <%} %>
   <input type="submit" value="Submit" style="display: none;" />
 </form>
 
 <script>
window.onload = function () { document.forms[0].submit(); }
</script>
