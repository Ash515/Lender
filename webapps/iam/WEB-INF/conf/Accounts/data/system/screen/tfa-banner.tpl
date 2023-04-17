<!DOCTYPE HTML>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<style>
body,table {
	font-size: 13px;
	padding:0px;
	margin:0px;
	font-family: "Open Sans";
}
.maindiv {
	width: 900px;
	margin: 0px auto;
	border-radius: 2px;
	text-align: justify;
	margin-top: 5%;
}

.tfabutton {
	background-color: #6DA60A;
	border: 1px solid #65990B;
	color: #FFFFFF;
	font-size: 14px;
	padding: 6px 14px;
	text-decoration: none;
}

.cancelbutton {
	background-color: #CACACA;
	font-size: 14px;
	padding: 6px 14px;
	text-decoration: none;
	color:#333;
	margin-left: 5px;
	border: 1px solid #c3c3c3;
}
.cancelbutton1 {
	background-color: #CACACA;
	font-size: 14px;
	padding: 6px 14px;
	text-decoration: none;
	color:#333;
	margin-left: 5px;
	border: 1px solid #c3c3c3;
}

.continuelink {
	text-decoration: underline;
	color: #0483C8;
	margin-left: 30px;
}

.mobileimage {
background: rgba(0, 0, 0, 0) url("${za.config.iam_img_url}/banner-icons.png") no-repeat scroll -12px -8px;
    display: inline-block;
    height: 192px;
    margin-left: 5px;
    margin-top: 34px;
    width: 192px;
}
.saveBtn {
    -moz-border-bottom-colors: none;
    -moz-border-left-colors: none;
    -moz-border-right-colors: none;
    -moz-border-top-colors: none;
    background-color: #5ac7f0;
    border-color: #47b0d8 #47b0d8 #2c8fb4;
    border-image: none;
    border-radius: 2px;
    border-style: solid;
    border-width: 1px;
    color: #fff;
    cursor: pointer;
    font-size: 13px;
    padding: 5px 10px;
    position: relative;
    text-align: center;
    margin-right: 6px;
    text-decoration:none;
}
.saveBtn:hover, .saveBtn:focus ,.minisaveBtn:hover, .minisaveBtn:focus {
    -moz-border-bottom-colors: none;
    -moz-border-left-colors: none;
    -moz-border-right-colors: none;
    -moz-border-top-colors: none;
    background-color: #55c0e8;
    border-color: #47b0d8 #47b0d8 #2c8fb4;
    border-image: none;
    border-style: solid;
    border-width: 1px;
    color:#fff;
	text-decoration:none;
}
.cancelBtn {
	-moz-border-bottom-colors: none;
    -moz-border-left-colors: none;
    -moz-border-right-colors: none;
    -moz-border-top-colors: none;
    background-color: #e4e4e4;
    border-color: #e4e4e4 #e4e4e4 #bbbbbb;
    border-image: none;
    border-radius: 2px;
    border-style: solid;
    border-width: 1px;
    color: #141823;
    cursor: pointer;
    font-size: 13px;
    padding: 5px 10px;
    text-align: center;
    margin-right: 6px;
    text-decoration:none;
}
.cancelBtn:hover, .cancelBtn:focus ,.minicancelBtn:hover, .minicancelBtn:focus {
    -moz-border-bottom-colors: none;
    -moz-border-left-colors: none;
    -moz-border-right-colors: none;
    -moz-border-top-colors: none;
    background-color: #e0e0e0;
    border-color: #d4d4d4 #d4d4d4 #bbbbbb;
    border-image: none;
    border-style: solid;
    border-width: 1px;
}
@font-face {
    font-family: 'Open Sans';
    font-weight: 400;
    font-style: normal;
	src :local('Open Sans'),url('${za.config.iam_img_url}/font.woff') format('woff');
}
.title-banner{
  font-size: 24px;
  width: 185px;
  text-align: right;
  line-height: 45px;
  }
</style>
<script type='text/javascript'>
	function redirect() {
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
	<div style="border-right:1px solid #8d8d8d;width: 235px;float: left;"><div class='title-banner'><@i18n key="IAM.TFA.BANNER.TITLE" /></div>
		<div class="mobileimage"></div>
	</div>
<div style="margin:0px 0 0 282px;">
<div style="width: 600px;line-height: 22px;float: left;">
<div style="margin-top: 20px;"><@i18n key="IAM.TFA.HI.USERNAME" arg0="${announcement.display_name}" /></div>
<div style="margin-top: 10px;"><@i18n key="IAM.TFA.BANNER.HEADER" /></div>
<div style="margin-top: 10px;"><@i18n key="IAM.TFA.BANNER.CONTENT" /></div>
<div style="font-size: 14px;margin-top: 10px;"><@i18n key="IAM.TFA.BANNER.JOIN.TXT" />. <a href="${announcement.help_document_link}" target="_blank" class="continuelink" style="font-size: 12px;margin-left: 5px;"><@i18n key="IAM.TFA.LEARN.MORE" /></a> </div>
<div style="clear: both;margin-top: 50px;">
<a href="${announcement.two_factor_url}" target="_blank" onclick="redirect();" class="saveBtn"><@i18n key="IAM.TFA.BANNER.SETUP.NOW" /></a>
<a href="${announcement.remind_me_later_url}" class="cancelBtn"><@i18n key="IAM.TFA.BANNER.REMIND.LATER" /></a>
</div>
<div style=" margin: 19px auto 100px; "><a href="${announcement.skip_url}" class="continuelink" style="margin: 0px auto 0;font-size: 12px;"><@i18n key="IAM.TFA.BANNER.SKIP" /></a></div>
</div>
<#if announcement.show_admin_note>
	<div style="margin-top: 35px;line-height: 20px;">
	<div style="color:#CE5153;"><@i18n key="IAM.NOTE" />&nbsp;:&nbsp;</div>
	<div><@i18n key="IAM.TFA.BANNER.ADMIN.MSG" /></div>
</div>
</#if>
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