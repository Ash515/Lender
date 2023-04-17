${za.config.css_content}

${za.config.js_content}
<script type='text/javascript'>
var userPasswordMinLen = ${userPassword.minlen};
var userPasswordMaxLen = ${userPassword.maxlen};
    Util.paramConfigure({
        "_sh" : "header,footer",
        "_embed" : {
	            ".containerbox" : {
	                style : "width: 100%; height: 100%; margin: 0px;border: none;box-shadow:none;padding:0px"
	            },
	            ".resetoutersection" : {
	                style : "width: 100%;margin: 0 auto;"
	                },
	                ".bodybg":{
	            	style:"background:none repeat scroll 0 0 #FFFFFF !important;"
	            },
	       		"#title":{
	            style:"display: none;"
	            },
	            ".margin":{
	            	style:"margin:10px;"
	            },
	            ".btn":{
        			'class':"btn"
        		}
        }
        
    });
    I18N.load({
        "IAM.ERROR.ENTER.LOGINPASS" : '<@i18n key="IAM.ERROR.ENTER.LOGINPASS" />',
        "IAM.ERROR.PASS.LEN" : '<@i18n key="IAM.ERROR.PASS.LEN" arg="${userPassword.minlen}" />',
		"IAM.ERROR.PASSWORD.MAXLEN" : '<@i18n key="IAM.ERROR.PASSWORD.MAXLEN" arg="${userPassword.maxlen}" />',
        "IAM.PASSWORD.POLICY.LOGINNAME" : '<@i18n key="IAM.PASSWORD.POLICY.LOGINNAME" />',
        "IAM.ERROR.WRONG.CONFIRMPASS" : '<@i18n key="IAM.ERROR.WRONG.CONFIRMPASS" />',
        "IAM.FORGOT.UPDATE.PASS" : '<@i18n key="IAM.FORGOT.UPDATE.PASS" />',
        "IAM.CONFIRMATION.CONTINUE" : '<@i18n key="IAM.CONFIRMATION.CONTINUE" />',
        "IAM.ERROR.GENERAL" : '<@i18n key="IAM.ERROR.GENERAL" />'
    });
    ZAConstants.load(${za.config});
</script>
