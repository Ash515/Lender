<div style="height:40px;margin:0px auto;border-bottom:1px solid #c5c8ca;box-shadow:0px 3px 0px #e8ebee;">
    <div style="width:50%;float:left;padding:0px;margin:6px 0px;">
    	<#if partner.isPartnerLogoExist>
    		<a href="/"><img src="${za.iam_contextpath}/static/file?t=org&ID=${partner.partnerId}" style="width:200px; height:30px; border:none;" title="<@i18n key="IAM.ZOHO.ACCOUNTS" />" alt="<@i18n key="IAM.ZOHO.ACCOUNTS" />"/></a>
    	<#else>
    		<a href="/"><img src="${za.config.iam_img_url}/spacer.gif" style="background:transparent url('${za.config.iam_img_url}/rebrand.gif') no-repeat -11px -200px;height:26px;width:210px;margin:2px 0px 0px 5px; border:none;" title="<@i18n key="IAM.ZOHO.ACCOUNTS" />" alt="<@i18n key="IAM.ZOHO.ACCOUNTS" />"/></a>
    	</#if>
    </div>
    <div style="float:right;padding:0px;margin:0px;">
		<div style="font-size:11px;color:#000;text-decoration:none;">
	    	<ul style="list-style: none; float: right; *padding-top:10px;">
				<li style="float: left; margin-right: 20px;"><a href="<@i18n key="IAM.HOME.LINK" />" title="<@i18n key="IAM.HOME" />" style="color:#085DDC;text-decoration:none;" onmouseover="this.style.textDecoration='underline';" onmouseout="this.style.textDecoration='none';"><@i18n key="IAM.HOME" /></a></li>
				<#if partner.isPartnerHideHeader>
					<li style="float: left; margin-right: 20px;"><a href="<@i18n key="IAM.BLOGS.LINK" />" title="<@i18n key="IAM.BLOGS" />" style="color:#085DDC;text-decoration:none;" onmouseover="this.style.textDecoration='underline';" onmouseout="this.style.textDecoration='none';"><@i18n key="IAM.BLOGS" /></a></li>
					<li style="float: left; margin-right: 20px;"><a href="<@i18n key="IAM.FORUMS.LINK" />" title="<@i18n key="IAM.FORUMS" />" style="color:#085DDC;text-decoration:none;" onmouseover="this.style.textDecoration='underline';" onmouseout="this.style.textDecoration='none';"><@i18n key="IAM.FORUMS" /></a></li>
				</#if>
				<li style="float: left; margin-right: 20px;"><a href="<@i18n key="IAM.FAQ.LINK" />" title="<@i18n key="IAM.TITLE.FAQ.EXPAND" />" style="color:#085DDC;text-decoration:none;" onmouseover="this.style.textDecoration='underline';" onmouseout="this.style.textDecoration='none';"><@i18n key="IAM.FAQ" /></a></li>
	    	</ul>
		</div>
    </div>
</div>
