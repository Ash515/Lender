<!-- $Id$ -->
<%@ include file="includes.jspf" %>
<%
Service service = Util.SERVICEAPI.getService(Util.getIAMServiceName());
String serviceurl = service != null ? service.getWebUrl() + service.getHomePage() : "/home"; //No I18N
%>
<script type="text/javascript">
var serviceurl = '<%=IAMEncoder.encodeJavaScript(serviceurl)%>';
function escapeServiceUrlHash(locationUrl) {
	var tmpserviceurl = serviceurl;
	try {
		if(locationUrl.indexOf('serviceurl=') !== -1) {
			var surl = decodeURIComponent(locationUrl.substring(locationUrl.indexOf('serviceurl=')+11));
			if(surl.indexOf('#') !== -1) {
        		if(surl.indexOf('&') !== -1) {
        			surl = surl.substr(0, surl.indexOf('&'));
        		}
        	}
        	serviceurl = surl;
        }
	}catch (e) {
        serviceurl = tmpserviceurl;
	}
}
window.onload = function() {
	var locationUrl = window.location.href;
	escapeServiceUrlHash(locationUrl);
	<%
	if (IAMUtil.getCurrentUser() == null) {
	%>
	var loginUrl = "<%=IAMEncoder.encodeJavaScript(Util.getIAMURL())%>/signin";
	var servicename = "<%=IAMEncoder.encodeJavaScript(Util.getIAMServiceName())%>";
	loginUrl += "?servicename=" + encodeURIComponent(servicename); //No I18N
	if(serviceurl && serviceurl !== '') {
		loginUrl += "&serviceurl="+ encodeURIComponent(serviceurl); //No I18N
	}
	window.parent.location.href = loginUrl;
	<%
	} else {
		response.sendRedirect(serviceurl);
	}
%>
}
</script>
