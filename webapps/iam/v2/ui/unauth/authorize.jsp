<%--$Id$--%>
<!DOCTYPE html>	<%--No I18N--%>
<%@page import="java.net.IDN"%>
<%@page import="com.adventnet.iam.CryptoUtil"%>
<%@page import="java.util.logging.Level"%>
<%@page import="java.util.logging.Logger"%>
<%@page import="java.util.regex.Pattern"%>
<%@ include file="../static/includes.jspf"%>
<%!
private static final Logger LOGGER = Logger.getLogger("ui.unauth.authorize.jsp"); //No I18N
%>
<html>
<head>
<title><%=Util.getI18NMsg(request,"IAM.ZOHO.ACCOUNTS")%></title>

<script src="<%=tpkgurl%>/jquery-3_5_1.min.js"></script>
<script src="<%=jsurl%>/common_unauth.js"></script>
<script src="<%=jsurl%>/zresource.js" type="text/javascript"></script> <%-- NO OUTPUTENCODING --%>
<script src="<%=jsurl%>/uri.js" type="text/javascript"></script> <%-- NO OUTPUTENCODING --%>
<script src="<%=jsurl%>/init.js" type="text/javascript"></script>  <%-- NO OUTPUTENCODING --%>
<link href="<%=cssurl%>/accountUnauthStyle.css" rel="stylesheet"
	type="text/css">


<meta name="viewport"
	content="width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=no" />


<%
	String serviceurl = request.getParameter("serviceurl");
    if(IAMUtil.isTrustedDomain(IAMUtil.getCurrentUser().getZUID(), serviceurl)){
    	response.sendRedirect(serviceurl);
        return;
    }
    //by standard ascii only is accepted for the domain names so displaying it in asci characters.
    String thirdpartysite = serviceurl != null? IDN.toASCII(IAMUtil.getDomain(serviceurl)) : "";
%>
<script>
	    	function redirectpage()
	    	{
	         	window.parent.location.href = "<%=request.getContextPath()%>/logout"; <%-- NO OUTPUTENCODING --%>
	    	}
	        
	    	function approverequest() 
	        {
	            var service_url = "<%=IAMEncoder.encodeJavaScript(serviceurl)%>";
	            var service_name = "<%=IAMEncoder.encodeJavaScript(request.getParameter("servicename"))%>";
	            var atd_val = $("#trust_check").is(":checked"); //No I18N
	            var parms = 
	    		{
	    			"serviceurl":service_url,		//No I18N
	    			"servicename":service_name,	//No I18N
	    			"atd":atd_val //No I18N
	    		}; 
	            var payload = TrustedDomain.create(parms);
	    		payload.POST("self","self").then(function(resp)	//No I18N
	    		{
	    			if(resp.trusteddomain.redirect_uri)
	        		{
	        			window.location=resp.trusteddomain.redirect_uri;
	        			return false;
	        		}
	    			window.location.href=window.location.origin;
	    		},
	    		function(resp)
	    		{
	    			showErrMsg(resp.localized_message?resp.localized_message:resp.message);
	    		});

	        }
		
		</script>

</head>
<body>
	<div class="authorize_bg"></div>
	<div id="error_space">
		<div class="top_div">
			<span class="cross_mark"> <span class="crossline1"></span> <span
				class="crossline2"></span>
			</span> <span class="top_msg"></span>
		</div>
	</div>
	<div style="overflow: auto">
		
		<div class="container">
			<div id="header">
				<img class="zoho_logo" src="<%=imgurl%>/zoho.png">
			</div>

			<div class="wrap">
				<div class="info">
					<div class="head_text"><%=Util.getI18NMsg(request, "IAM.ACCESS.REQUEST")%></div>
					<div class="normal_text"><%=Util.getI18NMsg(request, "IAM.THIRDPARTY.AUTHORIZE.TEXT1", IAMEncoder.encodeHTML(thirdpartysite))%></div>
				</div>
				<div class="authorize_check">
					<input type="checkbox" class="trust_check" id="trust_check" name="vehicle1"> <span
						class="auth_checkbox"> <span class="checkbox_tick"></span>
					</span> <label for="trust_check"><%=Util.getI18NMsg(request, "IAM.TFA.TRUST.SITE")%></label>
				</div>
				<div class="check_note"><%=Util.getI18NMsg(request, "IAM.AUTHORIZED.REVOKE.NOTE", IAMEncoder.encodeHTML(cPath+"/home#setting/authorizedsites"))%></div>


				<button class="btn green_btn"
					onclick="approverequest()"><%=Util.getI18NMsg(request,"IAM.THIRDPARTY.GRANT.ACCESS")%></button>


				<button class="btn" onclick='redirectpage();'><%=Util.getI18NMsg(request,"IAM.THIRDPARTY.DENY.ACCESS")%></button>


				<div class="notes">
					<b><%=Util.getI18NMsg(request, "IAM.NOTE.WARN")%>:</b>
					<ul>
						<li><div class="notes_list_text"><%=Util.getI18NMsg(request, "IAM.AUTHORIZE.PRIVACY.TEXT", IAMEncoder.encodeHTML(thirdpartysite) , IAMEncoder.encodeHTML(Util.getI18NMsg(request,"IAM.LINK.PRIVACY")))%></div></li>
					</ul>
				</div>

			</div>

		</div>
	</div>
	<footer id="footer"> <%--No I18N--%>
		<%@ include file="../unauth/footer.jspf"%>
	</footer> <%--No I18N--%>
</body>
<script>
window.onload=function() {

	try {
		URI.options.contextpath="<%=request.getContextPath()%>/webclient/v1";//No I18N
		URI.options.csrfParam = '<%=SecurityUtil.getCSRFParamName(request)%>'; //NO OUTPUTENCODING
		URI.options.csrfValue = '<%=SecurityUtil.getCSRFCookie(request)%>'; //NO OUTPUTENCODING
	}catch(e){}
}

</script>
</html>