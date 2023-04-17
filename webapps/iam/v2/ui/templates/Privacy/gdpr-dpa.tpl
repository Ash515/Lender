<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Frameset//EN" "http://www.w3.org/TR/REC-html40/frameset.dtd">



<#if (showGDPRDPAPage == 1) >

		<div class="box big_box" id="">
		
			<div class="box_info">
				<div class='dpa_ccpa_toggle'>
					<input type="checkbox" id='ccpa_toggle' onchange='load_GDPRdetails(privacy_data.Privacy)'>
					<label for='ccpa_toggle' class='ccpa_toggle_lbl'>
						<span class='dpa'><@i18n key="IAM.DPA.TOGGLE.GDPR" /></span>
						<span class='ccpa'><@i18n key="IAM.DPA.TOGGLE.CCPA" /></span>
					</label>
				</div>
				<div class="box_head"><@i18n key="IAM.GDPR.DPA" /><span class="icon-info"></span></div>
				<div class="box_discrption"><@i18n key="IAM.GDPR.DPA.HEAD.SUBTITLE" /></div>		
			</div>
			
			<div class="hide" id="exception_page_privacy">
				<div id="bad_net">
					<div id="" class="no_data_exception"></div>
					<div class="no_data_text" id="exception_page_txt"><@i18n key="IAM.PLEASE.CONNECT_INTERNET"/></div>
					<button class="primary_btn_check center_btn" id="reload_exception_page" onclick="document.location.reload()"><span><@i18n key="IAM.EXCEPTION.RELOAD"/></span></button>
				</div>
			</div>
			
			<div id="org_select_container">
				<div class="dpa_header header_for_gdpr"><@i18n key="IAM.GDPR.DPA.INITIATE.HEADER1" /></div>
				<div class="dpa_header header_for_ccpa"><@i18n key="IAM.CCPA.DPA.INITIATE.HEADER" /></div>
				<div class="dpa_definition">
					<@i18n key="IAM.GDPR.DPA.INITIATE.PROCESS.DETAILS" arg0="${email}"/>
				</div>
				<div>
					<div class="field textbox_div textbox_inline">
						<label class="textbox_label"><@i18n key="IAM.GDPR.DPA.CHOOSE.ORG"/></label>
						<select class="profile_mode" id="org_list">
					
						</select>
					</div>
				</div>
				<button class="primary_btn_check" onclick="initiateDPA()" id="org_btn"><span><@i18n key="GDPR.DPA.INITIATE.NOW"/></span></button>
			</div>
			<div id="signed_org_status" class="">
				<div class="template">
					<div class="org_box">
						<span class="status_indicator">
							
						</span>
						<div class="name_container">
							<div class="org_name"></div>
							<div class="service_name"></div>
						</div>
						<div class="status_block">
							<span><@i18n key="IAM.GDPR.ERROR.REASON"/></span>: <span class="rej_reason"></span>
						</div>
						<div class="signed_org_type">
							<div class="manual_sign"><@i18n key="IAM.GDPR.DPA.COMPLETED.PARENT"/></div>
							<div class="singed_with_parent"></div>
						</div>
						<div class="org_button">
							<span id="sign_reinitiate"><@i18n key="IAM.GDPR.DPA.REINITIATE.AGAIN"/></span>
							<span id="sign_create"><@i18n key="IAM.CREATE"/></span>
							<span id="add_to_singed"><@i18n key="IAM.GDPR.DPA.BUTTON.MERGE"/></span>
						</div>
					</div>
				</div>
				<div class="org_division" id="signed_org">
					<div class="org_head"><@i18n key="IAM.GDPR.DPA.STATUS.HEADER.SIGNED" /></div>
					<div class="org_container"></div>
				</div>
				<div class="org_division" id="pending_org">
					<div class="org_head"><@i18n key="IAM.GDPR.DPA.STATUS.HEADER.PENDING" /></div>
					<div class="org_container"></div>
				</div>
				<div class="hide pending_org_note">
					<b><@i18n key="IAM.NOTE.WARN"/></b>: <span><@i18n key="IAM.GDPR.DPA.PENDING.PROCESS.NOTE"/><span>
				</div>
				<div class="org_division" id="unsigned_org">
					<div class="org_head"><@i18n key="IAM.GDPR.DPA.STATUS.HEADER.UNSIGNED" /></div>
					<div class="org_container"></div>
				</div>
				
			</div>
						
		</div>
		
		<div class="hide popup" tabindex="1" id="dpa_merge_popup">
			<div class="popup_header ">
				<div class="popuphead_details">
					<span class="popuphead_text"><@i18n key="IAM.GDPR.DPA.MERGE.POPUP.HEADER"/></span>
					<span class="popuphead_define"><@i18n key="IAM.GDPR.DPA.MERGE.POPUP.DESC"/></span>
				</div>
				<div class="close_btn" onclick="popupBlurHide('#dpa_merge_popup')"></div>
			</div>
			<div>
				<form onsubmit="return false;">
					<div class="field full">
						<label class="textbox_label"><@i18n key="IAM.GDPR.DPA.SELECT.POPUP.ORG"/></label>
						<select id="parent_org_option">
						</select>
					</div>
					<button class="primary_btn_check " tabindex="1" id="merge_button"><span><@i18n key="IAM.GDPR.DPA.BUTTON.ADDNOW"/></span></button>
				</form>
			</div>
		</div>
		<div id="gdpr_form" class="hide popup" tabindex="1">
				<div class="popup_header ">
					<div class="popuphead_details">
						<div class="dpa_header">
							<span class="popuphead_text"><@i18n key="IAM.GDBR.DPA.POPUP.INITIATE.HEADER"/></span>
							<span class="popuphead_define define_for_gdpr"><@i18n key="IAM.GDPR.DPA.POPUP.INITIATE.DESCRIPTION" arg0="${gdpr_privacy_link}" arg1="${gdpr_policy_link}"/></span>
							<span class="popuphead_define define_for_ccpa"><@i18n key="IAM.GDPR.DPA.POPUP.INITIATE.DESCRIPTION" arg0="${ccpa_privacy_link}" arg1="${ccpa_policy_link}"/></span>
						</div>
						<div class="add_contact_header hide">
							<span class="popuphead_text"><@i18n key="IAM.GDBR.DPA.POPUP.ASSIGN.CONTACT.HEADER"/></span>
							<span class="popuphead_define"><@i18n key="IAM.GDBR.DPA.POPUP.ASSIGN.CONTACT.DESCRIPTION"/></span>
						</div>
					</div>
					<div class="close_btn" onclick="close_gdpr_form(false)"></div>
				</div>
				<form name="dpa_form" onsubmit="return false;">
					<div class="dpa_text_aligner">
						<div class="textbox_div textbox_inline">
							<label class="textbox_label"><@i18n key="IAM.FULL.NAME"/>&#42;</label>
							<input type="text" value="${full_name}" name="fname" onkeypress="remove_error()" class="textbox" >
						</div>
						<div class="textbox_div textbox_inline">
							<label class="textbox_label"><@i18n key="IAM.EMAIL.ADDRESS"/>&#42;</label>
							<input type="text" name="email" value="${email}" onkeypress="remove_error()" class="textbox" >
						</div>
						<div class="textbox_div textbox_inline">
							<label class="textbox_label"><@i18n key="IAM.GDPR.DPA.COMPANY.NAME"/>&#42;</label>
							<input type="text" name="cname" onkeypress="remove_error()" class="textbox" >
						</div>
						<div class="textbox_div textbox_inline">
							<label class="textbox_label"><@i18n key="IAM.GDPR.DPA.COMPANY.NAME.REGISTERATION.NUMBER"/>&#42;</label>
							<input type="text" name="cregnumber" onkeypress="remove_error()" class="textbox" >
						</div>
						<div class="textbox_div textbox_inline">
							<label class="textbox_label"><@i18n key="IAM.GDPR.DPA.DATA"/>&#42;<span title="<@i18n key="IAM.GDPR.DPA.DATA.FORM.NOTE"/>" class="data_expl icon-info"></span></label>
							<input type="text" class="textbox" name="cdata" onkeypress="remove_error()" placeholder="<@i18n key="IAM.GDPR.DPA.DATA.FORM.PLACEHOLDER"/>"></textarea>
						</div>
						<div class="textbox_div textbox_inline">
							<label class="textbox_label"><@i18n key="IAM.GDPR.DPA.ADDRESS.STREET_NAME"/>&#42;</label>
							<input type="text" class="textbox" name="address_street" onkeypress="remove_error()"></textarea>
						</div>
						<div class="textbox_div textbox_inline">
							<label class="textbox_label"><@i18n key="IAM.GDPR.DPA.ADDRESS.CITY"/>&#42;</label>
							<input type="text" class="textbox" name="address_city" onkeypress="remove_error()"></textarea>
						</div>
						<div class="textbox_div textbox_inline">
							<label class="textbox_label"><@i18n key="IAM.GDPR.DPA.ADDRESS.STATE"/>&#42;</label>
							<input type="text" class="textbox" name="address_state" onkeypress="remove_error()"></textarea>
						</div>
						<div class="field textbox_div textbox_inline">
							<label class="textbox_label"><@i18n key="IAM.GDPR.DPA.COMPANY.NAME.REGISTERATION.COUNTRY"/></label>
							<select name="dpaCn" class="profile_mode" id="dpa_country">
								<#list Countries as countrydata>
									<#assign count_data=countrydata.data >
	                          		<option value="${count_data.ISO2_CODE}" id="${count_data.ISO2_CODE}" >${count_data.DISPLAY_NAME}</option>
	                           	</#list>
							</select>
						</div>
						<div class="textbox_div textbox_inline">
							<label class="textbox_label"><@i18n key="IAM.GDPR.DPA.ADDRESS.Z_CODE"/>&#42;</label>
							<input type="text" class="textbox" name="z_code" onkeypress="remove_error()"></textarea>
						</div>
					</div>
					<button class="primary_btn_check" onclick="" id="dpa_form_btn"><span><@i18n key="IAM.BUTTON.SUBMIT"/></span></button>
					<button class="primary_btn_check high_cancel" onclick="close_gdpr_form(false);" id="dpa_form_btn"><span><@i18n key="IAM.CANCEL"/></span></button>
				</form>
				<div class="contact_template hide">
					<div class="contact_outline" id="kyc_contact">
						<div class="email_dp"></div>
						<span class="name_detail">
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
						<input type="hidden" class="isNew" value="">
						<span onclick="remove_contact(this)" class="deleteicon hide action_icon icon-delete" title="<@i18n key="IAM.REMOVE"/>"></span>
					</div>
				</div>
				
				<div class="contact_collecting_container contact_storage hide">
				</div>

				<div class="addnew new_contact hide" onclick="showContactForm()"><@i18n key="IAM.PRIVACY.POP.ADD.ANOTHER.CONTACT"/></div>
				
				<div class="contact_form_button hide">
					<button class="primary_btn_check" onclick="addKyc_Contact()" id=""><span><@i18n key="IAM.CONTINUE"/></span></button>
					<button class="primary_btn_check high_cancel" onclick="close_gdpr_form(true)" id=""><span><@i18n key="IAM.CLOSE"/></span></button>
				</div>
				
				<form name="add_contact" onsubmit="return false;" class="add_contact_pop hide">
						<div class="textbox_div textbox_inline">
							<label class="textbox_label"><@i18n key="IAM.GENERAL.FIRSTNAME"/></label>
							<input type="text" name="fname"  onkeypress="remove_error()" class="textbox" >
						</div>
						<div class="textbox_div textbox_inline">
							<label class="textbox_label"><@i18n key="IAM.GENERAL.LASTNAME"/></label>
							<input type="text" name="lname" onkeypress="remove_error()" class="textbox" >
						</div>
						<div class="textbox_div textbox_inline">
							<label class="textbox_label"><@i18n key="IAM.EMAIL.ADDRESS"/>&#42;</label>
							<input type="text" name="email" onkeypress="remove_error()" class="textbox" >
						</div>
						<div class="privacy_role_box">
							<div class="privacy_roles role_box">
								<div class="privacy_role_head"><@i18n key="IAM.GDBR.DPA.POPUP.ADD.CONTACT.ROLES"/></div>
								<div class="textbox_div" id="" onclick="">
									<input id="dpo_role" name="dpo_role" class="checkbox_check" type="checkbox">
									<span class="checkbox">
										<span class="checkbox_tick"></span>
									</span>
									<label for="dpo_role" class="checkbox_label"><@i18n key="IAM.GDBR.DPA.POPUP.ADD.CONTACT.ROLE.DPO"/></label>
								</div>
								<div class="textbox_div" id="" onclick="">
									<input id="privacy_rep_role" name="privacy_rep_role" class="checkbox_check" type="checkbox">
									<span class="checkbox">
										<span class="checkbox_tick"></span>
									</span>
									<label for="privacy_rep_role" class="checkbox_label"><@i18n key="IAM.GDBR.DPA.POPUP.ADD.CONTACT.ROLE.PRIVACY.REP"/></label>
								</div>
								<div class="textbox_div">
									<input id="ADR_role" name="ADR_role" class="checkbox_check" type="checkbox">
									<span class="checkbox">
										<span class="checkbox_tick"></span>
									</span>
									<label for="ADR_role" class="checkbox_label"><@i18n key="IAM.GDBR.DPA.POPUP.ADD.CONTACT.ROLE.ACCOUNT.DISPUTE.RESOLUTION"/></label>
								</div>
							</div>
							<div class="privacy_roles notif_box">
								<div class="privacy_role_head"><@i18n key="IAM.SETTINGS.NOTIFICATIONS.TITLE"/></div>
								<div class="textbox_div" id="" onclick="">
									<input id="breach_notif" name="breach_notif" onchange="removeCheckbox_err()" class="checkbox_check" type="checkbox">
									<span class="checkbox">
										<span class="checkbox_tick"></span>
									</span>
									<label for="breach_notif" class="checkbox_label"><@i18n key="IAM.GDBR.DPA.POPUP.ADD.CONTACT.NOTIFICATION.BREACH.NOTIFICATION"/></label>
								</div>
								<div class="textbox_div" id="" onclick="">
									<input id="subprocessor_add_notif" name="subprocessor_add_notif" onchange="removeCheckbox_err()" class="checkbox_check" type="checkbox">
									<span class="checkbox">
										<span class="checkbox_tick"></span>
									</span>
									<label for="subprocessor_add_notif" class="checkbox_label"><@i18n key="IAM.GDBR.DPA.POPUP.ADD.CONTACT.NOTIFICATION.SUBPROCESSOR.MODIFY.NOTIFICATION"/></label>
								</div>
							</div>
						</div>
						<button class="primary_btn_check" onclick="collectContect(document.add_contact)" id=""><span><@i18n key="IAM.ADD"/></span></button>
						<button class="primary_btn_check high_cancel" onclick="close_gdpr_form(true)" id=""><span><@i18n key="IAM.SKIP"/></span></button>
				</form>
			</div>
		
<#else>

		<div class="box big_box" id="">
			<div class="box_info">
				<div class="box_head"><@i18n key="IAM.GDPR.DPA" /><span class="icon-info"></span></div>
				<div class="box_discrption"><@i18n key="IAM.GDPR.DPA.HEAD.SUBTITLE" /></div>		
			</div>
			
			<div class="box_content_div" id="exception_page_privacy">
				<div id="bad_net">
					<div class="access_blk_img"></div>
					<div class="blk_header"><@i18n key="IAM.DPA.ERROR.ACCESS.DENIED" /></div>
					<div class="blk_content"><@i18n key="IAM.DPA.ERROR.ACCESS.DENIED.DEFINITION" /></div>
				</div>
			</div>
		</div>

</#if>