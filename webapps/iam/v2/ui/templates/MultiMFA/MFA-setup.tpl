				
<!--	#Mobile UI FOR DEVICES AND OTP MODE	-->			
				
					<div class="hide popup" tabindex="1" id="tfaphone_mobile_ui">
					    <div class="popup_header popup_header_for_mob">
							<div class="popuphead_details">
							</div>
						    <div class="close_btn" onclick="close_MFA_mobile_specific()"></div>
					    </div>
					    <div class="mob_popu_btn_container">
					        <button class id="btn_to_chng_primary" ><span class="icon-makeprimary"></span><span><@i18n key="IAM.MYEMAIL.MAKE.PRIMARY" /></span></button>
					        <button id="btn_to_delete" ><span class="icon-delete"></span><span><@i18n key="IAM.REMOVE" /></span></button>
					    </div>
					    <div class="option_container">
					    	<div class="mob_popuphead_define">
					    		
					    	</div>
					    	<div class="option_button">
						        <button id="action_granted"><@i18n key="IAM.CONTINUE"/></button>
						        <button id="" onclick="close_MFA_mobile_specific()"><@i18n key="IAM.CANCEL" /></button>
					    	</div>
					    </div>
					</div>	
				
			
<!--	#Mobile Number MFA		-->
			
				<div id="empty_MFAphone_format" class="hide">
					
					<div class="mfa_field_mobile secondary" id="mfa_phoneDetails">
						
						<span class="mobile_dp icon-call"></span>   
						<span class="mobile_info">
							<div class="emailaddress_text"></div>
							<div class="emailaddress_addredtime" id="mfa_ph_time"></div>
							<div class="emailaddress_addredtime primary_dot"></div>
							<div class="pri_sec_indicator">
								<div class="pri_indicator"><@i18n key="IAM.MFA.PRIMARY"/></div>
								<div class="sec_indicator"><@i18n key="IAM.MFA.SECONDARY"/></div>
							</div>
						</span>
						<div class="phnum_hover_show" id="mfa_ph_over">   
							<span class="action_icons_div_ph">				
								<span class="action_icon icon-makeprimary" id="icon-primary" title="<@i18n key="IAM.MYEMAIL.MAKE.PRIMARY" />" ></span>
																
								<span class="action_icon icon-delete" id="icon-delete" title="<@i18n key="IAM.DELETE"/>"</span>
							
							</span>
						</div>
					</div>
				
				</div>
				
				
				<div class="box_info hide" id="sms_mode_head">
					<div class="box_head"><@i18n key="IAM.USE.MOBILE" /> </div>
					<div class="box_discrption mob_hide"><@i18n key="IAM.SETUP.TFA.MOBILE.DESC" /> </div>
					<div class="box_verify_discrption"><@i18n key="IAM.SETUP.TFA.VERIFY_MOBILE.DESC" /> </div>
					
					<input type="hidden" id="enc_mob"/>
					<input type="hidden" id="newmobile"/>
					<input type="hidden" id="countrycode"/>
				</div>
				
				<div class="hide" id="mfa_sms_mode_popups">
					
					<div class="tfa_blur"></div>
					<div class="loader"></div>	
					
					<form class="tfa_setup_work_space" onsubmit="return false;">
						<div class="field" id="enter_num_tfa_space">
							<label class="textbox_label"><@i18n key="IAM.MOBILE.NUMBER" /></label>
							<div class="select_text">
								<label for="tfa_numbers_code" class="phone_code_label"></label>
								<select id="tfa_numbers_code" id="tfa_numbers_code">
									<#list country_code as dialingcode>
	                          			<option data-num="${dialingcode.dialcode}" value="${dialingcode.code}" value="${dialingcode.code}" id="${dialingcode.code}" >${dialingcode.display}</option>                          			
	                           		</#list>
								</select>
								<input class="textbox" id="tfa_number_input" onkeypress="remove_error()" maxlength="15" data-type="phonenumber" type="tel" >
							</div>
	
	
						</div>
						<div class="sms_warn"><span class="icon-MFA tfa_warnicon"></span><@i18n key="IAM.SMS.TEXT.WARN" /> </div>
						
				   		<button tabindex="0" class="primary_btn_check " onclick="add_mfa_Mobile()" ><span><@i18n key="IAM.NEXT" /> </span></button>

					</form>
					
				</div>
				
				

						


<!--	#Authenticator APP		-->



				<div class="box_info hide" id="auth_mode_head">
					<div class="box_head"><@i18n key="IAM.USE.AUTH.APP" /> </div>
					<div class="box_discrption mob_hide"><@i18n key="IAM.USE.AUTH.APP.DESC" /> </div>
				</div>
				
				<div class="box_info hide" id="auth_mode_downloads">
					<div class="box_head"><@i18n key="IAM.DOWNLOAD.AUTHENTICATOR" /></span></div>
					<div class="box_discrption mob_hide"><@i18n key="IAM.DOWNLOAD.AUTHENTICATOR.DESC" /> </div>
				</div>
				
				<div class="hide" id="mfa_auth_mode_popups">
				
					<div class="tfa_setup_work_space">
							
						<div class="key_qr_space">
							<div id="tfa_qr_space" class="tfa_qr_space">
								<img id="gauthimg" class="qr_tfa" alt="barcode image" />
							</div>
	
						
							<div class="qr_key_box">
								<div class="qr_key_head"><@i18n key="IAM.MANUAL.ENTRY" />  </div>
								<div class="tfa_info_text" id="skey"></div>
								<div class="qr_key_note"><@i18n key="IAM.TFA.TOTP.SPACE.TIP" /> </div>
							</div>
							
						</div>
						
			  	  		<button class="primary_btn_check "id="auth_app_confirm" tabindex="0" onclick="verify_auth_qr();" ><span><@i18n key="IAM.NEXT" /> </span></button>
		    			
	    				<div class="tfa_goto_other">
			   				<span><@i18n key="IAM.NOT.HAVE.APP" /> </span> 
			   				<span class="blue_link" onclick="download_options();"><@i18n key="IAM.DOWNLOAD.APP" />  </span>
			   			</div>
		    			
					</div>
					
				</div>
				
				<div class="hide" id="mfa_auth_downloads_popups">
				
					<div class="tfa_setup_work_space">
					
						<div class="tfa_authapp_list">
						
						<#if canSetup_mfa_device>
							<div class="tfa_authapp">
								<span class="tfa_auth_logo one_auth"></span>
								<span class="app_text" onclick='window.open(fta_oneauth_link)' ><@i18n key="IAM.ZONE.ONEAUTH" /> (<@i18n key="IAM.RECOMMENDED" />)</span>
							</div>
						</#if>
							
							<div class="tfa_authapp">
								<span class="tfa_auth_logo google_auth"></span>
								<span class="app_text" onclick='window.open("${googleAuthenticator_link}")'><@i18n key="IAM.GOOGLE.AUTHENTICATOR" /> </span>
							</div>
						</div>
						<a tabindex="0" class="primary_btn_check high_cancel" onclick="inititate_auth_setup();"><span><@i18n key="IAM.BACK" /></span></a>
					</div>
					
				</div>



<!--	#EXO STAR APP		-->


			<div class="box_info hide" id="exostar_mode_downloads">
				<div class="box_head"><@i18n key="IAM.CONFIG.EXOSTAR" /></span> </div>
				<div class="box_discrption mob_hide"><@i18n key="IAM.TFA.EXOAUTH.DESCRIPTION" /> </div>
				
				<input type="hidden" id="exo_type"/>
			</div>
			
			<div class="hide" id="mfa_exostar_mode_popups">
				
					<div class="radiobtn_div">
						<input class="real_radiobtn photo_radio" type="radio" name="exomodepref1" id="hardmodepref" value="hard" checked="checked">
						<div class="outer_circle">
							<div class="inner_circle"></div>
						</div>
						<label for="hardmodepref" class="radiobtn_text tfa_radio_text"><@i18n key="IAM.TFA.EXOAUTH.HARD" /> </label>
					</div>
					<div class="tfa_radio_desc" onclick="slect_option(this)"><@i18n key="IAM.TFA.EXOAUTH.OPTION.DESCRIPTION" /> </div>
					
					<div class="radiobtn_div">
						<input class="real_radiobtn photo_radio" type="radio" name="exomodepref1" id="softmodepref" value="soft" >
						<div class="outer_circle">
							<div class="inner_circle"></div>						
						</div>
						<label for="softmodepref" class="radiobtn_text tfa_radio_text"><@i18n key="IAM.TFA.EXOAUTH.SOFT" /> </label>
					</div>
					<div class="tfa_radio_desc" onclick="slect_option(this)"><@i18n key="IAM.TFA.EXOAUTH.MSG4" /> </div>
					
	  	  			<a class="primary_btn_check " onclick="showExoAuthVerify_popup()" ><span><@i18n key="IAM.NEXT" /> </span></a>
				
			</div>



<!--	# Yubikey Settings	-->


	
	<div class="hide" id="mfa_yubikey_mode_popups">
	
		
		<div id="first_step" class="yubikey_content">
		
			<div class="popup_head center_text"><@i18n key="IAM.MFA.YUBIKEY.HEAD.SETUP" /> </div>
			<div class="close_btn centre_cross" onclick="close_yubikey_popup();"></div>
			
			<div id="yubikey_pic" class="yubikey_pic"></div>
		
			<div class="yuikey_head"><@i18n key="IAM.MFA.YUBIKEY.INSERT.HEAD" /></div>
			<div class="yuikey_description" ><@i18n key="IAM.MFA.YUBIKEY.INSERT.DESCRIPTION" /></div>
			
			<div class="yubikey_verify_butt">					  
	  			<button class="primary_btn_check " id="yubikey_start_butt" tabindex="0" onclick="show_yubikey_configure()"><span><@i18n key="IAM.NEXT" /> </span></button>
				<button class="primary_btn_check high_cancel" id="yubikey_start_cancel" tabindex="0" onclick="close_yubikey_popup()"><span><@i18n key="IAM.CANCEL" /> </span></button>
			</div>
		</div>

		<div id="second_step" class="hide yubikey_content">
		
			<div class="popup_head center_text"><@i18n key="IAM.MFA.YUBIKEY.HEAD.CONFIG" /> </div>
			<div class="close_btn centre_cross" onclick="close_yubikey_popup();"></div>
			
			<div id="yubikey_pic" class="yubikey_pic"></div>
			
			<div class="yuikey_head bold"><@i18n key="IAM.TFA.YUBIKEY.TOUCH" /></div>

			<div class="yubikey_verify_butt">					  
	  			<button class="button_disable yubikeyregis hide" id="ubkey_wait_butt" tabindex="0"><span><@i18n key="IAM.GDPR.DPA.WAITING" />  </span></button>
	  			<button class="primary_btn_check hide yubikeyregis" id="ubkey_tryagain_butt" tabindex="0" onclick="yubikey_register()"><span><@i18n key="IAM.YUBIKEY.TRY.AGAIN" />  </span></button>
				<button class="primary_btn_check high_cancel" id="yubikey_touch_cancel" tabindex="0" onclick="show_yubikey_step1()"><span><@i18n key="IAM.BACK" />  </span></button>
			</div>
			
		</div>
		
		<div id="third_step" class=" hide yubikey_content">
		
			<div class="popup_head center_text"><@i18n key="IAM.MFA.YUBIKEY.HEAD.NAME" /> </div>
			<div class="close_btn centre_cross" onclick="close_yubikey_popup();"></div>
		
			<form onsubmit="return false;">
				<div class="field full" id="yubikey_name_field">
					<div class="textbox_label" id="yubikey_name_label"><@i18n key="IAM.MFA.YUBIKEY.NAME" /></div>
					<input class="textbox" tabindex="0" autocomplete="off" id="yubikey_name" type="text" onkeypress="remove_yubikeyerror()">
					<div class="yubikey_name_desc"><@i18n key="IAM.YUBIKEY.NAME.DESC" /></div>
				</div>
	
				<div class="yubikey_verify_butt">		 			  
		  			<button class="primary_btn_check " id="yubikey_verfiy_butt" tabindex="0" onclick="configure_yubikey()"><span><@i18n key="IAM.CONFIGURE" />  </span></button>
					<button class="primary_btn_check high_cancel" id="yubikey_verify_cancel" tabindex="0" onclick="show_yubikey_step2();show_yubikey_step1();"><span><@i18n key="IAM.BACK" />  </span></button>
				</div>
			</form>
		</div>
		

		
	</div>	
	
	
	



<!--	# verification Space for all modes		-->


			<div class="hide" id="mfa_verify_space_popups">
			
				<div class="tfa_blur"></div>
				<div class="loader"></div>	
				
				<form class="tfa_setup_work_space" onsubmit="return false;">
					
					<div class="field" id="verfiy_code_tfa_space">
							<div class="textbox_label" id="verfiy_code_tfa"><@i18n key="IAM.TFA.ENTER.OTP.CODE" /> </div>
							<input class="textbox" data-optional="true" onkeypress="remove_error()" name="" id="prefcode" oninput="this.value = this.value.replace(/[^\d]+/g,'')" tabindex="0" type="tel">
					</div>
					
					<div id="tfa_resend" class="" onclick="resend_verify_otp(this,true);"><a href="javascript:;"><@i18n key="IAM.TFA.RESEND.OTP" /> </a></div>
					
				
					<div class="tfa_verify_butt" >					  
		  	  			<button class="primary_btn_check " id="tfa_verfiy_butt" tabindex="0"><span><@i18n key="IAM.VERIFY" /> </span></button>
						<button class="primary_btn_check high_cancel" id="tfa_verify_cancel" tabindex="0"><span><@i18n key="IAM.BACK" /> </span></button>
	    			</div>	
				</form>
				
			</div>
			
			

