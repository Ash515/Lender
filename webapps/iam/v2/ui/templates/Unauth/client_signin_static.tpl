	<script type='text/javascript'>
        	var serviceUrl,serviceName;
			var csrfParam= "${za.csrf_paramName}";
			var csrfCookieName = "${za.csrf_cookieName}";
			var resetPassUrl = '${signin.resetPassUrl}';
			var queryString = window.location.search.substring(1);
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
			var isClientPortal = parseInt("${signin.isClientPortal}");
			var uriPrefix = '${signin.uri_prefix}';
			var contextpath = "${za.contextpath}";
			var istlsEnabled = parseInt('${signin.istlsEnabled}');
			
			I18N.load({
					"IAM.ZOHO.ACCOUNTS" : '<@i18n key="IAM.ZOHO.ACCOUNTS" />',
					"IAM.ERROR.ENTER_PASS" : '<@i18n key="IAM.ERROR.ENTER_PASS" />',
					"IAM.SIGNIN.ERROR.CAPTCHA.REQUIRED" : '<@i18n key="IAM.SIGNIN.ERROR.CAPTCHA.REQUIRED" />',
					"IAM.NEW.SIGNIN.INVALID.OTP.MESSAGE.EMPTY" : '<@i18n key="IAM.NEW.SIGNIN.INVALID.OTP.MESSAGE.EMPTY" />',
					"IAM.SIGNIN" : '<@i18n key="IAM.SIGN_IN" />', 
					"IAM.NEXT" : '<@i18n key="IAM.NEXT" />', 
					"IAM.VERIFY" : '<@i18n key="IAM.VERIFY" />',
					"IAM.NEW.SIGNIN.ENTER.EMAIL.OR.MOBILE" : '<@i18n key="IAM.NEW.SIGNIN.ENTER.EMAIL.OR.MOBILE" />',
					"IAM.SIGNIN.ERROR.USEREMAIL.NOT.EXIST":'<@i18n key="IAM.SIGNIN.ERROR.USEREMAIL.NOT.EXIST"/>',
					"IAM.NEW.SIGNIN.SERVICE.NAME.TITLE":'<@i18n key="IAM.NEW.SIGNIN.SERVICE.NAME.TITLE"/>',
					
				});
			window.onload = function() {
				$("#nextbtn").removeAttr("disabled");
				onSigninReady();
			}
			function getSigninParms(){
				var params = "cli_time=" + new Date().getTime();
				<#if (('${signin.servicename}')?has_content)>
					params += "&servicename=" + euc('${signin.servicename}');
					serviceName=euc('${signin.servicename}');
				</#if>
				<#if (('${signin.service_language}')?has_content)>
					params += "&service_language="+euc('${signin.service_language}');//no i18N
				</#if>
				return params;
			}
		</script>
