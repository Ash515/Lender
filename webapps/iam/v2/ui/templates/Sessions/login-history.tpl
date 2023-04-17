<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Frameset//EN" "http://www.w3.org/TR/REC-html40/frameset.dtd">
 
 
 
 				<div class="hide popup" id="popup_active-history_contents" tabindex="1">
					<div class="authweb_popup_head" id="history_popup_head"></div>
					<div class="close_btn" onclick="close_selected_history_screen()"></div>
					<span id="history_popup_info"></span>
				</div>
 
    					<div class="box big_box" id="history_box">
    						
    						<div class="box_blur"></div>
							<div class="loader"></div>
							
							<div class="box_info">
								<div class="box_head"><@i18n key="IAM.LOGINHISTORY" /><span class="icon-info"></span></div>
								<div class="box_discrption"><@i18n key="IAM.LOGINHISTORY.DESCRIPTION" /></div>
							</div>
							
							<div id="history_screen" class="box_content_div">
								
								<div class="no_data no_data_SQ"></div>
									<div class="no_data_text hide" id="history_screen"><@i18n key="IAM.LOGINHISTORY.SHOW" /> </div>
									<div class="no_data_text hide" id="history_unavaiable"><@i18n key="IAM.LOGIN_HISTORY.UNAVAILABLE" /> </div>
									<button class="primary_btn_check center_btn " onclick="show_history()"><span><@i18n key="IAM.SHOW.LOGINHISTORY.BUTTON" /></span></button>
								</div>
								
							<div id="history_space" class="hide">
								
							</div>
							
							<div class="icon-showall hide" id="history_showall" onclick="show_all_activehistory()"><span><@i18n key="IAM.VIEWMORE.INFO" /></span></div>

						</div>
						
						
						
						
				<div class="viewall_popup hide popupshowanimate_2" tabindex="1" id="history_web_more">
					<div class="box_info">
						<div class="expand_closebtn" onclick="closeview_all_activeHistoy_acc()"></div>
						<div class="box_head"><@i18n key="IAM.LOGINHISTORY" /><span class="icon-info"></span></div>
						<div class="box_discrption"><@i18n key="IAM.LOGINHISTORY.DESCRIPTION" /></div>
					</div>
					<div id="view_all_activeHistory"class="viewall_popup_content">
					</div>
				</div>
				
				
				
				
				
				<div id="empty_histroy_format" class="hide">
					
					<div class="Field_session" id="activehistory_entry" >
						
						<div class="info_tab">
							
							<div class="history_div">
								<span class="authtoken_pic product_icon"></span>
								<span class="authtoken_details">
									<span class="authtoken_name"></span>
									<span class="authtoken_time"></span>
								</span>
							</div>
							
							<div class="activesession_entry_info">
								<div class="history_device"></div>
								<div class="asession_os"></div>
								<div class="asession_browser"></div>

								<div class="asession_location location_unavail"><@i18n key="IAM.SESSIONS.LOCATION.UNAVAILABLE" /></div>

								<div class="asession_action history_delete"><@i18n key="IAM.MORE.INFORMATION" /></div>
							</div>
							
						</div>
					
					
							<div class="aw_info" id="activehistory_info">
								<div class="info_div">
									<div class="info_lable"><@i18n key="IAM.LOGINHISTORY.LOGINTIME" /></div>
									<div class="info_value" id="pop_up_time"></div>
								</div>
								<div class="info_div" id="history_logout_time">
									<div class="info_lable"><@i18n key="IAM.LOGINHISTORY.LOGOUTTIME" /></div>
									<div class="info_value" id="pop_up_logout_time"></div>
								</div>
								<div class="info_div">
									<div class="info_lable"><@i18n key="IAM.OS.NAME.HEADING" /></div>
									<div class="info_value" id="pop_up_os" ><div class="asession_os_popup "></div></div>
								</div>
								<div class="info_div">
									<div class="info_lable"><@i18n key="IAM.DEVICE" /></div>
									<div class="info_value" id="pop_up_device"><span class="asession_device_popup"></span></div>
								</div>
								<div class="info_div">
									<div class="info_lable"><@i18n key="IAM.LOGINHISTORY.BROWSERAGENT.BROWSER" /></div>
									<div class="info_value" id="pop_up_browser"><span class="asession_browser_popup"></span></div>
								</div>
								<div class="info_div">
									<div class="info_lable"><@i18n key="IAM.LOGINHISTORY.REFERRER" /></div>
									<div class="info_value" id="pop_refer"></div>
								</div>
								<div class="info_div">
									<div class="info_lable"><@i18n key="IAM.AUTHORIZED.WEBSITES.TRUSTED.LOCATION" /></div>
			
									<div class="info_value unavail" id="pop_up_location"><@i18n key="IAM.SESSIONS.LOCATION.UNAVAILABLE" /></div>
									
									<div class="info_ip"></div>
								</div>
							</div>
							
					</div>
				
				</div>