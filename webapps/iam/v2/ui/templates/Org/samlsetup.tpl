

			<div class="box big_box" id="saml_box">
			
					<div class="box_blur"></div>
					<div class="loader"></div>
					
					<div class="box_info">
							<div class="box_head saml_innerbox_head"><@i18n key="IAM.SAMLSETUP.PAGE.TITLE" /> </div>
							
							<span class="togglebtn_div hide" id="saml_activated">
								<input class="real_togglebtn"  id="toggle_saml" onchange="return updateSamlStatus((document.samlviewform))" type="checkbox" >								
								<div class="togglebase">
									<div class="toggle_circle"></div>
								</div>
								
							</span>
							
							<div class="box_discrption"><@i18n key="IAM.SAMLSETUP.PAGE.SUBTITLE" /> </div>
					</div>
					
					<#if !(is_org_user	&&	 is_org_admin)>
					
						<div class="no_data no_data_SQ"></div>
						<div class="no_data_text"><@i18n key="IAM.RESERVE.UNAUTHORIZED.ACCESS" />  </div>
					
					<#else>
					
						<div id="saml_notActivated" class="box_content_div hide">
							<div class="no_data"></div>
							<div class="no_data_text"></div>
							<button class="primary_btn_check center_btn" id="setupsaml"onclick="showSamlsetupOption()" id="allowedip_change"><span><@i18n key="IAM.BTNMSG.SETUP.NOW" /> </span></button>	
						</div>
						
						
						
						<div class="saml_info hide" id="saml_info_show">
							
							<div class="saml_div_aligner">
									<div class="info_div">
										<div class="info_lable"><@i18n key="IAM.SAMLSETUP.LOGIN.URL" /> </div>
										<div class="info_value" id="login_url"></div>
									</div>	
									<div class="info_div">
										<div class="info_lable"><@i18n key="IAM.SAMLSETUP.LOGOUT.URL" /></div>
										<div class="info_value" id="logout_url"></div>
										<div class="saml_response_downlaod icon-download" id="downalod_logout_response">
											<a class="saml_download " href="/accounts/samlsp/certificate"><@i18n key="IAM.SAML.LOGOUT_RESPONSE" /> </span></a>
										</div>
									</div>	
									
									
									
									<div class="info_div">
										<div class="info_lable"><@i18n key="IAM.SAMLSETUP.CHANGE.PASSWORD.URL" /> </div>
										<div class="info_value" id="password_url" ></div>
									</div>		
									<div class="info_div">
										<div class="info_lable"><@i18n key="IAM.SAMLSETUP.ALGORITHM" /> </div>
										<div class="info_value" id="saml_algorithm" ></div>
									</div>	
									<div class="info_div">
										<div class="info_lable"><@i18n key="IAM.SAMLSETUP.SERVICE.NAME" /> </div>
										<div class="info_value" id="SAMLservice_name"></div>
									</div>
								</div>
								
								<div class="info_div hide" id="SAML_JIT_indicator">
									<div class="info_value"><@i18n key="IAM.SAML.JIT.DEACTIVATED" /></div>
								</div>
									
								<a class="primary_btn_check " id="setsaml" href="/accounts/samlsp/metadata"><@i18n key="IAM.SAML.DOWNLOAD.METADATA" /> </span></a>
								<button class="primary_btn_check " onclick="showSamlEditOption()"><span><@i18n key="IAM.EDIT" /> </span></button>
								<button class="primary_btn_check negative_btn_red" onclick="deleteSaml()"><span><@i18n key="IAM.DELETE" /></span></button>

						</div>
					
					
					
					
						<div class="hide saml_opendiv popup" tabindex="0" id="saml_open_cont">
									
							<div class="popup_header">
									<div class="close_btn" onclick="close_SAML_edit()"></div>
									<div class="popuphead_text"><@i18n key="IAM.SAMLSETUP.PAGE.TITLE" /> </div>
							</div>					
							<div id="saml_set" class="saml_setup">							
								<form name="samlform" method="post" id="samlform" onsubmit="return false"  target="uploadaction1" enctype="multipart/form-data">
																			
										<div class="field">
											<div class="textbox_label"><@i18n key="IAM.SAMLSETUP.LOGIN.URL" /> </div>
											<input type="text" onkeypress="remove_error();" id="edit_login_url" type="email" data-validate="zform_field" name="login_url" class="textbox">
										</div>
										
										<div class="field">
											<div class="textbox_label"><@i18n key="IAM.SAMLSETUP.LOGOUT.URL" /> </div>
											<input type="text" data-optional="true" onkeypress="remove_error();" id="edit_logout_url" type="email" data-validate="zform_field" name="logout_url" class="textbox">
										</div>
										
										<div class="checkbox_div">
											<input class="checkbox_check" id="saml_logout_check" onchange="return change_logout_response()" data-validate="zform_field" name="enable_saml_logout" type="checkbox">
											<span class="checkbox">
												<span class="checkbox_tick"></span>
											</span>
											<label for="saml_logout_check" class="checkbox_label"><@i18n key="IAM.SAML.SETUP.ENABLE.SAML.LOGOUT" /> </label>
										</div>
										
										<div class="field">
											<div class="textbox_label "><@i18n key="IAM.SAMLSETUP.CHANGE.PASSWORD.URL" /> </div>
											<input type="text" data-optional="true" onkeypress="remove_error();" id="edit_password_url" data-validate="zform_field" name="password_url" class="textbox" />
										</div>
										
										<div class="field">
											<div class="textbox_label "><@i18n key="IAM.SAML.SETUP.PUBLICKEY" /> </div>
											<input type="text" onkeypress="remove_error();" data-validate="zform_field" name="publickey" id="saml_publickey" class="textbox" placeholder="Enter or Upload Public Key"/>
											<span id="saml_file_space" class="hide">
												<input type="text" onkeypress="remove_error();" onclick="changebacktotext()" id="saml_filename" name="saml_filename" class="textbox "  readonly/>
											</span>
											<input type="file" id="saml_publickey_upload" data-validate="zform_field" name="publickey_upload" style="display: none;">
											<button type="button" class="browse_btn icon-upload"  onclick="samlPublicKeyOption(false)"/></button>
										</div>
										
										<div class="field">
											<div class="textbox_label "><@i18n key="IAM.SAMLSETUP.ALGORITHM" /> </div>
											<select data-validate="zform_field" id="edit_saml_algorithm" name="algorithm" class="saml_select customised_select">
												<option value="RSA" ><@i18n key="IAM.SAML.RSA" /> </option>
												<option value="DSA" ><@i18n key="IAM.SAML.DSA" /> </option>
											</select>
										</div>
										
										<div class="field">
											<div class="textbox_label "><@i18n key="IAM.SAMLSETUP.SERVICE.NAME" /> </div>
											<select data-validate="zform_field" id="edit_SAMLservice_name" name="service" class="saml_select customised_select">
											
												<#list services as formats>
				                          			<option value="${formats.servicename}" id="${formats.servicename}" >${formats.displayname}</option>
				                           		</#list>
	                           		
											</select>
										</div>
										
										<div class="checkbox_div">
											<input class="checkbox_check" id="saml_jit_check" data-validate="zform_field" onchange="return show_jit_fields()" name="enable_saml_jit" type="checkbox">
											<span class="checkbox">
												<span class="checkbox_tick"></span>
											</span>
											<label for="saml_jit_check" class="checkbox_label"><@i18n key="IAM.SAML.AUTOPROVISIONING" /> </label>
										</div>
										
										<div class="saml_JIT_fields hide" id="saml_JIT_fields">
										
										</div>
									
										<div class="pop_up_overflow_btn">
											<button class="primary_btn_check " id="setsaml" onclick="updateSaml(document.samlform)"><span><@i18n key="IAM.CONFIGURE" /> </span></button>
											<button class="primary_btn_check high_cancel" onclick="return close_SAML_edit()"><span><@i18n key="IAM.CLOSE" /> </span></button>
										</div>
									
									
								</form>
								
							</div>
							
						</div>
						
														
						<div class="hide" id="empty_jit_fields_format">
						
							<div class="field">
								
								<select onchange="inputName(this)" class="saml_jit_select">
									<option value="first_name" ><@i18n key="IAM.GENERAL.FIRSTNAME" /></option>
									<option value="last_name" ><@i18n key="IAM.GENERAL.LASTNAME" /></option>
									<option value="display_name" ><@i18n key="IAM.GENERAL.DISPLAYNAME" /></option>
								</select>
								
								<div class="inputText">
									<input type="text" class="textbox namebox" value="" placeholder=''/>
								</div>
								
							</div>
							
						
						</div>
											
					</#if>
					
				</div>	
					
					
											
											
											