// $Id$ 


function load_Sessionsdetails(Policies,Active_Sessions)
{
	if(de("sessions_exception"))
	{
		$("#sessions_exception").remove();
	}
	if(Active_Sessions.exception_occured!=undefined	&&	Active_Sessions.exception_occured)
	{
		$("#sessions_box .box_info" ).after("<div id='sessions_exception' class='box_content_div'>"+$("#exception_tab").html()+"</div>" );
		$("#sessions_exception #reload_exception").attr("onclick","reload_exception(ActiveSessions,'sessions_box')");
		return;
	}

	var sessions=timeSorting(Active_Sessions);
	$("#other_sesion").html("");
	var count =0;
	var othersession=0;
	$("#sessions_showall").hide();	
	tooltip_Des(".Field_session .asession_browser");//No I18N
	tooltip_Des(".Field_session .asession_os");	//No I18N
	for(iter=0;iter<Object.keys(sessions).length;iter++)
	{
		count++;
		var current_session=Active_Sessions[sessions[iter]];
		session_format = $("#empty_sessions_format").html();
		if(current_session.is_current_session)
		{
			$("#current_sesion").html(session_format);
			$("#all_sessions_active #activesession_entry .activesession_entry_info .session_logout").remove();
			$("#all_sessions_active #activesession_info #current_session_logout").remove();
			$("#all_sessions_active #select_session_").remove();
		}
		else
		{
			othersession++;
			$("#other_sesion").append(session_format);
			$("#all_sessions_active #activesession_entry .activesession_entry_info .current").remove();
			$("#all_sessions_active #activesession_info #current_session_logout").attr("onclick","deleteTicket('"+current_session.session_ticket+"');");
			if(othersession > 2)
			{
				$("#other_sesion #activesession_entry").addClass("activesession_entry_hidden");  
			}
			$("#all_sessions_active #select_session_").attr("id","select_session_"+count);
		}
		$("#all_sessions_active #activesession_entry").attr("id","activesession_entry"+count);
		$("#all_sessions_active #activesession_info").attr("id","activesession_info"+count);
		var device_class="device_"+current_session.device_info.device_img;//No I18N
		$("#activesession_entry"+count).attr("onclick","show_selected_session("+count+",'"+device_class+"');");
		$("#activesession_entry"+count+" .device_pic").addClass(device_class);

		$("#activesession_entry"+count+" .device_name").html(current_session.device_info.device_name);
		$("#activesession_entry"+count+" .device_time").html(current_session.created_time_elapsed);
		var os_class=(current_session.device_info.os_img).toLowerCase().replace(/\s/g, '');
		if(de("select_session_"+count))
		{
			$("#select_session_"+count+" .checkbox_check").attr("id",current_session.session_ticket);
		}
		$("#activesession_entry"+count+" .activesession_entry_info .asession_os").addClass("os_"+os_class);
		if(current_session.device_info.version==undefined)
		{
			$("#activesession_entry"+count+" .activesession_entry_info .asession_os").attr("title",current_session.device_info.os_name);
			$("#activesession_info"+count+" #pop_up_os").append("<span>"+current_session.device_info.os_name+"</span>");
		}
		else
		{
			$("#activesession_entry"+count+" .activesession_entry_info .asession_os").attr("title",current_session.device_info.os_name+" "+current_session.device_info.version);
			$("#activesession_info"+count+" #pop_up_os").append("<span>"+current_session.device_info.os_name+" "+current_session.device_info.version+"</span>");

		}
		var browser_class=(current_session.browser_info.browser_image).toLowerCase().replace(/\s/g, '');
		$("#activesession_entry"+count+" .activesession_entry_info .asession_browser").addClass("browser_"+browser_class);
		$("#activesession_entry"+count+" .activesession_entry_info .asession_ip").html(current_session.ip_address);
		if(current_session.location!=undefined)
		{
			$("#activesession_entry"+count+" .asession_location").removeClass("location_unavail");
			$("#activesession_entry"+count+" .asession_location").html(current_session.location);
			$("#activesession_info"+count+" #pop_up_location").removeClass("unavail");
			$("#activesession_info"+count+" #pop_up_location").html(current_session.location);
		}
		$("#activesession_info"+count+" #pop_up_time").html(current_session.created_date);
		$("#activesession_info"+count+" #pop_up_os .asession_os_popup").addClass("minios_"+os_class);

		$("#activesession_info"+count+" #pop_up_browser .asession_browser_popup").addClass("minibrowser_"+browser_class);

		if(current_session.browser_info.version==undefined){
			$("#activesession_info"+count+" #pop_up_browser").append("<span>"+current_session.browser_info.browser_name+"</span>");
			$("#activesession_entry"+count+" .activesession_entry_info .asession_browser").attr("title",current_session.browser_info.browser_name);
		}
		else{
			$("#activesession_info"+count+" #pop_up_browser").append("<span>"+current_session.browser_info.browser_name+" "+current_session.browser_info.version+"</span>");
			$("#activesession_entry"+count+" .activesession_entry_info .asession_browser").attr("title",current_session.browser_info.browser_name+" "+current_session.browser_info.version);
		}
	}
	sessiontipSet(".Field_session .asession_browser");//No I18N
	sessiontipSet(".Field_session .asession_os");//No I18N
	if(count>3)//more THAN 3
	{
		$("#sessions_showall").show();	
	}
}

function display_removeselected_session()
{
	var selected = [];
	$('#view_all_sessions input:checked').each(function() {
	    selected.push($(this).attr('id'));
	});
	if(selected.length > 0)
	{
		$("#deleted_selected_sessions").show();
		if(isMobile){
			$(".delete_all_space .red_btn").hide();
		}
	}
	else
	{
		$("#deleted_selected_sessions").hide();
		if(isMobile){
			$(".delete_all_space .red_btn").show();
		}
	}
}


function deleteSelectedSessions()
{
	var selected = [];
	$('#view_all_sessions input:checked').each(function() {
	    selected.push($(this).attr('id'));
	});
	new URI(ActiveSessionsObj,"self","self",selected).DELETE().then(function(resp)	//No I18N
			{
				SuccessMsg(getErrorMessage(resp));
				for(i=0;i<selected.length;i++)
				{
					delete sessions_data.activesessions[selected[i]];
				}				
				$("#deleted_selected_sessions").hide();
				load_Sessionsdetails(sessions_data.Policies,sessions_data.activesessions);
				//closeview_selected_sessions_view();
				if(($("#sessions_web_more").is(":visible")))
				{
					tooltip_Des("#sessions_web_more .Field_session .asession_browser");//No I18N
					tooltip_Des("#sessions_web_more .Field_session .asession_os");//No I18N
					removeButtonDisable($("#sessions_web_more .aw_info"));
					$("#sessions_web_more").hide();
					$("#view_all_sessions").html("");
					show_all_sessions();
				
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

 function show_selected_session(id,device)
 {		$("#activesessions_pop").show(0,function(){
	 		$("#activesessions_pop").addClass("pop_anim");
 		});
		$("#activesessions_pop .device_name").html($("#activesession_entry"+id+" .device_name").html()); //load into popuop
		$("#activesessions_pop .device_time").html($("#activesession_entry"+id+" .device_time").html()); //load into popuop
		
		$("#activesessions_pop #sessions_current_info").html($("#activesession_info"+id).html()); //load into popuop
		$("#activesessions_pop #device_pic").removeAttr("class");
		$("#activesessions_pop #device_pic").addClass(device);
		
		popup_blurHandler('6','.5');
		closePopup(closeview_selected_sessions_view,"activesessions_pop");//No I18N
		
		if($("#activesessions_pop .primary_btn_check").length>0){
			$("#activesessions_pop .primary_btn_check").focus();
		}
		else{
			$("#activesessions_pop").focus();
		}
 }
 function closeview_selected_sessions_view()
 {
 	popupBlurHide('#activesessions_pop');  //No I18N
 }
 
 
function show_all_sessions()
{	
	tooltip_Des(".Field_session .asession_browser");//No I18N
	tooltip_Des(".Field_session .asession_os");//No I18N

	$("#view_all_sessions").html($("#all_sessions_active").html()); //load into popuop
	popup_blurHandler('6','.5');
	
	$("#view_all_sessions .activesession_entry_hidden").show();
	$("#view_all_sessions .authweb_entry").after( "<br />" );
	$("#view_all_sessions .authweb_entry").addClass("viewall_authwebentry");
	$("#view_all_sessions .Field_session").removeAttr("onclick");
	$("#view_all_sessions .info_tab").show();
	//$("#view_all_sessions .asession_action").hide();
	
	$("#view_all_sessions .select_holder").show();
	
	$("#sessions_web_more").show(0,function(){
		$("#sessions_web_more").addClass("pop_anim");
	});
	
	
	
	$("#view_all_sessions .Field_session").click(function(){
		if($(event.target).parents().hasClass("select_holder")){
			return;
		}
		var id=$(this).attr('id');
		$("#view_all_sessions .Field_session").addClass("autoheight");
		$("#view_all_sessions .aw_info").slideUp("fast");
		$("#view_all_sessions .activesession_entry_info").show();
		if($("#view_all_sessions #"+id).hasClass("web_email_specific_popup"))
		{
			$(".aw_info a").unbind();
			$("#view_all_sessions #"+id+" .aw_info").slideUp("fast",function(){
				$("#view_all_sessions #"+id).removeClass("web_email_specific_popup");
				$("#view_all_sessions .Field_session").removeClass("autoheight");
			});
			$("#view_all_sessions .activesession_entry_info").show();
		}
		else
		{
			
			$("#view_all_sessions .Field_session").removeClass("Active_sessions_showall_hover_primary");
			$("#view_all_sessions .Field_session").removeClass("web_email_specific_popup");
			$("#view_all_sessions #"+id).addClass("web_email_specific_popup");
			$("#view_all_sessions #"+id+" .aw_info").slideDown("fast",function(){

				//$("#view_all_sessions #"+id+" .primary_btn_check").focus();

				control_Enter(".aw_info a"); //No I18N
				$("#view_all_sessions .Field_session").removeClass("autoheight");
				
			});
			$("#view_all_sessions #"+id+" .activesession_entry_info").hide();
		}
	});
	sessiontipSet(".Field_session .asession_browser");//No I18N
	sessiontipSet(".Field_session .asession_os");//No I18N
	closePopup(closeview_all_sessions_view,"sessions_web_more");//No I18N
	
	$("#sessions_web_more").focus();
}

function deleteTicket(t) 
{
  //  var url=contextpath+"/u/sessions";//No i18N

	if($("#sessions_web_more").is(":visible")){
		disabledButton($("#sessions_web_more .aw_info:visible"));	
	}
	else{
		disabledButton($("#sessions_current_info"));
	}
	new URI(ActiveSessionsObj,"self","self",t).DELETE().then(function(resp)	//No I18N
			{
				SuccessMsg(getErrorMessage(resp));
				delete sessions_data.activesessions[t];
				load_Sessionsdetails(sessions_data.Policies,sessions_data.activesessions);
				closeview_selected_sessions_view();				
				if(($("#sessions_web_more").is(":visible")))
				{
					
					tooltip_Des("#sessions_web_more .Field_session .asession_browser");//No I18N
					tooltip_Des("#sessions_web_more .Field_session .asession_os");//No I18N
					removeButtonDisable($("#sessions_web_more .aw_info"));
					$("#sessions_web_more").hide();
					$("#view_all_sessions").html("");
					show_all_sessions();

				}
				else{
					removeButtonDisable($("#sessions_current_info"));
				}
			},
			function(resp)
			{
				if($("#sessions_web_more").is(":visible")){
					removeButtonDisable($("#sessions_web_more .aw_info"));	
				}
				else{
					removeButtonDisable($("#sessions_current_info"));
				}
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

function deleteAllSessions() 
{
	new URI(ActiveSessionsObj,"self","self").DELETE().then(function(resp)	//No I18N
			{
				SuccessMsg(getErrorMessage(resp));
				var dataKeys = Object.keys(sessions_data.activesessions);
				for(var a=0; a<dataKeys.length; a++)
				{
					if(!sessions_data.activesessions[dataKeys[a]].is_current_session)
					{
						delete sessions_data.activesessions[dataKeys[a]];
					}
				}
				load_Sessionsdetails(sessions_data.Policies,sessions_data.activesessions);
				closeview_all_sessions_view();
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


function closeview_all_sessions_view()
{
	tooltip_Des("#sessions_web_more .Field_session .asession_browser");//No I18N
	tooltip_Des("#sessions_web_more .Field_session .asession_os");//No I18N
	popupBlurHide("#sessions_web_more",function(){	//No I18N
		$("#view_all_sessions").html("");		
	});
}










/***************************** Active Authtokens *********************************/


function load_Authtokensdetails(Policies,Auth_tokens)
{
	if(de("auth_tokens_exception"))
	{
		$("#auth_tokens_exception").remove();
		$("#authokens_nodata").removeClass("hide");
	}
	if(Auth_tokens.exception_occured!=undefined	&&	Auth_tokens.exception_occured)
	{
		$("#auth_tokens_box .box_info" ).after("<div id='auth_tokens_exception' class='box_content_div'>"+$("#exception_tab").html()+"</div>" );
		$("#auth_tokens_exception #reload_exception").attr("onclick","reload_exception(ActiveAuthtokens,'auth_tokens_box')");
		$("#authokens_nodata").addClass("hide");
		return;
	}

	if(Auth_tokens!=undefined && !jQuery.isEmptyObject(Auth_tokens))
	{
		$("#authokens_nodata").hide();
		$("#all_set_api_tokens").show();
		
		var tokens=timeSorting(Auth_tokens);
		$("#all_set_api_tokens").html("");
		var count =0;
		for(iter=0;iter<Object.keys(tokens).length;iter++)
		{
			count++;
			var current_apitoken=Auth_tokens[tokens[iter]];
			apitoken_format = $("#empty_apitoken_format").html();
			$("#all_set_api_tokens").append(apitoken_format);
			
			$("#all_set_api_tokens #api_token").attr("id","api_token"+count);
			$("#all_set_api_tokens #select_apitoken_").attr("id","select_apitoken_"+count);
			$("#all_set_api_tokens #apitoken_info").attr("id","apitoken_info"+count);
			if(count > 3)
			{
				$("#api_token"+count).addClass("authweb_entry_hidden");  
			}
			var name;
			if(current_apitoken.authtoken_name.indexOf(" ")!=-1)
			{
				var temp_name=current_apitoken.authtoken_name.split(" ");
				name=(temp_name[0][0]+temp_name[1][0]).toUpperCase();
			}
			else
			{
				name=(current_apitoken.authtoken_name).substring(0,2).toUpperCase();
			}

			if(de("select_apitoken_"+count))
			{
				$("#select_apitoken_"+count+" .checkbox_check").attr("id",tokens[iter]);
			}
			$("#api_token"+count).attr("onclick","show_removeapitoken("+count+");");
			$("#api_token"+count+" .info_tab .email_dp").addClass(color_classes[gen_random_value()]);
		    $("#api_token"+count+" .info_tab .email_dp").html(name);
		    $("#api_token"+count+" .info_tab .authtoken_name").html(current_apitoken.authtoken_name);
		    if(current_apitoken.authtoken_name!=current_apitoken.authtoken_ticket)
		    {
		    	$("#apitoken_info"+count+" #pop_up_name").html(current_apitoken.authtoken_name);
		    }
		    else
		    {
		    	$("#apitoken_info"+count+" #authoken_name").remove();
		    }
		    $("#api_token"+count+" .info_tab .authtoken_time").html(current_apitoken.created_time_elapsed);
		    $("#apitoken_info"+count+" #pop_up_generatedtime").html(current_apitoken.created_time_formated);
		    $("#apitoken_info"+count+" #pop_up_lasttime").html(current_apitoken.last_accesed_time);
		    $("#apitoken_info"+count+" #pop_up_scope").html(current_apitoken.authtoken_scope);
		    $("#apitoken_info"+count+" #token_view").attr("id","token_view_"+count);
		    $("#apitoken_info"+count+" #token_hide").attr("id","token_hide_"+count);
		    $("#apitoken_info"+count+" #token_hide_"+count+" .blue").attr("onclick","token_hide('"+count+"')"); 
		    $("#apitoken_info"+count+" #token_view_"+count+" .blue").attr("onclick","show_token_full('"+count+"','"+tokens[iter]+"')"); 
		    $("#apitoken_info"+count+" #pop_up_ticket").html(current_apitoken.authtoken_ticket);

		    if(current_apitoken.location!=undefined)
			{
				$("#api_token"+count+" .asession_location").removeClass("location_unavail");
				$("#api_token"+count+" .asession_location").html(current_apitoken.location);
				$("#apitoken_info"+count+" #pop_up_location").removeClass("unavail");
				$("#apitoken_info"+count+" #pop_up_location").html(current_apitoken.location);
			}
		    
		    if(current_apitoken.last_accessed_ip!=undefined && current_apitoken.last_accessed_device!=undefined)
		    {
		    	$("#apitoken_info"+count+" #pop_up_lastIP").html(current_apitoken.last_accessed_ip);
		    	$("#apitoken_info"+count+" #pop_up_last_device").html(current_apitoken.last_accessed_device);
		    }
		    else
		    {
		    	$("#apitoken_info"+count+" #usage_exist").hide();
		    }
		    $("#apitoken_info"+count+" #authoken_remove").attr("onclick","deleteToken('"+tokens[iter]+"');");


		}
		if(count>3)
		{
			$("#api_token_viewall").show();
		}
	}
	else
	{
		$("#authokens_nodata").show();
		$("#all_set_api_tokens").hide();
		$("#api_token_viewall").hide();
	}
}

function display_removeselected_apitokens()
{
	var selected = [];
	$('#view_api_tokens_remove input:checked').each(function() {
	    selected.push($(this).attr('id'));
	});
	if(selected.length > 0)
	{
		$("#deleted_selected_apitokens").show();
		if(isMobile){
			$(".delete_all_space .red_btn").hide();
		}
	}
	else
	{
		$("#deleted_selected_apitokens").hide();
		if(isMobile){
			$(".delete_all_space .red_btn").show();
		}
	}
}

function deleteAlltokens() 
{
	new URI(ActiveAuthtokensObj,"self","self").DELETE().then(function(resp)	//No I18N
			{
				SuccessMsg(getErrorMessage(resp));
				var dataKeys = Object.keys(sessions_data.authtokens);
				for(var a=0; a<dataKeys.length; a++)
				{
					delete sessions_data.authtokens[dataKeys[a]];
				}
				load_Authtokensdetails(sessions_data.Policies,sessions_data.authtokens);
				closeview_all_apitokens_acc();
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

function deleteSelectedAuthtokens()
{
	var selected = [];
	$('#view_api_tokens_remove input:checked').each(function() {
	    selected.push($(this).attr('id'));
	});
	
	new URI(ActiveAuthtokensObj,"self","self",selected).DELETE().then(function(resp)	//No I18N
			{
				SuccessMsg(getErrorMessage(resp));
				for(i=0;i<selected.length;i++)
				{
					delete sessions_data.authtokens[selected[i]];
				}				
				load_Authtokensdetails(sessions_data.Policies,sessions_data.authtokens);
				close_apitoken_screen();
				$("#deleted_selected_apitokens").hide();
				if(($("#api_tokens_more").is(":visible")))
				{
					var lenn=Object.keys(sessions_data.authtokens).length;
					if(lenn>0)
					{
						show_all_apitokens();
					}
					else
					{
						closeview_all_apitokens_acc();
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

function close_apitoken_screen()
{
	popupBlurHide("#popup_active-authtokens_contents",function(){		//No I18N
		$("#apitoken_popup_head").html(""); 
		$("#apitoken_popup_info").html(""); 
	});

	
}


function show_token_full(count,token)
{
	new URI(ActiveAuthtokensObj,"self","self",token).GET().then(function(resp)	//No I18N
			{
				if($("#api_tokens_more").is(":visible")){
					$("#api_tokens_more #token_view_"+count).hide();
					$("#api_tokens_more #token_hide_"+count+" #pop_up_clear_ticket").html(resp.clear_token);
					$("#api_tokens_more #token_hide_"+count).css("display","inline-block");
				}
				else{
					$("#popup_active-authtokens_contents #token_view_"+count).hide();
					$("#popup_active-authtokens_contents #token_hide_"+count+" #pop_up_clear_ticket").html(resp.clear_token);
					$("#popup_active-authtokens_contents #token_hide_"+count).css("display","inline-block");
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

function token_hide(count)
{
	if($("#api_tokens_more").is(":visible")){
		$("#api_tokens_more #token_view_"+count).show();
		$("#api_tokens_more #token_hide_"+count).hide();
		$("#api_tokens_more #token_hide_"+count+" #pop_up_clear_ticket").html("");
	}
	else{
		$("#popup_active-authtokens_contents #token_view_"+count).show();
		$("#popup_active-authtokens_contents #token_hide_"+count).hide();
		$("#popup_active-authtokens_contents #token_hide_"+count+" #pop_up_clear_ticket").html("");
	}
	
}

function show_removeapitoken(id)
{
	
	$("#popup_active-authtokens_contents #apitoken_popup_head").html($("#api_token"+id+" .authtoken_div").html()); //load into popuop
	$("#popup_active-authtokens_contents #apitoken_popup_info").html($("#apitoken_info"+id).html()); //load into popuop
	popup_blurHandler('6','.5');

	$("#popup_active-authtokens_contents").show(0,function(){
		$("#popup_active-authtokens_contents").addClass("pop_anim");
	});
	closePopup(close_apitoken_screen,"popup_active-authtokens_contents");//No I18N
	$("#popup_active-authtokens_contents #authoken_remove").focus();
}

function deleteToken(token) 
{    
	if($("#api_tokens_more").is(":visible")){
		disabledButton($("#api_tokens_more .aw_info:visible"));	
	}
	else{
		disabledButton($("#apitoken_popup_info"));
	}
	new URI(ActiveAuthtokensObj,"self","self",token).DELETE().then(function(resp)	//No I18N
			{
				SuccessMsg(getErrorMessage(resp));
				delete sessions_data.authtokens[token];
				load_Authtokensdetails(sessions_data.Policies,sessions_data.authtokens);
				close_apitoken_screen();
				if($("#api_tokens_more").is(":visible"))
				{
					var lenn=Object.keys(sessions_data.authtokens).length;
					if(lenn>0){
						$("#api_tokens_more").hide();
						$("#view_api_tokens_remove").html("");
						$("#api_tokens_more .select_holder").hide();
						show_all_apitokens();
					}
					else{
						$(".blur").css({"z-index":"6","opacity":".5"});
						closeview_all_apitokens_acc();
					}
					removeButtonDisable($("#api_tokens_more .aw_info"));
				}
				else{
					removeButtonDisable($("#apitoken_popup_info"));	
				}

			},
			function(resp)
			{
				if($("#api_tokens_more").is(":visible"))
				{
					removeButtonDisable($("#api_tokens_more .aw_info"));
				}
				else{
					removeButtonDisable($("#apitoken_popup_info"));
				}
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


function closeview_all_apitokens_acc()
{
	$(".blur").css("opacity","0");
	popupBlurHide("#api_tokens_more",function(){ //No I18N 
		$("#view_api_tokens_remove").html("");
		$("#api_tokens_more .select_holder").hide();
	});
}

function show_all_apitokens()
{
	$("#view_api_tokens_remove").html($("#all_set_api_tokens").html()); //load into popuop

	
	popup_blurHandler('6','.5');
	
	$("#view_api_tokens_remove .authweb_entry_hidden").show();
	//$("#view_api_tokens_remove .Field_session").after( "<br />" );
	$("#view_api_tokens_remove .Field_session").removeAttr("onclick");
	
	
	
	$("#api_tokens_more").show(0,function(){
		$("#api_tokens_more").addClass("pop_anim");
	});
	
	
	
	$("#view_api_tokens_remove .Field_session").click(function(){
		if($(event.target).parents().hasClass("select_holder")){
			return;
		}
		if($(event.target).parents().hasClass("authtoken_container")||$(event.target).hasClass("authtoken_container")){	
			return;
		}
		var id=$(this).attr('id');
		$("#view_api_tokens_remove .Field_session").addClass("autoheight");
		$("#view_api_tokens_remove .aw_info").slideUp("fast");
		$("#view_api_tokens_remove .activesession_entry_info").show();
		if($("#view_api_tokens_remove #"+id).hasClass("web_email_specific_popup"))
		{
			$(".aw info a").unbind();
			$("#view_api_tokens_remove #"+id+" .aw_info").slideUp("fast",function(){
				$("#view_api_tokens_remove #"+id).removeClass("web_email_specific_popup");
				$("#view_api_tokens_remove .Field_session").removeClass("autoheight");
			});
		}
		else
		{
			$("#view_api_tokens_remove .Field_session").removeClass("web_email_specific_popup");		
			$("#view_api_tokens_remove #"+id).addClass("web_email_specific_popup");
			$("#view_api_tokens_remove #"+id+" .activesession_entry_info").hide();		
			$("#view_api_tokens_remove #"+id+" .aw_info").slideDown("fast",function(){
				control_Enter(".aw_info a") //No I18N
				$("#view_api_tokens_remove .Field_session").removeClass("autoheight");
			});
			
		
		}
		
		
	});
	$("#api_tokens_more .select_holder").show();
	closePopup(closeview_all_apitokens_acc,"api_tokens_more");//No I18N
	
	$("#api_tokens_more").focus();
	
	
}



/***************************** Active HISTORY *********************************/

function load_History()
{
	if(de("history_exception"))
	{
		$("#history_exception").remove();
		$("#history_screen").removeClass("hide");
	}
	if(history_data.exception_occured!=undefined	&&	history_data.exception_occured)
	{
		$("#history_box .box_info" ).after("<div id='history_exception' class='box_content_div'>"+$("#exception_tab").html()+"</div>" );
		$("#history_exception #reload_exception").attr("onclick","show_history()");
		$("#history_screen").addClass("hide");
		return;
	}

	if(history_data!=undefined && !jQuery.isEmptyObject(history_data))
	{
		$("#history_screen").hide();
		$("#history_space").show();
		var history=timeSorting(history_data, true);
		$("#history_space").html("");
		var count =0;
		for(iter=0;iter<Object.keys(history).length;iter++)
		{
			count++;
			var current_history=history_data[history[iter]];
			apitoken_format = $("#empty_histroy_format").html();
			$("#history_space").append(apitoken_format);
			$("#history_space #activehistory_entry").attr("id","activehistory_entry"+count);
			$("#history_space #activehistory_info").attr("id","activehistory_info"+count);
			if(count > 3)
			{
				$("#activehistory_entry"+count).addClass("activesession_entry_hidden");  
			}
			$("#activehistory_entry"+count).attr("onclick","show_selected_history("+count+");");
			$("#activehistory_entry"+count+" .history_div .product_icon").addClass("icon_"+current_history.service_name.toLowerCase().replace(/\s/g, ''));
			$("#activehistory_entry"+count+" .history_div .authtoken_name").html(current_history.service_name);
			$("#activehistory_entry"+count+" .history_div .authtoken_time").html(current_history.created_time_elapsed);
			var device_class="device_"+(current_history.device_info.device_img).toLowerCase().replace(/\s/g, '');//No I18N
			
			$("#activehistory_entry"+count+" .activesession_entry_info .history_device").addClass(device_class+"_20px");
			$("#activehistory_entry"+count+" .activesession_entry_info .history_device").attr("title",current_history.device_info.device_name);
			var os_class=(current_history.device_info.os_img);
			$("#activehistory_entry"+count+" .activesession_entry_info .asession_os").addClass("os_"+os_class);
			if(current_history.device_info.version==undefined){
				$("#activehistory_entry"+count+" .activesession_entry_info .asession_os").attr("title",current_history.device_info.os_name);
				$("#activehistory_info"+count+" #pop_up_os").append(current_history.device_info.os_name);

			}
			else{
				$("#activehistory_entry"+count+" .activesession_entry_info .asession_os").attr("title",current_history.device_info.os_name+" "+current_history.device_info.version);
				$("#activehistory_info"+count+" #pop_up_os").append(current_history.device_info.os_name+" "+current_history.device_info.version);
			}
			var browser_class=(current_history.browser_info.browser_image).toLowerCase().replace(/\s/g, '');

			$("#activehistory_entry"+count+" .activesession_entry_info .asession_browser").addClass("browser_"+browser_class);
			if(current_history.location!=undefined)
			{
				$("#activehistory_entry"+count+" .asession_location").removeClass("location_unavail");
				$("#activehistory_entry"+count+" .asession_location").html(current_history.location);
				$("#activehistory_entry"+count+" #pop_up_location").removeClass("unavail");
				$("#activehistory_entry"+count+" #pop_up_location").html(current_history.location);
			}
			$("#activehistory_info"+count+" #pop_up_time").html(current_history.created_time_formated);
			if(current_history.logout_date!=undefined)
			{
				$("#activehistory_info"+count+" #pop_up_logout_time").html(current_history.logout_date);
			}
			else
			{
				$("#activehistory_info"+count+" #history_logout_time").remove();
			}
			$("#activehistory_info"+count+" #pop_up_os .asession_os_popup").addClass("minios_"+os_class);

			if(current_history.browser_info.version==undefined){
				$("#activehistory_entry"+count+" .activesession_entry_info .asession_browser").attr("title",current_history.browser_info.browser_name);
				$("#activehistory_info"+count+" #pop_up_browser").append(current_history.browser_info.browser_name);				
			}
			else{
				$("#activehistory_entry"+count+" .activesession_entry_info .asession_browser").attr("title",current_history.browser_info.browser_name+" "+current_history.browser_info.version);
				$("#activehistory_info"+count+" #pop_up_browser").append(current_history.browser_info.browser_name+" "+current_history.browser_info.version);				
			}
			$("#activehistory_info"+count+" #pop_up_browser .asession_browser_popup").addClass("minibrowser_"+browser_class);
			$("#activehistory_info"+count+" #pop_refer").html(current_history.referrer);
			$("#activehistory_info"+count+" #pop_up_device .asession_device_popup").addClass(device_class+"_20px");
			$("#activehistory_info"+count+" #pop_up_device").append(current_history.device_info.device_name);
			
		}
		sessiontipSet("#history_space .Field_session .history_device");//No I18N
		sessiontipSet("#history_space .Field_session .asession_browser");//No I18N
		sessiontipSet("#history_space .Field_session .asession_os");//No I18N
		if(count>3)
		{
			$("#history_showall").show();
		}
	}
	else
	{
		$("#history_screen").show();
		$("#history_space").hide();
		$("#history_showall").hide();
	}
}

function show_selected_history(id)
{

		$("#popup_active-history_contents #history_popup_head").html($("#activehistory_entry"+id+" .history_div").html()); //load into popuop
		$("#popup_active-history_contents #history_popup_info").html($("#activehistory_info"+id).html()); //load into popuop
		
		popup_blurHandler('6','.5');
		$("#popup_active-history_contents").show(0,function(){
			$("#popup_active-history_contents").addClass("pop_anim");
		});
		
		closePopup(close_selected_history_screen,"popup_active-history_contents");//No I18N
		$("#popup_active-history_contents").focus();
}



function show_history()
{
	$("#history_box .box_blur").show();
	$("#history_box .loader").show();

	
	
	new URI(User,"self","self").include(LoginHistory).GET().then(function(resp)	//No I18N
			{
				history_data=resp.User.LoginHistory;
				load_History();
				$("#history_box .box_blur").hide();
				$("#history_box .loader").hide();
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
				$("#history_box .box_blur").hide();
				$("#history_box .loader").hide();
			});


}

function close_selected_history_screen()
{		
	popupBlurHide("#popup_active-history_contents",function(){	//No I18N
			$("#history_popup_head").html(""); 
			$("#history_popup_info").html(""); 
	});
}


function closeview_all_activeHistoy_acc()
{
	tooltip_Des("#history_web_more .Field_session .history_device");//No I18N
	tooltip_Des("#history_web_more .Field_session .asession_browser");//No I18N
	tooltip_Des("#history_web_more .Field_session .asession_os");//No I18N

	popupBlurHide("#history_web_more",function(){	//No I18N
		$("#view_all_activeHistory").html("");
	});
}

function show_all_activehistory()
{	
	tooltip_Des(".Field_session .history_device");//No I18N
	tooltip_Des(".Field_session .asession_browser");//No I18N
	tooltip_Des(".Field_session .asession_os");//No I18N
	$("#view_all_activeHistory").html($("#history_space").html()); //load into popuop
	popup_blurHandler('6','.5');
	
	$("#view_all_activeHistory .activesession_entry_hidden").show();
	//$("#view_all_activeHistory .Field_session").after( "<br />" );
	$("#view_all_activeHistory .Field_session").removeAttr("onclick");
	
	
	
	$("#history_web_more").show(0,function(){
		$("#history_web_more").addClass("pop_anim");
	});
	
	
	
	$("#view_all_activeHistory .Field_session").click(function(){
	
		var id=$(this).attr('id');
		$("#view_all_activeHistory .Field_session").addClass("autoheight");
		$("#view_all_activeHistory .aw_info").slideUp("fast");
		$("#view_all_activeHistory .activesession_entry_info").show();
		if($("#view_all_activeHistory #"+id).hasClass("web_email_specific_popup"))
		{
			$("#view_all_activeHistory #"+id+" .aw_info").slideUp("fast",function(){
				$("#view_all_activeHistory #"+id).removeClass("web_email_specific_popup");
				$("#view_all_activeHistory .Field_session").removeClass("autoheight");
			});
			$("#view_all_activeHistory .activesession_entry_info").show();
		}
		else
		{
			$("#view_all_activeHistory .Field_session").removeClass("web_email_specific_popup");
			$("#view_all_activeHistory #"+id).addClass("web_email_specific_popup");
			$("#view_all_activeHistory #"+id+" .aw_info").slideDown("fast",function(){
				$("#view_all_activeHistory .Field_session").removeClass("autoheight");
			});
			$("#view_all_activeHistory #"+id+" .activesession_entry_info").hide();
		}
	});
	
	sessiontipSet(".Field_session .history_device");//No I18N
	sessiontipSet(".Field_session .asession_browser");//No I18N
	sessiontipSet(".Field_session .asession_os");//No I18N
	closePopup(closeview_all_activeHistoy_acc,"history_web_more");//No I18N
	$("#history_web_more").focus();
	
}


/***************************** Connected Apps *********************************/

function load_connected_apps_details(Policies,connected_apps_details)
{
	if(jQuery.isEmptyObject(connected_apps_details))
	{
		$("#no_connected_apps").show();
		$("#display_connected_apps").hide();
		return;
	}
	if(de("Connected_apps_exception"))
	{
		$("#Connected_apps_exception").remove();
	}
	if(connected_apps_details.exception_occured!=undefined	&&	connected_apps_details.exception_occured)
	{
		$("#Connected_apps_box .box_info" ).after("<div id='Connected_apps_exception' class='box_content_div'>"+$("#exception_tab").html()+"</div>" );
		$("#Connected_apps_exception #reload_exception").attr("onclick","reload_exception(Connected_apps,'Connected_apps_box')");
		return;
	}

	$("#no_connected_apps").hide();
	$("#display_connected_apps").show();
	$("#display_connected_apps").html("");
	var count=0;
	var apps=Object.keys(connected_apps_details);
	for(iter=0;iter<apps.length;iter++)
	{
		count++;
		var current_app=connected_apps_details[apps[iter]];
		
		connected_apps_format = $("#empty_connected_apps_format").html();
		$("#display_connected_apps").append(connected_apps_format);
		
		$("#display_connected_apps #connected_apps_entry").attr("id","connected_apps_entry"+count);
		$("#display_connected_apps #connected_apps_info").attr("id","connected_apps_info"+count);
		
		
		$("#connected_apps_entry"+count).attr("onclick","show_selected_connected_apps_info("+count+");");
		
		if(count > 3)
		{
			$("#connected_apps_entry"+count).addClass("allowed_ip_entry_hidden");  
		}
		
		$("#connected_apps_entry"+count+" .device_name").html(current_app.client_name);
		$("#connected_apps_entry"+count+" .device_time").html(current_app.created_time_elapsed);
		$("#connected_apps_entry"+count+" .device_pic").addClass(color_classes[gen_random_value()]);
		if(current_app.client_name.indexOf(" ")==-1)
		{
			$("#connected_apps_entry"+count+" .device_pic").html(current_app.client_name.substr(0,2).toUpperCase());
		}
		else
		{
			var name=current_app.client_name.split(" ");
			$("#connected_apps_entry"+count+" .device_pic").html((name[0][0]+name[1][0]).toUpperCase());
		}
		if(current_app.location!=undefined)
		{
			$("#connected_apps_entry"+count+" .asession_location").removeClass("location_unavail");
			$("#connected_apps_entry"+count+" .asession_location").html(current_app.location);
			$("#connected_apps_info"+count+" #pop_up_location").removeClass("unavail");
			$("#connected_apps_info"+count+" #pop_up_location").html(current_app.location);
		}
		$("#connected_apps_info"+count+" #pop_up_time").html(current_app.created_date);
		$("#connected_apps_info"+count+" #pop_up_ip").html(current_app.ip_address);
		
		$("#connected_apps_info"+count+" #delete_current_app").attr("onclick","deleteApp('"+current_app.client_zid+"','"+iter+"')");
	}
	if(count>3)
	{
		$("#connected_apps_view").show();
	}
	else{
		$("#connected_apps_view").hide();
	}

}



function deleteApp(client_zid,index)
{
	
	new URI(ConnectedAppsOBJ,"self","self",client_zid).DELETE().then(function(resp)	//No I18N
			{
				SuccessMsg(getErrorMessage(resp));
				delete sessions_data.connectedapps[index];
				
				load_connected_apps_details(sessions_data.Policies,sessions_data.connectedapps);	
				
				
				closeview_selected_connected_apps_view();
				if($("#connected_apps_web_more").is(":visible")==true)
				{
					var lenn=Object.keys(sessions_data.connectedapps).length;
					if(lenn > 1)
					{
						$("#view_all_connected_apps").html("");
						show_all_connnected_apps();
					}
					else{
						closeview_connected_apps_view();
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


function show_selected_connected_apps_info(id)
{
	$("#Connected_apps_pop .device_pic").addClass($("#connected_apps_entry"+id+" .device_pic")[0].className);
	$("#Connected_apps_pop .device_pic").html($("#connected_apps_entry"+id+" .device_pic").html());
	$("#Connected_apps_pop .device_name").html($("#connected_apps_entry"+id+" .device_name").html()); //load into popuop
	$("#Connected_apps_pop .device_time").html($("#connected_apps_entry"+id+" .device_time").html()); //load into popuop
	
	$("#Connected_apps_pop #connected_app_current_info").html($("#connected_apps_info"+id).html()); //load into popuop
	
	
	
	
	popup_blurHandler('6','.5');
	$("#Connected_apps_pop").show(0,function(){
		$("#Connected_apps_pop").addClass("pop_anim");
	});
	$("#delete_current_app").focus();
	closePopup(closeview_selected_connected_apps_view,"Connected_apps_pop"); //No I18N
}


function closeview_selected_connected_apps_view()
{
	popupBlurHide("#Connected_apps_pop");	//No I18N
}



function show_all_connnected_apps()
{
	$("#view_all_connected_apps").html($("#display_connected_apps").html()); //load into popuop
	popup_blurHandler('6','.5');
	
	$("#view_all_connected_apps .allowed_ip_entry_hidden").show();
	//$("#view_all_app_pass .authweb_entry").after( "<br />" );
	//$("#view_all_app_pass .authweb_entry").addClass("viewall_authwebentry");
	$("#view_all_connected_apps .Field_session").removeAttr("onclick");
	$("#view_all_connected_apps .info_tab").show();

//	$("#view_all_allow_ip .asession_action").hide();

	//$("#view_all_allow_ip .asession_action").hide();

	
	$("#connected_apps_web_more").show(0,function(){
		$("#connected_apps_web_more").addClass("pop_anim");
	});
	
	
	
	$("#view_all_connected_apps .Field_session").click(function(){
		if($(event.target).parents().hasClass("select_holder")){
			return;
		}

		var id=$(this).attr('id');
		$("#view_all_connected_apps .Field_session").addClass("autoheight");
		$("#view_all_connected_apps .aw_info").slideUp(300);
		$("#view_all_connected_apps .activesession_entry_info").show();
		if($("#view_all_connected_apps #"+id).hasClass("Active_ip_showall_hover"))
		{
	
			$("#view_all_connected_apps #"+id+" .aw_info").slideUp("fast",function(){
				$("#view_all_connected_apps #"+id).removeClass("Active_ip_showall_hover");
				$("#view_all_connected_apps .Field_session").removeClass("autoheight");
			});
			$("#view_all_connected_apps .activesession_entry_info").show();
		}
		else
		{
			$("#view_all_connected_apps .Field_session").removeClass("Active_ip_showall_hover");
			$("#view_all_connected_apps .Field_session").removeClass("Active_ip_showcurrent");
			$("#view_all_connected_apps #"+id).addClass("Active_ip_showall_hover");
			$("#view_all_connected_apps #"+id+" .aw_info").slideDown(300,function(){
				$("#view_all_connected_apps .Field_session").removeClass("autoheight");
			});
			$("#view_all_connected_apps #"+id+" .activesession_entry_info").hide();
	//		$("#view_all_allow_ip #"+id+" .primary_btn_check").focus();
		}
		
	});
	$("#connected_apps_web_more .select_holder").show();
	control_Enter("a");//No I18N
	closePopup(closeview_connected_apps_view,"connected_apps_web_more");//No I18N
	
	$("#connected_apps_web_more").focus();
}


function closeview_connected_apps_view()
{
	$(".aw_info a").unbind();	
	popupBlurHide("#connected_apps_web_more",function(){	//No I18N
		$("#connected_apps_web_more .select_holder").hide();
		$("#view_all_connected_apps").html("");
	});
}





/***************************** APP LOGINS *********************************/

function load_App_Logins_details(Policies,App_logins_details)
{
	if(de("App_logins_exception"))
	{
		$("#App_logins_exception").remove();
	}
	if(App_logins_details.exception_occured!=undefined	&&	App_logins_details.exception_occured)
	{
		$("#App_logins_box .box_info" ).after("<div id='App_logins_exception' class='box_content_div'>"+$("#exception_tab").html()+"</div>" );
		$("#App_logins_exception #reload_exception").attr("onclick","reload_exception(App_logins,'App_logins_box')");
		return;
	}
	if(jQuery.isEmptyObject(App_logins_details))
	{
		$("#no_App_logins").show();
		$("#display_App_logins").hide();
	}
	else
	{
		$("#no_App_logins").hide();
		$("#display_App_logins").show();
		$("#display_App_logins").html("");
		var count=0;
		var product=Object.keys(App_logins_details);
		for(iter=0;iter<product.length;iter++)
		{
			count++;
			var current_app=App_logins_details[product[iter]];
			
			App_logins_format = $("#empty_App_logins_format").html();
			
			$("#display_App_logins").append(App_logins_format);
			
			$("#display_App_logins #App_logins_entry").attr("id","App_logins_entry"+count);
			$("#display_App_logins #App_logins_info").attr("id","App_logins_info"+count);
			$("#App_logins_entry"+count).attr("onclick","show_selected_applogins_info("+count+");");
			
			$("#App_logins_entry"+count+" .device_name").html(product[iter]);
			$("#App_logins_entry"+count+" .device_pic").addClass("icon_"+product[iter].toLowerCase().replace(/\s/g, ''));//No I18N

			
			if(App_logins_details[product[iter]].length==1)
			{
				if(App_logins_details[product[iter]][0].device_name!="")
				{
					$("#App_logins_entry"+count+" .device_time").html(App_logins_details[product[iter]][0].device_info.device_name);
				}
				else
				{
					$("#App_logins_entry"+count+" .device_time").html(unamed_device);
				}
				if(App_logins_details[product[iter]][0].location!=undefined)
				{
					$("#App_logins_entry"+count+" .asession_location").html(App_logins_details[product[iter]][0].location);
				}
				
			}
			else
			{
				$("#App_logins_entry"+count+" .device_time").html(App_logins_details[product[iter]].length+" "+Devices);
				$("#App_logins_entry"+count+" .asession_location").html(App_logins_details[product[iter]].length+" "+Locations);
			}
			if(count > 3)
			{
				$("#App_logins_entry"+count).addClass("allowed_ip_entry_hidden");  
			}
			var devices_count=0;
			for(devices_iter=0;devices_iter<App_logins_details[product[iter]].length;devices_iter++)
			{
				devices_count++;
				var current_device=App_logins_details[product[iter]][devices_iter];
				
				Device__format = $("#empty_Devices_format").html();
				$("#display_App_logins #App_logins_info"+count).append(Device__format);
				$("#display_App_logins #App_logins_info"+count+" #Devices_entry").attr("id","Devices_entry"+devices_count);
				
				if(current_device.device_info.device_name!=""	&&	current_device.device_info.device_name!=undefined)
				{
					$("#App_logins_info"+count+" #Devices_entry"+devices_count+" .device_name").html(current_device.device_info.device_name);
				}
				else
				{
					$("#App_logins_info"+count+" #Devices_entry"+devices_count+" .device_name").html(unamed_device);
				}
				
				if(current_device.device_info.device_model!=""	&&	current_device.device_info.device_model!=undefined)
				{
					$("#App_logins_info"+count+" #Devices_entry"+devices_count+" .device_model").html(current_device.device_info.device_model);
					$("#App_logins_info"+count+" #Devices_entry"+devices_count+" .device_pic").addClass("device_"+current_device.device_info.device_img);
				}
				else
				{
					$("#App_logins_info"+count+" #Devices_entry"+devices_count+" .device_model").html(unknown_device);
					$("#App_logins_info"+count+" #Devices_entry"+devices_count+" .device_pic").addClass("mail_client_logo");
					$("#App_logins_info"+count+" #Devices_entry"+devices_count+" .device_pic").html(unknown_device.substr(0,2).toUpperCase());
					$("#App_logins_info"+count+" #Devices_entry"+devices_count+" .device_pic").addClass(color_classes[gen_random_value()]);
				}
				$("#App_logins_info"+count+" #Devices_entry"+devices_count+" .device_time").html(current_device.created_time_elapsed);
				
				if(current_device.location!=undefined)
				{
					$("#App_logins_info"+count+" #Devices_entry"+devices_count+" .asession_location").html(current_device.location);
				}
				if(!current_device.device_info.is_primary)
				{
					$("#App_logins_info"+count+" #Devices_entry"+devices_count+" .deleteicon").attr("onclick","delete_current_device_entry("+count+","+devices_count+",\'"+product[iter]+"\',\'"+current_device.client_id+"\',\'"+current_device.refresh_token_hash+"\');");
					$("#App_logins_info"+count+" #Devices_entry"+devices_count+" #current_mfadevice").remove();
				}
				else
				{
					$("#App_logins_info"+count+" #Devices_entry"+devices_count+" .deleteicon").remove();
				}
				

				
			}
		}
		if(count>3)
		{
			$("#App_logins_viewmoew").show();
		}
	}
}



function show_selected_applogins_info(id)
{
	tooltip_Des("#App_logins_current_info .action_icon");//No I18N
	$("#App_logins_pop #product_img").removeClass();
//	$("#App_logins_pop .device_pic").attr("class","device_pic");
	$("#App_logins_pop #product_img").addClass($("#App_logins_entry"+id+" .device_pic:visible")[0].classList.value)
	$("#App_logins_pop .device_name").html($("#App_logins_entry"+id+" .device_name").html()); //load into popuop
	$("#App_logins_pop .device_time").html($("#App_logins_entry"+id+" .device_time").html()); //load into popuop
	
	$("#App_logins_pop #App_logins_current_info").html($("#App_logins_info"+id).html()); //load into popuop
	
	
	popup_blurHandler('6','.5');
	$("#App_logins_pop").show(0,function(){
		$("#App_logins_pop").addClass("pop_anim");
	});
	tooltipSet("#App_logins_current_info .icon-delete");//No I18N
	closePopup(closeview_selected_App_logins_view,"App_logins_pop"); //No I18N
	$("#App_logins_pop").focus();
}


function closeview_selected_App_logins_view()
{
	popupBlurHide("#App_logins_pop");	//No I18N
}







function show_all_App_logins()
{
	$("#view_all_App_logins").html($("#display_App_logins").html()); //load into popuop
	popup_blurHandler('6','.5');
	
	$("#view_all_App_logins .allowed_ip_entry_hidden").show();
	//$("#view_all_app_pass .authweb_entry").after( "<br />" );
	//$("#view_all_app_pass .authweb_entry").addClass("viewall_authwebentry");
	$("#view_all_App_logins .devicelogins_entry").removeAttr("onclick");
	$("#view_all_App_logins .info_tab").show();

//	$("#view_all_allow_ip .asession_action").hide();

	//$("#view_all_allow_ip .asession_action").hide();

	
	$("#App_logins_web_more").show(0,function(){
		$("#App_logins_web_more").addClass("pop_anim");
	});
	
	
	
	$("#view_all_App_logins .devicelogins_entry").click(function(){
		
		var id=$(this).attr('id');
		tooltip_Des(".devicelogins_entry .aw_info .action_icon");//No I18N
		$("#view_all_App_logins .devicelogins_entry").addClass("autoheight");
		$("#view_all_App_logins .aw_info").slideUp(300);
		$("#view_all_App_logins .activesession_entry_info").show();
		if($("#view_all_App_logins #"+id).hasClass("Active_ip_showall_hover"))
		{

			$("#view_all_App_logins #"+id+" .aw_info").slideUp("fast",function(){
				$("#view_all_App_logins #"+id).removeClass("Active_ip_showall_hover");
				$("#view_all_App_logins .devicelogins_entry").removeClass("autoheight");
			});
			$("#view_all_App_logins .activesession_entry_info").show();
		}
		else
		{
			$("#view_all_App_logins .devicelogins_entry").removeClass("Active_ip_showall_hover");
			$("#view_all_App_logins .devicelogins_entry").removeClass("Active_ip_showcurrent");
			$("#view_all_App_logins #"+id).addClass("Active_ip_showall_hover");
			$("#view_all_App_logins #"+id+" .aw_info").slideDown(300,function(){
				$("#view_all_App_logins .devicelogins_entry").removeClass("autoheight");
				tooltipSet(".devicelogins_entry .aw_info .action_icon");//No I18N
			});
			$("#view_all_App_logins #"+id+" .activesession_entry_info").hide();
	//		$("#view_all_allow_ip #"+id+" .primary_btn_check").focus();
		}
		
	});
	closePopup(closeview_App_logins_view,"App_logins_web_more");//No I18N
	$("#App_logins_web_more").focus();
}


function closeview_App_logins_view()
{
	popupBlurHide("#App_logins_web_more",function(){		//No I18N
		$("#view_all_App_logins").html("");
	});
}


function delete_current_device_entry(parent_id,device_id,product_name,client_id,refresh_token_hash)
{
	new URI(Applogin_devices,"self","self",refresh_token_hash,client_id).DELETE().then(function(resp)	//No I18N
			{
				SuccessMsg(getErrorMessage(resp));
				var deleted=false;
				sessions_data.applogins[product_name].splice(device_id-1,1);
				
				if(sessions_data.applogins[product_name].length==0)
				{
					delete sessions_data.applogins[product_name];
					deleted=true;
				}
				
				load_App_Logins_details(sessions_data.Policies,sessions_data.applogins);
				
				if($("#App_logins_web_more").is(":visible")==true)
				{
					 $("#view_all_App_logins").html("");
					 show_all_App_logins();
					if(!deleted)
					{
						$("#view_all_App_logins #App_logins_entry"+parent_id).click();
					}
				}
				else
				{
					if(deleted)
					{
						if(sessions_data.applogins[product_name] == undefined){
							closeview_selected_App_logins_view();	
						}
					}
					else
					{
						$("#App_logins_current_info #Devices_entry"+device_id).remove();
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






