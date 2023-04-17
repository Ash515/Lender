		 
		 
		 
		 
		 <div class="box  tfa_status_box" id="modes_space">
		 		
				<div class="box_info">
					
					<span class="reduce_width">
					<div class="box_head"><@i18n key="IAM.MFA.MODES.TITLE" /></div>
					<div class="box_discrption"><@i18n key="IAM.MULTI.MFA.MODES.DESC" /></div>
					</span>
					
					<div class="toggle_field tfa-main-toggle hide" id="tfa_status">
						<div class="togglebtn_div">
							<input class="real_togglebtn suscription_radio" id="tfa_active" onchange="change_tfa_status();" type="checkbox">
							<div class="togglebase">
								<div class="toggle_circle"></div>							
							</div>
							
						</div>					
					</div>
					
				</div>
				
				<div id="mfa_options" class="mfa_options">
					
					<#if canSetup_mfa_device>
					<!-- One auth mode --> 
					
					<div class="option_grid" id="mfa_oneauth_mode">
				
							<div class="option_information blue_banner" id="oneauth_mode_info">
								<div id="mfa_link_space" class="mfa_link_space">
									<div class="one_auth_icon"></div>
									<div class="mfa_banner_head"><@i18n key="IAM.ZONE.ONEAUTH" /></div>	
									<div class="mfa_banner_define"><@i18n key="IAM.TFA.BANNER.HEAD"/></div>
									<div class="mfa_download_links">
										<span class="mfa_download_app appstore" onclick="open_IOS_location()"></span>
										<span class="mfa_download_app googleplay" onclick="open_android_location()"></span>
									</div>	
									<div class="learn_more_link"><span onclick="window.open(fta_oneauth_link, '_blank');"><@i18n key="IAM.LEARN.LINK"/></span></div>
								</div>
							</div>
						
							<div class="hide option_preference" id="oneauth_mode_preference">
							
								<div class="mfa_option_head"><@i18n key="IAM.ZONE.ONEAUTH" /></div>
								<div class="mfa_mode_status_butt">
									<div class="primary_indicator"><@i18n key="IAM.MFA.PRIMARY.MODE" /></div>
									<div class="disbaled_indicator"><@i18n key="IAM.MFA.MODE.DISABLED" /></div>
									<div class="secondary_indicator hide" id="one_auth_primary_toggle"><@i18n key="IAM.MYEMAIL.MAKE.PRIMARY" /></div>
								</div>
							
								<div class="mfa_option_deatils" id="mfa_devices">
									
									<div id="all_tfa_devices">
										<div class="MFAdevice_primary"></div>
										<div class="MFAdevice_BKUP "></div>
									</div>
									<div class="tfa_viewmore icon-showall hide" id="view_only_devices" onclick="show_all_devices();"><span><@i18n key="IAM.VIEWMORE.INFO" /><span></div>
								</div>
					
							</div>
					
					</div>
					</#if>
				
					<!-- SMS mode -->
				
					<div class="option_grid" id="mfa_sms_mode">
					
							<div class="option_information" id="sms_mode_info">
								<div class="mode_div">
									<span class="mfa_option_icon sms_icon icon-sms"></span>
									<span class="mfa_option_head"><@i18n key="IAM.TFA.SMS.HEAD"/></span>
								</div>
								<div class="mode_desc">
									<div class="mfa_option_define"><@i18n key="IAM.USE.MOBILE.DESC" /></div>
									<div class="mfa_setupnow" onclick="inititate_sms_setup(this)" id="goto_sms_mode"><@i18n key="IAM.BTNMSG.SETUP.NOW" /></div>
								</div>
							</div>
					
							<div class="hide option_preference" id="sms_mode_preference">
								<div class="mfa_option_head"><@i18n key="IAM.TFA.SMS.HEAD"/></div>
								<div class="mfa_mode_status_butt">
									<div class="primary_indicator"><@i18n key="IAM.MFA.PRIMARY.MODE" /></div>
									<div class="disbaled_indicator"><@i18n key="IAM.MFA.MODE.DISABLED" /></div>
									<div class="secondary_indicator hide" onclick="MFA_changeMODE_confirm('<@i18n key="IAM.TFA.SMS.HEAD"/>','0')"><@i18n key="IAM.MYEMAIL.MAKE.PRIMARY" /></div>
								</div>
								
								<div class="mfa_option_deatils" id="mfa_phonenumbers">
									<div id="all_tfa_numbers">
										<div class="MFAnumber_primary"></div>
										<div class="MFAnumber_BKUP "></div>
									</div>
									
									<div id="tfa_phone_add_view_more" class="hide">
										<div class="icon-showall half" id="view_only_tfa" onclick="show_all_Mfa_phonenumbers()"><span><@i18n key="IAM.VIEWMORE.INFO" /></span></div> 
										<div class="addnew half" id="add_tfa_phone" onclick="add_Mfa_backup()"><span><@i18n key="IAM.ADDNEW.MOBILE" /></span></div>
									</div>
									<div class="tfa_viewmore addnew hide" id="add_more_backup_num" onclick="add_Mfa_backup();"><span><@i18n key="IAM.ADDNEW.MOBILE" /></span></div>
									<div class="tfa_viewmore icon-showall hide" id="show_backup_num_diabledMFA" onclick="show_all_Mfa_phonenumbers();"><span><@i18n key="IAM.VIEWMORE.INFO" /></span></div>
								</div>
							</div>
					
					</div>
					
					
					<!-- Google Auth mode -->
					
					<div class="option_grid" id="mfa_app_auth_mode">
					
							<div class="option_information" id="sms_app_auth_info">
								<div class="mode_div">
									<span class="mfa_option_icon totp_icon icon-totp"></span>
									<span class="mfa_option_head"><@i18n key="IAM.TIME.AUTHENTICATOR"/></span>
								</div>
								<div class="mode_desc">
									<div class="mfa_option_define"><@i18n key="IAM.USE.AUTH.APP.DESC" /></div>
									<div class="mfa_setupnow" onclick="inititate_auth_setup()" id="configure_authmode"><@i18n key="IAM.BTNMSG.SETUP.NOW" /></div>
								</div>
							</div>
						
							<div class="hide option_preference" id="app_auth_mode_preference">
								<div class="mfa_option_head"><@i18n key="IAM.TIME.AUTHENTICATOR"/></div>
								<div class="mfa_mode_status_butt">
									<div class="primary_indicator"><@i18n key="IAM.MFA.PRIMARY.MODE" /></div>
									<div class="disbaled_indicator"><@i18n key="IAM.MFA.MODE.DISABLED" /></div>
									<div class="secondary_indicator hide"  onclick="MFA_changeMODE_confirm('<@i18n key="IAM.TIME.AUTHENTICATOR"/>','1')"><@i18n key="IAM.MYEMAIL.MAKE.PRIMARY" /></div>
								</div>
								
								<div class="mfa_option_deatils" id="mfa_auth_detils">

									<span class="mfa_option_icon totp_icon icon-totp"></span>   
									<span class="mobile_info">
										<div class="emailaddress_text"><@i18n key="IAM.AUTHENTICATR.APP" /></div>
										<div class="emailaddress_addredtime"></div>
									</span>
									
									<div class="phnum_hover_show" id="mfa_auth_hover">   
										<span class="action_icons_div_ph">				
											<span class="action_icon icon-delete" id="icon-delete" onclick="MFA_delete_confirm('<@i18n key="IAM.TIME.AUTHENTICATOR"/>','1')" title="<@i18n key="IAM.DELETE"/>"</span>
										</span>
									</div>

								</div>
								<div class="configure" id="change_configure_Gauthmode" onclick="inititate_auth_setup()" ><@i18n key="IAM.CHANGE.CONFIGURATION" /></div>
							</div>
					
					</div>
					
					
					
					<!-- Yubikey Auth mode -->
					
					
					<div class="option_grid" id="mfa_yubikey_mode">
					
							<div class="option_information" id="yubikey_mode_info">
								<div class="mode_div">
									<span class="mfa_option_icon yubikey_icon"></span>
									<span class="mfa_option_head"><@i18n key="IAM.MFA.YUBIKEY"/></span>
								</div>
								<div class="mode_desc">
									<div class="mfa_option_define"><@i18n key="IAM.TFA.YUBIKEY.DESC" /></div>
									<div class="mfa_setupnow" onclick="inititate_yubikey_setup()" id="goto_yubikey_mode"><@i18n key="IAM.BTNMSG.SETUP.NOW" /></div>
								</div>
							</div>
					
							<div class="hide option_preference" id="yubikey_mode_preference">
								
									<div class="mfa_option_head"><@i18n key="IAM.MFA.YUBIKEY"/></div>
									<div class="mfa_mode_status_butt">
										<div class="primary_indicator"><@i18n key="IAM.MFA.PRIMARY.MODE" /></div>
										<div class="disbaled_indicator"><@i18n key="IAM.MFA.MODE.DISABLED" /></div>
										<div class="secondary_indicator hide"  onclick="MFA_changeMODE_confirm('<@i18n key="IAM.MFA.YUBIKEY"/>','8')" ><@i18n key="IAM.MYEMAIL.MAKE.PRIMARY" /></div>
									</div>
								
								<div class="mfa_option_deatils" id="mfa_yubikey_detils">
									<span class="mfa_option_icon yubikey_icon"></span>   
									<span class="mobile_info">
										<div class="emailaddress_text"></div>
										<div class="emailaddress_addredtime"></div>
									</span>
									
									<div class="phnum_hover_show" id="mfa_yubikey_hover">   
										<span class="action_icons_div_ph">				
											<span class="action_icon icon-delete" id="icon-delete" onclick="MFA_delete_confirm('<@i18n key="IAM.MFA.YUBIKEY"/>','8')" title="<@i18n key="IAM.DELETE"/>"</span>
										</span>
									</div>
								</div>

								<div class="configure" id="configure_yubikey_mode" onclick="inititate_yubikey_setup()" ><@i18n key="IAM.CHANGE.CONFIGURATION" /></div>
						
							</div>
					
					</div>
					
					
					
					<div class="option_grid" id="mfa_exo_mode">
						
							<div class="option_information" id="exo_mode_info">
							
								<div class="mode_div">
									<span class="mfa_option_icon exo_icon"></span>
									<span class="mfa_option_head"><@i18n key="IAM.EXO.AUTHENTICATE"/></span>
								</div>
								<div class="mode_desc">
									<div class="mfa_option_define"><@i18n key="IAM.TFA.EXOAUTH.DESCRIPTION" /></div>
									<div class="mfa_setupnow" onclick="inititate_exo_setup()" id="goto_exo_mode"><@i18n key="IAM.BTNMSG.SETUP.NOW" /></div>
								</div>
							
							</div>
					
							<div class="hide option_preference" id="exo_mode_preference">
								
								<div class="mfa_option_head"><@i18n key="IAM.EXO.AUTHENTICATE"/></div>
								<div class="mfa_mode_status_butt">
									<div class="primary_indicator"><@i18n key="IAM.MFA.PRIMARY.MODE" /></div>
									<div class="disbaled_indicator"><@i18n key="IAM.MFA.MODE.DISABLED" /></div>
									<div class="secondary_indicator hide" onclick="MFA_changeMODE_confirm('<@i18n key="IAM.EXO.AUTHENTICATE"/>','6')"><@i18n key="IAM.MYEMAIL.MAKE.PRIMARY" /></div>
								</div>
								
								<div class="mfa_option_deatils" id="mfa_exo_detils">
								
									<span class="mfa_option_icon exo_icon"></span>   
									<span class="mobile_info">
										<div class="emailaddress_text"><@i18n key="IAM.AUTHENTICATR.APP" /></div>
										<div class="emailaddress_addredtime"></div>
									</span>
									
									<div class="phnum_hover_show" id="mfa_exomode_hover">   
										<span class="action_icons_div_ph">				
											<span class="action_icon icon-delete" id="icon-delete" onclick="MFA_delete_confirm('<@i18n key="IAM.EXO.AUTHENTICATE"/>','6')" title="<@i18n key="IAM.DELETE"/>"</span>
										</span>
									</div>
								
								</div>
								
								<div class="configure" id="configure_exo_mode" onclick="inititate_exo_setup()" ><@i18n key="IAM.CHANGE.CONFIGURATION" /></div>
						
							</div>
					
					</div>
					
					
				</div>
				
				

		</div>
		
		
		
	<!-- temp activate and deactive mfa status -->
		
		<div class="hide popup" id="delete_tfa_popup" tabindex="0">
			<div class="popup_header ">
				<div class="popuphead_details">
				
					<div id="tfa_is_activated" class="hide">
						<span class="popuphead_text"><@i18n key="IAM.TFA.DISABLE.TITLE" /> </span>
						<span class="popuphead_define"><@i18n key="IAM.MFA.DISABLE.TXT" /></span>
					</div>
					
					<div id="tfa_not_activated" class="hide">
						<span class="popuphead_text"><@i18n key="IAM.TFA.REENABLE.HEADING" /> </span>
						<span class="popuphead_define"><@i18n key="IAM.TFA.REENABLE.TXT" /> </span>
					</div>
				
				</div>
				<div class="close_btn" onclick="close_delete_tfa_popup(false)"></div>
			</div>
			
			<div class="tfa_verify_butt" >
			
				<button class="primary_btn_check hide" id="tfa_deactivate" onclick="disableTFA()"><span><@i18n key="IAM.TURN.OFF.TFA" /> </span></button>
				<button class="primary_btn_check hide" id="tfa_activate"  onclick="return re_enableTFA()"><span><@i18n key="IAM.TURN.ON.TFA" /> </span></button>
				
			</div>
		</div>
		
		
		
		
		
	<!-- TFA choose new primary -->
	
	<div class="hide popup" tabindex="1" id="CHprimary_NOTICE">
			
			<div class="popup_header ">
				<div class="popuphead_details">
					<span class="popuphead_text"><@i18n key="IAM.MFA.DELETE.PRIMARY.HEAD" /> </span>
					<span class="popuphead_define"><@i18n key="IAM.MFA.DELETE.PRIMARY.DESC" /> </span>
				</div>
				<div class="close_btn" onclick="close_tfa_CHprimary_notice()"></div>
				
				<div class="mfa_select_primary field">
					<select id="mfa_primary_select">
					</select>	
				</div>
				
				<div class="tfa_verify_butt" >					  
	  	  			<button class="primary_btn_check " tabindex="1" onclick="change_new_primary()" ><span><@i18n key="IAM.UPDATE" /> </span></button>
		    	</div>
				
			</div>
		    	
	</div>
			
		
		
		
		<!--tfa add backup number space-->

		<div class="hide popup" tabindex="0" id="add_tfa_backup_popup">
		
			<div class="popup_header ">
				<div class="popuphead_details">
					<span class="popuphead_text"><@i18n key="IAM.TFA.ADD.BACKUP.NUMBERS" /></span>
					<span class="popuphead_define"></span>
				</div>
				<div class="close_btn" onclick="close_add_new_tfa_popup()"></div>
			</div>
			
<!--			<div id="tfa_recover_tobackup" class="hide">
			
				<form name="addbackup">
					<div class="field full noindent" id="select_existing_phone">
                  		<label class="textbox_label"><@i18n key="IAM.PHONE.NUMBER" /> </label>

                  		<select class="select_field" name="verifiedmobilesbackup" id="verifiedmobilesbackup"></select>
                  		
						<span class="blue" tabindex="0" onclick="show_addnewbackup();"><@i18n key="IAM.ADDNEW" /> </span>
					</div>
					
					<div class="tfa_verify_butt" >					  
		  	  			<button class="primary_btn_check " tabindex="0" onclick="addAsBackupNumber();" ><span><@i18n key="IAM.UPDATE" />  </span></button>
						<button class="primary_btn_check high_cancel" tabindex="0" onclick="return close_add_new_tfa_popup()"><span><@i18n key="IAM.CLOSE" /> </span></button>
	    			</div>
	    		</form>
	    		
	    	</div>
-->
	    	<div id="tfa_new_tobackup" class="hide">
			
				<form id="newphone" onsubmit="return false;">
					<div class="field full noindent" id="select_phonenumber">
                  		<label class="textbox_label"><@i18n key="IAM.PHONE.NUMBER" />  </label>
						<label class="phone_code_label" for="countNameAddDiv"></label>
                  		<select id="countNameAddDiv" name="countNameAddDiv" class="countNameAddDiv" style="width: 67px;">
                  			<#list country_code as dialingcode>
                          		<option data-num="${dialingcode.dialcode}" value="${dialingcode.code}" id="${dialingcode.code}" >${dialingcode.display}</option>
                           	</#list>
                  		</select>
						
						<input class="textbox" id="mobileno" maxlength="15" data-type="phonenumber" type="tel">
					</div>
					
				
					<div class="tfa_verify_butt" >					  
		  	  			<button class="primary_btn_check " tabindex="0" onclick="add_tfa_bkup();" ><span><@i18n key="IAM.NEXT" /> </span></button>
						<button class="primary_btn_check high_cancel" tabindex="0" onclick="return close_add_new_tfa_popup()"><span><@i18n key="IAM.CLOSE" /> </span></button>
	    			</div>
	    			
				</form>
				
				<form id="confirm_phone" onsubmit="return false;">
							
					<div class="tfa_info_text"><@i18n key="IAM.TFA.VERIFY.SMS_MESSAGE" /></div>
					
					<div class="field full" id="verfiy_code_tfa_bkup_space">
						<div class="textbox_label" id="verfiy_code_tfa"><@i18n key="IAM.TFA.ENTER.OTP.CODE" /> </div>
						<input class="textbox" data-optional="true" onkeypress="remove_error()" name="" id="vcode" type="tel">
					</div>
													
					<div id="tfa_resend" class="resend_link" onclick="resend_verify_otp(this,false)"><a href="javascript:;"><@i18n key="IAM.TFA.RESEND.OTP" /> </a></div>
					
					<div class="tfa_verify_butt" >					  
		  	  			<button class="primary_btn_check " onclick="verify_tfa_bkup();" ><span><@i18n key="IAM.ADD" /> </span></button>
						<button class="primary_btn_check high_cancel" onclick="return close_add_new_tfa_popup()"><span><@i18n key="IAM.CLOSE" /> </span></button>
	    			</div>
	    			
				</form>
				
			</div>
			
		</div>	
				
				
				
		<div class="viewall_popup hide popupshowanimate_2" tabindex="1" id="tfa_phonenumber_web_more">
					
			<div class="box_info">
				<div class="expand_closebtn" onclick="closeview_all_tfanumber_view()"></div>
				
				<div class="hide" id="mfa_show_all_otp">
					<div class="box_head"><@i18n key="IAM.TFA.SMS.HEAD" /></div>
					<div class="box_discrption"><@i18n key="IAM.USE.MOBILE.DESC" /></div>
				</div>
				
				<div class="hide" id="mfa_show_all_oneauth">
					<div class="box_head"><@i18n key="IAM.ZONE.ONEAUTH" /></div>
					<div class="box_discrption"><@i18n key="IAM.TFA.ONEAUTH.DESC" /></div>
				</div>
				
				
			</div>
			
			<div class="viewall_popup_content" id="view_all_tfa_phonenumber" tabindex="1"></div>
					
		</div>
		

						