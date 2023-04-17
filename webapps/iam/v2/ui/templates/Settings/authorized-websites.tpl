

				<div class="hide popup" tabindex="1" id="popup_authorized-web_contents">
				
					<div class="authweb_popup_head" id="authweb_popup_head"></div>
					<div class="close_btn" onclick="close_authorized_web_screen()"></div>
					<span id="authweb_popup_info"></span>
				
				</div>

				<div class="box big_box"  id="auth_websites_box">
				
					<div class="box_blur"></div>
					<div class="loader"></div>
						
					<div class="box_info">
						<div class="box_head"><@i18n key="IAM.AUTHORIZED.WEBSITES" /><span class="icon-info"></span></div>
						<div class="box_discrption"><@i18n key="IAM.AUTHORIZED.WEBSITES.DEFINITION" /> </div>
					</div>
					
					
					<div id="all_webistes_authorized" class="list_show hide">
					</div>
					
					<div id="no_authwebistes" class="box_content_div">
						<div class="no_data no_data_SQ"></div>
						<div class="no_data_text"><@i18n key="IAM.AUTHORIZED.WEBSITES_STATUS" /> </div>
		 			</div>
		 			
		 			<div class="icon-showall hide"id="auth_websites_viewall" onclick="show_all_websites()"><span><@i18n key="IAM.VIEWMORE.INFO" /></span> </div>
		 		
		 		</div>
		 		
		 		
		 		<div class="viewall_popup hide popupshowanimate_2" tabindex="1" id="authorized_web_more">
					<div class="box_info">
						<div class="expand_closebtn" onclick="closeview_all_autho_web()"></div>
						<div class="box_head"><@i18n key="IAM.AUTHORIZED.WEBSITES" /><span class="icon-info"></span></div>
						<div class="box_discrption"><@i18n key="IAM.AUTHORIZED.WEBSITES.DEFINITION" /></div>
					</div>
					<div id="view_more_contents"class="viewall_popup_content">
					</div>
				</div>
				
				
				
				<div id="empty_AuthSites_format" class="hide">
					
					<div class="Field_session" id="authdomain_entry" > 
						<span class="popup_head" id="popup_head">
							<div class="aw_dp device_pic"></div>
							<div class="aw_disc">
								<div class="aw_name"></div>
								<div class="aw_time"></div>
							</div>
						</span>
						<span class="action_info">
							<div class="aw_remove"><@i18n key="IAM.AUTHORIZED.WEBSITES.REVOKEACCESS" /> </div>
						</span>
						<div class="aw_info" id="authdomain_info">
							<div class="info_div" id="authdomain_date">
								<div class="info_lable"><@i18n key="IAM.AUTHORIZED.WEBSITES.TRUSTED.TIME" /> </div>
								<div class="info_value"></div>
								
							</div>
							<div class="info_div hide" id="authdomain_ip">
								<div class="info_lable"><@i18n key="IAM.AUTHORIZED.WEBSITES.TRUSTED.IPADDRESS" /> </div>
								<div class="info_value"></div>
							</div>

							<div class="info_div" id="location_div">
								<div class="info_lable"><@i18n key="IAM.AUTHORIZED.WEBSITES.TRUSTED.LOCATION" /> </div>
								<div class="info_value unavail" id="pop_up_location"><@i18n key="IAM.SESSIONS.LOCATION.UNAVAILABLE" /> </div>
							</div>
							
							<button class="primary_btn_check negative_btn_red inline" tabindex="1" id="authdomain_action"><span><@i18n key="IAM.AUTHORIZED.WEBSITES.REVOKEACCESS" /></span></button>
							
							
						</div>
					
					</div>		
					
				</div>
