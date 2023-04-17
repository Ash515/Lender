//$Id$
var accConfirmObj = ZResource.extendClass({
	resourceName: "Confirmation",//No I18N
	identifier: "digest",	//No I18N  
	attrs:["password"]
});
function confirmAccount(){
	err_remove();
	var parms={};
	if(!hasPassword){
		  var pass = $("#pass_input");
		  var conf_pass = $("#pass_conform_input").val();
		  if(pass.val()==""){
			  pass.parent().append("<span class='err_text'>"+current_pass_err+"</span>");
			  pass.focus();
			  return false;
		  }
		  if(!validatePassword('#pass_input')){
			  pass.parent().append("<span class='err_text'>"+valid_pass_err+"</span>");
			  pass.focus();
			  return false;
		  }
		  if(conf_pass==""){
			  $("#conform_pass_field #pass_conform_input").parent().append("<span class='err_text'>"+reenter_err+"</span>");
			  $("#conform_pass_field #pass_conform_input").focus();
			  return false;
		  }
		  if(!validateConfirmPassword("#pass_input")){
			  $("#pass_conform_input").parent().append("<span class='err_text'>"+password_mismatch_err+"</span>");
			  $("#pass_conform_input").focus();
			  return false;
		  }
		  var parms=
		  {
				  "password":pass.val()//No I18N
		  };
	}
	else if(isPasswordRequired){
		var pass = $("#confirm_pass_input");

		  if(pass==""){
			  pass.parent().append("<span class='err_text'>"+current_pass_err+"</span>");
			  pass.focus();
			  return false;
		  }
		  if(pass.val().length<PasswordPolicy.data.min_length){
			  pass.parent().append("<span class='err_text'>"+valid_pass_err+"</span>");
			  pass.focus();
			  return false;
		  }
		  var parms=
		  {
				  "password": pass.val()	//No I18N
		  };
	}
	else{
		var pass=$(".textbox_div:last");
	}
	disabledButton(document.confirm_form.confirm_btn);
	
	var payload = accConfirmObj.create(parms);	
	payload.PUT(digest).then(function(resp){		//No I18N
		removeButtonDisable(document.confirm_form.confirm_btn);
		showSuccessSignin();
	},
	function(resp){
		removeButtonDisable(document.confirm_form.confirm_btn);
		$(".pass_allow_indi").removeClass("show_pass_allow_indi");
		if(resp.errors[0].field){
			if(pass.hasClass("textbox_div")){
				pass.append("<span class='err_text'>"+getErrorMessage(resp)+"</span>");
				pass.focus();
			}
			else{
				pass.parent().append("<span class='err_text'>"+getErrorMessage(resp)+"</span>");
			}
		}
		else{
			$(".textbox_div:last").append("<span class='err_text'>"+network_common_err+"</span>");
		}
	});
}

function showSuccessSignin(){
	show_blur_screen();
	 $("#result_popup").show(0,function()
	 {
	     $("#result_popup").addClass("pop_anim");        
	 });
}
