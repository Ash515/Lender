<%-- $Id$ --%>
<%@page import="com.adventnet.iam.internal.audit.ARMAccountCloseAudit"%>
<%@page import="com.zoho.accounts.AccountsProto.Account.AppAccount.AppAccountService.AccountMember"%>
<%@page import="com.adventnet.iam.IAMUtil.ZIDType"%>
<%@page import="com.zoho.iam2.rest.AuthDomainAPIRestProtoImpl"%>
<%@page import="com.zoho.accounts.Accounts.RESOURCE.USERDOMAIN"%>
<%@page import="com.zoho.accounts.AccountsProto.Account.AuthDomain.UserDomain"%>
<%@page import="com.zoho.accounts.AccountsProto.Account.AuthDomain"%>
<%@page import="com.zoho.data.AccountsDataObject.IAMEmail"%>
<%@page import="com.adventnet.iam.internal.PhoneUtil"%>
<%@page import="com.zoho.accounts.AccountsProto.Account.User.UserMobile"%>
<%@page import="com.zoho.iam2.rest.ProtoUtil"%>
<%@page import="com.zoho.accounts.SystemResourceProto.DCLocation"%>
<%@page import="com.zoho.accounts.handler.GeoDCHandler"%>
<%@page import="com.zoho.accounts.AccountsProto.Account.AppAccount.AppAccountService"%>
<%@page import="com.zoho.accounts.AccountsProto.Account.AppAccount"%>
<%@page import="com.zoho.iam2.rest.ServiceOrgUtil"%>
<%@page import="com.zoho.accounts.AuditResource"%>
<%@page import="com.zoho.accounts.AccountsConstants.UserStatus"%>
<%@page import="com.zoho.resource.Criteria"%>
<%@page import="com.zoho.accounts.AuditResource.RESOURCE.ACCOUNTCLOSEAUDIT"%>
<%@page import="com.zoho.accounts.AuditResourceProto.AccountCloseAudit"%>
<%@page import="com.zoho.accounts.AccountsConstants"%>
<%@page import="com.zoho.accounts.phone.SMSUtil"%>
<%@page import="com.zoho.accounts.AccountsConstants.TFAPrefOption"%>
<%@page import="com.zoho.accounts.AccountsConstants.UserTFAStatus"%>
<%@page import="com.zoho.accounts.AccountsProto.Account.User.UserAccountsProperties"%>
<%@page import="com.zoho.accounts.AccountsProto.Account.User.UserSystemProperties"%>
<%@page import="com.zoho.accounts.AccountsProto.Account.Policy"%>
<%@page import="com.zoho.accounts.Accounts"%>
<%@page import="com.zoho.iam2.rest.RestProtoUtil"%>
<%@page import="java.util.logging.Logger"%>
<%@page import="java.util.logging.Level"%>
<%@ include file="includes.jsp" %>
<%
    String qry=null;
	String type=request.getParameter("type");
    qry = request.getParameter("qry");
%>

<div class="menucontent">
	<div class="topcontent"><div class="contitle">User/Org Info</div></div><%--No I18N--%>
	<div class="subtitle">Admin Services</div><%--No I18N--%>
</div>
<div class="maincontent" >
    <div class="field-bg">
	<div class="labelmain" id="searchuser" align="center">
	    <div class="labelkey" >
	    	<select id='mode' class="inputSelect chosen-select unauthinputSelect-tfa" style="background-color: white;width: 231px;background-position-x: 153px;" >
	    		<option value='email' <%if("email".equals(type)){ %>selected<%} %>>EmailId / MobileNo / UserName </option><%--No I18N--%>
	    		<option value='zid' <%if("zid".equals(type)){ %>selected<%} %>>ZUID / ZOID </option><%--No I18N--%>
	    	</select>
	    </div>
	    <div class="searchfielddiv">
                <input type="text" name="search" id="search" style="width:273px;height: 32px;margin-top: 1px;" value="<%=IAMEncoder.encodeHTMLAttribute(Util.isValid(qry)?qry:"")%>" class="unauthinputText" onmouseover="this.focus()" onkeypress="if(event.keyCode == 13){ searchUser();return false;}"/>
	    </div>
	   <div style="float:left;">
			<div class="saveBtn" onclick="searchUser()" style="margin-top: 7px;margin-left: 3px;" >Search</div><%--No I18N--%>
	    </div>
	</div>
    </div>
</div>

<%
if(Util.isValid(qry) && Util.isValid(type)) {
    User u = null;
    Org org = null;
    List<OrgDomain> orgDomainList = null;
    if("email".equals(type)){ //No I18N
    	u = Util.USERAPI.getUser(qry);
    }else if("zid".equals(type)){ //No I18N
    	try {
    		long zidl = Long.parseLong(qry);
    		u = Util.USERAPI.getUser(zidl);
    		if(u == null) {
    			org = Util.ORGAPI.getOrg(zidl);
    		}
   	    }
   	    catch(Exception e) {
   	    	u = Util.USERAPI.getUser(qry);
   	    }
    }
    if(u != null || org != null) {
	if(u != null && u.getZOID() != -1) {
	    org = Util.ORGAPI.getOrg(u.getZOID());
	    orgDomainList = Util.ORGAPI.getAllOrgDomain(u.getZOID());
	} else if(org != null) {
	    orgDomainList = Util.ORGAPI.getAllOrgDomain(org.getZOID());
	}

    %>
<div class="ursinfoheaderdiv">
	<%if(u != null) {%>
    <div class="usrinfoactivediv" id="panel_usrinfo" onclick="showDetails('panel_usrinfo')">Personal Info</div> <%--No I18N--%>
    <%-- <div class="usrinfoinactivediv" id="panel_usrphoto" onclick="showDetails('panel_usrphoto')">User Photo</div> No I18N --%>
    <div class="usrinfoinactivediv" id="panel_usrlogindetails" onclick="showLoginHistory('panel_usrlogindetails','<%=u.getZUID()%>','I','SignIn',0)">Login History</div> <%-- NO OUTPUTENCODING --%> <%--No I18N--%>
	<div class="usrinfoinactivediv" id="panel_usrtfadetails" onclick="showTFADetails('panel_usrtfadetails','<%=u.getZUID()%>')">TFA Settings</div> <%-- NO OUTPUTENCODING --%> <%--No I18N--%>

    <div class="usrinfoinactivediv" id="panel_usrservicedetails" onclick="showDetails('panel_usrservicedetails')">Service Status</div> <%--No I18N--%>
    <% String changeHistory=AccountsConfiguration.getConfiguration("changehistory.enable","true");
      if(changeHistory.equals("true") && (request.isUserInRole("IAMAdmininistrator") || request.isUserInRole("IAMSupportAdmin"))){%>
    <div class="usrinfoinactivediv" id="panel_usrchangehistory" onclick="showChangeHistory('panel_usrchangehistory','<%=u.getZUID()%>',0)">Change History</div> <%-- NO OUTPUTENCODING --%> <%--No I18N--%>
    <%} %>
	<%}if(org != null || u.getZOID() != -1) {%>
    <div class="<%=u == null ? "usrinfoactivediv" : "usrinfoinactivediv"%>" id="panel_orginfo" onclick="showDetails('panel_orginfo')">Org Info</div> <%--No I18N--%>
    <div class="usrinfoinactivediv" id="panel_orgdomain" onclick="showDetails('panel_orgdomain')">Org Domain Info</div> <%--No I18N--%>
    <div class="usrinfoinactivediv" id="panel_orgpolicy" onclick="showDetails('panel_orgpolicy')">Org Policy</div><%--No I18N--%>
	<%}
	if(org != null || u.getZOID() != -1 && u != null) {%>
	<div class="usrinfoinactivediv" id="panel_usrappaccountdetails" onclick="showDetails('panel_usrappaccountdetails')">AppAccount Details</div> <%--No I18N--%>
	<%}%>
	<div class="usrinfoinactivediv" id="panel_usrserviceorgdetails" onclick="showDetails('panel_usrserviceorgdetails')">Service Org Details</div> <%--No I18N--%>
	<div class="usrinfoinactivediv" id="panel_usrauthdomains" onclick="showDetails('panel_usrauthdomains')">Security Policies</div> <%--No I18N--%>
    <div>&nbsp;</div>
</div>

<div class="usrinfomaindiv">
    <div id="userinfo">
<%
	if(u != null) {
	UserSystemProperties usp = Accounts.getUserSystemPropertiesURI(u.getZaid(), u.getZUID()).GET();
	List<UserEmail> usremail = u.getEmails();
	if(usremail != null) {
%>
	<table class="usremailtbl" cellpadding="4">
	    <tr>
		<td class="usrinfoheader">Email Address</td> <%--No I18N--%>
		<td class="usrinfoheader">Type</td> <%--No I18N--%>
		<td class="usrinfoheader">Status</td> <%--No I18N--%>
		<td class="usrinfoheader">Created Time</td> <%--No I18N--%>
	    </tr>
<%
	    for(UserEmail uemail :usremail) {
		int status = uemail.getStatus();
		String email_type = "---"; //No I18N
		String email_status = "---"; //No I18N
		if(status == 0 || status == 99) {
			email_type = "Username"; //No I18N
			email_status = status==99 ? "Closed" : "Active"; //No I18N
			if(uemail.isZohoEmail()) {
				email_type = "System generated Username"; //No I18N
		}
		}
		else if(status == 1 || status == 3) {
			email_type = "Primary"; //No I18N
			email_status = uemail.isConfirmed() ? "Confirmed" : "Unconfirmed"; //No I18N
		}
		else if(status == 2 || status == 4) {
			email_type = "Secondary"; //No I18N
			email_status = uemail.isConfirmed() ? "Confirmed" : "Unconfirmed"; //No I18N
		}
		else if(status == 5) {email_type = "Screen Name";} //No I18N
		else if(status == 6) {
			email_type = "Mobile Number"; //No I18N
			email_status = uemail.isMobileLoginNameConfirmed() ? "Confirmed" : "Unconfirmed"; //No I18N
			}
		
		else if(status == 7) {email_type = "Group Email";} //No I18N
		if(uemail.isZohoEmail()) {
			email_type = "Zoho email ID / " + email_type; //No I18N
		}
%>
	    <tr>
                <td class="usremailtd"><%=IAMEncoder.encodeHTML(uemail.getEmailId())%></td>
		<td class="usremailtd"><%=email_type%></td> <%-- NO OUTPUTENCODING --%>
		<td class="usremailtd"><%=email_status%></td> <%-- NO OUTPUTENCODING --%>
		<td class="usremailtd"><%=uemail.getCreatedTime() != -1 ? new Date(uemail.getCreatedTime()) : ""%></td><%-- NO OUTPUTENCODING --%>
	    </tr>
<%
	    }
%>
	</table>
<%
	}
%>
	<table class="usrinfotbl" width="100%">
	    <tr>
		<td valign="top" width="50%">
		    <table cellpadding="3">
			<tr>
			    <td class="usrinfotdlt">ZUID</td> <%--No I18N--%>
			    <td class="usrinfotdrt"><%=u.getZUID()%></td><%-- NO OUTPUTENCODING --%>
			</tr>
			<tr>
			    <td class="usrinfotdlt">ZOID</td> <%--No I18N--%>
			    <td class="usrinfotdrt"><%=u.getZOID()%></td><%-- NO OUTPUTENCODING --%>
			</tr>
			<tr>
			    <td class="usrinfotdlt">ZAID</td> <%--No I18N--%>
			    <td class="usrinfotdrt"><%=IAMEncoder.encodeHTML(u.getZaid())%></td>
			</tr>
			<tr>
			    <td class="usrinfotdlt">USER NAME</td> <%--No I18N--%>
			    <td class="usrinfotdrt"><%=u.getLoginName() != null ? IAMEncoder.encodeHTML(u.getLoginName()) : ""%></td>
			</tr>
			<tr>
			    <td class="usrinfotdlt">FULL NAME</td> <%--No I18N--%>
			    <td class="usrinfotdrt"><%=u.getFullName() != null ? IAMEncoder.encodeHTML(u.getFullName()) : ""%></td>
			</tr>
			<tr>
			    <td class="usrinfotdlt">NICK NAME</td> <%--No I18N--%>
			    <td class="usrinfotdrt"><%=u.getDisplayName() != null ? IAMEncoder.encodeHTML(u.getDisplayName()) : ""%></td>
			</tr>
			<tr>
			    <td class="usrinfotdlt">SKYPE ID</td> <%--No I18N--%>
			    <td class="usrinfotdrt"><%=u.getSkypeId() != null ? IAMEncoder.encodeHTML(u.getSkypeId()) : ""%></td>
			</tr>
			<tr>
			    <td class="usrinfotdlt">GENDER</td> <%--No I18N--%>
			    <td class="usrinfotdrt"><%=u.getGender() == 0 ? "Female" : (u.getGender() == 1 ? "Male" : (u.getGender() == 2 ? "Not Defined" : "&nbsp;"))%></td><%-- NO OUTPUTENCODING --%>
			</tr>
			<tr>
			    <td class="usrinfotdlt">PRIMARY EMAIL</td> <%--No I18N--%>
			    <td class="usrinfotdrt"><%=u.getPrimaryEmail() != null ? IAMEncoder.encodeHTML(u.getPrimaryEmail()) : ""%></td>
			</tr>
			<tr>
			    <td class="usrinfotdlt">USER STATUS</td> <%--No I18N--%>
			    <td class="usrinfotdrt"><%=u.getUserStatus() == AccountsConstants.UserStatus.SPAM ? "Spam" : RestProtoUtil.getUserStatus(""+u.getZUID()) == AccountsConstants.UserStatus.IMPORTED_INACTIVE ? "IMPORTED_INACTIVE" : RestProtoUtil.getUserStatus(""+u.getZUID()) == AccountsConstants.UserStatus.IMPORTED_ACTIVE ? "IMPORTED_ACTIVE" : u.getUserStatus() == AccountsConstants.UserStatus.INACTIVE ? "InActive" : (u.getUserStatus() == AccountsConstants.UserStatus.ACTIVE ? "Active" : (u.getUserStatus() == AccountsConstants.UserStatus.CLOSED ? "Closed" : u.isExpired() ? "Expired" : u.getUserStatus()))%></td><%-- NO OUTPUTENCODING --%>
			</tr>
			<tr>
			    <td class="usrinfotdlt">USER ROLE</td> <%--No I18N--%>
			    <td class="usrinfotdrt">
			<%
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
			    </td>
			</tr>
			<%
			UserMobile ums[] = PhoneUtil.getUserRecoveryNumbers(u);
			String mobileStr ="";
			if(ums!=null){
				for(UserMobile um:ums){
					mobileStr+="(+"+SMSUtil.getISDCode(um.getCountryCode()) +") ";
					mobileStr+=IAMEncoder.encodeHTML(um.getMobile())+" &nbsp;";
					mobileStr+=SMSUtil.getISDCountryName(um.getCountryCode())+"<br>";
				}
				if(mobileStr.length()>4){
					mobileStr=mobileStr.substring(0, mobileStr.length()-4);
				}
			}
			if(Util.isValid(mobileStr)){
			%>
			<tr>
			    <td class="usrinfotdlt">RECOVERY NUMBERS</td> <%--No I18N--%>
			    <td class="usrinfotdrt">
			    <%=mobileStr%><%-- NO OUTPUTENCODING --%>
			    </td>
			</tr>
			<%} %>
			<tr>
			    <td class="usrinfotdlt">SPAM STATUS</td> <%--No I18N--%>
			    <td class="usrinfotdrt"><%=usp != null&&usp.getSpamCheckStatus() != null ? IAMEncoder.encodeHTML(usp.getSpamCheckStatus()) : ""%></td>
			</tr>
				<%
				UserPreference userpref = Util.USERAPI.getUserPreference(u.getZUID());
				String tfa_status = null,tfa_pref = null;
				if(userpref != null) {
					int status = userpref.getUserTFAStatus();
					if(status == UserTFAStatus.ENABLE_TFA) {
						tfa_status = "Enabled TFA"; //No I18N
					}else if(status == UserTFAStatus.ENABLE_TFA_BY_ADMIN) {
						tfa_status = "Enabled TFA By Admin"; //No I18N
					}else if(status == UserTFAStatus.DISABLE_TFA_BY_ADMIN) {
						tfa_status = "Disabled TFA by Admin"; //No I18N
					}else{
						tfa_status = "Disabled TFA"; //No I18N
					}
					int pref = userpref.getTFAPrefOption();
					if(pref == TFAPrefOption.ENABLE_TFA_SMART_PHONE) {
						tfa_pref = "Google Authenticator"; //No I18N
					}else if(pref == TFAPrefOption.ENABLE_TFA_SMS) {
						tfa_pref = "SMS Text Message"; //No I18N
					}else if(pref == TFAPrefOption.ENABLE_TFA_TOUCH_ID) {
						tfa_pref = "TouchID"; //No I18N
					}else if(pref == TFAPrefOption.ENABLE_TFA_QR) {
						tfa_pref = "ScanQR"; //No I18N
					}else if(pref == TFAPrefOption.ENABLE_TFA_PUSH) {
						tfa_pref = "Push Notification"; //No I18N
					}else if(pref == TFAPrefOption.ENABLE_TFA_TOTP) {
						tfa_pref = "Time-based OTP"; //No I18N
					}else if(pref == TFAPrefOption.ENABLE_TFA_EXO) {
						tfa_pref = "Exo-Star Authentication"; //No I18N
					}else if(pref == TFAPrefOption.ENABLE_TFA_FACEID) {
						tfa_pref = "FaceId"; //No I18N
					}
				}else{
					tfa_status = "Disabled TFA"; //No I18N
				}
				%>
			<tr>
				<td class="usrinfotdlt">TFA Status</td> <%--No I18N--%>
				<td class="usrinfotdrt">
				<%if(tfa_status != null){
					out.print(tfa_status);

				}%>
				</td>
			</tr>
			<%if(!"Disabled TFA".equals(tfa_status)) {%>
			<tr>
				<td class="usrinfotdlt">TFA Preference</td> <%--No I18N--%>
				<td class="usrinfotdrt">
				<%if(tfa_pref != null){
					out.print(tfa_pref);

				}%>
				</td>
			</tr>
			<% }%>
		    </table>
		</td>
		<td valign="top" width="50%">
		    <table cellpadding="3">
			<tr>
			    <td class="usrinfotdlt">COUNTRY</td> <%--No I18N--%>
			    <td class="usrinfotdrt"><%=u.getCountry() != null ? IAMEncoder.encodeHTML(u.getCountry()) : ""%></td>
			</tr>
			<tr>
			    <td class="usrinfotdlt">LANGUAGE</td> <%--No I18N--%>
			    <td class="usrinfotdrt"><%=u.getLanguage() != null ? IAMEncoder.encodeHTML(u.getLanguage()) : ""%></td>
			</tr>
			<tr>
			    <td class="usrinfotdlt">TIMEZONE</td> <%--No I18N--%>
			    <td class="usrinfotdrt"><%=u.getTimezone() != null ? IAMEncoder.encodeHTML(u.getTimezone()) : ""%></td>
			</tr>
			<tr>
			    <td class="usrinfotdlt">LOCALE INFO</td> <%--No I18N--%>
			    <td class="usrinfotdrt"><%=IAMEncoder.encodeHTML(u.getLocaleInfo())%></td>
			</tr>
			<tr>
<%
	    OrgLocation orgLocation = u.getWorkAddress();
	    String workAddr = orgLocation != null ? orgLocation.getLocationName() : null;
            String ipAddress = u.getProperty(User.IP_ADDRESS, null);
%>
			    <td class="usrinfotdlt">WORK ADDRESS</td> <%--No I18N--%>
			    <td class="usrinfotdrt"><%=workAddr != null ? IAMEncoder.encodeHTML(workAddr) : ""%></td>
			</tr>
			<tr>
			    <td class="usrinfotdlt">PROPERTIES</td> <%--No I18N--%>
			    <td class="usrinfotdrt"><%=u.getProperties() != null ? IAMEncoder.encodeHTML(u.convertToText(u.getProperties())) : ""%></td>
			</tr>
			<tr>
			    <td class="usrinfotdlt">IP ADDRESS</td> <%--No I18N--%>
			    <td class="usrinfotdrt"><%=ipAddress != null ? IAMEncoder.encodeHTML(ipAddress) : ""%></td>
			</tr>
			<tr>
			    <td class="usrinfotdlt">REFERRER</td> <%--No I18N--%>
			    <td class="usrinfotdrt"><%=u.getReferer() != null ? IAMEncoder.encodeHTML(u.getReferer()) : ""%></td>
			</tr>
			<tr>
			    <td class="usrinfotdlt">IPID</td> <%--No I18N--%>
			    <td class="usrinfotdrt"><%=CSPersistenceAPIImpl.getUserIPID(u)%></td> <%-- NO OUTPUTENCODING --%>
			</tr>
			<tr>
			    <td class="usrinfotdlt">IDP</td> <%--No I18N--%>
			    <td class="usrinfotdrt"><%=AccountsConstants.IdentityProvider.valueOfInt(u.getIDP())%></td><%-- NO OUTPUTENCODING --%>
			</tr>
			<tr>
			    <td class="usrinfotdlt">REGISTERED TIME</td> <%--No I18N--%>
			    <td class="usrinfotdrt"><%=u.getRegisteredTime() != -1 ? new Date(u.getRegisteredTime()) : ""%></td><%-- NO OUTPUTENCODING --%>
			</tr>
			<tr>
			    <td class="usrinfotdlt">LAST MODIFIED TIME</td> <%--No I18N--%>
			     <% long lastModifedTime=Util.getUserLastModifiedTime(u); %>
			    <td class="usrinfotdrt"><%=lastModifedTime > 0 ? new Date(lastModifedTime) : ""%></td><%-- NO OUTPUTENCODING --%>
			</tr>
			<tr>
			    <td class="usrinfotdlt">LAST LOGIN TIME</td> <%--No I18N--%>
			    <% long lastLoginTime=Util.USERAPI.getUserLastLoginTime(String.valueOf(u.getZUID()));%>
			    <td class="usrinfotdrt"><%=lastLoginTime!= -1 ? new Date(lastLoginTime) : "" %></td><%-- NO OUTPUTENCODING --%>
			</tr>
		    </table>
		</td>
	    </tr>
	</table>
	<%}%>
    </div>

    <div id="userinfo_photo" style="display:none;">
        <% if(u != null) {%>
        <div style="padding:10px 0px 10px 10px;">
            <img src="<%=IAMProxy.getContactsServerURL(request.getScheme().equalsIgnoreCase("https"))%>/file?fs=thumb&ID=<%=u.getZUID()%>" /> <%-- NO OUTPUTENCODING --%>
        </div>
        <% } %>
    </div>
    <div id="login_history" style="display:none;"></div>

    <div id="serviceorg" style="display:none;">
<%
        if(u != null) {
        	List<ServiceOrg> serviceOrgs = ServiceOrgUtil.getUserServiceOrgs(u.getZUID());
            if(serviceOrgs != null && !serviceOrgs.isEmpty()) {
%>
        <table class="sorg_details" cellpadding="4" >
            <tr>
		<td class="usrinfoheader" width="80">ZSOID</td> <%--No I18N--%>
		<td class="usrinfoheader" width="30%">Name / Description</td><%--No I18N--%>
		<td class="usrinfoheader" width="80" style="white-space: nowrap;text-overflow: ellipsis;overflow: hidden;" title="Status / Migrated / Parent Org Type - ZAAID / Directory ZAAID">Status / Migrated / Parent Org Type - ZAAID / Directory ZAAID</td><%--No I18N--%>
		<td class="usrinfoheader" width="15%">Owner / Created Time</td><%--No I18N--%>
	    </tr>
            <% for(ServiceOrg sorg : serviceOrgs) {
            	ServiceOrgMember member = Util.serviceOrgAPI.getMember(sorg.getOrgType(), sorg.getZSOID(), u.getZUID());
            %>
            <tr>
		<td class="usremailtd"><%=sorg.getZSOID()%><br><br><%=AccountsConstants.OrgType.valueOf(sorg.getOrgType(), false, false, true).getServiceName()%></td> <%--No I18N--%><%-- NO OUTPUTENCODING --%>
		<td class="usremailtd">
		<%=IAMEncoder.encodeHTML(sorg.getOrgName())%><br>
		<% if(sorg.getDescription() != null) { %>
		<span style="color:#777;font-size: 11px;"><%=IAMEncoder.encodeHTML(sorg.getDescription())%></span>
		<% } %>
		<br>
		<% 
		String userType = "Normal"; //No I18N
		int userTypeInt = member.getUserType();
		 if(userTypeInt == AccountsConstants.AccountMemberUserType.FREE_USER) {
			 userType = "Free";//No I18N 
		 } else if(userTypeInt == AccountsConstants.AccountMemberUserType.NORMAL) {
			 userType = "Normal";//No I18N
		 }
		%>
		<div><span style="color: #999;">Member Info:</span><br> <span style="color: #999;">Role</span>: <%= member.getUserRole() %>, <span style="color: #999;">Status</span> : <%=member.isActive() ? "Enabled" : "DISABLED"%>, <span style="color: #999;">Created On</span> : <%=new Date(member.getCreatedTime())%> <span style="color: #999;">User Type </span> : <%=userType%></div> <%-- NO OUTPUTENCODING --%> <%--No I18N--%>
		</td>
				<td class="usremailtd"><%=sorg.isEnabled() ? "Enabled" : "DISABLED"%><br><%=sorg.isMigratedToOrg() ? "<br> Migrated" : ""%><%=sorg.getParentZaaid() != -1 ? "<br>" + sorg.getParentOrgType() + " - " + sorg.getParentZaaid() : ""%><br><%=sorg.getDirectoryZaaid() != -1 ? sorg.getDirectoryZaaid() +"(D)" : ""%></td> <%--No I18N--%><%-- NO OUTPUTENCODING --%>
				<td class="usremailtd"><%=sorg.getCreatedBy()%><br><br><%=sorg.getCreatedTime() != -1 ? new Date(sorg.getCreatedTime()) : ""%></td><%-- NO OUTPUTENCODING --%>
	    </tr>
            <% } %>
        </table>
            <% } else { %>
        <div class="nosuchusr">
            <p align="center">No service org for the user</p> <%--No I18N--%>
	</div>
<%
            }
        }
%>
</div>


    <div id="appaccount" style="display:none;">
<%
        if(u != null && org != null && org.getZOID() != -1) {
        	List<AppAccount> appAccs = Util.appAccountAPI.getAppAccounts(u.getZUID());
            if(appAccs != null && !appAccs.isEmpty()) {
%>
        <table class="appaccount_details" cellpadding="4">
            <tr>
		<td class="usrinfoheader">Service Name</td> <%--No I18N--%>
		<td class="usrinfoheader">ZAAID </td><%--No I18N--%>
		<td class="usrinfoheader" width="30%"> Screen Name (Display Name) / Description</td><%--No I18N--%>
		<td class="usrinfoheader" width="25%" style="white-space: nowrap;text-overflow: ellipsis;overflow: hidden;" title="Status / Migrated / Parent Org Type - ZAAID/ Directory ZAAID">AppAccountService Status /AppAccount Status <br />/ Parent  ZAAID/ Directory ZAAID</td><%--No I18N--%>
		<td class="usrinfoheader">Created By <br /> Created Time</td><%--No I18N--%>
	    </tr>
            <% for(AppAccount app : appAccs) { 
            	if(app.getAppAccountServiceCount() >0 && app.getAppAccountServiceList() != null) {
            		  for(AppAccountService appservice : app.getAppAccountServiceList()) {
					%>
					
					<tr>
		<td class="usremailtd"><%=appservice.getAppName()%></td> <%-- NO OUTPUTENCODING --%>
		<td class="usremailtd" ><%=app.getZaaid()%></td><%-- NO OUTPUTENCODING --%>
		<td class="usremailtd">
			<%=IAMEncoder.encodeHTML(app.getScreenName() + " -  ( " + app.getDisplayName() + " )") %><br>
		<% if(app.getDescription() != null) { %>
		<span style="color:#777;font-size: 11px;"><%=IAMEncoder.encodeHTML(app.getDescription())%></span>
		<% } %>
		<br>
		<% 
		String roleName =" - ";
		int status = -1;
		long createdTime = -1l;
		String userType = "Normal"; //No I18N
		if(appservice.getAccountMemberCount() > 0 && appservice.getAccountMemberList() != null) {
			String zarid = null;
			AccountMember member = appservice.getAccountMemberList().get(0);
			if (member.getAccountMemberRoleCount() > 0) {
				zarid = member.getAccountMemberRoleList().get(0).getZarid();
			} else {
				zarid = member.getZarid(); //Backward compatability, for the account member stored in Cache
			}
			 roleName =  zarid != null ? ProtoUtil.getRoleName(appservice.getAppName(), zarid) + "(" + zarid + ")" : "-";
			 status = appservice.getAccountMemberList().get(0).getIsActive();
			 createdTime = appservice.getAccountMemberList().get(0).getCreatedTime();
			 int userTypeInt = appservice.getAccountMemberList().get(0).getUserType();
			 if(userTypeInt == AccountsConstants.AccountMemberUserType.FREE_USER) {
				 userType = "Free";//No I18N 
			 } else if(userTypeInt == AccountsConstants.AccountMemberUserType.NORMAL) {
				 userType = "Normal";//No I18N
			 } else if(!appservice.getAccountMemberList().get(0).hasUserType()) {
				 userType = "Normal - None";//No I18N
			 }
		}
		%>
		
		<div><span style="color: #999;">Member Info:</span><br> <span style="color: #999;">Role</span>: <%= roleName %>, <span style="color: #999;">Status</span> : <%=status == 1 ? "Enabled" : status == 0 ? "DISABLED" : status ==2 ? "closed" : "unknown" %>, <span style="color: #999;">Created On</span> : <%=new Date(createdTime)%> <span style="color: #999;">User Type </span> : <%=userType%></div> <%-- NO OUTPUTENCODING --%> <%-- No I18N --%>

		</td>
		<td class="usremailtd"><%=(appservice.getAccountStatus() == 1  ? "Enabled" : "DISABLED" ) + " / " + ( app.getAccountStatus() == 1  ? "Enabled" : "DISABLED") %><br><%=app.hasParentZaaid() ? "<br>" +  app.getParentZaaid() : ""%><br><%=app.hasDirectoryZaaid() ? "<br>" +  app.getDirectoryZaaid() +"(D)" : ""%></td> <%--No I18N--%><%-- NO OUTPUTENCODING --%><%--No I18N--%>
		<td class="usremailtd"><%=(appservice.hasZuid() ? appservice.getZuid()  : "-") + " / "  + (app.hasZuid() ?  app.getZuid() : "-")  %><br><br><%=appservice.getCreatedTime() != -1 ? new Date(appservice.getCreatedTime()) : ""%></td><%-- NO OUTPUTENCODING --%>
	    </tr>
	    
					<%}            		
            	} else { 
            %>
            			<tr>
		<td class="usremailtd" width="15"><%=app.getAppName()%></td> <%--No I18N--%><%-- NO OUTPUTENCODING --%>
		<td class="usremailtd" width="10"><%=app.getZaaid()%></td><%-- NO OUTPUTENCODING --%>
		<td class="usremailtd" width="40%"> <%=IAMEncoder.encodeHTML(app.getScreenName() + "/" + app.getDisplayName()) %><br>
		<% if(app.getDescription() != null) { %>
		<span style="color:#777;font-size: 11px;"><%=IAMEncoder.encodeHTML(app.getDescription())%></span>
		<% } %>
		<br>
		<% 
		String roleName =" - ";
		int status = -1;
		long createdTime = -1l;
		%>
		
		<div><span style="color: #999;">Member Info:</span><br> <span style="color: #999;">Role</span>: <%= roleName %>, <span style="color: #999;">Status</span> : <%=status == 1 ? "Enabled" : status == 0 ? "DISABLED" : status ==2 ? "closed" : "unknown" %>, <span style="color: #999;">Created On</span> : <%=new Date(createdTime)%></div> <%-- NO OUTPUTENCODING --%> <%-- No I18N --%>
 </td>
		<td class="usremailtd"><%=( app.getAccountStatus() == 1  ? "Enabled" : "DISABLED") %><br><%=app.hasParentZaaid() ? "<br>" +  app.getParentZaaid() : ""%><br><%=app.hasDirectoryZaaid() ? "<br>" +  app.getDirectoryZaaid() : ""%></td> <%--No I18N--%><%-- NO OUTPUTENCODING --%>
		<td class="usremailtd" width="25%"><%=app.getCreatedTime() != -1 ? new Date(app.getCreatedTime()) : ""%></td><%-- NO OUTPUTENCODING --%>
	    </tr>
            <% }
            }%>
        </table>
            <% } else { %>
        <div class="nosuchusr">
            <p align="center">No AppAccount for the user</p> <%--No I18N--%>
	</div>
<%
            }
        }
%>
</div>
	 <div id="authdomains" style="display:none;">
	 	<%
	 	 AuthDomain[] authDomains = null;
	 	 UserDomain[] userAuthDomains = null;
	 	 int zuidFlag = 1;
	 	 long zid = 0;
	 	 if(u != null){
	 		 zid=u.getZOID();
	 	 }else{
	 		 zid=org.getZOID();
	 	 }
	 	 if(zid!=-1){
	 	 authDomains =  (AuthDomain[])RestProtoUtil.GETS(Accounts.getAuthDomainURI(zid).addSubResource(USERDOMAIN.table()));
	 	 }
	 	%>
	 	<%if((authDomains != null && authDomains.length !=0)){ %>
	 		<div class="policytypetxt"><%-- No I18N --%>
	 		<%if(u != null){ %>
	 			ZUID :&nbsp;<%=IAMEncoder.encodeHTML(u.getZUID()+"")%> <%-- No I18N --%>
	 		<%}else{ %>
	 			ZOID :&nbsp;<%=IAMEncoder.encodeHTML(org.getZOID()+"")%> <%-- No I18N --%>
	 		<%} %>
	 		</div>
	 		<table class = "org_details" cellpadding="4">
			 	<tr>
				<td class="usrinfoheader">Security Policy</td><%--No I18N--%>
				<%if(u != null){ %>
				<td class="usrinfoheader">Is Excluded</td><%--No I18N--%>
				</tr>
				<%for(com.zoho.accounts.AccountsProto.Account.AuthDomain authDomain : authDomains){
					
					 	List<UserDomain> userDomainList = authDomain.getUserDomainList();
	 				
					 	if(AccountsConstants.DEFAULT_AUTH_DOMAIN_NAME.equals(authDomain.getDomainName())){
	 						boolean isUnderDefault=true;
	 						if(!userDomainList.isEmpty()){
	 							for(UserDomain ud :userDomainList){
	 								if(ud.getIsExcluded()&&((ud.getZuid().equals(String.valueOf(u.getZUID()))) || (ud.getZidType() == ZIDType.GROUP.ordinal() && Util.GROUPAPI.isGroupMember(IAMUtil.getLong(ud.getZuid()), u.getZUID())))) {
	 									isUnderDefault=false;
	 								}
	 							}
	 						}
 		 					%>
 	 						<tr>
 	 						<td class="usremailtd">&nbsp;<%=IAMEncoder.encodeHTML(authDomain.getDomainName())%></td> <!-- NO OUTPUTENCODING -->
 	 						<td class="usremailtd">&nbsp;<%=IAMEncoder.encodeHTML((!isUnderDefault)+"")%></td>
 	 						</tr>
 	 						<%continue;	 						
 						}
					 	
					 	
					 	if(userDomainList != null && !userDomainList.isEmpty()) {
		 					for(UserDomain ud :userDomainList){
		 						if((ud.getZuid().equals(String.valueOf(u.getZUID()))) || (ud.getZidType() == ZIDType.GROUP.ordinal() && Util.GROUPAPI.isGroupMember(IAMUtil.getLong(ud.getZuid()), u.getZUID()))) {%>
		 							<tr>
		 							<td class="usremailtd">&nbsp;<%=IAMEncoder.encodeHTML(authDomain.getDomainName())%></td>
									<td class="usremailtd">&nbsp;<%=IAMEncoder.encodeHTML(ud.getIsExcluded()+"")%></td>
		 							</tr>
		 						<%break;
							  }
		 					}
	 				 	}
	 				}
				}else{ %>
				<td class="usrinfoheader">Is Enabled</td><%--No I18N--%>
				</tr>
				<% 
					for(com.zoho.accounts.AccountsProto.Account.AuthDomain authDomain : authDomains){%>
						<tr>
						<td class="usremailtd">&nbsp;<%=IAMEncoder.encodeHTML(authDomain.getDomainName())%></td>
						<td class="usremailtd">&nbsp;<%=IAMEncoder.encodeHTML(authDomain.getIsEnabled()+"")%></td>
						</tr>
					<%}%>
				<%}%>
	    	</table>
		 	<%} else{%>
		 		<div class="nosuchusr">
		           <p align="center">No Auth Domain for the User/Org</p> <%--No I18N--%>
			</div>
			<%}%>
	 </div>	
 <div id="userservice" style="display:none;">
<%
        if(u != null) {
            List<UserAccount> ualistActive = Util.USERAPI.getUsedAccounts(u.getZUID());
            List<UserAccount> ualistALL = Util.USERAPI.getAccounts(u.getZUID());
            if((ualistActive != null && !ualistActive.isEmpty())|| (ualistALL != null && !ualistALL.isEmpty())) {
			List<Integer> listservices = new ArrayList<Integer>();
%>
        <table class="org_details" cellpadding="4">
            <tr>
		<td class="usrinfoheader">Service Name</td>
		<td class="usrinfoheader">User Status</td>
		<td class="usrinfoheader">Created Time</td>
	    </tr>
            <% if(ualistActive != null && !ualistActive.isEmpty()) {
            	for(UserAccount ua : ualistActive) {
            		Service usedService1 = ua != null ? Util.SERVICEAPI.getService(ua.getServiceId()) : null;
            		if(usedService1 == null) {
            			continue;
            		}
            		listservices.add(ua.getServiceId());
            	%>
            <tr>
		<td class="usremailtd" width="35%">
			<div class="emailleftdiv">
				<img class="usedServices" src="/images/spacer.gif">
				<span><%=usedService1.getServiceName()%></span><%--No I18N--%><%-- NO OUTPUTENCODING --%>
			</div>
  		</td>
		<td class="usremailtd" width="30%"><%=ua.isEnabled() ? "Active" : "Inactive"%></td>
		<td class="usremailtd" width="35%"><%=ua.getCreatedTime() != -1 ? new Date(ua.getCreatedTime()) : ""%></td><%-- NO OUTPUTENCODING --%>
	    </tr>
            <% }
            }%>
             <% if(ualistALL != null && !ualistALL.isEmpty()) {
            	for(UserAccount ua : ualistALL) {
	            	if(!listservices.contains(ua.getServiceId())) {
	            		Service usedService2 = ua != null ? Util.SERVICEAPI.getService(ua.getServiceId()) : null;
	            		if(usedService2 == null) {
	            			continue;
	            		}
	            	%>
	            <tr>
				<td class="usremailtd" width="35%">
					<div class="emailleftdiv">
						<span><%=usedService2.getServiceName()%></span><%--No I18N--%><%-- NO OUTPUTENCODING --%>
					</div>
		  		</td>
				<td class="usremailtd" width="30%"><%=ua.isEnabled() ? "Active" : "Inactive"%></td><%--No I18N--%>
				<td class="usremailtd" width="35%"><%=ua.getCreatedTime() != -1 ? new Date(ua.getCreatedTime()) : ""%></td><%-- NO OUTPUTENCODING --%>
		    </tr>
	            <% }
	            	}
            }%>
        </table>
        <div>
			<img class="usedServicesNoteImg" src="/images/spacer.gif">
			<div class="usedServicesNote">Services used by user</div><%--No I18N--%>
		</div>
            <% } else { %>
        <div class="nosuchusr">
            <p align="center">UserAccounts object is empty.</p> <%--No I18N--%>
	</div>
<%
            }
        }
%>
    </div>
    <div id="tfa_details" style="display:none;"></div>
    <div id="change_history" style="display:none;"></div>
    <div id="org_details" <%if(u != null) {%>style="display:none;"<%}%>>
	    <%if(org != null) {%>
	<table class="org_details" cellpadding="4">
	    <tr>
		<td class="usrinfoheader">NAME</td> <%--No I18N--%>
		<td class="usrinfoheader">VALUE</td> <%--No I18N--%>
	    </tr>
	    <tr>
		<td class="orgdetailtd">ZOID</td> <%--No I18N--%>
		<td class="orgdetailtd"><%=org.getZOID()%></td><%-- NO OUTPUTENCODING --%>
	    </tr>
	    <tr>
		<td class="orgdetailtd">Org Name</td> <%--No I18N--%>
		<td class="orgdetailtd"><%=IAMEncoder.encodeHTML(org.getOrgName())%></td>
	    </tr>
	    <tr>
		<td class="orgdetailtd">Display Name</td> <%--No I18N--%>
		<td class="orgdetailtd"><%=IAMEncoder.encodeHTML(org.getDisplayName())%></td>
	    </tr>
	    <tr>
		<td class="orgdetailtd">Screen Name</td> <%--No I18N--%>
		<td class="orgdetailtd"><%=org.getScreenName() != null ? IAMEncoder.encodeHTML(org.getScreenName()) : ""%></td>
	    </tr>
	    <tr>
		<td class="orgdetailtd">Org Contact</td> <%--No I18N--%>
		<%
		    String orgContact = "";
		    UserEmail orgContactUserEmail = org.getOrgContact() != -1 ? Util.USERAPI.getPrimaryEmail(org.getOrgContact()) : null;
		    if(orgContactUserEmail != null) orgContact = orgContactUserEmail.getEmailId();
		%>
		<td class="orgdetailtd"><%=IAMEncoder.encodeHTML(orgContact)%></td>
	    </tr>
	    <tr>
		<td class="orgdetailtd">Total Users</td> <%--No I18N--%>
		<td class="orgdetailtd"><%=Util.ORGAPI.getOrgUsersCount(org.getZOID())%></td><%-- NO OUTPUTENCODING --%>
	    </tr>
	    <tr>
		<td class="orgdetailtd">Active Users</td> <%--No I18N--%>
		<td class="orgdetailtd"><%=Util.ORGAPI.getOrgUsersCount(org.getZOID(), UserStatus.ACTIVE)%></td><%-- NO OUTPUTENCODING --%>
	    </tr>
	    <tr>
		<td class="orgdetailtd">SAML LoginURL</td> <%--No I18N--%>
		<td class="orgdetailtd"><%=org.getSamlLoginURL() != null ? IAMEncoder.encodeHTML(org.getSamlLoginURL()) : ""%></td>
	    </tr>
	    <tr>
		<td class="orgdetailtd">SAML LogoutURL</td> <%--No I18N--%>
		<td class="orgdetailtd"><%=org.getSamlLogoutURL() != null ? IAMEncoder.encodeHTML(org.getSamlLogoutURL()) : ""%></td>
	    </tr>
	    <tr>
		<td class="orgdetailtd">Mobile</td> <%--No I18N--%>
		<td class="orgdetailtd"><%=org.getMobile() != null ? IAMEncoder.encodeHTML(org.getMobile()) : ""%></td>
	    </tr>
	    <tr>
		<td class="orgdetailtd">Org Status</td> <%--No I18N--%>
		<td class="orgdetailtd"><%=org.getOrgStatus() == 0 ? "Inactive" : org.getOrgStatus() == 1 ? "Active" : org.getOrgStatus()%></td>
	    </tr>
	    <tr>
		<td class="orgdetailtd">Created Time</td> <%--No I18N--%>
		<td class="orgdetailtd"><%=org.getCreatedTime() != -1 ? new Date(org.getCreatedTime()) : ""%></td><%-- NO OUTPUTENCODING --%>
	    </tr>
	    <tr>
		<td class="orgdetailtd">Last Modified Time</td> <%--No I18N--%>
		<td class="orgdetailtd"><%=org.getLastModifiedTime() != -1 ? new Date(org.getLastModifiedTime()) : ""%></td><%-- NO OUTPUTENCODING --%>
	    </tr>
	</table>
	    <%} else {%>
	<div class="nosuchusr">
	    <p align="center">Organization object is null.</p> <%--No I18N--%>
	</div>
	    <%}%>
    </div>

    <div id="orgdomain_details" style="display:none;">
	    <%if(orgDomainList != null && !orgDomainList.isEmpty()) {%>
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
		<%for(OrgDomain orgDomain : orgDomainList) {%>
	    <tr>
		<td class="usremailtd"><%=IAMEncoder.encodeHTML(orgDomain.getDomainName())%></td>
		<td class="usremailtd"><%=orgDomain.isPrimary()%></td><%-- NO OUTPUTENCODING --%>
		<td class="usremailtd"><%=orgDomain.isVerified()%></td><%-- NO OUTPUTENCODING --%>
		<td class="usremailtd"><%=orgDomain.isRegisteredByZoho()%></td><%-- NO OUTPUTENCODING --%>
		<%
		    String verByContact = "";
		    UserEmail verByContactEmail = orgDomain.getVerBy() != -1 ? Util.USERAPI.getPrimaryEmail(orgDomain.getVerBy()) : null;
		    if(verByContactEmail != null) verByContact = verByContactEmail.getEmailId();
		%>
		<td class="usremailtd"><%=IAMEncoder.encodeHTML(verByContact)%></td>
		<td class="usremailtd"><%=(orgDomain.getVerDate() != -1 && orgDomain.getVerDate() != 0) ? new Date(orgDomain.getVerDate()) : ""%></td><%-- NO OUTPUTENCODING --%>
		<td class="usremailtd"><%=orgDomain.getCreatedTime() != -1 ? new Date(orgDomain.getCreatedTime()) : ""%></td><%-- NO OUTPUTENCODING --%>
		<td class="usremailtd"><%=orgDomain.getParentDomainName() != null ? orgDomain.getParentDomainName() : ""%></td><%-- NO OUTPUTENCODING --%>
	    </tr>
		<%}%>
	</table>
	    <%} else {%>
	<div class="nosuchusr">
	    <p align="center">Org domain object is null or empty.</p> <%--No I18N--%>
	</div>
	    <%}%>
    </div>
    <div id="orgpolicy_details" style="display:none;">
    <%
    if(org != null) {
    	OrgPolicy orgPolicy=Util.ORGAPI.getOrgPolicy(org.getZOID());
    	OrgPolicy defaultPolicy = new OrgPolicy();
    %>
    	<div class="policytypetxt">Policy Type : <blink><%=isOrgPolicyExists(org.getZOID()+"") ? "Custom" : "Default"%></blink></div><%-- No I18N --%>
		<table class="orgpolicy_details" cellpadding="4">
			<tr>
			<td class="usrinfoheader">Policy Name</td> <%--No I18N--%>
			<td class="usrinfoheader">Applied Value</td> <%--No I18N--%>
			<td class="usrinfoheader">Default Value</td> <%--No I18N--%>
			</tr>

			<tr>
			<td class="usremailtd">Maximum Users</td><%-- No I18N --%>
			<td class="usremailtd"><%=(orgPolicy.getMaxAllowedUsers())%></td><%-- NO OUTPUTENCODING --%>
			<td class="usremailtd"><%=(defaultPolicy.getMaxAllowedUsers())%></td><%-- NO OUTPUTENCODING --%>
			</tr>

			<tr>
			<td class="usremailtd">Maximum Groups</td><%-- No I18N --%>
			<td class="usremailtd"><%=(orgPolicy.getMaxAllowedGroups())%></td><%-- NO OUTPUTENCODING --%>
			<td class="usremailtd"><%=(defaultPolicy.getMaxAllowedGroups())%></td><%-- NO OUTPUTENCODING --%>
			</tr>

			<tr>
			<td class="usremailtd">Change Full Name</td><%-- No I18N --%>
			<td class="usremailtd"><%=getAllowedUsersForOrgPolicy(orgPolicy.getChangeFullname())%></td> <%-- NO OUTPUTENCODING --%>
			<td class="usremailtd"><%=getAllowedUsersForOrgPolicy(defaultPolicy.getChangeFullname())%></td> <%-- NO OUTPUTENCODING --%>
			</tr>

			<tr>
			<td class="usremailtd">Change Profile Photo</td><%-- No I18N --%>
			<td class="usremailtd"><%=getAllowedUsersForOrgPolicy(orgPolicy.getChangeProfilePhoto())%></td> <%-- NO OUTPUTENCODING --%>
			<td class="usremailtd"><%=getAllowedUsersForOrgPolicy(defaultPolicy.getChangeProfilePhoto())%></td> <%-- NO OUTPUTENCODING --%>
			</tr>

			<tr>
			<td class="usremailtd">Change Primary Email</td><%-- No I18N --%>
			<td class="usremailtd"><%=getAllowedUsersForOrgPolicy(orgPolicy.getPrimaryEmailChange())%></td> <%-- NO OUTPUTENCODING --%>
			<td class="usremailtd"><%=getAllowedUsersForOrgPolicy(defaultPolicy.getPrimaryEmailChange())%></td> <%-- NO OUTPUTENCODING --%>
			</tr>

			<tr>
			<td class="usremailtd">Add Secondary Email</td><%-- No I18N --%>
			<td class="usremailtd"><%=getAllowedUsersForOrgPolicy(orgPolicy.getAddSecondaryEmail())%></td> <%-- NO OUTPUTENCODING --%>
			<td class="usremailtd"><%=getAllowedUsersForOrgPolicy(defaultPolicy.getAddSecondaryEmail())%></td> <%-- NO OUTPUTENCODING --%>
			</tr>

			<tr>
			<td class="usremailtd">Always Secure Acces</td><%-- No I18N --%>
			<td class="usremailtd"><%=getAllowedUsersForOrgPolicy(orgPolicy.getAlwaysSecureAccess())%></td> <%-- NO OUTPUTENCODING --%>
			<td class="usremailtd"><%=getAllowedUsersForOrgPolicy(defaultPolicy.getAlwaysSecureAccess())%></td> <%-- NO OUTPUTENCODING --%>
			</tr>

			<tr>
			<td class="usremailtd">Enable ThirdParty SignIn</td><%-- No I18N --%>
			<td class="usremailtd"><%=getAllowedUsersForOrgPolicy(orgPolicy.getEnableThirdPartySignIn())%></td> <%-- NO OUTPUTENCODING --%>
			<td class="usremailtd"><%=getAllowedUsersForOrgPolicy(defaultPolicy.getEnableThirdPartySignIn())%></td> <%-- NO OUTPUTENCODING --%>
			</tr>

			<tr>
			<td class="usremailtd">Create Document</td><%-- No I18N --%>
			<td class="usremailtd"><%=getAllowedUsersForOrgPolicy(orgPolicy.getCreateDocument())%></td> <%-- NO OUTPUTENCODING --%>
			<td class="usremailtd"><%=getAllowedUsersForOrgPolicy(defaultPolicy.getCreateDocument())%></td> <%-- NO OUTPUTENCODING --%>
			</tr>

			<tr>
			<td class="usremailtd">External CoOwner</td><%-- No I18N --%>
			<td class="usremailtd"><%=getAllowedUsersForOrgPolicy(orgPolicy.getExternalCoOwner())%></td> <%-- NO OUTPUTENCODING --%>
			<td class="usremailtd"><%=getAllowedUsersForOrgPolicy(defaultPolicy.getExternalCoOwner())%></td> <%-- NO OUTPUTENCODING --%>
			</tr>

			<tr>
			<td class="usremailtd">Document Sharing with non-Organisation Users</td><%-- No I18N --%>
			<td class="usremailtd"><%=getAllowedUsersForOrgPolicy(orgPolicy.getShareDocumentExternally())%></td> <%-- NO OUTPUTENCODING --%>
			<td class="usremailtd"><%=getAllowedUsersForOrgPolicy(defaultPolicy.getShareDocumentExternally())%></td> <%-- NO OUTPUTENCODING --%>
			</tr>

			<tr>
			<td class="usremailtd">Export Document</td><%-- No I18N --%>
			<td class="usremailtd"><%=getAllowedUsersForOrgPolicy(orgPolicy.getExportDocument())%></td> <%-- NO OUTPUTENCODING --%>
			<td class="usremailtd"><%=getAllowedUsersForOrgPolicy(defaultPolicy.getExportDocument())%></td> <%-- NO OUTPUTENCODING --%>
			</tr>

			<tr>
			<td class="usremailtd">Publish Document</td><%-- No I18N --%>
			<td class="usremailtd"><%=getAllowedUsersForOrgPolicy(orgPolicy.getPublishDocument())%></td> <%-- NO OUTPUTENCODING --%>
			<td class="usremailtd"><%=getAllowedUsersForOrgPolicy(defaultPolicy.getPublishDocument())%></td> <%-- NO OUTPUTENCODING --%>
			</tr>

			<tr>
			<td class="usremailtd">Delete Document</td><%-- No I18N --%>
			<td class="usremailtd"><%=getAllowedUsersForOrgPolicy(orgPolicy.getDeleteDocument())%></td> <%-- NO OUTPUTENCODING --%>
			<td class="usremailtd"><%=getAllowedUsersForOrgPolicy(defaultPolicy.getDeleteDocument())%></td> <%-- NO OUTPUTENCODING --%>
			</tr>

			<tr>
			<td class="usremailtd">Create Personal Group</td><%-- No I18N --%>
			<td class="usremailtd"><%=getAllowedUsersForOrgPolicy(orgPolicy.getCreatePersonalGroup())%></td> <%-- NO OUTPUTENCODING --%>
			<td class="usremailtd"><%=getAllowedUsersForOrgPolicy(defaultPolicy.getCreatePersonalGroup())%></td> <%-- NO OUTPUTENCODING --%>
			</tr>

			<tr>
			<td class="usremailtd">Create Personal Group with Non-Organization</td><%-- No I18N --%>
			<td class="usremailtd"><%=getAllowedUsersForOrgPolicy(orgPolicy.getCreatePublicGroupsWithNonOrgUsers())%></td> <%-- NO OUTPUTENCODING --%>
			<td class="usremailtd"><%=getAllowedUsersForOrgPolicy(defaultPolicy.getCreatePublicGroupsWithNonOrgUsers())%></td> <%-- NO OUTPUTENCODING --%>
			</tr>

			<tr>
			<td class="usremailtd">Create Organization Group</td><%-- No I18N --%>
			<td class="usremailtd"><%=getAllowedUsersForOrgPolicy(orgPolicy.getCreateOrgGroup())%></td> <%-- NO OUTPUTENCODING --%>
			<td class="usremailtd"><%=getAllowedUsersForOrgPolicy(defaultPolicy.getCreateOrgGroup())%></td> <%-- NO OUTPUTENCODING --%>
			</tr>

			<tr>
			<td class="usremailtd">Personal Contacts Chat</td><%-- No I18N --%>
			<td class="usremailtd"><%=getAllowedUsersForOrgPolicy(orgPolicy.getPersonalContactsChat())%></td> <%-- NO OUTPUTENCODING --%>
			<td class="usremailtd"><%=getAllowedUsersForOrgPolicy(defaultPolicy.getPersonalContactsChat())%></td> <%-- NO OUTPUTENCODING --%>
			</tr>

			<tr>
			<td class="usremailtd">Organisation Contacts Chat</td><%-- No I18N --%>
			<td class="usremailtd"><%=getAllowedUsersForOrgPolicy(orgPolicy.getOrgContactsChat())%></td> <%-- NO OUTPUTENCODING --%>
			<td class="usremailtd"><%=getAllowedUsersForOrgPolicy(defaultPolicy.getOrgContactsChat())%></td> <%-- NO OUTPUTENCODING --%>
			</tr>

			<tr>
			<td class="usremailtd">Personal Chat File Transfer</td><%-- No I18N --%>
			<td class="usremailtd"><%=getAllowedUsersForOrgPolicy(orgPolicy.getPersonalChatFiletransfer())%></td> <%-- NO OUTPUTENCODING --%>
			<td class="usremailtd"><%=getAllowedUsersForOrgPolicy(defaultPolicy.getPersonalChatFiletransfer())%></td> <%-- NO OUTPUTENCODING --%>
			</tr>

			<tr>
			<td class="usremailtd">Organisation Chat File Transfer</td><%-- No I18N --%>
			<td class="usremailtd"><%=getAllowedUsersForOrgPolicy(orgPolicy.getOrgChatFiletransfer())%></td> <%-- NO OUTPUTENCODING --%>
			<td class="usremailtd"><%=getAllowedUsersForOrgPolicy(defaultPolicy.getOrgChatFiletransfer())%></td> <%-- NO OUTPUTENCODING --%>
			</tr>

			<tr>
			<td class="usremailtd">ThirdParty IM Chat</td><%-- No I18N --%>
			<td class="usremailtd"><%=getAllowedUsersForOrgPolicy(orgPolicy.getThirdPartyIMChat())%></td> <%-- NO OUTPUTENCODING --%>
			<td class="usremailtd"><%=getAllowedUsersForOrgPolicy(defaultPolicy.getThirdPartyIMChat())%></td> <%-- NO OUTPUTENCODING --%>
			</tr>

			<tr>
			<td class="usremailtd">Enable Organisation Buddies </td><%-- No I18N --%>
			<td class="usremailtd"><%=(orgPolicy.isOrgBuddiesEnabled())%></td> <%-- NO OUTPUTENCODING --%>
			<td class="usremailtd"><%=(defaultPolicy.isOrgBuddiesEnabled())%></td> <%-- NO OUTPUTENCODING --%>
			</tr>

			<tr>
			<td class="usremailtd">Auto Provisioning SAML for Users</td><%-- No I18N --%>
			<td class="usremailtd"><%=orgPolicy.isAutoProvisionAllowed()%></td> <%-- NO OUTPUTENCODING --%>
			<td class="usremailtd"><%=defaultPolicy.isAutoProvisionAllowed()%></td> <%-- NO OUTPUTENCODING --%>
			</tr>

			<% if (u != null && Util.getParentZAID(u.getZOID()) != -1) {%>
			<tr>
	       	<td class="orgpolicy">Partner SAML Configuration Inherited</td> <%--No I18N--%>
		   	<td class="orgpolicy"><%=orgPolicy.isPartnerSamlConfigInherited()%></td> <%-- NO OUTPUTENCODING --%>
		   	<td class="orgpolicy"><%=defaultPolicy.isPartnerSamlConfigInherited()%></td> <%-- NO OUTPUTENCODING --%>
	       	</tr>
	       	<% } %>

			<tr>
			<td class="usremailtd">Sync Users To Organisation Contacts </td><%-- No I18N --%>
			<td class="usremailtd"><%=(orgPolicy.isOrgContactsSyncEnabled())%></td> <%-- NO OUTPUTENCODING --%>
			<td class="usremailtd"><%=(defaultPolicy.isOrgContactsSyncEnabled())%></td> <%-- NO OUTPUTENCODING --%>
			</tr>

	    	<tr>
	       	<td class="orgpolicy">Enable TFA Preference For Organisation  </td> <%--No I18N--%>
		   	<td class="orgpolicy"><%=orgPolicy.isTFAPrefOptionEnabled()%></td> <%-- NO OUTPUTENCODING --%>
		   	<td class="orgpolicy"><%=defaultPolicy.isTFAPrefOptionEnabled()%></td> <%-- NO OUTPUTENCODING --%>
	       	</tr>
			
			<tr>
	       	<td class="orgpolicy">Enable TFA Preference using Exostar </td> <%--No I18N--%>
		   	<td class="orgpolicy"><%=orgPolicy.isTFAExoPref()%></td> <%-- NO OUTPUTENCODING --%>
		   	<td class="orgpolicy"><%=defaultPolicy.isTFAPrefOptionEnabled()%></td> <%-- NO OUTPUTENCODING --%>
	       	</tr>
			
			<tr>
	       	<td class="orgpolicy">Enable Domain Restriction For Invite Users </td> <%--No I18N--%>
		   	<td class="orgpolicy"><%=orgPolicy.isDomainRestrictionForInviteUsers()%></td> <%-- NO OUTPUTENCODING --%>
		   	<td class="orgpolicy"><%=defaultPolicy.isDomainRestrictionForInviteUsers()%></td> <%-- NO OUTPUTENCODING --%>
	       	</tr>
	       	
	       	<tr>
	       	<td class="orgpolicy">Alllowed No Of Domain  </td> <%--No I18N--%>
		   	<td class="orgpolicy"><%=orgPolicy.getAllowedNoOfDomains()%></td> <%-- NO OUTPUTENCODING --%>
		   	<td class="orgpolicy"><%=defaultPolicy.getAllowedNoOfDomains()%></td> <%-- NO OUTPUTENCODING --%>
	       	</tr>

	    </table>
	<% } else { %>
	    <div class="nosuchusr"><p align="center">Org policy is null.</p></div><%-- No I18N --%>
	<% } %>
	    </div>
</div>
 <% }else if(u==null && org==null){
		DCLocation loc = GeoDCHandler.getUserLocation(qry);
	  	  %>
	  	  <div class="nosuchusr">  <%-- No I18N --%>
		<p align="center"><%if(loc==null) {%>Invalid Search.<%}else{%><%=IAMEncoder.encodeHTML(loc.getDescription()+" , "+loc.getLocation()) %><%} %></p><%--No I18N--%>
		<%--No I18N--%>
	</div>
	<%
	AccountCloseAudit[] aca = null;
	if(AccountsConfiguration.ENABLE_DFS_AUDIT.toBooleanValue() && AccountsConfiguration.ENABLE_ACCOUNT_CLOSE_AUDIT_API.toBooleanValue()){
		aca = ARMAccountCloseAudit.getAudit(type, qry);
	}else{
		aca = AuditResource.getAccountCloseAuditURI().getQueryString().setCriteria(new Criteria(ACCOUNTCLOSEAUDIT.USERNAME,qry)).build().GETS();
	}
  	  if(aca!=null){ %>
  	  <div class="policytypetxt">Account Status : <blink>Closed Account</blink></div><%-- No I18N --%>
  		<%   int cnt=1;
  		  for(AccountCloseAudit closeduser:aca){ %>



  	  <table class="usrinfotbl" width="100%">
      		    <tr>
      			<td valign="top" width="50%">
      			    <table cellpadding="3">
      				<tr>
      				    <td class="usrinfotdlt">ZUID</td> <%--No I18N--%>
      				    <td class="usrinfotdrt"><%=closeduser.getZuid()%></td><%-- NO OUTPUTENCODING --%>
      				</tr>
      				<tr>
      				    <td class="usrinfotdlt">USERNAME</td> <%--No I18N--%>
      				    <td class="usrinfotdrt"><%=IAMEncoder.encodeHTML(closeduser.getUsername())%></td><%-- NO OUTPUTENCODING --%>
      				</tr>
      				<tr>
      				    <td class="usrinfotdlt">CLOSED TIME</td> <%--No I18N--%>
      				    <td class="usrinfotdrt"><%=new Date(closeduser.getCreatedTime())%></td><%-- NO OUTPUTENCODING --%>
      				</tr>
      				
      				<%
      				String usedService=closeduser.getUsedServices();
      				String[] services=usedService.split(",");
      				String servicesList="";
      				for(String serv:services){
      					int id=-1;
      					String servName = null;
      					try{
      						id=Integer.parseInt(serv);
      						servName=Util.SERVICEAPI.getService(id).getDisplayName();
      					}catch(NumberFormatException nfe){
      						servName=serv;
      					}
      					if(servName.startsWith("Zoho")){
								servName =servName.replace("Zoho", "");//No I18N
								if(servName.startsWith(" ")){
									servName =servName.substring(1, servName.length()-1);
								}
						}
						servicesList= servicesList+servName+","; //No I18N
      				}
      				servicesList = servicesList.endsWith(",") ? servicesList.substring(0, servicesList.length() - 1) : servicesList;
      			
      				%>
      				<tr>
      				    <td class="usrinfotdlt">USED SERVICES</td> <%--No I18N--%>
      				    <td class="usrinfotdrt"><%=IAMEncoder.encodeHTML(servicesList)%></td><%-- NO OUTPUTENCODING --%>
      				</tr>
      				<tr>
      				    <td class="usrinfotdlt">DETAILS</td> <%--No I18N--%>
      				    <td class="usrinfotdrt"><a href="javascript:;"onclick="document.getElementById('div_<%=cnt%>').style.display='';">More Details</a><br> <%--No I18N--%>
      				    <div class="usrdetails" style="display:none;left:40%;right:21%;" id="div_<%=cnt%>">
      				    <div class="close_div" onclick="closeDetails('div_<%=cnt%>')">x</div><%--No I18N--%>

      				    <% User ClosedUser=Util.USERAPI.getUser(Long.parseLong(closeduser.getZuid())); %>
						<div>
				        <div class="displayConLeft"><b>ZOID : </b></div><%--No I18N--%>
						<div class="displayConRight">&nbsp;&nbsp;<%= ClosedUser.getZOID()%></div><%-- NO OUTPUTENCODING --%>
						</div>
						<div>
				        <div class="displayConLeft"><b>ZAID : </b></div><%--No I18N--%>
						<div class="displayConRight">&nbsp;&nbsp;<%= ClosedUser.getZaid()%></div><%-- NO OUTPUTENCODING --%>
						</div>
						<div>
						<div class="displayConLeft"><b>USERNAME : </b></div><%--No I18N--%>
						<div class="displayConRight">&nbsp;&nbsp;<%=IAMEncoder.encodeHTML(ClosedUser.getLoginName())%></div>
						</div>
						<div>
						<div class="displayConLeft"><b>FULLNAME : </b></div><%--No I18N--%>
						<div class="displayConRight">&nbsp;&nbsp;<%=IAMEncoder.encodeHTML(ClosedUser.getFullName())%></div>
						</div>
						<div>
						<div class="displayConLeft"><b>NICKNAME : </b></div><%--No I18N--%>
						<div class="displayConRight">&nbsp;&nbsp;<%=IAMEncoder.encodeHTML(ClosedUser.getDisplayName())%></div>
						</div>
						<div>
						<div class="displayConLeft"><b>USER STATUS : </b></div><%--No I18N--%>
						<div class="displayConRight">&nbsp;&nbsp;<%= RestProtoUtil.getUserStatus(""+ClosedUser.getZUID())%></div><%-- NO OUTPUTENCODING --%>
						</div>
						<div>
						<div class="displayConLeft"><b>LANGUAGE : </b></div><%--No I18N--%>
						<div class="displayConRight">&nbsp;&nbsp;<%=IAMEncoder.encodeHTML(ClosedUser.getLanguage())%></div>
						</div>
						<div>
						<div class="displayConLeft"><b>TIMEZONE : </b></div><%--No I18N--%>
						<div class="displayConRight">&nbsp;&nbsp;<%= IAMEncoder.encodeHTML(ClosedUser.getTimezone())%></div>
						</div>

						<%   OrgLocation orgLocation =ClosedUser.getWorkAddress();
					    String workAddr = orgLocation != null ? orgLocation.getLocationName() : null;
			            String ipAddress =ClosedUser.getProperty(User.IP_ADDRESS, null);%>

			            <div>
						<div class="displayConLeft"><b>IP ADDRESS : </b></div><%--No I18N--%>
						<div class="displayConRight">&nbsp;&nbsp;<%=ipAddress != null ? IAMEncoder.encodeHTML(ipAddress) : "" %></div>
						</div>
						<div>
						<div class="displayConLeft"><b>REFERRER : </b></div><%--No I18N--%>
						<div class="displayConRight">&nbsp;&nbsp;<%=IAMEncoder.encodeHTML(ClosedUser.getReferer()) %></div>
						</div>
						<div>
						<div class="displayConLeft"><b>IPID : </b></div><%--No I18N--%>
						<div class="displayConRight">&nbsp;&nbsp;<%=CSPersistenceAPIImpl.getUserIPID(ClosedUser)%></div><%-- NO OUTPUTENCODING --%>
						</div>
						<div>
						<div class="displayConLeft"><b>IDP : </b></div><%--No I18N--%>
						<div class="displayConRight">&nbsp;&nbsp;<%=AccountsConstants.IdentityProvider.valueOfInt(ClosedUser.getIDP())%></div> <%-- NO OUTPUTENCODING --%>
						</div>
						<div>
      				    <div class="mrpBtn">
				        <input type="button" value="Close" onclick="closeDetails('div_<%=cnt%>')">
				        </div>
				        </div>
				        </div>
      				</tr>
      				</table>
      				</td>
      				</tr>
      				</table>

<%    cnt++;
}
	  }
  	  %>
<%}
          }%>
<%!
Logger LOGGER = Logger.getLogger("USER_INFO");//No I18N
private boolean isOrgPolicyExists(String ZAID) {
	try {
		Policy policy = (Policy) RestProtoUtil.GET(Accounts.getPolicyURI(ZAID));
		return policy != null;
	}catch(Exception e) {
		LOGGER.log(Level.WARNING, "Exception occured while checking org policy status for given ZOID "+ZAID, e);
	}
	return false;
}
private String getAllowedUsersForOrgPolicy(int policyValue) {
	return policyValue == 0 ? "All Members" : policyValue == 1 ? "Moderators" : policyValue == 2 ? "Super Administrator" : "Nobody"; //No I18N
}
%>
