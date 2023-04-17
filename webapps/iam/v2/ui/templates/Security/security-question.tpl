<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Frameset//EN" "http://www.w3.org/TR/REC-html40/frameset.dtd">




		<div class="hide popup" tabindex="1" id="popup_security_question">
		
			<div class="popup_header ">
				
				<div class="popuphead_details">
					<span class="popuphead_text"><@i18n key="IAM.SECUR.QUESTION" /></span>
					<span class="popuphead_define"><@i18n key="IAM.SECURITY.QUESTION.POPUP.DESCRIPTION" /></span>
				</div>
				<div class="close_btn" onclick="close_security_question()"></div>
				
			</div>
			
			<div id="security_question_info">
			
				<form id="phraseform" name="phraseform"  onsubmit="return security_enter_pass(this);">
				
					<div id="first_step">
						
						<div class="field full noindent" id="empty_phonenumber">
	                  		<label class="textbox_label"><@i18n key="IAM.SECUR.QUESTION.SELECT" /></label>
							
							<select id="security_question_choose" onchange="set_Format()">
								<option value="custom"><@i18n key="IAM.SECURITY.QUESTION.NEW" /> </option>
								<#list Sec_Quesions as questions>
                          			<option value="${questions}">${questions}</option>
                           		</#list>
							</select>
						
						</div>
						
						<div class="field full hide" id="New_Question">
	                  		<label class="textbox_label"><@i18n key="IAM.CUSTOM.SECUR.QUESTION" /> </label>
	                  		<input tabindex="0" class="textbox"  data-validate="zform_field" name="custSecQ" onkeypress="remove_error()" data-limit="200" id="custom_question_input" type="text">
						</div>
						
						<div class="field full" id="sq_answer">
	                  		<label class="textbox_label"><@i18n key="IAM.ANSWER" /></label>
	                  		<input tabindex="0" class="textbox" data-validate="zform_field" name="secA" onkeypress="remove_error()" data-limit="50" type="text">
						</div>
						
						
						<button type="submit" tabindex="0" class="primary_btn_check "  id="allowedip_change"><span><@i18n key="IAM.NEXT" /></span></button>
					</div>
					
					<div id="second_step" class="hide">
						<div class="field full" id="sec_q_password">
	                  		<label class="textbox_label"><@i18n key="IAM.ENTER.PASS" /> </label>
	                  		<input tabindex="0" class="textbox" data-validate="zform_field" autocomplete="off" name="current_password" id="secQA_pass" onkeypress="remove_error()"  type="password">
	                  		
							<#if ValidPrimaryEmail>
		              			<a tabindex="0" class="blue" onclick="goToForgotPwd();"><@i18n key="IAM.FORGOT.PASSWORD" /></a>
		              		</#if>	 
	              		   
						</div>
						
							<button tabindex="0" class="primary_btn_check " ><span><@i18n key="IAM.NEXT" /></span></button>
							<button tabindex="0" class="primary_btn_check high_cancel" onclick="return back_to_question();" ><span><@i18n key="IAM.BACK" /> </span></button>
					
					</div>
					
				</form>
			
			
			</div>
		
		</div>
		
		
		
		
		<div class="box big_box" id="secQA_box">
		
			<div class="box_blur"></div>
			<div class="loader"></div>
			
			<div class="box_info">
				<div class="box_head"> <@i18n key="IAM.SECUR.QUESTION" /><span class="icon-info"></span> </div>
				
				<div class="box_discrption "><@i18n key="IAM.SECURITY.QUESTION.DESCRIPTION" /></div>
								
			</div>
			
			
			<div class="box_content_div hide" id="SecQ_unconfirmed_user" >
					<div class="no_data no_data_SQ no_s_qus"></div>
					<div class="no_data_text"><@i18n key="IAM.SECQ.UNCONFIRMED.USER" /></div>
			</div>
			
			<div class="box_content_div hide" id="SecQ_Present">
				<div class="no_data no_s_qus no_data_SQ"></div>
				<div class="yes_data_text hide" id="secQ_ModifedTime"><@i18n key="IAM.LAST.MODIFIED.TIME" /><span id="secQ_time_sring"></span> </div>
				<button class="primary_btn_check center_btn " onclick="show_security_question_popup();"><span><@i18n key="IAM.SECURITY.QUEST.CHANGE" /></span></button>
			</div>
			
			<div class="box_content_div" id="SecQ_noPresent" >
					<div class="no_data no_s_qus no_data_SQ"></div>
					<div class="no_data_text"><@i18n key="IAM.SECURITY.QUEST.EMPTY" />  </div>
					<button class="primary_btn_check center_btn " onclick="show_security_question_popup();"><span><@i18n key="IAM.SECURITY.QUEST.ADD" /> </span></button>
			</div>	
			
			<div class="box_content_div hide" id="SecQ_fed_signin" >
					<div class="no_data no_data_SQ no_s_qus"></div>
					<div class="no_data_text"><@i18n key="IAM.PASSWORD.IDPUSER.DESC" arg0="${IDP_Name}"/></div>
					<button class="primary_btn_check center_btn " onclick="goToForgotPwd();"><span><@i18n key="IAM.PASSWORD.CREATE" /></span></button>
			</div>
			
		</div>
				
