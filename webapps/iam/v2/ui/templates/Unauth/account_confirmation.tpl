<html>

	<head>
	
		<title><@i18n key="IAM.EMAILCONFIRM.TITLE" /></title>

		<script src="${za.tpkg_url}/jquery-3_5_1.min.js"></script>	
		<script src="${za.js_url}/zresource.js" type="text/javascript"></script> 
		<script src="${za.js_url}/uri.js" type="text/javascript"></script> 
		<script src="${za.js_url}/common_unauth.js"></script>
		<link href="${za.css_url}/accountUnauthStyle.css" rel="stylesheet"type="text/css"/>
		
		<script type="text/javascript">
			var redirectUrl = "${redirectUrl}";
			<#if !((error_code)?has_content)>
				var passwordPolicy = '${passwordPolicy}';
				var digest ="${digest}";
				var hasPassword = ${hasPassword};
				var isPasswordRequired = ${isPasswordRequired};
				var current_pass_err = '<@i18n key="IAM.ERROR.ENTER_PASS"/>';
				var new_pass_err = '<@i18n key="IAM.ERROR.ENTER.NEW.PASSWORD"/>';
				var valid_pass_err = '<@i18n key="IAM.PASSWORD.INVALID.POLICY"/>';
				var password_mismatch_err = '<@i18n key="IAM.PASSWORD.ERROR.WRONG.CONFIRMPASS"/>';
				var network_common_err = '<@i18n key="IAM.EXCEPTION.OCCURED"/>'
				var reenter_err = '<@i18n key="IAM.REENTER.PASSWORD"/>';
				if(passwordPolicy!=""){
					PasswordPolicy.data = JSON.parse(passwordPolicy);
				}
			</#if>
		</script>
		<script src="${za.js_url}/account_confirmation.js"></script>
		
		<meta name="viewport"content="width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=no" />
		
	</head>
	<body>
		<div id="error_space">
			<div class="top_div">
				<span class="cross_mark"> <span class="crossline1"></span> <span
					class="crossline2"></span>
				</span> <span class="top_msg"></span>
			</div>
		</div>
		<div class="blur"></div>
		<div style="overflow:auto">
		
			<#if ((error_code)?has_content)>
			<div class="container centerContainer">			
			<#if (error_code == ErrorCode.DIGEST_ALREADY_VALIDATED)>
				<div class="header " id="header">			
			<#else>
				<div class="header error_header" id="header">
			</#if>
					<img class="zoho_logo" src="${za.img_url}/zoho.png"/>

					<#if (error_code == ErrorCode.DIGEST_ALREADY_VALIDATED)>
					<div class="page_type_indicator icon-tick"></div>
					<#else>
					<div class="page_type_indicator icon-invalid"></div>
					</#if>
				</div>
				
				<div class="wrap normal_text">
					<div class="info">
	    										
						<#if error_code == ErrorCode.DIGEST_ALREADY_VALIDATED>
						
							<div class="head_text"><@i18n key="IAM.CONFIRMATION.ERROR.ALREADY.CONFIRMED"/></div>
							<div class="description"><@i18n key="IAM.ACCOUNTCONFIRM.ALREADYCONFIRMED.DESC" arg0="${emailId}"/></div>
							<button class="btn green_btn center_btn" onclick="redirectLink(redirectUrl,this)"><@i18n key="IAM.CONTINUE"/></button>
						
						<#else>
						
							<div class="head_text"><@i18n key="IAM.ACCOUNTCONFIRM.URLINVALID"/></div>
							<div class="description"><@i18n key="IAM.ERROR.INVALID.URL.DESC"/></div>
						
						</#if>
	    			</div>
	    		</div>
			</div>
    		<#else>
    			<div class="acc_confirm_bg"></div>
    			<div class="container">
    				<div class="header" id="header">
    					<img class="zoho_logo" src="${za.img_url}/zoho.png">  
    				</div>
	    			<div class="wrap">  
	    				<div class="info">
	    					<div class="head_text"><@i18n key="IAM.ACCOUNTCONFIRM.HEADER"/></div>
	    					<form name="confirm_form" class="" novalidate onsubmit="return false;">
		    					
		    					<#if hasPassword == "false">
		    							<div class="description"><@i18n key="IAM.ACCOUNTCONFIRM.PASSWORD.CREATE" arg0="${emailId}"/></div>
				    					<div class="textbox_div" id="pass_field">
				                    		<input type="password" autocomplete="off" class="textbox" required="" tabindex="1" id="pass_input" onkeyup="validatePassword('#pass_input')" onkeydown="err_remove();" name="pass">
				                    		<span class="textbox_line"></span>
				                    		<span class="pass_allow_indi gray_tick"></span>
				                    		<label for="email" class="textbox_label"><@i18n key="IAM.PASSWORD"/></label>
				                		</div>
			                    		<div class="password_indicator" style="display:none">

			                    				<span class="gray_tick" id="char_check"><@i18n key="IAM.ACCOUNTCONFIRM.PASSWORD.CHARACTER" arg0="${passwordPolicy.min_length}"/></span>
			             					<#if passwordPolicy.min_numeric_chars != 0>
			             						<#if passwordPolicy.min_numeric_chars == 1>
			                    				<span class="gray_tick" id="num_check"><@i18n key="IAM.ACCOUNTCONFIRM.PASSWORD.NUMBER"/></span>
			                    				<#else>
			                    				<span class="gray_tick" id="num_check"><@i18n key="IAM.ACCOUNTCONFIRM.PASSWORD.NUMBERS" arg0="${passwordPolicy.min_numeric_chars}"/></span>
			                    				</#if>
			                    			</#if>
			                    			<#if passwordPolicy.min_spl_chars != 0>
			                    				<#if passwordPolicy.min_spl_chars == 1>
		                    					<span class="gray_tick" id="spcl_char_check"><@i18n key="IAM.ACCOUNTCONFIRM.PASSWORD.SPECICAL.CHARACTER"/></span>
		                    					<#else>
			                    				<span class="gray_tick" id="spcl_char_check"><@i18n key="IAM.ACCOUNTCONFIRM.PASSWORD.SPECICAL.CHARACTERS" arg0="${passwordPolicy.min_spl_chars}"/></span>
		                    					</#if>
		                    				</#if>
		                    				<#if passwordPolicy.mixed_case == true>
			                    				<span class="gray_tick" id="uppercase_check"><@i18n key="IAM.ACCOUNTCONFIRM.PASSWORD.UPPERCASE"/></span>
			                    				<span class="gray_tick" id="lowercase_check"><@i18n key="IAM.ACCOUNTCONFIRM.PASSWORD.LOWERCASE"/></span>
		                    				</#if>
			                    		</div>
				                		<div class="textbox_div" id="conform_pass_field">
				                    		<input type="password" autocomplete="off" tabindex="1" class="textbox" onkeyup="validateConfirmPassword('#pass_input')"  required="" id="pass_conform_input" onkeydown="err_remove();" name="confirm_pass" >
				                    		<span class="textbox_line"></span>
				                    		<span class="pass_allow_indi gray_tick"></span>
				                    		<label for="email" class="textbox_label"><@i18n key="IAM.CONFIRM.PASS"/></label>
				                		</div>
				                		<button id="password_conform_btn" name="confirm_btn" class="btn green_btn "  onclick="confirmAccount()"><@i18n key="IAM.BUTTON.VERIFY"/></button>
			                	<#elseif isPasswordRequired == "true">
			                			<div class="description"><@i18n key="IAM.ACCOUNTCONFIRM.PASSWORD.ENTER" arg0="${emailId}"/></div>
			                			<div class="textbox_div" id="pass_field">
				                    		<input type="password" autocomplete="off" class="textbox" tabindex="1" required="" id="confirm_pass_input" onkeydown="err_remove();" name="pass" >
				                    		<span class="textbox_line"></span>
				                    		<label for="email" class="textbox_label"><@i18n key="IAM.PASSWORD"/></label>
				                		</div>
				                		<button id="password_conform_btn" name="confirm_btn" class="btn green_btn " onclick="confirmAccount()"><@i18n key="IAM.BUTTON.VERIFY"/></button>
			                	<#else>
		    					
		    						<div class="description"><@i18n key="IAM.ACCOUNTCONFIRM.VERIFY.TEXT" arg0="${emailId}"/></div>
	    							<div class="textbox_div" style="margin-top:0px;"></div>
		    						<button id="accountconfirm" class="btn green_btn" name="confirm_btn" onclick="confirmAccount()"><@i18n key="IAM.BUTTON.VERIFY"/></button>
		    					</#if>
	    					</form>
	    				</div>
	    			</div>
					<div id="result_popup" class="hide result_popup">
						<div class="success_icon icon-tick"></div>
						<div class="grn_text"><@i18n key="IAM.CONFIRMATION.SUCCESS.VERIFIED.HEAD"/></div>
						<div class="defin_text"><@i18n key="IAM.ACCOUNTCONFIRM.VERIFIED.TEXT" arg0="${emailId}"/></div>
						<button class="btn green_btn center_btn" onclick="redirectLink(redirectUrl,this)"><@i18n key="IAM.CONFIRMATION.CONTINUE_ACCOUNT"/></button>
					</div>	
    			</#if>
		</div>
			
	</body>
	<script>
		window.onload=function() {
			try 
			{
    			URI.options.contextpath="${za.contextpath}/webclient/v1";//No I18N
				URI.options.csrfParam = "${za.csrf_paramName}";
				URI.options.csrfValue = getCookie("${za.csrf_cookieName}");
			}catch(e){}
		}
	</script>
</html>