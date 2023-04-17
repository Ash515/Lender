<!DOCTYPE HTML > 

		<div id="group_info_div">
			<div class="group_info_div">
				
				<div class="group_info_basic">
					<div class="info_group_dp icon-camera" id="edit_grp_dp">
						<div class="bg_blur_grp"></div>
						<img onerror="setDefault_dp(this)" class="profile_picture"></img>
					</div>
					<span class="info_group_details">
						<div class="info_group_name"></div>
						<div class="info_group_discription empty_dis"></div>	

						<div id="permission_infotab" class="groupinfo_actions">
							<span class="group_action icon-edit" title="<@i18n key="IAM.EDIT" />"></span>
							<span class="group_action icon-addmember" title="<@i18n key="IAM.INVITE" />"></span>
							<span class="group_action icon-delete" title="<@i18n key="IAM.DELETE" />"></span>
						</div>
					</span>
					
				</div>
				<div id="group_action_div" class="grp_operation_container">
					
				
				</div>
				<div class="group_members_info">
					<div class="group_members_tabs">
						<span id="show_acceptedtab" class="tab acceptedtab" onclick="swicth_to_accepted();"><@i18n key="IAM.GROUP.MEMBERS" /> (<span id="grp_size"></span>)</span>
						
						<span id="show_pendingtab" class="tab pendingtab" onclick="swicth_to_pending();"><@i18n key="IAM.GROUP.PENDING" /> (<span id="pcont"></span>)</span>

						<div class="group_search searchtab" onclick="show_grp_search_bar();"><span class="group_searchicon icon-search"></span><@i18n key="IAM.SEARCH" /></div>
						
						<div class="highlight_tab"></div>
						
					</div>
					
					<div id="grp_search_space" class="grp_search_space">
						
						<div class="field full">
							<div class="textbox_label "><@i18n key="IAM.SEARCH" /></div>
							<input tabindex="0" class="textbox big_textbox" oninput="searchMembers()" id="group_search">
						</div>
						
					</div>
					<div class="search_result">
						<div id="accepted_members">
						
							<div class="noresult hide"><@i18n key="IAM.NO.RESULT.FOUND" /></div>		
							
							<div class="grup_admin_space space_separation">
								<div class="member_info_head grp-moderator"><@i18n key="IAM.ADMIN" /></div>
								<div id="member_admin_space" >
								</div>
							</div>
							
							<div class="grup_moderator_space space_separation">
								<div class="member_info_head grp-moderator"><@i18n key="IAM.GROUP.MODERATORS" /></div>
								<div id="member_moderator_space" >
								</div>
							</div>
							
							<div class="grup_member_space space_separation">
								<div class="member_info_head grp-memeber"><@i18n key="IAM.GROUP.MEMBERS" /></div>
								<div id="member_user_space" >
								</div>
							</div>
						
		
						</div>
				
				
						<div id="pending_members">
							<div class="grp-pending head_info_search  hide" id="pendning_separator"><@i18n key="IAM.GROUP.PENDING" /></div>
							<div id="pending_member_space" >
							</div>
							<div id="no_invitaions" class="hide"> <@i18n key="IAM.GROUP.ERROR.EMPTY.INVITATIONS" /> </div>
							
						</div>
					</div>
				</div>
				
			</div>
		</div>	
				
				
		<div class="hide" id="empty_member_format">
		
							<div id="member" class="member active-member">
								<span class="member_dp1" id="member_dp"></span>
								<span class="member_info">
									<div class="member_name"></div>
									<div class="member_email"><a class="grpemaillink"></a></div>	
								</span>
								<div class="showmenu_div">
									<div class="showmenu_dot"></div>
									<div class="showmenu_dot"></div>
									<div class="showmenu_dot"></div>					
								</div>
								<div class="group_options">
									<span id="accepted_member" class="">
										<div class="group_option_text" id="member_depromote" ><@i18n key="IAM.MODERATOR_TO_MEMBER" /></div>
										<div class="group_option_text" id="member_promote" ><@i18n key="IAM.CHANGE.GROUP.MODERATOR" /></div>
										<div class="group_option_text" id="member_remove"><@i18n key="IAM.DELETE" /> </div>
									</span>
									
									<span id="invited_memebr" class="">
										<div class="group_option_text" id="pending_reinvite"><@i18n key="IAM.GROUP.MEMBER.REINVITE" /></div>
										<div class="group_option_text" id="pending_remove"><@i18n key="IAM.DELETE" /></div>
									</span>
								</div>
							</div>
									
		</div>
			
					
					