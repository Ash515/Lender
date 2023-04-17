<!DOCTYPE html>
<html>
<body>
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
	<#include "za_reset_password_frame">
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
