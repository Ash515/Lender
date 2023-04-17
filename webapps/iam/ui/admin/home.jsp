<%-- $Id: $ --%>
<!DOCTYPE HTML>
<%@ include file="../../static/includes.jspf" %>
<html>
    <head><title><%=Util.getI18NMsg(request,"IAM.ZOHO.ACCOUNTS")%></title>
<%
	boolean hideHeader = Boolean.parseBoolean(request.getParameter("hideheader"));
	User user = IAMUtil.getCurrentUser();
	long zuId = user.getZUID();

    boolean isIAMAdmin = request.isUserInRole("IAMAdmininistrator");
    boolean isIAMUser = request.isUserInRole("IAMUser");
    boolean isMarketingAdmin = request.isUserInRole("MarketingAdmin");
    boolean isIAMOperator = request.isUserInRole("IAMOperator");
    boolean isSupportAdmin = request.isUserInRole("SupportAdmin");
    boolean isIAMServiceAdmin = request.isUserInRole(Role.IAM_SERVICE_ADMIN);
    boolean isLegalAdmin = request.isUserInRole("LegalAdmin");
    boolean isSDAdmin = request.isUserInRole("SDAdmin");
    boolean isOAuthAdmin = request.isUserInRole("OAuthAdmin");
    boolean isDomainAdmin = request.isUserInRole("IAMDomainAdmin");
    boolean isIAMSupportAdmin = request.isUserInRole("IAMSupportAdmin");
    boolean isIAMCacheAdmin = request.isUserInRole("IAMCacheAdmin");
    boolean isIAMSystemAdmin = request.isUserInRole("IAMSystemAdmin");
    boolean isClearCacheOperator = request.isUserInRole("ClearCacheOperator");
	boolean isIAMTemplateAdmin = request.isUserInRole("IAMTemplateAdmin");
    boolean isTestAccountsAdmin = request.isUserInRole("IAMTestAccountsAdmin");
	
	String iamHelpLink = "";
	String userid = CryptoUtil.encryptWithSalt("photo", zuId+"", ":", IAMUtil.getCurrentTicket(), true); //No I18N
%>
    <script src="<%=jsurl%>/jquery-1.12.2.min.js" type="text/javascript"></script> <%-- NO OUTPUTENCODING --%>
    <script src="<%=wmsjsurl%>/wmsliteapi.js" type="text/javascript"></script> <%-- NO OUTPUTENCODING --%>
    <script src="<%=jsurl%>/chosen.jquery.js" type="text/javascript"></script> <%-- NO OUTPUTENCODING --%>
    <link href="<%=cssurl%>/chosen.css" type="text/css" type="text/css" rel="stylesheet" /> <%-- NO OUTPUTENCODING --%>
    
    <link href="<%=cssurl%>/select2.min.css" rel="stylesheet" />	<%-- NO OUTPUTENCODING --%>
	<script src="<%=jsurl%>/select2.min.js"></script>	<%-- NO OUTPUTENCODING --%>

	<link href="<%=cssurl_st%>/ui.ztooltip.css" type="text/css" rel="stylesheet"  /><%-- NO OUTPUTENCODING --%>

    <script src="<%=jsurl%>/jquery.ztooltip.js" type="text/javascript"></script> <%-- NO OUTPUTENCODING --%>
	
    <script src="<%=jsurl%>/common.js" type="text/javascript"></script> <%-- NO OUTPUTENCODING --%>
    <script src="<%=jsurl%>/xregexp-all.js" type="text/javascript"></script> <%-- NO OUTPUTENCODING --%>
    <script src="<%=jsurl%>/admin.js" type="text/javascript"></script> <%-- NO OUTPUTENCODING --%>
    <script src="<%=jsurl%>/supportadmin.js" type="text/javascript"></script> <%-- NO OUTPUTENCODING --%>
    <link href="<%=cssurl%>/style.css" type="text/css" rel="stylesheet" /> <%-- NO OUTPUTENCODING --%>
    <link href="<%=cssurl%>/admin.css" type="text/css" rel="stylesheet" /> <%-- NO OUTPUTENCODING --%>
    <script type="text/javascript">
	<%if ("true".equals(AccountsConfiguration.getConfiguration("use.https", "true"))) {%>
		var loc_port = window.location.port;
		if(loc_port =="" || loc_port == "80") {
        	var iurl=window.location.href;if(iurl.indexOf("http://")==0){iurl=iurl.replace("http://", "https://");window.location.href=iurl;}
		}
	<%}%>
		var fromService = false;
		var mainmenu = 'admin';//No I18N
		<%if(isIAMAdmin || isIAMUser || isMarketingAdmin || isIAMOperator || isSupportAdmin || isIAMServiceAdmin || isLegalAdmin || isIAMSupportAdmin) {%>
		var submenu = 'userinfo_panel';//No I18N
		<%} else if(isSDAdmin) {%>
		var submenu = 'sec_private_key';//No I18N
		<%} else if (isOAuthAdmin){%>
		var submenu = 'mobile_registration';//No I18N
		<%}else if (isDomainAdmin){%>
		var submenu = 'domain_verify';//No I18N
		<%} else if (isClearCacheOperator){%>
		var submenu = 'clearcache_panel';//No I18N
		<%} else if (isIAMSystemAdmin){%>
		var submenu = 'dclocation_panel';//No I18N
		<%} else if (isIAMTemplateAdmin){%>
		var submenu = 'i18n_panel';//No I18N
		<%} else if (isIAMServiceAdmin){%>
		var submenu = 'oauth_scope';//NO I18N
		<%}%>
		var contextpath = "<%=request.getContextPath()%>"; //NO OUTPUTENCODING	
		var csrfParam = '<%=SecurityUtil.getCSRFParamName(request)+"="+SecurityUtil.getCSRFCookie(request)%>'; //NO OUTPUTENCODING
	
		$(document).ready(function(){
	    	$(document).ztooltip();
	    	$("#ztb-change-photo,#ztb-help").hide();
	    });
    </script>
    <script src="<%=cPath%>/error-msgs?<%=Util.getErrorQS()%>" type="text/javascript"></script> <%-- NO OUTPUTENCODING --%>
	</head>
    <body>
		<!-- General Success Message -->
		<div id="msg_div" align="center">
			<table cellspacing="0" cellpadding="0">
				<tr><td>
					<span id="msgspan" class="successmsg"><span class="tickicon" id="tickicon"></span>&nbsp;<span id="msgpanel"></span></span>
				</td></tr>
			</table>
		</div>
		<div id="tempwin"></div>
		<div class="wrappermain">
			<div class="clrmrgn"><div class="ztb-topband" id="ztb-topband"><%@ include file="../../ui/profile/header.jspf" %></div></div>
			<div class="clrmrgn1">		
				<div id="progress-cont" style="display:none;"><img src="<%=imgurl%>/indicator.gif"/><div><%=Util.getI18NMsg(request,"IAM.LOADING")%>.....</div></div> <!-- NO OUTPUTENCODING -->
				<div id="mainmenupanel">
  					<div class="wrapper">
  						<div class="pane1 mnavi system-mainnavi">
    						<ul>
    							<li><a id="home" href="<%=cPath%>/u/h"><span class="mnavi-icon mnavi-org-icon"></span><%=Util.getI18NMsg(request, "IAM.MENU.DASHBOARD")%></a></li><%-- NO OUTPUTENCODING --%>								
								<li><a id="admin" class="active" onclick="loadTab('admin','userinfo_panel','/ui/admin/userinfo.jsp')"><span class="admin-icon"></span><%=Util.getI18NMsg(request, "IAM.ADMIN")%></a></li>
								<%if(isIAMAdmin || isIAMSupportAdmin){ %>
								<li><a href="<%=cPath%>/supportadmin"><span class="mnavi-icon mnavi-admin-icon"></span>Support Admin</a></li><%-- NO OUTPUTENCODING --%><!-- No I18N -->
								<%} %>
							</ul>
  						</div>
					</div>
				</div>
				<div id="panel_and_pagediv">
					<div>
						<div class="curvcontiner" id="submenupanel">
							<div id="adminsubmenu"><%-- admin sub menus  --%>
							
							
                    <%
                    	if(isIAMAdmin || isIAMUser || isIAMOperator || isSupportAdmin || isIAMServiceAdmin || isLegalAdmin || isIAMSupportAdmin) {
                    %>
								<div class="spantitle" id="userinfo_panel">
			    					<div class="menutitle" onclick="loadPage('userinfo_panel','/ui/admin/userinfo.jsp')">
										<a href="javascript:;">User Info</a><%--No I18N--%>
			    					</div>
								</div>
								<%
                    	}	if(isIAMAdmin || isIAMUser || isSupportAdmin || isIAMOperator || isIAMSupportAdmin) {
                    %>
								<div class="spantitle" id="usermailinfo_panel">
			    					<div class="menutitle" onclick="loadPage('usermailinfo_panel','/ui/admin/usermailinfo.jsp')">
										<a href="javascript:;">User Mail Info</a><%--No I18N--%>
			    					</div>
								</div>

		    <%
		    	} if(isIAMAdmin || (Util.isDevelopmentSetup() && isIAMServiceAdmin)) {
		    %>
								<div class="spantitle" id="role_panel">
			    					<div class="menutitle" onclick="loadPage('role_panel','/ui/admin/addrole.jsp');showSupportedList()">
										<a href="javascript:;">Add Role</a><%--No I18N--%>
			    					</div>
								</div>
					<%
						} if(isIAMAdmin || isIAMServiceAdmin) {
					%>
								<div class="spantitle" id="account_panel">
			    					<div class="menutitle" onclick="loadPageviaPOST('account_panel','/ui/admin/addaccount.jsp');<%if(isIAMAdmin) {%>showSupportedList();<%}%>">
										<a href="javascript:;">Assign Role</a><%--No I18N--%>
			    					</div>
								</div>
					<%
						} if(isIAMAdmin || isIAMCacheAdmin) {
					%>
								<div class="spantitle" id="agentcachereport_panel">
			    					<div class="menutitle" onclick="loadPage('agentcachereport_panel','/ui/admin/agentcachereport.jsp');"> <%-- NO OUTPUTENCODING --%>
										<a href="javascript:;">Agent Cache Report</a><%--No I18N--%>
			    					</div>
								</div>
				   <%
						} if(isIAMAdmin || isOAuthAdmin) {
					%>
								<div class="spantitle" id="auth2oauth_configuration"> 
									<div class="menutitle" onclick="loadPage('auth2oauth_configuration','/ui/admin/auth2oauthconfiguration.jsp')">
										<a href="javascript:;">AuthtoOAuth Configuration</a><%--No I18N--%>
			   						</div>
								</div>		
					<%
						} if(isIAMAdmin || isIAMSupportAdmin) {
					%>
								<div class="spantitle" id="close_panel">
			    					<div class="menutitle" onclick="loadPage('close_panel','/ui/admin/closeaccount.jsp')">
										<a href="javascript:;">Close Account</a><%--No I18N--%>
			    					</div>
								</div>
							</div>
					<%
						} if(isIAMAdmin || isOAuthAdmin || (Util.isDevelopmentSetup() && isIAMServiceAdmin) ) {
					%>
								<div class="spantitle" id="clientid_creation"> 
									<div class="menutitle" onclick="loadPage('clientid_creation','/ui/admin/clientidcreation.jsp')">
										<a href="javascript:;">Client ID creation</a><%--No I18N--%>
			   						</div>
								</div>
					<%
						}if(isIAMAdmin || isSDAdmin ||  isClearCacheOperator) {
					%>
								<div class="spantitle" id="clearcache_panel">
									<div class="menutitle" onclick="loadPage('clearcache_panel','/ui/admin/clearcacheinvoker.jsp');showSupportedList();">
										<a href="javascript:;">Clear Cache</a><%--No I18N--%>
									</div>
								</div>
					<%
                    	} if(isIAMAdmin) {
                    %>
								<div class="spantitle" id="clientuseremailconfirm_panel">
			    					<div class="menutitle" onclick="loadPage('clientuseremailconfirm_panel','/ui/admin/clientuseremailconfirm.jsp');"> <%-- NO OUTPUTENCODING --%>
										<a href="javascript:;">Client User Email Confirmation</a><%--No I18N--%>
			    					</div>
								</div>
					<%
                    	} if(isIAMAdmin  || isIAMCacheAdmin) {
                    %>
								<div class="spantitle" id="clusteradmin">
									<div class="menutitle" onclick="loadPage('clusteradmin','/ui/admin/cluster/clusteradmin.jsp?op=view')">
										<a href="javascript:;">Cluster Config</a><%--No I18N--%>
			   						</div>
								</div>
					<%
						} if(isIAMAdmin || isSupportAdmin || isIAMSupportAdmin || (isIAMServiceAdmin && Util.isDevelopmentSetup())) {
					%>
								<div class="spantitle" id="confirm_panel">
			    					<div class="menutitle" onclick="loadPage('confirm_panel','/ui/admin/confirmemail.jsp')">
										<a href="javascript:;">Confirm Email</a><%--No I18N--%>
			    					</div>
								</div>
                    <%
                    	} if(isIAMAdmin || isIAMOperator || isSupportAdmin || isIAMSupportAdmin) {
                    %>
								<div class="spantitle" id="deactivate_panel">
			    					<div class="menutitle" onclick="loadPage('deactivate_panel','/ui/admin/deactivateaccount.jsp');showSupportedList()">
										<a href="javascript:;">Deactivate Account</a><%--No I18N--%>
			    					</div>
								</div>
                    <%
                    	} if(isIAMAdmin || isIAMSystemAdmin){
                    %>
                    			<div class="spantitle" id="dclocation_panel">
			    					<div class="menutitle" onclick="loadPage('dclocation_panel','/ui/admin/dclocation/dclocations.jsp');"> <%-- NO OUTPUTENCODING --%>
										<a href="javascript:;">DC Location</a><%--No I18N--%>
			    					</div>
								</div>
					<%
                    	} if(isIAMAdmin || isIAMSupportAdmin ){
                    %>										
								<div class="spantitle"id="dissociate_org">
								    <div class="menutitle"onclick="loadPage('dissociate_org','/ui/admin/dissociate_org.jsp')">
										<a href="javascript:;">Delete Org </a><%--No I18N--%>
								    </div>
								</div>
								<div class="spantitle" id="digest_info">
			    					<div class="menutitle" onclick="loadPage('digest_info','/ui/admin/digestinfo.jsp')">
										<a href="javascript:;">Digest Info</a><%--No I18N--%>
			    					</div>
								</div>
					<%
                    	} if(isIAMAdmin  || isDomainAdmin || isIAMSupportAdmin){
                    %>
								<div class="spantitle" id="domain_verify">
									<div class="menutitle" onclick="loadPage('domain_verify','/ui/admin/domainVerification.jsp?is_ajax=true')"> <%-- NO OUTPUTENCODING --%>
										<a href="javascript:;">Domain Verification</a> <%--No I18N--%>
									</div>
								</div>
					<%
                    	} if(isIAMAdmin){
                    %>
                        		<div class="spantitle" id="enterprise_panel">
			    					<div class="menutitle" onclick="loadPage('enterprise_panel','/ui/admin/enterprise.jsp?action=list')">
										<a href="javascript:;">Enterprises</a><%--No I18N--%>
			    					</div>
								</div>
					<%
                    	} if(isIAMAdmin || isIAMTemplateAdmin){
                    %>
								<div class="spantitle" id="i18n_panel">
			    					<div class="menutitle" onclick="loadPage('i18n_panel','/ui/admin/i18n.jsp'); initSelect2()">
										<a href="javascript:;">I18N</a><%--No I18N--%>
			    					</div>
								</div>
					<%
                    	} if(isIAMAdmin){
                    %>
								<div class="spantitle" id="import_panel">
			    					<div class="menutitle" onclick="loadPage('import_panel','/ui/admin/importuser.jsp')">
										<a href="javascript:;">Import User</a><%--No I18N--%> 
			    					</div>
								</div>
					<%
                    	} if(isIAMAdmin || isOAuthAdmin){
                    %>
								<div class="spantitle" id="isc_panel">
			    					<div class="menutitle" onclick="loadPage('isc_panel','/ui/admin/iscscope.jsp?t=view')">
										<a href="javascript:;">ISCScope</a><%--No I18N--%>
			    					</div>
								</div>
					<%
                    	} if(isIAMAdmin || isIAMSystemAdmin){
                    %>
								<div class="spantitle" id="listener_panel">
			    					<div class="menutitle" onclick="loadPage('listener_panel','/ui/admin/listener.jsp?t=view')">
										<a href="javascript:;">Listener</a><%--No I18N--%>
			    					</div>
								</div>
			       <%
                    	} if(isIAMAdmin || isLegalAdmin || isIAMSupportAdmin){
                    %>
								<div class="spantitle" id="loginhistory_panel">
			    					<div class="menutitle" onclick="loadPage('loginhistory_panel','/ui/admin/signin-history.jsp?mode=view')">
										<a href="javascript:;">Login History</a><%--No I18N--%>
			    					</div>
								</div>
                    <%
                    	} if(isIAMAdmin || isIAMSupportAdmin){
                    %>
								<div class="spantitle" id="enableanddisabletfa">
			 						<div class="menutitle" onclick="loadPage('enableanddisabletfa','/ui/admin/enableanddisabletfa.jsp')">
										<a href="javascript:;">Manage TFA</a><%--No I18N--%>
			    					</div>
								</div>
					<%
                    	} if(isIAMAdmin || isIAMCacheAdmin){
                    %>
								<div class="spantitle" id="memcache_panel">
			    					<div class="menutitle" onclick="loadPage('memcache_panel','/ui/admin/viewcache.jsp'); initSelect2()">
										<a href="javascript:;">Memcache</a><%--No I18N--%>
			    					</div>
								</div>
					<%
                    	} if(isIAMAdmin || isIAMSupportAdmin){
                    %>
								<div class="spantitle" id="merge_org">
			    					<div class="menutitle" onclick="loadPage('merge_org','/ui/admin/merge_orgs.jsp')">
										<a href="javascript:;">Merge Org</a><%--No I18N--%>
			    					</div>
								</div>
					<%
						}if(isOAuthAdmin || isIAMAdmin || (Util.isDevelopmentSetup() && isIAMServiceAdmin)) {
					%>
								<div class="spantitle" id="mobile_registration">
			    					<div class="menutitle" onclick="loadPage('mobile_registration','/ui/admin/mobileregistration.jsp?t=view'); initSelect2()">
										<a href="javascript:;">Mobile App Registration</a><%--No I18N--%>
			    					</div>
								</div>
			       <%
                    	} if(isIAMAdmin || isMarketingAdmin){
                    %>
								<div class="spantitle" id="newsletter_panel">
			    					<div class="menutitle" onclick="loadPage('newsletter_panel','/ui/admin/newsletter.jsp?mode=view')">
										<a href="javascript:;">Newsletter</a><%--No I18N--%>
			    					</div>
								</div>
								<div class="spantitle" id="partner_panel">
			    					<div class="menutitle" onclick="loadPage('partner_panel','/ui/admin/partners.jsp?t=view')">
										<a href="javascript:;">Partners</a><%--No I18N--%>
			    					</div>
								</div>
					<%
						} if(isIAMAdmin || isOAuthAdmin || (Util.isDevelopmentSetup() && isIAMServiceAdmin)) {
					%>
								<div class="spantitle" id="oauth_configuration"> 
									<div class="menutitle" onclick="loadPage('oauth_configuration','/ui/admin/oauthconfiguration.jsp')">
										<a href="javascript:;">OAuth Configuration</a><%--No I18N--%>
			   						</div>
								</div>								
                    <%
                    	} if(isIAMAdmin || isOAuthAdmin || (isIAMServiceAdmin)){
                    %>
                    			<div class="spantitle" id="oauth_scope">
			    					<div class="menutitle" onclick="loadPage('oauth_scope','/ui/admin/oauthScope.jsp?t=view'); initSelect2();">
										<a href="javascript:;">OAuthScope</a><%--No I18N--%>
			    					</div>
								</div>
					<%
                    	} if(isIAMAdmin){
                    %>
                    			<div class="spantitle" id="partnersignup_panel">
			    					<div class="menutitle" onclick="loadPage('partnersignup_panel','/ui/admin/partner_signup.jsp?t=view')">
										<a href="javascript:;">Partner Account</a><%--No I18N--%>
			    					</div>
								</div>
								<div class="spantitle" id="reserve_panel">
			    					<div class="menutitle" onclick="loadPage('reserve_panel','/ui/admin/reserve.jsp')">
										<a href="javascript:;">Reserve</a><%--No I18N--%>
			    					</div>
								</div>
								
					<%
						} if(isIAMAdmin || isSupportAdmin || isIAMSupportAdmin) {
					%>
								<div class="spantitle" id="clrips_panel">
			    					<div class="menutitle" onclick="loadPage('clrips_panel','/ui/admin/reset_ips.jsp')">
										<a href="javascript:;">Reset IPs</a><%--No I18N--%>
			    					</div>
								</div>
					<%
						} if(isIAMAdmin || isSupportAdmin || isIAMSupportAdmin || (isIAMServiceAdmin && Util.isDevelopmentSetup())) {
					%>
								<div class="spantitle" id="password_panel">
			    					<div class="menutitle" onclick="loadPage('password_panel','/ui/admin/reset_password.jsp')">
										<a href="javascript:;">Reset Password</a><%--No I18N--%>
			    					</div>
								</div>
		    		<%
                    	} if(isIAMAdmin || isIAMSupportAdmin) {
				    %>
								<div class="spantitle" id="restore_panel">
			    					<div class="menutitle" onclick="loadPage('restore_panel','/ui/admin/restore_account.jsp')">
										<a href="javascript:;">Restore Account</a><%--No I18N--%>
			    					</div>
								</div>
					<%
                    	} if(isIAMAdmin){
                    %>						
								<!--  REST Client operations -->
								<div class="spantitle" id="rest_panel">
									<div class="menutitle" onclick="loadPage('rest_panel','/ui/admin/rest.jsp'); initSelect2();"> <%-- NO OUTPUTENCODING --%>
										<a href="javascript:;">REST Operations</a><%--No I18N--%>
									</div>
								</div>
					<%
                    	} if(isIAMAdmin || isOAuthAdmin){
                    %>						
								<div class="spantitle" id="restricted_scope_panel">
									<div class="menutitle" onclick="loadPage('restricted_scope_panel','/ui/admin/restrictedScope.jsp')"> <%-- NO OUTPUTENCODING --%>
										<a href="javascript:;">Restricted Scope Addition</a><%--No I18N--%>
									</div>
								</div>
					<%
						} if(isIAMAdmin || isIAMServiceAdmin) {
					%>
								<div class="spantitle" id="roleinfo_panel">
			    					<div class="menutitle" onclick="loadPageviaPOST('roleinfo_panel','/ui/admin/roleinfo.jsp');
			    					<%if(isIAMAdmin) {%>showSupportedList();<%}%>">
										<a href="javascript:;">Role Info</a><%--No I18N--%>
			    					</div>
								</div>
		    		<%
                    	} if(isIAMAdmin || isIAMSystemAdmin) {
				    %>
				    			<div class="spantitle" id="scheduler">
			    					<div class="menutitle" onclick="loadPage('scheduler','/ui/admin/scheduler.jsp?t=view');sortDropDownListByText();">
										<a href="javascript:;">Scheduler</a><%--No I18N--%>
			    					</div>
								</div>
					<%
						} if(isIAMAdmin || isIAMTemplateAdmin || (isIAMServiceAdmin && Util.isDevelopmentSetup())) {
					%>
								<div class="spantitle" id="screen_panel">
			    					<div class="menutitle" onclick="loadPage('screen_panel','/ui/admin/screen.jsp?t=view'); initSelect2();">
										<a href="javascript:;">Screen</a><%--No I18N--%>
			    					</div>
								</div>
					<%
						} if(isIAMAdmin || isIAMSystemAdmin) {
					%>
								<div class="spantitle" id="secret_panel">
			    					<div class="menutitle" onclick="loadPage('secret_panel','/ui/admin/secret_keys.jsp?t=view')">
										<a href="javascript:;">Secret Keys</a><%--No I18N--%>
			    					</div>
								</div>
								
								<%
						} if(isIAMAdmin || isSDAdmin) {
					%>
								<div class="spantitle" id="sec_private_key">
			    					<div class="menutitle" onclick="loadPage('sec_private_key','/ui/admin/secPrivateKey.jsp?action=view'); initSelect2();">
										<a href="javascript:;">Security Private Key</a><%--No I18N--%>
			    					</div>
								</div>
					<%
                    	} if(isIAMAdmin || isIAMSystemAdmin){
                    %>
								
								<div class="spantitle" id="service_panel">
									<div class="menutitle" onclick="loadPage('service_panel','/ui/admin/service.jsp?t=view')">
										<a href="javascript:;">Services</a><%--No I18N--%>
									</div>
								</div>
								
								<div class="spantitle" id="service_org_det_panel">
									<div class="menutitle" onclick="loadPage('service_org_det_panel','/ui/admin/service_org_details.jsp?t=view')">
										<a href="javascript:;">Services Org Details</a><%--No I18N--%>
									</div>
								</div>
					<%
						} if(isIAMAdmin || isIAMCacheAdmin) {
					%>
								<div class="spantitle" id="redismessage">
									<div class="menutitle" onclick="loadPage('redismessage','/ui/admin/redismessage.jsp')">
										<a href="javascript:;">Send Redis Message</a><%--No I18N--%>
			   						</div>
								</div>
								
								<div class="spantitle" id="streamsetting">
									<div class="menutitle" onclick="loadPage('streamsetting','/ui/admin/streamsetting.jsp')">
										<a href="javascript:;">Redis Stream Settings</a><%--No I18N--%>
			   						</div>
								</div>
								
					
                    <%
                    	} if(isIAMAdmin || isIAMOperator ||isIAMSystemAdmin){
                    %>
								<div class="spantitle" id="property_panel">
			    					<div class="menutitle" onclick="loadPage('property_panel','/ui/admin/systemconfig.jsp'); initSelect2();">
										<a href="javascript:;">System Configuration</a><%--No I18N--%>
			    					</div>
								</div>
		    		<%
                    	} if(isIAMAdmin || isIAMSupportAdmin){
                    %>
								<div class="spantitle" id="support_panel">
			    					<div class="menutitle" onclick="loadPage('support_panel','/ui/admin/passwordsupport.jsp'); initSelect2();">
										<a href="javascript:;">User Service Info</a><%--No I18N--%>
			    					</div>
								</div>
		    		<%
				    	}  if(isIAMAdmin){
                    %>
                    
                    			<div class="spantitle" id="transmail_panel">
			            			<div class="menutitle" onclick="loadPage('transmail_panel','/ui/admin/transMail.jsp?t=view')">
				        				<a href="javascript:;">TransMail Management</a><%--No I18N--%>
			            			</div>
			            		</div>
			        <%
						} if(isIAMAdmin || isTestAccountsAdmin) {
					%>
                        		<div class="spantitle" id="testaccounts_panel">
			            			<div class="menutitle" onclick="loadPage('testaccounts_panel','/ui/admin/testaccounts.jsp')">
				        				<a href="javascript:;">Zoho Test Accounts</a><%--No I18N--%>
			            			</div>
			            		</div>
			       <%
						} if(isIAMAdmin || isOAuthAdmin || (Util.isDevelopmentSetup() && isIAMServiceAdmin)) {
					%>
                        		<div class="spantitle menulast" id="ticketmanagement_panel">
			            			<div class="menutitle" onclick="loadPage('ticketmanagement_panel','/ui/admin/ticketmanagement.jsp')">
				        				<a href="javascript:;">Ticket Management</a><%--No I18N--%>
			            			</div>
			            		</div>
			        <%
                        }  
                    %>
		    				</div>
						</div>
					
						<div id="zcontiner" style="display:none;overflow:auto;"></div>

						<div id="home_continer" style="display:none;"> </div>
					</div>
				</div>
			</div>
		</div>
		
		<div id="opacity" style="display:none;"></div>
		<div id="verifyapassword" style="display:none;">
    		<div><b class="mrptop outbg"><b class="mrp1"></b><b class="mrp2"></b><b class="mrp3"></b><b class="mrp4"></b></b></div>
    		<div class="mrpheader">
				<span class="close" onclick="hideverificationform()"></span>
				<span>Admin Verification</span><%--No I18N--%>
    		</div>
    		<div class="mprcontent">
				<div><b class="mrptop inbg"><b class="mrp2"></b><b class="mrp3"></b><b class="mrp4"></b></b></div>
				<div class="mrpcontentdiv">
	    			<table cellspacing="5" cellpadding="0" border="0" width="100%">
						<tr><td align="right">Admin password :</td><%--No I18N--%>
						<td><input type="password" id="verifypwd" class="input"></td></tr>
	    			</table>
	    			<div class="mrpBtn">
						<input type="button" value="Verify" id="continuebtn"/>
						<input type="button" value="Cancel" onclick="hideverificationform()"/>
	    			</div>
				</div>
				<div><b class="mrpbot inbg"><b class="mrp4"></b><b class="mrp3"></b><b class="mrp2"></b></b></div>
    		</div>
    		<div><b class="mrpbot outbg"><b class="mrp4"></b><b class="mrp3"></b><b class="mrp2"></b><b class="mrp1"></b></b></div>
		</div>

		<div id="admin_newsl_div" style="display:none;position:absolute;z-index:1200;top:20%;left:24%;width:675px;margin:0px auto;">
    		<div><b class="mrptop outbg"><b class="mrp1"></b><b class="mrp2"></b><b class="mrp3"></b><b class="mrp4"></b></b></div>
    		<div class="mrpheader">
				<span class="close" onclick="closeNewsletterResult()"></span>
				<span id="newsl_admin_title"></span>
    		</div>
    		<div class="mprcontent">
				<div><b class="mrptop inbg"><b class="mrp2"></b><b class="mrp3"></b><b class="mrp4"></b></b></div>
				<div class="mrpcontentdiv" id="newsl_admin_main"></div>
				<div><b class="mrpbot inbg"><b class="mrp4"></b><b class="mrp3"></b><b class="mrp2"></b></b></div>
    		</div>
    		<div><b class="mrpbot outbg"><b class="mrp4"></b><b class="mrp3"></b><b class="mrp2"></b><b class="mrp1"></b></b></div>
		</div>
		
		<div class="confirmpop">
	    	<div class="confirmheader">
	    		<span class="fllt mtop" id="promptheader"></span>
				<span class="popupclose" onclick="$('#opacity').hide();$('.confirmpop').hide();"></span>
				<span style="display: inline-block;">&nbsp;</span>
	    	</div>
	    	<div class="border-dotted">&nbsp;</div>
	    	<span class="pcontentconfirm"></span>
    		<div class="confirmbutton">
	    		<button onclick="callInternalinvokeIps(this.value)" style="padding: 3px 9px 19px 9px;height:20px;width:65px" id="confirmboxipsvalue" class="bluebutton" value='<%=AccountsConfiguration.getConfigurationValue("iam.app.ips")%>'>Clear</button><%-- NO OUTPUTENCODING --%><%--No I18N--%>
	    		<button onclick="" style="display:none" class="bluebutton" style="padding: 3px 9px 19px 9px;height:20px;width:65px">Clear</button><%--No I18N--%>
	    		<button onclick="$('#opacity').hide();$('.confirmpop').hide()" class="bluebutton" style="padding: 3px 9px 19px 9px;height:20px;width:65px"><%=Util.getI18NMsg(request, "IAM.CANCEL")%></button>
    		</div>
		</div>
		<div id="portfolio-wrap"></div>
    </body>
</html>

<script>
    window.onload=function() {
		try {
			WmsLite.setNoDomainChange();
			WmsLite.setConfig(64);//64 is value of WMSSessionConfig.CROSS_PRD
	    	WmsLite.registerZuid('AC',"<%=zuId%>","<%=IAMEncoder.encodeJavaScript(user.getLoginName())%>", true);
		}catch(e){}    
		setWindowSize();
		loadHash();
    }
    window.onresize=function() {
    	setWindowSize();
    }
    window.setInterval("watchHash()", 1000);
</script>
