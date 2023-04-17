<!DOCTYPE html>
<html>
<head>
<title><@i18n key="IAM.CREATE.ZACCOUNT" /></title>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=no">
<script type="text/javascript" src="${za.contextpath}/register.js?${signup.scriptParams}"></script>
</head>
<body style="visibility: hidden;">
	<#assign tos_link><@i18n key="IAM.LINK.TOS" /></#assign> <#assign privacy_link><@i18n key="IAM.LINK.PRIVACY" /></#assign>
	<header> </header>
	<section class="signupoutersection">
		<section class="signupcontainer-mobile">
			<div class="logo"></div>
			<div style="clear: both;"></div>
		<#if signup.isEnabled>
			<div class="form-title"><@i18n key="IAM.CREATE.ZACCOUNT" /></div>
			<form action="${za.contextpath}/register.ac" name="signupform" method="post" class="form">   											
				<section class="signupcontainer">
				<div class="commonborder">
					<dl class="za-username-container za-placeholder-icon" style="position: relative;">
						<dd class="input">
							<label class="placeholder"><@i18n key="IAM.GENERAL.USERNAME" /></label>
							<input type="text"  name="username" maxlength="100">
						</dd>
					</dl>
					<dl class="za-emailormobile-container za-placeholder-icon">
     					<dd class="input">
     						<label class="placeholder"><@i18n key="IAM.EMAIL.ADDRESS.OR.MOBILE" /></label>
     						<input type="text" name="emailormobile" maxlength="100" tabindex="1" id="phonenumber" autofocus >
     					</dd>
     				</dl>
     				<dl class="za-mobile-container za-placeholder-icon">
							<dd class="input" style="position:relative;">
								<label class="placeholder phonelabel"><@i18n key="IAM.PHONE.NUMBER" /></label>
								<div class="za-country_code-container">
									<select class="form-input1 countryCnt1 za-country-select-code" name="country_code" id="country-code" tabindex="1"></select>
									<div class="ccdivtext1"><span class="ccdiv"></span></div>
								</div>
								<input type="text"  name="mobile" tabindex="1" id="mobilefield" />
							</dd>
					</dl>
					<dl class="za-rmobile-container za-placeholder-icon">
							<dd class="input" style="position:relative;">
								<label class="placeholder phonelabel"><@i18n key="IAM.PHONE.NUMBER" /></label>
								<div class="za-country_code-container">
									<select class="form-input1 countryCnt1 za-country-select-code" name="country_code" id="country-coderecovery" tabindex="1"></select>
									<div class="ccdivtext1"><span class="ccdiv1"></span></div>
								</div>
								<input type="text"  name="rmobile" tabindex="1" id="rmobilefield" />
							</dd>
					</dl>
					<dl class="za-email-container za-placeholder-icon">
						<dd class="input" style="position:relative;">
							<label class="placeholder"><@i18n key="IAM.EMAIL.ADDRESS" /></label>
							<input type="email"  name="email"  tabindex="1" autofocus>
						</dd>
					</dl>
					<dl class="za-password-container za-placeholder-icon">
						<dd class="input">
							<label class="placeholder"><@i18n key="IAM.PASSWORD" /></label>
							<input type="password" tabindex="1" name="password" onkeyup="checkPasswordStrength(${signup.minpwdlen},true)" > <span class='showpassword' style="display: none;" onclick='showPassword(this,true)'></span>
						</dd>
					</dl>
				</div>
				<dl class="za-country-container">
					<dd class="countrycont">
						<select class="form-input countryCnt za-country-select" name="country" id="country" tabindex="2" placeholder='<@i18n key="IAM.TFA.SELECT.COUNTRY" />' ></select>
						<span class="drop_arrow"></span>
					</dd>
				</dl>
				<dl class="za-country_state-container">
					<dd class="countrycont">
						<select class="form-input countryCnt" name="country_state" id="country_state" tabindex="2" ></select>
						<span class="drop_arrow"></span>
					</dd>
				</dl>
				<dl class="za-captcha-container">
					<dd>
						<img src="${za.contextpath}/images/spacer.gif" class="za-captcha">
						<dd class="input">
							<input type="text"  name="captcha" maxlength="10" placeholder="<@i18n key="IAM.ERROR.TEXT.IMAGE" />">
						</dd>
						<span class="za-refresh-captcha" onclick="reloadCaptcha(document.signupform)"></span>
					</dd>
						
				</dl>
				
				<dl class="za-newsletter-container">
					<dd>
						<div class="field-msg">
							<div class="znewsletter">
								<label><input type="checkbox" name="newsletter" value="true" class="za-newsletter" onclick="toggleNewsletterField()">
								<span class="unchecked" id="signup-newsletter"></span>
								<span class="newsfield"><@i18n key="IAM.TPL.ZOHO.NEWSLETTER.SUBSCRIBE"/></span></label>
							</div>
						</div>
					</dd>
				</dl>
				<div class="clearBoth"></div>
				<dl class="za-tos-container">
					<dd>
						<div class="znewsletter1">
							<label>
								<input type="checkbox" name="tos" value="false" class="za-tos">
								<span class="unchecked" id="signup-termservice"  onclick="toggleTosField()"></span>
								<span class="newsfield"><@i18n key="IAM.SIGNUP.AGREE.TERMS.OF.SERVICE" arg0="${tos_link}" arg1="${privacy_link}"/></span>
							</label>
						</div>
					</dd>
				</dl>
				<dl class="mob-submit-btn">
					<dd>
						<input type="submit" class="btn big-btn primary" value='<@i18n key="IAM.LINK.SIGNUP.SIGNUP" />'>
					</dd>
				</dl>
				</section>
				<section class="signupotpcontainer" style="display:none">
						<dl class="za-otp-container">
							<dd style="margin:0 auto;">
								<input type="text" class="form-input" tabindex="1" name="otp" id="otpfield" placeholder='<@i18n key="IAM.VERIFY.CODE" />' >
							</dd>
						</dl>
						<dl class="za-submitbtn-otp">
							<dd style="margin:0 auto;">
								<input type="button" tabindex="1" class="btn big-btn primary" style="width:180px" value='<@i18n key="IAM.VERIFY.OTP" />' onclick="validateOTP()" name="otpfield">
								<div class="loadingImg"></div>
							</dd>
						</dl>
				</section>
			</form>
		<#else>
			<div class="signupblockdiv">
				<dl><dt><@i18n key="IAM.REGISTRATION.NOT.ALLOWED" arg0="${signup.supportEmail}" /></dt></dl>
			</div>
			<dl class="mob-submit-btn">
				<dd><input type="button" class="blockbtndiv" value='<@i18n key="IAM.BACKTO.HOME" />' onclick="history.go(-1);"></dd>
			</dl>
		</#if>
		</section>
	</section>
	<script type="text/javascript">
		function onSignupReady() {
			$(".input input").focus(function() {
				$(this).parent(".input").each(function() { //No i18N
			         $("label", this).css({
			            "top":"0px","paddingLeft": "8px !important"
			         })
	    		 });
	    		 $(this).css("borderBottom","1px solid #1485e0");
			}).blur(function() {
			      if ($(this).val() == "") {
			         $(this).parent(".input").each(function() { //No i18N
			            $("label", this).css({
			               "top":"30px" //No i18N
			            })
			         });
	
		      	}
		      	$(this).css("borderBottom","1px solid #dedede");
	   		});
			$("input[name='password']").keyup(function() {
				if ($(this).val().length >= 2) {
					$(".showpassword").show();
				}
			})
			// To avoid glitches on page load, as we lazy load CSS. 
			$(document.body).css("visibility", "visible");
			$(document.signupform).zaSignUp({
				commonerror : true,
				handleConfirmation : function(data) {
					if(data.mobile_redirect_url){
						data.doAction();
						return;
					}
					if (!$(".za-confirm").length) {
						var confirmTpl = this.options.getConfirmationTemplate().replace("$EMAIL", data.email); // No I18N
						$(".signupoutersection").addClass("confirmoutersection").removeClass("signupoutersection");
						$(".confirmoutersection").html(confirmTpl);
					}
					$(".confirmoutersection input").click(data.doAction);
					setTimeout(function() {
						data.doAction();
					}, 5000);
				}
			});
		}
		
		
	</script>
</body>
</html>