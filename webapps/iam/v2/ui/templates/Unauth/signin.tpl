<!DOCTYPE html>
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<html>
	<head>
		<link href="${za.css_url}/signin.css" type="text/css" rel="stylesheet"/>
        <link  href="${za.css_url}/flagStyle.css" type="text/css" rel="stylesheet" defer/>
        <script src="${za.tpkg_url}/jquery-3_5_1.min.js" type="text/javascript"></script>
        <script src="${za.tpkg_url}/select2.full.min.js" type="text/javascript"></script>
        <script src="${za.wmsjsurl}/wmsliteapi.js" type="text/javascript" defer></script>
        <script src="${za.js_url}/signin.js" type="text/javascript"></script>
        <script src="${za.tpkg_url}/xregexp-all.js" type="text/javascript"></script>
        <script src="${za.tpkg_url}/u2f-api.js" defer></script>
        <script src="${za.js_url}/wmsliteimpl.js" type="text/javascript" defer></script>
        <#if signin.isEnabledZTM>
			<!-- Zoho Tag Manager -->
			<script type="text/javascript" defer>(function(w,s){var e=document.createElement("script");e.type="text/javascript";e.async=true;e.src="//zohotagmanager.cdn.pagesense.io/ztmjs/a298f0ccdb294c7594b9b37933ea4a5e.js";var x=document.getElementsByTagName("script")[0];x.parentNode.insertBefore(e,x);})(window,"script");</script>
			<!-- End Zoho Tag Manager -->
		</#if>
		
		<meta name="robots" content="noindex, nofollow"/>
        <script type='text/javascript'>
        	var serviceUrl,serviceName;
			var csrfParam= "${za.csrf_paramName}";
			var csrfCookieName = "${za.csrf_cookieName}";
			var resetPassUrl = '${signin.resetPassUrl}';
			var queryString = window.location.search.substring(1);
			var signup_url =  getSignupUrl();
			var signinParams= getSigninParms();
			var isMobile = parseInt('${signin.isMobile}');
			var loginID = "${Encoder.encodeJavaScript(signin.loginId)}";
			var isCaptchaNeeded ="${signin.captchaNeeded}";
			var UrlScheme = "${signin.UrlScheme}";
			var iamurl="${signin.iamurl}";
			var imgurl="${za.img_url}";
			var displayname = "${signin.app_display_name}";
			var reqCountry="${signin.reqCountry}";
			var cookieDomain="${signin.cookieDomain}";
			var iam_reload_cookie_name="${signin.iam_reload_cookie_name}";
			var isDarkMode = parseInt("${signin.isDarkmode}");
			var isMobileonly = 0;
			var uriPrefix = '${signin.uri_prefix}';
			var isClientPortal = parseInt("${signin.isClientPortal}");
			var contextpath = "${za.contextpath}";
			var istlsEnabled = parseInt('${signin.istlsEnabled}');
			I18N.load({
					"IAM.ZOHO.ACCOUNTS" : '<@i18n key="IAM.ZOHO.ACCOUNTS" />',
					"IAM.ERROR.ENTER_PASS" : '<@i18n key="IAM.ERROR.ENTER_PASS" />',
					"IAM.SIGNIN.ERROR.CAPTCHA.REQUIRED" : '<@i18n key="IAM.SIGNIN.ERROR.CAPTCHA.REQUIRED" />',
					"IAM.NEW.SIGNIN.INVALID.OTP.MESSAGE.EMPTY" : '<@i18n key="IAM.NEW.SIGNIN.INVALID.OTP.MESSAGE.EMPTY" />',
					"IAM.SIGNIN" : '<@i18n key="IAM.SIGN_IN" />', 
					"IAM.VERIFY" : '<@i18n key="IAM.VERIFY" />',
					"IAM.GOOGLE.AUTHENTICATOR" : '<@i18n key="IAM.GOOGLE.AUTHENTICATOR" />',
					"IAM.NEW.SIGNIN.SMS.MODE" : '<@i18n key="IAM.NEW.SIGNIN.SMS.MODE" />',
					"IAM.NEW.SIGNIN.TOTP" : '<@i18n key="IAM.NEW.SIGNIN.TOTP" />',
					"IAM.NEW.SIGNIN.TOTP.HEADER" : '<@i18n key="IAM.NEW.SIGNIN.TOTP.HEADER" />',		
					"IAM.NEW.SIGNIN.VERIFY.PUSH" : '<@i18n key="IAM.NEW.SIGNIN.VERIFY.PUSH" />',
					"IAM.NEW.SIGNIN.TOUCHID.TITLE" : '<@i18n key="IAM.NEW.SIGNIN.TOUCHID.TITLE" />',
					"IAM.NEW.SIGNIN.QR.CODE" : '<@i18n key="IAM.NEW.SIGNIN.QR.CODE" />',
					"IAM.NEW.SIGNIN.FACEID.TITLE" : '<@i18n key="IAM.NEW.SIGNIN.FACEID.TITLE" />',
					"IAM.NEW.SIGNIN.ENTER.EMAIL.OR.MOBILE" : '<@i18n key="IAM.NEW.SIGNIN.ENTER.EMAIL.OR.MOBILE" />',
					"IAM.NEW.SIGNIN.OTP.SENT.DEVICE" : '<@i18n key="IAM.NEW.SIGNIN.OTP.SENT.DEVICE" />',
					"IAM.NEW.SIGNIN.OTP.SENT" : '<@i18n key="IAM.NEW.SIGNIN.OTP.SENT" />',
					"IAM.NEW.SIGNIN.TOUCHID.HEADER" : '<@i18n key="IAM.NEW.SIGNIN.TOUCHID.HEADER" />',
					"IAM.NEW.SIGNIN.FACEID.HEADER" : '<@i18n key="IAM.NEW.SIGNIN.FACEID.HEADER" />',
					"IAM.PUSH.RESEND.NOTIFICATION" : '<@i18n key="IAM.PUSH.RESEND.NOTIFICATION" />',
					"IAM.RESEND.PUSH.MSG" : '<@i18n key="IAM.RESEND.PUSH.MSG" />',
					"IAM.NEXT" : '<@i18n key="IAM.NEXT" />',
					"IAM.NEW.SIGNIN.ENTER.VALID.BACKUP.CODE" : '<@i18n key="IAM.NEW.SIGNIN.ENTER.VALID.BACKUP.CODE" />',
					"IAM.NEW.SIGNIN.INVALID.OTP.MESSAGE.NEW" : '<@i18n key="IAM.NEW.SIGNIN.INVALID.OTP.MESSAGE.NEW" />',
					"IAM.NEW.SIGNIN.FEDERATED.USER.ERROR" : '<@i18n key="IAM.NEW.SIGNIN.FEDERATED.USER.ERROR" />',
					"IAM.TFA.USE.BACKUP.CODE" : '<@i18n key="IAM.TFA.USE.BACKUP.CODE" />',
					"IAM.NEW.SIGNIN.CANT.ACCESS" : '<@i18n key="IAM.NEW.SIGNIN.CANT.ACCESS" />',
					"IAM.NEW.SIGNIN.USING.OTP" : '<@i18n key="IAM.NEW.SIGNIN.USING.OTP" />',
					"IAM.SIGNIN.KEEP.ME" : '<@i18n key="IAM.SIGNIN.KEEP.ME" />',
					"IAM.BACKUP.VERIFICATION_CODE" : '<@i18n key="IAM.BACKUP.VERIFICATION_CODE" />',
					"IAM.NEW.SIGNIN.BACKUP.HEADER" : '<@i18n key="IAM.NEW.SIGNIN.BACKUP.HEADER" />',
					"IAM.NEW.SIGNIN.CONTACT.SUPPORT" : '<@i18n key="IAM.NEW.SIGNIN.CONTACT.SUPPORT" />',
					"IAM.NEW.SIGNIN.FEDERATED.LOGIN.TITLE" : '<@i18n key="IAM.NEW.SIGNIN.FEDERATED.LOGIN.TITLE" />',
					"IAM.NEW.SIGNIN.KEEP.ACCOUNT.SECURE" : '<@i18n key="IAM.NEW.SIGNIN.KEEP.ACCOUNT.SECURE" />',
					"IAM.NEW.SIGNIN.ONEAUTH.INFO.HEADER" : '<@i18n key="IAM.NEW.SIGNIN.ONEAUTH.INFO.HEADER" />',
					"IAM.HOME.WELCOMEPAGE.SIGNUP.NOW" : '<@i18n key="IAM.HOME.WELCOMEPAGE.SIGNUP.NOW" />',
					"IAM.ERROR.USER.ACTION" : '<@i18n key="IAM.ERROR.USER.ACTION" />',
					"IAM.NEW.SIGNIN.MFA.SMS.HEADER" : '<@i18n key="IAM.NEW.SIGNIN.MFA.SMS.HEADER" />',
					"IAM.NEW.SIGNIN.YUBIKEY.TITLE" : '<@i18n key="IAM.NEW.SIGNIN.YUBIKEY.TITLE" />',
					"IAM.NEW.SIGNIN.YUBIKEY.HEADER.NEW" : '<@i18n key="IAM.NEW.SIGNIN.YUBIKEY.HEADER.NEW" />',
					"IAM.ERROR.USER.ACTION" : '<@i18n key="IAM.ERROR.USER.ACTION" />',
					"IAM.TFA.TRUST.BROWSER.QUESTION" : '<@i18n key="IAM.TFA.TRUST.BROWSER.QUESTION" />',
					"IAM.NEW.SIGNIN.TRUST.HEADER.TOTP" : '<@i18n key="IAM.NEW.SIGNIN.TRUST.HEADER.TOTP" />',
					"IAM.NEW.SIGNIN.TRUST.HEADER.OTP" : '<@i18n key="IAM.NEW.SIGNIN.TRUST.HEADER.OTP" />',
					"IAM.NEW.SIGNIN.TRUST.HEADER.TOUCHID" : '<@i18n key="IAM.NEW.SIGNIN.TRUST.HEADER.TOUCHID" />',
					"IAM.NEW.SIGNIN.TRUST.HEADER.FACEID" : '<@i18n key="IAM.NEW.SIGNIN.TRUST.HEADER.FACEID" />',
					"IAM.NEW.SIGNIN.TRUST.HEADER.YUBIKEY" : '<@i18n key="IAM.NEW.SIGNIN.TRUST.HEADER.YUBIKEY" />',
					"IAM.NEW.SIGNIN.TRUST.HEADER.SCANQR" : '<@i18n key="IAM.NEW.SIGNIN.TRUST.HEADER.SCANQR" />',
					"IAM.NEW.SIGNIN.TRUST.HEADER.PUSH" : '<@i18n key="IAM.NEW.SIGNIN.TRUST.HEADER.PUSH" />',
					"IAM.TRUST" : '<@i18n key="IAM.TRUST" />',
					"IAM.NOTNOW" : '<@i18n key="IAM.NOTNOW" />',
					"IAM.NEW.SIGNIN.RETRY.YUBIKEY": '<@i18n key="IAM.NEW.SIGNIN.RETRY.YUBIKEY" />',
					"IAM.RECOVERY.MOBILE.LABEL" : '<@i18n key="IAM.RECOVERY.MOBILE.LABEL" />',
					"IAM.MOBILE.OTP.SENT" : '<@i18n key="IAM.MOBILE.OTP.SENT" />',
					"IAM.NEW.SIGNIN.PROBLEM.SIGNIN" : '<@i18n key="IAM.NEW.SIGNIN.PROBLEM.SIGNIN" />',
					"IAM.NEW.SIGNIN.CONTACT.SUPPORT.DESC" : '<@i18n key="IAM.NEW.SIGNIN.CONTACT.SUPPORT.DESC" />',
					"IAM.TOTP.TIME.BASED.OTP" : '<@i18n key="IAM.TOTP.TIME.BASED.OTP" />',
					"IAM.NEW.SIGNIN.PASSWORD.TITLE" : '<@i18n key="IAM.NEW.SIGNIN.PASSWORD.TITLE" />',
					"IAM.NEW.SIGNIN.PASSWORD.HEADER" : '<@i18n key="IAM.NEW.SIGNIN.PASSWORD.HEADER" />',
					"IAM.NEW.SIGNIN.SAML.TITLE" : '<@i18n key="IAM.NEW.SIGNIN.SAML.TITLE" />',
					"IAM.NEW.SIGNIN.SAML.HEADER" : '<@i18n key="IAM.NEW.SIGNIN.SAML.HEADER" />',
					"IAM.NEW.SIGNIN.CHOOSE.OTHER.WAY" : '<@i18n key="IAM.NEW.SIGNIN.CHOOSE.OTHER.WAY" />',
					"IAM.NEW.SIGNIN.OTP.TITLE" : '<@i18n key="IAM.NEW.SIGNIN.OTP.TITLE" />',
					"IAM.NEW.SIGNIN.VERIFY.VIA.YUBIKEY" : '<@i18n key="IAM.NEW.SIGNIN.VERIFY.VIA.YUBIKEY" />',
					"IAM.NEW.SIGNIN.VERIFY.VIA.YUBIKEY.DESC" : '<@i18n key="IAM.NEW.SIGNIN.VERIFY.VIA.YUBIKEY.DESC" />',
					"IAM.NEW.SIGNIN.VERIFY.VIA.AUTHENTICATOR" : '<@i18n key="IAM.NEW.SIGNIN.VERIFY.VIA.AUTHENTICATOR" />',
					"IAM.NEW.SIGNIN.VERIFY.VIA.OTP" : '<@i18n key="IAM.NEW.SIGNIN.VERIFY.VIA.OTP" />',
					"IAM.NEW.SIGNIN.VERIFY.VIA.ONEAUTH.DESC" : '<@i18n key="IAM.NEW.SIGNIN.VERIFY.VIA.ONEAUTH.DESC" />',
					"IAM.NEW.SIGNIN.VERIFY.VIA.ONEAUTH" : '<@i18n key="IAM.NEW.SIGNIN.VERIFY.VIA.ONEAUTH"/>',
					"IAM.NEW.SIGNIN.OTP.HEADER" : '<@i18n key="IAM.NEW.SIGNIN.OTP.HEADER" />',
					"IAM.NEW.SIGNIN.VERIFY.VIA.AUTHENTICATOR.DESC" : '<@i18n key="IAM.NEW.SIGNIN.VERIFY.VIA.AUTHENTICATOR.DESC" />',
					"IAM.NEW.SIGNIN.TRY.ANOTHERWAY":'<@i18n key="IAM.NEW.SIGNIN.TRY.ANOTHERWAY"/>',
					"IAM.NEW.SIGNIN.QR.HEADER":'<@i18n key="IAM.NEW.SIGNIN.QR.HEADER"/>',
					"IAM.NEW.SIGNIN.MFA.PUSH.HEADER":'<@i18n key="IAM.NEW.SIGNIN.MFA.PUSH.HEADER"/>',
					"IAM.NEW.SIGNIN.WAITING.APPROVAL":'<@i18n key="IAM.NEW.SIGNIN.WAITING.APPROVAL"/>',
					"IAM.PHONE.ENTER.VALID.MOBILE_NUMBER":'<@i18n key="IAM.PHONE.ENTER.VALID.MOBILE_NUMBER"/>',
					"IAM.MFA.YUBIKEY.ERROR.INVALID.REQUEST":'<@i18n key="IAM.MFA.YUBIKEY.ERROR.INVALID.REQUEST"/>',
					"IAM.NEW.SIGNIN.YUBIKEY.ERROR.DEVICEINELIGIBLE":'<@i18n key="IAM.NEW.SIGNIN.YUBIKEY.ERROR.DEVICEINELIGIBLE"/>',
					"IAM.NEW.SIGNIN.YUBIKEY.ERROR.UNSUPPORTED":'<@i18n key="IAM.NEW.SIGNIN.YUBIKEY.ERROR.UNSUPPORTED"/>',
					"IAM.NEW.SIGNIN.YUBIKEY.ERROR.BADREQUEST":'<@i18n key="IAM.NEW.SIGNIN.YUBIKEY.ERROR.BADREQUEST"/>',
					"IAM.SIGNIN.ERROR.USEREMAIL.NOT.EXIST":'<@i18n key="IAM.SIGNIN.ERROR.USEREMAIL.NOT.EXIST"/>',
					"IAM.NEW.SIGNIN.MFA.TOTP.HEADER":'<@i18n key="IAM.NEW.SIGNIN.MFA.TOTP.HEADER"/>',
					"IAM.NEW.SIGNIN.MFA.PASSWORD.HEADER":'<@i18n key="IAM.NEW.SIGNIN.MFA.PASSWORD.HEADER"/>',
					"IAM.NEW.SIGNIN.MFA.PASSWORD.DESC":'<@i18n key="IAM.NEW.SIGNIN.MFA.PASSWORD.DESC"/>',
					"IAM.NEW.SIGNIN.SERVICE.NAME.TITLE":'<@i18n key="IAM.NEW.SIGNIN.SERVICE.NAME.TITLE"/>',
					"IAM.SIGNIN.ERROR.CAPTCHA.INVALID":'<@i18n key="IAM.SIGNIN.ERROR.CAPTCHA.INVALID"/>',
					"IAM.SIGNIN.ERROR.INVALID.VERIFICATION.CODE":'<@i18n key="IAM.SIGNIN.ERROR.INVALID.VERIFICATION.CODE"/>',
					"IAM.RESETPASS.PASSWORD.MIN.ONLY":'<@i18n key="IAM.RESETPASS.PASSWORD.MIN.ONLY"/>',
					"IAM.RESET.PASSWORD.POLICY.MINSPECIALCHAR.ONLY":'<@i18n key="IAM.RESET.PASSWORD.POLICY.MINSPECIALCHAR.ONLY"/>',
					"IAM.RESET.PASSWORD.POLICY.MINNUMERICCHAR.ONLY":'<@i18n key="IAM.RESET.PASSWORD.POLICY.MINNUMERICCHAR.ONLY"/>',
					"IAM.RESET.PASSWORD.POLICY.CASE.BOTH":'<@i18n key="IAM.RESET.PASSWORD.POLICY.CASE.BOTH"/>',
					"IAM.RESETPASS.PASSWORD.MIN.NO.WITH":'<@i18n key="IAM.RESETPASS.PASSWORD.MIN.NO.WITH"/>',
					"IAM.PASSWORD.POLICY.HEADING":'<@i18n key="IAM.PASSWORD.POLICY.HEADING"/>',
					"IAM.RESETPASS.PASSWORD.MIN":'<@i18n key="IAM.RESETPASS.PASSWORD.MIN"/>',
					"IAM.RESETPASS.PASSWORD.MIN":'<@i18n key="IAM.RESETPASS.PASSWORD.MIN"/>',
					"IAM.INCLUDE":'<@i18n key="IAM.INCLUDE"/>',
					"IAM.NEW.SIGNIN.PASSWORD.EXPIRED.ORG.DESC":'<@i18n key="IAM.NEW.SIGNIN.PASSWORD.EXPIRED.ORG.DESC"/>',
					"IAM.NEW.SIGNIN.PASSWORD.EXPIRED.ORG.DESC.NOW":'<@i18n key="IAM.NEW.SIGNIN.PASSWORD.EXPIRED.ORG.DESC.NOW"/>',
					"IAM.ERROR.ENTER.NEW.PASS":'<@i18n key="IAM.ERROR.ENTER.NEW.PASS"/>',
					"IAM.ERROR.PASS.LEN":'<@i18n key="IAM.ERROR.PASS.LEN"/>',
					"IAM.ERROR.PASSWORD.MAXLEN":'<@i18n key="IAM.ERROR.PASSWORD.MAXLEN"/>',
					"IAM.PASSWORD.POLICY.LOGINNAME":'<@i18n key="IAM.PASSWORD.POLICY.LOGINNAME"/>',
					"IAM.ERROR.WRONG.CONFIRMPASS":'<@i18n key="IAM.ERROR.WRONG.CONFIRMPASS"/>',
					"IAM.NEW.SIGNIN.PASS.EXPIRY.SUCCESS.DESC":'<@i18n key="IAM.NEW.SIGNIN.PASS.EXPIRY.SUCCESS.DESC"/>',
					"IAM.NEW.SIGNIN.PASS.EXPIRY.SUCCESS.TITLE":'<@i18n key="IAM.NEW.SIGNIN.PASS.EXPIRY.SUCCESS.TITLE"/>',
					"IAM.NEW.SIGNIN.PASS.EXPIRY.SUCCESS.BUTTON":'<@i18n key="IAM.NEW.SIGNIN.PASS.EXPIRY.SUCCESS.BUTTON"/>',
					"IAM.NEW.SIGNIN.TITLE.RANDOM":'<@i18n key="IAM.NEW.SIGNIN.TITLE.RANDOM"/>',
					"IAM.PLEASE.CONNECT.INTERNET":'<@i18n key="IAM.PLEASE.CONNECT.INTERNET"/>',
					"IAM.NEW.SIGNIN.RESEND.OTP":'<@i18n key="IAM.NEW.SIGNIN.RESEND.OTP"/>',
					"IAM.TFA.RESEND.OTP.COUNTDOWN":'<@i18n key="IAM.TFA.RESEND.OTP.COUNTDOWN"/>',
					"IAM.NEW.SIGNIN.PASS.PHRASE.TITLE":'<@i18n key="IAM.NEW.SIGNIN.PASS.PHRASE.TITLE"/>',
					"IAM.NEW.SIGNIN.PASS.PHRASE.DESC":'<@i18n key="IAM.NEW.SIGNIN.PASS.PHRASE.DESC"/>',
					"IAM.NEW.SIGNIN.MFA.PASSPHRASE.HEADER":'<@i18n key="IAM.NEW.SIGNIN.MFA.PASSPHRASE.HEADER"/>',
					"IAM.NEW.SIGNIN.MFA.PASSPHRASE.DESC":'<@i18n key="IAM.NEW.SIGNIN.MFA.PASSPHRASE.DESC"/>',
					"IAM.NEW.SIGNIN.PASSPHRASE.RECOVER.HEADER":'<@i18n key="IAM.NEW.SIGNIN.PASSPHRASE.RECOVER.HEADER"/>',
					"IAM.NEW.SIGNIN.BACKUP.RECOVER.HEADER":'<@i18n key="IAM.NEW.SIGNIN.BACKUP.RECOVER.HEADER"/>',
					"IAM.NEW.SIGNIN.PASSPHRASE.RECOVER.TITLE":'<@i18n key="IAM.NEW.SIGNIN.PASSPHRASE.RECOVER.TITLE"/>',
					"IAM.NEW.SIGNIN.MORE.FEDRATED.ACCOUNTS.TITLE":'<@i18n key="IAM.NEW.SIGNIN.MORE.FEDRATED.ACCOUNTS.TITLE"/>',
					"IAM.NEW.SIGNIN.MORE.FEDRATED.ACCOUNTS.DESC":'<@i18n key="IAM.NEW.SIGNIN.MORE.FEDRATED.ACCOUNTS.DESC"/>',
					"IAM.NEW.SIGNIN.IDENTITY.PROVIDER.TITLE":'<@i18n key="IAM.NEW.SIGNIN.IDENTITY.PROVIDER.TITLE"/>',
					"IAM.NEW.SIGNIN.TRY.ANOTHERWAY.HEADER":'<@i18n key="IAM.NEW.SIGNIN.TRY.ANOTHERWAY.HEADER"/>',
					"IAM.NEW.SIGNIN.ENTER.VALID.PASSPHRASE.CODE":'<@i18n key="IAM.NEW.SIGNIN.ENTER.VALID.PASSPHRASE.CODE"/>',
					"IAM.NEW.SIGNIN.RIGHT.PANEL.VERIFY.SCANQR":'<@i18n key="IAM.NEW.SIGNIN.RIGHT.PANEL.VERIFY.SCANQR"/>',
					"IAM.NEW.SIGNIN.RIGHT.PANEL.ALLOW.SCANQR":'<@i18n key="IAM.NEW.SIGNIN.RIGHT.PANEL.ALLOW.SCANQR"/>',
					"IAM.NEW.SIGNIN.RIGHT.PANEL.VERIFY.TOTP":'<@i18n key="IAM.NEW.SIGNIN.RIGHT.PANEL.VERIFY.TOTP"/>',
					"IAM.NEW.SIGNIN.RIGHT.PANEL.ALLOW.TOTP":'<@i18n key="IAM.NEW.SIGNIN.RIGHT.PANEL.ALLOW.TOTP"/>',
					"IAM.NEW.SIGNIN.JWT.TITLE":'<@i18n key="IAM.NEW.SIGNIN.JWT.TITLE"/>',
					
				});
			$(document).ready(function() {
				<#if (('${signin.loginId}')?has_content)>
					handleCrossDcLookup("${Encoder.encodeJavaScript(signin.loginId)}");
				</#if>
				fediconsChecking();
				return false;
			});
			window.onload = function() {
				$("#nextbtn").removeAttr("disabled"); 
				<#if (('${signin.idp}')?has_content)>
					handleMfaForIdpUsers('${signin.idp}');
					return false;
				</#if>
				<#if signin.hiderightpanel>
					$(".signin_container").css("maxWidth","500px");
					$(".rightside_box").hide();
					$("#recoverybtn, #problemsignin, .tryanother").css("right","0px");
				</#if>
				onSigninReady();
			}
			function getSignupUrl(){
				<#if (('${signin.signupurl}')?has_content)>
					return '${Encoder.encodeJavaScript(signin.signupurl)}';
				<#else>
					var signupurl= "${signin.accountssignupurl}";
					<#if (('${signin.servicename}')?has_content)>
						signupurl += "servicename=" + euc('${signin.servicename}');
					</#if>
					<#if (('${signin.serviceurl}')?has_content)>
						signupurl += "&serviceurl="+euc('${Encoder.encodeJavaScript(signin.serviceurl)}');
					</#if>
					<#if (('${signin.appname}')?has_content)>
						signupurl += "&appname="+euc('${signin.appname}');
					</#if>
					<#if (('${signin.getticket}')?has_content)>
						signupurl += "&getticket=true";
					</#if>
					return signupurl; 
				</#if>
			}
			function getSigninParms(){
				var params = "cli_time=" + new Date().getTime();
				<#if (('${signin.servicename}')?has_content)>
					params += "&servicename=" + euc('${signin.servicename}');
					serviceName=euc('${signin.servicename}');
				</#if>
				<#if (('${signin.hide_signup}')?has_content)>
					params += "&hide_reg_link="+${signin.hide_signup};
				</#if>	
				<#if (('${signin.appname}')?has_content)>
					params += "&appname="+euc('${signin.appname}');
				</#if>	
				<#if (('${signin.getticket}')?has_content)>
					params += "&getticket=true";
				</#if>	
				<#if (('${signin.serviceurl}')?has_content)>
					params += "&serviceurl="+euc('${Encoder.encodeJavaScript(signin.serviceurl)}');
					serviceUrl = '${Encoder.encodeJavaScript(signin.serviceurl)}';
				</#if>	
				<#if (('${signin.service_language}')?has_content)>
					params += "&service_language="+euc('${signin.service_language}');//no i18N
				</#if>
				<#if (('${signin.portal_id}')?has_content)>
					params += "&portal_id="+euc('${signin.portal_id}');
				</#if>	
				<#if (('${signin.portal_name}')?has_content)>
					params += "&portal_name="+euc('${signin.portal_name}');
				</#if>	
				<#if (('${signin.portal_domain}')?has_content)>
					params += "&portal_domain="+euc('${signin.portal_domain}');
				</#if>
				<#if (('${signin.context}')?has_content)>
						params += "&context="+euc('${signin.context}');//no i18N
				</#if>
				<#if (('${signin.IAM_CID}')?has_content)>
						params += "&IAM_CID="+euc('${signin.IAM_CID}');//no i18N
				</#if>
				<#if (('${signin.token}')?has_content)>
						params += "&token="+euc('${signin.token}');//no i18N
				</#if>
				return params;
			}
		</script>
        <meta name="viewport" content="width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=no" />
        <title><@i18n key="IAM.ZOHO.ACCOUNTS"/></title>
	</head>
	<body>
			<div class="bg_one"></div>
    		<div class="Alert"> <span class="tick_icon"></span> <span class="alert_message"></span> </div>
    		<div class="Errormsg"> <span class="error_icon"></span> <span class="error_message"></span> </div>
			<div class="tls_announce_banner">
				  <span class="icon-warning warningicon"></span>
			      <span class="tls_banner_con"><@i18n key="IAM.NEW.TLS.UPDATE.DESC" arg0="${signin.tlsLearnMoreUrl}"/></span>
			      <div class="close_top"  onclick="this.parentElement.style.display='none';">
	                <span class="close_line1"></span>
	                <span class="close_line2"></span>
            	  </div> 
			</div>
    		<div class="signin_container">
    			<div class='loader'></div> 
    			<div class='blur_elem blur'></div>
    			<div class="signin_box" id="signin_flow">
    					<#if signin.isPortalLogo>
							<div class="zoho_logo ${signin.portal_name}"></div>
    					<#elseif signin.isPortalLogoURL>
    						<div><img class="portal_logo" src="${signin.portalLogoURL}"/></div>
						<#else>
							<div class='zoho_logo'></div>
    					</#if>
	    				<div id="signin_div">
	    					<form name="login" id="login" onsubmit="javascript:return submitsignin(this);" <#if (signin.isMobile == 1) > action="/signin/v2/lookup/"</#if> method="post" novalidate >
	    						<div class="signin_head">
			    					<span id="headtitle"><@i18n key="IAM.SIGN_IN"/></span>
			    					<span id="trytitle"></span>
									<div class="service_name"><@i18n key="IAM.NEW.SIGNIN.SERVICE.NAME.TITLE" arg0="${signin.app_display_name}"/></div>
									<div class="fielderror"></div>
								</div>
								<div class="fieldcontainer">
									<div class="searchparent" id="login_id_container">
									<div class="textbox_div" id="getusername">
										<label for='country_code_select' class='select_country_code'></label>
										<select id="country_code_select" onchange="changeCountryCode();">
		                  					<#list signin.country_code as dialingcode>
	                          					<option data-num="${dialingcode.code}" value="${dialingcode.dialcode}" id="${dialingcode.code}" >${dialingcode.display}</option>
	                           				</#list>
										</select>
										<input id="login_id" placeholder="<@i18n key="IAM.NEW.SIGNIN.EMAIL.ADDRESS.OR.MOBILE"/>" value="${Encoder.encodeHTMLAttribute(signin.loginId)}" type="email" name="LOGIN_ID" class="textbox" required="" onkeypress="clearCommonError('login_id')" onkeyup ="checking()" onkeydown="checking()" autocapitalize="off" autocomplete="on" autocorrect="off" ${signin.readOnlyEmail} tabindex="1" />
										<div class="fielderror"></div>						
									</div>
									</div>
									<div class="getpassword zeroheight" id="password_container">
										<div class="hellouser">
											<div class="username"></div>
											<span class="Notyou bluetext" onclick="resetForm()"><@i18n key="IAM.PHOTO.CHANGE"/></span>
										</div>
										<div class="textbox_div">
											<input id="password" placeholder="<@i18n key="IAM.NEW.SIGNIN.PASSWORD"/>" name="PASSWORD" type="password" class="textbox" required="" onkeypress="clearCommonError('password')" autocapitalize="off" autocomplete="password" autocorrect="off" /> 
											<span class="icon-hide show_hide_password" onclick="showHidePassword();"></span>
											<div class="fielderror"></div>
											<div class="textbox_actions" id="enableotpoption">
												<span class="bluetext_action" id="signinwithotp" onclick="showAndGenerateOtp()"><@i18n key="IAM.NEW.SIGNIN.USING.OTP"/></span>
												<#if !signin.ishideFp>
													<span class="bluetext_action bluetext_action_right" id="blueforgotpassword" onclick="goToForgotPassword();"><@i18n key="IAM.FORGOT.PASSWORD"/></span>
												</#if>
											</div>
											<div class="textbox_actions" id="enableforgot">
												<#if !signin.ishideFp>
													<span class="bluetext_action bluetext_action_right" id="blueforgotpassword" onclick="goToForgotPassword();"><@i18n key="IAM.FORGOT.PASSWORD"/></span>
												</#if>
											</div>
											<div class="textbox_actions_saml" id="enablesaml">
												<a href="" class="bluetext_action" id="signinwithsaml"><@i18n key="IAM.NEW.SIGNIN.USING.SAML"/></a>
												<#if !signin.ishideFp>
													<span class="bluetext_action bluetext_action_right" id="blueforgotpassword" onclick="goToForgotPassword();"><@i18n key="IAM.FORGOT.PASSWORD"/></span>
												</#if>
											</div>
											<div class="textbox_actions_saml" id="enablejwt">
												<a href="" class="bluetext_action" id="signinwithjwt"><@i18n key="IAM.NEW.SIGNIN.USING.JWT"/></a>
												<#if !signin.ishideFp>
													<span class="bluetext_action bluetext_action_right" id="blueforgotpassword" onclick="goToForgotPassword();"><@i18n key="IAM.FORGOT.PASSWORD"/></span>
												</#if>
											</div>	
										</div> 
									</div>
							<div class="textbox_div" id="mfa_device_container">
								<div class="devices">
									<select class='secondary_devices' onchange='changeSecDevice(this);'></select>
									<div class="deviceparent">
										<span class="deviceinfo icon-device"></span>
										<span class="devicetext"></span>
									</div>
								</div>
							</div>
								<div id="otp_container">
									<div class="hellouser">
										<div class="username"></div>
										<span class="Notyou bluetext" onclick="resetForm()"><@i18n key="IAM.PHOTO.CHANGE"/></span>
									</div>
									<div class="textbox_div" >
										<#if (signin.isMobile == 1) >
											<input id="otp" placeholder="<@i18n key="IAM.NEW.SIGNIN.OTP"/>" type="number" name="OTP" class="textbox" required="" onkeypress="clearCommonError('otp')" autocapitalize="off" autocomplete="off" autocorrect="off"/> 
										<#else>
											<input id="otp" placeholder="<@i18n key="IAM.NEW.SIGNIN.OTP"/>" type="text" name="OTP" class="textbox" required="" onkeypress="clearCommonError('otp')" autocapitalize="off" autocomplete="off" autocorrect="off"/>
										</#if>
										<div class="fielderror"></div>
										<div class="textbox_actions">
											<span class="bluetext_action" id="signinwithpass" onclick="showPassword()"><@i18n key="IAM.NEW.SIGNIN.USING.PASSWORD"/></span>
											<span class="bluetext_action bluetext_action_right resendotp" onclick="generateOTP(true)"><@i18n key="IAM.NEW.SIGNIN.RESEND.OTP"/></span>
										</div>
									</div>
								</div>
							<div class="textbox_div" id="mfa_otp_container">
								<#if (signin.isMobile == 1) >
									<input id="mfa_otp" placeholder="<@i18n key="IAM.NEW.SIGNIN.OTP"/>" type="number" name="MFAOTP" class="textbox" required="" onkeypress="clearCommonError('mfa_otp')" autocapitalize="off" autocomplete="off" autocorrect="off"/> 
								<#else>
									<input id="mfa_otp" placeholder="<@i18n key="IAM.NEW.SIGNIN.OTP"/>" type="text" name="MFAOTP" class="textbox" required="" onkeypress="clearCommonError('mfa_otp')" autocapitalize="off" autocomplete="off" autocorrect="off"/>
								</#if>
								<div class="fielderror"></div>
								<div class="textbox_actions">
									<span class="bluetext_action bluetext_action_right resendotp" onclick="generateOTP(true)"><@i18n key="IAM.NEW.SIGNIN.RESEND.OTP"/></span>
								</div>
							</div>
							<div class="textbox_div" id="mfa_totp_container">
								<#if (signin.isMobile == 1) >
									<input id="mfa_totp" placeholder="<@i18n key="IAM.NEW.SIGNIN.VERIFY.CODE"/>" type="number" name="TOTP" class="textbox" required="" onkeypress="clearCommonError('mfa_totp')" autocapitalize="off" autocomplete="off" autocorrect="off"/> 
								<#else>
									<input id="mfa_totp" placeholder="<@i18n key="IAM.NEW.SIGNIN.VERIFY.CODE"/>" type="text" name="TOTP" class="textbox" required="" onkeypress="clearCommonError('mfa_totp')" autocapitalize="off" autocomplete="off" autocorrect="off"/> 
								</#if>	
								<div class="fielderror"></div>
							</div>
							
							<div class="qrcodecontainer" id="mfa_scanqr_container">
								<span class="qr_before"></span>
							    <img id="qrimg" src=""/>
							    <span class="qr_after"></span>
							</div>
							<div class="textbox_div" id="captcha_container">
								<input id="captcha" placeholder="<@i18n key="IAM.NEW.SIGNIN.ENTER.CAPTCHA"/>" type="text" name="captcha" class="textbox" required="" onkeypress="clearCommonError('captcha')" autocapitalize="off" autocomplete="off" autocorrect="off" maxlength="8"/>
								<div id="captcha_img" name="captcha" class="textbox"></div>
								<span class="reloadcaptcha" onclick="changeHip()"> </span>
								<div class="fielderror"></div> 
							</div>
							<#if (signin.isMobile == 1) >
									<div class="btn blue waitbtn" id="openoneauth" onclick="QrOpenApp()">
										<span class="oneauthtext"><@i18n key="IAM.NEW.SIGNIN.OPEN.ONEAUTH"/></span>
									</div>
							</#if>
							<div id="yubikey_container">
								<div class="fielderror"></div>
							</div>
							<button class="btn blue waitbtn" id="waitbtn">
									<span class="loadwithbtn"></span>
									<span class="waittext"><@i18n key="IAM.NEW.SIGNIN.WAITING.APPROVAL"/></span>
							</button>
							</div>
							<div class="textbox_actions_more" id="enablemore">
								<span class="bluetext_action" id="showmoresigininoption" onclick="showmoresigininoption()"><@i18n key="IAM.NEW.SIGNIN.CHOOSE.OTHER.WAY"/></span>
								<#if !signin.ishideFp>
									<span class="bluetext_action bluetext_action_right blueforgotpassword" id="blueforgotpassword" onclick="goToForgotPassword();"><@i18n key="IAM.FORGOT.PASSWORD"/></span>
								</#if>
								<span class="bluetext_action bluetext_action_right resendotp" id="resendotp" onclick="generateOTP(true)"><@i18n key="IAM.NEW.SIGNIN.RESEND.OTP"/></span>
							</div>	
							<div class="addaptivetfalist">
									<div class="signin_head verify_title"><@i18n key="IAM.NEW.SIGNIN.TRY.ANOTHERWAY"/></div>
									<div class="optionstry optionmod" id="trytotp" onclick="tryAnotherway('totp')" >
										<div class="img_option_try img_option icon-totp"></div>
										<div class="option_details_try">
											<div class="option_title_try"><@i18n key="IAM.NEW.SIGNIN.TRY.ANOTHERWAY.TOTP.TITLE"/></div>
											<div class="option_description try_option_desc"><@i18n key="IAM.NEW.SIGNIN.TRY.ANOTHERWAY.TOTP.DESC"/></div>
										</div>
										<div class='mfa_totp_verify verify_totp' id='verify_totp_container'> 
											<input id="verify_totp" placeholder="<@i18n key="IAM.NEW.SIGNIN.OTP"/>" type="number" name="MFATOTP" class="textbox" required="" onkeypress="clearCommonError('verify_totp')" autocapitalize="off" autocomplete="off" autocorrect="off"/>
											<button class="btn blue" id="totpverifybtn" tabindex="2" >
												<span class="loadwithbtn"></span>
												<span class="waittext"><@i18n key="IAM.VERIFY"/></span>
											</button>
											<div class="fielderror"></div>
										</div>
									</div>
									<div class="optionstry optionmod" id="tryscanqr" onclick="tryAnotherway('qr')" >
										<div class="img_option_try img_option icon-qr"></div>
										<div class="option_details_try">
											<div class="option_title_try"><@i18n key="IAM.NEW.SIGNIN.TRY.ANOTHERWAY.SCANQR.TITLE"/></div>
											<div class="option_description try_option_desc"><@i18n key="IAM.NEW.SIGNIN.TRY.ANOTHERWAY.SCANQR.DESC"/></div>
										</div>
										<div class="verify_qr" id="verify_qr_container">
											<div class="qrcodecontainer">
												<div>
													<span class='qr_before'></span>
												    <img id="verify_qrimg" src=""/>
												   	<span class='qr_after'></span>
												   	<div class="loader"></div>
												   	<div class="blur_elem blur"></div>
											   	</div>
											</div>
										   	<#if (signin.isMobile == 1) >
												<div class="btn blue waitbtn" id="openoneauth" onclick="QrOpenApp()">
													<span class="oneauthtext"><@i18n key="IAM.NEW.SIGNIN.OPEN.ONEAUTH"/></span>
												</div>
											</#if>
										</div>
									</div>
									<span class="close_icon error_icon" onclick="hideTryanotherWay()"></span>
									<div class='text16 pointer nomargin' id='recoverybtn_mob' onclick='showCantAccessDevice()'><@i18n key="IAM.NEW.SIGNIN.CANT.ACCESS"/></div>
									<div class="text16 pointer nomargin" id="problemsignin_mob" onclick="showproblemsignin()"><@i18n key="IAM.NEW.SIGNIN.PROBLEM.SIGNIN"/></div>
							</div>
							<div id="problemsigninui"></div>
							
							<button class="btn blue" id="nextbtn" tabindex="2" disabled="disabled"><span><@i18n key="IAM.NEXT"/></span></button>
							<div class="btn borderless" onclick="hideBackupOptions()"><@i18n key="IAM.BACK"/></div>
							<div class='text16 pointer nomargin' id='recoverybtn' onclick='showCantAccessDevice()'><@i18n key="IAM.NEW.SIGNIN.CANT.ACCESS"/></div>
							<div class="text16 pointer nomargin" id="problemsignin" onclick="showproblemsignin()"><@i18n key="IAM.NEW.SIGNIN.PROBLEM.SIGNIN"/></div>
							<div class="tryanother text16" onclick ="showTryanotherWay()"><@i18n key="IAM.NEW.SIGNIN.TRY.ANOTHERWAY"/></div>
							<#if !signin.ishideFp>
								<div class="text16 pointer" id="forgotpassword"><a class="text16" onclick="goToForgotPassword();"><@i18n key="IAM.FORGOT.PASSWORD"/></a></div>
							</#if>
	    					</form>
	    					<div id="recovery_container">
								<div class="signin_head recoveryhead">
									<table id="recoverytitle"><span class='icon-backarrow backoption' onclick='goBackToProblemSignin()'></span><span class="rec_head_text"><@i18n key="IAM.NEW.SIGNIN.CANT.ACCESS"/></span></table>
									</div>
									<div id='recoverymodeContainer'></div>
									<div class='recoverymodes'>
										<div class="options options_hover" id="recoverOption" onclick="showBackupVerificationCode()">
											<div class="img_option icon-backup"></div>
											<div class="option_details">
												<div class="option_title"><@i18n key="IAM.TFA.USE.BACKUP.CODE"/></div>
												<div class="option_description"><@i18n key="IAM.NEW.SIGNIN.BACKUP.HEADER"/></div>
											</div>
										</div>
										<div class="options options_hover" id="passphraseRecover" onclick="showPassphraseContainer()">
											<div class="img_option icon-saml"></div>
											<div class="option_details">
												<div class="option_title"><@i18n key="IAM.NEW.SIGNIN.MFA.PASSPHRASE.HEADER"/></div>
												<div class="option_description"><@i18n key="IAM.NEW.SIGNIN.MFA.PASSPHRASE.DESC"/></div>
											</div>
										</div>
										<div class="options contact_support">
											<div class="img_option icon-support"></div>
											<div class="option_details">
												<div class="option_title"><@i18n key="IAM.NEW.SIGNIN.CONTACT.SUPPORT"/></div>
												<div class="option_description contactsuprt"><@i18n key="IAM.NEW.SIGNIN.CONTACT.SUPPORT.DESC" arg0="${signin.supportEmailAddress}"/></div>
										</div>
									</div>
								</div>
								<div class="btn greytext" ></div>
						   </div>
						   <div id='backup_container'>
								<div class="signin_head backuphead">
									<span id="backup_title"><span class='icon-backarrow backoption' onclick='showCantAccessDevice()'></span><@i18n key="IAM.TFA.USE.BACKUP.CODE"/></span>
									<div class="backup_desc extramargin"><@i18n key="IAM.NEW.SIGNIN.BACKUP.HEADER"/></div>
								</div>
								<div class="textbox_div" id="backupcode_container">
									<input id="backupcode" placeholder='<@i18n key="IAM.BACKUP.VERIFICATION.CODE"/>' type="text" name="backupcode" class="textbox" required="" onkeypress="clearCommonError('backupcode')" onkeyup="submitbackup(event)" autocapitalize="off" autocomplete="off" autocorrect="off"/> 
									<div class="fielderror"></div>
									<span class="bluetext_action" id="recovery_passphrase" onclick="changeRecoverOption('passphrase')"><@i18n key="IAM.NEW.SIGNIN.MFA.PASSPHRASE.HEADER"/></span>
								</div>
								<div class="textbox_div" id="passphrase_container">
									<input id="passphrase" placeholder="<@i18n key="IAM.NEW.SIGNIN.PASSPHRASE.CODE"/>" type="text" name="PASSPHRASE" class="textbox" required="" onkeypress="clearCommonError('passphrase')" autocapitalize="off" autocomplete="off" autocorrect="off"/>
									<div class="fielderror"></div>
									<span class="bluetext_action" id="recovery_backup" onclick="changeRecoverOption('recoverycode')"><@i18n key="IAM.NEW.SIGNIN.MFA.BACKUP.CODE"/></span>
								</div>
								<div class="textbox_div" id="bcaptcha_container">
									<input id="bcaptcha" placeholder="<@i18n key="IAM.NEW.SIGNIN.ENTER.CAPTCHA"/>" type="text" name="captcha" class="textbox" required="" onkeypress="clearCommonError('bcaptcha')" onkeyup="submitbackup(event)" autocapitalize="off" autocomplete="off" autocorrect="off" maxlength="8"/>
									<div id="bcaptcha_img" name="captcha" class="textbox"></div>
									<span class="reloadcaptcha" onclick="changeHip('bcaptcha_img','bcaptcha')"> </span>
									<div class="fielderror"></div> 
								</div>
								<button class="btn blue" onclick="verifyBackupCode()"><@i18n key="IAM.VERIFY"/></button>
								<div class="btn borderlessbtn back_btn"></div>
							</div>
	    				<div>
	    		</div>
	    		<#if signin.showIdps>
	    			<div class="line"></div>
	    				<div class="fed_2show">
							<div class="signin_fed_text"><@i18n key="IAM.NEW.SIGNIN.FEDERATED.LOGIN.TITLE"/></div>
							<#if signin.apple>
								<span class="fed_div large_box apple_normal_icon apple_fed" id="macappleicon" onclick="createandSubmitOpenIDForm('apple');" title="<@i18n key="IAM.FEDERATED.SIGNIN.APPLE"/>">
						            <div class="fed_icon apple_normal_large"></div>
						        </span>
							</#if>
							<#if signin.google>
								<span class="fed_div large_box google_icon google_fed" onclick="createandSubmitOpenIDForm('google');" title="<@i18n key="IAM.FEDERATED.SIGNIN.GOOGLE"/>">
						            <div class="fed_center_google">
						                <span class="fed_icon googleIcon"></span>
						                <span class="fed_text_avoid">Google</span>
						            </div>
						        </span>
							</#if>
							<#if signin.azure>
								<span class="fed_div large_box MS_icon azure_fed" onclick="createandSubmitOpenIDForm('azure');" title="<@i18n key="IAM.FEDERATED.SIGNIN.MICROSOFT"/>">
						            <div class="fed_center">
						                <span class="fed_icon"></span>
						                <span class="fed_text">Microsoft</span>
						            </div>
						        </span>
							</#if>
							<#if signin.linkedin>
								 <span class="fed_div large_box linkedin_icon linkedin_fed" onclick="createandSubmitOpenIDForm('linkedin');" title="<@i18n key="IAM.FEDERATED.SIGNIN.LINKEDIN"/>">
						            <div class="fed_center">
						                <span class="fed_icon linked_fed_icon"></span>
						            </div>
						        </span>
							</#if>
							<#if signin.facebook>
								<span class="fed_div large_box fb_icon facebook_fed" onclick="createandSubmitOpenIDForm('facebook');" title="<@i18n key="IAM.FEDERATED.SIGNIN.FACEBOOK"/>">
									<div class="fed_center">
							            <div class="fed_icon fb_fedicon"></div>
							            <span class="fed_text">Facebook</span>
							        </div>
						        </span>
							</#if>
							<#if signin.twitter>
								<span class="fed_div large_box twitter_icon twitter_fed" onclick="createandSubmitOpenIDForm('twitter');" title="<@i18n key="IAM.FEDERATED.SIGNIN.TWITTER"/>">
						            <div class="fed_center">
						                <span class="fed_icon"></span>
						                <span class="fed_text">Twitter</span>
						            </div>
						        </span>
							</#if>
							<#if signin.yahoo>
								<span class="fed_div large_box yahoo_icon yahoo_fed"  onclick="createandSubmitOpenIDForm('yahoo');" title="<@i18n key="IAM.FEDERATED.SIGNIN.YAHOO"/>">
						            <div class="fed_icon yahoo_fedicon"></div>
						        </span>
							</#if>
							<#if signin.slack>
								<span class="fed_div large_box slack_icon slack_fed" onclick="createandSubmitOpenIDForm('slack');" title="<@i18n key="IAM.FEDERATED.SIGNIN.SLACK"/>">
						            <div class="fed_icon slack_fedicon"></div>
						        </span>
							</#if>
							<#if signin.douban>
								<span class="fed_div large_box douban_icon douban_fed" onclick="createandSubmitOpenIDForm('douban');" title="<@i18n key="IAM.FEDERATED.SIGNIN.DOUBAN"/>">
						            <div class="fed_icon douban_fedicon"></div>
						        </span>
							</#if>
							<#if signin.qq>
								<span class="fed_div large_box qq_icon qq_fed" onclick="createandSubmitOpenIDForm('qq');" title="<@i18n key="IAM.FEDERATED.SIGNIN.QQ"/>">
						            <div class="fed_icon qq_fedicon"></div>
						        </span>
							</#if>
							<#if signin.wechat>
								<span class="fed_div large_box wechat_icon wechat_fed" onclick="createandSubmitOpenIDForm('wechat');" title="<@i18n key="IAM.FEDERATED.SIGNIN.WECHAT"/>">
						            <div class="fed_center">
						                <span class="fed_icon"></span>
						                <span class="fed_text">WeChat</span>
						            </div>
						        </span>
							</#if>
							<#if signin.weibo>
								<span class="fed_div large_box weibo_icon weibo_fed" onclick="createandSubmitOpenIDForm('weibo');" title="<@i18n key="IAM.FEDERATED.SIGNIN.WEIBO"/>">
						            <div class="fed_center">
						                <span class="fed_icon"></span>
						                <span class="fed_text weibo_text">Weibo</span>
						            </div>
						        </span>
							</#if>
							<#if signin.baidu>
								<span class="fed_div large_box baidu_icon baidu_fed"  onclick="createandSubmitOpenIDForm('baidu');" title="<@i18n key="IAM.FEDERATED.SIGNIN.BAIDU"/>">
						            <div class="fed_icon baidu_fedicon"></div>
						        </span>
							</#if>
							<#if signin.apple>
								<span class="fed_div large_box apple_normal_icon apple_fed" onclick="createandSubmitOpenIDForm('apple');" title="<@i18n key="IAM.FEDERATED.SIGNIN.APPLE"/>">
						            <div class="fed_icon apple_normal_large"></div>
						        </span>
							</#if>
							<#if signin.intuit>
								<span class="fed_div large_box intuit_icon intuit_fed" onclick="createandSubmitOpenIDForm('intuit');" title="<@i18n key="IAM.FEDERATED.SIGNIN.INTUIT"/>">
						             <div class="fed_icon intuit_fedicon"></div>
						        </span>
							</#if>
							<#if signin.adp>
								<span class="fed_div large_box adp_icon adp_fed" onclick="createandSubmitOpenIDForm('adp');" title="<@i18n key="IAM.FEDERATED.SIGNIN.ADP"/>">
						            <div class="fed_icon adp_fedicon"></div>
						        </span>
							</#if>
							<span class="fed_div more" id="showIDPs" title="<@i18n key="IAM.FEDERATED.SIGNIN.MORE"/>" onclick="showMoreIdps();"> <span class="morecircle"></span> <span class="morecircle"></span> <span class="morecircle"></span></span>
							<div class="zohosignin hide" onclick="showZohoSignin()"><@i18n key="IAM.NEW.SIGNIN.USING.ZOHO"/></div>	
					</div>
				</#if>
    			</div>
    			<div class="nopassword_container">
    				<div class="nopassword_icon icon-hint"></div>
    				<div class="nopassword_message"><@i18n key="IAM.NEW.SIGNIN.NO.PASSWORD.MESSAGE" arg0="goToForgotPassword();"/></div>
    			</div>
    			<div class="password_expiry_container">
    				<div class="passexpsuccess"></div>
    				<div class="signin_head">
							<span id="headtitle"><@i18n key="IAM.NEW.SIGNIN.PASSWORD.EXPIRED"/></span>
							<div class="pass_name extramargin" id="password_desc"></div>
					</div>
					<div class="textbox_div" id="npassword_container">
							<input id="new_password" onkeyup="setPassword(event)" placeholder='<@i18n key="IAM.NEW.SIGNIN.PASSWORD.EXPIRED.NEW.PASSWORD"/>' name="newPassword" type="password" class="textbox" required="" onkeypress="clearCommonError('password')" autocapitalize="off" autocomplete="password" autocorrect="off" />
							<span class="icon-hide show_hide_password" onclick="showHidePassword();"></span>
							<div class="fielderror"></div>
							<div id="pass_policy" class="pass_policy"></div>
							<div class="pass_policy_error"></div>
					</div>
					<div class="textbox_div" id="rpassword_container">
							<input id="new_repeat_password" onkeyup="setPassword(event)" placeholder='<@i18n key="IAM.CONFIRM.PASS"/>' name="cpwd" type="password" class="textbox" required="" onkeypress="clearCommonError('password')" autocapitalize="off" autocomplete="password" autocorrect="off" /> 
					</div>
					<div class="checkbox_div">
						<input id="termin_web" name="signoutfromweb" class="checkbox_check" type="checkbox">
						<span class="checkbox">
							<span class="checkbox_tick"></span>
						</span>
						<label for="termin_web" class="checkbox_label"><@i18n key="IAM.RESET.PASSWORD.SIGNOUT.WEB"/></label>
					</div>
					<div class="checkbox_div">
						<input id="termin_mob" name="signoutfrommobile" class="checkbox_check" type="checkbox">
						<span class="checkbox">
							<span class="checkbox_tick"></span>
						</span>
						<label for="termin_mob" class="checkbox_label big_checkbox_label"><@i18n key="IAM.RESET.PASSWORD.SIGNOUT.MOBILE.SESSION"/></label>
					</div>
					<div class="checkbox_div checkbox_mod">
						<input id="termin_api" name="signoutfrommobile" class="checkbox_check" type="checkbox">
						<span class="checkbox">
							<span class="checkbox_tick"></span>
						</span>
						<label for="termin_api" class="checkbox_label big_checkbox_label"><@i18n key="IAM.RESET.PASSWORD.DELETE.APITOKENS"/></label>
					</div>
					<button class="btn blue" id="changepassword" onclick="updatePassword();"><@i18n key="IAM.NEW.SIGNIN.PASSWORD.EXPIRED.SET"/></button>
    			</div>
    				<div class="trustbrowser_ui">
						<div class="signin_head">
							<span id="headtitle"><@i18n key="IAM.TFA.TRUST.BROWSER.QUESTION"/></span>
							<div class="service_name mod_sername"></div>
						</div>
						<button class="btn blue trustdevice trustbtn" onclick="updateTrustDevice(true)">
							<span class="loadwithbtn"></span>
							<span class="waittext"><@i18n key="IAM.TRUST"/></span>
						</button>
						<button class="btn grey trustdevice notnowbtn"  onclick="updateTrustDevice(false)">
							<span class="loadwithbtn"></span>
							<span class="waittext"><@i18n key="IAM.NOTNOW"/></span>
						</button>
				</div>
				<div id="restict_signin">
					<div class='signin_head restrict_head'><@i18n key="IAM.NEW.SIGNIN.RESTRICT.SIGNIN.HEADER"/></div>
					<div class='restrict_icon'></div> 
					<div class='restrict_desc service_name'><@i18n key="IAM.NEW.SIGNIN.RESTRICT.SIGNIN.DESC"/></div>
					<button class="btn blue trybtn" id="nextbtn" tabindex="2" onclick="window.location.reload()"><@i18n key="IAM.YUBIKEY.TRY.AGAIN"/></button>
				</div>
    		</div>
    		
    		<div class="rightside_box">
    			<div class='mfa_panel'>
					<div class="product_img" id="product_img"></div>
					<div class="product_head"><@i18n key="IAM.NEW.SIGNIN.KEEP.ACCOUNT.SECURE"/></div>
					<div class="devicedetails"><span class="deviceicon icon-device"></span><span class="devicetext"></span></div>
					<div class='devices'><select class='secondary_devices_right' onchange='changeSecDevice(this);'></select></div>
					<div class="product_text"><@i18n key="IAM.NEW.SIGNIN.ONEAUTH.INFO.HEADER" arg0="${signin.oneAuthUrl}"/></div>
				</div>
				<div class='oneauth_panel hide'>
					<div class="Steps">
	                    <div class="Step" id="Step1" onclick="ClickStep(1,true)">
	                        <div class="step_values active_step">1</div>
	                        <div class="step_after">
	                            <div class="animate_line"></div>
	                        </div>
	                    </div>
	                    <div class="Step" id="Step2" onclick="ClickStep(2,true)">
	                        <div class="step_values">2</div>
	                        <div class="step_after">
	                            <div class="animate_line"></div>
	                        </div>
	                    </div>
	                    <div class="Step" id="Step3" onclick="ClickStep(3,true)">
	                        <div class="step_values">3</div>
	                    </div>
	                </div> 
	                <div class="text_div"> 
	                    <div class="overlap_div">  
	                        <div class="step_content step_one"><@i18n key="IAM.NEW.SIGNIN.RIGHT.PANEL.VERIFY.PUSH"/></div> 
	                        <div class="step_content step_two"><@i18n key="IAM.NEW.SIGNIN.RIGHT.PANEL.ALLOW.PUSH"/></div> 
	                        <div class="step_content step_three"><@i18n key="IAM.NEW.SIGNIN.RIGHT.ALLOW.APPROVAL"/></div>   
	                    </div> 
	                </div>
	                <div class="MFA_illustration PushCame"></div>
				</div>
    		</div>
		</div>    	
		<#if !signin.hideSignUpOption>
			<div id="signuplink"><@i18n key="IAM.HOME.WELCOMEPAGE.SIGNUP.NOW" arg0="register()"/></div>
		</#if>
		<div id="enableCookie" style='display:none;text-align:center'>
            <#if signin.isPortalLogo>
                    <div class="zoho_logo ${signin.portal_name} logo_mod"></div>
            <#elseif signin.isPortalLogoURL>
                    <div><img class='logo_mod_url' src="${signin.portalLogoURL}" height="46"/></div>
            <#else>
                    <div class='zoho_logo zoho_loho_changes'></div>
            </#if>
            <div style="text-align: center;padding: 10px;"><@i18n key="IAM.ERROR.COOKIE_DISABLED"/></div>
	    </div>
	</body>
</html>