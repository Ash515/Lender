//$Id$
var yubikey_challenge={};

function clear_loading()
{
	$(".tfa_blur").hide();//tfa
	$(".loader").hide();//tfa

}

var mfa_deatils;//No i18N


function show_CHprimary_notice()
{
	popup_blurHandler('6','.5');
	$("#CHprimary_NOTICE").show(0,function(){
		$("#CHprimary_NOTICE").addClass("pop_anim");
	});
	closePopup(close_tfa_CHprimary_notice,"CHprimary_NOTICE");//No I18N
	
	$('#mfa_primary_select').empty();
	var one_auth_check=false;
	$("#mfa_primary_select").select2();
	for(i=0;i<tfa_data.modes.length;i++)
	{
		//TOUCH ID = 2; QR = 3; PUSH = 4; TOTP = 5; FACEID = 7;  BIOMETRIC = 11; MYZOHO_APP=12
		
		if(one_auth_check==false	&&	tfa_data.modes[i]=="devices")
		{
			one_auth_check=true;
			$('#mfa_primary_select').append($('<option>', { value : mfa_deatils.indexOf(tfa_data.modes[i]) }).text(mfa_mode_oneAuth));
		}
		else if(tfa_data.modes[i]=="otp")
		{
			$('#mfa_primary_select').append($('<option>', { value : mfa_deatils.indexOf(tfa_data.modes[i]) }).text(mfa_mode_details_otp));
		}
		else if(tfa_data.modes[i]=="totp")
		{
			$('#mfa_primary_select').append($('<option>', { value : mfa_deatils.indexOf(tfa_data.modes[i]) }).text(mfa_mode_details_totp));
		}
		else if(tfa_data.modes[i]=="exostar")
		{
			$('#mfa_primary_select').append($('<option>', { value : mfa_deatils.indexOf(tfa_data.modes[i]) }).text(mfa_mode_details_exo));
		}
		else if(tfa_data.modes[i]=="yubikey")
		{
			$('#mfa_primary_select').append($('<option>', { value : mfa_deatils.indexOf(tfa_data.modes[i]) }).text(mfa_mode_details_yubikey));
		}
	}
}

function change_new_primary()
{
	var mode=$('#mfa_primary_select').val();
	change_mode(mode);
	close_tfa_CHprimary_notice();
}

function load_mfa(display_bkup_popup)
{
	clear_loading();
	mfa_deatils=[];
	$("input[type=password]").val("");
	$("input[type=phonenumber]").val("");
	
	tooltip_Des(".action_icon");//No I18N
	
	$(".option_information").show();
	$(".option_preference").hide();
	
	
	//adding all modes
	//$("#mfa_modes1").html("");
	//$("#mfa_modes2").html("");
//	var mode_count=0;
//	
//	$(".option_grid").removeClass("primary_mode");
//	$(".child_flex").removeClass("column_order");
//	$(".mfa_mode_status_butt .primary_indicator").hide();
//	$(".mfa_mode_status_butt .secondary_indicator").show();
//	if($("#mfa_modes1").html()=="" && $("#mfa_modes2").html()==""){
//		
//	if(de("mfa_oneauth_mode"))//one auth mode exists
//	{
//		if(mode_count%2==0)
//		{
//			$("#mfa_modes1").append($("#allmodes #mfa_oneauth_mode")[0].outerHTML);
//			$("#mfa_modes1 #tfa_send_link_old").attr("id","tfa_send_link"); // chrome browser throws non-unique id err
//		}
//		else
//		{
//			$("#mfa_modes2").append($("#allmodes #mfa_oneauth_mode")[0].outerHTML);
//			$("#mfa_modes2 #tfa_send_link_old").attr("id","tfa_send_link"); // chrome browser throws non-unique id err
//		}
//		mode_count++;
//	}
//	
//	if(de("mfa_sms_mode"))//one auth mode exists
//	{
//		if(mode_count%2==0)
//		{
//			$("#mfa_modes1").append($("#allmodes #mfa_sms_mode")[0].outerHTML);
//		}
//		else
//		{
//			$("#mfa_modes2").append($("#allmodes #mfa_sms_mode")[0].outerHTML);
//		}
//		mode_count++;
//	}
//	
//	if(de("mfa_app_auth_mode"))//one auth mode exists
//	{
//		if(mode_count%2==0)
//		{
//			$("#mfa_modes1").append($("#allmodes #mfa_app_auth_mode")[0].outerHTML);
//		}
//		else
//		{
//			$("#mfa_modes2").append($("#allmodes #mfa_app_auth_mode")[0].outerHTML);
//		}
//		mode_count++;
//	}
//	
//	if(de("mfa_exo_mode"))//one auth mode exists
//	{
//		if(mode_count%2==0)
//		{
//			$("#mfa_modes1").append($("#allmodes #mfa_exo_mode")[0].outerHTML);
//		}
//		else
//		{
//			$("#mfa_modes2").append($("#allmodes #mfa_exo_mode")[0].outerHTML);
//		}
//		mode_count++;
//	}
//	
//	if(de("mfa_yubikey_mode"))//one auth mode exists
//	{
//		if(mode_count%2==0)
//		{
//			$("#mfa_modes1").append($("#allmodes #mfa_yubikey_mode")[0].outerHTML);
//		}
//		else
//		{
//			$("#mfa_modes2").append($("#allmodes #mfa_yubikey_mode")[0].outerHTML);
//		}
//		mode_count++;
//	}
//	$("#allmodes").remove();
//	mfa_html = $("#zcontiner").html();
//	}
/*	tfa_data.modes = tfa_data.modes.filter(function (el) 
	{
		return el != null;
	});
	if(tfa_data.modes.length==1)
	{
		change_mode(mfa_deatils.indexOf(tfa_data.modes[0]))
		return;
		tfa_data.primary=mfa_deatils.indexOf(tfa_data.modes[0]);
	}*/
	
//dont delete used for future change

	
	
	$(".option_grid").removeClass("primary_mode");
	$(".child_flex").removeClass("column_order");
	$(".mfa_mode_status_butt .primary_indicator").hide();
	$(".mfa_mode_status_butt .secondary_indicator").show();
	$(".mfa_mode_status_butt .disbaled_indicator").hide();
	$(".option_grid").removeClass("disabled_option_grid")
	$(".option_grid").css("order","6");
	if(tfa_data.modes.indexOf("devices")>-1)
	{
		$("#oneauth_mode_info").hide();
		$("#oneauth_mode_preference").show();
//			mode details		 TOUCH ID = 2; QR = 3; PUSH = 4; TOTP = 5; FACEID = 7; oneauth =11 ; nio metirc =12
		if(tfa_data.primary==7	||tfa_data.primary==2	||tfa_data.primary==3	||tfa_data.primary==4	||tfa_data.primary==5	||tfa_data.primary==11	||tfa_data.primary==12)
		{
			$("#mfa_oneauth_mode").addClass("primary_mode");
			$("#"+$("#mfa_oneauth_mode").parent().attr("id")).addClass("column_order");
			$("#oneauth_mode_preference .mfa_mode_status_butt .primary_indicator").show();
			$("#oneauth_mode_preference .mfa_mode_status_butt .secondary_indicator").hide();
			$("#oneauth_mode_preference  .mfa_mode_status_butt .disbaled_indicator").hide();
			$("#mfa_oneauth_mode").css("order",-1);
		}
		else
		{
			$("#mfa_oneauth_mode").css("order",tfa_data.modes.indexOf("devices")+1);
		}
		
		var devices_list=tfa_data.devices.device;
		var primay_mode=undefined;
		$(".MFAdevice_BKUP").html("");
	    $(".MFAdevice_primary").html("");
	    var sec_count=0;
	    $("#view_only_devices").hide();
	    for(j=0;j<devices_list.length;j++)
		{
	    	var mfa_device_format = $("#empty_MFAphone_format").html();
			if(devices_list[j].is_primary)
			{
				$("#all_tfa_devices .MFAdevice_primary").html(mfa_device_format);
				$("#all_tfa_devices .MFAdevice_primary #mfa_phoneDetails").attr("id","MFAdevice_primary");
				$("#MFAdevice_primary").attr("onclick","Mfa_mobile_ui_specific('MFAdevice_primary','"+devices_list[j].device_id+"')");
				if(devices_list[j].device_name!=devices_list[j].device_info)
				{
					$("#MFAdevice_primary .emailaddress_text").html(devices_list[j].device_info+" - "+devices_list[j].device_name);
				}
				else
				{
					$("#MFAdevice_primary .emailaddress_text").html(devices_list[j].device_name);
				}
				$("#MFAdevice_primary #mfa_ph_time").html(devices_list[j].created_time_elapsed);
				$("#MFAdevice_primary .primary_dot").html(devices_list[j].preference_name);
				$("#MFAdevice_primary .mobile_dp")[0].className="one_auth_list_icon";
				$("#MFAdevice_primary .sec_indicator").remove();
				$("#MFAdevice_primary .phnum_hover_show #icon-delete").attr("id","device-delete_primary");
				$("#MFAdevice_primary .phnum_hover_show #device-delete_primary").attr("onclick","remove_mfa_device('"+devices_list[j].device_id+"','MFAdevice_primary');"); 
				$("#MFAdevice_primary .phnum_hover_show #icon-primary").remove(); 
				sec_count++;
				primay_mode=devices_list[j].pref_option;
			}
			else
			{
				sec_count++;
				$("#all_tfa_devices .MFAdevice_BKUP").append(mfa_device_format);
				$("#all_tfa_devices .MFAdevice_BKUP #mfa_phoneDetails").attr("id","mfa_deviceDetails"+sec_count);
				$("#mfa_deviceDetails"+sec_count).attr("onclick","Mfa_mobile_ui_specific('mfa_deviceDetails"+sec_count+"','"+devices_list[j].device_id+"')");
				
				$(".MFAdevice_BKUP #mfa_deviceDetails"+sec_count+" .mobile_dp").addClass(color_classes[gen_random_value()]);
				
				if(devices_list[j].device_name!=devices_list[j].device_info)
				{
					$(".MFAdevice_BKUP #mfa_deviceDetails"+sec_count+" .emailaddress_text").html(devices_list[j].device_info+" - "+devices_list[j].device_name);
				}
				else
				{
					$(".MFAdevice_BKUP #mfa_deviceDetails"+sec_count+" .emailaddress_text").html(devices_list[j].device_name);
				}
				
				
				$(".MFAdevice_BKUP #mfa_deviceDetails"+sec_count+" #mfa_ph_time").html(devices_list[j].created_time_elapsed);
				$(".MFAdevice_BKUP #mfa_deviceDetails"+sec_count+" .primary_dot").html(devices_list[j].preference_name);
				$(".MFAdevice_BKUP #mfa_deviceDetails"+sec_count+" .pri_indicator").remove();
				$(".MFAdevice_BKUP #mfa_deviceDetails"+sec_count+" .mobile_dp")[0].className="one_auth_list_icon";
				if(sec_count > 1)
	          	{
	          		$("#mfa_deviceDetails"+sec_count).addClass("extra_phonenumbers"); 
	          	}
				
				$(".MFAdevice_BKUP #mfa_deviceDetails"+sec_count+" .phnum_hover_show #icon-delete").attr("id","device-delete"+sec_count); 
				$(".MFAdevice_BKUP #mfa_deviceDetails"+sec_count+" .phnum_hover_show #icon-primary").attr("id","device-primary"+sec_count); 
				
				$(".MFAdevice_BKUP #mfa_deviceDetails"+sec_count+" .phnum_hover_show #device-delete"+sec_count).attr("onclick","remove_mfa_device('"+devices_list[j].device_id+"','mfa_deviceDetails"+sec_count+"');"); 
				$(".MFAdevice_BKUP #mfa_deviceDetails"+sec_count+" .phnum_hover_show #device-primary"+sec_count).attr("onclick","make_device_primary('"+devices_list[j].device_id+"','mfa_deviceDetails"+sec_count+"');"); 

			}
		}
	    if(primay_mode==undefined)
	    {
			$("#oneauth_mode_preference #one_auth_primary_toggle").attr("onclick","MFA_changeMODE_confirm('"+mfa_mode_oneAuth+"',"+tfa_data.devices.device[0].pref_option+");");
			mfa_deatils[tfa_data.devices.device[0].pref_option]="devices";
	    }
	    else
	    {
	    	$("#oneauth_mode_preference #one_auth_primary_toggle").attr("onclick","MFA_changeMODE_confirm('"+mfa_mode_oneAuth+"','"+primay_mode+"');");
	    	mfa_deatils[primay_mode]="devices";
	    }
	    if(sec_count==1)
	    {
	    	$("#mfa_oneauth_mode .pri_sec_indicator").hide();
	    }
	    else
	    {
	    	$("#MFAdevice_primary .phnum_hover_show #device-delete_primary").remove();
	    }
	    if(sec_count>1)
	    {
	    	$("#view_only_devices").show();
	    	if(primay_mode!=undefined)//no primary all are secondary devices
	    	{
	    		$(".MFAdevice_BKUP .secondary").addClass("extra_phonenumbers");
	    	}
	    }
	    if(!canSetup_mfa_device)
		{
			$("#oneauth_mode_preference .mfa_mode_status_butt div").hide();
			$("#oneauth_mode_preference  .mfa_mode_status_butt .disbaled_indicator").show();
			$("#mfa_oneauth_mode").addClass("disabled_option_grid");
		}
	    if(isMobile)
		{
	    	$("#all_tfa_devices .phnum_hover_show").addClass("hide");
		}
	}
	else if(!canSetup_mfa_device) 
	{
		$("#mfa_oneauth_mode").remove();
	}
	
	
	if(tfa_data.modes.indexOf("otp")>-1)
	{
		mfa_deatils[0]="otp";
		$("#sms_mode_info").hide();
		$("#sms_mode_preference").show();
		var primay_mob_present=false;
		if(tfa_data.primary==0)
		{
			$("#mfa_sms_mode").addClass("primary_mode");
			$("#"+$("#mfa_sms_mode").parent().attr("id")).addClass("column_order");
			$("#sms_mode_preference .mfa_mode_status_butt .primary_indicator").show();
			$("#sms_mode_preference .mfa_mode_status_butt .secondary_indicator").hide();
			$("#sms_mode_preference .mfa_mode_status_butt .disbaled_indicator").hide();
			$("#mfa_sms_mode").css("order",-1);
		}
		else
		{
			$("#mfa_sms_mode").css("order",tfa_data.modes.indexOf("otp")+1);
		}
		
		var mobile_list=tfa_data.otp.mobile;
		
		$(".MFAnumber_BKUP").html("");
	    $(".MFAnumber_primary").html("");
	    var sec_count=0;
	    for(j=0;j<mobile_list.length;j++)
		{
	    	var mfa_phone_format = $("#empty_MFAphone_format").html();
			if(mobile_list[j].is_primary)
			{
				$(".MFAnumber_primary").html(mfa_phone_format);
				$(".MFAnumber_primary #mfa_phoneDetails").attr("id","mfa_num_primary");
				$("#mfa_num_primary").attr("onclick","Mfa_mobile_ui_specific('mfa_num_primary','"+mobile_list[j].e_mobile+"')");
				
				$("#mfa_num_primary .emailaddress_text").html("+"+mobile_list[j].r_mobile);
				$("#mfa_num_primary #mfa_ph_time").html(mobile_list[j].created_time_elapsed);
				$("#mfa_num_primary .primary_dot").remove();
				$("#mfa_num_primary #mfa_primary_title").css("display","none");
				$("#mfa_num_primary .sec_indicator").remove();
				$("#mfa_num_primary .phnum_hover_show #icon-delete").attr("id","mob-delete_primary");
				$("#mfa_num_primary .phnum_hover_show #mob-delete_primary").attr("onclick","remove_mfa_backup('"+mobile_list[j].e_mobile+"','mfa_num_primary');"); 
				$("#mfa_num_primary .phnum_hover_show #icon-primary").remove(); 
				sec_count++;
				primay_mob_present=true;
			}
			else
			{
				sec_count++;
				$(".MFAnumber_BKUP").append(mfa_phone_format);
				$(".MFAnumber_BKUP #mfa_phoneDetails").attr("id","mfa_phoneDetails"+sec_count);
				$("#mfa_phoneDetails"+sec_count).attr("onclick","Mfa_mobile_ui_specific('mfa_phoneDetails"+sec_count+"','"+mobile_list[j].e_mobile+"')");
				
				$(".MFAnumber_BKUP #mfa_phoneDetails"+sec_count+" .mobile_dp").addClass(color_classes[gen_random_value()]);
				$(".MFAnumber_BKUP #mfa_phoneDetails"+sec_count+" .emailaddress_text").html("+"+mobile_list[j].r_mobile);
				$(".MFAnumber_BKUP #mfa_phoneDetails"+sec_count+" #mfa_ph_time").html(mobile_list[j].created_time_elapsed);
				$(".MFAnumber_BKUP #mfa_phoneDetails"+sec_count+" .primary_dot").remove();
				$(".MFAnumber_BKUP #mfa_phoneDetails"+sec_count+" .pri_indicator").remove();
				$(".MFAnumber_BKUP #mfa_phoneDetails"+sec_count+" #mfa_primary_title").remove();
				if(sec_count > 1)
	          	{
	          		$("#mfa_phoneDetails"+sec_count).addClass("extra_phonenumbers"); 
	          	}
				$(".MFAnumber_BKUP #mfa_phoneDetails"+sec_count+" .phnum_hover_show #icon-delete").attr("id","mob-delete"+sec_count); 
				$(".MFAnumber_BKUP #mfa_phoneDetails"+sec_count+" .phnum_hover_show #icon-primary").attr("id","mob-primary"+sec_count);
				
				$(".MFAnumber_BKUP #mfa_phoneDetails"+sec_count+" .phnum_hover_show #mob-delete"+sec_count).attr("onclick","remove_mfa_backup('"+mobile_list[j].e_mobile+"','mfa_phoneDetails"+sec_count+"');"); 
				$(".MFAnumber_BKUP #mfa_phoneDetails"+sec_count+" .phnum_hover_show #mob-primary"+sec_count).attr("onclick","make_primary_backup('"+mobile_list[j].e_mobile+"','mfa_phoneDetails"+sec_count+"');"); 

			}
		}
	    $("#add_more_backup_num").hide();
    	$("#tfa_phone_add_view_more").hide();
    	$("#show_backup_num_diabledMFA").hide();
	    if(sec_count==1)
	    {
	    	$("#mfa_sms_mode .pri_sec_indicator").hide();
	    }
	    else
	    {
	    	$("#mfa_num_primary .phnum_hover_show #mob-delete_primary").remove();
	    }
	    if(sec_count>1)
	    {
	    	$("#tfa_phone_add_view_more").show();
	    	if(primay_mob_present)
	    	{
	    		$(".MFAnumber_BKUP .secondary").addClass("extra_phonenumbers");
	    	}
	    }
	    else
	    {
	    	$("#add_more_backup_num").show();
	    }
	    if(!canSetupSMS)
		{
			$("#sms_mode_preference .mfa_mode_status_butt div").hide();
			$("#sms_mode_preference  .mfa_mode_status_butt .disbaled_indicator").show();
			$("#mfa_sms_mode").addClass("disabled_option_grid");
			$("#add_more_backup_num").hide();
	    	$("#tfa_phone_add_view_more").hide();
	    	if(sec_count>1)
	    	{
	    		$("#show_backup_num_diabledMFA").show();
	    	}
		}
	    if(isMobile)
		{
	    	$("#all_tfa_numbers .phnum_hover_show").addClass("hide");
		}
	}
	else if(!canSetupSMS) 
	{
		$("#mfa_sms_mode").remove();
	}
	
	if(tfa_data.modes.indexOf("totp")>-1)
	{
		mfa_deatils[1]="totp";
		$("#sms_app_auth_info").hide();
		$("#app_auth_mode_preference").show();
		if(tfa_data.primary==1)
		{
			$("#mfa_app_auth_mode").addClass("primary_mode");
			$("#"+$("#mfa_app_auth_mode").parent().attr("id")).addClass("column_order");
			$("#app_auth_mode_preference .mfa_mode_status_butt .primary_indicator").show();
			$("#app_auth_mode_preference .mfa_mode_status_butt .secondary_indicator").hide();
			$("#app_auth_mode_preference  .mfa_mode_status_butt .disbaled_indicator").hide();
			$("#mfa_app_auth_mode").css("order",-1);
		}
		else
		{
			$("#mfa_app_auth_mode").css("order",tfa_data.modes.indexOf("totp")+1);
		}
		$("#configure_authmode").show();
		$("#change_configure_Gauthmode").show();
		if(!canSetupGAuth)
		{
			$("#app_auth_mode_preference .mfa_mode_status_butt div").hide();
			$("#app_auth_mode_preference  .mfa_mode_status_butt .disbaled_indicator").show();
			$("#mfa_app_auth_mode").addClass("disabled_option_grid");
			$("#configure_authmode").hide();
			$("#change_configure_Gauthmode").hide();
		}
		$("#mfa_auth_detils .emailaddress_addredtime").html(tfa_data.totp.created_time_elapsed);
	}
	else if(!canSetupGAuth) 
	{
		$("#mfa_app_auth_mode").remove();
	}
	
	if(tfa_data.modes.indexOf("yubikey")>-1)
	{
		mfa_deatils[8]="yubikey";
		$("#yubikey_mode_info").hide();
		$("#yubikey_mode_preference").show();
		if(tfa_data.primary==8)
		{
			$("#mfa_yubikey_mode").addClass("primary_mode");
			$("#"+$("#mfa_yubikey_mode").parent().attr("id")).addClass("column_order");
			$("#yubikey_mode_preference .mfa_mode_status_butt .primary_indicator").show();
			$("#yubikey_mode_preference .mfa_mode_status_butt .secondary_indicator").hide();
			$("#yubikey_mode_preference  .mfa_mode_status_butt .disbaled_indicator").hide();
			$("#mfa_yubikey_mode").css("order",-1);
		}
		else
		{
			$("#mfa_yubikey_mode").css("order",tfa_data.modes.indexOf("yubikey")+1);
		}
		$("#configure_yubikey_mode").show();
		$("#goto_yubikey_mode").show();
		if(!canSetupyubikey)
		{
			$("#yubikey_mode_preference .mfa_mode_status_butt div").hide();
			$("#yubikey_mode_preference  .mfa_mode_status_butt .disbaled_indicator").show();
			$("#mfa_yubikey_mode").addClass("disabled_option_grid");
			$("#configure_yubikey_mode").hide();
			$("#goto_yubikey_mode").hide();
		}
		
		$("#mfa_yubikey_detils .emailaddress_text").html(tfa_data.yubikey.yubiname);//No I18N
		$("#mfa_yubikey_detils .emailaddress_addredtime").html(tfa_data.yubikey.created_time_elapsed);
		$("#mfa_yubikey_hover #icon-delete").attr("onclick","MFA_delete_confirm('"+mfa_yubikey_mode+"','8','"+tfa_data.yubikey.yubiname+"');"); 
	}
	else if(!canSetupyubikey) 
	{
		$("#mfa_yubikey_mode").remove();
	}
	
	if(tfa_data.modes.indexOf("exostar")>-1)
	{
		mfa_deatils[6]="exostar";
		$("#exo_mode_info").hide();
		$("#exo_mode_preference").show();
		if(tfa_data.primary==6)
		{
			$("#mfa_exo_mode").addClass("primary_mode");
			$("#"+$("#mfa_exo_mode").parent().attr("id")).addClass("column_order");
			$("#exo_mode_preference .mfa_mode_status_butt .primary_indicator").show();
			$("#exo_mode_preference .mfa_mode_status_butt .secondary_indicator").hide();
			$("#exo_mode_preference  .mfa_mode_status_butt .disbaled_indicator").hide();
			$("#mfa_exo_mode").css("order",-1);
		}
		else
		{
			$("#mfa_exo_mode").css("order",tfa_data.modes.indexOf("yubikey")+1);
		}
		$("#configure_exo_mode").show();
		$("#goto_exo_mode").show();
		if(!canSetupExo)
		{
			$("#exo_mode_preference .mfa_mode_status_butt div").hide();
			$("#exo_mode_preference  .mfa_mode_status_butt .disbaled_indicator").show();
			$("#mfa_exo_mode").addClass("disabled_option_grid");
			$("#configure_exo_mode").hide();
			$("#goto_exo_mode").hide();
		}
		
//			$("#mfa_exo_detils .emailaddress_text").html("devicename");//No I18N
		$("#mfa_exo_detils .emailaddress_addredtime").html(tfa_data.exostar.created_time_elapsed);
	}
	else if(!canSetupExo) 
	{
		$("#mfa_exo_mode").remove();
	}
		
	
	if(tfa_data.modes.length==1)
	{
		$(".primary_mode .primary_indicator").hide();//hiding the primary indicator when only one mode is present
	}
	if((tfa_data.primary=="-1"	||	tfa_data.primary==undefined	||	mfa_deatils[tfa_data.primary]==undefined)	&&	 tfa_data.is_mfa_activated==true	)//check if primary mode is defined in the list of configured modes
	{
		setTimeout(function () {
			show_CHprimary_notice();
	    }, 210);
	}
	
	
	
	
//	var Policies =tfa_data.Policies;
//	var tfa = tfa_data.TFA;
	
	
	if(!jQuery.isEmptyObject(tfa_data.modes) 		||		tfa_data.is_mfa_activated)//tfa is deactivated and tfa data doesnt exist show setup
	{
		if(tfa_data.is_update_allowed)
		{
			$("#tfa_status").show();
		}
		if(tfa_data.is_mfa_activated)
		{
			$("#tfa_active").prop("checked","checked");
			
			$("#recovery_space").show();
			$("#tfa_bk_new_space").show();
		}
		else
		{
			$("#tfa_active").prop("checked",false);
		}
	}
	else
	{
		$("#tfa_status").hide();
	}
	
	if(tfa_data.is_mfa_activated)	
	{
		$(".TFAPrefrences_menu").css("display","block");
		$("#trusted_browser_space").show(); //display trsuted browsers space
		$("#trusted_browsers_space").show();
		$("#recovery_space").show();
		if(tfa_data.bc_cr_time.allow_codes		&&		tfa_data.bc_cr_time.created_time_elapsed!=undefined)
		{
			$('#tfa_bk_new_space #tfa_bk_time span').html(tfa_data.bc_cr_time.created_time_elapsed);
			$('#tfa_bk_new_space #tfa_bk_description').hide();
			$('#tfa_bk_new_space #tfa_bk_time').css("display","block");
		}
		else if(!tfa_data.bc_cr_time.allow_codes)
		{
			$("#recovery_space").hide();
			$("#multiTFAsubmenu #recovery").hide();
		}
		else
		{
			$('#tfa_bk_new_space #tfa_bk_description').show();
			$('#tfa_bk_new_space #tfa_bk_time').hide();
			if(mfa_deatils[tfa_data.primary]!=undefined		&&	display_bkup_popup)
			{
				setTimeout(function () {
					MFA_backup_notice();
			    }, 210);
			}
			
		}
	}
	else
	{
		$(".TFAPrefrences_menu").hide();
		$("#trusted_browser_space").hide(); //hide trusted browsers space
		$("#recovery_space").hide();
	}
	
	if(tfa_data.trusted_browsers!=undefined	&&	!jQuery.isEmptyObject(tfa_data.trusted_browsers))
	{
		tooltip_Des(".Field_session .asession_browser");//No I18N
		tooltip_Des(".Field_session .asession_os");//No I18N
		var trusted_browsers=tfa_data.trusted_browsers;
		var sessions=timeSorting(trusted_browsers);
		$(".tfa_trusted_browsers").html("");
		var count =0;
		for(iter=0;iter<Object.keys(sessions).length;iter++)
		{
			count++;
			var current_session=trusted_browsers[sessions[iter]];
			session_format = $("#empty_sessions_format").html();
			$(".tfa_trusted_browsers").append(session_format);
			
			$(".tfa_trusted_browsers #trusted_browser").attr("id","trusted_browser"+count);
			$(".tfa_trusted_browsers #trusted_browser_info").attr("id","trusted_browser_info"+count);
	
			$(".tfa_trusted_browsers #trusted_browser_info"+count+" #current_session_logout").attr("onclick","deleteMFATicket('"+current_session.session_ticket+"','trusted_browser"+count+"');");
			if(count > 3)
			{
				$(".tfa_trusted_browsers #trusted_browser"+count).addClass("activesession_entry_hidden");  
			}
			var device_class="device_"+(current_session.device_info.device_img).toLowerCase().replace(/\s/g, '');//No I18N
			$("#trusted_browser"+count).attr("onclick","show_selected_MFAbrowserinfo("+count+",'"+device_class+"');");
			$("#trusted_browser"+count+" .device_pic").addClass(device_class);
			$("#trusted_browser"+count+" .device_name").html(current_session.device_info.device_name);
			$("#trusted_browser"+count+" .device_time").html(current_session.created_time_elapsed);
			var os_class=(current_session.device_info.os_img).toLowerCase().replace(/\s/g, '');
			$("#trusted_browser"+count+" .activesession_entry_info .asession_os").addClass("os_"+os_class);
			if(current_session.device_info.version==undefined)
			{
				$("#trusted_browser"+count+" .activesession_entry_info .asession_os").attr("title",current_session.device_info.os_name);
				$("#trusted_browser_info"+count+" #pop_up_os").append("<span>"+current_session.device_info.os_name+"</span>");
			}
			else
			{
				$("#trusted_browser"+count+" .activesession_entry_info .asession_os").attr("title",current_session.device_info.os_name+" "+current_session.device_info.version);
				$("#trusted_browser_info"+count+" #pop_up_os").append("<span>"+current_session.device_info.os_name+" "+current_session.device_info.version+"</span>");

			}
			var browser_class=(current_session.browser_info.browser_image).toLowerCase().replace(/\s/g, '');
			$("#trusted_browser"+count+" .activesession_entry_info .asession_browser").addClass("browser_"+browser_class);
			$("#trusted_browser"+count+" .activesession_entry_info .asession_browser").attr("title",current_session.browser_info.browser_name+" "+current_session.browser_info.version);
			$("#trusted_browser"+count+" .activesession_entry_info .asession_ip").html(current_session.ip_address);

			if(current_session.location!=undefined)
			{
				$("#trusted_browser"+count+" .asession_location").removeClass("location_unavail");
				$("#trusted_browser"+count+" .asession_location").html(current_session.location);
				$("#trusted_browser_info"+count+" #pop_up_location").removeClass("unavail");
				$("#trusted_browser_info"+count+" #pop_up_location").html(current_session.location);
			}
			$("#trusted_browser_info"+count+" #pop_up_time").html(current_session.created_date);
			$("#trusted_browser_info"+count+" #pop_up_os .asession_os_popup").addClass("minios_"+os_class);
			$("#trusted_browser_info"+count+" #pop_up_browser .asession_browser_popup").addClass("minibrowser_"+browser_class);
			$("#trusted_browser_info"+count+" #pop_up_browser").append("<span>"+current_session.browser_info.browser_name+" "+current_session.browser_info.version+"</span>");
			
		}
		sessiontipSet(".Field_session .asession_browser");//No I18N
		sessiontipSet(".Field_session .asession_os");//No I18N
		if(count>3)//more THAN 3
		{
			$("#sessions_showall").show();	
		}
		else
		{
			$("#sessions_showall").hide();	
		}
		$("#tfa_empty_trustedbrowser").hide();
		$(".tfa_trusted_browsers").show();
	}
	else
	{
		$("#tfa_empty_trustedbrowser").show();
		$(".tfa_trusted_browsers").hide();
	}
	if(!isMobile)
	{
		tooltipSet(".action_icon");//No I18N
	}
	
	closeNotification();//closing the MFA reminder in the notifications
	
	
}



//send one auth link


function open_android_location()
{
	window.open(tfa_android_Link, '_blank');
}

function open_IOS_location()
{
	window.open(tfa_ios_Link, '_blank');
}


function send_link(num,Cno)
{
	if(!num)
	{
		if(!isPhoneNumber($("#tfa_send_link_old").val()))
		{
			showErrorMessage(err_enter_valid_mobile);
			return;
		}
		num=$("#tfa_send_link_old").val();
	}
	if(!validateMobile(num)) 
	{
		showErrorMessage(err_enter_valid_mobile);
		return;	
	} 
	if(!Cno)
	{
		Cno=$("#tfa_link_code").val();
	}
	
	var parms=
	{
		"mobile":num,//No I18N
		"countrycode":Cno//No I18N
	};
	
	var payload = TfaOneAuthSMS.create(parms);
	payload.POST("self","self").then(function(resp)	//No I18N
	{
		SuccessMsg(getErrorMessage(resp));
	},
	function(resp)
	{
		showErrorMessage(getErrorMessage(resp));
	});
	

}


//activate and deactive mfa temp

function change_tfa_status()
{
	if(tfa_data.is_update_allowed)
	{
		if(!$("#tfa_active").prop("checked"))
		{
			$("#tfa_is_activated").show();
			$("#tfa_not_activated").hide();
			$("#tfa_activate").hide();
			$("#tfa_deactivate").css("display","inline-block");
		}
		else
		{
			$("#tfa_is_activated").hide();
			$("#tfa_not_activated").show();
			$("#tfa_deactivate").hide();
	//		re_enableTFA();
			$("#tfa_activate").css("display","inline-block");
		}
		$("#delete_tfa_popup").show(0,function(){
			$("#delete_tfa_popup button:visible").focus();
			$("#delete_tfa_popup").addClass("pop_anim");
		});
		popup_blurHandler('6','.5');
		closePopup(close_delete_tfa_popup,"delete_tfa_popup"); //No i18N
	}
}


function close_delete_tfa_popup(check)
{
	popupBlurHide('#delete_tfa_popup',function(){	//No i18N
		$("#tfa_activate").hide();
		$("#tfa_deactivate").hide();	
	});
	if(!check)
	{
		if(!$("#tfa_active").prop("checked"))
		{
			$("#tfa_active").prop("checked","checked");
		}
		else
		{
			$("#tfa_active").prop("checked",false);
		}
	}
}


function disableTFA()
{

	if(tfa_data.is_update_allowed)
	{	var parms=
		{
			"activate":false//No I18N
		};
		tfa_status_change(parms);
	}
		
}
	
function re_enableTFA()
{
	if(tfa_data.is_update_allowed)
	{
		var parms=
		{
			"activate":true//No I18N
		};
		tfa_status_change(parms);
	}
}

function tfa_status_change(parms)
{
	if(tfa_data.is_update_allowed)
	{
		var payload = MfaFetchOBJ.create(parms);
		payload.PUT("self","self","mode").then(function(resp)	//No I18N
		{
			SuccessMsg(getErrorMessage(resp));
			tfa_data.is_mfa_activated=parms.activate;
			tfa_data.trusted_browsers={};
			close_delete_tfa_popup(true);
			load_mfa("true");
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
    return false;
}



//Delete Mode

function MFA_delete_confirm(mode_name,mode,name)
{
	show_confirm(formatMessage(mfa_delete_mode, mode_name),
	    function() 
	    {
			if(mode==8)
			{
				delete_yubikey(name);
			}
			else if(mode==1)
			{
				delete_totp();
			}
			else if(mode==6)
			{
				delete_exo();
			}
//			else
//			{
//				MFA_delete_mode(mode);
//			}
		},
	    function() 
	    {
	    	return false;
	    }
	);
}


function close_tfa_CHprimary_notice()
{
	popupBlurHide('#CHprimary_NOTICE');//No I18N
}


//backup codes function

function show_backup_notice()
{
	popup_blurHandler('6','.5');
	$("#backupcodes_NOTICE").show(0,function(){
		$("#backupcodes_NOTICE").addClass("pop_anim");
	});
}

function close_tfa_backupcode_NOTICE()
{
	popupBlurHide('#backupcodes_NOTICE');//No I18N
}


function show_backupcodes()
{
	var payload = TfaBackupCodes.create();
	disabledButton($("#backupcodes_tfa"));
	payload.PUT("self","self").then(function(resp)	//No I18N
	{
		if($("#backupcodes_NOTICE").is(":visible") )
		{
			$("#backupcodes_NOTICE").hide()
		}
		
		show_backup(resp.backupcodes);
		removeButtonDisable($("#backupcodes_tfa"));
		$("#backupcodes_tfa").focus();
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
		removeButtonDisable($("#backupcodes_tfa"));	
	});
	control_Enter("a");//No I18N
	closePopup(close_tfa_backupcode,"backupcodes_tfa");//No I18N
}

function show_backup(obj)
{
	var codes = obj.recovery_code;
	var recoverycodes = codes.split(":");
	var createdtime = obj.created_date;
	var res ="<ol class='bkcodes'>"; //No I18N
	var recCodesForPrint = "";
	for(idx in recoverycodes)
	{
		var recCode = recoverycodes[idx];
		if(recCode != ""){
			res += "<li><b><div class='bkcodes_cell'>"+recCode.substring(0, 4)+"</div><div class='bkcodes_cell'>"+recCode.substring(4, 8)+"</div><div class='bkcodes_cell'>"+recCode.substring(8) + "</div></b></li>"; //No I18N
			recCodesForPrint += recCode + ":";
		}
	}
	res += "</ol>";
	recCodesForPrint = recCodesForPrint.substring(0, recCodesForPrint.length -1); // Remove last ":"
	de('bk_codes').innerHTML = res; //No i18N
	$("#printcodesbutton").attr('onclick','printDoc(\''+obj.user+'\',\''+recCodesForPrint+'\');')
	$('#createdtime').html(createdtime); //No i18N
	if(obj.created_time_elapsed)
	{
		$('#tfa_bk_new_space #tfa_bk_time span').html(obj.created_time_elapsed); //No i18N
		$('#tfa_bk_new_space #tfa_bk_description').hide();
		$('#tfa_bk_new_space #tfa_bk_time').show();
		tfa_data.bc_cr_time.created_date=obj.created_date
		tfa_data.bc_cr_time.created_time=obj.created_time
		tfa_data.bc_cr_time.created_time_elapsed=obj.created_time_elapsed
	}
	popup_blurHandler('6','.5');
	$("#backupcodes_tfa").show(0,function(){
		$("#backupcodes_tfa").addClass("pop_anim");
	});
}

function printDoc(userName,codes) 
{
	var recoverycodes = codes.split(":");
	saved_backup_codes=true;
	var html = "<body><div style='font-size: 20px;'>" + err_backup_verification_codes + "&nbsp;-&nbsp;"+ userName + "</div>";
	html += "<div style='background-color: #EEECED;border: 1px solid #E1E1E1;padding: 4px;width: 220px;margin-top:10px;'>";
	html +="<ol style='line-height:25px;'>"; //No I18N
	if(recoverycodes !== null) 
	{
		for(idx in recoverycodes) 
		{
			var recCode = recoverycodes[idx];
			if(recCode !== "")
			{
				html += "<li><b><span style='margin-left:5px'>"+recCode.substring(0, 4)+"</span><span style='margin-left:5px'>"+recCode.substring(4, 8)+"</span><span style='margin-left:5px'>"+recCode.substring(8) + "</span></b></li>"; //No I18N
			}
		}		
	}
	html += "</ol></div>";
	html += "<div style='margin-top:20px;font-size:12px;'>" + err_backup_recommend_notes + "</div>"; 
	var printWindow = window.open('printdoc.html', saveTxtParams.printcodes.tagetWindowName, 'letf=0,top=0,width=400,height=400,toolbar=0,scrollbars=0,status=0');
	printWindow.document.write(html);
	printWindow.document.close();
	printWindow.focus();
	printWindow.print();
	
	var payload = tfabackup_print.create();
	payload.PUT("self","self").then(function(resp)	//No I18N
	{
		SuccessMsg(getErrorMessage(resp));
		close_tfa_backupcode();
		removeButtonDisable($("#backupcodes_tfa"));
		$("#backupcodes_tfa").focus();
	},
	function(resp)
	{
		showErrorMessage(getErrorMessage(resp));
		removeButtonDisable($("#backupcodes_tfa"));	
	});
}

var saveTxtParams = 
{
	savetxt : 
	{
		option : 1,
		tagetWindowName : "savetxtwindow" //No I18N 
	},
	printcodes : 
	{
		option : 2,
		tagetWindowName : "printwindow" //No I18N
	},
	sendemail : 
	{
		option : 3,
		tagetWindowName : "sendemailwindow", //No I18N
		validate : function() 
		{
			return validateEmailField();
		}
	}
};

function saveAsText() 
{
	saveCodes('savetxt'); //No I18N
}



function store_backupcodes(preference,parms)
{
	if(parms!=undefined)
	{
		var payload = TfaBackupCodes.create(parms);
	}
	else
	{
		var payload = TfaBackupCodes.create();
	}
	var pref=$('#tfa_method').val();
	disabledButton($("#backupcodes_tfa"));
//	var pref_val =saveTxtParams[preference].option;
	payload.PUT("self","self",pref,preference).then(function(resp)	//No I18N
	{
		SuccessMsg(getErrorMessage(resp));
		close_send_bkcode_emailpopup();
		removeButtonDisable($("#backupcodes_tfa"));
		$("#backupcodes_tfa").focus();
	},
	function(resp)
	{
		showErrorMessage(getErrorMessage(resp));
		removeButtonDisable($("#backupcodes_tfa"));	
	});
}



function saveCodes(preference) 
{
	saved_backup_codes=true;
	var csrf = csrfParam.split("=");
	var csrfCkName = csrf[0];
	var csrfCkValue = csrf[1];
 	if(csrfCkName !== null && csrfCkValue !== null && saveTxtParams[preference] !== null) 
 	{
 		var payload = tfabackup_download.create();
 		payload.getURI("self","self","self" ).GETS(); //No i18N
	}
}

function send_email_code()
{
	$("#backupcodes_tfa").hide();
	$("#backupcodes_tfa").removeClass("pop_anim");
	$("#backupcodes_tfa").fadeOut(200,function(){
		$("#send_bkcode_email").show(0,function(){
			$("#send_bkcode_email").addClass("pop_anim");
		});
	});
	closePopup(close_send_bkcode_emailpopup,"send_bkcode_email"); //No i18N
	$("#send_backup_em").focus();
}

function close_tfa_backupcode()
{
		popupBlurHide('#backupcodes_tfa',function(){	//No i18N
			$("a").unbind();
		});
}

function close_send_bkcode_emailpopup()
{
	popupBlurHide('#send_bkcode_email');	//No i18N	
}

function sendBackupCodesEmail() 
{
	remove_error();
	var email_id = $('#send_backup_em').val().trim();
	if(!isEmailId(email_id)) 
	{
		$("#tfa_email_space").append( '<div class="field_error">'+err_validemail+'</div>' );
		return;
	}
	
	var pass = $('#send_backup_pass').val().trim();
	if(pass=="")
	{
		$("#tfa_email_space_pass").append( '<div class="field_error">'+err_validemail+'</div>' );
		return;
	}
	
	parms=
	{
		"email_id":email_id,//No I18N
		"pass":pass//No I18N
	}
	store_backupcodes("sendemail",parms);//No I18N
	
}








//Change mode

function MFA_changeMODE_confirm(mode_name,mode)
{
	show_confirm(formatMessage(mfa_change_primary, mode_name),
	    function() 
	    {
			change_mode(mode);
		},
	    function() 
	    {
	    	return false;
	    }
	);
}


function change_mode(arg)
{
	var parms=
	{
		"makeprimary":true,//No I18N
		"mode":arg//No I18N
	};

	var payload = MfaFetchOBJ.create(parms);
	
	payload.PUT("self","self","mode").then(function(resp)	//No I18N
	{
		SuccessMsg(getErrorMessage(resp));
		tfa_data.primary=arg;
		load_mfa("true");
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

//Trusted Browsers

function closeview_selected_browser_view()
{
	popupBlurHide('#trustedbrowser_pop');	//No i18N
}

function show_selected_MFAbrowserinfo(id,device)
{
		$("#trustedbrowser_pop .device_name").html($("#trusted_browser"+id+" .device_name").html()); //load into popuop
		$("#trustedbrowser_pop .device_time").html($("#trusted_browser"+id+" .device_time").html()); //load into popuop
		
		$("#trustedbrowser_pop #sessions_current_info").html($("#trusted_browser_info"+id).html()); //load into popuop
		
		$("#trustedbrowser_pop .device_pic").addClass(device)
		
		popup_blurHandler('6','.5');
		$("#trustedbrowser_pop").show(0,function(){
			$("#trustedbrowser_pop").addClass("pop_anim");
		});
		$("#trustedbrowser_pop #current_session_logout").focus();
		closePopup(closeview_selected_browser_view,"trustedbrowser_pop");//No I18N
		control_Enter("#trustedbrowser_pop #current_session_logout");	//No I18N
}


function deleteMFATicket(ticket,id)
{
	var mode=$("#tfa_method").val();
	new URI(TfaBrowser,"self","self","mode",ticket).DELETE().then(function(resp)	//No I18N
			{
				SuccessMsg(getErrorMessage(resp));
				delete tfa_data.trusted_browsers[ticket]
				closeview_selected_browser_view();
				load_mfa();
				if($("#sessions_web_more").is(":visible"))
				{
					if(Object.keys(tfa_data.TFA.trusted_browsers).length>1)
					{
						show_all_MFAtrusted_browsers();
					}
				}
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


function show_all_MFAtrusted_browsers()
{	
	tooltip_Des(".Field_session .asession_browser");//No I18N
	tooltip_Des(".Field_session .asession_os");//No I18N

	$("#view_all_sessions").html($(".tfa_trusted_browsers").html()); //load into popuop
	popup_blurHandler('6','.5');
	
	$("#view_all_sessions .activesession_entry_hidden").show();
	$("#view_all_sessions .authweb_entry").after( "<br />" );
	$("#view_all_sessions .authweb_entry").addClass("viewall_authwebentry");
	$("#view_all_sessions .Field_session").removeAttr("onclick");
	$("#view_all_sessions .info_tab").show();
	//$("#view_all_sessions .asession_action").hide();
	
	
	$("#sessions_web_more").show(0,function(){
		$("#sessions_web_more").addClass("pop_anim")
	});
	
	
	
	$("#view_all_sessions .Field_session").click(function(){
		
		var id=$(this).attr('id');
		$("#view_all_sessions .Field_session").addClass("autoheight");
		$("#view_all_sessions .aw_info").slideUp("fast");
		$("#view_all_sessions .activesession_entry_info").show();
		if($("#view_all_sessions #"+id).hasClass("web_email_specific_popup"))
		{	
			$("#view_all_sessions #"+id+" .aw_info").slideUp("fast",function(){
				$("#view_all_sessions .Field_session").removeClass("autoheight");
				$("#view_all_sessions #"+id).removeClass("web_email_specific_popup");
			});
			$("#view_all_sessions .activesession_entry_info").show();
		}
		else
		{
			
			$("#view_all_sessions .Field_session").removeClass("web_email_specific_popup");
			$("#view_all_sessions .Field_session").removeClass("Active_sessions_showall_hover_primary");
			$("#view_all_sessions #"+id).addClass("web_email_specific_popup");
			$("#view_all_sessions #"+id+" .aw_info").slideDown("fast",function(){
				$("#view_all_sessions .Field_session").removeClass("autoheight");
			});
			$("#view_all_sessions #"+id+" .activesession_entry_info").hide();
			$("#view_all_sessions #"+id+" .primary_btn_check").focus();
		}
		
	});
	sessiontipSet(".Field_session .asession_browser");//No I18N
	sessiontipSet(".Field_session .asession_os");//No I18N
	closePopup(closeview_all_sessions_view,"sessions_web_more");//No I18N
	
	$("#sessions_web_more").focus();
}



//TFA SMS MODE 



function validateMobile(val)
{
	var regex = /^\d{5,14}$/; 
	if(val.search(regex) == -1){
		return false; 
	}
	return true; 
}


function close_add_new_tfa_popup()
{
	popupBlurHide('#add_tfa_backup_popup');	//No i18N	
	remove_error();
	$("#confirm_phone input").val("");
	$("#newphone input").val("");
	$(".blue").unbind();
}

function inititate_sms_setup()
{
	var heading = $("#sms_mode_head .box_head").html();
	var description=$("#sms_mode_head .box_discrption").html();
	set_popupinfo(heading,description);
	

	
	$("#pop_action").html($("#mfa_sms_mode_popups").html()); //load into popuop
//	if($("#newmobile").val()!="")
//	{
//		$("#tfa_number_input").val($("#newmobile").val());
//	}
	if(!isMobile)
	{
		$("#tfa_numbers_code").select2({ 
			width:"auto",//No I18N
			templateResult: phoneSelectformat,
			templateSelection: function (option) {
				selectFlag($(option.element));
				codelengthChecking(option.element,"tfa_number_input");//No i18N
				return $(option.element).attr("data-num");
			},
			escapeMarkup: function (m) {
			    	return m;
		}}).on("select2:open", function(){
			       $(".select2-search__field").attr("placeholder", iam_search_text);//No I18N
		});
		$("#enter_num_tfa_space .select2-selection").append("<span id='selectFlag' class='selectFlag'></span>");
		selectFlag($("#tfa_numbers_code").find("option:selected"));
		$(".select2-selection__rendered").attr("title", "");
		control_Enter(".primary_btn_check");//No I18N
	    $("#tfa_numbers_code").on("select2:close", function (e) { 
			$(e.target).siblings("input").focus();
		});
	}
	else{
		phonecodeChangeForMobile("#tfa_numbers_code");//No I18N
	}
	$("#tfa_method").val(0);
	closePopup(close_popupscreen,"common_popup");//No I18N

	
}


function add_mfa_Mobile()
{
	
	remove_error();
	clearInterval(resend_timer);
	if(de('tfa_number_input').value.trim() == ""	&&	$("#newmobile").val()=="")
	{
		$("#enter_num_tfa_space").append( '<div class="field_error">'+empty_field+'</div>' );
		return;
	}
	var mobVal = de('tfa_number_input').value.trim()!=""?de('tfa_number_input').value.trim():$("#newmobile").val();  //No I18N
	mobVal=mobVal.replace(/[+ \[\]\(\)\-\.\,]/g,'');
	var countryCode = $("#countrycode").val()!=""?$("#countrycode").val():de('tfa_numbers_code').value.trim(); //No I18N
	if(validateMobile(mobVal) != true) 
	{
		$("#enter_num_tfa_space").append( '<div class="field_error">'+err_enter_valid_mobile+'</div>' );
		return;
	}
	$("#newmobile").val(mobVal);
	$("#countrycode").val(countryCode);
	
	disabledButton(".tfa_setup_work_space");//No I18N
	var parms=
	{
		"mobile":mobVal,//No I18N
		"countrycode":countryCode//No I18N
	};


	var payload = TFA_mobileOBJ.create(parms);
	
	payload.POST("self","self","mode").then(function(resp)	//No I18N
	{
		clear_loading();
		SuccessMsg(getErrorMessage(resp));
		$("#add_tfa_backup_popup #tfa_resend").attr("onclick","resend_verify_otp(this,true)");//No I18N 
		$("#enc_mob").val(resp.mfamobile.encryptedMobile);
		verify_mfa_Otpcallback(mobVal);
		removeButtonDisable(".tfa_setup_work_space");//No I18N
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
		clear_loading();
		removeButtonDisable(".tfa_setup_work_space");//No I18N
	});
}


function verify_mfa_Otpcallback(mobVal)
{
	var heading = tfa_verify_smsmode;
	var description=tfa_mob_veri_desc;
	set_popupinfo(heading,description);
	
	$("#tfa_resend").show();
	
	var heading = $("#sms_mode_head .box_head").html();
	var description=formatMessage($("#sms_mode_head .box_verify_discrption").html(),mobVal);
	set_popupinfo(heading,description);
	

	$("#mfa_verify_space_popups #tfa_verfiy_butt").attr("onclick","verify_mfa_mobile()");
	$("#mfa_verify_space_popups #tfa_verify_cancel").attr("onclick","inititate_sms_setup()");
	$("#prefcode").val("");
	
	$("#pop_action").html($("#mfa_verify_space_popups").html()); //load into popuop
	$("#prefcode").focus();
	resend_countdown("#pop_action #tfa_resend");//No I18N
	closePopup(close_popupscreen,"common_popup");//No I18N
}



function verify_mfa_mobile()
{
	$("#newmobile").val("");//clearing the value
	remove_error();
	var val = de('prefcode').value; //No I18N
	var mobileVal;
	
	if(!isEmpty( $('#enc_mob').val()))
	{
		mobileVal = $('#enc_mob').val().trim();
	}
	else
	{
		showErrorMessage(err_cnt_error_occurred);
	}	if(isEmpty(val))
	{
		$("#verfiy_code_tfa_space").append( '<div class="field_error">'+empty_field+'</div>' );
		return;
	}
	if(isNaN(val))
	{
		$("#verfiy_code_tfa_space").append( '<div class="field_error">'+err_invalid_verify_code+'</div>' );
	}
	
	var parms=
	{
		"code":val//No I18N
	};
	$(".tfa_blur").show();
	$(".loader").show();
	var payload = TFA_mobileOBJ.create(parms);
	
	payload.PUT("self","self","mode",mobileVal).then(function(resp)	//No I18N
	{
		SuccessMsg(getErrorMessage(resp));
		$("#enc_mob").val("");
		$("#countrycode").val("");
		close_popupscreen();
		var display_bkup_popup=false;
		if(tfa_data.modes.indexOf("otp")==-1)
		{
			tfa_data.modes[tfa_data.modes.length]="otp"
			tfa_data.otp=[];
			tfa_data.otp.mobile=[];
			display_bkup_popup=true;
		}
		tfa_data.otp.mobile[tfa_data.otp.mobile.length]=resp.mfamobile;
		tfa_data.otp.count++;
		if(!tfa_data.is_mfa_activated)
		{
			tfa_data.is_mfa_activated=true;
			delete tfa_data.bc_cr_time.created_time;
			if(tfa_data.primary=="-1")
			{
				tfa_data.primary=0;
			}
		}
		load_mfa(display_bkup_popup);
	},
	function(resp)
	{
		clear_loading();
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
    return false;
}


function resend_mfa_otp(ele,is_primarymob)
{
	if(!$("#"+ele.id+" a").hasClass("resend_otp_blocked"))//countdown is over
	{
		if(is_primarymob)
		{
			add_mfa_Mobile();
		}
		else
		{
			add_tfa_bkup();
		}
	}
	return;
}

function resend_verify_otp(ele,is_primarymob)
{
	if(!$("#"+ele.id+" a").hasClass("resend_otp_blocked"))//countdown is over
	{
		remove_error();
		clearInterval(resend_timer);
		if(is_primarymob)
		{
			if(!isEmpty( $('#enc_mob').val()))
			{
				mobileVal = $('#enc_mob').val().trim();
			}
			else
			{
				showErrorMessage(err_cnt_error_occurred);
			}	
	
			var payload = TFA_mobileOBJ.create();
			
			payload.PUT("self","self","mode",mobileVal).then(function(resp)	//No I18N
			{
				clear_loading();
				SuccessMsg(getErrorMessage(resp));
				$("#add_tfa_backup_popup #tfa_resend").attr("onclick","resend_verify_otp(this,true)");//No I18N 
				$("#enc_mob").val(resp.mfamobile.encryptedMobile);
				verify_mfa_Otpcallback(mobVal);
				removeButtonDisable(".tfa_setup_work_space");//No I18N
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
				clear_loading();
				removeButtonDisable(".tfa_setup_work_space");//No I18N
			});
		}
		else
		{
			var mobileVal;
			
			if(!isEmpty( $('#enc_mob').val()))
			{
				mobileVal = $('#enc_mob').val().trim();
			}
			else
			{
				showErrorMessage(err_cnt_error_occurred);
			}
			var parms=
			{
				"is_resend":true//No I18N
			};

			disabledButton($("#newphone")[0]);
			var payload = TFA_mobileOBJ.create(parms);		
			payload.PUT("self","self","mode",mobileVal).then(function(resp)	//No I18N
			{
				SuccessMsg(getErrorMessage(resp));
				removeButtonDisable($("#newphone")[0]);
				$("#newphone").hide();
				$("#tfa_bkup_confim_space").hide();
				$("#add_tfa_backup_popup #tfa_resend").attr("onclick","resend_verify_otp(this,false)");
				$("#enc_mob").val(resp.mfamobile.encryptedMobile);
				$("#confirm_phone").show();
				resend_countdown("#confirm_phone #tfa_resend");//No I18N
				$("#vcode").focus();
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
				removeButtonDisable($("#newphone")[0]);
				clear_loading();
			});
		}

	}
	return;
}


//tfa backup number addition 

function add_Mfa_backup(recovery_exists)
{	
	$("#add_tfa_backup_popup #phonenumber_password").hide();
	$("#add_tfa_backup_popup").show(0,function(){
		$("#add_tfa_backup_popup").addClass("pop_anim");
	});
		show_addnewbkup();
		

	popup_blurHandler('6','.5');
	control_Enter(".blue");//No i18N
	closePopup(close_add_new_tfa_popup,"add_tfa_backup_popup");//No I18N
	
}


function show_addnewbkup()
{
	$("#delete_tfa_recovery_popup .popuphead_define").html(tfa_new_backup);
	$("#newphone").show();
	$("#confirm_phone").hide();
	if(!isMobile)
	{
		if(curr_country!=undefined	&&	curr_country!="")
		{
			$("#countNameAddDiv option[value="+curr_country.toUpperCase()+"]").attr('selected','selected');
		}
		
		$("#countNameAddDiv").select2({ 
			width: '67px',//No I18N
			dropdownCssClass: "tfa_backup_dropdown",//No I18N
			templateResult: phoneSelectformat,
			templateSelection: function (option) {
				selectFlag($(option.element));
				codelengthChecking(option.element,"mobileno");//No i18N
				return $(option.element).attr("data-num");
			},
		    escapeMarkup: function (m) {
		    	return m;
			}}).on("select2:open", function() {
		       $(".select2-search__field").attr("placeholder", iam_search_text);//No I18N
		  });
		$("#select_phonenumber .select2-selection").append("<span id='selectFlag' class='selectFlag'></span>");
		selectFlag( $("#countNameAddDiv").find("option:selected"));
		$(".select2-selection__rendered").attr("title", "");
	    $("#countNameAddDiv").on("select2:close", function (e) { 
			$(e.target).siblings("input").focus();
		});
	}
	else
	{
		phonecodeChangeForMobile($("#countNameAddDiv")[0]);
	}
	$("#tfa_new_tobackup").show();
	$("#tfa_recover_tobackup").hide();
	$("#mobileno").focus();
}

function add_tfa_bkup()
{
	remove_error();
	clearInterval(resend_timer);
	var mobVal = de('mobileno').value;  //No I18N
	if(mobVal == "")
	{
		$("#select_phonenumber").append( '<div class="field_error">'+empty_field+'</div>' );
		return;
	}
	if(validateMobile(mobVal) != true) 
	{
		$("#select_phonenumber").append( '<div class="field_error">'+err_enter_valid_mobile+'</div>' );
		return;	
	} 
	var countryCode = de('countNameAddDiv').value; //No I18N
	
	
	var parms=
	{
		"mobile":mobVal,//No I18N
		"countrycode":countryCode//No I18N
	};

	disabledButton($("#newphone")[0]);
	var payload = TFA_mobileOBJ.create(parms);
	
	payload.POST("self","self","mode").then(function(resp)	//No I18N
	{
		SuccessMsg(getErrorMessage(resp));
		removeButtonDisable($("#newphone")[0]);
		$("#newphone").hide();
		$("#tfa_bkup_confim_space").hide();
		$("#add_tfa_backup_popup #tfa_resend").attr("onclick","resend_verify_otp(this,false)");
		$("#enc_mob").val(resp.mfamobile.encryptedMobile);
		$("#confirm_phone").show();
		resend_countdown("#confirm_phone #tfa_resend");//No I18N
		$("#vcode").focus();
		var displayPhone ="("+$("#countNameAddDiv option:selected").text().split("(")[1]+" "+de('mobileno').value;
		$('.tfa_info_text').html(formatMessage(err_verify_sms_message,displayPhone));		
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
		removeButtonDisable($("#newphone")[0]);
		clear_loading();
	});

}




function closeview_all_tfanumber_view()
{
	tooltip_Des(".tfa_backupnumber .action_icon");//No I18N
	popupBlurHide('#tfa_phonenumber_web_more',function(){//No I18N
		$(".tfa_extra_num").hide();
		$("#view_all_tfa_phonenumber").html("");		
	});
}


function verify_tfa_bkup()
{
	remove_error();
	var code = $('#vcode').val().trim(); //No I18N
	if(isEmpty(code)) 
	{
		$("#verfiy_code_tfa_bkup_space").append( '<div class="field_error">'+err_invalid_verify_code+'</div>' );
		return;
	}
	if(isNaN(code))
	{
		$("#confirm_phone #verfiy_code_tfa_space").append( '<div class="field_error">'+err_invalid_verify_code+'</div>' );
		return;
	}
	
	var mobileVal;
	
	if(!isEmpty( $('#enc_mob').val()))
	{
		mobileVal = $('#enc_mob').val().trim();
	}
	else
	{
		showErrorMessage(err_cnt_error_occurred);
	}
	

	var parms=
	{
		"code":code//No I18N
	};
	disabledButton($("#confirm_phone"));
	var payload = TFA_mobileOBJ.create(parms);
	
	payload.PUT("self","self","mode",mobileVal).then(function(resp)	//No I18N
	{
		SuccessMsg(getErrorMessage(resp));
		close_add_new_tfa_popup();
		$("#enc_mob").val("");
		removeButtonDisable($("#confirm_phone"));
	
		tfa_data.otp.mobile[tfa_data.otp.mobile.length]=resp.mfamobile;
		tfa_data.otp.count++;
		load_mfa();
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
		removeButtonDisable($("#confirm_phone"));
		
	});
}




function remove_mfa_backup(encrypt_mob,id)
{
	var mobile=$("#"+id+" .emailaddress_text").html();
	
	show_confirm(formatMessage(err_mobile_sure_delete1, mobile),
	    function() 
	    {
			remove_tfabk_confirm(encrypt_mob);
		},
	    function() 
	    {
	    	return false;
	    }
	);
}


function make_primary_backup(encrypt_mob,id)
{
	var mobile=$("#"+id+" .emailaddress_text").html();
	
	show_confirm(formatMessage(primary_mobile_change_sure, mobile),
	    function() 
	    {
			MK_primary_tfabk_confirm(encrypt_mob);
		},
	    function() 
	    {
	    	return false;
	    }
	);
}


function MK_primary_tfabk_confirm(e_mobile)
{
	var parms={};

	var payload = tfa_makeprim.create(parms);
	payload.PUT("self","self","mode",e_mobile).then(function(resp)	//No I18N
    {
		SuccessMsg(getErrorMessage(resp));
		var mobile_list=tfa_data.otp.mobile;
	    for(j=0;j<mobile_list.length;j++)
		{
	    	if(mobile_list[j].is_primary)
			{
	    		delete tfa_data.otp.mobile[j].is_primary;
			}
	    	if(mobile_list[j].e_mobile==e_mobile)
	    	{
	    		tfa_data.otp.mobile[j].is_primary=true;
	    	}
		}
		load_mfa();
		if($("#tfa_phonenumber_web_more").is(":visible"))
		{
				show_all_Mfa_phonenumbers();
		}
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

function remove_tfabk_confirm(e_mobile)
{	
	new URI(TFA_mobileOBJ,"self","self","mode",e_mobile).DELETE().then(function(resp)	//No I18N
			{
				SuccessMsg(getErrorMessage(resp));
				var mobile_list=tfa_data.otp.mobile;
			    for(j=0;j<mobile_list.length;j++)
				{
			    	if(mobile_list[j].e_mobile==e_mobile)
			    	{
			    		if(mobile_list.length!=j+1)
			    		{
			    			tfa_data.otp.mobile[j]=mobile_list[mobile_list.length-1];
			    			delete tfa_data.otp.mobile[mobile_list.length-1];
			    		}
			    		else
			    		{
			    			delete tfa_data.otp.mobile[j];
			    		}
			    		var display_bkup_popup=false;
			    		tfa_data.otp.mobile.length--
			    		if(tfa_data.otp.mobile.length==0)
			    		{
			    			delete tfa_data.otp;
			    			delete tfa_data.modes[tfa_data.modes.indexOf("otp")];
			    			delete mfa_deatils[0];
			    			if(tfa_data.primary==0)
							{
								tfa_data.primary="-1";
							}
			    			if(jQuery.isEmptyObject(mfa_deatils))
			    			{
			    				tfa_data.is_mfa_activated=false;
			    			}
			    			display_bkup_popup=true;
			    		}
			    		break;
			    	}
				}
			    load_mfa(display_bkup_popup);
				if($("#tfa_phonenumber_web_more").is(":visible"))
				{
					if(tfa_data.otp.mobile.length==0)
					{
						closeview_all_mfanumber_view();
					}
					else
					{
						show_all_Mfa_phonenumbers();
					}
				}
				
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


function show_all_Mfa_phonenumbers()
{
	tooltip_Des(".action_icon");//No I18N
	$("#mfa_show_all_otp").show();
	$("#mfa_show_all_oneauth").hide();
	$("#view_all_tfa_phonenumber").html("");
	$("#view_all_tfa_phonenumber").append($("#all_tfa_numbers").html());
	
	popup_blurHandler('6','.5');
	$("#tfa_phonenumber_web_more").show(0,function(){
		$("#tfa_phonenumber_web_more").addClass("pop_anim");
	});
	$("#view_all_tfa_phonenumber .extra_phonenumbers").show();
	$("#view_all_tfa_phonenumber .pri_sec_indicator").show();
	$("#view_all_tfa_phonenumber .primary_dot").css("display","inline-block");
	$("#tfa_phonenumber_web_more").focus();
	sessiontipSet(".tfa_backupnumber .action_icon");//No I18N
	closePopup(closeview_all_mfanumber_view,"tfa_phonenumber_web_more");//No I18N
	
	$("#view_all_tfa_phonenumber .mfa_field_mobile .action_icon" ).removeAttr("onclick");
	
	$("#view_all_tfa_phonenumber .mfa_field_mobile .action_icons_div_ph span").click(function()
	{
		var id=$(this).attr('id');
		if($("#"+id).attr("onclick"))
		{
			var args=$("#"+id).attr("onclick").split(",");
		}
		
		if($("#view_all_tfa_phonenumber #"+id).hasClass("selected_icons"))
		{
			$("#view_all_tfa_phonenumber .mfa_field_mobile").removeClass("web_email_specific_popup");
			
			$("#view_all_tfa_phonenumber .inline_action").slideUp(300,function(){
				$("#view_all_tfa_phonenumber .inline_action").remove();
			});
			$("#view_all_tfa_phonenumber .action_icons_div_ph").removeClass("show_icons");
			$("#view_all_tfa_phonenumber .mfa_field_mobile .action_icons_div_ph span").removeClass("selected_icons");
			return;
		}
		var parent_id=$($("#view_all_tfa_phonenumber #"+id).parents(".mfa_field_mobile")).attr("id");//No I18N
		var prev_parent_id;
		if($("#view_all_tfa_phonenumber .inline_action").length)
		{
			prev_parent_id = $("#view_all_tfa_phonenumber .inline_action").parents(".mfa_field_mobile").attr("id");
			if(prev_parent_id == parent_id)
			{
				$("#"+prev_parent_id+" .inline_action").slideUp(300);
			}
		}
		
		
		$("#view_all_tfa_phonenumber .action_icons_div_ph").removeClass("show_icons");
		$("#view_all_tfa_phonenumber .mfa_field_mobile .action_icons_div_ph span").removeClass("selected_icons");
		
		if(id.startsWith("mob-delete"))//primary delete
		{
			var enc_mob=args[0].split("(")[1].replace(/'/g,'');
			var base_id=args[1].split(")")[0].replace(/'/g,'');
			var mobile=$("#"+base_id+" .emailaddress_text").html();
			
			$("#view_all_tfa_phonenumber #"+parent_id+" .action_icons_div_ph").addClass("show_icons");
			
			$("#view_all_tfa_phonenumber #"+id).addClass("selected_icons");
			
			$("#view_all_tfa_phonenumber #"+parent_id).append('<div class="inline_action"></div>');
			if($("#view_all_tfa_phonenumber #"+parent_id+" .inline_action").length==2)
			{
				var conf_ele = $("#view_all_tfa_phonenumber #"+parent_id+" .inline_action" )[1];
			}
			else
			{
				var conf_ele=$("#view_all_tfa_phonenumber #"+parent_id+" .inline_action" );
			}
			$(conf_ele).html('<div class="inline_action_discription">'+formatMessage(err_mobile_sure_delete1, mobile)+'</div>');
			
			$(conf_ele).append('<button id="delete_specific_email" class="primary_btn_check inline_btn nobottom_margin_btn delete_btn" onclick="remove_tfabk_confirm(\''+enc_mob+'\');">'+$("#return_true").html()+'</button>');

		}
		else if(id.startsWith("mob-primary"))
		{
			var enc_mob=args[0].split("(")[1].replace(/'/g,'');
			var base_id=args[1].split(")")[0].replace(/'/g,'');
			var mobile=$("#"+base_id+" .emailaddress_text").html();
			
			$("#view_all_tfa_phonenumber #"+parent_id+" .action_icons_div_ph").addClass("show_icons");
			
			$("#view_all_tfa_phonenumber #"+id).addClass("selected_icons");
			$("#view_all_tfa_phonenumber #"+parent_id).append('<div class="inline_action"></div>');
			if($("#view_all_tfa_phonenumber #"+parent_id+" .inline_action").length==2)
			{
				var conf_ele = $("#view_all_tfa_phonenumber #"+parent_id+" .inline_action" )[1];
			}
			else
			{
				var conf_ele=$("#view_all_tfa_phonenumber #"+parent_id+" .inline_action" );
			}
			$(conf_ele).html('<div class="inline_action_discription">'+formatMessage(primary_mobile_change_sure, mobile)+'</div>');
			$(conf_ele).append('<button id="delete_specific_email" class="primary_btn_check inline_btn nobottom_margin_btn delete_btn" onclick="MK_primary_tfabk_confirm(\''+enc_mob+'\');">'+$("#return_true").html()+'</button>');
			
		}
		
		if(prev_parent_id!=undefined)
		{
			if(prev_parent_id != parent_id)
			{
				$("#view_all_tfa_phonenumber .mfa_field_mobile").removeClass("web_email_specific_popup");
				
				$("#view_all_tfa_phonenumber #"+prev_parent_id+" .inline_action").slideUp(300,function(){
					$("#"+prev_parent_id+" .inline_action").remove();
				});
				$("#view_all_tfa_phonenumber #"+parent_id+" .inline_action" ).slideDown(300,function(){});
			}
			else
			{
				var previous=$("#"+prev_parent_id+" .inline_action")[0];
				var newele=$("#"+prev_parent_id+" .inline_action")[1];
				$(previous).slideUp(300,function(){
					$(newele).slideDown(300,function(){
						$(previous).remove();
					});
					
				});
			}
		}
		else
		{
			
			$("#view_all_tfa_phonenumber #"+parent_id+" .inline_action" ).slideDown(300,function(){});
		}
		$("#view_all_tfa_phonenumber #"+parent_id).addClass("web_email_specific_popup");
		
	});
	
	tooltipSet(".action_icon");//No I18N
	
	
	
}


function closeview_all_mfanumber_view()
{
	tooltip_Des(".tfa_backupnumber .action_icon");//No I18N
	popupBlurHide('#tfa_phonenumber_web_more',function(){//No I18N
		$(".tfa_extra_num").hide();
		$("#view_all_tfa_phonenumber").html("");		
	});
}

//MFA MOBILE SPECIFIC POPUP

function Mfa_mobile_ui_specific(id,enc_id)
{
	if(isMobile)
	{
		$(".mob_popu_btn_container").show();
		$(".option_container").hide();
		
		if(!$("#tfa_phonenumber_web_more").is(":visible"))
		{
			remove_error();	
			popup_blurHandler("6",'.5');
			$("#tfaphone_mobile_ui").show(0,function(){
				$("#tfaphone_mobile_ui").addClass("pop_anim");
			});
			
			if($("#"+id+" .action_icons_div_ph").children().hasClass("icon-delete"))
			{
				$("#btn_to_delete").show();
				var name = $("#"+id+" .mobile_info .emailaddress_text").html();
				
				if(id=="MFAdevice_primary"	||	id.startsWith("mfa_deviceDetails"))//for device mode
				{
					$("#btn_to_delete").attr("onclick","show_MFA_mob_confirmUI('mfa_device_delete','"+formatMessage(mfa_delete_device,name)+"','"+enc_id+"')");
				}
				else
				{
					$("#btn_to_delete").attr("onclick","show_MFA_mob_confirmUI('mfa_ph_delete','"+formatMessage(err_mobile_sure_delete1,name)+"','"+enc_id+"')");
				}
			}
			if($("#"+id+" .action_icons_div_ph").children().hasClass("icon-makeprimary"))
			{
				$("#btn_to_chng_primary").show();
				var name = $("#"+id+" .mobile_info .emailaddress_text").html();
				
				if(id=="MFAdevice_primary"	||	id.startsWith("mfa_deviceDetails"))//for device mode
				{
					$("#btn_to_chng_primary").attr("onclick","show_MFA_mob_confirmUI('mfa_device_primary','"+formatMessage(mfa_change_prim_device, name)+"','"+enc_id+"')");//No I18N
				}
				else
				{
					$("#btn_to_chng_primary").attr("onclick","show_MFA_mob_confirmUI('mfa_ph_primary','"+formatMessage(primary_mobile_change_sure, name)+"','"+enc_id+"')");//No I18N
				}
			}
			$("#tfaphone_mobile_ui .popuphead_details").html($("#"+id).html());
			$("#tfaphone_mobile_ui").focus();
			closePopup(close_MFA_mobile_specific,"tfaphone_mobile_ui");//No I18N
		}
		else
		{
			if(!$(event.target).parents().hasClass("inline_action"))
			{
				var prev_parent_id=undefined;
				if($("#view_all_tfa_phonenumber .inline_action").length)
				{
					prev_parent_id = $("#view_all_tfa_phonenumber .inline_action").parents(".mfa_field_mobile").attr("id");
					if(prev_parent_id == id)
					{
						$("#"+prev_parent_id+" .inline_action").slideUp(300,function(){
							$("#"+prev_parent_id+" .inline_action").remove();
						});
					}
				}
				
				$("#view_all_tfa_phonenumber .action_icons_div_ph").removeClass("show_icons");
				
				$("#view_all_tfa_phonenumber #"+id+" .action_icons_div_ph").addClass("show_icons");
				
				
				
				$("#view_all_tfa_phonenumber #"+id).append('<div class="inline_action"></div>');
				$("#view_all_tfa_phonenumber #"+id+" .inline_action").html($("#tfaphone_mobile_ui").html());
				
				
				if($("#"+id+" .action_icons_div_ph").children().hasClass("icon-delete"))
				{
					$("#btn_to_delete").show();
					var name = $("#"+id+" .mobile_info .emailaddress_text").html();
					
					if(id=="MFAdevice_primary"	||	id.startsWith("mfa_deviceDetails"))//for device mode
					{
						$("#btn_to_delete").attr("onclick","show_MFA_mob_confirmUI_viewall('mfa_device_delete','"+formatMessage(mfa_delete_device,name)+"','"+enc_id+"')");
					}
					else
					{
						$("#btn_to_delete").attr("onclick","show_MFA_mob_confirmUI_viewall('mfa_ph_delete','"+formatMessage(err_mobile_sure_delete1,name)+"','"+enc_id+"')");
					}
				}
				if($("#"+id+" .action_icons_div_ph").children().hasClass("icon-makeprimary"))
				{
					$("#btn_to_chng_primary").show();
					var name = $("#"+id+" .mobile_info .emailaddress_text").html();
					
					if(id=="MFAdevice_primary"	||	id.startsWith("mfa_deviceDetails"))//for device mode
					{
						$("#btn_to_chng_primary").attr("onclick","show_MFA_mob_confirmUI_viewall('mfa_device_primary','"+formatMessage(mfa_change_prim_device, name)+"','"+enc_id+"')");//No I18N
					}
					else
					{
						$("#btn_to_chng_primary").attr("onclick","show_MFA_mob_confirmUI_viewall('mfa_ph_primary','"+formatMessage(primary_mobile_change_sure, name)+"','"+enc_id+"')");//No I18N
					}
				}
				
				if(prev_parent_id!=undefined)
				{
					if(prev_parent_id != id)
					{
						$("#view_all_tfa_phonenumber #"+prev_parent_id+" .inline_action").slideUp(300,function(){
							$("#view_all_tfa_phonenumber #"+prev_parent_id+" .inline_action").remove();
							$("#view_all_tfa_phonenumber #"+id+" .inline_action" ).slideDown(300);
						});
						
					}
					else
					{
						var previous=$("#view_all_tfa_phonenumber #"+id+" .inline_action" )[0];
						var newele=$("#view_all_tfa_phonenumber #"+id+" .inline_action" )[1];
						$(previous).slideUp(300,function(){
							$(newele).slideDown(300,function(){
								$(previous).remove();
							});
						});
					}
				}
				else
				{
						$("#view_all_tfa_phonenumber #"+id+" .inline_action" ).slideDown(300);
				}
			
			}
		}
	}
}


function show_MFA_mob_confirmUI_viewall(action_type,def,enc_id)
{
	$(".inline_action").slideUp(300,function()
	{
		$(".inline_action .mob_popu_btn_container").hide();
		$(".inline_action .option_container").show();
		$(".inline_action").slideDown(300);		
	});
	$(".inline_action .option_container .mob_popuphead_define").html(def);
	
	$("#view_all_tfa_phonenumber .option_button #action_granted").click(function()
	{	
		if(action_type == "mfa_ph_primary" )
		{
			MK_primary_tfabk_confirm(enc_id)
			return false;
		}
		else if(action_type == "mfa_ph_delete" )
		{
			remove_tfabk_confirm(enc_id);
			return false;
		}
		else if(action_type == "mfa_device_delete" )
		{
			remove_device_confirm(enc_id);
			return false;
		}
		else if(action_type == "mfa_device_primary" )
		{
			MK_primary_device_confirm(enc_id);
			return false;
		}
			
	});
	
	
}

function show_MFA_mob_confirmUI(action_type,def,enc_id)
{
	$(".mob_popu_btn_container").slideUp(300,function()
	{
		$(".option_container").slideDown(300);
	});
	$(".option_container .mob_popuphead_define").html(def);
	
	$("#tfaphone_mobile_ui .option_button #action_granted").click(function()
	{	
		if(action_type == "mfa_ph_primary" )
		{
			MK_primary_tfabk_confirm(enc_id)
			return false;
		}
		else if(action_type == "mfa_ph_delete" )
		{
			remove_tfabk_confirm(enc_id);
			return false;
		}
		else if(action_type == "mfa_device_delete" )
		{
			remove_device_confirm(enc_id);
			return false;
		}
		else if(action_type == "mfa_device_primary" )
		{
			MK_primary_device_confirm(enc_id);
			return false;
		}
	});
}


function close_MFA_mobile_specific()
{
	if($("#tfa_phonenumber_web_more").is(":visible"))
	{
		$(".viewall_popup_content .inline_action").slideUp(300,function()
		{
			$(".viewall_popup_content .inline_action").remove();
		});
	}
	else{
		popupBlurHide("#tfaphone_mobile_ui",function()	//No I18N
		{

		}); 
	}
	$(".option_button #action_granted").unbind();
}



//Device setup 


function show_all_devices()
{
	tooltip_Des(".tfa_backupnumber .action_icon");//No I18N
	$("#mfa_show_all_otp").hide();
	$("#mfa_show_all_oneauth").show();
	$("#view_all_tfa_phonenumber").html("");
	$("#view_all_tfa_phonenumber").append($("#all_tfa_devices").html());
	
	popup_blurHandler('6','.5');
	$("#tfa_phonenumber_web_more").show(0,function(){
		$("#tfa_phonenumber_web_more").addClass("pop_anim");
	});
	$("#view_all_tfa_phonenumber .extra_phonenumbers").show();
	$("#view_all_tfa_phonenumber .primary_dot").css("display","inline-block");
	
	sessiontipSet(".tfa_backupnumber .action_icon");//No I18N
	closePopup(closeview_all_mfanumber_view,"tfa_phonenumber_web_more");//No I18N
	
	$("#view_all_tfa_phonenumber .mfa_field_mobile .action_icon" ).removeAttr("onclick");
	
	$("#view_all_tfa_phonenumber .mfa_field_mobile .action_icons_div_ph span").click(function()
			{
				var id=$(this).attr('id');
				if($("#"+id).attr("onclick"))
				{
					var args=$("#"+id).attr("onclick").split(",");
				}
				
				if($("#view_all_tfa_phonenumber #"+id).hasClass("selected_icons"))
				{
					$("#view_all_tfa_phonenumber .mfa_field_mobile").removeClass("web_email_specific_popup");
					
					$("#view_all_tfa_phonenumber .inline_action").slideUp(300,function(){
						$("#view_all_tfa_phonenumber .inline_action").remove();
					});
					
					$("#view_all_tfa_phonenumber .action_icons_div_ph").removeClass("show_icons");
					$("#view_all_tfa_phonenumber .mfa_field_mobile .action_icons_div_ph span").removeClass("selected_icons");
					
					return;
				}
				
				var parent_id=$($("#view_all_tfa_phonenumber #"+id).parents(".mfa_field_mobile")).attr("id");//No I18N
				var prev_parent_id;
				if($("#view_all_tfa_phonenumber .inline_action").length)
				{
					prev_parent_id = $("#view_all_tfa_phonenumber .inline_action").parents(".mfa_field_mobile").attr("id");
					if(prev_parent_id == parent_id)
					{
						$("#"+prev_parent_id+" .inline_action").slideUp(300);
					}
				}
				
				
				$("#view_all_tfa_phonenumber .action_icons_div_ph").removeClass("show_icons");
				$("#view_all_tfa_phonenumber .mfa_field_mobile .action_icons_div_ph span").removeClass("selected_icons");
				
				if(id.startsWith("device-delete"))//primary delete
				{
					var enc_divice=args[0].split("(")[1].replace(/'/g,'');
					var base_id=args[1].split(")")[0].replace(/'/g,'');
					var device_name=$("#"+base_id+" .emailaddress_text").html();
					
					$("#view_all_tfa_phonenumber #"+parent_id+" .action_icons_div_ph").addClass("show_icons");
					
					$("#view_all_tfa_phonenumber #"+id).addClass("selected_icons");
					
					$("#view_all_tfa_phonenumber #"+parent_id).append('<div class="inline_action"></div>');
					if($("#view_all_tfa_phonenumber #"+parent_id+" .inline_action").length==2)
					{
						var conf_ele = $("#view_all_tfa_phonenumber #"+parent_id+" .inline_action" )[1];
					}
					else
					{
						var conf_ele=$("#view_all_tfa_phonenumber #"+parent_id+" .inline_action" );
					}
					$(conf_ele).html('<div class="inline_action_discription">'+formatMessage(mfa_delete_device, device_name)+'</div>');
					
					$(conf_ele).append('<button id="delete_specific_email" class="primary_btn_check inline_btn nobottom_margin_btn delete_btn" onclick="remove_device_confirm(\''+enc_divice+'\');">'+$("#return_true").html()+'</button>');

				}
				else if(id.startsWith("device-primary"))
				{
					var enc_divice=args[0].split("(")[1].replace(/'/g,'');
					var base_id=args[1].split(")")[0].replace(/'/g,'');
					var device_name=$("#"+base_id+" .emailaddress_text").html();
					
					$("#view_all_tfa_phonenumber #"+parent_id+" .action_icons_div_ph").addClass("show_icons");
					
					$("#view_all_tfa_phonenumber #"+id).addClass("selected_icons");
					$("#view_all_tfa_phonenumber #"+parent_id).append('<div class="inline_action"></div>');
					if($("#view_all_tfa_phonenumber #"+parent_id+" .inline_action").length==2)
					{
						var conf_ele = $("#view_all_tfa_phonenumber #"+parent_id+" .inline_action" )[1];
					}
					else
					{
						var conf_ele=$("#view_all_tfa_phonenumber #"+parent_id+" .inline_action" );
					}
					$(conf_ele).html('<div class="inline_action_discription">'+formatMessage(mfa_change_prim_device, device_name)+'</div>');
					$(conf_ele).append('<button id="delete_specific_email" class="primary_btn_check inline_btn nobottom_margin_btn delete_btn" onclick="MK_primary_device_confirm(\''+enc_divice+'\');">'+$("#return_true").html()+'</button>');
					
				}
				
				if(prev_parent_id!=undefined)
				{
					if(prev_parent_id != parent_id)
					{
						$("#view_all_tfa_phonenumber .mfa_field_mobile").removeClass("web_email_specific_popup");
						
						$("#view_all_tfa_phonenumber #"+prev_parent_id+" .inline_action").slideUp(300,function(){
							$("#"+prev_parent_id+" .inline_action").remove();
						});
						$("#view_all_tfa_phonenumber #"+parent_id+" .inline_action" ).slideDown(300,function(){});
					}
					else
					{
						var previous=$("#"+prev_parent_id+" .inline_action")[0];
						var newele=$("#"+prev_parent_id+" .inline_action")[1];
						$(previous).slideUp(300,function(){
							$(newele).slideDown(300,function(){
								$(previous).remove();
							});
							
						});
					}
				}
				else
				{
					
					$("#view_all_tfa_phonenumber #"+parent_id+" .inline_action" ).slideDown(300,function(){});
				}
				$("#view_all_tfa_phonenumber #"+parent_id).addClass("web_email_specific_popup");
				
			});
}



function remove_mfa_device(encrypt_device,id)
{
	var device_name=$("#"+id+" .emailaddress_text").html();
	
	show_confirm(formatMessage(mfa_delete_device, device_name),
	    function() 
	    {
			remove_device_confirm(encrypt_device);
		},
	    function() 
	    {
	    	return false;
	    }
	);
}


function remove_device_confirm(encrypt_device)
{	
	new URI(TFA_deviceOBJ,"self","self","mode",encrypt_device).DELETE().then(function(resp)	//No I18N
			{
				SuccessMsg(getErrorMessage(resp));
				var device_list=tfa_data.devices.device;
			    for(j=0;j<device_list.length;j++)
				{
			    	if(device_list[j].device_id==encrypt_device)
			    	{
			    		if(device_list.length!=j+1)
			    		{
			    			tfa_data.devices.device[j]=device_list[device_list.length-1];
			    			delete tfa_data.devices.device[device_list.length-1];
			    		}
			    		else
			    		{
			    			delete tfa_data.devices.device[j];
			    		}
			    		tfa_data.devices.device.length--
			    		var display_bkup_popup=false;
			    		if(tfa_data.devices.device.length==0)
			    		{
			    			delete tfa_data.devices;
			    			delete tfa_data.modes[tfa_data.modes.indexOf("devices")];
			    			
			    			delete mfa_deatils[2];
			    			delete mfa_deatils[3];
			    			delete mfa_deatils[4];
			    			delete mfa_deatils[5];
			    			delete mfa_deatils[7];
			    			delete mfa_deatils[11];
			    			delete mfa_deatils[12];
			    			if(mfa_deatils[tfa_data.primary]==undefined)
							{
								tfa_data.primary="-1"
							}
			    			if(jQuery.isEmptyObject(mfa_deatils))
			    			{
			    				tfa_data.is_mfa_activated=false;
			    			}
			    			display_bkup_popup=true;
			    		}
			    		break;
			    	}
				}
			    load_mfa(display_bkup_popup);
				if($("#tfa_phonenumber_web_more").is(":visible"))
				{
					if(tfa_data.devices.device.length==0)
					{
						closeview_all_mfanumber_view();
					}
					else
					{
						show_all_devices();
					}
				}
				
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

function make_device_primary(encrypt_device,id)
{
	var device_name=$("#"+id+" .emailaddress_text").html();
	
	show_confirm(formatMessage(mfa_change_prim_device, device_name),
	    function() 
	    {
			MK_primary_device_confirm(encrypt_device);
		},
	    function() 
	    {
	    	return false;
	    }
	);
}


function MK_primary_device_confirm(encrypt_device)
{
	var payload = TFA_deviceOBJ.create();
	payload.PUT("self","self","mode",encrypt_device).then(function(resp)	//No I18N
    {
		SuccessMsg(getErrorMessage(resp));
		var device_list=tfa_data.devices.device;
	    for(j=0;j<device_list.length;j++)
		{
	    	if(device_list[j].is_primary)
			{
	    		delete tfa_data.devices.device[j].is_primary;
			}
	    	if(device_list[j].device_id==encrypt_device)
	    	{
	    		tfa_data.devices.device[j].is_primary=true;
	    	}
		}
		load_mfa();
		if($("#tfa_phonenumber_web_more").is(":visible"))
		{
			show_all_devices();
		}
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









//Authn App setup 


function inititate_auth_setup()
{
	var payload = OtpObj.create();
	payload.POST("self","self","mode").then(function(resp)	//No I18N
	{
		var heading = $("#auth_mode_head .box_head").html();
		var description=$("#auth_mode_head .box_discrption").html();
		set_popupinfo(heading,description);
		
		$("#pop_action").html($("#mfa_auth_mode_popups").html()); //load into popuop
		
		control_Enter(".primary_btn_check"); //No i18N
		control_Enter("#tfaremember_field"); //No i18N
		$("#tfa_auth_box .primary_btn_check:first").focus();
		closePopup(close_popupscreen,"common_popup");//No I18N
		$("#common_popup").focus();
		var data=resp.mfaotp[0];
		de('gauthimg').src="data:image/jpeg;base64,"+data.qr_image;
		var key=data.secretkey;
		
		var displaykey = "<span>"+key.substring(0, 4)+"</span>"+"<span style='margin-left:5px'>"+key.substring(4, 8)+"</span>"+"<span style='margin-left:5px'>"+key.substring(8,12)+"</span>"+"<span style='margin-left:5px'>"+key.substring(12)+"</span>"; //No I18N
		$('#skey').html(displaykey); //No i18N
		
		$("#pop_action #auth_app_confirm").attr("onclick","verify_auth_qr('"+data.encryptedSecretKey+"')")
		
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


function download_options()
{
	var heading = $("#auth_mode_downloads .box_head").html();
	var description=$("#auth_mode_downloads .box_discrption").html();
	set_popupinfo(heading,description);
	
	$("#pop_action").html($("#mfa_auth_downloads_popups").html()); //load into popuop
	closePopup(close_popupscreen,"common_popup");//No I18N
}


function verify_auth_qr(key)
{
	var heading = tfa_device_verify;
	var description=err_verify_qr_key;
	set_popupinfo(heading,description);
	
	$("#mfa_verify_space_popups #tfa_verfiy_butt").attr("onclick","verify_mfa_authOTP('"+key+"')");
	$("#mfa_verify_space_popups #tfa_verify_cancel").attr("onclick","inititate_auth_setup()");
	$("#prefcode").val("");
	
	$("#pop_action").html($("#mfa_verify_space_popups").html()); //load into popuop
	
	$("#tfa_resend").hide();

	closePopup(close_popupscreen,"common_popup");//No I18N
	$("#common_popup #prefcode").focus();
	
}


function verify_mfa_authOTP(key)
{
	remove_error();
	var code = de('prefcode').value; //No I18N
	if(code == "")
	{
		$("#verfiy_code_tfa_space").append( '<div class="field_error">'+empty_field+'</div>' );
		return;
	}
	
	var parms=
	{
		"code":code//No I18N
	};
	$(".tfa_blur").show();
	$(".loader").show();
	disabledButton($("#tfa_verify_box"));
	var payload = OtpObj.create(parms);
	
	payload.PUT("self","self","mode",key).then(function(resp)	//No I18N
	{
		SuccessMsg(getErrorMessage(resp));
		
		if(tfa_data.modes.indexOf("totp")==-1)
		{
			tfa_data.modes[tfa_data.modes.length]="totp";
		}
		tfa_data.totp=resp.mfaotp;
		if(!tfa_data.is_mfa_activated)
		{
			tfa_data.is_mfa_activated=true;
			delete tfa_data.bc_cr_time.created_time
			if(tfa_data.primary=="-1")
			{
				tfa_data.primary=1;
			}
		}
		close_popupscreen(function(){load_mfa("true")});
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
		clear_loading();
		removeButtonDisable($("#tfa_verify_box"));
	});	
}


function delete_totp()
{
	new URI(OtpObj,"self","self","mode").DELETE().then(function(resp)	//No I18N
			{
				SuccessMsg(getErrorMessage(resp));
				delete tfa_data.modes[tfa_data.modes.indexOf("totp")]
				delete tfa_data.totp;
				delete mfa_deatils[1];
				if(tfa_data.primary==1)
				{
					tfa_data.primary="-1";
				}
    			if(jQuery.isEmptyObject(mfa_deatils))
    			{
    				tfa_data.is_mfa_activated=false;
    			}
				load_mfa("true");
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

//EXO STAR MODE 


function inititate_exo_setup()
{
	$("#tfa_method").val(6);
	var heading = $("#exostar_mode_downloads .box_head").html();
	var description=$("#exostar_mode_downloads .box_discrption").html();
	set_popupinfo(heading,description);
	
	$("#pop_action").html($("#mfa_exostar_mode_popups").html()); //load into popuop
	
	closePopup(close_popupscreen,"common_popup");//No I18N
}



function showExoAuthVerify_popup()
{
	var heading =tfa_device_verify;
	var description;
	if(de('hardmodepref').checked)
	{ 
		description = err_exoauth_verify_message;//No i18N
		$("#exo_type").val("hardtok");
	}
	else
	{ 
		description = err_exoauth_verify_message1; //No i18N 
		$("#exo_type").val("softtok");
	}
	
	set_popupinfo(heading,description);
	
	$("#prefcode").val("");
	$("#prefcode").focus();
	
	$("#mfa_verify_space_popups #tfa_verfiy_butt").attr("onclick","verify_mfa_exoOTP()");
	$("#mfa_verify_space_popups #tfa_verify_cancel").attr("onclick","inititate_exo_setup()");
	
	$("#pop_action").html($("#mfa_verify_space_popups").html()); //load into popuop
	$("#tfa_resend").hide();
	
	closePopup(close_popupscreen,"common_popup");//No I18N
}

function verify_mfa_exoOTP()
{
	remove_error();
	var val = de('prefcode').value; //No I18N
	if(isEmpty(val))
	{
		$("#verfiy_code_tfa_space").append( '<div class="field_error">'+empty_field+'</div>' );
		return;
	}
	if(isNaN(val)	&&	val.length!=6)
	{
		$("#verfiy_code_tfa_space").append( '<div class="field_error">'+err_invalid_verify_code+'</div>' );
	}
	var type=$("#exo_type").val();
	
	$(".tfa_blur").show();
	$(".loader").show();
	var parms=
	{
		"code":val,//No I18N
		"type":type//No I18N
	};


	var payload = TFA_EXO_OBJ.create(parms);
	
	payload.POST("self","self","mode").then(function(resp)	//No I18N
	{
		SuccessMsg(getErrorMessage(resp));
		close_popupscreen();
		if(tfa_data.modes.indexOf("exo")==-1)
		{
			tfa_data.modes[tfa_data.modes.length]="exo";
		}
		tfa_data.exo=resp.MFAEXOStar;
		if(!tfa_data.is_mfa_activated)
		{
			tfa_data.is_mfa_activated=true;
			delete tfa_data.bc_cr_time.created_time
			if(tfa_data.primary=="-1")
			{
				tfa_data.primary=6;
			}
		}
		load_mfa("true");
	},
	function(resp)
	{
		showErrorMessage(getErrorMessage(resp));
		clear_loading();
	});
	
}

function delete_exo()
{
	new URI(TFA_EXO_OBJ,"self","self","mode").DELETE().then(function(resp)	//No I18N
			{
				SuccessMsg(getErrorMessage(resp));
				delete tfa_data.modes[tfa_data.modes.indexOf("exo")];
				delete tfa_data.exo;
				delete mfa_deatils[6];
				if(tfa_data.primary==6)
				{
					tfa_data.primary="-1";
				}
    			if(jQuery.isEmptyObject(mfa_deatils))
    			{
    				tfa_data.is_mfa_activated=false;
    			}
				load_mfa("true");
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

// YUBIKEY SETUP


function inititate_yubikey_setup()
{
	//show the yubikey popup
	set_popupinfo("","");//no heading needed
	
	$("#common_popup").addClass("yubikey_popup");
	$("#pop_action").html($("#mfa_yubikey_mode_popups").html()); //load into popuop
	closePopup(close_yubikey_popup,"common_popup");//No I18N
	$("#common_popup #yubikey_start_butt").focus();
}

function ubkeyregister_Callback(data)
{
	if(data.errorCode) 
	{
		$("#pop_action .yubikeyregis").hide();
		$("#pop_action #ubkey_tryagain_butt").show();
		 switch (data.errorCode) 
		 {
	        case 1:
	        case 5:
	          	 showErrorMessage(yubikey_error_timeout); 
             break;
         case 2:
        	 	showErrorMessage(yubikey_bad_req);
         	break;
     	case 3:
     			showErrorMessage(yubikey_error_unsupported);
             break;
         case 4:
        	 	showErrorMessage(yubikey_device_ineligible); 
         	break;
         default:
        	 	showErrorMessage(yubikey_invalid_req); //No I18N
		 }

    } 
	else 
	{
		yubikey_challenge.clientData=data.clientData;
		yubikey_challenge.registrationData=data.registrationData;
		
		get_YUBIKEY_name();
	}
}

function close_yubikey_popup()
{
	close_popupscreen(),function()
	{
		$("#common_popup").removeClass("yubikey_popup");
	}
}

function show_yubikey_configure()
{
	$("#tfa_method").val(8);
	
	var parms={};
	$("#common_popup").focus();
	var payload = Yubikey_obj.create(parms);
	payload.POST("self","self","mode").then(function(resp)	//No I18N
    {
		$("#pop_action .yubikeyregis").hide();
		$("#pop_action #ubkey_wait_butt").show();
		show_yubikey_step2();
		
		
		if(resp != null)
		{
			yubikey_challenge=resp.mfayubikey[0];
			delete yubikey_challenge.href;
			yubikey_register();
		}
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

function show_yubikey_step1()
{
	$("#pop_action #first_step").show();
	$("#pop_action #second_step").hide();
}

function yubikey_register()
{
	$("#pop_action .yubikeyregis").hide();
	$("#pop_action #ubkey_wait_butt").show();
	u2f.register(yubikey_challenge.appId,[yubikey_challenge],[],ubkeyregister_Callback,10);
}

function get_YUBIKEY_name()
{
	$("#pop_action #second_step").hide();
	$("#pop_action #third_step").show();
	$("#common_popup #yubikey_name").val("");
	$("#common_popup #yubikey_name").focus();
}

function show_yubikey_step2()
{
	remove_error();
	$("#pop_action #first_step").hide();
	$("#pop_action #third_step").hide();
	$("#pop_action #second_step").show();
}

function configure_yubikey()
{
	remove_yubikeyerror();
	var name=$("#pop_action #yubikey_name").val();
	if(isEmpty(name)	|| 	isBlank(name) )
	{
		$("#pop_action #yubikey_name_field").append( '<div class="yubikey_error field_error">'+empty_field+'</div>');
		$(".yubikey_name_desc").hide();
		return false;
	}
	else if(/^[a-zA-Z0-9_\-]*$/.test(name) == false)
	{
		$("#pop_action #yubikey_name_field").append( '<div class="yubikey_error field_error">'+yubikey_invalid_name+'</div>');
		$(".yubikey_name_desc").hide();
		return false;
	}

	var parms=
	{
			"appId":yubikey_challenge.appId,//No I18N		
			"clientData":yubikey_challenge.clientData,//No I18N	
			"registrationData":yubikey_challenge.registrationData//No I18N	
	};

	var payload = Yubikey_obj.create(parms);
	payload.PUT("self","self","mode",name).then(function(resp)	//No I18N
    {
		SuccessMsg(getErrorMessage(resp));
		close_popupscreen();
		if(tfa_data.modes.indexOf("yubikey")==-1)
		{
			tfa_data.modes[tfa_data.modes.length]="yubikey";
		}
		tfa_data.yubikey=resp.mfayubikey.yubikey;
		if(!tfa_data.is_mfa_activated)
		{
			tfa_data.is_mfa_activated=true;
			delete tfa_data.bc_cr_time.created_time
			if(tfa_data.primary=="-1")
			{
				tfa_data.primary=8;
			}
		}
		load_mfa("true");
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


function remove_yubikeyerror()
{
	$(".field_error").remove();
	$(".yubikey_name_desc").show();
}


function delete_yubikey(name)
{
	new URI(Yubikey_obj,"self","self","mode",name).DELETE().then(function(resp)	//No I18N
			{
				SuccessMsg(getErrorMessage(resp));
				delete tfa_data.modes[tfa_data.modes.indexOf("yubikey")];
				delete tfa_data.yubikey;
				delete mfa_deatils[8];
				if(tfa_data.primary==8)
				{
					tfa_data.primary="-1"
				}
    			if(jQuery.isEmptyObject(mfa_deatils))
    			{
    				tfa_data.is_mfa_activated=false;
    			}
				load_mfa("true");
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



function MFA_backup_notice()
{
	popup_blurHandler('6','.5');
	$("#backupcodes_NOTICE").show(0,function(){
		$("#backupcodes_NOTICE").addClass("pop_anim");
	});
	closePopup(close_tfa_backupcode_NOTICE,"backupcodes_NOTICE");//No I18N
	$("#backupcodes_NOTICE").focus();
}

//remove the notifiation askinf users to enable TFA
function remove_MFA_reminder()
{
 	$("#remind_TFA").remove();
 	var count=parseInt($("#pending_notif_count").attr("data-val"));
	count--;
	if(count<10	&&	count>0)
	{
		$("#pending_notif_count").html(count);
	}	
	else if(count==0)
	{
		$("#pending_notif_count").hide();
	}
}