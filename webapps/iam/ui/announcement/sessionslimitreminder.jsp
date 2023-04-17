<%--$Id$--%>
<%@page import="com.adventnet.iam.xss.IAMEncoder"%>
<%@page import="com.zoho.accounts.internal.announcement.Announcement"%>
<%@ include file="../../static/includes.jspf" %>
<%
User user = IAMUtil.getCurrentUser();
long zuId = user.getZUID();
String userid = CryptoUtil.encryptWithSalt("photo", zuId+"", ":", IAMUtil.getCurrentTicket(), true); //No I18N
String iamHelpLink = "";
String sessionUrl = "/u/h#sessions/useractivesessions"; //No I18N
%>
<html>
<head>
<style>
body,table {
	font-family: "Open sans";
	font-weight:600;
	font-size: 12px;
	padding:0px;
	margin:0px;
}
.maindiv {
	border: 1px solid #dcddda;
	width: 900px;
	margin: 0px auto;
	background: url('<%=imgurl%>/banner-bg.jpg'); <%-- NO OUTPUTENCODING --%>
	border-radius: 2px;
	text-align: justify;
	margin-top: 5%;
}
.contentdiv {
	padding: 27px 35px 30px;
}
.titlemsg {
	border-bottom: 1px solid #c9c9c9;
	font-size: 18px;
	padding-bottom: 8px;
}
.msgcontenttle {
	margin-top: 20px;
	line-height: 20px;
}
.msgcontent {
	margin-top: 10px;
	line-height: 20px;
}
.btndiv {
	clear: both;
	margin-top: 35px;
}
.buttongreen, .buttonred {
	color: #FFFFFF;
	padding: 6px 20px;
	text-decoration: none;
}
.buttongreen {
	background-color: #6DA60A;
	border: 1px solid #65990B;
	font-size: 16px;
}
.buttonred {
	background-color: #ff5722;
	border: 1px solid #ff5722;
	padding-bottom: 8px;
	font-size: 13px;
}
.continuelink {
	text-decoration: underline;
	color: #0483C8;
	margin-left: 20px;
	font-size: 12px;
	padding: 6px 0px 11px 0px;
}
.sessionbtndiv {
	float: left;
	margin-right: 20px;
}
.notesmaindiv {
	line-height:22px;
	margin-top:40px;
}
.notes { margin-top:8px; }
.subnotes { padding-left:20px; }
</style>
<%
%>
<script src="<%=jsurl%>/jquery-1.12.2.min.js" type="text/javascript"></script> <%-- NO OUTPUTENCODING --%>
<script src="<%=jsurl%>/jquery.ztooltip.js" type="text/javascript"></script> <%-- NO OUTPUTENCODING --%>
<script src="<%=jsurl%>/common.js" type="text/javascript"></script> <%-- NO OUTPUTENCODING --%>

<link href="<%=cssurl_st%>/ui.ztooltip.css" type="text/css" rel="stylesheet"  /><%-- NO OUTPUTENCODING --%>
<script>
function redirect() {
	window.location.href = '<%=IAMEncoder.encodeJavaScript(Announcement.getVisitedNextURL(request))%>';
	return;
}
function showWarningBtn() {
	document.getElementById('continue_skip').style.display='none';
	document.getElementById('continue_url').style.display='';
}
function showManageSessions(){
	window.open('<%=IAMEncoder.encodeJavaScript(sessionUrl)%>');
	redirect();
}
function showNextAnnouncement(){
	window.location.href = '<%=IAMEncoder.encodeJavaScript(Announcement.getSkipNextURL(request))%>';
}


$(document).ready(function(){
	$(document).ztooltip();
	$("#ztb-change-photo,#ztb-help").hide();
});
</script>
<title><%=Util.getI18NMsg(request, "IAM.ZOHO.ACCOUNTS")%></title>
</head>
<body>
	<table width="100%" height="100%" align="center" cellpadding="0" cellspacing="0">
		<tr><td valign="top" style="height:40px;"><div class="ztb-topband" id="ztb-topband"><%@ include file="../../ui/profile/header.jspf" %></div></td></tr>
		<tr><td valign="top">
			<div class="maindiv">
				<div class="contentdiv">
					<div class="titlemsg"><%=Util.getI18NMsg(request, "IAM.ANNOUNCEMENT.SESSIONREMINDER.TITLE") %></div>
					<div class="msgcontenttle"><%=Util.getI18NMsg(request, "IAM.TFA.HI.USERNAME",IAMEncoder.encodeHTML(user.getDisplayName()))%></div>

					<div class="msgcontent"><%=Util.getI18NMsg(request, "IAM.ANNOUNCEMENT.SESSIONREMINDER.MSG1")%></div>
					<div class="msgcontent"><%=Util.getI18NMsg(request, "IAM.ANNOUNCEMENT.SESSIONREMINDER.MSG2")%></div>

					<div class="btndiv">
						<div class="sessionbtndiv">
							<a href="javascript:;" onclick="showManageSessions();" class="buttongreen" title="<%=Util.getI18NMsg(request, "IAM.ANNOUNCEMENT.SESSIONREMINDER.MANAGESESSIONS")%>"><%=Util.getI18NMsg(request, "IAM.ANNOUNCEMENT.SESSIONREMINDER.MANAGESESSIONS") %></a>
						</div>
						<div>
							<a id="continue_url" href="javascript:showNextAnnouncement()" class="buttonred" style="display:none;"><%=Util.getI18NMsg(request, "IAM.ANNOUNCEMENT.SESSIONREMINDER.PROCCEED.WITH.RISK") %></a>
							<a id="continue_skip" href="javascript:showWarningBtn();" class="continuelink"><%=Util.getI18NMsg(request, "IAM.SKIP")%></a>
						</div>
					</div>
					<div class="notesmaindiv">
						<div><%=Util.getI18NMsg(request, "IAM.ANNOUNCEMENT.SESSIONREMINDER.NOTE")%>,</div>
						<div class="notes">
							<div><%=Util.getI18NMsg(request, "IAM.ANNOUNCEMENT.SESSIONREMINDER.NOTE1")%></div>
							<div class="subnotes"><%=Util.getI18NMsg(request, "IAM.ANNOUNCEMENT.SESSIONREMINDER.SUBNOTE1")%></div>
							<div class="subnotes"><%=Util.getI18NMsg(request, "IAM.ANNOUNCEMENT.SESSIONREMINDER.SUBNOTE2")%></div>
						</div>
						<div class="notes"><%=Util.getI18NMsg(request, "IAM.ANNOUNCEMENT.SESSIONREMINDER.NOTE2")%></div>
					</div>
				</div>
			</div>
		</td></tr>
		<tr><td valign="bottom"><%@ include file="../unauth/footer.jspf" %></td></tr>
	</table>
</body>
</html>