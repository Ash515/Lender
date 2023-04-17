<!DOCTYPE html>
<html>
<head>
<title><@i18n key="IAM.CREATE.ZACCOUNT" /></title>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<script type="text/javascript" src="${za.contextpath}/register.js?${signup.scriptParams}&loadcss=false&tvisit=true"></script>
<link href="${signup.cssurl}/registernew.css" type="text/css" rel="stylesheet" />
<link href="${signup.cssurl}/tplibs/chosen.css" type="text/css" rel="stylesheet" />
</head>
<body style="visibility: hidden;">
	<#assign tos_link><@i18n key="IAM.LINK.TOS" /></#assign> <#assign privacy_link><@i18n key="IAM.LINK.PRIVACY" /></#assign>
	<header>
		<#if partner.isPartnerLogoExist>
			<div><img class="partnerlogo" src="/static/file?t=org&ID=${partner.partnerId}" /></div>
		<#else>
			<div class="logo"></div>
		</#if>
		<div class="signinlink"><@i18n key="IAM.REGISTER.EXISTING.ACCOUNT"/><a href="${signup.signinURL}"><@i18n key="IAM.SIGNIN" /></a> </div>
		<div style="clear: both;"></div>
	</header>
<#if signup.isEnabled>
<h2 class="form-title"><@i18n key="IAM.TPL.SIGNUP.START.ACCOUNT" /></h2>
<div align="center" class="main">
<div class="inner-container">
			<form action="${za.contextpath}/register.ac" name="signupform" method="post" class="form">
				<section class="signupcontainer">
					<dl class="za-region-container">
						<dd>
							<span>Choose where your data lives because we understand  there is no safer place than home!</span>	
						<dd>
					</dl>
					<dl class="za-fullname-container">
     					<dd>
     						<input type="text" placeholder='<@i18n key="IAM.FULL.NAME" />' name="firstname" maxlength="100" tabindex="1" id="firstname">
     					</dd>
     				</dl>
     				<dl class="za-username-container">
     					<dd>
     						<input type="text" placeholder='<@i18n key="IAM.GENERAL.USERNAME" />' name="username" maxlength="100">
     					</dd>
     				</dl>
     				<dl class="za-emailormobile-container">
     					<dd>
     						<input type="text" placeholder='<@i18n key="IAM.EMAIL.ADDRESS.OR.MOBILE" />' name="emailormobile" maxlength="100" tabindex="1" id="phonenumber">
     					</dd>
     				</dl>	
     				<dl class="za-mobile-container">
     					<div style="width:98%">
	     					<div class="za-country_code-container">
								<dd>
									<div class="ccdivtext"><span class="ccdiv"></span><span class="arrowspan"></span></div>
									<select class="form-input1 countryCnt1 za-country-select-code" name="country_code" id="country-code" tabindex="1"></select>
								</dd>
							</div>
							<dd style="float: left; width: 86%;">
								<input type="text" placeholder='<@i18n key="IAM.PHONE.NUMBER" />' name="mobile" tabindex="1" id="mobilefield" >
							</dd>
						</div>
					</dl>	
					<dl class="za-rmobile-container">
     					<div style="width:98%">
	     					<div class="za-country_code-container">
								<dd>
									<div class="ccdivtext"><span class="ccdiv1"></span><span class="arrowspan"></span></div>
									<select class="form-input1 countryCnt1 za-country-select-code" name="country_code" id="country-coderecovery" tabindex="1"></select>
								</dd>
							</div>
							<dd style="float: left; width: 86%;">
								<input type="text" placeholder='<@i18n key="IAM.PHONE.NUMBER" />' name="rmobile" tabindex="1" id="rmobilefield" >
							</dd>
						</div>
					</dl>		
					<dl class="za-email-container">
						<dd>
							<input type="text" placeholder='<@i18n key="IAM.EMAIL.ADDRESS" />' name="email" class="form-input" tabindex="1" id="emailfield"  value="${signup.emailId}" ${signup.disabled}>
						</dd>
					</dl>
					<dl class="za-password-container">
						<dd>
							<input type="password" placeholder='<@i18n key="IAM.PASSWORD" />' name="password" id="password" class="form-input" onkeyup="checkPasswordStrength()"  tabindex="1">
							<div class="pwdparent"><div id="pwdstrength"></div><div class="pwdtext"></div></div>
						<div class="field-msg1">
							<div id="show-password" onclick="togglePasswordField(${signup.minpwdlen});" class="column show-password">
                                <span id="show-password-icon" class="uncheckedpass"></span>
                                <label id="show-password-label"><@i18n key="IAM.PASSWORD.SHOW" /></label>
                            </div>
							<p class="message1"><span id="errormg" class="pwderror"><@i18n key="IAM.TPL.PASSWORD.ALERT" arg0="${signup.minpwdlen}"/></span></p>
						</div>
						</dd>
					</dl>
					<#if signup.isCountryRequired>
					<dl class="za-country-container" style="display:none">
						<dd>
							<select class="form-input countryCnt za-country-select" name="country" id="country" tabindex="1" placeholder='<@i18n key="IAM.TFA.SELECT.COUNTRY" />' ></select>
						</dd>
					</dl>
					<dl class="za-country_state-container" style="display:none">
						<dd>
							<select class="form-input countryCnt" name="country_state" id="country_state" tabindex="1"></select>
						</dd>
					</dl>
					</#if>
					<dl class="za-captcha-container">
						<dd>
							<input type="text" placeholder='<@i18n key="IAM.FIELD.CAPTCHA.VERIFICATION" />' name="captcha" maxlength="10" class="form-input" tabindex="1"> 
							<div class="form-input" style="text-align:left"><img src="${za.contextpath}/images/spacer.gif" class="za-captcha"><span class="za-refresh-captcha" onclick="reloadCaptcha(document.signupform)"></span></div>
						</dd>
					</dl>
					<#if signup.isTosRequired>
						<dl class="za-tos-container">
							<dd>
								<label for="tos" class="tos-signup">
									<span class="icon-medium unchecked" id="signup-termservice"></span>
	                           	 	<span><@i18n key="IAM.SIGNUP.AGREE.TERMS.OF.SERVICE" arg0="${tos_link}" arg1="${privacy_link}"/></span>
	                            	<input tabindex="1" class="za-tos" type="checkbox" id="tos" name="tos" value="true" onclick="toggleTosField()"/>
	                       	 </label>
							</dd>
						</dl>
					<#else>
						<div class="field-msg">
							<span class="note p0"><@i18n key="IAM.SIGNUP.AGREE.TOS.PRIVACY.MOBILE" arg0="${tos_link}" arg1="${privacy_link}"/></span>
						</div>
					</#if>
					<dl class="za-newsletter-container" style="height:50px;display:none">
						<dd>
							<label for="newsletter" class="news-signup" style="display: flow-root;">
                            	<input tabindex="1" class="za-newsletter" type="checkbox" id="newsletter" name="newsletter" value="true" onclick="toggleNewsletterField()"/>
                            	<span class="icon-medium unchecked" id="signup-newsletter"></span>
                           	 <span style="width: 450px;"><@i18n key="IAM.TPL.ZOHO.NEWSLETTER.SUBSCRIBE1"/></span>
                       	 </label>
						</dd>
					</dl>
					<div class="clearBoth"></div>
					<dl class="za-submitbtn">
						<dd>
							<input type="submit" tabindex="1" class="signupbtn" style="width:180px" value='<@i18n key="IAM.LINK.SIGNUP.SIGNUP" />'>
							<div class="loadingImg"></div>
						</dd>
					</dl>
			</section>
			<section class="signupotpcontainer" style="display:none">
						<dl class="za-otp-container">
							<dd>
								<input type="text" class="form-input" tabindex="1" name="otp" id="otpfield" placeholder='<@i18n key="IAM.VERIFY.CODE" />' >
								<span onclick="resendOTP()"><@i18n key="IAM.SIGNUP.RESEND.OTP" /></span>
							</dd>
						</dl>
						<dl class="za-submitbtn-otp">
							<dd>
								<input type="button" tabindex="1" class="signupbtn" style="width:180px" value='<@i18n key="IAM.VERIFY.OTP" />' onclick="validateOTP()" name="otpfield">
								<div class="loadingImg"></div>
							</dd>
						</dl>
			</section>
		</form>
			<#if !signup.hide_federated_options>
			<div class="openidcontainer">
				<div class="ortext"><@i18n key="IAM.OR" /></div>
				<div class="openidtitle"><@i18n key="IAM.TPL.SIGNIN.FEDERATED" /></div>
				<div class="openidparent">
					<span class="openidlink GIcon" title='<@i18n key="IAM.SIGNIN.IDP.GOOGLE" />' onclick="FederatedSignIn.GO('g');"></span>
				<#if signup.yahoo>
					<span class="openidlink YIcon" title='<@i18n key="IAM.SIGNIN.IDP.YAHOO" />' onclick="FederatedSignIn.GO('y');"></span>
				</#if>
				<#if signup.facebook>
					<span class="openidlink FIcon" title='<@i18n key="IAM.SIGNIN.IDP.FACEBOOK" />' onclick="FederatedSignIn.GO('f');"></span>
				</#if>
				<#if signup.linkedin>
					<span class="openidlink LIcon" title='<@i18n key="IAM.LINKEDIN.SIGNIN" />' onclick="FederatedSignIn.GO('l');"></span>
				</#if>
				<#if signup.twitter>
					<span class="openidlink TIcon" title='<@i18n key="IAM.TWITTER.SIGNIN" />' onclick="FederatedSignIn.GO('t');"></span>
				</#if>
				<#if signup.azure>
					<span class="openidlink AZUREIcon" title='<@i18n key="IAM.AZURE.SIGNIN" />' onclick="FederatedSignIn.GO('a');"></span>
				</#if>
					
				</div>
			</div>
		</#if>
</div>
</div>
<#else>
	<table class="signupblocktabl" width="100%" cellpadding="0" cellspacing="0" border="0" style='margin-top:100px'>
		<tr><td align="center">
			<div class="signupblockdiv">
				<div class="signupblockheaderdiv">
					<div class="signupblockheader"><span><@i18n key="IAM.ACCESS.DENIED" /></span></div>
					<div class="signupblocksubtitle"><@i18n key="IAM.REGISTRATION.NOT.ALLOWED" arg0="${signup.supportEmail}" /></div>
				</div>
				<table align="center" cellpadding="0" cellspacing="0"><tr><td>
					<div class="signupblockbut" onclick="history.go(-1);">
						<div class="signupblockbutlt"></div>
						<div class="signupblockbutco"><a href="javascript:;"><@i18n key="IAM.BACKTO.HOME" /></a></div>
						<div class="signupblockbutrt"></div>
					</div>
				</td></tr></table>
			</div>
		</td><td class="rtshadow" valign="top"><div>&nbsp;</div></td></tr>
		<tr><td><div class="botshadow"><span></span></div></td></tr>
	</table>
</#if>
<footer>
	<#if !partner.isPartnerHideHeader>
	<#if partner.isfujixerox>
		<a href='<@i18n key="IAM.LINK.TOS" />' target="_blank"><@i18n key="IAM.SIGNUP.TERMS.OFSERVICE" /></a>
		<a href='<@i18n key="IAM.LINK.PRIVACY" />' target="_blank"><@i18n key="IAM.PRIVACY" /></a>
		<a href='<@i18n key="IAM.CONTACT.LINK" />' target="_blank"><@i18n key="IAM.CONTACT.US" /></a>
	<#else>
		<span><@i18n key="IAM.FOOTER.COPYRIGHT" arg0="${signup.copyrightYear}"/></span>
	</#if>
	</#if>
</footer>
	<script type="text/javascript">
	
	    
	 	function onSignupReady() {
	 		// To avoid glitches on page load, as we lazy load CSS. 
	 		$(document.body).css("visibility", "visible");
			$(document.signupform).zaSignUp();
	 		$(".za-region-select").chosen({disable_search_threshold: 10});//No I18N
	 		$('.chosen-search input').addClass('ignore-validation');//No I18N
	 		$(".chzn-single").css("borderRadius","0px");
	 		$(".chzn-container,.chzn-results").css("maxHeight","200px");
	 		$(".chzn-container-single .chzn-single").css("height","30px");
	 		$(".chzn-container,.chzn-results").css("border-top","1px");
	 		$(".chzn-container-single .chzn-single").css("lineHeight","21px");
	 		$(".chzn-single").css("fontSize","15px");
	 		$(".chzn-single").css("paddingTop","5px");
	 		$(".chzn-single").css("boxShadow","none");
	 		$("#contNameprefAdd_chzn ,#countNameAddDiv_chzn").css("width","25%");
	 		$(".chzn-container-single .chzn-single span").css("color","#000");
	 		$('.chzn-single').css('border','none');
	 		$('.chzn-single').css('background-image','none');
	 		$('.chzn-single').css('background-color','transparent');
	 	}

	</script>
</body>
</html>