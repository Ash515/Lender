<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Frameset//EN" "http://www.w3.org/TR/REC-html40/frameset.dtd">

	<div class="hide popup" tabindex="1" id="popup_password_change">
		
		<div class="popup_header ">
			<div class="popuphead_details">
				<span class="popuphead_text"></span>
				<span class="popuphead_define"></span>
			</div>
			<div class="close_btn" onclick="close_password_change()"></div>
		</div>
		
		<div class="change_pass_cont">
			
			<form id=passform name=passform onsubmit="return false;">
			
				<div id="change_password_desc" class="hide">
					<span class="heading"><@i18n key="IAM.PASSWORD" /></span>
					<span class="description"><@i18n key="IAM.PASSWORD.CHANGE.DECRIPTION" /></span>
				</div>
				
				<div id="change_first">	
					<div class="field full" id="curr_password">
						<div class="textbox_label "><@i18n key="IAM.CURRENT.PASS" /></div>
						<input class="textbox" tabindex="1" autocomplete="off" onkeypress="remove_error()" data-validate="zform_field" name="currentPass" type="password">
						
						<#if ValidPrimaryEmail>
	              			<a class="blue" tabindex="1" onclick="goToForgotPwd();"><@i18n key="IAM.FORGOT.PASSWORD" /></a>
	              		</#if>
					</div>
					<div class="field full" id="new_password">
						<div class="textbox_label "><@i18n key="IAM.NEW.PASS" /> </div>
						<input class="textbox" tabindex="1" autocomplete="off" id="newPassword" type="password" data-validate="zform_field" name="newPassword">
						<span class="pass_icon" onclick="togglePass(this)"></span>
						<div id="pass_policy" class="pass_policy"></div>
						<div class="pass_policy_error"></div>
					</div>
					<div class="field full" id="new_repeat_password">
						<div class="textbox_label "><@i18n key="IAM.CONFIRM.PASSWORD" /></div>
						<input class="textbox" tabindex="1" autocomplete="off" onkeypress="remove_error()" name="cpwd" type="password">
					</div>
					
					<button  class="primary_btn_check " tabindex="1" onclick="changepassword(document.passform)" id="change_password_call" ><span><@i18n key="IAM.PASSWORD.CHANGE" /></span></button>

				</div>
			</form>
			
			<form id="pass_esc_devices" name="pass_esc_devices" class="hide" onsubmit="return signout_devices(this)">
				<div  id="change_second">
				
				<div id="quit_session_desc" class="hide">
					<span class="heading"><@i18n key="IAM.PASSWORD.QUITSESSIONS.HEAD" /></span>
					<span class="description"><@i18n key="IAM.PASSWORD.QUITSESSIONS.DECRIPTION" /></span>
				</div>
					
					<div class="checkbox_div" style="margin:10px 0px 20px 0px;">
						<input data-validate="zform_field" id="ter_all" name="clear_web" class="checkbox_check" type="checkbox">
						<span class="checkbox">
							<span class="checkbox_tick"></span>
						</span>
						<label for="ter_all" class="checkbox_label"><@i18n key="IAM.RESET.PASSWORD.SIGNOUT.WEB" /></label>
					</div>
					<div class="checkbox_div" style="margin:10px 0px 20px 0px;">
						<input data-validate="zform_field" id="ter_mob" name="clear_mobile" class="checkbox_check" type="checkbox">
						<span class="checkbox">
							<span class="checkbox_tick"></span>
						</span>
						<label for="ter_mob" class="checkbox_label big_checkbox_label"><@i18n key="IAM.RESET.PASSWORD.SIGNOUT.MOBILE.SESSION" /></label>
					</div>
					<div class="checkbox_div" style="margin:0px;">
						<input data-validate="zform_field" id="ter_apiToken" name="clear_apiToken" class="checkbox_check" type="checkbox">
						<span class="checkbox">
							<span class="checkbox_tick"></span>
						</span>
						<label for="ter_apiToken" class="checkbox_label big_checkbox_label"><@i18n key="IAM.RESET.PASSWORD.DELETE.APITOKENS" /></label>
					</div>
					<button  class="primary_btn_check " ><span><@i18n key="IAM.CONTINUE" /></span></button>
					
				</div>
			</form>
		
		</div>
		
	</div>
	
	
	
	
	
	
	<div class="box big_box" id="password_box">
	
			<div class="box_blur"></div>
			<div class="loader"></div>
					
		<div class="box_info">
			<div class="box_head"><@i18n key="IAM.PASSWORD" /><span class="icon-info"></span></div>
			<div class="box_discrption hide" id="password_def"><@i18n key="IAM.PASSWORD.CHANGE.DEFINITION" /></div>
			<div class="box_discrption hide" id="NO_password_def"><@i18n key="IAM.NO.PASSWORD.DEFINITION" /></div>
			<div class="box_discrption hide" id="contact_superadmin_def"><@i18n key="IAM.PASSWORD.SAML.AUTHENTICATION" /></div>	
			<div class="box_discrption" id="no_pp"><@i18n key="IAM.PASSWORD.CHANGE.DEFINITION" /></div>
			<div class="box_discrption hide" id="yes_pp"><@i18n key="IAM.PASSWORD.CHANGE.INFO.ORG" /></div>
			<div class="box_discrption hide" id="yes_pp_exp_one"><@i18n key="IAM.PASSWORD.CHANGE.INFO.ORG.PASSWORD.EXPIRY.ONE.DAY" /></div>
			<div class="box_discrption hide" id="yes_pp_exp"><@i18n key="IAM.PASSWORD.CHANGE.INFO.ORG.PASSWORD.EXPIRED" /></div>
		</div>
		
		<div class="box_content_div">
		<div class="no_data no_pass"></div>
		
		<div class="yes_data_text hide" id="previous_modified_time" ><span id="password_time_sring"></span></div>				
				
		<div class="no_data_text hide" id="IDP_password" ><@i18n key="IAM.PASSWORD.IDPUSER.DESC" arg0="${IDP_Name}"/> </div>
		<div class="no_data_text hide" id="contact_superadmin_msg" ><@i18n key="IAM.PASSWORD.CONTACT.ADMIN" /> </div>
		<div class="no_data_text hide" id="passwordSyncURL" ><@i18n key="IAM.PASSWORD.SYNC_REDIRECT" /> </div>
		
		<button class="primary_btn_check center_btn hide" id="change_passwordbutton"><@i18n key="IAM.PASSWORD.CHANGE" /></span></button>
		<button class="primary_btn_check center_btn hide" id="new_passwordbutton"><@i18n key="IAM.PASSWORD.CREATE" /></span></button>
		</div>

	</div>

		
	
	
	