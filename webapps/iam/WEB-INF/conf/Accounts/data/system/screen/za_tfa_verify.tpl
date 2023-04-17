<!DOCTYPE html>
<html>
<head>
<title><@i18n key="IAM.ZOHO.ACCOUNTS" /></title>
<#include "za_tfa_verify_static">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<script type="text/javascript" src="${za.contextpath}/js/tplibs/jquery/jquery-1.12.2.min.js"></script>
<script type="text/javascript" src="${za.contextpath}/js/tfaverify.js"></script>
<script type="text/javascript" src="${za.contextpath}/js/common.js"></script>
<link href="${tfa.cssurl}/tfaverify.css" type="text/css" rel="stylesheet" />  
</head>
<body class="bodycolor">
	<header>
		<#if partner.isPartnerLogoExist>
			<div><img class="partnerlogo" src="/static/file?t=org&ID=${partner.partnerId}" /></div>
		<#else>
			<div class="logo"></div>
		</#if>
		<div style="clear: both;"></div>
	</header>
	<div class="tfa-container" align="center">
		<div id="pageheading" class="za-outer-verify">
			<div class="za-innerheading "><@i18n key="IAM.TFA" /></div>
			<#if tfa.isSmartPhone>
				<p align="center" class="tfa_message"><@i18n key="IAM.TFA.TOTP.MESSAGE"/></p>
			<#else>
				<p align="center" class="tfa_message"><@i18n key="IAM.TFA.VERIFICATION.MESSAGE" arg0="${tfa.displayMobile}"/></p>
			</#if>
			<dl class="za-mobilenumber-container">
				<dd>
					<b class="column-left"><@i18n key="IAM.TFA.ENTER.VERIFICATION.CODE" /></b> : <input type="text" class="column-right" id="code" name="code" size="10" onkeyup="hideErrordiv(this);if(event.keyCode==13) validateUserCode('$(tfa.isMobile)','$(tfa.serviceName)','$(tfa.serviceUrl)');" tabindex="1" />
				</dd>
			</dl>
			<dl class="za-captcha-container" style="display:none">
						<dd>
							<div style="font-size:11px"><b class="column-left" style="font-size:12px"><@i18n key="IAM.IMAGE.VERIFICATION" />  : </b> <@i18n key="IAM.TYPE.IMAGE.CHARACTERS" /></div>
							<input type="hidden" id="cdigest" />
							<div class="captcha-input"><input type="text" name="captcha" maxlength="10" class="column-right"" tabindex="1"></div> 
							<div class="form-input" style="text-align:left"><img src="${za.contextpath}/images/spacer.gif" class="za-captcha"><span class="za-refresh-captcha" onclick="reloadCaptcha(document.signupform)"></span></div>
						</dd>
			</dl>
			<dl class="za-trusted-container">
				<dd>
			    	<div class="trustinfo">
			    			<input type="checkbox" name="tfaremember" class="check hide" value="tfaremember" id="tfaremember" />
                   			<span onclick="checkCheckBoxStatus(de('tfaremember_field'), 'tfaremember');" style="cursor:pointer;font-size:12px;">
                   			<#if tfa.isApp>
								<@i18n key="IAM.TFA.TRUST.APP"/>                   			
                   			<#else>
                   				<@i18n key="IAM.TFA.TRUST.BROWSER"/>
                   			</#if>
                   			</span>
                   	<div>
                   		<div class="trustinfo">
	                   		<@i18n key="IAM.TFA.TRUST.INFO" arg0="${tfa.trusteddays}"/>
                   		</div>
				</dd>
			</dl>
			<dl class="za-verify-container">
				<dd>
				    <div>
				    	<span id="verify_button" class="bluebutt_ver old_button" onclick="validateUserCode('$(tfa.isMobile)','$(tfa.serviceName)','$(tfa.serviceUrl)')"><@i18n key="IAM.VERIFY"/></span>
						<span class="whitebutt_ver old_button" onclick="tfaredirect('${tfa.redirectUrl}');"><@i18n key="IAM.CANCEL"/></span>
				    </div>	
			    </dd>
			</dl>
		</div>
		<div class="pagenotesdiv" id="notediv">
		<#if !tfa.isSmartPhone>
		          <div>
		          <span class="fllt" style="font-size:11px;font-weight: bold;"><@i18n key="IAM.TFA.DIDNT.RECEIVE.CODE"/></span>
		          <div class="fllt">
		         	&nbsp;-&nbsp;
		         	<a href="javascript:;" class="hyperlink" style="margin-left:5px;" onclick="toggleResendOptions()"><@i18n key="IAM.TFA.RESEND.CODE"/></a>
		         </div>
		         <div class="fllt">
		          	<a href="javascript:;" class="hyperlink" style="margin-left:15px;" onclick="togglePopUp('show')"><@i18n key="IAM.TFA.CANT.ACCESS.PHONE"/></a>
		         </div>
		          </div>
		          <div style="clear:both;"></div>
		<#else>
			 <div>
		        <span class="fllt" style="font-size:11px;font-weight: bold;"><@i18n key="IAM.TFA.CANT.ACCESS.SMARTPHONE"/>&nbsp;&nbsp;-&nbsp;</span>
		        <#if tfa.isValiePhoneNumber|| tfa.backupNoExists>
			        <div class="fllt">
			         	<a href="javascript:;" class="hyperlink" style="margin-left:5px;" onclick="toggleResendOptions()"><@i18n key="IAM.TFA.BACKUP.SEND.CODE"/></a>
			        </div>
		        </#if>
		         <div class="fllt">
		        	<a href="javascript:;" class="hyperlink" style="margin-left:15px;" onclick="togglePopUp('show')"><@i18n key="IAM.TFA.CANT.ACCESS.ANY.PHONE"/></a>
		        </div>
		     </div>
		        <div style="clear: both;"></div>
		</#if>
		</div>
		<div id="opacity" onclick="togglePopUp('hide')" style="display:none;"></div>
		<dl class="popup-container">
			<dd>
				<div id="confirmpopup" class="maincontentdiv" style="display:none;text-align:left;">
					<div class="popupheading">
					<span class="fllt mtop"><@i18n key="IAM.TFA.CANT.ACCESS.PHONE"/></span>
					<span class="popupclose" onclick="togglePopUp('hide')"></span>
					<span style="display: inline-block;">&nbsp;</span>
					</div>
					<div class="border-dotted">&nbsp;</div>
					<div style="margin-left: 5px; padding-top: 5px; margin-top: 10px;">
						<span id="spantfabackupcode" style="margin-top: -2px;" class="radio-checked" onclick="checkRadioButtonStatus('tfabackupcode')"></span>
						<input type="radio" name="reslist" style="display:none" value="usecode" id="tfabackupcode" checked/>
						<span style="cursor:pointer" onclick="checkRadioButtonStatus('tfabackupcode')"><@i18n key="IAM.TFA.ALREADY.HAVE.BACKUP.CODE"/></span>
					</div>
					
					<div style="padding-top:5px;margin-left:5px;">
						<span id="spantfarecover" style="margin-top: -2px;" class="radio-uncheck" onclick="checkRadioButtonStatus('tfarecover')"></span>
						<input type="radio"  name="reslist" style="display:none" value="recover" id="tfarecover"/>
						<span style="cursor:pointer" onclick="checkRadioButtonStatus('tfarecover')"><@i18n key="IAM.TFA.DONT.HAVE.ANY.CODE"/></span>
					</div>
					<div style="margin-top: 20px;padding-bottom: 10px;text-align: center;">
						<span class="bluebutt_ver" id="confirmpopupbtn" onclick="checkRecoverOptions()"><@i18n key="IAM.PROCEED"/></span>
						<span class="whitebutt_ver" onclick="togglePopUp('hide')"><@i18n key="IAM.CANCEL"/></span>
					</div>
				</div>
			</dd>
		</dl>
</body>
</html>