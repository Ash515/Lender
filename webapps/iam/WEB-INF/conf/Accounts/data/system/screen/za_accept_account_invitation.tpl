<!DOCTYPE html>
<html>
<head>
<title><@i18n key="IAM.ORGINVITATION.TITLE" /></title>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<#include "za_accept_invitation_static">
</head>
<body class="bodybg">
<#if !tos_link??>
<#assign tos_link><@i18n key="IAM.LINK.TOS" /></#assign>
</#if>
<#if !privacy_link??>
 <#assign privacy_link><@i18n key="IAM.LINK.PRIVACY" /></#assign>
</#if>
	<header>
		<#if partner.isPartnerLogoExist>
			<div><img class="partnerlogo" src="/static/file?t=org&ID=${partner.partnerId}" /></div>
		<#else>
			<div class="logo"></div>
		</#if>
		<div style="clear: both;"></div>
	</header>
	<section class="invitationoutersection">
	<section id="invtitle">
	<#if isvalidrequest>
		<#if acceptinvitation>
			<h3><@i18n key="IAM.TEMPLATE.SIGNUP.ORG.SUBTITLE" arg0="${emailid}" arg1="${orgname}" /></h3>
		</#if>
	<#elseif !isAlreadyJoined>
		<h2 class="form-title"><@i18n key="IAM.ORG.INVITATION.FAILURE.TITLE" /></h2>
	</#if>
	</section>
		<section class="containerbox">
			<form name="accountinvitationform" class="form" action="${za.contextpath}/accinvite.ac" method="post">
						<div id="afterclick" class="margin bg-page-after" style="background :#F2F2F2;">
							<p class="ptxt">
								<#if acceptinvitation>
									<@i18n key="IAM.TEMPLATE.ORG.INVITATION.SUCESS" arg0="${orgname}"/>
								<#else>
									<@i18n key="IAM.TEMPLATE.ORG.INVITATION.REJECT.SUCESS" arg0="${orgname}"/>
								</#if>
							</p>
							<br/><a class="ptxt" id="continueto" href="" style="height: 29px;width: 166px;display: inline-block;box-shadow: 0 0 13px #DDDDDD;text-align: justify;padding: 23px;padding-top: 10px;padding-bottom: 0px;background: #D7D7D0;color:rgb(84, 80, 80);"><@i18n key="IAM.TEMPLATE.ORG.INVITATION.SUCESS.CONTINUE" arg0="${app_display_name}"/></a>
						</div>
						<#if isvalidrequest>
						<div id="beforeclick" class="margin">
							<p class="ptxt">
								<#if acceptinvitation>
								<div name="error" id="error"></div>
								<dl>
									<dd>
										<input type="text" name="firstname" tabindex="1" placeholder='<@i18n key="IAM.FIRST.NAME" />' onkeyup="hideMsg(this);" value="${firstName}">
									</dd>
								</dl>
								<dl>
									<dd>
										<input type="text" name="lastname" tabindex="1" placeholder='<@i18n key="IAM.LAST.NAME" />' onkeyup="hideMsg(this);" value="${lastName}">
									</dd>
								</dl>
									
								<#else>
								<div class="bg-page-after">
									<@i18n key="IAM.ORGINVITATION.REJECT.SUBTITLE" arg0="${emailid}" arg1="${orgname}"/>
								</div>
								</#if>
							</p>
							<#if acceptinvitation>
							<dl class="za-password-container">
								<dd style="position: relative;">
								<input type="password" placeholder='<@i18n key="IAM.PASSWORD" />' name="password" id="password" class="form-input" onkeyup="checkPasswordStrength(${userPassword.minlen});hideMsg(this)" tabindex="1">
								<div class="field-msg">
									<div onclick="togglePasswordField(${userPassword.minlen});" id="show-password" class="show-password">
		                                <span id="show-password-icon" class="icon-medium uncheckedpass"></span>
		                                <label id="show-password-label">Show</label>
		                            </div>
									<p class="message"><span id="errormg" class="pwderror"><@i18n key="IAM.TPL.PASSWORD.ALERT" arg0="${userPassword.minlen}"/></span></p>
								</div>
								<div class="pwdparent"><div id="pwdstrength"></div><div class="pwdtext"></div></div>
								</dd>
							</dl>
							
							<dl class="za-captcha-container" style="display: none;">
								<dd>
									<input type="text" placeholder='<@i18n key="IAM.FIELD.CAPTCHA.VERIFICATION" />' name="captcha" maxlength="10" class="form-input captchaCnt" tabindex="1" disabled /> 
									<div class="form-input" style="text-align:left"><img src="${za.contextpath}/images/spacer.gif" class="za-captcha"><span class="za-refresh-captcha" onclick="reloadCaptcha(document.accountinvitationform)"></span></div>
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
							</#if>
							<dl>
								<dd class="actionbtn">
									<#if acceptinvitation>
										<div class="field-msg" style="margin:8px 0">
											<span class="note p0"><@i18n key="IAM.SIGNUP.AGREE.TOS.PRIVACY.ORG" arg0="${tos_link}" arg1="${privacy_link}"/></span>
										</div>
										<input type="submit" tabindex="1" class="signupbtn" value='<@i18n key="IAM.TPL.ORGINVITATION.TOACCEPT" />'>
									<#else>
										<input tabindex="1" type="submit" class="signupbtn" value='<@i18n key="IAM.TPL.ORGINVITATION.TOREJECT" />'>
									</#if>
								</dd>
							</dl>
						</div>
						<#elseif isAlreadyJoined>
						<p class="ptxt margin bg-page-after" align="center"><@i18n key="IAM.ORGINVITATION.ALREADY.ACCEPTED" arg0="${loginurl}"/></p>
						<#elseif islogoutNeeded>
						<p class="ptxt margin bg-page-after" align="center" style="line-height : 2"><@i18n key="IAM.SIGNING.IN.ALREADY" arg0="${currentloggedInuser}" arg1="${logouturl}"/></p>
						<#elseif islicenseexceeds>
						<p class="ptxt margin bg-page-after " align="center"><@i18n key="IAM.ERROR.APP.MAXUSERS"/></p>
						<#elseif inActiveInvitation>
						<p class="ptxt margin bg-page-after" align="center"><@i18n key="IAM.ORGINVITATION.INACTIVE.ADMIN" /></p>
						<#else>
						<p class="ptxt margin bg-page-after" align="center"><@i18n key="IAM.INVALID.REQUEST" /></p>
						</#if>
					</div>
				</div>
			</form>
		</section>
	</section>
	<footer>
	<#if !partner.isPartnerHideHeader>
	<#if partner.isfujixerox>
		<a href='<@i18n key="IAM.LINK.TOS" />' target="_blank"><@i18n key="IAM.SIGNUP.TERMS.OFSERVICE" /></a>
		<a href='<@i18n key="IAM.LINK.PRIVACY" />' target="_blank"><@i18n key="IAM.PRIVACY" /></a>
		<a href='<@i18n key="IAM.CONTACT.LINK" />' target="_blank"><@i18n key="IAM.CONTACT.US" /></a>
	<#else>
		<span><@i18n key="IAM.FOOTER.COPYRIGHT" arg0="2012"/></span>
	</#if>
	</#if>
	</footer>
	<script type="text/javascript">
		$(document).ready(function() {
			$(document.body).css("visibility", "visible");
			$(document.accountinvitationform).zaAccountInvitation();
		});
		var passminlen = ${userPassword.minlen};
	</script>
</body>
</html>