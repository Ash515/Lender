<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Frameset//EN" "http://www.w3.org/TR/REC-html40/frameset.dtd">





		<div class=" hide popup" tabindex="1" id="App_logins_pop">
		
			<div class="on_popup">
				<span class="" id="product_img"></span>
				<span class="devicelogin_details">
					<span class="device_name range_name"></span>					
					<span class="device_time"></span>
				</span>
			</div>
			
			<div class="close_btn" onclick="closeview_selected_App_logins_view()"></div>

			<div id="App_logins_current_info">
			</div>
			
		</div>





		<div class="box big_box" id="App_logins_box">
		
			<div class="box_blur"></div>
			<div class="loader"></div>
	
			 <div class="box_info">
				<div class="box_head"><@i18n key="IAM.APP.LOGINS" /><span class="icon-info"></span></div>
				<div class="box_discrption"><@i18n key="IAM.CONNECTED.MOBILEAPPS_DEFINITION" /> </div>
			</div>
			
			 
			<div id="show_App_logins">
			
				<div id="no_App_logins" class="box_content_div hide">
					<div class="no_data no_data_SQ"></div>
					<div class="no_data_text" id="nodata_withTFA"><@i18n key="IAM.CONNECTEDMOBILEAPPS.NOT_PRESENT" /></div>
				</div>
				
				<div id="display_App_logins" class="hide">
				
				</div>
				
			</div>
			
			<div class="icon-showall hide" id="App_logins_viewmoew" onclick="show_all_App_logins();" ><span><@i18n key="IAM.VIEWMORE.INFO" /></span></div>	
		
		</div>
		
		
		
		<div class="hide viewall_popup popupshowanimate_2" tabindex="0" id="App_logins_web_more" >
		
			<div class="menu_header">
				<div class="box_info">
					<div class="expand_closebtn" onclick="closeview_App_logins_view()"></div>
					<div class="box_head"><@i18n key="IAM.APP.LOGINS" /><span class="icon-info"></span> </div>
					<div class="box_discrption"><@i18n key="IAM.CONNECTED.MOBILEAPPS_DEFINITION" /> </div>
				</div>
			</div>
			
			<div id="view_all_App_logins" class="all_elements_space"></div>
		</div>
		
		
		
		
		
		
		
		<div id="empty_App_logins_format" class="hide">
			
			<div class="devicelogins_entry" id="App_logins_entry">

				<div class="info_tab">	
					<div class="devicelogin_div">
						<span class="device_pic product_icon"></span>
						<span class="devicelogin_details">
							<span class="device_name field_value"></span>
							<span class="device_time"></span>
						</span>
					</div>
					
					<span class="activesession_entry_info">
						<span class="asession_location location_unavail"><@i18n key="IAM.SESSIONS.LOCATION.UNAVAILABLE" /></span>
					</span>
					
				</div>
				
				<div class="aw_info" id="App_logins_info">

					
				</div>
				
			</div>
				
		</div>
		
		
		<div id="empty_Devices_format" class="hide">
		
				<div class="" id="Devices_entry">
				
						<div class="devicelogins_devicedetails">	
							<div class="devicelogin_div">
								<span class="device_pic"></span>
								<span class="devicelogin_details">
									<span class="device_name field_value"></span>
									<span class="device_model"></span>
									<span class="device_time"></span>
								</span>
							</div>
							<span class="asession_location location_unavail"><@i18n key="IAM.SESSIONS.LOCATION.UNAVAILABLE" /></span>
							<span class="deleteicon action_icon icon-delete" title="<@i18n key="IAM.REMOVE" />"></span>
							<span id="current_mfadevice" class="asession_action current"><@i18n key="IAM.MFA.PRIMARY.MODE" /></span>
							</div>
								
	                </div>
		
		</div>
		
		
		