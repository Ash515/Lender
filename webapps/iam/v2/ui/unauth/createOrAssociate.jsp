<%--$Id$--%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Locale"%>
<%@page import="com.zoho.accounts.internal.util.IPInfo"%>
<%@page import="com.zoho.accounts.SystemResourceProto.DCLocation"%>
<%@page import="com.zoho.accounts.internal.util.AccountsInternalConst"%>
<%@page import="com.zoho.accounts.phone.SMSUtil"%>
<%@page import="com.zoho.accounts.SystemResourceProto.ISDCode"%>
<%@page import="com.zoho.accounts.handler.GeoDCHandler"%>
<%@page import="com.zoho.accounts.dcl.DCLUtil"%>
<%@page import="com.adventnet.iam.security.SecurityUtil"%>
<%@page import="com.adventnet.iam.internal.Util"%>
<%@page import="com.adventnet.iam.IAMUtil"%>
<%@page import="com.adventnet.iam.xss.IAMEncoder"%>
<%@page import="com.zoho.accounts.internal.fs.FSConsumerUtil"%>
<%@ include file="../static/includes.jspf" %>
<%

	Boolean isEmailNeeded = (Boolean) request.getAttribute("isEmailNeeded");
	isEmailNeeded = isEmailNeeded != null ? isEmailNeeded.booleanValue() : false;

	Boolean isZohoIDP = (Boolean) request.getAttribute("isZohoIDP");
	isZohoIDP = isZohoIDP != null ? isZohoIDP.booleanValue() : true;

	Boolean isOrgInvite = (Boolean) request.getAttribute("isOrgInvite");
	isOrgInvite = isOrgInvite != null ? isOrgInvite.booleanValue() : false;
	
	boolean hideDC = isOrgInvite || Boolean.TRUE == request.getAttribute("hideDC");
	
	Boolean blockSignup = (Boolean) request.getAttribute("blockSignup");
	blockSignup = blockSignup != null ? blockSignup.booleanValue() : false;
	
	String provider = (String) request.getAttribute("provider");
	String name = (String) request.getAttribute(FSConsumerUtil.OAUTH_NAME);
	if(name == null) {
		name = "";
	}
	Object pic_with_logo =request.getAttribute(FSConsumerUtil.OAUTH_PIC_URL);
	Object servicename = request.getAttribute("servicename");
	Object serviceUrl = request.getAttribute("serviceurl");
    String termsOfServiceUrl = Util.getTermsOfServiceURL(request, servicename.toString());
    String privacyPolicyUrl = Util.getPrivacyURL(request, servicename.toString());
    String emailId = (String) request.getAttribute("emailId");

	Object domain = request.getAttribute("hd-domain");
	boolean isValidDomain = Util.isValid(domain) ? true : false;
	boolean isMobile = Util.isMobileUserAgent(request);
%>

<!DOCTYPE html> <%--No I18N--%>
<html>
	<head>
		<meta charset="UTF-8">
		<title><%=Util.getI18NMsg(request,"IAM.ZOHO.ACCOUNTS")%></title>
		<% if(isMobile) { %>
		<meta name="viewport" content="width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=no" />
		<% } %>
		<link href="<%=cssurl%>/createOrAssociate.css" type="text/css" rel="stylesheet" /><%-- NO OUTPUTENCODING --%>
		<script src="<%=tpkgurl%>/jquery-3_5_1.min.js" type="text/javascript"></script><%-- NO OUTPUTENCODING --%>
		<script src="<%=tpkgurl%>/select2.full.min.js" type="text/javascript"></script><%-- NO OUTPUTENCODING --%>
		<script src="<%=IAMEncoder.encodeHTMLAttribute(request.getContextPath())%>/static/common.js" type="text/javascript"></script>
		<script src="<%=tpkgurl%>/xregexp-all.js" type="text/javascript"></script><%-- NO OUTPUTENCODING --%>
	</head>

	<body id="body">
		<div class="bg_one"></div>
		<div id="main-all">
			<div id="mainlayout" class="mainlayoutdiv">
				<div class="logo-top zlogo"></div>
    			<div class="title-1"><%=Util.getI18NMsg(request,"IAM.FACEBOOK.CREATE.NEW.ACCOUNT")%></div>
    			<div class="bdre2"></div>
    			<div id="alertMsg">
    				<div id="msg" Style="display:none;"></div><br>
    			</div>
				<div class="welcometxt"><strong><%=Util.getI18NMsg(request,"IAM.CREATE.WELCOME",IAMEncoder.encodeHTML(name))%></strong></div><%-- No I18N --%>

				<div class="title-2"><%=(blockSignup ==false && isOrgInvite == false)? Util.getI18NMsg(request,"IAM.FEDERATED.SIGNIN.WELCOME.TEXT", provider):""%></div>
    			<div id = "creatediv">
    				<div class="profile-img" id="profile-pic" Style="display:none;"><img src="<%=request.getContextPath()+"/images"%>/profile-img.gif" width="120" height="100" /></div> <%-- NO OUTPUTENCODING --%>
    
    				<div id="form-main2">
        				<form name='createAccount' id='createAccount' method='post' action='javascript:void(0);'>
							<div id="errmsg" ></div>
							<% if (isEmailNeeded != null && isEmailNeeded.booleanValue()) { %>
    						<div class="forms">
    							<input type="text" onkeydown="$('.errmsg').hide()" name="email" placeholder="Email" class="forms-input inputElement">
    						</div>
							<div id="email_errmsg" class="errmsg" ></div>    
							<% } %>						
    						<input type='hidden' id="token" name='<%=SecurityUtil.getCSRFParamName(request)%>' value='<%=SecurityUtil.getCSRFCookie(request)%>' /><%-- NO OUTPUTENCODING --%>
    						<%if(isValidDomain){ %>
							<input type='hidden' name='hd-domain' value='<%=IAMEncoder.encodeURL(domain.toString())%>' />
							<%} %>
							<div class="za-country-container">
								<select class="signup-country" name="country" id="country" onchange="handleNewsletterField(this)" placeholder='<%=Util.getI18NMsg(request, "IAM.TFA.SELECT.COUNTRY")%>' >
								<%
								String default_country=Util.getCountryCodeFromRequestUsingIP(request);
								List<ISDCode> isdCodes = SMSUtil.getAllowedISDCodes();
								if(isdCodes == null || isdCodes.isEmpty()) {
									isdCodes = new ArrayList<ISDCode>();
									ISDCode defaultISD = ISDCode.newBuilder().setCountryCode("US").setCountryName("United States").setNewsletterSubscriptionMode(0).build(); //No I18N
									isdCodes.add(defaultISD);
								}
								for(ISDCode isdCode : isdCodes) {
									if(isdCode == null) {
										continue;
									}
								%>
									<option value="<%=isdCode.getCountryCode()%>" <%if(isdCode.getCountryCode().equals(default_country)) {%> selected <%} %>newsletter_mode="<%=isdCode.getNewsletterSubscriptionMode()%>"><%=isdCode.getCountryName()%></option><%-- NO OUTPUTENCODING --%>
								<%
								}
								%>
								</select>
							</div>
							<%
							DCLocation remoteDeployment = DCLUtil.getRemoteDeployment(request);
							boolean showRemote = remoteDeployment!=null && AccountsConfiguration.getConfigurationTyped("fs.multidc.location.choice", false); // No I18N
							String currentCountry = new Locale("",DCLUtil.getLocation().toUpperCase()).getDisplayCountry().toUpperCase();
							if(!hideDC && showRemote) {%>
    						<div style="margin-top:30px;">
								<div class="change_dc"><%=Util.getI18NMsg(request, "IAM.MULTIDC.SIGNUP.DATACENTER.CONTENT", currentCountry)%> <span class="change_dc_btn" onclick="showDcOption(this)"><%=Util.getI18NMsg(request, "IAM.PHOTO.CHANGE")%></span></div>
								<select id="dc_option" class="signup-country" onchange="changeCreate(this,true)" style="display:none">
									<option value=1><%=currentCountry%></option>
									<option value=2><%=new Locale("",remoteDeployment.getDescription().toUpperCase()).getDisplayCountry().toUpperCase()%></option>
								</select>
							</div>
    						<%} %>
							<div class="za-tos-container">
								<label for="agree" class="tos-signup">
									<input tabindex="1" class="za-tos" type="checkbox" id="agree" onclick="$('.errmsg').hide()" name="agree" value="true"/>
									<span class="agree_check"></span>
									<span><%=Util.getI18NMsg(request, "IAM.SIGNUP.AGREE.TERMS.OF.SERVICE", termsOfServiceUrl, privacyPolicyUrl)%></span>
								</label>
							</div>
							<div class="za-newsletter-container">
								<label for="newsletter" class="news-signup">
									<input tabindex="1" class="za-newsletter" type="checkbox" id="newsletter" name="newsletter" value="true"/>
									<span><%=Util.getI18NMsg(request, "IAM.TPL.ZOHO.NEWSLETTER.SUBSCRIBE1")%></span>
								</label>
							</div>

							<div id="check_errmsg" class="errmsg" ></div>

    						<div id = "create" onclick="createNew();"><%=Util.getI18NMsg(request,"IAM.CONTINUE")%></div><%--NO OUTPUTENCODING--%>
        				</div>
					</form>
				</div>
			</div>
		</div>
	</body>

<script type="text/javascript">
	var tokenname = $("#token").attr('name');<%-- No I18N --%>
	var tokenval = $("#token").val();
	var reqInitaited = false;
	
	function redirectLogin() {
		window.location.href = "<%=Util.getIAMURL()%>/signin?servicename=AaaServer&serviceurl="+euc("/home#setting/linkedaccounts");<%-- No I18N --%>  <%-- NO OUTPUTENCODING --%>
		return false;
	}
	
	function showDcOption(ele){
		$(ele).parent().hide();
		$("#dc_option").val($("#dc_option option:contains("+$(".choosed_DC").html()+")").val());
		$(ele).parent().siblings("#dc_option").slideDown(200);	//No I18N
		if(!$("#dc_option").hasClass("select2-hidden-accessible")){
			$("#dc_option").select2({
				minimumResultsForSearch: Infinity
			});
		}
		else{
			$("#dc_option").siblings(".select2").show();
		}
		changeCreate($("#dc_option"),false);
	}
	
	function changeCreate(ele,handleHide){
			if($(ele).val()==2){
				$("#create").attr("onclick","createNewinRemote()"); //No I18N
			}
			else{
				$("#create").attr("onclick","createNew()");	//No I18N
			}
			if(handleHide){
				$("#dc_option").hide();
				$(".change_dc").show();
				$("#dc_option").siblings(".select2").hide();
				$(".choosed_DC").text($(ele).find("option:selected").html());
			}
	}
	window.onload=function() {
		<%if (IAMUtil.isValid(pic_with_logo)) {%>
		$("#profile-pic").html('<img src="<%=IAMEncoder.encodeJavaScript(pic_with_logo.toString())%>"width="120" height="100" alt="" title="" />'); <%-- No I18N --%>
		$("#profile-pic").show();
		<%}%>
		handleNewsletterField(document.getElementById('country'));
		$("#country").select2().on("select2:open", function() {
		       $(".select2-search__field").attr("placeholder", "<%=Util.getI18NMsg(request,"IAM.SEARCHING")%>");//No I18N
		});
	}
	
	function centrePopup(url) {
		var x = 700, y = 600, scroll = 1, resize = 1;
		var posX = (screen.width/2)-(x/2);
		var posY = (screen.height/2)-(y/2);
		var winPref = "width=" + x + ",height=" + y + ",innerWidth=" + x + ",innerHeight=" + y + ",left=" + posX + ",top=" + posY + ",screenX=" + posX + ",screenY=" + posY + ",toolbar=0" + ",location=0,directories=0," + ",resizable=" + resize +",width=" + x + ",height=" + y + ",scrollbars=" + scroll; //No I18N
		var remoteWin = null;
		remoteWin = window.open(url,'new',winPref);
		if (window.focus) {
			remoteWin.focus();
		}
	}
	
	$('#canceldiv').click(function(event){ <%-- No I18N --%>
	 window.location.href = "<%=Util.getIAMURL()%>";<%-- No I18N --%>  <%-- NO OUTPUTENCODING --%>
	});
	
	function createNew() {
		if(!reqInitaited){
			var isError = false;
			$(".errmsg").hide();
			if($("input[name=email]").length)
		    isError = !isEmailId($("input[name=email]").val()); <%-- No I18N --%>
		    if(isError){
	       		$("#email_errmsg").html("<%=Util.getI18NMsg(request, "IAM.ERROR.EMAIL.INVALID")%>"); <%-- No I18N --%>
	       		$("#email_errmsg").show();
	       		return false;
			}
		    if(!isError && !$("input[name=email]").length){
		    	if ($( "#agree" ).prop( "checked")) { 
		    		submitForm();
		    		return false;
		    	}else{
		    		$("#check_errmsg").html("<%=Util.getI18NMsg(request, "IAM.ERROR.TERMS.POLICY")%>");
		    		$("#check_errmsg").show();
		    		return false;
		  	  	}
			}
		    if (!isError) {
		    	if (!$( "#agree" ).prop( "checked")) { 
		    		$("#check_errmsg").html("<%=Util.getI18NMsg(request, "IAM.ERROR.TERMS.POLICY")%>"); <%-- No I18N --%>
		    		$("#check_errmsg").show();
		    		return false;
		    		}
		     }
	      	var param="email="+euc(de("createAccount").email.value);		<%-- No I18N --%>
			sendRequestWithCallback("/accounts/validate/register.ac",param,true,checkresponse);  <%-- No I18N --%>
			return false;
		}
	}
	
	<%
	if(AccountsConfiguration.getConfigurationTyped("fs.multidc.location.choice", false) && remoteDeployment!=null ) { %>
	function createNewinRemote() {
		 var isError = false;
		 $(".errmsg").hide();	<%-- No I18N --%>
			if($("input[name=email]").length)
			isError = !isEmailId($("input[name=email]").val()); <%-- No I18N --%>
			if(isError){
				$("#email_errmsg").html("<%=Util.getI18NMsg(request, "IAM.ERROR.EMAIL.INVALID")%>"); <%-- No I18N --%>
				$("#email_errmsg").show(); //No I18N
				return false;
			}
			if(!isError && !$("input[name=email]").length){
				if ($( "#agree" ).prop( "checked")) {
					submitFormForRemote();
					return false;
				}else{
					$("#check_errmsg").html("<%=Util.getI18NMsg(request, "IAM.ERROR.TERMS.POLICY")%>"); <%-- No I18N --%>
					$("#check_errmsg").show(); <%-- No I18N --%>
					return false;
				}
			}
		    if (!isError) {
				if (!$( "#agree" ).prop( "checked")) {
					$("#check_errmsg").html("<%=Util.getI18NMsg(request, "IAM.ERROR.TERMS.POLICY")%>"); <%-- No I18N --%>
					$("#check_errmsg").show(); <%-- No I18N --%>
					return false;
					}
			}
			var param="email="+euc(de("createAccount").email.value);	<%-- No I18N --%>
	 		sendRequestWithCallback("<%=remoteDeployment.getServerUrl()%>" + "/accounts/validate/register.ac",param,true,checkresponseForRemote); <%-- NO OUTPUTENCODING --%><%--No I18n--%>
			return false;
	}
	
	function submitFormForRemote(){
		de("createAccount").setAttribute("action", location.protocol + "//" + location.host + "/accounts/fschoose.dc?choose=<%=remoteDeployment.getLocation().toLowerCase()%>"); <%-- NO OUTPUTENCODING --%><%--No I18N--%>
		de("createAccount").submit(); //No I18N
		return true;
	}
	
	function checkresponseForRemote(res){
		var obj = JSON.parse(res);
		if(obj.error && obj.error.email){
			$("#errmsg").html(obj.error.email); <%-- No I18N --%>
	        $("#errmsg").show(); <%-- No I18N --%>
            return false;
		}
		submitFormForRemote();
	}

	function submitDataForRemote() {
		var f = document.createAccount;
		var remoteDCLocation = "<%=IAMEncoder.encodeJavaScript(remoteDeployment.getLocation().toLowerCase())%>";
		var params = '<%=SecurityUtil.getCSRFParamName(request)+"="+SecurityUtil.getCSRFCookie(request)%>'; //NO OUTPUTENCODING
		params += "&choose="+ euc(remoteDCLocation); //No I18N
		if(f.country) {
			params += "&country=" + euc(f.country.value); //No I18N
		}
		if(f.newsletter) {
			params += "&newsletter=" + euc(f.newsletter.checked); //No I18N
		}
		<%if(isValidDomain){ %>
			params += "&hd-domain=" + euc(f.hd-domain.value); //No I18N 
		<%}%>
		if(f.email && f.email.value !== '') {
			params += "&email=" + euc(f.email.value); //No I18N
		}
		sendRequestWithCallback("<%=request.getContextPath()%>/accounts/fschoose.dc", params, true, fschooseRemoteResponse);
	}
	
	function fschooseRemoteResponse(data) {
		var hasError = false;
		try {
			var jsonData = JSON.parse(data);
			if(jsonData) {
				if(jsonData.result == "true") {
					window.parent.location = jsonData.redirect_uri;
				} else if(jsonData.error == "access_denied_for_self_dc") { //No I18N
					submitForm();
				} else {
					hasError = true;
				}
			} else {
	        	hasError = true;
			}
		}catch (e) {
			hasError = true;
		}
		if(hasError == true) {
			$("#errmsg").html('<%=Util.getI18NMsg(request, "IAM.FEDERATED.SIGNIN.ERROR")%>');
        	$("#errmsg").show();
		}
	}
	
	<%}%>
	
	function checkresponse(res){
		var obj = JSON.parse(res);
		if(obj.error && obj.error.email)
		{
			$("#errmsg").html(obj.error.email); <%-- No I18N --%>
	        $("#errmsg").show();
            return false;
		}
		submitForm();
	}
	
	function submitForm() {
		reqInitaited = true;
		de("createAccount").setAttribute("action", location.protocol + "//" + location.host + "/accounts/fschoose.dc?choose=<%=DCLUtil.getLocation().toLowerCase()%>"); <%-- NO OUTPUTENCODING --%><%--No I18N--%>
		de("createAccount").submit(); //No I18N
		return true;
	}
	

	$('.forms-input').keypress(function(e) {
        if(e.which == 13) {
    		if(de('create')){
    			createNew();
    		}
    		else if(de('createremote')){
    			createNewinRemote();
    		}else{
    			associate();
    		}
        }else{
        $('#errmsg').hide();
        }
    });
	
	
	function switchTo(jsonResponse){
		var obj = JSON.parse(jsonResponse);
		if(obj.status == "success"){
	    window.parent.location = obj.url;
	    return false;
		}else{
			$("#errmsg").html(obj.error_msg);
			$('#errmsg').show();
		}
	    return true;
	}

	function handleNewsletterField(selectElement) {
		var SHOW_FIELD_WITH_CHECKED = <%=AccountsInternalConst.NewsLetterSubscriptionMode.SHOW_FIELD_WITH_CHECKED.getType()%>;<%-- NO OUTPUTENCODING --%>
		var SHOW_FIELD_WITHOUT_CHECKED = <%=AccountsInternalConst.NewsLetterSubscriptionMode.SHOW_FIELD_WITHOUT_CHECKED.getType()%>;<%-- NO OUTPUTENCODING --%>
		var DOUBLE_OPT_IN = <%=AccountsInternalConst.NewsLetterSubscriptionMode.DOUBLE_OPT_IN.getType()%>;<%-- NO OUTPUTENCODING --%>
		if(selectElement) {
				var optionEle = selectElement.selectedOptions[0];
				var countryCode = optionEle.value;
				var newsletter_mode = optionEle.getAttribute("newsletter_mode");
				if(newsletter_mode == SHOW_FIELD_WITH_CHECKED) {
			        $('#newsletter').prop('checked', true); //No I18N
			        $('.za-newsletter-container').css('display',''); //No I18N
				} else if(newsletter_mode == SHOW_FIELD_WITHOUT_CHECKED || newsletter_mode == DOUBLE_OPT_IN) {
			        $('#newsletter').prop('checked', false); //No I18N
			        $('.za-newsletter-container').css('display',''); //No I18N
				} else {
			        $('#newsletter').prop('checked', true); //No I18N
			        $('.za-newsletter-container').css('display','none'); //No I18N
				}
			}
	}

	function doGet(action, params) {
	    var objHTTP;
	    objHTTP = xhr();
		objHTTP.open('GET', action + "?" + params, false);	//No I18N
	    objHTTP.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded;charset=UTF-8');	//No I18N
	    objHTTP.send(params);
	    return objHTTP.responseText;
	}

	function xhr() {
	    var xmlhttp;
	    if (window.XMLHttpRequest) {
		xmlhttp=new XMLHttpRequest();
	    }
	    else if(window.ActiveXObject) {
		try {
		    xmlhttp=new ActiveXObject("Msxml2.XMLHTTP");
		}
		catch(e) {
		    xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
		}
	    }
	    return xmlhttp;
	}
</script>
</html>
