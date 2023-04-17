<%--$Id$--%>
<%@page import="com.adventnet.iam.internal.PhoneUtil"%>
<%@page import="com.zoho.accounts.actions.unauth.ForgotPassword"%>
<%@page import="com.zoho.accounts.internal.announcement.Announcement"%>
<%@page import="org.json.JSONObject"%>
<%@page import="com.zoho.accounts.Accounts.RESOURCE"%>
<%@page import="com.zoho.resource.Criteria"%>
<%@page import="com.zoho.accounts.Accounts"%>
<%@page import="com.zoho.accounts.AccountsProto.Account.Digest"%>
<%@page import="com.adventnet.iam.servlet.Password"%>
<%@page import="com.zoho.accounts.AccountsProto.Account.User.UserMobile"%>
<%@page import="com.zoho.accounts.SystemResourceProto.ISDCode"%>
<%@page import="com.zoho.accounts.phone.SMSUtil"%>
<%@page import="java.util.Locale"%>

<%@ include file="../../static/includes.jspf" %>
<%
	String portalid = request.getParameter("portal_id");
	String portalName = request.getParameter("portal_name");
	String portalDomain = request.getParameter("portal_domain");

	String serviceUrl = Util.getTrustedURL(-1, request.getParameter("servicename"), request.getParameter("serviceurl"));

	if( Util.getTempAuthTokenFromThreadLocal() == null){
		response.sendRedirect(serviceUrl);
		return;
	}
	User user = Util.USERAPI.getUser(IAMUtil.getLong(Util.getTempAuthTokenFromThreadLocal().getParent().getZuid()));

	List<ISDCode> countryList = null;
	String userCountry = null;
	
	String servicename = request.getParameter("servicename") != null ? request.getParameter("servicename") : "";

    boolean verify = Boolean.parseBoolean(request.getParameter("verify"));
    boolean isMobile = Util.isMobileUserAgent(request);
    String css_url = isMobile ? cssurl_st+"/mobilelogin.css" : cssurl+"/style.css"; //No I18N
    boolean iscss = request.getParameter("css") != null && Util.isTrustedCSSDomain(request.getParameter("css"));
    String customisedCSSUrl = iscss ? request.getParameter("css") : null; 
    boolean overrideCSS = Boolean.parseBoolean(request.getParameter("override_css"));
    Boolean isForgotPassword = (Boolean)request.getAttribute("isForgotPassword");

    if(!Util.isValid(isForgotPassword)){
    	isForgotPassword = false;
    }
   
	String primaryNumber = null;
	UserMobile primary_um = null;
    if(!isForgotPassword){
		primaryNumber = user.getMobileScreenName()!=null?user.getMobileScreenName().getEmailId():null;
		primary_um = primaryNumber!=null?(UserMobile) RestProtoUtil.GET(Accounts.getUserMobileURI(user.getZaid(), user.getZUID(),primaryNumber)):null;
		countryList = SMSUtil.getAllowedISDCodes();
		Locale locale = request.getLocale();
		userCountry = locale.getCountry();
    }
    
    String mobile = "";
    JSONObject jsonResponse = Util.getTempAuthTokenDataFromThreadLocal();
    if(Util.isValid(jsonResponse)){
    	mobile = jsonResponse.optString("mobile");   //No I18N
    }else if(user != null){
    	mobile = user.getMobileScreenName()!=null?user.getMobileScreenName().getEmailId():null;
    }
    if(Util.isValid(mobile) && isForgotPassword){
		mobile = mobile.substring(0,mobile.length()-2).replaceAll("[0-9]", "*") + mobile.substring(mobile.length()-2);
    }
    if(!isForgotPassword && (user.isConfirmed())){
        response.sendRedirect(serviceUrl);
        return;
    }
    String userAgent = request.getHeader("User-Agent");
    boolean isIosDevice = false;
    if(Util.isValid(userAgent) && userAgent.toLowerCase().indexOf("iphone") != -1){
    	isIosDevice = true;
    }

%>
<!DOCTYPE html>
<html>
    <head>
	 <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <%if(isMobile){ %>
    	<meta name="viewport" content="width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=no" />
    <%} %>
	<title><%=Util.getI18NMsg(request,"IAM.ZOHO.ACCOUNTS")%></title>
	<style type="text/css">
	@font-face {
    font-family: 'Open Sans';
    font-weight: 400;
    font-style: normal;
	src :local('Open Sans'),url('<%=imgurl%>/opensans/font.woff') format('woff');  <%-- NO OUTPUTENCODING --%>
	}
	
	.loadingImg{
	display: none;
    width: 25px;
	height: 25px;
	background: url('../../images/loading.gif')no-repeat 0px 0px;
	margin-top: 10px;
	position: absolute;
	margin-left: 150px;
}
            .pagesubtitle {
                  padding:5px 6px 5px 10px; 
                  line-height:22px; 
                  margin-top:5px;
                  color: #333333;
                  font-size: 14px;
                  text-align: center;
                  width: 780px;
  				  margin-left: 9%;
            }
            #progress-cont {
                  display : none;
                  position: absolute;
                  top: 35%;
                  left: 45%;
                  background-color: #fff;
                  padding: 5px 10px;
                  border: 2px solid #6699cc;
            }
            #contentdiv{
              margin-left: 18%;
  			  margin-top: 4%;
            }
            #messagepanel{
              text-align: center;
			  /* width: 800px; */
			  font-size: 13px;
            }
            #verify{
            background: none repeat scroll 0 0 #EC3618;
  			color: #FFF;
  			font-size: 12px;
  			line-height: 38px;
  			height: 30px;
  			text-align: center;
  			text-transform: uppercase;
  			border-radius: 2px;
  			padding: 0px 15px 6px 15px;
  			text-decoration: none;
  			font-weight: 600;
  			white-space: nowrap;
		  	float: left;
  			width: 50%;
  			cursor: pointer;
            }
                       #cancel{
            color: #141823;
  			font-size: 12px;
  			line-height: 30px;
  			height: 30px;
  			text-align: center;
  			text-transform: uppercase;
  			border-radius: 2px;
  			padding: 2px 15px 2px 15px;
  			margin-left: 4%;
  			font-weight: 600;
  			white-space: nowrap;
  			float: left;
  			width: 20%;
            } 
            #resendcode{
            margin-left: 55%;
  			font-size: 12px;
  			margin-top: -2%;
  			text-decoration: underline;
 			cursor: auto;
            }
            #errmsg{
              margin-left: 28%;
  			  font-size: 12px;
  			  margin-bottom: 1%;
  			  width: 38%;
  			  color:white;
  			  text-align: center;
            }
            body{
            	height:550px;
            }
            
</style>
	<script src="<%=jsurl%>/jquery-1.12.2.min.js" type="text/javascript"></script><%-- NO OUTPUTENCODING --%>
	<script src="<%=jsurl%>/common.js" type="text/javascript"></script> <%-- NO OUTPUTENCODING --%>
	<%if(iscss) { %>
		<%if(overrideCSS){ %>	
			<link href="<%=IAMEncoder.encodeHTMLAttribute(css_url)%>" type="text/css" rel="stylesheet" /> <%-- NO OUTPUTENCODING --%>
		<%}%>
		<link href="<%=IAMEncoder.encodeHTMLAttribute(customisedCSSUrl)%>" type="text/css" rel="stylesheet" /> <%-- NO OUTPUTENCODING --%>
	<%}else {%>
		<link href="<%=IAMEncoder.encodeHTMLAttribute(css_url)%>" type="text/css" rel="stylesheet" /> <%-- NO OUTPUTENCODING --%>
	<%} %>

	<script>
            var msg = '<%=Util.isValid(request.getAttribute("msg")) ? request.getAttribute("msg") : ""%>';<%-- NO OUTPUTENCODING --%>
	</script>
    </head>
	<body>
	 <div id="mobfor_tb" class="for-mobile" style="text-align:center;margin-top: 5%;">
	 <div>
	<%if (!verify) {
		if(Util.isValid(portalid)) {
			String logourl = IAMProxy.getContactsServerURL(true) + "/static/file?t=org&ID=" + portalid + "&nocache=" + System.currentTimeMillis(); //No I18N
	%>
		<img src="<%=IAMEncoder.encodeHTMLAttribute(logourl)%>" height="46" style="margin: 30px auto;"/>
	<%
		} else if(Util.isValid(portalDomain)) {
			String logourl = IAMProxy.getContactsServerURL(true) + "/static/file?t=org&domain=" + portalDomain + "&nocache=" + System.currentTimeMillis(); //No I18N
	%>
		<img src="<%=IAMEncoder.encodeHTMLAttribute(logourl)%>" height="46" style="margin: 30px auto;"/>
	<%
		} else {
			if(isMobile) {
	%>
		<div class="logocolor logoadjust"><span class="colorred"></span><span class="colorgreen"></span><span class="colorblue"></span><span class="coloryellow"></span></div>
		<div class="<%=IAMEncoder.encodeHTMLAttribute(Util.isValid(portalName) ? portalName : "mobilelogo")%>" style="margin: 30px auto;"></div>
	<%
			} else {
	%>
		<div class="<%=IAMEncoder.encodeHTMLAttribute(Util.isValid(portalName) ? portalName +" logo-top" : "logo-top")%>" style="margin: 30px auto;"></div>
	<%
			}
		}
	%>
	
	<div class="title-1"<%if(isMobile) {%> style="font-size: 22px"<%}%> id="passwordreset_title"><%=isForgotPassword ? Util.getI18NMsg(request,"IAM.FORGOTPASS.TITLE") : Util.getI18NMsg(request,"IAM.MSG.ACCOUNT.CREATED")%></div>
	<div class="bdre2"></div>
	<%if(!isMobile && isForgotPassword) {%>
		<div id="title-2"><%=Util.getI18NMsg(request,"IAM.MOBILE.VERIFICATION.SENT.MSG", mobile)%></div>
	<%}%>

	<div class="forgot_sub" id="forgot_sub"></div>
	<%} else {%>
	<div class="innerheading"><%=Util.getI18NMsg(request,"IAM.FORGOTPASS.SMS.TITLE")%></div>
	<div class="forgot_sub"><%=Util.getI18NMsg(request,"IAM.FORGOTPASS.SMS.SUBTITLE")%></div>
	<%}%>
	<div id="errmsgpanel" class="hide"></div>	
    <div id="emailmsg" style="font-size: 13px;<%if(!isMobile){%>margin: 0px auto;width: 30%;<%}%>"></div>	
    <div class="backtohome" style="text-align: center;margin-top: 8%;display:none">
	 <span class="whitebutton" onclick="goToHomeUrl()"><%=Util.getI18NMsg(request,"IAM.BACKTO.HOME")%></span>
	</div>
	<div class="backtohome_web" style="display:none;text-align: center;margin-top: 3%">
	<%if(isForgotPassword) {%>
	 <span class="cancel-btn" onclick="goToHomeUrl()"><%=Util.getI18NMsg(request,"IAM.BACKTO.HOME")%></span>
	 <%} %>
	 </div>
	 
	<div id="password">
		<% if(isMobile){%>
	<div class="otp" text-align: left;">
	<%if(isForgotPassword) {%>
		<div id="forgotpassmobiletxt" Style="text-align:justify; padding: 0px;"><%=Util.getI18NMsg(request, "IAM.MOBILE.VERIFICATION.SENT.MSG", mobile)%></div> <%-- NO I18N --%>
	<%}else{ %>
	<div id="forgotpassmobiletxt" Style="text-align:justify;padding: 0px;"><%=Util.getI18NMsg(request, "IAM.MOBILE.VERIFICATION.SENT.MSG.SIGNUP", mobile)%></div> <%-- NO I18N --%>
	<%} %>
	<%if(!isForgotPassword) {%>
	<div class="title-1" style="font-size: 15px; margin-top: 1%;"><%=Util.getI18NMsg(request, "IAM.MOBILE.LOGIN.USING.SAME.NUMBER")%></div>
	<%} %>
	<div id=maincontent style="margin-left:3%;margin-top:6%">
	<div id="forgotpassmobiletxt" class="resendtxt" Style="display:none;"></div> <%-- NO I18N --%>	
	<div id= "forgopassinput" Style = "text-align: left;">
	<input type="number" class="input_forgot" id="verifyCode" name="otpcode"  value="" placeholder='<%=Util.getI18NMsg(request, "IAM.VERIFY.CODE")%>' autocapitalize="off" autocomplete="off" autocorrect="off" style="width: 125px;padding-left: 12px;font-size: 17px;">
	<%if(!isIosDevice){ %>
		<span class="loadingVerify"></span>
	<%} %>
	<span class="resendbutton" style="display:none;" onclick="resendVerifyCode();"><%=Util.getI18NMsg(request, "IAM.MOBILE.RESEND")%></span><%-- NO I18N --%>
	</div>

	<div style="margin-top:12px;">
		<div class="desctd fllt"></div>
		<div class="descRtd txtalignlft">
			<span class="bluebutton" onclick="verifyotp(document.password);"><%=Util.getI18NMsg(request, "IAM.VERIFY")%></span> <%-- NO OUTPUTENCODING --%>
			<%if(isForgotPassword){ %>
			<span class="whitebutton" style="display:none;" onclick="window.parent.location.href='<%=IAMEncoder.encodeJavaScript(serviceUrl)%>';"><%=Util.getI18NMsg(request, "IAM.CANCEL")%></span>
			<%} %>
		</div>
	</div>
	</div>
		<%}else{ %>
		
		 <%if(!isForgotPassword && !isMobile) {%>
<table width="100%" height="100%" align="center" cellpadding="0" cellspacing="0">
            <tr>
                <td valign="top" align="center">
                    <table cellpadding="0" cellspacing="0" border="0">
                        <tr>
                            <td>
                                <div id="verifydiv">
                                    <div class="pagetitlediv">
                                        <div class="pagesubtitle" style="margin-right:100px;" id="page_subtitle"><%=!isForgotPassword ? Util.getI18NMsg(request, "IAM.ACCOUNT.VERIFY.MOBILENUMBER.SUBTITLE", IAMEncoder.encodeHTML(primary_um != null ? "(+"+SMSUtil.getISDCode(primary_um.getCountryCode())+") "+primary_um.getMobile() :  primaryNumber)) : ""%></div>
                                    </div>
                                   
	<div class="title-1" style="font-size: 15px; margin-top: 1%; text-align: center;"><%=Util.getI18NMsg(request, "IAM.MOBILE.LOGIN.USING.SAME.NUMBER")%></div>
                                    <div id="contentdiv">
                                    			 <div id="errmsg" style="background-color: rgb(236, 54, 24);"></div>
                                                 <div id="editMobile" class="label" Style="display:none;">
                                                      
                                                      
	<div class="label">
		<div class="inlineLabel" style="font-size:15px;">
			<%=Util.getI18NMsg(request, "IAM.PHONE.NUMBER")%> :
		</div>
		<div>
			<span class="prefvalue">
			<input type="hidden" id="oldmobile" value="<%=!isForgotPassword?IAMEncoder.encodeHTMLAttribute(primary_um != null?primary_um.getMobile() :  primaryNumber):""%>"/>
			<select name="selectdiv" id="selectdiv" style="width:158px;border: 1px solid #bdc7d8;color: #414141;font-size: 15px;margin-top: 0%;height: 28px;" >
			<% 
				if(countryList != null && countryList.size() > 0){
				String countryName = null,countryCode = null,display = null;
				int dialingCode = -1;
				for(ISDCode isdCode : countryList){
					countryName = isdCode.getCountryName();
					countryCode = isdCode.getCountryCode();
					dialingCode = isdCode.getDialingCode();
					display= countryName + " (+" + dialingCode + ")";//"(+"+ dialingCode +") " + countryName;
			%><option value='<%=IAMEncoder.encodeHTMLAttribute(countryCode)%>' <%if(countryCode.equalsIgnoreCase(userCountry)){%> selected <%}%>><%=IAMEncoder.encodeHTML(display)%></option><%
				}
				}
			%>
			</select>
			</span>
			<input type="text" id="mobile" name="mobileno"  onkeyup="if(event.keyCode==13) handleMobileAction()" class="inputText" style="width: 145px;margin-left: 2%;font-size:14px;" placeholder="<%=Util.getI18NMsg(request, "IAM.ENTER.PHONE.NUMBER")%>" onkeyup="$(this).siblings('.error').hide();if(event.keyCode==13) addNewPhoneNumber();">
			<input type="hidden" id="phmobNo" />
		</div>
	</div>								                                                      
                                                 </div>
     											 <p id="countrycodemsg" style="text-align: left; margin-left: 27%;font-size: 11px;display:none;"><%=Util.getI18NMsg(request, "IAM.MOBILE.COUNTRYCODE.NOTE")%><br> &nbsp;&nbsp;&nbsp;<%=Util.getI18NMsg(request, "IAM.MOBILE.COUNTRYCODE.EXAMPLE")%></p>  <%-- No I18N --%>     											                                                 
                                    
                                    
                                        <div id="sm_contectdiv">
                                                <div id="ch_email_default" class="label">
                                                      <div id="reg_e_a" class="inlineLabel" Style="font-size: 14px;"><%=Util.getI18NMsg(request, "IAM.TFA.ENTER.VERIFICATION.CODE")%> : </div>
	                                                  <input type="text"  tabindex="1"  onkeyup="if(event.keyCode==13) handleMobileAction()" autofocus class="unauthinputText" placeholder="Verification Code" style="width: 40%;" id="verifyCode">
                                                 </div>
                                                 <div id="resendcode" onclick="resendVerifyCode()"><a href="#"><%=Util.getI18NMsg(request, "IAM.TFA.RESEND.CODE")%></a></div><%-- No I18N --%>
                                        </div>
                                              <div id="cm_contectdiv" class="label">
                                              		 <div class="inlineLabel"></div>
                                                      <div id="verify_cancel" style=" width: 44%;   margin: 20px auto;">
														<div id="verify" onclick="handleMobileAction()" ><%=Util.getI18NMsg(request, "IAM.MOBILE.VERIFY")%></div><%-- No I18N --%>
														<div id="cancel"></div><%-- No I18N --%>
													  <%} else {%>
													  <div class="otp">
			<div class="errormsgtxt" Style="margin: 0px auto; display:none;"></div> <%-- NO I18N --%>
			<div Style="margin-top:1%;">
			<div class="inlineLabel hide" style="position: absolute; width: 43%; margin-top: 10px; opacity: 1; margin-left: -44px;font-size: 14px; display: block;"><%=Util.getI18NMsg(request, "IAM.TFA.ENTER.VERIFICATION.CODE") %> : </div><%-- NO I18N --%>
			<input type=text  id="verifyCode" name="otpcode" maxlength=8  onkeyup="animatePlaceHolder(this,'','-44px');" <%if(isMobile){ %> autocapitalize="off" autocomplete="off" autocorrect="off"<%}%> placeholder="Verification Code" style="width: 260px; line-height: 31px;">
			<div id="resendCode" onclick="resendVerifyCode();"></p><%=Util.getI18NMsg(request, "IAM.TFA.RESEND.CODE")%></p></div>
			</div>
		</div>
		<div class="button">
			<span <%if(isMobile){%>class="bluebutton" <%}else {%>class="redBtn"  style="<%=isForgotPassword? "" : "margin-right:150px;" %> " id="buttonloader verifyCode" <%} %>  tabindex="1"  onclick="verifyotp(document.password);"><%=Util.getI18NMsg(request, "IAM.VERIFY")%><span class="loadingImg" Style="display:none"></span></span> <%-- NO OUTPUTENCODING --%>
			<%if(isForgotPassword) {%>
			<span <%if(isMobile){%>class="whitebutton" <%}else {%>class="cancel-btn" style="margin-left:6px;"<%} %> tabindex="1" onclick="window.parent.location.href='<%=IAMEncoder.encodeJavaScript(serviceUrl)%>';"><%=Util.getI18NMsg(request, "IAM.BACKTO.HOME")%></span>
			<%}%>
	</div>
													  <%}%>
												</div>
                                              </div>
                                    </div>

                                </div>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
	</div>

		<%} %>
	</div>
	<%if(isForgotPassword) {%>
	<div id="successmsgpanel" class="hide mob_hide"><span id="successresp" <%if(!isMobile){%><% }%>>&nbsp;</span><div style="margin-top:10px;display:none;" id="success_mobile_txt"><%=Util.getI18NMsg(request, "IAM.FORGOT.SMS.ALSO.SENT")%></div><div class="mob_but_head" style="text-align: center;margin-top: 8%">
	 <span <%if(isMobile){%>class="whitebutton" <%}else {%>class="cancel-btn"<%} %>  onclick="goToHomeUrl()"><%=Util.getI18NMsg(request,"IAM.BACKTO.HOME") %></span><%-- NO OUTPUTENCODING --%></div>
	</div>
	<%} %>
	</div >
	<%if(!isMobile){ %>
		<div Style = "position : absolute;bottom : 0; height : 40px; margin-top : 40px; margin-left : 44%;"><%@ include file="../unauth/footer.jspf" %></div>
	<%}else{%>
		<div id="mobilefooter" class="otheracc-topborder" style="margin-top: 30%;"><%=Util.getI18NMsg(request, "IAM.FOOTER.COPYRIGHT", Util.getCopyRightYear())%>
	<%} %>
    </div>
</body>
</html>

<script>
	var isIOSDevice = '<%=isIosDevice%>';
	 var csrfParam = '<%=SecurityUtil.getCSRFParamName(request)+"="+SecurityUtil.getCSRFCookie(request)%>';<%-- NO OUTPUTENCODING --%>
		
		
	 function showsuccess(url) {
		window.location.href = url;
	 }
	 function isValidMobile(mobile){
	     	if(mobile.trim().length != 0){
	     		var mobilePattern = new RegExp("^([0-9]{8,12})$");
	     		if(mobilePattern.test(mobile)){
	     			return true;
	     		}
	     	}
	     	return false;
	     }
	 
		function showError(message){
			$('.resendtxt').html(message);//No I18N
			$('.resendtxt').css("color",'red');//No I18N
			$('.resendtxt').fadeIn();
			$('#errmsg').css("background-color",'rgb(236, 54, 24)');<%-- No I18N --%>
			$("#errmsg").html(message);
			$('#errmsg').fadeIn();
			$('#errmsg').fadeOut(2000);
			$('.errormsgtxt').css("background-color",'rgb(236, 54, 24)');<%-- No I18N --%>
			$(".errormsgtxt").html(message);
			$('.errormsgtxt').fadeIn();
			$('.errormsgtxt').fadeOut(2000);
		}
	 
	 function updateMobile(){
	     	var mobile = de("mobile").value;//No I18N
	     	var oldmobile = de("oldmobile")? de("oldmobile").value:"";//No I18N
	     	var countrycode = de("selectdiv").value;//No I18N        	
	 		if(!isValidMobile(mobile)){
	 			showError('<%=Util.getI18NMsg(request, "IAM.PHONE.ENTER.VALID.MOBILE")%>')
	 			return;
	 		}
         var resp = getPlainResponse("/u/updateMobile","mobile="+mobile+"&oldmobile="+oldmobile+"&code="+countrycode+"&"+ csrfParam); //No I18N
	 		try{
	         var obj = JSON.parse(resp);
	 		if(obj.status == "success"){
	 	    location.reload();
	 	    return false;
	 		}else{
	 			showError(obj.message);
	 		}
	 		}catch(e){
	 			showError('<%=Util.getI18NMsg(request, "IAM.ERROR.GENERAL")%>');	
	 		}
	     }
	 

	 function handleMobileAction() {
	 		if($('#verify').html() =="<%=Util.getI18NMsg(request, "IAM.MOBILE.UPDATE")%>"){
	 			updateMobile();
	 			return;
	 		}else{
	 			verifyotp();
	 		}
	 		
	 		return false;
	 	}
	 
	 
	 
	 function editMobile(){
	     	$('#sm_contectdiv').hide();
	     	$('#errmsg').hide();
	     	$('#page_subtitle').html('<%=Util.getI18NMsg(request, "IAM.MOBILE.ENTER.TO.UPDATE")%>');
	     	$('#cancel').html('<%=Util.getI18NMsg(request, "IAM.GAPPS.GOBACK")%>');//No I18N
	     	$("#cancel").attr("onclick","location.reload()");//No I18N
	     	$("#cancel").attr("style","border: 1px solid #ccc; cursor: pointer;");//No I18N
	     	$('#editMobile').show();
	     	$('#verify').html('<%=Util.getI18NMsg(request, "IAM.MOBILE.UPDATE")%>');//No I18N
	     	$('#mobile').focus();
	     }
	 
	 function resendVerifyCode(){
		var phoneNumber = $('#mobile').val();
    	var resp = getPlainResponse('<%=request.getContextPath()+(isForgotPassword ?"/password/resendcode" : "/u/resendCode")%>','<%=SecurityUtil.getCSRFParamName(request)%>'+'='+'<%=SecurityUtil.getCSRFCookie(request)%>'); <%-- NO I18N --%> <%-- NO OUTPUTENCODING --%>
		try{
    	var obj = JSON.parse(resp);
		$('.loadingVerify').fadeOut();
    	if(obj.status == "success"){
			$('.resendtxt').html(obj.message);
			$('.resendtxt').css("color",'green');//No I18N
			$('.resendtxt').css("border", "none"); //No I18N
			$('.resendtxt').fadeIn();
			$('.resendtxt').fadeOut(2000);
			$('.errormsgtxt').html(obj.message);
			$('.errormsgtxt').css("background-color", "#50BF54");//No I18N
			$('.errormsgtxt').css("color", "white"); //No I18N
			$('.errormsgtxt').fadeIn();
			$('.errormsgtxt').fadeOut(2000);
			
			$('#errmsg').html(obj.message);
			$('#errmsg').css("background-color", "#50BF54");//No I18N
			$('#errmsg').css("color", "white"); //No I18N
			$('#errmsg').fadeIn();
			$('#errmsg').fadeOut(2000);
		}else if(obj.status == "error"){//No I18N
			showError(obj.message);
			return;
		}
		}catch(e){
			showError('<%=Util.getI18NMsg(request, "IAM.MAXIMUM.RESEND.ATTEMPTS.ERROR")%>'); 
		}
	}
	
		
		$('#verifyCode').keypress(function(e) {
	        $('.errormsgtxt').fadeOut();
	        $('.errmsg').fadeOut();
	        $('.resendtxt').fadeOut();
	    });
		
	
        function isValidCode(code){
        	if(code.trim().length != 0){
        		var codePattern = new RegExp("^([0-9]{5,7})$");
        		if(codePattern.test(code)){
        			return true;
        		}
        	}
        	return false;
        }
		
	function verifyotp(){
		var otp = $('#verifyCode').val();
		if(!isValidCode(otp)){
    		showError('<%=Util.getI18NMsg(request, "IAM.PHONE.INVALID.VERIFY.CODE")%>');
    		$('#verifyCode').focus();
    		return;
        }
		$('.loadingVerify').fadeOut();
        params = "otpcode="+ euc(otp.trim()) +"&"+csrfParam+"&servicename="+'<%=IAMEncoder.encodeJavaScript(request.getParameter("servicename"))%>'+"&serviceurl="+'<%=IAMEncoder.encodeJavaScript(Util.encode(serviceUrl))%>'; <%-- NO I18N --%>
        <% if(jsonResponse.has("scopes")) { %>
        params = params +'<%="&scopes="+IAMEncoder.encodeJavaScript(jsonResponse.optString("scopes"))+"&appname="+IAMEncoder.encodeJavaScript(jsonResponse.optString("appname"))+"&getticket="+IAMEncoder.encodeJavaScript(jsonResponse.optString("getticket"))%>'; <%-- NO I18N --%>
        <% } %>
        var res = getPlainResponse('<%=request.getContextPath()+(isForgotPassword ? "/password/verifyotp" : "/u/verifyotp" )%>', params); <%-- NO OUTPUTENCODING --%> 
		try{
        var obj = JSON.parse(res);	
			if(obj.status=='success') {
				window.parent.location.href=obj.redirecturl;
				return true;
			}else if(obj.status=='error'){//No I18N
				showError(obj.message);
				$('#verifyCode').focus();
				return;
			}
		}catch(e){
			if(res.startsWith('showsuccess(')){
				new Function( 'return ' + res.trim())();
			}else{
				window.parent.location.href = "<%=IAMEncoder.encodeJavaScript(serviceUrl)%>";  <%-- NO OUTPUTENCODING --%>
			}
		}
	}
	
	$( document ).ready(function() {
		if(isIOSDevice == 'true'){
		$('.whitebutton').fadeIn();
		$('.resendbutton').fadeIn();
		$('.resendtxt').html("<%=Util.getI18NMsg(request,"IAM.MOBILE.VERIFICATION.RESEND")%>");//No I18N
		$('.resendtxt').fadeIn();
		}else{
		setTimeout(function(){
			$('.whitebutton').fadeIn();
			$('.resendbutton').fadeIn();
			$('.loadingVerify').fadeOut();
			$('.resendtxt').html("<%=Util.getI18NMsg(request,"IAM.MOBILE.VERIFICATION.RESEND")%>");//No I18N
			$('.resendtxt').fadeIn();
			},20000);
		}});
		
		
    function showmsg(msg) {
        de('errmsgpanel').className = <%if(isMobile){%>"errormsg"<%}else{%>"errormsgnew"<%}%>; //No I18N
        de('errmsgpanel').innerHTML = msg; //No I18N
        hideLoadinginButton('12');
    }

    
	function isValid(instr) {
	    return instr != null && instr != "" && instr != "null"; //No I18N
	}

    function goToHomeUrl(){
        var redirecturl='<%=IAMEncoder.encodeJavaScript(Util.getRedirectURLWithTrustedDomainCheck(user.getZUID(), request, request.getParameter("servicename"), request.getParameter("serviceurl")))%>'; <%-- NO OUTPUTENCODING --%>
        window.parent.location.href = redirecturl; <%-- NO OUTPUTENCODING --%>
    	}
</script>
