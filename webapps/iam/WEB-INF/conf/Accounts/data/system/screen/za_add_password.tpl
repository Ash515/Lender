<!DOCTYPE html>
<html>
<head>
<title><@i18n key="IAM.REGISTER.ACCOUNT.CONFIRMATION" /></title>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<#include "za_add_password_static">
<script type="text/javascript">
$(document).ready(function() {
	$(document.passwordform).zaAddPassword();
});
</script>
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
	<section class="addpasswordoutersection">
		<section class="containerbox">
					<div id="title">
						<div class="head"><@i18n key="IAM.REGISTER.ACCOUNT.CONFIRMATION" /></div> 
						<div class="desc">
							<@i18n key="IAM.ADDPASSWORD.DESC" />
						</div>
						<div class="hrTop"></div>
					</div>
					<#if zpass.isvalidrequest>
					<div id="beforeclick" class="margin">
					<form name="passwordform" class="form" action="${za.contextpath}/addpass.ac" method="post">
						<dl>
							<dt><@i18n key="IAM.PASSWORD" /></dt>
							<dd>
								<input type="password"  name="password">
							</dd>
						</dl>
						<dl>
							<dt><@i18n key="IAM.CONFIRM.PASS" /></dt>
							<dd>
								<input type="password" name="cpassword">
							</dd>
						</dl>
						<dl>
							<dd>
								<input type="submit" class="btn big-btn primary" value='<@i18n key="IAM.UPDATE" />' name="submit">
							</dd>
						</dl>
						<#if zpass.isppexist>
		<@i18n key="IAM.PASSWORD.POLICY.MINIMUMLENGTH" arg0="${zpass.minlen}"/><br>
		<@i18n key="IAM.PASSWORD.POLICY.MAXIMUMLENGTH" arg0="${zpass.maxlen}"/><br>
		<#if (zpass.minsplchar >0)>
		<@i18n key="IAM.PASSWORD.POLICY.MINSPECIALCHAR" arg0="${zpass.minsplchar}"/><br>
		</#if>
		<#if (zpass.minnumchar >0)>
		<@i18n key="IAM.PASSWORD.POLICY.MINNUMERICCHAR" arg0="${zpass.minnumchar}"/><br>
		</#if>
		<#if (zpass.passhistory>0)>
		<@i18n key="IAM.PASSWORD.POLICY.PASS_HISTORY" arg0="${zpass.passhistory}"/><br>
		</#if>
		<#if zpass.mixedcase>
		<@i18n key="IAM.PASSWORD.POLICY.MIXED_CASE"/><br>
		</#if>
		</#if>
					</form>
					</div>
					<#else>
					<p class="errortxt"><@i18n key="IAM.INVALID.REQUEST" /></p>
					</#if>
		</section>
	</section>
	<footer>
	<#if !partner.isPartnerHideHeader>
	<#if partner.isfujixerox>
		<a href='<@i18n key="IAM.LINK.TOS" />' target="_blank"><@i18n key="IAM.SIGNUP.TERMS.OFSERVICE" /></a>
		<a href='<@i18n key="IAM.LINK.PRIVACY" />' target="_blank"><@i18n key="IAM.PRIVACY" /></a>
		<a href='<@i18n key="IAM.CONTACT.LINK" />' target="_blank"><@i18n key="IAM.CONTACT.US" /></a>
	<#else>
		<span><@i18n key="IAM.FOOTER.COPYRIGHT" arg0="${zpass.copyrightYear}"/></span>
		<a href='<@i18n key="IAM.LINK.SECURITY" />' target="_blank"><@i18n key="IAM.FOOTER.SECURITY" /></a>
		<a href='<@i18n key="IAM.LINK.PRIVACY" />' target="_blank"><@i18n key="IAM.PRIVACY" /></a>
		<a href='<@i18n key="IAM.LINK.TOS" />' target="_blank"><@i18n key="IAM.SIGNUP.TERMS.OFSERVICE" /></a>
		<a href='<@i18n key="IAM.LINK.ABOUT.US" />' target="_blank"><@i18n key="IAM.ABOUT.US" /></a>
	</#if>
	</#if>
	</footer>
</body>
</html>