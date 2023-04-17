//$Id$  
var oldilan="";
var all_timezones=[];
var all_countries=[];
var contry_timzones=[];
function load_userdetails(Policies,userDetails)
{
	if(jQuery.isEmptyObject(all_timezones))
	{
		$('#localeTz option').each(function(){
			all_timezones.push({ "value" : this.value, "text" : this.textContent });
		});
	}
	if(jQuery.isEmptyObject(all_countries))
	{
		$('#localeCn option').each(function(){
			all_countries.push({ "value" : this.value, "text" : this.textContent });
		});
	}
	if(jQuery.isEmptyObject(contry_timzones))
	{
		$('#country_Tz option').each(function(){
			contry_timzones.push({ "value" : this.value, "text" : this.textContent });
		});
	}
	if(userDetails.photo_url!=undefined)
	  {
	    //$("#edit_delete_photo_profile").html('<div class="profile_options" id="edit_photo">'+edit+'</div><div class="profile_options" id="delete_photo" onclick="deletePhoto()" >'+deleted+'</div>');
		$("#dp_pic").attr("onerror", "this.onerror=null;this.src='"+imgurl+"/user_2.png';");//No i18N
		$("#dp_pic").attr("src",userDetails.photo_url);//No i18N
		$(".dp_pic_blur_bg").css("background-image","url("+userDetails.photo_url+")");
	  }
	  $("#profile_email").text(userDetails.primary_email);
	  
	  $("#profile_Fname_edit").val(decodeHTML(userDetails.first_name));
	  $("#profile_Lname_edit").val(decodeHTML(userDetails.last_name));
	  
	  var FullName=userDetails.first_name+" "+userDetails.last_name;
	  
	  $("#profile_name").text(decodeHTML(FullName));
	  $("#profile_name_edit").val(decodeHTML(FullName));
	  
	  
	  //$("#profile_email_edit").val(userDetails.profile_email);
	  $("#profile_nickname").val(decodeHTML(userDetails.display_name));
	  if(userDetails.gender==1)
	  {
	    $("#male_gender").prop('selected', true);
	  }
	  else if(userDetails.gender==0)
	  {
	    $("#female_gender").prop('selected', true);
	  }
	  else if(userDetails.gender==3)
	  {
	    $("#non_binary_gender").prop('selected', true);
	  }
	  else
	  {
	    $("#other_gender").prop('selected', true);
	  }
	  $("#gender_select").val(userDetails.gender);
	  $("#gdpr_us_state").hide();
	  $("#localeState").find('option').not(':first').remove();// remove previous countries state details exepct the default one i.e. select state
	  if(userDetails.country!="")
	  { 
		  $("#localeCn").val(userDetails.country.toLowerCase());
		  if($("#localeCn").val()==""	||	$("#localeCn").val()==null	||	$("#localeCn").val()==undefined)// user country is of a random value that is not present in the select
	      {
			  $("#localeCn").val($("#localeCn option:first").val())
	      }
		  if(profile_data.country.toUpperCase()=='US')
		  {
			  $("#gdpr_us_state").show();
			  $("#localeState").html(($("#localeState").html()+states_details.us));
			  if(userDetails.state!=""	&&	userDetails.state!=undefined)
			  {
				  $("#localeState").val(userDetails.state);
			  }
		  }
	  }
	  if(userDetails.language!="")
	  { 
		  $("#localeLn").val(userDetails.language);
	  }
	  if(userDetails.timezone!="")
	  {  
		  $("#localeTz").val(userDetails.timezone);
	  }
	  displayAllTimeZone();
	//  $("#gender_field").val(user.gendercode);
	
	  
	  /*
	  
	  getOptionsProfile();
	
	  showLocale();
	  
	  */
	  
	  
	//	  if(!isMobile)
	//	  {
	//	    $('#locale select').select2();
	//	  }
	//	  
	  
	  
	  
	  if(!isMobile)
	  {
	    $('#locale select').select2().on("select2:open", function() {
		       $(".select2-search__field").attr("placeholder", iam_search_text);//No I18N
		});
	    $('#locale select').on("select2:close", function (e) { 
			$(e.target).siblings(".select2").find(".select2-selection--single").focus();
		});
		$('#localeTz').on('select2:open', function (e) {
			$(".timeZone_show").remove();
			$("#select2-localeTz-results").parents(".select2-dropdown").find(".select2-search--dropdown").append("<div class='timeZone_show' >"+$("#displayall_timezone").html()+"</div>");
			$("#select2-localeTz-results").parents(".select2-dropdown").find(".select2-search--dropdown").css("display","flex"); //No I18N
			$("#select2-localeTz-results").parents(".select2-dropdown").find(".select2-search__field").css("width","auto");	//No I18N
	        $(".timeZone_show #timezone_toggle").attr("id","timezone_toggle_inside_select");
	        $(".timeZone_show label").attr("for","timezone_toggle_inside_select");
	        $('#timezone_show_type').is(':checked')?$('#timezone_toggle_inside_select').prop("checked", true):$('#timezone_toggle_inside_select').prop("checked", false);
		});
	//	    $("#localeTz").select2('destroy'); 			//create checkbox in select2 search container
	    $("#localeCn").select2('destroy');
	    $("#gender_select").select2('destroy');
	    
	    $("#gender_select").select2({
	    	minimumResultsForSearch: Infinity
	    });
	    
	    
	//		$("#localeTz").select2().on("select2:open", function() {//no i18n 
	//		       $(".select2-search__field").attr("placeholder", "Search...");
	//		       if(!$(".select2-search").siblings().hasClass("check_contain")){
	//		         $(".select2-search").append('<div class="checkbox_div check_contain"  id="showall_timediv"><input id="showall_time" type="checkbox" name="keepmesignin" class="realcheckbox"><span class="checkbox_style checkbox_scale check_on"></span><label class="checkbox_text removeFontHeight" for="showall_time">Display all time zones</label></div>');
	//		       }
	//		});
			$("#localeCn").select2({
			    width: '320px',//No I18N
			    templateResult: function(option){
			        var spltext;
			    	if (!option.id) { return option.text; }
			    	spltext=option.text.split("(");
			    	//var num_code = $(option.element).attr("data-num");
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
			$("#localeCn+.select2 .select2-selection").append("<span id='selectFlag' class='selectFlag'></span>");
			selectFlag($(document.locale.country).find("option:selected"));
	  }
	  
	  
	  
	  //initDefaultTimeZoneOptions();
	  $('#locale .select2-selection__arrow b').hide();
	  $("#locale .select2-selection__rendered").attr("title","");
	 
}


function check_state()
{
	if(document.locale.country.value.trim()=="us")
	{ 
		  $("#localeState").find('option').not(':first').remove();// remove previous countries state details exepct the default one i.e. select state
		  $("#gdpr_us_state").show();
		  $("#localeState").html(($("#localeState").html()+states_details.us));
		  if(profile_data.state!=""	&&	profile_data.state!=undefined)
		  {
			  $("#localeState").val(userDetails.state);
		  }
	}
	else
	{
		$("#gdpr_us_state").hide();
	}
}
//
//function format (option) {		//select2 result format changing function result with flag
//	
//    if (!option.id) { return option.text; }
//       var getPos = $(option.element).attr("position");
//       getPos=getPos.split(" ");
//    var ob = '<div class="pic" style="background-position-x:'+getPos[0]+';background-position-y:'+getPos[1]+';"></div><span class="cn">'+option.text+'</span>';
//    return ob;
//};

function editProfile()
{
	remove_error();	
	control_Enter("a"); //No I18N
	 $("#Full_Name").hide();
	 $("#First_Name").css("display","inline-block");
	 $("#Last_Name").css("display","inline-block");
	
	$("#savebtnid").slideDown(200);
	$(".textbox_div").removeClass("editmode");
	$(".field .select2-container .select2-selection--single").css("text-indent","5px");//No I18N
	
	
	$(".profile_mode").addClass("profile_editmode");
	$('.edit_display').css("display","inline-block");
	$('.field').addClass("mob_edit");
	isMobile ? $('#displayall_timezone').show() : $('#displayall_timezone').hide();
		
	if(!isMobile)
	{
		$('#locale .select2-selection__arrow b').show();
		
	}
	$(".profile_mode").attr("disabled",false);
    if(!profile_data.Policies.CHANGE_FULL_NAME)
    {
    	$("#profile_Fname_edit").attr("readonly",true);
    	$("#profile_Fname_edit").removeClass("profile_editmode");
    	$("#profile_Lname_edit").attr("readonly",true);
    	$("#profile_Lname_edit").removeClass("profile_editmode");
    }
//    if(!user.disabled_email)
//    {
//    	$("#profile_email_edit").attr("readonly",true);
//    	$("#profile_email_edit").removeClass("profile_editmode");
//    }
    $(".lable_editmode").slideDown(200);
    $("#save_cancel_btn").show();
    $("#editprofile").addClass("hide_btn");
    $("#editonmobile").addClass("hide_btn");
    if($("#profile_Fname_edit").attr("readonly")==undefined){
    	$("#profile_Fname_edit").focus();
    }
    else{
    	$("#profile_nickname").focus();    	
    }
	
    $("#saveprofile").addClass("pref_disable_btn");
	$("#saveprofile").removeClass("primary_btn_check");
	$("#saveprofile").attr("disabled", "disabled");
   
	$("#timezone_toggle").keypress(function(event){
    	if(event.keyCode==13){
    		$(this).prop("checked", !$(this).prop("checked"));
    	}
    });
    	$(".profileinfo_form").keydown(function(e) {   
    		if(e.keyCode == 27) {
    			undochanges();
    		}
    	});
    	$(".profileinfo_form .profile_editmode").on("change input",function(){
    		show_save();
    	});

    return false;
	
};

function show_save(){
	var doc = document.locale;
	var gen_val = profile_data.gender == undefined ? "" : profile_data.gender ;
	var con_val = profile_data.country == undefined ? "" : profile_data.country ;
	var lan_val = profile_data.language == undefined ? "" : profile_data.language ;
	var tim_val = profile_data.timezone == undefined ? "" : profile_data.timezone ;
	var state_val = profile_data.state == undefined ? "" : profile_data.state ;
	var show_var = false;
	if(doc.firstname.value != profile_data.first_name){
		show_var = true;
	}
	else if(doc.lastname.value != profile_data.last_name){
		show_var = true;
	}
	else if(doc.displayname.value != profile_data.display_name){
		show_var = true;
	}
	else if(doc.gender.value != gen_val){
		show_var = true;
	}
	else if(doc.country.value.toUpperCase() != con_val){
		show_var = true;
	}
	else if(doc.language.value != lan_val){
		show_var = true;
	}
	else if(doc.timezone.value != tim_val){
		show_var = true;
	}
	else if(doc.state.value != state_val)
	{
		show_var = true;
	}
	else{
		show_var = false;
	}
	
	if(show_var){
		$("#saveprofile").removeClass("pref_disable_btn");
		$("#saveprofile").addClass("primary_btn_check");
		$("#saveprofile").removeAttr("disabled");
	}
	else{
		$("#saveprofile").addClass("pref_disable_btn");
		$("#saveprofile").removeClass("primary_btn_check");
		$("#saveprofile").attr("disabled", "disabled");
	}
};


function undochanges()
{
	$("#savebtnid").slideUp(200,function(){
		$("#editprofile").removeClass("hide_btn");
		$("#editonmobile").removeClass("hide_btn");		
	});
	$(".textbox_div").addClass("editmode");
	$(".field .select2-container .select2-selection--single").css("text-indent","-7px");//No I18N
	
    $(".profile_mode").removeClass("profile_editmode");
    $('#displayall_timezone').hide();
    $(".gender_view").removeClass("gender_edit");
    
//	if(gendercode==0)
//	{
//		$('#maleid').addClass("hide");
//	}
//	else if(gendercode==1)
//	{
//		$('#femaleid').addClass("hide");
//	}
    
    $('.field').removeClass("mob_edit");
    if(!isMobile)
	{
    	$('#locale .select2-selection__arrow b').hide();
	}
    $(".profile_mode").attr("disabled",true);
    $('.edit_display').hide();
     $(".lable_editmode").slideUp(200);
     $("#save_cancel_btn").hide();
     
     $("#Full_Name").show();
	 $("#First_Name").hide();
	 $("#Last_Name").hide();
	 
	 $("a").unbind();
	 $(".profileinfo_form .profile_editmode").unbind();
     load_userdetails(profile_data.Policies,profile_data);
     return false;
}

//function select_gender(gen)
//{
//	$(".gender_view").removeClass("highlight");
//	if($(".profile_mode").hasClass("profile_editmode"))
//		{
//			$(gen).addClass("highlight");
//		}
//}

function saveProfile(f)
{    
     oldilan=isEmpty(oldilan.trim())?(profile_data.language!=undefined)?profile_data.language:"":oldilan;
     if(validateForm(f))
 	 {
    	disabledButton(f);
    	//var parms=getparams(f);
    	
		var parms=
					{
						"first_name":$('#'+f.id).find('input[name="firstname"]').val(),//No I18N
						"last_name":$('#'+f.id).find('input[name="lastname"]').val(),//No I18N
						"display_name":$('#'+f.id).find('input[name="displayname"]').val(),//No I18N
						"gender":$('#'+f.id).find('select[name="gender"]').val(),//No I18N
						"country":$('#'+f.id).find('select[name="country"]').val(),//No I18N
						"language":$('#'+f.id).find('select[name="language"]').val(),//No I18N
						"timezone":$('#'+f.id).find('select[name="timezone"]').val()//No I18N
					};
		if($('#'+f.id).find('select[name="country"]').val().toUpperCase()=="US"	&&	$('#'+f.id).find('select[name="state"]').val()!=null)
		{ 
			parms.state=$('#'+f.id).find('select[name="state"]').val()//No I18N
		}
	
		
		var payload = User.create(parms);
    	payload.PUT("self","self").then(function(resp)	//No I18N
		{
    		SuccessMsg(getErrorMessage(resp));
    		doneEditing();
    		removeButtonDisable(f);
    	},
    	function(resp)
    	{
    		showErrorMessage(getErrorMessage(resp));
    		removeButtonDisable(f);
    	});
    	
		//new URI(User,"self","self").include(EMAIL).include(PHONE).PUT(); //No I18N
		
		//phone.AddFromBackup(parms,callback,phnum);
 	 }
     
  return false;   
}
function doneEditing()
{
		
		 var temp_fname=$("#profile_Fname_edit").val();
		 var temp_lname=$("#profile_Lname_edit").val();
		 var temp_dname=$("#profile_nickname").val();
		 var supported_lang = iam_supported_language.split(',');
	     var templang=document.locale.language.value.trim();
	     var tempitzone=document.locale.timezone.value.trim();
	     var tempicountry=document.locale.country.value.trim();
	     var tempState="";
	     if(tempicountry=="us")
	     {
	    	 tempState=document.locale.state.value.trim();
	     }
		 
		 profile_data.first_name = temp_fname;
		 profile_data.last_name = temp_lname;
		 profile_data.display_name = temp_dname;
		 profile_data.gender=$('#locale').find('select[name="gender"]').val();
		  for(var i=0; i<supported_lang.length; i++) //check if the language changed is supported
		  {
		  	if(supported_lang[i] == templang && oldilan!=templang) 
		  	{
		  		window.location.reload();
		        return false;
		  	}
		  }
		  profile_data.language=templang;
		  profile_data.timezone=tempitzone;
		  profile_data.country=tempicountry;
		  profile_data.state=tempState;
		  load_profile();
	
    $(".profile_mode").removeClass("profile_editmode");
    $('#displayall_timezone').hide();
    $(".gender_view").removeClass("gender_edit");
    $('.field').removeClass("mob_edit");
    if(!isMobile)
	{
    	$('.select2-selection__arrow b').hide();
	}
    $(".profile_mode").attr("disabled",true);

	 
	  
    var Fullname= $("#profile_Fname_edit").val()+" "+$("#profile_Lname_edit").val();
    $("#profile_name").text(Fullname);
    $("#profile_name_edit").val(Fullname);
    $("#Full_Name").show();
    $("#First_Name").hide();
    $("#Last_Name").hide();
    $('.edit_display').hide();

    
    $("#savebtnid").slideUp(200,function(){
        $("#editprofile").removeClass("hide_btn");
        $("#editonmobile").removeClass("hide_btn");
    });
	$(".textbox_div").addClass("editmode");
	$(".field .select2-container .select2-selection--single").css("text-indent","-7px");//No I18N
	
	 return false;
}



function getLocaleTz(t) 
{
	var tzSelectedVal=de('localeTz').value;//No I18N
    for(var iter=0;iter<contry_timzones.length;iter++)
	{
    	var country_code=contry_timzones[iter].value;
		var timezones=contry_timzones[iter].text;
		if(country_code.trim()==t.trim())
		{
			if(tzSelectedVal)
			{
				if(timezones.indexOf(tzSelectedVal) === -1){
					if((profile_data.timezone == tzSelectedVal)||(timezones.indexOf(profile_data.timezone) != -1)){
						timezones=tzSelectedVal+","+timezones;
					}
					else{
						timezones=tzSelectedVal+","+timezones+","+profile_data.timezone;
					}
				}
			}
			var timezone_list=timezones.split(",");
			getTimeZoneFromList(timezone_list);
		}
	}
	resetTimeZoneOptions();
	$("#displayall_timezone").attr("checked",false);
}

function getTimeZoneFromList(timezones)
{
    de('locale').className = "";		
    var tz = de('localeTz');//No I18N
    tz.options.length = 0;
    if(isEmpty(profile_data.timezone.trim())) 
    {
        tz.appendChild(new Option());
    }
    var option;
    for ( var timeZ in timezones) 
    {
    	option = document.createElement("option");	
    	 for(var iter=0;iter<all_timezones.length;iter++)
    		{
    		 	if(all_timezones[iter].value.trim()==timezones[timeZ].trim())
    		 	{
    		    	option.innerHTML=all_timezones[iter].text;
    		    	option.value = all_timezones[iter].value;
    		 	}
    		}
    	if(!(isEmpty(option.value) && isEmpty(option.innerHTML)))
    	{
    		 tz.appendChild(option);
    	}
    }
    if(profile_data.timezone!="")
	{  
    	$("#localeTz").val(profile_data.timezone);
	}
}

function resetTimeZoneOptions() 
{
	if(!isMobile)
	{
		if(de('select2-localeTz-container')) 
		{
			$("#localeTz").select2('destroy'); 
			$('#localeTz').select2();
			$('#localeTz').on('select2:open', function (e) {
				$(".timeZone_show").remove();
				$("#select2-localeTz-results").parents(".select2-dropdown").find(".select2-search--dropdown").append("<div class='timeZone_show' >"+$("#displayall_timezone").html()+"</div>");
				$("#select2-localeTz-results").parents(".select2-dropdown").find(".select2-search--dropdown").css("display","flex");	//No I18N
				$("#select2-localeTz-results").parents(".select2-dropdown").find(".select2-search__field").css("width","auto");			//No I18N
				$(".timeZone_show #timezone_toggle").attr("id","timezone_toggle_inside_select");
		        $(".timeZone_show label").attr("for","timezone_toggle_inside_select");
		        $('#timezone_show_type').is(':checked')?$('#timezone_toggle_inside_select').prop("checked", true):$('#timezone_toggle_inside_select').prop("checked", false);
			});
			$(".field .select2-container .select2-selection--single").css("text-indent","5px"); //No I18N
		}
	}
}

function showZoneAfterCheck(){
	if($('#timezone_toggle_inside_select').is(':checked') || $('#timezone_toggle').is(':checked')){
		$('#timezone_show_type').prop("checked", true);
	}
	else{
		$('#timezone_show_type').prop("checked", false);
	}
	var searchVal=$(".select2-container .select2-search__field").val();
	displayAllTimeZone();
	$('#localeTz').select2('open');
    $(".select2-container .select2-search__field").val(searchVal);
    $('.select2-container .select2-search__field').trigger($.Event('keyup'));
}

function displayAllTimeZone() 
{
	if($('#timezone_show_type').is(':checked')) // display
	{
		showTimeZoneList();
		resetTimeZoneOptions();
	}
	else
	{
		getLocaleTz($("#localeCn").val());	
	}
}

function showTimeZoneList()
{
    var tz = de('localeTz');//No I18N
    tz.options.length = 0;
    if(isEmpty(profile_data.timezone.trim())) {
        tz.appendChild(new Option());
    }
    var option;
    
    for(iter=0;iter<all_timezones.length;iter++)
	{
    	option = document.createElement("option");
    	option.innerHTML=all_timezones[iter].text;
    	option.value = all_timezones[iter].value;
    	if(all_timezones[iter].value.toLowerCase() == profile_data.timezone.toString().toLowerCase()){
		    option.selected = true;
		}
    	tz.appendChild(option);
	}
}

//function initDefaultTimeZoneOptions() {
//	if(de('localeCn')) {
//		getLocaleTz($("#localeCn").val());
//	}
//}