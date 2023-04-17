<!DOCTYPE HTML>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<link href="${za.config.v2_iam_css_url}/announcement_style.css" type="text/css"  rel="stylesheet" />
<style>
@font-face {
		    font-family: 'Montserrat-regular';
		    font-style: normal;
		    font-weight: 400;
		    src:url('${za.config.v2_iam_img_url}/montserratregular/font.eot');
		    src:url('${za.config.v2_iam_img_url}/montserratregular/font.eot?#iefix') format('eot'),
		        url('${za.config.v2_iam_img_url}/montserratregular/font.woff2') format('woff2'),
		        url('${za.config.v2_iam_img_url}/montserratregular/font.woff') format('woff'),
		        url('${za.config.v2_iam_img_url}/montserratregular/font.ttf') format('truetype'),
		        url('${za.config.v2_iam_img_url}/montserratregular/font.svg#Montserrat-Regular') format('svg');
		}
		
		@font-face {
		    font-family: 'Montserrat-semibold';
		    font-style: medium;
		    font-weight: 500;
		    src:url('${za.config.v2_iam_img_url}/montserratsemibold/font.eot');
		    src:url('${za.config.v2_iam_img_url}/montserratsemibold/font.eot?#iefix') format('eot'),
		        url('${za.config.v2_iam_img_url}/montserratsemibold/font.woff2') format('woff2'),
		        url('${za.config.v2_iam_img_url}/montserratsemibold/font.woff') format('woff'),
		        url('${za.config.v2_iam_img_url}/montserratsemibold/font.ttf') format('truetype'),
		        url('${za.config.v2_iam_img_url}/montserratsemibold/font.svg#Montserrat-Regular') format('svg');
		}
body,table, button {
	font-family: "Montserrat-regular";
	font-size: 13px;
	padding:0px;
	margin:0px;
}

 .cancel_btn_link {
	text-decoration: none !important;
	color: black !important;
}

.blur_screen {
	width: 100%;
    height: 100%;
    background: black;
    position: absolute;
    z-index: 10;
    opacity: 0.3;
    display: none;
    top: 0px;
}

.succ_msg {
    display: block;
	font-weight: 100;
	font-size: 16px;
}

.warn_msg {
	color: red;
	margin-top: 20px;
	visibility: hidden;
}
</style>

<script src="${za.config.iam_js_url_static}/jquery-1.12.2.min.js" type="text/javascript"></script>
<script src="${za.config.iam_js_url_static}/common.js" type="text/javascript"></script>
<script src="${za.config.iam_js_url_static}/chosen.jquery.js" type="text/javascript"></script>
<link href="${za.config.iam_css_url}/chosen.css" type="text/css"  rel="stylesheet" />
<script src="${za.config.v2_iam_tpkg_url}/select2.full.min.js"></script>
<script>
var csrfParam = '${za.config.csrfParam}='+getIAMCookie('${za.config.csrfCookie}');
var contextpath = '${za.iam_contextpath}';
var current_country_code, selected_timezone, current_country_name, current_timezone, user_country_val, countryStateList = [], is_state_needed = false, is_timezone_update_needed = false;
var current_country_html, current_timezone_html;

var Country_list = ${announcement.CountryList};	
var Country_codes = ${announcement.country_Codes};
var timezone_list = ${announcement.timezone_List};	
is_timezone_update_needed = timezone_list && timezone_list.length > 0;

		
var i18nkeys = {
	"IAM.ANNOUNCEMENT.LOCALE.SELECT.COUNTRY" : '<@i18n key="IAM.ANNOUNCEMENT.LOCALE.SELECT.COUNTRY" />',
	"IAM.ANNOUNCEMENT.LOCALE.SELECT.STATE" : '<@i18n key="IAM.ANNOUNCEMENT.LOCALE.SELECT.STATE" />',
	"IAM.ANNOUNCEMENT.LOCALE.SELECT.TIMEZONE" : '<@i18n key="IAM.ANNOUNCEMENT.LOCALE.SELECT.TIMEZONE" />',
	"IAM.US.STATE.SELECT" : '<@i18n key="IAM.US.STATE.SELECT" />',
	"IAM.TFA.SELECT.COUNTRY" : '<@i18n key="IAM.TFA.SELECT.COUNTRY" />',
	"IAM.ANNOUNCEMENT.TIMEZONE.SELECT" : '<@i18n key="IAM.ANNOUNCEMENT.TIMEZONE.SELECT" />',
	"IAM.ERROR.GENERAL" : '<@i18n key="IAM.ERROR.GENERAL" />',
	"IAM.ERROR.UPDATE.SUCCESS.MESSAGE" : '<@i18n key="IAM.ERROR.UPDATE.SUCCESS.MESSAGE" />'
};
		

function redirect(){
	window.location.href="${announcement.visited_url}";
}

function remind_later() {
	window.location.href="${announcement.remind_me_later_url}";
}

function close_popup() {
		$("#result_popup_failure, .blur_screen").slideUp(150);
}

function toggleCountryStates(selectCountryElement) {
	var select = $('#state_dropdown select[name=country_state]');
	var is_state_present = false;
	if(select.length > 0 && ZACountryStateDetails && ZACountryStateDetails.length > 0) {
		var countryOptionEle = selectCountryElement.options[selectCountryElement.selectedIndex];//.selectedOptions[0];
		var countryCode = countryOptionEle.value;
		var countryStates = ZACountryStateDetails[0];
		var stateOptios = countryStates[countryCode.toLowerCase()];
		if(stateOptios != undefined) {
			select[0].innerHTML = stateOptios;			
			for (i = 0; i < document.getElementById("state_dropdown_list").length; ++i) {
			    if (document.getElementById("state_dropdown_list").options[i].value.toLowerCase() == current_state_name.toLowerCase()){
			      is_state_present = true;
			      $('#state_dropdown_list option:eq('+i+')').prop('selected', true);
			    }
			}
			is_state_needed = true;
			$('#state_dropdown').css('display',''); //No I18N
		} else {
			select[0].innerHTML = "";
			is_state_needed = false;
			$('#state_dropdown').css('display','none'); //No I18N
		}
	}
}

function populate_states() {
     var countryStates = ${announcement.states};
     if(countryStates != null && countryStates != '') {
	     var stateJson = {};
     	 var stateCountries_len = Object.keys(countryStates).length;
     	 for(country_no = 0; country_no < stateCountries_len; country_no++) {
     	 	var stateCountry = Object.keys(countryStates)[country_no];
     	 	var states = countryStates[stateCountry];
     	 	var stateOptions = '';
     	 	for(state_no = 0; state_no < states.length; state_no++) {
     	 		stateOptions += "<option value=\"" + states[state_no] + "\">" + states[state_no] + "</option>";
     	 	}
			stateJson[stateCountry] = stateOptions.toString();
			countryStateList.push(stateCountry);
     	 }
     	 var countryStateDetails = [];
     	 countryStateDetails.push(stateJson);
     	 window.ZACountryStateDetails = countryStateDetails;
     }  
}

$(document).ready(function() {
		populate_states();
		$("#container").css("display", "block");
		 current_country_name = "${announcement.current_countryName}";
		 current_country_code = "${announcement.current_countryCode}";
		 current_timezone = "${announcement.current_timezone}";
		 current_state_name = "${announcement.current_stateName}";
		 user_state_val = "${announcement.user_statename}";
		 user_country_code = "${announcement.user_country_code}";
		 if(user_state_val != '' && countryStateList.includes(user_country_code.toLowerCase())) {
			 $(".current_country_box").append("<span class='current_locale_value'> (" + user_state_val + ") </span>");
		 }
		$("#country_dropdown_list").select2({
			   width: "320px", //No I18N
			   placeholder: i18nkeys["IAM.TFA.SELECT.COUNTRY"] //NO I18N
		 }).on("select2:open", function() {
		       $(".select2-dropdown").css("margin-left", "-2px");//No I18N
		 }).on("change.select2", function(event) {
				   var value = $(event.currentTarget).find("option:selected").text();
				   current_country_code = $(event.currentTarget).find("option:selected").val();
				   toggleCountryStates(this);
				   $(".warn_msg").css("visibility", "hidden");
		  });
		 
		 $("#state_dropdown_list").select2({
			   width: "320px", //No I18N
			   placeholder: i18nkeys["IAM.US.STATE.SELECT"] //NO I18N
		 }).on("select2:open", function() {
		       $(".select2-dropdown").css("margin-left", "-2px");//No I18N  
		       $(".warn_msg").css("visibility", "hidden");  
		 });
		 
		 if(is_timezone_update_needed) {
		 	$("#timezone_dropdown_list").select2({
                width: "420px", //No I18N
                placeholder: i18nkeys["IAM.ANNOUNCEMENT.TIMEZONE.SELECT"] //NO I18N
		    }).on("select2:open", function() {
		        $(".select2-dropdown").css("margin-left", "-2px");//No I18N 
		        $(".select2-selection__rendered").css("max-width", "380px");   //NO I18N  
		    });
		 }
	      
	    content_for_form_container();
		$("#cancel_btn").click(function() {
			$("#locale_dropdown_container").css("display", "none");
			$("#user_details_container").css("display", "block");
			content_for_form_container();
		});		
});

function content_for_form_container() {
	   var country_list_len = Country_list.length;
	   var country_dropdown_length = $("#country_dropdown_list").children().length;
	   for(var country_no = 0; country_no < country_list_len; country_no++) {
		   var countryName = Country_list[country_no];
		   var country_Code = Country_codes[country_no];
		   if(country_dropdown_length == 0) {
		       if(countryName.toLowerCase() !== current_country_name.toLowerCase()) {
				   $("#country_dropdown_list").append("<option value="+country_Code+">"+countryName+"</option>");
			   } else {
				   $("#country_dropdown_list").append("<option selected='selected' value="+country_Code+">"+countryName+"</option>");
			   }
		   } else {
		  	   if(countryName.toLowerCase() == current_country_name.toLowerCase()) {
		  	   	   $('#country_dropdown_list option:eq('+country_no+')').prop('selected', true).trigger( "change" );
			   }
		   }
	   }
	   
	   if(is_timezone_update_needed)
	   {
		   var timezone_list_len = timezone_list.length;
		   var timezone_dropdown_length = $("#timezone_dropdown_list").children().length;
	       for(var timezone_no = 0; timezone_no < timezone_list_len; timezone_no++) {
	              var  timezone_val = timezone_list[timezone_no];
	              var timezone_val_id = timezone_val.split(" ");
	              timezone_val_id = timezone_val_id[(timezone_val_id.length)-1];
	              var regExp = /\(([^)]+)\)/;
	              var matches = regExp.exec(timezone_val_id);
	              timezone_val_id = matches[1];
	              if(timezone_dropdown_length == 0) {
	               	if(timezone_val_id.toLowerCase() !== current_timezone.toLowerCase()) {
		                 $("#timezone_dropdown_list").append("<option>"+timezone_val+"</option>");
			          } else {
			                 $("#timezone_dropdown_list").append("<option selected='selected'>"+timezone_val+"</option>");
			          }
	              } else {
	              	 if(timezone_val_id.toLowerCase() == current_timezone.toLowerCase()) {
		                 $('#timezone_dropdown_list option:eq('+timezone_no+')').prop('selected', true).trigger( "change" );
			          }
	              }
	     	}
	     	$("#timezone_dropdown").css("display", "block");
	     	 if(current_timezone == "") {
			   	  $('#timezone_dropdown_list option:eq(0)').prop('selected', true).trigger('change');
			 }
     	}
       
       if(current_country_name == "") {
	   	  $('#country_dropdown_list option:eq(0)').prop('selected', true).trigger('change');
	   }
}


function edit_details() {
	$("#user_details_container").css("display", "none");
	select = $('#country_dropdown select[name=country]')[0];
	if(current_country_name)
	toggleCountryStates(select);
	$("#locale_dropdown_container").css("display", "block");
}

function update_profile() {	
	var new_country = $("#select2-country_dropdown_list-container").attr("title");	
	if(new_country != undefined) {
		var update_profile_data = {
				"country" : current_country_code.toLowerCase(), //NO I18N
		}
		if(is_timezone_update_needed) {
			var new_timezone = $("#select2-timezone_dropdown_list-container").attr("title");
			if(new_timezone != undefined) {
				new_timezone = new_timezone.split(" ");
				new_timezone = new_timezone[(new_timezone.length)-1];
				var regExp = /\(([^)]+)\)/;
				var matches = regExp.exec(new_timezone);
				new_timezone = matches[1];
				$.extend(update_profile_data, { "timezone" : new_timezone }); //NO I18N
			} else {
				update_profile_data = null;
				$(".warn_msg").text(i18nkeys["IAM.ANNOUNCEMENT.LOCALE.SELECT.TIMEZONE"]);
			}
		} 
		if(is_state_needed) {
			var new_state = $("#select2-state_dropdown_list-container").attr("title");
			if(new_state != undefined) {
				$.extend(update_profile_data, { "state" : new_state }); //NO I18N
			} else {
				update_profile_data = null;
				$(".warn_msg").text(i18nkeys["IAM.ANNOUNCEMENT.LOCALE.SELECT.STATE"]);
			}
		}	
	} else {
		update_profile_data = null;
		$(".warn_msg").text(i18nkeys["IAM.ANNOUNCEMENT.LOCALE.SELECT.COUNTRY"]);
	}
	if(update_profile_data == undefined || update_profile_data == null) {
		$(".warn_msg").css("visibility", "visible");
	} else {
		params = JSON.stringify({"user" : update_profile_data}); //NO I18N
		var xhr=$.ajax({
			"beforeSend": function(xhr) { //NO I18N
				xhr.setRequestHeader("X-ZCSRF-TOKEN", csrfParam);
			},
			type: "PUT",// No I18N
			url: contextpath + "/webclient/v1/account/self/user/self", //NO I18N
			data: params,// No I18N
			dataType : "json", // No I18N
			success: function(obj) {
			if(obj.status_code == 200) {
				$("#result_popup_success, .blur_screen").slideDown(150);
			} else {
				$("#result_popup_failure, .blur_screen").slideDown(150);
			}
			}
		});
	}
}
</script>
</head>
<body>
<div class="container" id="container">
<div class="blur_screen"></div>
</div></div>


		<div class="blur hide"></div>
		<div class="result_popup hide" id="result_popup_success">
			<div class="success_pop_bg"></div>
			<div class="success_icon"></div>
			<div class="grn_text" id="result_content"><@i18n key="IAM.ANNOUNCEMENT.LOCALE.SUCCESS.MESSAGE.HEADER"/></div>
			<div class="defin_text"><@i18n key="IAM.ANNOUNCEMENT.LOCALE.SUCCESS.MESSAGE.TEXT"/></div>
			<button class="button center_btn" id="continue" onclick="redirect();"><@i18n key="IAM.CONTINUE"/></button>
		</div>

		<div class="result_popup hide" id="result_popup_failure">
			<div class="reject_pop_bg"></div>
			<div class="reject_icon"></div>
			<div class="grn_text" id="result_content"><@i18n key="IAM.ANNOUNCEMENT.LOCALE.FAILURE.MESSAGE.HEADER"/></div>
			<div class="defin_text"><@i18n key="IAM.ANNOUNCEMENT.LOCALE.FAILURE.MESSAGE.TEXT"/></div>
			<button class="button center_btn" id="close_popup" onclick="close_popup();"><@i18n key="IAM.TRY.AGAIN"/></button>
		</div>

			<div class="announcement_content">			
				<div class="zoho_logo"></div>
				<div class="announcement_heading"> <@i18n key="IAM.ANNOUNCEMENT.LOCALE.TITLE" /> </div>
			    <div class="announcement_description"> <@i18n key="IAM.ANNOUNCEMENT.LOCALE.DESCRIPTION" /></div>
				
				
				<div id="user_details_container">
				<div class="user_locale_container">
					<div class="current_country_box">
						<span class="current_locale_icon location_icon"></span>
						<span class="current_locale_value">${announcement.user_country_name}</span>
					</div>
					<div class="current_timezone_box">
						<span class="current_locale_icon timezone_icon"></span>
						<span class="current_locale_value timezone_value">${announcement.user_timezone_val}</span>
					</div>
				</div>
				<button class="update_profile" onclick="window.location.href='${announcement.remind_me_later_url}'"><@i18n key="IAM.CONFIRM" /></a></button>
				<button class="cancel_btn" id="edit_details" onclick="edit_details();"><@i18n key="IAM.PHOTO.CHANGE" /></button>
				</div>
				
				<div id="locale_dropdown_container" class="container">
				
				<div class="list_dropdown_box" id="country_dropdown">
					<div class="selected_option_info">			
						<label class="dropdown_label"><@i18n key="IAM.COUNTRY" /></label>
					</div>
					<select class="profile_mode select2-hidden-accessible" name="country" id="country_dropdown_list"></select>
				</div>
				
				<div class="list_dropdown_box" id="state_dropdown" style="display: none;">
					<div class="selected_option_info">
						<label class="dropdown_label"><@i18n key="IAM.ANNOUNCEMENT.LOCALE.STATE.TITLE" /></label>
					</div>
					<select class="profile_mode select2-hidden-accessible" name="country_state" id="state_dropdown_list"></select>
				</div>
				
				<div class="list_dropdown_box" id="timezone_dropdown" style="max-width: 416px; display: none;" >
                       <div class="selected_option_info">
                               <label class="dropdown_label"><@i18n key="IAM.ANNOUNCEMENT.LOCALE.TIMEZONE.TITLE" /></label>
                       </div>
                       <select class="profile_mode select2-hidden-accessible long_div" id="timezone_dropdown_list">
                       </select>
               </div>
			
			    <div class="warn_msg"><@i18n key="IAM.ANNOUNCEMENT.LOCALE.SELECT.COUNTRY" /></div>
			
				<button class="update_profile" id="update_profile" onclick="update_profile();"><@i18n key="IAM.UPDATE" /></button>
				<button class="cancel_btn" id="cancel_btn"><@i18n key="IAM.CANCEL" /></button>
				</div>
				
			</div>
			<div class="announcement_img">
			</div>
		</div>	
</body>
</html>