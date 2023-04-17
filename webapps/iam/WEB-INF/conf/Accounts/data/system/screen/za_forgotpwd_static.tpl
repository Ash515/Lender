${za.config.css_content}

${za.config.js_content}
<script type='text/javascript'>
var userPasswordMinLen = ${userPassword.minlen};
var userPasswordMaxLen = ${userPassword.maxlen};
    Util.paramConfigure({
        "_sh" : "header,footer",
        "_hn":{
            ".field-msg" : {
                style : "display: none;"
            },
            ".notes_text":{
                style : "display: none;"
            }
        },
        "_embed" : {
        ".bodybg":{
            	style:"background:none repeat scroll 0 0 #FFFFFF !important;"
            },
            "#title":{
            style:"display: none;"
            },
            ".containerbox":{
            	style:"margin:0 auto;padding: 0;border:none;box-shadow:none;padding:0px;"
            },
            ".margin":{
            style:"margin:10px;"
            },
            ".forgotoutersection" : {
                style : "width: 100%;margin: 0 auto;"
            },
            ".recoverymainpage" : {
                style : "width: 100%;margin: 0 auto;"
            },
            ".recoveryoptions" : {
                style : "width: 100%;margin: 0 auto;"
            },
            ".btn":{
        		'class':"btn"
        	}
        }
    });
        
    I18N.load({
        "IAM.ERROR.RECOVERY.MANDATORY" : '<@i18n key="IAM.ERROR.RECOVERY.MANDATORY" />',
        "IAM.ERROR.WORD.IMAGE" : '<@i18n key="IAM.ERROR.WORD.IMAGE" />',
        "IAM.ERROR.INVALID_IMAGE_TEXT" : '<@i18n key="IAM.ERROR.INVALID_IMAGE_TEXT" />',
        "IAM.ERROR.GENERAL" : '<@i18n key="IAM.ERROR.GENERAL" />',
        "IAM.SECURITY.NOTIFICATION.FAILED" : '<@i18n key="IAM.SECURITY.NOTIFICATION.FAILED" />',
        "IAM.FORGOT.PASSWORD.RECOVERY" : '<@i18n key="IAM.FORGOT.PASSWORD.RECOVERY" />',
        "IAM.FORGOT.PASSWORD.SECOND.DIV" : '<@i18n key="IAM.FORGOT.PASSWORD.SECOND.DIV" />',
        "IAM.GENERAL.RECOVERY.PASSWORD" : '<@i18n key="IAM.GENERAL.RECOVERY.PASSWORD" />',
        "IAM.ERROR.RECOVERY.MANDATORY" : '<@i18n key="IAM.ERROR.RECOVERY.MANDATORY" />',
        "IAM.ERROR.SECURITYQA.EMPTY" : '<@i18n key="IAM.ERROR.SECURITYQA.EMPTY" />',
        "IAM.ERROR.MOBILEVERIFY.EMPTY" : '<@i18n key="IAM.ERROR.MOBILEVERIFY.EMPTY" />',
        "IAM.ERROR.USER.NOTEXIST" : '<@i18n key="IAM.ERROR.USER.NOTEXIST" />',
        "iam.securityqa.last.passwordhistory" : '<@i18n key="iam.securityqa.last.passwordhistory" />',
        "iam.securityqa.last.passwordhistory.empty" : '<@i18n key="iam.securityqa.last.passwordhistory.empty" />',
        "IAM.RECOVERY.EMAIL.NOTES" : '<@i18n key="IAM.RECOVERY.EMAIL.NOTES" />',
        "IAM.MOBILE.VERIFICATION.CODE.NOTES" : '<@i18n key="IAM.MOBILE.VERIFICATION.CODE.NOTES" />',
        "IAM.FORGOTPASS.SUCCESS.TXT.NEW" : '<@i18n key="IAM.FORGOTPASS.SUCCESS.TXT.NEW" />',
        "IAM.FORGOTPASS.NOTES" : '<@i18n key="IAM.FORGOTPASS.NOTES" />',
        "IAM.ERROR.PASS.LEN" : '<@i18n key="IAM.ERROR.PASS.LEN" arg="${userPassword.minlen}" />',
		"IAM.ERROR.PASSWORD.MAXLEN" : '<@i18n key="IAM.ERROR.PASSWORD.MAXLEN" arg="${userPassword.maxlen}" />',
        "IAM.FORGOT.ERROR.SENDING" : '<@i18n key="IAM.FORGOT.ERROR.SENDING" />'
    });
    ZAConstants.load(${za.config});
</script>