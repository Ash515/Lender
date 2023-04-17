<div style="font-size:10px;text-align:center;padding:5px 0px;">
	<#if partner.is_zoho>
		&copy;&nbsp;${za.config.copyright_year},&nbsp;<a href="<@i18n key="IAM.ZOHOCORP.LINK" />" title="<@i18n key="IAM.ZOHOCORP" />" target="_blank" style="font-size:11px;color:#085ddc;"><@i18n key="IAM.ZOHOCORP" /></a>&nbsp;<@i18n key="IAM.ADVENTNET.ALL.RIGHTS.RESERVED" />
	<#else>
		&copy;&nbsp;${za.config.copyright_year},&nbsp;<a href="<@i18n key="IAM.HOME.LINK" />" title="<@i18n key="IAM.ZOHO" />" target="_blank" style="font-size:11px;color:#085ddc;"><@i18n key="IAM.ZOHO" /></a>&nbsp;<@i18n key="IAM.ADVENTNET.ALL.RIGHTS.RESERVED" />
	</#if>
</div>