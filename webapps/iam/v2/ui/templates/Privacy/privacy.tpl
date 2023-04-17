
		<div id="privacy_space" class="page_head">	<@i18n key="IAM.MENU.PRIVACY" />	</div>
		
		<div id="dpa_space" onclick="clicked_tab('privacy','dpa')">
			<#include "${location}/Privacy/gdpr-dpa.tpl">
		</div>
		
		<div id="myc_space" onclick="clicked_tab('privacy','myc')">
			<#include "${location}/Privacy/kyc.tpl">
		</div>