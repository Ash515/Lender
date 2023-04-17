<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Frameset//EN" "http://www.w3.org/TR/REC-html40/frameset.dtd">


	<div class=" hide popup" id="activesessions_pop" tabindex="1">
	
		<div class="device_div on_popup">
			
			<span id="device_pic" ></span>
			<span class="device_details">
				<span class="device_name"></span>
				<span class="device_time"></span>
			</span>
			
		</div>
		
		<div class="close_btn" onclick="closeview_selected_sessions_view()"></div>

		<br><br><br>

		<div id="sessions_current_info" class="list_show">
		</div>
		
	</div>
	
	
	
	<div class="box big_box" id="sessions_box">
	
		<div class="box_blur"></div>
		<div class="loader"></div>
		
		<div class="box_info">
			<div class="box_head"><@i18n key="IAM.ACTIVESESSIONS" /><span class="icon-info"></span></div>
			<div class="box_discrption"><@i18n key="IAM.ACTIVESESSIONS.DESCRIPTION" /> </div>
		</div>
	
	
		<div id="all_sessions_active">
			<div id="current_sesion"> 
			</div>
			<div id="other_sesion"> 
			</div>
		
		</div>

		<div class="icon-showall hide" id="sessions_showall" onclick="show_all_sessions()"><span><@i18n key="IAM.VIEWMORE.INFO" /></span></div>
		
	</div>
		
		
		
		
		<div class="viewall_popup hide popupshowanimate_2" tabindex="1" id="sessions_web_more">
			
			<div class="box_info">
				<div class="expand_closebtn" onclick="closeview_all_sessions_view()"></div>
				<div class="box_head"><@i18n key="IAM.ACTIVESESSIONS" /><span class="icon-info"></span></div>
				<div class="box_discrption"><@i18n key="IAM.ACTIVESESSIONS.DESCRIPTION" /></div>
			</div>
			
			<div id="view_all_sessions"class="viewall_popup_content selected_delete_popup">
			</div>
			
			<div class="delete_all_space">
				<button class="primary_btn_check right_btn red_btn" onclick="deleteAllSessions()"><@i18n key="IAM.DELETE.ALL.SESSIONS" /></button>	
				<button class="primary_btn_check right_btn hide deleted_selected" id="deleted_selected_sessions" onclick="deleteSelectedSessions();" ><@i18n key="IAM.DELETE.SELECTED" /></button>	
			</div>

		</div>
		
		
		<div id="empty_sessions_format" class="hide">
		
					<div class="Field_session" id="activesession_entry" >
							
						<div class="info_tab">	
								<div class="select_holder hide" id="select_session_">
									<input data-validate="zform_field" id="session_check" onclick="display_removeselected_session();" name="signoutfromweb" class="checkbox_check" type="checkbox">
									<span class="checkbox">
											<span class="checkbox_tick"></span>
									</span>
								</div>
								<div class="device_div">
									<span class="device_pic"></span>
									<span class="device_details">
										<span class="device_name"></span>
										<span class="device_time"></span>
										
									</span>
								</div>
								<div class="activesession_entry_info">
									<div class="asession_os"></div>
									
									<div class="asession_browser"></div>
									
									<div class="asession_ip hide"></div>
	
									<div class="asession_location location_unavail"><@i18n key="IAM.SESSIONS.LOCATION.UNAVAILABLE" /></div>

									<div class="asession_action current"><@i18n key="IAM.USERSESSIONS.CURRENT.SESSION" /></div>
									<div class="asession_action session_logout"><@i18n key="IAM.TERMINATE" /></div>
								</div>
							</div>
						
							<div class="aw_info" id="activesession_info">
	
								<div class="info_div">
									<div class="info_lable"><@i18n key="IAM.USERSESSIONS.STARTED.TIME" /></div>
									<div class="info_value" id="pop_up_time"></div>
								</div>
								<div class="info_div">
									<div class="info_lable"><@i18n key="IAM.OS.NAME.HEADING" /></div>
									<div class="info_value" id="pop_up_os" ><div class="asession_os_popup"></div></div>
								</div>
								<div class="info_div">
									<div class="info_lable"><@i18n key="IAM.LOGINHISTORY.BROWSERAGENT.BROWSER" /></div>
									<div class="info_value" id="pop_up_browser"><span class="asession_browser_popup "></span></div>
								</div>
								<div class="info_div">
									<div class="info_lable"><@i18n key="IAM.AUTHORIZED.WEBSITES.TRUSTED.LOCATION" /></div>
									
									<div class="info_value location_unavail" id="pop_up_location"><@i18n key="IAM.SESSIONS.LOCATION.UNAVAILABLE" /></div>
									 
									<div class="info_ip"></div>
								</div>
									<button class="primary_btn_check negative_btn_red inline" tabindex="1" id="current_session_logout"><span><@i18n key="IAM.TERMINATE" /></span></button>									
							</div>
						
						
					</div>
		
		
		</div>
		
		
		