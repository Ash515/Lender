<div class="box big_box" id="domain_box">
				
		<div class="box_blur"></div>
		<div class="loader"></div>
	
		<div class="box_info">
			<div class="box_head"><@i18n key="IAM.HEADER.DOMAINS" /></div>
			<div class="box_discrption mob_hide"></div>
		</div>
		<div class="hide domain_temp">
			<span class="icon-domain email_dp dp_blue"></span>
			<span class="domain_info">
				<div class="domain_name"></div>
				<div class="domain_type">
					<span class="ver_content"><@i18n key="IAM.DOMAIN.VERIFIED"/></span>
					<span class="unver_content"><@i18n key="IAM.DOMAIN.UNVERIFIED"/></span>
				</div>
			</span>
			<span class="delete_button action_icon icon-delete" title="<@i18n key="IAM.DELETE"/>" onclick=""></span>
			<span class="verify_button action_icon" onclick="showDomainVerifyPopup()"><span class="domain_ver_icon icon-verify"></span><@i18n key="IAM.VERIFY.NOW" /></span>
		</div>
		<div id="domain_content">
			<div class="unverified_domain"></div>
			<div class="verified_domain"></div>
		</div>
		<div id="no_domain" class="box_content_div hide">
			<div class="no_data no_data_SQ"></div>
			<div class="no_data_text"><@i18n key="IAM.ORG.DOMAIN.EMPTY.STATE" /></div>
		</div>
</div>
<div class=" hide popup" tabindex="0" id="verify_domain">
	<div class="popup_header">
		<div class="close_btn" onclick="close_domain_edit()"></div>
		<div class="popuphead_text"><@i18n key="IAM.ORG.DOMAIN.POPUP.HEADER" /></div>
	</div>
	<div class="verifyDomain_content">
		<div class="verify_option">
			<div class="option_text"><@i18n key="IAM.ORG.DOMAIN.POPUP.VERIFY.TEXT"/></div>
			<div class="domain_options">
				<div class="radiobtn_div">
					<input class="real_radiobtn" onchange="changeDomainOption(this)" type="radio" name="options" id="txt" value="2" checked="checked">
					<div class="outer_circle">
					<div class="inner_circle"></div></div>
					<label class="radiobtn_text" for="txt"><@i18n key="IAM.ORG.DOMAIN.POPUP.VERIFY.OPTION.TXT"/></label>
				</div>
				<div class="radiobtn_div">
					<input class="real_radiobtn" onchange="changeDomainOption(this)" type="radio" name="options" id="cname" value="1" >
					<div class="outer_circle">
					<div class="inner_circle"></div></div>
					<label class="radiobtn_text" for="cname"><@i18n key="IAM.ORG.DOMAIN.POPUP.VERIFY.OPTION.CNAME"/></label>
				</div>
				<div class="radiobtn_div">
					<input class="real_radiobtn" type="radio" onchange="changeDomainOption(this)" name="options" id="html" value="0">
					<div class="outer_circle">
					<div class="inner_circle"></div></div>
					<label class="radiobtn_text" for="html"><@i18n key="IAM.ORG.DOMAIN.POPUP.VERIFY.OPTION.HTML"/></label>
				</div>
			</div>
		</div>
		<div class="verify_option_detail">
			<div class="step_box txt_content">
				<div class="steps step1">
					<div class="text_button text_grn_btn"><@i18n key="IAM.ORG.DOMAIN.POPUP.STEP1"/></div>
					<div class="steps_detail">
						<@i18n key="IAM.ORG.DOMAIN.POPUP.TEXT.STEP1"/>
					</div>
				</div>
				<div class="steps step2">
					<div class="text_button text_grn_btn"><@i18n key="IAM.ORG.DOMAIN.POPUP.STEP2"/></div>
					<div class="steps_detail">
						<@i18n key="IAM.ORG.DOMAIN.POPUP.TEXT.STEP2"/>
						<div class="gray_box_container">
							<div class="domainGrayBox">
								<div class="gray_header"><@i18n key="IAM.ORG.DOMAIN.POPUP.TEXT.HOST.NAME"/></div>
								<div class="host_name">"@"</div>
							</div>
							<div class="domainGrayBox">
								<div class="gray_header"><@i18n key="IAM.ORG.DOMAIN.POPUP.TEXT.HOST.VALUE"/></div>
								<div class="host_value" id="txt_host_value"></div>
								<div class="blue txt_copy" onclick="clickToCopy('txt_copy','txt_host_value')"><@i18n key="IAM.COPY"/></div>
							</div>
						</div>
					</div>
				</div>
				<div class="steps step3">	
					<div class="text_button text_grn_btn"><@i18n key="IAM.ORG.DOMAIN.POPUP.STEP3"/></div>
					<div class="steps_detail">
						<@i18n key="IAM.ORG.DOMAIN.POPUP.TEXT.STEP3"/>
					</div>
				</div>
			</div>
			<div class="hide step_box cname_content">
				<div class="steps step1">
					<div class="text_button text_grn_btn"><@i18n key="IAM.ORG.DOMAIN.POPUP.STEP1"/></div>
					<div class="steps_detail">
						<@i18n key="IAM.ORG.DOMAIN.POPUP.CNAME.STEP1"/>
					</div>
				</div>
				<div class="steps step2">
					<div class="text_button text_grn_btn"><@i18n key="IAM.ORG.DOMAIN.POPUP.STEP2"/></div>
					<div class="steps_detail">
						<@i18n key="IAM.ORG.DOMAIN.POPUP.CNAME.STEP2"/>
						<div class="gray_box_container">
							<div class="domainGrayBox">
								<div class="gray_header"><@i18n key="IAM.ORG.DOMAIN.POPUP.CNAME.NAME"/></div>
								<div class="host_name" id="cname_host_name"></div>
								<div class="blue cname_name_copy" onclick="clickToCopy('cname_name_copy','cname_host_name')"><@i18n key="IAM.COPY"/></div>
							</div>
							<div class="domainGrayBox">
								<div class="gray_header"><@i18n key="IAM.ORG.DOMAIN.POPUP.CNAME.VALUE"/></div>
								<div class="host_value" id="cname_host_value"></div>
								<div class="blue cname_value_copy" onclick="clickToCopy('cname_value_copy','cname_host_value')"><@i18n key="IAM.COPY"/></div>
							</div>
						</div>
					</div>
				</div>
				<div class="steps step3">
					<div class="text_button text_grn_btn"><@i18n key="IAM.ORG.DOMAIN.POPUP.STEP3"/></div>
					<div class="steps_detail">
						<@i18n key="IAM.ORG.DOMAIN.POPUP.CNAME.STEP3"/>
					</div>
				</div>
			</div>
			<div class="hide step_box html_content">
				<div class="steps step1">
					<div class="text_button text_grn_btn"><@i18n key="IAM.ORG.DOMAIN.POPUP.STEP1"/></div>
					<div class="steps_detail">
						<@i18n key="IAM.ORG.DOMAIN.POPUP.HTML.STEP1"/>
						<div class="gray_box_container">
							<div class="domainGrayBox html_domain_box">
								<div class="domain_html"></div>
								<span class="html-download"></span>
							</div>
						</div>
					</div>
				</div>
				<div class="steps step2">
					<div class="text_button text_grn_btn"><@i18n key="IAM.ORG.DOMAIN.POPUP.STEP2"/></div>
					<div class="steps_detail">
						<@i18n key="IAM.ORG.DOMAIN.POPUP.HTML.STEP2"/>
						<div><@i18n key="IAM.ORG.DOMAIN.POPUP.HTML.URL.EXAMPLE"/></div>
					</div>
				</div>
				<div class="steps step3">
					<div class="text_button text_grn_btn"><@i18n key="IAM.ORG.DOMAIN.POPUP.STEP3"/></div>
					<div class="steps_detail">
						<@i18n key="IAM.ORG.DOMAIN.POPUP.HTML.STEP3"/>
					</div>
				</div>
			</div>
			<div class="domain_err_content">
			</div>
			<div class="dom_verify_actions">
				<button tabindex="0" class="primary_btn_check inline" id="verify_domain_action" onclick="verifyTheDomain()"><span><@i18n key="IAM.VERIFY"/></span></button>
				<button tabindex="0" class="primary_btn_check high_cancel" id="cancel_verification" onclick="close_domain_edit()"><span><@i18n key="IAM.CANCEL"/></span></button>
			</div>
			
		</div>
	</div>
</div>
<div class="hide popup" tabindex="0" id="domain_popup_for_mobile">
	<div class="popup_header popup_header_for_mob">
		<div class="popuphead_details">
	                	
		</div>
		<div class="close_btn" onclick="close_domain_mobile_specific()"></div>
	</div>
	<div class="mob_popu_btn_container">
		<button class="" id="btn_to_verify" onclick="" ><span class="icon-verify"></span><span><@i18n key="IAM.VERIFY.NOW"/></span></button>
		<button class="" id="btn_to_delete_domain" onclick="" ><span class="icon-delete"></span><span><@i18n key="IAM.DELETE"/></span></button>
	</div>
</div>