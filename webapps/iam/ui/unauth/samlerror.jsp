<%-- $Id$ --%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1.dtd">

<%@ include file="../../static/includes.jspf" %>
<html>
<head>
<title><%=Util.getI18NMsg(request, "IAM.ERROR.CODE.Z101")%></title>
<style>
    body {font-family:DejaVu Sans, Roboto, Helvetica, sans-serif; margin:0px; padding:0px;}
    .errtbl {margin-top:5%;}
    .zohologo {background:transparent url('<%=imgurl%>/rebrand.gif') no-repeat -186px -196px; height:40px; width:221px; } <%-- NO OUTPUTENCODING --%>
    .errmaindiv {width:600px;}
    .errmsgdiv {margin-top:5px; height:auto; border:6px solid #BFCAFF;}
    .errtxtheader {padding:10px 0px 0px 15px; height:auto;}
    .errtxtheader img {background:transparent url('<%=imgurl%>/acc-img.gif') no-repeat -3px -201px; height:33px; width:33px;} <%-- NO OUTPUTENCODING --%>
    .errtxtheader b {display:block; font-size:15px; margin:0px; padding:15px 0px 0px 5px;}
    .errlink {padding:5px 0px 5px 20px; font-size:11px;}
    .errlink a {color:#085DDC; text-decoration:none;}
    .errlink a:hover {text-decoration:underline;}
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
			<b><%=request.getAttribute("ERROR_MESSAGE")%></b> <%-- NO OUTPUTENCODING --%>
		    </div><br>
		    <%
            String errdoc = AccountsConfiguration.SAML_FAQS.getValue(); 
            %>
		    <div class="errlink"><%=Util.getI18NMsg(request,"IAM.ERROR.POSSIBLE.REASONS.TXT3",errdoc)%>
		    </div>
		</div>
	    </div>
	</td></tr>
	<tr><td  valign="middle">
        <%
        	String supportEmailAddress = AccountsConfiguration.SUPPORT_EMAILID.getValue(); //No I18N
        %>
	    <div class="abusetxt"><%=Util.getI18NMsg(request,"IAM.ERROR.POSSIBLE.REASONS.FOOTER1",supportEmailAddress)%></div>
	</td></tr>
    </table>
</body>
</html>