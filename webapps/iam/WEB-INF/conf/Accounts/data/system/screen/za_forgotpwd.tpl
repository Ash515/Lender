<!DOCTYPE html>
<html>
<head>
<title><@i18n key="IAM.FORGOT.PASSWORD.TITLE" /></title>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<#include "za_forgotpwd_static">
<style type="text/css">
.field-error input {
	background: none !important;
	padding-right: 0 !important;
	width: 350px !important;
	border-color: #D6D6D6 !important; 
}
.field-msg .error {
	border-radius: 0 !important;
	margin-top: 5px !important;
	background-color: transparent !important;
	border-color: transparent !important;
	padding: 0 !important;
	color: #DD4B39 !important;
}
input[type="text"], input[type="email"], input[type="password"], textarea {
	border-radius: 3px !important;

}
</style>
</head>
<body class="bodybg">
	<header>
		<div class="links">
			<a href='<@i18n key="IAM.LINK.ZOHO.HOME" />' target="_blank"><@i18n key="IAM.ZOHO.HOME" /></a>
			<#if !partner.isPartnerHideHeader>
			<#if !partner.isfujixerox>
			<a href='<@i18n key="IAM.LINK.BLOGS" />' target="_blank"><@i18n key="IAM.HEADER.BLOGS" /></a>
			<a href='<@i18n key="IAM.LINK.FORUMS" />' target="_blank"><@i18n key="IAM.HEADER.FORUMS" /></a>
			<a href='<@i18n key="IAM.LINK.FAQ" />' target="_blank"><@i18n key="IAM.HEADER.FAQ" /></a>
			</#if>
			</#if>
		</div>
		<#if partner.isPartnerLogoExist>
			<div><img class="partnerlogo" src="/static/file?t=org&ID=${partner.partnerId}" /></div>
		<#else>
			<div class="logo"></div>
		</#if>
		<div style="clear: both;"></div>
	</header>
	<section class="forgotoutersection">
		<section class="containerbox"> 
		<div id="title">
						<div class="head"><@i18n key="IAM.FORGOT.PASSWORD.TITLE.DIV" /></div>
						<div class="hrTop"></div>
					</div>
					<div class="margin">
			<form action="${za.contextpath}/password.ac" name="passwordform" method="post" class="form">
				<dl>
					<dt><@i18n key="IAM.GENERAL.RECOVERY.PASSWORD" /></dt>
					<dd>
						<input type="text" name="recovery" autofocus maxlength="100" />
					</dd>
				</dl>
				<dl>
					<dt><@i18n key="IAM.FIELD.CAPTCHA.VERIFICATION" /></dt>
					<dd>
						<input type="text" maxlength="10" name="captcha" /> <img src="${za.contextpath}/images/spacer.gif" class="za-captcha" />
					</dd>
				</dl>
				<dl>
					<dd>
						<input type="submit" class="btn big-btn primary" value='<@i18n key="IAM.BUTTON.SUBMIT" />' />
					</dd>
				</dl>
				<dl>
					<dd>
						<div class="field-msg">
							<span class="note p0"> <@i18n key="IAM.FORGOTPASS.NOTES" arg0="${zvars.supportemailid}"/></span>
						</div>
					</dd>
				</dl>
			</form>
			</div>
		</section>
	</section>
	<section class="recoverymainpage">
		<section class="fcontainer2">
			<div class="form-ttl"><@i18n key="IAM.FORGOT.PASSWORD.SECOND.DIV"/></div>
			<form action="${za.contextpath}/password2.ac" name="passwordoptionform" method="post">
			<#if zvars.showpwdrecmobileoption>
				<label class="label_radio" style="margin-top: 20px" for="radio-mobile">
					<input name="radio-box" id="radio-mobile" value="1" type="radio" checked=""> <@i18n key="IAM.RECOVERY.MOBILE.LABEL" />: <strong id="phone"></strong>
				</label>
			</#if>
				<label class="label_radio" for="radio-email">
					<input name="radio-box" id="radio-email" value="2" type="radio"> <@i18n key="IAM.RECOVERY.EMAIL.LABEL" />
				</label>
				<div class="btntag">
					<input type="button" value="<@i18n key='IAM.CONTINUE'/>" class="btn" onclick="validateReset()" />
				</div>
			</form>
		</section>
	</section>
	<!-- Reset password       -->
	<section class="recoveryoptions">
		<div class="email_field">
			<div class="email_notify"></div>
			<div class="notes_text"><@i18n key="IAM.FORGOTPASS.NOTES" arg0="${zvars.supportemailid}"/></div>
		</div>
		<div class="mobile_field">
			<h2><@i18n key="IAM.PHONE.VERIFICATION.CODE.SENT.SUCCESS"/></h2>
			<div class="mobile_notify"></div>
			<div class="mobile_input">
				<div><@i18n key="IAM.MOBILE.VERFICATION.TEXTLABEL"/>
				</div>
				<input type="text" class="verification_mobile" />
			</div>
			<div>
				<input type="button" value="<@i18n key='IAM.CONTINUE'/>" class="btn" style='margin-top: 10px;' onclick="resetPasswordTemplateView()" />&nbsp;
			</div>
		</div>
	</section>
	<!--        -->

	<footer>
	<#if !partner.isPartnerHideHeader>
	<#if partner.isfujixerox>
		<a href='<@i18n key="IAM.LINK.TOS" />' target="_blank"><@i18n key="IAM.SIGNUP.TERMS.OFSERVICE" /></a>
		<a href='<@i18n key="IAM.LINK.PRIVACY" />' target="_blank"><@i18n key="IAM.PRIVACY" /></a>
		<a href='<@i18n key="IAM.CONTACT.LINK" />' target="_blank"><@i18n key="IAM.CONTACT.US" /></a>
	<#else>
		<span><@i18n key="IAM.FOOTER.COPYRIGHT" arg0="${zvars.copyrightYear}"/></span>
		<a href='<@i18n key="IAM.LINK.SECURITY" />' target="_blank"><@i18n key="IAM.FOOTER.SECURITY" /></a>
		<a href='<@i18n key="IAM.LINK.PRIVACY" />' target="_blank"><@i18n key="IAM.PRIVACY" /></a>
		<a href='<@i18n key="IAM.LINK.TOS" />' target="_blank"><@i18n key="IAM.SIGNUP.TERMS.OFSERVICE" /></a>
		<a href='<@i18n key="IAM.LINK.ABOUT.US" />' target="_blank"><@i18n key="IAM.ABOUT.US" /></a>
	</#if>
	</#if>
	</footer>
	<script type="text/javascript">
		$(document).ready(function() {
			$(document.passwordform).zaForgotPwd();
		});
	</script>
</body>
</html>