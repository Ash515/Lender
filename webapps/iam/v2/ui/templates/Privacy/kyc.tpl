<#if (showGDPRDPAPage == 1) >	
		<div class="box big_box" id="">
		
			<div class="box_info">
				<div class="box_head"><@i18n key="IAM.GDPR.KYC.NAV.SUBHEAD" /><span class="icon-info"></span></div>
				<div class="box_discrption" style="max-width: calc(100% - 210px)"><@i18n key="IAM.PRIVACY.KYC.DESC" /></div>
				<div class="kyc_org">
					<div class="field textbox_div textbox_inline">
						<select class="profile_mode" onchange="loadKycOrgDetails()" id="kyc_org_list">
				
						</select>
					</div>
				</div>
			</div>
			
			<div class="hide" id="exception_page_privacy">
				<div id="bad_net">
					<div id="" class="no_data_exception"></div>
					<div class="no_data_text" id="exception_page_txt"><@i18n key="IAM.PLEASE.CONNECT_INTERNET"/></div>
					<button class="primary_btn_check center_btn" id="reload_exception_page" onclick="document.location.reload()"><span><@i18n key="IAM.EXCEPTION.RELOAD"/></span></button>
				</div>
			</div>
			
			<div id="no_kyc" class="box_content_div hide">
					<div class="no_data no_data_SQ"></div>
					<select id="kycOptionButton" onchange="selectKycOption(this)">
						<option value="0"><@i18n key="IAM.ADD"/></option>
						<option value="2"><@i18n key="IAM.PRIVACY.KYC.ADD.PERSONAL.DETAIL"/></option>
						<option value="1"><@i18n key="IAM.PRIVACY.KYC.ADD.PERSONAL.CONTACT"/></option>
					</select>
		 	</div>
		 	
		 	<div class="addnew" id="merge_contact_btn" onclick="showContactMerge()"><@i18n key="IAM.PRIVACY.KYC.ADD.EXISTING.CONTACT"/></div>
		 	
		 	<div class="contact_details">
		 		<div class="personal_detail">
		 			<div class="kyc_subhead"><@i18n key="IAM.PRIVACY.KYC.POPUP.HEADER.PERSONAL"/><span class="sub_head_border"></span></div>
		 			<div class="detail_template hide">
						<span class="name_detail detail_divide_div">
							<div class="title_text"><@i18n key="IAM.NAME"/></div>
							<div class="detail_text contact_name">
								<span class="f_name"></span> <span class="l_name"></span>
							</div>
						</span>
						<div class="detail_divide_div mail_detail">
							<div class="title_text"><@i18n key="IAM.PRIVACY.KYC.POPUP.DESIGNATION"/></div>
							<div class="detail_text contact_mail"></div>
						</div>
						<div class="detail_divide_div mail_detail">
							<div class="title_text"><@i18n key="IAM.EMAIL.ADDRESS"/></div>
							<div class="detail_text email_id"></div>
						</div>
						<div class="detail_divide_div mobile_detail">
							<div class="title_text"><@i18n key="IAM.MOBILE.NUMBER"/></div>
							<div class="detail_text mob_number"></div>
						</div>
		 			</div>
		 			<div class="personal_info_empty kyc_empty_blocks hide">
		 				<div class="no_data no_data_SQ">
		 					
		 				</div>
		 				<div class="addnew" onclick="showKycForm('edit')"><@i18n key="IAM.PRIVACY.KYC.ADD.PERSONAL.DETAIL"/></div>
		 			</div>
		 			<div class="detail_container">
		 				
		 			</div>
					<div class="addnew kyc_blue_btn" onclick="showKycForm('edit')"><@i18n key="IAM.PRIVACY.KYC.DETAILS.BUTTON.EDIT"/></div>
		 		</div>
		 		<div class="org_detail">
		 			<div class="kyc_subhead"><@i18n key="IAM.PRIVACY.KYC.POPUP.HEADER.ORG"/><span class="sub_head_border"></span></div>
		 			<div class="org_info_empty kyc_empty_blocks hide">
		 				<div class="no_data no_data_SQ">
		 					
		 				</div>
		 				<div class="addnew" onclick="showKycForm('edit')"><@i18n key="IAM.PRIVACY.KYC.ADD.PERSONAL.DETAIL"/></div>
		 			</div>
		 			<div class="detail_template hide">
						<span class="name_detail detail_divide_div">
							<div class="title_text"><@i18n key="IAM.ORGANIZATION.NAME"/></div>
							<div class="contact_name detail_text">
								<span class="f_name org_name"></span>
							</div>
						</span>
						<div class="detail_divide_div mobile_detail">
							<div class="title_text"><@i18n key="IAM.PRIVACY.KYC.POPUP.ORG.NUMBER_OF_EMPLOYEES"/></div>
							<div class="detail_text contact_mail"><span class="emp_count"></span> <span><@i18n key="IAM.PRIVACY.KYC.EMPLOYEES"/></span></div>
						</div>
						<div class="detail_divide_div">
							<div class="title_text"><@i18n key="IAM.PRIVACY.KYC.POPUP.ORG.INDUSTRY.TYPE"/></div>
							<div class="detail_text indus_type"></div>
							<input type="hidden" value="MANUFACTURING" class="indus_type_val">
						</div>
						<div class="detail_divide_div indus_address_div">
							<div class="title_text"><@i18n key="IAM.PRIVACY.KYC.ADDRESS"/></div>
							<div class="detail_text indus_address">
								<span class="st_name"></span>
								<span class="city_name"></span>
								<span class="state"></span>
								<span class="country"></span>
								<span class="p_code"></span>
							</div>
						</div>
		 			</div>
		 			<div class="detail_container">
		 				
		 			</div>
					<div class="addnew kyc_blue_btn" onclick="showKycForm('edit')"><@i18n key="IAM.PRIVACY.KYC.DETAILS.BUTTON.EDIT"/></div>
		 		</div>
		 		<div class="privacy_contacts">
		 			<div class="kyc_subhead"><@i18n key="IAM.PRIVACY.KYC.POPUP.HEADER.PRIVACY"/><span class="sub_head_border"></span></div>
		 			<div class="detail_template hide">
		 				<div class="email_dp"></div>
						<span class="name_detail detail_divide_div">
							<div class="contact_name">
								<span class="f_name"></span> <span class="l_name"></span>
							</div>
							<div class="contact_mail"></div>
						</span>
						<div class="role_type">
							<span class="dpo"><@i18n key="IAM.GDBR.DPA.POPUP.ADD.CONTACT.ROLE.DPO"/></span>
							<span class="priv_rep"><@i18n key="IAM.GDBR.DPA.POPUP.ADD.CONTACT.ROLE.PRIVACY.REP"/></span>
							<span class="adr"><@i18n key="IAM.GDBR.DPA.POPUP.ADD.CONTACT.ROLE.ACCOUNT.DISPUTE.RESOLUTION"/></span>
							<span class="breach_notif"><@i18n key="IAM.GDBR.DPA.POPUP.ADD.CONTACT.NOTIFICATION.BREACH.NOTIFICATION"/></span>
							<span class="subprocessor_notif"><@i18n key="IAM.GDBR.DPA.POPUP.ADD.CONTACT.NOTIFICATION.SUBPROCESSOR.MODIFY.NOTIFICATION"/></span>
						</div>
		 			</div>
		  			<div class="detail_container">
		 				
		 			</div>
					<div id="add_with_viewmore" class="kyc_blue_btn hide">
						<div class="icon-showall half" onclick="view_all_contacts()"><span><@i18n key="IAM.VIEWMORE.INFO"/><span></div>   
						<div class="addnew half" onclick="showKycForm('edit')" ><@i18n key="IAM.PRIVACY.KYC.ADD.CONTACT" /></div>
					</div>
					<div class="only_add addnew kyc_blue_btn hide" onclick="showKycForm('edit')" ><@i18n key="IAM.PRIVACY.KYC.ADD.CONTACT" /></div>
		 		</div>
		 	</div>	
		 
		</div>
		
		<div class="popup kyc_popup hide" id="kyc_form_popup" tabindex="1">
			<div class="popup_header">
				<div class="popuphead_text"><@i18n key="IAM.GDPR.KYC.NAV.SUBHEAD"/></div>
				<div class="close_btn" onclick="closeKycForm()"></div>
				<div class="slide_header">
					<span class="head personal" onclick="kycFormChange(this,false)"><@i18n key="IAM.PRIVACY.KYC.POPUP.HEADER.PERSONAL"/></span>
					<span class="head org_detail" onclick="kycFormChange(this,true)"><@i18n key="IAM.PRIVACY.KYC.POPUP.HEADER.ORG"/></span>
					<span class="head priv_detail" onclick="kycFormChange(this,true)"><@i18n key="IAM.PRIVACY.KYC.POPUP.HEADER.PRIVACY"/></span>
					<span class="high_light_border"></span>
				</div>
			</div>
			<div class="form_place">
				<form name="personal" class="kyc_personal_form" onsubmit="return false;">
					<div style="display:flex;flex-wrap:wrap">
					<div class="textbox_div textbox_inline">
						<label class="textbox_label"><@i18n key="IAM.GENERAL.FIRSTNAME"/></label>
						<input type="text" name="fname" onkeypress="remove_error(this)" class="textbox" >
					</div>
					<div class="textbox_div textbox_inline">
						<label class="textbox_label"><@i18n key="IAM.GENERAL.LASTNAME"/></label>
						<input type="text" name="lname" onkeypress="remove_error(this);" class="textbox" >
					</div>
					<div class="textbox_div textbox_inline">
						<label class="textbox_label"><@i18n key="IAM.EMAIL.ADDRESS"/>&#42;</label>
						<input type="text" name="email" onkeypress="remove_error(this)" onkeyup="checkMYC_FormField(true)" class="textbox" >
					</div>
					<div class="textbox_div textbox_inline">
						<label class="textbox_label"><@i18n key="IAM.MOBILE.NUMBER"/></label>
						<input type="text" name="mobile" onkeypress="remove_error(this)" onkeyup="checkMYC_FormField(true)" class="textbox" >
					</div>
					<div class="textbox_div textbox_inline">
						<label class="textbox_label"><@i18n key="IAM.PRIVACY.KYC.POPUP.DESIGNATION"/>&#42;</label>
						<input type="text" name="designation" onkeypress="remove_error(this)" onkeyup="checkMYC_FormField(true)" class="textbox" >
					</div>
					</div>
					<button class="primary_btn_check" onclick="kycFormChange('.slide_header .org_detail',true);" id=""><span><@i18n key="IAM.NEXT"/></span></button>

				</form>
				<form name="organization" class="kyc_org_form" onsubmit="return false;">
					<div style="display:flex;flex-wrap:wrap">
					<div class="textbox_div textbox_inline">
						<label class="textbox_label"><@i18n key="IAM.ORGANIZATION.NAME"/></label>
						<input type="text" name="org_name" onkeypress="remove_error(this)" onkeyup="checkMYC_FormField(true)" class="textbox" >
					</div>
					<div class="textbox_div textbox_inline">
						<label class="textbox_label"><@i18n key="IAM.PRIVACY.KYC.POPUP.ORG.NUMBER_OF_EMPLOYEES"/></label>
						<input type="text" name="number_of_emp" onkeypress="remove_error(this)" onkeyup="checkMYC_FormField(true)" class="textbox" >
					</div>
					<div class="field textbox_div textbox_inline">
						<label class="textbox_label"><@i18n key="IAM.PRIVACY.KYC.POPUP.ORG.INDUSTRY.TYPE"/></label>
						<select class="profile_mode" name="industry_type" id="industry_type">
                   			<option value="MANUFACTURING"><@i18n key="IAM.PRIVACY.KYC.POPUP.ORG.INDUSTRY.MANUFACTURING"/></option>
                   			<option value="PRODUCTION"><@i18n key="IAM.PRIVACY.KYC.POPUP.ORG.INDUSTRY.PRODUCTION"/></option>
                   			<option value="SOFTWARE"><@i18n key="IAM.PRIVACY.KYC.POPUP.ORG.INDUSTRY.SOFTWARE"/></option>
                   			<option value="FINANCIAL"><@i18n key="IAM.PRIVACY.KYC.POPUP.ORG.INDUSTRY.FINANCIAL"/></option>
                   			<option value="TRANSPORT"><@i18n key="IAM.PRIVACY.KYC.POPUP.ORG.INDUSTRY.TRANSPORT"/></option>
                   			<option value="HEALTHCARE"><@i18n key="IAM.PRIVACY.KYC.POPUP.ORG.INDUSTRY.HEALTHCARE"/></option>
                   			<option value="FOOD"><@i18n key="IAM.PRIVACY.KYC.POPUP.ORG.INDUSTRY.FOOD"/></option>
                   			<option value="EDUCATION"><@i18n key="IAM.PRIVACY.KYC.POPUP.ORG.INDUSTRY.EDUCATION"/></option>
						</select>
					</div>
					<div class="textbox_div textbox_inline">
						<label class="textbox_label"><@i18n key="IAM.GDPR.DPA.ADDRESS.STREET_NAME"/></label>
						<input type="text" name="area" onkeypress="remove_error(this)" class="textbox" >
					</div>
					<div class="textbox_div textbox_inline">
						<label class="textbox_label"><@i18n key="IAM.GDPR.DPA.ADDRESS.CITY"/></label>
						<input type="text" name="city" onkeypress="remove_error(this)" class="textbox" >
					</div>
					<div class="textbox_div textbox_inline">
						<label class="textbox_label"><@i18n key="IAM.GDPR.DPA.ADDRESS.STATE"/></label>
						<input type="text" name="state" onkeypress="remove_error(this)" class="textbox" >
					</div>
					<div class="field textbox_div textbox_inline">
						<label class="textbox_label"><@i18n key="IAM.GDPR.DPA.COMPANY.NAME.REGISTERATION.COUNTRY"/></label>
						<select name="kycCn" class="profile_mode" id="kyc_country">
							<#list Countries as countrydata>
                          		<#assign count_data=countrydata.data >
                          		<option value="${count_data.ISO2_CODE}" id="${count_data.ISO2_CODE}" >${count_data.DISPLAY_NAME}</option>
                           	</#list>
						</select>
					</div>
					<div class="textbox_div textbox_inline">
						<label class="textbox_label"><@i18n key="IAM.GDPR.DPA.ADDRESS.Z_CODE"/></label>
						<input type="text" name="z_code" onkeypress="remove_error(this)" onkeyup="checkMYC_FormField(true)" class="textbox" >
					</div>
					</div>
					<button class="primary_btn_check" onclick="kycFormChange('.slide_header .priv_detail',true);" id=""><span><@i18n key="IAM.NEXT"/></span></button>
					<button class="primary_btn_check high_cancel" onclick="kycFormChange('.slide_header .personal',false);" id=""><span><@i18n key="IAM.BACK"/></span></button>
				</form>
				
				<div class="kyc_contact_container contact_storage hide">
				</div>
				<div class="addnew new_contact_kyc hide" onclick="showKycContactForm()"><@i18n key="IAM.PRIVACY.POP.ADD.ANOTHER.CONTACT"/></div>
				
				<form name="contacts" class="kyc_contacts_form" onsubmit="return false;">
					<div class="textbox_div textbox_inline">
							<label class="textbox_label"><@i18n key="IAM.GENERAL.FIRSTNAME"/></label>
							<input type="text" name="fname" onkeypress="remove_error(this)" class="textbox" >
						</div>
						<div class="textbox_div textbox_inline">
							<label class="textbox_label"><@i18n key="IAM.GENERAL.LASTNAME"/></label>
							<input type="text" name="lname"  onkeypress="remove_error(this)" class="textbox" >
						</div>
						<div class="textbox_div textbox_inline">
							<label class="textbox_label"><@i18n key="IAM.EMAIL.ADDRESS"/>&#42;</label>
							<input type="text" name="email" onkeypress="remove_error(this)" class="textbox" >
						</div>
						<div class="privacy_role_box">
							<div class="privacy_roles role_box">
								<div class="privacy_role_head"><@i18n key="IAM.GDBR.DPA.POPUP.ADD.CONTACT.ROLES"/></div>
								<div class="textbox_div" id="" onclick="">
									<input id="kyc_dpo_role" name="dpo_role" onchange="removeCheckbox_err()" class="checkbox_check" type="checkbox">
									<span class="checkbox">
										<span class="checkbox_tick"></span>
									</span>
									<label for="kyc_dpo_role" class="checkbox_label"><@i18n key="IAM.GDBR.DPA.POPUP.ADD.CONTACT.ROLE.DPO"/></label>
								</div>
								<div class="textbox_div" id="" onclick="">
									<input id="kyc_privacy_rep_role" name="privacy_rep_role" onchange="removeCheckbox_err()" class="checkbox_check" type="checkbox">
									<span class="checkbox">
										<span class="checkbox_tick"></span>
									</span>
									<label for="kyc_privacy_rep_role" class="checkbox_label"><@i18n key="IAM.GDBR.DPA.POPUP.ADD.CONTACT.ROLE.PRIVACY.REP"/></label>
								</div>
								<div class="textbox_div" id="" onclick="">
									<input id="kyc_ADR_role" name="kyc_ADR_role" onchange="removeCheckbox_err()" class="checkbox_check" type="checkbox">
									<span class="checkbox">
										<span class="checkbox_tick"></span>
									</span>
									<label for="kyc_ADR_role" class="checkbox_label"><@i18n key="IAM.GDBR.DPA.POPUP.ADD.CONTACT.ROLE.ACCOUNT.DISPUTE.RESOLUTION"/></label>
								</div>
							</div>
							<div class="privacy_roles notif_box">
								<div class="privacy_role_head"><@i18n key="IAM.SETTINGS.NOTIFICATIONS.TITLE"/></div>
								<div class="textbox_div" id="" onclick="">
									<input id="kyc_breach_notif" name="breach_notif" onchange="removeCheckbox_err()" class="checkbox_check" type="checkbox">
									<span class="checkbox">
										<span class="checkbox_tick"></span>
									</span>
									<label for="kyc_breach_notif" class="checkbox_label"><@i18n key="IAM.GDBR.DPA.POPUP.ADD.CONTACT.NOTIFICATION.BREACH.NOTIFICATION"/></label>
								</div>
								<div class="textbox_div" id="" onclick="">
									<input id="kyc_subprocessor_add_notif" name="subprocessor_add_notif" onchange="removeCheckbox_err()" class="checkbox_check" type="checkbox">
									<span class="checkbox">
										<span class="checkbox_tick"></span>
									</span>
									<label for="kyc_subprocessor_add_notif" class="checkbox_label"><@i18n key="IAM.GDBR.DPA.POPUP.ADD.CONTACT.NOTIFICATION.SUBPROCESSOR.MODIFY.NOTIFICATION"/></label>
								</div>
							</div>
						</div>
						<button class="primary_btn_check" onclick="collectContect(document.contacts)" id=""><span><@i18n key="IAM.ADD"/></span></button>
						<button class="primary_btn_check high_cancel" onclick="kycFormChange('.slide_header .org_detail',true);" id="contact_edit_back"><span><@i18n key="IAM.BACK"/></span></button>
						<button class="primary_btn_check high_cancel" onclick="kycFormChange('.slide_header .priv_detail',true)" id="contact_edit_close"><span><@i18n key="IAM.CLOSE"/></span></button>
				</form>
				<div class="form_action_btns hide">
					<button class="primary_btn_check kyc_submit" id="contact_form_assign" onclick="addKyc_Contact()" id=""><span><@i18n key="IAM.ASSIGN"/></span></button>
					<button class="primary_btn_check kyc_submit hide" id="contact_form_submit" onclick="addKyc_Contact()" id=""><span><@i18n key="IAM.SUBMIT"/></span></button>
					<button class="primary_btn_check high_cancel" onclick="kycFormChange('.slide_header .org_detail',true);" id=""><span><@i18n key="IAM.BACK"/></span></button>
				</div>
			</div>
		</div>

		<div class="hide popup" tabindex="1" id="kyc_show_contact">
			<div class="popup_header ">
				<div class="popuphead_details">
					<span class="popuphead_text"><@i18n key="IAM.PRIVACY.KYC.POPUP.HEADER.PRIVACY"/></span>
				</div>
				<div class="close_btn" onclick="popupBlurHide('#kyc_show_contact')"></div>
			</div>
			<div class="contact_content">
				<div class="field full">
					
				</div>
			</div>
		</div>
		
		<div class="hide popup" tabindex="1" id="kyc_merge_popup">
			<div class="popup_header ">
				<div class="popuphead_details">
					<span class="popuphead_text"><@i18n key="IAM.PRIVACY.KYC.MERGE.POPUP.HEADER"/></span>
					<span class="popuphead_define"><@i18n key="IAM.PRIVACY.KYC.MERGE.POPUP.DESC"/></span>
				</div>
				<div class="close_btn" onclick="popupBlurHide('#kyc_merge_popup')"></div>
			</div>
			<div>
				<form onsubmit="return false;">
					<div class="field full">
						<label class="textbox_label"><@i18n key="IAM.GDPR.DPA.SELECT.POPUP.ORG"/></label>
						<select id="parent_contact_option">
						</select>
					</div>
					<button class="primary_btn_check " tabindex="1" id="merge_button" onclick="mergeContact()"><span><@i18n key="IAM.GDPR.DPA.BUTTON.ADDNOW"/></span></button>
				</form>
			</div>
		</div>

		<div class="viewall_popup hide" tabindex="1" id="kyc_contcts_viewall">
			<div class="box_info">
				<div class="expand_closebtn" onclick="popupBlurHide('#kyc_contcts_viewall')"></div>
				<div class="box_head"><@i18n key="IAM.PRIVACY.KYC.POPUP.HEADER.PRIVACY"/></div>
			</div>
			<div id="view_all_contacts" class="viewall_popup_content">
			</div>
		</div>
		
<#else>

		<div class="box big_box" id="">
		
			<div class="box_info">
				<div class="box_head"><@i18n key="IAM.GDPR.KYC.NAV.SUBHEAD" /><span class="icon-info"></span></div>
				<div class="box_discrption"><@i18n key="IAM.PRIVACY.KYC.DESC" /></div>
			</div>
			
			<div class="box_content_div" id="exception_page_privacy">
				<div id="bad_net">
					<div class="no_data no_data_SQ"></div>
					<div class="no_data_text" id="exception_page_txt"><@i18n key="IAM.DPA.ERROR.ACCESS.DENIED"/></div>
				</div>
			</div>
		</div>

</#if>