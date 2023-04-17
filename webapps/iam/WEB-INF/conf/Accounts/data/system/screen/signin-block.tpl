<!DOCTYPE html>
<html>
<style>
body
{
    font-family: 'Open Sans', sans-serif;
    margin: 0;
}
@font-face {
    font-family: 'Open Sans';
    font-style: normal;
    font-weight: 300;
    src:url('../../images/opensanslight/font.eot');
    src:local('Open Sans'),
    	url('../../images/opensanslight/font.eot?#iefix') format('eot'),
        url('../../images/opensanslight/font.woff') format('woff'), 
        url('../../images/opensanslight/font.ttf') format('truetype'),
        url('../../images/opensanslight/font.svg#OpenSans-Light') format('svg');
}
.container {
	margin-top: 4%;
	width: 60%;
	margin-left: auto;
	margin-right: auto;
} 

.zoho_logo {
	height: auto;
	width: auto;
}

.head_text { 
	display: block; 
	font-size: 22px; 
	margin-bottom: 10px; 
	margin-top: 30px; 
} 
.name { 
	font-size: 15px; 
	font-weight: bold; 
	display: block;
	margin-top:20px; 

}

.announcement_text { 
    line-height: 1.5;
    font-size: 14px;
    display: block;
    padding: 5px 0px;
} 
.skip_btn { 
    margin-right: 10px;
    cursor: pointer;
    font-size: 14px;
    border: none;
    background-color: #1ab2f1;
    padding: 8px 16px;
    color: #fff;
    display: inline-block;
    text-decoration: none;
    margin-top: 20px;
}
#footer { width:100%; height:20px; } #footer div { text-align:center; font-size: 70%; } #footer div a { text-decoration:none; } #height { height:100%; width:1px; background-color:transparent; position: absolute; display:none; }
</style>
    <body>
    	<div id="height"></div>
        <div class="container">
        <img class="zoho_logo" src="../../images/zlogo.png"> 
        <div class=wrap>
        <span class="head_text"><@i18n key="IAM.ACCOUNT.LOCK.NOTIFICATION" /></span>
        <span class="name"><@i18n key="IAM.TFA.HI.USERNAME" arg0="${announcement.display_name}" /></span> 
        <#if announcement.logins_left == 0>
        	<span class="announcement_text"><@i18n key="IAM.ACCOUNT.LOCK.THRESHOLD" arg0="${announcement.threshold}"/><@i18n key="IAM.ACCOUNT.LOCK.LAST.LOGIN"/></span>
        <#else>
        	<span class="announcement_text"><@i18n key="IAM.ACCOUNT.LOCK.THRESHOLD" arg0="${announcement.threshold}"/><@i18n key="IAM.ACCOUNT.LOCK.REMAINING.LOGINS" arg0="${announcement.logins_left}" /></span>
        </#if>
        <span class="announcement_text"><@i18n key="IAM.ACCOUNT.SUGGESTION" /></span>
      	<a class="skip_btn" href="${announcement.skip_url}"><@i18n key="IAM.ACCOUNT.LOCK.MESSAGE.CONTINUE" /></a>
      	</div>
      	<footer id="footer">
      	<div >
		<span><@i18n key="IAM.FOOTER.COPYRIGHT" arg0="2012"/></span>
		</div>
	</footer>
    </body>
    <script src="${za.config.iam_js_url_static}/jquery-1.12.2.min.js" type="text/javascript"></script>
	<script src="${za.config.iam_js_url_static}/common.js" type="text/javascript"></script>
    <script>
    $(document).ready(function() {
	    var offset= $("#height").outerHeight()-155;// 20 for footer and 120for top 
	    $(".wrap").css("min-height", offset); 
    	$( window ).resize(function(){ offset= $("#height").outerHeight()-155;// 20 for footer and 120for top 
    	$(".wrap").css("min-height", offset); }); });
    </script>
</html>