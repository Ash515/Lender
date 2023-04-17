<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Frameset//EN" "http://www.w3.org/TR/REC-html40/frameset.dtd">








		<div class=" hide popup" tabindex="1" id="app_pass_pop">
		
			<div class="device_div on_popup">
				<span class="device_pic"></span>
				<span class="device_details">
					<span class="device_name range_name"></span>					
					<span class="device_time"></span>
					
				</span>
			</div>
			
			<div class="close_btn" onclick="closeview_selected_app_pass_view()"></div>

			<div id="app_current_info">

			</div>
			
		</div>



		<div class="hide popup" tabindex="0" id="popup_apppass_new">
		
			<div class="popup_header ">
				<div class="popuphead_details">
					<span class="popuphead_text"><@i18n key="IAM.TFA.APP.SPEC.PASSWORDS" /> </span>
					<span id="apppassworddef_id" class="popuphead_define"><@i18n key="IAM.TFA.ADD.APPSPEC.SUBTITLE" /> </span>
				</div>
				<div class="close_btn" onclick="close_new_app_pass_popup()"></div>
			</div>
			
			<form class="" id="generate_new_pass" onsubmit="return generateAppPassword()">
				
				<div class="tfa_blur"></div>
				<div class="loader"></div>
				
				<div class="field full" id="gene_app_space">
					<div class="textbox_label"><@i18n key="IAM.TFA.DEVICE.APP.NAME" /> </div>
					<input class="textbox" data-optional="true" onkeypress="remove_error()" name="" tabindex='1' id="applabel" type="text">
				</div>
				
				<div>					  
	  	  			<button class="primary_btn_check " tabindex='1' ><span><@i18n key="IAM.TFA.GENERATE" /> </span></button>
    			</div>
				
			</form>
			
			<div class="hide" id="generated_passsword">
					<div class="app_pasword_info popuphead_define">
						<div class="app_info"></div>
					</div>
					<div class="info_div">
						<div class="info_lable"><@i18n key="IAM.TFA.APP.NAME" /> </div>
						<div id="app_name" class="info_value"></div>
					</div>
					<div class="info_div">
						<div class="info_lable"><@i18n key="IAM.TFA.APPLICATION.PASSWORD" /> </div>
						<div class="qr_key_box app_password_grid" onclick="clipboard_copy()" title="">
							<div class="app_password" id="password_key" ></div>
						</div>
						<div class="popuphead_define"><@i18n key="IAM.TFA.APP.PASS.WARN" /> </div>
					</div>
	  	  			<button class="primary_btn_check " tabindex="0" onclick="close_new_app_pass_popup();" ><@i18n key="IAM.CLOSE" /></button>			
			</div>

		</div>			
					
					

		<div class="box big_box" id="App_Password_box">
		
			<div class="box_blur"></div>
			<div class="loader"></div>
	
			 <div class="box_info">
				<div class="box_head"><@i18n key="IAM.TFA.APP.SPEC.PASSWORDS" /><span class="icon-info"></span></div>
				<div class="box_discrption"><@i18n key="IAM.TFA.APPSPEC.DESCRIPTION" /> </div>
			</div>
			
			 
			<div id="show_app_password">
			
				<div id="no_app_passwords" class="box_content_div hide">
					<div class="no_data  no_data_SQ"></div>
					<div class="no_data_text hide" id="nodata_withTFA"><@i18n key="IAM.GENERATED.PASSWORD.EMPTY" /></div>
					<div class="no_data_text hide" id="nodata_withoutTFA"><@i18n key="IAM.GENERATED.PASSWORD.EMPTY.NOT.ALLOWED" /></div>
					<button class="primary_btn_check center_btn hide" id="generate_app_pass" onclick="show_generate_popup();"><span><@i18n key="IAM.GENERATE.PASSWORD" /> </span></button>
				</div>
				
				<div id="display_app_passwords" class="hide">
				
				</div>
				
			</div>
				
			<div id="app_pass_add_view_more" class="hide">
				<div class="icon-showall half" onclick="show_all_app_passwords()"><span><@i18n key="IAM.VIEWMORE.INFO" /></span></div>   
				<div class="addnew half " onclick="show_generate_popup();" ><@i18n key="IAM.GENERATE.PASSWORD" /></div>
			</div>
			
			<div class="addnew hide" id="app_pass_justaddmore" onclick="show_generate_popup();" ><@i18n key="IAM.GENERATE.PASSWORD" /></div>	
		
		</div>
		
		
		
		
		<div class="hide viewall_popup popupshowanimate_2" tabindex="0" id="app_password_web_more" >
		
			<div class="menu_header">
				<div class="box_info">
					<div class="expand_closebtn" onclick="closeview_all_app_view()"></div>
					<div class="box_head"><@i18n key="IAM.TFA.APP.SPEC.PASSWORDS" /> <span class="icon-info"></span></div>
					<div class="box_discrption"><@i18n key="IAM.TFA.APPSPEC.DESCRIPTION" /> </div>
				</div>
			</div>
			
			<div id="view_all_app_pass" class="all_elements_space"></div>
		</div>
		
		
		
		
		
		
		
		
		
		
		
		
		
		<div id="empty_app_pass_format" class="hide">
			
			<div class="allowed_ip_entry" id="app_password_entry">

				<div class="info_tab">	
					<div class="device_div">
						<span class="device_pic"></span>
						<span class="device_details">
							<span class="device_name field_value"></span>
							<span class="device_time"></span>
						</span>
					</div>
					
					<div class="activesession_entry_info">
						
						<div class="asession_location location_unavail"><@i18n key="IAM.SESSIONS.LOCATION.UNAVAILABLE" /></div>

						<div class="asession_action ip_delete"><@i18n key="IAM.DELETE" /></div>
					</div>
					
				</div>
				
				<div class="aw_info" id="app_password_info">

					<div class="info_div">
						<div class="info_lable"><@i18n key="IAM.GENERATE.ON" /> </div>
						<div class="info_value" id="pop_up_time"></div>
					</div>
					
					<div class="info_div">
						<div class="info_lable"><@i18n key="IAM.TFA.GENERATED.IP" /> </div>
						<div class="info_value" id="pop_up_ip"></div>
					</div>

					<div class="info_div">
						<div class="info_lable"><@i18n key="IAM.AUTHORIZED.WEBSITES.TRUSTED.LOCATION" /> </div>
						<div class="info_value unavail" id="pop_up_location"><@i18n key="IAM.SESSIONS.LOCATION.UNAVAILABLE" /> </div>
					</div>
					
					<button class="primary_btn_check negative_btn_red" tabindex="0" id="delete_generated_password"><span><@i18n key="IAM.DELETE" /></span></button>
					
				</div>
				
			</div>
			
		</div>
		