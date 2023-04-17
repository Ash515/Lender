<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Frameset//EN" "http://www.w3.org/TR/REC-html40/frameset.dtd">



		<div class="popup" tabindex="1" id="grp_popup">
		</div>
		
		<div class="hide" id="groupexist">
		
			<div class="menu_desc">
				<div class="page_head"><@i18n key="IAM.GROUPS" /></div>
			</div>
			
			<#if can_create_groups>
				<div class="grp_content" id="create_grp_box">	
						
					<div class="group_div">
						
						<div class="new_group_dp icon-cadd" onclick="group_operation('creategroup')">
							<div class="add_new_grpDP icon-mgroups">
							</div>
						</div>
						<div class="group_name new_group_name"><@i18n key="IAM.CREATE.GROUP" /></div>
						
						<div class="group_actions">
							<button class="primary_btn_check add_new_grp irclebtn_mobile_edit " onclick="group_operation('creategroup')" ><span><@i18n key="IAM.CREATE" /></span></button>
						</div>
						
					</div>
					
				</div>
			</#if>
			
			<div class="grp_content" id="all_groups">	
			</div>
			
			
			
			
		</div>
		
		
				
		
		
		
		<div id="empty_groups">
			
			<div class="no_data_GRP"></div>
			<#if can_create_groups>
				<div class="no_data_text"><@i18n key="IAM.EMPTY.GROUP.DESCRIPTION" /></div>
				<button class="primary_btn_check center_btn" id="create_new_grp" onclick="group_operation('creategroup')" ><span><@i18n key="IAM.CREATE.GROUP" /></span></button>
			<#else>
				<div class="no_data_text"><@i18n key="IAM.ORGPOLICY.CREATEGROUP.NOT.SUPPORTED" /></div>
			</#if>
		</div>
		<div class="hide">
			<form name="Grp_photo" method="post" id="grp_photo_cropform" enctype="multipart/form-data" target="dummy" onSubmit="return false;">
				<input type="file" accept="image/x-png,image/gif,image/jpeg" name="picture" onchange="change_grp_pic(this)" id="picsrc_grp">
			</form>
		</div>
		<div class="hide" id="empty_group_format">	
			
			<div class="group_div" id="grpid" >
				<div class="as_admin icon-makeprimary"></div>
				<div class="showmenu_div">
					<div class="showmenu_dot"></div>
					<div class="showmenu_dot"></div>
					<div class="showmenu_dot"></div>					
				</div>
				<div class="group_options">
						<div id="group_info" class="group_info_option group_option_text"><@i18n key="IAM.INFO" /> </div>
						
						<span id="moderator_power" class="hide">
							<div id="edit_group" class="group_option_text"><@i18n key="IAM.EDIT" /> </div>
							<div id="invite_to_group" class="group_option_text"><@i18n key="IAM.INVITE" /> </div>
							<div id="delete_group" class="group_option_text"><@i18n key="IAM.DELETE" /> </div>
						</span>
						
						<div id="unsuscribe_group" class="group_option_text"><@i18n key="IAM.GROUP.UNSUBCRIBE" /> </div>
				</div>
				
				<div class="group_dp">
					<div class="bg_blur_grp" ></div>
					<img onerror="setDefault_dp(this)" class="profile_picture" src="">
				</div>
				<div class="group_details">
					<div class="group_name"></div>
					<div class="group_members">
						<span></span>
						<@i18n key="IAM.GROUP.MEMBERS" />
					</div>
				</div>
				<div class="group_actions">
				
					<div class="group_members_overview1 dp1 only1 hide"></div>
				
					<div class="only2 hide">
						<div class="group_members_overview1 dp1"></div>
						<div class="group_members_overview2 dp2"></div>
					</div>
							
					<div class="only3 hide">
						<div class="group_members_overview1 dp1"></div>
						<div class="group_members_overview2 dp2"></div>
						<div class="group_members_overview3 dp3"></div>		
						<div class="group_members_overview3 dp3_plus" ><span class="dp_number"></span></div>
					</div>	
					
				</div>
			</div>
		
		</div>		
				