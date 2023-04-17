<!DOCTYPE html>
<html>
<head>
	<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
</head>
<body style="margin:0;padding:0;">
<table border="0" cellpadding="0" cellspacing="0" width="100%">
<table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse;max-width: 700px;min-width: 320px;width:100%;"> 
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
						<b><@i18n key="IAM.PSWD.CHANGED.TITLE" /></b>
					</td>
					</tr>
					<#if ((ztpl.IP_ADDRESS) == '')>
         	           <#if (ztpl.ORG_ADMIN)>
         	              <tr>
					      <td style="padding:20px 0 0 0;font-size: 14px;line-height: 24px;font-family: 'Open Sans','Trebuchet MS',sans-serif;">
						     <@i18n key="IAM.PASSWORD.CHANGE.NOTIFICATION.BY.ORGADMIN" arg0="${ztpl.EMAIL_ID}" arg1="${ztpl.TIME}" arg2="${ztpl.ORG_EMAIL_ID}"/>
					      </td>
					      </tr>		
          	           <#else>
          	              <tr>
					      <td style="padding:20px 0 0 0;font-size: 14px;line-height: 24px;font-family: 'Open Sans','Trebuchet MS',sans-serif;">
						     <@i18n key="IAM.PASSWORD.CHANGE.NOTIFICATION" arg0="${ztpl.EMAIL_ID}" arg1="${ztpl.TIME}"/>
					      </td>
					      </tr>
         	           </#if> 	
                   <#else>
          		       <#if (ztpl.ORG_ADMIN)>
          		          <tr>
					      <td style="padding:20px 0 0 0;font-size: 14px;line-height: 24px;font-family: 'Open Sans','Trebuchet MS',sans-serif;">
						     <@i18n key="IAM.PASSWORD.CHANGE.NOTIFICATION.WITH.IPADDRESS.BY.ORGADMIN" arg0="${ztpl.EMAIL_ID}" arg1="${ztpl.TIME}" arg2="${ztpl.IP_ADDRESS}" arg3="${ztpl.ORG_EMAIL_ID}" />
					      </td>
					      </tr>
         		       <#else>
         		          <tr>
					      <td style="padding:20px 0 0 0;font-size: 14px;line-height: 24px;font-family: 'Open Sans','Trebuchet MS',sans-serif;">
						     <@i18n key="IAM.PASSWORD.CHANGE.NOTIFICATION.WITH.IPADDRESS" arg0="${ztpl.EMAIL_ID}" arg1="${ztpl.TIME}" arg2="${ztpl.IP_ADDRESS}" />
					      </td>
					      </tr>
         		       </#if> 
                   </#if>
           	          <tr>
					  <td style="padding:20px 0 20px 0;font-size: 14px;line-height: 24px;font-family: 'Open Sans','Trebuchet MS',sans-serif;">
						  <@i18n key="IAM.PASSWORD.RESET.ACCOUNT"/>
					  </td>
					  </tr>
                    <tr>
						<td>
							<a style="text-decoration:none;color: #ffffff;display: inline-block;border-top:12px solid #339E72;border-right:40px solid #339E72;border-bottom:12px solid #339E72;border-left:40px solid #339E72;font-size: 16px;font-weight: 600;font-family: 'Open Sans','Trebuchet MS',sans-serif;color: #ffffff;background-color:#339E72;" href="${ztpl.FORGOT_PASSWORD}"><@i18n key="IAM.RESET.PASSWORD.TITLE"/></a>
						</td>
                    </tr>
                    <#if ztpl.USER_TFA_DISABLED>
                    <#if ztpl.IS_TFA_ENABLED> 
					  <tr>
					  <td style="padding:20px 0 0 0;font-size: 14px;line-height: 24px;font-family: 'Open Sans','Trebuchet MS',sans-serif;">
						  <@i18n key="IAM.PASSWORD.RESET.ENABLE.TFA"  arg0="${ztpl.TFA_HELP_LINK}"/>
					  </td>
					  </tr>
				   </#if>
                   </#if>
                    <tr>
					<td style="padding:20px 0 0 0;font-size: 14px;line-height: 24px;font-family: 'Open Sans','Trebuchet MS',sans-serif;">
						<@i18n key="IAM.PASSWORD.RESET.QUERIES" arg0="${ztpl.SUPPORT_EMAIL}" />
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