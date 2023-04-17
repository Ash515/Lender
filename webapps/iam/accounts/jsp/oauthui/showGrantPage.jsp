/*$Id$*/
<%@page import="com.adventnet.iam.xss.IAMEncoder"%>
<%@page import="com.zoho.accounts.internal.util.AccountsInternalConst"%>
<%@page import="com.zoho.accounts.AccountsConfiguration"%>
<%@page import="com.zoho.accounts.internal.util.Util"%>
<%@page import="com.adventnet.iam.security.SecurityUtil"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<%
String accountsStaticURL =  Util.getServerURL(request, false);
boolean useStaticServer = AccountsConfiguration.USE_STATIC_SERVER.toBooleanValue();
accountsStaticURL  = useStaticServer ? Util.getJSStaticURL(AccountsInternalConst.STATIC_SERVER_CONTEXT) : accountsStaticURL;
%>
<html>
<head>
<title><%=IAMEncoder.encodeHTML(com.adventnet.iam.internal.Util.getI18NMsg(request, "IAM.ZOHO.ACCOUNTS"))%></title>
<script src="<%=accountsStaticURL%>/js/tplibs/jquery/jquery-1.12.2.min.js" type="text/javascript"></script> <%-- NO OUTPUTENCODING --%>
<script>

function getcsrfParams() {
	var csrfParam = "<%=SecurityUtil.getCSRFParamName(request)%>"; //NO OUTPUTENCODING
	var csrfCookieName = "<%=SecurityUtil.getCSRFCookieName(request)%>"; //NO OUTPUTENCODING
	var params = csrfParam + "=" + getCookie(csrfCookieName);
	return params;
	 
}

function showError() {
	alert("error Occred");	//NO I18N
}

function submitRejectForm() {
	$.ajax({
		type: "POST", //NO I18N
		    url: "<%=IAMEncoder.encodeJavaScript(request.getContextPath())%>/oauth/v2/reject",//NO I18N
		    data: "<s:property escapeHtml="false" value="queryParams"/>&approvedScope=<s:property escapeHtml="false" value="scopeDetailsParam"/>&" + getcsrfParams()+"&is_ajax=true",//NO I18N
		    dataType  : "json",//NO I18N
		    success: function(data, status, xnr) {
		        if(data.redirect_uri) {
		        	window.location.replace(data.redirect_uri);
		        } else {
		        	showError();
		        }
		    },
		    error: function(data, textStatus, errorThrown){
		   	 showError();
		    }

		});
}

function submitAppriveForm() {
	$.ajax({
		type: "POST",//NO I18N
		    url: "<%=IAMEncoder.encodeJavaScript(request.getContextPath())%>/oauth/v2/approve", //NO I18N
		    data: "<s:property escapeHtml="false" value="queryParams"/>&approvedScope=<s:property escapeHtml="false" value="scopeDetailsParam"/>&" + getcsrfParams()+"&is_ajax=true",//NO I18N
		    dataType  : "json",//NO I18N
		    success: function(data, status, xnr) {
		        if(data.redirect_uri) {
		        	window.location.replace(data.redirect_uri);
		        } else {
		        	showError();
		        }
		    },
		    error: function(data, textStatus, errorThrown){
		   	 showError();
		    }

		});
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


</script>
<style>
body {
	font-family: "Open sans";
	margin: 0px;
	padding: 0px;
	font-weight: 300;
}
@font-face {
	    font-family: 'Open Sans';
	    font-style: normal;
	    font-weight: 300;
	    src:url('../images/opensans/font.eot');
	    src:local('Open Sans'),
	    	url('../images/opensans/font.eot?#iefix') format('eot'),
	        url('../images/opensans/font.woff') format('woff'), 
	        url('../images/opensans/font.ttf') format('truetype'),
	        url('../images/opensans/font.svg#OpenSans-Light') format('svg');
}

.title1 {
	font-size: 30px;
	font-family: "Open sans";
	font-weight: 300;
	text-align: center;
}

.title2 {
	font-size: 16px;
	font-family: "Open sans";
	font-weight: 300;
	text-align: center;
	margin-top: 4%;
}

.main {
	margin: 4% auto;
	width: 600px;
}

.linkdiv {
	text-align: center;
	font-size: 13px;
	color: #888;
	padding: 2px;
	line-height: 25px;
}

.linkdiv a {
	text-decoration: none;
	color: #888;
}

.linkdiv a:hover {
	text-decoration: underline;
}

.borderline {
	  border-bottom: 1px solid #e3e3e3;
  width: 500px;
  margin-left: 51px;
}

.parent_accept {
	text-align: center;
	margin: 4% auto;
	width: 300px;
}

.parent_accept div {
	padding: 11px 0px;
	font-size: 13px;
}

.parent_accept div:hover {
	border-bottom: 1px solid #ccc;
	background: #f5f5f5;
}

.redBtn {
	background-color: #f04b2f;
	border: 1px solid #f04b2f;
	border-radius: 2px;
	color: #fff;
	cursor: pointer;
	font-size: 13px;
	margin-right: 6px;
	padding: 3px 5px;
	text-align: center;
	width: 100px;
	float: left;
	line-height: 24px;
}
.redBtn:hover {
    background-color: #e64226;
}
.cancel-btn:hover{border:1px solid #999;  cursor:pointer;}

.cancel-btn {
	border: 1px solid #c1c1c1;
	line-height: 24px;
	border-radius: 2px;
	padding: 3px 5px;
	font-size: 12px;
	color: #333;
	width: 100px;
	float: left;
	
}
.footer{
text-align: center;font-size: 13px;}
.notes{
  font-size: 13px;
  margin: 17% auto;
  text-align: center;
  width: 457px;
  line-height: 22px;
}
.infoicon{
background: transparent url(../images/icons.png) no-repeat -204px -150px;
  height: 20px;
  width: 20px;
  position: absolute;
  margin-left: 11px;
}
.logo-top {
			  background-image: url('../images/zlogo.png');
  width: 127px;
  height: 44px;
  margin: 18px auto;
  background-repeat: no-repeat;
}

</style>
</head>
<body>
	<div class="main">
	<!-- <div class="logo-top"></div> -->
		<div class="title1">Zoho - <s:property value="clientName" /></div> <%--No I18N--%>
		<div class="title2"><s:property value="clientName" /> would like to access:</div><%--No I18N--%>
		<div class="linkdiv">
			Clicking "Accept" will redirect you to : <a href="<s:property value="redirectUrl" />"><%--No I18N--%>
				<s:property value="redirectUrl" /> </a>
		</div>
		<div class="borderline"></div>
		<div class="parent_accept">
		<s:iterator value="scopeDetails" status="descsStatus">
			<div>
				<s:property value="shortDescription" /> <span class="infoicon"></span>
			</div>
			</s:iterator> <%--No I18N--%>
		</div>
		<div style="text-align: center;  margin-left: 175px;margin-top:7%;">
			<div class="redBtn" onclick="submitAppriveForm()" tabindex="1">Accept</div> <%--No I18N--%>
			<div class="cancel-btn" onclick="" tabindex="1">Reject</div><%--No I18N--%>
		</div>
		<div class="notes">By clicking Accept , you allow this app and zoho to use your information in accordance with their respective terms of service and privacy policies . You can change this and other Account Permissions at any time</div><%--No I18N--%>
	</div>
	<div class="footer">
		<span><%=IAMEncoder.encodeHTML(com.adventnet.iam.internal.Util.getI18NMsg(request, "IAM.FOOTER.COPYRIGHT",
				com.adventnet.iam.internal.Util.getCopyRightYear()))%></span>
	</div>
</body>
</html>
