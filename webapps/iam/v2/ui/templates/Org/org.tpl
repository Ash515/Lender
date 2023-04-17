	<div id="" class="page_head"> <@i18n key="IAM.MENU.ORGANIZATION" /></div>
	
	<#if  is_org_user	&&	 is_org_admin>
	<div id="org_saml_space" onclick="clicked_tab('org', 'org_saml')">
		<#include "${location}/Org/samlsetup.tpl" > 
	</div>
	</#if>
	<div id="org_domains_space" onclick="clicked_tab('org', 'domains')">
		<#include "${location}/Org/domains.tpl">
	</div>