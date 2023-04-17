<%--$Id$--%>
<%@page import="com.adventnet.iam.security.IAMSecurityException"%>
<%@ include file="../../static/includes.jspf" %>
<!DOCTYPE html> <%-- No I18N --%>
<html>
    <head>
	<title><%=Util.getI18NMsg(request,"IAM.RESETPASS.TITLE")%></title>
	<link href="<%=cssurl%>/style.css" type="text/css" rel="stylesheet" /> <%-- NO OUTPUTENCODING --%>
    </head>
    <body>  
   <script src="<%=jsurl%>/jquery-1.12.2.min.js" type="text/javascript"></script><%-- NO OUTPUTENCODING --%>
<script src="<%=request.getContextPath()%>/static/common.js" type="text/javascript"></script> <%-- NO OUTPUTENCODING --%>
<script>
    var msg = '<%=IAMEncoder.encodeJavaScript((String)request.getAttribute("msg"))%>';
    var pp = '<%=IAMEncoder.encodeJavaScript((String)request.getAttribute("passInfo"))%>';
</script> 
<%	
    PasswordPolicy pp = null;
    int minPassLength=-1;
    int maxPassLength=-1;
    int minsplCharLength=0;
    int minnumericLength=0;
    int passHistory=-1;
    boolean mixed_case=false;

    User user = (User)request.getAttribute("USER");
    if(user != null && user.getZOID() != -1){ pp = Util.USERAPI.getPasswordPolicy(user.getZUID()+"");}
    if(pp != null){
	minPassLength = pp.getMinimumPasswordLength();
	maxPassLength = pp.getMaximumPasswordLength();
	minsplCharLength = pp.getMinimumSpecialChars();
	minnumericLength = pp.getMinimumNumericChars();
	passHistory = pp.getNumberOfPasswordsToRember();
	mixed_case = pp.isMixedCaseEnforced();
    } else {
    	minPassLength = Util.getUserPasswordDefaultMinLength();
    	maxPassLength = Util.getUserPasswordDefaultMaxLength();
    	passHistory = IAMUtil.getInt(AccountsConfiguration.getConfiguration("min.password.history","1")); //No I18N
    }
    String redirectURL = Util.isFujixerox() ? Util.getRedirectURL(request) : (String)request.getAttribute("serviceurl");
    if(AccountsConfiguration.getConfigurationTyped("enable.password.backto", true) && Util.isMobileUserAgent(request)){//No I18N
    	if(request.getHeader("Referer")!=null){//No I18N
    		redirectURL = request.getHeader("Referer");//No I18N  
        	request.getSession().setAttribute("fp_backtourl", redirectURL);//No I18N
    	} else if(request.getAttribute("fp_backtourl")!=null) {//No I18N
    		redirectURL = (String) request.getSession().getAttribute("fp_backtourl");//No I18N
    	}
    }
    long zuid = user != null ? user.getZUID() : -1 ;
    redirectURL = Util.isValid(redirectURL) && IAMUtil.isTrustedDomain(zuid, redirectURL)? redirectURL : Util.getIAMURL();

    String portalid = request.getParameter("portal_id");
    String portalName = request.getParameter("portal_name");
    String portalDomain = request.getParameter("portal_domain");
%>
	<div  id="maindiv" style="width: 800px;margin: auto;">
		<div >
			<div class="maindiv">
				<%
				if(Util.isValid(portalid)) {
					String logourl = IAMProxy.getContactsServerURL(true) + "/static/file?t=org&ID=" + portalid + "&nocache=" + System.currentTimeMillis(); //No I18N
				%>
				<table align="center" cellspacing="0" cellpadding="0" border="0"><tr><td valign="top">
					<img src="<%=IAMEncoder.encodeHTMLAttribute(logourl)%>" height="46" style="margin: 30px auto;"/>
				</td></tr></table>
				<%
				} else if(Util.isValid(portalDomain)) {
					String logourl = IAMProxy.getContactsServerURL(true) + "/static/file?t=org&domain=" + portalDomain + "&nocache=" + System.currentTimeMillis(); //No I18N
				%>
				<table align="center" cellspacing="0" cellpadding="0" border="0"><tr><td valign="top">
					<img src="<%=IAMEncoder.encodeHTMLAttribute(logourl)%>" height="46" style="margin: 30px auto;"/>
				</td></tr></table>
				<% } else { %>
				<div class="<%=IAMEncoder.encodeHTMLAttribute(Util.isValid(portalName) ? portalName +" logo-top" : "logo-top")%>" style="margin: 30px auto;"></div>
				<% } %>
				
				<div class="title-1" style="text-align: center"><span><%=Util.getI18NMsg(request, "IAM.RESETPASS.TITLE")%></span></div>
				<div class="bdre2"></div>
				<div id="title2" style="text-align: center;font-size: 13px;"><%=Util.getI18NMsg(request, "IAM.RESETPASS.SUBTITLE")%></div>
				<div style="margin-left:8%;margin-top:4%">
			    <div id="password">
				<div id="errmsgpanel" style="text-align: center;margin-left:199px;width: 300px" class="hide"></div>
				<form name=password onsubmit="return resetpassword(this);" method="post">
				    <div id="phrase" class="label"style="margin-bottom:16px;">
					<div class="inlineLabel"><%=Util.getI18NMsg(request, "IAM.SECUR.QUESTION")%>  </div>
					<div class="inputText" style="margin-top:2px;"><span id="question"></span> ?</div>
				    </div>
				    <div id="ans" class="label" style="margin-left: 200px; ">
					<div class="inlineLabel hide" style="position:absolute"><%=Util.getI18NMsg(request, "IAM.ANSWER")%>  </div>
					<input type="text" class="unauthinputText" name="ans" id="answer" onkeypress="closemsg()" onkeyup="animatePlaceHolder(this,'','-155px');" placeholder='<%=Util.getI18NMsg(request, "IAM.ANSWER")%>'>
				    </div>
				    <div  class="label" style="margin-left: 200px; ">
					<div class="inlineLabel hide" style="position:absolute"><%=Util.getI18NMsg(request, "IAM.PASSWORD")%> </div>
					<input type="password" class="unauthinputText" id="pwd" name="pwd" onkeypress="closemsg()" onkeyup="animatePlaceHolder(this,'','-155px');" placeholder='<%=Util.getI18NMsg(request, "IAM.PASSWORD")%> '>
				    </div>
				    <div class="label" style=" margin-left: 200px;">
						<div class="inlineLabel hide" style="position:absolute"><%=Util.getI18NMsg(request, "IAM.CONFIRM.PASS")%>  </div>
						<input type="password" class="unauthinputText" name="cpwd" onkeypress="closemsg()" onkeyup="animatePlaceHolder(this,'','-155px');" placeholder='<%=Util.getI18NMsg(request, "IAM.CONFIRM.PASS")%>'>
				    </div>
				   <div class="label" style="margin-top: -19px;">
						<div class="inlineLabel"></div>
						<label for="signoutfromweb">
							<a href="javascript:checkMobileWeb('signoutfromweb','signoutweb');" onkeypress="if(event.keyCode == 13||event.keyCode == 32){checkMobileWeb('signoutfromweb','signoutweb');}" style="outline:none" onfocus="setFocus(de('signoutfromweb'),'signoutweb')" onkeydown="removeFocus(de('signoutfromweb'),'signoutweb')">
								<input type=checkbox name="signoutfromweb" id="signoutfromweb" class="hide"/>
								<span class="icon-medium check-unchecked" id="signoutweb" style="margin-left: 3px;"></span>
								<div class="inputText" style="border:none; padding:1px 0px 0px;"><%=Util.getI18NMsg(request,"IAM.RESET.PASSWORD.SIGNOUT.WEB")%></div>
							</a>
						</label>
					</div>
					<div class="label" style="margin-top: -19px;">
						<div class="inlineLabel"></div>
						<label for="signoutfrommobile">
							<a href="javascript:checkMobileWeb('signoutfrommobile','signoutmobile')" onkeypress="if(event.keyCode == 13||event.keyCode == 32){checkMobileWeb('signoutfrommobile','signoutmobile');}" style="outline:none" onfocus="setFocus(de('signoutfrommobile'),'signoutmobile')" onkeydown="removeFocus(de('signoutfrommobile'),'signoutmobile')">
								<input type=checkbox name="signoutfrommobile" id="signoutfrommobile" class="hide">
								<span class="icon-medium check-unchecked" id="signoutmobile" style="margin-left: 3px;"></span>
								<div class="inputText" style="width: 56%;border:none; padding:1px 0px 0px;"><%=Util.getI18NMsg(request,"IAM.RESET.PASSWORD.SIGNOUT.MOBILE")%></div>
							</a>
						</label>
					</div>
					<div class="label" id="signoutinfo" style="display: none; margin-top: -20px;">
						<div class="inlineLabel"></div>
							<div class="inputText noteL" style="padding: 2px 6px; line-height: 24px; border: 1px solid #f3f3f3;width: 57%;background-color:#feff98;font-size: 13px;border:none;"><%=Util.getI18NMsg(request,"IAM.RESET.PASSWORD.SIGNOUT.FROMALL.DEVICES.FULL.DETAILS.NEW")%></div>
					</div>
					
				    <div class="label">
					<div class="inlineLabel"></div>
					   <span class="redBtn"  style="padding:8px 29px;font-size: 14px;" onclick="resetpassword(document.password)"><%=Util.getI18NMsg(request, "IAM.PASSWORD.CHANGE")%></span>
                       <span class="cancel-btn" style="padding:8px 29px;font-size: 14px" onclick="javascript:window.location.href='<%=IAMEncoder.encodeJavaScript(redirectURL)%>';"><%=Util.getI18NMsg(request,"IAM.CANCEL")%></span>
				    </div>
				    <div class="tipmessage"  onclick="hidetipMessage('passpolicy')" style=" margin-left: 198px; "></div>
				<div class="passpolicy noteL" style=" margin-left: 23%; margin-top: 7%;">
				<%if(pp != null) {%>
				<div>
					<span class="passpolicyicon"></span>
					<span><%=Util.getI18NMsg(request, "IAM.PASSWORD.POLICY.LOGINNAME")%></span>
		    	</div>
		    	<div>
					<span class="passpolicyicon"></span>
					<span><%=Util.getI18NMsg(request, "IAM.PASSWORD.POLICY.MAXIMUMLENGTH", maxPassLength)%></span>
		    	</div>
		    	<div>
					<span class="passpolicyicon" ></span>
					<span><%=Util.getI18NMsg(request, "IAM.PASSWORD.POLICY.MINIMUMLENGTH", minPassLength)%></span>
		    	</div>
				    <%if(minsplCharLength != 0) {%>
				    <div>
						<span class="passpolicyicon"></span>
						<span><%=Util.getI18NMsg(request, "IAM.PASSWORD.POLICY.MINSPECIALCHAR", minsplCharLength)%></span>
		    		</div>
				    <%} if(minnumericLength != 0) {%>
				    <div>
						<span class="passpolicyicon"></span>
						<span><%=Util.getI18NMsg(request, "IAM.PASSWORD.POLICY.MINNUMERICCHAR", minnumericLength)%></span>
		    		</div>
				    <%} if(mixed_case) {%>
				    <div>
						<span class="passpolicyicon"></span>
						<span><%=Util.getI18NMsg(request, "IAM.PASSWORD.POLICY.MIXED_CASE")%></span>
		    		</div>
				    <%} if(passHistory != -1) {%>
				    <div>
						<span class="passpolicyicon"></span>
						<span><%=Util.getI18NMsg(request, "IAM.PASSWORD.POLICY.PASS_HISTORY", passHistory)%></span>
		    		</div>
				    <%}%>
				<%} else {%>
				<div>
						<span class="passpolicyicon"></span>
						<span><%=Util.getI18NMsg(request, "IAM.RESETPASS.PASSWORD.NOTE1", minPassLength, maxPassLength)%></span>
		    	</div>
		    	<div>
						<span class="passpolicyicon"></span>
						<span><%=Util.getI18NMsg(request, "IAM.RESETPASS.PASSWORD.NOTE2")%></span>
		    	</div><div>
						<span class="passpolicyicon"></span>
						<span><%=Util.getI18NMsg(request, "IAM.RESETPASS.PASSWORD.NOTE3")%></span>
		    	</div>
		    		<% if(passHistory != -1) {%>
				    <div>
						<span class="passpolicyicon"></span>
						<span><%=Util.getI18NMsg(request, "IAM.PASSWORD.NOT.LAST")%></span>
		    		</div>
				    <%}%>
		    	
				<%}%>
				</div>
				</form>
			    </div>

			    <div id="msgboard" class="hide" style="color:#333;background: none;  margin-left: -43px; margin-bottom: 25%;font-size: 12px">
			    <div class="successicon"></div>
				<span><%=Util.getI18NMsg(request,"IAM.FORGOT.UPDATE.PASS")%>&nbsp;&nbsp;</span>
                                <a href="<%=IAMEncoder.encodeHTMLAttribute(redirectURL)%>" style="color: #478ed8;"><%=Util.getI18NMsg(request,"IAM.CONFIRMATION.CONTINUE")%></a>
			    </div>

			    </div>
			    </div>
			</div>
		</div>
	<div><%@ include file="../unauth/footer.jspf" %></div> 
    </body>
</html>
<script>
    var timeout;
    function resetpassword(f) {
	var pwdlen=f.pwd.value.trim().length;
	if((pp != 'null' && f.answer.value == "")) {
	    showmsg('<%=Util.getI18NMsg(request,"IAM.FORGOT.ANSQUES")%>');
	    f.answer.focus();
	    return false;
	}

	if(f.pwd.value.trim() == "") {
	    showmsg('<%=Util.getI18NMsg(request,"IAM.ERROR.ENTER.LOGINPASS")%>');
	    f.pwd.focus();
	    return false;
	}
	if(pwdlen < <%=minPassLength%>) {
	    showmsg('<%=Util.getI18NMsg(request,"IAM.ERROR.PASS.LEN", minPassLength)%>');
	    f.pwd.value="";
	    f.cpwd.value="";
	    f.pwd.focus();
	    return false;
	}
	if(pwdlen > <%=maxPassLength%>) {
	    showmsg('<%=Util.getI18NMsg(request,"IAM.ERROR.PASSWORD.MAXLEN", maxPassLength)%>');
	    f.pwd.value="";
	    f.cpwd.value="";
	    f.pwd.focus();
	    return false;
	}
	if(f.pwd.value.trim() != f.cpwd.value.trim()) {
	    showmsg('<%=Util.getI18NMsg(request,"IAM.ERROR.WRONG.CONFIRMPASS")%>');
	    f.pwd.value="";
	    f.cpwd.value="";
	    f.pwd.focus();
	    return false;
	}
	var params = 'pwd='+euc(f.pwd.value.trim()) + '&uid=<%=IAMEncoder.encodeJavaScript(request.getParameter("uid"))%>'; //No I18N
	if(pp != 'null') {
	    params = params + "&ans="+ euc(f.answer.value);//No I18N
	}
	 var csrfParam = '<%=SecurityUtil.getCSRFParamName(request)+"="+SecurityUtil.getCSRFCookie(request)%>';<%-- NO OUTPUTENCODING --%>
	params+="&removewebsessions="+euc(f.signoutfromweb.checked)+"&removedevicesessions="+euc(f.signoutfrommobile.checked)+"&"+csrfParam;//No I18N
	var result = getPlainResponse("<%=request.getContextPath()%>/password/reset", params); <%-- NO OUTPUTENCODING --%> <%-- No I18N --%>
	result = result.trim();
	if(result == 'success') {
	    de('password').className = "hide";
	    de('msgboard').className = "successmsg";
	    de('title2').className = "hide";
	}
	else if(result == 'invalid_answer') {
	    showmsg('<%=Util.getI18NMsg(request,"IAM.FORGOT.INVALID.ANS")%>');
	    f.ans.focus();
	}
	else if(result == 'loginName_same') {
	    showmsg('<%=Util.getI18NMsg(request,"IAM.PASSWORD.POLICY.LOGINNAME")%>');
	    f.pwd.focus();//No I18N
	}
	else if(result == "<%=IAMSecurityException.URL_ROLLING_THROTTLES_LIMIT_EXCEEDED%>") {   <%-- NO OUTPUTENCODING --%>
        showmsg('<%=Util.getI18NMsg(request, "IAM.MANY.ATTEMPTS")%>');
	}
	else {
	    showmsg(result);//No I18N
	    f.pwd.focus();//No I18N
	}
	return false;//No I18N
    }
    
    function showmsg(msg) {
	de('errmsgpanel').className = "errormsgnew"; //No I18N
	de('errmsgpanel').innerHTML = msg; //No I18N
    }
    function closemsg() {de('errmsgpanel').className='hide';}
    
    function showFailure(cause) {showmsg(cause);}
    
    if(msg != 'null'){showmsg(msg);}
    if(pp != 'null' && pp != ""){
	de('question').innerHTML = pp;
	de('answer').focus();//No I18N
    }
    else {
	de('phrase').style.display='none';//No I18N
	de('ans').style.display='none';//No I18N
	de('pwd').focus();//No I18N
    }
    function signOutfromalldevicesmsg(ele, msg){
    	jQuery('#message').text(msg); //No I18N
    	var msgEle = de('message');//No I18N
    	de('message').style.display='block';
    	msgEle.style.top = ((jQuery(ele).offset().top)-15)+'px';
    	msgEle.style.left = ((jQuery(ele).offset().left)+20)+'px';
    }
    function hidedetail(){
    	de('message').style.display='none';
    	de('message').innerHTML='';//No I18N
    }
    window.onload = function() {
    	$('#password input[placeholder]').zPlaceHolder();
    	$('.zph-overlay').css("padding-top", "27px"); //No I18N
    	$('.inlineLabel').css("margin-top", "8px"); //No I18N
    	var offset = $(window).innerHeight() - ($('#maindiv').outerHeight() + 100);
    	if(offset > 0){
        $('#maindiv').css("margin-bottom", offset +'px'); //No I18N
    	}
    }
    window.onresize = function() {
    	var offset = $(window).innerHeight() - ($('#maindiv').outerHeight() + 100);
    	if(offset > 0){
        $('#maindiv').css("margin-bottom", offset +'px'); //No I18N
    	}
    };
</script>
