<%--$Id$--%>
<%@page import="com.adventnet.iam.xss.IAMEncoder"%>
<%@page import="com.zoho.accounts.internal.announcement.Announcement"%>
<%@page import="com.adventnet.iam.internal.Util"%>
<%@ include file="../../static/includes.jspf" %>

<html>
    <head>
	<title><%=Util.getI18NMsg(request,"IAM.MOBILE.CONFIRMED")%></title>
	<style type="text/css">
		body, a, table, input { font-size:11px;}
		body { margin: 0px; padding: 0px;}
		input {font-size:11px;}
		form {margin: 0px; padding: 0px;}
		a:link, a:visited {color:#085ddc; text-decoration:none; outline:none;}
		a:hover {text-decoration:underline;}
		.mainbodydiv {
		    width:850px;
		    margin-top:15px;
		    text-align:left;
		}
		#confirmpassword {margin:10px 0px;margin-left: 5%}
		.pagetitle {font-size:20px; padding:0px; color:#3d3d3d;}
		.pagesubtitle { padding:5px 0px; margin-top:10px;}
		.fieldmain { padding:4px 0px;}
		.fieldlt {
		    padding:6px 3px 6px 2px; float:left; font-weight:bold;
		    text-align:right; color:#414141; width:40%;
		}
		.fieldrt { padding:6px 0px; white-space:nowrap; overflow:hidden;}
		.resultbtn {padding:0px 0px 6px;}
		.input { border:1px solid #7b9db4; padding:2px 2px 3px; color:#414141; width:180px;}
		.signindiv {padding-top:3px;}
		.hide { display:none;}
		.pagenotes {margin:0px; float:left; padding-top:10px; width:100%;}
		.pagenotes div {background-color:#fff8cc; border:1px solid #f7e98f; padding:5px;}
		.newreqtitle {font-size:13px; color:#3d3d3d; padding:5px 0px 0px 5px;text-align: center; margin-top:1%;}
		ul {margin-top:5px; margin-bottom:5px; list-style:none;text-align: center;line-height: 22px;}
		
		.erricon {background-position:-128px -227px; padding:2px 0px 13px 10px;}
		.errormsg, .successmsg { margin:5% 0px; padding:10px 5px 10px 5px;}
		.successmsg a, .errormsg a {margin-left:3px;}
		.errormsg { border:1px solid #e3b5b1; background-color:#f9d0ce; margin:5px 0px; padding:5px;}
		.successmsg { margin:5% 0px; padding:10px 5px 10px 5px;}
	</style>
	
	<link href="<%=cssurl%>/style.css" type="text/css" rel="stylesheet" /> <%-- NO OUTPUTENCODING --%>
    </head>
    <body>
    <table width="100%" height="80%" align="center" cellpadding="0" cellspacing="0">
    <div class="logo-top"></div>
    <tr><td valign="top" align="center">
    <div class="mainbodydiv">
	<div class="title-1" style="text-align: center;"><%=Util.getI18NMsg(request,"IAM.MOBILE.CONFIRMED")%></div>  
	<div class="bdre2"></div>
 
     <div id="msgboard" style="color:#333;background: none; font-size: 12px;text-align: center;">
	    <div class="successicon" style="margin-left: 46%">&nbsp;</div>
	    <div style="font-size:13px;line-height: 24px; "><%=Util.getI18NMsg(request, "IAM.MOBILECONFIRM.SUCCESS",IAMEncoder.encodeHTML(Util.getBackToURL(request.getParameter("servicename"), request.getParameter("serviceurl"))))%></div>
	     </div>
 
    </div>
    </td></tr>

    <tr><td valign="bottom">



<%@ include file="../unauth/footer.jspf" %>

</td></tr>
    </table>
    </body>
</html>
