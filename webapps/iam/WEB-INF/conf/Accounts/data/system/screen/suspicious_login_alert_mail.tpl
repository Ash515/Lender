<!DOCTYPE html>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
</head>
<body style="margin:0;padding:0;">
<table border="0" cellpadding="0" cellspacing="0" width="100%">
<table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse;max-width: 700px; min-width: 320px;width:100%;">
    <tr>
    <td align="left" style="padding:2% 2% 2% 2%;">
        <table border="0" cellpadding="0" cellspacing="0" width="100%">
            <tr border="0">
            <td>
                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                    <tr>
                    <td>
	                    <a href="<@i18n key="IAM.ALERT.SUSPICIOUS.HOME.LINK" arg0="${ztpl.SERVICE}"/>" style="display:inline-block;"><img src="cid:23abc@pc27" style="display: block;height: 30px;width: 80px;" /></a>
                    </td>
                    </tr>
                    <tr>
                    <td style="padding:20px 0 0 0;font-size: 24px;line-height: 48px;font-family: 'Open Sans','Trebuchet MS',sans-serif;">
                        <b><@i18n key="IAM.TPL.DEAR.FULLNAME" arg0="${ztpl.FIRST_NAME}"/></b>
                    </td>
                    </tr>
                    <tr>
                    <td style="padding:20px 0 0 0;font-size: 14px;line-height: 24px;font-family: 'Open Sans','Trebuchet MS',sans-serif;">
                         <@i18n key="IAM.ALERT.NEW.LOGIN.DETECTED" args0="${ztpl.SERVICE_NAME}" args1="${ztpl.EMAIL_ID}" args2="${ztpl.LOGIN_TIME}"/>
                    </td>
                    </tr>
                    <tr>
					<td style="padding:10px 0 0 0;font-size: 14px;line-height: 24px;font-family: 'Open Sans','Trebuchet MS',sans-serif;">
						<b style="width:80px;display:inline-table;"><@i18n key="IAM.ALERT.SHOW.DEVICE"/></b> ${ztpl.DEVICE}
					</td>
					</tr>
					<tr>
					<td style="padding:10px 0 0 0;font-size: 14px;line-height: 24px;font-family: 'Open Sans','Trebuchet MS',sans-serif;">
						<b style="width:80px;display:inline-table;"><@i18n key="IAM.LOGINHISTORY.BROWSERAGENT.BROWSER"/></b> ${ztpl.BROWSER}
					</td>
					</tr>
                    <tr>
					<td style="padding:10px 0 0 0;font-size: 14px;line-height: 24px;font-family: 'Open Sans','Trebuchet MS',sans-serif;">
						<b style="width:80px;display:inline-table;"><@i18n key="IAM.ALERT.SHOW.REGION"/></b> ${ztpl.LOCATION}
						<br>
						<span style="color:#666;font-size:12px;display:inline-block;margin-left:85px"><@i18n key="IAM.SIGNIN.ALERT.IPADDRESS.INFO" args0="${ztpl.IP_ADDRESS}"/></span>
					</td>
					</tr>
					<tr>
					<td style="padding:20px 0 0 0;font-size: 14px;line-height: 24px;font-family: 'Open Sans','Trebuchet MS',sans-serif;">
						<@i18n key="IAM.ALERT.SUSPICIOUS.CHECK.ACTIVITY" args0="${ztpl.CHECK_ACTIVITY_URL}" args1="${ztpl.LEARN_MORE_URL}"/>
					</td>
					</tr>
                    <tr>
                    <td style="padding:20px 0 0 0;font-size: 14px;line-height: 24px;font-family: 'Open Sans','Trebuchet MS',sans-serif;">
                        <@i18n key="IAM.TPL.REGARDS"/><br>
                    </td>
                    </tr>
                    <tr>
                    <td style="font-size: 14px;line-height: 24px;font-family: 'Open Sans','Trebuchet MS',sans-serif;">
                         <b><@i18n key="IAM.ALERT.TEAM" args0="${ztpl.SERVICE_NAME}"/></b><br>
                    </td>
                    </tr>
                    <tr>
                    <td style="font-size: 14px;line-height: 24px;font-family: 'Open Sans','Trebuchet MS',sans-serif;">
	                	<a href="<@i18n key="IAM.ALERT.SUSPICIOUS.HOME.LINK" arg0="${ztpl.SERVICE}"/>" style="color:#2696eb;text-decoration:none;"><@i18n key="IAM.ALERT.SUSPICIOUS.HOME.LINK.TEXT" arg0="${ztpl.SERVICE}"/></a>
                    </td>
                    </tr>
                    <tr style="font-size: 14px;line-height: 24px;font-family: 'Open Sans','Trebuchet MS',sans-serif;">
		                    <td style="padding:20px 0 20px 0;font-size: 14px;line-height: 24px;font-family: 'Open Sans','Trebuchet MS',sans-serif;">
		                        <@i18n key="IAM.NEW.SIGNIN.ALERT.NOTIFICATION.CONTACTUS" arg0="${ztpl.CONTACT_ID}"/>
		                    </td>
		             </tr>
                    <tr>
                    <td style="border-bottom: 3px solid #339e72;">
                        <img src="<@image cid="23abc@pc29" img_path="${ztpl.IMG_PATH}/mailbottomimg.gif" />" style="display: block;width: 100%;height: auto !important;" />
                    </td>
                    </tr>
                </table>
            </td>
            </tr>
        </table>
        <table>
            <tr>	
                <td style="padding:10px 0 10px 0;font-size: 12px;color:#757575;line-height: 22px;font-family: 'Open Sans','Trebuchet MS',sans-serif;">
                    <@i18n key="IAM.TPL.ZOHO.ADDRESS" /><br><@i18n key="IAM.TPL.SPAM.TEXT" />
                </td>
            </tr>
        </table>
    </td>
    </tr>
</table>
</table>
</body>
</html>