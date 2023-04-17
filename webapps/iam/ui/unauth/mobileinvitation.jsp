<%--$Id$--%>
<%@page import="com.adventnet.iam.PasswordPolicy"%>
<%@page import="com.zoho.accounts.Accounts"%>
<%@page import="com.zoho.data.AccountsDataObject.IAMEmail"%>
<%@page import="com.adventnet.iam.IAMUtil"%>
<%@page import="com.zoho.accounts.AccountsUtil"%>
<%@page import="com.adventnet.iam.Org"%>
<%@page import="com.adventnet.iam.User"%>
<%@page import="com.adventnet.iam.xss.IAMEncoder"%>
<%@page import="com.zoho.accounts.AccountsConfiguration"%>
<%@page import="com.zoho.accounts.AccountsConstants"%>
<%@page import="org.json.JSONObject"%>
<%@page import="com.zoho.accounts.AccountsProto.Account.Digest"%>
<%@page import="com.adventnet.iam.internal.Util"%> 
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> <%--No I18N--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
	<title><%=Util.getI18NMsg(request, "IAM.ORGINVITATION.TITLE")%></title>
	<%
	boolean isStatic = "true".equals(AccountsConfiguration.getConfiguration("iam.static", "false"));
	String cPath = request.getContextPath();
	String jsurl = isStatic ? Util.getJSURL(request) : cPath+"/static"; // No I18N
	String cssurl = isStatic ? Util.getCSSURL(request) : cPath+"/styles";// No I18N
	%>
	<link href="<%=cssurl%>/style.css" type="text/css" rel="stylesheet" /><%-- NO OUTPUTENCODING --%>
	<% 
	String fromurl=null;
	String language=null;
	language = request.getLocale()!=null?request.getLocale().toString().split("_")[0]:null;
	JSONObject jobj=null;
	String mobileNo=null;
	User currentUser=null,orgadmin=null;
	long ZUID=-1;
	long ZOID=-1;
	Org org = null;
	String rejectUrl=Util.isValid( request.getAttribute("rurl"))?(String)request.getAttribute("rurl"):Util.getIAMURL();
	Digest accDigest=request.getAttribute("jdigestobj")!=null?((Digest)request.getAttribute("jdigestobj")):null;
	if (accDigest != null && !accDigest.getIsValidated()) {
		fromurl = accDigest.getServiceUrl();
		mobileNo=accDigest.hasEmailId()?accDigest.getEmailId():null;
		if (Util.isValid(accDigest.getArgsData())) {
			jobj = new JSONObject(accDigest.getArgsData());
			org = Util.ORGAPI.getOrg(jobj.optLong(AccountsConstants.DigestParams.ZOID.dbValue(),-1));
			orgadmin=(org!=null)?Util.USERAPI.getUser(org.getOrgContact()):null;
			if(org!=null && jobj.has("invitermail")){
				orgadmin=Util.USERAPI.getUser(jobj.getString("invitermail"));
				if(orgadmin==null || !(orgadmin.isOrgAdmin()||orgadmin.isOrgSuperAdmin())){
					orgadmin=Util.USERAPI.getUser(org.getOrgContact());
				}
			}
			if(request.getAttribute("user")!=null) {
				currentUser = (User)request.getAttribute("user");
			}
			if(jobj.has(AccountsConstants.DigestParams.EMAIL_ID.dbValue()) && !Util.isValid(mobileNo)) {
				mobileNo = jobj.getString(AccountsConstants.DigestParams.EMAIL_ID.dbValue());
			}
		}
	}else if(accDigest != null && accDigest.getIsValidated()){
		request.setAttribute("cause", "ALREADY_ACCEPTED");
		request.getRequestDispatcher("/ui/unauth/orguserinvite.jsp").forward(request, response); // No I18N
		return;
	}else{
		request.setAttribute("cause", "INVALID_INVITATION");
		request.getRequestDispatcher("/ui/unauth/orguserinvite.jsp").forward(request, response); // No I18N
		return;
	}
	String digest = request.getParameter("digest");
	String acurl=Util.getIAMURL() + "/accounts/i/a?digest=" + digest; // No I18N
	%>
	<script src="<%=jsurl%>/common.js" type="text/javascript"></script><%-- NO OUTPUTENCODING --%>
	<script type="text/javascript" src="<%=jsurl %>/jquery-1.12.2.min.js"></script><%-- NO OUTPUTENCODING --%>
	<link rel="stylesheet" type="text/css" href="/accounts/css/registernew.css">
	<script type="text/javascript">
	<%
	if(currentUser==null){
	%>
	
	
	
	function hideTipMessage(){
		if(de("policy")&&de("policy").style.display=='none'){
			$("#policy").slideDown();
		}else{
			$("#policy").slideUp();
		}	
	}
	function verifyCode(){
		var _p = "code="+de("verifycode").value.trim();//No I18N
		var resp=(de("verifycode").value.trim()!="")?getPlainResponse("/accounts/invitation/verifycode",_p):"";//No I18N
		if(IsJsonString(resp)){
			var obj = JSON.parse(resp);
			if(obj.status=="success"){
					window.location.href="<%=IAMEncoder.encodeJavaScript(acurl)%>";
			}else{
				if(obj.message=="INVAID_TEMP_TOKEN"){
					showERORR("<%=IAMEncoder.encodeJavaScript(Util.getI18NMsg(language, "IAM.INVITAION.SESSION.EXPIRED"))%>","msgpanel1");
				}else if(obj.cause=="INVALID_CODE"){ //No I18N
					showERORR("<%=IAMEncoder.encodeJavaScript(Util.getI18NMsg(language, "IAM.PHONE.INVALID.VERIFY.CODE"))%>","msgpanel1");
				}else {
					showERORR("<%=IAMEncoder.encodeJavaScript(Util.getI18NMsg(language, "IAM.ERROR.GENERAL"))%>","msgpanel1");
				}
			}
			return;
		}else{
			showERORR("<%=IAMEncoder.encodeJavaScript(Util.getI18NMsg(language, "IAM.PHONE.INVALID.VERIFY.CODE"))%>","msgpanel1");
		}
	}
	function showVerify(temp){
		var _a="",_p="";
		if(temp=="true"){
			_a="/accounts/invitation/accept?digest="+digest; //No I18N
		}else{
			_a="/accounts/invitation/resendotp"; //No I18N
		}
		var resp=getPlainResponse(_a,_p);
		if(IsJsonString(resp)){
			var obj = JSON.parse(resp);
			if(obj.status=="success"){
				if(obj.message=="redirect"){
					window.location.href="<%=IAMEncoder.encodeJavaScript(acurl)%>";
					return;
				}
				$(".inv-div").hide();
				$(".verify-div").show();
	   			setTimeout("$('.hintdiv').show()", 10000);
			}else{
				if(obj.message=="INVAID_TEMP_TOKEN"){
					window.location.href="";
				}else {
					showERORR("<%=IAMEncoder.encodeJavaScript(Util.getI18NMsg(language, "IAM.ERROR.GENERAL"))%>","msgpanel1");
				}
			}
			return;
		}
	}
	<%} 
%>
	var digest="<%=IAMEncoder.encodeJavaScript(digest) %>";
	function showERORR(msg,id){
		var msgDiv = $('#msg_div');
		msgDiv.stop(true,true);
		if(de(id)) {
			de(id).innerHTML = msg;	
		}
		msgDiv.show();
		msgDiv.fadeOut(10000);
	}
	function rejectInvite(){
		var resp=getPlainResponse("/accounts/rejectinvite.ac","iamcsrcoo="+getIAMCookie("iamcsr")+"&digest="+digest+"&is_ajax=true"); //No I18N
		
		if(IsJsonString(resp)){
			var obj = JSON.parse(resp);
			if(obj.data){
				$(".inv-div").hide();
				$(".reject-div").show();
				return;
			}
		}
		showERORR("<%=IAMEncoder.encodeJavaScript(Util.getI18NMsg(language, "IAM.ERROR.GENERAL"))%>","msgpanel1");
	}
	</script>
	</head>
	<body >
		<div id="msg_div" style="text-align: center;z-index: 3;margin-top: 14px;width: 100%;position: absolute;display:none;">
			<span id="msgpanel1" style="background-color: #ffbcbc;color: red;padding-left: 2%;margin-left: -17%;padding-right: 2%;font-size: 15px;padding-top: 2px;z-index: 2;"></span></span>
		</div>
		<div class="inv-div" style="font-family: 'Lucida Grande','Lucida Sans Unicode', Helvetica, Roboto, DejaVu Sans, sans-serif; font-size: 12px; background-color: #FFFFFF; color:#333333;">
			<table align="center">
			
	        	<tr>
	        		<td align="center">
	        			<div style=" width:700px;">
	        			
					        <div style="background-color:#FFFFFF;padding: 3px 0px 10px 0px;">
					             <div class="logo-top" style="margin-top: 72px;"></div>
					             <div style="padding: 10px 0px 0px 0px;font-size: 30px;color: #666;font-weight: 300;margin-top: -14px;" ><%=IAMEncoder.encodeHTML(Util.getI18NMsg(request, "IAM.ORGINVITATION.TITLE")) %></div>
					             <div class="bdre2" style="border-bottom: 2px solid #000;height: 1px;margin: 6px auto;width: 100px;" align ="center"></div>
					            <div style="padding:10px; line-height:18px;">
				                	<div style="font-size: 12px; padding: 10px 0px 0px 0px;"><%=Util.getI18NMsg(request, "IAM.TPL.ORG.WELCOME.TEXT.MOBILE",orgadmin.getDisplayName(),orgadmin.getPrimaryEmail(),org.getOrgName()) %></div>
					                <div style="font-size: 12px; padding: 10px 0px 0px 0px;"><%=currentUser==null? Util.getI18NMsg(request, "IAM.TPL.ORGINVITATION.NEWUSER.ACCEPT1",org.getOrgName()):IAMEncoder.encodeHTML(Util.getI18NMsg(request, "IAM.TPL.ORGCONFIRM.ACCEPT.TEXT")) %></div>
					                <div  class="btnmaindiv" align="center"style="margin-top: 5%;">
					                	<div style="display:inline-block;">
						                    <div style="line-height:34px; width:auto; float:left;margin-right:9px">
						                        <%if(currentUser!=null) {
						                        %>
						                        <a href="<%=IAMEncoder.encodeHTMLAttribute(acurl) %>" class="redBtn" style="text-decoration:none;cursor:pointer;"><%-- NO OUTPUTENCODING --%>
						                        	<span style="color:#FFFFFF; font-size:14px; margin: 5px 12px 0px;"><%=IAMEncoder.encodeHTML(Util.getI18NMsg(request, "IAM.TPL.ORGINVITATION.TOACCEPT"))%></span>
						                        </a> 
						                        <%}else{ %>
						                        <a type="button" class="redBtn" onclick="showVerify('true');"  style="text-decoration:none;cursor:pointer;"><span style="color:#FFFFFF; font-size:14px; margin: 5px 12px 0px;"><%=Util.getI18NMsg(language, "IAM.TPL.ORGINVITATION.TOACCEPT") %></span></a>
						                    	<%} %>
						                    </div>
						                    <div style="clear:both;"></div>
						                </div>
						                <div style="display:inline-block;color:black;">
						                    <div style=" none; border-radius:4px; text-align:center; font-size:14px; color:black; line-height:30px; width:auto; float:left;">
						                        <a type="button" class="cancel-btn" onclick="rejectInvite()" style="cursor:pointer;text-decoration:none"><%-- NO OUTPUTENCODING --%>
						                        	<span style="font-size:14px; margin: 5px 12px 0px;"><%=Util.getI18NMsg(language, "IAM.TPL.ORGINVITATION.TOREJECT") %></span>
						                        </a>
						                    </div>
						                    <div style="clear:both;"></div>
						                </div>
					                </div>
					            </div>
					        </div>
				        </div>
	        		</td>
	        	</tr>
	        	<tr><td valign="bottom"><%@ include file="../unauth/footer.jspf" %></td></tr>
	        </table>
		</div>
		<%if(currentUser==null) {
			PasswordPolicy pp = null;
		    int minPassLength = -1;
		    int maxPassLength = -1;
		    int minsplCharLength=0;
		    int minnumericLength=0;
		    int passHistory=-1;
		    boolean mixed_case=false;
		    pp = Util.ORGAPI.getPasswordPolicy(org.getZOID());
		    if(pp != null){
			minPassLength = pp.getMinimumPasswordLength()<8?8:pp.getMinimumPasswordLength();
			maxPassLength = pp.getMaximumPasswordLength();
			minsplCharLength = pp.getMinimumSpecialChars();
			minnumericLength = pp.getMinimumNumericChars();
			passHistory = pp.getNumberOfPasswordsToRember();
			mixed_case = pp.isMixedCaseEnforced();
		    }
		%>
		<div style="display:none;" class="verify-div">
			<header>
				<div class="logo"></div>
				<div style="clear: both;"></div>
			</header>
			<h2 class="form-title"><%=IAMEncoder.encodeHTML(Util.getI18NMsg(language, "IAM.INVITAION.VERIFY.MOBILE")) %></h2> <%--No I18N--%>
			<table align="center">
	        	<tr>
	        		<td align="center">
	        			<div class="bdre2" style="border-bottom: 2px solid #000;height: 1px;margin: 6px auto;width: 100px;" align ="center"></div>
						<div class="hintdivheader" style="text-align: center;margin-top:18px;margin-bottom:18px;font-size: 12px;" align="center">
							<span class="hintdiv" id="resendhint" style="display: none"><%=Util.getI18NMsg(language, "IAM.PHONE.TXT.RESEND.VERIFY.CODE","showVerify();") %><%-- NO OUTPUTENCODING --%></span>
						</div>
						<div class="title-1" style="text-align: center;width: 500px;font-size: 15px;margin-top: 2px;" id="pagetitle"><span><%=IAMEncoder.encodeHTML(Util.getI18NMsg(language, "IAM.INVITAION.VERIFY.MOBILE.MSG",mobileNo)) %></span></div>
						<dl class="textme-div">  <%--No I18N--%>
							<dd>
								<input type="text" id="verifycode" placeholder='<%=Util.getI18NMsg(language, "IAM.TFA.ENTER.VERIFICATION.CODE") %>' name="firstname" maxlength="100" tabindex="1" id="firstname"style="width: 300px;">
							</dd>
						</dl>
						<dl class="button-div">  <%--No I18N--%>
							<dd>
								<div class="inlineLabel"></div>
								 <div class="inputText" style="text-align: left;border:none;margin-left:25%">
										<span id="verify_button" style="padding: 6px 30px;" tabindex="3" class="redBtn" onclick="verifyCode()" onkeypress="if(event.keyCode == 13||event.keyCode == 32){validateUserCode()}"><%=Util.getI18NMsg(request, "IAM.VERIFY")%></span>
										<span class="cancel-btn" style="padding: 6px 30px;" onclick="window.parent.location.href=''"><%=Util.getI18NMsg(request, "IAM.BACK")%></span>
								 </div>
							</dd>
						</dl>
					</td>
	        	</tr>
	        </table>
		</div>
		<%} %>
		<div style="display:none;" class="reject-div">
			<header>
				<div class="logo"></div>
				<div style="clear: both;"></div>
			</header>
			<h2 class="form-title"><%=IAMEncoder.encodeHTML(Util.getI18NMsg(language, "IAM.TPL.ORGINVITATION.TOREJECT")) %></h2> <%--No I18N--%>
			<table align="center">
	        	<tr>
	        		<td align="center">
	        			<div class="bdre2" style="border-bottom: 2px solid #000;height: 1px;margin: 6px auto;width: 100px;" align ="center"></div>
	        			<div class="title-1" style="text-align: center;width: 500px;font-size: 15px;margin-top: 2px;" id="pagetitle"><span><%=IAMEncoder.encodeHTML(Util.getI18NMsg(language, "IAM.TEMPLATE.ORG.INVITATION.REJECT.SUCESS",org.getOrgName())) %></span></div>
	        			<div class="inputText" style="text-align: center;border:none;margin-top:3%">
	        				<span class="cancel-btn" style="padding: 6px 30px;" onclick="window.parent.location.href='<%=IAMEncoder.encodeJavaScript(rejectUrl)%>'"><%=Util.getI18NMsg(request, "IAM.TEMPLATE.ORG.INVITATION.SUCESS.CONTINUE")%></span>
						</div>
					</td>
	        	</tr>
	        </table>
		</div>
	</body>
</html>