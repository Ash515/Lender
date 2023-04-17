	//$Id$
var d = new Date();
var n;

var  primary_email="";
var  login_mobile="";
function load_emaildetails(policies,emailDetail)
{
	if(de("email_exception"))
	{
		$("#email_exception").remove();
	}
	if(emailDetail.exception_occured!=undefined	&&	emailDetail.exception_occured)
	{
		$( "#email_box .box_info" ).after("<div id='email_exception' class='box_content_div'>"+$("#exception_tab").html()+"</div>" );
		$("#email_exception #reload_exception").attr("onclick","reload_exception(EMAIL,'email_box')");
		return;
	}
	tooltip_Des(".field_email .action_icon");//No I18N
	var email_keys=timeSorting(emailDetail);
	
	  if(Object.keys(profile_data.Email).length<1)
	  {
	    $("#no_email_add_here").removeClass("hide");
	    if(!$("#emailID_prim").hasClass("hide"))
	    {
	      $("#emailID_prim").addClass("hide");
	    }
	    if(!policies.ADD_SECONDARY_EMAIL)
	    {
	    	$("#no_email_add_here .primary_btn_check").hide();
	    }
	    else
	    {
	    	$("#no_email_add_here .primary_btn_check").show();
	    }
	  }
	  var sec_count=0;
	  $(".emailID_sec").html("");
	  $("#emailID_prim").addClass("hide");
//	  primary_email.email_id=profile_data.primary_email;
	  for(iter=0;iter<Object.keys(profile_data.Email).length;iter++)
	  {
		$("#email_content").removeClass("hide");
	    var current_email=profile_data.Email[email_keys[iter]];
	    if(current_email.is_primary)
	    {
	    	$("#emailID_prim").removeClass("hide");
//	        primary_email=current_email;

	        $("#emailID_info0 .email_hover").html("");
	        $("#no_email_add_here").addClass("hide");
	        $(".email_popup_forgotpass").show();
	        if(profile_data.primary_email==undefined)
	        {
	          $(".email_popup_forgotpass").hide();
	        }
	        if(current_email.email_id_ejs)
	        {
	          $("#emailID_prim").removeClass("hide");
	          $("#primary_emailid").html(current_email.email_id);
	          if(isMobile)
	          {
	            $(".email_hover_show").addClass("hide");
	          }
//	          else
//	          {
////	            $(".left_arrow").addClass("hide");
//	          }
	          
	          if(de("em_icon_delete_0") && profile_data.login_mobile!=undefined)
	          {
	        	  $('#em_icon_delete_0').show();
	        	  $('#em_icon_delete_0').attr("onclick","deleteEmail(\'"+current_email.email_id_ejs+"\',\'"+profile_data.primary_email+"\')");
	          }
	          else
        	  {
	        	  $('#em_icon_delete_0').hide();
	        	  $('#em_icon_delete_0').attr("onclick","");
        	  }
	          
	          if(!current_email.is_verified)//not confirmed
	          {
	            $("#PrimConfim").removeClass("hide");
	            $("#prim_em_time").hide();
	            if(de("em_icon_resend_0"))
	            {
	            	$('#em_icon_resend_0').show();
	            }
//	            $('#em_icon_resend_0').attr("onMouseOver", 'show_resendConfirmation(\''+current_email.email_id+'\',\'0\')');

	            $("#resend_0 .resend_em_text").html(formatMessage(em_resend_conf, current_email.email_id));
	            $("#resend_0 .resend_grn_btn").attr("onclick",'resendConfirmation(\''+current_email.email_id_ejs+'\',\'0\')');
	            tippy("#em_icon_resend_0", {		  //No I18N
	    			animation: 'scale',					//No I18N
	    			trigger: 'click mouseenter',				//No I18N
	    			appendTo:document.querySelector('#em_icon_resend_0').parentNode,//No I18N
	    			theme:'light',				//No I18N
	    			livePlacement: false,
	    			maxWidth: '300px',			//No I18N
	    			arrow: true,
	    			html: '#resend_0',		//No I18N
	    			hideOnClick: true,
	    			interactive: true
	    		});
	          }
	          else
	          {
	        	$("#PrimConfim").addClass("hide");
	        	$("#prim_em_time").show();
	            $("#prim_em_time").html(current_email.created_time_elapsed);
	            if(de("em_icon_resend_0"))
	            {
	            	$('#em_icon_resend_0').hide();
	            }
	          }
	          if(!policies.CHANGE_FULL_NAME)
	          {
	        	  $("#em_icon_edit_0").hide();
	          }
	          else
	          {
	        	  $("#em_icon_edit_0").show();
	          }
	        }  
	    }
	    else
	    {  
	      ++sec_count;
	      
	      secondary_format = $("#empty_secondary_format").html();
	      var sec_em_id=current_email.created_time+"_secondary";//No i18N
	      
	      $(".emailID_sec").append(secondary_format);
	      
	      $(".emailID_sec #sec_emailDetails").attr("id","emailID_num_"+sec_count);
	      
	      $("#emailID_num_"+sec_count).attr("onclick",'for_mobile_specific_email(\'emailID_num_'+sec_count+'\')');
	      
	      if(sec_count > 2)
	      {
	        $("#emailID_num_"+sec_count).addClass("extra_emailids");  
	      }
	      
	      $("#emailID_num_"+sec_count+" .email_info .emailaddress_text").attr("id",sec_em_id);//No i18N
//	      if(current_email.is_FB_em)
//	      {
//	        $("#emailID_num_"+sec_count+" .email_info .emailaddress_text").html(Fbaccount);
//	      }
//	      else
//	      {
	        $("#emailID_num_"+sec_count+" .email_info .emailaddress_text").html(current_email.email_id);
//	      }
	      
	      $("#emailID_num_"+sec_count+" .email_hover_show").attr("id",'emailID_info'+sec_count);
	              
	      if(!current_email.is_verified)//not confirmed	
	      {
	        $("#emailID_num_"+sec_count+" .email_info #secondary_unconfirmed").show();
	        $("#emailID_num_"+sec_count+" .email_info #secondary_time").hide();

	        $("#emailID_info"+sec_count+" .resendconfir").attr("id",'em_icon_resend_'+sec_count);
//	        $('#em_icon_resend_'+sec_count).attr("onMouseOver", 'show_resendConfirmation(\''+current_email.email_id+'\',\''+sec_count+'\')');
	        
	        $("#emailID_info"+sec_count+" .resend_options").attr("id",'resend_'+sec_count);
	        $("#resend_"+sec_count+" .resend_em_text").html(formatMessage(em_resend_conf, current_email.email_id));
	        $("#resend_"+sec_count+" .resend_grn_btn").attr("onclick",'resendConfirmation(\''+current_email.email_id_ejs+'\',\''+sec_count+'\')');
            tippy("#em_icon_resend_"+sec_count, {		  //No I18N
    			animation: 'scale',					//No I18N
    			trigger: 'click mouseenter',				//No I18N
    			appendTo:document.querySelector('#em_icon_resend_'+sec_count).parentNode,//No I18N
    			theme:'light',				//No I18N
    			livePlacement: false,
    			maxWidth: '300px',			//No I18N
    			arrow: true,
    			html: '#resend_'+sec_count,		//No I18N
    			hideOnClick: true,
    			interactive: true
    		});
	        
            $("#emailID_info"+sec_count+" .action_icons_div .mkeprimary").remove();
            
	      }
	      else
	      {
	    	  $("#emailID_num_"+sec_count+" .email_info #secondary_unconfirmed").hide();
	          $("#emailID_num_"+sec_count+" .email_info #secondary_time").show();
	          $("#emailID_num_"+sec_count+" .email_info #secondary_time").html(current_email.created_time_elapsed);
	          
	          $("#emailID_info"+sec_count+" .resendconfir").remove();
	          $("#emailID_info"+sec_count+" .resend_options").remove();
	    	  if(policies.CHANGE_PRIMARY_EMAIL)//make primary
		       {
	         	 	$("#emailID_info"+sec_count+" .action_icons_div .mkeprimary").attr("onclick",'showEmail_changePrimary(\''+sec_em_id+'\',\'setAsPrimary\');');
	         	 	$("#emailID_info"+sec_count+" .action_icons_div .mkeprimary").attr("id","em_icon_MKprim_"+sec_count);
		       }
	    	   else
	    	   {
	    		   $("#emailID_info"+sec_count+" .action_icons_div .mkeprimary").remove();
	    	   }
	      }
//	      if(!current_email.is_FB_em)
//	      {
//	    	  $("#emailID_info"+sec_count+" .action_icons_div .icon-edit").attr("id","em_icon_edit_"+sec_count);
//	    	  $("#em_icon_edit_"+sec_count).attr("onclick",'showEmail_editpopup(\''+sec_em_id+'\',"",0);');
	          $("#emailID_info"+sec_count+" .action_icons_div .icon-delete").attr("onclick","deleteEmail(\'"+current_email.email_id_ejs+"\',\'"+primary_email.email_id_ejs+"\')");
	          $("#emailID_info"+sec_count+" .action_icons_div .icon-delete").attr("id","em_icon_delete_"+sec_count);
	          $("#emailID_info"+sec_count+" .action_icons_div .icon-delete").show();
//	      }
//	      else
//	      {
//	    	  if(policies.change_email)//make primary
//		       {
//		           $("#emailID_info"+sec_count+" .action_icons_div .mkeprimary").attr("onclick",'showEmail_changePrimary(\''+sec_em_id+'\',\'setFBPrimary\');');
//		           $("#emailID_info"+sec_count+" .action_icons_div .mkeprimary").attr("id","em_icon_MKprim_"+sec_count);
//		       }
//	    	   $("#emailID_info"+sec_count+" .action_icons_div .icon-delete").attr("id","em_icon_delete_"+sec_count);
//	    	   $("#emailID_info"+sec_count+" .action_icons_div .icon-delete").attr("onclick","return unlinkFacebook()"); 
//	      }
	    }
	    $("#emailID_num_"+iter+" .email_dp").addClass(color_classes[gen_random_value()]);
	  }
	  if(isMobile)
	  {
	    $("#email_content .email_hover_show").addClass("hide");
	  }
	  $("#email_box .addnew").show();
	  $("#email_add_view_more").show();
	  if(policies.ADD_SECONDARY_EMAIL && (Object.keys(profile_data.Email).length>0))//CAN ADD AND NOT EMPTY
	  {
		  if(sec_count<3)//less THAN 3
		  {
			  $("#email_justview").hide();
			  $("#email_add_view_more").hide();
		  }
		  else
		  {
			  $("#email_justaddmore").hide();
			  $("#email_justview").hide();
		  }
	  }
	  else if(!policies.ADD_SECONDARY_EMAIL && (Object.keys(profile_data.Email).length>0)) //cant add but more than 3
	  {
		  if(sec_count>2)
		  {	  
			  $("#email_add_view_more").hide();
			  $("#email_justaddmore").hide();	  
		  }
		  else
		  {
			  $("#email_justaddmore").hide();
			  $("#email_justview").hide();
			  $("#email_justview").hide();
			  $("#email_add_view_more").hide();
		  }
	  }
	  else
	  {
		  $("#email_justaddmore").hide();
		  $("#email_justview").hide();
		  $("#email_justview").hide();
		  $("#email_add_view_more").hide();
	  }
	  if(!isMobile){
		  tooltipSet(".field_email .action_icon");//No I18N
	  }
}




//add email
function showaddemail_popup()
{
	remove_error();
	popup_blurHandler('6','.5');

	$("#add_email_popup").show(0,function(){
		$("#add_email_popup").addClass("pop_anim");		
	});
	$("#create_description").show();
	$("#email_otp_description").hide();
	$("#NEWemail_add").show();
	$("#NEWemail_confirmation").hide();
	$('#addemailform')[0].reset();
	control_Enter(".blue"); //No I18N
	$("#add_email_popup .textbox:first").focus();
	closePopup(close_addemail_popup,"add_email_popup");//No I18N
}


function close_addemail_popup()
{
	clearInterval(resend_timer);
	$(".blue").unbind(); 
	popupBlurHide("#add_email_popup",function(){   //No I18N
		$("#addemailform").attr("onsubmit","return add_email(document.addemailid,add_email_callback)");
	});
}

function add_email(form,callback)
{
	if(validateForm(form))
	{
		disabledButton(form);
		var new_emailid=$('#'+form.id).find('input[name="email_id"]').val();
		var parms=
		{
			"email_id":new_emailid//No I18N
		};


		var payload = Email.create(parms);
		payload.POST("self","self").then(function(resp)	//No I18N
		{
			callback(resp,new_emailid);
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

function add_email_callback(emailObj,new_emailid)
{
	SuccessMsg(getErrorMessage(emailObj));
	if(!$("#add_email_popup").is(":visible"))
	{
		showaddemail_popup();
		$('#NEWemail_add').find('input[name="email_id"]').val(new_emailid);
	}
	$("#NEWemail_add").hide();
	$("#NEWemail_confirmation").show();
	var str = $("#email_otp_text").html();
	$("#email_otp_description").html(formatMessage(str,new_emailid));//No I18N 	
	$("#create_description").hide();
	$("#email_otp_description").show();
	resend_countdown("#add_email_popup #emailOTP_resend");//No I18N 	
	$("#addemailform").attr("onsubmit","return confirm_add_email(document.addemailid,confirm_add_email_callback)");
	$("#otp_email_input").focus();
	closePopup(close_addemail_popup,"add_email_popup",true);//No I18N
	//profile_data.Email[emailObj.email.email_id]=emailObj.email;
	//load_emaildetails(profile_data.Policies,profile_data.Email);
	
}

function confirm_add_email(form,callback)
{
	if(validateForm(form))
	{
		if(!isMobile){
			disabledButton(form);			
		}
		var email=$('#'+form.id).find('input[name="email_id"]').val();
		var parms=
		{
			"otp_code":$('#'+form.id).find('input[name="otp_code"]').val()//No I18N
		};
		var payload = Email.create(parms);
		payload.PUT("self","self",email).then(function(resp)	//No I18N
		{
			callback(resp);
			if(!isMobile){
				removeButtonDisable(form);
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
			if(!isMobile){
				removeButtonDisable(form);
			}
		});	
	}
	return false;
}

function confirm_add_email_callback(emailObj)
{
	SuccessMsg(getErrorMessage(emailObj));
	if($("#emails_web_more").is(":visible")){
		closeview_all_email_view();
	}
	$("#NEWemail_add").show();
	$("#NEWemail_confirmation").hide();
	
	profile_data.Email[decodeHTML(emailObj.email.email_id)]=emailObj.email;
	if(profile_data.Email[decodeHTML(emailObj.email.email_id)].is_primary){
		$("#profile_email").html(emailObj.email.email_id);
		profile_data.primary_email=emailObj.email.email_id_ejs;
		profile_data.login_name=emailObj.email.email_id_ejs;
	}
	load_emaildetails(profile_data.Policies,profile_data.Email);
	close_addemail_popup();
}
//delete email


function deleteEmail(emailid,priemail) 
{
    if(priemail.trim() == emailid.trim()) 
    {
    	show_confirm(formatMessage(err_email_sure_delete_prim, emailid),
			    function() 
			    {	new URI(Email,"self","self",emailid).DELETE().then(function(resp)	//No I18N
					{
			    		profile_data.primary_email=profile_data.login_mobile;//no primary email as of now so we will use primary mobile
			    		profile_data.login_name=profile_data.login_mobile;
			    		$("#profile_email").html(profile_data.login_mobile);
						delete_email_callback(resp,emailid);
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
    else 
    {

		show_confirm(formatMessage(err_email_sure_delete1, emailid),
			    function() 
			    {	new URI(Email,"self","self",emailid).DELETE().then(function(resp)	//No I18N
					{
						delete_email_callback(resp,emailid);
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
    $("#confirm_popup button:first").focus();
}
//function unlinkFacebook() {
//
//    
//	show_confirm(confirm_fb_delete,
//		    function() 
//		    {
//				sendRequestURI(contextpath+"/u/em/fbdl",csrfParam,delete_email_callback);  //No I18N
//
//		    },
//		    function() 
//		    {
//		    	return false;
//		    }
//		);
//}

function delete_email_callback(emailObj,emailid)
{
		SuccessMsg(getErrorMessage(emailObj));
		delete profile_data.Email[emailid];
		load_emaildetails(profile_data.Policies,profile_data.Email);
		load_phonedetails(profile_data.Policies,profile_data.Phone);
		if($("#emails_web_more").is(":visible")==true){
			var lenn=Object.keys(profile_data.Email).length;
			if(lenn>1){
				$("#view_all_email").html("");
				goback_mob();
				$("#emails_web_more").hide();
				show_all_emails();
			}
			else{
				closeview_all_email_view();
			}
		}
		else{
			closeview_all_email_view();
		}
}




//make primary email id



function showEmail_changePrimary(element)
{
	remove_error();
	$('#selectedemail').prop("readonly", false);

	$("#selectedemail").val($("#"+element).html());
	$("#selectedemail").attr("readonly","readonly");
	
	var sec_emailid = $("#"+element).html();
	$("#make_email_primary").html(formatMessage(i18nkeys["IAM.PROFILE.EMAILS.MAKE.PRIMARY.DESCRIPTION"],sec_emailid));//No I18N
	$("#mkprim_email_action").attr("onclick", "changePrimary_popup('"+element+ "',changed_primaryemail)");
	
	popup_blurHandler("6",'.5');
	$("#change_primaryEM").show(0,function(){
		$("#change_primaryEM").addClass("pop_anim");
	});
	control_Enter("a"); //No I18N
	control_Enter(".blue"); //No I18N
	$("#mkprim_email_action").focus();
	closePopup(close_change_primaryEM,"change_primaryEM");//No I18N
}


function close_change_primaryEM()
{
	$(".blur").css({"opacity":"0"});
	popupBlurHide("#change_primaryEM",function(){   //No I18N
		$('#Changeemailform')[0].reset();
	});
	$("a").unbind();
	$(".blue").unbind();

}


function changePrimary_popup(element,callback)
{
		var emailid = $("#"+element).html();
		var payload = makePrimary.create();
		payload.PUT("self","self",emailid).then(function(resp)	//No I18N
		{
			callback(resp,emailid);
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
	return;	
}


function changePrimary(form,callback)
{
	
	if(validateForm(form))
	{
		var parms="";
		var emailid =$('#'+form.id).find('input[name="email_id"]').val();

		var payload = makePrimary.create();
		
		payload.PUT("self","self",emailid).then(function(resp)	//No I18N
		{
			callback(resp,emailid);
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
	return;
	
	
}

function changed_primaryemail(emailObj,emailid)
{
	SuccessMsg(getErrorMessage(emailObj));
	//delete profile_data.email_detail[emailid];
	
	if((!isEmpty(profile_data.primary_email))	&&	profile_data.primary_email!=profile_data.login_mobile	)
	{
		profile_data.Email[$("#primary_emailid").html()].is_primary=false;
	}
	profile_data.Email[emailid].is_primary=true;
	profile_data.primary_email=emailid;
	$("#profile_email").html(emailid);
	load_emaildetails(profile_data.Policies,profile_data.Email);
	
	close_change_primaryEM();
	
	if($("#emails_web_more").is(":visible")==true){
		//closeview_all_email_view();
		$("#view_all_email").html("");
		$("#emails_web_more").hide();
		show_all_emails();
	}
}


//resend confirmation for unverfied emails of the previous setup

function resendConfirmation(emid,id_cnt) 
{
	if(document.querySelector('#em_icon_resend_'+id_cnt)!=null)
	{
		document.querySelector('#em_icon_resend_'+id_cnt)._tippy.hide(); //No I18N
	}
	var parms=
	{
		"email_id":emid//No I18N
	};


	var payload = Email.create(parms);
	payload.POST("self","self").then(function(resp)	//No I18N
	{
		if(!$("#emails_web_more").is(":visible")){			
			add_email_callback(resp,emid);
		}
		else{
			$("#view_all_email .web_email_specific_popup .inline_action").slideUp(300,function(){
				$("#view_all_email .web_email_specific_popup .inline_action").html("<div id='email_otp_description' class='inline_action_discription'></div>");

				$("#view_all_email .web_email_specific_popup .inline_action").append($("#add_em_form").html());
				if(!$("#NEWemail_add").is(":visible"))
				{
					$('#view_all_email #NEWemail_add').find('input[name="email_id"]').val(emid);
				}
				$("#view_all_email .web_email_specific_popup .inline_action form").attr("name","viewmore_otp");
				$("#view_all_email .web_email_specific_popup .inline_action form").attr("id","veri_otp_form");
				var str = $("#email_otp_text").html();
				$(".inline_action #email_otp_description").html(formatMessage(str,emid));//No I18N
				$("#view_all_email #NEWemail_add").hide();
				$("#view_all_email #NEWemail_confirmation").show();
				$("#veri_otp_form").attr("onsubmit","return confirm_add_email(document.viewmore_otp,confirm_add_email_callback)");
				$("#view_all_email .web_email_specific_popup .inline_action").slideDown(300);
			});
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

function resendConfirmationCodeForMob(c_code,mobilenum,ele_id){
	if(document.querySelector('#mob_icon_resend_'+ele_id)!=null)
	{
		document.querySelector('#mob_icon_resend_'+ele_id)._tippy.hide(); //No I18N
	}
	var parms=
	{
		"mobile_no":mobilenum,//No I18N
		"countrycode":c_code//No I18N
	};

	if($("#phonenumber_web_more").is(":visible")){
		disabledButton($("#phonenumber_web_more .inline_action"));
	}
	var payload = Phone.create(parms);
	
	payload.POST("self","self").then(function(resp)	//No I18N
	{
		removeButtonDisable($("#phonenumber_web_more .inline_action"))
		if(!$("#phonenumber_web_more").is(":visible")){		
			$("#addphoneonly").trigger('click');
			$(document.addphonenum).find('input[name="mobile_no"]').val(mobilenum);
			Otp_verify_show(resp);
			$("#common_popup .popuphead_define").html(formatMessage(otp_description,mobilenum));
		}
		else{
			SuccessMsg(getErrorMessage(resp));		
			$("#view_all_phonenumber .web_email_specific_popup .inline_action").slideUp(300,function(){
				$("#view_all_phonenumber .web_email_specific_popup .inline_action").html("<div id='email_otp_description' class='inline_action_discription'></div>");

				$("#view_all_phonenumber .web_email_specific_popup .inline_action").append($("#phonenumber_popup_contents").html());
	
				$("#view_all_phonenumber #empty_phonenumber").hide();
				$("#view_all_phonenumber #phonenumber_password").hide();
				$("#view_all_phonenumber #select_existing_phone").hide();
				$("#view_all_phonenumber #select_phonenumber").hide();
				$("#phonenumber_popup_contents form").attr("name","mobile_otp_resend_form_popup");
				$("#phonenumber_popup_contents form").attr("action","");
				$("#view_all_phonenumber #otp_phonenumber").show();
				
				$('#view_all_phonenumber #popup_mobile_action').html(iam_verify_phone_number);
				$("#view_all_phonenumber #email_otp_description").html(formatMessage(otp_description,mobilenum));
				$($('#view_all_phonenumber #phoneNumberform')[0]).attr("id","mobile_resend_otp_form");	//No I18N
				$("#view_all_phonenumber #mobile_resend_otp_form").find('input[name="mobile_no"]').val(mobilenum);
				$('#view_all_phonenumber #popup_mobile_action').attr("onclick","verifyOTP($('#view_all_phonenumber #mobile_resend_otp_form')[0],new_phonum_callback);");
				$("#view_all_phonenumber .web_email_specific_popup .inline_action").slideDown(300);
				$('#view_all_phonenumber #mobile_resend_otp_form #otp_phonenumber_input').attr("onkeydown","remove_error()");
			});
		}
	},
	function(resp)
	{
		removeButtonDisable($("#phonenumber_web_more .inline_action"));
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

// resend the otp for email confirmation


function emailOTP_resendcode(ele)
{
	if(!$("#add_email_popup #emailOTP_resend a").hasClass("resend_otp_blocked"))//countdown is over
	{
		var emid=	$(ele).parents("form").find('input[name="email_id"]').val();	
		if(emid!="")
		{	
			var parms=
			{
				"email_id":emid//No I18N
			};
			var payload = Email.create(parms);
			payload.POST("self","self").then(function(resp)	//No I18N
			{
				SuccessMsg(getErrorMessage(resp));
				resend_countdown("#add_email_popup #emailOTP_resend");//No I18N 
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
	}
}


//for view more in emails

function for_mobile_specific_email(id)
{
	if(isMobile)
	{	
		if(!$("#emails_web_more").is(":visible")){
			remove_error();	
			popup_blurHandler("6",'.5');
			$("#Email_popup_for_mobile").show(0,function(){
				$("#Email_popup_for_mobile").addClass("pop_anim");
			});
			$(".mob_popu_btn_container").show();
			$(".option_container").hide();
			$(".mob_popu_btn_container button").hide();
			if($("#"+id+" .action_icons_div").children().hasClass("icon-makeprimary")){
				$("#btn_to_chng_primary").show();
				$("#btn_to_chng_primary").attr("onclick","show_mob_conform('email_primary','"+$("#change_primaryEM .popuphead_define").html()+"')");//No I18N
			}
			if($("#"+id+" .action_icons_div").children().hasClass("icon-delete")){
				$("#btn_to_delete").show();
				var email = $("#"+id+" .action_icons_div").children(".icon-delete").attr("onclick");
				email = email.slice(email.indexOf("(")+2,email.indexOf(",")-1);
				$("#btn_to_delete").attr("onclick","show_mob_conform('email_delete','"+formatMessage(err_email_sure_delete1,email)+"')");
			}
			if($("#"+id+" .action_icons_div").children().hasClass("verify_icon")){
				$("#btn_to_resend").show();
				var email = $("#"+id+" .action_icons_div").children(".icon-delete").attr("onclick");
				email = email.slice(email.indexOf("(")+2,email.indexOf(",")-1);
				$("#btn_to_resend").attr("onclick","show_mob_conform('email_resend','"+formatMessage(em_resend_conf,email)+"')");
			}
			$("#Email_popup_for_mobile .popuphead_details").html($("#"+id).html());
			$("#Email_popup_for_mobile").focus();
			closePopup(close_for_mobile_specific,"Email_popup_for_mobile");//No I18N
		}
		else{
			if(!$(event.target).parents().hasClass("inline_action")){
				var id_num=parseInt(id.match(/\d+$/)[0], 10);
				var prev_num;
				if($("#view_all_email .inline_action").length)
				{
					prev_num = $("#view_all_email .inline_action").parents(".field_email").attr("id");
					prev_num = parseInt(prev_num.match(/\d+$/)[0], 10);

					if(prev_num == id_num)
					{
						$("#"+id+" .inline_action").slideUp(300,function(){
							$("#"+id+" .inline_action").remove();
						});
						return false;
					}

				}
				$("#view_all_email #"+id).append('<div class="inline_action"></div>');
				$("#view_all_email #"+id+" .inline_action").html($("#Email_popup_for_mobile").html());
	
				if($("#"+id+" .action_icons_div").children().hasClass("icon-makeprimary")){
					$("#view_all_email #"+id+" #btn_to_chng_primary").show();
					$("#view_all_email #"+id+" #btn_to_chng_primary").attr("onclick","show_mob_conform_viewall('email_primary',"+id_num+",'"+$("#change_primaryEM .popuphead_define").html()+"')");//No I18N
				}
				if($("#"+id+" .action_icons_div").children().hasClass("icon-delete")){
					$("#view_all_email #"+id+" #btn_to_delete").show();
					var email = $("#"+id+" .action_icons_div").children(".icon-delete").attr("onclick");
					email = email.slice(email.indexOf("(")+2,email.indexOf(",")-1);
					$("#view_all_email #"+id+" #btn_to_delete").attr("onclick","show_mob_conform_viewall('email_delete',"+id_num+",'"+formatMessage(err_email_sure_delete1,email)+"')");
				}
				if($("#"+id+" .action_icons_div").children().hasClass("verify_icon")){
					$("#view_all_email #"+id+" #btn_to_resend").show();
					var email = $("#"+id+" .action_icons_div").children(".icon-delete").attr("onclick");
					email = email.slice(email.indexOf("(")+2,email.indexOf(",")-1);
					$("#view_all_email #"+id+" #btn_to_resend").attr("onclick","show_mob_conform_viewall('email_resend',"+id_num+",'"+formatMessage(em_resend_conf,email)+"')");
				}
				if(prev_num!=undefined)
				{
					if(prev_num != id_num)
					{
						$("#view_all_email #emailID_num_"+prev_num+" .inline_action").slideUp(300,function(){
							$(".otp_mobile_form").hide();
							$("#view_all_email #emailID_num_"+prev_num+" .inline_action").remove();
						});
						$("#view_all_email #emailID_num_"+id_num+" .inline_action" ).slideDown(300,function(){
							$(".otp_mobile_form").hide();
						});
					}
					else
					{
						var previous=$("#view_all_email #emailID_num_"+prev_num+" .inline_action")[0];
						var newele=$("#view_all_email #emailID_num_"+prev_num+" .inline_action")[1];
						$(previous).slideUp(300,function(){
							$(".otp_mobile_form").hide();
							$(newele).slideDown(300,function(){
								$(previous).remove();
							});
						});
					}
				}
				else
				{
						$("#view_all_email #emailID_num_"+id_num+" .inline_action" ).slideDown(300,function(){
							$(".otp_mobile_form").hide();
						});
				}
			}
		}


	}
}


function closeview_all_email_view()
{
	$("#view_all_phonenumber").html("");
	popupBlurHide("#emails_web_more");   //No I18N
	goback_mob();
	$(".blue").unbind(); //No I18N
}

function show_all_emails()
{
	remove_error();
	tooltip_Des(".field_email .action_icon");//No I18N
	$(".resend_options").hide();
		goback_mob();
		$("#view_all_email").html($(".emailID_prim").html() + $(".emailID_sec").html()); //load into popuop
		popup_blurHandler('6','.5')
		

		$("#emails_web_more").show(0,function(){
			$("#emails_web_more").addClass("pop_anim");
		});
		$("#view_all_email .extra_emailids").show();
//		$("#view_all_email .viewmore").hide();
		$("#view_all_email").show();
		$("#specific_emailID").hide();
		

	
		
		if(isMobile)
		{
			$("#view_all_email .email_hover_show").remove();
		}
		else
		{
			$("#view_all_email .primary").removeAttr("onclick");
			$("#view_all_email .secondary").removeAttr("onclick");
			$("#view_all_email .field_email .action_icons_div span").removeAttr("onclick");
			tooltip_Des("#emails_web_more .verify_icon");//No I18N
			$("#emails_web_more .verify_icon").attr("title",resend_tooltip);
			$("#view_all_email .field_email .action_icons_div span").click(function(){
				
				
				var id=$(this).attr('id');
				var id_num=parseInt(id.match(/\d+$/)[0], 10);
				if($("#view_all_email #"+id).hasClass("selected_icons"))
				{
					return;
				}
				if(id!="em_icon_resend_"+id_num){
					if($("#"+id).attr("onclick"))
					{
						var args=$("#"+id).attr("onclick").split(",");
					}
					else
					{
						var args=$("#"+id).attr("onmouseover").split(",");
					}
				}
				else{
					if($("#"+id).find(".resend_grn_btn").attr("onclick"))
					{
						var args=$("#"+id).find(".resend_grn_btn").attr("onclick").split(",");
					}
					else
					{
						var args=$("#"+id).find(".resend_grn_btn").attr("onmouseover").split(",");
					}
				}
				var prev_num;
				if($("#view_all_email .inline_action").length)
				{
					prev_num = $("#view_all_email .inline_action").parents(".field_email").attr("id");
					prev_num = parseInt(prev_num.match(/\d+$/)[0], 10);

					if(prev_num == id_num)
					{
						$("#emailID_num_"+id_num+" .inline_action").slideUp(300);
					}
				}
				
				
				$("#view_all_email .action_icons_div").removeClass("show_icons");
				$("#view_all_email .field_email .action_icons_div span").removeClass("selected_icons");
				if(id=="em_icon_resend_"+id_num)
				{
					
					var emailID=args[0].split("(")[1].replace(/'/g,'');
					var count=args[1].split(")")[0].replace(/'/g,'');
					
					$("#view_all_email #emailID_num_"+id_num+" .action_icons_div").addClass("show_icons");
					
					$("#view_all_email #"+id).addClass("selected_icons");
					
					$("#view_all_email #emailID_num_"+id_num).append('<div class="inline_action"></div>');
					if($("#view_all_email #emailID_num_"+id_num+" .inline_action").length==2)
					{
						var conf_ele = $("#view_all_email #emailID_num_"+id_num+" .inline_action" )[1];
					}
					else
					{
						var conf_ele=$("#view_all_email #emailID_num_"+id_num+" .inline_action" );
					}
					
					
					$(conf_ele).html('<div class="inline_action_discription">'+formatMessage(em_resend_conf, emailID)+'</div>');
					
					
					$(conf_ele).append('<button id="delete_specific_email" class="primary_btn_check inline_btn nobottom_margin_btn delete_btn" onclick="resendConfirmation(\''+emailID+'\');">'+$("#resend_"+id_num+" .resend_grn_btn").html()+'</button>');
					
					
				}			
				else if(id=="em_icon_MKprim_"+id_num)
				{
					
					
					var element=args[0].split("(")[1].replace(/'/g,'');
					var action=args[1].split(")")[0].replace(/'/g,'');
					
					

					
					$("#view_all_email #emailID_num_"+id_num+" .action_icons_div").addClass("show_icons");
					
					$("#view_all_email #"+id).addClass("selected_icons");
					
					
					
					
					
					$('#selectedemail').prop("readonly", false);
					
					$("#view_all_email #emailID_num_"+id_num).append('<div class="inline_action"></div>');
					
					if($("#view_all_email #emailID_num_"+id_num+" .inline_action").length==2)
					{
						var prim_ele = $("#view_all_email #emailID_num_"+id_num+" .inline_action" )[1];
					}
					else
					{
						var prim_ele = $("#view_all_email #emailID_num_"+id_num+" .inline_action" );
					}
					
					$(prim_ele).append('<div class="inline_action_discription">'+$("#change_primaryEM .popuphead_define").html()+'</div>');
					
					
					$(prim_ele).append($("#change_primaryEM #change_em_form").html());//load into popuop
					
					
					$("#view_all_email #emailID_num_"+id_num+" .inline_action #Changeemailform" ).attr("id","ViewallChangeemailform");
					
					$("#view_all_email #emailID_num_"+id_num+" .inline_action #ViewallChangeemailform").attr("name","Viewall"+action);
					

					$('#view_all_email #emailID_num_'+id_num+' .inline_action #mkprim_email_action').attr("onclick","changePrimary(document.ViewallsetAsPrimary,changed_primaryemail);");
					$("#view_all_email #emailID_num_"+id_num+" .inline_action #selectedemail").val($("#"+element).html());
					$("#view_all_email #emailID_num_"+id_num+" .inline_action #selectedemail").attr("readonly","readonly");
					

					control_Enter(".blue"); //No I18N
					control_Enter(".inline_action a"); //No I18N
				}
				else if(id=="em_icon_delete_"+id_num)
				{
					var emailid= $("#emailID_num_"+id_num+" .emailaddress_text").html();
					
						
						
						$("#view_all_email #emailID_num_"+id_num+" .action_icons_div").addClass("show_icons");
						
						$("#view_all_email #"+id).addClass("selected_icons");
						
						
						$("#view_all_email #emailID_num_"+id_num).append('<div class="inline_action"></div>');
						
						if($("#view_all_email #emailID_num_"+id_num+" .inline_action").length==2)
						{
							var deleteele=$("#view_all_email #emailID_num_"+id_num+" .inline_action" )[1];
						}
						else
						{
							var deleteele=$("#view_all_email #emailID_num_"+id_num+" .inline_action" );
						}
						
						$(deleteele).html('<div class="inline_action_discription">'+formatMessage(err_email_sure_delete1, emailid)+'</div>');
						$(deleteele).append('<button id="delete_specific_email" class="primary_btn_check inline_btn nobottom_margin_btn delete_btn">'+iam_continue+'</button>');
						$("#delete_specific_email").click(function(){
							
						    if($("#emailID_num_0 .emailaddress_text").html().trim() == emailid.trim()) 
						    {
						    	showErrorMessage(err_email_primary_notdlt);
						        return false;
						    }
						    else 
						    {		
				        		
				        		new URI(Email,"self","self",emailid).DELETE().then(function(resp)	//No I18N
				    					{
				    						delete_email_callback(resp,emailid);
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

						});
						
						
				}
				if(prev_num!=undefined)
				{
					if(prev_num != id_num)
					{
						$("#view_all_email .field_email").removeClass("web_email_specific_popup");
						
						$("#emailID_num_"+prev_num+" .inline_action").slideUp(300,function(){
							$("#emailID_num_"+prev_num+" .inline_action").remove();
						});
						$("#view_all_email #emailID_num_"+id_num+" .inline_action" ).slideDown(300,function(){
//							if($("#view_all_email #emailID_num_"+id_num+" .inline_action .textbox:first").length==0){
//								$("#delete_specific_email").focus();
//							}
//							else{
//								$("#view_all_email #emailID_num_"+id_num+" .inline_action .textbox:first" ).focus();
//							}
						});
						
					}
					else
					{
						var previous=$("#emailID_num_"+prev_num+" .inline_action")[0];
						var newele=$("#emailID_num_"+prev_num+" .inline_action")[1];
						$(previous).slideUp(300,function(){
							$(newele).slideDown(300,function(){
								$(previous).remove();
//								if($(newele).find(".textbox:first").length==0){
//									$("#delete_specific_email").focus();
//								}
//								else{
//									$(newele).find(".textbox:first" ).focus();
//								}
							});
							
						});
					}
				}
				else
				{
						$("#view_all_email #emailID_num_"+id_num+" .inline_action" ).slideDown(300,function(){
//							if($("#view_all_email #emailID_num_"+id_num+" .inline_action .textbox:first" ).length==0){
//								$("#delete_specific_email").focus();
//							}
//							else{
//								$("#view_all_email #emailID_num_"+id_num+" .inline_action .textbox:first" ).focus();			
//							}
						});
						
				}

				$("#view_all_email #emailID_num_"+id_num).addClass("web_email_specific_popup");
			});
		}
		tooltipSet("#emails_web_more .action_icon");//No I18N
		tooltipSet(".field_email .action_icon");	//No I18N
		tooltipSet("#emails_web_more .verify_icon");					//No I18N
		$("#emails_web_more").focus();
		closePopup(closeview_all_email_view,"emails_web_more");//No I18N
}

//function goback_mob_email()
//{
//	$("#view_all_email").show();
//	$("#specific_emailID").hide();
//	$("#show_specific_email_info").html("");
//	$(".small_circle").removeClass("small_circle_selected");
//}


//function specific_unlinkFacebook() 
//{
//
//    
//    $("#show_specific_email_info").html("");
//	
//	$("#specific_emailID .small_circle").removeClass("small_circle_selected");
//	$("#specific_emailID #deleteicon_circle").addClass("small_circle_selected");
//	
//	$("#show_specific_email_info").html('<br /><div class="popup_header "><div class="popuphead_details"><span class="popuphead_text">'+delete_EMAIL+'</span><span class="popuphead_define">'+confirm_fb_delete+'</span></div></div>');
//	$("#show_specific_email_info").append('<input class="primary_btn_check  " id="delete_specific_email" type="button" value="'+iam_continue+'">');
//	$("#delete_specific_email").click(function(){
//		    
//				var url=contextpath+"/u/em/fbdl";//No i18N
//				sendRequestURI(url,csrfParam,delete_email_callback);    
//			    return false;
//
//		    });
//}
//
//function specific_deleteEmail(emailid,priemail) 
//{
//
//    
//    $("#show_specific_email_info").html("");
//	
//	$("#specific_emailID .small_circle").removeClass("small_circle_selected");
//	$("#specific_emailID #deleteicon_circle").addClass("small_circle_selected");
//	
//	$("#show_specific_email_info").html('<br /><div class="popup_header "><div class="popuphead_details"><span class="popuphead_text">'+delete_EMAIL+'</span><span class="popuphead_define">'+(formatMessage(err_email_sure_delete1, emailid))+'</span></div></div>');
//	$("#show_specific_email_info").append('<input class="primary_btn_check  " id="delete_specific_email" type="button" value="'+iam_continue+'">');
//	
//	$("#delete_specific_email").click(function(){
//	
//	    if(priemail.trim() == emailid.trim()) 
//	    {
//	    	showErrorMessage(err_email_primary_notdlt);
//	        return false;
//	    }
//	    else 
//	    {
//			
//			var params = "email="+euc(emailid.toLowerCase())+"&"+csrfParam; //No I18N
//    	    var url=contextpath+"/u/em/d";//No i18N
//    		sendRequestURI(url,params,delete_email_callback); 
//		}
//
//	});
//    
//    
//}
//function specific_make_primary(element,heading,description,button,action)
//{
//	$("#show_specific_email_info").html("");
//	
//	$("#specific_emailID .small_circle").removeClass("small_circle_selected");
//	$("#specific_emailID #mk_PRIM_circle").addClass("small_circle_selected");
//	$("#show_specific_email_info").html('<br /><div class="popup_header "><div class="popuphead_details"><span class="popuphead_text">'+heading+'</span><span class="popuphead_define">'+description+'</span></div></div>');
//	$('#popup_email_action span').html(button);
//	$("#email_popup_contents form").attr("name",action);
//	if(action=="setFBPrimary")
//	{
//		$("#email_popup_contents form").attr("action",contextpath+"/u/em/fbpr");//No I18N
//	}
//	else if(action=="setAsPrimary")
//	{
//		$("#email_popup_contents form").attr("action",contextpath+"/u/em/mkprimary");//No I18N
//	}
//	$('#popup_email_action').attr("onclick","validateForm(document."+action+",changed_primaryemail);");
//	
//	
//	$("#inputemail").attr("readonly","readonly");
//	
//	$("#show_specific_email_info").append($("#email_popup_contents").html());//load into popuop
//	
//	$("#show_specific_email_info #inputemail").val($("#"+element).html());
//	$("#specific_emailID #show_specific_email_info form").attr("id","emailform_specific");
//	
//	$("#email_popup_contents form").attr("name","");
//	$("#email_popup_contents form").attr("action","");
//	
//}
//
//function specific_showedit_emailscreen(element,heading,description,button,action,isprimary)
//{
//	$("#show_specific_email_info").html("");
//	
//	$("#specific_emailID .small_circle").removeClass("small_circle_selected");
//	$("#specific_emailID #icon-pencil_circle").addClass("small_circle_selected");
//	$("#show_specific_email_info").html('<br /><div class="popup_header "><div class="popuphead_details"><span class="popuphead_text">'+heading+'</span><span class="popuphead_define">'+description+'</span></div></div>');
//
//	$('#popup_email_action span').html(button);
//
//	
//	$("#email_popup_contents form").attr("name",action);
//	$("#email_popup_contents form").attr("action",contextpath+"/u/em/e");//No I18N
//
//	if(isprimary)
//	{
//		$('#popup_email_action').attr("onclick","validateForm(document."+action+",useremail_success);");
//	}
//	else
//	{
//		$('#popup_email_action').attr("onclick","validateForm(document."+action+",edit_email_callback);");
//	}
//	
//	$("#show_specific_email_info").append($("#email_popup_contents").html());//load into popuop
//	$("#show_specific_email_info #inputemail").val($("#"+element).html());
//	$("#show_specific_email_info #old_emailid").val($("#"+element).html());
//	
//	$("#specific_emailID #show_specific_email_info form").attr("id","emailform_specific");
//	
//	$("#email_popup_contents form").attr("name","");
//	$("#email_popup_contents form").attr("action","");
//}
//
//
//function specific_show_resendConfirmation(heading,description,button,icon_popup,id) 
//{
//	
//	$("#show_specific_email_info").html("");
//	
//	$("#specific_emailID .small_circle").removeClass("small_circle_selected");
//	$("#specific_emailID #resendconfir_circle").addClass("small_circle_selected");
//	
//	$("#show_specific_email_info").html('<br /><div class="popup_header "><div class="popuphead_details"><span class="popuphead_text">'+heading+'</span><span class="popuphead_define">'+formatMessage(description, id)+'</span></div></div>');
//	
//	$('#show_specific_email_info').append("<br /><br /><b>"+note+":</b>"); 
//	$('#show_specific_email_info').append("<div><ul>"+mailpopup_email_tip+"</ul></div>"); 
//
//	
//	$('#show_specific_email_info').append("<button  class='primary_btn_check' onclick='resendConfirmation(\""+id+"\");'>"+button+"</button>");  //No I18N
//	
//	
//}













if(isMobile)
{
	$("#countNameAddDiv option").click(function()
	{
		$("#countNameAddDiv option:selected").text().split('(')[1].split(')')[0];
		return false;
	});
	
	$("#countNameAddDiv option").bind(function(e)
	{
		$("#countNameAddDiv option:selected").text().split('(')[1].split(')')[0];
		return false;
	});
}



//$(document.addemailid.countNameAddDiv).select2({ 
//	width: '67px',
//	templateResult: phoneSelectformat,
//	templateSelection: function (option) {
//		return option.text;
//	},
//    escapeMarkup: function (m) {
//    	return m;
//	}
//}).on("select2:open", function() {
//	       $(".select2-search__field").attr("placeholder", "Search...");
//});
//$('#select2-countNameAddDiv-container').text($( "#countNameAddDiv option:selected" ).text().split('(')[1].split(')')[0]);
//$("#select_phonenumber .select2-selection--single").append("<span class='selectflag'></span>");
//selectFlag();
//selectIndent();






//$('#countNameAddDiv').find('option').remove();
//var x_pos = 20;
//var y_pos = 0;
//$.each(profile_data.countryCode, function(key, value) 
//{   
//	if(x_pos <= -260){
//		x_pos = 20;
//		y_pos = y_pos-14;
//		
//	}
//	x_pos=x_pos-20; 
//  if(key.toUpperCase()===profile_data.userDetails.country.toUpperCase())
//     {
//       $('#countNameAddDiv').append($("<option></option>").attr("value",key).text(value).attr('selected', 'selected').attr('position',(x_pos)+"px "+y_pos+"px"));//No i18N
//     }
//     else
//     {
//       $('#countNameAddDiv').append($("<option></option>").attr("value",key).text(value).attr('position',(x_pos)+"px "+y_pos+"px"));
//});




function load_phonedetails(policies,phoneDetail)
{
	if(de("phone_exception"))
	{
		$("#phone_exception").remove();
		$("#no_phnum_add_here").removeClass("hide");
	}
	if(phoneDetail.exception_occured!=undefined	&&	phoneDetail.exception_occured)
	{
		$( "#phnum_box .box_info" ).after("<div id='phone_exception' class='box_content_div'>"+$("#exception_tab").html()+"</div>" );
		$("#phone_exception #reload_exception").attr("onclick","reload_exception(PHONE,'phnum_box')");
		$("#no_phnum_add_here").addClass("hide");
		return;
	}
	tooltip_Des(".field_mobile .action_icon");//No I18N

		if(jQuery.isEmptyObject(phoneDetail))
		{
		      $("#no_phnum_add_here").removeClass("hide");
		      $(".phone_number_content").addClass("hide");
		      
		      $("#phone_add_view_more").addClass("hide");
		      $(".separate_addnew").hide();
		      
		      $("#addfrom_backup").hide();
	    	  $("#add_newnobackup").show();
		}
		else
		{
			$("#no_phnum_add_here").addClass("hide");
			$(".phone_number_content").removeClass("hide");
			
			
			if(!jQuery.isEmptyObject(phoneDetail.tfa))
		    {
		      $('#backupnumber').find('option').remove();
		      var tfa_num = Object.keys(phoneDetail.tfa);
		      for(i=0;i<tfa_num.length;i++)
		      { 
		    	  var number= phoneDetail.tfa[tfa_num[i]];
		    	  $('#backupnumber').append($("<option></option>").attr("value",tfa_num[i]).text(number.display_number));
		      }
//	    	  $("#add_newnobackup").hide();
//	    	  $("#addfrom_backup").css("display","block");
		      $("#addfrom_backup").hide();
	    	  $("#add_newnobackup").show();
	    	  if(	jQuery.isEmptyObject(phoneDetail.recovery)	&&	jQuery.isEmptyObject(phoneDetail.unverfied)	)
	    	  {
	    		  $("#no_phnum_add_here").removeClass("hide");
			      $(".phone_number_content").addClass("hide");
	    	  }
		    }
			else
			{
				  $("#addfrom_backup").hide();
		    	  $("#add_newnobackup").show();
			}
			
	      //Recovery Numbers
			var sec_count=0;
			if(profile_data.login_mobile!=undefined)
			{
				sec_count++;
			}
			if(!jQuery.isEmptyObject(phoneDetail.recovery))
		    {
		      var phnum =timeSorting(phoneDetail.recovery);	      
		      if(primary_email==undefined)
		      {
		        $("#tfa_phonenumber_password .blue").hide();
		        $("#phonenumber_password .blue").hide();
		      }
		      else
		      {
		    	  $("#tfa_phonenumber_password .blue").show();
			        $("#phonenumber_password .blue").show();
		      }
		      
		      $(".phone_number_content").removeClass("hide");
		      $("#no_phnum_add_here").addClass("hide");
		      var primary_exist=false;
		      $('#editscreenname').find('option').remove();
		      $(".phonenumber_prim").addClass("hide");
		      $(".phonenumber_sec").html("");
		      for(i=0;i<phnum.length;i++)
		      { 
		    	var current_phone=phoneDetail.recovery[phnum[i]];
		    	if(login_mobile=="")
		    	{
			    	if(profile_data.login_mobile!=undefined)
			    	{
			    		login_mobile=profile_data.login_mobile.split("-")[1]
			    	}
		    	}
		    	if(current_phone.mobile==login_mobile)
		        {
		            primary_exist=true;
		            $(".phonenumber_prim").removeClass("hide");
		            $("#primary_mobid").html(current_phone.display_number);
		            $("#prim_mob_time").html(current_phone.created_time_elapsed);
		          
		            if(isMobile)
		            {
		              $("#phonenumber_info0").addClass("hide");
		            }
//		            else
//		            {
//		//	              $(".phonenumber_prim .left_arrow").addClass("hide");
//		            }
		            
		            //$("#phonenumber_info0 .action_icons_div_ph").html("");
		            if(phnum.length<=1)
		            {
		              $("#ph_icon_edit_0").hide();
		            }
		            else
		            {
		            	$("#ph_icon_edit_0").show();
		            }
		            if(de("ph_icon_delete_0")	&& isEmailId(profile_data.primary_email))
		            {
		            	$("#ph_icon_delete_0").show();
		            	$("#ph_icon_delete_0").attr("onclick",'deleteMobile(\''+current_phone.mobile+'\');');
		            }	
		            else{
						$("#ph_icon_delete_0").hide();
		            	$("#ph_icon_delete_0").attr("onclick",'');
		            }	    	   
		        }
		        else
		        {
		        	sec_count++;
		          
		          	secondary_format = $("#empty_phone_format").html();
		          
		            $('#editscreenname').append($("<option></option>").attr("value",phnum[i]).text(current_phone.display_number));       
	
		          	$(".phonenumber_sec").append(secondary_format);
		          	$(".phonenumber_sec #sec_phoneDetails").attr("id","mobile_num_"+sec_count);
		          	
		          	if(sec_count > 3)
		          	{
		          		$("#mobile_num_"+sec_count).addClass("extra_phonenumbers"); 
		          	}
		          	
		          	
		          	$("#mobile_num_"+sec_count).attr("onclick","for_mobile_specific('mobile_num_"+sec_count+"') "); 
		          	
		          	$("#mobile_num_"+sec_count+" .mobile_info .emailaddress_text").html(current_phone.display_number);
		          	$("#mobile_num_"+sec_count+" .mobile_info .emailaddress_addredtime").html(current_phone.created_time_elapsed);
		          	$("#mobile_num_"+sec_count+" #phonenumber_infohover").attr("id",'phonenumber_info'+sec_count);
		          
	//	          	if(!isMobile)
	//	          	{
	//	           	 $("#mobile_num_"+sec_count+" .left_arrow").addClass("hide");
	//	          	}
		          
		          	var onclick;
		          	$("#mobile_num_"+sec_count+" .action_icons_div_ph #icon-primary").attr("id",'ph_icon_MKprim_'+sec_count);//No i18N
		          	onclick = $("#ph_icon_MKprim_"+sec_count).attr("onclick");
		          	onclick=onclick.split(");");
		          	onclick[0]+=",'"+current_phone.display_number+"','editPrimary','sec_count');"
		          	$("#ph_icon_MKprim_"+sec_count).attr("onclick",onclick[0]);
		          
		          	$("#mobile_num_"+sec_count+" .action_icons_div_ph .icon-delete").attr("id",'ph_icon_delete_'+sec_count);//No i18N
		          	$("#ph_icon_delete_"+sec_count).attr("onclick",'deleteMobile(\''+current_phone.mobile+'\');');
		        }
		    	$("#mobile_num_"+i+" .mobile_dp").addClass(color_classes[gen_random_value()]);
		    	$("#mobile_num_"+sec_count+" .action_icons_div_ph .verify_icon").remove();
		      }
	    	}
	      
	      if(!jQuery.isEmptyObject(phoneDetail.unverfied))
		  {	   
	    	  $(".phonenumber_unverfied").html("");
	    	  $(".phone_number_content").removeClass("hide");
		      //unverfied numbers
		      var unv_phnum = timeSorting(phoneDetail.unverfied);	  
		      for(i=0;i<unv_phnum.length;i++)
		      { 
			    	var current_phone=phoneDetail.unverfied[unv_phnum[i]];
			    	sec_count++;
	  	          
			    	secondary_format = $("#empty_phone_format").html();
		          	$(".phonenumber_unverfied").append(secondary_format);
		        	$(".phonenumber_unverfied #sec_phoneDetails").attr("id","mobile_num_"+sec_count);
		        	
		        	if(sec_count > 3)
		        	{
		        		$("#mobile_num_"+sec_count).addClass("extra_phonenumbers"); 
		        	}
		        	
		        	
		        	$("#mobile_num_"+sec_count).attr("onclick","for_mobile_specific('mobile_num_"+sec_count+"') "); 
		        	
		        	$("#mobile_num_"+sec_count+" .Mob_resend_confirmation").attr("id",'mob_icon_resend_'+sec_count);
		            $("#mobile_num_"+sec_count+" .mobile_dp").addClass(color_classes[gen_random_value()]);
		            $("#mobile_num_"+sec_count+" .mobile_info .emailaddress_text").html(current_phone.display_number);
		            $("#mobile_num_"+sec_count+" .mobile_info .emailaddress_addredtime").addClass("red");
		            $("#mobile_num_"+sec_count+" #phonenumber_infohover").attr("id",'phonenumber_info'+sec_count);
	
		            $("#mobile_num_"+sec_count+" .action_icons_div_ph #icon-primary").remove();
		            $("#mobile_num_"+sec_count+" .action_icons_div_ph .icon-edit").remove();
		          
		            $("#mobile_num_"+sec_count+" .action_icons_div_ph .icon-delete").attr("id",'ph_icon_delete_'+sec_count);//No i18N
		            $("#ph_icon_delete_"+sec_count).attr("onclick",'deleteMobile(\''+current_phone.mobile+'\');');
		       
		            $("#mobile_num_"+sec_count+" .resend_options").attr("id",'resend_'+sec_count);
			        $("#mobile_num_"+sec_count+" #resend_"+sec_count+" .resend_mob_text").html(formatMessage(mob_resend_conf, current_phone.display_number));
			        $("#mobile_num_"+sec_count+" #resend_"+sec_count+" .resend_grn_btn").attr("onclick",'resendConfirmationCodeForMob(\''+current_phone.country_code+'\',\''+current_phone.mobile+'\',\''+sec_count+'\')');
			    	
		            tippy("#mob_icon_resend_"+sec_count, {		  //No I18N
		            	animation: 'scale',					//No I18N
		            	trigger: 'click mouseenter',				//No I18N
		            	appendTo:document.querySelector('#mob_icon_resend_'+sec_count).parentNode,//No I18N
		            	theme:'light',				//No I18N
		            	livePlacement: false,
		            	maxWidth: '300px',			//No I18N
		            	arrow: true,
		            	html: '#mobile_num_'+sec_count+' #resend_'+sec_count,		//No I18N
		            	hideOnClick: true,
		            	interactive: true
		            });
		      }
		  }
	      if(!primary_exist)
	      {
	    	  $(".phonenumber_prim").addClass("no_primaryexist");
	      }	 
	      else
	      {
	    	  $(".phonenumber_prim").removeClass("no_primaryexist");
	      }
	      

	      if(isMobile)
	      {
	        $(".phone_number_content .phnum_hover_show").addClass("hide");
	      }

	      $("#phnum_box .addnew").show();
	      $("#phone_add_view_more").show();
	      if((sec_count > 3 && !primary_exist)  ||  (primary_exist && sec_count > 3))
	      {
	    	  $("#addphoneonly").hide();
	    	  $("#addTFAphoneonly").hide();
	  
//	        if(jQuery.isEmptyObject(phoneDetail.tfa))
//	        { 
	        	$("#addTFAphone").hide();
//	        }
//	        else
//	        {
//	        	$("#addphone").hide();
//	        }
	      }

	      else
	      {
	    	  $("#phone_add_view_more").hide();
	    	if(jQuery.isEmptyObject(phoneDetail.recovery)		&&		jQuery.isEmptyObject(phoneDetail.unverfied))
	    	{
	    		$("#addTFAphoneonly").hide();$("#addphoneonly").hide();
	    	}
	    	else
	    	{
//		        if(jQuery.isEmptyObject(phoneDetail.tfa))
//		        { 
		        	$("#addTFAphoneonly").hide();
//		        }
//		        else
//		        {
//		        	$("#addphoneonly").hide();
//		        }
	    	}

	      }
	    }
    if(!isMobile){
		tooltipSet(".field_mobile .action_icon");//No I18N
    }
}


//delete Mobile Number


function deleteMobile(mobile) 
{
	var alertmsg = err_mobile_sure_delete1;
	
	show_confirm(formatMessage(alertmsg, mobile),
		    function() 
		    {
	    		new URI(Phone,"self","self",mobile).DELETE().then(function(resp)	//No I18N
						{
	    					delete_phonum_callback(resp,mobile);
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
	$("#confirm_popup button:first").focus();
}

function delete_phonum_callback(phObj,phnum)
{	

		SuccessMsg(getErrorMessage(phObj));
		if(profile_data.Phone.recovery[phnum])
		{
			delete profile_data.Phone.recovery[phnum];
		}
		else if(profile_data.Phone.unverfied[phnum])
		{
			delete profile_data.Phone.unverfied[phnum];
		}
		
		
		if(jQuery.isEmptyObject(profile_data.Phone.recovery))
		{
			delete profile_data.Phone.recovery;
		}
		else if(jQuery.isEmptyObject(profile_data.Phone.unverfied))
		{
			delete profile_data.Phone.unverfied;
		}
		
		if(profile_data.login_mobile!=undefined		&&	profile_data.login_mobile.split("-")[1]==phnum){
			delete profile_data.login_mobile;
			$("#em_icon_delete_0").hide();
			$("#em_icon_delete_0").attr("onclick","");
		}
		
		load_phonedetails(profile_data.Policies,profile_data.Phone);

		if($("#phonenumber_web_more").is(":visible")==true){
			var phone_num_length = profile_data.Phone.recovery != undefined ? Object.keys(profile_data.Phone.recovery).length : 0 ;
			var unverified_length = profile_data.Phone.unverfied != undefined ? Object.keys(profile_data.Phone.unverfied).length :0 ;
			var lenn=phone_num_length+unverified_length;
			if(lenn>1){
				tooltip_Des("#phonenumber_web_more .action_icon");//No I18N
				$("#view_all_phonenumber").html("");
				goback_mob();
				show_all_phonenumbers();
			}
			else{
				closeview_all_phonenumber_view();
			}
		}	
	
}



//make recovery as Primary Phone Number

function showmake_prim_mobilescreen(heading,description,button,number,action)
{
	set_popupinfo(heading,formatMessage(description, number));
	
	
	
	$('#popup_mobile_action span').html(button);
	$("#popuphead_icon").attr('class','')
	//$('#popuphead_icon').addClass("mobile_blue_icon");
	$("#phonenumber_popup_contents form").attr("name",action);
	
	//$("#phonenumber_popup_contents form").attr("action",contextpath+"/u/updateMobilePrimary");//No I18N
	$('#popup_mobile_action').attr("onclick","changePrimaryPhonenum_popup(document."+action+", '"+ number +"',changeprim_phonum_callback);");
//	$('#popup_mobile_action').attr("onclick","editLoginName(document."+action+","+id+");");
	

	$("#pop_action").css("margin-top", "0px");
	//$("#empty_phonenumber").show();
	$("#select_phonenumber").hide();
	
	$("#phonenumber_password").show();
	$("#select_existing_phone").hide();
	$("#otp_phonenumber").hide();
	
	$("#empty_phonenumber_input_code").attr("readonly","readonly");
	
	$("#pop_action").html($("#phonenumber_popup_contents").html()); //load into popuop
	$("#empty_phonenumber_input_code").val(number);
	$("#empty_phonenumber_input").val(number.split(')')[1]);

	
	$("#phonenumber_popup_contents form").attr("name","");
	//$("#phonenumber_popup_contents form").attr("action","");
	
	control_Enter("a"); //No I18N
	control_Enter(".blue"); //No I18N

	$("#popup_mobile_action").focus();

	closePopup(close_popupscreen,"common_popup");//No I18N
}

function editLoginName(f,callback)
{
	$('#'+f.id).find('input[name="phone_input_code"]').val(f.editscreenname.selectedOptions[0].text.trim());
	changePrimaryPhonenum(f,callback)
}

function changePrimaryPhonenum_popup(form, phnum,callback)
{
		phnum=phnum.split(") ")[1];
		phnum=phnum.trim();


		var payload = MakeLoginNumberPhone.create();
		payload.PUT("self","self",phnum).then(function(resp)	//No I18N
		{
			callback(resp,phnum);
			removeButtonDisable(form);
		},
		function(resp)
		{
			removeButtonDisable(form);
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
		
	return;
}


function changePrimaryPhonenum(form,callback)
{
	
	
	if(validateForm(form))
	{
		disabledButton(form);
		var phnum =$('#'+form.id).find('input[name="phone_input_code"]').val();
		phnum=phnum.split(") ")[1];	
		phnum=phnum.trim();


		var payload = MakeLoginNumberPhone.create();
		
		payload.PUT("self","self",phnum).then(function(resp)	//No I18N
		{
			callback(resp,phnum);
			removeButtonDisable(form);
		},
		function(resp)
		{
			removeButtonDisable(form);
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
	return;
}

function changeprim_phonum_callback(phObj,phnum)
{
	
		SuccessMsg(getErrorMessage(phObj));
		login_mobile=phnum;
		profile_data.login_mobile=profile_data.Phone.recovery[phnum].display_number.replace(/[^0-9 ]/g,"").replace(" ","-");
		load_phonedetails(profile_data.Policies,profile_data.Phone);
		load_emaildetails(profile_data.Policies,profile_data.Email);
		close_popupscreen();
		if($("#phonenumber_web_more").is(":visible")==true){
			tooltip_Des("#phonenumber_web_more .action_icon");//No I18N
			$("#view_all_phonenumber").html("");
			goback_mob();
			show_all_phonenumbers();
		}
}




//add Phone Number	

function show_add_mobilescreen(heading,description,button,action)
{
	/*close_popupscreen();
	close_converttfa_popup();*/
	if(profile_data.Phone!=undefined	&&	profile_data.Phone.tfa!=undefined)
	{
		$("#addToRecovery").hide();
		$("#addToRecovery").removeClass("pop_anim");		
	}
	else{
		$("#addToRecovery").slideUp(300,function(){
			$("#addToRecovery").removeClass("pop_anim");
		});
	}
	$('#empty_phonenumber_input').prop("readonly", false);
	$("#common_popup").addClass("default_popup");
	$('#common_popup .popuphead_text').html(heading);
	$('#common_popup .popuphead_define').html(description);
	$("#common_popup").show(0,function(){
		$("#common_popup").addClass("pop_anim");		
	});
	popup_blurHandler("6",".5");
	$('#popup_mobile_action span').html(button);;
	//$("#popuphead_icon").attr('class','')
	//$('#popuphead_icon').addClass("mobile_blue_icon");
	$("#phonenumber_popup_contents form").attr("name",action);
//	$('#popup_mobile_action').attr("onclick","addNewPhoneNumber(document."+action+",false);");
	$('#popup_mobile_action').attr("onclick","NewPhoneNO(document.addphonenum,Otp_verify_show);");
	//$("#phonenumber_popup_contents form").attr("action",contextpath+"/u/updateMobileAdd");//No I18N

	
	$("#empty_phonenumber").hide();
	$("#phonenumber_password").hide();
	$("#select_existing_phone").hide();
	$("#otp_phonenumber").hide();
	$("#select_phonenumber").show();

	$("#pop_action").html($("#phonenumber_popup_contents").html()); //load into popuop
	
	$(".pp_popup").addClass("addMob_popup");
	
	
	$("#phonenumber_popup_contents form").attr("name","");
	$("#phonenumber_popup_contents form").attr("action","");

	if(!isMobile)
	{

		$(document.addphonenum.countrycode).select2({ 
			width: '67px',//No I18N
			templateResult: phoneSelectformat,
			templateSelection: function (option) {
				selectFlag($(option.element));
				codelengthChecking(option.element,"select_phonenumber_input");//No i18N
				return $(option.element).attr("data-num");
			},
		    escapeMarkup: function (m) {
		    	return m;
			}}).on("select2:open", function() {
		       $(".select2-search__field").attr("placeholder", iam_search_text);//No I18N
		  });
		$("#select_phonenumber .select2-selection").append("<span id='selectFlag' class='selectFlag'></span>");
		selectFlag($(document.addphonenum.countrycode).find("option:selected"));
		$(".select2-selection__rendered").attr("title", "");
	    $(document.addphonenum.countrycode).on("select2:close", function (e) { 
			$(e.target).siblings("input").focus();
		});
	}
	else{
		phonecodeChangeForMobile(document.addphonenum.countrycode);
	}
	closePopup(close_popupscreen,"common_popup");//No I18N
	
	$("#select_phonenumber_input").focus();
}

function NewPhoneNO(form,callback)
{
	if(validateForm(form))
	{
		disabledButton(form);
		var NewPhone = $('#'+form.id).find('input[name="mobile_no"]').val().replace(/[+ \[\]\(\)\-\.\,]/g,'');
		var parms=
		{
			"mobile_no":NewPhone,//No I18N
			"countrycode":$('#'+form.id).find('select[name="countrycode"]').val()//No I18N
		};


		var payload = Phone.create(parms);
		
		payload.POST("self","self").then(function(resp)	//No I18N
		{
			callback(resp);
			removeButtonDisable(form);
		},
		function(resp)
		{
			removeButtonDisable(form);
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
	return;
}



//enter OTP to get verify the mobile number
function Otp_verify_show(phObj)
{
		SuccessMsg(getErrorMessage(phObj));		

		$("#empty_phonenumber").hide();
		$("#phonenumber_password").hide();
		$("#select_existing_phone").hide();
		$("#otp_phonenumber").show();
		$("#select_phonenumber").hide();
		
		$('#popup_mobile_action').html(iam_verify_phone_number);
		$("#common_popup .popuphead_define").html(formatMessage(otp_description,$('#select_phonenumber').find('input[name="mobile_no"]').val()));
		$('#popup_mobile_action').attr("onclick","verifyOTP(document.addphonenum,new_phonum_callback);");
		
		resend_countdown("#phoneNumberform #emailOTP_resend");//No I18N 
		
		control_Enter("a"); //No I18N
		$('#otp_phonenumber_input').val('');
		$('#otp_phonenumber_input').focus();
		closePopup(close_popupscreen,"common_popup",true);//No I18N
	
}


function PhoneOTP_resendcode()
{
	if(!$("#phoneNumberform #emailOTP_resend a").hasClass("resend_otp_blocked"))//countdown is over
	{
		var PHid=	$('#select_phonenumber').find('input[name="mobile_no"]').val();	
		if(PHid!="")
		{	
			var parms=
			{
				"mobile_no":PHid,//No I18N
				"countrycode":$('#select_phonenumber').find('select[name="countrycode"]').val()	//No I18N
			};
	
	
			var payload = Phone.create(parms);
			payload.POST("self","self").then(function(resp)	//No I18N
			{
				SuccessMsg(getErrorMessage(resp));
				resend_countdown("#phoneNumberform #emailOTP_resend");//No I18N 
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
	}
}
function resendverifyOTP()
{
	if(!$("#phoneNumberform #emailOTP_resend a").hasClass("resend_otp_blocked"))
	{	
		var phun=$('#select_phonenumber').find('input[name="mobile_no"]').val();	
		
		var parms=
		{
			"countrycode":$('#select_phonenumber').find('select[name="countrycode"]').val()	//No I18N
		};

		var payload = Phone.create(parms);
		payload.PUT("self","self",phun).then(function(resp)	//No I18N
		{
			SuccessMsg(getErrorMessage(resp));
			resend_countdown("#phoneNumberform #emailOTP_resend");//No I18N 
		},
		function(resp)
		{
			removeButtonDisable(form);
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
	return;
}

function verifyOTP(form,callback)
{
	if(validateForm(form))
	{	
		disabledButton(form);
		var phun=$('#'+form.id).find('input[name="mobile_no"]').val().replace(/[+ \[\]\(\)\-\.\,]/g,'');
		var oldnum =$('#'+form.id).find('input[name="old_phone"]').val();
		
		var parms=
		{
			"otp_code":$('#'+form.id).find('input[name="otp_code"]').val()//No I18N
		};


		var payload = Phone.create(parms);
		payload.PUT("self","self",phun).then(function(resp)	//No I18N
		{
			callback(resp,phun,oldnum);
			removeButtonDisable(form);
		},
		function(resp)
		{
			removeButtonDisable(form);
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
	return;
}



function new_phonum_callback(phdet,newPH,old_num)
{
	SuccessMsg(getErrorMessage(phdet));
	

	close_popupscreen();
	
	if(!jQuery.isEmptyObject(profile_data.Phone)	&&	!jQuery.isEmptyObject(profile_data.Phone.recovery)	&&	profile_data.Phone.recovery[newPH])
	{
		delete profile_data.Phone.recovery[newPH];
	}
	
	if(profile_data.Phone==undefined)
	{
		profile_data.Phone=[];
	}
	if(profile_data.Phone.recovery==undefined)
	{
		profile_data.Phone.recovery=[];
	}
	
	profile_data.Phone.recovery[newPH]=phdet.phone.mobile_num;
	
	if(old_num)
	{
		$("#old_mob").val("");
		delete profile_data.Phone.recovery[old_num];
	}
	if(profile_data.Phone.unverfied!=undefined&&profile_data.Phone.unverfied[newPH] != undefined){
		profile_data.Phone.recovery[newPH] = profile_data.Phone.unverfied[newPH];
		delete profile_data.Phone.unverfied[newPH];
	}	
	load_phonedetails(profile_data.Policies,profile_data.Phone);

	if($("#phonenumber_web_more").is(":visible")==true)
	{
		//closeview_all_phonenumber_view();
		tooltip_Des("#phonenumber_web_more .action_icon");//No I18N
		$("#view_all_phonenumber").html("");
		goback_mob();
		show_all_phonenumbers();
	}
	else
	{
		closeview_all_phonenumber_view();
	}
}



//change tfa backup to recovery

function show_tfa_switch_mobilescreen()
{
	//set_popupinfo(heading,description);
	//$("#popuphead_icon").attr('class','')
	//$('#popuphead_icon').addClass("mobile_blue_icon");
	//$("#pop_action").html($("#addToRecovery").html()); //load into popuop
	
	remove_error();
	popup_blurHandler('6','.5');
	$("#addToRecovery").show(0,function(){
		$("#addToRecovery").addClass("pop_anim");
	});
	$('#backup_to_recovery')[0].reset();
	
	if(!isMobile)
	{
		$("#backupnumber").select2();
	}
	$("#addToRecovery .select2-selection").focus();
	closePopup(close_converttfa_popup,"addToRecovery");		//No I18N
}



function close_converttfa_popup()
{
	popupBlurHide("#addToRecovery"); //No I18N
}



function switchBackupNoForRecovery(f,callback)
{
	if(validateForm(f))
	{	
		var phnum=$("#backupnumber").val();


		var payload = MakeRecoveryPhone.create();
		payload.PUT("self","self",phnum).then(function(resp)	//No I18N
		{
			callback(resp,phnum);
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
	return;
}

function newRecovery(phdet,phnum)
{
	SuccessMsg(getErrorMessage(phdet));
	
	profile_data.Phone.recovery[phnum]=phdet.makerecovery;
	delete profile_data.Phone.tfa[phnum];
	close_converttfa_popup();
	
	load_phonedetails(profile_data.Policies,profile_data.Phone);
	if($("#view_all_phonenumber").is(":visible")){
		closeview_all_phonenumber_view();
	}
}




//for viewmorw phonenumbers.jsp
function resendEmailConfirmLink_mobile(emailid){
	var parms=
	{
		"email_id":emailid//No I18N
	};
	var payload = Email.create(parms);
	payload.POST("self","self").then(function(resp)	//No I18N
	{	
		SuccessMsg(getErrorMessage(resp));
		var str = $("#email_otp_text").html();
		if(!$("#emails_web_more").is(":visible")){	
			$("#Email_popup_for_mobile .option_container").slideUp(300,function(){
				$("#Email_popup_for_mobile .option_button").hide();
				$("#Email_popup_for_mobile .mob_popuphead_define").html(formatMessage(str,emailid));
				$("#Email_popup_for_mobile .otp_mobile_form").show();	
				$("#Email_popup_for_mobile #otp_email_input").val("");
				$("#Email_popup_for_mobile .otp_mobile_form form").attr('name','resend_otp_ver_form');
				$("#Email_popup_for_mobile  #email_conf_input").val(emailid);
				$("#Email_popup_for_mobile .option_container").slideDown(300);
				$("#Email_popup_for_mobile #action_otp_conform").attr('onclick','return confirm_add_email(document.resend_otp_ver_form,resendEmailConfirmLink_mobile_callback)');
			})
		}
		else{
			$(".field_email .option_container").slideUp(300,function(){
				$(".field_email .option_button").hide();	
				$(".field_email .mob_popuphead_define").html(formatMessage(str,emailid));
				$(".field_email .otp_mobile_form").show();
				$(".field_email #otp_email_input").val("");	
				$(".inline_action .otp_mobile_form form").attr('name','otp_form_in_viewall');
				$(".inline_action #action_otp_conform").attr('onclick','return confirm_add_email(document.otp_form_in_viewall,resendEmailConfirmLink_mobile_callback)');
				$(".inline_action #email_conf_input").val(emailid);
				$(".field_email .option_container").slideDown(300);
			});
			
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

function resendEmailConfirmLink_mobile_callback(emailObj){
	SuccessMsg(getErrorMessage(emailObj));
	close_for_mobile_specific(function(){
		profile_data.Email[emailObj.verifyotp.email_id]=emailObj.verifyotp;
		load_emaildetails(profile_data.Policies,profile_data.Email);		
		if($("#emails_web_more").is(":visible")){
			show_all_emails();
		}
		else{
			close_for_mobile_specific();
		}
	});
}

function removeEmailForMobile(emailid){
	
	new URI(Email,"self","self",emailid).DELETE().then(function(resp)	//No I18N
			{
	    		profile_data.primary_email=profile_data.login_mobile;//no primary email as of now so we will use primary mobile
				close_for_mobile_specific(function(){
					$("#profile_email").html(profile_data.login_mobile);
					delete_email_callback(resp,emailid);
				});
				return false;
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
				return false;
			});
}
function emailMakePrimaryForMobile(emailid){
	var payload = makePrimary.create();
	payload.PUT("self","self",emailid).then(function(resp)	//No I18N
			{
				close_for_mobile_specific(function(){
					changed_primaryemail(resp,emailid);					
				});
				return false;
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
				return false;
			});
}
function makePrimaryMobileForMobile(phnum){
	var payload = MakeLoginNumberPhone.create();
	
	payload.PUT("self","self",phnum).then(function(resp)	//No I18N
	{
		close_for_mobile_specific(function(){
			changeprim_phonum_callback(resp,phnum);
		});
		return false;
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
		return false;
	});
}

function deleteMobileNumber_MobileUi(phnum){
	new URI(Phone,"self","self",phnum).DELETE().then(function(resp)	//No I18N
			{
				close_for_mobile_specific(function(){
					delete_phonum_callback(resp,phnum);					
				});
				return false;
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
				return false;
			});
}
function close_for_mobile_specific(callback){
	if($("#phonenumber_web_more").is(":visible")||$("#emails_web_more").is(":visible")){
		$(".viewall_popup_content .inline_action").slideUp(300,function(){
			$(".otp_mobile_form").hide();
			$(".viewall_popup_content .inline_action").remove();
			if(callback){
				callback();
			}
		});
	}
	else{
		popupBlurHide("#Email_popup_for_mobile",function(){//No I18N
			$(".mob_popu_btn_container").show();
			$(".mob_popu_btn_container button").hide();
			$(".option_container").hide();
			$(".option_button").show();
			$(".otp_mobile_form").hide();
			if(callback){
				callback();
			}
		}); 
	}
	$(".option_button #action_granted").unbind();
}

function show_mob_conform(action_type,def){
	$(".mob_popu_btn_container").slideUp(300,function(){
		$(".option_container").slideDown(300);
	});
	$(".option_container .mob_popuphead_define").html(def);
	
	
	$("#Email_popup_for_mobile .option_button #action_granted").click(function(){	
		if(action_type == "email_primary" ){
			var emailid =$('#Email_popup_for_mobile').find('.emailaddress_text').html();
			emailMakePrimaryForMobile(emailid);
			return false;
		}
		if(action_type == "email_delete" ){
			var emailid =$('#Email_popup_for_mobile').find('.emailaddress_text').html();
			removeEmailForMobile(emailid);
			return false;
		}
		if(action_type == "email_resend" ){
			var emailid =$('#Email_popup_for_mobile').find('.emailaddress_text').html();
			resendEmailConfirmLink_mobile(emailid);
			return false;
		}
		if(action_type == "pho_primary" ){
			var phnum =$('#Email_popup_for_mobile').find('.emailaddress_text').html();
			phnum=phnum.split(") ")[1];	
			phnum=phnum.trim();
			makePrimaryMobileForMobile(phnum);
			return false;
		}
		if(action_type == "pho_delete" ){
			var phnum =$('#Email_popup_for_mobile').find('.emailaddress_text').html();
			phnum=phnum.split(") ")[1];	
			phnum=phnum.trim();
			deleteMobileNumber_MobileUi(phnum);
			return false;
		}
	});
}

function show_mob_conform_viewall(action_type,id,def){
	
	$(".inline_action").slideUp(300,function(){
		$(".inline_action .mob_popu_btn_container").hide();
		$(".inline_action .option_container").show();
		$(".inline_action").slideDown(300);		
	});
	$(".inline_action .option_container .mob_popuphead_define").html(def);
	$(".option_button #action_granted").click(function(){	
		if(action_type=="pho_primary"){
			var phnum =$('#mobile_num_'+id).find('.emailaddress_text').html();
			phnum=phnum.split(") ")[1];	
			phnum=phnum.trim();
			makePrimaryMobileForMobile(phnum);
			return false;
		}
		if(action_type=="pho_delete"){
			var phnum =$('#mobile_num_'+id).find('.emailaddress_text').html();
			phnum=phnum.split(") ")[1];	
			phnum=phnum.trim();
			deleteMobileNumber_MobileUi(phnum);	
			return false;
		}
		if(action_type == "email_resend" ){
			var emailid =$('#emailID_num_'+id).find('.emailaddress_text').html();
			resendEmailConfirmLink_mobile(emailid);
			return false;
		}
		if(action_type == "email_primary" ){
			var emailid =$('#emailID_num_'+id).find('.emailaddress_text').html();
			emailMakePrimaryForMobile(emailid);
			return false;
		}
		if(action_type == "email_delete" ){
			
			var emailid =$('#emailID_num_'+id).find('.emailaddress_text').html();
			removeEmailForMobile(emailid);
			return false;
		}
	});
	
}
function for_mobile_specific(id)
{
	if(isMobile)
	{
		if(!$("#phonenumber_web_more").is(":visible")){
			remove_error();	
			popup_blurHandler("6",'.5');
			$("#Email_popup_for_mobile").show(0,function(){
				$("#Email_popup_for_mobile").addClass("pop_anim");
			});

			if($("#"+id+" .action_icons_div_ph").children().hasClass("icon-makeprimary")){
				$("#btn_to_chng_primary").show();
				$("#btn_to_chng_primary").attr("onclick","show_mob_conform('pho_primary','"+primay_mobile_definition+"')");//No I18N
			}
			if($("#"+id+" .action_icons_div_ph").children().hasClass("icon-delete")){
				$("#btn_to_delete").show();
				var mob_number = $("#"+id+" .action_icons_div_ph").children(".icon-delete").attr("onclick");
				mob_number = mob_number.slice(mob_number.indexOf("(")+2,mob_number.indexOf(")")-1);
				$("#btn_to_delete").attr("onclick","show_mob_conform('pho_delete','"+formatMessage(err_mobile_sure_delete1,mob_number)+"')");
			}
			$("#Email_popup_for_mobile .popuphead_details").html($("#"+id).html());
			$("#Email_popup_for_mobile").focus();
			closePopup(close_for_mobile_specific,"Email_popup_for_mobile");//No I18N
		}
		else{
			if(!$(event.target).parents().hasClass("inline_action")){
				var id_num=parseInt(id.match(/\d+$/)[0], 10);
				var prev_num;
				if($("#view_all_phonenumber .inline_action").length)
				{
					prev_num = $("#view_all_phonenumber .inline_action").parents(".field_mobile").attr("id");
					prev_num = parseInt(prev_num.match(/\d+$/)[0], 10);

					if(prev_num == id_num)
					{
						$("#mobile_num_"+id_num+" .inline_action").slideUp(300,function(){
							$("#mobile_num_"+id_num+" .inline_action").remove();
						});
						return false;
					}

				}
				$("#view_all_phonenumber #mobile_num_"+id_num).append('<div class="inline_action"></div>');
				$("#view_all_phonenumber #mobile_num_"+id_num+" .inline_action").html($("#Email_popup_for_mobile").html());
	
				if($("#"+id+" .action_icons_div_ph").children().hasClass("icon-makeprimary")){
					$("#view_all_phonenumber #"+id+" #btn_to_chng_primary").show();
					$("#view_all_phonenumber #"+id+" #btn_to_chng_primary").attr("onclick","show_mob_conform_viewall('pho_primary',"+id_num+",'"+primay_mobile_definition+"')");//No I18N
				}
				if($("#"+id+" .action_icons_div_ph").children().hasClass("icon-delete")){
					$("#view_all_phonenumber #"+id+" #btn_to_delete").show();
					var mob_number = $("#"+id+" .action_icons_div_ph").children(".icon-delete").attr("onclick");
					mob_number = mob_number.slice(mob_number.indexOf("(")+2,mob_number.indexOf(")")-1);
					$("#view_all_phonenumber #"+id+" #btn_to_delete").attr("onclick","show_mob_conform_viewall('pho_delete',"+id_num+",'"+formatMessage(err_mobile_sure_delete1,mob_number)+"')");
				}
				if(prev_num!=undefined)
				{
					if(prev_num != id_num)
					{
						$("#view_all_phonenumber #mobile_num_"+prev_num+" .inline_action").slideUp(300,function(){
							$("#view_all_phonenumber #mobile_num_"+prev_num+" .inline_action").remove();
						});
						$("#view_all_phonenumber #mobile_num_"+id_num+" .inline_action" ).slideDown(300,function(){

						});
					}
					else
					{
						var previous=$("#view_all_phonenumber #mobile_num_"+prev_num+" .inline_action")[0];
						var newele=$("#view_all_phonenumber #mobile_num_"+prev_num+" .inline_action")[1];
						$(previous).slideUp(300,function(){
							$(newele).slideDown(300,function(){
								$(previous).remove();
							});
						});
					}
				}
				else
				{
						$("#view_all_phonenumber #mobile_num_"+id_num+" .inline_action" ).slideDown(300);
				}
			}
		}

	}
}


function closeview_all_phonenumber_view()
{
	tooltip_Des("#phonenumber_web_more .action_icon");//No I18N
	$("#view_all_phonenumber").html("");
	popupBlurHide('#phonenumber_web_more');//No I18N
	goback_mob();
	$(".blue").unbind();
	$("a").unbind();
}

function show_all_phonenumbers()
{

	
		goback_mob();
		tooltip_Des(".field_mobile .action_icon");//No I18N
		$("#view_all_phonenumber").html("");
		if( $( ".phonenumber_prim" ).is(":visible") ) 
		{
			$("#view_all_phonenumber").append($(".phonenumber_prim").html());
		}
		if( $( ".phonenumber_sec" ).length ) 
		{
			$("#view_all_phonenumber").append($(".phonenumber_sec").html());
		}
		if( $( ".phonenumber_unverfied" ).length ) 
		{
			$("#view_all_phonenumber").append($(".phonenumber_unverfied").html());
		}
		popup_blurHandler('6','.5');
		
	
		$("#phonenumber_web_more").show(0,function(){
			$("#phonenumber_web_more").addClass("pop_anim");
		});
		
		$("#view_all_phonenumber .extra_phonenumbers").show();
//		$("#view_all_phonenumber .viewmore").hide();
		$("#view_all_phonenumber").show();
		$("#specific_phoneNUM").hide();
		

	
		if(isMobile)
		{
			$("#view_all_phonenumber .phnum_hover_show").remove();
		}
		else
		{
			$("#view_all_phonenumber .primary").removeAttr("onclick");
			$("#view_all_phonenumber .secondary").removeAttr("onclick");
			$("#view_all_phonenumber .field_mobile .action_icons_div_ph span").removeAttr("onclick");
			tooltip_Des("#view_all_phonenumber .verify_icon");//No I18N
			$("#view_all_phonenumber .verify_icon").attr("title",resend_otp_title);
			
			$("#view_all_phonenumber .field_mobile .action_icons_div_ph span").click(function(){
				
				
				var id=$(this).attr('id');
				var id_num=parseInt(id.match(/\d+$/)[0], 10);
				
				if($("#view_all_phonenumber #"+id).hasClass("selected_icons"))
				{
					return;
				}
				if(id!="mob_icon_resend_"+id_num){
					if($("#"+id).attr("onclick"))
					{
						var args=$("#"+id).attr("onclick").split(",");
					}
					else
					{
						var args=$("#"+id).attr("onmouseover").split(",");
					}
				}
				else{
					if($("#"+id).find(".resend_grn_btn").attr("onclick"))
					{
						var args=$("#"+id).find(".resend_grn_btn").attr("onclick").split(",");
					}
					else
					{
						var args=$("#"+id).find(".resend_grn_btn").attr("onmouseover").split(",");
					}
				}
				var len=args.length;
				var prev_num;
				if($("#view_all_phonenumber .inline_action").length)
				{
					prev_num = $("#view_all_phonenumber .inline_action").parents(".field_mobile").attr("id");
					prev_num = parseInt(prev_num.match(/\d+$/)[0], 10);

					if(prev_num == id_num)
					{
						$("#mobile_num_"+id_num+" .inline_action").slideUp(300);
					}

				}
				
				
//				if($("#view_all_phonenumber .inline_action").length)
//				{
//						$("#view_all_phonenumber .inline_action").remove();
//				}
				$("#view_all_phonenumber .field_mobile").removeClass("web_email_specific_popup");//No I18N
				
				$("#view_all_phonenumber .action_icons_div_ph").removeClass("show_icons");
				$("#view_all_phonenumber .field_mobile .action_icons_div_ph span").removeClass("selected_icons");
				
//				if(id=="ph_icon_edit_0")//for primary edit 0is always primary or screenname
//				{
//					var heading=args[0].split("(")[1].replace(/'/g,'');
//					var description=args[1].replace(/'/g,'');
//					var button=args[2].replace(/'/g,'');
//					var action=args[3].split(")")[0].replace(/'/g,'');
//					
//					
//					$("#view_all_phonenumber #mobile_num_"+id_num+" .action_icons_div_ph").addClass("show_icons");
//					$("#view_all_phonenumber #"+id).addClass("selected_icons");
//					
////					$("#view_all_phonenumber #mobile_num_"+id_num).addClass("web_email_specific_popup");
//					
//					
//					
////					$("#view_all_phonenumber #mobile_num_"+id_num).append('<div id="web_specific_popup_ph"></div>')
////					$("#view_all_phonenumber #mobile_num_"+id_num+" #web_specific_popup_ph" ).html('<br /><div class="popup_header "><div class="popuphead_details"><span class="popuphead_text">'+heading+'</span><span class="popuphead_define">'+description+'</span></div></div>');
//					
////					$('#popup_mobile_action span').html(button);;
//					$("#phonenumber_popup_contents form").attr("name","Viewmore"+action); 
//					//$("#phonenumber_popup_contents form").attr("action",contextpath+"/u/updateMobilePrimary");//No I18N
//					
////					$('#popup_mobile_action').attr("onclick","editLoginName(document."+action+",changeprim_phonum_callback);");
//					
//					$("#empty_phonenumber").hide();
//					$("#phonenumber_password").show();
//					$("#select_existing_phone").show();
//					$("#otp_phonenumber").hide();
//					$("#select_phonenumber").hide();
//					
//					
//					$("#view_all_phonenumber #mobile_num_"+id_num).append('<div class="inline_action"></div>');
//				
//					if($("#view_all_phonenumber #mobile_num_"+id_num+" .inline_action").length==2)
//					{
//						var edit_0th=$("#view_all_phonenumber #mobile_num_"+id_num+" .inline_action" )[1];
//					}
//					else
//					{
//						var edit_0th=$("#view_all_phonenumber #mobile_num_"+id_num+" .inline_action" );
//					}
//					$(edit_0th).html('<div class="inline_action_discription">'+description+'</div>');
//					
//					$(edit_0th).append($("#phonenumber_popup_contents").html()); //load into popuop
//					
//					$("#view_all_phonenumber #mobile_num_"+id_num+" .inline_action .popup_header" ).remove();
//					$("#view_all_phonenumber #mobile_num_"+id_num+" .inline_action #popup_mobile_action" ).remove();
//					
//					if($("#phoneNumberform_specific").length){
//						$("#phoneNumberform_specific").removeAttr("name");
//					}
//					
//					$("#view_all_phonenumber #mobile_num_"+id_num+" .inline_action form").attr("id","phoneNumberform_specific");
//
//					$(edit_0th).children("form").append('<button class="primary_btn_check inline_btn nobottom_margin_btn delete_btn" onclick="editLoginName(document.Viewmore'+action+',changeprim_phonum_callback);">'+button+'</button>');
//					
////					$("#view_all_phonenumber #web_specific_popup_ph").addClass("MKprim_0_top");
//					
//					$("#phonenumber_popup_contents form").attr("name","");
//					//$("#phonenumber_popup_contents form").attr("action","");
//					if(!isMobile)
//					{
//						$(document.ViewmoreeditPrimary.editscreenname).select2({
//							minimumResultsForSearch: Infinity
//						});
//						$("#view_all_phonenumber #mobile_num_"+id_num+".select2-selection__rendered").attr("title", "");
//					}
//					control_Enter(".blue"); //No I18N
//				}
//				else 
				if(id=="mob_icon_resend_"+id_num)
				{
					
					var Ccode=args[0].split("(")[1].replace(/'/g,'');
					var phoneNumber=args[1].split(")")[0].replace(/'/g,'');
					
					$("#view_all_phonenumber #mobile_num_"+id_num+" .action_icons_div_ph").addClass("show_icons");
					
					$("#view_all_phonenumber #"+id).addClass("selected_icons");
					
					$("#view_all_phonenumber #mobile_num_"+id_num).append('<div class="inline_action"></div>');
					if($("#view_all_phonenumber #mobile_num_"+id_num+" .inline_action").length==2)
					{
						var conf_ele = $("#view_all_phonenumber #mobile_num_"+id_num+" .inline_action" )[1];
					}
					else
					{
						var conf_ele=$("#view_all_phonenumber #mobile_num_"+id_num+" .inline_action" );
					}
					
					
					$(conf_ele).html('<div class="inline_action_discription">'+formatMessage(em_resend_conf, phoneNumber)+'</div>');
					
					
					$(conf_ele).append('<button id="delete_specific_email" class="primary_btn_check inline_btn nobottom_margin_btn delete_btn" onclick="resendConfirmationCodeForMob(\''+Ccode+'\',\''+phoneNumber+'\',\''+id_num+'\');">'+$("#view_all_phonenumber #resend_"+id_num+" .resend_grn_btn").html()+'</button>');
					
					
				}
				else if(id=="ph_icon_delete_"+id_num)
				{
					mobile=args[0].split("(")[1].split(")")[0].replace(/'/g,'');
					
					$("#view_all_phonenumber #mobile_num_"+id_num+" .action_icons_div_ph").addClass("show_icons");
					
					$("#view_all_phonenumber #"+id).addClass("selected_icons");
					
//					$("#view_all_phonenumber #mobile_num_"+id_num).addClass("web_email_specific_popup");
					
//					$("#view_all_phonenumber #mobile_num_"+id_num).append('<div id="web_specific_popup_ph"></div>')
//					$("#view_all_phonenumber #mobile_num_"+id_num+" #web_specific_popup_ph" ).html('<br /><div class="popup_header "><div class="popuphead_details"><span class="popuphead_text">'+delete_Mobile+'</span><span class="popuphead_define">'+formatMessage(err_mobile_sure_delete1, mobile)+'</span></div></div><input class="primary_btn_check  " id="delete_specific_mob" type="button" value="'+iam_continue+'">');
					
					$("#view_all_phonenumber #mobile_num_"+id_num).append('<div class="inline_action"></div>');
					
					if($("#view_all_phonenumber #mobile_num_"+id_num+" .inline_action").length==2)
					{
						var deleteele=$("#view_all_phonenumber #mobile_num_"+id_num+" .inline_action" )[1];
					}
					else
					{
						var deleteele=$("#view_all_phonenumber #mobile_num_"+id_num+" .inline_action" );
					}
					$(deleteele).html('<div class="inline_action_discription">'+formatMessage(err_mobile_sure_delete1, mobile)+'</div>');
					$(deleteele).append('<button id="delete_specific_mob" class="primary_btn_check inline_btn nobottom_margin_btn delete_btn">'+iam_continue+'</button>');
					
					
					$("#delete_specific_mob").click(function()
					{
						new URI(Phone,"self","self",mobile).DELETE().then(function(resp)	//No I18N
								{
			    					delete_phonum_callback(resp,mobile);
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
					});
				}
				else if(id=="ph_icon_MKprim_"+id_num)
				{
					var heading=args[0].split("(")[1].replace(/'/g,'');
					var description=args[1].replace(/'/g,'');
					var button=args[2].replace(/'/g,'');
					var number=args[3].replace(/'/g,'');
					var action=args[4].split(")")[0].replace(/'/g,'');
					
					$("#view_all_phonenumber #mobile_num_"+id_num+" .action_icons_div_ph").addClass("show_icons");
					
					$("#view_all_phonenumber #"+id).addClass("selected_icons");
					
//					$("#view_all_phonenumber #mobile_num_"+id_num).addClass("web_email_specific_popup");
					
//					$("#view_all_phonenumber #mobile_num_"+id_num).append('<div id="web_specific_popup_ph"></div>')
//					$("#view_all_phonenumber #mobile_num_"+id_num+" #web_specific_popup_ph" ).html('<br /><div class="popup_header "><div class="popuphead_details"><span class="popuphead_text">'+heading+'</span><span class="popuphead_define">'+description+'</span></div></div>');
					
//					$('#popup_mobile_action span').html(button);;
					//$("#phonenumber_popup_contents form").attr("action",contextpath+"/u/updateMobilePrimary");//No I18N
					$("#phonenumber_popup_contents form").attr("name","Viewmore"+action); 
//					$('#popup_mobile_action').attr("onclick","editLoginName(document."+action+",changeprim_phonum_callback);");
					
					$("#empty_phonenumber").show();
					$("#select_phonenumber").hide();
					
					$("#phonenumber_password").show();
					$("#select_existing_phone").hide();
					$("#otp_phonenumber").hide();
					
					$("#empty_phonenumber_input_code").attr("readonly","readonly");
					
					$("#view_all_phonenumber #mobile_num_"+id_num).append('<div class="inline_action"></div>');
					
					if($("#view_all_phonenumber #mobile_num_"+id_num+" .inline_action").length==2)
					{
						var prim_ele=$("#view_all_phonenumber #mobile_num_"+id_num+" .inline_action" )[1];
					}
					else
					{
						var prim_ele=$("#view_all_phonenumber #mobile_num_"+id_num+" .inline_action" );
					}
					
					$(prim_ele).html('<div class="inline_action_discription">'+description+'</div>');
					
					$(prim_ele).append($("#phonenumber_popup_contents").html()); //load into popuop
					
					$("#view_all_phonenumber #mobile_num_"+id_num+" .inline_action .popup_header" ).remove();
					$("#view_all_phonenumber #mobile_num_"+id_num+" .inline_action #popup_mobile_action" ).remove();
					
					$(prim_ele).children("form").append('<button class="primary_btn_check inline_btn nobottom_margin_btn delete_btn" onclick="changePrimaryPhonenum(document.Viewmore'+action+',changeprim_phonum_callback);">'+button+'</button>');

					$("#view_all_phonenumber #empty_phonenumber_input_code").val(number);
					$("#view_all_phonenumber #mobile_num_"+id_num+" .inline_action form").attr("id","phoneNumberform_specific");
					$("#phonenumber_popup_contents form").attr("name","");
					//$("#phonenumber_popup_contents form").attr("action","");
					control_Enter(".blue"); //No I18N
					
				}
//				else if(id=="ph_icon_edit_"+id_num)
//				{
//					var heading=args[0].split("(")[1].replace(/'/g,'');
//					var description=args[1].replace(/'/g,'');
//					var button=args[2].replace(/'/g,'');
//					var number=args[3].replace(/'/g,'');
//					var action=args[4].split(")")[0].replace(/'/g,'');
//					
//					$("#view_all_phonenumber #mobile_num_"+id_num+" .action_icons_div_ph").addClass("show_icons");
//					
//					$("#view_all_phonenumber #"+id).addClass("selected_icons");
//					
//					$("#phonenumber_popup_contents form").attr("name","Viewmore"+action);
//
//					$("#empty_phonenumber").hide();
//					$("#select_phonenumber").show();
//					
//					$("#phonenumber_password").hide();
//					$("#select_existing_phone").hide();
//					$("#otp_phonenumber").hide();
//					
//					
//					$("#view_all_phonenumber #mobile_num_"+id_num).append('<div class="inline_action"></div>');
//					
//					//$("#mobile_num_"+prev_num+" .inline_action form").removeAttr("name");
//				//	$("#mobile_num_"+prev_num+" .inline_action form select").select2('remove'); 
//					
//					if($("#view_all_phonenumber #mobile_num_"+id_num+" .inline_action").length==2)
//					{						
//						var edit_ele=$("#view_all_phonenumber #mobile_num_"+id_num+" .inline_action" )[1];
//					}	
//					else
//					{
//						var edit_ele=$("#view_all_phonenumber #mobile_num_"+id_num+" .inline_action" );
//					}
//					
//					//$("#mobile_num_"+prev_num+" .inline_action form #countNameAddDiv").select2("destroy");
//					$("#mobile_num_"+prev_num+" .inline_action form").removeAttr("name");
//				
//					$(edit_ele).html('<div class="inline_action_discription">'+description+'</div>');
//					
//					$(edit_ele).append($("#phonenumber_popup_contents").html()); //load into popuop
//					
//					$("#view_all_phonenumber #mobile_num_"+id_num+" .inline_action .popup_header" ).remove();
//					$("#view_all_phonenumber #mobile_num_"+id_num+" .inline_action #popup_mobile_action" ).remove();
//					
//					$(edit_ele).children("form").append('<button class="primary_btn_check inline_btn nobottom_margin_btn delete_btn" onclick="EditPhoneNO(document.Viewmore'+action+',Otp_verify_show_specific);">'+button+'</button>');
//
//					$(edit_ele).find("#empty_phonenumber_input").val(number);
//					//$("#view_all_phonenumber #empty_phonenumber_input").val(number);
//					$(edit_ele).children("form").attr("id","phoneNumberform_specific");
//
//					$(edit_ele).find("#select_phonenumber_input").val(number.split(') ')[1]);
//					$("#view_all_phonenumber #old_mob").val(number.split(') ')[1]);
//					
//					$("#phonenumber_popup_contents form").attr("name","");
//					//$("#phonenumber_popup_contents form").attr("action","");
//					
//					control_Enter(".blue"); //No I18N
//					
//					if(!isMobile)
//					{
//						$(document.Viewmoreaddphonenum.countrycode).select2({ 
//							width: '67px',//No I18N
//							templateResult: phoneSelectformat,//use to change select2 option html structure
//							templateSelection: function (option) {  //selecting time function
//								selectFlag($(option.element));
//								codelengthChecking(option.element,"select_phonenumber_input");//No i18N
//								return $(option.element).attr("data-num");
//							},
//						    escapeMarkup: function (m) {   //this function change text to html content
//						    	return m;
//						}}).on("select2:open", function() {
//						       $(".select2-search__field").attr("placeholder", iam_search_text+"...");//No I18N
//							});
//						$(document.Viewmoreaddphonenum.countrycode).on("select2:closing", function (e) {
//							$(".select2-selection__rendered").focus();	
//						});
//						$("#select_phonenumber .select2-selection").append("<span id='selectFlag' class='selectFlag'></span>");
//						selectFlag($(document.Viewmoreaddphonenum.countrycode).find("option:selected"));
//						$(".select2-selection__rendered").attr("title", "");
//					    $(document.Viewmoreaddphonenum.countrycode).on("select2:close", function (e) { 
//							$(e.target).siblings("input").focus();
//						});
//					}
//							
//				}
				
			
				if(prev_num!=undefined)
				{
					if(prev_num != id_num)
					{
						$("#view_all_phonenumber .field_mobile").removeClass("web_email_specific_popup");
						
						$("#mobile_num_"+prev_num+" .inline_action").slideUp(300,function(){
							$("#mobile_num_"+prev_num+" .inline_action").remove();
						});
						$("#view_all_phonenumber #mobile_num_"+id_num+" .inline_action" ).slideDown(300,function(){
							
//							if($("#view_all_phonenumber #mobile_num_"+id_num+" .inline_action .textbox:first").length==0){
//								$("#delete_specific_mob").focus();
//							}
//							else{
//								$("#view_all_phonenumber #mobile_num_"+id_num+" .inline_action .textbox:first" ).focus();
//							}
						});
					}
					else
					{
						var previous=$("#mobile_num_"+prev_num+" .inline_action")[0];
						var newele=$("#mobile_num_"+prev_num+" .inline_action")[1];
						$(previous).slideUp(300,function(){
							$(newele).slideDown(300,function(){
								$(previous).remove();
//								if($(newele).find(".textbox:first").length==0){
//									$("#delete_specific_mob").focus();
//								}
//								else{
//									$(newele).find(".textbox:first" ).focus();
//								}
							});
						});
					}
				}
				else
				{
						$("#view_all_phonenumber #mobile_num_"+id_num+" .inline_action" ).slideDown(300,function(){
//							if($("#view_all_phonenumber #mobile_num_"+id_num+" .inline_action .textbox:first" ).length==0){
//								$("#delete_specific_mob").focus();
//							}
//							else{
//								$("#view_all_phonenumber #mobile_num_"+id_num+" .inline_action .textbox:first" ).focus();			
//							}							
						});
				}
				$("#view_all_phonenumber #mobile_num_"+id_num).addClass("web_email_specific_popup");
				
				

			});
		}
		tooltipSet("#phonenumber_web_more .action_icon"); //No I18N
		tooltipSet(".field_mobile .action_icon");//No I18N
		tooltipSet("#phonenumber_web_more .verify_icon");//No I18N
		$("#phonenumber_web_more").focus();
		closePopup(closeview_all_phonenumber_view,"phonenumber_web_more");//No I18N
}


function Otp_verify_show_specific()
{
	if(isMobile)
		{
			$("#show_specific_ph_info #empty_phonenumber").hide();
			$("#show_specific_ph_info #phonenumber_password").hide();
			$("#show_specific_ph_info #select_existing_phone").hide();
			$("#show_specific_ph_info #otp_phonenumber").show();
			$("#show_specific_ph_info #select_phonenumber").hide();
			
			$('#show_specific_ph_info #popup_mobile_action').html(iam_verify_phone_number);
//			$('#show_specific_ph_info #popup_mobile_action').attr("onclick","verifyPhoneNumber(document.addemailid,true)");
			
			$('#show_specific_ph_info #popup_mobile_action').attr("onclick","verifyOTP(document.Viewmoreaddphonenum,new_phonum_callback);");
			//$("#show_specific_ph_info #phoneNumberform_specific").attr("action",contextpath+"/u/verifyotp");//No I18N
			
	
			$('#show_specific_ph_info #otp_phonenumber_input').val('');
		}
		else
		{
			$("#view_all_phonenumber #empty_phonenumber").hide();
			$("#view_all_phonenumber #phonenumber_password").hide();
			$("#view_all_phonenumber #select_existing_phone").hide();
			$("#view_all_phonenumber #otp_phonenumber").show();
			$("#view_all_phonenumber #select_phonenumber").hide();
			
			$('#view_all_phonenumber #popup_mobile_action').html(iam_verify_phone_number);
//			$('#view_all_phonenumber #popup_mobile_action').attr("onclick","verifyPhoneNumber(document.addemailid,true)");
			
			$('.web_email_specific_popup button').attr("onclick","verifyOTP(document.Viewmoreaddphonenum,new_phonum_callback);");
			//$("#web_specific_popup_ph #phoneNumberform_specific").attr("action",contextpath+"/u/verifyotp");//No I18N

			
	
			$('#view_all_phonenumber #otp_phonenumber_input').val('');
		}
}
//function verifyPhoneNumber_specific()
//{
//		if(isMobile)
//		{
//			$("#show_specific_ph_info #empty_phonenumber").hide();
//			$("#show_specific_ph_info #phonenumber_password").show();
//			$("#show_specific_ph_info #select_existing_phone").hide();
//			$("#show_specific_ph_info #otp_phonenumber").hide();
//			$("#show_specific_ph_info #select_phonenumber").hide();
//			
//			$('#show_specific_ph_info #popup_mobile_action').html(err_addphone_confirm);
////			$('#show_specific_ph_info #popup_mobile_action').attr("onclick","confirmaddmobile(document.addemailid)");
//			
//			$('#show_specific_ph_info #popup_mobile_action').attr("onclick","confirm_addphone(document.Viewmoreaddemailid,new_phonum_callback);");
//			//$("#show_specific_ph_info #phoneNumberform_specific").attr("action",contextpath+"/u/confirmaddmobile");//No I18N
//	
//			$('#show_specific_ph_info #passwod').val('');
//		}
//		else
//		{
//			$("#view_all_phonenumber #empty_phonenumber").hide();
//			$("#view_all_phonenumber #phonenumber_password").show();
//			$("#view_all_phonenumber #select_existing_phone").hide();
//			$("#view_all_phonenumber #otp_phonenumber").hide();
//			$("#view_all_phonenumber #select_phonenumber").hide();
//			
//			var ph =$("#view_all_phonenumber #select_phonenumber input").val();
//			$('#view_all_phonenumber #popup_mobile_action').html(err_addphone_confirm);
////			$('#view_all_phonenumber #popup_mobile_action').attr("onclick","confirmaddmobile(document.addemailid)");
//			
//			$('.web_email_specific_popup button').attr("onclick","confirm_addphone(document.Viewmoreaddphonenum,new_phonum_callback,"+ph+");");
//			//$("#web_specific_popup_ph #phoneNumberform_specific").attr("action",contextpath+"/u/confirmaddmobile");//No I18N
//	
//			$('#view_all_phonenumber #passwod').val('');
//		}
//}

function goback_mob()
{
	$("#view_all_phonenumber").show();
	$("#specific_phoneNUM").hide();
	$("#show_specific_ph_info").html("");
	$(".small_circle").removeClass("small_circle_selected");
}


function specific_showmake_prim_mobilescreen(heading,description,button,number,action,id)
{
	$("#show_specific_ph_info").html("");
	
	$("#specific_phoneNUM .small_circle").removeClass("small_circle_selected");
	$("#specific_phoneNUM #resendconfir_circle").addClass("small_circle_selected");
	
	$("#show_specific_ph_info").html('<br /><div class="popup_header "><div class="popuphead_details"><span class="popuphead_text">'+heading+'</span><span class="popuphead_define">'+description+'</span></div></div>');
	
	$('#popup_mobile_action span').html(button);;
	
	$("#phonenumber_popup_contents form").attr("name",action);
	$("#phonenumber_popup_contents form").attr("action",contextpath+"/u/updateMobilePrimary");//No I18N
	$('#popup_mobile_action').attr("onclick","editLoginName(document."+action+",changeprim_phonum_callback);"); //No I18N

	
	$("#empty_phonenumber").show();
	$("#select_phonenumber").hide();
	
	$("#phonenumber_password").show();
	$("#select_existing_phone").hide();
	$("#otp_phonenumber").hide();
	
	$("#empty_phonenumber_input_code").attr("readonly","readonly");
	$("#show_specific_ph_info").append($("#phonenumber_popup_contents").html()); //load into popuop
	$("#show_specific_ph_info #empty_phonenumber_input_code").val(number);
	$("#specific_phoneNUM #show_specific_ph_info form").attr("id","phoneNumberform_specific");
	$("#phonenumber_popup_contents form").attr("name","");
	$("#phonenumber_popup_contents form").attr("action","");

	
	
}

function specific_showchange_prim_mobilescreen(heading,description,button,action)
{

	$("#show_specific_ph_info").html("");
	
	$("#specific_phoneNUM .small_circle").removeClass("small_circle_selected");
	$("#specific_phoneNUM #icon-pencil_circle").addClass("small_circle_selected");
	
	$("#show_specific_ph_info").html('<br /><div class="popup_header "><div class="popuphead_details"><span class="popuphead_text">'+heading+'</span><span class="popuphead_define">'+description+'</span></div></div>');
	$('#popup_mobile_action span').html(button);;
	
	$("#phonenumber_popup_contents form").attr("name",action);
	$("#phonenumber_popup_contents form").attr("action",contextpath+"/u/updateMobilePrimary");//No I18N
	$('#popup_mobile_action').attr("onclick","editLoginName(document."+action+",changeprim_phonum_callback);"); //No I18N
	
	$("#empty_phonenumber").hide();
	$("#phonenumber_password").show();
	$("#select_existing_phone").show();
	$("#otp_phonenumber").hide();
	$("#select_phonenumber").hide();
	
	$("#show_specific_ph_info").append($("#phonenumber_popup_contents").html()); //load into popuop
	$("#specific_phoneNUM #show_specific_ph_info form").attr("id","phoneNumberform_specific");

	$("#phonenumber_popup_contents form").attr("name","");
	$("#phonenumber_popup_contents form").attr("action","");


}


function specific_show_editMobile(heading,description,button,number,action)
{
	
	$("#show_specific_ph_info").html("");
	
	$("#specific_phoneNUM .small_circle").removeClass("small_circle_selected");
	$("#specific_phoneNUM #icon-pencil_circle").addClass("small_circle_selected");
	
	$("#show_specific_ph_info").html('<br /><div class="popup_header "><div class="popuphead_details"><span class="popuphead_text">'+heading+'</span><span class="popuphead_define">'+description+'</span></div></div>');
	
	$('#popup_mobile_action span').html(button);
	
	$("#phonenumber_popup_contents form").attr("name",action);
	$("#phonenumber_popup_contents form").attr("action",contextpath+"/u/updateMobileAdd");//No I18N
	$('#popup_mobile_action').attr("onclick","validateForm(document.addemailid,Otp_verify_show_specific);");
	
	$("#empty_phonenumber").hide();
	$("#select_phonenumber").show();
	
	$("#phonenumber_password").hide();
	$("#select_existing_phone").hide();
	$("#otp_phonenumber").hide();
	
	
	$("#show_specific_ph_info").append($("#phonenumber_popup_contents").html()); //load into popuop
	$("#specific_phoneNUM #show_specific_ph_info form").attr("id","phoneNumberform_specific");

	$("#show_specific_ph_info #empty_phonenumber_input").val(number);
	$("#phonenumber_popup_contents form").attr("name","");
	$("#show_specific_ph_info #select_phonenumber_input").val(number.split(') ')[1]);
	$("#show_specific_ph_info #old_mob").val(number.split(') ')[1]);
	
	$("#phonenumber_popup_contents form").attr("name","");
	$("#phonenumber_popup_contents form").attr("action","");

	
	if(!isMobile)
	{
		$(document.addemailid.countrycode).select2({ width: '67px'}).on("select2:open", function() {
		       $(".select2-search__field").attr("placeholder", iam_search_text);//No I18N
		       $("#select_phonenumber_input").addClass("textindent78");
		  });
		$('#select2-countNameAddDiv-container').text($( "#countNameAddDiv option:selected" ).text().split('(')[1].split(')')[0]);
		codelengthChecking("countNameAddDiv","select_phonenumber_input");//No I18N
		$(".select2-selection__rendered").attr("title", "");
	}
}



function specific_deleteMobile(mobile) 
{
	
	$("#show_specific_ph_info").html("");
	
	$("#specific_phoneNUM .small_circle").removeClass("small_circle_selected");
	$("#specific_phoneNUM #deleteicon_circle").addClass("small_circle_selected");
	
	$("#show_specific_ph_info").html('<br /><div class="popup_header "><div class="popuphead_details"><span class="popuphead_text">'+delete_Mobile+'</span><span class="popuphead_define">'+formatMessage(err_mobile_sure_delete1, mobile)+'</span></div></div>');
	$("#show_specific_ph_info").append('<input class="primary_btn_check  " id="delete_specific_mob" type="button" value="'+iam_continue+'">');
	
	$("#delete_specific_mob").click(function(){
		
		
		
		var params = "mobile="+euc(mobile.trim())+"&"+csrfParam;//No I18N
		var url=contextpath+"/u/deleteMobile";//No i18N
		sendRequestURI(url,params,delete_phonum_callback);    
	    return false;
		
		
	});
	
}





