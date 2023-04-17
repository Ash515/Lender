<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Frameset//EN" "http://www.w3.org/TR/REC-html40/frameset.dtd">




	<div class=" hide popup" tabindex="1" id="Device_logins_pop">
		
		<div class="on_popup">
			<span class="" id="platform_img"></span>
			<span class="device_platform_details">
				<span class="device_name range_name"></span>					
			</span>
		</div>
		
		<div class="close_btn" onclick="closeview_selected_Device_logins_view()"></div>

		<div id="Device_logins_current_info">
		</div>
			
	</div>



	<div class="box big_box" id="Device_logins_box">
	
		<div class="box_blur"></div>
		<div class="loader"></div>
		
		<div class="box_info">
			<div class="box_head"><@i18n key="IAM.DEVICE.LOGINS.TITLE" /><span class="icon-info"></span></div>
			<div class="box_discrption"><@i18n key="IAM.DEVICE.LOGINS.DEFINITION" /> </div>
		</div>
		
		<div id="show_Device_logins">
			
			<div id="no_Devices" class="box_content_div">
				<div class="no_data "></div>
				<div class="no_data_text" id="nodata_withTFA"><@i18n key="IAM.DEVICELOGINS.UNAVAILABLE" /></div>
			</div>
			
			<div id="display_all_Devices" class="hide">
			
			</div>
				
		</div>
		
		<div class="icon-showall hide" id="Device_logins_viewmore" onclick="show_all_device_logins()"><span><@i18n key="IAM.VIEWMORE.INFO" /></span></div>
		
	</div>
	
	
		<div class="hide viewall_popup popupshowanimate_2" tabindex="0" id="Device_logins_web_more" >
		
			<div class="menu_header">
				<div class="box_info">
					<div class="expand_closebtn" onclick="closeview_Device_logins_view()"></div>
					<div class="box_head"><@i18n key="IAM.DEVICE.LOGINS.TITLE" /></span> </div>
					<div class="box_discrption"><@i18n key="IAM.DEVICE.LOGINS.DEFINITION" /> </div>
				</div>
			</div>
			
			<div id="view_all_Device_logins" class="all_elements_space"></div>
		</div>
		
		
		<div id="empty_Device_logins_format" class="hide">
			
			<div class="devicelogins_entry" id="Device_logins_entry">

				<div class="info_tab">	
					<div class="devicelogin_div">
						<span class="mail_client_logo"></span>
						<span class="device_platform_details">
							<span class="device_name field_value"></span>
						</span>
					</div>
					
					<span class="activesession_entry_info">
						<span class="asession_location location_unavail"></span>
					</span>
					
				</div>
				
				<div class="aw_info" id="Device_logins_info">

					
				</div>
				
			</div>
				
		</div>
		
		
		
		<div id="empty_Devices_format" class="hide">
		
			<div class="" id="Devices_entry">
			
					<div class="devicelogins_devicedetails">	
						<div class="devicelogin_div">
							<span class="asession_browser"></span>
							<span class="devicelogin_details">
								<span class="device_name field_value"></span>
								<span class="device_login_tim"></span>
							</span>
						</div>
						
						<div class="devicelogins_entry_info">
						
							<div class="asession_os"></div>
																
							<div class="asession_ip hide"></div>

							<div class="asession_location location_unavail"><@i18n key="IAM.SESSIONS.LOCATION.UNAVAILABLE" /></div>

							<span class="deleteicon action_icon icon-delete" title="<@i18n key="IAM.REMOVE" />"></span>
							
						</div>
						
						
					</div>
							
			</div>
		
		</div>