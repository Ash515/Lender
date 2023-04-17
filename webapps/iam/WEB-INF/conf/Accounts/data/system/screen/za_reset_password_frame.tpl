<head>
<title><@i18n key="IAM.RESET.PASSWORD.TITLE" /></title>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<#include "za_reset_password_static">
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
<section class="resetoutersection">
	<#if zpass.isvalidrequest>
		<section class="containerbox">
		<div id="title">
						<div class="head"><@i18n key="IAM.RESET.PASSWORD.TITLE" /></div> 
						<div class="hrTop"></div>
		</div>
		<div class="margin">
			<form action="${za.contextpath}/reset.ac" name="resetPassword" method="post" class="form">
				<dl>
					<dt><@i18n key="IAM.NEW.PASS" /></dt>
					<dd>
						<input type="password" name="password" autofocus maxlength="60">
					</dd>
				</dl>
				<dl>
					<dt><@i18n key="IAM.REENTER.PASSWORD" /></dt>
					<dd>
						<input type="password" name="cpassword" maxlength="60">
					</dd>
				</dl>
				<dl>
					<dd>
						<input type="submit" class="btn big-btn primary" value='<@i18n key="IAM.RESET.PASSWORD.TITLE" />'>
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
		</section>
	<#else>
		<p class="ptxt"><@i18n key="IAM.INVALID.REQUEST" /></p>
	</#if>
</section>
<div id="msgboard" class="successmsg">
	<span><@i18n key="IAM.FORGOT.UPDATE.PASS" /></span><br>
</div>
</body>
<script type="text/javascript">
	$(document).ready(function() {
	$(document.resetPassword).zaResetPassword();
});
</script>