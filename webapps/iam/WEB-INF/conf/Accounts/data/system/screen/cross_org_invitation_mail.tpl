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
						                        <a href="<@i18n key="IAM.HOME.LINK" />" style="display:inline-block;"><img src="cid:23abc@pc27" style="display: block;height: 30px;width: 80px;" /></a>
						                    </td>
					                    </tr>
					                    <tr>
						                    <td style="padding:20px 0 0 0;font-size: 24px;line-height: 48px;font-family: 'Open Sans','Trebuchet MS',sans-serif;">
						                        <b><@i18n key="IAM.HI.USERNAME.EXCLAMATION" arg0="${ztpl.CONTACTED_USER_NAME}"/></b>
						                    </td>
					                    </tr>
					                    <tr>
						                    <td style="padding:20px 0 0 0;font-size: 14px;line-height: 24px;font-family: 'Open Sans','Trebuchet MS',sans-serif;">
						                    	<@i18n key="IAM.OAUTH.CROSS.ORG.MAIL.CONTENT" arg0="${ztpl.FROM_SER}" arg1="${ztpl.INVITED_DISPLAY_NAME}" arg2="${ztpl.INVITED_CONTACT_EMAIL}" arg3="${ztpl.TO_SER}"/> 
						                    </td>
					                    </tr>
					                    <tr>
						                    <td style="padding:20px 0 0 0;font-size: 14px;line-height: 24px;font-family: 'Open Sans','Trebuchet MS',sans-serif;">
						                        <a style="text-decoration:none;color: #ffffff;display: inline-block;border-top:14px solid #339E72;border-right:40px solid #339E72;border-bottom:14px solid #339E72;border-left:40px solid #339E72;font-size: 16px;font-weight: 600;font-family: 'Open Sans','Trebuchet MS',sans-serif;color: #ffffff;background-color:#339E72;" href="${ztpl.DIGEST_URL}"><@i18n key="IAM.OAUTH.CROSS.ORG.URL" /></a>
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

