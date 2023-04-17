<!DOCTYPE html>
<html>
<head>
<title><@i18n key="IAM.ZOHO.ACCOUNTS" /></title>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<#include "za_signin_static">
<meta name="viewport" content="width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=no" />
<link href="${signin.cssURL}/css/newMobileLogin.css" rel="stylesheet">
<script>

function errorhide() {
   $("#emailid_error").hide();
}
    
function onSigninReady() {

    $("#sigin_in").click(function(){
    	$("#sigin_in span").addClass('buttontexthide');
		$("#sigin_in").addClass('changeloadbtn');
        if( (!$("#username").val()))
        {
        	$("#emailid_error").text(I18N.get("IAM.ERROR.EMAIL.INVALID"));
        	$("#emailid_error").show();
        	$("#sigin_in").removeClass('changeloadbtn');
        	$("#sigin_in span").removeClass('buttontexthide');
        }else if((!$("#password").val())){
        	$("#emailid_error").text(I18N.get("IAM.ERROR.ENTER.LOGINPASS"));
        	$("#emailid_error").show();
        	$("#sigin_in").removeClass('changeloadbtn');
        	$("#sigin_in span").removeClass('buttontexthide');
        }else{
        	$("#emailid_error").text("");
        }
    });

    $(".eye_icon").click(function()
    {
         
                var passwordField = document.getElementById('password');
         
                if(passwordField.type == 'password') 
                {
                    passwordField.type = 'text';
                    $(".eye_icon").css('background-position', '-105px -119px');               
                }
                else 
                {
                    passwordField.type = 'password';
                    $(".eye_icon").css('background-position', '-34px -119px');  
                }
                
                
    });
    
    $(document.signinform).zaSignIn();
    
    }
    
    
 </script>

</head>
<body>


<#if signin.isLogoExist?c>
			<div class="zoho-logo"><img src="/static/file?t=org&ID=${signin.zaid}" /></div>
		</#if>
<#if signin.showTitle>
        <div class="signin-head">${signin.accountName}</div>
       </#if>
        
        <div class="signin-div">
        <#if signin.showTitle>
            <div class="sub-head"><@i18n key="IAM.SIGNIN.PORTAL.HEADER" /></div>
           </#if>
<form action="${za.contextpath}/signin.ac" name="signinform" method="post" class="form">
 			<div class="formfield_errormsg" id="emailid_error"></div>            
            <div class="formfield" id="emailform">
                <input type="text" class="textbox" autocapitalize="off" id="username" name="username" onkeydown="errorhide()" placeholder="<@i18n key="IAM.EMAIL.ADDRESS.OR.MOBILE" />" required="">
            </div>
           

            <div class="formfield password" id="passwordid">
                <input type="password" class="textbox" id="password" name="password" onkeydown="errorhide()" placeholder="<@i18n key="IAM.PASSWORD" />" required=""><span class="eye_icon"></span>
            </div>
            
            <div class="za-captcha-container" style="display: none;">
				<input type="text" class="textbox" name="captcha" onkeydown="errorhide()" placeholder='<@i18n key="IAM.FIELD.CAPTCHA.VERIFICATION" />' disabled> <img src="${za.contextpath}/images/spacer.gif" class="za-captcha">
			</div>
            
            <button class="primary-btn" id="sigin_in"><span><@i18n key="IAM.SIGNIN" /></span></button>
            </form>
        </div>
	<#if zidp.showidp>
        <br />
        <span class="fed_head"> <@i18n key="IAM.SIGNIN.USING"/></span>
        <form action="${za.contextpath}/openid" name="idpform" method="post" class="form"></form>
            <div class="federated_signin">
            <#if zidp.zoho> <span class="fed-logo zoho" onclick="openIdSignIn('z', '${zidp.zohoname}', ${zidp.isclient});"> </span>  </#if>  
          	<#if zidp.google> <span class="fed-logo google" onclick="openIdSignIn('g', '${zidp.googlename}', ${zidp.isclient});"></span>  </#if>  
           	<#if zidp.facebook> <span class="fed-logo facebook" onclick="openIdSignIn('f', '${zidp.facebookname}', ${zidp.isclient});"></span> </#if>  
            <#if zidp.twitter> <span class="fed-logo twitter" onclick="openIdSignIn('t', '${zidp.twittername}', ${zidp.isclient});"></span> </#if>  
            <#if zidp.linkedin> <span class="fed-logo linkedin" onclick="openIdSignIn('l', '${zidp.linkedinname}', ${zidp.isclient});"></span> </#if>  
            <#if zidp.yahoo> <span class="fed-logo yahoo" onclick="openIdSignIn('y', '${zidp.yahooname}', ${zidp.isclient});"></span> </#if>  
            </div>
    </#if>  
</body>
</html>