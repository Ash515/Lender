<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Frameset//EN" "http://www.w3.org/TR/REC-html40/frameset.dtd">


				<div class="hide popup" tabindex="1" id="popup_active-authtokens_contents">
					<div class="authweb_popup_head" id="apitoken_popup_head"></div>
					<div class="close_btn" onclick="close_apitoken_screen()"></div>
					<span id="apitoken_popup_info"></span>
				</div>
    
    
    
    
    


					<div class="box big_box" id="auth_tokens_box">
					
						<div class="box_blur"></div>
						<div class="loader"></div>
						
						<div class="box_info">
							<div class="box_head"><@i18n key="IAM.ACTIVETOKENS" /><span class="icon-info"></span></div>
							<div class="box_discrption"><@i18n key="IAM.ACTIVETOKENS.DESCRPITION" /></div>
							
						</div>
						
						<div class="box_content_div" id="authokens_nodata" >
							<div class="no_data no_data_SQ"></div>
							<div class="no_data_text"><@i18n key="IAM.ACTIVETOKENS.NOT_PRESENT" /> </div>	
						</div>
						
						<div id="all_set_api_tokens" class="list_show hide">
						</div>
						
						<div class="icon-showall hide" id="api_token_viewall" onclick="show_all_apitokens()"><span><@i18n key="IAM.VIEWMORE.INFO" /></span></div>
					
					</div>
					
					
					         			
         		<div class="viewall_popup hide popupshowanimate_2" tabindex="1" id="api_tokens_more">
					<div class="box_info">
						<div class="expand_closebtn" onclick="closeview_all_apitokens_acc()"></div>
						<div class="box_head"><@i18n key="IAM.ACTIVETOKENS" /><span class="icon-info"></span></div>
						<div class="box_discrption"><@i18n key="IAM.ACTIVETOKENS.DESCRPITION" /></div>
					</div>
					<div id="view_api_tokens_remove"class="viewall_popup_content selected_delete_popup">
					</div>
					
					<div class="delete_all_space">
						<button class="primary_btn_check right_btn red_btn" onclick="deleteAlltokens()"><@i18n key="IAM.DELETE.ALL.TOKENS" /></button>
						<button class="primary_btn_check right_btn hide deleted_selected" id="deleted_selected_apitokens" onclick="deleteSelectedAuthtokens();" ><@i18n key="IAM.DELETE.SELECTED" /></button>		
					</div>
					
				</div>
				
				
				
					<div id="empty_apitoken_format" class="hide">
				
						<div class="Field_session" id="api_token">	
						
							<div class="select_holder hide" id="select_apitoken_">
								<input data-validate="zform_field" onclick="display_removeselected_apitokens();" name="signoutfromweb" class="checkbox_check" type="checkbox">
								<span class="checkbox">
										<span class="checkbox_tick"></span>
								</span>
							</div>					
						
							<div class="info_tab">	
								<div class="authtoken_div">
									<span class="email_dp auth_dp"></span>
									<span class="authtoken_details">
										<span class="authtoken_name"></span>
										<span class="authtoken_time"></span>
									</span>
								</div>
								<div class="activesession_entry_info">
									<div class="asession_location location_unavail"><@i18n key="IAM.SESSIONS.LOCATION.UNAVAILABLE" /></div>
								
									<div class="asession_action authtoken_delete"><@i18n key="IAM.DELETE" /></div>
								</div>
							</div>
						
						
						
							<div class="aw_info" id="apitoken_info">
	
								<div class="info_div" id="authoken_name">
									<div class="info_lable"><@i18n key="IAM.TOKEN.NAME" /></div>
									<div class="info_value" id="pop_up_name"></div>
								</div>
								
								<div class="info_div">
									<div class="info_lable"><@i18n key="IAM.GENERATEDTIME" /></div>
									<div class="info_value" id="pop_up_generatedtime"></div>
								</div>
								
								<div class="info_div">
									<div class="info_lable"><@i18n key="IAM.ACTIVETOKEN.LAST.ACCESS.TIME" /></div>
									<div class="info_value" id="pop_up_lasttime"></div>
								</div>
								
								<div class="info_div">
									<div class="info_lable"><@i18n key="IAM.SCOPE" /> (<@i18n key="IAM.SERVICE" />)</div>
									<div class="info_value" id="pop_up_scope"></div>
								</div>
								
								<span class="info_div authtoken_container" style="display:inline-block" id="token_view">
									<div class="info_lable"><@i18n key="IAM.ACTIVETOKEN" /></div>
									<span class="info_value" id="pop_up_ticket"></span>
									<span class="blue"><@i18n key="IAM.ACTIVETOKEN.SHOWTEXT" /></span>
								</span>
								
								<span class="info_div authtoken_container hide" id="token_hide">
									<div class="info_lable"><@i18n key="IAM.ACTIVETOKEN" /></div>
									<span class="info_value" id="pop_up_clear_ticket"></span>
									<span class="blue"><@i18n key="IAM.ACTIVETOKEN.HIDETEXT" /></span>
								</span>
								
								<div id="usage_exist">
									<div class="info_div usage_exist">
										<div class="info_lable"><@i18n key="IAM.ACTIVETOKEN.LAST.ACCESSED.IP" /></div>
										<div class="info_value" id="pop_up_lastIP"></div>
									</div>
									<div class="info_div usage_exist">
										<div class="info_lable"><@i18n key="IAM.ACTIVETOKEN.LAST.ACCESSED.USERAGENT" /></div>
										<div class="info_value" id="pop_up_last_device"></div>
									</div>
								</div>

								<button class="primary_btn_check negative_btn_red inline" id="authoken_remove" tabindex="1"><span><@i18n key="IAM.DELETE" /></span></button>
							
							</div>

						</div>
			
					</div>
						