<%-- $Id: $ --%>
<%@page import="com.zoho.accounts.OAuthResourceProto.OAuthAppGroup.OAuthClient.OAuthJavaScriptDomains"%>
<%@page import="com.zoho.accounts.internal.util.AccountsInternalConst"%>
<%@page import="com.zoho.resource.ResourceException"%>
<%@page import="com.zoho.accounts.internal.OAuthException.OAuthErrorCode"%>
<%@page import="com.zoho.accounts.internal.util.AccountsInternalConst.OAuthConstants.OAuthClientType"%>
<%@page import="com.zoho.accounts.internal.OAuthException"%>
<%@page import="com.zoho.accounts.OAuthResourceProto.OAuthAppGroup.OAuthClient.OAuthDcDetails"%>
<%@page import="com.zoho.accounts.AccountsUtil"%>
<%@page import="com.zoho.accounts.OAuthResourceProto.OAuthAppGroup.OAuthClient.OAuthRedirectURL"%>
<%@page import="com.zoho.accounts.OAuthResource.RESOURCE.OAUTHCLIENT"%>
<%@page import="com.zoho.resource.Criteria"%>
<%@page import="com.zoho.accounts.OAuthResource"%>
<%@page import="com.adventnet.iam.xss.IAMEncoder"%>
<%@page import="com.adventnet.iam.UserPreference"%>
<%@page import="com.adventnet.iam.internal.Util"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.util.TimeZone"%>
<%@page import="java.util.Locale"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.logging.Level"%>
<%@page import="java.util.logging.Logger"%>
<%@page import="org.json.JSONObject"%>
<%@page import="com.zoho.accounts.internal.util.AccountsInternalConst.OAuthConstants.OAuthInternalScope"%>
<%@page import="com.zoho.accounts.internal.OAuthParams"%>
<%@page import="com.zoho.accounts.internal.util.AccountsInternalConst.OAuthConstants.OAuthRedirectType"%>
<%@page import="com.zoho.accounts.internal.oauth2.OAuth2Util.OAuthAppGroup"%>
<%@page import="com.adventnet.iam.IAMException"%>
<%@page import="com.adventnet.iam.User"%>
<%@page import="com.adventnet.iam.IAMUtil"%>
<%@page import="com.zoho.accounts.OAuthResourceProto.OAuthAppGroup.OAuthClient"%>
<%@page import="java.util.List"%>
<%@page import="com.zoho.accounts.internal.oauth2.OAuth2Util"%>
<%!
Logger LOGGER = Logger.getLogger("developerconsole_jsp"); //No I18N
public OAuthClient checkAndGetCurrentUserClient(String clientZid) throws OAuthException{
	com.adventnet.iam.User user = IAMUtil.getCurrentUser();
	if(user == null ){
		throw new OAuthException(OAuthErrorCode.invalid_user);
	}
	OAuthClient client = null;
	try {
		client = com.adventnet.iam.internal.Util.oAuthInternalAPI.getOAuthClient(OAuth2Util.getOAuthGroupForClientID(clientZid), clientZid, true);
	} catch (IAMException e) {
		throw new OAuthException(OAuthErrorCode.invalid_client);
	}
	if(client == null){
		throw new OAuthException(OAuthErrorCode.invalid_client);
	}
	if(Long.parseLong(client.getCreatedBy()) == user.getZUID() && (AccountsInternalConst.OAuthConstants.OAuthClientType.isExternalClinetType(client.getClientType()))){
		return client;
	}
	LOGGER.log(Level.WARNING, "Hacking Attempt");
	return null;
}
%>
<%
User user = IAMUtil.getCurrentUser();
if("addclient".equals(request.getParameter("action"))) {
	try {
		String clientId = request.getParameter("client_id");
		String clientName = request.getParameter("client_name");
		String domain = request.getParameter("client_domain");
		String redirectURL = request.getParameter("client_redirect_uri");		
		String oldRedirectURL = request.getParameter("old_client_redirect_uri");
		String[] jsDomain = request.getParameterValues("client_js_domain");
		String appGroupId = OAuthAppGroup.OAUTH_SPACE.getOAuthAppGroupID();
		String clientType = request.getParameter("clientType");
		int clientTypeInt = OAuthClientType.EXTERNA_USER.getType(); 
		if(clientType != null && "JS".equals(clientType)) {
			clientTypeInt = OAuthClientType.EXTERNAL_CLIENTOAUTH.getType();
		} else if(clientType != null && "Mobile".equals(clientType)) {  //No I18N
			clientTypeInt = OAuthClientType.EXTERNA_MOBILE.getType();
		}
		String clientSecret = null;
		if(Util.isValid(clientId)) {
			OAuthClient client = com.adventnet.iam.internal.Util.oAuthInternalAPI.getOAuthClient(appGroupId, clientId, false);
			if(client.getClientType() == OAuthClientType.EXTERNAL_INTERNAL_PURPOSE_CLIENT.getType()){
				return;
			}
			if(client != null && Long.parseLong(client.getCreatedBy()) == user.getZUID() && (AccountsInternalConst.OAuthConstants.OAuthClientType.isExternalClinetType(client.getClientType()))){
				OAuthClient.Builder oauth = OAuthClient.newBuilder().setClientDomain(domain).setClientName(clientName);
				OAuthResource.getOAuthClientURI(appGroupId, clientId).PUT(oauth.build());
				if(Util.isValid(oldRedirectURL) && Util.isValid(redirectURL) && !oldRedirectURL.equalsIgnoreCase(redirectURL)) {
					String oldRedirectURLApl = AccountsUtil.computeAutoPermaLink(oldRedirectURL);
					List<OAuthRedirectURL> uriObjs = client.getOAuthRedirectURLList();
					OAuthRedirectURL uriObj = null;
					for(OAuthRedirectURL uriObject:uriObjs){
						if(uriObject.getRedirectUrlApl().equalsIgnoreCase(oldRedirectURLApl)){
							uriObj = uriObject;
							break;
						}
					}
					if(uriObj != null) {
						OAuthResource.getOAuthRedirectURLURI(appGroupId, clientId, oldRedirectURLApl).PUT(OAuthRedirectURL.newBuilder().mergeFrom(uriObj).setRedirectUrl(redirectURL).build());
					}
				}
				if(Util.isValid(jsDomain) && client != null && client.getClientType() == AccountsInternalConst.OAuthConstants.OAuthClientType.EXTERNAL_CLIENTOAUTH.getType()){
					List<OAuthJavaScriptDomains> oauthJs = client.getOAuthJavaScriptDomainsList();
					List<String> exist = new ArrayList<String>();
					if(oauthJs != null) {
						for(OAuthJavaScriptDomains j : oauthJs) {
							exist.add(j.getDomain());
						}
					}
					for(String dom : jsDomain){
						if(!exist.contains(dom)) {
							OAuthResource.getOAuthJavaScriptDomainsURI(appGroupId, clientId, AccountsUtil.computeAutoPermaLink(dom)).POSTONPUT(OAuthJavaScriptDomains.newBuilder().setDomain(dom).build());	
						} else {
							exist.remove(dom);
						}
					}
					if(!exist.isEmpty()) {
						for(String dom : exist){
							OAuthResource.getOAuthJavaScriptDomainsURI(appGroupId, clientId, AccountsUtil.computeAutoPermaLink(dom)).DELETE();
						}
					}
				}
			} else { 
				%>
				<div align="center"><%=Util.getI18NMsg(request, "IAM.ERROR.GENERAL")%></div>
				<%
					return;
					}
						} else {
					OAuthParams oauthParam = new OAuthParams(request);
					oauthParam.setScopes(OAuthInternalScope.EMAIL.name().split(","));
					JSONObject json = OAuth2Util.createOAuthClient(appGroupId, String.valueOf(user.getZUID()), clientName, domain, redirectURL, OAuthRedirectType.SERVER, oauthParam, jsDomain, clientTypeInt, 0, request.getRemoteAddr(), request.getHeader("User-Agent"));
					clientId = json.getString("client_id");
					clientSecret = json.getString("client_secret");
						}
					out.println(IAMEncoder.encodeHTML("success_"+clientId+"_"+clientSecret)); //No I18N
					}catch(Exception ex) {
						LOGGER.log(Level.WARNING, null, ex);
						out.println("error"); //No I18N
					}
					return;
				} else if("deleteclient".equals(request.getParameter("action"))) { //No I18N
					try {
						String appGroupId = OAuthAppGroup.OAUTH_SPACE.getOAuthAppGroupID();
						String client_zid = request.getParameter("client_zid");
						OAuthClient oauthclient;
						try{
					oauthclient = checkAndGetCurrentUserClient(client_zid);
					if(oauthclient == null){
				%>
				<div align="center"><%=Util.getI18NMsg(request, "IAM.ERROR.GENERAL")%></div>
			<%
				return;
				}
					}catch(OAuthException e){
				out.println(IAMEncoder.encodeHTML(e.getErrorCode().toString()));
				return;
					}
					if(!Util.isValid(client_zid)) {
				out.println("invalid_client_id"); //No I18N
				return;
					}
					OAuth2Util.deleteOAuthClient(oauthclient.getClientId());
					out.println("success"); //No I18N
				}catch(Exception ex) {
					LOGGER.log(Level.WARNING, null, ex);
					out.println("error"); //No I18N
				}
				return;
			}else if("multidcsupportenable".equals(request.getParameter("action"))) { //No I18N
				try{
					out.println("success");//No I18N
				}catch(Exception ex) {
					LOGGER.log(Level.WARNING, null, ex);
					out.println("error"); //No I18N
				}
				return;
			}else if("multidcsupportdisable".equals(request.getParameter("action"))) { //No I18N
				try{
					out.println("success");//No I18N
				}catch(Exception ex) {
					LOGGER.log(Level.WARNING, null, ex);
					out.println("error"); //No I18N
				}
				return;
			}
			%>

<%@ include file="../../static/includes.jspf" %>
<%
	String mode = request.getParameter("mode");
if(mode == null) {
	List<OAuthClient> oauthClients = OAuth2Util.getAllUserOAuthClients(user);
	if(!user.isConfirmed()){
		%>
		<div id="add_client_div">
			<div class="add_client_message">
				<div><%=Util.getI18NMsg(request, "IAM.DEVELOPERCONSOLE.USER.UNCONFIRMED")%></div>
			</div>
		</div>
		<%
		return;
	}
	if(oauthClients == null || oauthClients.isEmpty()) {
%>
<div id="add_client_div">
	<div class="add_client_message">
		<div><%=Util.getI18NMsg(request, "IAM.DEVELOPERCONSOLE.APIKEY.DEFINITION")%></div>
		<div style="margin-top: 5%;">
			<button class="client_button_blue" onclick="goToAddClient()"><%=Util.getI18NMsg(request, "IAM.DEVELOPERCONSOLE.ADD.CLIENTID")%></button>
		</div>
	</div>
</div>
<%
	} else {
		Locale locale = user.getLanguage() != null ? new Locale(user.getLanguage()) : request.getLocale();
		String utz = user.getTimezone() != null ? user.getTimezone() : Util.getDefaultTimeZone();
		TimeZone tz = utz != null ? TimeZone.getTimeZone(utz) : TimeZone.getDefault();
		UserPreference upref = user.getUserPreference();
		String udf = (upref != null && Util.isValid(upref.getDateFormat())) ? upref.getDateFormat() : Util.getDefaultDateFormat();
		DateFormat df = new SimpleDateFormat(udf, locale);
		df.setTimeZone(tz);
%>
<div class="add_client_btn_div_list">
	<button class="client_button_blue" onclick="goToAddClient()"><%=Util.getI18NMsg(request, "IAM.DEVELOPERCONSOLE.ADD.CLIENTID")%></button>
</div>
<div class="view_client_outer_container">
		<div class="view_clients_header" >
			<div class="view_clients_inner_header" style="width:260px;"><%=Util.getI18NMsg(request, "IAM.DEVELOPERCONSOLE.CLIENTNAME")%></div>
			<div class="view_clients_inner_header" style="width:600px;"><%=Util.getI18NMsg(request, "IAM.DEVELOPERCONSOLE.CLIENTID")%></div>
			<div class="view_clients_inner_header" style="width:240px;"><%=Util.getI18NMsg(request, "IAM.GENERATEDTIME")%></div>
			<div class="view_clients_inner_header" style="min-width:60px;"></div>
		</div>
	<div class="view_client_inner_container">
		<%
			for(OAuthClient oauthClient : oauthClients) {
			if(oauthClient == null) {
				continue;
			}
		%>
		<div class="view_clients_rows" >
			<div class="view_clients_inner_rows" style="width:260px;"><%=IAMEncoder.encodeHTML(oauthClient.getClientName())%></div>
			<div class="view_clients_inner_rows" style="width:600px;"><%=IAMEncoder.encodeHTML(oauthClient.getClientId())%></div>
			<div class="view_clients_inner_rows" style="width:240px;"><%=IAMEncoder.encodeHTML(df.format(new Date(oauthClient.getCreatedTime())))%></div>
			<div class="menu_icon" onclick="displayIcons(this)">
				<span class="dot"></span>
				<span class="dot"></span>
				<span class="dot"></span>
				<div class="client_icons">
					<div class="client_icons_arrow_up"></div>
			  		<div class="client_icons_box">				  		
					  	<div class="client_icons_value" onclick="goToThisClient('<%=IAMEncoder.encodeJavaScript(oauthClient.getClientZid())%>')"><%=Util.getI18NMsg(request, "IAM.EDIT")%></div>
					  	<div class="client_icons_value" onclick="displayDeleteAlert('<%=IAMEncoder.encodeJavaScript(oauthClient.getClientZid())%>',this)"><%=Util.getI18NMsg(request, "IAM.DELETE")%></div>
					  	<%
					  		if(Util.isMultiDCSupport()){
					  	%>
						<div class="client_icons_value"  onclick="goToMultiDCSupport('<%=IAMEncoder.encodeJavaScript(oauthClient.getClientZid())%>')"><%=Util.getI18NMsg(request, "IAM.DEVELOPERCONSOLE.ZOHO.MULTI.DC")%></div>	
						<%
								}
							%>
						<%
							if(OAuth2Util.isSelfClientSupport(oauthClient)){
						%>
						<div class="client_icons_value" onclick="goToSelfClient('<%=IAMEncoder.encodeJavaScript(oauthClient.getClientZid())%>')"><%=Util.getI18NMsg(request, "IAM.DEVELOPERCONSOLE.SELF.CLIENT")%></div>
						<%
							}
						%> 				  				  		
				  	</div>
			  	</div>
			</div>
		</div>
		<%
			}
		%>
	</div>
</div>
<div class="message_banner" id="delete_client_id_success" style="display:none;"><%=Util.getI18NMsg(request, "IAM.DEVELOPERCONSOLE.SUCCESS.DELETE.CLIENT")%></div>
<div class="message_banner" id="delete_client_id_failed" style="display:none;"><%=Util.getI18NMsg(request, "IAM.DEVELOPERCONSOLE.ZOHO.DELETE.CLIENTID.FAILURE")%></div>
<div class="black_background" id="delete_alert" style="display:none;">
	<div class = "delete_alert">
		<div class="delete_alert_header"><%=Util.getI18NMsg(request, "IAM.DEVELOPERCONSOLE.DELETE.APICLIENT")%></div>
		<div class="delete_alert_btn">
			<button class="client_button_blue"onclick="deleteAPIClient()" style="padding:5px 20px;"><%=Util.getI18NMsg(request, "IAM.YES")%></button>
			<span class="client_button_spacer" >&nbsp;</span>
			<span class="client_button_spacer" >&nbsp;</span>
			<span class="client_button_spacer" >&nbsp;</span>
			<button class="client_button_white" onclick="hideDeleteAlert()" style="padding:5px 20px;"><%=Util.getI18NMsg(request, "IAM.NO")%></button>
		</div>
	</div>
</div>
<%
	}
} else if("viewclient".equals(mode)) { //No I18N
	String clientZid = request.getParameter("client_zid");
	OAuthClient oauthClient ;
	try{
		oauthClient = checkAndGetCurrentUserClient(clientZid);
		if(oauthClient == null)
		{
%>
				<div align="center"><%=Util.getI18NMsg(request, "IAM.ERROR.GENERAL")%></div>
			<%
				return;
					}
				}catch(OAuthException e){
					out.println(IAMEncoder.encodeHTML(e.getErrorCode().toString()));
					return;
				}
	boolean isReadOnly = oauthClient.getClientType() == OAuthClientType.EXTERNAL_INTERNAL_PURPOSE_CLIENT.getType();
				OAuthRedirectURL redirectUrlObj = oauthClient != null ? oauthClient.getOAuthRedirectURL(0) : null;
				List<OAuthJavaScriptDomains> jsDomains = null;
				String jsDoms = "";
				if(oauthClient != null && oauthClient.getClientType() == AccountsInternalConst.OAuthConstants.OAuthClientType.EXTERNAL_CLIENTOAUTH.getType()){
					jsDomains = oauthClient.getOAuthJavaScriptDomainsList();
					if(jsDomains != null){
						for(OAuthJavaScriptDomains dom : jsDomains){
							jsDoms = jsDoms + dom.getDomain() + ",";
						}
					}
					jsDoms = jsDoms!= "" ? jsDoms.substring(0, jsDoms.length()-1) : null;
				}
			%>
<div class="add_client_main_div" id="add_client_form_container">
	<div class="add_client_header"><%=Util.getI18NMsg(request, "IAM.DEVELOPERCONSOLE.ZOHO.CLIENTDETAILS")%></div>
	<div class="add_client_formdiv">
	<%
		if(oauthClient != null) {
	%>
		<form name="update_api_client" method="POST" onsubmit="return updateAPIClient(this)">
			<div class="add_client_form_field_main_div">
				<div class="add_client_form_field_label"><%=Util.getI18NMsg(request, "IAM.DEVELOPERCONSOLE.CLIENTID")%></div>
				<div class="add_client_form_field_value">
					<input type="text" name="client_id" class="client_form_field_input_disabled" value="<%=IAMEncoder.encodeHTMLAttribute(oauthClient.getClientId())%>" readonly/>
				</div>
			</div>
			<div class="add_client_form_field_main_div">
				<div class="add_client_form_field_label"><%=Util.getI18NMsg(request, "IAM.DEVELOPERCONSOLE.CLIENTSECRET")%></div>
				<div class="add_client_form_field_value">
					<input type="text" name="client_secret" class="client_form_field_input_disabled" value="<%=IAMEncoder.encodeHTMLAttribute(oauthClient.getClientSecret())%>" readonly/>
				</div>
			</div>
			<div class="add_client_form_field_main_div">
				<div class="add_client_form_field_label"><%=Util.getI18NMsg(request, "IAM.DEVELOPERCONSOLE.CLIENTNAME")%></div>
				<div class="add_client_form_field_value">
					<input type="text" name="client_name" class="client_form_field_input" value="<%=IAMEncoder.encodeHTMLAttribute(oauthClient.getClientName())%>" placeholder="<%=Util.getI18NMsg(request, "IAM.DEVELOPERCONSOLE.ENTER.CLIENTNAME")%>" onkeypress="clearAPIClientError(this)" <%=isReadOnly ? "readonly" : "" %>/>
					<div class="form_field_alert_msg"></div>
				</div>
			</div>
			<div class="add_client_form_field_main_div">
				<div class="add_client_form_field_label"><%=Util.getI18NMsg(request, "IAM.DEVELOPERCONSOLE.CLIENT.DOMAIN")%></div>
				<div class="add_client_form_field_value">
					<input type="text" name="client_domain" class="client_form_field_input" value="<%=IAMEncoder.encodeHTMLAttribute(oauthClient.getClientDomain())%>" placeholder="<%=Util.getI18NMsg(request, "IAM.EXAMPLE.DOMAIN")%>" onkeypress="clearAPIClientError(this)" <%=isReadOnly ? "readonly" : "" %>/>
					<div class="form_field_alert_msg"></div>
				</div>
			</div>
			<div class="add_client_form_field_main_div">
				<div class="add_client_form_field_label"><%=Util.getI18NMsg(request, "IAM.DEVELOPERCONSOLE.AUTHORIZED.REDIRECTURL")%></div>
				<div class="add_client_form_field_value">
					<input type="text" name="client_redirect_uri" class="client_form_field_input" value="<%=IAMEncoder.encodeHTMLAttribute(redirectUrlObj != null ? redirectUrlObj.getRedirectUrl() : "")%>" placeholder="<%=Util.getI18NMsg(request, "IAM.DEVELOPERCONSOLE.SAMPLE.REDIRECTURL")%>" onkeypress="clearAPIClientError(this)" <%=isReadOnly ? "readonly" : "" %>/>
					<div class="form_field_alert_msg"></div>
				</div>
			</div>
			<% if(oauthClient.getClientType() == AccountsInternalConst.OAuthConstants.OAuthClientType.EXTERNAL_CLIENTOAUTH.getType() ){%>
				<div class="add_client_form_field_main_div">
				<div class="add_client_form_field_label"><%=Util.getI18NMsg(request, "IAM.DEVELOPERCONSOLE.CLIENT.JS.DOMAIN")%></div>
				<div class="add_client_form_field_value">
					<input type="text" name="client_js_domain" class="client_form_field_input" value="<%=IAMEncoder.encodeHTMLAttribute(jsDoms != null ? jsDoms : "")%>" placeholder="<%=Util.getI18NMsg(request, "IAM.EXAMPLE.JS.DOMAIN")%>" onkeypress="clearAPIClientError(this)"/>
					<div class="form_field_alert_msg"></div>
				</div>
			</div>
			<%} %>
			<div id="client_common_error_panel" style="margin:-10px 0px 10px 0px; display:none;">
				<div class="form_field_alert_msg"><%=Util.getI18NMsg(request, "IAM.ERROR.GENERAL")%></div>
			</div>
			<input type="hidden" name="old_client_redirect_uri" value="<%=IAMEncoder.encodeHTMLAttribute(redirectUrlObj != null ? redirectUrlObj.getRedirectUrl() : "")%>"/>
			<%
			String clintTypeStr  = "WEB"; //No I18N
			 clintTypeStr  = oauthClient.getClientType() == AccountsInternalConst.OAuthConstants.OAuthClientType.EXTERNAL_CLIENTOAUTH.getType() ? "JS" : clintTypeStr; //No I18N
			 clintTypeStr  = oauthClient.getClientType() == AccountsInternalConst.OAuthConstants.OAuthClientType.EXTERNA_MOBILE.getType() ? "Mobile" : clintTypeStr; //No I18N
			
			%>
			<input type="hidden" name="client_type" value="<%=clintTypeStr%>"/> <%-- NO OUTPUTENCODING --%>
			<input type="hidden" name="old_client_js_domain" value="<%=IAMEncoder.encodeHTMLAttribute(jsDomains != null ? jsDoms : "") %>"/>
			<input type="submit" class="hidesubmit" />
		</form>
		<button class="client_button_blue" onclick="updateAPIClient(document.update_api_client)"><%=Util.getI18NMsg(request, "IAM.DEVELOPERCONSOLE.UPDATE.CLIENT")%></button>
		<span class="client_button_spacer">&nbsp;</span>				
		<button class="client_button_white" onclick="goToClientHome()"><%=Util.getI18NMsg(request, "IAM.CANCEL")%></button>
		<%
			}
		%>
	</div>
</div>
<div class="add_client_main_div" id="add_client_container_response" style="display:none;">
	<div class="add_client_success_container">
		<img src="<%=imgurl%>/round-tick.png" class="add_client_success_icon"/> <%-- NO OUTPUTENCODING --%> 
		<div class="add_client_success_msg"><%=Util.getI18NMsg(request, "IAM.DEVELOPERCONSOLE.SUCCESS.UPDATE.CLIENT")%></div>
		<div class="add_client_resp_btn_div"><button class="client_button_blue" onclick="goToClientHome()"><%=Util.getI18NMsg(request, "IAM.CLOSE")%></button></div>
	</div>
</div>
<%
	} else if("addclient".equals(mode)) { //No I18N
%>
<div class="add_client_main_div" id="add_client_form_container">
	<div class="add_client_header"><%=Util.getI18NMsg(request, "IAM.DEVELOPERCONSOLE.CREATE.CLIENTID")%></div>
	<div class="add_client_formdiv">
		<form name="add_api_client" method="POST" onsubmit="return addAPIClient(this)">
			<div class="add_client_form_field_main_div">
				<div class="add_client_form_field_label"><%=Util.getI18NMsg(request, "IAM.DEVELOPERCONSOLE.CLIENTNAME")%></div>
				<div class="add_client_form_field_value">
					<input type="text" name="client_name" class="client_form_field_input" placeholder="<%=Util.getI18NMsg(request, "IAM.DEVELOPERCONSOLE.ENTER.CLIENTNAME")%>" onkeypress="clearAPIClientError(this)"/>
					<div class="form_field_alert_msg"></div>
				</div>
			</div>
			<div class="add_client_form_field_main_div">
				<div class="add_client_form_field_label"><%=Util.getI18NMsg(request, "IAM.DEVELOPERCONSOLE.CLIENT.DOMAIN")%></div>
				<div class="add_client_form_field_value">
					<input type="text" name="client_domain" class="client_form_field_input" placeholder="<%=Util.getI18NMsg(request, "IAM.EXAMPLE.DOMAIN")%>" onkeypress="clearAPIClientError(this)"/>
					<div class="form_field_alert_msg"></div>
				</div>
			</div>
			<div class="add_client_form_field_main_div">
				<div class="add_client_form_field_label"><%=Util.getI18NMsg(request, "IAM.DEVELOPERCONSOLE.AUTHORIZED.REDIRECTURL")%></div>
				<div class="add_client_form_field_value">
					<input type="text" name="client_redirect_uri" class="client_form_field_input" placeholder="<%=Util.getI18NMsg(request, "IAM.DEVELOPERCONSOLE.SAMPLE.REDIRECTURL")%>" onkeypress="clearAPIClientError(this)"/>
					<div class="form_field_alert_msg"></div>
				</div>
			</div>
			<div id="js_client" style="display:none;">
			<div class="add_client_form_field_main_div">
				<div class="add_client_form_field_label"><%=Util.getI18NMsg(request, "IAM.DEVELOPERCONSOLE.CLIENT.JS.DOMAIN")%></div>
				<div class="add_client_form_field_value">
					<input type="text" name="client_js_domain" class="client_form_field_input" placeholder="<%=Util.getI18NMsg(request, "IAM.EXAMPLE.JS.DOMAIN")%>" onkeypress="clearAPIClientError(this)"/>
					<div class="form_field_alert_msg"></div>
				</div>
			</div>
			</div>
			<div class="add_client_form_field_main_div">
				<div class="add_client_form_field_label"><%=Util.getI18NMsg(request, "IAM.DEVELOPERCONSOLE.CLIENT.TYPE")%></div>
				<div class="add_client_form_field_value">
					<select name="client_type" id="client_type" onchange="resetJavaScript(this)">
					<option value="WEB"><%=Util.getI18NMsg(request, "IAM.DEVELOPERCONSOLE.WEB")%>
					<option value="JS"><%=Util.getI18NMsg(request, "IAM.DEVELOPERCONSOLE.JS")%>
					<option  value="Mobile"><%=Util.getI18NMsg(request, "IAM.DEVELOPERCONSOLE.MOBILE")%>
					</select>
					<div class="form_field_alert_msg"></div>
				</div>
			</div>
			<div id="client_common_error_panel" style="margin:-10px 0px 10px 0px; display:none;">
				<div class="form_field_alert_msg"><%=Util.getI18NMsg(request, "IAM.ERROR.GENERAL")%></div>
			</div>
			<input type="submit" class="hidesubmit" />
		</form>
		<button class="client_button_red" onclick="addAPIClient(document.add_api_client)"><%=Util.getI18NMsg(request, "IAM.CREATE")%></button>
		<button class="client_button_white" onclick="goToClientHome()"><%=Util.getI18NMsg(request, "IAM.CANCEL")%></button>
	</div>
</div>
<div class="add_client_main_div" id="add_client_container_response" style="display:none;">
	<div class="add_client_success_container">
		<img src="<%=imgurl%>/round-tick.png" class="add_client_success_icon"/> <%-- NO OUTPUTENCODING --%>
		<div class="add_client_success_msg"><%=Util.getI18NMsg(request, "IAM.DEVELOPERCONSOLE.SUCCESS.CREATE.CLIENT")%>
			<div><%=Util.getI18NMsg(request, "IAM.DEVELOPERCONSOLE.SUCCESS.CREATE.CLIENT.CLIENT.ID")%>&nbsp;<span  id="add_client_success_msg_client_id"></span></div>
			<div><%=Util.getI18NMsg(request, "IAM.DEVELOPERCONSOLE.SUCCESS.CREATE.CLIENT.CLIENT.SECRET")%>&nbsp;<span id="add_client_success_msg_client_secret"></span></div>
		</div>
			<div class="add_client_resp_btn_div"><button class="client_button_blue" onclick="goToClientHome()"><%=Util.getI18NMsg(request, "IAM.CLOSE")%></button></div>
	</div>
</div>
<%
	} else if("multidcsupport".equals(mode)) { //No I18N
	String clientZid = request.getParameter("client_zid");
	OAuthClient oauthClient;
	try{
		oauthClient = checkAndGetCurrentUserClient(clientZid);
		if(oauthClient == null)
		{
%>
			<div align="center"><%=Util.getI18NMsg(request, "IAM.ERROR.GENERAL")%></div>
		<%
			return;
				}
			}catch(OAuthException e){
				out.println(IAMEncoder.encodeHTML(e.getErrorCode().toString()));
				return;
			}
			OAuthRedirectURL redirectUrlObj = null;
			List<String> enabledLocations = new ArrayList<String>();
			if(oauthClient != null) {
				redirectUrlObj = oauthClient.getOAuthRedirectURL(0);
				List<OAuthDcDetails> dcd = oauthClient.getOAuthDcDetailsList();
				if(dcd != null) {
			for(OAuthDcDetails dc : dcd){
				if(dc == null) {
					continue;
				}
				enabledLocations.add(dc.getDcLocation().toLowerCase());
			}
				}
			}
		%>
<div class="add_client_main_div">
	<div class="add_client_header"><%=Util.getI18NMsg(request, "IAM.DEVELOPERCONSOLE.ZOHO.MULTI.DC")%></div>
	<div class="add_client_formdiv">
	<%
		if(oauthClient != null) {
	%>
			<div class="add_client_form_field_main_div">
				<div class="add_client_form_field_label"><%=Util.getI18NMsg(request, "IAM.DEVELOPERCONSOLE.CLIENTID")%></div>
				<div class="add_client_form_field_value">
					<input type="text" name="client_id" class="client_form_field_input_disabled" value="<%=IAMEncoder.encodeHTMLAttribute(oauthClient.getClientId())%>" readonly/>
				</div>
			</div>
			<div class="add_client_form_field_main_div">
				<div class="add_client_form_field_label"><%=Util.getI18NMsg(request, "IAM.DEVELOPERCONSOLE.CLIENTSECRET")%></div>
				<div class="add_client_form_field_value">
					<input type="text" name="client_secret" class="client_form_field_input_disabled" value="<%=IAMEncoder.encodeHTMLAttribute(oauthClient.getClientSecret())%>" readonly/>
				</div>
			</div>
		  <%
		  	String locations = Util.multiDcLocations();
		  	for(String loc : locations.split(",")){
		  		if(enabledLocations.contains(loc.toLowerCase())){
		  %>
			<div style="padding:10px 0px;">
				<div class="multi_dc_checkbox_div"><%=IAMEncoder.encodeHTML(loc)%></div>
				<div class="multiDc_enable" onclick="multiDcCheckbox('<%=IAMEncoder.encodeHTMLAttribute(loc)%>','<%=IAMEncoder.encodeHTMLAttribute(oauthClient.getClientId())%>','<%=IAMEncoder.encodeHTMLAttribute(oauthClient.getParent().getOauthAppGroupId())%>',this,'Enabled')">
				<%=Util.getI18NMsg(request, "IAM.TFA.ENABLED")%>
				</div>
				<div class="multi_dc_view" onclick="multiDcView('<%=IAMEncoder.encodeHTMLAttribute(loc)%>','<%=IAMEncoder.encodeHTMLAttribute(oauthClient.getClientId())%>','<%=IAMEncoder.encodeHTMLAttribute(oauthClient.getParent().getOauthAppGroupId())%>',this)"><%=Util.getI18NMsg(request,"IAM.DEVELOPERCONSOLE.CLIENTSECRET")%></div>
			  	<div class="multi_dc_view_box"><%=Util.getI18NMsg(request, "IAM.DEVELOPERCONSOLE.CLIENTSECRET")%>&nbsp;:&nbsp;<span style="color:#a8a8a8;"></span></div>				
			</div>
			<%
				}else{
			%>
			<div style="padding:10px 0px;">
				<div class="multi_dc_checkbox_div"><%=IAMEncoder.encodeHTML(loc)%></div>
				<div class="multiDc_enable" style="background-color:#fff;color:#000;border:1px solid #c1c1c1;" onclick="multiDcCheckbox('<%=IAMEncoder.encodeHTMLAttribute(loc)%>','<%=IAMEncoder.encodeHTMLAttribute(oauthClient.getClientId())%>','<%=IAMEncoder.encodeHTMLAttribute(oauthClient.getParent().getOauthAppGroupId())%>',this,'Disabled')"><%=Util.getI18NMsg(request, "IAM.DEVELOPERCONSOLE.ZOHO.DISABLED")%></div>
				<div class="multi_dc_view" onclick="multiDcView('<%=IAMEncoder.encodeHTMLAttribute(loc)%>','<%=IAMEncoder.encodeHTMLAttribute(oauthClient.getClientId())%>','<%=IAMEncoder.encodeHTMLAttribute(oauthClient.getParent().getOauthAppGroupId())%>',this)" style="display:none;"><%=Util.getI18NMsg(request,"IAM.DEVELOPERCONSOLE.CLIENTSECRET")%></div>
			 	<div class="multi_dc_view_box"><%=Util.getI18NMsg(request, "IAM.DEVELOPERCONSOLE.CLIENTSECRET")%>&nbsp;:&nbsp;<span style="color:#a8a8a8;"></span></div>							
			</div>
			<%
				}		
				}
			%>
		<button class="client_button_blue" onclick="goToClientHome()" style="margin-top:20px;"><%=Util.getI18NMsg(request, "IAM.BACKTO.HOME")%></button>
	<%
		} else {
	%>
		<div id="add_client_div">
			<div class="add_client_message" style="font-size: 13px;"><%=Util.getI18NMsg(request, "IAM.DEVELOPERCONSOLE.NOTFOUND.CLIENT")%></div>
		</div>
	<%
		}
	%>
	</div>
</div>
<div class="message_banner" id="multi_dc_support_banner" style="display:none;"></div> 
<%
 	}else if("selfclient".equals(mode)) { //No I18N
 	String clientZid = request.getParameter("client_zid");
 	OAuthClient oauthClient;
 	try{
 		oauthClient = checkAndGetCurrentUserClient(clientZid);
 		if(oauthClient == null)
 	{
 %>
				<div align="center"><%=Util.getI18NMsg(request, "IAM.ERROR.GENERAL")%></div>
			<%
				return;
		}
	}catch(OAuthException e){
		out.println(IAMEncoder.encodeHTML(e.getErrorCode().toString()));
		return;
	}
	OAuthRedirectURL redirectUrlObj = oauthClient != null ? oauthClient.getOAuthRedirectURL(0) : null;
%>
<div class="add_client_main_div" id="self_client">
	<div class="add_client_header"><%=Util.getI18NMsg(request, "IAM.DEVELOPERCONSOLE.SELF.CLIENT")%></div>
	<div class="add_client_formdiv">
	<%if(oauthClient != null){%>
		<form name="self_client" method="POST" onsubmit="return selfClient(this)">
		<div class="add_client_form_field_main_div">
			<div class="add_client_form_field_label"><%=Util.getI18NMsg(request, "IAM.DEVELOPERCONSOLE.SCOPE")%></div>
			<div class="add_client_form_field_value">
				<input type="text" name="scope" class="client_form_field_input" placeholder="<%=Util.getI18NMsg(request, "IAM.DEVELOPERCONSOLE.ENTER.SCOPE")%>" onkeypress="clearAPIClientError(this)"/>
				<div class="form_field_alert_msg" id="self_client_scope_error"></div>
			</div>
		</div>
		<div class="add_client_form_field_main_div">
			<div class="add_client_form_field_label" style="display:inline-block;"><%=Util.getI18NMsg(request, "IAM.DEVELOPERCONSOLE.EXPIRY")%>:&nbsp;
			 	<input type="text" name="expiry" class="client_form_field_input expiry_input" value="3 minutes" onclick="showExpiryDropDown(this,1)" id='1' readonly />
			 	<div class="expiry_dropdown" >				  		
				  	<div class="client_icons_value" onclick="changeExpiryValue(this,1)">3 <%=Util.getI18NMsg(request, "IAM.MINUTES")%></div>
				  	<div class="client_icons_value" onclick="changeExpiryValue(this,2)">5 <%=Util.getI18NMsg(request, "IAM.MINUTES")%></div>				 
					<div class="client_icons_value" onclick="changeExpiryValue(this,3)">7 <%=Util.getI18NMsg(request, "IAM.MINUTES")%></div>					
					<div class="client_icons_value" onclick="changeExpiryValue(this,4)">10 <%=Util.getI18NMsg(request, "IAM.MINUTES")%></div> 				  				  		
			 	</div>
			</div>
		</div>
		<div id="selfclient_common_error_panel" style="margin:-10px 0px 10px 0px; display:none;">
				<div class="form_field_alert_msg"><%=Util.getI18NMsg(request, "IAM.ERROR.GENERAL")%></div>
		</div>
		<input type="hidden" name="client_id" value="<%=IAMEncoder.encodeHTML(oauthClient.getClientId())%>"/>
		<input type="hidden" name="redirect_uri" value="<%=IAMEncoder.encodeHTMLAttribute(redirectUrlObj != null ? redirectUrlObj.getRedirectUrl() : "")%>"/>
		<input type="submit" class="hidesubmit"/>
		</form>
		<button class="client_button_red" onclick="selfClient(document.self_client)"><%=Util.getI18NMsg(request, "IAM.DEVELOPERCONSOLE.VIEWCODE")%></button>
		<button class="client_button_white" onclick="goToClientHome()"><%=Util.getI18NMsg(request, "IAM.CANCEL")%></button>
	<%} else {%>
		<div id="self_client_div">
			<div class="add_client_message" style="font-size: 13px;"><%=Util.getI18NMsg(request, "IAM.DEVELOPERCONSOLE.NOTFOUND.CLIENT")%></div>
		</div>
	<%}%>
	</div>
</div>
<div class="black_background" id="self_client_token" style="display:none;">
	<div class = "delete_alert" style="width:600px;">
		<div class="delete_alert_header"><%=Util.getI18NMsg(request, "IAM.DEVELOPERCONSOLE.CODE")%></div>
		<div class="delete_alert_header" id ="self_client_token_code"></div>
		<div class="delete_alert_btn">
			<button class="client_button_blue"onclick="goToClientHome()" style="padding:5px 20px;"><%=Util.getI18NMsg(request, "IAM.CLOSE")%></button>
		</div>
	</div>
</div>
<%}%>