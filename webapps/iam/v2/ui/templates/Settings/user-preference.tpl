    				
    				
    				
    		<div class="hide" id="popup_user-preference_contents">
				<form  method="post" onsubmit="return false;" novalidate>
					<div id="user_pref_dateformat" class="hide">
						
						<div class="field full noindent">
							
							<div class="textbox_label "><@i18n key="IAM.USERPREFERENCE.SELECT.FORMAT" /> </div>
    							<select name="date_format" id="format"  onchange="setFormat()" class="customised_select">
	    							
    								<option id="custom_" value="custom"><@i18n key="IAM.USERPREFERENCE.CUSTOM" /></option>
	    							<#list dateFormats as formats>
	                          			<option value="${formats.format}" id="${formats.format}" >${formats.format} - ${formats.example}</option>
	                           		</#list>
    							
    							</select>
    						<div class="field full hide" id="customizeFormat">
		                  		<label class="textbox_label"><@i18n key="IAM.USERPREFERENCE.ENTER.FORMAT" /> </label>
		                  		<input class="textbox" name="custom" oninput="check_disable(this)" id="custom" type="text">
							</div>
							
						</div>
						
						<div class="field hide full noindent">
							<div class="textbox_label "><@i18n key="IAM.TIME.FORMAT" /></div>
							<select id="hours_type" class="customised_select">
								<option><@i18n key="IAM.USER.PREF.12.HOURS" /> </option>
								<option><@i18n key="IAM.USER.PREF.24.HOURS" /> </option>
							</select>
						</div>
						
					</div>
					
					
						
						
					<div id="user_pref_photoview_permi" class="hide">

						
						<div class="radiobtn_div">
							<input class="real_radiobtn photo_radio" type="radio" name="ppview" id="3" value="3">

							<div class="outer_circle">
							<div class="inner_circle"></div></div>
							<label class="radiobtn_text" for="3"><@i18n key="IAM.PHOTO.PERMISSION.ZOHO_USERS" /> </label>
						</div>
						<div class="radiobtn_div">
							<input class="real_radiobtn photo_radio" type="radio" name="ppview" id="2"  value="2">
							<div class="outer_circle"><div class="inner_circle"></div></div>
							<label class="radiobtn_text" for="2"><@i18n key="IAM.PHOTO.PERMISSION.CHAT_CONTACTS" /></label>
						</div>
						
						<#if  is_org_user>
							<div class="radiobtn_div" id="org_photo">
								<input class="real_radiobtn photo_radio" type="radio" name="ppview" id="1" value="1">
	
								<div class="outer_circle">
								<div class="inner_circle"></div></div>
								<label class="radiobtn_text" for="1"><@i18n key="IAM.PHOTO.PERMISSION.ORG_USERS" /> </label>
							</div>
						</#if>
						
						<div class="radiobtn_div">
							<input class="real_radiobtn photo_radio" type="radio" name="ppview" id="4" value="4">
							<div class="outer_circle">
							<div class="inner_circle"></div></div>
							<label class="radiobtn_text" for="4"><@i18n key="IAM.PHOTO.PERMISSION.EVERYONE" /> </label>
						</div>
						<div class="radiobtn_div">
							<input class="real_radiobtn photo_radio" type="radio" name="ppview" id="0" value="0">
							<div class="outer_circle">
							<div class="inner_circle"></div></div>
							<label class="radiobtn_text" for="0"><@i18n key="IAM.PHOTO.PERMISSION.ONLY_MYSELF" /> </label>
						</div>					
					</div>
					
					
				<#if  is_password_expiry_notification>
					
					<div id="user_pref_notifications" class="hide">	
						
						
										
							<div class="toggle_block_field">
							
								<div class="toggle_block">
									<div class="toggle_head"><@i18n key="IAM.USERPREFERENCE.PASSEXPIRY_NOTIFICATION" /> </div>
									<div class="toggle_desc"><@i18n key="IAM.SETTINGS.PASSWORD.EXPIRY.DESC" /> </div>
								</div>
								
								<div class="togglebtn_div">
									<input class="real_togglebtn" id="password_expiry" type="checkbox">
									<div class="togglebase">
										<div class="toggle_circle"></div>
									</div>
									
								</div>
							</div>	
	
					</div>
				
				</#if>
					
				
				
					<div id="user_pref_subscriptions" class="hide">	

						<div class="toggle_field">
							<label class="toggle_text"><@i18n key="IAM.USERPREFERENCE.GENERAL" /> </label>
							<div class="togglebtn_div">
								<input class="real_togglebtn suscription_radio" id="news_letter" type="checkbox">
								<div class="togglebase">
									<div class="toggle_circle"></div>
								</div>
							</div>
						</div>
						
						<div id="double_opt" class="hide"><@i18n key="IAM.NOTE.DOUBLE.OPT.IN.NOTIFICATION" /> </div>
				
					</div>
					
					
					
					
					<button class="primary_btn_check " tabindex="0" id="popup_user-preference_action" ><span></span></button>
								
				</form>
				
			</div>
				
    					
    				
    				
    				
    				<div class="box big_box" id="preference_box">
    				
    					<div class="box_blur"></div>
						<div class="loader"></div>
						
						<div class="box_info">
							<div class="box_head"><@i18n key="IAM.USERPREFERENCE" /><span class="icon-info"></span> </div>
							<div class="box_discrption"><@i18n key="IAM.USER.PREFERENCE.DESCRIPTION" /> </div>
						</div>
						

					
					<div class="pref_option" id="dateformatid" onclick="showuser_pref_dateformat('<@i18n key="IAM.SETTINGS.DATEFORMAT.HEADDING" /> ','<@i18n key="IAM.SETTINGS.DATEFORMAT.DESCRIPTION" /> ','<@i18n key="IAM.SAVE" /> ','savedateformat');"> 
						<div class="option_desc">
							<div class="option_head"><@i18n key="IAM.USERPREFERENCE.SELECT.FORMAT" /> </div>
							<div class="option_values" id="current_date_format"></div>
						</div>
						<div class="edit_text"><@i18n key="IAM.EDIT" /> </div>
					</div>
					
					
					<div class="pref_option" id="ppviewid" onclick="showuser_pref_photoview_permi('<@i18n key="IAM.PRIVACY.SETTINGS" />','<@i18n key="IAM.SETTINGS.PHOTOVIEW.DESCRIPTION" /> ','<@i18n key="IAM.SAVE" />','savephotoview_permi');"> 
						<div class="option_desc">
							<div class="option_head"><@i18n key="IAM.PRIVACY.SETTINGS" /> </div>
							<div class="option_values" id="photo_view_per"></div>
						</div>
						<div class="edit_text"><@i18n key="IAM.EDIT" /> </div>
					</div>
					
			
			<#if is_password_expiry_notification >
								
					<div class="pref_option" id="notificationid" onclick="showuser_pref_notifications('<@i18n key="IAM.SETTINGS.NOTIFICATIONS.TITLE" />','<@i18n key="IAM.SETTINGS.NOTIFICATIONS.TITLE.DESCRIPTION" />','<@i18n key="IAM.UPDATE" />','save_email_notification');">
						<div class="option_desc">
							<div class="option_head"><@i18n key="IAM.SETTINGS.NOTIFICATION.HEADDING" /> </div>
							<div class="option_values" id="notification_value"></div>
						</div>
						<div class="edit_text"><@i18n key="IAM.EDIT" /></div>
					</div>
					
			</#if>
			

					<div class="pref_option" id="subscriptionsid" onclick="showuser_pref_subscriptions('<@i18n key="IAM.USERPREFERENCE.NEWSLETTER.SUBSCRIBE" />','<@i18n key="IAM.TPL.ZOHO.NEWSLETTER.SUBSCRIBE.DESC" />','<@i18n key="IAM.SAVE" />','save_browser_subscriptions');">
						<div class="option_desc">
							<div class="option_head"><@i18n key="IAM.USERPREFERENCE.NEWSLETTER.SUBSCRIBE" /></div>
							<div class="option_values" id="subscription_values"></div>
						</div>
						<div class="edit_text"><@i18n key="IAM.EDIT" /></div>
					</div>

				</div>