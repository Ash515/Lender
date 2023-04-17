<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta http-equiv="X-UA-Compatible" content="ie=edge" />
    
    <meta name="viewport"content="width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=no" />
   <title><@i18n key="IAM.ZOHO.ACCOUNTS" /></title>

    <link href="${za.css_url}/accountUnauthStyle.css" rel="stylesheet"type="text/css">
    <script src="${za.tpkg_url}/jquery-3_5_1.min.js"></script>
    <script src="${za.js_url}/common_unauth.js"></script>
    <style>
	    @font-face {
		    font-family: 'Montserrat';
		    font-style: normal;
		    font-weight: 400;
		    src:url('${za.img_url}/montserratregular/font.eot');
		    src:url('${za.img_url}/montserratregular/font.eot?#iefix') format('eot'),
		        url('${za.img_url}/montserratregular/font.woff2') format('woff2'),
		        url('${za.img_url}/montserratregular/font.woff') format('woff'),
		        url('${za.img_url}/montserratregular/font.ttf') format('truetype'),
		        url('${za.img_url}/montserratregular/font.svg#Montserrat-Regular') format('svg');
		}
		@font-face {
		    font-family: 'Montserrat';
		    font-style: medium;
		    font-weight: 500;
		    src:url('${za.img_url}/montserratsemibold/font.eot');
		    src:url('${za.img_url}/montserratsemibold/font.eot?#iefix') format('eot'),
		        url('${za.img_url}/montserratsemibold/font.woff2') format('woff2'),
		        url('${za.img_url}/montserratsemibold/font.woff') format('woff'),
		        url('${za.img_url}/montserratsemibold/font.ttf') format('truetype'),
		        url('${za.img_url}/montserratsemibold/font.svg#Montserrat-Bold') format('svg');
		}
		html {
			height: 100%;
			width: 100%;
		}
		
		body {
			margin: 0px;
			min-height: 100%;
			width: 100%;
			font-family: Montserrat, sans-serif;
		}
    </style>
  </head>
  <body>
    <div class="content">
      <div class="maincolumn-containers maincolumn1">
        <div class="subcontainer">
          <img class="logo" src="${za.img_url}/zoho.png"/>
          <div class="head-text">
          	<#if unverified?size == 1 >
				<@i18n key="IAM.DOMAIN.BANNER.HEADER.SINGLE"/>
			<#else>
				<@i18n key="IAM.DOMAIN.BANNER.HEADER.MULTIPLE"/>
			</#if>
          </div>
          <div class="description">
	          <@i18n key="IAM.DOMAIN.BANNER.TEXT"/>
          </div>
          <div class="card-container">
          	<#list unverified as x>
            <div class="card">
              <div class="mobilelogo"></div>
              <div class="domain">
               	${x}
              </div>
              <div class="verification-container"><@i18n key="IAM.UNVERIFIED" /></div>
            </div>
           </#list>
          </div>
          <button class="button" onclick="verify()"><span id="loader"><@i18n key="IAM.DOMAIN.BANNER.BUTTON"/></span></button>
          <button class="button rmnd_btn" onclick="window.open('${remind_me_later_url}','_self')"><span id="loader"><@i18n key="IAM.TFA.BANNER.REMIND.LATER"/></span></button>

        </div>
      </div>
      <div class="maincolumn-containers maincolumn2">
      </div>

    </div>
  </body>
</html>
