//$Id$

var yubikey_challenge={};

var Announcement = ZResource.extendClass({
	  resourceName: "Announcement",//No I18N
	  identifier: "type"	//No I18N  
});

var MFA  = ZResource.extendClass({
	  resourceName: "mfa",//No I18N
	  identifier: "type",	//No I18N 
	  parent : Announcement
});

var EnforcedMfaTOTP = ZResource.extendClass({ 
	  resourceName: "EnforcedMfaTOTP",//No I18N
	  identifier: "identifier",	//No I18N
	  path : 'totp',// No i18N
	  attrs : ["code"], // No i18N
	  parent : MFA
});

var EnforcedMfaMobile = ZResource.extendClass({ 
	  resourceName: "EnforcedMfaMobile",//No I18N
	  attrs : ["mobile","countrycode","code"], // No i18N
	  path : 'mobile',//No I18N 
	  identifier: "encryptedMobile",	//No I18N 
	  parent : MFA
});


var EnforcedMfaYubikey = ZResource.extendClass({ 
	  resourceName: "EnforcedMfaYubikey",//No I18N
	  path : 'yubikey',//No I18N
	  attrs : [ "appId","clientData","registrationData"],// No i18N
	  identifier: "yubikeyName",	//No I18N 
	  parent : MFA
});





function err_remove()
{
	$(".err_text").remove();
}

function open_new_link(link)
{
	window.location.href = link;
}


function select_mode(ele)
{
	var check=$("#"+ele.id).hasClass("highlight_selectmode");
	if(check)
	{
		return;
	}
	$(".realradiobtn").attr("checked", false);	//No I18N
	
	$(".selectedbox").find(".mode_description").slideUp(200);
	$(".selectedbox").removeClass("highlight_selectmode");
	$("#"+ele.id).addClass("highlight_selectmode");
	$("#"+ele.id).find(".radio_btn").find(".realradiobtn").prop("checked", true);	//No I18N
	
	
	//hide other divs
	$("#gauth_textbox_btn").hide();
	$("#third_step").hide();
	$("#yubikey_textbox_btn").hide();
	$("#second_step").hide();
	$("#ode_container").hide();
	
	if(ele.id == "smsmode_div")
	{
		
		$("#verify_mobile").hide();
		$("#sms_textbox_btn").hide();
		$("#sms_mode_desc").show();
		$("#ode_container").show();
		
		
		$("#combobox").select2({ 
			width:"auto",//No I18N
			dropdownParent: $("#get_mobile"),
			templateResult: phoneSelectformat,
			templateSelection: function (option) 
			{
				selectFlag($(option.element));
				codelengthChecking(option.element,"tfa_number_input");//No i18N
				return $(option.element).attr("data-num");
			},
			escapeMarkup: function (m) {
			    	return m;
		}}).on("select2:open", function(){
			       $(".select2-search__field").attr("placeholder", I18N.get("IAM.SEARCHING"));//No I18N
		});
		$("#get_mobile .select2-selection").append("<span id='selectFlag' class='selectFlag'></span>");
		selectFlag($("#combobox").find("option:selected"));
		$(".select2-selection__rendered").attr("title", "");
		control_Enter(".primary_btn_check");//No I18N
	    $("#combobox").on("select2:close", function (e) { 
			$(e.target).siblings("input").focus();
		});
	    
	    $("#mobilenumber").keyup(function(event) 
		{
		    if (event.keyCode === 13) 
		    {
		        $("#sendcodebtn").click();
		    }
		});
	    
	    
	}
	if(ele.id == "gauthmode_div")
	{
		$("#gauth_textbox_btn").show();
		
		var payload = EnforcedMfaTOTP.create();
		payload.POST("pre","self").then(function(resp)	//No I18N
		{
			var EnforcedMfaTOTP=resp.enforcedmfatotp[0];
			de('gauthimg').src="data:image/jpeg;base64,"+EnforcedMfaTOTP.qr_image;
			var key=EnforcedMfaTOTP.secretkey;
			
			var displaykey = "<span>"+key.substring(0, 4)+"</span>"+"<span style='margin-left:5px'>"+key.substring(4, 8)+"</span>"+"<span style='margin-left:5px'>"+key.substring(8,12)+"</span>"+"<span style='margin-left:5px'>"+key.substring(12)+"</span>"; //No I18N
			$('#manual_totp_code').html(displaykey); //No i18N
			
			$("#auth_app_confirm").attr("onclick","verify_auth_qr('"+EnforcedMfaTOTP.encryptedSecretKey+"')");
			
			$("#gauth_code").keyup(function(event) 
			{
			    if (event.keyCode === 13) 
			    {
			        $("#auth_app_confirm").click();
			    }
			});
			
		},
		function(resp)
		{
			showErrMsg(getErrorMessage(resp)); 
		});	
	} 
	$("#"+ele.id).find(".mode_description").slideDown(200);
}

//yubikey mode

function show_yubikey_configure()
{
	
	var parms={};

	var payload = EnforcedMfaYubikey.create(parms);
	payload.POST("pre","self").then(function(resp)	//No I18N
    {
		$("#ubkey_wait_butt").show();
		show_yubikey_step2();
		
		
		if(resp != null)
		{
			yubikey_challenge=resp.enforcedmfayubikey[0];
			delete yubikey_challenge.href;
			yubikey_register();
		}
    },
    function(resp)
	{
    	showErrMsg(getErrorMessage(resp));
	});

}


function show_yubikey_step1()
{
	$("#first_step").show();
	$("#second_step").hide();
}

function yubikey_register()
{
	$("#ubkey_wait_butt").show();
	$("#ubkey_tryagain_butt").hide();
	u2f.register(yubikey_challenge.appId,[yubikey_challenge],[],ubkeyregister_Callback,10);
}

function get_YUBIKEY_name()
{
	$("#second_step").hide();
	$("#third_step").show();
	$("#yubikey_textbox_btn").show();
	$("#yubikey_name").keyup(function(event) 
	{
	    if (event.keyCode === 13) 
	    {
	        $("#yubikey_name_confirm").click();
	    }
	});
}

function show_yubikey_step2()
{
	$("#first_step").hide();
	$("#third_step").hide();
	$("#yubikey_textbox_btn").hide();
	$("#second_step").show();
}


function ubkeyregister_Callback(data)
{
	if(data.errorCode) 
	{
		$("#ubkey_wait_butt").hide();
		$("#ubkey_tryagain_butt").show();
		 switch (data.errorCode) 
		 {
	        case 1:
	        case 5:
	        	showErrMsg(I18N.get('IAM.NEW.SIGNIN.YUBIKEY.ERROR.REGISTRATION.TIMEOUT')); //No I18N
	        	break;
	         case 2:
	        	 showErrMsg(I18N.get('IAM.NEW.SIGNIN.YUBIKEY.ERROR.BADREQUEST')); //No I18N
	         	break;
	     	case 3:
	     		showErrMsg(I18N.get('IAM.NEW.SIGNIN.YUBIKEY.ERROR.UNSUPPORTED')); //No I18N
	             break;
	         case 4:
	        	 showErrMsg(I18N.get('IAM.NEW.SIGNIN.YUBIKEY.ERROR.DEVICEINELIGIBLE')); //No I18N
	         	break;
	         default:
	        	 showErrMsg(I18N.get('IAM.MFA.YUBIKEY.ERROR.INVALID.REQUEST')); //No I18N
		 }
    } 
	else 
	{
		yubikey_challenge.clientData=data.clientData;
		yubikey_challenge.registrationData=data.registrationData;
		
		get_YUBIKEY_name();
	}
}

function configure_yubikey()
{
	var name=$("#yubikey_name").val();
	err_remove();
	if(isEmpty(name))
	{
		$("#yubikey_textbox_btn").append( '<div class="err_text " style="margin-top:5px">'+I18N.get("IAM.ERROR.EMPTY.FIELD")+'</div>');
		return false;
	}
	else if(/^[a-zA-Z0-9_\-]*$/.test(name) == false)
	{
		$("#yubikey_textbox_btn").append( '<div class="err_text" style="margin-top:5px">'+I18N.get("IAM.MFA.YUBIKEY.INVALID.YUBIKEY_NAME")+'</div>');
		return false;
	}
	
	var parms=
	{
			"appId":yubikey_challenge.appId,//No I18N		
			"clientData":yubikey_challenge.clientData,//No I18N	
			"registrationData":yubikey_challenge.registrationData//No I18N	
	};

	var payload = EnforcedMfaYubikey.create(parms);
	payload.PUT("pre","self",name).then(function(resp)	//No I18N
    {
		var data=resp;
		showSuccesspopup(data);
    },
    function(resp)
	{
    	showErrMsg(getErrorMessage(resp)); 
	});
}



//sms mode

function validateMobile(val)
{
	var regex = /^\d{5,14}$/; 
	if(val.search(regex) == -1){
		return false; 
	}
	return true; 
}

function addmobile()
{
	
	err_remove();
	var mobVal = de('mobilenumber').value.trim();  //No I18N
	if(mobVal == "")
	{
		$("#get_mobile").append( '<div class="err_text">'+I18N.get("IAM.ERROR.EMPTY.FIELD")+'</div>' );
		return;
	}
	var countryCode = de('combobox').value.trim(); //No I18N
	if(validateMobile(mobVal) != true) 
	{
		$("#get_mobile").append( '<div class="err_text">'+I18N.get("IAM.PHONE.ENTER.VALID.MOBILE_NUMBER")+'</div>' );
		return;
	}
	
	disabledButton($("#tfa_sms_box"));
	var parms=
	{
		"mobile":mobVal,//No I18N
		"countrycode":countryCode//No I18N
	};


	var payload = EnforcedMfaMobile.create(parms);
	
	payload.POST("pre","self").then(function(resp)	//No I18N
	{
		showmsg(getErrorMessage(resp)); 
		var EnforcedMfaMobile=resp.enforcedmfamobile;
		$("#smsVerifyButton").attr("onclick","verify_sms_code('"+EnforcedMfaMobile.encryptedMobile+"')");
		$("#mobile_edit").text(mobVal);
		$("#verify_mobile").show();
		$("#sms_textbox_btn").show();
		$("#sms_mode_desc").hide();
		$("#ode_container").hide();
	},
	function(resp)
	{
		showErrMsg(getErrorMessage(resp)); 
	});
}


function verify_sms_code(key)
{
	var val = de('verification_code').value; //No I18N
	var mobVal = de('mobilenumber').value.trim();  //No I18N
	
	if(isEmpty(val))
	{
		$("#sms_textbox_btn").append( '<div class="field_error">'+I18N.get("IAM.ERROR.EMPTY.FIELD")+'</div>' );
		return;

	}
	if(isNaN(val))
	{
		$("#sms_textbox_btn").append( '<div class="field_error">'+I18N.get("IAM.PHONE.INVALID.VERIFY_CODE")+'</div>' );
		return;
	}
	
	var parms=
	{
		"code":val//No I18N
	};
	var payload = EnforcedMfaMobile.create(parms);
	
	payload.PUT("pre","self",key).then(function(resp)       //No I18N
	{
		var data=resp;
		showSuccesspopup(data);
	},
	function(resp)
	{
		showErrMsg(getErrorMessage(resp)); 
	});	
}


function editMobile()
{
	$("#verify_mobile").hide();
	$("#sms_textbox_btn").hide();
	$("#sms_mode_desc").show();
	$("#ode_container").show();
}


// authenticator
function verify_auth_qr(key)
{
	err_remove();
	var code = de('gauth_code').value; //No I18N
	if(code == "")
	{
		$("#gauth_textbox_btn").append( '<div class="err_text">'+I18N.get("IAM.ERROR.EMPTY.FIELD")+'</div>' );
		return;
	}
	var parms=
	{
		"code":code//No I18N
	};
	var payload = EnforcedMfaTOTP.create(parms);
	
	payload.PUT("pre","self",key).then(function(resp)	//No I18N
	{
		var data=resp;
		
		showSuccesspopup(data);
	},
	function(resp)
	{
		showErrMsg(getErrorMessage(resp)); 
	});	
}

function showSuccesspopup(data)
{
	 show_blur_screen();
	 $("#result_popup .defin_text").html(getErrorMessage(data));
	 $("#result_popup").show(0,function()
	 {
	     $("#result_popup").addClass("pop_anim");        
	 });
}

function manualEntry()
{
	$('#qr_display_div').hide();
	$('#manual_entry_div').show();
}

function backToQrScan()
{
	$('#qr_display_div').show();
	$('#manual_entry_div').hide();
}


//SELECT 2 FUNCTIONS

function phoneSelectformat(option) 
{
	//use to country flag structure in select2
    var spltext;
	if (!option.id) { return option.text; }
	spltext=option.text.split("(");
	var num_code = $(option.element).attr("data-num");
	var string_code = $(option.element).attr("value");

	var ob = '<div class="pic flag_'+string_code+'" ></div><span class="cn">'+spltext[0]+"</span><span class='cc'>"+num_code+"</span>" ;
	return ob;
};

function selectFlag(e)
{
    var flagpos = "flag_"+$(e).val().toUpperCase();//No i18N
    $(".select2-selection__rendered").attr("title","");
    e.parent().siblings(".select2").find("#selectFlag").attr("class","");//No i18N
    e.parent().siblings(".select2").find("#selectFlag").addClass("selectFlag"); //No I18N
    e.parent().siblings(".select2").find("#selectFlag").addClass(flagpos); //No I18N
}

function codelengthChecking(length_id,changeid){
	var code_len=$(length_id).attr("data-num").length;
	var length_ele = $(length_id).parent().siblings("#"+changeid);
	length_ele.removeClass("textindent58");
	length_ele.removeClass("textindent66");
	length_ele.removeClass("textindent78");
	if(code_len=="3"){
		length_ele.addClass("textindent66");
    }
    else if(code_len=="2"){
    	length_ele.addClass("textindent58");
    }
    else if(code_len=="4"){
    	length_ele.addClass("textindent78");
    }
	length_ele.focus();
}


function control_Enter(tag)
{
	$(tag).keypress(function(event){
		if(event.keyCode==13){
			this.click();
		}
	});
}




