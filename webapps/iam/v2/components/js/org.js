//$Id$
function loadDomains(Domain_detail){
	if(Object.keys(Domain_detail).length == 0){		
		$("#domain_content").hide();
		$("#no_domain").show();
		return false;
	}
	var verified_domain = Object.keys(Domain_detail.verified).sort(function(a,b){return ignoreCaseSensitive(a,b)});
	var unverified_domain = Object.keys(Domain_detail.unVerified).sort(function(a,b){return ignoreCaseSensitive(a,b)});
	var count=0;
	$(".unverified_domain,.verified_domain").text("");
	for(var a in unverified_domain){
		count++;
		$("#domain_content .unverified_domain").append("<div class='domain_tab domain_unverified_"+count+"' >"+$(".domain_temp").html()+"</div>"); //No I18N
		$(".domain_unverified_"+count+" .domain_name").text(unverified_domain[a]);
		$(".domain_unverified_"+count+" .email_dp").addClass(color_classes[gen_random_value()]);
		$(".domain_unverified_"+count+" .verify_button").attr("onclick","showDomainVerifyPopup('"+unverified_domain[a]+"')");
		$(".domain_unverified_"+count+" .delete_button").attr("onclick","deleteDomain('"+unverified_domain[a]+"')");
		$(".domain_unverified_"+count).attr("onclick","showMobileDomain(this,'"+unverified_domain[a]+"')");
	}
	count=0;
	for(var a in verified_domain){
		count++;
		$("#domain_content .verified_domain").append("<div class='domain_tab domain_verified_"+count+"' >"+$(".domain_temp").html()+"</div>"); //No I18N
		$(".domain_verified_"+count+" .domain_name").text(verified_domain[a]);
		$(".domain_verified_"+count+" .email_dp").addClass(color_classes[gen_random_value()]);
		$(".domain_verified_"+count+" .verify_button").remove();
		$(".domain_verified_"+count+" .delete_button").remove();
	}
	if(isMobile){
		$(".domain_tab .action_icon").remove();
	}
	else{		
		tooltipSet(".domain_tab .delete_button"); //No I18N
	}
	$(".verified_domain .unver_content").hide();
	$(".unverified_domain .ver_content").hide();
}

function showMobileDomain(ele,domain){
	if(isMobile){
		popup_blurHandler('6','.5');
		var isVerified = org_data.DOMAINDETAILS.unVerified[domain] != undefined ? false : true;
		if(!isVerified){
			$("#domain_popup_for_mobile").show(0,function(){
				$("#domain_popup_for_mobile").addClass("pop_anim");		
			});	
			$("#domain_popup_for_mobile .popuphead_details").html("");
			$("#domain_popup_for_mobile .popuphead_details").append($(ele).find(".email_dp")[0].outerHTML);
			$("#domain_popup_for_mobile .popuphead_details").append($(ele).find(".domain_info")[0].outerHTML);
				$("#domain_popup_for_mobile #btn_to_verify").show();
				$("#domain_popup_for_mobile #btn_to_verify").attr("onclick","mobilePopupCallback(function(){showDomainVerifyPopup('"+domain+"')})");//No I18N
				$("#domain_popup_for_mobile #btn_to_delete_domain").attr("onclick","mobilePopupCallback(function(){deleteDomain('"+domain+"')})");//No I18N
				$("#domain_popup_for_mobile #btn_to_delete_domain").show();
			closePopup(close_domain_mobile_specific,"domain_popup_for_mobile");//No I18N
		}
	}
}
function mobilePopupCallback(callback){
	$("#domain_popup_for_mobile").removeClass("pop_anim");
	$("#domain_popup_for_mobile").fadeOut(200,function(){
		callback();
	});
}

function close_domain_mobile_specific(){
	popupBlurHide("#domain_popup_for_mobile"); //No I18N
}

function showDomainVerifyPopup(domain){
	$(".domain_err_content").hide();
	if(isMobile){
		$(".step_box").css("max-height","calc(100% - 292px)");
	}
	else{
		$(".step_box").css("max-height","calc(100% - 250px)");
	}
	$("#verify_domain").show(0,function(){
		$("#verify_domain").addClass("pop_anim");
	});
	popup_blurHandler('6','.5');
	$(".domain_options #txt").click();
	$(".domainNameWithContent").text(domain);
	var data = org_data.DOMAINDETAILS.unVerified[domain] != undefined ? org_data.DOMAINDETAILS.unVerified[domain] : org_data.DOMAINDETAILS.verified[domain];
	var html_name = data.html.url.split("/")[data.html.url.split("/").length-1];
	$(".html_content .domain_html").text(html_name);
	$(".html_content .url_examp").text(data.html.url);
	$(".html_domain_box").attr("onclick","downloadFile('"+html_name+"','"+data.html.Vcode+"')");//No I18N
	$(".cname_content .host_name").text(data.cname.host);
	$(".cname_content .host_value").text(data.cname.destination);
	
	$(".txt_content .host_value").text(data.txt);
	$("#verify_domain .blue").attr("title",err_app_pass_copied);
	tippy("#verify_domain .blue",{//No I18N
		trigger:"click",//No I18N
		arrow:true,
		hideOnClick: false, // if you want
		onShow(instance) {
		   setTimeout(function() {
		     instance.hide();
		   }, 800);
		}
	});
	$("#verify_domain #verify_domain_action").attr("onclick","verifyTheDomain('"+domain+"')");
	closePopup(close_domain_edit,"verify_domain");//No I18N
	changeDomainOption($(".domain_options #txt"));
	$("#verify_domain").focus();
}

function ignoreCaseSensitive(a,b){
	  var nameA = a.toUpperCase();
	  var nameB = b.toUpperCase();
	  if (nameA < nameB) {
	    return -1;
	  }
	  if (nameA > nameB) {
	    return 1;
	  }
	  return 0;
}



function clickToCopy(tippyTarget,copyTarget){
	var range = document.createRange();
    range.selectNode(document.getElementById(copyTarget));
    window.getSelection().removeAllRanges();
    window.getSelection().addRange(range);
    document.execCommand("copy");//No I18N
    window.getSelection().removeAllRanges();  
}
function close_domain_edit(){
	popupBlurHide("#verify_domain",function(){	//No I18N
		remove_error();
		removeButtonDisable("#verify_domain");	//No I18N
	});
}
function changeDomainOption(ele){
	$(".step_box").hide();
	$(".domain_err_content").hide();
	if(isMobile){
		$(".step_box").css("max-height","calc(100% - 292px)");
	}
	else{
		$(".step_box").css("max-height","calc(100% - 250px)");
	}
	$("."+$(ele).attr("id")+"_content").show();
	$(".step_box:visible").css("max-height","unset");
	
	if(isMobile){
		$("#verify_domain").css("height",312+$(".step_box:visible")[0].scrollHeight+"px");
		$(".step_box:visible").css("max-height","calc(100% - 292px)"); //No I18N
	}else{
		$("#verify_domain").css("height",272+$(".step_box:visible")[0].scrollHeight+"px");
		$(".step_box:visible").css("max-height","calc(100% - 250px)"); //No I18N
	}
}
function verifyTheDomain(domain){
	$(".domain_err_content").hide();
	if(isMobile){
		$(".step_box").css("max-height","calc(100% - 292px)");
	}
	else{
		$(".step_box").css("max-height","calc(100% - 250px)");
	}

	var payload = DomainObj.create({"type":$(".domain_options").find("input:checked").val()});//No I18N
	payload.build();
	disabledButton("#verify_domain");	//No I18N
	payload.PUT("self",domain).then(function(resp)	//No I18N
	{
		removeButtonDisable("#verify_domain");	//No I18N
		org_data.DOMAINDETAILS.verified[domain]=org_data.DOMAINDETAILS.unVerified[domain]
		delete org_data.DOMAINDETAILS.unVerified[domain];
		SuccessMsg(getErrorMessage(resp));
		close_domain_edit();
		loadDomains(org_data.DOMAINDETAILS);
	},
	function(resp)
	{
		removeButtonDisable("#verify_domain");	//No I18N
		if(resp.cause && resp.cause.trim() === "invalid_password_token") 
		{
			relogin_warning();
			var service_url = euc(window.location.href);
			$("#new_notification").attr("onclick","window.open('"+contextpath + resp.redirect_url +"?serviceurl="+service_url+"&post="+true+"', '_blank');");//No I18N 
		}
		else
		{
			if(resp.errors[0].code=="DOMAIN500"){
				$(".domain_err_content").html(resp.localized_message);
				$(".domain_err_content").show();
				var errHeight= !isMobile ? $(".domain_err_content")[0].scrollHeight : $(".domain_err_content")[0].scrollHeight+40;
				$(".domain_err_content").hide()
				$(".domain_err_content").slideDown(200);
				$(".step_box:visible").css("max-height","calc(100% - "+(250+errHeight+20)+"px)"); //No I18N
			}
			else{
				showErrorMessage(getErrorMessage(resp));
			}
		}
	});	
}

function deleteDomain(domain){
	show_confirm(formatMessage(iam_org_domain_delete, domain),
		    function() 
		    {
				new URI(DomainObj,"self",domain).DELETE().then(function(resp)	//No I18N
						{
							delete org_data.DOMAINDETAILS.unVerified[domain];
							loadDomains(org_data.DOMAINDETAILS);
						},
						function(resp)
						{
							if(resp.cause && resp.cause.trim() === "invalid_password_token") 
							{
								relogin_warning();
								var service_url = euc(window.location.href);
								$("#new_notification").attr("onclick","window.open('"+contextpath + resp.redirect_url +"?serviceurl="+service_url+"&post="+true+"', '_blank');");//No I18N 
							}
							else
							{
								showErrorMessage(getErrorMessage(resp));
							}
						});
		    },function(){
		    	return false;
		    }
	);
}
/*********************************SAML***************************************/

function load_samldetails(SAML_details)
{
	if(de("saml_exception"))
	{
		$("#saml_exception").remove();
	}
	if(SAML_details.exception_occured!=undefined	&&	SAML_details.exception_occured)
	{
		$("#saml_box .box_info" ).after("<div id='saml_exception' class='box_content_div'>"+$("#exception_tab").html()+"</div>" );
		$("#saml_exception #reload_exception").attr("onclick","reload_exception(SAML,'saml_box')");
		return;
	}
	
	if(SAML_details!=undefined)
	{	
		if(SAML_details.issaml_loginenabled)
		{
			$("#saml_notActivated").hide();
			$("#saml_activated").show();
			$("#saml_info_show").show();
			
			if(SAML_details.issaml_enabled)
			{
				$("#toggle_saml").attr("checked","checked");
				if(SAML_details.issaml_logoutEnabled)
				{
					$("#saml_logout_check").attr("checked","checked");
					$("#edit_logout_url").removeAttr("data-optional");
				}
				else
				{
					$("#saml_logout_check").removeAttr("checked");
					$("#edit_logout_url").attr("data-optional","true");
				}
				
			}
			else
			{
				$("#toggle_saml").removeAttr("checked");
				$("#saml_logout_check").removeAttr("checked");
			}
			
			$("#saml_info_show #login_url").html(SAML_details.saml_login_url);
			$("#saml_info_show #logout_url").html(SAML_details.saml_logout_url);
			$("#saml_info_show #password_url").html(SAML_details.saml_password_url);
			$("#saml_info_show #saml_algorithm").html(SAML_details.saml_algorithm);
			$("#saml_info_show #SAMLservice_name").html(SAML_details.saml_service);
			
			
			$("#edit_login_url").val(SAML_details.saml_login_url);
			$("#edit_logout_url").val(SAML_details.saml_logout_url);
			$("#edit_password_url").val(SAML_details.saml_password_url);
			if(SAML_details.issaml_logoutEnabled)
			{
				$("#downalod_logout_response").show();
			}
			else
			{
				$("#downalod_logout_response").hide();
			}
			$('#edit_saml_algorithm option[value='+SAML_details.saml_algorithm+']').prop('selected', true);
			$('#edit_SAMLservice_name option[value='+SAML_details.saml_service+']').prop('selected', true);
			
			if(SAML_details.issaml_jit_enabled)
			{
				$("#SAML_JIT_indicator").show();
				
				$("#saml_jit_check").attr("checked","checked");
				$("#saml_JIT_fields").html("");
				$("#saml_JIT_fields").show();
				if(SAML_details.jit_attributes)
				{
					if(SAML_details.jit_attributes.first_name)
					{
						init_jit_fields();
						$("#saml_JIT_fields select:last").val("first_name");
						$("#saml_JIT_fields .inputText:last input")[0].name="first_name";
						$("#saml_JIT_fields .inputText:last input")[0].value=SAML_details.jit_attributes.first_name;
					}
					if(SAML_details.jit_attributes.last_name)
					{
						init_jit_fields();
						$("#saml_JIT_fields select:last").val("last_name");
						$("#saml_JIT_fields .inputText:last input")[0].name="last_name";
						$("#saml_JIT_fields .inputText:last input")[0].value=SAML_details.jit_attributes.last_name;
					}
					if(SAML_details.jit_attributes.display_name)
					{
						init_jit_fields();
						$("#saml_JIT_fields select:last").val("display_name");
						$("#saml_JIT_fields .inputText:last input")[0].name="display_name";
						$("#saml_JIT_fields .inputText:last input")[0].value=SAML_details.jit_attributes.display_name;
					}
					$("#saml_JIT_fields .saml_jit_select").select2();
				}
				else
				{
					init_jit_fields();
				}
				
			}
			else
			{
				$("#SAML_JIT_indicator").hide();
			}
			
		}
		else
		{
			$("#samlform")[0].reset();
			$("#saml_info_show").hide();
			$("#saml_notActivated").show();
			$("#saml_notActivated .no_data_text").html(formatMessage(saml_setup_description,SAML_details.org_name));	
			$("#saml_activated").hide();
		}
		
		//moved to template resource
//		var services=Object.keys(SAML_details.services);
//		$('#edit_SAMLservice_name').find('option').remove();
//		for(iter=0;iter<services.length;iter++)
//		{
//			var current_service=SAML_details.services[services[iter]];
//			$("#edit_SAMLservice_name").append("<option value="+current_service.servicename+">"+current_service.displayname+"</option>");
//		}
	}
}


function updateSaml(f) 
{
	assignHash("setting", "org_saml");//No I18N

	if(validateForm(f))
	{
		var login_url = f.login_url.value.trim();
		var logout_url = f.logout_url.value.trim();
		var change_pwd_url = f.password_url.value.trim();
		var servicename=f.service[f.service.selectedIndex].value.trim();
		var algorithm =f.algorithm[f.algorithm.selectedIndex].value.trim();
		var public_key = f.publickey.value.trim();
		var publickey_upload = f.publickey_upload.value;
		var logout_check=$('#saml_logout_check').prop('checked');
		var enable_saml_jit=$('#saml_jit_check').prop('checked');
	    
	    
			if(enable_saml_jit)
			{
				if(f.first_name && f.first_name.length>1)
				{
					showErrorMessage(saml_jit_duplicate);
					return false;
				}
				if(f.last_name && f.last_name.length>1)
				{
					showErrorMessage(saml_jit_duplicate);
					return false;
				}
				if(f.display_name && f.display_name.length>1)
				{
					showErrorMessage(saml_jit_duplicate);
					return false;
				}
			}
			var lastname = f.last_name?f.last_name.value:"" ;
			var firstname = f.first_name?f.first_name.value:"";
			var displayname = f.display_name?f.display_name.value:"";
		   disabledButton(f);
		   if(isEmpty(public_key) && isEmpty(publickey_upload)) 
		   {
			   showErrorMessage(err_samlsetup_enter_publickey);
			   removeButtonDisable(f);
		    	f.saml_publickey.focus();
		   }
		   else
		   {
				var parms=
				{
						"login_url":login_url,//No I18N
						"logout_url":logout_url,//No I18N
						"password_url":change_pwd_url,//No I18N
						"publickey":public_key,//No I18N
						"algorithm":algorithm,//No I18N
						"service":servicename,//No I18N
						"enable_saml_logout":logout_check,//No I18N
						"enable_saml_jit":enable_saml_jit,//No I18N
						"last_name":lastname,//No I18N
						"first_name":firstname,//No I18N
						"display_name":displayname,//No I18N
						"__form":$('#'+f.id)//No I18N	
				};
				
				var payload = SAMLObj.create(parms);
				payload.build();
				payload.POST("self").then(function(resp)	//No I18N
				{
					SuccessMsg(getErrorMessage(resp));
					org_data.SAML.issaml_loginenabled=true;
					org_data.SAML.issaml_enabled=true;
					org_data.SAML.issaml_logoutEnabled=logout_check;
					
					org_data.SAML.saml_login_url=login_url;
					org_data.SAML.saml_logout_url=logout_url;
					org_data.SAML.saml_password_url=change_pwd_url;
					org_data.SAML.saml_algorithm=algorithm;
					org_data.SAML.saml_service=servicename;
					if(enable_saml_jit)
					{
						org_data.SAML.issaml_jit_enabled=true;
						org_data.SAML.jit_attributes={};	
						if(firstname)
						{
							org_data.SAML.jit_attributes.first_name=firstname;
						}
						if(lastname)
						{
							org_data.SAML.jit_attributes.last_name=lastname;
						}
						if(displayname)
						{
							org_data.SAML.jit_attributes.display_name=displayname;
						}
					}
					else
					{
						org_data.SAML.issaml_jit_enabled=false;
					}
	
					load_samldetails(org_data.SAML);
					close_SAML_edit();
					removeButtonDisable(f);
				},
				function(resp)
				{
					removeButtonDisable(f);
					if(resp.cause && resp.cause.trim() === "invalid_password_token") 
					{
						relogin_warning();
						var service_url = euc(window.location.href);
						$("#new_notification").attr("onclick","window.open('"+contextpath + resp.redirect_url +"?serviceurl="+service_url+"&post="+true+"', '_blank');");//No I18N 
					}
					else
					{
						showErrorMessage(getErrorMessage(resp));
					}
				});	
	   		
		   }
	   }
    return false;
}

function updateSamlStatus(f) 
{
	var enablesaml =$('#toggle_saml').is(":checked");
	if(enablesaml!=null)
	{
		var parms=
		{
				"saml_status":enablesaml//No I18N
		};
		
		var payload = SAMLObj.create(parms);
		payload.build();
		payload.PUT("self").then(function(resp)	//No I18N
		{
			SuccessMsg(getErrorMessage(resp));
		},
		function(resp)
		{
			if(resp.cause && resp.cause.trim() === "invalid_password_token") 
			{
				relogin_warning();
				var service_url = euc(window.location.href);
				$("#new_notification").attr("onclick","window.open('"+contextpath + resp.redirect_url +"?serviceurl="+service_url+"&post="+true+"', '_blank');");//No I18N 
			}
			else
			{
				showErrorMessage(getErrorMessage(resp));
			}
		});	
		
	}
	else
	{
		return false;
    }
}

function show_jit_fields()
{
	if($('#saml_jit_check').is(":checked"))
	{
		$("#saml_JIT_fields").html("");
		$("#saml_JIT_fields").show();
		init_jit_fields();
	}
	else
	{
		$("#saml_JIT_fields").hide();
		$("#saml_JIT_fields").html("");
	}
	return;
}

function change_logout_response()
{
	if($('#saml_logout_check').is(":checked"))
	{
		$("#edit_logout_url").removeAttr("data-optional");
	}
	else
	{
		$("#edit_logout_url").attr("data-optional","true");
	}
	return;
}

function init_jit_fields()
{
	var JIT_var=[];
	$("#empty_jit_fields_format .saml_jit_select option").each(function()
	{
		JIT_var.push($(this).val())
	});
	
	if($("#saml_JIT_fields").children().length<JIT_var.length)
	{
		$("#empty_jit_fields_format").children().clone().appendTo("#saml_JIT_fields"); //No I18N
    	if($("#saml_JIT_fields .inputText").children().hasClass("saml_jit_fieldaction"))
    	{
    		$("#saml_JIT_fields .saml_jit_fieldaction").remove();
    	}
    	$("#saml_JIT_fields .inputText").not(":last").append(" <div class='saml_jit_fieldaction icon-cadd remove_field' onclick='removeEle(this)'></div>");
    	$("#saml_JIT_fields .inputText:last").append("<div class='saml_jit_fieldaction icon-cadd add_field' onclick='init_jit_fields()'></div>");
    	if($("#saml_JIT_fields").children().length==3)
    	{
        	$("#saml_JIT_fields .inputText:last .add_field").remove();
    	}
    	for(i=0;i<JIT_var.length;i++)
    	{
    		if($("#samlform input[name="+JIT_var[i]+"]").length==0)
    		{
    			$("#saml_JIT_fields select:last").val(JIT_var[i]);
				$("#saml_JIT_fields .inputText:last input")[0].name=JIT_var[i];
				break;
    		}
    	}
    	
    	$("#saml_JIT_fields .saml_jit_select").select2({
    		minimumResultsForSearch: Infinity,
    		theme:"saml" //No I18N
    	});
	}
	$("#saml_set").scrollTop($("#saml_set")[0].scrollHeight);
}

function inputName(ele)
{
	  $(ele).parents(".field").find(".namebox").attr("name",$(ele).val()); //No I18N
}

function removeEle(ele)
{
	$(ele).parents(".field").remove();
  	if($("#saml_JIT_fields .inputText").children().hasClass("saml_jit_fieldaction"))
	{
		$("#saml_JIT_fields .saml_jit_fieldaction").remove();
	}
	$("#saml_JIT_fields .inputText").not(":last").append(" <div class='saml_jit_fieldaction icon-cadd remove_field' onclick='removeEle(this)'></div>");
	$("#saml_JIT_fields .inputText:last").append("<div class='saml_jit_fieldaction icon-cadd add_field' onclick='init_jit_fields()'></div>");
}


function showSamlsetupOption() 
{
	
		$(".saml_opendiv").show(0,function(){
			$(".saml_opendiv").addClass("pop_anim");
		});
		closePopup(close_SAML_edit,"saml_open_cont");//No I18N
		popup_blurHandler('6','.5');
		if(!isMobile){			
			$("#edit_saml_algorithm").select2({
				minimumResultsForSearch: Infinity
			});
			$("#edit_SAMLservice_name").select2();
		}
		$("#saml_open_cont input:first").focus();//No I18N
}

function showSamlEditOption() 
{
	$(".saml_opendiv").show(0,function(){
		$(".saml_opendiv").addClass("pop_anim");
	});
	closePopup(close_SAML_edit,"saml_open_cont");//No I18N
	popup_blurHandler('6','.5');
	$('#edit_SAMLservice_name').val($('#edit_SAMLservice_name').find('option:contains('+org_data.SAML.saml_service+')').val());
	$(".saml_select").select2();
	$("#saml_open_cont input:first").focus();//No I18N
}

function close_SAML_edit()
{
	popupBlurHide(".saml_opendiv",function(){	//No I18N
		remove_error();
	});
	return false;
}

function deleteSaml() 
{
	show_confirm(err_saml_delete_confirmation,
		    function() 
		    {
				new URI(SAMLObj,"self").DELETE().then(function(resp)	//No I18N
						{
							SuccessMsg(getErrorMessage(resp));
							org_data.SAML.issaml_loginenabled=false;
							org_data.SAML.issaml_enabled=false;
							org_data.SAML.issaml_logoutEnabled=false;
							
							delete org_data.SAML.jit_attributes;							
							delete org_data.SAML.saml_login_url;
							delete org_data.SAML.saml_logout_url;
							delete org_data.SAML.saml_password_url;
							delete org_data.SAML.saml_algorithm;
							delete org_data.SAML.saml_service;
							
							load_samldetails(org_data.SAML);
							
							close_SAML_edit();
						},
						function(resp)
						{
							if(resp.cause && resp.cause.trim() === "invalid_password_token") 
							{
								relogin_warning();
								var service_url = euc(window.location.href);
								$("#new_notification").attr("onclick","window.open('"+contextpath + resp.redirect_url +"?serviceurl="+service_url+"&post="+true+"', '_blank');");//No I18N 
							}
							else
							{
								showErrorMessage(getErrorMessage(resp));
							}
						});
		    },
		    function() 
		    {
		    	return false;
		    }
		);
}



function samlPublicKeyOption(canShowUploadOption) 
{

	$("#saml_publickey").val("");
	$("#saml_publickey_upload").click();
	$("#saml_publickey_upload").change(function () 
	{
		$("#saml_filename").val($("#saml_publickey_upload").prop("files")[0].name);
		$("#saml_file_space").show();
		$("#saml_publickey").hide();
		$('#saml_publickey_upload').unbind();
	});
			
}


function changebacktotext()
{
	$("#saml_filename").val("");
	$("#saml_file_space").hide();
	$("#saml_publickey").show();
	$("#saml_publickey_upload").val("");
}