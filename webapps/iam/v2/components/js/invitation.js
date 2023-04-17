//$Id$
var isFormSubmitted = false;
var GInvitation = ZResource.extendClass({
	  				resourceName: "GInvitation",//No I18N
	 				identifier: "digest",//No I18N
	 				attrs : ["firstname","lastname","country","newsletter","password"]	//No I18N  
				});

function reject_group_invitation() {
	if(isFormSubmitted) {
		return false;
	}
	isFormSubmitted = true;
	disabledButton("#reject_btn");//No I18N
	new URI(GInvitation,digest).DELETE().then(function(resp) {
	      show_resultpopup(false);
	},
  	function(resp) {
		show_group_invitation_error(getErrorMessage(resp));
  	}); 
}
				
function accept_group_invitation(signupRequired) {
	if(isFormSubmitted) {
		return false;
	}
	err_remove();
	if(signupRequired) {	 
		var form = document.signup_form;
		if($("#signup_container").is(":visible")){
			if(form.first_name.value==""){
				$(form.first_name).parent().append("<span class='err_text'>"+I18N.get("IAM.ERROR.EMPTY.FIELD")+"</span>");
				$(form.first_name).focus();
				return false;
			}
			if(form.last_name.value==""){
				$(form.last_name).parent().append("<span class='err_text'>"+I18N.get("IAM.ERROR.EMPTY.FIELD")+"</span>");
				$(form.last_name).focus();
				return false;
			}
			if(form.password.value==""){
				  $(form.password).after("<span class='err_text'>"+I18N.get("IAM.ERROR.ENTER_PASS")+"</span>");
				  $(form.password).focus();
				  return false;
			}
			if(!validatePassword('#signup_pass')){
				$(form.password).after("<span class='err_text'>"+I18N.get("IAM.ERROR.INVITATION.PASSWORD.INVALID")+"</span>");
				$(form.password).focus();
			  	return false;
			}
			if(form.con_password.value==""){
				$(form.con_password).parent().append("<span class='err_text'>"+I18N.get("IAM.REENTER.PASSWORD")+"</span>");
				$(form.con_password).focus();
				return false;
			}
			if(!validateConfirmPassword('#signup_pass')){
				$(form.con_password).parent().append("<span class='err_text'>"+I18N.get("IAM.PASSWORD.ERROR.WRONG.CONFIRMPASS")+"</span>");
				$(form.con_password).focus();
				return false;
			}
			if(form.tos_check.checked == false ){
				 $(form.tos_check).parent().append("<div class='err_text'>"+I18N.get("IAM.ACCOUNT.SIGNUP.POLICY.ERROR.TEXT")+"</div");
				 return false;
			}
			var parms={
					"firstname"	:form.first_name.value,		//No I18N
					"lastname"	:form.last_name.value,		//No I18N
					"country"	:form.country.value,		//No I18N
					"newsletter":form.news_letter.checked,		//No I18N
					"password"	:form.password.value			//No I18N
			};
		}
		else{
			$("#acceptGroupInvite").hide(0,function(){
				$("#signup_container").show();
			});	
			$(form.first_name).focus();
			return false;
		}
  	} else {
  		var parms={};
  	}
    var payload = GInvitation.create(parms);
    isFormSubmitted = true;
    var disable_ele = signupRequired ? form.signup_button :"#accept_btn";	//No I18N
    disabledButton(disable_ele);
    payload.PUT(digest).then(function(resp) {
        show_resultpopup(true,resp.ginvitation.redirect_url);
    },
    function(resp) {
    	show_group_invitation_error(getErrorMessage(resp));
    }); 
}

function show_resultpopup(is_accepted,link) {
	isFormSubmitted = false;
	removeButtonDisable(".disable_button");//No I18N
	show_blur_screen();
	if(is_accepted){
		$("#result_popup_accepted").show(0,function() {
			$("#result_popup_accepted").addClass("pop_anim");   
			$("#result_popup_accepted button").attr("onclick","redirectLink('"+link+"',this)");
		});  
	} else{
		$("#result_popup_rejected").show(0,function() {
			$("#result_popup_rejected").addClass("pop_anim");        
		});   
	}
}

function show_group_invitation_error(cause) {
	isFormSubmitted = false;
	removeButtonDisable(".disable_button");//No I18N
	showErrMsg(cause);
}

function setSelect2WithFlag(ele){
	$(ele).select2({
		width:"300px", //No I18N
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
	       $(".select2-search__field").attr("placeholder", I18N.get("IAM.SEARCH")+'...');//No I18N
	});
	$(ele+"+.select2 .select2-selection").append("<span id='selectFlag' class='selectFlag'></span>");
	selectFlag($(document.signup_form.country).find("option:selected"));	
}

function selectFlag(e){
    var flagpos = "flag_"+$(e).val().toUpperCase();//No i18N
    $(".select2-selection__rendered").attr("title","");
    e.parent().siblings(".select2").find("#selectFlag").attr("class","");//No i18N
    e.parent().siblings(".select2").find("#selectFlag").addClass("selectFlag"); //No I18N  
    e.parent().siblings(".select2").find("#selectFlag").addClass(flagpos); //No I18N  
}