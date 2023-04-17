<%-- // $Id: $ --%>
<%@page import="com.adventnet.iam.xss.IAMEncoder"%>
<%@page import="com.adventnet.iam.internal.PartnerAccountUtil"%>
<%@page import="com.adventnet.iam.IAMUtil"%>
<%@page import="com.adventnet.iam.PartnerAccount"%>
<%@page import="com.adventnet.iam.security.ActionRule"%>
<%@page import="com.adventnet.iam.security.SecurityRequestWrapper"%>
<%@page import="com.adventnet.iam.security.IAMSecurityException"%>
<%@page import="com.zoho.accounts.internal.util.AccountsInternalConst"%>
<%@page import="com.zoho.accounts.AccountsConstants"%>
<%@page import="java.net.HttpURLConnection"%>
<%@page import="com.zoho.accounts.internal.util.I18NUtil"%>
<%@page import="com.zoho.accounts.ajax.AjaxResponse.Type"%>
<%@page import="com.zoho.accounts.ajax.AjaxResponse"%>
<%@page import="com.zoho.accounts.CrossDomainUtil"%>
<%@page import="com.zoho.accounts.AccountsConfiguration"%>
<%@page import="com.zoho.accounts.internal.util.Util"%>
<%@page isErrorPage="true"%>



<%
	IAMSecurityException ex =  (IAMSecurityException) request.getAttribute(IAMSecurityException.class.getName());
	if(ex != null && ex.getErrorCode() != null) {
		String errorCode = ex.getErrorCode();
			SecurityRequestWrapper secRequest = SecurityRequestWrapper.getInstance(request);
			ActionRule rule = secRequest.getURLActionRule();
			if(rule != null) {
				if(errorCode.equals(IAMSecurityException.PATTERN_NOT_MATCHED)) {
				    int err_userPasswordMinLength = com.adventnet.iam.internal.Util.getUserPasswordDefaultMinLength();
				    int err_userPasswordMaxLength = com.adventnet.iam.internal.Util.getUserPasswordDefaultMaxLength();
				    if ((("/accounts/register.ac".equals(rule.getPath()) || "/accounts/registerbyinvite.ac".equals(rule.getPath())) && ("password".equals(ex.getParameterName()) || "repassword".equals(ex.getParameterName()))) ||
				    	("/accounts/addpass.ac".equals(rule.getPath()) && ("password".equals(ex.getParameterName()) || "cpassword".equals(ex.getParameterName()))) || //No I18N
				    	("/accounts/reset.ac".equals(rule.getPath()) && "password".equals(ex.getParameterName())) || //No I18N
				    	("/accounts/password2.ac".equals(rule.getPath()) && "securityqa1".equals(ex.getParameterName())) || //No I18N
				    	("/accounts/adduser.ac".equals(rule.getPath()) && "password".equals(ex.getParameterName())) || //No I18N
				    	("/accounts/accinvite.ac".equals(rule.getPath()) && "password".equals(ex.getParameterName()))) { //No I18N
				    	String accountPassword = request.getParameter(ex.getParameterName());
				    	String respStr = null;
				    	if(accountPassword == null || "".equals(accountPassword.trim())) {
				    		respStr = I18NUtil.getMessage("IAM.ERROR.PASS.EMPTY");
				    	} else if(accountPassword.trim().length() < err_userPasswordMinLength) {
				    		respStr = I18NUtil.getMessage("IAM.ERROR.PASS.LEN", err_userPasswordMinLength);
				    	} else if(accountPassword.trim().length() > err_userPasswordMaxLength){
				    		respStr = I18NUtil.getMessage("IAM.ERROR.PASSWORD.MAXLEN", err_userPasswordMaxLength);
				    	} else {
				    		respStr = I18NUtil.getMessage("IAM.ERROR.INVALID.PASS");
				    	}
				    	response.setStatus(HttpServletResponse.SC_OK);
				    	out.print(IAMEncoder.encodeHTML(CrossDomainUtil.getResponse(request, response, new AjaxResponse(Type.JSON).addError(respStr).toString(), false))); //NO OUTPUTENCODING
				    	return;
				    }
				}
			}
	}
	if (request.getMethod().equalsIgnoreCase("POST")) { // Sending response in JSON/iFrame submit format assuming POST request is comming through Ajax. 
		out.print(IAMEncoder.encodeHTML(CrossDomainUtil.getResponse(request, response, new AjaxResponse(Type.JSON).addError(I18NUtil.getMessage("IAM.ERROR.GENERAL")).toString(), false))); // No I18N
		return;
	}
	boolean isStatic = AccountsConfiguration.USE_STATIC_SERVER.toBooleanValue();
	String imgurl = isStatic ? Util.getIMGStaticURL(AccountsInternalConst.STATIC_SERVER_CONTEXT) : request.getContextPath() + "/accounts/images";// No I18N
%>
<html>
<head>

<title><%=IAMEncoder.encodeHTML(I18NUtil.getMessage("IAM.ERROR.SERVER.ERROR.OCCURED"))%></title>
<style>
body {
	font-family: DejaVu Sans, Roboto, Helvetica, sans-serif;
	margin: 0px;
	padding: 0px;
}

.errtbl {
	margin-top: 5%;
}

.zohologo {
	background: transparent url('<%=imgurl%>/logo.png') no-repeat 0px 0px; <%-- NO OUTPUTENCODING --%>
	height: 40px;
	width: 221px;
}

.errmaindiv {
	width: 600px;
}

.errmsgdiv {
	margin-top: 5px;
	border: 6px solid #F5ADAD;
}

.errtxtheader {
	padding: 10px 0px 0px 15px;
	height: 33px;
}

.errtxtheader img {
	background: transparent url('<%=imgurl%>/acc-img.gif') no-repeat -3px -201px;<%-- NO OUTPUTENCODING --%>
	height: 33px;
	width: 33px;
	float: left;
}

.errtxtheader b {
	float: left;
	font-size: 15px;
	margin: 0px;
	padding: 15px 0px 0px 5px;
}

.err-reason {
	font-size: 11px;
	margin-left: 15px;
}

.err-reason ul {
	list-style: none;
	margin-top: 5px;
	margin-bottom: 5px;
	line-height: 15px;
}

.err-reason li {
	padding: 3px 0px;
}

.abusetxt {
	padding: 5px 0px 5px 5px;
	font-size: 11px;
}

.abusetxt a {
	color: #085DDC;
	text-decoration: none;
}

.abusetxt a:hover {
	text-decoration: underline;
}
</style>
</head>
<body>
	<table class="errtbl" align="center" cellpadding="0" cellspacing="0">
		<tr>
		<%
		PartnerAccount partnerAccount = PartnerAccountUtil.getPartnerAccount(request);
		boolean partnerLogoExists = partnerAccount != null && PartnerAccountUtil.isPartnerLogoExists(partnerAccount.getPartnerID());
		if(partnerLogoExists){%>
			<td valign="middle" align="center"><img src="<%=IAMEncoder.encodeHTMLAttribute(request.getContextPath())%>/static/file?t=org&ID=<%=partnerAccount.getPartnerID()%>" style="width:200px; height:30px; margin-top:5px; border: none;background: none" class="zohologo" /></td><%-- NO OUTPUTENCODING --%>
		<%}else{ %>
			<td valign="middle" align="center"><img src="<%=imgurl%>/spacer.gif" class="zohologo" /></td><%-- NO OUTPUTENCODING --%>
		<% }%>
		</tr>
		<tr>
			<td valign="middle">
				<div class="errmaindiv">
					<div class="errmsgdiv">
						<div class="errtxtheader">
							<img src="<%=imgurl%>/spacer.gif" align="absmiddle" /> <b> <%=IAMEncoder.encodeHTML(I18NUtil.getMessage("IAM.ERROR.SERVER.ERROR.OCCURED"))%><%-- NO OUTPUTENCODING --%>

							</b>
							<div>&nbsp;</div>
						</div>
						<br>
						<div class="err-reason">

							<b><%=IAMEncoder.encodeHTML(I18NUtil.getMessage("IAM.ERROR.POSSIBLE.REASONS.TITLE"))%> </b>
							<ul>
								<li>1. <%=IAMEncoder.encodeHTML(I18NUtil.getMessage("IAM.ERROR.POSSIBLE.REASONS.TXT1"))%>
								</li>
								<li>2. <%=IAMEncoder.encodeHTML(I18NUtil.getMessage("IAM.ERROR.POSSIBLE.REASONS.TXT2"))%>
								</li>
							</ul>
						</div>
					</div>
				</div>
			</td>
		</tr>
		<tr>
			<td valign="middle">
				<%--
				<div class="abusetxt">
					<%=I18NUtil.getMessage("IAM.ERROR.POSSIBLE.REASONS.FOOTER") %>
				</div>
				// No I18N --%>
			</td>
		</tr>
	</table>
</body>
</html>
