<#if (error_code)?has_content>

<html>
	<head>
		<title><@i18n key="IAM.GRPINVITATION.TITLE" /></title>
		<link href="${za.css_url}/accountUnauthStyle.css" rel="stylesheet"type="text/css" />
		<meta name="viewport"content="width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=no" />
	</head>
	<body>
    	<div style="overflow:auto">
			<div class="centerContainer container" >
				<div class="header error_header" id="header">
   					<img class="zoho_logo" src="${za.img_url}/zoho.png"/>   
					<div class="page_type_indicator icon-invalid"></div>
	        	</div>

	        	<div class="wrap">  
		        	<div class="info">
					    <div id="msgboard">
					    	<div class="head_text">${error_code}</div>
					    	<div class="description">${error_desc}</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</body>
</html>


<#else>


<html>
	<head>
		<title><@i18n key="IAM.GRPINVITATION.TITLE" /></title>

		<script src="${za.tpkg_url}/jquery-3_5_1.min.js"></script>	
		<script src="${za.js_url}/zresource.js" type="text/javascript"></script> 
		<script src="${za.js_url}/uri.js" type="text/javascript"></script> 
		<script src="${za.js_url}/common_unauth.js"></script>
    	<script src="${za.tpkg_url}/select2.full.min.js" type="text/javascript"></script>
		<link href="${za.css_url}/accountUnauthStyle.css" rel="stylesheet"type="text/css" />
		<script src="${za.js_url}/invitation.js"></script>
		
		<script type="text/javascript">
		
			var passwordPolicy = undefined;
			
			<#if ((passwordPolicy)?has_content)>
			 passwordPolicy = '${passwordPolicy}';
			</#if>
			 
			var digest ="${digest}";
			var signupRequired = ${signupRequired};
			if(passwordPolicy!=""){
				PasswordPolicy.data = JSON.parse(passwordPolicy);
			}

			I18N.load({
				"IAM.ERROR.ENTER_PASS" : '<@i18n key="IAM.ERROR.ENTER_PASS" />',
				"IAM.ERROR.ENTER.NEW.PASSWORD" : '<@i18n key="IAM.ERROR.ENTER.NEW.PASSWORD" />',
				"IAM.ERROR.INVITATION.PASSWORD.INVALID" : '<@i18n key="IAM.ERROR.INVITATION.PASSWORD.INVALID" />',
				"IAM.PASSWORD.ERROR.WRONG.CONFIRMPASS" : '<@i18n key="IAM.PASSWORD.ERROR.WRONG.CONFIRMPASS" />',
				"IAM.REENTER.PASSWORD" : '<@i18n key="IAM.REENTER.PASSWORD" />',
				"IAM.ERROR.EMPTY.FIELD" : '<@i18n key="IAM.ERROR.EMPTY.FIELD" />',
				"IAM.ACCOUNT.SIGNUP.POLICY.ERROR.TEXT" : '<@i18n key="IAM.ACCOUNT.SIGNUP.POLICY.ERROR.TEXT" />',
				"IAM.SEARCH" : '<@i18n key="IAM.SEARCH" />'
			});
    
			$(function() {	
				if(signupRequired) {
					setSelect2WithFlag('#localeCn');
				}
			});
		</script>
		<meta name="viewport"content="width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=no" />
	</head>
	<body>
		<#assign tos_link><@i18n key="IAM.LINK.TOS" /></#assign> <#assign privacy_link><@i18n key="IAM.LINK.PRIVACY" /></#assign>
		<div class="blur"></div>
		<div class="grp_invite_bg"></div>

		<div id="error_space">
			<div class="top_div">
				<span class="cross_mark"> 
				<span class="crossline1"></span>
				<span class="crossline2"></span>
				</span>
				<span class="top_msg"></span>
			</div>
		</div>

		<div class="result_popup hide" id="result_popup_accepted">
			<div class="success_icon icon-tick"></div>
			<div class="grn_text" id="result_content"><@i18n key="IAM.INVITATION.ACCEPTED.TITLE"/></div>
			<div class="defin_text"><@i18n key="IAM.GROUP.INVITATION.ACCEPTED.SUCCESS"/></div>
			<button class="btn green_btn center_btn" ><@i18n key="IAM.CONTINUE"/></button>
		</div>

		<div class="result_popup hide" id="result_popup_rejected">
			<div class="success_icon icon-tick"></div>
			<div class="grn_text" id="result_content"><@i18n key="IAM.INVITATION.REJECTED.TITLE"/></div>
			<div class="defin_text"><@i18n key="IAM.GROUP.INVITATION.REJECTED.SUCCESS"/></div>
		</div>

    	<div style="overflow:auto">
	        <div class="container" >
        		<div id="header">
        			<img class="zoho_logo" src="${za.img_url}/zoho.png"/>   
        		</div>

        		<div class="wrap">  
	        		<div class="info">
			        	<div id="acceptGroupInvite">
			        		<div class="head_text"><@i18n key="IAM.GROUPINVITATION.TITLE" /></div>
			        		<#if ((inviter_name)?has_content)>
							<div class="normal_text"><@i18n key="IAM.GROUPINVITATION.SUBTITLE.BYINVITE" arg0="${inviter_name}" arg1="${group.name}"/></div>
							<#else>
							<div class="normal_text"><@i18n key="IAM.GROUPINVITATION.SUBTITLE" arg0="${group.name}"/></div>
							</#if>	
							<div class="selectedbox highlight_selectmode" style="overflow:auto;" >
								<span class="grp_pro_pic" style="background:url(${group.photourl}),url(${za.img_url}/group_2.png) no-repeat transparent;background-size:cover;"></span>
								<div  class="description_con" >
									<div class="text"><b>${group.name}</b></div>
									<div class="grp_description">${group.description}</div>
								</div>
							</div>
				    		<button class="btn green_btn" id="accept_btn" onclick="accept_group_invitation(${signupRequired})"><@i18n key="IAM.CONTACTS.ACCEPT" /> </button>
				    		<button class="btn grey_btn" id="reject_btn" onclick="reject_group_invitation()"><@i18n key="IAM.INVITE.REJECT" /> </button>
			        	</div>

						<#if signupRequired=="true">
						<div class="signup_container hide" id="signup_container">
							<div class="head_text"><@i18n key="IAM.GROUPINVITATION.TITLE" /></div>
							<div class="normal_text"><@i18n key="IAM.GROUPINVITATION.SIGNUP.DEFINITION" arg0="${emailId}"/></div>
							<form name="signup_form" novalidate onsubmit="return false;">
								<div class="text_field_area">
									<div class="textbox_div" id="first_name_field">
										<input name="first_name" class="textbox" tabindex="1" id="first_name" autocomplete="off" onkeypress="err_remove()" required=""/>
										<span class="textbox_line"></span>
										<label for="pass" class="textbox_label"><@i18n key="IAM.GENERAL.FIRSTNAME" /></label>
									</div>

									<div class="textbox_div" id="last_name_field">
										<input name="last_name" class="textbox" id="last_name" tabindex="1" autocomplete="off" onkeypress="err_remove()" required=""/>
										<span class="textbox_line"></span>
										<label for="pass" class="textbox_label"><@i18n key="IAM.GENERAL.LASTNAME" /></label>
									</div>

									<div class="textbox_div" id="password_field">
										<input name="password" class="textbox" tabindex="1" id="signup_pass" onkeypress="err_remove()" onkeyup="validatePassword('#signup_pass')" autocomplete="off" required="" type="password"/>
										<span class="textbox_line"></span>
										<span class="pass_allow_indi gray_tick"></span>
										<label for="pass" class="textbox_label"><@i18n key="IAM.PASSWORD" /></label>
										<div class="password_indicator" style="display:none">
											<span class="gray_tick" id="char_check"><@i18n key="IAM.ACCOUNTCONFIRM.PASSWORD.CHARACTER" arg0="${passwordPolicy.min_length}"/></span>
											<#if passwordPolicy.min_numeric_chars == 1>
											<span class="gray_tick" id="num_check"><@i18n key="IAM.ACCOUNTCONFIRM.PASSWORD.NUMBER"/></span>
											<#elseif passwordPolicy.min_numeric_chars > 1>
											<span class="gray_tick" id="num_check"><@i18n key="IAM.ACCOUNTCONFIRM.PASSWORD.NUMBERS" arg0="${passwordPolicy.min_numeric_chars}"/></span>
											</#if>
											
											<#if passwordPolicy.min_spl_chars == 1>
											<span class="gray_tick" id="spcl_char_check"><@i18n key="IAM.ACCOUNTCONFIRM.PASSWORD.SPECICAL.CHARACTER"/></span>
											<#elseif passwordPolicy.min_spl_chars > 1>
											<span class="gray_tick" id="spcl_char_check"><@i18n key="IAM.ACCOUNTCONFIRM.PASSWORD.SPECICAL.CHARACTERS" arg0="${passwordPolicy.min_spl_chars}"/></span>
											</#if>
		
											<#if passwordPolicy.mixed_case == true>
											<span class="gray_tick" id="uppercase_check"><@i18n key="IAM.ACCOUNTCONFIRM.PASSWORD.UPPERCASE"/></span>
											<span class="gray_tick" id="lowercase_check"><@i18n key="IAM.ACCOUNTCONFIRM.PASSWORD.LOWERCASE"/></span>
											</#if>
										</div>
									</div>
									<div class="textbox_div" id="confirm_password_field">
										<input name="con_password" class="textbox" tabindex="1"  onkeyup="validateConfirmPassword('#signup_pass')" id="confirm_pass" onkeypress="err_remove()" autocomplete="off" required="" type="password"/>
										<span class="textbox_line"></span>
										<span class="pass_allow_indi gray_tick"></span>
										<label for="pass" class="textbox_label"><@i18n key="IAM.CONFIRM.PASS" /></label>
									</div>
								</div>

								<div class="field textbox_div textbox_inline "> 
									<select class="profile_mode" autocomplete='country-name' name="country" id="localeCn">
										<#list Countries as countrydata>
											<#assign count_data=countrydata.data >
                          					<option value="${count_data.ISO2_CODE}" id="${count_data.ISO2_CODE}" >${count_data.DISPLAY_NAME}</option>
										</#list>
									</select>
									<div class="textbox_label"><@i18n key="IAM.COUNTRY" /></div>
								</div>

								<div class="authorize_check">
									<input type="checkbox" onclick="err_remove()" class="trust_check" id="news_letter" name="news_letter"/>
									<span class="auth_checkbox">
										<span class="checkbox_tick"></span>
									</span> 
									<label for="news_letter"><@i18n key="IAM.USERPREFERENCE.NEWSLETTER.SUBSCRIBE" /></label>
								</div>

								<div class="authorize_check" style="margin-top:15px;">
									<input type="checkbox" onclick="err_remove()" class="trust_check" id="tos_check" name="tos_check"/> 
									<span class="auth_checkbox"> 
										<span class="checkbox_tick"></span>
									</span> 
									<label for="tos_check"><@i18n key="IAM.SIGNUP.AGREE.TERMS.OF.SERVICE" arg0="${tos_link}" arg1="${privacy_link}" /></label>
								</div>
								<button class="btn green_btn" name="signup_button" onclick="accept_group_invitation(${signupRequired})"><@i18n key="IAM.JOIN" /> </button>
							</form>
						</div>
						</#if>
	        		</div>		  
    			</div>		
    		</div>
    	</div>
	</body>
	<script>
		window.onload=function() {
			try {
    			URI.options.contextpath="${za.contextpath}/webclient/v1";//No I18N
				URI.options.csrfParam = "${za.csrf_paramName}";
				URI.options.csrfValue = getCookie("${za.csrf_cookieName}");
			}catch(e){}
		}
	</script>
</html>

</#if>
