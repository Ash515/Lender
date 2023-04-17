//$Id$
function load_CERTIFICATEdetails(certificate_data) {
	var parent_service_ele = $(".services_list_box").html();
	var default_service_ele = $(parent_service_ele).first();
	
	for(var i = 0; i < (certificate_data.Certificates_PCI_services.length); i++) {
		if(i !== certificate_data.Certificates_PCI_services.length-1) {
			var new_service_ele = $(default_service_ele).clone();
			$(new_service_ele).appendTo(".services_list_box");
		}
		var service_name = certificate_data.Certificates_PCI_services[i].toLowerCase();
		
		$("#services_list_box").children(":eq("+i+")").find(".checkbox_check").attr("id", service_name); //NO I18N
		$("#services_list_box").children(":eq("+i+")").parents(".service_box").attr("for", service_name);//NO I18N
		$("#services_list_box").children(":eq("+i+")").find(".service_icon").addClass("icon20_"+service_name);
		$("#services_list_box").children(":eq("+i+")").find(".service_name").html(certificate_data.Certificates_PCI_services[i]);
	}
	
	var parent_cert_ele = $(".certifications_list_boxes").html();
	var default_cert_ele = $(parent_cert_ele).first();	
	for(var i = 0; i< (certificate_data.Certificate_list.length); i++) {
		if(i !== certificate_data.Certificate_list.length-1) {
			var new_service_ele = $(default_cert_ele).clone();
			$(new_service_ele).appendTo(".certifications_list_boxes");
		}
		var cert_name = certificate_data.Certificate_list[i].toLowerCase();
		$(".certifications_list_boxes").children(":eq("+i+")").attr("id", certificate_data.Certificate_types[(certificate_data.Certificate_list[i])]); //No I18N
		$(".certifications_list_boxes").children(":eq("+i+")").find(".certificate_icon").addClass(cert_name+"_cert");
		$(".certifications_list_boxes").children(":eq("+i+")").find(".certificate_name").html(certificate_data.Certificate_names[(certificate_data.Certificate_list[i])]);
	}
}

function cert_download(cert_type, is_download) {	
	$("#download_cert").prop("disabled", true);
	var formName = "certificate_download"; //No I18N
	$("form[name="+formName+"]").remove();
	$form = $("<form></form>");
	$form.attr({
		method : "get", //No I18N
		action : contextpath+ "/privacy/certificate/"+cert_type, //No I18N
		name : formName //No I18N
	});
	$form.append('<input type="hidden" name="download" value='+ is_download +' />');
	if(is_download) {
		var certificates_for_services= "";
	    $.each($("input[name='certi_services']:checked"), function(){
	    	if(certificates_for_services) {
	    		certificates_for_services += "," + $(this).siblings().find(".service_name").text();
	    	} else {
	    		certificates_for_services = $(this).siblings().find(".service_name").text();
	    	}
	    });
	    if(certificates_for_services.length != 0) {
			$form.append('<input type="hidden" name="services" value='+ certificates_for_services +' />');
		}
	    $form.attr('target','_self'); //No I18N
	} else {
		$form.attr('target','_blank'); //No I18N
	}
	$('body').append($form);
	$form.submit();
	$("#download_cert").prop("disabled", false);
}


//------------------------------using for slide popup function------------------------
var bodyScroll = $("body").scrollTop();

function showPopupWithPosition(eve,prevent_detail){
	
	var class_name = $(eve)[0].classList[0];
	if($("."+class_name+":visible").length < 2 && !isMobile)
	{
		if($('.expand_box').length==0){
			popup_blurHandler("6",'.5');
			$("#Email_popup_for_mobile").show(0,function(){
				$("#Email_popup_for_mobile").addClass("pop_anim");
			});
			$("#Email_popup_for_mobile .popuphead_details").html($(eve).html());
			$("#Email_popup_for_mobile .tag_types").remove();
			$(".mob_popu_btn_container,.option_container").hide();
			$(".mob_popu_btn_container .pop_detail").show();
			closePopup(close_for_mobile_specific,"Email_popup_for_mobile");//No I18N
		}
	}
	else{
			$('.box').removeClass('clicked_tab');
			$(eve).closest(".box").addClass('clicked_tab');
			$(".field_email,.field_mobile").removeClass("entry_highlight");
			$(eve).addClass("entry_highlight");
			if($(eve).closest(".box").hasClass("expand_box") && isMobile){
				$(".expand_box .right_slider .closeicon").attr("onclick","closeMobileSlider()");
			}
			if(!$(eve).closest(".box").hasClass("expand_box") ||isMobile)
			{
				var box=$(".box");
				var scroll=$(window).scrollTop(); 
				var data = {};
				if(!($(eve).closest(".box").hasClass("expand_box")&&isMobile)){
					bodyScroll = $("body").scrollTop();
					var no_of_big_boxes = $('.big_box').length;
					for(i=0;i<no_of_big_boxes;i++)
					{ 
						var getposition=$(box[i]).offset();
						var mesur ={'right':($(window).width() - ($(box[i]).offset().left + $(box[i]).outerWidth())),	// No I18N
								'top':getposition.top-scroll,		// No I18N
								'left':getposition.left,			// No I18N
								'height':$(box[i]).outerHeight()	// No I18N 
						};   
						data[i] = mesur; 
						
					}
					for(var x in data){
						$(box[x]).css("right",data[x].right+"px");
						$(box[x]).css("top",data[x].top+"px");
						$(box[x]).css("left",data[x].left+"px");
						$(box[x]).css("height",data[x].height+"px");
						$(box[x]).css("position","absolute");
					}
				}
				setTimeout(function(){ 
					$(".right_slider:visible").click();
					$(eve).closest(".box").find(".icon-showall").addClass('hide_expand_button');
					$(eve).closest(".box").find(".addnew").addClass('hide_expand_button');
					$(".clicked_tab").addClass("expand_box");
					if(!(prevent_detail&&isMobile)){
						$(".clicked_tab").find(".right_slider").addClass("show_slider").delay(10).queue(function(){
							$(".show_slider").addClass("show_slider_with_scroll").dequeue();
						});
					}
					$(".ztopbar").addClass("header_addborder");
					$('body').css({
						overflow: "hidden" //No I18N
					});
				},0);
				window.scrollTo(0,0);
			}
			setTimeout(function(){ 
				if($(eve).parents("#useremails_space").length != 0){
					fillEmailSliderData(profile_data.Email[$(eve).find(".emailaddress_text").html()]);
				}
				else if($(eve).parents("#phonenumbers_space").length != 0){
					fillMobileSliderData(profile_data.Phone.recovery[$(eve).find(".emailaddress_text").html().split(") ")[1]]);
				}
				else if($(eve).parents("#certifications_space").length != 0){
					fillCertificatesSliderData(compliance_data.Certificates, $(eve).attr("id")); //NO I18N
				}
			},0);
	}

}

function closeMobileSlider(){
	$(".expand_box .right_slider .closeicon").attr("onclick","closeSliderPopup(this)");
	$(".show_slider").removeClass("show_slider");
	$(".show_slider").removeClass("show_slider_with_scroll");
}
function fillEmailSliderData(data){
	$(".show_slider").find(".slider_head_text").html(data.email_id);
	$(".show_slider .primary_ind").next(".value").html(data.email_signin_type); //No I18N
	$(".show_slider").find(".added_time").next(".value").html(data.created_time_formated);
	if(data.is_primary){
		$(".show_slider .slider_btn_delete").hide();
		$(".show_slider #make_primary").hide();
		$(".show_slider .slider_actions").hide();
	}
	else{
		$(".show_slider .slider_btn_delete").attr("onclick","deleteEmail(\'"+data.email_id+"\',\'"+profile_data.primary_email+"\')");
		$(".show_slider .slider_btn_delete").show();
		$(".show_slider .slider_actions").show();
		$(".show_slider #make_primary").attr("onclick","showEmail_changePrimary('"+data.created_time+"_secondary','setAsPrimary')");
		$(".show_slider #make_primary").show();
	}
	//$(".right_slider").find(".location").next(".value").html(data.created_time_formated);
}

function fillMobileSliderData(data){
	$(".show_slider").find(".slider_head_text").html(data.display_number);
	$(".show_slider .slider_btn_delete").attr("onclick","deleteMobile('"+data.mobile+"')");
	$(".show_slider").find(".added_time").next(".value").html(data.created_time_formated);
	$(".show_slider #make_primary").hide();
}

function fillCertificatesSliderData(certificate_data, cert_type) {
	$(".checkbox_check").prop("checked", false);
	$(".checkbox_check").unbind("click").click(function() {
		if($(this).is(':checked')) {
			$(this).parents(".service_box").addClass("entry_highlight");
		} else {
			$(this).parents(".service_box").removeClass("entry_highlight");
		}
		if(($("#agreement_accept").prop("checked")) == true) {
			var service_box = $("#services_list_box").css("display");
			if(service_box == "table") {
				var no_of_services_selected = $(".service_box").find('.checkbox_check:checked').length;
				if(no_of_services_selected == 0) {
					disable_cert_buttons();
				} else {
					enable_cert_buttons();
				}
			} else {
				enable_cert_buttons();
			}
		} else {
			disable_cert_buttons();
		}
	});	
	$("#download_cert").unbind("click").click(function() {
		cert_download(cert_type, true); //NO I18N
	});
}

function enable_cert_buttons() {
	$("#download_cert").removeClass("pref_disable_btn").prop("disabled", false);
}

function disable_cert_buttons() {
	$("#download_cert").addClass("pref_disable_btn").prop("disabled", true);
}

function certifications_slide_content(eve, isUserAllowedToDownloadCertificate) {
	if(isUserAllowedToDownloadCertificate == 1) {
		$("#download_cert, #cert_agreement").css("display", "inline-block");
	} else {
		$(".service_box").find(".checkbox_check").css("display", "none");
		$(".service_box").find(".checkbox").css("display", "none");
	}
	$("#agreement_accept").prop({"checked": false, "disabled": false}).css("cursor", "pointer");
	$(".service_box").removeClass("entry_highlight");
	disable_cert_buttons();
	$(".entry_highlight").removeClass("entry_highlight");
	var cert_name = $(eve).find(".certificate_name").html();
	$(".certificate_description").html("").hide();
	$(".services_list_box").hide();
	$(".slider_header_cert_icon").removeClass(function (index, className) { //To remove previous cert icon in the header
	    return (className.match(/\b\S+_cert+/g) || []).join(' ');
	});
	$(".slider_head_content").find(".slider_head_text").text(cert_name);
	if(cert_name == i18nkeys["IAM.PRIVACY.CERTIFICATIONS.ISO27001"]) {
		$(".desc1").html(i18nkeys["IAM.PRIVACY.CERTIFICATIONS.ISO27001.DESCRIPTION"]).show(); //NO I18N
		$(".slider_header_cert_icon").addClass("iso27001_cert");
	} 
	else if(cert_name == i18nkeys["IAM.PRIVACY.CERTIFICATIONS.ISO27017"]) {
		$(".desc1").html(i18nkeys["IAM.PRIVACY.CERTIFICATIONS.ISO27017.DESCRIPTION1"]).show(); //NO I18N
		$(".desc2").html(i18nkeys["IAM.PRIVACY.CERTIFICATIONS.ISO27017.DESCRIPTION2"]).show();//NO I18N
		$(".slider_header_cert_icon").addClass("iso27017_cert");
	} 
	else if(cert_name == i18nkeys["IAM.PRIVACY.CERTIFICATIONS.ISO27018"]) {
		$(".desc1").html(i18nkeys["IAM.PRIVACY.CERTIFICATIONS.ISO27018.DESCRIPTION"]).show(); //NO I18N
		$(".slider_header_cert_icon").addClass("iso27018_cert");
	}
	else if(cert_name == i18nkeys["IAM.PRIVACY.CERTIFICATIONS.SOC"]) {
		$(".desc1").html(i18nkeys["IAM.PRIVACY.CERTIFICATIONS.SOC.DESCRIPTION"]).show(); //NO I18N
		$(".slider_header_cert_icon").addClass("soc2_cert");
	} 
	else if(cert_name == i18nkeys["IAM.PRIVACY.CERTIFICATIONS.PCI"]) {
		$(".desc1").html(i18nkeys["IAM.PRIVACY.CERTIFICATIONS.PCI.DESCRIPTION1"]).show(); //NO I18N
		$(".desc2").html(i18nkeys["IAM.PRIVACY.CERTIFICATIONS.PCI.DESCRIPTION2"]).show();//NO I18N
		$(".slider_header_cert_icon").addClass("pci_cert");
		if(isUserAllowedToDownloadCertificate == 1) {
			$(".services_list_box").css("display", "table");//NO I18N
		}
	} 
	else if(cert_name == i18nkeys["IAM.PRIVACY.CERTIFICATIONS.GDPR"]) {
		$(".desc1").html(i18nkeys["IAM.PRIVACY.CERTIFICATIONS.GDPR.DESCRIPTION1"]).show(); //NO I18N
		$(".desc2").html(i18nkeys["IAM.PRIVACY.CERTIFICATIONS.GDPR.DESCRIPTION2"]).show();//NO I18N
		$(".desc3").html(i18nkeys["IAM.PRIVACY.CERTIFICATIONS.GDPR.DESCRIPTION3"]).show();//NO I18N
		$(".slider_header_cert_icon").addClass("gdpr_cert");
	} 
	else if(cert_name == i18nkeys["IAM.PRIVACY.CERTIFICATIONS.TRUSTE"]) {
		$(".desc1").html(i18nkeys["IAM.PRIVACY.CERTIFICATIONS.TRUSTE.DESCRIPTION1"]).show(); //NO I18N
		$(".desc2").html(i18nkeys["IAM.PRIVACY.CERTIFICATIONS.TRUSTE.DESCRIPTION2"]).show();//NO I18N
		$(".slider_header_cert_icon").addClass("trust_cert");
	}
	else if (cert_name == i18nkeys["IAM.PRIVACY.CERTIFICATIONS.ISO9001"]) {
		$(".desc1").html(i18nkeys["IAM.PRIVACY.CERTIFICATIONS.ISO9001.DESCRIPTION"]).show(); //NO I18N 
		$(".slider_header_cert_icon").addClass("iso9001_cert");
	}
	
//------ Certificates change the listing style start
	var parent_box = $(eve).parent();
	if(!parent_box.find(".certification_info").hasClass("certificates_info_listing")) {
		$(parent_box).addClass("certifications_list_boxes_listing");
		$(parent_box).find(".certification_info").addClass("certificates_info_listing");
		$(parent_box).find(".certificate_name").addClass("certificate_name_listing");
		var no_of_certificates = $(".certifications_list_boxes").children().length;
		
		for(var certificate_no = 0; certificate_no < no_of_certificates; certificate_no++) {
			var icon_box = $(".certifications_list_boxes").children(":eq("+certificate_no+")").children().first();
			var icon_class_list_length = $(icon_box).attr("class").split(/\s+/).length; //NO i18N
			var icon_class_list = $(icon_box).attr("class").split(/\s+/); //NO i18N 
			for(var i = 0; i < icon_class_list_length; i++) {
				$(icon_box).addClass(icon_class_list[i]+"_listing");
			}
		}
	}	
//------- Certificates change the listing style end
	showPopupWithPosition(eve);
}

function closeSliderPopup(ele){
	  
	// ---PRIVACY - CERTIFICATIONS SPECIFIC SLIDER CHANGES START
	$("#agreement_accept").prop("checked", false);
	disable_cert_buttons();
	if($(ele).siblings(".certifications_list_boxes")) {
		var parent_box = $(ele).parents(".right_slider").siblings(".certifications_list_boxes");
		$(parent_box).removeClass("certifications_list_boxes_listing");
		$(parent_box).find(".certification_info").removeClass("certificates_info_listing");
		$(parent_box).find(".certificate_name").removeClass("certificate_name_listing");
	}
	$(".certificate_description").hide();
	$(".certifications_list_boxes").find("div").removeClass(function (index, className) {
	    return (className.match(/\b\S+_listing+/g) || []).join(' ');
	});
	// ---PRIVACY - CERTIFICATIONS SPECIFIC SLIDER CHANGES END
	
	$(".entry_highlight").removeClass("entry_highlight");
	$(ele).closest(".box").removeClass("expand_box");
	$(".show_slider").removeClass("show_slider_with_scroll");
	$(ele).closest(".right_slider").removeClass("show_slider");
	var box=$(".box");
	$(".ztopbar").removeClass("header_addborder");   
	$(".hide_expand_button").delay(350).removeClass("hide_expand_button");  
	setTimeout(function(){
			$(box).css("top","unset");
			$(box).css("left","unset");
			$(box).css("right","unset");
			$(box).css("height","auto");
			$(box).css("width","auto");
			$(box).css("position","relative");
			$("body").scrollTop(bodyScroll);
	},10);
	$('body').css({
		overflow: "unset" //No I18N
	});
}