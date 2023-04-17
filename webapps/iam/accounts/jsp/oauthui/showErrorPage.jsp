<%-- // $Id: $ --%>
<%@page import="com.opensymphony.xwork2.ActionContext"%>
<%@page import="com.zoho.accounts.internal.OAuthException.OAuthErrorCode"%>
<%@page import="com.zoho.accounts.internal.OAuthException"%>
<%@page import="com.zoho.accounts.internal.util.AccountsInternalConst"%>
<%@page import="com.zoho.accounts.AccountsConfiguration"%>
<%@page import="com.adventnet.iam.internal.Util"%>

<%
String accountsStaticURL =  com.zoho.accounts.internal.util.Util.getServerURL(request, false);
boolean useStaticServer = AccountsConfiguration.USE_STATIC_SERVER.toBooleanValue();
accountsStaticURL  = useStaticServer ? com.zoho.accounts.internal.util.Util.getJSStaticURL(AccountsInternalConst.STATIC_SERVER_CONTEXT) : accountsStaticURL;
OAuthException oathExp =  ActionContext.getContext().get("OAuthException") != null ? (OAuthException) ActionContext.getContext().get("OAuthException") :  new OAuthException(OAuthErrorCode.invalid_client); //No I18N

String imgurl = accountsStaticURL +"/images";  //NO OUTPUTENCODING //No I18N
%>
<html>
<head>
<title><%=Util.getI18NMsg(request,"IAM.ERROR.SERVER.ERROR.OCCURED")%></title>
<style>
    body {font-family:DejaVu Sans, Roboto, Helvetica, sans-serif; margin:0px; padding:0px;}
    .errtbl {margin-top:5%;}
    .zohologo {background: transparent url('<%=imgurl%>/rebrand.gif') no-repeat -9px -199px;width: 230px;height: 29px;margin: 4px 0px 0px 6px; border: none;} <%-- NO OUTPUTENCODING --%>
    .errmaindiv {width:600px;}
    .errmsgdiv {margin-top:5px; border:6px solid #BFCAFF;}
    .errtxtheader {padding:10px 0px 0px 15px; height:33px;}
    .errtxtheader img {background:transparent url('<%=imgurl%>/acc-img.gif') no-repeat -3px -201px; height:33px; width:33px; float:left;} <%-- NO OUTPUTENCODING --%>
    .errtxtheader b {float:left; font-size:15px; margin:0px; padding:15px 0px 0px 5px;}
    .err-reason {font-size:11px; margin-left:15px;}
    .err-reason ul {list-style:none; margin-top:5px; margin-bottom:5px; line-height:15px;}
    .err-reason li {padding:3px 0px;}
    .abusetxt {padding:5px 0px 5px 5px; font-size:11px;}
    .abusetxt a {color:#085DDC; text-decoration:none;}
    .abusetxt a:hover {text-decoration:underline;}
</style>
</head>
<body>
    <table class="errtbl" align="center" cellpadding="0" cellspacing="0">
		
			<tr><td  valign="middle" align="center"><img src="<%=imgurl%>/spacer.gif" class="zohologo"/></td></tr> <%-- NO OUTPUTENCODING --%>
	
	
	<tr><td  valign="middle">
	    <div class="errmaindiv">
		<div class="errmsgdiv">
		    <div class="errtxtheader">
			<img src="<%=imgurl%>/spacer.gif" align="absmiddle" /> <%-- NO OUTPUTENCODING --%>
			<b>
			<%=Util.getI18NMsg(request, "IAM.ERROR.SERVER.ERROR.OCCURED")%>
			</b>
			<div>&nbsp;</div>
		    </div><br>
		    <div class="err-reason">
			<b><%=Util.getI18NMsg(request,oathExp.getErrorCode().getDescription())%></b>
			<%-- <ul>
			    <li>1. <%=Util.getI18NMsg(request,"IAM.ERROR.POSSIBLE.REASONS.TXT1")%></li>
			    <li>2. <%=Util.getI18NMsg(request,"IAM.ERROR.POSSIBLE.REASONS.TXT2")%></li>
			</ul> --%>
	    	    </div>
		</div>
	    </div>
	</td></tr>
	<tr><td  valign="middle">
<%
String supportEmailAddress = AccountsConfiguration.SUPPORT_EMAILID.getValue();
%>
	    <div class="abusetxt"><%=Util.getI18NMsg(request,"IAM.ERROR.POSSIBLE.REASONS.FOOTER", supportEmailAddress)%></div>
	</td></tr>
    </table>
</body>
</html>