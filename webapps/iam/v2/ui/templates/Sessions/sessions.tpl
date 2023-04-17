	<div id="useractivesessions_space" class="page_head">	<@i18n key="IAM.MENU.SESSIONS" />	</div>
	
	<div onclick="clicked_tab('sessions', 'useractivesessions')">
		<#include "${location}/Sessions/user-sessions.tpl">
	</div>
	
	<div id="userauthtoken_space" onclick="clicked_tab('sessions', 'userauthtoken')" >
		<#include "${location}/Sessions/api-tokens.tpl">
	</div>
	
	<div id="useractivityhistory_space" onclick="clicked_tab('sessions', 'useractivityhistory')">
		<#include "${location}/Sessions/login-history.tpl">
	</div>
	
	<div id="userconnectedapps_space" onclick="clicked_tab('sessions', 'userconnectedapps')">
		<#include "${location}/Sessions/connected-apps.tpl"> 
	</div>
	
	<div id="userapplogins_space" onclick="clicked_tab('sessions', 'userapplogins')">
		<#include "${location}/Sessions/app-logins.tpl"> 
	</div>