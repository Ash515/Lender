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
                    <td style="font-size: 24px;line-height: 48px;font-family: 'Open Sans','Trebuchet MS',sans-serif;">
                    <b><@i18n key="IAM.ALERT.SUSPICIOUS.TITLE" /></b>
                    </td>
                    </tr>
                    <tr>
                    <td style="padding:20px 0 0 0;font-size: 14px;line-height: 24px;font-family: 'Open Sans','Trebuchet MS',sans-serif;">
                         <@i18n key="IAM.ALERT.SUSPICIOUS.LOGIN.DETECTED" args0="${ztpl.ORG_USER_EMAIL}" args1="${ztpl.LOGIN_TIME}"/>
                    </td>
                    </tr>
                    <tr>
                    <td style="padding:20px 0 0 0;font-size: 14px;line-height: 24px;font-family: 'Open Sans','Trebuchet MS',sans-serif;">
                         <b><@i18n key="IAM.ALERT.SHOW.REGION"/></b> : ${ztpl.LOCATION}
                         <a title="<@i18n key="IAM.SIGNIN.SUSPICIOUS.ALERT.IPADDRESS.INFO" args0="${ztpl.IP_ADDRESS}"/>" style="display: inline-block;width: 12px;height: 12px;font-size: 10px;line-height: 14px;border-radius: 50px;color: #fff;background: #d2d2d2;text-align:center;text-decoration:none;border: 1px solid #333;color:#333;">i</a>
                    </td>
                    </tr>
                    <tr>
                    <td style="padding:10px 0 0 0;font-size: 14px;line-height: 24px;font-family: 'Open Sans','Trebuchet MS',sans-serif;">
                         <b><@i18n key="IAM.ALERT.SHOW.DEVICE"/></b> : ${ztpl.DEVICE}
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
                <td style="padding:10px 0 10px 0;font-size: 12px;color:#333333;line-height: 22px;font-family: 'Open Sans','Trebuchet MS',sans-serif;">
                      <@i18n key="${ztpl.OFFICE_ADDRESS_I18N_KEY}"/><br><@i18n key="IAM.NEW.TPL.SPAM.TEXT" args0="${ztpl.ABUSE_ID}"/>
                </td>
            </tr>
        </table>
    </td>
    </tr>
</table>
</table>
</body>
</html>