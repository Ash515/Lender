<script>


var i18nkeys = {
 
			"IAM.PRIVACY.CERTIFICATIONS.ISO27001.DESCRIPTION" : '<@i18n key="IAM.PRIVACY.CERTIFICATIONS.ISO27001.DESCRIPTION" />',
			"IAM.PRIVACY.CERTIFICATIONS.ISO27017.DESCRIPTION1" : '<@i18n key="IAM.PRIVACY.CERTIFICATIONS.ISO27017.DESCRIPTION1" />',
			"IAM.PRIVACY.CERTIFICATIONS.ISO27017.DESCRIPTION2" : '<@i18n key="IAM.PRIVACY.CERTIFICATIONS.ISO27017.DESCRIPTION2" />',
			"IAM.PRIVACY.CERTIFICATIONS.ISO27018.DESCRIPTION" : '<@i18n key="IAM.PRIVACY.CERTIFICATIONS.ISO27018.DESCRIPTION" />',
			"IAM.PRIVACY.CERTIFICATIONS.ISO9001.DESCRIPTION" : '<@i18n key="IAM.PRIVACY.CERTIFICATIONS.ISO9001.DESCRIPTION" />',
			"IAM.PRIVACY.CERTIFICATIONS.SOC.DESCRIPTION" : '<@i18n key="IAM.PRIVACY.CERTIFICATIONS.SOC.DESCRIPTION" />',
			"IAM.PRIVACY.CERTIFICATIONS.PCI.DESCRIPTION1" : '<@i18n key="IAM.PRIVACY.CERTIFICATIONS.PCI.DESCRIPTION1" />',
			"IAM.PRIVACY.CERTIFICATIONS.PCI.DESCRIPTION2" : '<@i18n key="IAM.PRIVACY.CERTIFICATIONS.PCI.DESCRIPTION2" />',
			"IAM.PRIVACY.CERTIFICATIONS.GDPR.DESCRIPTION1" : '<@i18n key="IAM.PRIVACY.CERTIFICATIONS.GDPR.DESCRIPTION1" />',
			"IAM.PRIVACY.CERTIFICATIONS.GDPR.DESCRIPTION2" : '<@i18n key="IAM.PRIVACY.CERTIFICATIONS.GDPR.DESCRIPTION2" />',
			"IAM.PRIVACY.CERTIFICATIONS.GDPR.DESCRIPTION3" : '<@i18n key="IAM.PRIVACY.CERTIFICATIONS.GDPR.DESCRIPTION3" />',
			"IAM.PRIVACY.CERTIFICATIONS.TRUSTE.DESCRIPTION1" : '<@i18n key="IAM.PRIVACY.CERTIFICATIONS.TRUSTE.DESCRIPTION1" />',
			"IAM.PRIVACY.CERTIFICATIONS.TRUSTE.DESCRIPTION2" : '<@i18n key="IAM.PRIVACY.CERTIFICATIONS.TRUSTE.DESCRIPTION2" />',
			"IAM.PRIVACY.CERTIFICATIONS.AGREEMENT" : '<@i18n key="IAM.PRIVACY.CERTIFICATIONS.AGREEMENT" />',
			
			"IAM.PRIVACY.CERTIFICATIONS.ISO27001" : '<@i18n key="IAM.PRIVACY.CERTIFICATIONS.ISO27001" />',
			"IAM.PRIVACY.CERTIFICATIONS.ISO9001" : '<@i18n key="IAM.PRIVACY.CERTIFICATIONS.ISO9001" />',
			"IAM.PRIVACY.CERTIFICATIONS.ISO27017" : '<@i18n key="IAM.PRIVACY.CERTIFICATIONS.ISO27017" />',
			"IAM.PRIVACY.CERTIFICATIONS.ISO27018" : '<@i18n key="IAM.PRIVACY.CERTIFICATIONS.ISO27018" />',
			"IAM.PRIVACY.CERTIFICATIONS.SOC" : '<@i18n key="IAM.PRIVACY.CERTIFICATIONS.SOC" />',
			"IAM.PRIVACY.CERTIFICATIONS.PCI" : '<@i18n key="IAM.PRIVACY.CERTIFICATIONS.PCI" />',
			"IAM.PRIVACY.CERTIFICATIONS.GDPR" : '<@i18n key="IAM.PRIVACY.CERTIFICATIONS.GDPR" />',
			"IAM.PRIVACY.CERTIFICATIONS.TRUSTE" : '<@i18n key="IAM.PRIVACY.CERTIFICATIONS.TRUSTE" />'
			
	    };
	   	    	    
</script>
	
		<div class="box big_box" id="">
			<div class="box_info">
				<div class="box_head"><@i18n key="IAM.PRIVACY.CERTIFICATIONS.SUBHEAD"/><span class="icon-info info_icon"></span></div>
			</div>
		
			<div class="hide" id="exception_page_privacy">
				<div id="bad_net">
					<div id="" class="no_data_exception"></div>
					<div class="no_data_text" id="exception_page_txt"><@i18n key="IAM.PLEASE.CONNECT_INTERNET"/></div>
					<button class="primary_btn_check center_btn" id="reload_exception_page" onclick="document.location.reload()"><span><@i18n key="IAM.EXCEPTION.RELOAD"/></span></button>
				</div>
			</div>
			
			<#--   				MAIN PAGE CERTS LILSTING START				-->
			
			<div class="certifications_list_boxes">
					<div class="certification_info" onclick="certifications_slide_content(this,${isUserAllowedToDownloadCertificate});">
						<div class="certificate_icon"></div>
						<div class="certificate_name"></div>
					</div>
			</div>
	
			<#--   				MAIN PAGE CERTS LILSTING END				-->
			
			<#--   				CERTS SLIDER CONTENT START				-->
			
			<div class="right_slider">
				<div class="slider_head">
					<div class="closeicon slider_close" onclick="closeSliderPopup(this)"></div>
					<div class="details_div">
						<span class="slider_header_cert_icon certificate_icon"></span>
						<span class="slider_head_content">
                			<div class="cert_name_header slider_head_text"></div>
            			</span>
					</div>
				</div>
				<div class="selected_ele_detail">
					<div class="certificate_description desc1"></div>
					<div class="certificate_description desc2"></div>
					<div class="certificate_description desc3"></div>
					<div class="services_list_box hide" id="services_list_box">
						<div class="service_container">
							
							<label class="service_box" style="display: inline-block;">
								<div class="checkbox_div">
									<input name="certi_services" class="checkbox_check" type="checkbox">
										<span class="checkbox">
											<span class="checkbox_tick"></span>
										</span>
										<div class="checkbox_label">
											<span class="service_icon certificate_product_icon"></span>
											<span class="service_name"></span>
										</div>							
								</div>							
							</label>
						</div>
						
					</div>
						<div class="agreement" id="cert_agreement" style="display: none;"> 
							<div class="checkbox_div">
								<input id="agreement_accept" class="checkbox_check" type="checkbox">
									<span class="checkbox">
										<span class="checkbox_tick"></span>
									</span>
								<label for="agreement_accept" class="checkbox_label"> <@i18n key="IAM.PRIVACY.CERTIFICATIONS.AGREEMENT" arg0="${certificates_policy_link}"/> </label>
							</div>
						</div>
					 
						<div class="buttons_box">
							<button class="primary_btn_check" id="download_cert" style="display: none;" disabled="disabled"> <@i18n key="IAM.DOWNLOAD.APP"/></button>
					</div>
				</div>
			</div>
			
			<#--   				CERTS SLIDER CONTENT END				-->
			
		</div>
		