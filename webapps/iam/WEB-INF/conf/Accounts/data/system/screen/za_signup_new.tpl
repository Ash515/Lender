<!DOCTYPE html>
<html>
<head>
<title><@i18n key="IAM.CREATE.ZACCOUNT" /></title>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<script type="text/javascript" src="${za.iam_contextpath}/register/script?${signup.scriptParams}&loadcss=false&tvisit=true"></script>
<script src="${signup.tpkg_url}/jquery-3_5_1.min.js" type="text/javascript"></script>
<link href="${signup.cssurl}/signupnew.css" type="text/css" rel="stylesheet" />
<link  href="${signup.cssurl}/flagStyle.css" type="text/css" rel="stylesheet"/>
<script src="${signup.tpkg_url}/select2.full.min.js" type="text/javascript"></script>
<meta name="viewport" content="width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=no" />
</head>
<body style="visibility: hidden;">
<#if signup.isEnabled>
	<div class="bg_one"></div>
	<div class="Alert"> <span class="tick_icon"></span> <span class="alert_message"></span> </div>
	<div align="center" class="main">
		<div class="inner-container">
					<#if partner.isPartnerLogoExist>
						<div><img class="partnerlogo" src="/static/file?t=org&ID=${partner.partnerId}" /></div>
					<#else>
						<div class='zoho_logo'></div>
    				</#if>
    				<div class="signuptitle"><@i18n key="IAM.NEW.SIGNUP.TITLE"/></div>
			<form action="${za.contextpath}/register.ac" name="signupform" method="post" class="form">
				<section class="signupcontainer">
					<dl class="za-region-container">
						<dd>
							<span>Choose where your data lives because we understand  there is no safer place than home!</span>	
						<dd>
					</dl>
					<dl class="za-fullname-container">
     					<dd>
     						<input type="text" placeholder='<@i18n key="IAM.FIRST.NAME" />' name="firstname" maxlength="100" id="firstname" onblur="validateFirstName(this)" />
     						<input type="text" placeholder='<@i18n key="IAM.LAST.NAME" />' name="lastname" maxlength="100" id="lastname" onblur="validateLastName(this)" />
     					</dd>
     				</dl>
     				<dl class="za-username-container">
     					<dd>
     						<input type="text" placeholder='<@i18n key="IAM.GENERAL.USERNAME" />' name="username" maxlength="100" />
     					</dd>
     				</dl>
     				<dl class="za-emailormobile-container">
     					<dd>
     						<div class="za-country_code-container">
								<select class="form-input1 countryCnt1 za-country-select-code" name="country_code" id="country-emailormobile" ></select>
							</div>
     						<input type="text" placeholder='<@i18n key="IAM.EMAIL.ADDRESS.OR.MOBILE" />'onkeyup ="checking()" onkeydown="checking()" name="emailormobile" maxlength="100" id="phonenumber">
     					</dd>
     				</dl>	
     				<dl class="za-mobile-container">
	     				<dd>
	     					<div class="za-country_code-container">
	     						<label for='country_code_select' class='select_country_code'></label>
								<select class="form-input1 countryCnt1 za-country-select-code" name="country_code" id="country-code" ></select>
							</div>
							<input type="text" placeholder='<@i18n key="IAM.PHONE.NUMBER" />' onkeyup ="checking()" onkeydown="checking()" name="mobile" id="mobilefield"  >
						</dd>
					</dl>	
					<dl class="za-rmobile-container">
						<dd>
	     					<div class="za-country_code-container">
								<select class="form-input1 countryCnt1 za-country-select-code" name="country_code" id="country-coderecovery" ></select>
							</div>
							<input type="text" placeholder='<@i18n key="IAM.PHONE.NUMBER" />' onkeyup ="checking()" name="rmobile" id="rmobilefield" >
						</dd>
					</dl>		
					<dl class="za-email-container">
						<dd>
							<#if signup.emailId?has_content>
								<input type="text" placeholder='<@i18n key="IAM.EMAIL.ADDRESS" />' name="email" class="form-input" id="emailfield"  value="${signup.emailId}" >
							<#else>
								<input type="text" placeholder='<@i18n key="IAM.EMAIL.ADDRESS" />' name="email" class="form-input" id="emailfield"  >
							</#if>
						</dd>
					</dl>
					<dl class="za-password-container">
						<dd>
							<input type="password" placeholder='<@i18n key="IAM.PASSWORD" />' name="password" id="password" class="form-input" onkeyup="checkPasswordStrength()" >
							<span class="icon-hide show_hide_password"  id="show-password-icon" onclick=togglePasswordField(${signup.minpwdlen});></span>
						</dd>
					</dl>
					<dl class="za-country-container" style="display:none">
						<dd>
							<select class="form-input countryCnt za-country-select" name="country" id="country"  placeholder='<@i18n key="IAM.TFA.SELECT.COUNTRY" />' ></select>
						</dd>
					</dl>
					<dl class="za-country_state-container" style="display:none">
						<dd>
							<select class="form-input countryCnt" name="country_state" id="country_state"></select>
						</dd>
					</dl>
					<dl class="za-captcha-container" style='position:relative;'>
						<dd>
							<input type="text" placeholder='<@i18n key="IAM.NEW.SIGNIN.ENTER.CAPTCHA" />' name="captcha" maxlength="10" class="form-input" id="captchafield"> 
							<div class="form-input" style="text-align:left">
							<div class='captcha_container'>
								<img src="${za.contextpath}/images/spacer.gif" class="za-captcha">
								<span class="za-refresh-captcha" onclick="changeHip(document.signupform)"></span></div>
							</div>
						</dd>
					</dl>
					<dl class="za-tos-container">
							<dd>
								<label for="tos" class="tos-signup">
									<span class="icon-medium unchecked" id="signup-termservice"></span>
	                           	 	<span><@i18n key="IAM.SIGNUP.AGREE.TERMS.OF.SERVICE" arg0="${signup.termsOfServiceUrl}" arg1="${signup.privacyPolicyUrl}"/></span>
	                            	<input class="za-tos" type="checkbox" id="tos" name="tos" value="true" onclick="toggleTosField()"/>
	                       	 </label>
							</dd>
						</dl>
					<dl class="za-newsletter-container" style="display:none">
						<dd>
							<label for="newsletter" class="news-signup" style="display: flow-root;">
                            	<input class="za-newsletter" type="checkbox" id="newsletter" name="newsletter" value="true" onclick="toggleNewsletterField()"/>
                            	<span class="icon-medium icon-checkbox_on" id="signup-newsletter"></span>
                           	 <span style="width: 450px;"><@i18n key="IAM.TPL.ZOHO.NEWSLETTER.SUBSCRIBE1"/></span>
                       	 </label>
						</dd>
					</dl>
					<div class="clearBoth"></div>
					<dl class="za-submitbtn">
						<dd>
							<button class="signupbtn" id="nextbtn" onclick="return validateInputFeilds();"><span><@i18n key="IAM.LINK.SIGNUP.SIGNUP"/></span></button>
							<div class="loadingImg"></div>
						</dd>
					</dl>
	    			<div class="fed_2show">
							<div class="signin_fed_text"><@i18n key="IAM.NEW.SIGNIN.FEDERATED.LOGIN.TITLE"/></div>
							<div id="feddivparent"></div>
					</div>
			</section>
			<section class="signupotpcontainer" style="display:none">
						<div class="verifytitle"><@i18n key="IAM.NEW.SIGNUP.VERIFY.TITLE"/></div>
						<div class="verifyheader"><@i18n key="IAM.NEW.SIGNUP.MOBILE.VERIFY.DESC"/></div>
						<div class="otpmobile">
							<span id="mobileotp"></span>
							<span class="change" onclick="gobacktosignup()"><@i18n key="IAM.PHOTO.CHANGE"/></span>
						</div>
						<dl class="za-otp-container">
							<dd>
								<input type="text" class="form-input" name="otp" id="otpfield" placeholder='<@i18n key="IAM.VERIFY.CODE" />' >
								<span onclick="resendOTP()" class="resendotp"><@i18n key="IAM.SIGNUP.RESEND.OTP" /></span>
							</dd>
						</dl>
						<dl class="za-submitbtn-otp">
							<dd>
								<input type="button" class="signupbtn"  value='<@i18n key="IAM.NEW.SIGNIN.VERIFY" />' onclick="validateOTP()" name="otpfield">
								<div class="loadingImg"></div>
							</dd>
						</dl>
			</section>
			</form>
		</div>
	</div>
</#if>
<script type="text/javascript">
	 	function onSignupReady() {
	 		var fedlist = ${signup.fedlist};
	 		var fedElem = '';
	 		fedlist.forEach(function(fed,fedindex){
	 			fedElem += "<div class='"+fed+"_fed fed_div' onclick=FederatedSignIn.GO('"+fed+"')><div style='width:fit-content;margin:auto'><span class='"+fed+"_icon fed_icon'></span><span class='fed_text'>"+fed+"</span></div></div>"
	 		});
	 		$('#feddivparent').html(fedElem);
			$(document.body).css("visibility", "visible");
			$(document.signupform).zaSignUp();
			var countrySelect = $(".za-rmobile-container").is(":visible") ? "country-coderecovery" : $(".za-mobile-container").is(":visible") ? "country-code": $(".za-emailormobile-container").is(":visible") ? "country-emailormobile":"";
		if(countrySelect){
			$("#"+countrySelect).select2({
		        allowClear: true,
		        templateResult: format,
		        searchInputPlaceholder: 'Search',//no i18n
		        templateSelection: function (option) {
		              return option.text;
		        },
		        escapeMarkup: function (m) {
		          return m;
		        }
		      });
		      $("#select2-"+countrySelect+"-container").html($("#"+countrySelect+" option:selected").attr("data_number"));
      		 $(".select_"+countrySelect).html($("#"+countrySelect+" option:selected").attr("data_number"));
      		 $("#"+countrySelect).change(function(){
		        $(".country_code").html($("#"+countrySelect+" option:selected").attr("data_number"));
		        $("#select2-"+countrySelect+"-container").html($("#"+countrySelect+" option:selected").attr("data_number"));
		        $("#mobilefield,#rmobilefield").removeClass("textindent62");
		        $("#mobilefield,#rmobilefield").removeClass("textintent52");
		        $("#mobilefield,#rmobilefield").removeClass("textindent42");
				if($("#select2-"+countrySelect+"-container").html().length=="3"){
		            $("#mobilefield,#rmobilefield").addClass("textintent52");
		        }
		        if($("#select2-"+countrySelect+"-container").html().length=="2"){
		            $("#mobilefield,#rmobilefield").addClass("textindent42");
		        }
		        if($("#select2-"+countrySelect+"-container").html().length=="4"){
		            $("#mobilefield,#rmobilefield").addClass("textindent62");
		        }
	      });
	     }
	 	}
	</script>
</body>
</html>