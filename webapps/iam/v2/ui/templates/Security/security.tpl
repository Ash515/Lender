	
	<script>
		var euserPassMaxLen =${euserPassMaxLen};
	</script>
	
	<div id="security_pwd_space" class="page_head">	<@i18n key="IAM.MENU.SECURITY" />	</div>
	
	<div onclick="clicked_tab('security', 'security_pwd')">
		<#include "${location}/Security/password.tpl">
	</div>
	
	<div id="security_qa_space" onclick="clicked_tab('security', 'security_qa')">
		<#include "${location}/Security/security-question.tpl">
	</div>
	
	<div id="security_ips_space" onclick="clicked_tab('security', 'security_ips')">
		<#include "${location}/Security/allowed-ip.tpl">
	</div>
	
	
	<#if Show_app_passwords && TFA_configurable>
		
		<div id="app_password_space" onclick="clicked_tab('security', 'app_password')">
			<#include "${location}/Security/app_password.tpl">
		</div>
    		
  	</#if>
  	
  	<#if Track_logins>
  	
  		<div id="device_logins_space" onclick="clicked_tab('security', 'device_logins')">
			<#include "${location}/Security/device_logins.tpl">
		</div>
  	
  	</#if>
