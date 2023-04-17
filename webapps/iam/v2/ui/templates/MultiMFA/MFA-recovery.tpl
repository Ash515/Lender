
		
		<!-- TFA Backup Codes Remainder -->
		
		<div class="hide popup" tabindex="1" id="backupcodes_NOTICE">
			
			<div class="popup_header ">
				<div class="popuphead_details">
					<span class="popuphead_text"><@i18n key="IAM.TFA.BACKUP.ACCESS.CODES" /> </span>
					<span class="popuphead_define"><@i18n key="IAM.LIST.BACKUPCODES.NOTICE" /> </span>
				</div>
				<div class="close_btn" onclick="close_tfa_backupcode_NOTICE()"></div>
			</div>
			
			
			<div class="tfa_verify_butt" >					  
  	  			<button class="primary_btn_check " tabindex="1" onclick="show_backupcodes()" ><span><@i18n key="IAM.TFA.GENERATE.NEW_CODES" /> </span></button>
	    	</div>
	    	
		</div>
			
			
			
		<div class="box hide" id="recovery_space">
		
			<div class="box_info">
				<span class="reduce_width">
				<div class="box_head"><@i18n key="IAM.MFA.RECOVERY.OPTION" /></div>
				<div class="box_discrption"><@i18n key="IAM.MULTI.MFA.RECOVERY.DESC" /></div>
			</div>
				
			<div class="option_grid">
				
				<div id="tfa_bk_new_space" class="hide">
					<div class="tfa_sub_head"><@i18n key="IAM.TFA.BACKUP.ACCESS.CODES" /> </div>
					<div class="tfa_sub_head_desc" id="tfa_bk_description" ><@i18n key="IAM.TFA.BKP.DESCRIPTION" /></div>
					<div class="tfa_sub_head_desc" id="tfa_bk_time" ><@i18n key="IAM.TFA.BKP.GENERATED.TIME" /> <span></span></div>
					<button class="primary_btn_check circlebtn_mobile_edit " onclick="show_backupcodes()"><span><@i18n key="IAM.TFA.GENERATE.NEW" /> </span></button>
				</div>
				
			</div>
			
		</div>
		
		
				
	<!--	TFA Backup Codes Space -->
	
		<div class="backup_verficationspace hide popup" tabindex="1" id="backupcodes_tfa">
			
				<div class="popup_header ">
					<div class="popuphead_details">
						<span class="popuphead_text"><@i18n key="IAM.TFA.BACKUP.ACCESS.CODES" /> </span>
						<span class="popuphead_define"><@i18n key="IAM.LIST.BACKUPCODES.DESCRPRITION" /> </span>
					</div>
					<div class="close_btn" onclick="close_tfa_backupcode()"></div>
				</div>
				
				<div id="bkup_code_space" class="tfa_bkup_grid">
					<div id="bk_codes"></div>
					<div id="bkup_cope">
						<span class="bk_code_save" onclick="saveAsText();"><@i18n key="IAM.TFA.SAVEAS.TEXT" /> </span>
						<span class="bk_code_save" id="printcodesbutton"><@i18n key="IAM.TFA.PRINT.CODES" />  </span>
						<span class="bk_code_save hide" onclick="send_email_code();"><@i18n key="IAM.EMAIL.CONFIRMATION.SEND.EMAIL" />  </span>
					</div>
					<span class="cut_position icon-cut"></span>
				</div>
				
				<div >
					<span class="tfa_info_text"><@i18n key="IAM.GENERATE.ON" /> </span>
					<span class="tfa_info_text" id="createdtime"></span>
				</div>
				
				
				<div class="tfa_verify_butt" >					  
	  	  			<button class="primary_btn_check " tabindex="1" onclick="show_backupcodes()" ><span><@i18n key="IAM.TFA.GENERATE.NEW_CODES" /> </span></button>
					<button class="primary_btn_check high_cancel" tabindex="1" onclick="close_tfa_backupcode()"><span><@i18n key="IAM.CLOSE" /> </span></button>
		    	</div>
		    	
			</div>
			
		<!-- sending email is yet to be decided -->
			
			<form onsubmit="return false;" tabindex="1" class="hide popup" id="send_bkcode_email">
			
				<div class="popup_header ">
					<div class="popuphead_details">
						<span class="popuphead_text"><@i18n key="IAM.EMAIL.CONFIRMATION.SEND.EMAIL" /> </span>
						<span class="popuphead_define">
							<@i18n key="IAM.TFA.RECOVERY.EMAIL.SUBTXT" />
							<@i18n key="IAM.NOTE" />&nbsp;:&nbsp;<@i18n key="IAM.TFA.RECOVERY.EMAIL.WARNING" />
						</span>
					</div>
					<div class="close_btn" onclick="close_send_bkcode_emailpopup()"></div>
				</div>
				
				<div class="field full" id="tfa_email_space"> 
					<div class="textbox_label" id="tfa_confim"><@i18n key="IAM.ENTER.EMAIL" /> </div>
					<input class="textbox" data-optional="true" onkeypress="remove_error()" type="text" id="send_backup_em">
				</div>
				
				<div class="field full" id="tfa_email_space_pass"> 
					<div class="textbox_label" ><@i18n key="IAM.CURRENT.PASS" /></div>
					<input class="textbox" data-optional="true" autocomplete="off" onkeypress="remove_error()" id="send_backup_pass" type="password">
				</div>
				
				<div class="tfa_verify_butt" >					  
	  	  			<button class="primary_btn_check " onclick="sendBackupCodesEmail();" ><span><@i18n key="IAM.TFA.GENERATE.NEW_CODES" /> </span></button>
					<button class="primary_btn_check high_cancel" onclick="return close_send_bkcode_emailpopup()"><span><@i18n key="IAM.CLOSE" /> </span></button>
		    	</div>
		    	
			</form>