<!DOCTYPE html>
<html>
<head>
<title><@i18n key="IAM.ORGINVITATION.TITLE" /></title>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<#include "za_accept_invitation_static">
</head>
<body class="bodybg">
	<header>
		<#if partner.isPartnerLogoExist>
			<div><img class="partnerlogo" src="/static/file?t=org&ID=${partner.partnerId}" /></div>
		<#else>
			<div class="logo"></div>
		</#if>
		<div style="clear: both;"></div>
	</header>
	<section class="invitationoutersection">
	<#if isvalidrequest>
		<#if acceptinvitation>
		<h3><@i18n key="IAM.TEMPLATE.SIGNUP.ORG.SUBTITLE.EXISTING" arg0="${emailid}" arg1="${orgname}" /></h3>
		</#if>
	<#elseif !isAlreadyJoined>
		<h2 class="form-title"><@i18n key="IAM.ORG.INVITATION.FAILURE.TITLE" /></h2>
	</#if>
		<section class="containerbox">
			<form name="accountinvitationform" class="form" action="${za.contextpath}/accinvite.ac" method="post">
						<div id="afterclick" class="margin bg-page-after">
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
								<#else>
									<div class="bg-page-after">
										<@i18n key="IAM.ORGINVITATION.REJECT.SUBTITLE" arg0="${emailid}" arg1="${orgname}"/>
									</div>
								</#if>
							</p>
							<#if acceptinvitation>
							<div name="error" id="error"></div>
							<dl class="za-password-container">
								<dd>
								<input type="password" placeholder='<@i18n key="IAM.PASSWORD" />' name="password" id="password" class="form-input" autofocus tabindex="1" maxlength="250" onkeypress="hideMsg(this);" />
								<div>
									<p class="tos"><a href="/password" class="forpassword" tabindex="-10"><@i18n key="IAM.FORGOT.PASS" /></a></p>
								</div>
								</dd>
							</dl>
							</#if>
							<dl>
								<dd class="actionbtn">
									<#if acceptinvitation>
									<#if tos_link?? || privacy_link??>
										<#if !tos_link??>
											<#assign tos_link><@i18n key="IAM.LINK.TOS" /></#assign>
										</#if>
										<#if !privacy_link??>
										 	<#assign privacy_link><@i18n key="IAM.LINK.PRIVACY" /></#assign>
										</#if>
										<div class="field-msg" style="margin:8px 0">
											<span class="note p0"><@i18n key="IAM.SIGNUP.AGREE.TOS.PRIVACY.ORG" arg0="${tos_link}" arg1="${privacy_link}"/></span>
										</div>
									</#if>
										<input type="submit" tabindex="1" class="signupbtn" value='<@i18n key="IAM.TPL.ORGINVITATION.TOACCEPT" />'>
									<#else>
										<input tabindex="1" type="submit" class="signupbtn" value='<@i18n key="IAM.TPL.ORGINVITATION.TOREJECT" />'>
									</#if>
								</dd>
							</dl>
						</div>
						<#elseif islogoutNeeded>
						<p class="ptxt margin bg-page-after" align="center"><@i18n key="IAM.SIGNING.IN.ALREADY" arg0="${currentloggedInuser}" arg1="${logouturl}"/></p>
						<#elseif islicenseexceeds>
						<p class="ptxt margin bg-page-after" align="center"><@i18n key="IAM.ERROR.APP.MAXUSERS"/></p>
						<#elseif isalreadyorguser>
							<#if isOrgAdmin && isSingleUserOrg>
							<p class="ptxt margin bg-page-after" align="center"><@i18n key="IAM.ORG.INVITATION.CONTACT.PERSON.FAILURE.SINGLEUSER" arg0="${userexistingorg}" arg1="${currentorg}" arg2="${emailid}" /></p>
							<#elseif isOrgAdmin>
							<p class="ptxt margin bg-page-after" align="center"><@i18n key="IAM.ORG.INVITATION.CONTACT.PERSON.FAILURE" arg0="${userexistingorg}" arg1="${currentorg}" arg2="${emailid}" /></p>
							<#else>
							<p class="ptxt margin bg-page-after" align="center"><@i18n key="IAM.ORG.INVITATION.ALREADY.ORGUSER" arg0="${userexistingorg}" arg2="${currentorg}" arg1="${userexistingadminmail}"  arg2="${currentorg}" arg3="${emailid}"/></p>
							</#if>
						<#elseif isAlreadyJoined>
						<p class="ptxt margin bg-page-after" align="center"><@i18n key="IAM.ORGINVITATION.ALREADY.ACCEPTED" arg0="${loginurl}"/></p>
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
		<a href='${tos_link}' target="_blank"><@i18n key="IAM.SIGNUP.TERMS.OFSERVICE" /></a>
		<a href='${privacy_link}' target="_blank"><@i18n key="IAM.PRIVACY" /></a>
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
	</script>
</body>
</html>