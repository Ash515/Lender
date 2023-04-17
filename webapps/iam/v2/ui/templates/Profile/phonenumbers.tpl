 
		
			
				<div class="hide" id="phonenumber_popup_contents">
				
					<form  method="post" class="zform" id="phoneNumberform" onsubmit="return false;" novalidate>

						<div class="field full hide" id="empty_phonenumber">
	                  		<label class="textbox_label"><@i18n key="IAM.MOBILE.NUMBER" /></label>
	                  		<input class="textbox" data-validate="zform_field" name="phone_input_code" autocomplete="phonenumber" id="empty_phonenumber_input_code" maxlength="15" data-type="phonenumber" type="tel" >
	                  		<input type="hidden" id="empty_phonenumber_input" data-validate="zform_field" name="phone_input">
						</div>
						
						<div class="field full hide noindent" id="select_phonenumber">
	                  		<label class="textbox_label"><@i18n key="IAM.MOBILE.NUMBER" /></label>
	                  		<label for="countNameAddDiv" class="phone_code_label"></label>
	                  		<select id="countNameAddDiv" data-validate="zform_field" autocomplete='country-name' name="countrycode" class="countNameAddDiv" style="width: 67px;">
	                  			<#list country_code as dialingcode>
                          			<option data-num="${dialingcode.dialcode}" value="${dialingcode.code}" id="${dialingcode.code}" >${dialingcode.display}</option>
                           		</#list>
							</select>
							<input class="textbox select_phonenumber_input" tabindex="0" data-validate="zform_field" autocomplete="phonenumber" onkeypress="remove_error()" name="mobile_no" id="select_phonenumber_input" maxlength="15" data-type="phonenumber" type="tel" >
						</div>
						
						<input type="hidden" id="old_mob" data-validate="zform_field" name="old_phone">
						
						<div class="field full hide" id="otp_phonenumber">
	                  		<label class="textbox_label"><@i18n key="IAM.VERIFY.LABEL" /></label>
	                  		<input class="textbox" data-validate="zform_field" name="otp_code" autocomplete="off" oninput="this.value = this.value.replace(/[^\d]+/g,'')" id="otp_phonenumber_input" type="tel" >
	                  		<div id="emailOTP_resend" class="" onclick="resendverifyOTP();"><a href="javascript:;"><@i18n key="IAM.TFA.RESEND.OTP" /></a></div>
						</div>
						
						<div class="field full hide noindent" id="select_existing_phone">
	                  		<label class="textbox_label"><@i18n key="IAM.PHONE.NUMBER" /></label>
	                  		<select class="select_field" data-validate="zform_field" autocomplete="off" name="editscreenname" id="editscreenname">
							</select>
						</div>

						
						<button tabindex="0" class="primary_btn_check " id="popup_mobile_action"><span></span></button>
						
					</form>
				
				</div>
				
				
				
				
				
				
				<div class="hide popup" tabindex="0" id="addToRecovery">
					<div class="popup_header">
						<div class="popuphead_details">
							<span class="popuphead_text"><@i18n key="IAM.PHONE.NUMBER" /></span>
							<span class="popuphead_define"><@i18n key="IAM.PROFILE.PHONENUMBERS.ADD.NUMBER.DESCRIPTION" /></span>
						</div>
						<div class="close_btn" onclick="close_converttfa_popup()"></div>
					</div>
							
					<div id="add_ph_form">
	    				<form method="post" name="backup_to_recovery" id="backup_to_recovery" onsubmit="return false;" novalidate>   				
	 
		    				<div class="field full " id="select_existing_backup">
		                  		<label class="textbox_label"><@i18n key="IAM.MOBILE.TFA.BACKUP.PHONE_NUMBERS" /></label>
		                  		<select class="select_field" data-validate="zform_field" name="backupnumber" id="backupnumber" >
								</select>
								<span class="blue" onclick="show_add_mobilescreen('<@i18n key="IAM.ADD.PHONE.NUMBER" />','<@i18n key="IAM.PROFILE.PHONENUMBERS.ADD.NUMBER.DESCRIPTION" />','<@i18n key="IAM.ADD" />','addphonenum');" title="<@i18n key="IAM.ADDNEW" />"><@i18n key="IAM.ADDNEW" /></span>
							</div>
		                  	
							
							
							<button type="submit" class="primary_btn_check" onclick="switchBackupNoForRecovery(document.backup_to_recovery,newRecovery)" id="popup_mobile_action"><@i18n key="IAM.TFA.RCOVERY.SWITCH" /></button>
	    				</form>
    				</div>
    				
    			</div>
    			
    			
    			
    			
    			
    			
    			<div class="box big_box"  id="phnum_box">
    			
    						<div class="box_blur"></div>
							<div class="loader"></div>
					
					<div class="box_info">
						<div class="box_head"><@i18n key="IAM.MY.PHONENUMBERS" /></div>
						<div class="box_discrption"><@i18n key="IAM.PHONENUMBERS.DEFINITION" /></div>
					</div>
				
					<div id="no_phnum_add_here" class="box_content_div">
						<div class="no_data no_data_SQ"></div>
						<div class="no_data_text hide"><@i18n key="IAM.PHONENUMBER.LIST.EMPTY" /> </div>	
						
						<button class="primary_btn_check  center_btn " id="add_newnobackup" onclick="show_add_mobilescreen('<@i18n key="IAM.ADD.PHONE.NUMBER" />','<@i18n key="IAM.PROFILE.PHONENUMBERS.ADD.NUMBER.DESCRIPTION" />','<@i18n key="IAM.ADD" />','addphonenum');" ><span><@i18n key="IAM.ADD.PHONE.NUMBER" /></span></button>
						
						<button class="primary_btn_check  center_btn hide" id="addfrom_backup" onclick="show_tfa_switch_mobilescreen();" ><span><@i18n key="IAM.USE.TFA.BACKUP.NUMBER.TO.RECOVERY" /></span></button>
					</div>
							
					<div class="phone_number_content">
						<div class="phonenumber_prim hide">
					
							<div class="field_mobile primary" id="mobile_num_0" onclick="for_mobile_specific('mobile_num_0')">
								<span class="mobile_dp icon-call"></span>
								<span class="mobile_info">
									<div class="emailaddress_text" id="primary_mobid"></div>
									<div class="emailaddress_addredtime" id="prim_mob_time"></div>
									<div class="emailaddress_addredtime primary_dot" title="Primary"><@i18n key="IAM.EMAIL.PRIMARY.PHONE" /></div>
								</span>
								
								<div class="phnum_hover_show" id="phonenumber_info0">
									<span class="action_icons_div_ph">
									<span class="deleteicon action_icon icon-delete" id="ph_icon_delete_0" title="<@i18n key="IAM.REMOVE" />" ></span>
									</span>
								</div>
							</div>
							
						</div>
						
						<div class="phonenumber_sec"></div>
						
						<div class="phonenumber_unverfied"></div>
					</div>
					
					
					<div id="phone_add_view_more" class="hide">
						<div class="icon-showall half" id="view_only" onclick="show_all_phonenumbers()"><span><@i18n key="IAM.VIEWMORE.INFO" /></span></div> 
						
						<div class="addnew half" id="addphone" onclick="show_add_mobilescreen('<@i18n key="IAM.ADD.PHONE.NUMBER" />','<@i18n key="IAM.PROFILE.PHONENUMBERS.ADD.NUMBER.DESCRIPTION" />','<@i18n key="IAM.ADD" />','addphonenum');"><@i18n key="IAM.ADD.PHONE.NUMBER" /></div>
						<div class="addnew half" id="addTFAphone" onclick="show_tfa_switch_mobilescreen();"><@i18n key="IAM.ADD.PHONE.NUMBER" />	</div>				
					</div>
					
					<div class="addnew separate_addnew hide" id="addphoneonly" onclick="show_add_mobilescreen('<@i18n key="IAM.ADD.PHONE.NUMBER" />','<@i18n key="IAM.PROFILE.PHONENUMBERS.ADD.NUMBER.DESCRIPTION" />','<@i18n key="IAM.ADD" />','addphonenum');"><@i18n key="IAM.ADD.PHONE.NUMBER" /></div>
					
					<div class="addnew separate_addnew hide" id="addTFAphoneonly" onclick="show_tfa_switch_mobilescreen();"><@i18n key="IAM.ADD.PHONE.NUMBER" /></div>					
					
				</div>
				
				
				
				
				
				<div id="empty_phone_format" class="hide">
					
					<div class="field_mobile secondary" id="sec_phoneDetails" onclick="for_mobile_specific('mobile_num_0000') ">
						
						<span class="mobile_dp icon-call"></span>   
						<span class="mobile_info">
							<div class="emailaddress_text"></div>
							<div class="emailaddress_addredtime"><@i18n key="IAM.EMAIL.UNCONFIRMED" /></div>
						</span>
						
						<div class="phnum_hover_show" id="phonenumber_infohover">   
							<span class="action_icons_div_ph">
							
								<span class="verify_icon resendconfirm Mob_resend_confirmation">
	                				<div class="icon-verify"></div>
	                				<div class="resend_options" style="display:none;">
		                				<div class="resend_space">
		                					<div class="resend_mob_text"></div>
		                					<div class="resend_grn_btn"><@i18n key="IAM.SEND.OTP" /></div>
		                				</div>
		                			</div>
	                			</span>
								<span class="resendconfir action_icon icon-makeprimary" id="icon-primary" title="<@i18n key="IAM.MYEMAIL.MAKE.PRIMARY" />" onclick="showmake_prim_mobilescreen('<@i18n key="IAM.MODIFY.LOGIN.NAME" />','<@i18n key="IAM.PROFILE.PHONENUMBERS.MAKE.PRIMARY.POPUP.DESCRIPTION" />','<@i18n key="IAM.UPDATE" />');"></span>
																
								<span class="action_icon icon-delete"  title='<@i18n key="IAM.REMOVE" />'></span>
							
							</span>
						</div>
					</div>
				
				</div>
				
				
				
				
				
				
				<div class="viewall_popup hide popupshowanimate_2" tabindex="1" id="phonenumber_web_more">
					
					<div class="box_info">
						<div class="expand_closebtn" onclick="closeview_all_phonenumber_view()"></div>
						<div class="box_head"><@i18n key="IAM.MY.PHONENUMBERS" /></div>
						<div class="box_discrption"><@i18n key="IAM.PHONENUMBERS.DEFINITION" /></div>
					</div>
					
					<div class="viewall_popup_content" id="view_all_phonenumber"></div>
					
				</div>