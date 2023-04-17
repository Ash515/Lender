//$Id$

function show_resetpassword_security()// not currently used
{
	//close_security_question();
	//close_password_change();
	//close_deleteaccount()
	if($("#popup_deleteaccount_close").is(":visible")){
		$("#popup_deleteaccount_close").removeClass("pop_anim");
		$("#popup_deleteaccount_close").fadeOut(200);
		$(".blue").unbind();
	}
	else if($("#popup_password_change").is(":visible")){
		$("#popup_password_change").removeClass("pop_anim");
		$("#popup_password_change").fadeOut(200,function(){
			$("#pass_esc_devices").hide();
		});
		remove_error();
		$("#passform").trigger('reset'); 
		$("#popup_password_change a").unbind();
	}
	else if($("#popup_security_question").is(":visible")){
		$("#popup_security_question").removeClass("pop_anim");
		$("#popup_security_question").fadeOut(200,function(){
			$("#sq_answer .textbox").val("");
			$("#custom_question_input").val("");
		});
	}
	setTimeout(show_resetpassword,250);
	$("#pop_action .primary_btn_check").focus();
	closePopup(close_popupscreen,"common_popup");//No I18N
}

/***************************** password change *********************************/



function load_passworddetails(policies,password_detail)
{
	if(de("password_exception"))
	{
		$("#password_exception").remove();
		$("#password_box .box_content_div").removeClass("hide");
	}
	if(password_detail.exception_occured!=undefined	&&	password_detail.exception_occured)
	{
		$( "#password_box .box_info" ).after("<div id='password_exception' class='box_content_div'>"+$("#exception_tab").html()+"</div>" );
		$("#password_exception #reload_exception").attr("onclick","reload_exception(PASSWORD,'password_box')");
		$("#password_box .box_content_div").addClass("hide");
		return;
	}

	if(!jQuery.isEmptyObject(password_detail))
	{
		$("#password_box .box_discrption").hide();
		$("#password_box .yes_data_text").hide();
		$("#password_box .no_data_text").hide();
		if(password_detail.password_exists!=undefined && !password_detail.password_exists)
		{
			$("#NO_password_def").show();
			$("#IDP_password").show();
			$("#change_passwordbutton").hide();
			$("#new_passwordbutton").css("display","block");
			$("#new_passwordbutton").attr("onclick", "goToForgotPwd()");
		}
		else if(password_detail.saml_user!=undefined && password_detail.saml_user) //org user using saml authentication and not super admin
		{
			$("#contact_superadmin_def").show();
			$("#contact_superadmin_msg").show();
			$("#change_passwordbutton").hide();
			$("#new_passwordbutton").hide();
		}
		else if(password_detail.PasswordInfo.passwordSyncURL!=undefined)
		{
			$("#password_def").show();
			$("#passwordSyncURL").show();
			$("#change_passwordbutton").removeClass("hide");
			$("#change_passwordbutton").attr("onclick","openInNewTab("+password_detail.PasswordInfo.passwordSyncURL+")");
		}
		else if(security_data.Password.PasswordPolicy.password_age_remaining!=undefined	&&	security_data.Password.PasswordPolicy.password_age_warning!=undefined)
		{
			$("#previous_modified_time").show();
			$("#password_def").hide();
			$("#password_time_sring").text(security_data.Password.PasswordPolicy.password_age_warning);
			$("#change_passwordbutton").hide();
			$("#new_passwordbutton").hide();
		}
		else
		{
			$("#previous_modified_time").show();
			$("#password_def").hide();
			if(password_detail.PasswordInfo.last_changed_time_millis!=-1)
			{
				$("#password_time_sring").text(password_last_modified+" "+password_detail.PasswordInfo.last_changed_time);
			}
			else
			{
				$("#password_time_sring").text(password_never_modified);
			}
//			else
//			{
//				$("#password_def").show();
//				$("#previous_modified_time").hide();
//	
//			}
			
			if(password_detail.PasswordPolicy!=undefined	&&	 (password_detail.PasswordPolicy.expiry_days!=undefined	&& 	password_detail.PasswordPolicy.expiry_days!=-1)	)
			{
				var str = null;
				if(password_detail.PasswordInfo.days_remaining > 1){
					str =$("#yes_pp").html();
					str=formatMessage(str,password_detail.PasswordInfo.org_name,(password_detail.PasswordPolicy.expiry_days).toString(),(password_detail.PasswordInfo.days_remaining).toString());
				} else {
					if(password_detail.PasswordInfo.days_remaining == 1) {
						str =$("#yes_pp_exp_one").html();
					} else {
						str = $("#yes_pp_exp").html();
					}
					str=formatMessage(str,password_detail.PasswordInfo.org_name,(password_detail.PasswordPolicy.expiry_days).toString());
				}
				$("#yes_pp").text(str);
				$("#yes_pp").show();
				$("#no_pp").hide();
				
			}
			else
			{
				$("#no_pp").show();
				$("#yes_pp").hide();
			}
			
			$("#change_passwordbutton").attr("onclick", "show_password_change_popup();");
			$("#change_passwordbutton").removeClass("hide");
			if(password_detail.PasswordPolicy!=undefined)
			{
				var policy=err_pp_start+" ";
				if(password_detail.PasswordPolicy.min_length > 0){
					if((password_detail.PasswordPolicy.mixed_case)||(password_detail.PasswordPolicy.min_spl_chars > 0)||(password_detail.PasswordPolicy.min_numeric_chars > 0)){
						policy+=formatMessage(err_pp_minnum,(password_detail.PasswordPolicy.min_length));       
					}
				    else{
				        policy+=formatMessage(err_pp_minnum_only,(password_detail.PasswordPolicy.min_length));
				    }
				}
				if(password_detail.PasswordPolicy.min_spl_chars > 0)
				{
					policy+=" "+formatMessage(err_pp_splchar,(password_detail.PasswordPolicy.min_spl_chars));
				}
				if(password_detail.PasswordPolicy.min_numeric_chars > 0)
				{
					policy+=", "+formatMessage(err_pp_numchar,(password_detail.PasswordPolicy.min_numeric_chars));
				}
				if(password_detail.PasswordPolicy.mixed_case)
				{
					policy+=", "+err_pp_cases;
				}
				$("#pass_policy").html(policy);
				$("#newPassword").attr("onkeyup","check_pp("+password_detail.PasswordPolicy.mixed_case+","+password_detail.PasswordPolicy.min_spl_chars+","+password_detail.PasswordPolicy.min_numeric_chars+","+password_detail.PasswordPolicy.min_length+")");
				$("#change_password_call").attr("onclick","changepassword(document.passform,"+password_detail.PasswordPolicy.min_length+","+password_detail.PasswordPolicy.max_length+",'"+security_data.login_name+"')");
			}
			
		}
		
	}
}





function check_pp(cases,spl,num,minlen)
{
	remove_error();
	if($("#new_password input").val()=="")
	{
		$(".pass_policy").show();
		$(".pass_policy_error").hide();
	}
	else
	{
		var err_str=err_pp_start+" ";
		
		var done= false;
		
		var pp_done=true;
		
		$(".pass_policy").hide();
		
		var str=$("#new_password input").val();
		
		if(str.length<minlen)
		{
			
			
			if(cases || (spl > 0) || (num > 0))
			{
				err_str+=formatMessage(err_pp_minnum, minlen.toString());
			}
			else
			{
				err_str+=formatMessage(err_pp_minnum_pp_no, minlen.toString());
				 pp_done=true;
			}
			done= false;
		}
		else
		{
			done= true;
		}
		
		if(spl > 0)
		{
			if(	(	(str.match(new RegExp("[^a-zA-Z0-9]","g")) || []).length	) < spl)
			{
					err_str+=" ";

					
				err_str+=formatMessage(err_pp_splchar, spl.toString());
				pp_done=false;
			}
			else if(pp_done)
			{
				pp_done= true;
			}
		}

		
		if(num > 0)
		{
			if(	(	(str.match(new RegExp("[0-9]","g")) || []).length	) < num)
			{
				if((str.length<minlen) ||	(	(	(str.match(new RegExp("[^a-zA-Z0-9]","g")) || []).length	) < spl) )
				{
					err_str+=", ";
				}
				else
				{
					err_str+=" ";
				}
				
				err_str+=formatMessage(err_pp_numchar, num.toString());
				pp_done=false;
			}
			else if(pp_done)
			{
				pp_done= true;
			}
		}


		if(cases)
		{
			if(!(		(new RegExp("[A-Z]","g").test(str))	&&	(new RegExp("[a-z]","g").test(str))		))
			{
				if((str.length<minlen) ||	(	(	(str.match(new RegExp("[^a-zA-Z0-9]","g")) || []).length	) < spl) || (	(	(str.match(new RegExp("[0-9]","g")) || []).length	) < num))
				{
					err_str+=", "+err_pp_cases, minlen;
				}
				else
				{
					err_str=iam_include+" "+err_pp_cases, minlen;
				}
				pp_done=false;
			}
			else if(pp_done)
			{
				pp_done= true;
			}
		}



		$(".pass_policy_error").show();
		$(".pass_policy_error").html(err_str);
		
		if((done) && (pp_done))
		{
			$(".pass_policy_error").hide();
		}
		else if((!done) && (pp_done))
		{
			err_str=err_pp_start+" "+formatMessage(err_pp_minnum_pp_no, minlen.toString());
			$(".pass_policy_error").html(err_str);
		}
		
		
	}
	
	
}
function show_password_change_popup()
{
	$("#popup_password_change").show(0,function(){
		$("#popup_password_change").addClass("pop_anim");
	});
	$("#popup_password_change .popuphead_details .popuphead_text").html($("#change_password_desc .heading").html());
	$("#popup_password_change .popuphead_details .popuphead_define").html($("#change_password_desc .description").html());
	$("#passform").show();
	$("#pass_esc_devices").hide();
	popup_blurHandler('6','.5');
	control_Enter("#popup_password_change a");//No i18N
	$("#popup_password_change input:first").focus();
	closePopup(close_password_change,"popup_password_change");//No I18N
}

function togglePass(ele){
	if($(ele).siblings("#newPassword").attr("type")=="password"){
		$(ele).siblings("#newPassword").attr("type","text");//No I18N
		$(ele).addClass("pass_hide");
	}	
	else{
		$(ele).siblings("#newPassword").attr("type","password"); //No I18N
		$(ele).removeClass("pass_hide");
	}
}

function close_password_change()
{
	popupBlurHide('#popup_password_change',function(){ //No I18N
		$("#pass_esc_devices").hide();
	});
	remove_error();
	$("#passform").trigger('reset'); 
	$("#popup_password_change a").unbind();
}

function changepassword(f,min_Len,max_Len,login_name) 
{
	remove_error();
    var currentpass = f.currentPass.value.trim();
    var newpass = f.newPassword.value.trim();
    var confirmpass = f.cpwd.value.trim();
    if(isEmpty(currentpass)) 
    {
    	$('#curr_password').append( '<div class="field_error">'+err_enter_currpass+'</div>' );
    	f.currentPass.value="";
    	f.currentPass.focus();
    } else 
    if(isEmpty(newpass)) 
    {
    	$('#new_password').append( '<div class="field_error">'+err_enter_newpass+'</div>' );
        f.newPassword.value="";
        f.cpwd.value="";
        f.newPassword.focus();
        $(".pass_policy").hide();
    	$(".pass_policy_error").hide();
    } else 
    if(newpass.length < min_Len) 
    {
    	$('#new_password').append( '<div class="field_error">'+formatMessage(err_pass_len, security_data.Password.PasswordPolicy.min_length)+'</div>' );
    	f.newPassword.value="";
    	f.cpwd.value="";
    	f.newPassword.focus();
    	$(".pass_policy").hide();
    	$(".pass_policy_error").hide();
    } else 
    if(newpass.length > max_Len) 
    {
    	$('#new_password').append( '<div class="field_error">'+formatMessage(err_password_maxlen, security_data.Password.PasswordPolicy.max_length)+'</div>' );
    	f.newPassword.value="";
    	f.cpwd.value="";
    	f.newPassword.focus();
    	$(".pass_policy").hide();
    	$(".pass_policy_error").hide();
    } else 
    if(newpass == login_name) 
    {
    	$('#new_password').append( '<div class="field_error">'+err_loginName_same+'</div>' );
    	f.newPassword.focus();
    	$(".pass_policy").hide();
    	$(".pass_policy_error").hide();
    } else 
    if(isEmpty(confirmpass) || newpass != confirmpass) 
    {
    	$('#new_repeat_password').append( '<div class="field_error">'+err_wrong_pass+'</div>' );
        f.cpwd.value="";
        f.cpwd.focus();
    }
    else if(validateForm(f))
    {
    		disabledButton(f);
    		var parms=
    		{
    			"currentPass":$('#'+f.id).find('input[name="currentPass"]').val(),//No I18N
    			"newPassword":$('#'+f.id).find('input[name="newPassword"]').val()//No I18N
    		};


    		var payload = Password.create(parms);
    		payload.PUT("self","self").then(function(resp)	//No I18N
    		{
    			SuccessMsg(getErrorMessage(resp));
    			//change the modified time
				security_data.Password.PasswordInfo.last_changed_time=resp.password.last_changed_time;
    			if(security_data.Password.PasswordInfo.org_name!==undefined)
    			{
    				security_data.Password.PasswordInfo.org_name=resp.password.org_name;
    				security_data.Password.PasswordInfo.days_remaining=resp.password.days_remaining;
    			}
    			load_passworddetails(security_data.Policies,security_data.Password);
       			changeToDevice();
       			removeButtonDisable(f);    
    		},
    		function(resp)
    		{
    			showErrorMessage(getErrorMessage(resp));
    			removeButtonDisable(f)
    		});	
    }

    
    return false;
    
}

function changeToDevice()
{
	$("#popup_password_change .popuphead_details .popuphead_text").html($("#quit_session_desc .heading").html());
	$("#popup_password_change .popuphead_details .popuphead_define").html($("#quit_session_desc .description").html());
	$("#passform").hide();
	$("#pass_esc_devices").show();
}

function signout_devices(f,callback)
{
	var terminate_web=$('#'+f.id).find('input[name="clear_web"]').is(":checked");
	var terminate_mob=$('#'+f.id).find('input[name="clear_mobile"]').is(":checked");
	var terminate_api=$('#'+f.id).find('input[name="clear_apiToken"]').is(":checked");
	if(terminate_mob||terminate_web||terminate_api)
	{	
		if(validateForm(f))
	    {
				disabledButton(f);
	    		var parms=
	    		{
	    			"clear_web_sessions":terminate_web,//No I18N
	    			"clear_app_sessions":terminate_mob,//No I18N
	    			"clear_api_tokens":terminate_api//No I18N
	    		};
	
	
	    		var payload = SignOutObj.create(parms);
	    		payload.PUT("self","self").then(function(resp)	//No I18N
	    		{
	    			SuccessMsg(getErrorMessage(resp));
	    			close_password_change();
	       			removeButtonDisable(f);
	    		},
	    		function(resp)
	    		{
	    			showErrorMessage(getErrorMessage(resp));
	    			removeButtonDisable(f);
	    		});	
	    }
	}
	else
	{
		close_password_change();
	}
	return false;
	
}
/***************************** security question *********************************/


function load_SecQdetails(policies,SecQuestion_detail)
{
	if(de("secQA_exception"))
	{
		$("#secQA_exception").remove();
		$("#secQA_box #SecQ_noPresent").removeClass("hide");
	}
	if(SecQuestion_detail.exception_occured!=undefined	&&	SecQuestion_detail.exception_occured)
	{
		$( "#secQA_box .box_info" ).after("<div id='secQA_exception' class='box_content_div'>"+$("#exception_tab").html()+"</div>" );
		$("#secQA_exception #reload_exception").attr("onclick","reload_exception(SecurityQ,'secQA_box')");
		$("#secQA_box #SecQ_noPresent").addClass("hide");
		return;
	}
	
	if(SecQuestion_detail.confirmed_user!=undefined && !SecQuestion_detail.confirmed_user)
	{
		$("#SecQ_unconfirmed_user").show();
		$("#SecQ_fed_signin").hide();
		$("#secQ_ModifedTime").hide();
		$("#SecQ_noPresent").hide();
		$("#SecQ_Present").hide();
	}
	else if(SecQuestion_detail.password_exists!=undefined && !SecQuestion_detail.password_exists)
	{
		$("#secQ_ModifedTime").hide();
		$("#SecQ_unconfirmed_user").hide();
		$("#SecQ_fed_signin").show();
		$("#SecQ_noPresent").hide();
		$("#SecQ_Present").hide();
	}
	else
	{
		if(SecQuestion_detail!=undefined	&&	!jQuery.isEmptyObject(SecQuestion_detail))
		{
			$("#secQ_time_sring").html(" "+SecQuestion_detail.modified_time);
			$("#secQ_ModifedTime").show();
			$("#SecQ_unconfirmed_user").hide();
			$("#SecQ_fed_signin").hide();
			$("#SecQ_noPresent").hide();
			$("#SecQ_Present").show();
			
		}
		else
		{
			$("#secQ_ModifedTime").hide();
			$("#SecQ_unconfirmed_user").hide();
			$("#SecQ_fed_signin").hide();
			$("#SecQ_noPresent").show();
			$("#SecQ_Present").hide();
		}
	}
}


function show_security_question_popup()
{
	remove_error();
	$("#secQA_pass").val("");
	document.phraseform.reset();
	$("#custom_question_input").val($("#security_question_choose").val());
	if(!isMobile)
	{
		$("#security_question_choose").select2({ width: '320px'}).on("select2:close", function (e) { 
			$(".select2-selection--single").focus();
		});
		$("#security_question_choose").change(function(){
			//$("#sq_answer .textbox").focus();
		});
	}
	$("#New_Question").hide();
	$("#second_step").hide();
 	$("#first_step").show();
 	
	$("#popup_security_question").show(0,function(){
		$("#popup_security_question").addClass("pop_anim");
	});
	popup_blurHandler('6','.5');
	control_Enter("#popup_security_question a");//No i18N
	set_Format();
	$("#popup_security_question .select2-selection").focus();
	closePopup(close_security_question,"popup_security_question")//No I18N
}

function security_enter_pass(f)
{
	remove_error();
    var question =document.phraseform.custSecQ.value.trim();
    var answer = f.secA.value.trim();
    if(isEmpty(question)) 
    {
    	$('#New_Question').append( '<div class="field_error">'+err_enter_ques+'</div>' );
    }
    else if(question.length > 200) 
    {
    	$('#New_Question').append( '<div class="field_error">'+err_question_maxlen+'</div>' );
    }
    else if(isEmpty(answer)) 
    {
    	$('#sq_answer').append( '<div class="field_error">'+err_enter_ans+'</div>' );
    }
    else if(answer.length > 50) 
    {
    	$('#sq_answer').append( '<div class="field_error">'+err_answer_maxlen+'</div>' );
    }
    else
    {
//    	ChangeSecQiestion(f);
    	$("#second_step").show();
    	$("#first_step").hide();
    }
    $("#phraseform").attr("onsubmit","return ChangeSecQiestion(this)");
    $("#secQA_pass").focus();
    return false;
}
 function back_to_question()
 {
	 
	$("#second_step").hide();
	$("#secQA_pass").val("");
	$("#first_step").show();
	$("#phraseform").attr("onsubmit"," return security_enter_pass(this)");
	return false; 
 }

function set_Format()
{
    var selected=$("#security_question_choose" ).val();//No i18N
    if(selected=="custom") 
    {
        if(de('New_Question')) 
        {
            $('#New_Question').show();
            $("#custom_question_input").val("");
            $("#sq_answer .textbox").val("");
            de('custom_question_input').focus();//No i18N
        }
    }else 
    {
    	$('#New_Question').hide();
    	$("#custom_question_input").val(selected);
    	$("#sq_answer .textbox").val("");
    	$("#sq_answer .textbox").focus();
    }
}

function close_security_question()
{
	$("#phraseform").attr("onsubmit"," return security_enter_pass(this)");
	popupBlurHide('#popup_security_question',function(){	//No I18N
		$("#sq_answer .textbox").val("");
		$("#custom_question_input").val("");		
	});
}

function ChangeSecQiestion(form)
{
	if(validateForm(form))
    {
			disabledButton(form);
    		var parms=
    		{
    				"custSecQ":$('#'+form.id).find('input[name="custSecQ"]').val(),//No I18N
    				"secA":$('#'+form.id).find('input[name="secA"]').val(),//No I18N
    				"current_password":$('#'+form.id).find('input[name="current_password"]').val()//No I18N
    		};


    		var payload = SecurityQuestion.create(parms);
    		payload.PUT("self","self").then(function(resp)	//No I18N
    		{
    			SuccessMsg(getErrorMessage(resp));
    			close_security_question();
				load_SecQdetails(security_data.Policies,resp.securityquestion);
				close_security_question();
				removeButtonDisable(form);

    		},
    		function(resp)
    		{
    			showErrorMessage(getErrorMessage(resp));
    			if(resp.cause!=undefined && resp.cause=="inavlid_answer")
    			{
    				back_to_question();
    			}
    			removeButtonDisable(form);
    		});	
    }
	return false;
}

/***************************** Allowed IPs *********************************/
function gen_random_num(){
	var pre_random = undefined;
	do{
		var ran = Math.floor(Math.random() * (10));
		pre_random=ran;
	}
	while(ran!=pre_random)
	return ran;
}

function load_IPdetails(policies,IP_details)
{
	if(de("allowedIP_exception"))
	{
		$("#allowedIP_exception").remove();
		$("#AllowedIP_box #all_ip_show").removeClass("hide");
	}
	if(IP_details.exception_occured!=undefined	&&	IP_details.exception_occured)
	{
		$( "#AllowedIP_box .box_info" ).after("<div id='allowedIP_exception' class='box_content_div'>"+$("#exception_tab").html()+"</div>" );
		$("#allowedIP_exception #reload_exception").attr("onclick","reload_exception(AllowedIP,'AllowedIP_box')");
		$("#AllowedIP_box #all_ip_show").addClass("hide");
		return;
	}
	
	//var index = from_IP.indexOf("remote_ip");
	var count=0;
//	if(from_IP.length>1)
//	{
	if(!jQuery.isEmptyObject(IP_details.IPs))
	{
		var from_IPs=timeSorting(IP_details.IPs);
		
		$("#no_ip_add_here").hide();
		$("#IP_content").show();
		
		if(IP_details.IPs[IP_details.remote_ip]!=undefined)
		{
			$("#current_ip").hide();
			$("#allowed_ip_entry0").hide();
		}
		else
		{
			
			
			$("#current_ip").show();
			$("#current_ip .ip_blue").html(IP_details.remote_ip);
			$("#cur_ip").val(IP_details.remote_ip);
			
			//warning msg that the current ip is not allowed
			$("#allowed_ip_entry0").show();
			$("#IP_content .alone_current_ip").html(formatMessage("<div class='note_ip'>"+note+" </div><div class='ip_note_desc'>"+current_to_wanrning+"</div>",IP_details.remote_ip));
			$("#allowed_ip_entry0").attr("onclick","show_get_name('"+IP_details.remote_ip+"','"+IP_details.remote_ip+"',"+true+",0);");
			$("#allowed_ip_entry0 #ip_range_forNAME").html(IP_details.remote_ip);
			$("#allowed_ip_info0").attr("onclick","show_get_name('"+IP_details.remote_ip+"','"+IP_details.remote_ip+"',"+true+",0);");
			
		}
//		if (index > -1) 
//		{
//			from_IP.splice(index, 1);
//		}
		$("#IPdisplay_others").html("");
		
		for(iter=0;iter<Object.keys(IP_details.IPs).length;iter++)
		{
			count++;
			var current_from_IP=IP_details.IPs[from_IPs[iter]];
			
			IPdisplay_format = $("#empty_ip_format").html();
			$("#IPdisplay_others").append(IPdisplay_format);
			
			$("#IPdisplay_others #allowed_ip_entry").attr("id","allowed_ip_entry"+count);
			$("#IPdisplay_others #allowed_ip_info").attr("id","allowed_ip_info"+count);
			//$("#IPdisplay_others #allowed_ip_info_rename").attr("id","allowed_ip_info_rename"+count);
			
			$("#allowed_ip_entry"+count).attr("onclick","show_selected_ip_info("+count+");");
		      
			if(count > 2)
			{
				$("#allowed_ip_entry"+count).addClass("allowed_ip_entry_hidden");  
			}

			$("#allowed_ip_entry"+count+" .range_name").html(current_from_IP.display_name);
			$("#allowed_ip_entry"+count+" #range_name").html(current_from_IP.display_name);
			$("#allowed_ip_entry"+count+" .device_time").html(current_from_IP.created_time_elapsed);
			//$("#allowed_ip_entry"+count+" #ip_pencil").attr("onclick","show_get_name('"+current_from_IP.from_ip+"','"+current_from_IP.to_ip+"',true,"+count+");");
			$("#allowed_ip_entry"+count+" .device_pic").addClass(color_classes[gen_random_value()]);
			$("#allowed_ip_entry"+count+" .device_pic").html(current_from_IP.display_name.substr(0,2).toUpperCase());
			
			
			if(current_from_IP.from_ip==current_from_IP.to_ip||current_from_IP.to_ip==undefined)//Static IP check
			{
				$("#allowed_ip_entry"+count+" .IP_tab_info").html(current_from_IP.from_ip);
				$("#allowed_ip_info"+count+" .static").html(current_from_IP.from_ip);
				$("#allowed_ip_info"+count+" .range").hide();
				$("#allowed_ip_info"+count+" .static").show();
			}
			else
			{
				$("#allowed_ip_entry"+count+" .IP_tab_info").html(current_from_IP.from_ip+" - "+current_from_IP.to_ip);
				$("#allowed_ip_info"+count+" .range").html(current_from_IP.from_ip+" - "+current_from_IP.to_ip);
				$("#allowed_ip_info"+count+" .range").show();
				$("#allowed_ip_info"+count+" .static").hide();
			}
			$("#allowed_ip_info"+count+" #pop_up_time").html(current_from_IP.created_date);
			if(current_from_IP.location!=undefined)
			{
				$("#allowed_ip_entry"+count+" .asession_location").removeClass("location_unavail");
				$("#allowed_ip_entry"+count+" .asession_location").text(current_from_IP.location);
				$("#allowed_ip_info"+count+" #pop_up_location").removeClass("unavail");
				$("#allowed_ip_info"+count+" #pop_up_location").text(current_from_IP.location);
			}
			$("#allowed_ip_info"+count+" #current_session_logout").attr("onclick","deleteip('"+current_from_IP.from_ip+"','"+current_from_IP.to_ip+"')");
			
		}	 
		if(count<3)//less THAN 3
		{
			$("#ip_justaddmore").show();
			$("#IP_add_view_more").hide();
		}
		else
		{
			$("#ip_justaddmore").hide();
			$("#IP_add_view_more").show();
		}
	}
	else
	{
		$("#no_ip_add_here").show();
		$("#IP_content").hide();
		
		$("#current_ip").show();
		$("#current_ip .ip_blue").html(IP_details.remote_ip);
		$("#cur_ip").val(IP_details.remote_ip);
		$("#ip_justaddmore").hide();
		$("#IP_add_view_more").hide();
	}
	
	  
	
}


function show_selected_ip_info(id)
{	
	if(!$(popup_ip_new).is(":visible")){
		$("#allowed_ip_pop .device_pic").addClass($("#allowed_ip_entry"+id+" .device_pic")[0].className);
		$("#allowed_ip_pop .device_pic").html($("#allowed_ip_entry"+id+" .device_pic").html());
		$("#allowed_ip_pop .device_name").html($("#allowed_ip_entry"+id+" .device_name").html()); //load into popuop
		$("#allowed_ip_pop #edit_ip_name").attr("onclick",$("#allowed_ip_entry"+id+" #ip_pencil").attr("onclick"));
		$("#allowed_ip_pop .device_time").html($("#allowed_ip_entry"+id+" .device_time").html()); //load into popuop
		
		$("#allowed_ip_pop #ip_current_info").html($("#allowed_ip_info"+id).html()); //load into popuop
		
		
		popup_blurHandler('6','.5');
		$("#allowed_ip_pop").show(0,function(){
			$("#allowed_ip_pop").addClass("pop_anim");
		});
		control_Enter("a"); ///No I18N
		$("#current_session_logout").focus();
		closePopup(closeview_selected_ip_view,"allowed_ip_pop"); //No I18N
	}
		
}
function closeview_selected_ip_view()
{
	popupBlurHide("#allowed_ip_pop"); //No I18N
	$("#allowed_ip_pop #edit_ip_name").attr("onclick","");
	$("#allowed_ip_pop a").unbind();
}

function closeview_all_ip_view(callback)
{
	popupBlurHide('#allow_ip_web_more',function(){ //No I18N
		$("#view_all_allow_ip").html("");
		if(callback)
		{
			callback();
		}
		
	});
	$(".aw_info a").unbind();
}

function show_all_ip()
{

	$("#view_all_allow_ip").html($("#all_ip_show").html()); //load into popuop
	popup_blurHandler('6','.5');
	
	$("#view_all_allow_ip .allowed_ip_entry_hidden").show();
	$("#view_all_allow_ip .authweb_entry").after( "<br />" );
	$("#view_all_allow_ip .authweb_entry").addClass("viewall_authwebentry");
	$("#view_all_allow_ip .allowed_ip_entry").removeAttr("onclick");
	if($("#view_all_allow_ip #allowed_ip_info0").length==1) 
	{ 
		$("#view_all_allow_ip #allowed_ip_info0").removeAttr("onclick"); 
		$("#view_all_allow_ip #allowed_ip_info0 #add_current_ip").attr("onclick","add_current_ip()"); 
		
	}
	
	$("#view_all_allow_ip .info_tab").show();

	//$("#view_all_allow_ip .asession_action").hide();

	//$("#view_all_allow_ip .asession_action").hide();

	//$("#view_all_allow_ip .ip_pencil").hide();
	
	$("#allow_ip_web_more").show(0,function(){
		$("#allow_ip_web_more").addClass("pop_anim");
	});
	
	
	
	$("#view_all_allow_ip .allowed_ip_entry").click(function(){
		
		var id=$(this).attr('id');
		if($(event.target).hasClass("action_icon")){
			return;
		}

		if(id=="allowed_ip_entry0")
		{ 	
			if($("#view_all_allow_ip #"+id).hasClass("Active_ip_showall_hover"))
			{ 
				return; 
			} 
		}
	
		$("#view_all_allow_ip .allowed_ip_entry").addClass("autoheight");
		$("#view_all_allow_ip .aw_info").slideUp("fast");
		$("#view_all_allow_ip .activesession_entry_info").show();
		if($("#view_all_allow_ip #"+id).hasClass("Active_ip_showall_hover"))
		{

				$("#view_all_allow_ip #"+id+" .aw_info").slideUp("fast",function(){
					$("#view_all_allow_ip #"+id).removeClass("Active_ip_showall_hover");
					$("#view_all_allow_ip .allowed_ip_entry").removeClass("autoheight");
				});
				$("#view_all_allow_ip .activesession_entry_info").show();
		}
		else
		{
			
			$("#view_all_allow_ip .allowed_ip_entry").removeClass("Active_ip_showall_hover");
			$("#view_all_allow_ip #"+id).addClass("Active_ip_showall_hover");
			$("#view_all_allow_ip .aw_info").slideUp(300);
			$("#view_all_allow_ip #"+id+" .aw_info").slideDown("fast",function(){

				control_Enter(".aw_info a"); //No I18N
				$("#view_all_allow_ip .allowed_ip_entry").removeClass("autoheight");
				
			});
			$("#view_all_allow_ip #"+id+" .activesession_entry_info").hide();
		}

	});
	closePopup(closeview_all_ip_view,"allow_ip_web_more");//No I18N
	
	$("#allow_ip_web_more").focus();	
}





function add_new_ip_popup()
{

	document.addip.reset();
	remove_error();
	if($("#current_ip").css("display")=="none"){
		$('#static_ip_sel').prop("checked", true);
		$("#range_ip").hide();
		$("#static_ip").show();	
	}
	else{
		$('#current_ip_sel').prop("checked", true);
		$("#range_ip").hide();
		$("#static_ip").hide();	
	}
	$("#popup_ip_new").show(0,function(){
		$("#popup_ip_new").addClass("pop_anim");
	});
	$("#ip_name_bak").show();
	$("#get_ip").show();
	$("#get_name").hide();
	popup_blurHandler('6','.5');
	$("#ip_name_bak").show();
	$("#add_new_ip").show();
	$("#add_name_old_ip").hide();
	$("#back_name_old_ip").hide();
	$("#allowedipform").attr("onsubmit","return addipaddress(this)");
	$('input[name=ip_select]').change(function () {
        var val=$(this).val();
        if(val=="1")
        {
        	$("#static_ip").slideUp(300);
        	$("#range_ip").slideUp(300);
        }
        else if(val=="2")
        {
        	$("#static_ip").slideDown(300);
        	$("#range_ip").slideUp(300);
        	$(".sip .ip_field_cell:first").focus();
        }
        else
        {
        	$("#static_ip").slideUp(300);
        	$("#range_ip").slideDown(300);////for inline block
        	$(".fip .ip_field_cell:first").focus();
        }
    });

	$(".ip_field_cell").click(function()
	{
		var parent=$(this).parent();
		var ips_cell=parent.children('.ip_field_cell');//No I18N
		if($(this).val().length==0)
		{
			$(this).focus();
		}
		else
		{
			for(var i=0;i<4;i++)
			{
				if(ips_cell[i].value.length==0)
				{
					ips_cell[i].focus();
					break;
				}
			}
		}
	});
	$(".ip_field_cell").focus(function()
	{
		$(this).parent().css("border","2px solid #10bc83");
		$(this).select();
	});
	$(".ip_field_cell").blur(function()
	{
		$(this).parent().css("border","2px solid #ccc");
	});

	$(".ip_field_cell").keyup(function(ele)
			{
			var e=ele.keyCode;
			
			if(e=="190")//for '.'
			{
				this.value=this.value.substring(0, this.value.length - 1);
				if(this.value!="")
				{
					var $next = $(this).next().next();
					  if ($next.hasClass("ip_field_cell"))
					  {
						  $next.focus();
					  }
				}
				
			}
			if(e==8 || e==46)
			{
				if(this.value.length==0)
				{
					var $before = $(this).prev().prev();
					  if ($before.hasClass("ip_field_cell"))
					  {
						  $before.focus();
					  }
				}
			}
			if (this.value.length == this.maxLength) 
				{
					  var $next = $(this).next().next();
					  if ($next.hasClass("ip_field_cell"))
						  {
						  	$next.focus();
						  }
					   return;
				}
			});
	closePopup(close_new_ip_popup,"popup_ip_new");//No I18N
	$("#popup_ip_new .real_radiobtn:first").focus();
}

function isNumberKey(evt)
{
	remove_error();
    var charCode = (evt.which) ? evt.which : event.keyCode
    if (charCode > 31 && (charCode < 48 || charCode > 57))
    {
    	return false;
    }
    return true;
}


function close_new_ip_popup()
{
	popupBlurHide('#popup_ip_new',function(){ //No I18N
		closeview_selected_ip_view();
	});
	
	$( ".ip_field_cell").unbind( "keyup" );

	$("#ip_name_bak").show();
	$("#add_new_ip").show();
	
	$("#add_name_old_ip").hide();
	$("#back_name_old_ip").hide();
	
	$("#get_ip").show();
	$("#get_name").hide();
	
	$(".ip_impt_note").hide();
}



function addipaddress(f) 
{
	remove_error();
	var val= f.ip_select.value.trim();
	var fip;
    var tip;
	if(val==1)
	{
		fip=tip=f.cur_ip.value.trim();
	}
	else if(val==2)
	{
		fip=tip=$("#static_ip .1_cell").val()+"."+$("#static_ip .2_cell").val()+"."+$("#static_ip .3_cell").val()+"."+$("#static_ip .4_cell").val();
		tip=tip.trim();
		fip=fip.trim();
	}
	else if(val==3)
	{
		fip=$("#range_ip .fip .1_cell").val()+"."+$("#range_ip .fip .2_cell").val()+"."+$("#range_ip .fip .3_cell").val()+"."+$("#range_ip .fip .4_cell").val();
		tip=$("#range_ip .tip .1_cell").val()+"."+$("#range_ip .tip .2_cell").val()+"."+$("#range_ip .tip .3_cell").val()+"."+$("#range_ip .tip .4_cell").val();
		tip=tip.trim();
		fip=fip.trim();
	}
    if(isEmpty(fip)) 
    {
    	if($('input[name=ip_select]:checked').val()=="2")
    	{
    		$('#static_ip').append( '<div class="field_error">'+err_empty_static_ip+'</div>' );
    	}
    	else
    	{
    		$('#range_ip').append( '<div class="field_error">'+err_empty_fromip+'<br /></div>' );    	
    	}
    }
    else if(!isIP(fip)) 
    {
    	if($('input[name=ip_select]:checked').val()=="2")
    	{
    		$('#static_ip').append( '<div class="field_error">'+err_enter_ip+'</div>' );
    	}
    	else
    	{
    		$('#range_ip').append( '<div class="field_error">'+err_enter_ip+'<br /></div>' );    	
    	}
    }
    else if(!isEmpty(tip) && !isIP(tip)) 
    {
		$('#range_ip').append( '<div class="field_error">'+err_enter_toip+'<br /></div>' );    	

    }
    else 
    {
    	show_get_name(fip,tip,false);
    	
    }
    closePopup(close_new_ip_popup,"popup_ip_new",true);//No I18N

    $("#ip_name").focus();
    return false;
}

function show_get_name(fip,tip,is_directly,id)
{
//	if($("#allow_ip_web_more").is(":visible"))
//	{
//		$("#allow_ip_web_more #allowed_ip_info_rename"+id).html($("#popup_ip_new").html());
//			$("#allow_ip_web_more #allowed_ip_info_rename"+id+" .close_btn").remove();
//
//			$("#view_all_allow_ip .allowed_ip_entry").addClass("autoheight");
//			$("#view_all_allow_ip .activesession_entry_info").show();
//			var vis_check=false;
//			if($("#view_all_allow_ip .aw_info").is(":visible")){
//				vis_check=true;
//			}
//			$("#view_all_allow_ip .aw_info_rename").slideUp(300);
//			
//			if($("#view_all_allow_ip #allowed_ip_entry"+id).hasClass("Active_ip_showall_hover"))
//			{
//				if(vis_check){
//					$(".aw_info a").unbind();
//					$("#view_all_allow_ip #allowed_ip_entry"+id+" .aw_info").slideUp("fast",function(){
//					//	$("#view_all_allow_ip #"+id).addClass("Active_ip_showall_hover");
//						$("#view_all_allow_ip #allowed_ip_entry"+id+" .aw_info_rename").slideDown(300,function(){
//							$("#view_all_allow_ip .allowed_ip_entry").removeClass("autoheight");
//						});
//					});
//					$("#view_all_allow_ip .activesession_entry_info").show();
//					$("#view_all_allow_ip #allowed_ip_entry"+id+" .activesession_entry_info").hide();
//				}
//				else{
//					$(".aw_info a").unbind();
//					$("#view_all_allow_ip #allowed_ip_entry"+id+" .aw_info_rename").slideUp("fast",function(){
//						$("#view_all_allow_ip #allowed_ip_entry"+id).removeClass("Active_ip_showall_hover");
//						$("#view_all_allow_ip .allowed_ip_entry").removeClass("autoheight");
//					});
//					$("#view_all_allow_ip .activesession_entry_info").show();
//				}
//			}
//			else
//			{
//
//				$("#view_all_allow_ip .allowed_ip_entry").removeClass("Active_ip_showall_hover");
//				$("#view_all_allow_ip #allowed_ip_entry"+id).addClass("Active_ip_showall_hover");
//				$("#view_all_allow_ip .aw_info_rename").slideUp(300);
//				$("#view_all_allow_ip .aw_info").slideUp(300);
//				$("#view_all_allow_ip #allowed_ip_entry"+id+" .aw_info_rename").slideDown("fast",function(){
//					$("#view_all_allow_ip .allowed_ip_entry").removeClass("autoheight");
//				});
//				$("#view_all_allow_ip #allowed_ip_entry"+id+" .activesession_entry_info").hide();
//			}
//				
//			closePopup(closeview_all_ip_view,"allow_ip_web_more");//No i18N
//
//			$("#allowed_ip_info_rename"+id+" #get_ip").hide();
//			$("#allowed_ip_info_rename"+id+" #get_name").show();
//			if(is_directly)
//			{
//				$("#allowed_ip_info_rename"+id+" #ip_name_bak").hide();
//				$("#allowed_ip_info_rename"+id+" #back_name_old_ip").hide();
//
//				$("#allowed_ip_info_rename"+id+" #add_new_ip").hide();
//				$("#allowed_ip_info_rename"+id+" #add_name_old_ip").show();
//			}
//			else
//			{
//				$("#allowed_ip_info_rename"+id+" .ip_impt_note").show();
//			}
//			if($("#allowed_ip_pop").is(":visible"))
//			{
//				$("#allowed_ip_info_rename"+id+" #back_name_old_ip").show();
//			}
//			
//			if(fip && tip)
//			{
//				$("#fip").val(fip);
//				$("#tip").val(tip);
//				if(fip==tip)
//				{
//					$("#allowed_ip_info_rename"+id+" #ip_range_forNAME").html(fip);
//				}
//				else
//				{
//					$("#allowed_ip_info_rename"+id+" #ip_range_forNAME").html(fip+" - "+tip);
//				}
//			}
//			$("#get_name #ip_name").val($("#allowed_ip_entry"+id+" #range_name").html());
//	}
//	else
//	{
		closeview_selected_ip_view();
		$("#popup_ip_new").show(0,function(){
			$("#popup_ip_new").addClass("pop_anim");
		});

		if(is_directly)
		{
			$("#ip_name_bak").hide();
		}
		$("#get_ip").hide();
		$("#get_name").show();
//		if(is_directly)
//		{
//			$("#ip_name_bak").hide();
//			$("#back_name_old_ip").hide();
//			if(id==0)
//			{
//				$("#add_new_ip").show();
//				$("#add_name_old_ip").hide();
//			}
//			else
//			{
//				$("#add_new_ip").hide();
//				$("#add_name_old_ip").show();
//			}
//		}
//		else
//		{
			$(".ip_impt_note").show();
//		}
		if($("#allowed_ip_pop").is(":visible"))
		{
			$("#back_name_old_ip").show();
		}
		
		if(fip && tip)
		{
			$("#fip").val(fip);
			$("#tip").val(tip);
			if(fip==tip)
			{
				$("#ip_range_forNAME").text(fip);
			}
			else
			{
				$("#ip_range_forNAME").text(fip+" - "+tip);
			}
		}
		$("#get_name #ip_name").val($("#allowed_ip_entry"+id+" #range_name").html());
		
		popup_blurHandler('6','.5');
		$("#allowedipform").attr("onsubmit","return add_ip_with_name(this)");
		control_Enter("a");//No i18N
		closePopup(close_new_ip_popup,"popup_ip_new"); //No I18N
		$("#ip_name").focus();
		return false;
//	}

}

function add_ip_with_name(form)
{
	
	if(validateForm(form))
    {
		disabledButton(form);
		var from = $("#fip").val();
		var to = $("#tip").val();
		var name=$("#get_name #ip_name").val();
		
    		var parms=
    		{
    				"f_ip":from,//No I18N
    				"t_ip":to,//No I18N
    				"ip_name":name//No I18N
    		};


    		var payload = AllowedIPObj.create(parms);
    		payload.POST("self","self").then(function(resp)	//No I18N
    		{
    			SuccessMsg(getErrorMessage(resp));

    			if(security_data.AllowedIPs.IPs==undefined)
    			{
    				security_data.AllowedIPs.IPs=[];
    			}
    			
    			security_data.AllowedIPs.IPs[resp.allowedip.from_ip]=resp.allowedip;
    			
    			load_IPdetails(security_data.Policies,security_data.AllowedIPs);
    			
    			$('#allowedipform')[0].reset();
    			close_new_ip_popup();
    			removeButtonDisable(form);
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
    			removeButtonDisable(form); 
    		});	
    }
	return false;
}


function add_current_ip()
{
	var parms=
	{
			"f_ip":security_data.AllowedIPs.remote_ip,//No I18N
			"t_ip":security_data.AllowedIPs.remote_ip,//No I18N
			"ip_name":$("#view_all_allow_ip #allowed_ip_info0 #new_ip_name").val()//No I18N
	};


	var payload = AllowedIPObj.create(parms);
	payload.POST("self","self").then(function(resp)	//No I18N
	{
		SuccessMsg(getErrorMessage(resp));

		security_data.AllowedIPs.IPs[resp.allowedip.from_ip]=resp.allowedip;
		
		load_IPdetails(security_data.Policies,security_data.AllowedIPs);
		
		$('#allowedipform')[0].reset();
		if($("#allow_ip_web_more").is(":visible")==true)
		{
			var lenn=Object.keys(security_data.AllowedIPs.IPs).length;
			if(lenn > 1){
				closeview_all_ip_view(show_all_ip);
			}
			else{
				closeview_all_ip_view();
			}
		}
		else{
			closeview_all_ip_view();
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

function deleteip(fip,tip)
{		    
			new URI(AllowedIPObj,"self","self",fip).DELETE().then(function(resp)	//No I18N
			{
				SuccessMsg(getErrorMessage(resp));
				delete security_data.AllowedIPs.IPs[fip];
				load_IPdetails(security_data.Policies,security_data.AllowedIPs);
				closeview_selected_ip_view();
				if($("#allow_ip_web_more").is(":visible")==true){
					lenn=Object.keys(security_data.AllowedIPs.IPs).length;
					if(lenn > 1)
					{
						closeview_all_ip_view(show_all_ip);
					}
					else
					{
						closeview_all_ip_view();
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

function change_ip_only_name()
{
	var from = $("#fip").val();
	var to = $("#tip").val();
	var name=$("#get_name #ip_name").val();
	
	var parms=
	{
			"t_ip":to,//No I18N
			"ip_name":name//No I18N
	};
	var payload = AllowedIPObj.create(parms);
	payload.PUT("self","self",from).then(function(resp)	//No I18N
	{
		SuccessMsg(getErrorMessage(resp));
		
		security_data.AllowedIPs.IPs.from_ip.display_name=name;
		
		load_IPdetails(security_data.Policies,security_data.AllowedIPs);
		$('#allowedipform')[0].reset();
		close_new_ip_popup();
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
		if($("#allow_ip_web_more").is(":visible")){
			closeview_all_ip_view(show_all_ip);
		}
		else{
			close_new_ip_popup();
		}
	});	
    return false;
}




function back_to_info()
{
	$("#popup_ip_new").hide();
	
}
function back_to_addip()
{
	$("#get_ip").show();
	$("#get_name").hide();
	$(".ip_impt_note").hide();
	$("#allowedipform").attr("onsubmit","return addipaddress(this)");
	return false;
}


/***************************** App Passwords *********************************/

function load_AppPasswords(Policies,AppPasswords)
{
	if(de("App_Password_exception"))
	{
		$("#App_Password_exception").remove();
	}
	if(AppPasswords.exception_occured!=undefined	&&	AppPasswords.exception_occured)
	{
		$("#App_Password_box .box_info" ).after("<div id='App_Password_exception' class='box_content_div'>"+$("#exception_tab").html()+"</div>" );
		$("#App_Password_exception #reload_exception").attr("onclick","reload_exception(AppPasswords,'App_Password_box')");
		return;
	}

//	if(Policies.is_tfa_activated)
//	{
		$("#generate_app_pass").css("display","block");
		$("#nodata_withoutTFA").hide();
		$("#nodata_withTFA").show();
//	}
//	else
//	{
//		$("#generate_app_pass").hide();
//		$("#nodata_withoutTFA").show();
//		$("#nodata_withTFA").hide();
//	}
	
	if(!jQuery.isEmptyObject(security_data.AppPasswords))
	{
		var count=0;
		$("#no_app_passwords").hide();
		$("#display_app_passwords").show();
		$("#display_app_passwords").html("");
		var passwords=timeSorting(AppPasswords);
		for(iter=0;iter<Object.keys(passwords).length;iter++)
		{
			count++;
			var current_password=AppPasswords[passwords[iter]];
			app_password_format = $("#empty_app_pass_format").html();
			$("#display_app_passwords").append(app_password_format);
			
			$("#display_app_passwords #app_password_entry").attr("id","app_password_entry"+count);
			$("#display_app_passwords #app_password_info").attr("id","app_password_info"+count);
			
			
			$("#app_password_entry"+count).attr("onclick","show_selected_app_password_info("+count+");");
			
			if(count > 3)
			{
				$("#app_password_entry"+count).addClass("allowed_ip_entry_hidden");  
			}
			$("#app_password_entry"+count+" .device_name").html(current_password.app_name);
			$("#app_password_entry"+count+" .device_time").html(current_password.created_time_elapsed);
			$("#app_password_entry"+count+" .device_pic").addClass(color_classes[gen_random_value()]);
			if(current_password.app_name.indexOf(" ")==-1)
			{
				$("#app_password_entry"+count+" .device_pic").html(current_password.app_name.substr(0,2).toUpperCase());
			}
			else
			{
				var name=current_password.app_name.split(" ");
				$("#app_password_entry"+count+" .device_pic").html((name[0][0]+name[1][0]).toUpperCase());
			}
			if(current_password.location!=undefined)
			{
				$("#app_password_entry"+count+" .asession_location").removeClass("location_unavail");
				$("#app_password_entry"+count+" .asession_location").html(current_password.location);
				$("#app_password_info"+count+" #pop_up_location").removeClass("unavail");
				$("#app_password_info"+count+" #pop_up_location").html(current_password.location);
			}
			$("#app_password_info"+count+" #pop_up_time").html(current_password.created_date);
			$("#app_password_info"+count+" #pop_up_ip").html(current_password.created_ip);
			
			$("#app_password_info"+count+" #delete_generated_password").attr("onclick","delete_app_pass('"+count+"','"+current_password.app_pass_id+"')");
		}
		if(count > 3)
		{
			$("#app_pass_add_view_more").show();
			$("#app_pass_justaddmore").hide();
		}
		else
		{
			$("#app_pass_add_view_more").hide();
			$("#app_pass_justaddmore").show();
		}
	}
	else
	{
		$("#no_app_passwords").show();
		$("#display_app_passwords").hide();
		$("#app_pass_justaddmore").hide();
	}
	
}


function show_selected_app_password_info(id)
{
	
	$("#app_pass_pop .device_pic").addClass($("#app_password_entry"+id+" .device_pic")[0].className);
	$("#app_pass_pop .device_pic").html($("#app_password_entry"+id+" .device_pic").html());
	$("#app_pass_pop .device_name").html($("#app_password_entry"+id+" .device_name").html()); //load into popuop
	$("#app_pass_pop .device_time").html($("#app_password_entry"+id+" .device_time").html()); //load into popuop
	
	$("#app_pass_pop #app_current_info").html($("#app_password_info"+id).html()); //load into popuop
	
	popup_blurHandler('6','.5');
	
	$("#app_pass_pop").show(0,function(){
		$("#app_pass_pop").addClass("pop_anim");
	});
	$("#delete_generated_password").focus();
	closePopup(closeview_selected_app_pass_view,"app_pass_pop"); //No I18N
}

function closeview_selected_app_pass_view()
{
	popupBlurHide('#app_pass_pop'); //No I18N
	$("#app_pass_pop a").unbind();
}


function delete_app_pass(count,pwdid)
{
	
	
	new URI(AppPasswordsObj,"self","self",pwdid).DELETE().then(function(resp)	//No I18N
			{
				SuccessMsg(getErrorMessage(resp));
				delete security_data.AppPasswords[pwdid];
				load_AppPasswords(security_data.Policies,security_data.AppPasswords);				
				closeview_selected_app_pass_view();
				if($("#app_password_web_more").is(":visible")==true)
				{					
					var lenn=Object.keys(security_data.AppPasswords).length;
					if(lenn > 1)
					{
						$("#app_password_web_more").hide();
						$("#view_all_app_pass").html("");
						show_all_app_passwords();
					}
					else{
						$(".blur").css({"z-index":"6","opacity":".5"});
						closeview_all_app_view();
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

function show_generate_popup()
{
	$("#popup_apppass_new").show(0,function(){
		$("#popup_apppass_new").addClass("pop_anim");
	});
	$("#generate_new_pass").show();
	$("#generated_passsword").hide();
	
	popup_blurHandler('6','.5');
	control_Enter("#popup_apppass_new a");//No i18N
	$("#popup_apppass_new input:first").focus();
	closePopup(close_new_app_pass_popup,"popup_apppass_new");//No I18N	
}















function close_new_app_pass_popup()
{
	popupBlurHide('#popup_apppass_new',function(){	//No i18N
		$("#generate_new_pass").show();
		$("#generated_passsword").hide();		
	});
	remove_error();
	$("#popup_apppass_new input").val(''); 
}






function generateAppPassword()
{
	remove_error();
	var label = de('applabel').value.trim(); //No i18N
	if(label == "")
	{
		$("#gene_app_space").append( '<div class="field_error">'+empty_field+'</div>' );
		return;
	}
	if(validatelabel(label) != true) 
	{
		$("#gene_app_space").append( '<div class="field_error">'+err_invalid_label+'</div>' );
		return;
	}

	if(label.length > 45)
	{
		$("#gene_app_space").append( '<div class="field_error">'+err_invalid_label+'</div>' );//No i18N
		return;
	}
//	pass = de('passapp').value.trim(); //No i18N
//	if(pass=="")
//	{
//		$("#gene_app_pass_space").append( '<div class="field_error">'+err_invalid_password+'</div>' );
//		return;
//	}
	
	disabledButton($("#generate_new_pass"));
	var parms=
	{
//		"password":pass,//No I18N
		"keylabel":label//No I18N
	};
	
	
	var payload = AppPasswordsObj.create(parms);
	//$("#generate_new_pass .tfa_blur").show();
	//$("#generate_new_pass .loader").show();
	
	payload.POST("self","self").then(function(resp)	//No I18N
	{
		SuccessMsg(getErrorMessage(resp));
		//$("#generate_new_pass .tfa_blur").hide();
		//$("#generate_new_pass .loader").hide();
		security_data.AppPasswords[resp.apppasswords.app_info.app_pass_id]=resp.apppasswords.app_info;
		load_AppPasswords(security_data.Policies,security_data.AppPasswords);
		generate_appcallback(resp.apppasswords.password)
		removeButtonDisable($("#generate_new_pass"));
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
		//$("#generate_new_pass .tfa_blur").hide();
		//$("#generate_new_pass .loader").hide();
		removeButtonDisable($("#generate_new_pass"));
	});

	return false;
}

function generate_appcallback(password)
{	
	
	$("#generate_new_pass").hide();
	$("#generated_passsword").show();
	
	$("#app_name").html(de('applabel').value.trim()); //No i18N
	var displayPass = "<span>"+password.substring(0, 4)+"</span>"+"<span style='margin-left:5px'>"+password.substring(4, 8)+"</span>"+"<span style='margin-left:5px'>"+password.substring(8)+"</span>"; //No I18N
	$('.app_password').html(displayPass); //No i18N
	//$('.password_key').val(password); //No i18N
	$("#apppassworddef_id").hide();
	$(".app_pasword_info .app_info").html(formatMessage(tfa_pass_msg,de('applabel').value.trim()));//No i18N
	$(".app_password_grid").attr("title",err_app_pass_click_text);//No i18N
	tippy(".app_password_grid",{//No I18N
    		trigger:"mouseenter",	//No I18N
    		arrow:true
	});
	$("#popup_apppass_new").focus();
}


function show_all_app_passwords()
{
	$("#view_all_app_pass").html($("#display_app_passwords").html()); //load into popuop
	popup_blurHandler('6','.5');
	
	$("#view_all_app_pass .allowed_ip_entry_hidden").show();
	//$("#view_all_app_pass .authweb_entry").after( "<br />" );
	//$("#view_all_app_pass .authweb_entry").addClass("viewall_authwebentry");
	$("#view_all_app_pass .allowed_ip_entry").removeAttr("onclick");
	$("#view_all_app_pass .info_tab").show();

//	$("#view_all_allow_ip .asession_action").hide();

	//$("#view_all_allow_ip .asession_action").hide();

	
	$("#app_password_web_more").show(0,function(){
		$("#app_password_web_more").addClass("pop_anim");
	});
	
	
	
	$("#view_all_app_pass .allowed_ip_entry").click(function(){
		
		var id=$(this).attr('id');

		$("#view_all_app_pass .allowed_ip_entry").addClass("autoheight");
		$("#view_all_app_pass .aw_info").slideUp(300);
		$("#view_all_app_pass .activesession_entry_info").show();
		if($("#view_all_app_pass #"+id).hasClass("Active_ip_showall_hover"))
		{

			$("#view_all_app_pass #"+id).removeClass("Active_ip_showall_hover");
			$("#view_all_app_pass #"+id+" .aw_info").slideUp("fast",function(){
				$("#view_all_app_pass .allowed_ip_entry").removeClass("autoheight");
			});
			$("#view_all_app_pass .activesession_entry_info").show();
		}
		else
		{
			$("#view_all_app_pass .allowed_ip_entry").removeClass("Active_ip_showall_hover");
			$("#view_all_app_pass .allowed_ip_entry").removeClass("Active_ip_showcurrent");
			$("#view_all_app_pass #"+id).addClass("Active_ip_showall_hover");
			$("#view_all_app_pass #"+id+" .aw_info").slideDown(300,function(){
				$("#view_all_app_pass .allowed_ip_entry").removeClass("autoheight");
			});
			$("#view_all_app_pass #"+id+" .activesession_entry_info").hide();
	//		$("#view_all_allow_ip #"+id+" .primary_btn_check").focus();
		}
		
	});
	closePopup(closeview_all_app_view,"app_password_web_more");//No I18N
	
	$("#app_password_web_more").focus();

}


function closeview_all_app_view()
{
	popupBlurHide('#app_password_web_more',function(){	//No i18N
		$("#view_all_app_pass").html("");		
	});
}



/***************************** Device Logins *********************************/

 function load_DeviceLogins(Policies,Devicelogins)
 {
	if(de("Device_logins_exception"))
	{
		$("#Device_logins_exception").remove();
		$("#show_Device_logins #no_Devices").removeClass("hide");
	}
	if(Devicelogins.exception_occured!=undefined	&&	Devicelogins.exception_occured)
	{
		$("#Device_logins_box .box_info" ).after("<div id='Device_logins_exception' class='box_content_div'>"+$("#exception_tab").html()+"</div>" );
		$("#Device_logins_exception #reload_exception").attr("onclick","reload_exception(Device_logins,'Device_logins_box')");
		$("#show_Device_logins #no_Devices").addClass("hide");
		return;
	}
	
//	if(!jQuery.isEmptyObject(security_data.DeviceLogins))
	$("#display_all_Devices").html("");
	var count=0;
	var hideCount = security_data.DeviceLogins.client_apps?2:3;
	if(!jQuery.isEmptyObject(security_data.DeviceLogins.Platform_Logins))
	{
		var platform_logins=security_data.DeviceLogins.Platform_Logins;
		$("#show_Device_logins #no_Devices").hide();
		$("#display_all_Devices").show();
		var devices=Object.keys(platform_logins);
		for(var iter=0;iter<devices.length;iter++)
		{
			var current_device=platform_logins[devices[iter]];
			Device_logins_format = $("#empty_Device_logins_format").html();
			$("#display_all_Devices").append(Device_logins_format);
			$("#display_all_Devices #Device_logins_entry").attr("id","Device_logins_entry"+count);
			$("#display_all_Devices #Device_logins_info").attr("id","Device_logins_info"+count);
			
			$("#Device_logins_entry"+count).attr("onclick","show_selected_devicelogins_info("+count+");");
			
			$("#Device_logins_entry"+count+" .device_name").html(devices[iter]);
			
			$("#Device_logins_entry"+count+" .mail_client_logo").html(devices[iter].substr(0,2).toUpperCase());//No I18N
			$("#Device_logins_entry"+count+" .mail_client_logo").addClass(color_classes[gen_random_value()]);
						
			if(platform_logins[devices[iter]].length==1)
			{
				//$("#Device_logins_entry"+count+" .device_time").html(Devicelogins[devices[iter]][0].device_name);
				if(platform_logins[devices[iter]][0].location!=undefined)
				{
					$("#Device_logins_entry"+count+" .asession_location").html(platform_logins[devices[iter]][0].location);
				}
				
			}
			else
			{
				//$("#Device_logins_entry"+count+" .device_time").html(Devicelogins[devices[iter]].length+" "+Devices);
				$("#Device_logins_entry"+count+" .asession_location").html(platform_logins[devices[iter]].length+" "+Locations);
			}
			if(count >= hideCount)
			{
				$("#Device_logins_entry"+count).addClass("allowed_ip_entry_hidden");  
			}
			
			var locations_count=0;
			for(devices_iter=0;devices_iter<platform_logins[devices[iter]].length;devices_iter++)
			{
				locations_count++;
				var current_browser=platform_logins[devices[iter]][devices_iter];
				
				Device__format = $("#empty_Devices_format").html();
				
				$("#display_all_Devices #Device_logins_info"+count).append(Device__format);
				
				$("#display_all_Devices #Device_logins_info"+count+" #Devices_entry").attr("id","Devices_entry"+locations_count);
				
				$("#display_all_Devices #Device_logins_info"+count+" #Devices_entry"+locations_count+" #devicelogins_entry_info").attr("id","devicelogins_entry_info"+locations_count);
				
				$("#Device_logins_info"+count+" #Devices_entry"+locations_count+" .asession_browser").addClass("browser_"+current_browser.browser_info.browser_image);
				$("#Device_logins_info"+count+" #Devices_entry"+locations_count+" .asession_browser").attr('title',current_browser.browser_info.browser_version);
				
				$("#Device_logins_info"+count+" #Devices_entry"+locations_count+" .device_name").html(current_browser.browser_info.browser_name);
				$("#Device_logins_info"+count+" #Devices_entry"+locations_count+" .device_login_tim").html(current_browser.last_accessed_elapsed);
				$("#Device_logins_info"+count+" #Devices_entry"+locations_count+" .devicelogins_entry_info .asession_os").addClass("os_"+current_browser.device_info.os_img);
				$("#Device_logins_info"+count+" #Devices_entry"+locations_count+" .devicelogins_entry_info .asession_os").attr('title',current_browser.device_info.os_name)
				
				if(current_browser.location!=undefined)
				{
					$("#Device_logins_info"+count+" #Devices_entry"+locations_count+" .devicelogins_entry_info .asession_location").html(current_browser.location);
				}
				
				$("#Device_logins_info"+count+" #Devices_entry"+locations_count+" .deleteicon").attr("onclick","delete_current_trusted_entry("+count+","+locations_count+",\'"+devices[iter]+"\',\'"+current_browser.device_id+"\');");

				
			}
			
			
			count++;
		}

	}
	if(!jQuery.isEmptyObject(security_data.DeviceLogins.client_apps))
	{
		$("#show_Device_logins #no_Devices").hide();
		$("#display_all_Devices").show();
		Device_logins_format = $("#empty_Device_logins_format").html();
		$("#display_all_Devices").append(Device_logins_format);
		$("#display_all_Devices #Device_logins_entry").attr("id","Device_logins_entry"+count);
		$("#display_all_Devices #Device_logins_info").attr("id","Device_logins_info"+count);
		
		$("#Device_logins_entry"+count).attr("onclick","show_selected_devicelogins_info("+count+");");
		
		$("#Device_logins_entry"+count+" .device_name").html(mail_client);
		$("#Device_logins_entry"+count+" .mail_client_logo").html(mail_client.substr(0,2).toUpperCase());//No I18N
		$("#Device_logins_entry"+count+" .mail_client_logo").addClass(color_classes[gen_random_value()]);
		
		var mail_client_logins=security_data.DeviceLogins.client_apps;
		var client_APPS=Object.keys(mail_client_logins);
		
		if(client_APPS.length==1)
		{
			//$("#Device_logins_entry"+count+" .device_time").html(Devicelogins[devices[iter]][0].device_name);
			if(mail_client_logins[client_APPS[0]].location!=undefined)
			{
				$("#Device_logins_entry"+count+" .asession_location").html(mail_client_logins[client_APPS[0]].location);
			}
		}
		else
		{
			$("#Device_logins_entry"+count+" .asession_location").html(client_APPS.length+" "+Locations);
		}
		if(count > 3)
		{
			$("#Device_logins_entry"+count).addClass("allowed_ip_entry_hidden");  
		}
		var locations_count=0;
		for(var client_iter=0;client_iter<client_APPS.length;client_iter++)
		{
			locations_count++;
			var current_client=mail_client_logins[client_APPS[client_iter]];
			Device__format = $("#empty_Devices_format").html();
			$("#display_all_Devices #Device_logins_info"+count).append(Device__format);
			$("#display_all_Devices #Device_logins_info"+count+" #Devices_entry").attr("id","Devices_entry"+locations_count);
			$("#display_all_Devices #Device_logins_info"+count+" #Devices_entry"+locations_count+" #devicelogins_entry_info").attr("id","devicelogins_entry_info"+locations_count);
			
			
			$("#Device_logins_info"+count+" #Devices_entry"+locations_count+" .asession_browser").attr('class', '');
			
			$("#Device_logins_info"+count+" #Devices_entry"+locations_count+" .device_name").html(current_client.location);
			 
			$("#Device_logins_info"+count+" #Devices_entry"+locations_count+" .device_name").addClass("device_client_name");
			
			if(current_client.location!=undefined)
			{
				$("#Device_logins_info"+count+" #Devices_entry"+locations_count+" .device_name").html(current_client.location);
			}
			$("#Device_logins_info"+count+" #Devices_entry"+locations_count+" .device_login_tim").html(current_client.last_accessed_elapsed);
			
			$("#Device_logins_info"+count+" #Devices_entry"+locations_count+" .devicelogins_entry_info .asession_os").attr('class', '');
			$("#Device_logins_info"+count+" #Devices_entry"+locations_count+" .devicelogins_entry_info .asession_os").attr('title',"")
			

			$("#Device_logins_info"+count+" #Devices_entry"+locations_count+" .devicelogins_entry_info .asession_location").html("");
			
			$("#Device_logins_info"+count+" #Devices_entry"+locations_count+" .deleteicon").attr("onclick","delete_current_trusted_MailClient_entry("+count+","+locations_count+",\'"+client_APPS[client_iter]+"\',\'"+current_client.device_id+"\');");
		}
		count++;
	}
	if(count>3)
	{
		$("#Device_logins_viewmore").show();
	}
	else if(count==0)
	{
		$("#display_all_Devices").hide();
		$("#display_all_Devices").html("");
		$("#show_Device_logins #no_Devices").show();
	}
	return;
	 
 }

 function  delete_current_trusted_MailClient_entry(platform_id,location_id,platform_name,device_id)
 {
	new URI(Mail_ClientLoginsObj,"self","self",device_id).DELETE().then(function(resp)	//No I18N
			{
				SuccessMsg(getErrorMessage(resp));
				var deleted=false;
				if(security_data.DeviceLogins.client_apps!=undefined	&&	security_data.DeviceLogins.client_apps[platform_name]!=undefined)
				{
					if(security_data.DeviceLogins.client_apps[platform_name]!=undefined)
					{
						delete security_data.DeviceLogins.client_apps[platform_name];
						deleted=true;
					}
				}
				load_DeviceLogins(security_data.Policies,security_data.DeviceLogins);
				
				
				if($("#Device_logins_web_more").is(":visible")==true)
				{
					 $("#view_all_Device_logins").html("");
					show_all_device_logins();
					if(!deleted)
					{
						$("#view_all_Device_logins #Device_logins_entry"+platform_id).click();
					}
				}
				else
				{
					if(deleted)
					{
						closeview_selected_Device_logins_view();
					}
					else
					{
						$("#Device_logins_current_info #Devices_entry"+location_id).remove();
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
 
 
 
function  delete_current_trusted_entry(platform_id,location_id,platform_name,device_id)
{
	new URI(DeviceLoginsObj,"self","self",device_id).DELETE().then(function(resp)	//No I18N
	{
		SuccessMsg(getErrorMessage(resp));
		var deleted=false;
		if(security_data.DeviceLogins.Platform_Logins!=undefined	&&	security_data.DeviceLogins.Platform_Logins[platform_name]!=undefined)
		{
			security_data.DeviceLogins.Platform_Logins[platform_name].splice(location_id-1,1);
			if(security_data.DeviceLogins.Platform_Logins[platform_name].length==0)
			{
				delete security_data.DeviceLogins.Platform_Logins[platform_name];
				deleted=true;
			}
		}
		load_DeviceLogins(security_data.Policies,security_data.DeviceLogins);
		
		
		if($("#Device_logins_web_more").is(":visible")==true)
		{
			 $("#view_all_Device_logins").html("");
			show_all_device_logins();
			if(!deleted)
			{
				$("#view_all_Device_logins #Device_logins_entry"+platform_id).click();
			}
		}
		else
		{
			if(deleted)
			{
				if(security_data.DeviceLogins.Platform_Logins[platform_name] == undefined){
					closeview_selected_Device_logins_view();
				}
			}
			else
			{
				$("#Device_logins_current_info #Devices_entry"+location_id).remove();
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

 function show_selected_devicelogins_info(id)
 {
	 	tooltip_Des("#Device_logins_current_info .action_icon");//No I18N
		tooltip_Des("#Device_logins_current_info .asession_os");	//No I18N
		$("#Device_logins_pop #platform_img").removeClass();
//		$("#App_logins_pop .device_pic").attr("class","device_pic");
		$("#Device_logins_pop #platform_img").addClass($("#Device_logins_entry"+id+" .mail_client_logo:visible")[0].classList.value);
		$("#Device_logins_pop #platform_img").text($("#Device_logins_entry"+id+" .mail_client_logo:visible").text());
		$("#Device_logins_pop .device_name").html($("#Device_logins_entry"+id+" .device_name").html()); //load into popuop
		
		$("#Device_logins_pop #Device_logins_current_info").html($("#Device_logins_info"+id).html()); //load into popuop
		
		
		popup_blurHandler('6','.5');
		$("#Device_logins_pop").show(0,function(){
			$("#Device_logins_pop").addClass("pop_anim");
		});
		tooltipSet("#Device_logins_current_info .action_icon");//No I18N
		sessiontipSet("#Device_logins_current_info .asession_os");//No I18N
		closePopup(closeview_selected_Device_logins_view,"Device_logins_pop"); //No I18N
		$("#Device_logins_pop").focus();
 }
 
 
 function closeview_selected_Device_logins_view()
 {
	 popupBlurHide("#Device_logins_pop");	//No I18N
 }
 
 
 
 function show_all_device_logins()
 {
	 $("#view_all_Device_logins").html($("#display_all_Devices").html()); //load into popuop
	 tooltip_Des("#view_all_Device_logins .action_icon");//No I18N
	 tooltip_Des("#view_all_Device_logins .asession_os");	//No I18N
	 popup_blurHandler('6','.5');
		//$("#view_all_app_pass .authweb_entry").after( "<br />" );
		//$("#view_all_app_pass .authweb_entry").addClass("viewall_authwebentry");
		$("#view_all_Device_logins .devicelogins_entry").removeAttr("onclick");
		$("#view_all_Device_logins .devicelogins_entry").show();
		
		$("#Device_logins_web_more").show(0,function(){
			$("#Device_logins_web_more").addClass("pop_anim");
		});
		
		$("#view_all_Device_logins .devicelogins_entry").click(function()
		{
			var id=$(this).attr('id');
			
			tooltip_Des(".devicelogins_entry .aw_info .action_icon");//No I18N
			
			$("#view_all_Device_logins .devicelogins_entry").addClass("autoheight");
			$("#view_all_Device_logins .aw_info").slideUp(300);
			$("#view_all_Device_logins .activesession_entry_info").show();
			if($("#view_all_Device_logins #"+id).hasClass("Active_ip_showall_hover"))
			{

				$("#view_all_Device_logins #"+id+" .aw_info").slideUp("fast",function(){
					$("#view_all_Device_logins #"+id).removeClass("Active_ip_showall_hover");
					$("#view_all_Device_logins .devicelogins_entry").removeClass("autoheight");
				});
				$("#view_all_Device_logins .activesession_entry_info").show();
			}
			else
			{
				$("#view_all_Device_logins .devicelogins_entry").removeClass("Active_ip_showall_hover");
				$("#view_all_Device_logins .devicelogins_entry").removeClass("Active_ip_showcurrent");
				$("#view_all_Device_logins #"+id).addClass("Active_ip_showall_hover");
				$("#view_all_Device_logins #"+id+" .aw_info").slideDown(300,function(){
					$("#view_all_Device_logins .devicelogins_entry").removeClass("autoheight");
					tooltipSet(".devicelogins_entry .aw_info .action_icon");//No I18N
				});
				$("#view_all_Device_logins #"+id+" .activesession_entry_info").hide();
		//		$("#view_all_allow_ip #"+id+" .primary_btn_check").focus();
			}
			
		});
		tooltipSet("#view_all_Device_logins .action_icon");//No I18N
		sessiontipSet("#view_all_Device_logins .asession_os");//No I18N
		closePopup(closeview_Device_logins_view,"Device_logins_web_more");//No I18N
		$("#Device_logins_web_more").focus();
 }
 
 
 function closeview_Device_logins_view()
 {
 	popupBlurHide("#Device_logins_web_more",function(){		//No I18N
 		$("#view_all_Device_logins").html("");
 	});
 }
