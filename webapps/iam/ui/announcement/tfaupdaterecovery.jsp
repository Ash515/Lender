<%--$Id$--%>
<%@page import="com.zoho.accounts.internal.util.AccountsInternalConst"%>
<%@page import="com.zoho.accounts.AccountsProto.Account.User.UserMobile"%>
<%@page import="com.adventnet.iam.internal.PhoneUtil"%>
<%@page import="com.zoho.iam2.rest.ProtoToZliteUtil"%>
<%@page import="com.zoho.accounts.Accounts"%>
<%@page import="com.zoho.accounts.internal.announcement.Announcement"%>
<%@page import="org.json.JSONObject"%>
<%@page import="com.zoho.accounts.internal.util.AccountsInternalConst.TFARecoveryPreference"%>
<%@page import="com.zoho.accounts.AccountsProto.Account.User.Properties"%>
<%@page import="java.util.Locale"%>
<%@page import="com.zoho.accounts.SystemResourceProto.ISDCode"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.DateFormat"%>
<%@page import="com.adventnet.iam.servlet.TFAPrefServlet"%>
<%@page import="java.util.Map"%>
<%@page import="com.zoho.accounts.phone.SMSUtil"%>
<%@page import="com.zoho.accounts.AccountsConstants.TFAPrefOption"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@ include file="../../static/includes.jspf" %>
<%
response.setHeader("Pragma", "no-cache"); // No I18N
response.setHeader("Cache-Control", "no-store, no-cache"); // No I18N
User user = IAMUtil.getCurrentUser();
UserPreference upref = user.getUserPreference();
boolean usesSms = upref!= null && (upref.getTFAPrefOption() == TFAPrefOption.ENABLE_TFA_SMS);
List<UserPhone> phoneList = ProtoToZliteUtil.toUserPhoneNumbers(PhoneUtil.getUserVerifiedNumbers(user));
List<UserPhone> backupNumbers = new ArrayList<UserPhone>();
UserMobile um=PhoneUtil.getUserTFANumber(user);
if (phoneList != null) {
	for (UserPhone val : phoneList) {
		if(!usesSms){
			if(val.isVerified() && val.getMode()==AccountsInternalConst.UserMobileMode.TFA_NUMBER.getValue()) {
				backupNumbers.add(val);
			}
		}else{
			if(!val.getPhoneNumber().equals((um!=null?um.getMobile():"")) && val.isVerified() && val.getMode()==AccountsInternalConst.UserMobileMode.TFA_NUMBER.getValue()) {
				backupNumbers.add(val);
			}
		}
	}
}
boolean hasBackupNumbers = (backupNumbers != null) && (backupNumbers.size() > 0);
Map recCodeMap = CSPersistenceAPIImpl.getRecoveryCodes(user);
boolean hasRecoveryCodes = recCodeMap != null;
if(!hasRecoveryCodes) {
	   CSPersistenceAPIImpl.generateRecoveryCodes(user);
	   recCodeMap = CSPersistenceAPIImpl.getRecoveryCodes(user);
	   hasRecoveryCodes = recCodeMap != null;
	   Util.USERAPI.deleteUserProperty(user.getZUID(), Util.appendIAMPropertyPrefix(TFAPrefServlet.TFA_RECOVERY_PREFERENCE));
	   Util.USERAPI.deleteUserProperty(user.getZUID(), Util.appendIAMPropertyPrefix(TFAPrefServlet.TFA_BKPCODES_INFO));
	   Util.USERAPI.deleteUserProperty(user.getZUID(), Util.appendIAMPropertyPrefix(TFAPrefServlet.TFA_RECOVERY_LAST_UPDATED_TIME)); //deleted since, the recovery codes are auto generated in this page.
}
String[] recoveryCodesArray = null;
String recoveryCodes = null;
long createdTime = -1;
if(hasRecoveryCodes) {
	recoveryCodes = (String) recCodeMap.get("RECOVERY_CODES");
	recoveryCodesArray = recoveryCodes.split(":");
	createdTime = (Long) recCodeMap.get("CREATED_TIME");
}
int recoveryCodesCount = recoveryCodesArray != null? recoveryCodesArray.length : 0;
DateFormat df = Util.getDateFormat(request, user);
List<ISDCode> countryList = SMSUtil.getAllowedISDCodes();
Locale locale = request.getLocale();
String userCountry = Util.isValid(user.getCountry())? user.getCountry() : locale.getCountry();
Properties saveTypeProperty = Accounts.getPropertiesURI(user.getZaid(), user.getZUID(),Util.appendIAMPropertyPrefix(TFAPrefServlet.TFA_RECOVERY_PREFERENCE)).GET();
boolean alreadySavedCodes = saveTypeProperty != null;
Properties backupinfoProperty = alreadySavedCodes ? Accounts.getPropertiesURI(user.getZaid(), user.getZUID(),Util.appendIAMPropertyPrefix(TFAPrefServlet.TFA_BKPCODES_INFO)).GET() : null;
boolean hasBackupInfo = backupinfoProperty != null;
String propJsonString = hasBackupInfo ? backupinfoProperty.getPropValue() : null;
JSONObject jsonBackupInfo = hasBackupInfo ? new JSONObject(propJsonString) : null;
String TwoFactorUrl = Util.getIAMURL() + "/u/h#security/authentication"; //No I18N
String recoveryDocumentLink = AccountsConfiguration.getConfiguration("tfa.asp.help.document", "https://zohosso.wiki.zoho.com/TFA-Recovery-Options.html"); //No I18N
%>
<!DOCTYPE HTML>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<title><%=Util.getI18NMsg(request, "IAM.TFA.RECOVERYMODES.HEADING") %></title>
<link href="<%=cssurl%>/style.css" type="text/css" rel="stylesheet" /> <%-- NO OUTPUTENCODING --%>
<script src="<%=jsurl%>/jquery-1.12.2.min.js" type="text/javascript"></script> <%-- NO OUTPUTENCODING --%>
<script src="<%=jsurl%>/tfa-preference.js" type="text/javascript"></script> <%-- NO OUTPUTENCODING --%>
<script src="<%=jsurl%>/phone-number.js" type="text/javascript"></script> <%-- NO OUTPUTENCODING --%>
<script src="<%= cPath%>/error-msgs?<%=Util.getErrorQS()%>" type="text/javascript"></script> <%-- NO OUTPUTENCODING --%>
<script src="<%=jsurl%>/common.js" type="text/javascript"></script> <%-- NO OUTPUTENCODING --%>
<script src="<%=jsurl%>/xregexp-all.js" type="text/javascript"></script> <%-- NO OUTPUTENCODING --%>
<meta name="viewport" content="width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=no" />
<style>
body,table {
	font-family:"Open Sans";
	font-size: 13px;
	padding:0px;
	margin:0px;
}
a.hyperlink:link {color:#1155CC;text-decoration:underline;  font-size: 13px;
  line-height: 22px;  color: #2c8fb4;}
a:hover {
    text-decoration: none;
}
.rec-heading {
	margin-top: 20px;
	color: #E24122;
}

.rec-subtxt {
	margin-top: 7px;
	line-height: 20px;
}

.rec-list-heading {
	padding: 5px 0px;
  font-size: 14px;
    border-bottom: 1px solid #999;
    color:#666;
}
.rec-list-content {
	line-height: 20px;
}
.rec-whitebutton {
	cursor: pointer;
}
.error {
	color: red;
   	font-size: 11px;
   	margin-left: 8px;
}
.rec-success-popup {
	background-color: #FEFF99;
    border: 1px solid #EFED02;
    left: 34%;
    padding: 5px;
    position: absolute;
    top: 101px;
    z-index: 417;
}
.title-banner{
  font-size: 24px;
  width: 191px;
  text-align: right;
  line-height: 45px;
 }
 .mobilechange{
   background: rgba(0, 0, 0, 0) url("../../images/banner-icons.png") no-repeat scroll -237px -33px;
  display: inline-block;
  height: 130px;
  margin-left: 21px;
  width: 160px;
 }
 .maindiv {
  width: 900px;
  margin: 0px auto;
  border-radius: 2px;
  text-align: justify;
  margin-top: 5%;
}
.mobilecode{
 background: rgba(0, 0, 0, 0) url("../../images/banner-icons.png") no-repeat scroll -229px -190px;
  display: inline-block;
  height: 133px;
  margin-left: 21px;
  width: 160px
}
.rightsight_con{
	width: 800px;
	margin:0px auto;
	margin-top: 25px;
}
.leftside_con{
	border-right: 1px solid #8d8d8d;
	width: 235px;
	float: left;
}
.mobile_icon,.num_icon{
	float: left;
}
@media only screen and (max-width: 900px) {
	.maindiv{
		width: 100%;
	}
	.rightsight_con{
		width: 80%;
	}
	.leftside_con{
		width: 25%;
	}
}
@media only screen and (max-width: 600px) {
	.rightsight_con,.leftside_con{
		float: unset;
		width: 100%;
	}
	.mobile_icon,.num_icon{
		float: unset;
	}
}
</style>
<script>
var csrfParam = '<%=IAMEncoder.encodeJavaScript(SecurityUtil.getCSRFParamName(request))+"="+IAMEncoder.encodeJavaScript(SecurityUtil.getCSRFCookie(request))%>';
var isdCodes = new Array();
var saved_backup_codes = <%=alreadySavedCodes%>;
<%List<ISDCode> isdCodesList = SMSUtil.getAllowedISDCodes();
if(isdCodesList != null && isdCodesList.size() > 0) {
	for(ISDCode isdCode : isdCodesList){
		String countryCode = isdCode.getCountryCode();
		int dialingCode = isdCode.getDialingCode();
%>
isdCodes['<%=countryCode%>'] = '<%=dialingCode%>';  <%-- NO OUTPUTENCODING --%>
<%	}
}%>
$(document).keydown(function(e) {
    if (e.keyCode === 27) {
    	closeDiv();
    }
  });
window.onload = function() {
	$('#recoverycontent input[placeholder]').zPlaceHolder();
}
</script>
</head>
<body id="recoverycontent">
<div id="msg_div" align="center">
	<table cellspacing="0" cellpadding="0">
		<tr><td>
			<span id="msgspan" class="successmsg"><span class="tickicon" id="tickicon"></span>&nbsp;<span id="msgpanel"></span></span>
		</td></tr>
	</table>
</div>
<div id="progress-cont" style="display:none;"><img src="<%=imgurl%>/indicator.gif"/><div><%=Util.getI18NMsg(request,"IAM.LOADING")%>.....</div></div><%-- NO OUTPUTENCODING --%>
<table width="100%" height="100%" align="center" cellpadding="0" cellspacing="0">
<tr><td valign="top" style="height:40px;"><%@ include file="../unauth/header.jspf" %></td></tr>
<tr><td valign="top">
<div class="maindiv">
<div class='leftside_con'>
<div class="title-banner"><%=Util.getI18NMsg(request, "IAM.TFA.RECOVERYMODES.HEADING") %></div>
	<div style="margin-left: 18px;margin-right: 38px;margin-top: 20px;" class='mobile_icon'>
		<div class="mobilechange"></div>
	</div>
	<div style="margin-left: 18px;margin-right: 38px;margin-top: 20px;" class='num_icon'>
		<div class="mobilecode"></div>
	</div>
</div>
<div class='rightsight_con'>
<div style="margin-top: 20px;  margin-left: 230px;">
	<div style="line-height: 22px;">
	<%=Util.getI18NMsg(request, "IAM.TFA.RECOVERYUPDATE.HEADING") %>
	</div>
	<div class="rec-heading">
		<%=Util.getI18NMsg(request, "IAM.TFA.WHY.VERIFY.RECOVERYMODES") %>
	</div>
	<div class="rec-subtxt">
		<%=Util.getI18NMsg(request, "IAM.TFA.RECOVERYUPDATE.SUBTXT") %>
	</div>
	<div style="margin-top: 20px;">
	<div style="float: left;">
		<div class="rec-list-heading" style="width: 162px;">
		<%=Util.getI18NMsg(request, "IAM.TFA.BACKUP.NUMBER") %>
		</div>
		<div class="rec-list-content">
		<%if(hasBackupNumbers){ 
			for(UserPhone phone : backupNumbers) {
				int dailingCode = -1;
				String displayPhone = null;
			    if(phone.getCountryCode() != null){
			    	dailingCode = SMSUtil.getISDCode(phone.getCountryCode());	
			    }
			    displayPhone = dailingCode != -1 ? "(+"+ dailingCode+") "+ phone.getPhoneNumber() : phone.getPhoneNumber();//No I18N
			%>
			<div style="margin-top:10px">
			<div style="float: left;font-weight: bold;"><%=IAMEncoder.encodeHTML(displayPhone)%></div>
			<br>
			<div>
			<%if(usesSms){ %>
				<a href="javascript:void(0);" class="hyperlink" onclick="confirmMakePrimary('<%=IAMEncoder.encodeJavaScript(phone.getPhoneNumber())%>')"><%=Util.getI18NMsg(request, "IAM.MYEMAIL.MAKE.PRIMARY") %></a>
			<%} %>
			</div>
			</div>
			<div style="clear:both;"></div>
			
		<%}
		} else {%>
			<div>
				<%=Util.getI18NMsg(request, "IAM.TFA.NOT.SAVED.BACKUP.PHONE") %>
			</div>
		<%} %>
		<a href="javascript:void(0);" class="hyperlink" onclick="popup('show','phonenumbers_popup');$('#mobileno').focus();" style="margin-top:5px;"><%=Util.getI18NMsg(request, "IAM.TFA.ADD.BACKUP.NUMBER") %></a>
		</div>
	</div>
	<div style="float: left;">
		<div class="rec-list-heading" style="width: 170px;">
		<%=Util.getI18NMsg(request, "IAM.BACKUP.VERIFICATION.CODE") %>
		</div>
		<div class="rec-list-content">
			<div style="margin-top:10px">
			<%=Util.getI18NMsg(request, "IAM.TFA.BACKUP.CODES.COUNT.MSG",recoveryCodesCount) %>
			</div>
			<%if(createdTime != -1) {%>
			<div style="margin-top: 10px;">
				<%=Util.getI18NMsg(request, "IAM.GENERATEDTIME") %>&nbsp;:&nbsp;<span style="font-weight: bold;"><%=df.format(new Date(createdTime))%></span><%-- NO OUTPUTENCODING --%>
			<%}%>
			
			<%if(alreadySavedCodes){ 
				long savedTime = saveTypeProperty.getModifiedTime() != 0 ? saveTypeProperty.getModifiedTime() : saveTypeProperty.getCreatedTime();
				if(TFARecoveryPreference.SAVE_TEXT.getValue().equalsIgnoreCase(saveTypeProperty.getPropValue()) && (jsonBackupInfo != null)) {
					String browserName = jsonBackupInfo.optString(TFAPrefServlet.TFA_BROWSER_KEY);
					String oSName = jsonBackupInfo.optString(TFAPrefServlet.TFA_OS_KEY);
					if(Util.isValid(browserName) && Util.isValid(oSName) && savedTime != -1){%>
							<div style="margin-top: 10px;">
								<%=Util.getI18NMsg(request, "IAM.TFA.SAVEDCODE.SAVETXT.MSG",IAMEncoder.encodeHTML(oSName),IAMEncoder.encodeHTML(browserName),df.format(new Date(savedTime))) %> <%--No I18N--%>
							</div>		
					<%}
				} else if(TFARecoveryPreference.PRINT_CODES.getValue().equalsIgnoreCase(saveTypeProperty.getPropValue()) && savedTime != -1) { %>
				<div style="margin-top: 10px;">
				<%=Util.getI18NMsg(request, "IAM.TFA.SAVEDCODE.PRINTCODES.MSG",df.format(new Date(savedTime)))%>
				</div>
			<%}else if(TFARecoveryPreference.EMAIL.getValue().equalsIgnoreCase(saveTypeProperty.getPropValue())) {
			String email = jsonBackupInfo.optString(TFAPrefServlet.TFA_RECOVERY_EMAIL_KEY);
			if(Util.isValid(email) && savedTime != -1) {%>
			<div style="margin-top: 15px;">
			<%=Util.getI18NMsg(request, "IAM.TFA.SAVEDCODE.EMAIL.MSG",IAMEncoder.encodeHTML(email),df.format(new Date(savedTime))) %> <%--No I18N--%>
			</div>
			<%}
			} 
		}%></div>
				<a href="javascript:void(0);" class="hyperlink" onclick="popup('show','managereccodes_popup')" style="margin-top:5px;"><%=Util.getI18NMsg(request, "IAM.TFA.SHOW.BACKUPCODES") %></a>
		</div>
	</div>
	</div>
	<div style="clear: both;"></div>
	<div style="margin-top: 20px;">
	</div>
	<div style="clear: both;"></div>
	<div style="margin-bottom: 20px;">
	<a href="<%=IAMEncoder.encodeHTMLAttribute(TwoFactorUrl)%>" style="margin-right: 5px;" target="_blank"><button class="saveBtn" style="cursor: pointer;padding: 4px;"><%=Util.getI18NMsg(request, "IAM.TFA.MANAGE.TFA.SETTINGS") %></button></a>
	<a href="javascript:void(0);" onclick="checkRecoveryskip('<%=IAMEncoder.encodeJavaScript(Announcement.getVisitedNextURL(request))%>')"><button class="cancelBtn" style="cursor: pointer;"><%=Util.getI18NMsg(request, "IAM.CONTINUE") %></button></a>
	</div>
</div>
</div>
</div>
</td></tr>
<tr><td valign="bottom"><%@ include file="../unauth/footer.jspf" %></td></tr>
</table>

<!-- Generate Recovery Codes -->
<div id="managereccodes_popup" class="maincontentdiv" style="display:none;left: 23%;top: 20%;">
	<div class="popupheading">
	<div class="fllt mtop"><%=Util.getI18NMsg(request, "IAM.TFA.MANAGE.BACKUP.CODES")%></div>
	<div class="popupclose" onclick="closeDiv();"></div>
	<span style="display: inline-block;">&nbsp;</span>
	</div>
	<div class="border-dotted">&nbsp;</div>
	<div class="contentpadding">
	<div style="line-height: 16px;">
	<%=Util.getI18NMsg(request, "IAM.LIST.BACKUPCODES.SUBTITLE")%>
	</div>
	<div style="margin-top: 20px;"><%=Util.getI18NMsg(request, "IAM.BACKUP.VERIFICATION.CODE")%></div>
	<div style="background-color:#f0f0f0;padding: 1px 1px 11px;width: 315px;">
	<div id="displaycode" style="line-height: 25px;">
	<%if(hasRecoveryCodes){%>
		<ol>
		<%for(String val : recoveryCodesArray){
			String displayVal = "<span style='margin-left:5px'>"+ val.substring(0, 4)+"</span><span style='margin-left:5px'>"+val.substring(4, 8)+"</span><span style='margin-left:5px'>"+val.substring(8)+"</span>";//No I18N%>
			<li><b><%=displayVal%></b></li> <%-- NO OUTPUTENCODING --%>
			<%}%>
		</ol>
	<%}%>
	</div>
	<div style="margin-top: 10px;margin-left: 35px;">
		<button class="greenbutton" onclick="saveAsText();"><%=Util.getI18NMsg(request, "IAM.TFA.SAVEAS.TEXT")%></button>
		<button class="greenbutton" id="printcodesbutton" onclick="printDoc('<%=IAMEncoder.encodeJavaScript(user.getFullName())%>','<%=IAMEncoder.encodeJavaScript(recoveryCodes)%>');"><%=Util.getI18NMsg(request, "IAM.TFA.PRINT.CODES") %></button>
		<button class="greenbutton" onclick="closeDiv();popup('show','sendbkp_email_popup');de('pref_recovery_email').focus();"><%=Util.getI18NMsg(request, "IAM.EMAIL.CONFIRMATION.SEND.EMAIL")%></button>
	</div>
	</div>
	<div style="margin-top: 8px;">
		<span><%=Util.getI18NMsg(request, "IAM.GENERATEDTIME")%>&nbsp;:&nbsp;</span>
		<span style="color:#444;font-weight: bold;" id="createdtime">
		<%if(createdTime != -1) {%>
			<%=df.format(new Date(createdTime))%>	<%-- NO OUTPUTENCODING --%>
		<%}%>
		</span>
	</div>
	
	<div style="margin-top: 20px;">
		<button id="gen_new_button" class="saveBtn" onclick="generateRecoveryCode('<%=IAMEncoder.encodeJavaScript(user.getFullName())%>');"><%=Util.getI18NMsg(request, "IAM.TFA.GENERATE.NEW")%></button>
	</div>
	<div class="error" id="generrordiv" style="margin-top:5px;margin-bottom: 0px;clear:both;display:none;"></div>
	</div>
</div>

<!--Add Phone Numbers  -->
<div id="phonenumbers_popup" class="maincontentdiv" style="display:none;left: 23%;top: 20%;">
<div class="popupheading">
	<span class="fllt mtop"><%=Util.getI18NMsg(request, "IAM.TFA.ADD.BACKUP.NUMBERS")%></span>
	<span class="popupclose" onclick="closeDiv();"></span>
	<span style="display: inline-block;">&nbsp;</span>
</div>
<div class="border-dotted">&nbsp;</div>
<div class="contentpadding">
<div id="addphNoDiv" style="display:;">
<div class="tfapref_heading"><%=Util.getI18NMsg(request, "IAM.TFA.SETUP.MESSAGE")%></div>
	<div style="margin-top: 10px">
		<div class="phvalname_tfapref">
			<%=Util.getI18NMsg(request, "IAM.PHONE.NUMBER")%>&nbsp;:&nbsp;
		</div>
		<div>
			<span class="prefvalue">
			<select id="countNameAddDiv" name="countNameAddDiv" style="width:110px">
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
			<input type="text" id="mobileno" class="tfainput" style="width: 125px;" placeholder="<%=Util.getI18NMsg(request, "IAM.ENTER.PHONE.NUMBER")%>" onkeyup="$(this).siblings('.error').hide();if(event.keyCode==13) addMobile();">
			<input type="hidden" id="phmobNo" />
		</div>
	</div>
	<div style="margin-top: 10px;">
		<div class="phvalname_tfapref">
			<span><%=Util.getI18NMsg(request, "IAM.TFA.SEND.CODE.BY")%>&nbsp;:&nbsp;</span>
		</div>
    	<div class="prefvalue">
    	    <span>
    	    <a href="javascript:checkRadioandChangeButton('prefaddsms')">
    	        <span id="spanprefaddsms" class="icon-medium radio-checked"></span>
				<input type="radio" name="prefradio" style="display:none;float:left;" value="1" id="prefaddsms" checked/>
				<span class="phoneradio-span" style="color:#333;"><%=Util.getI18NMsg(request, "IAM.TFA.SMS.TEXT.MESSAGE")%></span>
			</a>
			</span>
			<span>
			<a href="javascript:checkRadioandChangeButton('prefaddcall')">
				<span id="spanprefaddcall" class="icon-medium radio-unchecked" style="float:clear;"></span>
				<input type="radio"  name="prefradio" style="display:none" value="2" id="prefaddcall"/>
				<span class="phoneradio-span" style="color:#333;"><%=Util.getI18NMsg(request, "IAM.TFA.VOICE.CALL")%></span>
				</a>
       		</span>
       		<span style="clear:both;">&nbsp;</span>
    	</div>
	</div>
	<div class="tfapref_marleft" style="margin-top:25px">
	<a href="javascript:void(0);" class="bluebutton" onclick="addMobile()" id="textme"><%=Util.getI18NMsg(request, "IAM.SEND.SMS")%></a>
	<a href="javascript:void(0);" class="bluebutton" onclick="addMobile()" id="callme" style="display: none;"><%=Util.getI18NMsg(request, "IAM.SEND.CALL")%></a>
	<a href="javascript:void(0);" class="whitebutton" onclick="closeDiv();"><%=Util.getI18NMsg(request, "IAM.CANCEL")%></a>
	</div>
</div>
<div id="verifyphNoDiv" style="display:none;">
<div id="codeSentMsg" class="tfapref_heading"></div>
<div style="margin-top:10px;">
	<div class="phvalname_tfapref"><%=Util.getI18NMsg(request, "IAM.VERIFY.CODE")%>&nbsp;:&nbsp;</div>
	<div>
		<input type="text" id="vcode" class="tfainput" onkeyup="$(this).siblings('.error').hide();if(event.keyCode==13) verifyCode('rec_update');" placeholder="<%=Util.getI18NMsg(request, "IAM.TFA.ENTER.VERIFICATION.CODE")%>">
	</div>
</div>
<div style="margin-top:10px;">
	<div class="phvalname_tfapref">
		<%=Util.getI18NMsg(request, "IAM.CURRENT.PASS")%>&nbsp;:&nbsp;
	</div>
	<div>
		<input type="password" id="phpass_tfapref" class="tfainput" onkeyup="$(this).siblings('.error').hide();if(event.keyCode==13) verifyCode('rec_update');" placeholder="<%=Util.getI18NMsg(request, "IAM.USER.EMAIL.ADD.PASSWORD.PLACEHOLDER")%>" />
	</div>
</div>
<div class="tfapref_marleft" style="margin-top: 15px;">
	<a href="javascript:void(0);" class="bluebutton" onclick="verifyCode('rec_update');"><%=Util.getI18NMsg(request, "IAM.TFA.ENTER.VERIFICATION.CODE")%></a>
	<a href="javascript:void(0);" class="whitebutton" onclick="closeDiv();"><%=Util.getI18NMsg(request, "IAM.CANCEL")%></a>
	
</div>
<div class="tfapref_marleft phsub_tfapref">
<%=Util.getI18NMsg(request, "IAM.TFA.DIDNT.RECEIVE.CODE")%>
</div>
<div class="tfapref_marleft">&nbsp;-&nbsp;<a href="javascript:void(0);" class="hyperlink" onclick="resendVerificationCode()" ><%=Util.getI18NMsg(request, "IAM.TFA.RESEND.CODE") %></a></div>
</div>
</div>
</div>

<!-- General Success Message -->
<div id="msgpopup_div" class="rec-success-popup" style="display:none;">
		&nbsp;<span id="msgpopup_panel"></span>&nbsp;
</div>

<!-- tfa pop up -->
<div id="tfaopacity" onclick="closeDiv();" style="display:none;"></div>

<!-- Send Email popup -->
<div id="sendbkp_email_popup" class="maincontentdiv" style="display:none;left: 23%;top: 20%;">
	<div class="popupheading">
		<span class="fllt mtop"><%=Util.getI18NMsg(request, "IAM.EMAIL.CONFIRMATION.SEND.EMAIL") %></span>
		<span class="popupclose" onclick="closeDiv();"></span>
		<span style="display: inline-block;">&nbsp;</span>
	</div>
	<div class="border-dotted">&nbsp;</div>
	<div class="contentpadding">
	<div><%=Util.getI18NMsg(request, "IAM.TFA.RECOVERY.EMAIL.SUBTXT") %><div>
	<div style="margin-top: 10px;background-color: #FEFF98;color: #476E01;padding: 7px;"><%=Util.getI18NMsg(request, "IAM.NOTE")%>&nbsp;:&nbsp;<%=Util.getI18NMsg(request, "IAM.TFA.RECOVERY.EMAIL.WARNING") %></div>
	<div style="margin-top: 20px;">
	<div div class="tfaprefname" style="width: 200px;">
		<%=Util.getI18NMsg(request, "IAM.ENTER.EMAIL") %>&nbsp;:&nbsp;
	</div>
	<div class="tfaprefvalue" style="padding:5px 0px;"><input type=text class="tfainput" id="pref_recovery_email" placeholder="<%=Util.getI18NMsg(request, "IAM.USER.ADD.EMAIL.PLACEHOLDER") %>" onkeyup="$('#pref_recovery_email').siblings('.error').hide();if(event.keyCode == 13) de('pref_recovery_pass').focus();" /></div>
	<div div class="tfaprefname" style="width: 200px;">
		<%=Util.getI18NMsg(request, "IAM.LABEL.ENTER.ZOHO.PASSWORD") %>&nbsp;:&nbsp;
	</div>
	<div class="tfaprefvalue" style="padding:5px 0px;"><input type=password class="tfainput" id="pref_recovery_pass" placeholder="<%=Util.getI18NMsg(request, "IAM.USER.EMAIL.ADD.PASSWORD.PLACEHOLDER") %>" onkeyup="$('#pref_recovery_pass').siblings('.error').hide();if(event.keyCode == 13) sendBackupCodesEmail('pref');" /></div>
	
	<div style="margin-left: 196px;margin-top: 19px;">
	<button class="configure_blue_button" onclick="sendBackupCodesEmail('pref');"><%=Util.getI18NMsg(request, "IAM.EMAIL.CONFIRMATION.SEND.EMAIL") %></button>
	<button class="configure_grey_button" onclick="closeDiv();"><%=Util.getI18NMsg(request, "IAM.CANCEL")%></button>
	</div>
	</div>
	</div>
</div>
</div>
</div>

<div id="backup_codes" class="maincontentdiv" style="display:none;text-align:left;width: 500px;">
	<div class="popupheading">
		<span class="fllt mtop"><%=Util.getI18NMsg(request, "IAM.TFA.RECOVERY.SAVECODES") %></span>
		<span class="popupclose" onclick="popup('hide','backup_codes');"></span>
		<span style="display: inline-block;">&nbsp;</span>
	</div>
	<div class="border-dotted">&nbsp;</div>
	<div class="contentpadding">
		<%=Util.getI18NMsg(request, "IAM.TFA.RECOVERY.WARNING") %>&nbsp;<a href="<%=recoveryDocumentLink%>" class="hyperlink" target="_blank"><%=Util.getI18NMsg(request, "IAM.TFA.LEARN.MORE") %></a>
	</div>
	<div style="margin-top: 20px;padding-bottom: 10px;margin-left: 162px;float: left">
		<button type="submit" onclick="saveAsText();" class="greenbutton"><%=Util.getI18NMsg(request, "IAM.TFA.SAVEAS.TEXT")%></button>
		<button class="greenbutton" onclick="printDoc('<%=IAMEncoder.encodeJavaScript(user.getFullName())%>','<%=IAMEncoder.encodeJavaScript(recoveryCodes)%>');" style="margin-left: 5px;"><%=Util.getI18NMsg(request, "IAM.TFA.PRINT.CODES") %></button>
	</div>
	<div style="margin-top: 25px;padding-bottom: 20px;float: right;margin-right: 10px;">
	<a href="<%=IAMEncoder.encodeHTMLAttribute(Announcement.getVisitedNextURL(request))%>" class="hyperlink"><%=Util.getI18NMsg(request, "IAM.CONTINUE")%></a>
	</div>
</div>


<!-- Confirm Password Box -->
<div id="password_popup" class="maincontentdiv" style="width: 600px;display:none;left: 23%;top: 20%;">	
<div class="popupheading">
	<span class="fllt mtop"><%=Util.getI18NMsg(request, "IAM.PASSWORD.VERIFICATION")%></span>
	<span class="popupclose" onclick="closeDiv();"></span>
	<span style="display: inline-block;">&nbsp;</span>
</div>
<div class="border-dotted">&nbsp;</div>
<div class="contentpadding">
<div style="font-size:12px;"><%=Util.getI18NMsg(request, "IAM.TFA.MAKEPRIMARY.NOTE") %></div>
<div style="margin-left: 8px;margin-top: 15px;">
		<div class="tfaprefname" style="width: 180px;"><%=Util.getI18NMsg(request, "IAM.ENTER.PASSWORD")%>&nbsp;:&nbsp;</div>
		<div class="tfaprefvalue"><input type=password class="tfainput" id="pass_confirm" /></div>
</div>
<div style="margin:8px 0 7px 189px;">
	<a href="javascript:void(0);" class="bluebutton" id="mkprim_confirm"><%=Util.getI18NMsg(request, "IAM.TFA.VERIFY.PASSWORD")%></a>
	<a href="javascript:void(0);" class="whitebutton" onclick="closeDiv();"><%=Util.getI18NMsg(request, "IAM.CANCEL")%></a>
</div>
</div>
</div>
</body>

</html>