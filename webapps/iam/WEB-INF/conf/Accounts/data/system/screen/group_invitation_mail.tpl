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
		               <#if ztpl.user_exist=="true">
		             		<b><@i18n key="IAM.HI.EXCLAMATION" arg0="${ztpl.user_name}"/></b>
		               <#else>
							<b><@i18n key="IAM.HI.EXCLAMATION" arg0="${ztpl.email_id}"/></b>
		               </#if>
		            </td>
		    	    </tr>
					<tr>
					<td style="padding:20px 0 0 0;font-size: 14px;line-height: 24px;font-family: 'Open Sans','Trebuchet MS',sans-serif;">
						<@i18n key="IAM.GROUPINVITATION.MAIL.GROUP.NAME" arg0="${ztpl.inviter_name}" arg1="${ztpl.inviter_email}" arg2="${ztpl.grp_name}"/>
					</td>
					</tr>
					<#if  ztpl.user_exist=="false">
		 				<tr>
							<td style="padding:20px 0 0 0;font-size: 14px;line-height: 24px;font-family: 'Open Sans','Trebuchet MS',sans-serif;">
									<@i18n key="IAM.GROUPINVITATION.MAIL.USERNOTEXIST.MESSAGE" arg0="${ztpl.email_id}"/>
							</td>
						</tr>
					</#if>
                   	<tr>
			            <td style="padding:20px 0 0 0;font-size: 14px;line-height: 24px;font-family: 'Open Sans','Trebuchet MS',sans-serif;">
			              <@i18n key="IAM.GROUPINVITATION.MAIL.CTA.LINK" arg0="${ztpl.invitation_url}" />
			            </td>
		            </tr>
                    <tr>
                    <td style="padding:20px 0 0 0;font-size: 14px;line-height: 24px;font-family: 'Open Sans','Trebuchet MS',sans-serif;">
                        <@i18n key="IAM.GROUPINVITATION.MAIL.MESSAGE.CONTACT.SUPPORT" args0="${ztpl.support_mailId}"/>
                    </td>
                    </tr>
                    <tr>
                    <td style="padding:20px 0 20px 0;font-size: 14px;line-height: 24px;font-family: 'Open Sans','Trebuchet MS',sans-serif;">
                        <@i18n key="IAM.REGARDS"/>,
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