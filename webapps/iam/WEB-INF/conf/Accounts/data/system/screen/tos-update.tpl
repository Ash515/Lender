<!DOCTYPE HTML>
<html>
<head>
<style>
body,table {
	font-family: lucida grande, Roboto, Helvetica, sans-serif;
	font-size: 12px;
	padding:0px;
	margin:0px;
}

.maindiv {
	border: 1px solid #dcddda;
	width: 900px;
	margin: 0px auto;
	background: url(../../images/banner-bg.jpg);
	border-radius: 2px;
	text-align: justify;
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
<script>
function redirect() {
	var button = document.getElementById('continueButton');
	button.setAttribute('href','javascript:void(0)');
    button.innerHTML = '<@i18n key="IAM.ANNOUNCEMENT.UPDATING" />';
    window.location.href = '${announcement.visited_url}';
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
<div style="border-bottom: 1px solid #c9c9c9;font-size: 18px;padding-bottom: 8px;"><@i18n key="IAM.BANNER.SUBTITLE" /></div>
<div style="line-height: 20px;">
<div style="margin-top: 20px;"><@i18n key="IAM.TFA.HI.USERNAME" arg0="${announcement.display_name}" />,</div>
<div style="margin-top: 10px;">
<div>
	<@i18n key="IAM.BANNER.MSG" arg0="${announcement.pp_url}" arg1="${announcement.tos_url}" arg2="${announcement.pp_changes_url}" arg3="${announcement.pp_compares_url}" arg4="${announcement.tos_changes_url}" arg5="${announcement.tos_compares_url}"/>
</div>

<div style="clear: both;margin-top: 30px;">
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