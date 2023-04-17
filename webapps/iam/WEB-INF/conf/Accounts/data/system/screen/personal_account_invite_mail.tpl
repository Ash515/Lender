<html>
<body style="font-family: 'Lucida Grande', 'Lucida Sans Unicode', Helvetica, Roboto, DejaVu Sans, sans-serif; font-size: 12px; background-color: #FFFFFF; color: #333333;">
	<div style="width: 700px;">
		<div style="background-color: #FFFFFF; border: #E5E5E5 solid 1px; -moz-box-shadow: 0 0 3px #F1F1F1; -webkit-box-shadow: 0 0 3px #F1F1F1; box-shadow: 0 0 3px #F1F1F1;">
			<div style="background-color: #F4F4F4; height: 36px;">
				<a href="<@i18n key="IAM.HOME.LINK" />"><img src="cid:23abc@pc27" width="73" height="25" style="margin: 4px 0px 0px 10px; border: 0px" /></a>
			</div>
			<div style="padding: 10px; line-height: 18px;">
				<div style="font-size: 12px;"><@i18n key="IAM.TPL.DEAR.FULLNAME" arg0="${ztpl.EMAIL_ID}"/></div>
				<div style="font-size: 12px; font-weight: bold; padding: 10px 0 0 0;"><@i18n key="IAM.TPL.WELCOME.ZOHO.TEXT" /></div>
				<div style="font-size: 12px; padding: 10px 0 0 0;"><@i18n key="IAM.TPL.INVITED.ZOHO" arg0="${ztpl.LOGIN_USER_FIRST_NAME}"/></div>
				<div style="padding: 20px 0px 10px 0px;">
					<div style="background-color: #2C8ECE; border-radius: 4px; text-align: center; font-size: 14px; color: #FFFFFF; line-height: 30px; width: auto; float: left;padding:0 10px;">
						<a href="${ztpl.URL}"><span style="color: #FFFFFF; font-size: 14px; text-decoration: underline; margin: 5px 12px 0px;"><@i18n key="IAM.TPL.JOIN.ZOHO.HREF.TEXT"/></span></a>
					</div>
					<div style="clear: both;"></div>
				</div>
				<div style="font-size: 12px; padding: 10px 0 0 0;"><@i18n key="IAM.TPL.EMAIL.IGNORE.NEW" args0="${ztpl.IP_ADDRESS}" /></div>
				<div style="font-size: 12px; padding: 10px 0 0 0; line-height: 16px;">
					<@i18n key="IAM.TPL.THANKS" /><br><@i18n key="IAM.TPL.ZOHO.TEAM" /><br> <a href="<@i18n key="IAM.HOME.LINK" />" style="color:#00f;"><@i18n key="IAM.HOME.LINK" /></a>
				</div>
				<div style="font-size: 12px; padding: 10px 0 0 0;"><@i18n key="IAM.TPL.SUBSCRIPTION" /></div>
			</div>
		</div>
		<div style="padding: 5px 0px 0px 10px;">
			<div style="font-size: 11px; color: #AEAEAE;"><@i18n key="${ztpl.OFFICE_ADDRESS_I18N_KEY}"/></div>
			<div style="font-size: 11px; color: #AEAEAE; padding: 8px 0px;"><@i18n key="IAM.NEW.TPL.SPAM.TEXT" args0="${ztpl.ABUSE_ID}"/></div>
			  
		</div>
	</div>
</body>
</html>