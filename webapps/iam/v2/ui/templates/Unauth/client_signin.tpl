<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Frameset//EN" "http://www.w3.org/TR/REC-html40/frameset.dtd">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<html>
	<head>
		<link href="${za.css_url}/clientsignin.css" type="text/css" rel="stylesheet"/>
        <script src="${za.tpkg_url}/jquery-3_5_1.min.js" type="text/javascript"></script>
        <script src="${za.tpkg_url}/select2.full.min.js" type="text/javascript"></script>
        <script src="${za.js_url}/common_unauth.js" type="text/javascript"></script>
        <script src="${za.js_url}/signin.js" type="text/javascript"></script>
        <script src="${za.tpkg_url}/xregexp-all.js" type="text/javascript"></script>
	</head>
	<meta name="robots" content="noindex, nofollow"/>
	<#include "client_signin_static">
        <meta name="viewport" content="width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=no" />
        <title><@i18n key="IAM.ZOHO.ACCOUNTS"/></title>
        <body>
			<div class="bg_one"></div>
			<div class="signin_container">
				<div class="signin_box" id="signin_flow">
					<div class="titlename">${signin.app_display_name}</div>
					<div id="signin_div">
						<form name="login" id="login" onsubmit="javascript:return submitsignin(this);"  method="post" novalidate >
							<div class="signin_head">
			    					<span id="headtitle"><@i18n key="IAM.SIGN_IN"/></span>
			    					<span id="trytitle"></span>
									<div class="service_name"><@i18n key="IAM.NEW.SIGNIN.SERVICE.NAME.TITLE" arg0="${signin.app_display_name}"/></div>
									<div class="fielderror"></div>
							</div>
							<div class="fieldcontainer">
								<div class="searchparent" id="login_id_container">
									<div class="textbox_div" id="getusername">
										<input id="login_id" placeholder="<@i18n key="IAM.NEW.SIGNIN.EMAIL.ADDRESS.OR.MOBILE"/>" value="${signin.loginId}" type="email" name="LOGIN_ID" class="textbox" required="" onkeypress="clearCommonError('login_id')" autocapitalize="off" autocomplete="on" autocorrect="off" ${signin.readOnlyEmail} tabindex="1" />
										<div class="fielderror"></div>
									</div>
								</div>
								<div class="getpassword zeroheight" id="password_container">
									<div class="hellouser">
											<div class="username"></div>
											<span class="Notyou bluetext" onclick="resetForm()"><@i18n key="IAM.PHOTO.CHANGE"/></span>
									</div>
									<div class="textbox_div">
										<input id="password" placeholder="<@i18n key="IAM.NEW.SIGNIN.PASSWORD"/>" name="PASSWORD" type="password" class="textbox" required="" onkeypress="clearCommonError('password')" autocapitalize="off" autocomplete="password" autocorrect="off" /> 
											<span class="icon-hide show_hide_password" onclick="showHidePassword();"></span>
											<div class="fielderror"></div>
									</div>
								</div>
								<div class="textbox_div" id="captcha_container">
									<input id="captcha" placeholder="<@i18n key="IAM.NEW.SIGNIN.ENTER.CAPTCHA"/>" type="text" name="captcha" class="textbox" required="" onkeypress="clearCommonError('captcha')" autocapitalize="off" autocomplete="off" autocorrect="off" maxlength="8"/>
									<div id="captcha_img" name="captcha" class="textbox"></div>
									<span class="reloadcaptcha" onclick="changeHip()"> </span>
									<div class="fielderror"></div> 
								</div>
								<button class="btn blue" id="nextbtn" tabindex="2" disabled="disabled"><span><@i18n key="IAM.NEXT"/></span></button>
							</div>
						</form>
					</div>
				</div>
			</div>
			<div id="enableCookie" style='display:none;text-align:center'>
	            <div style="text-align: center;padding: 10px;"><@i18n key="IAM.ERROR.COOKIE_DISABLED"/></div>
		    </div>
		</body>
</html>