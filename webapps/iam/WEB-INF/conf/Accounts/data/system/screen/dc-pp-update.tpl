<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1.dtd">
<html>
<head>
	 <meta name="viewport"content="width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=no" />
<style>
body,table {
	font-family: lucida grande, Roboto, Helvetica, sans-serif;
	font-size: 12px;
	padding:0px;
	margin:0px;
}

.maindiv {
	border: 1px solid #dcddda;
	max-width: 900px;
	width:86%;
	margin: 0px auto;
	background: url(../../images/banner-bg.jpg);
	border-radius: 2px;
	margin-top: 5%;
}

.continue {
	background-color: #6DA60A;
	border: 1px solid #65990B;
	color: #FFFFFF;
	font-size: 14px;
	padding: 6px 14px;
	text-decoration: none;
}

.mobileimage {
background: url("../../images/banner-icons.png") no-repeat scroll 10px 0px;
    display: inline-block;
    height: 186px;
    margin-left: 34px;
    margin-top: 55px;
    width: 185px;
}
	
	
</style>
<script src="${za.config.iam_js_url_static}/jquery-1.12.2.min.js" type="text/javascript"></script>
<script src="${za.config.iam_js_url_static}/common.js" type="text/javascript"></script>
<script>
function redirect() {
	var button = document.getElementById('continueButton');
	button.setAttribute('href','javascript:void(0)');
    button.innerHTML = '<@i18n key="IAM.ANNOUNCEMENT.UPDATING" />';

	var params = '${za.config.csrfParam}='+getIAMCookie('${za.config.csrfCookie}');
	try{
		var resp=JSON.parse(getPlainResponse("/webclient/v1/dcpolicy", params));
		if(resp.message.trim()=="success") {
             window.location.href = '${announcement.visited_url}';
             return;
        }
	}catch(e){ 
	}
	$('#errormsg').show().html("<@i18n key="IAM.ERROR.GENERAL" />");
	button.innerHTML = '<@i18n key="IAM.BANNER.ACCEPT.BTN" />';
	button.setAttribute('href','javascript:redirect()');
	return;   
}
</script>
</head>
<body>
<table width="100%" height="100%" align="center" cellpadding="0" cellspacing="0">
<tr><td valign="top" style="height:40px;">
	<header>
		<#include "header">
	</header>
</td></tr>
<tr>
<td valign="top">
<div class="maindiv">
<div style="padding: 27px 35px 40px;">
<div style="border-bottom: 1px solid #c9c9c9;font-size: 18px;padding-bottom: 15px;line-height:24px;"><@i18n key="IAM.GDPR.TOS.BANNER" /></div>
<div style="line-height: 20px;">
<div style="margin-top: 20px;"><@i18n key="IAM.TFA.HI.USERNAME" arg0="${announcement.display_name}" />,</div>
<div style="margin-top: 20px;"><@i18n key="IAM.GDPR.TOS.TOPTEXT4" arg0="${announcement.user_migrated_from_dc}" arg1="${announcement.current_dc}"  arg2="${announcement.short_banner_url}" arg3="${announcement.long_banner_url}" /></div>
<div style="margin-top: 10px;"><@i18n key="IAM.GDPR.TOS.TOPTEXT2" /></div>

<div style="margin-top: 20px;">
	<a href="javascript:redirect();" id="continueButton" class="continue"><@i18n key="IAM.BANNER.ACCEPT.BTN" /></a>
</div>
</div>
</div>
</div>
</td></tr>
<tr><td valign="bottom">
	<footer>
		<#include "footer">
	</footer>
</td></tr>
</table>
</body>
</html>