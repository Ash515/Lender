<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Frameset//EN" "http://www.w3.org/TR/REC-html40/frameset.dtd">


<#include "${location}/Groups/AllGroups.tpl">


<#if can_create_groups>
	<div class="hide" id="create_groups_template">
		<#include "${location}/Groups/creategroup.tpl">
	</div>
</#if>

<div class="grp_info_side" tabindex="1" id="grp_info_side">
			
	<div class="close_btn grp_slide_cross" onclick="close_group_info_display_space();"></div>
	<div id="group_info_display_space">	
		<#include "${location}/Groups/groupinfo.tpl">
	</div>
			
</div>


	<div class="hide" id="edit_groups">
		<#include "${location}/Groups/editGroup.tpl">
	</div>
	
	<div class="hide" id="invite_mem_groups">
		<#include "${location}/Groups/invitemem.tpl">
	</div>
	
	<input type="hidden" id="group_member_limit" value="${group_limit}"/>
