
<%-- $Id$--%>
<%
	String url = (String)request.getAttribute("url");
	String samlRequest = (String)request.getAttribute("SAMLRequest");
	String relayState = (String)request.getAttribute("RelayState");
	if(url == null || samlRequest == null || relayState ==null) {
		return;
	}
%>
<form method="post" action="<%=url%>" > <%-- NO OUTPUTENCODING --%>
   <input type="hidden" name="SAMLRequest" value="<%=samlRequest%>" /> <%-- NO OUTPUTENCODING --%>
   <input type="hidden" name="RelayState" value="<%=relayState%>" /> <%-- NO OUTPUTENCODING --%>
   <input type="submit" value="Submit" style="display: none;" />
 </form>
 
 <script>
window.onload = function () { document.forms[0].submit(); }
</script>