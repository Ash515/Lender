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
						<b><@i18n key="IAM.MFA.PREF.CHANGED.TITLE" /></b>
					</td>
					</tr>
					<#if ztpl.tfapref == 2>
					<tr>
					<td style="padding:20px 0 0 0;font-size: 14px;line-height: 24px;font-family: 'Open Sans','Trebuchet MS',sans-serif;">
						<@i18n key="IAM.TPL.MFA.UPDATE.STATUS" /><@i18n key="IAM.TPL.MFA.TOUCHID.STATUS"/>
					</td>
					</tr>
					<tr>
					<td style="padding:20px 0 0 0;font-size: 14px;line-height: 24px;font-family: 'Open Sans','Trebuchet MS',sans-serif;">
						<b><@i18n key="IAM.TFA.AUTH.MODE"/></b>
					</td>
					</tr>
					<tr>
					<td style="font-size: 14px;line-height: 24px;font-family: 'Open Sans','Trebuchet MS',sans-serif;">
						<@i18n key="IAM.TOUCHID"/>
					</td>
					</tr>
                    <#elseif ztpl.tfapref == 3>
                    <tr>
					<td style="padding:20px 0 0 0;font-size: 14px;line-height: 24px;font-family: 'Open Sans','Trebuchet MS',sans-serif;">
						<@i18n key="IAM.TPL.MFA.UPDATE.STATUS" /><@i18n key="IAM.TPL.MFA.QR.STATUS"/>
					</td>
					</tr>
					<tr>
					<td style="padding:20px 0 0 0;font-size: 14px;line-height: 24px;font-family: 'Open Sans','Trebuchet MS',sans-serif;">
						<b><@i18n key="IAM.TFA.AUTH.MODE"/></b>
					</td>
					</tr>
					<tr>
					<td style="font-size: 14px;line-height: 24px;font-family: 'Open Sans','Trebuchet MS',sans-serif;">
						<@i18n key="IAM.SCAN.QR"/>
					</td>
					</tr>  
            		<#elseif ztpl.tfapref == 4>
            		<tr>
					<td style="padding:20px 0 0 0;font-size: 14px;line-height: 24px;font-family: 'Open Sans','Trebuchet MS',sans-serif;">
						<@i18n key="IAM.TPL.MFA.UPDATE.STATUS" /><@i18n key="IAM.TPL.MFA.PUSH.STATUS"/>
					</td>
					</tr>
					<tr>
					<td style="padding:20px 0 0 0;font-size: 14px;line-height: 24px;font-family: 'Open Sans','Trebuchet MS',sans-serif;">
						<b><@i18n key="IAM.TFA.AUTH.MODE"/></b>
					</td>
					</tr>
					<tr>
					<td style="font-size: 14px;line-height: 24px;font-family: 'Open Sans','Trebuchet MS',sans-serif;">
						<@i18n key="IAM.PUSH.NOTIFICATION"/>
					</td>
					</tr>                      	
                    <#elseif ztpl.tfapref == 5>
                    <tr>
					<td style="padding:20px 0 0 0;font-size: 14px;line-height: 24px;font-family: 'Open Sans','Trebuchet MS',sans-serif;">
						<@i18n key="IAM.TPL.MFA.UPDATE.STATUS" /><@i18n key="IAM.TPL.MFA.TOTP.STATUS"/>
					</td>
					</tr>
					<tr>
					<td style="padding:20px 0 0 0;font-size: 14px;line-height: 24px;font-family: 'Open Sans','Trebuchet MS',sans-serif;">
						<b><@i18n key="IAM.TFA.AUTH.MODE"/></b>
					</td>
					</tr>
					<tr>
					<td style="font-size: 14px;line-height: 24px;font-family: 'Open Sans','Trebuchet MS',sans-serif;">
						<@i18n key="IAM.TIME.BASED.OTP"/>
					</td>
					</tr>
                    <#elseif ztpl.tfapref == 7>
                    <tr>
					<td style="padding:20px 0 0 0;font-size: 14px;line-height: 24px;font-family: 'Open Sans','Trebuchet MS',sans-serif;">
						<@i18n key="IAM.TPL.MFA.UPDATE.STATUS" /><@i18n key="IAM.TPL.MFA.FACEID.STATUS"/>
					</td>
					</tr>
					<tr>
					<td style="padding:20px 0 0 0;font-size: 14px;line-height: 24px;font-family: 'Open Sans','Trebuchet MS',sans-serif;">
						<b><@i18n key="IAM.TFA.AUTH.MODE"/></b>
					</td>
					</tr>
					<tr>
					<td style="font-size: 14px;line-height: 24px;font-family: 'Open Sans','Trebuchet MS',sans-serif;">
						<@i18n key="IAM.FACEID"/>
					</td>
					</tr>
                    </#if>
                    <#if ztpl.has_config_device_name>
                    <tr>
					<td style="padding:20px 0 0 0;font-size: 14px;line-height: 24px;font-family: 'Open Sans','Trebuchet MS',sans-serif;">
						<@i18n key="IAM.CONFIG.DEVICE" arg0="${ztpl.configured_device_name}"/>
					</td>
					</tr>
                    </#if> 
					<tr>
					<td style="padding:20px 0 0 0;font-size: 14px;line-height: 24px;font-family: 'Open Sans','Trebuchet MS',sans-serif;">
					   <@i18n key="IAM.TPL.MFA.NOT.UPDATED.WARN.MESSAGE" arg0="${ztpl.SUPPORT_EMAIL}"/>
					</td>
					</tr>
					<tr>
					<td style="padding:20px 0 0 0;font-size: 14px;line-height: 24px;font-family: 'Open Sans','Trebuchet MS',sans-serif;">
						<@i18n key="IAM.TPL.CHEERS"/><br>
					</td>
					</tr>
					<tr>
					<td style="font-size: 14px;line-height: 24px;font-family: 'Open Sans','Trebuchet MS',sans-serif;">
						<b><@i18n key="IAM.TPL.ZOHO.TEAM"/></b><br>
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