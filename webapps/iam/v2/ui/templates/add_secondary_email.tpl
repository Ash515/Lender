<html lang="en">
	<head>
		<meta charset="utf-8">
		<meta name="viewport"content="width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=no" />
		<script src="${za.js_url}/jquery-1.12.2.min.js" type="text/javascript"></script>
		<script src="${za.js_url}/add_secondary_email.js" type="text/javascript"></script>
		<script src="${za.js_url}/xregexp-all.js" type="text/javascript"></script>
		<link href="${za.css_url}/add_secondary_email.css" type="text/css" rel="stylesheet" />
	
	<script type="text/javascript">
	    var temp_token = "${temp_token}";
	    var csrfParamName = "${za.csrf_paramName}";
	    var csrfCookieName = "${za.csrf_cookieName}";
	    var cPath = "${za.contextpath}";
	    var i18nkeys = {
		    "IAM.SECONDARY.EMAIL.OTP.RESEND.SUCCESS" : '<@i18n key="IAM.SECONDARY.EMAIL.OTP.RESEND.SUCCESS" />',
		    "IAM.ERROR.VALID.OTP" : '<@i18n key="IAM.ERROR.VALID.OTP" />',
			"IAM.VERIFY.SECONDARY.EMAIL.OTP.TEXT" : '<@i18n key="IAM.VERIFY.SECONDARY.EMAIL.OTP.TEXT" />',
			"IAM.ERROR.ENTER.SIGNUP.EMAIL" : '<@i18n key="IAM.ERROR.ENTER.SIGNUP.EMAIL" />',
			"IAM.SECONDARY.EMAIL.ERROR.GENERAL" : '<@i18n key="IAM.SECONDARY.EMAIL.ERROR.GENERAL" />',
			"IAM.MYEMAIL.ADD.NEWEMAIL.SUCCESS" : '<@i18n key="IAM.MYEMAIL.ADD.NEWEMAIL.SUCCESS" />',
			"IAM.SECONDARY.EMAIL.ADDITION.SUCCESS" : '<@i18n key="IAM.SECONDARY.EMAIL.ADDITION.SUCCESS" />'
	    };
	</script>
		<style>
		@font-face {
			 font-family: 'Open Sans';
			 font-weight: 400;
			 font-style: normal;
			 src: local('Open Sans'), url('${za.img_url}/opensans/font.woff') format('woff'); <%-- NO OUTPUTENCODING --%>
		}
		</style>
	</head>
	<body>	
		<div class="Alert">
			<span id="message_icon"></span>
			<span class="alert_message"></span>
		</div>
		
		<div class="container">
			<img class="zoho_logo" src="${za.img_url}/zlogo.png"></img>
			<div id="sec_email_div">
			    <div class="heading"><@i18n key="IAM.ADD.SECONDARY.EMAIL.TEXT" /></div>
				<div class="description"><@i18n key="IAM.ADD.SECONDARY.EMAIL.DESCRIPTION" /></div>
				
				<div class="textbox_div">
					<input class="textbox" type="text" id="sec_email" onkeydown="remove_warning('sec_email', 'sec_email_div');" required> 
					<div class="textbox_line"></div>
					<label for="sec_email" class="textbox_label"><@i18n key="IAM.EMAIL.ADDRESS" /></label>
				</div>
				<div class="error_msg"><@i18n key="IAM.ERROR.ENTER.SIGNUP.EMAIL" /></div>
				<div class="button_block">
				<button class="btn" id="addemail"><@i18n key="IAM.ADD" />
				<span class="loading_gif"></span></button>
				</div>
			</div>
			<div id="otpdiv">
			    <div class="heading"><@i18n key="IAM.HOSTED.EMAIL.PREANNOUNCEMENT.MAIL.TITLE" /></div>
				<div class="description"><@i18n key="IAM.VERIFY.SECONDARY.EMAIL.OTP.TEXT" /> </div>
				<div class="emailchange"></div><span class="bluetext" id="changeemail"><@i18n key="IAM.PHOTO.CHANGE" /> </span>
				<div class="textbox_div">
					<input class="textbox" id="otp_input" type="number" onkeydown="remove_warning('otp_input', 'otpdiv');" required> 
					<div class="textbox_line"></div>
					<label for="otp_input" class="textbox_label"><@i18n key="IAM.VERIFY.CODE" /> </label>
					<span class="resend bluetext"><@i18n key="IAM.SECONDARY.EMAIL.RESEND.OTP" /> </span>
				</div>
				<span class="error_msg"><@i18n key="IAM.ERROR.VALID.OTP" /> </span>
				<div class="button_block"><button class="btn" id="verifyotp" onclick="verify_otp();"><@i18n key="IAM.TFA.VERIFY" /> 
				<span class="loading_gif"></span></button>
				</div>
			</div>
			
			<div id="error_page" class="errorbox" style="display: none;">
				<div class="logo_bg">
					<div class="zoho_logo center_logo"></div>
				</div>
				<div class="error_icon link_expire_icon"></div>
				<div class="discription center_text"><@i18n key="IAM.SECONDARY.EMAIL.TOKEN.EXPIRED" /></div>
            </div>
			
			<div id="email_addition_success" class="errorbox" style="display: none;">
				<div class="logo_bg">
					<div class="zoho_logo center_logo"></div>
				</div>
				<div class="error_icon success_icon"></div>
				<div class="discription center_text"><@i18n key="IAM.SECONDARY.EMAIL.ADDITION.SUCCESS"/></div>
				<button class="btn green center_btn" id="redirect_uri_btn"><@i18n key="IAM.CONTINUE" /></button>
            </div>
			
		</div>
	</body>
</html>
