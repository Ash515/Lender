<%-- $Id$ --%>
<%@page import="com.adventnet.iam.User"%>
<%@page import="com.adventnet.iam.IAMUtil"%>
<%@page import="com.adventnet.iam.CryptoUtil"%>
<%@page import="com.adventnet.iam.Role"%>
<%@page import="com.adventnet.iam.internal.Util"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ include file="../../static/includes.jspf" %>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=Util.getI18NMsg(request,"IAM.ZOHO.ACCOUNTS")%></title>

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
    boolean isOAuthAdmin = request.isUserInRole("OAuthAdmin");
    boolean isDomainAdmin = request.isUserInRole("IAMDomainAdmin");
    boolean isIAMSupportAdmin = request.isUserInRole("IAMSupportAdmin");
	boolean isIAMCacheAdmin = request.isUserInRole("IAMCacheAdmin");
	boolean isClearCacheOperator = request.isUserInRole("IAMCacheAdmin");
	boolean isIAMTemplateAdmin = request.isUserInRole("IAMTemplateAdmin");
	
	String userid = CryptoUtil.encryptWithSalt("photo", zuId+"", ":", IAMUtil.getCurrentTicket(), true); //No I18N
	String iamHelpLink = "";
%>

    <script src="<%=jsurl%>/jquery-1.12.2.min.js" type="text/javascript"></script> <%-- NO OUTPUTENCODING --%>
    <script src="<%=wmsjsurl%>/wmsliteapi.js" type="text/javascript"></script> <%-- NO OUTPUTENCODING --%>
    <script src="<%=jsurl%>/chosen.jquery.js" type="text/javascript"></script> <%-- NO OUTPUTENCODING --%>
    <link href="<%=cssurl%>/chosen.css" type="text/css" type="text/css" rel="stylesheet" /> <%-- NO OUTPUTENCODING --%>
    
    <link href="<%=cssurl%>/select2.min.css" rel="stylesheet" />	<%-- NO OUTPUTENCODING --%>
	<script src="<%=jsurl%>/select2.min.js"></script>	<%-- NO OUTPUTENCODING --%>

	<link href="<%=cssurl_st%>/ui.ztooltip.css" type="text/css" rel="stylesheet"  /><%-- NO OUTPUTENCODING --%>

    <script src="<%=jsurl%>/jquery.ztooltip.js" type="text/javascript"></script> <%-- NO OUTPUTENCODING --%>
	<script src="<%=jsurl%>/xregexp-all.js" type="text/javascript"></script> <%-- NO OUTPUTENCODING --%>
	
    <script src="<%=jsurl%>/common.js" type="text/javascript"></script> <%-- NO OUTPUTENCODING --%>
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
		var mainmenu = 'supportadmin';//No I18N
		var submenu = 'appaccount_panel';//No I18N
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
								<%	if(isIAMAdmin || isIAMUser || isIAMOperator || isSupportAdmin || isIAMServiceAdmin || isLegalAdmin || isOAuthAdmin || isDomainAdmin || isIAMSupportAdmin || isIAMCacheAdmin || isClearCacheOperator || isIAMTemplateAdmin) {
                    			%>
    							<li><a href="<%=cPath%>/admin"><span class="mnavi-icon mnavi-admin-icon"></span><%=Util.getI18NMsg(request, "IAM.ADMIN")%></a></li><%-- NO OUTPUTENCODING --%>
    							<%}%>
								<li><a id="supportadmin" class="active" onclick="loadTab('supportadmin','appaccount_panel','/ui/support/appaccountops.jsp'); initSelect2()"><span class="admin-icon"></span>Support Admin</a></li><!-- No I18N -->
							</ul>
  						</div>
					</div>
				</div>
				
				
				<div id="panel_and_pagediv">
					<div>
						<div class="curvcontiner" id="submenupanel">
							<div id="adminsubmenu"><%-- admin sub menus  --%>

				
								<div class="spantitle" id="appaccount_panel">
			    					<div class="menutitle" onclick="loadPage('appaccount_panel','/ui/support/appaccountops.jsp'); initSelect2()">
										<a href="javascript:;">AppAccount Operations</a><%--No I18N--%>
			    					</div>
								</div>
								
								
								<div class="spantitle" id="appaccountowner_panel">
			    					<div class="menutitle" onclick="loadPage('appaccountowner_panel','/ui/support/appaccountowner.jsp'); initSelect2()">
										<a href="javascript:;">Change AppAccount Owner</a><%--No I18N--%>
			    					</div>
								</div>
								
								
								<div class="spantitle" id="defaultzsoid_panel">
			    					<div class="menutitle" onclick="loadPage('defaultzsoid_panel','/ui/support/defaultzsoid.jsp')">
										<a href="javascript:;">Change Default ZSOID</a><%--No I18N--%>
			    					</div>
								</div>
								
								
								<div class="spantitle" id="orgcontact_panel">
			    					<div class="menutitle" onclick="loadPage('orgcontact_panel','/ui/support/orgcontact.jsp')">
										<a href="javascript:;">Change Org Contact</a><%--No I18N--%>
			    					</div>
								</div>
								
								<div class="spantitle" id="invitation_panel">
			    					<div class="menutitle" onclick="loadPage('invitation_panel','/ui/support/inviteRestrictionClear.jsp')">
										<a href="javascript:;">Clear Invite Restriction</a><%--No I18N--%>
			    					</div>
								</div>
								
								
								<div class="spantitle" id="domain_panel">
			    					<div class="menutitle" onclick="loadPage('domain_panel','/ui/support/domain.jsp')">
										<a href="javascript:;">Delete Domain</a><%--No I18N--%>
			    					</div>
								</div>
								

								<div class="spantitle" id="externalusers_panel">
			    					<div class="menutitle" onclick="loadPage('externalusers_panel','/ui/support/externalusers.jsp')">
										<a href="javascript:;">Delete External Users</a><%--No I18N--%>
			    					</div>
								</div>
								
								
								<div class="spantitle" id="group_panel">
			    					<div class="menutitle" onclick="loadPage('group_panel','/ui/support/deletegroup.jsp')">
										<a href="javascript:;">Delete Group/Members</a><%--No I18N--%>
			    					</div>
								</div>
								
								
								<div class="spantitle" id="pendinguser_panel">
			    					<div class="menutitle" onclick="loadPage('pendinguser_panel','/ui/support/pendinguser.jsp')">
										<a href="javascript:;">Delete Pending User</a><%--No I18N--%>
			    					</div>
								</div>
								
								
								<div class="spantitle" id="digest_panel">
			    					<div class="menutitle" onclick="loadPage('digest_panel','/ui/support/digest.jsp')">
										<a href="javascript:;">Email Digest</a><%--No I18N--%>
			    					</div>
								</div>

								
								<div class="spantitle" id="emailops_panel">
			    					<div class="menutitle" onclick="loadPage('emailops_panel','/ui/support/emailops.jsp')">
										<a href="javascript:;">Email Operations</a><%--No I18N--%>
			    					</div>
								</div>
								
								
								<div class="spantitle" id="securityqa_panel">
			    					<div class="menutitle" onclick="loadPage('securityqa_panel','/ui/support/securityqa.jsp')">
										<a href="javascript:;">Security Questions</a><%--No I18N--%>
			    					</div>
								</div>


								<div class="spantitle" id="serviceorg_panel">
			    					<div class="menutitle" onclick="loadPage('serviceorg_panel','/ui/support/serviceorgops.jsp'); initSelect2()">
										<a href="javascript:;">ServiceOrg Operations</a><%--No I18N--%>
			    					</div>
								</div>


								<div class="spantitle" id="orgpolicy_panel">
			    					<div class="menutitle" onclick="loadPage('orgpolicy_panel','/ui/support/orgpolicy.jsp'); initSelect2()">
										<a href="javascript:;">Update Org policy</a><%--No I18N--%>
			    					</div>
								</div>
								
								
								<div class="spantitle" id="orgrole_panel">
			    					<div class="menutitle" onclick="loadPage('orgrole_panel','/ui/support/orgrole.jsp')">
										<a href="javascript:;">Change User Role</a><%--No I18N--%>
			    					</div>
								</div>
								
								
								<div class="spantitle" id="screenname_panel">
			    					<div class="menutitle" onclick="loadPage('screenname_panel','/ui/support/screenname.jsp')">
										<a href="javascript:;">User Mobile and Screen Name</a><%--No I18N--%>
			    					</div>
								</div>

								
								<div class="spantitle" id="userdevice_panel">
			    					<div class="menutitle" onclick="loadPage('userdevice_panel','/ui/support/userdevice.jsp')">
										<a href="javascript:;">User Device</a><%--No I18N--%>
			    					</div>
								</div>
								
							</div>
						</div>
					</div>	
					
					<div id="zcontiner" style="display:none;overflow:auto;"></div>
					<div id="home_continer" style="display:none;"> </div>
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
</html>