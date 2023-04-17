
<%--$Id$--%>
<!doctype html>
<%@page import="com.zoho.accounts.AccountsConstants.IdentityProvider"%>
<%@page import="com.zoho.resource.util.ThreadLocalObjects"%>
<%@page import="com.zoho.accounts.actions.unauth.DCLHandshakeAction"%>
<%@page import="org.json.JSONObject"%>
<%@page import="com.zoho.accounts.internal.announcement.Announcement"%>
<%@page import="com.zoho.accounts.internal.util.AccountsInternalConst"%>
<%@page import="com.adventnet.iam.IAMUtil"%>
<%@page import="com.adventnet.iam.xss.IAMEncoder"%>
<%@page import="com.adventnet.iam.internal.Util"%>
<%@page import="com.adventnet.iam.security.SecurityUtil"%>
<%@page import="com.zoho.accounts.internal.fs.FSConsumerUtil"%>
<%@include file="../../static/includes.jspf" %>


<html>
	<head>
	<meta charset="UTF-8">
	<title>Sign In</title><%-- No I18N --%>
	<style type="text/css">
	body {
	margin: 0px;
	padding:0px;
	font-family:"Open sans";
	font-size:13px;
	color:#141823;
	}
	</style>
	</head>
	<script src="<%=request.getContextPath() + "/static"%>/common.js" type="text/javascript"></script> <%-- NO OUTPUTENCODING --%>
	<script src="<%=jsurl%>/jquery-1.12.2.min.js" type="text/javascript"></script><%-- NO OUTPUTENCODING --%>
	
	<%
	Boolean isZohoIDP = (Boolean) request.getAttribute("isZohoIDP");
	isZohoIDP = isZohoIDP != null ? isZohoIDP.booleanValue() : true;
	String name = (String) request.getAttribute(FSConsumerUtil.OAUTH_NAME);
	Object pic_with_logo =request.getAttribute(FSConsumerUtil.OAUTH_PIC_URL);
    String emailId = (String) request.getAttribute("emailId");
	Object domain = request.getAttribute("hd-domain");
	JSONObject tempTokenDetails = Util.getTempAuthTokenDataFromThreadLocal();
	
	if(tempTokenDetails==null){
		if(DCLHandshakeAction.getFromState("fsjson") != null) {
			tempTokenDetails = new JSONObject(DCLHandshakeAction.getFromState("fsjson")); //No I18N
		} else if(ThreadLocalObjects.getThreadLocal("fs_native_token") != null) { //Cases like native signin where FS deatils will not present in cookie //No I18N
			tempTokenDetails = (JSONObject) ThreadLocalObjects.getThreadLocal("fs_native_token"); //No I18N
		}
	}
	String provider = tempTokenDetails.has("provider") ? tempTokenDetails.getString("provider") : (String)request.getAttribute("provider");//No I18N
	String servicename = tempTokenDetails.optString("servicename");//No I18N
	String serviceurl = tempTokenDetails.optString("serviceurl");//No I18N
	String returnurl = Util.getBackToURL(servicename, serviceurl);
	boolean isValidDomain = false;
	if (Util.isValid(domain)) {
		isValidDomain = true;
	}
	boolean idpDomain = true;	
	boolean isMobile = Util.isMobileUserAgent(request);
	String cssUrl = request.getContextPath() +"/static"+(isMobile?"/federated_signin_mobile.css":"/federated_signin.css"); // No I18N
	String callbackurl = returnurl;
%>
	<link href="<%=cssUrl%>" type="text/css" rel="stylesheet" /><%-- NO OUTPUTENCODING --%>
	
	<body id="body">
	<div id="main-all">
	<div id="maindiv" style="margin:1% auto; display:table; text-align:center;">
	<div class="logo-top"></div>
	<div class="title-1"><%=Util.getI18NMsg(request,"IAM.FACEBOOK.ASSOCIATE")%></div>
	<div class="bdre2"></div>
	<div class="title-2"><b><%=Util.getI18NMsg(request,"IAM.HELLO")%>, <%=IAMEncoder.encodeHTML(name)%></b> <br><%=Util.getI18NMsg(request,"IAM.FEDERATED.SIGNIN.EMAIL.ALREADY.REGISTERED",emailId)%> <%=isZohoIDP?Util.getI18NMsg(request,"IAM.FEDERATED.SIGNIN.TYPE.PASSWORD.TO.ASSOCIATE"):Util.getI18NMsg(request,"IAM.FEDERATED.SIGNIN.VERIFY.CODE") %></div>
	<div class="profile-img" id="profile-pic"><img src="<%=request.getContextPath()+"/images"%>/profile-img.gif" width="130" height="110" /></div> <%-- NO OUTPUTENCODING --%>
	<%if(!isZohoIDP){ %>
	<div id="form-main2">
	<div id="errmsg_1"></div>
	
	<div class="forms"><input type="text" placeholder="Verification Code" id="input" class="forms-input"></div>
	<div id="resendcode"><a href="#"><%=Util.getI18NMsg(request,"IAM.TFA.RESEND.CODE")%></a></div><%-- No I18N --%>
	<input type='hidden' id="token" name='<%=SecurityUtil.getCSRFParamName(request)%>' value='<%=SecurityUtil.getCSRFCookie(request)%>' /><%-- NO OUTPUTENCODING --%>
	
	<div id="verify_cancel">
	<div id="verify" onclick="verifyAccount()";><%=Util.getI18NMsg(request,"IAM.FEDERATED.SIGNIN.VERIFY")%></div><%-- No I18N --%>
	<div id="cancel"><%=Util.getI18NMsg(request,"IAM.CANCEL")%></div><%-- No I18N --%>
	</div>
	
	
	
	<div style="margin:2% auto; display: inline-flex;">
	</div>	
	</div>
	<%}else{ %>
	
    <div id="form-main2">
    	<div id="errmsg_1" ></div>
    
    	<div class="forms_1"><input type="text" value="<%=request.getAttribute("emailId")%>" class="forms-input-1" disabled>  <%-- NO OUTPUTENCODING --%>
    	<input type="password" placeholder="Password"  id="input" class="forms-input-1"></div>
    	<input type='hidden' id="token" name='<%=SecurityUtil.getCSRFParamName(request)%>' value='<%=SecurityUtil.getCSRFCookie(request)%>' /><%-- NO OUTPUTENCODING --%>
        
     
    <div id="verify_cancel_1">
	<div id="verify" onclick="associate()";><%=Util.getI18NMsg(request,"IAM.FEDERATED.SIGNIN.ASSOCIATE")%></div><%-- No I18N --%>
	<div id="cancel"><%=Util.getI18NMsg(request,"IAM.CANCEL")%></div>
	</div>           
        
	</div>
        
	<%} %>
	
	<%if(!Util.isFujixerox()){%>
    <div class="footer">
		<span>&copy; <%=Util.getCopyRightYear()%>,&nbsp;<a href="<%=Util.getI18NMsg(request,"IAM.ZOHOCORP.LINK")%>" title="<%=Util.getI18NMsg(request,"IAM.ZOHOCORP")%>" target="_blank" style="color:#085ddc;"><%=Util.getI18NMsg(request,"IAM.ZOHOCORP")%></a>&nbsp;<%=Util.getI18NMsg(request,"IAM.ADVENTNET.ALL.RIGHTS.RESERVED")%></span><%-- NO OUTPUTENCODING --%><%--No I18N--%>
	</div>
	<%}%>
	
	</div>
	</div>
	</body>
	<script type="text/javascript">
	var tokenname = $("#token").attr('name');<%-- No I18N --%>
	var tokenval = $("#token").val();

	$('#resendcode').click(function(event){ <%-- No I18N --%>
	sendRequestWithCallback("/u/resendConfirmationMail",tokenname+"="+tokenval+"&name="+'<%=IAMEncoder.encodeHTML(name)%>'+"&email="+'<%=IAMEncoder.encodeJavaScript(emailId)%>',true,displayMsg); <%-- No I18N --%>
	});
	
	$('#cancel').click(function(event){ <%-- No I18N --%>
	 window.location.href = "<%=IAMEncoder.encodeJavaScript(returnurl)	%>";<%-- No I18N --%>  <%-- NO OUTPUTENCODING --%>
	});

	
	function displayMsg(jsonResponse){
		try{
		var obj = JSON.parse(jsonResponse);
		$('#errmsg_1').html(obj.message);<%-- No I18N --%>
		$('#errmsg_1').css("background-color",'#21CA16');<%-- No I18N --%>
		$('#errmsg_1').css("border", "none"); <%-- No I18N --%>
		$('#errmsg_1').show();<%-- No I18N --%>
		$('#errmsg_1').fadeOut(2000);<%-- No I18N --%>		
	}catch(e){
			document.cookie = '<%=AccountsInternalConst.TMP_TOKEN_COOKIE_NAME%>' + '=;expires=Thu, 01 Jan 1970 00:00:01 GMT;';<%-- NO OUTPUTENCODING --%>
			window.location.href = "<%=IAMEncoder.encodeJavaScript(returnurl)	%>";  <%-- NO OUTPUTENCODING --%>
	}
	}


	function associate(){
		var password = document.getElementById("input").value;
		if(!isValidPassword(password)){
			$('#errmsg_1').html('<%=Util.getI18NMsg(request,"IAM.ERROR.INVALID_PASSWORD")%>');<%-- No I18N --%>
			$('#errmsg_1').show();
			return false;
		}
		sendRequestWithCallback("/u/verifyPassword","password="+euc(password)+"&"+tokenname+"="+tokenval+'<%=isValidDomain?"&hd-domain="+IAMEncoder.encodeURL(domain.toString()):""%>',true,switchTo); <%-- No I18N --%>
	    return false;
	}
	
	function isValidPassword(password){
		if(password.length<3){
			return false;
		}
		return true;
	}

	function verifyAccount(e){
		var code = $(".forms-input").val();
		if( /[^a-zA-Z0-9\-\/]/.test( code ) ) {
			$('#errmsg_1').css("background-color",'#FF6A6A');<%-- No I18N --%>
			$("#errmsg_1").html("<%=Util.getI18NMsg(request,"IAM.PHONE.INVALID.VERIFY.CODE")%>");
			$('#errmsg_1').show();
			return false;
		}
		sendRequestWithCallback("/u/verifyCode","code="+code+"&"+tokenname+"="+tokenval+'<%=isValidDomain?"&hd-domain="+IAMEncoder.encodeURL(domain.toString()):""%>',true,switchTo); <%-- No I18N --%>
	    return false;
	}
	
	function switchTo(jsonResponse){
		<%
			if(IdentityProvider.AZURE.name().equalsIgnoreCase(provider)){
				JSONObject userFSResponse = Util.convertToJson(tempTokenDetails.optString(FSConsumerUtil.FS_RESPONSE));
				callbackurl = FSConsumerUtil.validateAndGetAzureServiceUrl(AccountsConstants.IdentityProvider.AZURE, serviceurl, servicename, userFSResponse != null ? userFSResponse.optString(FSConsumerUtil.OAUTH_TENANT_ID) : "");//No I18N
			}
		%>
		try{
			var obj = JSON.parse(jsonResponse);
			console.log(obj.url);
			if(obj.status == "success"){
			    window.parent.location = obj.url;
			    return false;
			}else{
				$('#errmsg_1').css("background-color",'#FF6A6A');<%-- No I18N --%>
				$("#errmsg_1").html(obj.error_msg);
				$('#errmsg_1').show();
			}
		}catch(e){
			window.location.href = "<%=IAMEncoder.encodeJavaScript(callbackurl)%>";  <%-- NO OUTPUTENCODING --%>
		}
	    return true;
	}
	
	$(document).ready(function() {
		<%if (IAMUtil.isValid(pic_with_logo)) {%>
		$("#profile-pic").html('<img src="<%=IAMEncoder.encodeJavaScript(pic_with_logo.toString())%>"width="130" height="110" alt="" title="" />'); <%-- No I18N --%>
		<%}%>
	});

	
	$('#input').keypress(function(e) {
        if(e.which == 13) {
    		if(de('resendcode')){
    			verifyAccount(e);
    		}else{
    			associate();
    		}
        }else{
        $('#errmsg_1').hide();
        }
    });
	
	
	</script>
	</html>
	