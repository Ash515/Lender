



		<script>
				var canSetupyubikey = Boolean("<#if canSetupyubikey>true</#if>");
				var canSetupGAuth = Boolean("<#if canSetupGAuth>true</#if>");
				var canSetupSMS = Boolean("<#if canSetupSMS>true</#if>");
				var canSetupExo = Boolean("<#if canSetupExo>true</#if>");
				var canSetup_mfa_device = Boolean("<#if canSetup_mfa_device>true</#if>");
		</script>
		
		
		<div id="MFA_space" class="page_head">	<@i18n key="IAM.MFA" />	</div>

		<div class="tfa_settings_sapce" onclick="clicked_tab('multiTFA', 'modes')">
			<#include "${location}/MultiMFA/MFA-modes.tpl">
		</div>
		
		<div class="tfa_settings_sapce" onclick="clicked_tab('multiTFA', 'recovery')">
			<#include "${location}/MultiMFA/MFA-recovery.tpl">
		</div>
		
		<div class="tfa_settings_sapce" onclick="clicked_tab('multiTFA', 'trusted_browser')">
			<#include "${location}/MultiMFA/MFA-trustedbrowser.tpl">
		</div>
		
		<div id="tfa_setup_sapce" class="">
			<#include "${location}/MultiMFA/MFA-setup.tpl">
		</div>
		
		<input type="hidden" id="tfa_method" value="">
		 
		