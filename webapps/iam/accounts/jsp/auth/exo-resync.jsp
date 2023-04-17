<%-- $Id$ --%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Frameset//EN" "http://www.w3.org/TR/REC-html40/frameset.dtd"><%-- NO I18N --%>
<%@page import="com.zoho.accounts.AccountsUtil"%>
<%@page import="java.net.URISyntaxException"%>
<%@page import="java.net.URI"%>
<%@page import="com.adventnet.iam.User"%>
<%@page import="com.adventnet.iam.internal.ExoStarUtil"%>
<%@page import="com.adventnet.iam.internal.Util"%>
<%@page import="com.adventnet.iam.IAMUtil"%>
<%@page import="com.adventnet.iam.xss.IAMEncoder"%>
<html>
	<head>
<%
	if("start".equals(request.getParameter("oper"))){
		User user = IAMUtil.getCurrentUser();
		String exoResult=ExoStarUtil.validateEXO(user,"","sesreq");
		if(AccountsUtil.startsWithHttp(exoResult)){
			response.sendRedirect(exoResult);
			return;
		}
	%>
		<title><%=IAMEncoder.encodeHTML(Util.getI18NMsg(request, "IAM.EXO.AUTHENTICATE")) %></title>
		<style type="text/css">
			body, table, a { font-size:11px;font-family: "Open Sans"}
    		body { margin: 0px; padding: 0px;}
    		.errmsg {
				 text-align:center; color:#3d3d3d;
				 padding:15px 5px 10px 15px;
				 font-size: 13px;
			}
			.erricon{
				background: url("../images/unauthsprite.png") no-repeat scroll -74px -121px transparent;
			  	  height: 60px;
			  	  width: 60px;
			  	  margin-left: 44%;
			  	  display: block;
			}
		</style>
	</head>
	<body>
		<div class="errmsg">
		    <div class="erricon">&nbsp;</div>
		    <%
		    	String msg="";
			    if("unknown_user".equals(exoResult)){ //No I18N
					msg="IAM.TFA.EXO.RESYNC.UNKNOWN"; //No I18N
				}else{
					msg="IAM.ERROR.GENERAL";//No I18N
				}
		    %>
		    <span><%=Util.getI18NMsg(request, msg)%></span>
		</div>
	</body>
	<%
	}else{
	%>
		<script>window.close()</script>
	</head>
	<%
	return;
	}
%>
</html>