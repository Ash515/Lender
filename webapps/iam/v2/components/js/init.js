//$Id$
/***************************** Variable decalartion *********************************/
  var Account = ZResource.extendClass({
	  resourceName: "Account",//No I18N
	  identifier: "zaid"	//No I18N  
  });
  var DpaObj = ZResource.extendClass({	//using szid for merge org purpose
	  resourceName: "DPA",//No I18N
	  attrs : ["fn","em","on","cn","rn","cd","ca","szid","dpa_type"],	//No I18N  
	  parent : Account
  });
  
  var KYC_Org_Obj = ZResource.extendClass({
	  resourceName: "kyc",//No I18N
	  attrs : ["on","it","ec","em","fn","ln","mn","dn","ca","kyc_contacts","soid"],	//No I18N
	  parent : Account
  });
  var Org = ZResource.extendClass({
	  resourceName: "Org", //No I18N
	  identifier: "zaid" //No I18N
  });
  var DomainObj = ZResource.extendClass({
	  resourceName: "Domain", //No I18N
	  identifier: "domainName", //No I18N
	  attrs:["type"], //No I18N
	  parent:Org
  });
  var Certificates = ZResource.extendClass({
	  resourceName: "certificate",//No I18N
	  identifier: "certtype",//No I18N
	  attrs: ["ctype", "services","download"]//NO I18N
  });
  
  var SAMLObj =  ZResource.extendClass({ 
	  resourceName: "SAML",//No I18N
	  attrs :["login_url","logout_url","password_url","publickey","algorithm","service","enable_saml_logout","publickey_upload","saml_status","enable_saml_jit","first_name","last_name","display_name"],//No I18N
	  multipartAttrs:["publickey_upload"],//No I18N
	  parent : Org
  });
  
//  var Locale = ZResource.extendClass({
//	  resourceName: "Locale",//No I18N
//	  identifier: "zuid",	//No I18N 
//  });
  
  var Template  = ZResource.extendClass({
	  resourceName: "Template",//No I18N
	  identifier: "details"	//No I18N 
  });
  
  var User  = ZResource.extendClass({
	  resourceName: "User",//No I18N
	  identifier: "zuid",	//No I18N 
	  attrs : [ "first_name","last_name","display_name","gender","country","language","timezone","state" ], // No i18N
	  parent : Account
  });
  
  var PrivacyOBJ= ZResource.extendClass({
	  resourceName: "Privacy",//No I18N
	  parent : User
  });
  
  var KycObj = ZResource.extendClass({
	  resourceName: "kyc",//No I18N
	  parent : User
  });
  
  var Photo = ZResource.extendClass({
	  resourceName: "Photo",//No I18N
	  attrs :["height","width","x_point","y_point","r_value","picture","photo_Permission"],//No I18N
	  multipartAttrs:["picture"],//No I18N
	  parent : User
  });
  
  
  var Email = ZResource.extendClass({
	  resourceName: "Email",//No I18N
	  identifier: "emailID",	//No I18N 
	  attrs : [ "email_id","otp_code"], // No i18N
	  parent : User
  });
  var makePrimary = ZResource.extendClass({
	  resourceName: "makePrimary",//No I18N
	  attrs : [ "password"], // No i18N
	  parent : Email
  });
  
  
  var Phone = ZResource.extendClass({
	  resourceName: "Phone",//No I18N
	  identifier: "phonenum",	//No I18N 
	  attrs : [ "countrycode","mobile_no","otp_code"], // No i18N
	  parent : User
  });
  
  var MakeRecoveryPhone = ZResource.extendClass({
	  resourceName: "MakeRecovery",//No I18N
	  attrs : ["password"], // No i18N
	  parent : Phone
  });
  var MakeLoginNumberPhone = ZResource.extendClass({
	  resourceName: "MakeLoginNumber",//No I18N
	  attrs : ["password"], // No i18N
	  parent : Phone
  });
	  
  var Password = ZResource.extendClass({
	  resourceName: "Password",//No I18N
	  attrs : ["currentPass","newPassword"], // No i18N
	  parent : User
  });
  
  var SignOutObj = ZResource.extendClass({
	  resourceName: "SignOut",//No I18N
	  attrs : ["clear_web_sessions","clear_app_sessions","clear_api_tokens"], // No i18N
	  parent : User
  });
  
  var SecurityQuestion = ZResource.extendClass({
	  resourceName: "SecurityQuestion",//No I18N
	  attrs : ["custSecQ","current_password","secA"], // No i18N
	  parent : User
  });
  
  var AllowedIPObj = ZResource.extendClass({
	  resourceName: "AllowedIP",//No I18N
	  attrs : ["f_ip","t_ip","ip_name"], // No i18N
	  parent : User
  });
  
  var AppPasswordsObj = ZResource.extendClass({
	  resourceName: "AppPasswords",//No I18N
	  identifier: "pass_id",	//No I18N 
	  attrs : ["password","keylabel"], // No i18N
	  parent : User
  });
  
  var DeviceLoginsObj = ZResource.extendClass({//not completed
	  resourceName: "DeviceLogins",//No I18N
	  identifier: "device_id",	//No I18N 
	  parent : User
  });
  
  var Mail_ClientLoginsObj = ZResource.extendClass({//not completed
	  resourceName: "MailClientLogins",//No I18N
	  identifier: "location_id",	//No I18N 
	  parent : User
  });
  
  
  
  var ActiveSessionsObj = ZResource.extendClass({
	  resourceName: "ActiveSessions",//No I18N
	  parent : User
  });
  var ActiveAuthtokensObj = ZResource.extendClass({
	  resourceName: "ActiveAuthtokens",//No I18N
	  parent : User
  });
  
  var ConnectedAppsOBJ= ZResource.extendClass({
	  resourceName: "ConnectedApps",//No I18N
	  identifier: "clientID",	//No I18N 
	  parent : User
  });
  
  
  var AppLoginsOBJ= ZResource.extendClass({
	  resourceName: "AppLogins",//No I18N
	  identifier: "refreshToken",	//No I18N 
	  parent : User
  });
  
  var Applogin_devices = ZResource.extendClass({
	  resourceName: "Devices",//No I18N
	  parent : AppLoginsOBJ,
	  identifier: "clientID"	//No I18N
  });
  
  
  
  
  var PreferencesObj =  ZResource.extendClass({ 
	  resourceName: "Preferences",//No I18N
	  attrs : [ "dateformat","pass_expiry","photo_Permission","subscription"],// No i18N
	  parent : User
  });
  
  
  
  var AuthWebsitesObj =  ZResource.extendClass({ 
	  resourceName: "AuthorizedWebsites",//No I18N
	  parent : User
  });
  var LinkedAccountsObj =  ZResource.extendClass({ 
	  resourceName: "LinkedAccounts",//No I18N
	  parent : User
  });
  
  
  var MfaFetchOBJ = ZResource.extendClass({ 
	  resourceName: "MFA",//No I18N
	  identifier: "mode",	//No I18N 
	  attrs : ["activate","makeprimary","mode"],// No i18N
	  parent : User
  });
  
  
  var TFA_EXO_OBJ = ZResource.extendClass({ 
	  resourceName: "MFAEXOStar",//No I18N
	  attrs : [ "code","type"],// No i18N
	  path : 'exostar',// No i18N
	  parent : MfaFetchOBJ
  });
  
  var TfaOneAuthSMS = ZResource.extendClass({ 
	  resourceName: "OneAuthSMS",//No I18N
	  attrs : [ "mobile","countrycode"],// No i18N
	  parent : User
  });

  var Yubikey_obj = ZResource.extendClass({ 
	  resourceName: "MFAYubikey",//No I18N
	  identifier: "yubikey_id",	//No I18N 
	  path : 'yubikey',// No i18N
	  attrs : [ "appId","clientData","registrationData"],// No i18N
	  parent : MfaFetchOBJ
  });
  
  var TfaBrowser = ZResource.extendClass({ 
	  resourceName: "MFABrowser",//No I18N
	  parent : MfaFetchOBJ,
	  path : 'browser'//No I18N
  });
  
  var TfaBackupCodes = ZResource.extendClass({ 
	  resourceName: "BackupCodes",//No I18N
//	  attrs : [ "email_id","pass"],// No i18N
	  parent : User
  });
  
  var tfabackup_print = ZResource.extendClass({ 
	  resourceName: "Print",//No I18N
//	  attrs : [ "email_id","pass"],// No i18N
	  parent : TfaBackupCodes
  });
  
  var tfabackup_download = ZResource.extendClass({ 
	  resourceName: "Download",//No I18N
//	  attrs : [ "email_id","pass"],// No i18N
	  parent : TfaBackupCodes,
	  exports: true
  });
  
  var OtpObj=  ZResource.extendClass({ 
	  resourceName: "mfaotp",//No I18N
	  attrs : ["code"], // No i18N
	  path : 'otp',// No i18N
	  parent : MfaFetchOBJ
  });
  
  
  var TFA_mobileOBJ = ZResource.extendClass({ 
	  resourceName: "MFAMobile",//No I18N
	  attrs : ["mobile","countrycode","code"], // No i18N
	  path : 'mobile',// No i18N
	  identifier: "number",	//No I18N 
	  parent : MfaFetchOBJ
  });
  
  var tfa_makeprim=  ZResource.extendClass({ 
	  resourceName: "Primary",//No I18N
	  parent : TFA_mobileOBJ
  });
  
  var TFA_deviceOBJ = ZResource.extendClass({ 
	  resourceName: "Device",//No I18N
	  identifier: "device_token",	//No I18N 
	  parent : MfaFetchOBJ
  });
  
  
  var CloseAccountsObj =  ZResource.extendClass({ 
	  resourceName: "CloseAccounts",//No I18N
	  attrs : [ "reason","comments"],// No i18N
	  parent : User
  });
  
  var Groups  = ZResource.extendClass({
	  resourceName: "Groups",//No I18N
	  identifier: "zgid",	//No I18N 
	  attrs : [ "grpname","grpdesc","grpmembers"],// No i18N
	  parent : User
  });
  
  var GMemeber = ZResource.extendClass({
	  resourceName: "Members",//No I18N
	  identifier: "member_zuid",	//No I18N 
	  attrs : [ "isReInvite","isModerator"],// No i18N
	  parent : Groups
  });
  
  var GInvitation = ZResource.extendClass({
	  resourceName: "Invitation",//No I18N
	  identifier: "status",	//No I18N 
	  parent : Groups
  });
  
  var GroupPhoto = ZResource.extendClass({
	  resourceName: "Uploadphoto",//No I18N
	  attrs :["picture"],//No I18N
	  multipartAttrs:["picture"],//No I18N
	  parent : Groups
  });
  
  var Contacts = ZResource.extendClass({
	  resourceName: "Contacts",//No I18N
	  parent : User
  });
  
  var TrustedDomain = ZResource.extendClass({
	  resourceName: "TrustedDomain",//No I18N
	  parent : User,
	  attrs : ["serviceurl","servicename","atd"] //No I18N
  });
  
  var USER="User";//No I18N 
  var POLICY="Policies";//No I18N 
//  var POLICY="Policy";//No I18N 
  var EMAIL = "Email";//No I18N 
  var PHONE = "Phone";//No I18N 
  var primary_email=undefined;
  var PASSWORD = "Password";//No I18N 
  var SecurityQ = "SecurityQuestion";//No I18N 
  var AllowedIP = "AllowedIP";//No I18N
  var AppPasswords = "AppPasswords";//No I18N
  var Device_logins="DeviceLogins";//No I18N
  var ActiveSessions="ActiveSessions"//No I18N
  var ActiveAuthtokens="ActiveAuthtokens"//No I18N
  var LoginHistory="LoginHistory";//No I18N
  var Connected_apps="ConnectedApps";//No I18N
  var App_logins="AppLogins";//No I18N
  var UserPreferences="Preferences";//No I18N
  var LinkedAccounts="LinkedAccounts";//No I18N	  
  var AuthorizedWebsites="AuthorizedWebsites";//No I18N	
  var SAML="SAML";//No I18N	
  var CloseAccounts="CloseAccounts";//No I18N
  var GroupMembers="Members";//No I18N
  var privacy="Privacy";//No I18N
  var KYC="KYC"//No I18N
  var Domain="Domain" //No I18N
  var GroupPendingInvitations="PendingInvitations";//No I18N	
  var TFA="TFA"//No I18N
  var certificates="Certificates";//NO I18N 

	  
  var color_classes = ["dp_green", "dp_green_lt", "dp_red", "dp_blue", "dp_blue_lt","dp_yellow","dp_violet","dp_pink","dp_orange_lt","dp_orange"];    //No I18N
  var locale,profile_html, security_html, sessions_html,settings_html,groups_html,tfa_html,mfa_html,privacy_html,compliance_html,org_html;
  var profile_data, security_data, sessions_data,history_data,settings_data,groups_data,tfa_data,privacy_data,compliance_data,org_data;
  var secondary_format;
 
$profile =
{
		load: function(panel_id) 
		{	
			$(window).unbind("scroll");
			if(profile_html)
			{
				new URI(User,"self","self").include(USER).include(POLICY).include(EMAIL).include(PHONE).GET().then(function(resp)	//No I18N
				{
					profile_data=resp.User;
					de('zcontiner').style.display='none';
					$('#zcontiner').html(profile_html);//No I18N
					load_profile();
					removeGif();
					de('zcontiner').style.display='block';
					scroll_tab(panel_id,scroll_change);
					
				},
				function(resp)
				{
					 if(resp.cause && resp.cause.trim() === "invalid_password_token") 
					 {
						 var serviceurl = window.location.href;
						 var redirecturl = resp.redirect_url;
	     	             window.location.href =contextpath + redirecturl +'?serviceurl='+euc(serviceurl)//No I18N
	     	             return false;
					 }
					 $('#zcontiner').html($("#exception_page").html());
					 de('zcontiner').style.display='block';
					 removeGif();
					 if(resp.status_code==0)//no internet
					 {
						 $('#zcontiner #exception_page_img').removeClass("no_data_exception");
						 $('#zcontiner #exception_page_img').addClass("no_internet_exception");
					 }
					 else //some exception occured
					 {
						 $('#zcontiner #exception_page_img').addClass("no_data_exception");
						 $('#zcontiner #exception_page_img').removeClass("no_internet_exception");
						 $('#zcontiner #exception_page_txt').html(resp.message)
					 }
				});
				
			}
			else
			{	
				//$(".content").show();
				// Template.create({screenname: 'profile'}).getURI('profile').GET()
				$.when( Template.GET("profile"),new URI(User,"self","self").include(USER).include(POLICY).include(EMAIL).include(PHONE).GET())//No I18N
					.then(function(template,detail) 
				    {
				    	profile_html=template.content;
						$('#zcontiner').html(profile_html);//No I18N
						profile_data=detail.User;
						load_profile();
						removeGif();
						de('zcontiner').style.display='block';
						scroll_tab(panel_id,scroll_change);
				    },
					function(resp)
					{
						 if(resp.cause && resp.cause.trim() === "invalid_password_token") 
						 {
							 var serviceurl = window.location.href;
							 var redirecturl = resp.redirect_url;
		     	             window.location.href =contextpath + redirecturl +'?serviceurl='+euc(serviceurl)//No I18N
		     	             return false;
						 }
						 else
						 {
							 $('#zcontiner').html($("#exception_page").html());
							 de('zcontiner').style.display='block';
							 removeGif();
							 $('#zcontiner #exception_page_txt').html(resp.message)
						 }
					});
					
			}
			
		}
}

$security = 
{
		load: function(panel_id) 
		{
			$(window).unbind("scroll");
			if(security_html)
			{
				new URI(User,"self","self").include(POLICY).include(PASSWORD).include(SecurityQ).include(AllowedIP).include(AppPasswords).include(Device_logins).GET().then(function(resp)	//No I18N
				{
					security_data=resp.User;
					de('zcontiner').style.display='none';
					$('#zcontiner').html(security_html);//No I18N
					load_security();
					removeGif();
					de('zcontiner').style.display='block';
					scroll_tab(panel_id,scroll_change);
				},
				function(resp)
				{
					 if(resp.cause && resp.cause.trim() === "invalid_password_token") 
					 {
						 var serviceurl = window.location.href;
						 var redirecturl = resp.redirect_url;
	     	             window.location.href =contextpath + redirecturl +'?serviceurl='+euc(serviceurl)//No I18N
	     	             return false;
					 }
					 else
					 {
						 $('#zcontiner').html($("#exception_page").html());
						 de('zcontiner').style.display='block';
						 removeGif();
						 $('#zcontiner #exception_page_txt').html(resp.message)
					 }
				});
				
				
			}
			else
			{	
				// Template.create({screenname: 'profile'}).getURI('profile').GET()
				$.when( Template.GET("security"), new URI(User,"self","self").include(POLICY).include(PASSWORD).include(SecurityQ).include(AppPasswords).include(AllowedIP).include(Device_logins).GET())//No I18N
				    .then(function(template,detail) 
				    {
				    	security_html=template.content;
						$('#zcontiner').html(security_html);//No I18N
						security_data=detail.User;
						load_security();
						removeGif();
						de('zcontiner').style.display='block';
						scroll_tab(panel_id,scroll_change);
				    },
					function(resp)
					{
						 if(resp.cause && resp.cause.trim() === "invalid_password_token") 
						 {
							 var serviceurl = window.location.href;
							 var redirecturl = resp.redirect_url;
		     	             window.location.href =contextpath + redirecturl +'?serviceurl='+euc(serviceurl)//No I18N
		     	             return false;
						 }
						 else
						 {
							 $('#zcontiner').html($("#exception_page").html());
							 de('zcontiner').style.display='block';
							 removeGif();
							 $('#zcontiner #exception_page_txt').html(resp.message)
						 }
					});
					
			}	
		}
}



$MFA =
{
		load: function(panel_id) 
		{
			$(window).unbind("scroll");
			if(mfa_html)
			{
				new URI(MfaFetchOBJ,"self","self").GETS().then(function(resp)	//No I18N
						{
							tfa_data=resp[0];
							de('zcontiner').style.display='none';
							$('#zcontiner').html(mfa_html);//No I18N
							load_mfa();
							removeGif();
							de('zcontiner').style.display='block';
							scroll_tab(panel_id,scroll_change);
						},
						function(resp)
						{
							 if(resp.cause && resp.cause.trim() === "invalid_password_token") 
							 {
								 var serviceurl = window.location.href;
								 var redirecturl = resp.redirect_url;
			     	             window.location.href =contextpath + redirecturl +'?serviceurl='+euc(serviceurl)//No I18N
			     	             return false;
							 }
							 else
							 {
								 $('#zcontiner').html($("#exception_page").html());
								 de('zcontiner').style.display='block';
								 removeGif();
								 $('#zcontiner #exception_page_txt').html(resp.message)
							 }
						});
						
			}
			else
			{
				$.when( Template.GET("mfa"), new URI(MfaFetchOBJ,"self","self").GETS())//No I18N
			    .then(function(template,detail) 
			    {
			    	mfa_html=template.content;
			    	$('#zcontiner').html(mfa_html);//No I18N
					tfa_data=detail[0];
					load_mfa();
					removeGif();
					de('zcontiner').style.display='block';
					scroll_tab(panel_id,scroll_change);
			    },
				function(resp)
				{
					 if(resp.cause && resp.cause.trim() === "invalid_password_token") 
					 {
						 var serviceurl = window.location.href;
						 var redirecturl = resp.redirect_url;
	     	             window.location.href =contextpath + redirecturl +'?serviceurl='+euc(serviceurl)//No I18N
	     	             return false;
					 }
					 else
					 {
						 $('#zcontiner').html($("#exception_page").html());
						 de('zcontiner').style.display='block';
						 removeGif();
						 $('#zcontiner #exception_page_txt').html(resp.message)
					 }
				});
				
			}
		}
}


$settings = 
{
		load: function(panel_id) 
		{
			$(window).unbind("scroll");
			if(settings_html)
			{
				new URI(User,"self","self").include(POLICY).include(UserPreferences).include(LinkedAccounts).include(CloseAccounts).include(AuthorizedWebsites).GET().then(function(resp)	//No I18N
				{
					settings_data=resp.User;
					de('zcontiner').style.display='none';
					$('#zcontiner').html(settings_html);//No I18N
					load_settings();
					removeGif();
					de('zcontiner').style.display='block';
					scroll_tab(panel_id,scroll_change);
				},
				function(resp)
				{
					 if(resp.cause && resp.cause.trim() === "invalid_password_token") 
					 {
						 var serviceurl = window.location.href;
						 var redirecturl = resp.redirect_url;
	     	             window.location.href =contextpath + redirecturl +'?serviceurl='+euc(serviceurl)//No I18N
	     	             return false;
					 }
					 else
					 {
						 $('#zcontiner').html($("#exception_page").html());
						 de('zcontiner').style.display='block';
						 removeGif();
						 $('#zcontiner #exception_page_txt').html(resp.message)
					 }
				});
				
			}
			else
			{	
				$.when( Template.GET("settings"), new URI(User,"self","self").include(POLICY).include(UserPreferences).include(LinkedAccounts).include(CloseAccounts).include(AuthorizedWebsites).GET())//No I18N
				    .then(function(template,detail) 
				    {
				    	settings_html=template.content;
				    	$('#zcontiner').html(settings_html);//No I18N
						settings_data=detail.User;
						load_settings();
						removeGif();
						de('zcontiner').style.display='block';
						scroll_tab(panel_id,scroll_change);
				    },
					function(resp)
					{
						 if(resp.cause && resp.cause.trim() === "invalid_password_token") 
						 {
							 var serviceurl = window.location.href;
							 var redirecturl = resp.redirect_url;
		     	             window.location.href =contextpath + redirecturl +'?serviceurl='+euc(serviceurl)//No I18N
		     	             return false;
						 }
						 else
						 {
							 $('#zcontiner').html($("#exception_page").html());
							 de('zcontiner').style.display='block';
							 removeGif();
							 $('#zcontiner #exception_page_txt').html(resp.message)
						 }
					});
			}	
		}
}

$sessions = 
{
		load: function(panel_id) 
		{
			$(window).unbind("scroll");
			if(sessions_html)
			{
				new URI(User,"self","self").include(ActiveSessions).include(ActiveAuthtokens).include(Connected_apps).include(App_logins).include(POLICY).GET().then(function(resp)	//No I18N
				{
					sessions_data=resp.User;
					de('zcontiner').style.display='none';
					$('#zcontiner').html(sessions_html);//No I18N
					load_sessions();
					removeGif();
					de('zcontiner').style.display='block';
					scroll_tab(panel_id,scroll_change);
				},
				function(resp)
				{
					 if(resp.cause && resp.cause.trim() === "invalid_password_token") 
					 {
						 var serviceurl = window.location.href;
						 var redirecturl = resp.redirect_url;
	     	             window.location.href =contextpath + redirecturl +'?serviceurl='+euc(serviceurl)//No I18N
	     	             return false;
					 }
					 else
					 {
						 $('#zcontiner').html($("#exception_page").html());
						 de('zcontiner').style.display='block';
						 removeGif();
						 $('#zcontiner #exception_page_txt').html(resp.message);
					 }
				});
				
				
			}
			else
			{	
				// Template.create({screenname: 'profile'}).getURI('profile').GET()
				$.when( Template.GET("sessions"), new URI(User,"self","self").include(ActiveSessions).include(ActiveAuthtokens).include(Connected_apps).include(App_logins).include(POLICY).GET())//No I18N
				    .then(function(template,detail) 
				    {
				    	sessions_html=template.content;
				    	$('#zcontiner').html(sessions_html);//No I18N
						sessions_data=detail.User;
						load_sessions();
						removeGif();
						de('zcontiner').style.display='block';
						scroll_tab(panel_id,scroll_change);
				    },
					function(resp)
					{
						 if(resp.cause && resp.cause.trim() === "invalid_password_token") 
						 {
							 var serviceurl = window.location.href;
							 var redirecturl = resp.redirect_url;
		     	             window.location.href =contextpath + redirecturl +'?serviceurl='+euc(serviceurl)//No I18N
		     	             return false;
						 }
						 else
						 {
							 $('#zcontiner').html($("#exception_page").html());
							 de('zcontiner').style.display='block';
							 removeGif();
							 $('#zcontiner #exception_page_txt').html(resp.message)
						 }
					});
					
			}	
		}
}


$groups = 
{
		load: function(action, id) 
		{
			$(window).unbind("scroll");
			if(groups_html)
			{
				new URI(Groups,"self","self").include(GroupMembers).include(GroupPendingInvitations).GETS().then(function(resp)	//No I18N
				{
					groups_data=resp;
					de('zcontiner').style.display='none';
					$('#zcontiner').html(groups_html);//No I18N
					load_groups();
					removeGif();
					de('zcontiner').style.display='block';
					group_operation(action, id)
				},
				function(resp)
				{
					 $('#zcontiner').html($("#exception_page").html());
					 de('zcontiner').style.display='block';
					 removeGif();
					 $('#zcontiner #exception_page_txt').html(resp.message)
				});
				
			}
			else
			{	
				// Template.create({screenname: 'profile'}).getURI('profile').GET()
				$.when( Template.GET("groups"), new URI(Groups,"self","self").include(GroupMembers).include(GroupPendingInvitations).GETS())//No I18N
				    .then(function(template,detail) 
				    {
				    	groups_html=template.content;
				    	$('#zcontiner').html(groups_html);//No I18N
						groups_data=detail;
						load_groups();
						removeGif();
						de('zcontiner').style.display='block';
						group_operation(action, id)
				    },
					function(resp)
					{
						 $('#zcontiner').html($("#exception_page").html());
						 de('zcontiner').style.display='block';
						 removeGif();
						 $('#zcontiner #exception_page_txt').html(resp.message)
					});
			}	
		}
}


$privacy = 
{
		load: function(panel_id,kyc_id) 
		{
			$(window).unbind("scroll");
			if(privacy_html)
			{
				new URI(User,"self","self").include(privacy).include(POLICY).include(KYC).GET().then(function(resp)	//No I18N
				{
					privacy_data=resp.User;
					de('zcontiner').style.display="none";
					$('#zcontiner').html(privacy_html);//No I18N
					load_privacy(panel_id,kyc_id);
				},
				function(resp)
				{
					if(resp.cause && resp.cause.trim() === "invalid_password_token") 
					 {
						 var serviceurl = window.location.href;
						 var redirecturl = resp.redirect_url;
	     	             window.location.href =contextpath + redirecturl +'?serviceurl='+euc(serviceurl)//No I18N
	     	             return false;
					 }
					 else
					 {
						 $('#zcontiner').html($("#exception_page").html());
						 de('zcontiner').style.display='block';
						 removeGif();
						 $('#zcontiner #exception_page_txt').html(resp.message)
					 }
				});
				
			}
			else
			{	
				// Template.create({screenname: 'profile'}).getURI('profile').GET()
				$.when( Template.GET("privacy"), new URI(User,"self","self").include(privacy).include(POLICY).include(KYC).GET())//No I18N
				    .then(function(template,detail) 
				    {
				    	privacy_html=template.content;
				    	de('zcontiner').style.display="none";
				    	$('#zcontiner').html(privacy_html);//No I18N
						privacy_data=detail.User;
						load_privacy(panel_id,kyc_id);
				    },
					function(resp)
					{
				    	if(resp.cause && resp.cause.trim() === "invalid_password_token") 
						 {
							 var serviceurl = window.location.href;
							 var redirecturl = resp.redirect_url;
		     	             window.location.href =contextpath + redirecturl +'?serviceurl='+euc(serviceurl)//No I18N
		     	             return false;
						 }
						 else
						 {
							 $('#zcontiner').html($("#exception_page").html());
							 de('zcontiner').style.display='block';
							 removeGif();
							 $('#zcontiner #exception_page_txt').html(resp.message)
						 }
					});
			}	
		}
}

$compliance = 
{
		load: function() 
		{
			$(window).unbind("scroll");
			if(compliance_html)
			{
				new URI(User,"self","self").include(certificates).GET().then(function(resp)	//No I18N
				{
					compliance_data=resp.User;
					de('zcontiner').style.display="none";
					$('#zcontiner').html(compliance_html);//No I18N
					load_compliance();
					removeGif();
					de('zcontiner').style.display='block';
				},
				function(resp)
				{
					if(resp.cause && resp.cause.trim() === "invalid_password_token") 
					 {
						 var serviceurl = window.location.href;
						 var redirecturl = resp.redirect_url;
	     	             window.location.href =contextpath + redirecturl +'?serviceurl='+euc(serviceurl)//No I18N
	     	             return false;
					 }
					 else
					 {
						 $('#zcontiner').html($("#exception_page").html());
						 de('zcontiner').style.display='block';
						 removeGif();
						 $('#zcontiner #exception_page_txt').html(resp.message)
					 }
				});
				
			}
			else
			{	
				$.when( Template.GET("compliance"), new URI(User,"self","self").include(certificates).GET())//No I18N
				    .then(function(template,detail) 
				    {
				    	compliance_html=template.content;
				    	de('zcontiner').style.display="none";
				    	$('#zcontiner').html(compliance_html);//No I18N
				    	compliance_data=detail.User;
						load_compliance();
						removeGif();
						de('zcontiner').style.display='block';
				    },
					function(resp)
					{
				    	if(resp.cause && resp.cause.trim() === "invalid_password_token") 
						 {
							 var serviceurl = window.location.href;
							 var redirecturl = resp.redirect_url;
		     	             window.location.href =contextpath + redirecturl +'?serviceurl='+euc(serviceurl)//No I18N
		     	             return false;
						 }
						 else
						 {
							 $('#zcontiner').html($("#exception_page").html());
							 de('zcontiner').style.display='block';
							 removeGif();
							 $('#zcontiner #exception_page_txt').html(resp.message)
						 }
					});
			}	
		}
}

$org = 
{
		load: function(panel_id) 
		{
			$(window).unbind("scroll");
			if(org_html)
			{
				new URI(Org,"self").include(Domain).include(SAML).GET().then(function(resp)	//No I18N
				{
					org_data = resp;
					$('#zcontiner').html(org_html);
					removeGif();
					de('zcontiner').style.display='block';
					loadOrg();
					
				},
				function(resp)
				{
					if(resp.cause && resp.cause.trim() === "invalid_password_token") 
					 {
						 var serviceurl = window.location.href;
						 var redirecturl = resp.redirect_url;
	     	             window.location.href =contextpath + redirecturl +'?serviceurl='+euc(serviceurl)//No I18N
	     	             return false;
					 }
					 else
					 {
						 $('#zcontiner').html($("#exception_page").html());
						 de('zcontiner').style.display='block';
						 removeGif();
						 $('#zcontiner #exception_page_txt').html(resp.message)
					 }
				});
				
			}
			else
			{	
				// Template.create({screenname: 'profile'}).getURI('profile').GET()
				$.when( Template.GET("organization"),new URI(Org,"self").include(SAML).include(Domain).GET())//No I18N
				    .then(function(template,detail) 
				    {
				    	org_html=template.content;
				    	org_data = detail;
				    	$('#zcontiner').html(org_html);
				    	removeGif();
						de('zcontiner').style.display='block';
						loadOrg();
				    },
					function(resp)
					{
				    	if(resp.cause && resp.cause.trim() === "invalid_password_token") 
						 {
							 var serviceurl = window.location.href;
							 var redirecturl = resp.redirect_url;
		     	             window.location.href =contextpath + redirecturl +'?serviceurl='+euc(serviceurl)//No I18N
		     	             return false;
						 }
						 else
						 {
							 $('#zcontiner').html($("#exception_page").html());
							 de('zcontiner').style.display='block';
							 removeGif();
							 $('#zcontiner #exception_page_txt').html(resp.message)
						 }
					});
			}
		}
}
		

function reload_exception(tab,id)
{
	$("#"+id+" .box_blur").show();
	$("#"+id+" .loader").show();
	
	new URI(User,"self","self").include(tab).include(POLICY).GET().then(function(resp)	//No I18N
			{
		  		var Policies =resp.User.Policies;
				if(tab=="Email")
				{
				  profile_data.Email=JsonArrayToArray(resp.User.Email,'email_id');//No I18N
				  load_emaildetails(Policies, profile_data.Email);
				}
				else if(tab=="Phone")
				{
					  profile_data.Phone=resp.User.Phone;
					  if(!jQuery.isEmptyObject(profile_data.Phone))
					  {
						  if(!jQuery.isEmptyObject(profile_data.Phone.recovery))
						  {
							  profile_data.Phone.recovery=JsonArrayToArray( profile_data.Phone.recovery,'mobile');//No I18N
						  }
						  if(!jQuery.isEmptyObject(profile_data.Phone.unverfied))
						  {
							  profile_data.Phone.unverfied=JsonArrayToArray(profile_data.Phone.unverfied,'mobile');//No I18N
						  }
						  if(!jQuery.isEmptyObject(profile_data.Phone.tfa))
						  {
							  profile_data.Phone.tfa=JsonArrayToArray( profile_data.Phone.tfa,'mobile');//No I18N
						  }
						  var Phones = profile_data.Phone;
						  load_phonedetails(Policies,Phones);
					  }
				}
				else if(tab=="Password")
				{
					security_data.Password=resp.User.Password;
					load_passworddetails(Policies,security_data.Password);
				}
				else if(tab=="SecurityQuestion")
				{
					security_data.SecurityQA=resp.User.SecurityQA;
					if(security_data.SecurityQA!=undefined)
					{
						load_SecQdetails(Policies,security_data.SecurityQA);
					}
				}
				else if(tab=="AppPasswords")
				{
					security_data.AppPasswords=resp.User.AppPasswords;
					load_AppPasswords(Policies,security_data.AppPasswords);
				}
				else if(tab=="AllowedIP")
				{
					security_data.AllowedIPs=resp.User.AllowedIPs;
					load_IPdetails(Policies,security_data.AllowedIPs);
				}
				else if(tab=="DeviceLogins")
				{
					security_data.AllowedIPs=resp.User.DeviceLogins;
					load_DeviceLogins(Policies,security_data.DeviceLogins);
				}
				else if(tab=="AuthorizedWebsites")
				{
					settings_data.AuthorizedWebsites=resp.User.AuthorizedWebsites;
					load_AuthWebsitesdetails(Policies,settings_data.AuthorizedWebsites);
				}
				else if(tab=="LinkedAccounts")
				{
					settings_data.LinkedAccounts=resp.User.LinkedAccounts;
					load_Linked_Accountsdetails(Policies,settings_data.LinkedAccounts);
				}
				else if(tab=="SAML")
				{
					settings_data.SAML=resp.User.SAML;
					if(de("org_saml_space")	&&	settings_data.SAML!=undefined)
					{
						load_samldetails(Policies,settings_data.SAML);

					}
				}
				else if(tab=="CloseAccounts")
				{
					settings_data.CloseAccounts=resp.User.CloseAccounts;
					load_closeddetails(Policies,settings_data.CloseAccounts);
				}
				else if(tab=="ActiveSessions")
				{
					sessions_data.activesessions=resp.User.activesessions;
					load_Sessionsdetails(Policies,sessions_data.activesessions);
				}
				else if(tab=="ActiveAuthtokens")
				{
					sessions_data.authtokens=resp.User.authtokens;
					if(sessions_data.authtokens!=undefined)
					{
						load_Authtokensdetails(Policies,sessions_data.authtokens);
					}
				}
				else if(tab=="ConnectedApps")
				{
					sessions_data.connectedapps=resp.User.connectedapps.response;
					load_connected_apps_details(Policies,sessions_data.connectedapps);
				}
				else if(tab=="AppLogins")
				{
					sessions_data.applogins=resp.User.applogins;
					load_App_Logins_details(Policies,sessions_data.applogins);
				}
				$("#"+id+" .box_blur").hide();
				$("#"+id+" .loader").hide();

			},
			function(resp)
			{
				$("#"+id+" .box_blur").hide();
				$("#"+id+" .loader").hide();
				 if(resp.cause && resp.cause.trim() === "invalid_password_token") 
				 {
					 var serviceurl = window.location.href;
					 var redirecturl = resp.redirect_url;
     	             window.location.href =contextpath + redirecturl +'?serviceurl='+euc(serviceurl)//No I18N
     	             return false;
				 }
				 else
				 {
					 showErrorMessage(resp.message);
				 }
			});
}


function JsonArrayToArray(obj,id)
{
	var array=[];
	for(i=0;i<obj.length;i++)
	{
		if(id=='email_id')
		{
			array[obj[i].email_id]=obj[i];
		}
		else if(id=='mobile')
		{
			array[obj[i].mobile]=obj[i];
		}
		
	}
	return array;
}

function load_profile()
{
	if(profile_data.Email[0]!=undefined)// to check if it has already been converted
	{
		profile_data.Email=JsonArrayToArray(profile_data.Email,'email_id');//No I18N
		var email_keys = Object.keys(profile_data.Email);
		for(var x in email_keys){
			profile_data.Email[decodeHTML(email_keys[x])] = profile_data.Email[email_keys[x]];
			delete profile_data.Email[email_keys[x]];
		}
	}

  var Policies =profile_data.Policies;
  var Emails = profile_data.Email;

  load_userdetails(Policies,profile_data);
  load_emaildetails(Policies,Emails);
 
  if(!jQuery.isEmptyObject(profile_data.Phone))
  {
	  if(!jQuery.isEmptyObject(profile_data.Phone.recovery))
	  {
		if(profile_data.Phone.recovery[0]!=undefined)// to check if it has already been converted
		{
		  profile_data.Phone.recovery=JsonArrayToArray( profile_data.Phone.recovery,'mobile');//No I18N
		}
	  }
	  if(!jQuery.isEmptyObject(profile_data.Phone.unverfied))
	  {
		if(profile_data.Phone.unverfied[0]!=undefined)// to check if it has already been converted
		{
			  profile_data.Phone.unverfied=JsonArrayToArray(profile_data.Phone.unverfied,'mobile');//No I18N
		}
	  }
	  if(!jQuery.isEmptyObject(profile_data.Phone.tfa))
	  {
		if(profile_data.Phone.tfa[0]!=undefined)// to check if it has already been converted
		{
		  profile_data.Phone.tfa=JsonArrayToArray( profile_data.Phone.tfa,'mobile');//No I18N
		}
	  }
	  var Phones = profile_data.Phone;
	  load_phonedetails(Policies,Phones);
  }
	if((profile_data.country!="") && (profile_data.country != undefined))
	{
		$('#countNameAddDiv option:selected').removeAttr('selected');
		$("#countNameAddDiv option[value="+profile_data.country.toUpperCase()+"]").attr('selected','selected');
	}
	else if(curr_country!=undefined	&&	curr_country!="")
	{
		$('#countNameAddDiv option:selected').removeAttr('selected');
		$("#countNameAddDiv option[value="+curr_country.toUpperCase()+"]").attr('selected','selected');
	}
  //$(".textbox").attr('autocomplete','off');//No I18N
}


function load_security()
{
	var Policies =security_data.Policies;
	var Password = security_data.Password;
	var SecurityQA = security_data.SecurityQA;
	var AllowedIPs = security_data.AllowedIPs;
	var AppPasswords = security_data.AppPasswords;
	var DeviceLogins = security_data.DeviceLogins;

	load_passworddetails(Policies,Password);
	if(SecurityQA!=undefined)
	{
		load_SecQdetails(Policies,SecurityQA);
	}
	load_IPdetails(Policies,AllowedIPs);
	load_AppPasswords(Policies,AppPasswords);
	load_DeviceLogins(Policies,DeviceLogins);
}

function load_sessions()
{
	var Policies =sessions_data.Policies;
	var Active_Sessions = sessions_data.activesessions;
	var Auth_tokens = sessions_data.authtokens;
	sessions_data.connectedapps=sessions_data.connectedapps.response

	var connected_apps_details = sessions_data.connectedapps;
	var App_Logins_details = sessions_data.applogins;

	load_Sessionsdetails(Policies,Active_Sessions);
	if(Auth_tokens!=undefined)
	{
		load_Authtokensdetails(Policies,Auth_tokens);
	}
	if(history_data)
	{
		load_History();
	}
	load_connected_apps_details(Policies,connected_apps_details);
	load_App_Logins_details(Policies,App_Logins_details);
}

function load_settings()
{
	var Policies =settings_data.Policies;
	var Preferences = settings_data.UserPreferences;
	var Auth_websites = settings_data.AuthorizedWebsites;
	var Linked_Accounts = settings_data.LinkedAccounts;
	var Close_Accounts = settings_data.CloseAccounts;
	

	load_Preferencedetails(Policies,Preferences);
	load_AuthWebsitesdetails(Policies,Auth_websites);
	if(settings_data.LinkedAccounts!=undefined)
	{
		load_Linked_Accountsdetails(Policies,Linked_Accounts);
	}
	else
	{
		$("#linkedaccounts").remove();
		if(de("linkedaccounts_space"))
		{
			$("#linkedaccounts_space").remove();
		}
	}
	load_closeddetails(Policies,Close_Accounts);
}
function loadOrg(){
	var SAML_details = org_data.SAML;
	var Domain_detail = org_data.DOMAINDETAILS;
	if(de("org_saml_space")	&&	SAML_details!=undefined)
	{
		load_samldetails(SAML_details);
	}
	loadDomains(Domain_detail);
}

function timeSorting(object, issignoutbased)
{
	sortedData = [];
	iter = 0;
	for(a in object)
	{
		sortedData[iter] = object[a];
		sortedData[iter].keyName = a;
		iter++;
	}
	if(issignoutbased){
		sortedData=sortedData.sort(GetSortOrder("logout_millis"));  //No I18N
	}
	else{
		sortedData=sortedData.sort(GetSortOrder("created_time"));  //No I18N
	}
	var data = [];
	for(var a in sortedData){data.push(sortedData[a].keyName)}
	return data;
}

function GetSortOrder(prop) {  
    return function(a, b) {  
        if (a[prop] < b[prop]) {  
            return 1;  
        } else if (a[prop] > b[prop]) {  
            return -1;  
        }  
        return 0;  
    }  
}


function removeGif(){
	$(".nav_bar").hide();
	$(".content").hide();	
}



function load_privacy(panel_id,kyc_id)
{
	//var Policies = "";//privacy_data.Policies;
	var dpa_data = privacy_data.Privacy;
	var kyc_data = privacy_data.KYC;
	
	if(window.location.hash.split('/')[2] == 'gdpr'){
		$("#ccpa_toggle").prop( "checked", false );
	}
	else if(window.location.hash.split('/')[2] == 'ccpa'){
		$("#ccpa_toggle").prop( "checked", true );
	}
	
	if(Object.keys(dpa_data).length > 0) {
		load_GDPRdetails(dpa_data);
	}
	
	if(Object.keys(kyc_data).length > 0) {
		$("#myc_space").show();
		load_KYCdetails(kyc_data, function(){
			if(kyc_id){
				removeGif();
				de('zcontiner').style.display='block';
				assignHash("privacy", "myc?"+kyc_id); //No I18N
				scroll_tab(panel_id,scroll_change);
			}
		},kyc_id);
	}
	
	else{
		$("#myc_space").hide();
		removeGif();
		de('zcontiner').style.display='block';
	}
	if(privacy_data.Privacy.ccpa_data.code == "DPA401" && privacy_data.Privacy.gdpr_data.code == "DPA401"){
		$("#dpa,#myc").hide();
		show_submenu("privacy","");	//No I18N
	}
	else{
		$("#dpa,#myc").show();
		show_submenu("privacy","dpa"); //No I18N
	}
	if(!isMobile){
		tippy(".data_expl",{	//No I18N
			maxWidth: '250px',	//No I18N
			arrow: true,
			theme:'whiteTip'		//No I18N
		});		
	}
}

function load_compliance()
{
	var certificate_data = compliance_data.Certificates;
	load_CERTIFICATEdetails(certificate_data);
}

