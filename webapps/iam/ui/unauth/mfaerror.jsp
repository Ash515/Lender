<%--$Id$--%>
<%@page import="com.adventnet.iam.xss.IAMEncoder"%>
<%@page import="com.adventnet.iam.internal.Util"%>
<%@ include file="../../static/includes.jspf" %>
    
<%
String serviceName = request.getParameter("servicename");
String redirectUrl = Util.getBackToURL(serviceName, null);
boolean isLocked = Boolean.parseBoolean(request.getParameter("lockapp"));
boolean isMobile = Util.isMobileUserAgent(request); //No I18N\
String css_url = isMobile ? cssurl_st+"/newmobilelogin.css" : cssurl+"/style.css"; //No I18N
boolean iscss = request.getParameter("css") != null && Util.isTrustedCSSDomain(request.getParameter("css"));
String customisedCSSUrl = iscss ? request.getParameter("css") : null;
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
 <head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
     <%if(isMobile){ %>
    	<meta name="viewport" content="width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=no" />
    <%} %>
	<title><%=Util.getI18NMsg(request,"IAM.ZOHO.ACCOUNTS")%></title>
<%if(iscss) { %>
		<link href="<%=IAMEncoder.encodeHTMLAttribute(customisedCSSUrl)%>" type="text/css" rel="stylesheet" /> <%-- NO OUTPUTENCODING --%>
<%}else {%>
		<link href="<%=IAMEncoder.encodeHTMLAttribute(css_url)%>" type="text/css" rel="stylesheet" /> <%-- NO OUTPUTENCODING --%>
<%} %>
	<style type="text/css">
	body, table, a, input, select, textarea {
		font-family: Open Sans;
		font-size:12px;
		margin:0px;
		padding:0px;
	    }
	a, a:link, a:visited {color:#085ddc;}
	.error {
	<%if(isMobile){%>
		  color: red;
  font-size: 11px;
  margin-bottom: 6px;
    text-align: left;
    padding-left: 7px;
		<%}else{%>
		  background-color: #ffdadd;
  border-radius: 2px;
  color: red;
  margin-bottom: 1%;
  padding: 8px 0;
  text-align: center;
  width: 300px;
  margin:0 auto;
  <%}%>
    	
	}	
	.lockcontent span {
		font-weight: normal;
	}	
</style>
</head>
<body class="bodycolor">
<form name="mfaerrorform" id="mfaerrorformid">
    <table id="mobver_tb" class="ver-mobile" <%if(!isMobile){ %>style="margin:0px auto;" <%}%>  cellpadding="0" cellspacing="0" >
    <%if(!isMobile){ %>
		<div class="logo-top"></div>
		<%if(isLocked){%>
			<div class="title1"><%=Util.getI18NMsg(request, "IAM.ONEAUTH.LOCKED.TITLE")%></div>
			<div class="bdre2"></div>
    <%}}else{%>
		<tr><td valign="top" <%if(isMobile) {%>align="center"<%} %> >
		<div class="logocolor logoadjust"><span class="colorred"></span><span class="colorgreen"></span><span class="colorblue"></span><span class="coloryellow"></span></div>
		<div class="mobilelogo"></div>
		<div class="mobiletitle"><%=Util.getI18NMsg(request, "IAM.ONEAUTH.LOCKED.TITLE")%></div>
	<%} %>


	<%
	if(isLocked) {
	%> 
						<%if(isMobile){ %>
						<div id="pageheading">
					<div>
						<img src="<%=imgurl%>/app-lock.png" style="margin-top: 25px; margin-bottom: 26px; "> <%-- NO OUTPUTENCODING --%>
					</div>
					<div style="text-align: center; line-height: 24px;" class="lockcontent">
						<%=Util.getI18NMsg(request, "IAM.ONEAUTH.LOCKED")%>
					</div>
					</div> <%--No I18N--%>
						<table class="innertable" width="100%">
					 	<tr>
				    	<td class=desctd></td>
						<td class="descRtd ele_position" align="center">
							<span class="bluebutt_ver" style="margin-left: -13px;" onclick="mfaredirect('<%=IAMEncoder.encodeJavaScript(redirectUrl)%>');"><%=Util.getI18NMsg(request, "IAM.ONEAUTH.LOCKED.TRY.AGAIN")%></span>
						</td>
				 	</tr>
				 	<tr><td id="bot_bor" class="border_bottom">&nbsp;</td><tr>
				 	</table>
						<%}else{ %>
				<div id="pageheading" style="width: 100%; text-align: center;">
					<div>
						<img src="<%=imgurl%>/app-lock.png" style="margin-top: 25px; margin-bottom: 26px; "> <%-- NO OUTPUTENCODING --%>
					</div>
					<div style="text-align: center; line-height: 24px;margin-bottom: 20px; font-weight: normal;" class="lockcontent">
						<%=Util.getI18NMsg(request, "IAM.ONEAUTH.LOCKED")%>
					</div>
					<span class="redBtn" style="margin-right:0;padding: 5px 18px" onclick="mfaredirect('<%=IAMEncoder.encodeJavaScript(redirectUrl)%>');"><%=Util.getI18NMsg(request, "IAM.ONEAUTH.LOCKED.TRY.AGAIN")%></span>
			</div> <%--No I18N--%>
						<div style=" margin-left: 57px; margin-top: 16px; ">
							
						</div>
						<%} %>
						
			<%
	} %>
</table>
</form>
</body>
</html>

<script>
   	function mfaredirect(serviceUrl) {
   		window.parent.location.href = serviceUrl;
   		return;
   	}
</script>