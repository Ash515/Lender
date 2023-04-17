<%--$Id$--%>

<%@page import="com.zoho.iam2.rest.ProtoToZliteUtil"%>
<%@page import="com.zoho.accounts.AccountsProto.Account.User.UserMobile"%>
<%@page import="com.zoho.accounts.internal.announcement.Announcement"%>
<%@page import="com.adventnet.iam.internal.PhoneUtil"%>
<%@page import="java.util.Locale"%>
<%@page import="com.zoho.accounts.phone.SMSUtil"%>
<%@page import="com.zoho.accounts.SystemResourceProto.ISDCode"%>
<%@include file="../../static/includes.jspf" %>
<html>
<head>
	<title><%=Util.getI18NMsg(request,"IAM.ZOHO.ACCOUNTS")%></title>
    <meta name="viewport"content="width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=no" />
    <link href="<%=cssurl%>/chosen.css" type="text/css" type="text/css" rel="stylesheet" /> <%-- NO OUTPUTENCODING --%>
    <link href="<%=cssurl_st%>/configureMobile.css" rel="stylesheet" type="text/css">
    <style type="text/css">
    .text_box:valid {
    	color: black;
	}
	.text_box:invalid {
	    color: grey;
	}
    </style>
    <script type="text/javascript">
	<%
	String servicename = request.getParameter("servicename") != null ? request.getParameter("servicename") : "";
	User user = IAMUtil.getCurrentUser();
	String backToURL = Util.getBackToURL(servicename, request.getParameter("serviceurl"));
	String redirectUrl = Util.getTrustedURL(user.getZUID(), backToURL);
	boolean isMobile = Util.isMobileUserAgent(request);
	
	boolean isRecovery=false;
	boolean isLoginMobile=false;
	boolean isEmail=false;
	boolean redirect=true;
	String email=null;
	String uri = request.getRequestURI();
	
	if(uri.equals(cPath + "/ui/configure/mobile/login")){//No I18N
		isLoginMobile=true;
		redirect=user.hasVerifiedMobileScreenName();
		%>
		var sendurl='/setup/screenmobile/otp/'; //No I18N
		<%
	}else if(uri.equals(cPath + "/ui/configure/mobile/recovery")){//No I18N
		UserMobile[] temp=PhoneUtil.getUserVerifiedNumbers(user);
		redirect=temp!=null && temp.length>0;
		isRecovery=true;
		%>
		var sendurl='/setup/recoverymobile/otp/';//No I18N
		<%
	}else if(uri.equals(cPath + "/ui/configure/email")){//No I18N
		isEmail=true;
		redirect=user.hasVerifiedEmail();
		email=request.getParameter("email_id")!=null?request.getParameter("email_id"):user.getPrimaryEmail();
		email= IAMUtil.isValidEmailId(email)?email:"";
		%>
		var sendurl='/setup/email/otp/';//No I18N
		<% 
	}
	if(redirect){
		response.sendRedirect(redirectUrl);
	    return;
	}
	%>
	</script>
	<%if(isEmail){ %>
	 <script src="<%=jsurl%>/xregexp-all.js" type="text/javascript"></script><%-- NO OUTPUTENCODING --%>
	<%} %>
</head>
<body>
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
    <div class="head_text"> <%=Util.getI18NMsg(request,(isEmail)?"IAM.ADD.CONTACT.EMAIL":"IAM.ADD.CONTACT.MOBILE")%></div><br>
    <div class="normal_text">
    <b><%=Util.getI18NMsg(request,"IAM.USER.HI",IAMEncoder.encodeHTMLAttribute(user.getFullName()))%></b>
    <div id="welcome_text"><%=Util.getI18NMsg(request,(isEmail)?"IAM.ADD.CONTACT.EMAIL.TXT":"IAM.ADD.CONTACT.MOBILE.TXT")%></div>   
    </div>
	
	<div class="form_field" id="get_mob_no" >
	   <%if(isLoginMobile || isRecovery){%>
	   <input class="text_box" id="mobileno" pattern="[0-9]{5,14}"  type="text" style="text-indent:71px;" required="" autocomplete="off" maxlength="15" placeholder="<%=Util.getI18NMsg(request,"IAM.ENTER.PHONENUMBER")%>">
       <span class="edit_icon" onclick=edit();></span>
	   <select class="chosen-select" id="country_code_select">
		    <%
		    String userCountry = Util.getCountryCodeFromRequestUsingIP(request);
		    int dCode = SMSUtil.getISDCode(userCountry);
		    List<ISDCode> countryList = SMSUtil.getAllowedISDCodes();
		    for(ISDCode isdCode : countryList){%>
			<option data-num="<%=IAMEncoder.encodeHTMLAttribute(isdCode.getDialingCode()+"")%>" <%if(isdCode.getDialingCode()==dCode){%>selected<%}%> value="<%=IAMEncoder.encodeHTMLAttribute(isdCode.getCountryCode()) %>"><%= IAMEncoder.encodeHTML(isdCode.getCountryName())+"&nbsp;(+"+IAMEncoder.encodeHTML(""+isdCode.getDialingCode())+")" %> </option>
			<%}%>
		</select> 
		<%}else{%>
		<input class="text_box" id="mobileno" type="email"  type="text" style="text-indent:5px;" required="" autocomplete="off" placeholder="<%=Util.getI18NMsg(request,"IAM.USER.ADD.EMAIL.PLACEHOLDER")%>" value="<%=email%>"/>
        <span class="edit_icon" onclick=edit();></span>
		<%}%>
        <span id="mobileno_lab_bar"class="bar"></span>
	</div>
        
    <div class="form_field" id="get_ver_code">
        <input class="text_box"  id="verify_code" type="text" oninput="this.value = this.value.replace(/[^\d]+/g,'')" required="">
        <span class="bar"></span>
        <label><%=Util.getI18NMsg(request,"IAM.TFA.ENTER.VERIFICATION.CODE")%></label>
    </div>    
        
    <div class="medium_text blue" id="resend_code" onclick="resendCode();"><%=Util.getI18NMsg(request,"IAM.TFA.RESEND.CODE")%></div>
        
    <div class="normal_text" id="mob_no_added">
        <img class="tick" src="../../../images/round-tick.png">
   		<%=Util.getI18NMsg(request,isEmail?"IAM.EMAIL.ADDED.SUCCESSFULLY":isRecovery?"IAM.RECOVERY.MOBILE.ADDED.SUCCESSFULLY":"IAM.MOBILE.ADDED.SUCCESSFULLY")%>
        <br>
    </div>
    <button class="btn" id="send_ver" onclick="updateMobile()"><%=Util.getI18NMsg(request,"IAM.SEND.VERIFY")%></button>
    <button class="btn" id="ver_id" onclick="verifyCode()"><%=Util.getI18NMsg(request,"IAM.VERIFY")%></button>    
	<div class="note_message" id="show_phone_message"></div>
    </div>
    <%if(!isMobile){ %>
		<div Style = "position : absolute;bottom : 0; height : 40px; margin-top : 40px; margin-left : 44%;"><%@ include file="../unauth/footer.jspf" %></div>
	<%}else{%>
		<div id="mobilefooter" class="otheracc-topborder" style="margin-top: 30%; text-align: center;"><%=Util.getI18NMsg(request, "IAM.FOOTER.COPYRIGHT", Util.getCopyRightYear())%></div>
	<%} %>
</body>
<script src="<%=jsurl%>/jquery-1.12.2.min.js" type="text/javascript"></script><%-- NO OUTPUTENCODING --%>
<script src="<%=jsurl%>/common.js" type="text/javascript"></script> <%-- NO OUTPUTENCODING --%>
	<script src="<%=jsurl%>/chosen.jquery.js" type="text/javascript"></script> <%-- NO OUTPUTENCODING --%>
<script>
	var csrfParam = '<%=SecurityUtil.getCSRFParamName(request)+"="+SecurityUtil.getCSRFCookie(request)%>';<%-- NO OUTPUTENCODING --%>
	<%if(isEmail){%>
	$(function() {
	    step1();
		$("#mobileno").focus();
		<%if(IAMUtil.isValid(email)){%>updateMobile();<%}%>
	});
	<%}else{%>
	$(function() {
		$(".chosen-select").chosen();
		setSetChosenSpan();
		$("#country_code_select_chzn").css("display","inline-block");    //No I18N
		$('.chzn-search input').attr('tabindex',1);		//No I18N
		$(document).on('change', '#country_code_select', setSetChosenSpan);
		$('.chzn-results').click(setSetChosenSpan);
		$(".chzn-container").bind('keyup',function(e) {
		    if(e.which === 13) {
		    	setSetChosenSpan();
		    	return false;
		    }
		});
	    step1();
		$("#mobileno").focus();
	});
	<%}%>
	function setSetChosenSpan(){
		$('.chzn-single span').text('+'+$( "#country_code_select option:selected" ).attr('data-num'));//No I18N
	}
    var usedMobile='';
    
    function isValidCode(code) {
        if(code.trim().length != 0){
            var codePattern = new RegExp("^([0-9]{5,7})$");
            if(codePattern.test(code)){
                return true;
            }
        }
        return false;
    }
    
    function doValidate(code) {
        return <%if(isRecovery||isLoginMobile){%>isPhoneNumber(usedMobile)<%}else{%>isEmailId(usedMobile)<%}%>;
    }
    
    function updateMobile() {
    	$('#show_phone_message').hide();
    	var _param=csrfParam;
    	var resp ="";
   		usedMobile = de("mobileno").value;//No I18N
        var countrycode =$( "#country_code_select" ).val();//No I18N
        if(!doValidate(usedMobile)){
            showErrMsg('<%=Util.getI18NMsg(request, isEmail?"IAM.ERROR.EMAIL.INVALID":"IAM.PHONE.ENTER.VALID.MOBILE")%>')
            return;
        }
        <%if(isEmail){%>
        _param+="&email="+euc(usedMobile);//No I18N
        <%}else{%>
   		_param+="&mobile="+usedMobile+"&country_code="+countrycode;//No I18N
   		<%}%>
   		resp = getPlainResponse(sendurl+"send",_param); //No I18N
        try{
	        var obj = JSON.parse(resp);
	        if(obj.status == "success"){
	        	if(obj.message == "vercode"){
	        		step2();
	        	}
	        }else{
	        	handleErrorResponse(obj);
	        }
        }catch(e){
            showErrMsg('<%=Util.getI18NMsg(request, "IAM.ERROR.GENERAL")%>');    
        }
    }
    
    function resendCode(){
        if(usedMobile!=''){
        	var params=csrfParam
        	<%if(isEmail){%>
        		params+="&email="+euc(usedMobile);//No I18N
            <%}else{%>
            	params+="&mobile="+usedMobile;//No I18N
        	<%}%>
        	var resp = getPlainResponse(sendurl+"resend",params); //No I18N
            try{
	            var obj = JSON.parse(resp);
	            if(obj.status == "success"){
                	showSuccessMsg(obj.message);
                }else{
                	handleErrorResponse(obj);
                }
            }catch(e){
                showErrMsg('<%=Util.getI18NMsg(request, "IAM.ERROR.GENERAL")%>');
            }
        }else{
        	step1();
        	edit();
        }
    }
    
    function verifyCode() {
        var code = de("verify_code").value;//No I18N
        if(!isValidCode(code)){
            showErrMsg('<%=Util.getI18NMsg(request, "IAM.PHONE.INVALID.VERIFY.CODE")%>');
            return;
        }
        var params=csrfParam;
        <%if(isEmail){%>
			params+="&email="+euc(usedMobile);//No I18N
	    <%}else{%>
	    	params+="&mobile="+usedMobile;//No I18N
		<%}%>
        var resp = getPlainResponse(sendurl+"verify",params+"&otp="+code); //No I18N  <%-- NO I18N --%>
        try{
               var obj = JSON.parse(resp);
            if(obj.status == 'success'){
                step3();
            return false;
            }else{
            	handleErrorResponse(obj);
            }
        }catch(e){
            showErrMsg('<%=Util.getI18NMsg(request, "IAM.ERROR.GENERAL")%>');
        }
        return true;
    }
    
    function handleErrorResponse(obj){
    	if(obj.status == "error" || obj.response == "error"){ //No I18N
    		if(obj.code=="PP112"){// this is seprately handled for reauth case
    			showErrMsg('<%=Util.getI18NMsg(request, "IAM.ERROR.CODE.U136")%>');
    		}else{
    			showErrMsg(obj.message?obj.message:'<%=Util.getI18NMsg(request, "IAM.ERROR.GENERAL")%>');
    		}
			if(obj.code &&(obj.code=="U135"||obj.code=="U136"||obj.code=="U137" || obj.code=="PP112")){
			  		setTimeout(function(){ window.location.href=""; }, 5000);
			}
        }
    }
    
    function step1() {
    	document.getElementById("get_mob_no").style.display="block";
        document.getElementById("send_ver").style.display="inline-block";
    }
    
    
    function step2() {
        document.getElementById("get_ver_code").style.display="block";
        document.getElementById("resend_code").style.display="block";   
        document.getElementById("send_ver").style.display="none";   
        document.getElementById("ver_id").style.display="inline-block"; 
        lock_text();
        document.getElementById("welcome_text").innerHTML="<br>"+'<%=Util.getI18NMsg(request, isEmail?"IAM.EMAIL.OTP.SENT":"IAM.MOBILE.OTP.SENT")%>';
        $("#verify_code").focus();
    }
    function step3() {
        document.getElementById("mob_no_added").style.display="block";
        document.getElementById("resend_code").style.display="none";
        document.getElementById("get_ver_code").style.display="none";
        $('#prevNoSelect').hide();
        document.getElementById("ver_id").style.display="block";
        $('#welcome_text').remove();
        document.getElementById("ver_id").innerHTML='<%=Util.getI18NMsg(request,"IAM.CONTINUE")%>';
        document.getElementById("ver_id").onclick=function() {
        	<%if("true".equals(request.getParameter("ann"))) {
        		%>
            	window.location.href = '<%=IAMEncoder.encodeJavaScript(Announcement.getVisitedNextURL(request))%>';
        	<%} else {
        	%>
            window.location.href = '<%=IAMEncoder.encodeJavaScript(redirectUrl)%>';
            <%}%>
        };
        $('#get_mob_no').remove();
    }
    
    function edit(){
         document.getElementById("get_ver_code").style.display="none";
         document.getElementById("resend_code").style.display="none";   
         document.getElementById("send_ver").style.display="block";
         document.getElementById("ver_id").style.display="none";
         document.getElementById("welcome_text").innerHTML="<br>"+'<%=Util.getI18NMsg(request, (isEmail)?"IAM.ADD.CONTACT.EMAIL.TXT":"IAM.ADD.CONTACT.MOBILE.TXT")%>';
         $('.edit_icon').hide();
         $('#down_arrowid').hide();
         $("#mobileno").prop("disabled",false);//No I18N
         $("#countrycodeid").prop("disabled",false);//No I18N
         $(".country_code").removeAttr("style");//No I18N
         $('#country_code_select').prop('disabled', false).trigger("liszt:updated");
         if($( "#country_code_select option:selected" ).text()){
        	 setSetChosenSpan();
 		 }
         $('.chzn-single span').css("color","black");	//No I18N
         $('#mobileno').css("color","black");	//No I18N
         $('#mobileno').focus();
    }
    
    function lock_text() {
    	$("#mobileno").prop("disabled",true); //No I18N
    	$(".country_code").css("display","block"); //No I18N
    	$(".edit_icon").css("display","block"); //No I18N
    	$("#countrycodeid").prop("disabled",true); //No I18N
    	$("#countrycodeid").css("color","grey"); //No I18N
    	$("#mobileno").css("color","grey"); //No I18N
    	$('#country_code_select').prop('disabled', true).trigger("liszt:updated");
    	if($( "#country_code_select option:selected" ).text()) {
    		setSetChosenSpan();
    	}
		$('.chzn-single span').css("color","grey");	//No I18N
    }
    
    function showErrMsg(msg){
     $(".top_div").css({"border-right": "3px solid #ef4444", "color": "#ef4444"});  //No I18N
     $(".cross_mark").css("background-color","#ef4444");     //No I18N
     $(".crossline1").css({"top": "18px", "left": "0px", "width":"20px"});   //No I18N
     $(".crossline2").css("left","0px");  //No I18N
     $('.top_msg').html(msg); //No I18N
     $( ".top_div" ).fadeIn("slow");//No I18N
     setTimeout(function() {
      $( ".top_div" ).fadeOut("slow");//No I18N
     }, 3000);;
    }
    
    function showSuccessMsg(msg) {
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