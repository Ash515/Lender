<%--$Id$--%>
<%@page import="com.zoho.accounts.actions.unauth.JCaptcha"%>
<%@ include file="../../static/includes.jspf" %>
<%
    String cdigest = JCaptcha.getCaptchaDigest();
    User user = IAMUtil.getCurrentUser();
    String serviceUrl = Util.getTrustedURL(user.getZUID(), request.getParameter("servicename"), request.getParameter("serviceurl"));
    if(user.getZohoID() != null && user.isLoginNameExists()) {
    	response.sendRedirect(serviceUrl);
    	return;
    }
    boolean verifyCaptcha = !user.isCaptchaEntered();
    String referer = request.getHeader("Referer");
    boolean isPageLoadedAsIFrame = Util.isValid(referer) ? referer.contains(request.getServerName()) : false;
    boolean isMobile = !isPageLoadedAsIFrame && Util.isMobileUserAgent(request); //No I18N
%>
<!DOCTYPE HTML>
<html>
    <head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <%if(isMobile){ %>
    	<meta name="viewport" content="width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=no" />
    <%} %>
	<title><%=Util.getI18NMsg(request,"IAM.ZOHO.ACCOUNTS")%></title>
	<style type="text/css">
	body, table, a, input, select, textarea {
		font-family:DejaVu Sans, Roboto, Helvetica, sans-serif; font-size:11px;
		margin:0px;
		padding:0px;
	    }
	a, a:link, a:visited {color:#085ddc;}
	.hide { display:none;}
	.desctd {
		font-size:12px;
		text-align: right;
		padding:5px 0px;
		color:#444;
		width:45%;
		float:left;
	    }
	    .descRtd {text-align:left} 
	    .input {
			border: 1px solid #DADADA;
			border-radius: 2px 2px 2px 2px;
			color: #444444;
			font-size: 12px;
			padding: 4px;
			width: 250px;
		}
	    .bluebutton,.whitebutton {
		background-color: #40AADF;
    	border: 1px solid #3999C9;
 	   	color: #FFFFFF;
 	   	cursor: pointer;
 	   	font-size: 11px;
  	  	height: 16px;
 	   	line-height: 19px;
  	  	padding: 4px 10px;
   	 	text-decoration: none;
		}
		 .errormsg {
		border:1px solid #e3b5b1;
		background-color:#f9d0ce;
		margin:5px 0px;
		padding:5px;
	    }
	    .successmsg {
		border:1px solid #b5d8b8;
		background-color:#caf4cd;
		margin:5% 0px;
		padding:5px;
	    }
		.whitebutton{
			background-color: #ececec;
			border:1px solid #d6d6d6;
			color: #333;
		}
		.pagenotesdiv {
		margin:15px 6px;
		text-align:left;
		background-color:#ffffcd;
		border-top:1px solid #cdcbcc;
		border-bottom:1px solid #cdcbcc;
		padding:6px;
		line-height:16px;
	    }
	    .change-captcha-icon {
		background:transparent url(<%=imgurl%>/register.gif) no-repeat -47px -177px; <%-- NO OUTPUTENCODING --%>
		height:28px;
		width:28px;
		cursor:pointer;
	}
	 .captcha {
		width:202px;
		padding:0px;
		margin:0px 8px 0px 0px;
		height: 85px;
	    }
	 .hideliderrmsg, .liderrormsg, .lidsuccessmsg {
	    font-size:11px;
	    float:right;
	    width:81%;
	    color:#d50000;
	    padding:3px 0px 0px 0px;
	    margin:4px 3px 0px 0px;
	}
	.hideliderrmsg {height:0;}
	.lidsuccessmsg {
	    color: #008600;
	}
	.hiptxt { padding-top:2px;}
	.hip { 
			border: 1px solid #DADADA;
    		border-radius: 4px;
    }
    .tempdiv {
    	position: absolute;
    	width: 262px;
	}
	.arrbg {
    	background: url("<%=imgurl%>/border-bg.gif") repeat scroll -3px 0 transparent;<%-- NO OUTPUTENCODING --%>
	}
	#temp {
	    text-align:justify;
	    font-size:11px;
	    background-color: #797979;
    	color: #ffffff;
	}
	.arrcrv {
	    background: url("<%=imgurl%>/register.png") no-repeat scroll -142px -26px transparent;<%-- NO OUTPUTENCODING --%>
	    height: 14px;
	    width: 14px;
	}
	.toprightcrv {
	    background: url("<%=imgurl%>/register.png") no-repeat scroll -133px -24px transparent;<%-- NO OUTPUTENCODING --%>
	    height: 7px;
	}
	.topleftcrv {
	    background: url("<%=imgurl%>/register.png") no-repeat scroll -118px -24px transparent;<%-- NO OUTPUTENCODING --%>
	    height: 7px;
	}
	.crvtoptd {
	    background-color: #797979;
	    border-top: 1px solid #797979;
	}
	.crvmiddletd {
	    background-color: #797979;
	    border-right: 1px solid #797979;
	}
	.botleftcrv {
	    background: url("<%=imgurl%>/register.png") no-repeat scroll -118px -32px transparent;<%-- NO OUTPUTENCODING --%>
	    height: 7px;
	}
	.crvbottomtd {
	    background-color: #797979;
	    border-bottom: 1px solid #797979;
	}
	.botrightcrv {
	    background: url("<%=imgurl%>/register.png") no-repeat scroll -133px -32px transparent;<%-- NO OUTPUTENCODING --%>
	    height: 7px;
	    width: 7px;
	}
	.email {
		border: 1px solid #DADADA;
		border-radius: 2px 2px 2px 2px;
		display: inline-block;
		width: 288px;
	}
	.input {
		outline: 0 none;
		padding: 5px;
		width: 200px;
	}

	.email .input{
		border:0px;
	}
	.ddomain{
		color:#aaa;
	}
	</style>
	<script src="<%=jsurl%>/common.js" type="text/javascript"></script> <%-- NO OUTPUTENCODING --%>
	<script>
            var msg = '<%=Util.isValid(request.getAttribute("msg")) ? request.getAttribute("msg") : ""%>';<%-- NO OUTPUTENCODING --%>
	</script>
    </head>
	<body>
	 <table width="100%" height="100%" align="center" cellpadding="0" cellspacing="0">
	 <tr><td valign="top" style="height:40px;">
	 <div style="height:40px;margin:0px auto;border-bottom:1px solid #c5c8ca;box-shadow:0px 3px 0px #e8ebee;">

	    <div id="headerlogo" style="width:50%;float:left;padding:0px;margin:6px 0px;">
	
		<a href="/"><img src="<%=imgurl%>/spacer.gif" style="background:transparent url('<%=imgurl%>/rebrand.gif') no-repeat -11px -200px;height:26px;width:210px;margin:2px 0px 0px 5px; border:none;" title="<%=Util.getI18NMsg(request,"IAM.ZOHO.ACCOUNTS")%>" alt="<%=Util.getI18NMsg(request,"IAM.ZOHO.ACCOUNTS")%>"/></a><%-- NO OUTPUTENCODING --%>
	    </div>
	    <div style="float:right;padding:0px;margin:0px;">
		
	    </div>
	</div>


</td></tr>
	 <tr><td valign="top" align="center">
	 <div id="formcontainer" style="border:1px solid #E0E0E0;margin-top:1%;width:800px;">
	
	 <div style="background-color:#F5F5F5;text-align:left;font-size:14px;border-bottom:1px solid #E0E0E0;padding:9px;"><%=Util.getI18NMsg(request,"IAM.ZOHOID.TITLE")%></div>
	 <div style="color: #444;font-size: 12px;text-align:left;padding-bottom: 11px;padding:12px;"><%=Util.getI18NMsg(request,"IAM.ZOHOID.SUBTITLE")%></div>
	
	<div id="errmsgpanel" class="hide"></div>
	<div id="password">
	<form name=zohomail onsubmit="return updateZohoEmail(this);" method="POST"> <%-- NO OUTPUTENCODING --%>
	<div style="margin-top:10px;">
	 <div id="lidhelper" class="hideliderrmsg"></div>
		<div class="desctd" id="emailname">
			<%=Util.getI18NMsg(request, "IAM.GENERAL.USERNAME")%>&nbsp;:&nbsp;
		</div>
		<div id="dummy"></div>
		<div class="descRtd">
			<div class="email" id="atzoho">
							<input class="input" type="text" name="zohoemail" id="zohoId" onblur="hideHints(); showCheckAvailability();" onkeypress="closemsg()" onfocus="showHints();" /> 
							<span class="ddomain"><%=IAMEncoder.encodeHTML(AccountsConfiguration.BLOCKED_EMAIL_DOMAIN.getConfiguration().getConfigValue())%></span>
						</div>
		</div>
		
		<!-- Hint -->
		<div id="tempdiv" class="tempdiv" style="display:none;">
                    <table border="0" cellspacing="0" cellpadding="0">
                        <tr><td align="left">&nbsp;</td><td align="left">&nbsp;</td><td align="left">&nbsp;</td></tr>
                        <tr>
                            <td align="left">&nbsp;</td>
                            <td align="left"><table border="0" cellspacing="0" cellpadding="0" >
                                <tr>
                                    <td width="7" align="right"></td>
                                    <td align="right" class="topleftcrv"></td>
                                    <td align="left" class="crvtoptd"><img src="<%=imgurl%>/spacer.gif"/></td><%-- NO OUTPUTENCODING --%>
                                    <td align="left" class="toprightcrv"></td>
                                </tr>
                                <tr>
                                    <td align="right" valign="middle">&nbsp;</td>
                                    <td align="right" valign="top" class="arrbg"><img src="<%=imgurl%>/spacer.gif" class="arrcrv"/></td><%-- NO OUTPUTENCODING --%>
                                    <td align="left" bgcolor="#f3f8fc" id="temp"></td>
                                    <td align="right" class="crvmiddletd">&nbsp;</td>
                                </tr>
                                <tr>
                                    <td align="right"></td>
                                    <td align="right" class="botleftcrv"></td>
                                    <td align="left" class="crvbottomtd"><img src="<%=imgurl%>/spacer.gif"/></td><%-- NO OUTPUTENCODING --%>
                                    <td align="left" class="botrightcrv"></td>
                                </tr>
                            </table></td>
                            <td align="left">&nbsp;</td>
                        </tr>
                        <tr><td align="left">&nbsp;</td><td align="left">&nbsp;</td><td align="left">&nbsp;</td></tr>
                    </table>
                </div>
		<!-- End hint  -->
		</div>
		<!-- start captcha -->
		<%if(verifyCaptcha) { %>
	<div style="margin-top:10px;">
		     <input type="hidden" name="cdigest" value="<%=cdigest%>"> <%-- NO OUTPUTENCODING --%> 
	
	
	<div class="desctd" id="captchaName">
		<%=Util.getI18NMsg(request, "IAM.IMAGE.VERIFICATION")%>&nbsp;:&nbsp;
	</div>
	
	<div class="descRtd">
		  <div style="padding:5px;" id="captchadesc"><%=Util.getI18NMsg(request, "IAM.TYPE.IMAGE.CHARACTERS")%></div> 
		<input type=text style="width:202px;" class="input" name="captcha" maxlength=8 onkeypress="closemsg()">
	</div>
	
	<div style="margin-top:10px;">
	<div class="desctd" id="captchaimg"></div>
	<div class="descRtd">
		<table style="padding: 0; margin: 0;">
			<tr style="padding: 0; margin: 0;">
				<td style="padding: 0; margin: 0;"><div class="captcha" id="hipimg"></div></td>
				<td valign="top"><img src="<%=imgurl%>/spacer.gif" onclick="changeHip()" class="change-captcha-icon" title='<%=Util.getI18NMsg(request,"IAM.REGISTER.RELOAD.CAPTCHA")%>'/></td> <%-- NO OUTPUTENCODING --%>
			</tr>
		</table>
	</div>
	</div>
	</div>
	<%} %>
	<!-- End captcha -->
	<div style="margin-top:10px;">
		<div class="desctd" id ="buttonleft"></div>
		<div class="descRtd">
			<span class="bluebutton" onclick="updateZohoEmail(document.zohomail);"><%=Util.getI18NMsg(request, "IAM.UPDATE")%></span> <%-- NO OUTPUTENCODING --%>
			<span class="whitebutton" onclick="window.parent.location.href='<%=IAMEncoder.encodeJavaScript(serviceUrl)%>';"><%=Util.getI18NMsg(request, "IAM.CANCEL")%></span>
		</div>
	</div>
	</form>
	</div>
	<div id="successmsgpanel" class="hide"><span id="successresp">&nbsp;</span><div style="margin-top:10px;display:none;" id="success_mobile_txt"><%=Util.getI18NMsg(request, "IAM.FORGOT.SMS.ALSO.SENT")%></div><a href="<%=Util.isFujixerox() ? Util.getRedirectURL(request) : IAMEncoder.encodeHTMLAttribute(serviceUrl)%>"><%=Util.getI18NMsg(request, "IAM.CONTACTS.OK")%></a></div><%-- NO OUTPUTENCODING --%>
	</div>
	</td>
	</tr>
	<tr><td valign="bottom"><%@ include file="../unauth/footer.jspf" %></td></tr>
    </table>
</body>
</html>


<script>
	var startsWithPat = /^[A-Za-z0-9]/;
	var validChars = /^[A-Za-z0-9_\.]+$/;
	var contDots = /([._][._])+/;
	var endWithPat = /[A-Za-z0-9]$/;
	var onlyNumbers = /^[0-9]+$/
	var previousValidatedName = '';
    var previousRes = '';
    var csrfParam = '<%=SecurityUtil.getCSRFParamName(request)+"="+SecurityUtil.getCSRFCookie(request)%>'; //NO OUTPUTENCODING
    
    
    
    function updateZohoEmail(f) {
        var zohoemail = f.zohoemail.value.trim();
        var validate_user_res = validateUserName(zohoemail);
        if(validate_user_res != 'success') {
            de('lidhelper').innerHTML = validate_user_res;//No I18N
            de('lidhelper').className='liderrormsg';
            de('zohoId').focus();//No I18N
            return false;
        }
        <%if(verifyCaptcha) {%>
        if(f.captcha.value.trim() == "") {
            showmsg('<%=Util.getI18NMsg(request, "IAM.ENTER.IMAGE")%>');
            f.captcha.focus();
            return false;
        }
        <%}%>
        var params = "uname=" + euc(zohoemail.toLowerCase()) <%if(verifyCaptcha) {%> + "&captcha=" + euc(f.captcha.value) + "&cdigest=" + document.zohomail.cdigest.value <%}%>+ "&serviceurl=<%=IAMEncoder.encodeJavaScript(Util.encode(serviceUrl))%>&" + csrfParam; //No I18N
        var res = getPlainResponse("<%=request.getContextPath()%>/setzohoid", params); <%-- NO OUTPUTENCODING --%> <%-- No I18N --%>
        res = res.trim();
        if(res  == "success") { //No I18N
            proceed();
            f.reset();
            return false;
        }
        else if(res  == "invalid_hip") {
            showmsg('<%=Util.getI18NMsg(request, "IAM.ERROR.INVALID_IMAGE_TEXT")%>');
            f.captcha.focus();
        } else {
            showmsg('<%=Util.getI18NMsg(request, "IAM.ERROR.CODE.Z101")%>');
            f.zohoemail.focus(); //No I18N
        }
        <%if(verifyCaptcha) {%>
        	changeHip();
        <%}%>
        return false;
    }


    function showmsg(msg) {
        de('errmsgpanel').className = "errormsg"; //No I18N
        de('errmsgpanel').innerHTML = msg; //No I18N
    }
    function closemsg() {de('errmsgpanel').className='hide';}

    function showHip(cdigest) {
    	if ( !(cdigest && isValid(cdigest)) ) {
		if (document.zohomail.cdigest) {
			cdigest = document.zohomail.cdigest.value; <%-- No I18N --%>
		}
	}
        var hipRow = de('hipimg'); //No I18N
        hipRow.innerHTML= "<img name='hipImg' id='hip' class='hip' width='200' height='75' src='<%=request.getContextPath()%>/accounts/captcha?cdigest=" + cdigest + "'  alt='<%=Util.getI18NMsg(request,"IAM.HIP.IMAGE")%>' title='<%=Util.getI18NMsg(request,"IAM.TITLE.RANDOM")%>' align='absmiddle'>"; <%-- NO OUTPUTENCODING --%>
    }

    function changeHip() {
    	var hipdigest = getNewHip('<%=request.getContextPath()%>/accounts/captcha', 'action=newcaptcha'); <%-- NO OUTPUTENCODING --%> <%-- No I18N --%>
    	if (document.zohomail.cdigest)
    		document.zohomail.cdigest.value = hipdigest
	showHip(hipdigest);<%-- No I18N --%>
    }

	function isValid(instr) {
	    return instr != null && instr != "" && instr != "null"; //No I18N
	}

    function getNewHip(action, params) {
        var objHTTP;
        objHTTP = xhr();
		objHTTP.open('GET', action + "?" + params, false); <%-- No I18N --%>
        objHTTP.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded;charset=UTF-8'); <%-- No I18N --%>
        objHTTP.send(params);
        return objHTTP.responseText;
    }

    function xhr() {
        var xmlhttp;
        if (window.XMLHttpRequest) {
            xmlhttp=new XMLHttpRequest();
        }
        else if(window.ActiveXObject) {
	    try { <%-- No I18N --%>
	        xmlhttp=new ActiveXObject("Msxml2.XMLHTTP"); <%-- No I18N --%>
	    }
	    catch(e) { <%-- No I18N --%>
	        xmlhttp=new ActiveXObject("Microsoft.XMLHTTP"); <%-- No I18N --%>
	    }
        }
        return xmlhttp;
    }

    window.onload = function() {
        var zohoId = document.zohomail.zohoId;
      	de('zohoId').focus();//No I18N
      	 <%if(verifyCaptcha) {%>
        showHip();
        <%}%>
        var isMobile = '<%=isMobile%>';
        if(isMobile == "true"){
            checkisMobile(isMobile);
        }
    }
    
    function validateUserName(lid) {
        if(lid.trim() == "") {
            return "<%=Util.getI18NMsg(request,"IAM.ERROR.ENTER.USERNAME")%>";
        }
        if(lid.length < 6) {
            return "<%=Util.getI18NMsg(request,"IAM.ERROR.USERNAME.INCORRECT.LENGTH.LESS", 6)%>";
        }
        if(lid.length > 30) {
            return "<%=Util.getI18NMsg(request,"IAM.ERROR.USERNAME.INCORRECT.LENGTH.MORE", 30)%>";
        }
        if(!startsWithPat.test(lid)) {
            return "<%=Util.getI18NMsg(request,"IAM.ERROR.USERNAME.INCORRECT.STARTSWITH")%>";
        }
        if(!validChars.test(lid)) {
            return "<%=Util.getI18NMsg(request,"IAM.ERROR.ONLY.ALPANUMERIC")%>";
        }
        if(contDots.test(lid)) {
            return "<%=Util.getI18NMsg(request,"IAM.ERROR.USERNAME.INCORRECT.CONSECUTIVE.DOTS")%>";
        }
        if(!endWithPat.test(lid)) {
            return "<%=Util.getI18NMsg(request,"IAM.ERROR.USERNAME.INCORRECT.ENDSWITH")%>";
        }
        if(onlyNumbers.test(lid)) {
            return "<%=Util.getI18NMsg(request,"IAM.ERROR.USERNAME.INCORRECT.ATLEAST.ONEALPHA")%>";
        }
        return 'success'; //No I18N
    }
    
    function showCheckAvailability() {
        <%if(Util.isEnabledUsernameAvailability()) {%>
            var lid = de('zohoId').value;//No I18N
            var validate_user_res = validateUserName(lid);

            if(validate_user_res != 'success') {
                de('lidhelper').innerHTML = validate_user_res;//No I18N
            }
            else {
                if(previousValidatedName == lid) {
                    res = previousRes;
                } else {
                    params = "LOGIN_ID="+euc(lid.toLowerCase())+"&"+csrfParam;//No I18N
                    res = getPlainResponse("<%=request.getContextPath()%>/register/checkusername", params); <%-- NO OUTPUTENCODING --%> //No I18N 

                    previousValidatedName = lid;
                    previousRes = res.trim();
                }

                if(res.trim() == 'true') {
                    de('lidhelper').innerHTML = formatMessage('<%=Util.getI18NMsg(request,"IAM.REGISTER.ISNOT.AVAILABLE")%>',lid);//No I18N
                } else {
                    if(res.trim() == 'false') {
                        de('lidhelper').className='lidsuccessmsg'; //No I18N
                        de('lidhelper').innerHTML = formatMessage('<%=Util.getI18NMsg(request,"IAM.REGISTER.IS.AVAILABLE")%>',lid);//No I18N
                    }
                    return false;
                }
            }
            de('lidhelper').className='liderrormsg';
            de('zohoId').focus();//No I18N
       <%}%>
            return false;
        }
    
    var hints = new Array('<%=Util.getI18NMsg(request,"IAM.REGISTER.USERNAME.HINTS", 6, 30)%>','<%=Util.getI18NMsg(request,"IAM.REGISTER.EMAIL.HINTS")%>','<%=Util.getI18NMsg(request,"IAM.REGISTER.PASSWORD.HINTS", 3, 60)%>');

    function findPosX(obj) {
        var curleft = 0;
        if (obj.offsetParent) {
            while (obj.offsetParent) {
                curleft += obj.offsetLeft;
                obj = obj.offsetParent;
            }
        }
        else if (obj.x) {
            curleft += obj.x;
        }
        return curleft;
    }

    function findPosY(obj) {
        var curtop = 0;
        if (obj.offsetParent) {
            while (obj.offsetParent) {
                curtop += obj.offsetTop;
                obj = obj.offsetParent;
            }
        }
        else if (obj.y) {
            curtop += obj.y;
        }
        return curtop;
    }
    
    function showHints() {
        <%if(!"true".equals(request.getParameter("hidehints")) && !isMobile) {%>
            var tempmsg = de('temp'); //No I18N
            tempmsg.innerHTML = hints[0];
			f1 = de('atzoho');//No I18N
            de('tempdiv').style.left=findPosX(f1)+f1.offsetWidth-10+'px';
            de('tempdiv').style.top=findPosY(f1)-(f1.offsetHeight-5)+'px';
            de('tempdiv').style.display='';
        <% } %>
    }

    function hideHints() {
        <%if(!"true".equals(request.getParameter("hidehints"))) {%>
            de('tempdiv').style.display = 'none'; //No I18N
        <%}%>
    }
    
    function proceed() {
        var ele = de('continuebtn');//No I18N
        if(ele) {
            ele.removeAttribute('onclick');
            ele.className = 'disablebtn';
            ele.disabled = true;
        }
        window.location.href = "<%=IAMEncoder.encodeJavaScript(serviceUrl)%>";
    }
    
    function checkisMobile(isMobile) {
		if(isMobile == "true") {
			window.scrollTo(0, document.body.scrollHeight);
			var heightOfdevice =  window.innerHeight; 
			var heightToBeadded = heightOfdevice - 416;
			if(heightToBeadded > 0 && heightToBeadded < 150) {
				heightToBeadded = heightToBeadded / 4;
				document.getElementById("inntbl").style.marginTop = heightToBeadded + "px"; //No I18N
				document.getElementById("submit_but").style.marginTop = 7 + heightToBeadded / 2 + "px"; //No I18N
				document.getElementById("opensignin").style.marginTop = 17 + heightToBeadded + "px"; //No I18N
			}
			document.getElementById("headerlogo").style.width = "100%"; //No I18N
			document.getElementById("formcontainer").style.width = "100%"; //No I18N
			document.getElementById("buttonleft").style.width = "10%"; //No I18N
			document.getElementById("emailname").style.display = "none"; //No I18N
			document.getElementById("captchaName").style.display = "none"; //No I18N
			document.getElementById("captchadesc").style.display = "none"; //No I18N
			document.getElementById("zohoId").setAttribute("placeholder",'<%=Util.getI18NMsg(request, "IAM.GENERAL.USERNAME")%>');//No I18N
			document.getElementById("dummy").style.width = "10%"; //No I18N
			document.getElementById("captchaimg").style.width = "1%"; //No I18N
			
		}
	}
</script>