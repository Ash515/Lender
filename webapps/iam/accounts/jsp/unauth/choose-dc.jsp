<%--$Id$--%>
<%@page import="org.json.JSONObject"%>
<%@page import="com.zoho.accounts.dcl.DCLUtil"%>
<%@page import="com.adventnet.iam.IAMUtil"%>
<%@page import="com.zoho.accounts.handler.GeoDCHandler"%>
<%@page import="com.zoho.accounts.AccountsConfiguration"%>
<%@page import="com.adventnet.iam.internal.Util"%>
<%@page import="com.zoho.accounts.actions.unauth.DCLHandshakeAction"%>
<%@include file="../../../static/includes.jspf" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%
	boolean isMobile = Util.isMobileUserAgent(request);
	String ua = request.getHeader("User-Agent");//No I18N
	if(GeoDCHandler.isBlockedPartnerDomain(DCLHandshakeAction.getFromState("hd-domain"))){	//No I18N
		DCLHandshakeAction.redirectToRemoteDeployment(request, response);
		return;
	}
	if((ua!=null && ua.toLowerCase().contains("iphone")) && "true".equals(DCLHandshakeAction.getFromState("hide_signup"))){//No I18N
		DCLHandshakeAction.handOverToLocalDeployment(request, response);
		return;
	}
	String chosenDep = request.getParameter("choose"); //No I18N
	if(chosenDep!=null){
		if(chosenDep.equalsIgnoreCase(DCLUtil.getLocation())){
			DCLHandshakeAction.handOverToLocalDeployment(request, response);			
		} else {
			DCLHandshakeAction.redirectToRemoteDeployment(request, response);
		}
%>
		<%=Util.getI18NMsg(request, "IAM.UPLOAD.LOADING") %>  <%--NO OUTPUTENCODING--%>
<%
		return;
	}
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta name="viewport" content="width=device-width" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="<%=request.getContextPath()%>/styles/style.css" type="text/css" rel="stylesheet"> <%--NO OUTPUTENCODING--%>
<script src="<%=jsurl%>/jquery-1.12.2.min.js" type="text/javascript"></script> <%-- NO OUTPUTENCODING --%>
<title><%=Util.getI18NMsg(request, "IAM.MULTIDC.SIGNUP.PAGETITLE")%></title> <%--NO OUTPUTENCODING--%>
<style>
html,body{
	height:100%;
	overflow-y:hidden; 
}
.container{
	width:50%;
	font-family:"Open sans";
	margin-left:25%;
	min-height:95%;
	height:95%;
	display:inline-block;
}

.sub-title{
	display: inline-table;
    font-size: 14px;
    font-weight: 300;
    width: 100%;
	text-align: center;
	line-height:20px;
}

.title{
	font-size: 30px;
    color: #666;
    font-weight: 300;
    margin-top: -14px;
	text-align: center;
}

div{
	width:100%;
}

.profile-img img{
	margin-top: 2em;
	width:15%;
	margin-left:42.5%;
	border-radius:50%;
	margin-bottom:2%;
}

.copyright{
	margin-left:25%;
	width: 50%;
	text-align: center;
	margin-bottom:1%;
	height:5%;
	color:#666;
    font-size: 10px;
    text-align: center;
    padding: 5px 0px;
}

.unauthlabel{
    margin-left: 0%;
    display: block;
    margin-top: 0%
    font-size: 17px;
    font-weight: 300;
    width: 100%;
    text-align: center;
    line-height: 60px;
}

span{
	white-space:nowrap;
}

<%if(isMobile){%>
    .container, .copyright {
        width:100%;
        margin-left:0px;
    } 
    
    .title{
		font-size: 15px;
    }
   
   	span{
		width: 40%;
		display:inline-block;
    }
  
    .unauthlabel{
		width:100%;
    	text-align:center;
    	margin-top: 10%;
    	margin-left:0px;
    	padding: 0px;
    }
    
    .cancel-btn{
    	margin-top: 5%;
    	height: 20px;
   	  	padding-top:0px;
    	padding-bottom:10px;
   	 	margin-left: -11px;
    }
    .redBtn{
		margin-left: 0px;	
	}
	
<%}%>
</style>
</head>
<body>
	<div class='container'>
		<div class='logo-top'></div>
		<div class='title'><%=Util.getI18NMsg(request, "IAM.MULTIDC.SIGNUP.TITLE")%></div> <%--NO OUTPUTENCODING--%>
		<div class='bdre2'></div>
		<div class='profile-img'><img src='<%=DCLHandshakeAction.getFromState("image-url")%>'/></div><%--NO OUTPUTENCODING--%>
		<div class='sub-title'><%=Util.getI18NMsg(request, "IAM.MULTIDC.SIGNUP.MSG", DCLUtil.getRemoteDeployment(request).getDescription(), DCLUtil.getRemoteDeployment(request).getLocation().toUpperCase()) %></div> <%--NO OUTPUTENCODING--%>
		<div class="unauthlabel">
			<span class="redBtn" onclick="return remote(this);"><%=Util.getI18NMsg(request, "IAM.MULTIDC.SIGNUP.REMOTE.BUTTON", DCLUtil.getRemoteDeployment(request).getLocation().toUpperCase())%></span><%--NO OUTPUTENCODING--%>
			<%if(isMobile) {%>
			<br/>
			<%}%>
			<span class="cancel-btn" onclick="return local(this);"><%=Util.getI18NMsg(request, "IAM.CONTINUE")%></span> <%--NO OUTPUTENCODING--%>
		</div>
	</div>	
	<div class='copyright'><%=Util.getI18NMsg(request, "IAM.FOOTER.COPYRIGHT", AccountsConfiguration.getConfiguration("iam.copyright.year","2016"))%></div>	
</body>
<script type="text/javascript">
<% JSONObject stateParamMap = new JSONObject(DCLHandshakeAction.getFromState("state"));%>
function remote(thisR){
	disableInputs(thisR);
	window.location.href="/accounts/choose.dc?choose=<%=DCLUtil.getRemoteDeployment(request).getLocation().toLowerCase()%>&state=<%=stateParamMap.get("secret")%>";<%--NO OUTPUTENCODING--%>
}

function disableInputs(thisR){
	$(thisR).text('<%=Util.getI18NMsg(request, "IAM.MULRIDC.SIGNUP.LOADING")%>');
	$('.redBtn,.cancel-btn').map(function(d,i){i.onclick=null;});//No I18N
}

function local(thisR){
	disableInputs(thisR);
	window.location.href="/accounts/choose.dc?choose=<%=DCLUtil.getLocation().toLowerCase()%>&state=<%=stateParamMap.get("secret")%>";<%--NO OUTPUTENCODING--%>
}
</script>
</html>