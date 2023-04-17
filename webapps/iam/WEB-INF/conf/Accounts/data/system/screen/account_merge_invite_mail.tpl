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
	                    <tr style="display:none;">
		                    <td>
		                        <a href="<@i18n key="IAM.HOME.LINK" />" style="display:inline-block;"><img src="cid:23abc@pc27" style="display: block;height: 30px;width: 80px;" /></a>
		                    </td>
	                    </tr>
	                    <tr>
		                    <td style="font-size: 24px;line-height: 48px;font-family: 'Open Sans','Trebuchet MS',sans-serif;">
		                    <b><@i18n key="IAM.ORGINVITATION.JOIN.THIS.TITLE" args0="${ztpl.ACCOUNT_NAME}"/></b>
		                    </td>
	                    </tr>
	                    <tr>
		                    <td style="padding:10px 0 0 0;font-size: 14px;line-height: 24px;font-family: 'Open Sans','Trebuchet MS',sans-serif;">
		                    	<@i18n key="IAM.TPL.ORG.INVITE.WELCOME.TEXT.NEW" args0="${ztpl.ACCOUNT_NAME}" args1="${ztpl.ADMIN_FULL_NAME}" args2="${ztpl.ADMIN_EMAIL_ID}"/>
		                    </td>
	                    </tr>
	                    <tr>
			                    <td>
				                    <span style="padding: 20px 0 0 0;display: inline-block;">
				                        <a style="text-decoration:none;color: #ffffff;display: inline-block;border-top:14px solid #339E72;border-right:40px solid #339E72;border-bottom:14px solid #339E72;border-left:40px solid #339E72;font-size: 16px;font-weight: 600;font-family: 'Open Sans','Trebuchet MS',sans-serif;color: #ffffff;background-color:#339E72;    margin-right: 10px;" href="${ztpl.ACCEPT_URL}"><@i18n key="IAM.TPL.ORGINVITATION.TOACCEPT" /></a>
									</span>
									<span style="padding: 20px 0 0 0;display: inline-block;">	                        
				                        <a style="text-decoration:none;color: #444;display: inline-block;border-top:14px solid #ECECEC;border-right:40px solid #ECECEC;border-bottom:14px solid #ECECEC;border-left:40px solid #ECECEC;font-size: 16px;font-weight: 600;font-family: 'Open Sans','Trebuchet MS',sans-serif;color: #444;background-color:#ECECEC;    margin-right: 10px;" href="${ztpl.REJECT_URL}"><@i18n key="IAM.TPL.ORGINVITATION.TOREJECT" /></a>
				                     </span>
			                    </td>
			             </tr>
	                    <tr>
		                    <td style="border-bottom: 3px solid #339e72;padding:20px 0 0 0;">
		                        <img src="<@image cid="23abc@pc28" img_path="${ztpl.IMG_PATH}/zohoRegionLogo.gif" />" style="display: block;width: 100%;height: auto !important;" /> 
		                    </td>
	                    </tr>
	                </table>
	                <table> 
			            <tr>
			                <td style="padding:10px 0 10px 0;font-size: 12px;color:#757575;line-height: 22px;font-family: 'Open Sans','Trebuchet MS',sans-serif;">
			                    <@i18n key="IAM.ORGINVITATION.ABUSE.TEXT" args0="${ztpl.APP_NAME}" args1="${ztpl.ABUSE_EMAIL}" />
			                </td>
			            </tr>       
			        </table>
	                
	            </td>
            </tr>           
        </table>
    </td>
    </tr>
</table>
</table>
</body>
</html>

