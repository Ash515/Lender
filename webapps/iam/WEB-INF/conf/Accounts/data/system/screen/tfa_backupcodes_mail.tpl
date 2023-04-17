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
					<td style="font-family: 'Open Sans','Trebuchet MS',sans-serif;">
					    <a href="<@i18n key="IAM.HOME.LINK" />" style="display:inline-block;"><img src="cid:23abc@pc27" style="display: block;height: 30px;width: 80px;" /></a>
					</td>
					</tr>
					<tr>
					<td style="padding:20px 0 0 0;font-size: 24px;line-height: 48px;font-family: 'Open Sans','Trebuchet MS',sans-serif;">
						<b><@i18n key="IAM.HI.USERNAME.EXCLAMATION" arg0="${ztpl.FIRST_NAME}"/></b>
					</td>
					</tr>
					<tr>
					<td style="font-size: 24px;line-height: 48px;font-family: 'Open Sans','Trebuchet MS',sans-serif;">
						<b><@i18n key="IAM.TFA.BACKUP.CODES.TITLE" /></b>
					</td>
					</tr>
					<tr>
					<td style="padding:20px 0 0 0;font-size: 14px;line-height: 24px;font-family: 'Open Sans','Trebuchet MS',sans-serif;">
						<@i18n key="IAM.TFA.BKP.MAIL.HINT" arg0="${ztpl.backup_verification_link}"/>
					</td>
					</tr>
					<tr>
					<td style="padding:20px 0 0 0;font-size: 14px;line-height: 24px;font-family: 'Open Sans','Trebuchet MS',sans-serif;">
						<b><@i18n key="IAM.TFA.RECOVERY.TITLE"/></b>
					</td>
					</tr>
					<tr>
					<td style="font-size: 14px;line-height: 24px;font-family: 'Open Sans','Trebuchet MS',sans-serif;">
						<a style="color:#333333;text-decoration:none;">${ztpl.sender_email}</a>
					</td>
					</tr>
					<tr>
					<td style="padding:20px 0 0 0;font-size: 14px;line-height: 24px;font-family: 'Open Sans','Trebuchet MS',sans-serif;">
						<@i18n key="IAM.BACKUP.CODE.AIDE"/>
					</td>
					</tr>
					<tr>
					<td style="padding:10px 0 0 0;">
					<table border="0" cellpadding="0" cellspacing="0" bgcolor= "#f0f0f0">
					<tr>
					<td style="line-height: 15px;border-left: 2px solid #339e72;width: 250px;">
						&nbsp;
					</td>
					</tr>
    	            <#list ztpl.RECOVERY_CODES as recoverycode>
    	            <tr>
					<td style="padding:0 0 10px 0;font-size: 14px;line-height: 24px;font-family: 'Open Sans','Trebuchet MS',sans-serif;border-left: 2px solid #339e72;width: 250px;">
						<table border="0" cellpadding="0" cellspacing="0">
							<tr>
							<td style="padding:0 0 0 30px;">
						        ${recoverycode?substring(0, 4)}&nbsp;&nbsp;&nbsp;${recoverycode?substring(4, 8)}&nbsp;&nbsp;&nbsp;${recoverycode?substring(8, 12)}
					        </td>
							</tr>
						</table>
					</td>
					</tr>
					</#list>
					<tr>
					<td style="line-height: 5px;border-left: 2px solid #339e72;width: 250px;">
						&nbsp;
					</td>
					</tr>
					</table>
					</td>
					</tr>
					<tr>
					<td style="padding:10px 0 0 0;font-size: 14px;line-height: 24px;font-family: 'Open Sans','Trebuchet MS',sans-serif;">
						<@i18n key="IAM.GENERATEDTIME"/> : ${ztpl.CREATED_TIME}
					</td>
					</tr>
                    <tr>
					<td style="padding:20px 0 0 0;font-size: 14px;line-height: 24px;font-family: 'Open Sans','Trebuchet MS',sans-serif;">
						<@i18n key="IAM.TFA.HELP.DOCUMENT.MSG" arg0="${ztpl.helplink}"/>
					</td>
					</tr>
					<tr>
					<td style="padding:20px 0 0 0;font-size: 14px;line-height: 24px;font-family: 'Open Sans','Trebuchet MS',sans-serif;">
						<@i18n key="IAM.BACKUP.CODES.SUPPORT" arg0="${ztpl.SUPPORT_EMAIL}"/>
					</td>
					</tr>
					<tr>
					<td style="padding:20px 0 0 0;font-size: 14px;line-height: 24px;font-family: 'Open Sans','Trebuchet MS',sans-serif;">
						<@i18n key="IAM.TPL.CHEERS"/>
					</td>
					</tr>
					<tr>
					<td style="font-size: 14px;line-height: 24px;font-family: 'Open Sans','Trebuchet MS',sans-serif;">
						<b><@i18n key="IAM.TPL.ZOHO.TEAM"/></b> 
					</td>
					</tr>
					<tr>
					<td style="font-size: 14px;line-height: 24px;font-family: 'Open Sans','Trebuchet MS',sans-serif;">
						<a href="<@i18n key="IAM.HOME.LINK" />" style="color:#2696eb;text-decoration:none;"><@i18n key="IAM.HOME.LINK.TEXT"/></a> 
					</td>
					</tr>
					<tr>
					<td style="border-bottom: 3px solid #339e72;">
					     <img src="<@image cid="23abc@pc28" img_path="${ztpl.IMG_PATH}/zohoRegionLogo.gif" />" style="display: block;width: 100%;height: auto !important;" /> 
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