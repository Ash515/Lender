	<div id="personal_space"  class="page_head">	<@i18n key="IAM.PROFILE" />	</div>
	
	<div onclick="clicked_tab('profile', 'personal')">
		<#include "${location}/Profile/personal_details.tpl">
	</div>

        
    
    <div id="useremails_space" onclick="clicked_tab('profile', 'useremails')">
    	<#include "${location}/Profile/email.tpl">
	</div>

		
	<div id="phonenumbers_space" onclick="clicked_tab('profile', 'phonenumbers')">
		<#include "${location}/Profile/phonenumbers.tpl">
	</div>
    		
  	

   
	