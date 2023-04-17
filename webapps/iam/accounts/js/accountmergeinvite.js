//$Id: $
(function($) {
	var params = Util.parseParameter(location.search);
	$.fn.zaAccountInvitation = function(options) {
		var args = null;
		if (!options || typeof options == "object") { // First Time
			args = [ $.extend(true, {}, $.fn.zaAccountInvitation.defaults, options) ];
			this.attr({
				novalidate : true,
				autocomplete : "off" // No I18N
			});
		}
		return this.form.apply(this, args || arguments);
	};
	// Default Values
	$.fn.zaAccountInvitation.defaults = {
		url : function() {
			return ZAConstants.contextpath + (params.r ? "/rejectinvite.ac" : "/accmergeinvite.ac"); // No I18N	
		},
		params : {
			servicename : params.servicename,
			digest : params.digest,
			redirecturl : params.redirecturl,
			is_ajax : true
		},
		onsubmit : function() {
			$(".btn_loading").css("display","inline-block");
			$('.verify_btn,.skip_btn').map(function(d,i){i.onclick=null;});//No I18N
		},
		success : function(data) {
			var ar = new AjaxResponse(data);
			if(ar.error) { //security exp response error handling
				this.showErrors(I18N.get(ar.error));
				return;
			}
			var data = ar.data, _this = this;
			if(data.reject === true){
				var redirect = data.redirect;
				if(redirect){
					showSuccessMsg(I18N.get("IAM.ORG.INVITATION.REJECT.SUCCESS"), data.url, true); // No I18N
				}else{
					showSuccessMsg(I18N.get("IAM.ORG.INVITATION.REJECT.SUCCESS"),null,false);
				}
			} else{
				var statusCode = data.httpResponseCode, isSuccess = (statusCode >= 200 && statusCode < 300), representation = data.representation[0];
				if(!isSuccess) {
					if (data.httpResponseCode == "400" && representation.redirect_uri) {
						window.location.href = representation.redirect_uri;
					} else if (!data.errorCode) {
						showErrMsg(I18N.get("IAM.ERROR.GENERAL")); // No I18N
					} else {
						var errorObj = {}, errorCode = data.errorCode;
						errorObj = data.localizedMessage || I18N.get("IAM.ERROR.GENERAL");
						if (typeof errorObj == "string") {
							showErrMsg(errorObj);
						}
					}
				}else {
					showSuccessMsg(I18N.get("IAM.ORG.MERGE.SUCCESS"), representation.redirect_uri,true); // No I18N
				}
			}
		},
		
		error : function() {
			showErrMsg(I18N.get("IAM.ERROR.GENERAL")); // No I18N
		}
	};
})(jQuery);

function showSuccessMsg(msg,uri,showbtn)
{
	$(".btn_loading").hide();
	$(".blur_screen").css({"display": "block"});
	$(".announcement_popup").css({"display": "block"});
	$(".success_message").html(msg); //No I18N
	if(showbtn){
		$('#continue').html(I18N.get("IAM.CONTINUE")); // No I18N
		$('#continue').click(function () { window.location = uri;});
	} else {
		$('#continue').css("display","none");
	}
}

function showErrMsg(msg) 
{
	$(".btn_loading").hide();
    $(".top_div").css({"border-right": "3px solid #ef4444", "color": "#ef4444"});       
    $(".cross_mark").css("background-color","#ef4444");                 
    $(".crossline1").css({"top": "18px", "left": "0px", "width":"20px"});           
    $(".crossline2").css("left","0px");     
    $('.top_msg').html(msg); //No I18N

    $( ".top_div" ).fadeIn("slow");
    
    setTimeout(function() {
        $( ".top_div" ).fadeOut("slow");
    }, 5000);;
}

