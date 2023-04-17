<%@page import="com.zoho.accounts.internal.util.I18NUtil"%>
<%@page import="com.adventnet.iam.xss.IAMEncoder"%>
<%@page import="com.zoho.accounts.actions.ZohoActionSupport"%>
<%@page import="com.opensymphony.xwork2.ActionContext"%>
<%@page import="com.zoho.accounts.AccountsConfiguration"%>
<%@page import="com.zoho.accounts.internal.OAuthException.OAuthErrorCode"%>
<%@page import="com.adventnet.iam.internal.Util"%>
<%
boolean isStatic = "true".equals(AccountsConfiguration.getConfiguration("iam.static", "false"));
String cPath = request.getContextPath();
String imgurl = isStatic ? Util.getIMGURL(request) : cPath+"/images"; //No I18N

%>
<html>
<head>
<title><%=Util.getI18NMsg(request,"IAM.ERROR.SERVER.ERROR.OCCURED")%></title>
<style>
    body { margin:0px; padding:0px;font-family:"Open sans";font-weight: 300; }
    .errmaindiv {text-align: center;}
    .errmsgdiv {margin-top:5px; border:6px solid #BFCAFF;}
    .errtxtheader b {float:left; font-size:15px; margin:0px; padding:15px 0px 0px 5px;}
    .err-reason {font-size:13px;}
    .abusetxt {padding: 5px 0px 5px 5px; font-size: 13px; text-align: center; font-weight: 300; margin-top: 20px;}
    .abusetxt a {color:#085DDC; text-decoration:none;}
    .abusetxt a:hover {text-decoration:underline;}
    .logo-top {
  width: 100px;
  height: 35px;
  margin: 40px auto;
  background-repeat: no-repeat;}
    .title1{margin-top:-14px;font-size:30px;font-family: "Open sans";font-weight:300;text-align: center;}
	.title2 {font-size:18px;width: 500px;margin-bottom: 10px;margin-top: 10px;}
	.bdre2 { border-bottom: 2px solid #000; height: 1px; margin: 6px auto; width: 100px; }
	.errorLogo{background: url("<%=imgurl%>/unauthsprite.png") no-repeat scroll 5px 10px transparent; height: 130px; width: 150px;}  <%-- NO OUTPUTENCODING --%>
	.error-reason{font-size: 13px; line-height: 22px; margin-top: 13px;font-weight: 300}
	@font-face {
    font-family: 'Open Sans';
	font-weight: 400;
	font-style: normal;
	src :local('Open Sans'),url('<%=imgurl%>/font.woff') format('woff');  <%-- NO OUTPUTENCODING --%>
 }
</style>
</head>
<body>
    <table class="errtbl" align="center" cellpadding="0" cellspacing="0">
			<div class="logo-top"></div>
			<div class="title1"><%=Util.getI18NMsg(request, "IAM.ERROR.UH")%></div>
			<div class="bdre2"></div>
	<tr><td  valign="middle">
	    <div class="errmaindiv">
	    <div class="errorLogo" style=" margin-left: 110px; margin-top: 11px; "></div>
		<div>
		    <div style="font-size: 16px; font-weight: 500;">
		    
<%
String errorMessage = "General error"; //No I18N

if(ZohoActionSupport.getValue("ERROR_MESSAGE") != null) {
	errorMessage = (String) ZohoActionSupport.getValue("ERROR_MESSAGE"); //No I18N
} else if(request.getParameter("error")!= null) {
	try {
		OAuthErrorCode errorCode = OAuthErrorCode.valueOf(request.getParameter("error"));
		errorMessage = errorCode.getDescription();
		errorMessage = I18NUtil.getMessage(errorMessage);
	}catch(Exception e){
	}
}
%>
		    </div>
		    <div class="error-reason">
				<div style=" font-weight: 300; font-size: 13px; "><%=Util.getI18NMsg(request,"IAM.ERROR.POSSIBLE.REASONS.TITLE")%></div>
			    <div> <%= IAMEncoder.encodeHTML(errorMessage)%></div>
	    	    </div>
		</div>
	    </div>
	</td></tr>
	<tr><td  valign="middle">
	    <div class="abusetxt"><%=Util.getI18NMsg(request,"IAM.CLIENT.ERROR.HELP")%></div>
	</td></tr>
    </table>
</body>
</html>