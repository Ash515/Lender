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
		<div style="clear: both;"></div>
	</header>
<#if signup.isValidInvitation>
<div align="center" class="main">
<div class="inner-container">
<h2 class="form-title"><@i18n key="IAM.CREATE.ZACCOUNT" /></h2>
<div class="za-invitation-desc" style="text-align: center;margin-bottom: -20px;"><@i18n key="IAM.REGISTERUSERNAME.TITLE"  arg0="${signup.invitedEmailID}" /></div>

			<form action="${za.contextpath}/register.ac" name="signupform" method="post" class="form">
				<section class="signupcontainer">
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
					<dl class="za-email-container">
					</dl>
					<dl class="za-password-container">
						<dd>
							<input type="password" placeholder='<@i18n key="IAM.PASSWORD" />' name="password" id="password" class="form-input" onkeyup="checkPasswordStrength(${signup.minpwdlen})" onfocus="hideMsg(this,${signup.minpwdlen});" tabindex="1" onblur="hideLenError(this,${signup.minpwdlen})">
						<div class="field-msg">
							<div onclick="togglePasswordField(${signup.minpwdlen});" id="show-password" class="column show-password">
                                <span id="show-password-icon" class="icon-medium uncheckedpass"></span>
                                <label id="show-password-label">Show</label>
                            </div>
							<p class="message"><span id="errormg" class="pwderror"><@i18n key="IAM.TPL.PASSWORD.ALERT" arg0="${signup.minpwdlen}"/></span></p>
							<div class="pwdparent"><div id="pwdstrength"></div><div class="pwdtext"></div></div>
						</div>
						</dd>
					</dl>
					<dl class="za-captcha-container">
						<dd>
							<input type="text" placeholder='<@i18n key="IAM.FIELD.CAPTCHA.VERIFICATION" />' name="captcha" maxlength="10" class="form-input captchaCnt" tabindex="1"> 
							<div class="form-input" style="text-align:left"><img src="${za.contextpath}/images/spacer.gif" class="za-captcha"><span class="za-refresh-captcha" onclick="reloadCaptcha(document.signupform)"></span></div>
						</dd>
					</dl>
					<dl class="za-newsletter-container">
						<dd>
							<label for="newsletter" class="news-signup">
                            	<input tabindex="1" class="za-newsletter" type="checkbox" id="newsletter" name="newsletter" value="true" onclick="toggleNewsletterField()"/>
                            	<span class="icon-medium unchecked" id="signup-newsletter"></span>
                           	 <span><@i18n key="IAM.TPL.ZOHO.NEWSLETTER.SUBSCRIBE"/></span>
                       	 </label>
						</dd>
					</dl>
					<div class="clearBoth"></div>
					<dl class="za-submitbtn">
						<dd>
							<div class="field-msg">
								<span class="note p0"><@i18n key="IAM.SIGNUP.AGREE.TOS.PRIVACY" arg0="${tos_link}" arg1="${privacy_link}"/></span>
							</div>
							<input type="submit" tabindex="1" class="signupbtn" style="width:180px" value='<@i18n key="IAM.SIGNUP.CREATE.AN.ACCOUNT" />'
							onblur="hideLenError(this,${signup.minpwdlen})" onclick="hideLenError(this,${signup.minpwdlen});"
							<div class="loadingImg"></div>
						</dd>
					</dl>
					<dl class="za-region-container">
					</dl>
			</section>
		</form>
</div>
</div>
						<#elseif signup.islogoutNeeded>
						<p class="ptxt margin bg-page-after" align="center" style="line-height : 2"><@i18n key="IAM.SIGNING.IN.ALREADY" arg0="${signup.currentloggedInuser}" arg1="${signup.logouturl}"/></p>
						<#else>
						<p class="ptxt margin bg-page-after" align="center"><@i18n key="IAM.INVALID.REQUEST" /></p>
						</#if>
<footer>
	<#if !partner.isPartnerHideHeader>
	<#if partner.isfujixerox>
		<a href='<@i18n key="IAM.LINK.TOS" />' target="_blank"><@i18n key="IAM.SIGNUP.AGREE.TOS.PRIVACY" /></a>
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
			$(".za-region-container").hide();
			$("#signupform").zaSignUp({
				handleConfirmation:function(data){
		    		if(data["email"]){
		    			window.location.href=data["redirectURL"];
		    		}
		    	}
	    	});
	 	}
	</script>
</body>
</html>
