




					<div class="box big_box" id="deleteacc_box">
					
						<div class="box_blur"></div>
						<div class="loader"></div>
			
						<div class="box_info">
							<div class="box_head"><@i18n key="IAM.CLOSE.ACCOUNT" /><span class="icon-info"></span></div>
							<div class="box_discrption"><@i18n key="IAM.CLOSEACCOUNT.DEFINITION" /> </div>
						</div>
						
						<div id="CloseAccount" class="box_content_div">
							<div class="no_data no_data_closeACC"></div>
							
							<div id="close_info_text">
								<div class="no_data_text hide" id="partner_info"><@i18n key="IAM.CLOSEACCOUNT.MESSAGE.FOR.PARTNERADMIN" /> </div>
								<div class="no_data_text hide" id="org_owner_info"><@i18n key="IAM.CLOSEACCOUNT.MSG.ORGOWNER" /> </div>
								<div class="no_data_text hide" id="blank_org_owner_info"><@i18n key="IAM.CLOSEACCOUNT.MSG.ORGOWNER.BLANK_ORGNAME" /> </div>
								<div class="no_data_text hide" id="contact_admin"><@i18n key="IAM.CLOSE.CONTACT.ADMIN.TEXT" /> </div>
								<div class="no_data_text hide" id="blank_org_contact_admin"><@i18n key="IAM.CLOSE.CONTACT.ADMIN.TEXT.BLANK_ORGNAME" /> </div>
								<div class="no_data_text hide" id="anti_spam"><@i18n key="IAM.REGISTER.ANTISPAM_ERROR" /> </div>
								<div class="no_data_text hide" id="downgrade_service"><@i18n key="IAM.CLOSEACCOUNT.PAYMENT_DOWNGRADE" /></div>
								<div class="no_data_text hide" id="close_acc_nopassword"><@i18n key="IAM.CLOSEACCOUNT.FEDERATED.USER_NO_PASSWORD" />  </div>
								<div class="no_data_text"><@i18n key="IAM.CLOSE.TEXT" />  </div>
							</div>
							
							<div id="close_info_button">
								<button class="primary_btn_check center_btn "  >
									<span class="hide" id="support_mail"><@i18n key="IAM.EMAIL.CONFIRMATION.SEND.EMAIL" /> </span>
									<span class="hide" id="org_cancel"><@i18n key="IAM.CANCEL.ORG" />  </span>
									<span class="hide" id="unsubcribe"><@i18n key="IAM.GROUP.UNSUBCRIBE" /> </span>
									<span class="hide" id="close_acc_reset_pass"><@i18n key="IAM.RESET.PASSWORD" /></span>
									<span><@i18n key="IAM.CLOSE.ACCOUNT" /></span>
								</button>
							
							</div>
							
		 				</div>
		 				
		 			</div>
		 			
		 			
		 			
		 			
		 		<div class="hide popup" id="popup_deleteaccount_close" tabindex="1">
					<div class="popup_header ">
						<div class="popuphead_details">
							<span class="popuphead_text"><@i18n key="IAM.CLOSE.ACCOUNT" /></span>
							<span class="popuphead_define"><@i18n key="IAM.CLOSEACCOUNT.DEFINITION" /></span>
						</div>
						<div class="close_btn" onclick="close_deleteaccount()"></div>
					</div>
					<div id="delete_acc_final">
					
						<form id=closeform name=closeform onsubmit="return false" >
							
							
							
							<div class="field full noindent">
		                  		<label class="textbox_label"><@i18n key="IAM.CLOSE.CLOSING_REASON" /></label>
								<select class="select_field" data-validate="zform_field" name="reason" id="delete_acc_reason" >

										<option value="NOT_HAPPY"><@i18n key="IAM.NOT.HAPPY" /></option>
										<option value="NOT_USEFUL"><@i18n key="IAM.NOT_USEFUL" /></option>
										<option value="MOVING_TO_ALTERNATIVE"><@i18n key="IAM.CLOSE.MOVE_ALTERNATE" /></option>
	
								</select>
							</div>
							
							<div class="field full" >
		                  		<label class="textbox_label"><@i18n key="IAM.CLOSE.ACCOUNT.FEEDBACK" /></label>

								<textarea class="deleteacc_cmnd" tabindex="0" data-limit="250" data-validate="zform_field" name="comments" placeholder="feedback"></textarea>

							</div>
							<div class="close_account_warn"><@i18n key="IAM.CLOSEACCOUNT.RELOGIN.DESCRIPTION" /></div>
							
							<button class="primary_btn_check" tabindex="0" id="confirm_close_account" onclick="CLOSE_ACCOUNT();" ><span><@i18n key="IAM.CLOSE.ACCOUNT" /></span></button>
							<button class="primary_btn_check high_cancel" tabindex="0" onclick="close_deleteaccount();" ><span><@i18n key="IAM.CANCEL" /></span></button>
						</form>

					</div>
				</div>
				
				
				
				
				
				
				<div class="hide popup" id="popup_deleteaccount_downgrade">
					<div class="popup_header ">
						<div class="popuphead_details">
							<span class="popuphead_text"><@i18n key="IAM.CLOSE.ACCOUNT" /></span>
							<span class="popuphead_define"><@i18n key="IAM.CLOSEACCOUNT.PAYMENT_DOWNGRADE" /> </span>
						</div>
						<div class="close_btn" onclick="close_downgradepopup()"></div>
					</div>
					<div id="delete_acc_info">
					</div>
				</div>
				
				
				<div id="empty_app_format" class="hide">
					    
					    <div class="Field_session" id="service_info"> 
							<div class="info_tab">	
								<div class="authtoken_div">
									<span class="authtoken_pic product_icon"></span>
									<span class="authtoken_details closeacc_name">
										<span class="authtoken_name"></span>
									</span>
								</div>
							</div>
						</div>
						
				</div>
				
				
				