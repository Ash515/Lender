<%--$Id$--%>

<%@page import="com.adventnet.iam.security.SecurityUtil"%>
<%@page import="com.adventnet.iam.IAMUtil"%>
<%@page import="com.zoho.accounts.AccountsProto.Account.User.UserMobile"%>
<%@page import="com.zoho.accounts.internal.announcement.Announcement"%>
<%@page import="com.adventnet.iam.internal.PhoneUtil"%>
<%@page import="java.util.Locale"%>
<%@page import="com.zoho.accounts.phone.SMSUtil"%>
<%@page import="com.zoho.accounts.SystemResourceProto.ISDCode"%>
<%@page import="com.zoho.resource.Criteria"%>
<%@page import="com.adventnet.iam.OrgPolicy"%>
<%@page import="com.adventnet.iam.User"%>
<%@page import="com.adventnet.iam.internal.Util"%>
<%@page import="com.zoho.accounts.Accounts"%>
<%@page import="com.zoho.accounts.Accounts.RESOURCE.USERMOBILE"%>
<%@page import="com.zoho.accounts.AccountsProto.Account.User.UserMobile"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@page import="com.zoho.accounts.internal.util.AccountsInternalConst"%>
<%@page import="com.adventnet.iam.xss.IAMEncoder"%>
<%@page import="com.zoho.accounts.AccountsConfiguration"%>

<%@include file="../static/includes.jspf" %>
<%
boolean useStaticServer = AccountsConfiguration.USE_STATIC_SERVER.toBooleanValue();
String cssurl_style = isStatic ? Util.getCSSURL(request) : cPath+"/styles"; //No I18N
String cssurl_static = isStatic ? Util.getCSSURL(request) : cPath+"/static"; //No I18N
String jsurl_st = isStatic ? Util.getJSURL(request) : cPath+"/static"; //No I18N
%>

<html>
<head>
    <meta name="viewport"content="width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=no" />
    <link href="<%=cssurl_style%>/chosen.css" type="text/css" type="text/css" rel="stylesheet" /> <%-- NO OUTPUTENCODING --%>
    <link href="<%=cssurl_static%>/configureMobile.css" rel="stylesheet" type="text/css">
</head>
<body>

<%
User user = IAMUtil.getCurrentUser();
boolean isMobile = Util.isMobileUserAgent(request);
String userCountry = Util.getCountryCodeFromRequestUsingIP(request);
int dCode = SMSUtil.getISDCode(userCountry);
List<ISDCode> countryList = SMSUtil.getAllowedISDCodes();
%>


<div id="error_space">
    <div class="top_div">
    <span class="cross_mark">
    <span class="crossline1"></span>
    <span class="crossline2"></span>
    </span>
    <span class="top_msg"></span>
    </div>
</div>
    <div class="container">
    <img id="logo" src="<%=IAMEncoder.encodeHTMLAttribute(Util.getCurrentOrgLogoURL(request))%>">
    <div class="head_text"> <%=Util.getI18NMsg(request,"IAM.ADD.CONTACT.MOBILE")%></div><br>
    <div class="normal_text">
    <b><%=Util.getI18NMsg(request,"IAM.USER.HI",IAMEncoder.encodeHTMLAttribute(user.getFullName()))%></b>
    <div id="welcome_text"><%=Util.getI18NMsg(request,"IAM.ADD.CONTACT.MOBILE.TXT")%></div>   
    </div>
    <div class="form_field" id="prevNoSelect" Style="margin-top: 30px;">
    <span class="edit_icon" onclick=edit();></span>
	   <select id="mobile_no_select">
		    <% 
			UserMobile[] um = Accounts.getUserMobileURI(user.getZaid(), user.getZuid()).getQueryString().setCriteria(new Criteria(USERMOBILE.MODE,AccountsInternalConst.UserMobileMode.RECOVERY_NUMBER.getValue()).and(new Criteria(USERMOBILE.IS_VERIFIED,true))).build().GETS();
			if(um != null) {
				String arr[] = new String[um.length];
				for(int i=0;i<um.length;i++) {
					%>
					<option name="<%=um[i].getCountryCode()%>" value="<%=um[i].getMobile() %>"><%=um[i].getMobile() %> </option><%-- NO OUTPUTENCODING --%>
					<% 
			}
			}
		    %>
			<option value="new"><%=Util.getI18NMsg(request,"IAM.ADDNEW")+" "+Util.getI18NMsg(request,"IAM.USER.PHONE") %></option>
		</select>
		<label id="mob-label" style="top:-50px"><%=Util.getI18NMsg(request,"IAM.PHONE.NUMBER")%></label> 
	</div>
	
	<div class="form_field" id="get_mob_no" >
        <input class="text_box" id="mobileno" pattern="[0-9]*"  type="text" required="" autocomplete="off" maxlength="15" >
         <span class="edit_icon" onclick=edit();></span>
	   <select class="chosen-select" id="country_code_select">
		    <option></option>
		    <% 
		    for(ISDCode isdCode : countryList)
		    {
				String display=IAMEncoder.encodeHTMLAttribute(isdCode.getCountryName())   +"&nbsp;(+"+IAMEncoder.encodeHTMLAttribute(String.valueOf(isdCode.getDialingCode()))+") ";
			%>
			<option data-num="+<%=IAMEncoder.encodeHTMLAttribute(String.valueOf(isdCode.getDialingCode()))%>" value="<%=IAMEncoder.encodeHTMLAttribute(isdCode.getCountryCode()) %>"><%= display %> </option>
			<% 
			}%>
		</select> 
        <span id="mobileno_lab_bar"class="bar"></span>
        <label id="mobileno_lab"><%=Util.getI18NMsg(request,"IAM.ENTER.PHONENUMBER")%></label>        
	</div>
    <div class="form_field" id="get_ver_code">
        <input class="text_box"  id="verify_code" type="password" required="">
        <span class="bar"></span>
        <label><%=Util.getI18NMsg(request,"IAM.TFA.ENTER.VERIFICATION.CODE")%></label>
    </div>    
        
    <div class="medium_text blue" id="resend_code" onclick="resendCode();"><%=Util.getI18NMsg(request,"IAM.TFA.RESEND.CODE")%></div>
        
    <div class="normal_text" id="mob_no_added">
        <img class="tick" src="../../../images/round-tick.png">
   <%=Util.getI18NMsg(request,"IAM.MOBILE.ADDED.SUCCESSFULLY")%>
        <br>
    </div>
        
    <button class="btn" id="add_btn" onclick="step1()"><%=Util.getI18NMsg(request,"IAM.ADDNEW.MOBILE")%></button>
    <button class="btn" id="send_ver" onclick="updateMobile()"><%=Util.getI18NMsg(request,"IAM.SEND.VERIFY")%></button>
    <button class="btn" id="ver_id" onclick="verifyCode()"><%=Util.getI18NMsg(request,"IAM.VERIFY")%></button>    
    
   				<div class="note_message" id="show_phone_message">	
				</div>
    </div>
    <%if(!isMobile){ %>
		<div Style = "position : absolute;bottom : 0; height : 40px; margin-top : 40px; margin-left : 44%;">
		<div style="font-size:10px;text-align:center;padding:5px 0px;">&copy;&nbsp;<%=Util.getCopyRightYear()%>,&nbsp;<a href="<%=Util.getI18NMsg(request,"IAM.ZOHOCORP.LINK")%>" title="<%=Util.getI18NMsg(request,"IAM.ZOHOCORP")%>" target="_blank" style="font-size:11px;color:#085ddc;"><%=Util.getI18NMsg(request,"IAM.ZOHOCORP")%></a>&nbsp;<%=Util.getI18NMsg(request,"IAM.ADVENTNET.ALL.RIGHTS.RESERVED")%></div> <%--No I18N--%>
		</div>
	<%}else{%>
		<div id="mobilefooter" class="otheracc-topborder" style="margin-top: 30%; text-align: center;"><%=Util.getI18NMsg(request, "IAM.FOOTER.COPYRIGHT", Util.getCopyRightYear())%></div>
	<%} %>
</body>


<script src="<%=tpkgurl%>/jquery-3_5_1.min.js" type="text/javascript"></script><%-- NO OUTPUTENCODING --%>
<script src="<%=jsurl_st%>/common.js" type="text/javascript"></script> <%-- NO OUTPUTENCODING --%>
<script src="<%=jsurl_st%>/chosen.jquery.js" type="text/javascript"></script> <%-- NO OUTPUTENCODING --%>
<script>
var csrfParam = '<%=SecurityUtil.getCSRFParamName(request)+"="+SecurityUtil.getCSRFCookie(request)%>';<%-- NO OUTPUTENCODING --%>
var encrypted_phone_number;
$(function()
{
	$(".chosen-select").chosen();
	$('.chzn-single span').text("+<%=dCode %>");
	$("#country_code_select_chzn").css("display","none");	//No I18N
	if($("#mobileno").val()!="")
	{
			$("#mobileno_lab").css("top","-50px");	//No I18N
	}
	$('.chzn-search input').attr('tabindex',1);		//No I18N
	$('#get_mob_no_conf').bind("cut copy paste",function(e) {
	     e.preventDefault();
	 });
	 $('#get_mob_no').bind("cut copy paste",function(e) {
	     e.preventDefault();
	 });

    $("#mobileno").keyup(function(evt)
    	     {
    	         evt = (evt) ? evt : window.event; var charCode = (evt.which) ? evt.which : evt.keyCode;

    	         if($("#mobileno").val()=="")
    	         {
    	             $("#country_code_select_chzn").css("display","none");    //No I18N
    	         }   
    	         if(	((((	$('#mobileno').val().match(new RegExp("[0-9]","g")) || []).length) > 0)) && (((($('#mobileno').val().match(new RegExp("[a-zA-Z]","g")) || []).length) == 0)) && (((($('#mobileno').val().match(new RegExp("[^a-zA-Z0-9]","g")) || []).length) ==0 ))) //No I18N 
    	        {
    	             $("#country_code_select_chzn").css("display","inline-block");    //No I18N
    	        }
    	         else 
    	         {
    	             $("#country_code_select_chzn").css("display","none"); //No I18N
    	         }

    	    });
    step1();
    $("#mobileno").blur(function()
    		{
    			if($("#mobileno").val()!="")
    				{
    						$("#mobileno_lab").css("top","-50px");	//No I18N
    						$("#mobileno").css("color","#666");    	//No I18N
    				}
				else
					$("#mobileno_lab").css("top","-25px");		//No I18N
				mobileChange($("#mobileno").val());
    		});
    $("#mobileno").focus(function()
    		{
					$("#mobileno_lab").css("top","-50px");	//No I18N
					$("#mobileno").css("color","#666");    	//No I18N			
    		});
	
    $(document).on('change', '#mobile_no_select', mobileChange);
  
 	$(document).on('change', '#country_code_select', function() {
		
		$('.chzn-single span').text($( "#country_code_select option:selected" ).text().split('(')[1].slice(0,-3));
	});
		
		
	$('.chzn-results').click(function(){
		$('.chzn-single span').text($( "#country_code_select option:selected" ).text().split('(')[1].slice(0,-3));
		return false;
		});

	$(".chzn-container").bind('keyup',function(e) {
	    if(e.which === 13) {
	    	$('.chzn-single span').text($( "#country_code_select option:selected" ).text().split('(')[1].slice(0,-3));
	    	return false;
	    }
	});
	    	$('#passwd').focus();
	    	$("#mobileno").focus();
   	mobileChange('hide');//No I18N
});

	function mobileChange(temp) {
		if(temp && temp.type==undefined && temp!='hide'){
			if($("#mobile_no_select option[value='"+temp+"']").length > 0){
				$("#mobile_no_select").val($("#mobileno").val()).change();
				$("#mobile_no_select").attr("name", $("#mobileno").attr("name")).change();//NO I18N
				$("#mobileno").val('').change();
				$('#mobileno').trigger('keyup');//NO I18N
			}
		}else{
			if($('#mobile_no_select').val()=='new'){
				$('#get_mob_no').show();
				$('#mob-label').hide();
				document.getElementById("welcome_text").innerHTML="<br>"+'<%=Util.getI18NMsg(request, "IAM.ADD.CONTACT.MOBILE.TXT")%>';
				if(temp=='hide' && $("#mobile_no_select option").length == 1){
					$('#prevNoSelect').hide();
					$('#get_mob_no').css("margin-top","30px");//No I18N
				}
				de('send_ver').innerHTML="<%=Util.getI18NMsg(request,"IAM.SEND.VERIFY")%>";
				$('#mobileno').focus();
			}else{
				if($('#get_mob_no')){
					$('#get_mob_no').hide();
					$('#mob-label').show();
					<%-- de('send_ver').innerHTML="<%=Util.getI18NMsg(request,"IAM.TFA.VERIFY")%>"; //No I18N --%>	
				}
			}
		}
	}

        function lock_text()
        {
        	$("#mobileno").prop("disabled",true);//No I18N
        	$("#mobileno_lab").css("top","-50px");		//No I18N
        	$(".country_code").css("display","block");//No I18N
        	$("#get_mob_no .text_box").css("text-indent" ,"70px");//No I18N
        	$(".edit_icon").css("display","block");//No I18N
        	$("#countrycodeid").prop("disabled",true);//No I18N
        	$("#countrycodeid").css("color","grey");//No I18N
        	$("#mobileno").css("color","grey");//No I18N
        	$('#country_code_select').prop('disabled', true).trigger("liszt:updated");//NO I18N
        	if($("#mobile_no_select")){
        		$("#mobile_no_select").prop('disabled', 'disabled');//No I18N
        	}
        	if($( "#country_code_select option:selected" ).text())
        		{
        			$('.chzn-single span').text($( "#country_code_select option:selected" ).text().split('(')[1].slice(0,-3));
        		}
        	else
        		{
        			$('.chzn-single span').text("+"+<%=dCode%>);
        		}
        		$('.chzn-single span').css("color","grey");	//No I18N
        }

    var usedMobile='';
    function verifyCode(){
        var code = de("verify_code").value;//No I18N
        if(!isValidCode(code)){
            showErrMsg('<%=Util.getI18NMsg(request, "IAM.PHONE.INVALID.VERIFY.CODE")%>');
            return;
        }
        var _param = {code : code};
        
        _param = JSON.stringify({ "enforcedloginmobile" : _param }); //NO I18N        
        var xhr=$.ajax({
			"beforeSend": function(xhr) { //NO I18N
				xhr.setRequestHeader("X-ZCSRF-TOKEN", csrfParam);
			},
			data: _param,
			type: "PUT",// No I18N
			url: "/webclient/v1/announcement/pre/loginmobile/"+encrypted_phone_number, //NO I18N
			success: function(obj) {
				if(obj.status_code == 200) {
					step3();
					return false;
				} else {
					showErrMsg(obj.localized_message);
				}
			}
		});
    }
    
    function isValidCode(code){
        if(code.trim().length != 0){
            var codePattern = new RegExp("^([0-9]{5,7})$");
            if(codePattern.test(code)){
                return true;
            }
        }
        return false;
    }
    
    function updateMobile(){
    	$('#show_phone_message').hide();
    	var _param;
    	if($('#mobile_no_select') && $('#mobile_no_select').val()!='new'){//No I18N
    		usedMobile=$('#mobile_no_select').val();
    		
    		countrycode=$('#mobile_no_select').find('option:selected').attr("name");//No I18N
    		_param={mobile : usedMobile, countrycode : countrycode};
    	}else{
    		usedMobile = de("mobileno").value;//No I18N
            var countrycode =$( "#country_code_select" ).val();//No I18N
            if(countrycode=="")
        	{
        		countrycode= "<%=IAMEncoder.encodeJavaScript(userCountry)%>";  
        	}
            if(!isValidMobile(usedMobile)){
                showErrMsg('<%=Util.getI18NMsg(request, "IAM.PHONE.ENTER.VALID.MOBILE")%>')
                return;
            }
    		_param= { mobile : usedMobile, countrycode : countrycode};
    	}
    	    	
    	_param = JSON.stringify({ "enforcedloginmobile" : _param }); //NO I18N
		var xhr=$.ajax({
			"beforeSend": function(xhr) { //NO I18N
				xhr.setRequestHeader("X-ZCSRF-TOKEN", csrfParam);
			},
			type: "POST",// No I18N
			url: "/webclient/v1/announcement/pre/loginmobile", //NO I18N
			data: _param,
			success: function(obj) {
				if(obj.status_code == 201) {
					encrypted_phone_number = obj.enforcedloginmobile.encryptedMobile;
					step2();
				} else {
					showErrMsg(obj.localized_message);
				}
			}
		});
    }
    
    function resendCode(){
        if(usedMobile != ''){
        	var xhr=$.ajax({
    			"beforeSend": function(xhr) { //NO I18N
    				xhr.setRequestHeader("X-ZCSRF-TOKEN", csrfParam);
    			},
    			type: "PUT",// No I18N
    			url: "/webclient/v1/announcement/pre/loginmobile/"+encrypted_phone_number, //NO I18N
    			success: function(obj) {
    				if(obj.status_code == 200) {
    					showSuccessMsg(obj.localized_message);
    				} else {
    					showErrMsg(obj.localized_message);
    				}
    			}
    		});
        }else{
        	step1();
        	edit();
        	mobileChange('hide');//No I18N
        }
    }
    
    function step1()
    {
    	document.getElementById("get_mob_no").style.display="block";
        document.getElementById("add_btn").style.display="none";
        document.getElementById("send_ver").style.display="inline-block";
    }
    
    
    function step2()
    {
        document.getElementById("get_ver_code").style.display="block";
        document.getElementById("resend_code").style.display="block";   
        document.getElementById("send_ver").style.display="none";   
        document.getElementById("ver_id").style.display="inline-block"; 
        lock_text();
        document.getElementById("welcome_text").innerHTML="<br>"+'<%=Util.getI18NMsg(request, "IAM.MOBILE.OTP.SENT")%>';
        $("#verify_code").val("").focus();
        
    }
    function step3()
    {
        document.getElementById("mob_no_added").style.display="block";
        document.getElementById("resend_code").style.display="none";
        document.getElementById("get_ver_code").style.display="none";
        $('#prevNoSelect').hide();
        document.getElementById("ver_id").style.display="block";
        $('#welcome_text').remove();
        document.getElementById("ver_id").innerHTML="Continue";//No I18N
        document.getElementById("ver_id").onclick=function() {
            window.location.href = "<%= Util.getNextPreAnnouncementUrl("add-mobile-screenname-enforcement") %>";
        };
        $('#get_mob_no').remove();
    }
    
    function edit(){
         document.getElementById("get_ver_code").style.display="none";
         document.getElementById("resend_code").style.display="none";   
         document.getElementById("send_ver").style.display="block";
         document.getElementById("ver_id").style.display="none";
         $('.edit_icon').hide();
         $('#passwd').val('');//No I18N
         $('#down_arrowid').hide();//No I18N
         $("#mobileno").prop("disabled",false);//No I18N
         $("#countrycodeid").prop("disabled",false);//No I18N
         $("#mobileno_lab").removeAttr("style");	//No I18N
         $(".country_code").removeAttr("style");//No I18N
         $("#get_mob_no .text_box").removeAttr("style");//No I18N
         $('#country_code_select').prop('disabled', false).trigger("liszt:updated");//NO I18N
         if($( "#country_code_select option:selected" ).text())
 		{
 			$('.chzn-single span').text($( "#country_code_select option:selected" ).text().split('(')[1].slice(0,-3));//No I18N
 		}
 		else
 		{
 			$('.chzn-single span').text("+"+<%=dCode%>);
 		}
 		$('.chzn-single span').css("color","grey");	//No I18N
         $('.chzn-single span').css("color","black");	//No I18N
         $('#mobileno').focus();
         if(de('mobile_no_select') && de('mobile_no_select').options.length>1){
        	 $('#mobile_no_select').show();
        	 $("#mobile_no_select").removeAttr("disabled");//No I18N
        	 if($('#mobile_no_select').val()!='new'){
        		 $('#get_mob_no').hide();
        	 }
         }
    }
    
    function showErrMsg(msg)
    {
     $(".top_div").css({"border-right": "3px solid #ef4444", "color": "#ef4444"});  //No I18N
     $(".cross_mark").css("background-color","#ef4444");     //No I18N
     $(".crossline1").css({"top": "18px", "left": "0px", "width":"20px"});   //No I18N
     $(".crossline2").css("left","0px");  //No I18N
     $('.top_msg').html(msg); //No I18N
     $( ".top_div" ).fadeIn("slow");//No I18N
     setTimeout(function() {
      $( ".top_div" ).fadeOut("slow");//No I18N
     }, 3000);
    }

    function isValidMobile(mobile){
        if(mobile.trim().length != 0){
            var mobilePattern = new RegExp("^([0-9]{5,12})$");
            if(mobilePattern.test(mobile)){
                return true;
            }
        }
        return false;
    }
    
    function showSuccessMsg(msg)
    {
     $(".top_div").css({"border-right": "3px solid #50BF54", "color": "#50BF54"});  //No I18N
     $(".cross_mark").css("background-color","#50BF54");     //No I18N
     $(".crossline1").css({"top": "22px", "left": "-6px", "width":"12px"});    //No I18N
     $(".crossline2").css("left","4px");  //No I18N
     $('.top_msg').html(msg); //No I18N
     $( ".top_div" ).fadeIn("slow");//No I18N

     setTimeout(function() { $( ".top_div" ).fadeOut("slow"); }, 3000);
    }
    
</script>
</html>