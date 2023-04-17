<%--$Id$--%>
<%@page import="com.zoho.accounts.phone.SMSUtil"%>
<%@page import="com.zoho.accounts.SystemResourceProto.ISDCode"%>
<%@page import="com.zoho.accounts.actions.unauth.JCaptcha"%>
<%@ include file="../../static/includes.jspf" %>
<%
    String cdigest = JCaptcha.getCaptchaDigest();
    String fromAddress = AccountsConfiguration.ADMIN_EMAIL_ID.getValue(); //No I18N
    boolean verify = Boolean.parseBoolean(request.getParameter("verify"));
    String jsFun = verify ? "submitRecoveryCode" : "resetpassword"; //No I18N
    String demail = request.getParameter("demail");
    String serviceUrl= request.getParameter("serviceurl");
    if(AccountsConfiguration.getConfigurationTyped("enable.password.backto", true) && Util.isMobileUserAgent(request)){//No I18N
    	if(request.getHeader("Referer")!=null){//No I18N
        	serviceUrl = request.getHeader("Referer");//No I18N  
        	request.getSession().setAttribute("fp_backtourl", serviceUrl);//No I18N
    	} else if(request.getAttribute("fp_backtourl")!=null) {//No I18N
    		serviceUrl = (String) request.getSession().getAttribute("fp_backtourl");//No I18N
    	}
    }
    serviceUrl = Util.getTrustedURL(-1, request.getParameter("servicename"), serviceUrl);
    boolean isMobile = Util.isMobileUserAgent(request);
    String css_url = isMobile ? cssurl_st+"/mobilelogin.css" : cssurl+"/style.css"; //No I18N
    boolean iscss = request.getParameter("css") != null && Util.isTrustedCSSDomain(request.getParameter("css"));
    String customisedCSSUrl = iscss ? request.getParameter("css") : null; 
    boolean overrideCSS = Boolean.parseBoolean(request.getParameter("override_css"));
    String userEmail=Util.isValid(request.getParameter("email"))?request.getParameter("email"):"";
    String orgemail=null;
    User user = Util.USERAPI.getUser(userEmail);
    if(user !=null){
    	Org org = Util.ORGAPI.getOrg(user.getZOID());
    	if(org != null){
    		Long orgContact= org.getOrgContact();
    		if(orgContact != -1){
    			UserEmail userprimaryemail=Util.USERAPI.getPrimaryEmail(orgContact);
 				orgemail=userprimaryemail.getEmailId();
    		}
    	}
    }
    boolean hideSignUpOption = !"false".equals(request.getParameter("hide_reg_link"));
    String portalid = request.getParameter("portal_id");
    String portalName = request.getParameter("portal_name");
    String portalDomain = request.getParameter("portal_domain");
	String supportEmailAddress = AccountsConfiguration.SUPPORT_EMAILID.getValue();
  %>
<!DOCTYPE html>
<html>
    <head>
	 <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <%if(isMobile){ %>
    	<meta name="viewport" content="width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=no" />
    <%} %>
	<title><%=Util.getI18NMsg(request,"IAM.ZOHO.ACCOUNTS")%></title>
	<style type="text/css">
		@font-face {
    		font-family: 'Open Sans';
    		font-weight: 400;
    		font-style: normal;
			src :local('Open Sans'),url('<%=imgurl%>/opensans/font.woff') format('woff');  <%-- NO OUTPUTENCODING --%>
		}
		.fp_errormsgnew {
			background-color: #ffdadd;
    		border-radius: 2px;
    		color: red;
    		margin-bottom: 1%;
    		padding: 5px;
    		text-align: center;
    		min-width:260px;
    		max-width: 340px;
    		font-size: 12px;
    		margin:0 auto;
		}
	</style>
	<script src="<%=jsurl%>/jquery-1.12.2.min.js" type="text/javascript"></script><%-- NO OUTPUTENCODING --%>
	<script src="<%=jsurl%>/common.js" type="text/javascript"></script> <%-- NO OUTPUTENCODING --%>
	<script src="<%=jsurl%>/xregexp-all.js" type="text/javascript"></script> <%-- NO OUTPUTENCODING --%>
	<%if(!isMobile && AccountsConfiguration.SIGNUP_PHONENUMBER_REQUIRED.toBooleanValue()){ %>
		<script src="<%=jsurl%>/chosen.jquery.js" type="text/javascript"></script><%-- NO OUTPUTENCODING --%>
		<link href="<%=cssurl%>/chosen.css" type="text/css" type="text/css" rel="stylesheet" /> <%-- NO OUTPUTENCODING --%>
		<link href="<%=cssurl_st%>/chosen-custom.css" type="text/css" type="text/css" rel="stylesheet" /> <%-- NO OUTPUTENCODING --%>
	<%} %>
	<%if(iscss) { %>
		<%if(overrideCSS){ %>	
	<link href="<%=IAMEncoder.encodeHTMLAttribute(css_url)%>" type="text/css" rel="stylesheet" /> <%-- NO OUTPUTENCODING --%>
		<%}%>
	<link href="<%=IAMEncoder.encodeHTMLAttribute(customisedCSSUrl)%>" type="text/css" rel="stylesheet" /> <%-- NO OUTPUTENCODING --%>
	<%}else {%>
	<link href="<%=IAMEncoder.encodeHTMLAttribute(css_url)%>" type="text/css" rel="stylesheet" /> <%-- NO OUTPUTENCODING --%>
	<%} %>

	<script>
            var msg = '<%=Util.isValid(request.getAttribute("msg")) ? request.getAttribute("msg") : ""%>';<%-- NO OUTPUTENCODING --%>
	</script>
	<style type="text/css">
		#country_code_select_chzn{
			border-color: transparent;
		}
		.chzn-single{
			left: -272px;
    		top: 9px;
			background-color:transparent !important;
			font-size:14px;
		}
		.chzn-drop{
			width:273.5px !important;
			margin-left:-274px !important;
			top:43px !important
		}
		#selectspan:after {
		    content: "";
		    height: 5px;
		    width: 5px;
		    display: inline-block;
		    border-left: 3px solid #444;
		    border-bottom: 3px solid #444;
		    transform: rotate(-45deg);
		    margin: 3px;
		    border-radius: 1px;
		    margin-left: 6px;
		}
	</style>
    </head>
	<body>
		<div id="mobfor_tb" class="for-mobile" style="text-align:center;margin:0px auto 0px;">
			<div class="logocolor logoadjust"><span class="colorred"></span><span class="colorgreen"></span><span class="colorblue"></span><span class="coloryellow"></span></div>
			<div>
<%
	if (!verify) {
		if(!Boolean.parseBoolean(request.getParameter("hide_logo"))){
			if(Util.isValid(portalid)) {
				String logourl = IAMProxy.getContactsServerURL(true) + "/static/file?t=org&ID=" + portalid + "&nocache=" + System.currentTimeMillis(); //No I18N
%>
				<img src="<%=IAMEncoder.encodeHTMLAttribute(logourl)%>" height="46" style="margin: 30px auto;"/>
			<%
			} else if(Util.isValid(portalDomain)) {
				String logourl = IAMProxy.getContactsServerURL(true) + "/static/file?t=org&domain=" + portalDomain + "&nocache=" + System.currentTimeMillis(); //No I18N
			%>
				<img src="<%=IAMEncoder.encodeHTMLAttribute(logourl)%>" height="46" style="margin: 30px auto;"/>
<%
			} else {
				if(isMobile) {
%>
				<div class="<%=IAMEncoder.encodeHTMLAttribute(Util.isValid(portalName) ? portalName : "mobilelogo")%>" style="margin: 30px auto 0px;"></div>
<%
				} else {
%>
				<div class="<%=IAMEncoder.encodeHTMLAttribute(Util.isValid(portalName) ? portalName +" logo-top" : "logo-top")%>" style="margin: 30px auto;"></div>
<%
				}
			}
		}
	%>
				<div class="title-1"<%if(isMobile) {%> style="font-size: 14px"<%}%> id="passwordreset_title"><%=Util.getI18NMsg(request,"IAM.FORGOTPASS.TITLE")%></div>
				<div class="bdre2"></div>
		<%if(!isMobile) {%>
				<div id="title-2"><%=Util.getI18NMsg(request,"IAM.FORGOT.PASSWORD.SUB.TITLE")%></div>
		<%} %>
				<div class="forgot_sub" id="forgot_sub"></div>
	<%} else {%>
				<div class="innerheading"><%=Util.getI18NMsg(request,"IAM.FORGOTPASS.SMS.TITLE")%></div>
				<div class="forgot_sub"><%=Util.getI18NMsg(request,"IAM.FORGOTPASS.SMS.SUBTITLE")%></div>
	<%}%>
				<div id="errmsgpanel" class="hide"></div>	
    			<div id="emailmsg" style="font-size: 13px; margin: 6%; text-align: justify;<%if(!isMobile){%>margin: 0px auto;width: 36%;<%}%>"></div>	
    			<div class="backtohome" style="text-align: center;margin-top: 8%;display:none">
	 				<span class="whitebutton" onclick="goToHomeUrl()"><%=Util.getI18NMsg(request,"IAM.BACKTO.HOME")%></span>
				</div>
				<div class="backtohome_web" style="display:none;text-align: center;margin: 3%">
	 				<span class="cancel-btn" onclick="goToHomeUrl()"><%=Util.getI18NMsg(request,"IAM.BACKTO.HOME")%></span>
	 			</div>
	<% if(isMobile){%>
  				<div id="passwdopt" style="text-align: left;margin-left: 8%; display:none;">
  					<p id="resetpassmsg" style="font-size: 15px;"> <%=Util.getI18NMsg(request,"IAM.RESET.PASSWORD.OPTIONS")%></p>
  					<div id="resetbyemail" style="font-size: 14px;">
  						<input type="radio" name="radiobtn" id="resetbylink" checked onclick="toggle('listofemails','listofmobiles')">
  						<span style="cursor:pointer;color:#141823;margin-left: 2%;"><%=Util.getI18NMsg(request,"IAM.RESET.PASSWORD.EMAIL.OPTION")%> </span>
  						<div id="resetpassemail" style="cursor:pointer;color:#141823;margin-left: 5%;"><%-- NO I18N --%>
  							<select id="listofemails">
  							</select>
  						</div>
  					</div>
  
  					<div id="resetbyphone" style="font-size: 14px; margin-top: 3%;">
  						<input type="radio" name="radiobtn" id="resetbynum" onclick="toggle('listofmobiles','listofemails')">
  						<span style="cursor:pointer;color:#141823;margin-left: 1%;"><%=Util.getI18NMsg(request,"IAM.RESET.PASSWORD.OTP.OPTION")%> </span>
  						<div id="otpmobile" style="cursor:pointer;color:#141823;margin-left: 5%;"><%-- NO OUTPUTENCODING --%><%-- NO I18N --%>
  							<select id="listofmobiles"  disabled>
  							</select>
  						</div>
  					</div>
  
  					<div class="inputText" style="border:none;margin-top: 2%;">
						<span class="bluebutton" id="passResetOption"><%=Util.getI18NMsg(request,"IAM.SUBMIT")%></span>
						<span class="whitebutton" onclick="goToHomeUrl()"><%=Util.getI18NMsg(request,"IAM.CANCEL")%></span>
						<span class="loadingVerify" Style="display:none;"></span>
  					</div>
				</div>
	<%} else {%>
  				<div id="passwdopt" style="text-align: left;margin-left: 41%; margin-bottom: 5%; display:none;">
  					<p style="font-size: 16;"> <%=Util.getI18NMsg(request,"IAM.RESET.PASSWORD.OPTIONS")%></p>
  					<div id="resetbyemail" style="font-size: 13px; margin: 3%;"">
  						<input type="radio" name="radiobtn" id="resetbylink"  class="radiobtn" checked onclick="toggle('listofemails','listofmobiles')">
  						<span style="cursor:pointer;color:#141823;margin-left: 1%;"><%=Util.getI18NMsg(request,"IAM.RESET.PASSWORD.EMAIL.OPTION")%> </span>
  						<div id="resetpassemail" style="cursor:pointer;color:#141823;margin-left: 5%;"><%-- NO I18N --%>
  							<select id="listofemails" style="border: 1px solid #bdc7d8;font-size: 14px;margin-top: 8px;">
  							</select>
  						</div>
  					</div>
  
  					<div id="resetbyphone" style="font-size: 13px; margin: 3%;">
  						<input type="radio" name="radiobtn" id="resetbynum"  class="radiobtn" onclick="toggle('listofmobiles','listofemails')" >
  						<span style="cursor:pointer;color:#141823;margin-left: 1%;"><%=Util.getI18NMsg(request,"IAM.RESET.PASSWORD.OTP.OPTION")%> </span>
  						<div id="otpmobile" style="cursor:pointer;color:#141823;margin-left: 5%;"><%-- NO OUTPUTENCODING --%><%-- NO I18N --%>
  							<select id="listofmobiles" style=" width: 16%; border: 1px solid #bdc7d8; color: #414141;font-size: 14px;margin-top: 1%;" disabled>
  							</select>
  						</div>
  					</div>
  
					<div id="submitprefoption" style="margin-top: 1%;margin-left: 5%;">
			 			<span class="redBtn" id="passResetOption"><%=Util.getI18NMsg(request,"IAM.SUBMIT")%></span>
			 			<span class="cancel-btn" onclick="goToHomeUrl()"><%=Util.getI18NMsg(request,"IAM.CANCEL")%></span>
	  		 			<span class="loadingVerify" style="display:none;"></span>
 					</div>
				</div>
	<%}%>
				<div id="password">
					<form name=password onsubmit="return <%=jsFun%>(this);" method="POST"> <%-- NO OUTPUTENCODING --%>
	<% if (demail == null) { %>
		<% if(isMobile){%>
						<div class="field_label">
							<%if(AccountsConfiguration.SIGNUP_PHONENUMBER_REQUIRED.toBooleanValue()){ %>
							<div style="display:inline-block;position:  absolute;margin-left:5px;margin-top: 11px;z-index:1">
   						 		<div id="selectspan" class="selectspanforgot"style="display:none;margin-left: 3px;top:2px;position: absolute;z-index: 0;text-align: center;font-size:14px"><span>-1</span></div>
   						 		<select class="chosen-select" id="country_code_select" style="display:none;opacity:0;width: 68px;z-index:1;margin-top: 4px;" >
								    <%  
								    List<ISDCode> countryList = SMSUtil.getISDCodes();
								    String reqCountry=request.getLocale()!=null && request.getLocale().getCountry()!=null?request.getLocale().getCountry():"";
								    for(ISDCode isdCode : countryList){
										String display=IAMEncoder.encodeHTMLAttribute(isdCode.getCountryName())   +"&nbsp;(+"+IAMEncoder.encodeHTMLAttribute(String.valueOf(isdCode.getDialingCode()))+") ";
									%>
									<option data-num="<%=IAMEncoder.encodeHTMLAttribute(isdCode.getCountryCode())%>" <%if(isdCode.getCountryCode().equalsIgnoreCase(reqCountry)){ %>selected<%} %> value="<%=IAMEncoder.encodeHTMLAttribute(String.valueOf(isdCode.getDialingCode())) %>"><%= display %> </option>
									<%}%>
								</select>
   						 	</div>
   						 	<%}%>
							<input type=text class="input_forgot" id="email" name="email" size="30" style="padding-left:5px"  value="<%=IAMEncoder.encodeHTMLAttribute(userEmail)%>" <%if(isMobile){ %>placeholder='<%=AccountsConfiguration.SIGNUP_PHONENUMBER_REQUIRED.toBooleanValue() ? Util.getI18NMsg(request, "IAM.FORGOT.REGISTERED.EMAIL.OR.MOBILE") : Util.getI18NMsg(request, "IAM.FORGOT.REGISTERED.EMAIL")%>' autocapitalize="off" autocomplete="off" autocorrect="off" <%}%> onkeypress="closemsg()" placeholder='<%=Util.getI18NMsg(request, "IAM.ACCOUNT.VERIFY.REGISTER.EMAIL")%>'>
						</div>
		<% }else{%>
						<div class="unauthlabel">
							<span>
								<div class="inlineLabel hide" style="position: absolute;width: 43%;margin-top: 10px;"><%=AccountsConfiguration.SIGNUP_PHONENUMBER_REQUIRED.toBooleanValue() ? Util.getI18NMsg(request, "IAM.FORGOT.REGISTERED.EMAIL.OR.MOBILE") : Util.getI18NMsg(request, "IAM.FORGOT.REGISTERED.EMAIL")%></div>
								<input type=text class="unauthinputText" id="email" name="email"  value="<%=IAMEncoder.encodeHTMLAttribute(userEmail)%>" onkeyup="animatePlaceHolder(this,'','-44px');" <%if(isMobile){ %>placeholder='<%=Util.getI18NMsg(request, "IAM.EMAIL.ADDRESS")%>' autocapitalize="off" autocomplete="off" autocorrect="off" <%}%> onkeypress="closemsg()" placeholder='<%=AccountsConfiguration.SIGNUP_PHONENUMBER_REQUIRED.toBooleanValue() ? Util.getI18NMsg(request, "IAM.FORGOT.REGISTERED.EMAIL.OR.MOBILE") : Util.getI18NMsg(request, "IAM.FORGOT.REGISTERED.EMAIL")%>' style="width: 260px; line-height: 31px;">
								<%if(AccountsConfiguration.SIGNUP_PHONENUMBER_REQUIRED.toBooleanValue()){ %>
								<select class="chosen-select" id="country_code_select" style="width:258px">
									    <% 
									    String reqCountry=request.getLocale()!=null && request.getLocale().getCountry()!=null?request.getLocale().getCountry():"";
									    List<ISDCode> countryList = SMSUtil.getISDCodes();
									    for(ISDCode isdCode : countryList){
											String display=IAMEncoder.encodeHTMLAttribute(isdCode.getCountryName())   +"&nbsp;(+"+IAMEncoder.encodeHTMLAttribute(String.valueOf(isdCode.getDialingCode()))+") ";
										%>
										<option data-num="<%=IAMEncoder.encodeHTMLAttribute(isdCode.getCountryCode())%>" <%if(isdCode.getCountryCode().equalsIgnoreCase(reqCountry)){ %>selected<%} %> value="<%=IAMEncoder.encodeHTMLAttribute(String.valueOf(isdCode.getDialingCode())) %>"><%= display %> </option>
										<%}%>
								</select> 
								<%}%>
							</span>
						</div>
						<%if(AccountsConfiguration.SIGNUP_PHONENUMBER_REQUIRED.toBooleanValue()){ %>
						<div class="unauthlabel" id="ie_select" style="display:none;">
							<span>
								<div class="inlineLabel hide" style="position: absolute; width: 43%; margin-top: 10px; display: block; margin-left: -44px; opacity: 1;"><%=IAMEncoder.encodeHTMLAttribute(Util.getI18NMsg(request,"IAM.COUNTRY.CODE"))%></div>
								<select class="chosen-select" id="country_code_select_ie" style="width: 273px; line-height: 31px; background-color:  transparent;height:39px" align="center">
									    <% 
									    String reqCountry=request.getLocale()!=null && request.getLocale().getCountry()!=null?request.getLocale().getCountry():"";
									    List<ISDCode> countryList = SMSUtil.getISDCodes();
									    for(ISDCode isdCode : countryList){
											String display=IAMEncoder.encodeHTMLAttribute(isdCode.getCountryName())   +"&nbsp;(+"+IAMEncoder.encodeHTMLAttribute(String.valueOf(isdCode.getDialingCode()))+") ";
										%>
										<option data-num="<%=IAMEncoder.encodeHTMLAttribute(isdCode.getCountryCode())%>" <%if(isdCode.getCountryCode().equalsIgnoreCase(reqCountry)){ %>selected<%} %> value="<%=IAMEncoder.encodeHTMLAttribute(String.valueOf(isdCode.getDialingCode())) %>"><%= display %> </option>
										<%}%>
								</select> 
							</span>
						</div>
						<%}%>
		<% }  %>
	<% } else { %>
						<input type="hidden" name="email" value="<%=IAMEncoder.encodeHTMLAttribute(demail)%>">
	<% } %>
		    			<input type="hidden" name="cdigest" value="<%=cdigest%>"> <%-- NO OUTPUTENCODING --%>
	<% if (verify) { %>
						<div class="field_label">
							<input type=text class="field_label_input" id="code" name="code" size="30" onkeypress="closemsg()" value="<%=request.getParameter("code") == null ? "" : IAMEncoder.encodeHTMLAttribute(request.getParameter("code"))%>">
						</div>
	<%}%>
	<% if(isMobile){%>
						<div class="captchadiv" style="margin-top:10px;">
							<div class="desctd fllt">
								<%=Util.getI18NMsg(request, "IAM.IMAGE.VERIFICATION")%>&nbsp;:&nbsp;
							</div>
							<div class="descRtd txtalignlft">
								<div class="rempadding" style="padding:5px;"><%=Util.getI18NMsg(request, "IAM.TYPE.IMAGE.CHARACTERS")%></div>
								<input type=text style="width:202px;" class="input_forgot insidecaptcha" name="captcha" maxlength=8 onkeypress="closemsg()" <%if(isMobile){ %> autocapitalize="off" autocomplete="off" autocorrect="off"<%}%>>
							</div>
							<div style="margin-top:10px;">
								<div class="desctd fllt"></div>
								<div class="descRtd txtalignlft">
									<table style="padding: 0; margin: 0;">
										<tr style="padding: 0; margin: 0;">
											<td style="padding: 0; margin: 0;"><div class="captcha" id="hipimg"></div></td>
											<td valign="top"><img src="<%=IAMEncoder.encodeHTMLAttribute(request.getContextPath())%>/images/spacer.gif" onclick="changeHip()" class="change-captcha-icon" title='<%=Util.getI18NMsg(request,"IAM.REGISTER.RELOAD.CAPTCHA")%>'/></td>
										</tr>
									</table>
								</div>
							</div>
						</div>
						<div class="otp" Style="display:none;text-align: left;">
							<div id="forgotpassmobiletxt"><%=Util.getI18NMsg(request, "IAM.MOBILE.VERIFICATION.SENT.MSG")%></div> <%-- NO I18N --%>
							<div id="forgotpassmobiletxt" class="resendtxt" Style="display:none;"></div> <%-- NO I18N --%>
							<input type="text" class="input_forgot" id="verifyCode" name="otpcode"  value="" placeholder='<%=Util.getI18NMsg(request, "IAM.VERIFY.CODE")%>' autocapitalize="off" autocomplete="off" autocorrect="off" onkeypress="closemsg()" style="width: 44%;">
							<span class="resendbutton" onclick="resendVerifyCode();" Style="display:none;"><%=Util.getI18NMsg(request, "IAM.TFA.RESEND.CODE")%></span><%-- NO I18N --%>
						</div>

						<div style="margin-top:10px;">
							<div class="desctd fllt"></div>
							<div class="descRtd txtalignlft">
								<span class="bluebutton" onclick="<%=jsFun%>(document.password);"><%=Util.getI18NMsg(request, "IAM.REQUEST")%></span> <%-- NO OUTPUTENCODING --%>
								<span class="whitebutton" onclick="window.parent.location.href='<%=IAMEncoder.encodeJavaScript(serviceUrl)%>';"><%=Util.getI18NMsg(request, "IAM.CANCEL")%></span>
							</div>
						</div>
	<%}else{ %>
						<div class="unauthlabel">
							<div class="inlineLabel" style="position: absolute;margin-top: 9px;margin-top: 9px;"></div>
							<div class="unauthinputText" style="height: 90px; padding: 0px; width: 260px; line-height: 31px;margin: 0 auto;">
								<div class="captcha" id="hipimg" style="width: 220px;float: left;border-right: 1px solid #ccc;height: 92px;"></div>
								<span><img src="<%=IAMEncoder.encodeHTMLAttribute(request.getContextPath())%>/images/spacer.gif" onclick="changeHip()" class="change-captcha-icon" title='<%=Util.getI18NMsg(request,"IAM.REGISTER.RELOAD.CAPTCHA")%>'/></span>
							</div>
						</div>
						<div class="unauthlabel">
							<span>
								<div class="inlineLabel hide" style="position: absolute;width: 43%;margin-top: 10px;"><%=Util.getI18NMsg(request, "IAM.UNAUTH.NEW.CAPTCHA.TEXT")%></div>
								<input type=text  class="unauthinputText insidecaptcha" name="captcha" maxlength=8 onkeypress="closemsg()" onkeyup="animatePlaceHolder(this,'','-44px');" <%if(isMobile){ %> autocapitalize="off" autocomplete="off" autocorrect="off"<%}%> placeholder="<%=Util.getI18NMsg(request, "IAM.UNAUTH.NEW.CAPTCHA.TEXT")%>" style="width: 260px; line-height: 31px;">
							</span>
						</div>
		
						<div class="otp" Style="display:none;">
							<div class="errormsgtxt" Style="margin: 0px auto; display:none;"></div> <%-- NO I18N --%>
							<div Style="margin-top:1%;">
								<div class="inlineLabel hide" style="position: absolute; width: 43%; margin-top: 10px; opacity: 1; margin-left: -44px; display: block;"><%=Util.getI18NMsg(request, "IAM.TFA.ENTER.VERIFICATION.CODE") %></div><%-- NO I18N --%>
								<input type=text  id="verifyCode" name="otpcode" maxlength=8 onkeypress="closemsg()" onkeyup="animatePlaceHolder(this,'','-44px');" <%if(isMobile){ %> autocapitalize="off" autocomplete="off" autocorrect="off"<%}%> placeholder="Verification Code" style="width: 260px; line-height: 31px;">
								<div id="resendCode" onclick="resendVerifyCode();"></p><%=Util.getI18NMsg(request, "IAM.TFA.RESEND.CODE")%></p></div>
							</div>
						</div>
						<div class="button">
							<span <%if(isMobile){%>class="bluebutton" <%}else {%>class="redBtn"  style="margin-right:0px;" id="buttonloader" <%} %>  tabindex="1"  onclick="<%=jsFun%>(document.password);"><%=Util.getI18NMsg(request, "IAM.REQUEST")%><span class="loadingImg" Style="display:none"></span></span> <%-- NO OUTPUTENCODING --%>
							<span <%if(isMobile){%>class="whitebutton" <%}else {%>class="cancel-btn" style="margin-left:6px;"<%} %> tabindex="1" onclick="goToHomeUrl()"><%=Util.getI18NMsg(request, "IAM.BACKTO.SIGNIN")%></span>
						</div>
	<%} %>
					<input type="submit" style="display:none">
					</form>
				</div>
				<div id="successmsgpanel" class="hide mob_hide"><span id="successresp" <%if(!isMobile){%><% }%>>&nbsp;</span><div style="margin-top:10px;display:none;" id="success_mobile_txt"><%=Util.getI18NMsg(request, "IAM.FORGOT.SMS.ALSO.SENT")%></div><div class="mob_but_head" style="text-align: center;margin-top: 8%">
	 				<span <%if(isMobile){%>class="whitebutton" <%}else {%>class="cancel-btn"<%} %>  onclick="goToHomeUrl()"><%=Util.getI18NMsg(request, "IAM.BACKTO.HOME") %></span><%-- NO OUTPUTENCODING --%></div>
				</div>
			</div>
	<%if(!verify){%>
			<div class="pagenotesdiv mob_hide" style="display:none">
				<div><span><%=Util.getI18NMsg(request, "IAM.FORGOTPASS.NOTES", IAMEncoder.encodeHTML(fromAddress))%></span></div>
			</div>
	<% } %>
	<%if(!isMobile){ %>
			<div><%@ include file="../unauth/footer.jspf" %></div>
	<%} else if(!Util.isFujixerox()){%>
			<div class="otheracc-topborder" style="font-size: 11px;margin-bottom: 9px;">
				<div style="margin:15px 0px"><%=Util.getI18NMsg(request, "IAM.FOOTER.COPYRIGHT", Util.getCopyRightYear())%></div>
			</div>
	<%}%>
		</div>
	</body>
</html>
<script>
	 var csrfParam = '<%=SecurityUtil.getCSRFParamName(request)+"="+SecurityUtil.getCSRFCookie(request)%>';<%-- NO OUTPUTENCODING --%>
	 var crossDC = '<%=request.getAttribute("crossdc") %>'; <%-- NO OUTPUTENCODING --%>
	 var isChosen=true;
		$('#passResetOption').click(function() {
			var user = $('#email').val();
			if(user == ""){
				user = '<%=IAMEncoder.encodeJavaScript(request.getParameter("email")) %>';
			}
            if(isValidMobile(user)){
            	user = (isChosen?$( "#country_code_select" ).val():$( "#country_code_select_ie" ).val())+'-'+user;
            }
			var params = params + "&serviceurl=<%=IAMEncoder.encodeJavaScript(Util.encode(serviceUrl))%>"; //No I18N
			   if($('#resetbylink').is(':checked')) {
				   var email = $('#listofemails').val();
				   params = params + "&email="+euc(email.toLowerCase()); 	//No I18N
				   params = params + "&prefOption=email"+ "&"+csrfParam; //No I18N
			        <%if(Util.isValid(portalid)) {%>
			        params = params + "&portal_id=<%=IAMEncoder.encodeJavaScript(portalid)%>";
			        <%}%>
			        <%if(Util.isValid(portalName)) {%>
			        params = params + "&portal_name=<%=IAMEncoder.encodeJavaScript(portalName)%>";
			        <%}%>
			        <%if(Util.isValid(portalDomain)) {%>
			        params = params + "&portal_domain=<%=IAMEncoder.encodeJavaScript(portalDomain)%>";
			        <%}%>
				   var res = getPlainResponse("<%=request.getContextPath()%>/password/selectpref", params); <%-- NO OUTPUTENCODING --%>	//No I18N
				   try{
					   var obj = JSON.parse(res);
					   if(obj.status == "success"){
				            $('#emailmsg').html(obj.message); //No I18N
				            $('#passwdopt').hide();
				            <%if(isMobile){%>
				            $('.backtohome').show();
				            <%}else{%>
				            $('.backtohome_web').show();
				            <%}%>
						   	return false;
					   }else if(obj.status == "error"){//No I18N
						   showmsg(obj.message);
					   }
				   }catch(e){
				   	   $('#passwdopt').hide();
				   	   email =  $( "#listofemails option:selected" ).text();
					   validateResponse(res,email);
					   return;
				   }
			   }else{
				   var mobile = $('#listofmobiles').val();
				   params = params + "&mobile="+euc(mobile.toLowerCase()); 	//No I18N
				   params = params + "&prefOption=otp"+ "&"+csrfParam; //No I18N
			        <%if(Util.isValid(portalid)) {%>
			        params = params + "&portal_id=<%=IAMEncoder.encodeJavaScript(portalid)%>";
			        <%}%>
			        <%if(Util.isValid(portalName)) {%>
			        params = params + "&portal_name=<%=IAMEncoder.encodeJavaScript(portalName)%>";
			        <%}%>
			        <%if(Util.isValid(portalDomain)) {%>
			        params = params + "&portal_domain=<%=IAMEncoder.encodeJavaScript(portalDomain)%>";
			        <%}%>
				   $('.loadingVerify').show();
				   var res = getPlainResponse("<%=request.getContextPath()%>/password/selectpref", params); <%-- NO OUTPUTENCODING --%>	//No I18N
				   var obj = JSON.parse(res);
				   if(obj.status == "success"){
						window.parent.location.href=obj.redirecturl;   
				   }else if(obj.status == "error"){//No I18N
					   showmsg(obj.message);
				   }
					return;
				   }			
			});
		
		$('#verifyCode').keypress(function(e) {
	        $('.errormsgtxt').hide();
	    });
	
		 if(crossDC == 'true'){
			 var prefData = '<%=request.getAttribute("prefData") %>'; <%-- NO OUTPUTENCODING --%>
			 var obj = JSON.parse(prefData);
			 handleMobilePref(obj);
		 }
		
	function toggle(hide, show){
		$("#"+show).attr("disabled", "disabled");
		$("#"+hide).removeAttr("disabled");
	}
	
	function handleMobilePref(obj){
        	$('#password').hide();
            $('#title-2').hide();
        	$('#passwdopt').show();
        	var listofemails = obj.listofemails;
  		  	var x = document.getElementById("listofemails");
  		  	if(listofemails.length == 0){
  		  		$('#resetbyemail').hide();
  		  		$('#resetbynum').attr('checked', 'checked'); //No I18N
  		  		$('#listofmobiles').removeAttr('disabled'); //No I18N
  		  	}
        	for(i=0 ; i<listofemails.length ; i++){
        		  var option = document.createElement("option");
        		  var emailObj = listofemails[i];
        		  option.text = emailObj.email;
        		  option.value = emailObj.encryptedval;
        		  x.add(option);
        	}
        	var mobileCount = obj.listofmobiles.length;
        	if(mobileCount == 0){
        		$('#resetbyphone').hide();
        		return;
        	}
  		  	var x = document.getElementById("listofmobiles");
        	var listofmobiles = obj.listofmobiles;
        	for(i=0 ; i<listofmobiles.length ; i++){
        		  var option = document.createElement("option");
        		  var mobileObj = listofmobiles[i]
        		  option.text = mobileObj.mobile;
        		  option.value = mobileObj.encryptedval;
        		  x.add(option);
        	}
        	return;
 	}
		
    function resetpassword(f) {
       	var email = f.email.value.trim();
        if(email == "") {
            showmsg('<%=Util.getI18NMsg(request, "IAM.FORGOTPASS.ENTER.YOUR.EMAIL.OR.MOBILE")%>');
            f.email.focus();
            return false;
        }
        email = email.toLowerCase().replace(/ /g,'');
        if(!isEmailId(email) && !isValidMobile(email)) {
            showmsg('<%=Util.getI18NMsg(request, "IAM.FORGOTPASS.INVALID.EMAIL.OR.MOBILE")%>');
            f.email.focus();
            return false;
        }
        if(isValidMobile(email)){
        	if(isChosen){
        		email = $("#country_code_select_chzn").is(":visible")||$("#country_code_select").is(":visible")?($( "#country_code_select" ).val()+'-'+email):email;
        	}else{
        		if($("#country_code_select_ie").is(":visible")){
        			email=$( "#country_code_select_ie" ).val()+'-'+email;
        		}
        	}
		}
        if(f.captcha.value.trim() == "") {
            showmsg('<%=Util.getI18NMsg(request, "IAM.ENTER.IMAGE")%>');
            f.captcha.focus();
            return false;
        }
        showLoadingButton('33');
        var params = "email=" + euc(email) + "&captcha=" + euc(f.captcha.value) + "&cdigest=" + document.password.cdigest.value + "&serviceurl=<%=IAMEncoder.encodeJavaScript(Util.encode(serviceUrl))%>"; //No I18N
        <%if(Util.isValid(portalid)) {%>
        params = params + "&portal_id=<%=IAMEncoder.encodeJavaScript(portalid)%>";
        <%}%>
        <%if(Util.isValid(portalName)) {%>
        params = params + "&portal_name=<%=IAMEncoder.encodeJavaScript(portalName)%>";
        <%}%>
        <%if(Util.isValid(portalDomain)) {%>
        params = params + "&portal_domain=<%=IAMEncoder.encodeJavaScript(portalDomain)%>";
        <%}%>
        var res = getPlainResponse("<%=request.getContextPath()%>/password", params); <%-- NO OUTPUTENCODING --%> <%-- No I18N --%>
    	res = res.trim();
    	validateResponse(res,email,f);
    	return false;
    }
    
    
    function validateResponse(res, email, f){
    	try{
    		var obj = JSON.parse(res);
    	    if(obj && obj.status == "success"){
    	    	if(obj.message){
    	        	$('#password').hide();
    	            $('#title-2').hide();
    				$('#emailmsg').html(obj.message);
    				<%if(isMobile){%>
    	            $('.backtohome').show();
    	            <%}else{%>
    	            $('.backtohome_web').show();
    	            <%}%>
    			   	return;
    	    	}
    	    	window.parent.location.href = obj.redirecturl;
    	    	return;
       		} else if(obj && obj.crossdc == 'true'){
       			window.parent.location.href = obj.load_password_url;
       			return;	
       		} else if(obj && obj.status == "select_prefoption"){//No I18N
				handleMobilePref(obj);
				return;
			}else if(obj && obj.status == "success_mobile"){//No I18N
	        	$('#password').hide();
	            $('#title-2').hide();
				$('#emailmsg').html(obj.message);
				<%if(isMobile){%>
	            $('.backtohome').show();
	            <%}else{%>
	            $('.backtohome_web').show();
	            <%}%>
			   	return;
			}else if(obj && obj.status == 'error') {//No I18N
				showmsg('<%=Util.getI18NMsg(request, "IAM.ERROR.GENERAL")%>'); 
				return;
			}
   		}catch(e){
    	}
        if(res.indexOf("user_recovery_option-")!=-1){
        	de("passwordreset_title").innerHTML =formatMessage('<%=Util.getI18NMsg(request,"IAM.RESET.PASSWORD.ASSISTANCE")%>', email); //No I18N
        	de("forgot_sub").style.display="none";
        	de('password').className = 'hide mob_hide';
        	 var useremails=res.split("-")[1];
        	if(useremails.indexOf(",")==-1){
        		de('successresp').innerHTML = "<span>"+formatMessage('<%=Util.getI18NMsg(request,"IAM.RESET.PASSWORD.EMAIL.SENT")%>', useremails)+"</span>"; //No I18N            		
        		de('successmsgpanel').className = "successmsg_forgot"; //No I18N
        	}
        	de("errmsgpanel").style.display="none";
        	if(de("title-2")){de("title-2").style.display="none";}
        	hideLoadinginButton('12');
        }
        if(res.indexOf("success-")!=-1) { //No I18N
        	de("errmsgpanel").style.display="none";
	        if(de("title-2")){de("title-2").style.display="none";}
            var adminEmailId = res.split("-")[1];
            var htmldiv = "";
			de('password').className = 'hide mob_hide';
            if(adminEmailId.trim().length != 0){
            	if(adminEmailId.indexOf("contactsupport")!=-1){
            		de('successresp').innerHTML ="<span>"+formatMessage('<%=Util.getI18NMsg(request,"IAM.RESET.PASSWORD.HOSTED.ORFADMIN.CHECK",AccountsConfiguration.SUPPORT_EMAILID.toStringValue())%>')+ "</span>"; //No I18N
            	}else if(res.indexOf("norecoveryoptions")!=-1){
            		de('successresp').innerHTML = "<span>"+ formatMessage('<%=Util.getI18NMsg(request,"IAM.RESET.PASSWORD.NORECOVERY.OPTIONS",AccountsConfiguration.SUPPORT_EMAILID.toStringValue())%>')+ "</span>"; //No I18N
            	}else{
            		de('successresp').innerHTML = "<span>"+ formatMessage('<%=Util.getI18NMsg(request,"IAM.FORGOTPASS.HOSTED.EMAIL")%>', adminEmailId)+ "</span>"; //No I18N	
            	}
            }
            
            else if(adminEmailId.trim().length == 0){
            	de('successresp').innerHTML = "<span>"+formatMessage('<%=Util.getI18NMsg(request,"IAM.FORGOTPASS.SUCCESS.TXT")%>', email)+"</span>"+htmldiv; //No I18N
            }
            de('successmsgpanel').className = "successmsg_forgot"; //No I18N
           	de("forgot_sub").style.display = "none"; //No i18N
           	hideLoadinginButton('12');
           	if(f){
                f.reset();
           	}
            return false;
        }
        else if(res  == "invalid_hip") {
            showmsg('<%=Util.getI18NMsg(request, "IAM.ERROR.INVALID_IMAGE_TEXT")%>');
            f.captcha.focus();
        }
        else if(res == 'no_such_email') {
        	<%if(hideSignUpOption) {%>
    		showmsg('<%=Util.getI18NMsg(request, "IAM.FORGOTPASS.NOSUCH.USER")%>');
        	<%} else {%>
        	showmsg('<%=Util.getI18NMsg(request, "IAM.FORGOTPASS.NOSUCH.EMAIL", AccountsConfiguration.ACCOUNTS_SERVER.getValue()+"/register?servicename="+ Util.getIAMServiceName())%>');
        	<%}%>
        	if(f){
            	f.email.focus();
        	}
        }
        else if(res == 'no_such_email_or_mobile') {
        	<%if(hideSignUpOption) {%>
    		showmsg('<%=Util.getI18NMsg(request, "IAM.FORGOTPASS.NOSUCH.ID")%>');
        	<%} else {%>
        	showmsg('<%=Util.getI18NMsg(request, "IAM.FORGOTPASS.NOSUCH.EMAIL.OR.MOBILE", AccountsConfiguration.ACCOUNTS_SERVER.getValue()+"/register?servicename="+ Util.getIAMServiceName())%>');
        	<%}%>
        	if(f){
            	f.email.focus();	
        	}
       }else if(res =='inactive_user'){ //No I18N
    	   showmsg('<%=Util.getI18NMsg(request, "IAM.ERROR.USER_NOT_ACTIVE")%>'); 
    	}else if(res =='unconfirmed_primary_number'){//No I18N
    		showmsg('<%=Util.getI18NMsg(request, "IAM.ERROR.MYPHONENUMBER.CONFIRM.PRIMARY")%>'); 
    	}else if(res.startsWith("saml_user:")){//No I18N
    		showmsg(res.substring(res.indexOf(":")+1,res.length));
    	} else if(res == 'not_authorized_access') { //No I18N
    		showmsg('<%=Util.getI18NMsg(request, "IAM.UNAUTHORIZED.REQUEST")%>');
    	}else {
            showmsg(res);
            if(f){
                f.email.focus(); //No I18N
            }
        }
        hideLoadinginButton('12');
        changeHip();
        return false;
    }

    function submitRecoveryCode(f) {
        if(!isEmailId(f.email.value)) {
            showmsg('<%=Util.getI18NMsg(request, "IAM.ERROR.VALID.EMAIL")%>');
            f.email.focus();
            return false;
        }
        var val = f.code.value.trim();
        if(val == "") {
            showmsg('<%=Util.getI18NMsg(request, "IAM.FORGOT.ENTER.RECOVERY.CODE")%>');
            f.code.focus();
            return false;
        } else if(isNaN(val)) {
            showmsg('<%=Util.getI18NMsg(request, "IAM.FORGOT.INVALID.RECOVERY.CODE")%>');
            f.code.focus();
            return false;
        }
        if(f.captcha.value == "") {
            showmsg('<%=Util.getI18NMsg(request, "IAM.ENTER.IMAGE")%>');
            f.captcha.focus(); //No I18N
            return false; //No I18N
        }
        f.email.value = f.email.value.trim(); //No I18N
        f.code.value = f.code.value.trim();
        f.captcha.value = f.captcha.value.trim();
        f.submit();
    }

    function showmsg(msg) {
        de('errmsgpanel').className = <%if(isMobile){%>"errormsg"<%}else{%>"fp_errormsgnew"<%}%>; //No I18N
        de('errmsgpanel').innerHTML = msg; //No I18N
        hideLoadinginButton('12');
    }
    function closemsg() {de('errmsgpanel').className='hide mob_hide';}

    function showHip(cdigest) {
    	if ( !(cdigest && isValid(cdigest)) ) {
		if (document.password.cdigest) {
			cdigest = document.password.cdigest.value; <%-- No I18N --%>
		}
	}
        var hipRow = de('hipimg'); //No I18N
        hipRow.innerHTML= '<img name="hipImg" id="hip" width="216" height="90" src="<%=request.getContextPath()%>/accounts/captcha?cdigest='+ cdigest +'&width=200&height=75"  alt="<%=Util.getI18NMsg(request,"IAM.HIP.IMAGE")%>" title="<%=Util.getI18NMsg(request,"IAM.TITLE.RANDOM")%>" align="absmiddle" style="height:90px;">'; <%-- NO OUTPUTENCODING --%>
    }

    function changeHip() {
    	var hipdigest = getNewHip('<%=request.getContextPath()%>/accounts/captcha', 'action=newcaptcha'); <%-- NO OUTPUTENCODING --%> <%-- No I18N --%>
    	if (document.password.cdigest)
    		document.password.cdigest.value = hipdigest
	showHip(hipdigest);<%-- No I18N --%>
    }

	function isValid(instr) {
	    return instr != null && instr != "" && instr != "null"; //No I18N
	}

    function getNewHip(action, params) {
        var objHTTP;
        objHTTP = xhr();
	objHTTP.open('GET', action + "?" + params, false); <%-- No I18N --%>
        objHTTP.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded;charset=UTF-8'); <%-- No I18N --%>
        objHTTP.send(params);
        return objHTTP.responseText;
    }

    function xhr() {
        var xmlhttp;
        if (window.XMLHttpRequest) {
            xmlhttp=new XMLHttpRequest();
        }
        else if(window.ActiveXObject) {
	    try { <%-- No I18N --%>
	        xmlhttp=new ActiveXObject("Msxml2.XMLHTTP"); <%-- No I18N --%>
	    }
	    catch(e) { <%-- No I18N --%>
	        xmlhttp=new ActiveXObject("Microsoft.XMLHTTP"); <%-- No I18N --%>
	    }
        }
        return xmlhttp;
    }
    

    window.onload = function() {
    	if(document.password) {
        	var mail = document.password.email;
        	if(msg != undefined && msg != ''){showmsg(msg);}
        	if(mail && mail.type != "hidden") {
        		de('email').focus();//No I18N
        	} else {
        		document.password.code.focus();
        	}
        	showHip();
        	$('#password input[placeholder]').zPlaceHolder();
        	$('.zph-overlay').css("padding-top", "27px"); //No I18N
        }
    	<%if(AccountsConfiguration.SIGNUP_PHONENUMBER_REQUIRED.toBooleanValue()){ %>
	    	<%if(!isMobile){ %>
		    $("#country_code_select").chosen();
		    if($("#country_code_select_chzn").length!=0){
		    	$("#ie_select").hide();
		    	$("#country_code_select_chzn").css("display","none");	//No I18N
			    if($( "#country_code_select option:selected").text()){
			    	$('.chzn-single span').text($( "#country_code_select option:selected" ).text().split('(')[1].slice(0,-3));
			    }
		    }else{
		    	isChosen=false;
		    	$("#country_code_select").hide();
		    }
		   <%}else{%>
		    if($( "#country_code_select option:selected").text()){
		    	$('#selectspan span').text($( "#country_code_select option:selected" ).text().split('(')[1].slice(0,-3));
		    }
		   <%}%>
	   <%}%>
    }
    function isValidMobile(mobile){
        if(mobile.trim().length != 0){
            var mobilePattern = new RegExp("^([0-9]{4,13})$");
            if(mobilePattern.test(mobile)){
                return true;
            }
        }
        return false;
    }
    <%if(AccountsConfiguration.SIGNUP_PHONENUMBER_REQUIRED.toBooleanValue()){ %>
     var uUpdate=false,invoked=false;
	 function isSelectInvokeNeeded(mobile){
	        if(mobile.trim().length != 0 && !invoked){
	            var mobilePattern = new RegExp("^([0-9]{1,2})$");
	            if(mobilePattern.test(mobile)){
	                return true;
	            }
	        }
	        return false;
	}
	
    $(document).on('change', '#country_code_select', function() {
		uUpdate=true;
		<%if(!isMobile){%>
		$('.chzn-single span').text($( "#country_code_select option:selected" ).text().split('(')[1].slice(0,-3));
		<%}else{%>
		$('#selectspan span').text($( "#country_code_select option:selected" ).text().split('(')[1].slice(0,-3));
		<%}%>
	});
	<%if(!isMobile){%>
	$(document).on('click','.chzn-results',function(){
		$('.chzn-single span').text($( "#country_code_select option:selected" ).text().split('(')[1].slice(0,-3));
		return false;
	});
	$(document).on('keyup','.chzn-container',function(e){
		if(e.which === 13) {
			$('.chzn-single span').text($( "#country_code_select option:selected" ).text().split('(')[1].slice(0,-3));
			return false;
		}
	});
	$("#email").keyup(function(evt){
        evt = (evt) ? evt : window.event; var charCode = (evt.which) ? evt.which : evt.keyCode;
        if(isSelectInvokeNeeded($('#email').val())){
        	if(!uUpdate){
        		changeDialCode();
        	}
        }
        if(isValidMobile($('#email').val())){ //No I18N 
            if(isChosen){
            	if($('#email').css('text-indent')=='0px' ||!$("#country_code_select_chzn").is(":visible")){
                	$("#email").animate({'text-indent': '64px'}, 200,function(){$("#country_code_select_chzn").css("display","inline-block"); });//No I18N
                }
    	    }else{
    	    	$("#ie_select").show();
    	    }
       }
       else{
           if(isChosen){
        	   if($("#country_code_select_chzn").is(":visible") ||$('#email').css('text-indent')!='0px' ){
	   	        	$("#country_code_select_chzn").fadeOut(200);
	   	        	$("#email").animate({'text-indent': '0px'},200);//No I18N 
               }
	   	    }else{
		    	$("#ie_select").hide();
		    }
       }
   	 });
<%}else{%>
	$("#email").keyup(function(evt){
		if($('#selectspan').is(':animated')||$('#lid').is(':animated')){
			$('#selectspan').finish();
			$('#email').finish();
		}
        evt = (evt) ? evt : window.event; var charCode = (evt.which) ? evt.which : evt.keyCode;
        if(isSelectInvokeNeeded($('#email').val())){
        	if(!uUpdate){
        		changeDialCode();
        	}
        }
        if(isValidMobile($('#email').val())){ //No I18N 
            if($('#email').css('text-indent')=='0px' ||!$('#selectspan').is(":visible")){
            	$("#email").animate({'text-indent': '64px'}, 150,function(){$('#selectspan').fadeIn(200).css("display","inline-block"); });//No I18N
            	$('#country_code_select').css("display","inline-block");//No I18N 
            }
       }
       else{
           if($('#selectspan').is(":visible") ||$('#email').css('text-indent')!='0px' ){
	        	$('#selectspan').fadeOut(200);
	        	$('#country_code_select').css("display","none");//No I18N
	        	$("#email").animate({'text-indent': '0px'},200);//No I18N
           }
       }
   	 });
<%}%>
function changeDialCode(){	
	invoked=true;
	try{
		var objHTTP = xhr();
	    objHTTP.open('POST', "/accounts/public/api/locate", true);
	    objHTTP.setRequestHeader('Content-Type','application/x-www-form-urlencoded;charset=UTF-8');
		objHTTP.onreadystatechange=function() {
		    if(objHTTP.readyState==4) {
		    	var obj=JSON.parse(objHTTP.responseText); 
				if(obj.isd_code){
					if(!uUpdate){
						$("#country_code_select").val(obj.isd_code).trigger('change');
					}
				}
		    }
		};
	    objHTTP.send(csrfParam);
	}catch(e){
	}
}
<%} %>
    function goToHomeUrl(){
        var redirecturl='<%=IAMEncoder.encodeJavaScript(Util.isFujixerox() ? Util.getRedirectURL(request) : serviceUrl)%>'; <%-- NO OUTPUTENCODING --%>
        window.parent.location.href = redirecturl; <%-- NO OUTPUTENCODING --%>
    	}
</script>
