<!DOCTYPE html>
<html>
<head>
<title><@i18n key="IAM.ZOHO.ACCOUNTS" /></title>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<#include "za_signin_static">
</head>
<body style="visibility: hidden;">
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
	<section class="signinoutersection">
		<section class="signincontainer">
			<div class="form-title"><@i18n key="IAM.SIGNIN" /></div>
			<form action="${za.contextpath}/signin.ac" name="signinform" method="post" class="form">
				<dl>
					<dd>
						<input type="text" name="username" placeholder='<@i18n key="IAM.EMAIL.ADDRESS" />' autofocus>
					</dd>
				</dl>
				<dl>
					<dd>
						<input type="password" name="password" placeholder='<@i18n key="IAM.PASSWORD" />'>
					</dd>
				</dl>
				<dl class="za-captcha-container" style="display: none;">
					<dd>
						<input type="text" name="captcha" placeholder='<@i18n key="IAM.FIELD.CAPTCHA.VERIFICATION" />' disabled> <img src="${za.contextpath}/images/spacer.gif" class="za-captcha">
					</dd>
				</dl>
				<dl>
					<dd>
						<label>
							<input type="checkbox" name="sremember" value="true" style="vertical-align: top;"> <@i18n key="IAM.SIGNIN.KEEP.ME" />
						</label>
					</dd>
				</dl>
				<dl>
					<dd>
						<input type="submit" class="btn big-btn primary" value='<@i18n key="IAM.SIGNIN" />'>
					</dd>
				</dl>
			</form>
			<#if zidp.showidp>
			<div>
				<div class="idp-topborder"></div>
				<div class="sub-form-title"><@i18n key="IAM.SIGNIN.USING" /></div>
				<div>
					<form action="${za.contextpath}/openid" name="idpform" method="post" class="form"></form>
					<#if zidp.zoho><span class="ZIcon" title='<@i18n key="IAM.ZOHO.SIGNIN" />' onclick="openIdSignIn('z', '${zidp.zohoname}', ${zidp.isclient});"></span></#if>
					<#if zidp.google><span class="GIcon" title='<@i18n key="IAM.GOOGLE.SIGNIN" />' onclick="openIdSignIn('g', '${zidp.googlename}', ${zidp.isclient});"></span></#if>
					<#if zidp.yahoo><span class="YIcon" title='<@i18n key="IAM.YAHOO.SIGNIN" />' onclick="openIdSignIn('y', '${zidp.yahooname}', ${zidp.isclient});"></span></#if>
					<#if zidp.facebook><span class="FIcon" title='<@i18n key="IAM.FACEBOOK.SIGNIN" />' onclick="openIdSignIn('f', '${zidp.facebookname}', ${zidp.isclient});"></span></#if>
					<#if zidp.twitter><span class="TWIcon" title='<@i18n key="IAM.TWITTER.SIGNIN" />' onclick="openIdSignIn('t', '${zidp.twittername}', ${zidp.isclient});"></span></#if>
					<#if zidp.linkedin><span class="LNIcon" title='<@i18n key="IAM.LINKEDIN.SIGNIN" />' onclick="openIdSignIn('l', '${zidp.linkedinname}', ${zidp.isclient});"></span></#if>
					<#if zidp.azure><span class="AZIcon" title='<@i18n key="IAM.AZURE.SIGNIN" />' onclick="openIdSignIn('a', '${zidp.azurename}', ${zidp.isclient});"></span></#if>
				</div>
			</div>
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
		<span><@i18n key="IAM.FOOTER.COPYRIGHT" arg0="${signin.copyrightYear}"/></span>
		<a href='<@i18n key="IAM.LINK.SECURITY" />' target="_blank"><@i18n key="IAM.FOOTER.SECURITY" /></a>
		<a href='<@i18n key="IAM.LINK.PRIVACY" />' target="_blank"><@i18n key="IAM.PRIVACY" /></a>
		<a href='<@i18n key="IAM.LINK.TOS" />' target="_blank"><@i18n key="IAM.SIGNUP.TERMS.OFSERVICE" /></a>
		<a href='<@i18n key="IAM.LINK.ABOUT.US" />' target="_blank"><@i18n key="IAM.ABOUT.US" /></a>
	</#if>
	</#if>
	</footer>
	<script type="text/javascript">
		function onSigninReady() {
			// To avoid glitches on page load, as we lazy load CSS. 
	 		$(document.body).css("visibility", "visible");
			$(document.signinform).zaSignIn();
		};
	</script>
</body>
</html>