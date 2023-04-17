
<%-- $Id$ --%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@page import="com.zoho.accounts.AccountsConstants.OrgType"%>
<%@page import="com.zoho.iam2.rest.ServiceOrgUtil"%>
<%@page import="com.zoho.accounts.internal.util.AppConfiguration"%>
<%@page import="com.zoho.accounts.AppResourceProto.App.Configuration"%>
<%@page import="com.zoho.accounts.AppResource"%>
<%@page import="com.zoho.iam2.rest.ProtoUtil"%>
<%@page import="com.zoho.accounts.AppResourceProto.App.AppKeyStore"%>
<%@page import="com.zoho.iam2.rest.ServiceAPIRestProtoImpl"%>
<%@page import="com.zoho.accounts.Accounts"%>
<%@page import="java.io.ByteArrayOutputStream"%>
<%@ include file="../../static/includes.jspf"%>
<%@ include file="includes.jsp"%>
<div class="maincontent">
	<div class="menucontent">
	<div class="topcontent"><div class="contitle">Zoho Services</div></div>
		<div class="subtitle">Admin Services</div>
	</div>
	<div class="field-bg">
		<%
			String type = request.getParameter("t");
			 if ("add".equals(type)) {
		%>
	<div class="topbtn Hcbtn">
	    <div class="addnew" onclick="loadui('/ui/admin/service.jsp?t=view');">
		<span class="cbtnlt"></span>
		<span class="cbtnco">Back to Service</span>
		<span class="cbtnrt"></span>
			</div>
		</div>
		<div id="headerdiv"></div>
		<div id="overflowdiv">
			<form name="addservice" class="zform addservice" method="post" onsubmit="return saveService(this)">
				<div class="labelmain">
					<div class="labelkey">Service Name :</div>
		<div class="labelvalue"><input name="serviceName" class="input" type="text"></div>
					<div class="labelkey">Display Name :</div>
		<div class="labelvalue"><input name="displayName" type="text" class="input"></div>
				    <div class="labelkey">AppCode/ZAC ServiceName :</div> <%--No I18N--%>
		<div class="labelvalue"><input name="app_code" type="text" class="input"></div>
					<div class="labelkey">Description :</div>
		<div class="labelvalue"><input name="description" type="text" class="input"></div>
					<div class="labelkey">URL :</div>
		<div class="labelvalue"><input name="domainName" type="text" class="input"></div>
					<div class="labelkey">RO URL :</div><%--No I18N--%>
		<div class="labelvalue"><input name="roDomainName" type="text" class="input" placeholder="Optional"></div>
					<div class="labelkey">Home Page :</div>
		<div class="labelvalue"><input name="homePage" type="text" class="input"></div>
					<div class="labelkey">Internal Server URL :</div> <%--No I18N--%>
		<div class="labelvalue"><input name="internal_server" type="text" class="input"></div>
					<div class="labelkey">Allow Registration :</div>
		<div class="labelvalue"><input type="checkbox" name="allowRegistration"></div>
					<div class="labelkey">Auto Registration :</div>
		<div class="labelvalue"><input type="checkbox" name="autoRegistration"></div>
					<div class="labelkey">Is Public :</div>
		<div class="labelvalue"><input type="checkbox" name="isPublic"></div>
		<div class="labelkey">Is Loginname Needed :</div><%--No I18N--%>
		<div class="labelvalue"><input type="checkbox" name="isLN"></div>
		<div class="labelkey">Service Type :</div><%--No I18N--%>
					<div class="labelvalue">
						<select name="serviceType" style="width: 200px;">
							<option value="1">Productivity</option>
							<option value="2">Collaboration</option>
							<option value="3">Business</option>
							<option value="4">Helpdesk</option><%--No I18N--%>
							<option value="5">Finance</option><%--No I18N--%>
							<option value="6">Humanresources</option><%--No I18N--%>
						</select>
					</div>
		<div class="labelkey">Org Type :</div><%--No I18N--%>
		<div class="labelvalue radiobutton"><input type="radio" name="orgType" value="<%=Service.OrgType.APPACCOUNT.getValue()%>" onchange="showDivByID('appRoolediv'); showDivByID('serviceparentorgappdiv');hideDivByID('serviceparentorgdiv');"> AppAccount<input onchange="hideDivByID('appRoolediv'); showDivByID('serviceparentorgdiv');hideDivByID('serviceparentorgappdiv');" type="radio" name="orgType" value="<%=Service.OrgType.SERVICEORG.getValue()%>"> ServiceOrg <input type="radio" name="orgType" value="<%=Service.OrgType.ADMIN_TOOL.getValue()%>" onchange=");hideDivByID('appRoolediv'); );hideDivByID('serviceparentorgappdiv');hideDivByID('serviceparentorgdiv');"> Admin Tool/Internal App(No DB) </div><%--No I18N--%><%-- NO OUTPUTENCODING --%>
		<div class="labelkey">Org Model :</div><%--No I18N--%>
		<div class="labelvalue radiobutton"><input type="radio" name="orgModel" value="<%=Service.OrgModel.SINGLE.getValue()%>"> Single <input type="radio" name="orgModel" value="<%=Service.OrgModel.MULTIPLE.getValue()%>"> Multiple</div><%--No I18N--%><%-- NO OUTPUTENCODING --%>
		
		<div id="serviceparentorgdiv" style="display: none;">
		<div class="labelkey">Parent ServiceOrg :</div><%--No I18N--%>
		<div class="labelvalue choosen-style">
			<select name="parentOrgtype" style="width:250px;" class="chosen-serType chosen-oath-admin-select labelvalue" tabindex="6">
			<option value="-1" "selected"> None</option> <%--No I18N--%>
	        	<% 
	        		for(OrgType st : OrgType.values()) {
	        			if(st.isServiceOrg()) {
	        	%>
	        			<option value="<%=st.getType() %>"><%=st.name() +"(" + st.getServiceName() +")"%></option><%-- NO OUTPUTENCODING --%>
	        	<%
	        		}
	        			}
	        	%>
			</select>
		</div>
		</div>
		<div id="serviceparentorgappdiv" style="display: none;">
		<div class="labelkey">Parent AppAccount :</div><%--No I18N--%>
		<div class="labelvalue choosen-style">
			<select name="parentappOrgtype" style="width:250px;" class="chosen-serType chosen-oath-admin-select labelvalue" tabindex="6">
			<option value="-1" "selected"> None</option> <%--No I18N--%>
	        	<% 
	        		for(OrgType st : OrgType.values()) {
	        			if(st == OrgType.BCOrgType || st == OrgType.DEFAULT || st == OrgType.ACCOUNTS || !st.isAppAccountType()) {
	        				continue;
	        			}
	        	%>
	        			<option value="<%=st.getType() %>"><%=st.name() +"(" + st.getServiceName() +")"%></option><%-- NO OUTPUTENCODING --%>
	        	<%
	        		}
	        	%>
			</select>
		</div>
		</div>
		<div id="appRoolediv" style="display: none;">
		<div class="labelkey">AppAccount roles :</div><%--No I18N--%>
		<div class="labelvalue choosen-style">
			<select name="accroles" style="width:350px;" class="chosen-select11 chosen-oath-admin-select labelvalue" multiple tabindex="6">
	        <option value="SuperAdmin" selected  >SuperAdmin</option> <%--No I18N--%>
	        <option value="Admin" selected> Admin </option> <%--No I18N--%>
	        <option value=User selected> User </option> <%--No I18N--%>
			</select>
		</div>
		</div>
		<div class="labelkey">Service :</div><%--No I18N--%>
		<div class="labelvalue">
			<select name="service" style="width: 200px;">
			<%
				for(AccountsInternalConst.Services serviceName : AccountsInternalConst.Services.values()) {
				%>
					<option value="<%= serviceName.getValue() %>"><%=serviceName.name()%></option>><%--No I18N--%>
				<% 
				}
			%>
			</select>
		</div>
		
					<div class="accbtn Hbtn">
						<div class="savebtn" onclick="saveService(document.addservice)">
			<span class="btnlt"></span>
			<span class="btnco">Add</span>
			<span class="btnrt"></span>
						</div>
						<div onclick="loadui('/ui/admin/service.jsp?t=view');">
			<span class="btnlt"></span>
			<span class="btnco">Cancel</span>
			<span class="btnrt"></span>
						</div>
					</div>
					<input type="submit" class="hidesubmit" />
				</div>
			</form>
		</div>
		<%
			}
				    else if("view".equals(type)) {
		%>
		<div class="topbtn Hcbtn" style="margin:6px 0px 8px 0px;">
			<div class="addnew" style="float:left; margin: 0;" onclick="loadui('/ui/admin/service.jsp?t=add');initAccMember();">
		<span class="cbtnlt"></span>
		<span class="cbtnco">Add New Service</span><%--No I18N--%>
		<span class="cbtnrt"></span>
			</div>
			<div class="addnew" style="margin: 0;" onclick="loadui('/ui/admin/reorder-service.jsp')">
		<span class="cbtnlt"></span>
		<span class="cbtnco">Reorder Services</span><%--No I18N--%>
		<span class="cbtnrt"></span>
			</div>
		</div>
		<div class="apikeyheader" id="headerdiv">
	    <div class="apikeytitle" style="width:10%;">Service Name</div> <%--No I18N--%>
	    <div class="apikeytitle" style="width:10%;">Service Code</div> <%--No I18N--%>
			<div class="apikeytitle" style="width: 20%;">Description</div>	<%--No I18N--%>
			<div class="apikeytitle" style="width: 20%;">Default Url</div>	<%--No I18N--%>
			<div class="apikeytitle" style="width: 20%;">IAM Build</div>	<%--No I18N--%>
			<div class="apikeytitle" style="width: 16%;">Action</div>	<%--No I18N--%>
		</div>
		<div class="content1" id="overflowdiv">
	<%
		for(Service service : CSPersistenceAPIImpl.getAllServicesByListingOrder()){
	%>
			<div class="apikeycontent">
				<div class="apikey" style="width: 10%;"><%=IAMEncoder.encodeHTML(service.getServiceName())%></div>
				<div class="apikey" style="width: 10%;"><%=IAMEncoder.encodeHTML(service.getServiceCode())%></div>
				<div class="apikey" style="width: 20%;"><%=IAMEncoder.encodeHTML(service.getDescription())%></div>
				<div class="apikey" style="width: 20%;"><%=IAMEncoder.encodeHTML(service.getWebUrl())%></div>
				<div class="apikey" style="width: 20%;"><%=IAMEncoder.encodeHTML(ProtoUtil.getIAMAgentBuildInfo(service.getServiceName()))%></div>
				<div class="apikey apikeyaction">
					<div class="Hbtn fllt" style="width: 67%;">
                    <div class="savebtn" onclick="loadui('/ui/admin/service.jsp?t=edit&sname=<%=IAMEncoder.encodeJavaScript(service.getServiceName())%>');initAccMember();">
			<span class="cbtnlt"></span>
			<span class="cbtnco" style="width:35px;">Edit</span>
			<span class="cbtnrt"></span>
						</div>
					</div>
				</div>
				<div class="clrboth"></div>
			</div>
			<%
				}
							out.println("</div>");
				    }
				    else if("edit".equals(type)) {
							String sName = request.getParameter("sname");
							ServiceAPI servieAPI = Util.SERVICEAPI;
							Service service = servieAPI.getService(sName);
							Configuration intconf = (Configuration) RestProtoUtil.GET(AppResource.getConfigurationURI(sName, "iam.internal.server")); //No I18N
							String intServerURL = intconf != null ? intconf.getConfigValue() : "";
							com.zoho.accounts.AppResourceProto.App.Role[] appRoles = AppResource.getRoleURI(service.getServiceName()).GETS();
							String publickey = null;
							AppKeyStore appKeyStore = AppResource.getAppKeyStoreURI(sName,"isc").GET();//No I18N
							if(appKeyStore != null){
							 	publickey = appKeyStore.getPublicKey();
							}
			%>
			<div class="topbtn Hcbtn">
				<div class="addnew" onclick="loadui('/ui/admin/service.jsp?t=view');">
		<span class="cbtnlt"></span>
		<span class="cbtnco">Back to Service</span>
		<span class="cbtnrt"></span>
				</div>

			</div>

			<div id="headerdiv">&nbsp;</div>
			<div id="overflowdiv">
				<div id="editservice">
					<div class="editlink">
						<a href="javascript:;" onclick="updateserviceform('show')">[Edit Service]</a>
					</div>
					<div class="editlink">
			<%
				if(IAMUtil.isValid(publickey)){
			%>
						<a style="color:#0487EF" href="javascript:;" onclick="regenerate('<%=IAMEncoder.encodeJavaScript(sName)%>','download',false)">ReGenerate</a><%--No I18N--%>
			<%
				} else {
			%>
						<a href="javascript:;" onclick="regenerate('<%=IAMEncoder.encodeJavaScript(service.getServiceName())%>','add',false)">[Add ISC Key]</a><%--No I18N--%>
			<%
				}
			%>
                    </div>
					<div class="labelkey key">Service Name :</div>
					<div class="labelvalue"><%=IAMEncoder.encodeHTML(service.getServiceName())%></div>
	    <div class="labelkey key">Service Code :</div>	<%--No I18N--%>
					<div class="labelvalue"><%=IAMEncoder.encodeHTML(service.getServiceCode())%></div>
					<div class="labelkey key">Display Name :</div>
					<div class="labelvalue"><%=IAMEncoder.encodeHTML(service.getDisplayName())%></div>
					<div class="labelkey key">Description :</div>
					<div class="labelvalue"><%=IAMEncoder.encodeHTML(service.getDescription())%></div>
					<div class="labelkey key">URL :</div>
					<div class="labelvalue"><%=IAMEncoder.encodeHTML(service.getWebUrl())%></div>
					<div class="labelkey key">RO URL :</div><%--No I18N--%>
					<div class="labelvalue"><%=IAMEncoder.encodeHTML(service.getRoUrl())%></div>
					<div class="labelkey key">Home Page :</div>
					<div class="labelvalue"><%=IAMEncoder.encodeHTML(service.getHomePage())%></div>
					<div class="labelkey key">Internal Server :</div> <%--No I18N--%>
					<div class="labelvalue"><%=Util.isValid(intServerURL) ? IAMEncoder.encodeHTML(intServerURL) : "-"%></div>
					<div class="labelkey key">Allow Registration :</div>
					<div class="labelvalue"><%=service.isAllowRegistration() ? "allowed" : "closed"%></div>
					<div class="labelkey key">Auto Registration :</div>
					<div class="labelvalue"><%=service.isAutoRegistration() ? "Yes" : "No"%></div>
					<div class="labelkey key">Is Public :</div>
					<div class="labelvalue"><%=service.isPublic() ? "Yes" : "No"%></div>
	    <div class="labelkey key">Is Loginname Needed :</div><%--No I18N--%>
					<div class="labelvalue"><%=service.isLoginNameNeeded() ? "Yes" : "No"%></div>
            <div class="labelkey key">Service Type :</div><%--No I18N--%>
					<div class="labelvalue">
						<%
							if (service.getServiceType() == Service.COLLABORATION) {
																	out.print("Collaboration");
																} else if (service.getServiceType() == Service.BUSINESS) {
																	out.print("Business");
																} else if (service.getServiceType() == service.PRODUCTIVITY){
																	out.print("Productivity");
																} else if (service.getServiceType() == service.HELPDESK){
																	out.print("Helpdesk");//No i18N
																} else if (service.getServiceType() == service.FINANCE){
																	out.print("Finance");//No i18N
																} else{
																	out.print("Humanresources");//No i18N
																}
						
						%> 
 					</div>
 										
					<div class="labelkey key">Org Type:</div><%--No I18N--%>
					<div class="labelvalue"> <%=service.isAppAccountEnabled() && service.isServiceOrgEnabled() ? "AppAccount/ServiceOrg " : service.isAppAccountEnabled() ? "Appaccount" : service.isServiceOrgEnabled() ? "ServiceOrg" : "None"%>
					</div>
					<div class="labelkey key">Org Model :</div><%--No I18N--%>
					<div class="labelvalue"> <%=Service.OrgModel.SINGLE.getValue() ==service.getAccountType()  ? "Single" : Service.OrgModel.MULTIPLE.getValue() ==service.getAccountType() ? "Multiple" : "None"%>
					</div>
					<%
											if(service.isServiceOrgEnabled()) {
												OrgType stype = null;
												int orgTypeInt = service.getParentServiceOrgType();
												if(orgTypeInt != -1) {
													stype = OrgType.valueOf(orgTypeInt, true, false);
												}
												
										%>
					<div class="labelkey key">Parent ServiceOrg  :</div><%--No I18N--%>
					<div class="labelvalue"> <%=(stype != null ? stype.name() : "None" ) %><%-- NO OUTPUTENCODING --%>
					</div>
					<%} %>
					<%
											if(service.isAppAccountEnabled()) {
												OrgType stype = null;
												int orgTypeInt = service.getParentAppAccountOrgType();
												if(orgTypeInt != -1) {
													stype = OrgType.valueOf(orgTypeInt, true, true);
												}
												
										%>
					<div class="labelkey key">Parent AppAccount Type  :</div><%--No I18N--%>
					<div class="labelvalue"> <%=(stype != null ? stype.name() : "None" ) %><%-- NO OUTPUTENCODING --%>
					</div>
					<%} %>
					<div class="labelkey key">Public Key :</div><%--No I18N--%>
					
					<div class="pkvalue"><%=IAMEncoder.encodeHTML(IAMUtil.isValid(publickey) ? publickey : "None")%></div>
					
					<div class="roleHeader">
						System Roles : <%--No I18N--%>
					</div>
					<div class="apikeyheader">
		<div class="apikeytitle" style="width:34%;">Role Name</div> <%--No I18N--%>
		<div class="apikeytitle" style="width:37%;">Role Description</div> <%--No I18N--%>
						<div class="apikeytitle" style="width: 25%;">Is Default</div>
					</div>
					<%
						Map<String, Role> rolesCache = Util.getRoleCache();
													Collection<Role> rolesList = rolesCache.values();
													int rolecnt = 0;
													for (Role r : rolesList) {
														if (r.getServiceId() == service.getServiceId()) {
															rolecnt++;
					%>
					<div class="apikeycontent content1">
						<div class="apikey" style="width: 34%;"><%=IAMEncoder.encodeHTML(r.getRoleName())%></div>
						<div class="apikey" style="width: 37%;"><%=IAMEncoder.encodeHTML(r.getRoleDescription())%></div>
		<div class="apikey" style="width:25%;"><%=r.isDefault()%></div> <%-- NO OUTPUTENCODING --%>
						<div class="clrboth"></div>
					</div>
					<%
						}
													}
													if (rolecnt == 0) {
					%>
			<div class="apikeycontent content1" style="text-align:center;height:15px;padding:5px 0px;">No Roles Defined</div><%--No I18N--%>
					<%
						}
					%>
					
					<%
											if(service.isAppAccountEnabled()) {
										%>
					
					<div class="roleHeader">
						AppAccount Roles : <%--No I18N--%>
					</div>
					<div class="apikeyheader">
						<div class="apikeytitle" style="width:34%;">Role Name</div> <%--No I18N--%>
						<div class="apikeytitle" style="width:37%;">ZARID</div> <%--No I18N--%>
					</div>
					<%
						int approlecnt = 0;
													if (appRoles != null) {
													for (com.zoho.accounts.AppResourceProto.App.Role r : appRoles) {
														approlecnt++;
					%>
					<div class="apikeycontent content1">
						<div class="apikey" style="width: 34%;"><%=IAMEncoder.encodeHTML(r.getRoleName())%></div>
						<div class="apikey" style="width: 37%;"><%=IAMEncoder.encodeHTML(r.getZarid())%></div>
					<div class="clrboth"></div>
					</div>
					<%
						}
													}
													if (approlecnt == 0) {
					%>
				<div class="apikeycontent content1" style="text-align:center;height:15px;padding:5px 0px;">No AppAccount  Defined</div><%--No I18N--%>
								<%
									}
																	}
								%>
					
				</div>

	<form name="updateservice" class="zform" id="updateservice" method="post" onsubmit="return saveService(this)" style="display:none;">
	    <input name="serviceid" type="hidden" value="<%=service.getServiceId()%>"> <%-- NO OUTPUTENCODING --%>
					<div class="service">
						<div class="labelkey">Service Name :</div>
						<div class="labelvalue">
		    <input name="serviceName" class="input" type="text" value="<%=IAMEncoder.encodeHTMLAttribute(service.getServiceName())%>">
						</div>
						<div class="labelkey">Display Name :</div>
						<div class="labelvalue">
		    <input name="displayName" type="text" class="input" value="<%=IAMEncoder.encodeHTMLAttribute(service.getDisplayName())%>">
						</div>
						<div class="labelkey">AppCode/ZAC ServiceName :</div> <%--No I18N--%>
						<div class="labelvalue">
		    <input name="app_code" type="text" class="input" value="<%=IAMEncoder.encodeHTMLAttribute(service.getServiceCode())%>">
						</div>
						<div class="labelkey">Description :</div>
						<div class="labelvalue">
		    <input name="description" type="text" class="input" value="<%=IAMEncoder.encodeHTMLAttribute(service.getDescription())%>">
						</div>
						<div class="labelkey">URL :</div>
						<div class="labelvalue">
							<input name="domainName" type="text" class="input" value="<%=IAMEncoder.encodeHTMLAttribute(service.getWebUrl())%>">
						</div>
						<div class="labelkey">RO URL :</div><%--No I18N--%>
						<div class="labelvalue">
							<input name="roDomainName" type="text" class="input" value="<%=IAMEncoder.encodeHTMLAttribute(service.getRoUrl())%>">
						</div>
						<div class="labelkey">Home Page :</div>
						<div class="labelvalue">
							<input name="homePage" type="text" class="input" value="<%=IAMEncoder.encodeHTMLAttribute(service.getHomePage())%>">
						</div>
						<div class="labelkey">Internal Server URL :</div> <%--No I18N--%>
						<div class="labelvalue">
							<input name="internal_server" type="text" class="input" value="<%=IAMEncoder.encodeHTMLAttribute(intServerURL)%>">
						</div>
						<div class="labelkey">Allow Registration :</div>
						<div class="labelvalue">
							<input type="checkbox" class="checkbox" name="allowRegistration" <%=service.isAllowRegistration() ? "checked" : ""%>>
						</div>
						<div class="labelkey">Auto Registration :</div>
						<div class="labelvalue">
							<input type="checkbox" class="checkbox" name="autoRegistration" <%=service.isAutoRegistration() ? "checked" : ""%>>
						</div>
						<div class="labelkey">Is Public :</div>
						<div class="labelvalue">
							<input type="checkbox" class="checkbox" name="isPublic" <%=service.isPublic() ? "checked" : ""%>>
						</div>
		<div class="labelkey">Is Loginname needed :</div><%--No I18N--%>
						<div class="labelvalue">
							<input type="checkbox" class="checkbox" name="isLN" <%=service.isLoginNameNeeded() ? "checked" : ""%>>
						</div>
                <div class="labelkey">Service Type :</div><%--No I18N--%>
						<div class="labelvalue">
							<select name="serviceType" style="width: 200px;">
								<option value="1" <%=service.getServiceType() == Service.PRODUCTIVITY ? "selected" : ""%>>Productivity</option>
								<option value="2" <%=service.getServiceType() == Service.COLLABORATION ? "selected" : ""%>>Collaboration</option>
								<option value="3" <%=service.getServiceType() == Service.BUSINESS ? "selected" : ""%>>Business</option>
								<option value="4" <%=service.getServiceType() == Service.HELPDESK ? "selected" : ""%>>Helpdesk</option><%--No I18N--%>
								<option value="5" <%=service.getServiceType() == Service.FINANCE ? "selected" : ""%>>Finance</option><%--No I18N--%>
								<option value="6" <%=service.getServiceType() == Service.HUMANRESOURCES ? "selected" : ""%>>Humanresources</option><%--No I18N--%>
							</select>
						</div>
						
						<div class="labelkey">Org Type :</div><%--No I18N--%>
					<div class="labelvalue radiobutton"><input type="radio" name="orgType" value="<%=Service.OrgType.APPACCOUNT.getValue()%>" onchange="showDivByID('appRoolediv');hideDivByID('serviceparentorgdiv');showDivByID('serviceparentorgappdiv');" <%=(!service.isServiceOrgEnabled() && service.isAppAccountEnabled() ? "checked=\"checked\"" : "" )%>  > AppAccount<input onchange="hideDivByID('appRoolediv');showDivByID('serviceparentorgdiv');hideDivByID('serviceparentorgappdiv');" type="radio" name="orgType" value="<%=Service.OrgType.SERVICEORG.getValue()%>" <%=(!service.isAppAccountEnabled() && service.isServiceOrgEnabled() ? "checked=\"checked\"" : "" )%> > ServiceOrg <%--No I18N--%><%-- NO OUTPUTENCODING --%>
					
					<%if(service.isServiceOrgEnabled() && service.isAppAccountEnabled()) {
						%>
							<input type="radio" name="orgType" value="<%=Service.OrgType.APPACCOUNT_SERVICEORG.getValue()%>" onchange="showDivByID('appRoolediv');showDivByID('serviceparentorgdiv');showDivByID('serviceparentorgappdiv');" checked="checked">  > AppAccount & ServiceOrg <%--No I18N--%><%-- NO OUTPUTENCODING --%>
						<%
					}
						%>
						<input type="radio" name="orgType" value="<%=Service.OrgType.ADMIN_TOOL.getValue()%>" onchange=");hideDivByID('appRoolediv');hideDivByID('serviceparentorgdiv');hideDivByID('serviceparentorgappdiv');" <%=(!service.isServiceOrgEnabled() && !service.isAppAccountEnabled() ? "checked=\"checked\"" : "" )%>  >  Admin Tool/Internal App(No DB) <%-- NO OUTPUTENCODING --%><%--No I18N--%> 
					</div>
					<div class="labelkey">Org Model :</div><%--No I18N--%>
					<div class="labelvalue radiobutton"><input type="radio" name="orgModel" value="<%=Service.OrgModel.SINGLE.getValue()%>" <%=(service.getAccountType() ==Service.OrgModel.SINGLE.getValue() ? "checked=\"checked\"" : "" )%> > Single <input type="radio" name="orgModel" value="<%=Service.OrgModel.MULTIPLE.getValue()%>" <%=(service.getAccountType() ==Service.OrgModel.MULTIPLE.getValue() ? "checked=\"checked\"" : "" )%>> Multiple</div><%--No I18N--%><%-- NO OUTPUTENCODING --%>
					
					<div id="appRoolediv" <%=!service.isAppAccountEnabled() ? "style=\"display: none;\"" :"" %> >

							<%
								StringBuilder roles = new StringBuilder();
							if(appRoles != null)  {
								for(com.zoho.accounts.AppResourceProto.App.Role rol :  appRoles) {
									if(roles.length() > 0 ){
										roles.append(",");
									}
									roles.append(rol.getRoleName());
								}
							}%>					
						<div class="labelkey">Existing AppAccount roles :</div><%--No I18N--%>
						<div class="labelvalue">
							<input name="existAppAccRoles" type="text" class="input" disabled="disabled" value="<%=IAMEncoder.encodeHTMLAttribute(roles.toString())%>">
						</div>
						<div class="labelkey">New AppAccount roles :</div> <%--No I18N--%>
						<div class="labelvalue choosen-style">
							<select name="accroles" style="width:350px;" class="chosen-select11 chosen-oath-admin-select labelvalue" multiple tabindex="6">								
							</select>
						</div>
					</div>
					
					<div id="serviceparentorgdiv" <%=!service.isServiceOrgEnabled() ? "style=\"display: none;\"" :"" %> >
						<div class="labelkey">Parent ServiceOrg : </div><%--No I18N--%>
						<div class="labelvalue choosen-style">
							<select name="parentOrgtype" style="width:250px;" class="chosen-serType chosen-oath-admin-select labelvalue" tabindex="6">
								<option value="-1" <%=(service.getParentServiceOrgType() == -1)  ? "selected=\"selected\"" :"" %> > None</option><%--No I18N--%>
					        	<% 
					        		for(OrgType st : OrgType.values()) {
					        			if(st.isServiceOrg()) {
					        	%>
					        			<option value="<%=st.getType()%>" <%=((service.getParentServiceOrgType() == st.getType())  ? "selected=\"selected\"" :"" )%> > <%=IAMEncoder.encodeHTML(st.name() +"(" + st.getServiceName() +")")%></option><%-- NO OUTPUTENCODING --%>
					        	<%
					        		}
					        		}
					        	%>
							</select>
						</div>
					</div>
					
					<div id="serviceparentorgappdiv" <%=!service.isAppAccountEnabled() ? "style=\"display: none;\"" :"" %> >
		<div class="labelkey">Parent AppAccount :</div><%--No I18N--%>
		<div class="labelvalue choosen-style">
			<select name="parentappOrgtype" style="width:250px;" class="chosen-serType1 chosen-oath-admin-select labelvalue" tabindex="6">
			<option value="-1" > None</option> <%--No I18N--%>
	        	<% 
	        		for(OrgType st : OrgType.values()) {
	        			if(st == OrgType.BCOrgType || st == OrgType.DEFAULT || st == OrgType.ACCOUNTS || !st.isAppAccountType()) {
	        				continue;
	        			}
	        			
	        	%>
	        			<option value="<%=st.getType() %>" <%=((service.getParentAppAccountOrgType() == st.getType())  ? "selected=\"selected\"" :"" )%> ><%=st.name() +"(" + st.getServiceName() +")"%></option><%-- NO OUTPUTENCODING --%>
	        	<%
	        		}
	        	%>
			</select>
		</div>
		</div>
		<div class="labelkey">Service :</div><%--No I18N--%>
		<div class="labelvalue">
			<select name="service" style="width: 200px;">
				<%
				for(AccountsInternalConst.Services serviceName : AccountsInternalConst.Services.values()) {
				%>
					<option value="<%= serviceName.getValue() %>"><%=serviceName.name()%></option>><%--No I18N--%>
				<% 
				}
				%>
			</select>
		</div>
					
						<div class="accbtn Hbtn" id='_updateservicebtn'>
							<div class="savebtn" onclick="saveService(document.updateservice)">
								<span class="btnlt"></span>
								<span class="btnco">Update</span><%--No I18N--%>
	                  			<span class="btnrt"></span>
							</div>
							<div onclick="loadui('/ui/admin/service.jsp?t=edit&sname=<%= IAMEncoder.encodeHTML(service.getServiceName())%>');initAccMember();">
								<span class="btnlt"></span> <span class="btnco">Cancel</span> <span class="btnrt"></span><%--No I18N--%>
							</div>
						</div>
						<input type="submit" class="hidesubmit" />
					</div>
				</form>
			</div>
			<%
				}
			%>
		</div>
	</div>
	<iframe name="uploadaction" id="uploadaction" class="hide" frameborder="0" height="0%" width="0%"></iframe>
	</div>