<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Frameset//EN" "http://www.w3.org/TR/REC-html40/frameset.dtd">




		<div class=" hide popup" tabindex="1" id="allowed_ip_pop">
		
			<div class="device_div on_popup">
				<span class="device_pic"></span>
				<span class="device_details">
					<span class="device_name range_name"></span>
					
						<span id="edit_ip_name" title="<@i18n key='IAM.EDIT'/>"></span>
					
					<span class="device_time"></span>
					
				</span>
			</div>
			
			<div class="close_btn" onclick="closeview_selected_ip_view()"></div>

			<div id="ip_current_info">

			</div>
			
		</div>
		
		
		<div class="hide popup" tabindex="0" id="popup_ip_new">
		
			<div class="popup_header ">
				<div class="popuphead_details">
					<span class="popuphead_text"><@i18n key="IAM.ALLOWED.IPADDRESS" /> </span>
					<span class="popuphead_define"><@i18n key="IAM.ADD.ALLOWEDIP.DEFINITION" />  <br /><span class="ip_impt_note"><@i18n key="IAM.IMPT.NOTE" /></span></span>
				</div>
				<div class="close_btn" onclick="close_new_ip_popup()"></div>
			</div>
			
			<div id="ip_new_info">
						
				<form name ="addip"  id="allowedipform" onsubmit="return addipaddress(this)">
						
					<div id="get_ip">
							
						<div id="current_ip" class="radiobtn_div hide">
							<input class="real_radiobtn photo_radio" checked="checked" type="radio" name="ip_select" id="current_ip_sel" value="1">
							<div class="outer_circle">
								<div class="inner_circle"></div>
							</div>
							<label for="current_ip_sel" class="radiobtn_text"><@i18n key="IAM.IP.ADD.CURRENT" /> ( <span class="ip_blue"></span> )<label>
						</div>
						<input type="hidden" id="cur_ip" name="cur_ip" value=""/>
							
						<div class="radiobtn_div">
							<input class="real_radiobtn photo_radio" type="radio" name="ip_select" id="static_ip_sel" value="2">
							<div class="outer_circle">
								<div class="inner_circle"></div>
							</div>
							<label for="static_ip_sel" class="radiobtn_text"><@i18n key="IAM.IP.ADD.STATIC" /> </label>
						</div>	
						<div id="static_ip" class="hide ip_cell_parent">
							<div class="ip_field sip">
								<input class="ip_field_cell 1_cell" autocomplete="address-line1" type="tel" onkeypress="remove_error()" maxlength="3"><span class="ip_dot">.</span>
								<input class="ip_field_cell 2_cell" onkeypress="remove_error()"  type="tel" maxlength="3"><span class="ip_dot">.</span>
								<input class="ip_field_cell 3_cell" onkeypress="remove_error()"  type="tel" maxlength="3"><span class="ip_dot">.</span>
								<input class="ip_field_cell 4_cell" onkeypress="remove_error()"  type="tel" maxlength="3">
							</div>
						</div>
							
						<div class="radiobtn_div">
							<input class="real_radiobtn photo_radio" type="radio" name="ip_select" id="range_ip_sel" value="3">
							<div class="outer_circle">
								<div class="inner_circle"></div>
							</div>
							<label for="range_ip_sel" class="radiobtn_text"><@i18n key="IAM.IP.ADD.RANGE" /> </label>
						</div>
						<div id="range_ip" class="ip_cell_parent hide">
							<div>
								<div class="ip_field fip">
									<input class="ip_field_cell 1_cell" autocomplete="address-line1" type="tel" onkeypress="remove_error()"  maxlength="3"><span class="ip_dot">.</span>
									<input class="ip_field_cell 2_cell" onkeypress="remove_error()"  type="tel" maxlength="3"><span class="ip_dot">.</span>
									<input class="ip_field_cell 3_cell" onkeypress="remove_error()"  type="tel" maxlength="3"><span class="ip_dot">.</span>
									<input class="ip_field_cell 4_cell" onkeypress="remove_error()"  type="tel" maxlength="3">
								</div>					
								<span class="range_to_sep"><@i18n key="IAM.TO" /> </span>				
								<div class="ip_field tip">
									<input class="ip_field_cell 1_cell" autocomplete="address-line1" type="tel" onkeypress="remove_error()"  maxlength="3"><span class="ip_dot">.</span>
									<input class="ip_field_cell 2_cell" onkeypress="remove_error()"  type="tel" maxlength="3"><span class="ip_dot">.</span>
									<input class="ip_field_cell 3_cell" onkeypress="remove_error()"  type="tel" maxlength="3"><span class="ip_dot">.</span>
									<input class="ip_field_cell 4_cell" onkeypress="remove_error()"  type="tel" maxlength="3">
								</div>	
							</div>							
						</div>

						<button type="submit" class="primary_btn_check " ><span><@i18n key="IAM.NEXT" /> </span></button>

					</div>
					
					<div class="hide" id="get_name">
						
						<div class="info_div">
							<div class="info_lable"><@i18n key="IAM.IP.YOUR.ADDRESS" /> </div>
							<div class="info_value" id="ip_range_forNAME"></div>
						</div>
						
						<div class="field full">
							<div class="textbox_label "><@i18n key="IAM.IP.NAME" /> </div>
							<input class="textbox" data-optional=true data-validate="zform_field" tabindex="0" name="ip_name" id="ip_name" type="text">
						</div>
						
						<input type="text" class="ip_hide" data-validate="zform_field" name="fip" autocomplete="address-line1" id="fip"/>
						<input type="text" class="ip_hide" data-validate="zform_field" name="tip" autocomplete="address-line2" id="tip"/>
						
						<div id="creatgrp_butt2" style="display: block;">
			    			
			    			<button class="primary_btn_check" tabindex="0"  id="add_new_ip"><span><@i18n key="IAM.ADD" /> </span></button>
							<button class="primary_btn_check high_cancel" tabindex="0" id="ip_name_bak" onclick="return back_to_addip();"><span><@i18n key="IAM.BACK" /> </span></button>

				
			    		</div>
			    		
					</div>
					
				</form>
						
			</div>
				
		</div>	
		
		
		<div class="box big_box" id="AllowedIP_box">
		
			<div class="box_blur"></div>
			<div class="loader"></div>
			
			<div class="box_info">
				<div class="box_head"><@i18n key="IAM.ALLOWED.IPADDRESS" /><span class="icon-info"></span></div>
				<div class="box_discrption"><@i18n key="IAM.ALLOWED_IP.DEFINITION" /> </div>
			</div>
			
			<div id="all_ip_show">
			
				<div id="no_ip_add_here" class="box_content_div">
					<div class="no_data no_ip"></div>
					<div class="no_data_text hide"><@i18n key="IAM.ALLOWEDIP.IP_NODISPLAY" /></div>
					<button type="submit" class="primary_btn_check center_btn" onclick="add_new_ip_popup();" id="allowedip_change"><span><@i18n key="IAM.ALLOWEDIP.ADD.BUTTON" /> </span></button>
		 		</div>
		 		
		 		<div id="IP_content" class="hide">
		 		
		 			<div class="allowed_ip_entry always_hover not_included_current hide" id="allowed_ip_entry0">
					
						<div class='alone_current_ip'></div>
						
						<div class="asession_action current ip_add_btn"><@i18n key="IAM.ADD" /> </div>
							
							<div class="aw_info" id="allowed_ip_info0">
								
								<div class="info_div">
									<div class="info_lable"><@i18n key="IAM.IP.YOUR.ADDRESS" /> </div>
									<div class="info_value" id="ip_range_forNAME"></div>
								</div>
								
								<div class="field full">
										<div class="textbox_label "><@i18n key="IAM.IP.NAME" /> </div>
										<input class="textbox " name="ip_name" id="new_ip_name" type="text">
								</div>
								
								<div class="primary_btn_check" id="add_current_ip" style="display:inline-block;"><@i18n key="IAM.ADD" /> </div>							
							
							</div>
							
					</div>
					
					<div id="IPdisplay_others">
		        
					</div>
						
		 		
		 		</div>
		 		
			</div>

	 		<div id="IP_add_view_more" class="hide">
					<div class="icon-showall half" onclick="show_all_ip()"><span><@i18n key="IAM.VIEWMORE.INFO" /></span></div>   
					<div class="addnew half " onclick="add_new_ip_popup();" ><@i18n key="IAM.ALLOWEDIP.ADD.BUTTON" /></div>
			</div>
				
			<div class="addnew hide" id="ip_justaddmore" onclick="add_new_ip_popup();" ><@i18n key="IAM.ALLOWEDIP.ADD.BUTTON" /></div>	
					
		</div>
				
		<div class="hide viewall_popup popupshowanimate_2" id="allow_ip_web_more" tabindex="0" >
			<div class="menu_header">
				<div class="box_info">
					<div class="expand_closebtn" onclick="closeview_all_ip_view()"></div>
					<div class="box_head"><@i18n key="IAM.ALLOWED.IPADDRESS" /><span class="icon-info"></span> </div>
					<div class="box_discrption"><@i18n key="IAM.ALLOWED_IP.DEFINITION" /></div>
				</div>
				
			</div>
			
			<div id="view_all_allow_ip" class="all_elements_space"></div>
		</div>
		
		 
		<div id="empty_ip_format" class="hide">
		
			<div class="allowed_ip_entry" id="allowed_ip_entry">

				<div class="info_tab">	
					<div class="device_div">
						<span class="device_pic"></span>
						<span class="device_details">
							<div class="device_name">
								<span id="range_name"></span>
								<span id="ip_pencil"></span>
							</div>
							<div class="device_time"></div>
							
						</span>
					</div>
					
					<div class="activesession_entry_info">

						<div class=IP_tab_info></div>
						
						<div class="asession_location location_unavail"><@i18n key="IAM.SESSIONS.LOCATION.UNAVAILABLE" /></div>

						<div class="asession_action ip_delete"><@i18n key="IAM.DELETE" /></div>
					</div>
					
				</div>
				
				<div class="aw_info" id="allowed_ip_info">

					<div class="info_div">
						<div class="info_lable"><@i18n key="IAM.USERSESSIONS.STARTED.TIME" /> </div>
						<div class="info_value" id="pop_up_time"></div>
					</div>
					
					<div class="info_div">

							<div class="info_lable"><@i18n key="IAM.ALLOWED.IPADDRESS" /> </div>

							<div class="info_value range hide"  ></div>

							<div class="info_value static hide" ></div>

					</div>

					<div class="info_div">
						<div class="info_lable"><@i18n key="IAM.AUTHORIZED.WEBSITES.TRUSTED.LOCATION" /> </div>
							<div class="info_value unavail" id="pop_up_location"><@i18n key="IAM.SESSIONS.LOCATION.UNAVAILABLE" /> </div>
				
							<div class="info_ip"></div>
					</div>
						<a class="primary_btn_check negative_btn_red" tabindex="1" id="current_session_logout"><span><@i18n key="IAM.DELETE" /></span></a>
				</div>
				
				<div class="aw_info_rename" id="allowed_ip_info_rename">
				</div>
				
			</div>
			
		</div>
				
		