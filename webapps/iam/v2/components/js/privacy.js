//$Id$

function privacy_callback_data(callback,zid){
	
	de('zcontiner').style.display='none';
	$(".content").show();
	new URI(User,"self","self").include(privacy).include(POLICY).include(KYC).include(certificates).GET().then(function(resp)	//No I18N
			{
				privacy_data=resp.User;
				de('zcontiner').style.display="none";
				$('#zcontiner').html(privacy_html);//No I18N
				load_privacy();
				if(callback){
					callback(zid);
				}
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
					 de('zcontiner').style.display="none";
					 $('#zcontiner #exception_page_txt').html(getErrorMessage(resp))
					 if(callback){
						callback(zid);
					 }
				 }
			});
}

function load_GDPRdetails(dpa_data)
{
	if($('#ccpa_toggle').is(':checked')){
		dpa_data = dpa_data.ccpa_data.data;
		$('.header_for_gdpr').hide();
		$('.header_for_ccpa').show();
	}
	else{
		dpa_data = dpa_data.gdpr_data.data;
		$('.header_for_ccpa').hide();
		$('.header_for_gdpr').show();
	}
	if(dpa_data!=undefined && Object.keys(dpa_data).length != 0)
	{
		$("#dpa_space").show();
		$("#privacy_setup_allowed").hide();
		var non_initiate_org = dpa_data.pending_orgs;
		var completed_orgs = dpa_data.completed_orgs;
		var initiated_orgs = dpa_data.initiated_orgs;
		var service_name,user_visible_name;
		$(".org_container").html("");
		$('.org_division').show();
		if(completed_orgs.length==0 && initiated_orgs.length == 0){
			$("#signed_org_status").hide();
			$("#gdpr_form").hide();
			$("#org_select_container").show();
			$("#org_list").html('');
			for(var x in non_initiate_org){
				service_name = non_initiate_org[x].service_name ? non_initiate_org[x].service_name : non_initiate_org[x].org_name;
				user_visible_name = non_initiate_org[x].org_name;
				if(service_name != non_initiate_org[x].org_name){
					user_visible_name = non_initiate_org[x].org_name+" ("+non_initiate_org[x].service_name+")";
				}
				$("#org_list").append('<option data-org_name="'+non_initiate_org[x].org_name+'" data-service="'+service_name+'" value="'+non_initiate_org[x].zid+'">'+user_visible_name+'</option>');
			}
			if(!isMobile){				
				$("#org_list").select2({
					width:"320px" //No I18N
				});
			}
		}
		else
		{
			$("#gdpr_form").hide();
			$("#org_select_container").hide();
			$("#signed_org_status").show();
			var data,service_name,ele;
			for(var i in completed_orgs){
				data = completed_orgs[i];
				service_name = data.service_name ? data.service_name:data.org_name;
				$("#signed_org .org_container").append($(".template").html());
				ele = $("#signed_org .org_container").children()[i];
				$(ele).find(".org_name").html(data.org_name);
				$(ele).find(".service_name").html(service_name);
				$(ele).find(".status_indicator").addClass("dpa_completed icon-ccomplete");
				$(ele).find(".status_indicator").attr("title",iam_gdpr_dpa_complete_tooltip)
				$(ele).find(".org_button").remove();
				$(ele).find(".status_block").remove();
				if(data.parent_org_name){
					$(ele).find(".manual_sign").remove();
					$(ele).find(".singed_with_parent").html(formatMessage(iam_gdpr_dpa_signed_with_parent_text,data.parent_org_name));
				}
				else{
					$(ele).find(".singed_with_parent").remove();
				}
			}
			for(var i in initiated_orgs){
				data = initiated_orgs[i];
				service_name = data.service_name ? data.service_name:data.org_name;
				service_name_js = data.service_name_js ? data.service_name:data.org_name_js;
				$("#pending_org .org_container").append($(".template").html());
				ele = $("#pending_org .org_container").children()[i];
				$(ele).find(".org_name").html(data.org_name);
				$(ele).find(".service_name").html(service_name);
				if(data.status=="ERROR"){
					$(ele).find(".status_indicator").addClass("dpa_error icon-cerror");
					$(ele).find(".status_indicator").attr("title",iam_gdpr_dpa_reject_tooltip)
					$(ele).find(".org_button span").not(":first").remove();
					if(data.description_message == ""){
						$(ele).find(".status_block").remove();
					}else{
						$(ele).find(".rej_reason").text(data.description_message);
					}
					$(ele).css("order","-1");
					$(ele).find("#sign_reinitiate").attr("onclick","getForm_details('"+data.zid+"','"+data.org_name_js+"','"+service_name_js+"',true)");
				}
				else{
					$(ele).find(".status_indicator").addClass("dpa_waiting icon-cwaiting");
					$(ele).find(".status_indicator").attr("title",iam_gdpr_dpa_initiate_tooltip)
					$(ele).find(".org_button").remove();
					$(ele).find(".status_block").remove();
				}
				$(ele).find(".signed_org_type").remove();
			}
			if(completed_orgs.length>0){
				var show_merge = true;
				for(var i in completed_orgs){
					if(!completed_orgs[i].parent_org_name){
						var show_merge = false;
						break;
					}
				}
				for(var i in non_initiate_org){
					data = non_initiate_org[i];
					service_name = data.service_name ? data.service_name:data.org_name;
					service_name_js = data.service_name_js ? data.service_name:data.org_name_js;
					$("#unsigned_org .org_container").append($(".template").html());
					ele = $("#unsigned_org .org_container").children()[i];
					$(ele).find(".org_name").html(data.org_name);
					$(ele).find(".service_name").html(service_name);
					$(ele).find(".status_block").remove();
					$(ele).find(".status_indicator").remove();
					$(ele).find(".signed_org_type").remove();
					$(ele).find("#sign_reinitiate").remove();
					$(ele).find("#add_to_singed").attr("onclick","showMergePopup("+data.zid+")");
					$(ele).find("#sign_create").attr("onclick","getForm_details('"+data.zid+"','"+data.org_name_js+"','"+service_name_js+"',true)");
				}	
				if(show_merge){
					$("#unsigned_org .org_container").find("#add_to_singed").remove();
				}
			}
			$(".org_head + .org_container:empty").parent().hide();
			if(dpa_data.completed_orgs.length==0 && dpa_data.initiated_orgs.length<=1){
				$(".pending_org_note").show();
			}
			else{
				$(".pending_org_note").hide();
			}
			if(!isMobile){				
				tooltipSet("#signed_org_status .status_indicator"); //No I18N
			}
		}		
		
	}
	else{
		$("#org_select_container,#gdpr_form,#signed_org_status").hide();
		$("#exception_page_privacy").show();
	}
}

function saveGDPRdetails(f,zid,org_name){
	remove_error();
	var fName = f.fname.value.trim();
	var email = f.email.value.trim();
	var cName = f.cname.value.trim();
	var cRegNumber = f.cregnumber.value.trim();
	var data = f.cdata.value.trim();
	var StrName = f.address_street.value.trim();
	var city = f.address_city.value.trim();
	var state = f.address_state.value.trim();
	var ccountry = f.dpaCn.value.trim();
	var zcode = f.z_code.value.trim();
	var dpa_type = 1;
	if(isEmpty(fName)){
		show_Err(f.fname,err_fname);
    	return false;
	}
	if(isEmpty(email)){
		show_Err(f.email,iam_gdpr_dpa_email_err);
    	return false;
	}
    else if(isEmpty(cName)){
    	show_Err(f.cname,iam_gdpr_dpa_cname_err);
    	return false;
	}
	if(!$('#ccpa_toggle').is(':checked')){
		dpa_type = 0;
	    if(isEmpty(cRegNumber)){
	    	show_Err(f.cregnumber,iam_gdpr_dpa_com_reg_num_err);
	    	return false;
		}
	    else if(isEmpty(data)){
	    	show_Err(f.cdata,iam_gdpr_dpa_data_err);
	    	return false;
	    }
	}
    if(isEmpty(StrName)){
    	show_Err(f.address_street,iam_gdpr_dpa_street_err);
    	return false;
	}
    else if(isEmpty(city)){
    	show_Err(f.address_city,iam_gdpr_dpa_city_err);
    	return false;
	}
    else if(isEmpty(state)){
    	show_Err(f.address_state,iam_gdpr_dpa_state_err);
    	return false;
	}
    else if(isEmpty(zcode)){
    	show_Err(f.z_code,iam_gdpr_dpa_z_code_err);
    	return false;
	}
	else if(isEmpty(ccountry)){
		show_Err(f.dpaCn,iam_gdpr_dpa_country_err);
    	return false;
	}
	else{
		disabledButton(f);
		var parms={};
		if($('#ccpa_toggle').is(':checked')){
			parms=
			{
				"fn":fName,				//No I18N
				"em":email,				//No I18N
				"on":org_name,			//No I18N
				"cn":cName,				//No I18N
				"dpa_type":dpa_type, 	//No I18N
				"ca":{					//No I18N
						"str":StrName,	//No I18N
						"city":city,	//No I18N
						"state":state,	//No I18N
						"country":ccountry,	//No I18N
						"zcode":zcode	//No I18N
					}
			};
		}
		else{
			parms=
			{
				"fn":fName,				//No I18N
				"em":email,				//No I18N
				"on":org_name,			//No I18N
				"cn":cName,				//No I18N
				"rn":cRegNumber,		//No I18N
				"cd":data,				//No I18N
				"dpa_type":dpa_type, 	//No I18N
				"ca":{					//No I18N
						"str":StrName,	//No I18N
						"city":city,	//No I18N
						"state":state,	//No I18N
						"country":ccountry,	//No I18N
						"zcode":zcode	//No I18N
					}
			};
		}

		var payload = DpaObj.create(parms);
		
		payload.POST(zid).then(function(resp){		//No I18N
			removeButtonDisable(f);
			showContactForm(zid);
			SuccessMsg(getErrorMessage(resp));
		},
		function(resp){
			removeButtonDisable(f);
			showErrorMessage(getErrorMessage(resp));
		});
	}
}

function showMergePopup(child_id){
	$("#dpa_merge_popup").show(0,function(){
 		$("#dpa_merge_popup").addClass("pop_anim");
	});
	var completed_orgs;
	if($('#ccpa_toggle').is(':checked')){
		completed_orgs= privacy_data.Privacy.ccpa_data.data.completed_orgs;
	}
	else{
		completed_orgs= privacy_data.Privacy.gdpr_data.data.completed_orgs;
	}
	$("#parent_org_option option").remove();
	for(var i in completed_orgs){
		if(!completed_orgs[i].hasOwnProperty("parent_org_name")) {
			
			service_name = completed_orgs[i].service_name ? completed_orgs[i].service_name : completed_orgs[i].org_name;
			user_visible_name = completed_orgs[i].org_name;
			
			if(service_name != completed_orgs[i].org_name){
				user_visible_name = completed_orgs[i].org_name+" ("+completed_orgs[i].service_name+")";
			}
			$("#parent_org_option").append("<option value='"+completed_orgs[i].zid+"'>"+user_visible_name+"</option>");	//No I18N
		}
	}
	$("#parent_org_option").select2({
		width : "320px" //No I18N 
	});
	$(".select2-selection__rendered").removeAttr("title");
	$("#merge_button").attr("onclick","merge_org('"+child_id+"')");
	popup_blurHandler('6','.5');
	closePopup(closeMergePopup,"dpa_merge_popup");//No I18N
	$("#dpa_merge_popup").focus();
}

function closeMergePopup(){
	popupBlurHide('#dpa_merge_popup'); //No I18N
}

function merge_org(child_id){
	var parent_id = $("#parent_org_option").val();
	var dpa_type = 0;
	if($('#ccpa_toggle').is(':checked')){
		dpa_type = 1;
	}
	var param = {
					"szid" : child_id,		//No I18N
					"dpa_type" : dpa_type 	//No I18N
				}
	var payload = DpaObj.create(param);
	payload.PUT(parent_id).then(function(resp){
		closeMergePopup();
		privacy_callback_data();
		SuccessMsg(getErrorMessage(resp));
	},
	function(resp){
		showErrorMessage(getErrorMessage(resp));
	})
}

function show_info(ele)
{
	if(privacy_data.Privacy.dpa_status!=undefined	&& (privacy_data.Privacy.dpa_status==5	||	privacy_data.Privacy.dpa_status==6))
	{
		$("#user_completed").toggle();
	}
	else
	{
		var information =$(ele);
		information.siblings(".show_elem").toggle(); //No I18N
	}
}

function load_KYCdetails(kyc_data,callback,kyc_id){
	var org_list = kyc_data;
	for(var x in org_list){
		service_name = org_list[x].service_name ? org_list[x].service_name : org_list[x].org_name;
		user_visible_name = org_list[x].org_name;
		if(service_name != org_list[x].org_name){
			user_visible_name = org_list[x].org_name+" ("+org_list[x].service_name+")";
		}
		$("#kyc_org_list").append('<option value="'+x+'">'+user_visible_name+'</option>');
	}
	if(kyc_id && kyc_data.hasOwnProperty(kyc_id)){
		$("#kyc_org_list").val(kyc_id);		
	}
	if(!isMobile){
		$("#kyc_org_list").select2({
			dropdownCssClass: "kyc_org_select",//No I18N
			width:"200px" //No I18N
		});
	}
	loadKycOrgDetails(callback,kyc_id);
}


function removeCheckbox_err(){
	$(document.contacts.kyc_ADR_role).parents(".privacy_role_box").siblings('.field_error').remove();
}

function addKyc_Contact(orgid,kyc){
	
	var contact_count;
	var parms={};
	if(kyc && (!$(".kyc_contact_container").is(":visible")||$(".slide_header").is(":visible"))){
		remove_error();

		if(checkMYC_FormField().org||checkMYC_FormField().personal){
			return false;
		}
		contact_count = $(".kyc_contact_container").children();
		parms=
		{
			"on":$(document.organization.org_name).val(),			//No I18N
			"it":$(document.organization.industry_type).val(),		//No I18N
			"ec":$(document.organization.number_of_emp).val(),		//No I18N
			"em":$(document.personal.email).val(),					//No I18N
			"fn":$(document.personal.fname).val(),					//No I18N
			"ln":$(document.personal.lname).val(),					//No I18N
			"mn":$(document.personal.mobile).val(),					//No I18N
			"dn":$(document.personal.designation).val(),			//No I18N
			"ca":{													//No I18N
					"str":$(document.organization.area).val(),		//No I18N
					"city":$(document.organization.city).val(),		//No I18N
					"state":$(document.organization.state).val(),	//No I18N
					"country":$(document.organization.kycCn).val(),	//No I18N
					"zcode":$(document.organization.z_code).val()	//No I18N	
			}
		};		
		disabledButton($(".form_action_btns"));
	}	
	else{
		if($("#gdpr_form").is(":visible")){			
			contact_count = $(".contact_collecting_container").children();		
			disabledButton($(".contact_form_button"));
		}
		else{
			contact_count = $(".kyc_contact_container").children();
			disabledButton($(".form_action_btns"));
		}
	}
	var contact_array=[];
	var collected_contact={};
	for(var i=0; i<contact_count.length; i++){
		var ele = contact_count[i];
		collected_contact={};
		if($(ele).find(".isNew").val()!=""){	
			if(isEmpty($(ele).find(".l_name").html()) && isEmpty($(ele).find(".contact_mail").html())){
				collected_contact={
						"cem":$(ele).find(".f_name").html(),			//No I18N
						"dpo":$(ele).find(".dpo").length !=0,			//No I18N
						"pr":$(ele).find(".priv_rep").length !=0,		//No I18N
						"adr":$(ele).find(".adr").length !=0,			//No I18N
						"bn":$(ele).find(".breach_notif").length !=0,			//No I18N
						"spn":$(ele).find(".subprocessor_notif").length !=0,			//No I18N
						"add":$(ele).is(":visible")						//No I18N
				}
			}
			else{
				collected_contact={
						"cem":$(ele).find(".contact_mail").html(),		//No I18N
						"cfn":$(ele).find(".f_name").html(),			//No I18N
						"cln":$(ele).find(".l_name").html(),			//No I18N
						"dpo":$(ele).find(".dpo").length !=0,			//No I18N
						"pr":$(ele).find(".priv_rep").length !=0,		//No I18N
						"adr":$(ele).find(".adr").length !=0,			//No I18N
						"bn":$(ele).find(".breach_notif").length !=0,			//No I18N
						"spn":$(ele).find(".subprocessor_notif").length !=0,			//No I18N
						"add":$(ele).is(":visible")						//No I18N
				}
			}
			contact_array.push(collected_contact);
		}
	}
	parms.kyc_contacts=contact_array;
	var payload = KYC_Org_Obj.create(parms);
	payload.POST(orgid).then(function(resp){		
		removeButtonDisable($(".contact_form_button"));
		removeButtonDisable($(".form_action_btns"));
		SuccessMsg(getErrorMessage(resp));
		close_gdpr_form(true);
	},
	function(resp){
		removeButtonDisable($(".contact_form_button"));
		removeButtonDisable($(".form_action_btns"));
		showErrorMessage(getErrorMessage(resp));
	});
}

function loadKycOrgDetails(callback,kyc_id){
	var org_id =$("#kyc_org_list").val();
	new URI(KYC_Org_Obj,org_id).GET().then(function(resp)
			{
				removeGif();
				de('zcontiner').style.display='block';
				$(".box_cover loader").hide();
				$("#kyc_space").attr("onclick","clicked_tab('privacy','myc?"+org_id+"')");
				if(callback){
					callback();
				}
				else{
					scroll_tab("myc",scroll_change); //No I18N
				}
				$(".select2-selection__rendered").removeAttr("title");
				var result = resp[0].data;
				privacy_data.KYC.cur_org_detail = result;
				if(result.KYCDetails==undefined||result.KYCDetails.contacts.length==0){
					$("#no_kyc").show();
					$(".contact_details").hide();
					if(JSON.stringify(privacy_data.KYC).indexOf("has_contacts") === -1){
						$("#merge_contact_btn").hide();
					}
					else{
						$("#merge_contact_btn").show();
					}
					$("#kycOptionButton").select2({
						width:"fir-content", //No I18N
						minimumResultsForSearch: Infinity,
						theme: "kycOption", //no I18N
					    templateSelection: function (option) {
		   		            return $("#kycOptionButton option:first").html();
					    }
					});
					$("#select2-kycOptionButton-container").addClass("primary_btn_check");

					if(kyc_id){
						showKycForm('add'); //No I18N
					}
					return false;
				}
				else{
					
					$("#merge_contact_btn").hide();
					$("#no_kyc").hide();					
					$(".contact_details").show();
					//$(".privacy_contacts .icon-showall").hide();
					//load personal detail
					$(".detail_container").html("");
					$(".personal_detail .detail_container").append($(".personal_detail .detail_template")[0].outerHTML);
					$(".detail_container .detail_template").removeClass("hide");
						
					$(".personal_detail").show();
					var personal_is_empty = true;
					if(!isEmpty(result.personalDetails.fn)||!isEmpty(result.personalDetails.ln)){
						$(".personal_detail .detail_container .f_name").text(result.personalDetails.fn);
						$(".personal_detail .detail_container .l_name").text(result.personalDetails.ln);
						personal_is_empty = false;
					}
					else{
						$(".personal_detail .detail_container .name_detail").hide();
					}
					if(!isEmpty(result.personalDetails.email)){
						$(".personal_detail .detail_container .email_id").text(result.personalDetails.email);
						personal_is_empty = false;
					}
					else{
						$(".personal_detail .detail_container .mail_detail").hide();						
					}
					if(!isEmpty(result.personalDetails.num)){
						personal_is_empty = false;
						$(".personal_detail .detail_container .mob_number").text(result.personalDetails.num);
					}
					else{
						$(".personal_detail .detail_container .mobile_detail").hide();						
					}
					if(!isEmpty(result.personalDetails.dsn)){
						//$(".personal_detail .detail_container .f_name").parents(".contact_name").css("line-height","50px");
						$(".personal_detail .detail_container .contact_mail").parents(".detail_divide_div").hide();
						personal_is_empty = false;
					}
					else{						
						$(".personal_detail .detail_container .contact_mail").text(result.personalDetails.dsn);
					}
					if(personal_is_empty==true){
						$(".personal_info_empty").show();
						$(".personal_detail .detail_container").hide();
						$(".personal_detail .kyc_blue_btn").hide();
					}
					else{
						$(".personal_info_empty").hide();
						$(".personal_detail .detail_container").show();
						$(".personal_detail .kyc_blue_btn").show();
					}
					//load org details
					$(".org_detail .detail_container").html("");
					$(".org_detail .detail_container").append($(".org_detail .detail_template")[0].outerHTML);
					$(".detail_container .detail_template").removeClass("hide");
					var org_is_empty = true;
					if(!isEmpty(result.KYCDetails.org_name)){
						$(".org_detail .detail_container .org_name").text(result.KYCDetails.org_name);
						org_is_empty = false;
					}
					else{
						$(".org_detail .detail_container .org_name").parents(".detail_divide_div").hide();
					}
					if(result.KYCDetails.em_n == -1 || result.KYCDetails.em_n == 0){
						$(".org_detail .detail_container .contact_mail").parents(".detail_divide_div").hide();
						//$(".org_detail .detail_container .org_name").parents(".contact_name").css("line-height","50px");
					}
					else
					{
						org_is_empty = false;
						$(".org_detail .detail_container .emp_count").text(result.KYCDetails.em_n);					
					}
					if(isEmpty(result.KYCDetails.industry)){
						$(".org_detail .detail_container .indus_type").parents(".detail_divide_div").hide();
					}
					else{
						$(".org_detail .detail_container .indus_type").text(KYC_INDUSTRY_TYPE[result.KYCDetails.industry]);
						$(".org_detail .detail_container .indus_type_val").val(result.KYCDetails.industry);
						org_is_empty = false;
					}
					if(result.KYCDetails.add.hasOwnProperty("ctry")){
						result.KYCDetails.add.str != "" ? $(".org_detail .detail_container .st_name").text(result.KYCDetails.add.str+", ") : "";
						result.KYCDetails.add.cty != "" ? $(".org_detail .detail_container .city_name").text(result.KYCDetails.add.cty+", ") : "";
						result.KYCDetails.add.st != "" ? $(".org_detail .detail_container .state").text(result.KYCDetails.add.st+", ") : "";
						$(".org_detail .detail_container .country").text($(document.organization.kycCn).find("#"+result.KYCDetails.add.ctry).html());
						result.KYCDetails.add.st != "" ? $(".org_detail .detail_container .p_code").text("- "+result.KYCDetails.add.pcode+".") : "";
						org_is_empty = false;
					}
					else{
						$(".org_detail .detail_container .indus_address_div").hide();
					}
					if(org_is_empty==true){
						$(".org_info_empty").show();
						$(".org_detail .detail_container").hide();
						$(".org_detail .kyc_blue_btn").hide();
					}
					else{
						$(".org_info_empty").hide();
						$(".org_detail .detail_container").show();
						$(".org_detail .kyc_blue_btn").show();
					}
					//load contact details
						
//						if(result.contacts.length>2){
//							$(".privacy_contacts .icon-showall").show();
//						}
						$(".privacy_contacts").show();
						$(".privacy_contacts .detail_container").html("");
						for(var a in result.KYCDetails.contacts){
							$(".privacy_contacts .detail_container").append($(".privacy_contacts .detail_template")[0].outerHTML);
							$(".detail_container .detail_template").removeClass("hide");
							var curr_ele = $(".privacy_contacts .detail_container .detail_template")[a];
							$(curr_ele).attr("onclick","showContact(this)");
							if((!isEmpty(result.KYCDetails.contacts[a].cfn) && !isEmpty(result.KYCDetails.contacts[a].cln))||(!isEmpty(result.KYCDetails.contacts[a].cfn) && isEmpty(result.KYCDetails.contacts[a].cln))){								
								$(curr_ele).find(".f_name").text(result.KYCDetails.contacts[a].cfn);
								$(curr_ele).find(".l_name").text(result.KYCDetails.contacts[a].cln);
								$(curr_ele).find(".contact_mail").text(result.KYCDetails.contacts[a].em);
								$(curr_ele).find(".email_dp").text(result.KYCDetails.contacts[a].cfn.slice(0,2));
							}
							else{
								$(curr_ele).find(".f_name").text(result.KYCDetails.contacts[a].em);
								$(curr_ele).find(".email_dp").text(result.KYCDetails.contacts[a].em.slice(0,2));
								$(curr_ele).find(".f_name").css("line-height","50px");
								$(curr_ele).find(".contact_mail").hide();
							}
							result.KYCDetails.contacts[a].dpo ? $(curr_ele).find(".dpo").show() : $(curr_ele).find(".dpo").remove();//No I18N
							result.KYCDetails.contacts[a].pr ? $(curr_ele).find(".priv_rep").show() : $(curr_ele).find(".priv_rep").remove();//No I18N
							result.KYCDetails.contacts[a].adr ? $(curr_ele).find(".adr").show() : $(curr_ele).find(".adr").remove();//No I18N
							result.KYCDetails.contacts[a].bn ? $(curr_ele).find(".breach_notif").show() : $(curr_ele).find(".breach_notif").remove();//No I18N
							result.KYCDetails.contacts[a].spn ? $(curr_ele).find(".subprocessor_notif").show() : $(curr_ele).find(".subprocessor_notif").remove();//No I18N
							if(a>3){
								$(curr_ele).addClass("contact_hide");
							}
						}
						if(result.KYCDetails.contacts.length <= 4){
							$(".privacy_contacts #add_with_viewmore").hide();
							$(".privacy_contacts .only_add").show();
						}
						else{
							$(".privacy_contacts #add_with_viewmore").show();
							$(".privacy_contacts .only_add").hide();
						}
				
				}
			},
			function(resp)
			{
				showErrorMessage(getErrorMessage(resp));
				removeGif();
				$("#kyc_space #exception_page_privacy").show();
				de('zcontiner').style.display='block';
			});
}
function showContact(ele){
	popup_blurHandler('6','.5');
	$("#kyc_show_contact").show(0,function(){
		$("#kyc_show_contact").addClass("pop_anim");
		$("#kyc_show_contact .contact_content .field").html($(ele).html());
	});
	closePopup(function(){popupBlurHide('#kyc_show_contact')},"kyc_show_contact");//No I18N
	$("#kyc_show_contact").focus();
}
function close_gdpr_form(callback){	
	popupBlurHide("#gdpr_form"); //No I18N
	remove_error();
	var dpa_data;
	if($('#ccpa_toggle').is(':checked')){
		var dpa_data = privacy_data.Privacy.ccpa_data.data;
	}
	else{
		var dpa_data = privacy_data.Privacy.gdpr_data.data;
	}
	if(callback){		
		privacy_callback_data();
	}
	if(dpa_data.completed_orgs.length>0 || dpa_data.initiated_orgs.length>0){
		$("#signed_org_status").show();
	}	
	else{
		$("#org_select_container").show();
	}
}

function showContactForm(zid){
	$(".dpa_header").hide();
	$("#gdpr_form .new_contact").hide();
	$(".add_contact_header").show();
	$(".contact_form_button").hide();
	$(document.dpa_form).hide();
	$(".add_contact_pop").show();
	$(".add_contact_pop .textbox").val("");
	$(".add_contact_pop .checkbox_check").prop("checked", false);
	$("#gdpr_form .close_btn").attr("onclick","close_gdpr_form(true)");
	$(".contact_form_button button:first-child").attr("onclick","addKyc_Contact('"+zid+"',false)");
	$("#gdpr_form .new_contact").attr("onclick","showContactForm('"+zid+"')");
	closePopup(function(){close_gdpr_form(true)},"gdpr_form");//No I18N
	$(document.add_contact.fname).focus();
}

function collectContect(f){
	
	remove_error();//No I18N
	if(isEmpty(f.email.value)){
		show_Err(f.email,iam_gdpr_dpa_email_err);
		return false;
	}
	
	if(!isEmailId(f.email.value)){
		show_Err(f.email,err_validemail);
		return false;
	}
	var ele;
	if($(f).hasClass("add_contact_pop"))
	{
		if(isEnteredEmail($(".contact_collecting_container .contact_outline"),f.email.value)){
			show_Err(f.email,iam_gdpr_dpa_email_exist_err);
			return false;
		}
		if(!$(f.privacy_rep_role).prop("checked") && !$(f.dpo_role).prop("checked") && !$(f.ADR_role).prop("checked") && !$(f.breach_notif).prop("checked") && !$(f.subprocessor_add_notif).prop("checked")){
			$(f.ADR_role).parents(".privacy_role_box").after('<div class="field_error">'+iam_gdpr_dpa_role_err+'</div>');
 			return false;
		}
		$(".add_contact_pop").hide();
		$(".contact_collecting_container").show();
		$("#gdpr_form .new_contact").show();
		$(".contact_form_button").show();
		$(".contact_collecting_container").append($(".contact_template").html());
		ele = $(".contact_collecting_container").children(":last");
		$(f.ADR_role).prop("checked")?$(ele).find(".adr").show():$(ele).find(".adr").remove();
	}
	else if($(f).hasClass("kyc_contacts_form"))
	{
		if(isEnteredEmail($(".kyc_contact_container .contact_outline"),f.email.value)){
			show_Err(f.email,iam_gdpr_dpa_email_exist_err);
			return false;
		}
		if(!$(f.privacy_rep_role).prop("checked") && !$(f.dpo_role).prop("checked") && !$(f.kyc_ADR_role).prop("checked") && !$(f.breach_notif).prop("checked") && !$(f.subprocessor_add_notif).prop("checked")){
			if($(f.kyc_ADR_role).parents(".privacy_role_box").next().hasClass("field_error")){
				$(f.kyc_ADR_role).parents(".privacy_role_box").siblings(".field_error").remove();
			}
			$(f.kyc_ADR_role).parents(".privacy_role_box").after('<div class="field_error">'+iam_gdpr_dpa_role_err+'</div>');
			return false;
		}

		$(".kyc_contacts_form").hide();
		$(".kyc_contact_container").show();
		$(".new_contact_kyc").show();
		$(".form_action_btns").show();
		$(".kyc_contact_container").append($(".contact_template").html());
		ele = $(".kyc_contact_container").children(":last");
		$(f.kyc_ADR_role).prop("checked")?$(ele).find(".adr").show():$(ele).find(".adr").remove();
	}
	if(isEmpty($(f.fname).val()) && isEmpty($(f.lname).val())){
		$(ele).find(".contact_name .f_name").text($(f.email).val());
		$(ele).find(".contact_name .f_name").css("line-height","50px");
		$(ele).find(".email_dp").text($(f.email).val().slice(0,2));
		$(ele).find(".contact_mail").hide();
	}
	else if(isEmpty($(f.fname).val()) && !isEmpty($(f.lname).val())){
		$(ele).find(".contact_name .f_name").text($(f.lname).val());
		$(ele).find(".contact_mail").text($(f.email).val());
		$(ele).find(".email_dp").text($(f.lname).val().slice(0,2));
	}
	else{	
		
		$(ele).find(".contact_name .f_name").text($(f.fname).val());
		$(ele).find(".contact_name .l_name").text($(f.lname).val());
		$(ele).find(".contact_mail").text($(f.email).val());
		$(ele).find(".email_dp").text($(f.fname).val().slice(0,2));
	}
	if(!isMobile){
		tooltipSet($(ele).find(".deleteicon")[0]);//No I18N
	}
	$(ele).find(".isNew").val(true);
	$(f.dpo_role).prop("checked")?$(ele).find(".dpo").show():$(ele).find(".dpo").remove();
	$(f.privacy_rep_role).prop("checked")?$(ele).find(".priv_rep").show():$(ele).find(".priv_rep").remove();
	$(f.breach_notif).prop("checked")?$(ele).find(".breach_notif").show():$(ele).find(".breach_notif").remove();
	$(f.subprocessor_add_notif).prop("checked")?$(ele).find(".subprocessor_notif").show():$(ele).find(".subprocessor_notif").remove();
	$(ele).parents(".contact_storage").find(".contact_outline:visible:first").css("margin-top","0px");//No I18N
	$(".contact_outline .role_type").hide();//hide roles temporary in add contact popup 
	
}


function showKycContactForm(){
	$(".new_contact_kyc").hide();
	$(document.contacts).show();
	$(".form_action_btns").hide();
	$(document.contacts.fname).focus();
	$(".kyc_contacts_form .textbox").val("");
	$(".kyc_contacts_form .checkbox_check").prop("checked", false);
	if($(".kyc_contact_container").children(".contact_outline").length - $(".kyc_contact_container").children(".deleted_contact").length != 0){
		$("#contact_edit_back").hide();
		$("#contact_edit_close").show();
	}
	else{
		$("#contact_edit_back").show();
		$("#contact_edit_close").hide();
	}
}
function checkMYC_FormField(hideError){
	var isError = {
			"personal":false, //No I18N
			"org":false	//No I18N
	}
	hideError==true?"":remove_error();
	form = $("#kyc_form_popup form:visible");
		if(form.hasClass("kyc_personal_form")){
		if(isEmpty($(document.personal.designation).val()))
		{
			hideError==true?"":show_Err($(document.personal.designation),iam_gdpr_kyc_designation_err);
			isError.personal = true;
		}
		if(!isBlank($(document.personal.mobile).val())){
			if(!Number.isInteger(+$(document.personal.mobile).val())){
				hideError==true?"":show_Err($(document.personal.mobile),err_enter_valid_mobile);
				isError.personal = true;
			}
		}
		if(isBlank($(document.personal.email).val())||!isEmailId($(document.personal.email).val())){
			hideError==true?"":show_Err($(document.personal.email),err_validemail);
			isError.personal = true;
		}
		if(isError.personal){
			$("#kyc_form_popup .org_detail,#kyc_form_popup .priv_detail").css("opacity","0.4");
			return isError;
		}
		else{
			$("#kyc_form_popup .org_detail").css("opacity","1");
			$("#kyc_form_popup .priv_detail").css("opacity","0.4");
		}
		}
		if(form.hasClass("kyc_org_form")){
		if(isEmpty($(document.organization.org_name).val()))
		{
			hideError==true?"":show_Err($(document.organization.org_name),iam_gdpr_kyc_org_name_err);
			isError.org = true;
		}
		if(!isBlank($(document.organization.number_of_emp).val())){
			if(!Number.isInteger(+$(document.organization.number_of_emp).val())){
				hideError==true?"":show_Err($(document.organization.number_of_emp),iam_gdpr_dpa_emp_count_err);
				isError.org = true;
			}
		}
		if(isError.org){
			$("#kyc_form_popup .priv_detail").css("opacity","0.4");
			return isError;
		}
		else{
			$("#kyc_form_popup .org_detail,#kyc_form_popup .priv_detail").css("opacity","1");
		}	
		}
		return isError;
}
function kycFormChange(ele,isCheckNeed){
	$(".kyc_contact_container").hide();
	$(".new_contact_kyc").hide();
	$(".form_action_btns").hide();
	if(isCheckNeed){
		if(checkMYC_FormField().personal||checkMYC_FormField().org){
			return false;
		}
	}
	if($(ele).hasClass("personal")){
		if(isMobile){
			$(".slide_header")[0].scrollLeft=0;
		}
		$(document.personal).show();
		$(document.organization).hide();
		$(document.contacts).hide();
		removeCheckbox_err();
		checkMYC_FormField(true);
		$(document.personal.fname).focus();
	}
	else if($(ele).hasClass("org_detail")){
		$(document.personal).hide();
		$(document.organization).show();
		$(document.contacts).hide();
		removeCheckbox_err();
		checkMYC_FormField(true);
		$(document.organization.org_name).focus();
	}
	else if($(ele).hasClass("priv_detail")){
		
		if(isMobile){
			$(".slide_header")[0].scrollLeft=$(".slide_header")[0].scrollWidth-$('body').width();
		}
		if($(".kyc_contact_container").children(".contact_outline").length - $(".kyc_contact_container").children(".deleted_contact").length != 0){
			$(".kyc_contacts_form").hide();
			$(".kyc_contact_container").show();
			$(".new_contact_kyc").show();
			$(".form_action_btns").show();
			$("#contact_edit_back").hide();
			$("#contact_edit_close").show();
		}
		else{
			$(document.contacts).show();
			$(document.contacts.fname).focus();	
			$("#contact_edit_back").show();
			$("#contact_edit_close").hide();
		}
		$(document.personal).hide();
		checkMYC_FormField(true);
		$(document.organization).hide();
	}
	remove_error();	
	$(".slide_header .high_light_border").css("width",$(ele)[0].offsetWidth);
	$(".slide_header .high_light_border").css("left",$(ele)[0].offsetLeft);
}

function showKycForm(mode){
	if(curr_country!=undefined	&&	curr_country!="")
	{
		$("#kyc_country option[value="+curr_country.toLowerCase()+"]").attr('selected','selected');
	}
	$(".form_action_btns .kyc_submit").attr("onclick","addKyc_Contact("+$("#kyc_org_list").val()+",true)");	//No I18N
	popup_blurHandler('6','.5');
	var data = privacy_data.KYC.cur_org_detail;
	$(document.personal.fname).val(data.personalDetails.fn ? data.personalDetails.fn : "");
	$(document.personal.lname).val(data.personalDetails.ln ? data.personalDetails.ln : "");
	$(document.personal.email).val(data.personalDetails.email ? data.personalDetails.email : "");
	var mob_num = data.personalDetails.num;
	if(mob_num && mob_num.indexOf("-") != -1){
		mob_num = mob_num.split("-")[1].trim();
	}
	$(document.personal.mobile).val(mob_num ? mob_num : "");
	$(document.personal.designation).val(data.personalDetails.dsn ? data.personalDetails.dsn : "");
	if(data.KYCDetails){
		$(document.organization.org_name).val(data.KYCDetails.org_name ? data.KYCDetails.org_name : "");
		$(document.organization.number_of_emp).val(data.KYCDetails.em_n ? data.KYCDetails.em_n : "");
		$(document.organization.industry_type).val(data.KYCDetails.industry ? data.KYCDetails.industry : "");
		$(document.organization.area).val(data.KYCDetails.add.str ? data.KYCDetails.add.str : "");
		$(document.organization.city).val(data.KYCDetails.add.cty ? data.KYCDetails.add.cty : "");
		$(document.organization.state).val(data.KYCDetails.add.st ? data.KYCDetails.add.st : "");
		$(document.organization.z_code).val(data.KYCDetails.add.pcode ? data.KYCDetails.add.pcode : "");
	}
	if(mode=="edit"){
		var contacts_list = $(".privacy_contacts .detail_container .detail_template");
		if(contacts_list.length!=0){
			for(var i=0;i<contacts_list.length;i++){
				$("#kyc_form_popup .kyc_contact_container").append($(".contact_template").html());
				$(".kyc_contact_container #kyc_contact").attr("id","kyc_contact"+i);
				var ele = $(contacts_list[i]);
				if(isEmpty(ele.find(".contact_mail").html()) && isEmpty(ele.find(".l_name").html())){
					$("#kyc_contact"+i+" .contact_name .f_name").text(ele.find(".f_name").html());
					$("#kyc_contact"+i+" .contact_name .f_name").css("line-height","50px");
					$("#kyc_contact"+i+" .email_dp").text(ele.find(".f_name").html().slice(0,2));
					$("#kyc_contact"+i+" .contact_mail").hide();
				}
				else{		
					$("#kyc_contact"+i+" .contact_name .f_name").html(ele.find(".f_name").html());
					$("#kyc_contact"+i+" .contact_name .l_name").html(ele.find(".l_name").html());
					$("#kyc_contact"+i+" .contact_mail").html(ele.find(".contact_mail").html());
					$("#kyc_contact"+i+" .email_dp").text(ele.find(".f_name").html().slice(0,2));
				}
				ele.find(".dpo").length !=0 ? $("#kyc_contact"+i+" .dpo").show() : $("#kyc_contact"+i+" .dpo").remove();
				ele.find(".priv_rep").length !=0 ? $("#kyc_contact"+i+" .priv_rep").show() : $("#kyc_contact"+i+" .priv_rep").remove();
				ele.find(".adr").length !=0 ? $("#kyc_contact"+i+" .adr").show():$("#kyc_contact"+i+" .adr").remove();
				ele.find(".breach_notif").length !=0 ? $("#kyc_contact"+i+" .breach_notif").show():$("#kyc_contact"+i+" .breach_notif").remove();
				ele.find(".subprocessor_notif").length !=0 ? $("#kyc_contact"+i+" .subprocessor_notif").show():$("#kyc_contact"+i+" .subprocessor_notif").remove();
			}
			$(".kyc_contact_container .role_type").hide();//hide roles temporary in add contact popup 
		}
		if(!isMobile){			
			tooltipSet(".kyc_contact_container .deleteicon");//No I18N
		}
	}
	
	if(!isMobile){
		$(".kyc_org_form #kyc_country").select2({
		    width: '320px',//No I18N
		    templateResult: function(option){
		        var spltext;
		    	if (!option.id) { return option.text; }
		    	spltext=option.text.split("(");
		    	var string_code = $(option.element).attr("value");
		    	var ob = '<div class="pic flag_'+string_code.toUpperCase()+'" ></div><span class="cn">'+spltext[0]+"</span>" ;
		    	return ob;
		    },
		    templateSelection: function (option) {
		    	selectFlag($(option.element));
		        return option.text;
	
		    },
		    escapeMarkup: function (m) {
		       return m;
		    }
		  }).on("select2:open", function() {
		       $(".select2-search__field").attr("placeholder", iam_search_text);//No I18N
		 });
		$("#kyc_country+.select2 .select2-selection").append("<span id='selectFlag' class='selectFlag'></span>");
		selectFlag($(document.organization.kycCn).find("option:selected"));
		$(".kyc_org_form #industry_type").select2({
			width:"320px"	//No I18N
		});
	}
	
	$(".kyc_popup").show(0,function(){
		$(".kyc_popup").addClass("pop_anim");
		$("#kyc_form_popup form #contact_form_submit").remove();
		if(mode=="edit"){
			var target_ele = event.target;
			if($(target_ele).parents().hasClass("org_detail")){
				kycFormChange(".slide_header .org_detail",false); //No I18N
				$(".kyc_org_form button").hide();
				$($(".kyc_org_form button")[0]).before($("#kyc_form_popup #contact_form_submit")[0].outerHTML);
				$(".kyc_org_form .kyc_submit").show();
			}
			else if($(target_ele).parents().hasClass("privacy_contacts")){
				kycFormChange(".slide_header .priv_detail",false); //No I18N
				$("#kyc_form_popup #contact_edit_back").hide();
				$("#kyc_form_popup #contact_edit_close").show();
				$("#kyc_form_popup .form_action_btns").show();
				$("#kyc_form_popup .form_action_btns .high_cancel").hide();
			}
			else
			{
				kycFormChange(".slide_header .head:first",false); //No I18N
				$(".kyc_personal_form button").hide();
				$(".kyc_personal_form button").before($("#kyc_form_popup #contact_form_submit")[0].outerHTML);
				$(".kyc_personal_form .kyc_submit").show();
			}
			$(".slide_header").hide()
		}
		else{
			$(".kyc_personal_form button").show();
			$(".kyc_org_form button").show();
			$("#kyc_form_popup .form_action_btns").hide();
			$("#kyc_form_popup .form_action_btns .high_cancel").show();
			$("#kyc_form_popup #contact_edit_back").show();
			$("#kyc_form_popup #contact_edit_close").hide();
			$(".slide_header").show()
			kycFormChange(".slide_header .head:first",false); //No I18N
		}
	});
	closePopup(closeKycForm,"kyc_form_popup");//No I18N
}

function closeKycForm(){
	popupBlurHide(".kyc_popup",function(){	//No I18N
		$(".kyc_contact_container").html("");
		$(".new_contact_kyc").hide();
		$("#kyc_form_popup input").val("");
		$("#kyc_form_popup .checkbox_check").prop("checked", false);
		$("#kycOptionButton").prop("selectedIndex", 0);
	});	//No I18N
	remove_error();
}

function view_all_contacts(){

	$("#view_all_contacts").html($(".privacy_contacts .detail_container").html());
	popup_blurHandler('6','.5');

	$("#kyc_contcts_viewall").show(0,function(){
		$("#kyc_contcts_viewall").addClass("pop_anim");
		$("#view_all_contacts .detail_template").removeAttr("onclick");
	});
	closePopup(function(){popupBlurHide('#kyc_contcts_viewall')},"kyc_contcts_viewall");//No I18N
	$("#kyc_contcts_viewall").focus();
}


function initiateDPA() 
{
	var zid = $("#org_list").val();
	var service_name = $("#org_list option:selected").attr("data-service");
	var org_name = $("#org_list option:selected").attr("data-org_name");
	getForm_details(zid,org_name,service_name,false);
	
}

function getForm_details(zid,org_name,service_name,loading){
		var parms = {
					"sn" : service_name,//No I18N
					"on" : org_name //No I18N
					};
		
		new URI(DpaObj,zid).setParams(parms).GET().then(function(resp)	//No I18N
		{
			var result = resp[0];
			//$("#org_select_container").hide();
			$(document.dpa_form).show();
			$(".contact_template").hide();
			$(".contact_collecting_container").hide();
			$(".contact_collecting_container").html("");
			$("#gdpr_form .new_contact").hide();
			$(".add_contact_pop").hide();
			$(".contact_form_button").hide();
			if($('#ccpa_toggle').is(':checked')){
				$(document.dpa_form.cdata).parents('.textbox_div').hide();	//No I18N
				$(document.dpa_form.cregnumber).parents('.textbox_div').hide();	//No I18N
				$('.define_for_ccpa').show();
				$('.define_for_gdpr').hide();
			}
			else{
				$(document.dpa_form.cdata).parents('.textbox_div').show();			//No I18N
				$(document.dpa_form.cregnumber).parents('.textbox_div').show();		//No I18N
				$('.define_for_ccpa').hide();
				$('.define_for_gdpr').show();
			}
			popup_blurHandler('6','.5');
			$("#gdpr_form").show(0,function(){
				$("#gdpr_form").addClass("pop_anim");		
			});
			$(document.dpa_form).find("input").not(document.dpa_form.fname).not(document.dpa_form.email).val("");
			if(curr_country!=undefined	&&	curr_country!="")
			{
				$("#dpa_country option[value="+curr_country.toLowerCase()+"]").attr('selected','selected');
			}
			document.dpa_form.cname.value = result.data != undefined || result.data.company_name != undefined ? result.data.company_name : "";
			$(document.dpa_form).find("#dpa_form_btn")[0].setAttribute("onclick","saveGDPRdetails(document.dpa_form,'"+zid+"','"+result.data.org_name+"')");
			if(!isMobile){
				$("#dpa_country").select2({
				    width: '320px',//No I18N
				    templateResult: function(option){
				        var spltext;
				    	if (!option.id) { return option.text; }
				    	spltext=option.text.split("(");
				    	var string_code = $(option.element).attr("value");
				    	var ob = '<div class="pic flag_'+string_code.toUpperCase()+'" ></div><span class="cn">'+spltext[0]+"</span>" ;
				    	return ob;
				    },
				    templateSelection: function (option) {
				    	selectFlag($(option.element));
				        return option.text;
		
				    },
				    escapeMarkup: function (m) {
				       return m;
				    }
				  }).on("select2:open", function() {
				       $(".select2-search__field").attr("placeholder", iam_search_text);//No I18N
				 });
				$("#dpa_country+.select2 .select2-selection").append("<span id='selectFlag' class='selectFlag'></span>");
				selectFlag($(document.dpa_form.dpaCn).find("option:selected"));
			}
			closePopup(close_gdpr_form,"gdpr_form");//No I18N
			$("#gdpr_form input:first").focus();
		},
		function(resp)
		{
			showErrorMessage(getErrorMessage(resp));
			de('zcontiner').style.display='block';
			$(".content").hide();
		});	
}

function isEnteredEmail(parent_ele,email)
{
	for(var i=0;i<parent_ele.length;i++)
	{
		if($(parent_ele[i]).is(":visible")){			
			if( (email==$(parent_ele[i]).find(".contact_mail").html()) || (email==$(parent_ele[i]).find(".f_name").html()) ){
				return true;
			}
		}
	}
	return false;
}

function showContactMerge(){
	$("#kyc_merge_popup").show(0,function(){
 		$("#kyc_merge_popup").addClass("pop_anim");
	});
	var completed_orgs = privacy_data.KYC;
	$("#parent_contact_option option").remove();
	for(var i in completed_orgs){
		if(completed_orgs[i].hasOwnProperty("has_contacts")) {
			
			service_name = completed_orgs[i].service_name ? completed_orgs[i].service_name : completed_orgs[i].org_name;
			user_visible_name = completed_orgs[i].org_name;
			
			if(service_name != completed_orgs[i].org_name){
				user_visible_name = completed_orgs[i].org_name+" ("+completed_orgs[i].service_name+")";
			}
			$("#parent_contact_option").append("<option value='"+i+"'>"+user_visible_name+"</option>");	//No I18N
		}
	}
	$("#parent_contact_option").select2({
		width : "320px" //No I18N 
	});
	$(".select2-selection__rendered").removeAttr("title");
	popup_blurHandler('6','.5');
	closePopup(function(){popupBlurHide('#kyc_merge_popup')},"kyc_merge_popup");//No I18N
	$("#kyc_merge_popup .select2-selection").focus();
}

function mergeContact(){
	
	var parent_id = $("#kyc_org_list").val();
	var param = {
			"soid":	$("#parent_contact_option").val()	//No I18N
	}
	var payload = KYC_Org_Obj.create(param);
	payload.PUT(parent_id).then(function(resp){
		SuccessMsg(getErrorMessage(resp));
		privacy_data.KYC[parent_id].has_contacts=true;
		popupBlurHide('#kyc_merge_popup');	//No I18N
		loadKycOrgDetails();
		
	},
	function(resp){
		showErrorMessage(getErrorMessage(resp));
	})
}

function remove_contact(ele,container){
	if($(ele).parent().siblings(".contact_outline:visible").length==0){
		$(ele).parents(".contact_storage").hide();
		$(ele).parents(".contact_storage").siblings(".addnew").click();
	}
	$(ele).parent().find(".isNew").val(true);
	$(ele).parent().addClass("deleted_contact");
	$(ele).parent().hide();
	$(ele).parents(".contact_storage").find(".contact_outline:visible:first").css("margin-top","0px");//No I18N
}
function show_Err(input,err_msg){
	$(input).parent().append( '<div class="field_error">'+err_msg+'</div>' );
	$(input).focus();
};

function selectKycOption(ele){
		showKycForm('add'); //No I18N
		if($(ele).val()==1){
			kycFormChange('.slide_header .priv_detail',false);	//No I18N
			$(".slide_header").hide();
			$("#contact_edit_back").hide();
			$("#kyc_form_popup .form_action_btns .high_cancel").hide()
		}
}