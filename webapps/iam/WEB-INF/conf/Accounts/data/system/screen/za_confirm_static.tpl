${za.config.css_content}

${za.config.js_content}
<script type='text/javascript'>
	I18N.load({
		"IAM.ERROR.ENTER.LOGINPASS" : '<@i18n key="IAM.ERROR.ENTER.LOGINPASS" />',
		"IAM.REGISTER.REMOTE.IP.LOCKED" : '<@i18n key="IAM.REGISTER.REMOTE.IP.LOCKED" />',
		"IAM.ERROR.GENERAL" : '<@i18n key="IAM.ERROR.GENERAL" />'
	});
	Util.paramConfigure({
		"_sh" : "header1,footer,#title,#invhints"
	});
	ZAConstants.load(${za.config});
</script>
