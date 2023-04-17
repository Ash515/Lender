<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Frameset//EN" "http://www.w3.org/TR/REC-html40/frameset.dtd">


	<div class="hide" id="popup_user-notification_contents">
	
		<form  method="post" onsubmit="return false;" novalidate>

		<#if is_password_expiry_notification>
	
			<div id="user_password_notifications" class="hide">	
			
				<div class="toggle_field">
					<div class="toggle_text"><@i18n key="IAM.USERPREFERENCE.PASSEXPIRY_NOTIFICATION" /> </div>
					<div class="togglebtn_div">
						<input class="real_togglebtn" id="password_expiry" type="checkbox">
						<div class="togglebase">
							<div class="toggle_circle"></div>
						</div>
						
					</div>
				</div>
	
			</div>
		
		</#if>
				
			<div id="user_signin_notifications" class="hide">	
			
				<div class="toggle_field">
					<div class="toggle_text"><@i18n key="IAM.SETTINGS.NOTIFICATIONS.TITLE.SIGNIN" /> </div>
					<div class="togglebtn_div">
						<input class="real_togglebtn" id="sign_in_notification" type="checkbox">
						<div class="togglebase">
							<div class="toggle_circle"></div>
						</div>
						
					</div>
					<div><@i18n key="IAM.SETTINGS.NOTIFICATIONS.TITLE.SIGNIN_DESCRIPTION" /></div>
				</div>
				
			</div>	
			
			<button class="primary_btn_check " tabindex="0" id="popup_user-notification_action" ><span></span></button>
			
		</form>
				
	</div>	
		


	<div class="box big_box" id="notification_box">
    				
		<div class="box_blur"></div>
		<div class="loader"></div>
		
		<div class="box_info">
			<div class="box_head"><@i18n key="IAM.SECURITY.NOTIFICATION.TITLE" /><span class="icon-info"></span> </div>
			<div class="box_discrption"><@i18n key="IAM.SETTINGS.NOTIFICATIONS.TITLE.DESCRIPTION" /> </div>
		</div>
		
		<div class="pref_option" id="security_notification">
			<div class="option_desc">
				<div class="option_head"><@i18n key="IAM.SETTINGS.NOTIFICATIONS.TITLE.SIGNIN" /> </div>
				<div class="option_values" id="signin_notification_value"></div>
			</div>
			<div class="edit_text"><@i18n key="IAM.EDIT" /></div>
		</div>
		
		<#if is_password_expiry_notification>
								
		<div class="pref_option" id="password_expiry" onclick="showuser_pref_notifications('<@i18n key="IAM.SETTINGS.NOTIFICATIONS.TITLE" />','<@i18n key="IAM.SETTINGS.NOTIFICATIONS.TITLE.DESCRIPTION" />','<@i18n key="IAM.UPDATE" />','save_email_notification');">
			<div class="option_desc">
				<div class="option_head"><@i18n key="IAM.SETTINGS.NOTIFICATION.HEADDING" /> </div>
				<div class="option_values" id="passexp_notification_value"></div>
			</div>
			<div class="edit_text"><@i18n key="IAM.EDIT" /></div>
		</div>
					
		</#if>
		
	</div>