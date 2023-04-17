<%-- $Id$ --%>
<%@ include file="../../static/includes.jspf" %>
<%
boolean isMobile = Util.isMobileUserAgent(request); //No I18N
String css_url = isMobile ? cssurl_st+"/mobilelogin.css" : cssurl+"/style.css"; //No I18N
%>
<html>
<head>
<%if(isMobile){ %>
    	<meta name="viewport" content="width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=no" />
    <%} %>
<title><%=Util.getI18NMsg(request, "IAM.ERROR.SERVER.ERROR.OCCURED")%></title>
<style type="text/css">
 .pagesubtitle {
                  padding:35px 39px 38px 10px; 
                  line-height:22px; 
                  margin-top:5px;
                  color: #333333;
                  font-size: 14px;
                  text-align: center;
                  width: 780px;
  				  margin-left: 9%;
            }
    body {font-family:DejaVu Sans, Roboto, Helvetica, sans-serif; margin:0px; padding:0px;}
</style>
<link href="<%=IAMEncoder.encodeHTMLAttribute(css_url)%>" type="text/css" rel="stylesheet" /> <%-- NO OUTPUTENCODING --%>
</head>
<body class="bodycolor">
<%
String error = request.getAttribute("ERROR_MESSAGE") != null ? (String)request.getAttribute("ERROR_MESSAGE") : Util.getI18NMsg(request,"IAM.ERROR.SERVER.ERROR.OCCURED");//No I18N
boolean conflictError = request.getAttribute("IS_CONFLICTERROR")  != null ? (Boolean)request.getAttribute("IS_CONFLICTERROR") : false;
boolean blockedEmailDomainUser=request.getAttribute("IS_BLOCKEDDOMAIN_USER")  != null?(Boolean)request.getAttribute("IS_BLOCKEDDOMAIN_USER") : false;
int error_code = request.getAttribute("ERROR_CODE") != null ? (Integer)request.getAttribute("ERROR_CODE") : -1;
boolean isAccountLocked = request.getAttribute("ACCOUNT_LOCKED") != null ? (Boolean)request.getAttribute("ACCOUNT_LOCKED") : false;

String serviceName=request.getParameter("servicename")!=null?request.getParameter("serviceName"):Util.getIAMServiceName();
String serviceurl=request.getParameter("serviceurl")!=null?request.getParameter("serviceurl"):Util.getIAMURL();

String loginURL = request.getContextPath() + "/signin?servicename=" +serviceName; //No I18N
if(Util.isValid(serviceurl)) {
loginURL += "&serviceurl=" + Util.encode(serviceurl); //No I18N
}
%>

<% 	if(error_code!=-1){
    String emailID=request.getAttribute("USER_EMAIL_ID")!=null?(String)request.getAttribute("USER_EMAIL_ID"):null;

%>
             
         <body>
        <div id="progress-cont"></div><%-- No I18N --%>
        <table width="100%" align="center" cellpadding="0" cellspacing="0">
            <div class="logo-top"></div>
            <div class="title-1" style="text-align: center;"><%=Util.getI18NMsg(request, "IAM.ACCOUNT.ALREADY.EXISTS")%></div> <%-- NO OUTPUTENCODING --%> <%-- Output encoding done while constructing the message. --%>
	        <div class="bdre2"></div>
            <tr>
                <td valign="top" align="center">
                    <table cellpadding="0" cellspacing="0" border="0">
                        <tr>
                        <td>
                               <div class="errmsg">
		                       <span class="infoicon1" style="margin-top:5px;">&nbsp;</span>
                               <div class="pagesubtitle" style="padding:20px 39px 38px 10px;" id="page_subtitle"><%=Util.getI18NMsg(request,"IAM.ACCOUNT.ALREADY.EXISTS.DIFFERENT.REGION",emailID)%></div>
                               </div>
                               
                               <div id="cm_contectdiv" class="label">
                                              		 <div class="inlineLabel"></div>
                                                      <div id="smor_div">
                                                            <span class="redBtn" style="margin-left:170px;" onclick="javascript:window.location.href='<%=IAMEncoder.encodeJavaScript(loginURL)%>';"><%=Util.getI18NMsg(request, "IAM.BACKTO.HOME") %></span>
                                                         </div>
                                              </div>	
			
	</td></tr>
	<tr><td valign="middle">
	</td></tr>
    </table>
    </td>
    </tr>
    <tr><td valign="bottom"><div style="margin-top:300px;"><%@ include file="../unauth/footer.jspf" %></div></td></tr> 
    </table>   

	<%}else if(blockedEmailDomainUser){ %>
        <body>
        <div id="progress-cont"></div><%-- No I18N --%>
        <table width="100%" align="center" cellpadding="0" cellspacing="0">
            <div class="logo-top"></div>
            <div class="title-1" style="text-align: center;"><%=Util.getI18NMsg(request, "IAM.ACCOUNT.ALREADY.EXISTS")%></div> <%-- NO OUTPUTENCODING --%> <%-- Output encoding done while constructing the message. --%>
	        <div class="bdre2"></div>
            <tr>
                <td valign="top" align="center">
                    <table cellpadding="0" cellspacing="0" border="0">
                        <tr>
		    <% 
		       String emailID=null;
		       long zuid=request.getAttribute("blockedemaildomain_user_zuid")!=null?(Long)request.getAttribute("blockedemaildomain_user_zuid"):-1;
		       if(zuid!=-1){
		       emailID=request.getAttribute("blockedemaildomain_user_emailID")!=null?(String)request.getAttribute("blockedemaildomain_user_emailID"):null;
		         }
		     
		       if(Util.isValid(emailID)){
		    	   loginURL += "&LOGIN_ID=" + Util.encode(emailID); //No I18N 
		         }
		    %>
		     <td>
                               <div class="errmsg">
		                       <span class="infoicon1" style="margin-top:5px;">&nbsp;</span>
                               <div class="pagesubtitle" style="padding:20px 39px 38px 10px;" id="page_subtitle"><%=Util.getI18NMsg(request,"IAM.ALREADYHAVING.ZOHOACCOUNT.OPENID.USERNAME",emailID)%></div>
                               </div>
                               
                               <div id="cm_contectdiv" class="label">
                                              		 <div class="inlineLabel"></div>
                                                      <div id="smor_div">
                                                            <span class="redBtn" style="margin-left:170px;" onclick="javascript:window.location.href='<%=IAMEncoder.encodeJavaScript(loginURL)%>';"><%=Util.getI18NMsg(request, "IAM.CONFIRMATION.CONTINUE") %></span>
                                                         </div>
                                              </div>	
			
	</td></tr>
	<tr><td valign="middle">
	</td></tr>
    </table>
    </td>
    </tr>
    <tr><td valign="bottom"><div style="margin-top:300px;"><%@ include file="../unauth/footer.jspf" %></div></td></tr> 
    </table>   

<%}else if(isAccountLocked){ 
	String supportEmailAddress = AccountsConfiguration.SUPPORT_EMAILID.getValue();
    %>
    <div class="container_full">
		<div class="zoho_logo center"></div>
		<div class="top_illustration center"></div>
		<div class="heading1"><%=Util.getI18NMsg(request,"IAM.OPENID.ERROR.ACCOUNT.LOCKED")%></div>
		<a href="https://www.zoho.com/accounts/help/faq.html#account-2" target="_blank">
			<button class="btn1 green center" style="    text-transform: uppercase;"><%=Util.getI18NMsg(request,"IAM.TFA.LEARN.MORE")%></button>
		</a>
	</div>
	<div class="lockfooter"><%=Util.getI18NMsg(request,"IAM.OPENID.ERROR.ACCOUNTCONFLICT.FOOTER",supportEmailAddress)%></div>
<%}else if(!conflictError) { %>
    <table class="errtbl" align="center" cellpadding="0" cellspacing="0">
	<tr><td align="center" valign="top">
	<div class="logocolor logoadjust"><span class="colorred"></span><span class="colorgreen"></span><span class="colorblue"></span><span class="coloryellow"></span></div>
	<img src="<%=imgurl%>/spacer.gif" class="zohologo"/></td></tr> <%-- NO OUTPUTENCODING --%>
	<tr><td <%if(!isMobile){ %> valign="middle"<%}else{ %> valign="top" <%}%> >
	    <div class="errmaindiv">
		<div class="errmsgdiv">
		    <div class="errtxtheader">
			<img src="<%=imgurl%>/spacer.gif" align="absmiddle" /> <%-- NO OUTPUTENCODING --%>
                        <b><%=IAMEncoder.encodeHTML(error)%></b>
			<div>&nbsp;</div>
		    </div><br>
		    <div class="err-reason">
			<b><%=Util.getI18NMsg(request,"IAM.ERROR.POSSIBLE.REASONS.TITLE")%></b>
			<ul>
			    <li>1. <%=Util.getI18NMsg(request,"IAM.ERROR.POSSIBLE.REASONS.TXT1")%></li>
			    <li>2. <%=Util.getI18NMsg(request,"IAM.ERROR.POSSIBLE.REASONS.TXT2")%></li>
			</ul>
	    	    </div>
		</div>
	    </div>
	</td></tr>
	<tr><td valign="middle">
        <%
            String supportEmailAddress = AccountsConfiguration.SUPPORT_EMAILID.getValue(); //No I18N
        %>
	    <div class="abusetxt"><%=Util.getI18NMsg(request,"IAM.ERROR.POSSIBLE.REASONS.FOOTER",supportEmailAddress)%></div>
	</td></tr>
    </table>
    <% } else { 
    	String oldEmail = (String)request.getAttribute("OLD_EMAIL");
    	String newEmail = (String)request.getAttribute("NEW_EMAIL");
    	String idp = (String)request.getAttribute("IDP");
    	
    %>
    
    
    
    <table class="errtbl" align="center" cellpadding="0" cellspacing="0">
	<tr><td  valign="middle" align="center"><img src="<%=imgurl%>/spacer.gif" class="zohologo"/></td></tr> <%-- NO OUTPUTENCODING --%>
	<tr><td  valign="middle">
	    <div style="width: 103%">
		<div class="errmsgdiv">
		    <div class="errtxtheader">
			<img src="<%=imgurl%>/spacer.gif" align="absmiddle" /> <%-- NO OUTPUTENCODING --%>
                        <b><%=IAMEncoder.encodeHTML(Util.getI18NMsg(request,"IAM.OPENID.ERROR.ACCOUNTCONFLICT.TITLE"))%></b>
			<div>&nbsp;</div>
		    </div><br>
		    <div class="err-reason">
			<%=Util.getI18NMsg(request,"IAM.OPENID.ERROR.ACCOUNTCONFLICT.DESCRIBTION", IAMEncoder.encodeHTML(idp), IAMEncoder.encodeHTML(oldEmail), IAMEncoder.encodeHTML(newEmail))%>
			<br/>
			</div>
			<div class="err-reason1">
			<span><%=Util.getI18NMsg(request,"IAM.OPENID.ERROR.ACCOUNTCONFLICT.REFERENCEARTICLE")%></span>
	    	    </div>
		</div>
	    </div>
	</td></tr>
	<tr><td  valign="middle">
        <%
            String supportEmailAddress = AccountsConfiguration.SUPPORT_EMAILID.getValue(); //No I18N
        %>
	    <div class="abusetxt"><%=Util.getI18NMsg(request,"IAM.OPENID.ERROR.ACCOUNTCONFLICT.FOOTER",supportEmailAddress)%></div>
	</td></tr>
    </table>
    <%} %>
    
</body>
</html>
