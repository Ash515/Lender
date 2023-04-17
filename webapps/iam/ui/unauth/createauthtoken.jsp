<%--$Id$--%>
<%@page import="com.zoho.accounts.AppResourceProto.App"%>
<%@page import="com.zoho.accounts.internal.util.AppConfiguration"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="com.adventnet.iam.User"%>
<%@page import="com.adventnet.iam.IAMUtil"%>
<%@ include file="../../static/includes.jspf" %>
<!DOCTYPE html> <%-- No I18N --%>
<html>
<head>
</head>
<%
User user= IAMUtil.getCurrentUser();
String[] scopes = request.getParameterValues("SCOPE");
Map<String,List<String>> scopeMap = Util.geAuthtokenScopeDetails(scopes);
%>
<link rel="stylesheet" type="text/css" href="<%=cssurl_st%>/servicelogo.css"></link>
<style type="text/css">
@font-face {
    font-family: 'Open Sans';
    font-style: normal;
    font-weight: 600;
    src:url('<%=imgurl%>/opensanssemibold/font.eot'); <%-- NO OUTPUTENCODING --%>
    src:url('<%=imgurl%>/opensanssemibold/font.eot?#iefix') format('eot'), <%-- NO OUTPUTENCODING --%>
        url('<%=imgurl%>/opensanssemibold/font.woff2') format('woff2'), <%-- NO OUTPUTENCODING --%>
        url('<%=imgurl%>/opensanssemibold/font.woff') format('woff'),  <%-- NO OUTPUTENCODING --%>
        url('<%=imgurl%>/opensanssemibold/font.ttf') format('truetype'), <%-- NO OUTPUTENCODING --%>
        url('<%=imgurl%>/opensanssemibold/font.svg#OpenSans-Semibold') format('svg'); <%-- NO OUTPUTENCODING --%>
}
.authtoken {
	width: 100%;
	margin: 0 auto;
	text-align: center;
}
.errormsg {
    margin: 65px auto;
    display: inline-block;
}
</style>
<script src="<%=jsurl%>/jquery-1.12.2.min.js" type="text/javascript"></script><%-- NO OUTPUTENCODING --%>
<body>
<form action="<%=IAMEncoder.encodeHTMLAttribute(request.getContextPath())%>/apiauthtoken/create" method="post" >

	<div class="authtoken">
		<div class="logo"></div>
		<div class="authchild">
			<div class="authheader">
				<div class="headerchild">
					<%=Util.getI18NMsg(request,"IAM.AUTHTOKEN.CREATE.HEADER",IAMEncoder.encodeHTML(user.getDisplayName()))%>
				</div>
			</div>
			<div class="scopeerror">
					<div class="scopeerrormsg" ></div>
			</div>
			<%if(scopeMap == null ||scopeMap.isEmpty()){ %>
			<div class="commonerror">
					<div class="errormsg" >
						<div class="erroricon">
							<div class="error_x">x</div>
						</div>
						<div><%=Util.getI18NMsg(request,"IAM.AUTHTOKEN.INVALID.SCOPE")%></div>
				</div>
			</div>
			<% return;} %>
			<div class="authchild1">
			<%
			Iterator <String> scopeIterator = scopeMap.keySet().iterator();
			while(scopeIterator.hasNext()){
				String serviceName = scopeIterator.next();
				String actualserviceName = serviceName;
				Service appobj = IAMProxy.getInstance().getServiceAPI().getService(serviceName);
				if(appobj == null){
					appobj=Util.SERVICEAPI.getServiceByAliasName(serviceName);
					actualserviceName = appobj.getServiceName();
				}
				String displayName = (appobj != null) ? appobj.getDisplayName(): serviceName;
				String serviceclass="icon_"+actualserviceName.toLowerCase()+"_48px";//No I18N
				String retinaIcon = "icon_"+actualserviceName.toLowerCase()+"_48-2x";//No I18N
				List<String> scopeList = scopeMap.get(serviceName);
			%>
				<div class="servicecontainer">
				<div class="servicelogoparent">
					<div class="servicelogo <%=serviceclass%> defaultlogo retinalogo <%=retinaIcon%>"></div>
				</div>
					<div class="servicename"><%=IAMEncoder.encodeHTML(displayName)%></div>
				<% for(String scope: scopeList){ %>	
					<div class="servicescope" id="scopeid"><%=IAMEncoder.encodeHTML(scope)%></div>
				<%}%>
				</div>
			<%}%>
				</div>
			<div id="buttonholder">
				<div class="generatebtn" onclick="generateAuthToken()"><%=Util.getI18NMsg(request,"IAM.AUTHTOKEN.GENERATE")%></div>
			</div>
			<div id="tokenholder">
				<div style="text-align: left;margin-left: 40px;margin-bottom: 10px;ont-size: 14px;color: #232323;"><%=Util.getI18NMsg(request,"IAM.AUTHTOKEN")%></div>
				<div class="tokenval"></div>
			</div>
		</div>

	</div>
</form>
</body>

<script type="text/javascript">
var csrfParam = "<%=IAMEncoder.encodeJavaScript(SecurityUtil.getCSRFParamName(request))%>";
var csrfCookieName = "<%=IAMEncoder.encodeJavaScript(SecurityUtil.getCSRFCookieName(request))%>";
function generateAuthToken(){
	var hrefUrl = window.location.href;
	var scopes =hrefUrl.split("?")[1];
	$.ajax({
	      type: "POST",// No I18N
	      url: "<%=IAMEncoder.encodeJavaScript(request.getContextPath())%>/apiauthtoken/create",
	      data:scopes+"&"+getCSRFParamValue(),// No I18N
	      dataType : "json", // No I18N
	      success: function(data){
	    	if(data.status==false){
	    		$(".scopeerrormsg").html(data.error);// No I18N
	    		$(".scopeerror").show();// No I18N
	    	}else if(data.status==true){ 
	    		$(".tokenval").html(data.token);// No I18N
	    		$("#tokenholder").slideToggle("slow");// No I18N
	    		$("#buttonholder").hide();// No I18N
	    		document.getElementById("tokenholder").style.display="inline-block";// No I18N
	    	}else{
	    		$(".errordiv").html(data);// No I18N
	    	}
	      }
	   });
}
function getCSRFParamValue() {
	return csrfParam + "=" + euc(getCookie(csrfCookieName));
}
function getCookie(cookieName) {
	var nameEQ = cookieName + "=";
	var ca = document.cookie.split(';');
	for(var i=0;i < ca.length;i++) {
		var c = ca[i].trim();
		if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length,c.length);
	}
	return null;
}
function euc(i) {
	return encodeURIComponent(i);
}
</script>

</html>

