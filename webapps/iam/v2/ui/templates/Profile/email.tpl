
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Frameset//EN" "http://www.w3.org/TR/REC-html40/frameset.dtd">
<script type="text/javascript">
	    var i18nkeys = {
		    "IAM.PROFILE.EMAILS.MAKE.PRIMARY.DESCRIPTION" : '<@i18n key="IAM.PROFILE.EMAILS.MAKE.PRIMARY.DESCRIPTION" />'
	    };
	</script>
<#--   ADD EMAIL POPUP -->



						<div tabindex="1" class="hide popup" id="add_email_popup">
							<div class="popup_header">
								<div class="popuphead_details">
									<span class="popuphead_text"><@i18n key="IAM.EMAIL.ADDRESS.ADD" /></span>
									<span class="popuphead_define" id="create_description"><@i18n key="IAM.PROFILE.EMAILS.ADD.SECONDARY.DESCRIPTION" /></span>
									<span class="popuphead_define hide" id="email_otp_description"></span>
									<span class="hide" id="email_otp_text"><@i18n key="IAM.PROFILE.EMAILS.ADD.SECONDARY.OTP.DESCRIPTION" /></span>
								</div>
								<div class="close_btn" onclick="close_addemail_popup()"></div>
							</div>
							
							<div id="add_em_form">
					
								<form method="post" name ="addemailid" id="addemailform" onsubmit="return add_email(document.addemailid,add_email_callback);" novalidate="">
								
									<div class="" id="NEWemail_add">
										<div class="field full">
					                  		<label class="textbox_label"><@i18n key="IAM.USER.ENTER.EMAIL.PLACEHOLDER" /></label>
					                  		<input class="textbox" tabindex="1" data-validate="zform_field" autocomplete="email" name="email_id" data-limit="100" onkeypress="remove_error()" type="email">
										</div>
										
										<button class="primary_btn_check " tabindex="1" id="add_email_action" ><span><@i18n key="IAM.ADD" /></span></button>
									</div>
									
									<div class="hide" id="NEWemail_confirmation">
										<div class="field full" id="otp_emailaddress">
					                  		<label class="textbox_label"><@i18n key="IAM.VERIFY.LABEL" /></label>
					                  		<input class="textbox" tabindex="1" data-validate="zform_field" name="otp_code" autocomplete="off" id="otp_email_input" oninput="this.value = this.value.replace(/[^\d]+/g,'')" type="tel">
					                  		<div id="emailOTP_resend" class="" onclick="emailOTP_resendcode(this);"><a href="javascript:;"><@i18n key="IAM.TFA.RESEND.OTP" /> </a></div>
										</div>
										
										<button class="primary_btn_check " tabindex="1" id="add_email_action"  ><span><@i18n key="IAM.VERIFY" /></span></button>
										
									</div>
									
								</form>
							
							</div>
					</div>
		
		
<#--   Change Primary EMAIL POPUP -->	


					<div class="hide popup" tabindex="1" id="change_primaryEM">
						<div class="popup_header ">
							<div class="popuphead_details">
								<span class="popuphead_text"><@i18n key="IAM.MYEMAIL.MAKE.PRIMARY" /></span>
								<span class="popuphead_define" id="make_email_primary"><@i18n key="IAM.PROFILE.EMAILS.MAKE.PRIMARY.DESCRIPTION" /></span>
							</div>
							<div class="close_btn" onclick="close_change_primaryEM()"></div>
						</div>
						
						<div id="change_em_form">
				
							<form method="post" name="setAsPrimary" class="zform" id="Changeemailform" onsubmit="return false;" novalidate="">
							
								<div class="field full hide">
			                  		<label class="textbox_label"><@i18n key="IAM.USER.ENTER.EMAIL.PLACEHOLDER" /></label>
			                  		<input class="textbox" tabindex="1" data-validate="zform_field" autocomplete="email" name="email_id" data-limit="100" id="selectedemail" type="email">
								</div>
								
								<button class="primary_btn_check " tabindex="1" id="mkprim_email_action"><span><@i18n key="IAM.MYEMAIL.MAKE.PRIMARY" /></span></button>
								
							</form>
						
						</div>
					</div>


<#--   			Mobile Email Option Popup				-->
					
					<div class="hide popup" tabindex="1" id="Email_popup_for_mobile">
					    <div class="popup_header popup_header_for_mob">
							<div class="popuphead_details">
							</div>
						    <div class="close_btn" onclick="close_for_mobile_specific()"></div>
					    </div>
					    <div class="mob_popu_btn_container">
					        <button id="btn_to_resend" onclick=""><span class="icon-verify"></span><span><@i18n key="IAM.MSG.POPUP.SENDMAIL.TEXT" /></span></button>
					        <button class id="btn_to_chng_primary" onclick="show_mob_conform('primary','<@i18n key="IAM.PROFILE.PHONENUMBERS.MAKE.PRIMARY.DESCRIPTION" />')"><span class="icon-makeprimary"></span><span><@i18n key="IAM.MYEMAIL.MAKE.PRIMARY" /></span></button>
					        <button id="btn_to_edit"><span class="icon-edit"></span><span>Edit</span></button>
					        <button id="btn_to_delete" onclick="show_mob_conform('delete')"><span class="icon-delete"></span><span><@i18n key="IAM.REMOVE" /></span></button>
					    </div>
					    <div class="option_container">
					    	<div class="mob_popuphead_define">
					    		
					    	</div>
					    	<div class="option_button">
						        <button id="action_granted"><@i18n key="IAM.CONTINUE"/></button>
						        <button id="" onclick="close_for_mobile_specific()"><@i18n key="IAM.CANCEL" /></button>
					    	</div>
					    	<div class="otp_mobile_form">
					    	<form name="resend_otp_ver_form" id="resend_otp_ver_form" onsubmit="return false;">
					    		<input type="text" id="email_conf_input" read-only style="display:none;" name="email_id">
					    		<div class="field full" id="otp_emailaddress">
					            	<label class="textbox_label"><@i18n key="IAM.VERIFY.LABEL" /></label>
					            	<input class="textbox" tabindex="1" onkeypress="remove_error()" data-validate="zform_field" name="otp_code" autocomplete="off" oninput="this.value = this.value.replace(/[^\d]+/g,'')" id="otp_email_input" type="text">
					            	<div id="emailOTP_resend" class="" onclick="emailOTP_resendcode(this);"><a href="javascript:;"><@i18n key="IAM.TFA.RESEND.OTP" /></a></div>
								</div>
								<button id="action_otp_conform" onclick="return confirm_add_email(document.otp_form_in_viewall,resendEmailConfirmLink_mobile_callback)"><@i18n key="IAM.EMAIL.VERIFY"/></button>
								<button id="" onclick="close_for_mobile_specific()"><@i18n key="IAM.CANCEL" /></button>
					    	</form>
					    	</div>
					    </div>
					</div>
					

<#--   			The UI BOX				-->
    




				<div class="box big_box" id="email_box">
				
							<div class="box_blur"></div>
							<div class="loader"></div>
				
					<div class="box_info">
						<div class="box_head"><@i18n key="IAM.MYEMAIL.ADDRESS" /></div>
						<div class="box_discrption mob_hide"><@i18n key="IAM.MYEMAIL.DESCRIPTION" /></div>
					</div>
					
					<div id="no_email_add_here" class="box_content_div hide">
						<div class="no_data no_data_SQ"></div>
						<div class="no_data_text hide"><@i18n key="IAM.EMAIL.LIST.EMPTY" /> </div>
						<a class="primary_btn_check  center_btn " onclick="showaddemail_popup();" ><span><@i18n key="IAM.EMAIL.ADDRESS.ADD" /></span></a>
			 		</div>
			 		
			 		
					<div id="email_content" class="hide">
						
						<div class="emailID_prim hide" id="emailID_prim">
						
							<!-- PRIMARY EMAIL -->	
							<div class="field_email primary" id="emailID_num_0" onclick="">
													
								<span class="email_dp icon-email"></span>
								<span class="email_info">
									<div id="primary_emailid" class="emailaddress_text"></div>
									<div  id="PrimConfim" class="hide red emailaddress_addredtime"><@i18n key="IAM.EMAIL.UNCONFIRMED" /></div>	
									<div id="prim_em_time" class="emailaddress_addredtime"></div>	
									<div class="emailaddress_addredtime primary_dot" title="Primary"><@i18n key="IAM.EMAIL.PRIMARY.EMAIL" /></div>
								</span>
							
							<!-- PRIMARY EMAIL HOVER SECTION -->
								<div id="emailID_info0" class="email_hover_show">
									<span class="action_icons_div">
										
										<span class="verify_icon resendconfir  EMresend_confirmation" id="em_icon_resend_0">
											<div class="icon-verify"></div>
											<div id="resend_0" class="resend_options" style="display:none">
												<div class="resend_space">
													<div class="resend_em_text"></div>
													<div class="resend_grn_btn"><@i18n key="IAM.MSG.POPUP.SENDMAIL.TEXT" /></div>
												</div>
											</div>
											
										</span>
										
										<span class="deleteicon action_icon icon-delete" id="em_icon_delete_0" title="<@i18n key="IAM.REMOVE" />" ></span>
									</span>
								</div>
								
							</div>
							
						</div>
					
						<div class="emailID_sec ">
		        
						</div>
					
					</div>
					
					<div id="email_add_view_more" class="hide">
						<div class="icon-showall half" onclick="show_all_emails()"><span><@i18n key="IAM.VIEWMORE.INFO" /></span></div>   
						<div class="addnew half " onclick="showaddemail_popup();" ><@i18n key="IAM.EMAIL.ADDRESS.ADD" /></div>
					</div>
					
					<div class="addnew hide" id="email_justaddmore" onclick="showaddemail_popup();" ><@i18n key="IAM.EMAIL.ADDRESS.ADD" /></div>
					<div class="icon-showall hide" id="email_justview" onclick="show_all_emails()"><span><@i18n key="IAM.VIEWMORE.INFO" /></span></div>
				
				</div>


    
    			
             	<div class="viewall_popup hide popupshowanimate_2" tabindex="1" id="emails_web_more">
					
					<div class="box_info">
						<div class="expand_closebtn" onclick="closeview_all_email_view()"></div>
						<div class="box_head"><@i18n key="IAM.MYEMAIL.ADDRESS" /></div>
						<div class="box_discrption"><@i18n key="IAM.MYEMAIL.DESCRIPTION" /></div>
					</div>
					
					<div class="viewall_popup_content" id="view_all_email">
					</div>
				</div>
                

                
               	
               <div id="empty_secondary_format" class="hide">
               
	                <div class="field_email secondary" id="sec_emailDetails">
	                	
	                	<span class="email_dp icon-email"></span>
	                	<span class="email_info"> 
	                		<div class="emailaddress_text"></div>
	                		 <div id="secondary_unconfirmed" class="hide red emailaddress_addredtime"><@i18n key="IAM.EMAIL.UNCONFIRMED" /></div>	
	                		 <div id="secondary_time" class="emailaddress_addredtime"></div>
	                	</span>
	                	
	                	<div class="email_hover_show">
	                		<div class="action_icons_div">
	                			<span class="verify_icon resendconfir EMresend_confirmation">
	                				<div class="icon-verify"></div>
	                				<div class="resend_options" style="display:none;">
		                				<div class="resend_space">
		                					<div class="resend_em_text"></div>
		                					<div class="resend_grn_btn"><@i18n key="IAM.MSG.POPUP.SENDMAIL.TEXT" /></div>
		                				</div>
		                			</div>
	                			</span>
	    
	                				                			
	                			<span class="mkeprimary action_icon icon-makeprimary" title="<@i18n key="IAM.MYEMAIL.MAKE.PRIMARY" />"></span>
	                			
	                			
	                			<span class="deleteicon hide action_icon icon-delete" title="<@i18n key="IAM.REMOVE" />" ></span>
	                		
	                		</div>
	                	</div>
	                	
	                </div>
                	
                </div>
                
                