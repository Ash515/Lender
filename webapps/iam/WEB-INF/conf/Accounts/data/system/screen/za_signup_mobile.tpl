<!DOCTYPE html>
<html>
<head>
<title><@i18n key="IAM.CREATE.ZACCOUNT" /></title>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=no">
<script type="text/javascript" src="${za.contextpath}/register.js?${signup.scriptParams}"></script>
</head>
<body style="visibility: hidden;">
	<#assign tos_link><@i18n key="IAM.LINK.TOS" /></#assign> <#assign privacy_link><@i18n key="IAM.LINK.PRIVACY" /></#assign>
	<header> </header>
	<section class="signupoutersection">
		<section class="signupcontainer">
			<div class="logocolor">
				<span class="colorred"></span> <span class="colorgreen"></span> <span class="colorblue"></span> <span class="coloryellow"></span>
			</div>
			<div class="logo"></div>
			<div style="clear: both;"></div>
		<#if signup.isEnabled>
			<div class="form-title"><@i18n key="IAM.CREATE.ZACCOUNT" /></div>
			<form action="${za.contextpath}/register.ac" name="signupform" method="post" class="form">   											
				<div class="commonborder">
					<dl class="za-username-container za-placeholder-icon">
						<dd>
							<input type="text" placeholder='<@i18n key="IAM.GENERAL.USERNAME" />' name="username" maxlength="100">
						</dd>
					</dl>
					<dl class="za-emailormobile-container">
     					<dd>
     						<input type="text" placeholder='<@i18n key="IAM.EMAIL.ADDRESS.OR.MOBILE" />' name="emailormobile" maxlength="100" tabindex="1" id="phonenumber" autofocus >
     					</dd>
     				</dl>
     				<dl class="za-mobile-container">
						<dd>
							<input type="text" placeholder='<@i18n key="IAM.PHONE.NUMBER" />' name="mobile" tabindex="1" id="mobilefield" >
						</dd>
					</dl>
					<dl class="za-email-container za-placeholder-icon">
						<dd>
							<input type="text" placeholder='<@i18n key="IAM.EMAIL.ADDRESS" />' name="email" autofocus>
						</dd>
					</dl>
					<dl class="za-password-container za-placeholder-icon">
						<dd>
							<input type="password" placeholder='<@i18n key="IAM.PASSWORD" />' name="password"> <span class='showpassword' style="display: none;" onclick='showPassword(this)'>Show</span>
						</dd>
					</dl>
				</div>
				<dl class="za-country-container">
					<dd>
						<select class="form-input countryCnt za-country-select" name="country" id="country" tabindex="1" placeholder='<@i18n key="IAM.TFA.SELECT.COUNTRY" />' ></select>
					</dd>
				</dl>
				<dl class="za-country_state-container">
					<dd>
						<select class="form-input countryCnt" name="country_state" id="country_state" tabindex="1"></select>
					</dd>
				</dl>
				<dl class="za-captcha-container">
					<dt><@i18n key="IAM.FIELD.CAPTCHA.VERIFICATION" /></dt>
					<dd>
						<img src="${za.contextpath}/images/spacer.gif" class="za-captcha"> <input type="text" placeholder='' name="captcha" autocapitalize="off" autocomplete="off" autocorrect="off" maxlength="10"> <span class="za-refresh-captcha" onclick="reloadCaptcha(document.signupform)"></span>
					</dd>
				</dl>
				<dl class="za-newsletter-container">
					<dd>
						<div class="field-msg">
							<div class="znewsletter"><label><input type="checkbox" name="newsletter" value="true" class="za-newsletter"><@i18n key="IAM.TPL.ZOHO.NEWSLETTER.SUBSCRIBE"/></label></div>
							<#if !signup.isTosRequired> <span class="note p0"><@i18n key="IAM.SIGNUP.AGREE.TOS.PRIVACY.MOBILE" arg0="${tos_link}" arg1="${privacy_link}"/></span></#if>
						</div>
					</dd>
				</dl>
			<#if signup.isTosRequired>
				<dl class="za-tos-container">
					<dd>
						<div class="field-msg">
							<div class="znewsletter"><label><input type="checkbox" name="tos" value="true" class="za-newsletter"><@i18n key="IAM.SIGNUP.AGREE.TERMS.OF.SERVICE" arg0="${tos_link}" arg1="${privacy_link}"/></label></div>
						</div>
					</dd>
				</dl>
			</#if>
				<dl class="mob-submit-btn">
					<dd>
						<input type="submit" class="btn big-btn primary" value='<@i18n key="IAM.LINK.SIGNUP.SIGNUP" />'>
					</dd>
				</dl>
			</form>
		<#else>
			<div class="signupblockdiv">
				<dl><dt><@i18n key="IAM.REGISTRATION.NOT.ALLOWED" arg0="${signup.supportEmail}" /></dt></dl>
			</div>
			<dl class="mob-submit-btn">
				<dd><input type="button" class="blockbtndiv" value='<@i18n key="IAM.BACKTO.HOME" />' onclick="history.go(-1);"></dd>
			</dl>
		</#if>
		</section>
		<#if !partner.isfujixerox>
		<div class="footer">
			<span><@i18n key="IAM.FOOTER.COPYRIGHT" arg0="${signup.copyrightYear}"/></span>
		</div>
		</#if>
	</section>
	<footer> </footer>
	<script type="text/javascript">
		function onSignupReady() {
			$("input[name='password']").keyup(function() {
				if ($(this).val().length >= 2) {
					$(".showpassword").show();
				}
			})
			// To avoid glitches on page load, as we lazy load CSS. 
			$(document.body).css("visibility", "visible");
			$(document.signupform).zaSignUp({
				commonerror : true,
				handleConfirmation : function(data) {
					if(data.mobile_redirect_url){
						data.doAction();
						return;
					}
					if (!$(".za-confirm").length) {
						var confirmTpl = this.options.getConfirmationTemplate().replace("$EMAIL", data.email); // No I18N
						$(".signupoutersection").addClass("confirmoutersection").removeClass("signupoutersection");
						$(".confirmoutersection").html(confirmTpl);
					}
					$(".confirmoutersection input").click(data.doAction);
					setTimeout(function() {
						data.doAction();
					}, 5000);
				}
			});
		}
		
		
	</script>
</body>
</html>