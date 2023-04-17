		
		
		
	<div id="preference_space" class="page_head"><@i18n key="IAM.SETTINGS" /></div>
							
		<div onclick="clicked_tab('setting', 'preference')">
			<#include "${location}/Settings/user-preference.tpl">
		</div>
		
		<div id="authorizedsites_space" onclick="clicked_tab('setting', 'authorizedsites')">
			<#include "${location}/Settings/authorized-websites.tpl">
		</div>
  		
  		<#if (!hideLinkedAccounts)>
			<div id="linkedaccounts_space" onclick="clicked_tab('setting', 'linkedaccounts')">
				<#include "${location}/Settings/linked-accounts.tpl">		
			</div>
		</#if>
  		
  		<div id="closeaccount_space" onclick="clicked_tab('setting', 'closeaccount')">
			<#include "${location}/Settings/closeaccount.tpl" > 
		</div>