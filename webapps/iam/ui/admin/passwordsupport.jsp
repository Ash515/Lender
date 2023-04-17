<%-- $Id$ --%>
<%@page import="com.zoho.accounts.internal.util.AccountsInternalConst.TotpType"%>
<%@page import="com.zoho.accounts.AccountsProto.Account.User.OpenId"%>
<%@page import="com.zoho.iam2.rest.ProtoConverterUtil"%>
<%@page import="com.zoho.iam2.rest.ProtoUtil"%>
<%@page import="com.adventnet.iam.IdentityProvider"%>
<%@page import="com.zoho.accounts.internal.util.IPInfo"%>
<%@page import="com.zoho.accounts.AccountsConstants.UserStatus"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="com.zoho.accounts.Accounts.RESOURCE.OPENID"%>
<%@page import="com.adventnet.iam.servlet.TFAPrefServlet"%>
<%@page import="com.zoho.accounts.internal.util.AccountsInternalConst.TFARecoveryPreference"%>
<%@page import="com.zoho.accounts.Accounts.RESOURCE.USERSECRETKEY"%>
<%@page import="com.zoho.accounts.AccountsProto.Account.User.UserSecretKey"%>
<%@page import="com.zoho.accounts.cache.MemCacheConstants"%>
<%@page import="com.zoho.accounts.cache.MemCacheUtil"%>
<%@page import="com.zoho.accounts.phone.SMSUtil"%>
<%@page import="com.zoho.accounts.internal.util.AccountsInternalConst"%>
<%@page import="com.zoho.iam2.rest.RestProtoUtil"%>
<%@page import="com.zoho.iam2.rest.ProtoToZliteUtil"%>
<%@page import="org.json.JSONObject"%>
<%@page import="com.zoho.accounts.AccountsProto.Account.User.Properties"%>
<%@page import="com.zoho.resource.Criteria"%>
<%@page import="com.zoho.accounts.Accounts.RESOURCE"%>
<%@page import="com.zoho.accounts.AccountsConstants"%>
<%@page import="com.zoho.accounts.AccountsProto.Account.User.AppPassword"%>
<%@page import="com.zoho.accounts.internal.oauth2.OAuth2Util"%>
<%@page import="com.zoho.accounts.internal.oauth2.OAuthClientGrantDetails"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DateFormat"%>
<%@page import="com.zoho.accounts.AccountsConstants.TFAPrefOption"%>
<%@page import="com.zoho.accounts.AccountsProto.Account.User.Password"%>
<%@page import="com.adventnet.iam.UserEmail"%>
<%@page import="com.zoho.accounts.AccountsProto.Account.User.UserMobile"%>
<%@page import="com.adventnet.iam.internal.PhoneUtil"%>
<%@page import="com.adventnet.iam.security.UserAgent"%>
<%@page import="com.zoho.accounts.AccountsProto.Account.User.UserDevice"%>
<%@page import="com.zoho.accounts.AccountsProto.Account.User.Password"%>
<%@page import="com.zoho.accounts.Accounts"%>
<%@page import="com.zoho.accounts.AccountsProto.Account.User.UserAccountsProperties"%>
<%@page import="com.adventnet.iam.internal.Util"%>
<%@ include file="includes.jsp" %>
<%@ include file="../../static/includes.jspf" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%><%--No I18N--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<script src="<%=jsurl%>/email.js" type="text/javascript"></script>	<%-- NO OUTPUTENCODING --%>
<script src="<%=jsurl%>/allowedip.js" type="text/javascript"></script>	<%-- NO OUTPUTENCODING --%>

<%
      String qry=null;
    qry = request.getParameter("qry");
    String ip =null;
    ip = request.getParameter("ip");
%>
<head>
</head>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<div class="menucontent">
	<div class="topcontent"><div class="contitle">User Service Info</div></div><%--No I18N--%>
	<div class="subtitle">Complete user information based on service</div><%--No I18N--%>
</div>
<div class="maincontent" >
    <div class="field-bg">
	<div class="labelmain" id="searchuser" align="center">
	    <div class="searchfielddiv">
                <input type="text" name="search" id="search" placeholder="Email or Mobile" style="width:273px;height: 32px;margin-top: 1px;" class="unauthinputText" onmouseover="this.focus()" onkeypress="if(event.keyCode == 13){ findUser();return false;}"/>
	    </div>
	    <div class="searchfielddiv">
                <input type="text" name="ip" id="ip" placeholder="Remote IP" style="width:273px;height: 32px;margin-top: 1px;" class="unauthinputText" onmouseover="this.focus()" onkeypress="if(event.keyCode == 13){ findUser();return false;}"/>
	    </div>
	   <div style="float:left;">
			<div class="saveBtn" onclick="findUser()" style="margin-top: 7px;margin-left: 3px;" >Search</div><%--No I18N--%>
	    </div>
	</div>
    </div>
    
</div>
<%
if(ip != null){
    try{
    	IPUtil.IP_LONG(ip);
    }catch(Exception e){
    	%>
    	<div>Invalid IP Address</div>
    	<%
    	response.getWriter().write("INVALID IP ADDRESS");	//No I18N
    	return;
    }
    }
%>

<%
User u = null;
if(Util.isValid(qry)) {
	u = Util.USERAPI.getUser(qry);
	UserAccountsProperties userProperties = null;
	if(u != null && Util.isValid(ip)){
	 userProperties = Accounts.getUserAccountsPropertiesURI(u.getZaid(), u.getZUID()).GET();%>
	 
<table>

<tr>
<td class="usremailtd">USER </td> <%--No I18N--%>
<td class="usremailtd"><%= u.getPrimaryEmail() %></td><%-- NO OUTPUTENCODING --%>
</tr>
 
<tr>

<%
java.util.List<IPRange> ipr = Util.USERAPI.getAllowedIPRanges(u.getZUID());
%>
<tr>
<td class="usremailtd" id="remoteip" <%if(!Util.isIPInRange(ipr,ip)){ %>style="color:red" <%} %>>REMOTE IP </td> <%--No I18N--%>
<td class="usremailtd" id="remoteip1" <%if(!Util.isIPInRange(ipr,ip)){ %>style="color:red" <%} %>><%=IAMEncoder.encodeHTML(ip) %> <%if(!Util.isIPInRange(ipr,ip)){ %>  (Not in allowed IP Range)<%} %></td><%-- NO OUTPUTENCODING --%>
 </tr>

<%
IPInfo currentIPinfo = IPInfo.getIPInfo(ip);

boolean diffRegion = false;
if(currentIPinfo != null && !currentIPinfo.getCountryName().equals(userProperties.getLastLoginCountry()) && Util.isValid(userProperties.getLastLoginCountry())){
diffRegion = true;	
}
		
%>

<tr>
<td class="usremailtd">LAST LOGIN TIME </td> <%--No I18N--%>
<td class="usremailtd"><%= ((userProperties!=null && userProperties.getLastLoginTime() != -1) ? new Date(userProperties.getLastLoginTime()) : "") %> </td><%-- NO OUTPUTENCODING --%>
</tr>

<tr>
<td class="usremailtd">LAST LOGIN REGION </td> <%--No I18N--%>
<td class="usremailtd"  <%if(diffRegion){ %> style="color:red" <%} %> ><%= userProperties!=null && userProperties.getLastLoginCountry() != null ? userProperties.getLastLoginCountry() : ""  %> <%if(diffRegion){ %>  (Different login country) <%} %></td><%-- NO OUTPUTENCODING --%>
</tr>

<tr>
<td class="usremailtd">RECENT PASSWORD RESET TIME </td> <%--No I18N--%>
<%
Password pwd = Accounts.getPasswordURI(u.getZaid(), u.getZUID()).GET();
%>
<td class="usremailtd"><%= pwd!=null && pwd.getModifiedTime() != -1 ? new Date(pwd.getModifiedTime()) : "" %></td><%-- NO OUTPUTENCODING --%>
</tr>

</table>


<!-- ////////////////////////////////////////////    BASIC USER INFO     ////////////////////////////////////////////////////////////////// -->
    <div class="topcontent"><div class="contitle">Basic User Info</div></div> <%-- No I18N --%>
    
    <table>
    <tr><td class="usrinfotdlt">First Name</td>	<%--No I18N--%>
    <td class="usrinfotdrt"><%=u.getFirstName() %> </td></tr>	<%-- NO OUTPUTENCODING --%>
    <tr><td class="usrinfotdlt">Last Name</td>	<%--No I18N--%>
    <td class="usrinfotdrt"><%=Util.isValid(u.getLastName())? u.getLastName() : "  -"%> </td></tr>	<%-- NO OUTPUTENCODING --%>
    <tr><td class="usrinfotdlt">Time Zone</td>	<%--No I18N--%>
    <td class="usrinfotdrt"><%=u.getTimezone() %> </td></tr>	<%-- NO OUTPUTENCODING --%>
    <tr><td class="usrinfotdlt">Local Info</td>	<%--No I18N--%>
    <td class="usrinfotdrt"><%=u.getLocaleInfo() %> </td></tr>	<%-- NO OUTPUTENCODING --%>
    <tr><td class="usrinfotdlt">Registered Time</td>	<%--No I18N--%>
    <td class="usrinfotdrt"><%=new Date(u.getRegisteredTime()) %> </td></tr>	<%-- NO OUTPUTENCODING --%>
    <tr><td class="usrinfotdlt">Referrer</td>	<%--No I18N--%>
    <td class="usrinfotdrt"><%=u.getReferer() %> </td></tr>	<%-- NO OUTPUTENCODING --%>
    <tr><td class="usrinfotdlt">User Role</td>	<%--No I18N--%>
  <td class="usrinfotdrt"> <%
			    if(u.getUserRole() == 0 && u.getZOID() == -1) {
				out.println("User"); //No I18N
			    } else if(u.getUserRole() == 0 && u.getZOID() != -1) {
				out.println("Org User"); //No I18N
			    } else if((u.getUserRole() == 1 || u.getUserRole() == 2) && u.getZOID() != -1) {
				out.println("Org Admin"); //No I18N
				} else if(u.getUserRole()==3 && u.getZOID() != -1) {
					out.println("Partner Admin"); //No I18N
				}
			%>
			</td></tr>

	<% String mob = null;
	UserMobile um1[] = PhoneUtil.getUserVerifiedNumbers(u);
	if(um1 != null){ %>
		<tr> <td class="usrinfotdlt">Numbers associated to account</td><%--No I18N--%>
		<td class="usrinfotdrt">
		<%
		for(UserMobile umob:um1){
			mob = umob.getMobile();
		%>
		<%=mob +";     "%>	<%-- NO OUTPUTENCODING --%>
		<%
			}
		}
	%>
    </td>
    </tr>
    
    <%
List<UserEmail> emails1 = u.getEmails();
if(emails1!=null){
	%>
	<tr> <td class="usrinfotdlt"> Emails associated to account</td><%--No I18N--%>
	<td class="usrinfotdrt">
	<%
	for(UserEmail email : emails1){		%>
		<%=email.isEmailId() ? email.getEmailId() + ";  ": ""%>	<%-- NO OUTPUTENCODING --%>
<%			}
		}
%>
    </td></tr>
    
<tr><td class="usrinfotdlt">Mobile Apps</td>	<%--No I18N--%>
<td class="usrinfotdrt">
<%
List<ISCTicket> userticket1 = null;
userticket1 = Util.USERAPI.getAllISCTickets(u.getZUID(), false);
List<OAuthClientGrantDetails> retLis1 = new ArrayList<OAuthClientGrantDetails>(); 
retLis1 = OAuth2Util.getAllUserApprovedClients(u, true);

if(retLis1 != null){
%>

<%
for(OAuthClientGrantDetails clientList : retLis1){
%>				
<%=IAMEncoder.encodeHTML(clientList.getGetMobileClientName()) + ";  "%>
									
<%					
 }
}
	if(userticket1 != null){
		for (ISCTicket tickets : userticket1) {
		%>
		<%=tickets.getDisplayName() + ";  " %> <%-- NO OUTPUTENCODING --%>
		<%
		}
	}
	
%>
</td></tr>

<tr><td class="usrinfotdlt">Services</td>	<%--No I18N--%>

<td class="usrinfotdrt">
<%
List<UserAccount> ualistActive1 = Util.USERAPI.getUsedAccounts(u.getZUID());
 if(ualistActive1 != null && !ualistActive1.isEmpty()) {
	for(UserAccount ua : ualistActive1) {
		Service usedService1 = ua != null ? Util.SERVICEAPI.getService(ua.getServiceId()) : null;
		String serviceName = usedService1 != null ? usedService1.getServiceName() : null;
		%>
<%=serviceName + ";  " %><%-- NO OUTPUTENCODING --%>
<%
	}
	}
%>


</td></tr>


    </table>


<!-- //////////////////////// ALLOWED IPs SECTION   ////////////////// -->
<%if(ipr!=null){ %>
<div class="topcontent"><div class="contitle">Allowed IPs</div></div> <%-- No I18N --%>
<div class="allowedipmain">
			<div class="allowediptab">
			    <div class="fromto"><%=Util.getI18NMsg(request,"IAM.ALLOWEDIP.FROMIP.ADDRESS")%></div>
			    <div class="fromto"><%=Util.getI18NMsg(request,"IAM.ALLOWEDIP.TOIP.ADDRESS")%></div>
			</div>
		    <%for(IPRange cntipr1 : ipr){%>
			<div class="allowedips" >
			    <div class="configip"><%=IAMEncoder.encodeHTML(cntipr1.getFromIPAsString())%></div>
			    <div class="configip"><% if(cntipr1.getToIPAsString()!=null){ %><%=IAMEncoder.encodeHTML(cntipr1.getToIPAsString())%><%}%></div>
			</div>
		    <%}
		    }%>
		    </div>
		    
<!-- ////////////////    TFA DETILS SECTION  ////////////////// -->		
<div class="topcontent"><div class="contitle">TFA Details</div></div> <%-- No I18N --%>
<div id="tfasetting_maincontainer" style="font-size: 12px;padding: 10px;line-height: 20px;margin-left: 50px;">
<%
long zuid = u.getZUID();
boolean isTFAConfiguredByUser = Util.isTFAEnabled(u);
UserPreference userPreference = u.getUserPreference();
boolean usesGAuthenticator = userPreference!= null && (userPreference.getTFAPrefOption() == TFAPrefOption.ENABLE_TFA_SMART_PHONE);
boolean usesSms = userPreference!= null && (userPreference.getTFAPrefOption() == TFAPrefOption.ENABLE_TFA_SMS);
boolean isEnforcedandNotSet = false;

if(u.isOrgUser()) {
	boolean isTFAEnableduser = Util.USERAPI.isTFAPrefOptionEnabled(u.getZUID());
	if(isTFAEnableduser) {
		if(userPreference == null) {
			isEnforcedandNotSet = true;
		}else {
			if(userPreference.isUsingTFA()){
				isEnforcedandNotSet = !Util.checkIfUserHasTFASpecificData(u, userPreference);
			}
		}
	}
	if(isEnforcedandNotSet){
		isTFAConfiguredByUser = false;
	}
}
long recoveryCodesCount = Accounts.getRecoveryCodeURI(u.getZaid(), u.getZUID()).COUNT();
AppPassword[] appPasswords = Accounts.getAppPasswordURI(u.getZaid(), u.getZUID()).GETS();
List<UserSession> listSessions = CSPersistenceAPIImpl.getUserTFASession(u.getZUID());

Properties saveTypeProperty = Accounts.getPropertiesURI(u.getZaid(), u.getZUID(),Util.appendIAMPropertyPrefix(TFAPrefServlet.TFA_RECOVERY_PREFERENCE)).GET();
boolean alreadySavedCodes = saveTypeProperty != null;
Properties backupinfoProperty = alreadySavedCodes ? Accounts.getPropertiesURI(u.getZaid(), u.getZUID(),Util.appendIAMPropertyPrefix(TFAPrefServlet.TFA_BKPCODES_INFO)).GET() : null;
boolean hasBackupInfo = backupinfoProperty != null;
String propJsonString = hasBackupInfo ? backupinfoProperty.getPropValue() : null;
JSONObject jsonBackupInfo = hasBackupInfo ? new JSONObject(propJsonString) : null;

%>
<%if(!isTFAConfiguredByUser) {%>
	<%if(isEnforcedandNotSet){ %>
	<div style="margin: 30px 0px 19px 0px;background-color: #FEE1E1;border: 1px solid #FAB9B9;padding: 4px;float: left;font-size: 11px;">
	<div>TFA is Enforced on this user by the org admin, but the user has not configured TFA.</div> <%-- No I18N --%>
	<div>Possible reasons could be</div> <%-- No I18N --%>
	<ul>
	<li>
		User has not logged in after TFA is enforced. <%-- No I18N --%>
	</li>
	<li>
		Admin has reset TFA for this user. <%-- No I18N --%>
	</li>
	</ul>
	</div>
	<%}else{ %>
		<div style="margin: 30px 0px 19px 0px;background-color: #FEE1E1;border: 1px solid #FAB9B9;padding: 4px;float: left;font-size: 11px;">
			User has not configured TFA <%-- No I18N --%>
		</div>
	<%} %>
<%} else {
String pref = TFAPrefOption.getPrefOption(u.getUserPreference().getTFAPrefOption());
%>

<div style="margin: 30px 0px 19px 0px;background-color: #C7EAC7;border: 1px solid #98CE98;padding: 4px;float: left;font-size: 11px;">
			User has Configured TFA using <span style="font-weight: bold;"><%=IAMEncoder.encodeHTML(pref)%></span>. <%-- No I18N --%>
	</div>
<%} %>
<div style="clear: both;"></div>

<%
int dialingCode=-1;
List<UserPhone> phoneList = ProtoToZliteUtil.toUserPhoneNumbers((UserMobile[]) RestProtoUtil.GETS(Accounts.getUserMobileURI(u.getZaid(),u.getZUID())));
List<UserPhone> backupNumbers = new ArrayList<UserPhone>();
List<UserPhone> unverifiedNumbers = new ArrayList<UserPhone>();
List<UserPhone> allBackupPhones = new ArrayList<UserPhone>();
UserPhone tfaNumber=null;
if (phoneList != null) {
		for (UserPhone val : phoneList) {
			if(val.isVerified()){
				if(val.getMode()==AccountsInternalConst.UserMobileMode.TFA_NUMBER.getValue() && val.isPrimary() && usesSms){
					tfaNumber=val;
					dialingCode=SMSUtil.getISDCode(tfaNumber.getCountryCode());
				}else if(val.getMode()==AccountsInternalConst.UserMobileMode.TFA_NUMBER.getValue()){
					backupNumbers.add(val);
				}
			}else{
				unverifiedNumbers.add(val);
			}
		}
	}
boolean hasBackupNumbers = (backupNumbers != null)&& (backupNumbers.size() > 0);
boolean hasUnverifiedNumbers = (unverifiedNumbers != null) && (unverifiedNumbers.size() > 0);
%>

<div style="font-weight: bold;text-decoration: underline;">
	TFA Number <%-- No I18N --%>
</div>
<div>
<%if(!usesGAuthenticator) { %>
	
	<%if(tfaNumber!=null){ %>
		<%=IAMEncoder.encodeHTML("(+"+dialingCode+")"+tfaNumber.getPhoneNumber()) %>
		<%
		String displaybackup = null;
		%>
<script type="text/javascript" src="js/admin.js"></script>
	<%}else{ %>
		User doesn't have a TFA number. <%-- No I18N --%>
	<%} %>
<%}else{ 
	UserSecretKey usk = Accounts.getUserSecretKeyURI(u.getZaid(), u.getZUID()).getQueryString().setCriteria(new Criteria(USERSECRETKEY.IS_PRIMARY,true).and(new Criteria(USERSECRETKEY.IS_VERIFIED,true)).and(new Criteria(USERSECRETKEY.KEY_TYPE, TotpType.totp.getIntValue()))).build().GET();
	if(usk != null) { %>
		User has Configured Google Authenticator using the label <span style="font-weight: bold;"><%=IAMEncoder.encodeHTML(usk.getKeyLabel())%></span> <%-- No I18N --%>
	<%} %>	
<%}%>
</div>
<div style="font-weight: bold;text-decoration: underline;margin-top: 15px;">
	TFA-Backup Number(s) <%-- No I18N --%>
</div>
<%if(hasBackupNumbers || hasUnverifiedNumbers){ %>
<div>User has <%-- No I18N --%>
<%=backupNumbers.size() %> verified backup phones and <%=unverifiedNumbers.size()%> unverified phones</div>  <%-- NO OUTPUTENCODING --%> <%-- No I18N --%> 
<ol>
<%
allBackupPhones.addAll(backupNumbers);
allBackupPhones.addAll(unverifiedNumbers);
String verificationStatusMessage = null;
  for(UserPhone phone : allBackupPhones) {
	dialingCode = -1;
	String displaybackup = null;
	if(phone.getCountryCode() != null){
		dialingCode = SMSUtil.getISDCode(phone.getCountryCode());		
	}	
	if(!phone.isVerified()){
		verificationStatusMessage = " ( Unverified ) ";	//No I18N
	}
	else verificationStatusMessage = " ( Verified ) "; // No I18N
	
	displaybackup = dialingCode != -1 ? "(+" + dialingCode + ") " + phone.getPhoneNumber() : phone.getPhoneNumber();
	%>
<li><%=IAMEncoder.encodeHTML(displaybackup)%></li>
</ol>
<%}
  }else {%>
<div>User has no backup phones</div> <%-- No I18N --%>
<%} %>
<div style="font-weight: bold;text-decoration: underline;margin-top: 15px;">
	Backup Verification Codes <%-- No I18N --%>
</div>
<div>
<%if(recoveryCodesCount == 0){ %>
	User doesn't have any backup codes <%-- No I18N --%>
<%}else{ %>
	<span style="font-weight: bold;"><%=recoveryCodesCount%> un-used</span> backup codes&nbsp; <%-- No I18N --%>
	<%if(alreadySavedCodes){
				long savedTime = saveTypeProperty.getModifiedTime() != 0 ? saveTypeProperty.getModifiedTime() : saveTypeProperty.getCreatedTime();
				if(TFARecoveryPreference.SAVE_TEXT.getValue().equalsIgnoreCase(saveTypeProperty.getPropValue()) && (jsonBackupInfo != null)) {
					String browserName = jsonBackupInfo.optString(TFAPrefServlet.TFA_BROWSER_KEY);
					String oSName = jsonBackupInfo.optString(TFAPrefServlet.TFA_OS_KEY);
					if(Util.isValid(browserName) && Util.isValid(oSName) && savedTime != -1){%>
							<span>
								(Codes saved on <span style="font-weight: bold;"><%=IAMEncoder.encodeHTML(oSName)%></span> from <span style="font-weight: bold;"><%=IAMEncoder.encodeHTML(browserName)%></span> browser on <%=new Date(savedTime) %>) <%--No I18N--%>
							</span>		
					<%} else {%>
					<span>(Codes not saved)</span> <%-- No I18N --%>
					<%}
				} else if(TFARecoveryPreference.PRINT_CODES.getValue().equalsIgnoreCase(saveTypeProperty.getPropValue()) && savedTime != -1) { %>
				<span>
				(<span style="font-weight: bold;">printed backup codes</span> on <%=new Date(savedTime)%>) <%-- No I18N --%>
				</span>
			<%}else if(TFARecoveryPreference.EMAIL.getValue().equalsIgnoreCase(saveTypeProperty.getPropValue()) && jsonBackupInfo != null) {
			String email = jsonBackupInfo.optString(TFAPrefServlet.TFA_RECOVERY_EMAIL_KEY);
			if(Util.isValid(email) && savedTime != -1) {%>
			<span>
			(Codes sent to email - <span style="font-weight: bold;"><%=IAMEncoder.encodeHTML(email) %></span> on <%= new Date(savedTime)%>) <%-- No I18N --%>
			</span>
			<%} else {%>
				<span>(Codes not saved)</span> <%-- No I18N --%>	
			<%}
			} 
		} else {%>
			<span>(Codes not saved)</span> <%-- No I18N --%>	
		<%} %>
<%} %>
</div>
<div style="font-weight: bold;text-decoration: underline;margin-top: 15px;">
	App Specific Passwords <%-- No I18N --%>
</div>
<div>
<%if(appPasswords != null) { %>
User has <span style="font-weight: bold;"><%=appPasswords.length %></span> app specific passwords. <%-- NO OUTPUTENCODING --%> <%-- No I18N --%>
<div style="text-decoration: underline;">Key Labels :</div> <%-- No I18N --%>
<ol>
<%
for(AppPassword appPassword : appPasswords) {%>
	<li><%=IAMEncoder.encodeHTML(appPassword.getKeyLabel())%></li>
<%}%>
</ol>
<%}else{ %>
User doesn't have any app passwords. <%-- No I18N --%>
<%} %>
</div>
<div style="font-weight: bold;text-decoration: underline;margin-top: 15px;">
Trusted Browsers <%-- No I18N --%>
</div>
<div>
<%if(listSessions != null && listSessions.size() > 0){ 
%>
<table border="1" style="border:1px solid #a39e9e;border-collapse: collapse;width: 600px;margin-top: 10px;">
	<tr style="background-color: whitesmoke;">
		<td style="width:40%;padding:5px;">Started Time</td> <%-- No I18N --%>
		<td style="width:20%;padding:5px;">Browser</td> <%-- No I18N --%>
		<td style="width:40%;padding:5px;">Connected From IP Address</td> <%-- No I18N --%>
	</tr>
	<%for(UserSession us : listSessions) {
		UserAgent userAgent = new UserAgent(us.getUserAgent());
	    String browserclass = null;
	    if(userAgent != null) {
	    	if(userAgent.getBrowserName().toLowerCase().contains("firefox")) {
	    		browserclass = "firefox"; //No I18n
	    	}else if(userAgent.getBrowserName().toLowerCase().contains("chrome")) { //No I18n
	    		browserclass = "chrome"; //No I18n
	    	}else if(userAgent.getBrowserName().toLowerCase().contains("opera")) { //No I18n
	    		browserclass = "opera"; //No I18n
	    	}else if(userAgent.getBrowserName().toLowerCase().contains("safari")) { //No I18n
	    		browserclass = "safari"; //No I18n 
	    	}else if(userAgent.getBrowserName().toLowerCase().contains("ie")) { //No I18n
	    		browserclass = "ie"; //No i18N
	    	}
	    }
	%>
		<tr style="border:1px solid #a39e9e;">
		<td>
		<%=new Date(us.getStartTime())%> <%-- NO OUTPUTENCODING --%>		</td>
		<td>
		<div title="<%=IAMEncoder.encodeHTMLAttribute(us.getUserAgent())%>" style="cursor: help;">
			<span <%if(browserclass != null){ %>class="<%=browserclass%>" <%} %>></span>
			<span style="margin-left: 7px; display: inline-block; margin-top: 3px;"><%=IAMEncoder.encodeHTML(userAgent.getBrowserName())%></span>
		</div>
		</td>
		<td>
		<%=IAMEncoder.encodeHTML(us.getFromIP())%>
		</td>
		</tr>
	<%}%>
</table>
<%} else {%>
User doesn't have any trusted sessions. <%-- No I18N --%>
<%} %>
</div>
</div>


<!-- ////////////////////////   LINKED ACCOUNTS (FB,yahoo)    //////////////////////////////////// -->

<%
	OpenId[] sysopenIDS = Accounts.getOpenIdURI(u.getZaid(), u.getZUID()).GETS();
    %>

		<div class="topcontent"><div class="contitle"><%=Util.getI18NMsg(request,"IAM.LINKED.ACCOUNTS")%></div></div>

<%
List<OpenId> nonZohoOpenIDs = new ArrayList<OpenId>();
if(sysopenIDS !=  null && sysopenIDS.length > 0 ) {
	 
	 for(OpenId sys : sysopenIDS) {
	    	if(sys.getIdp() != AccountsConstants.IdentityProvider.ZOHO.dbValue()) {
	    		//nonZohoOpenIDs.add(sys);
	    	}
	    	nonZohoOpenIDs.add(sys);
	 }
}
	boolean isFirstTime=true;
	if(nonZohoOpenIDs.size() > 0) { %>
	
	<table>
	<%
    for(OpenId sys : nonZohoOpenIDs) {
    	if(sys.getIdp() != AccountsConstants.IdentityProvider.ZOHO.dbValue() && sys.getIdp() != -1) {
    		String idp = AccountsConstants.IdentityProvider.valueOfInt(sys.getIdp()).name();
    		if(isFirstTime){ 
    			isFirstTime=false;
    	%>
				<tr><td class="usrinfotdlt"><%=Util.getI18NMsg(request,"IAM.EMAIL.ADDRESS")%></td>
				<td class="usrinfotdlt"><%=Util.getI18NMsg(request,"IAM.IDP.PROVIDER")%></td></tr>
				
				<%} %>
			<tr><td class="usrinfotdrt"><%=IAMEncoder.encodeHTML(sys.getEmailId())%></td>
                        <td class="usrinfotdrt"><%=IAMEncoder.encodeHTML(idp)%></td></tr>
    	<%}
    	}%>
	    </table>
	    <%}
		if(nonZohoOpenIDs.isEmpty() || isFirstTime){ %>
		    <dl>
		    	<dd class="nodata"></dd><%--NO I18N--%>
		    </dl>
		    <dl>
		    	<dd class="groupdet">No Linked Accounts Present</dd><%--NO I18N--%>
		    </dl>
	    <%} %>
<%

%>

<!-- /////////////////////////////////////     LOGIN HISTORY     ////////////////////////////////////////////// -->
<div class="topcontent"><div class="contitle">Login History and Commonly Used Devices & Browsers</div></div> <%-- No I18N --%>
<%
 long zuid1 = u.getZUID();
	
    List<Map> accessAudit = CSPersistenceAPIImpl.getAccessAudit(zuid, null, 1, 8);
    int size = 0;
    if(accessAudit !=null && !accessAudit.isEmpty()){
	size =  accessAudit.size();
    }
    %>
    <%if(accessAudit !=null && ! accessAudit.isEmpty()) {%>
<table class="usremailtbl" cellpadding="4" style="margin-top:0px;">
    <tr>
	<td class="usrinfoheader">Service Name</td> <%--No I18N--%>
	<td class="usrinfoheader">Ip Address</td> <%--No I18N--%>
	<td class="usrinfoheader">Created Time</td> <%--No I18N--%>
	<td class="usrinfoheader">Login IDP</td><%--No I18N--%>
	<td class="usrinfoheader">Referrer</td> <%--No I18N--%>
	<td class="usrinfoheader">Device Name</td> <%--No I18N--%>
	<td class="usrinfoheader">Device Type</td> <%--No I18N--%>
	<td class="usrinfoheader">Browser Name</td> <%--No I18N--%>
    </tr>
<%
	ServiceAPI sapi = Util.SERVICEAPI;
	String [] mobileUserAgents12 = new String [] {"Blackberry","Blazer","Handspring","iPhone","iPod","Kyocera","LG","Motorola","Nokia","Palm","PlayStation Portable","Samsung","Smartphone","SonyEricsson","Symbian","WAP","Windows CE"};//No I18N
	
	for(Map map : accessAudit) {
	    Timestamp time = new Timestamp(IAMUtil.getLong(map.get("TIMESTAMP").toString())); //No I18N
	    String serviceName = sapi.getService(Integer.parseInt(map.get("SERVICE_ID").toString())).getServiceName(); //No I18N
	    UserAgent uag = new UserAgent(map.get("USERAGENT").toString());
	    String usAgent = map.get("USERAGENT").toString();
	    String bclass = null;
	    if(usAgent != null) {
	    	if(usAgent.toLowerCase().contains("firefox")) {
	    		bclass = "firefox"; //No I18n
	    	}else if(usAgent.toLowerCase().contains("chrome")) { //No I18n
	    		bclass = "chrome"; //No I18n
	    	}else if(usAgent.toLowerCase().contains("opera")) { //No I18n
	    		bclass = "opera"; //No I18n
	    	}else if(usAgent.toLowerCase().contains("safari")) { //No I18n
	    		bclass = "safari"; //No I18n 
	    	}else if(usAgent.toLowerCase().contains("ie")) { //No I18n
	    		bclass = "ie"; //No i18N
	    	}
	    }
%>
    <tr>
	<td class="usremailtd"><%=serviceName%></td> <%-- NO OUTPUTENCODING --%>
	<td class="usremailtd"><%=IAMEncoder.encodeHTML((String)map.get("IP_ADDRESS"))%></td>
	<td class="usremailtd"><%=time%></td> <%-- NO OUTPUTENCODING --%>
<%
	AccountsConstants.IdentityProvider []idpList = AccountsConstants.IdentityProvider.values();
	String loginidp = map.get("OPERATION").toString();	//No I18N
	for(int i=0;;i++){
		AccountsConstants.IdentityProvider idps = AccountsConstants.IdentityProvider.valueOfInt(i);
		if(idps == null){
			break;
		}
		if(idps.getCookieValue() != null && ProtoConverterUtil.getAuditOperationType(idps.getCookieValue()).equals(loginidp)){	//To show the correct login operation such as FACEBOOK, YAHOO etc.
			loginidp = idps.name();
			break;
		}
	}
%>
	<td class="usremailtd"><%=loginidp%></td> <%-- NO OUTPUTENCODING --%>
	<td class="usremailtd"><%=IAMEncoder.encodeHTML((String)map.get("REFERRER"))%></td>
	<td class="usremailtd"><%=uag.getDeviceName()%></td> <%-- NO OUTPUTENCODING --%>
	<td class="usremailtd"><%=uag.getDeviceType()%></td> <%-- NO OUTPUTENCODING --%>
	<td class="usremailtd"><%=bclass%></td> <%-- NO OUTPUTENCODING --%>
	<td class="usremailtd" ><div <%if(bclass != null){ %>class="<%=bclass%>" style="margin-left: 10px;"<%} %>></div></td> <%-- NO OUTPUTENCODING --%>
    </tr>
	<%}%>

</table>
<% } %>

    <!-- ////////////////////////////////////////////////////   ORG INFO  /////////////////////////////////////////////////////////////////// -->

<%
Org org1 = Util.ORGAPI.getOrg(u.getZOID());
List<OrgDomain> orgDomainList1 = null;
if(u != null && u.getZOID() != -1) {
    orgDomainList1 = Util.ORGAPI.getAllOrgDomain(u.getZOID());
} else if(org1 != null) {
    orgDomainList1 = Util.ORGAPI.getAllOrgDomain(org1.getZOID());
}
%>
<%if(org1 != null){ %>
    <div class="topcontent"><div class="contitle">Org Info</div></div> <%-- No I18N --%>
<table class="org_details" cellpadding="4">
	    <tr>
		<td class="orgdetailtd">ZOID</td> <%--No I18N--%>
		<td class="orgdetailtd"><%=org1.getZOID()%></td><%-- NO OUTPUTENCODING --%>
	    </tr>
	    <tr>
		<td class="orgdetailtd">Org Name</td> <%--No I18N--%>
		<td class="orgdetailtd"><%=IAMEncoder.encodeHTML(org1.getOrgName())%></td>
	    </tr>
	    <tr>
		<td class="orgdetailtd">Display Name</td> <%--No I18N--%>
		<td class="orgdetailtd"><%=IAMEncoder.encodeHTML(org1.getDisplayName())%></td>
	    </tr>
	    <tr>
		<td class="orgdetailtd">Screen Name</td> <%--No I18N--%>
		<td class="orgdetailtd"><%=org1.getScreenName() != null ? IAMEncoder.encodeHTML(org1.getScreenName()) : ""%></td>
	    </tr>
	    <tr>
		<td class="orgdetailtd">Org Contact</td> <%--No I18N--%>
		<% 
		    String orgContact1 = "";
		    UserEmail orgContactUserEmail = org1.getOrgContact() != -1 ? Util.USERAPI.getPrimaryEmail(org1.getOrgContact()) : null;
		    if(orgContactUserEmail != null) orgContact1 = orgContactUserEmail.getEmailId();
		%>
		<td class="orgdetailtd"><%=IAMEncoder.encodeHTML(orgContact1)%></td>
	    </tr>
	    <tr>
		<td class="orgdetailtd">Total Users</td> <%--No I18N--%>
		<td class="orgdetailtd"><%=Util.ORGAPI.getOrgUsersCount(org1.getZOID())%></td><%-- NO OUTPUTENCODING --%>
	    </tr>
	    <tr>
		<td class="orgdetailtd">Active Users</td> <%--No I18N--%>
		<td class="orgdetailtd"><%=Util.ORGAPI.getOrgUsersCount(org1.getZOID(), UserStatus.ACTIVE)%></td><%-- NO OUTPUTENCODING --%>
	    </tr>
	    <tr>
		<td class="orgdetailtd">SAML LoginURL</td> <%--No I18N--%>
		<td class="orgdetailtd"><%=org1.getSamlLoginURL() != null ? IAMEncoder.encodeHTML(org1.getSamlLoginURL()) : ""%></td>
	    </tr>
	    <tr>
		<td class="orgdetailtd">SAML LogoutURL</td> <%--No I18N--%>
		<td class="orgdetailtd"><%=org1.getSamlLogoutURL() != null ? IAMEncoder.encodeHTML(org1.getSamlLogoutURL()) : ""%></td>
	    </tr>
	    <tr>
		<td class="orgdetailtd">Mobile</td> <%--No I18N--%>
		<td class="orgdetailtd"><%=org1.getMobile() != null ? IAMEncoder.encodeHTML(org1.getMobile()) : ""%></td>
	    </tr>
	    <tr>
		<td class="orgdetailtd">Org Status</td> <%--No I18N--%>
		<td class="orgdetailtd"><%=org1.getOrgStatus() == 0 ? "Inactive" : org1.getOrgStatus() == 1 ? "Active" : org1.getOrgStatus()%></td>
	    </tr>
	    <tr>
		<td class="orgdetailtd">Created Time</td> <%--No I18N--%>
		<td class="orgdetailtd"><%=org1.getCreatedTime() != -1 ? new Date(org1.getCreatedTime()) : ""%></td><%-- NO OUTPUTENCODING --%>
	    </tr>
	    <tr>
		<td class="orgdetailtd">Last Modified Time</td> <%--No I18N--%>
		<td class="orgdetailtd"><%=org1.getLastModifiedTime() != -1 ? new Date(org1.getLastModifiedTime()) : ""%></td><%-- NO OUTPUTENCODING --%>
	    </tr>
	</table>





    <!-- /////////////////////////////////////////////////  ORG DOMAIN INFO    //////////////////////////////////////////////////////////////////// -->
    <%if(orgDomainList1 != null){ %>
    <div class="topcontent"><div class="contitle">Org Domain Info</div></div> <%-- No I18N --%>
<table class="orgdomain_details" cellpadding="4">
	    <tr>
		<td class="usrinfoheader">Domain Name</td> <%--No I18N--%>
		<td class="usrinfoheader">Primary</td> <%--No I18N--%>
		<td class="usrinfoheader">Verified</td> <%--No I18N--%>
		<td class="usrinfoheader">RegisteredByZoho</td> <%--No I18N--%>
		<td class="usrinfoheader">VerifiedBy</td> <%--No I18N--%>
		<td class="usrinfoheader">Verified Date</td> <%--No I18N--%>
		<td class="usrinfoheader">Created Time</td> <%--No I18N--%>
		<td class="usrinfoheader">Parent Domain</td> <%--No I18N--%>
	    </tr>
		<%for(OrgDomain orgDomain : orgDomainList1) {%>
	    <tr>
		<td class="usremailtd"><%=IAMEncoder.encodeHTML(orgDomain.getDomainName())%></td>
		<td class="usremailtd"><%=orgDomain.isPrimary()%></td><%-- NO OUTPUTENCODING --%>
		<td class="usremailtd"><%=orgDomain.isVerified()%></td><%-- NO OUTPUTENCODING --%>
		<td class="usremailtd"><%=orgDomain.isRegisteredByZoho()%></td><%-- NO OUTPUTENCODING --%>
		<%
		    String verByContact1 = "";
		    UserEmail verByContactEmail1 = orgDomain.getVerBy() != -1 ? Util.USERAPI.getPrimaryEmail(orgDomain.getVerBy()) : null;
		    if(verByContactEmail1 != null) verByContact1 = verByContactEmail1.getEmailId();
		%>
		<td class="usremailtd"><%=IAMEncoder.encodeHTML(verByContact1)%></td>
		<td class="usremailtd"><%=(orgDomain.getVerDate() != -1 && orgDomain.getVerDate() != 0) ? new Date(orgDomain.getVerDate()) : ""%></td><%-- NO OUTPUTENCODING --%>
		<td class="usremailtd"><%=orgDomain.getCreatedTime() != -1 ? new Date(orgDomain.getCreatedTime()) : ""%></td><%-- NO OUTPUTENCODING --%>
		<td class="usremailtd"><%=orgDomain.getParentDomainName() != null ? orgDomain.getParentDomainName() : ""%></td><%-- NO OUTPUTENCODING --%>
	    </tr>
		<%}%>
	</table>
	   <% 	}
    	} %>
	
	<!-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// -->


<%
	} else{ %>
	<div>Invalid User Detail</div>  <%-- No I18N --%>
	
	<%
	}
}

%>

<body>

</body>



</html>