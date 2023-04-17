${za.config.css_content}

${za.config.js_content}
<script type='text/javascript'>
var userPasswordMinLen = ${userPassword.minlen};
var userPasswordMaxLen = ${userPassword.maxlen};
	Util.paramConfigure({
		"_sh" : "header,footer",
		"_embed" : {
			".containerbox" : {
				style : "width: 100%;height: 100%;margin: 0px;border: none;box-shadow:none;padding:0px"
			},
			".bodybg":{
            	style:"background:none repeat scroll 0 0 #FFFFFF !important;"
            },
			".invitationoutersection" : {
				style : "width: 100%;margin: 0 auto;"
			},
			".invitationcontainer" : {
				style : "margin: 0;"
			},
			".btn":{
        		'class':"btn"
        	}
		}
	});
	I18N.load({
		"IAM.ERROR.ENTER.LOGINPASS" : '<@i18n key="IAM.ERROR.ENTER.LOGINPASS" />',
		"IAM.ERROR.PASSWORD.INVALID" : '<@i18n key="IAM.ERROR.PASSWORD.INVALID" />',
		"IAM.ERROR.PASS.LEN" : '<@i18n key="IAM.ERROR.PASS.LEN" arg="${userPassword.minlen}" />',
		"IAM.ERROR.PASSWORD.MAXLEN" : '<@i18n key="IAM.ERROR.PASSWORD.MAXLEN" arg="${userPassword.maxlen}" />',
		"IAM.PASSWORD" : '<@i18n key="IAM.PASSWORD" />',
		"IAM.PHONE.MOBILE.ALREADY.EXIST" : '<@i18n key="IAM.PHONE.MOBILE.ALREADY.EXIST" />',
		"IAM.ERROR.INVALID_IMAGE_TEXT" : '<@i18n key="IAM.ERROR.INVALID_IMAGE_TEXT" />',
		"IAM.ERROR.ENTER.CONTACTNAME" :  '<@i18n key="IAM.ERROR.ENTER.CONTACTNAME" />',
		"IAM.ERROR.LASTNAME.MANDATORY" : '<@i18n key="IAM.ERROR.LASTNAME.MANDATORY" />',
		"IAM.ERROR.SIGNUP.DIFFERENT.REGION" : '<@i18n key="IAM.ERROR.SIGNUP.DIFFERENT.REGION" />',
		"IAM.ERROR.GENERAL" : '<@i18n key="IAM.ERROR.GENERAL" />'
	});
	$(document).ready(function() {
		$("#afterclick").hide();
	});
	ZAConstants.load(${za.config});
</script>