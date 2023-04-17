<!DOCTYPE html>
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
</head>
<body style="margin: 0; padding: 0;">
	<table border="0" cellpadding="0" cellspacing="0" width="100%">
		<table border="0" cellpadding="0" cellspacing="0"
			style="border-collapse: collapse; max-width: 700px; min-width: 320px; width: 100%;">
			<tr>
				<td align="left" style="padding: 2% 2% 2% 2%;">
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
										<td style="padding: 20px 0 0 0; font-size: 24px; line-height: 48px; font-family: 'Open Sans', 'Trebuchet MS', sans-serif;">
											<b><@i18n key="IAM.HI.USERNAME" arg0="${ztpl.FIRST_NAME}"/></b>
										</td>
									</tr>
									<tr>
										<td style="padding: 20px 0 0 0; font-size: 14px; line-height: 24px; font-family: 'Open Sans', 'Trebuchet MS', sans-serif;">
											<@i18n key="IAM.PRIVACY.CERTIFICATES.DESCRIPTION" arg0="${ztpl.CTYPE}"/>
										</td>
									</tr>
									<tr>
										<td style="padding: 10px 0 0 0; font-size: 14px; line-height: 24px; font-family: 'Open Sans', 'Trebuchet MS', sans-serif;">
											<ul>
												<#list ztpl.CERTIFICATES_LIST as certificate>
													<li>${certificate}</li>
												</#list>
											</ul>
										</td>
									</tr>
									<tr>
										<td style="padding: 20px 0 0 0; font-size: 14px; line-height: 24px; font-family: 'Open Sans', 'Trebuchet MS', sans-serif;"> <@i18n key="IAM.TPL.REGARDS"/><br> </td>
									<tr>
									<tr>
										<td style="font-size: 14px;line-height: 24px;font-family: 'Open Sans','Trebuchet MS',sans-serif;"> <b><@i18n key="IAM.PRIVACY.CERTIFICATES.TEAM"/></b><br> </td>
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