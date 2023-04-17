<%-- $Id$ --%>
<%@page import="com.zoho.accounts.AppResource.RESOURCE.USERSYSTEMROLES"%>
<%@page import="com.zoho.resource.Criteria"%>
<%@page import="com.zoho.accounts.AppResource"%>
<%@page import="com.zoho.iam2.rest.RestProtoUtil"%>
<%@page import="com.zoho.accounts.AppResourceProto.App.AppSystemRole"%>
<%@page import="org.json.JSONArray"%>
<%@ include file="includes.jsp" %>
<%
	boolean isIAMServiceAdmin = !request.isUserInRole("IAMAdmininistrator") && request.isUserInRole(Role.IAM_SERVICE_ADMIN);
	List<String> isUserAllowedServices = new ArrayList<String>(); 
	if(isIAMServiceAdmin) {
		for(Service s: ss){
			if(s == null || s.getServiceName().equalsIgnoreCase(Util.getIAMServiceName())) {
				continue;
			}
			AppSystemRole appRole = (AppSystemRole) RestProtoUtil.GET(AppResource.getAppSystemRoleURI(s.getServiceName(), Role.IAM_SERVICE_ADMIN).getQueryString().setCriteria(new Criteria(USERSYSTEMROLES.ZUID, user.getZUID())).build());
			if(appRole != null) {
				isUserAllowedServices.add(s.getServiceName());
			}
		}
	}

	String type = request.getParameter("t");
	String sName = request.getParameter("serviceName");
	ServiceAPI servieAPI = Util.SERVICEAPI;
	Service service = sName != null ? servieAPI.getService(sName) : null;
	
	if(sName != null && isIAMServiceAdmin) {
		if(service == null || isUserAllowedServices.isEmpty() || !isUserAllowedServices.contains(service.getServiceName())) {
			return;
		}
	}
	if(service != null){
		if("getrole".equals(type)) {//No i18N
			Collection<Role> rolesList = Util.getRoleCache().values();
			String[] blockedRoles = AccountsConfiguration.getConfiguration("iam.serviceadmin.blocked.roles", (Role.IAM_SERVICE_ADMIN+",SASAdmin")).split(","); //No I18N
			JSONArray listrole=new JSONArray();
		  	int rolecnt = 0;
		  	for(Role r : rolesList) {
		  		if(r == null) {
		  			continue;
		  		}
		  		if(isIAMServiceAdmin && (!Util.isDevelopmentSetup())) {
		  			boolean isBlockedRole = false;
		  			for(String blockedRole : blockedRoles) {
						if(blockedRole.equalsIgnoreCase(r.getRoleName())) {
							isBlockedRole = true;
							break;
						}
					}
		  			if(isBlockedRole) {
						//don't allow to manage sasadmin and iamserviceadmin roles to iamserviceadmin role users
		  				continue;
		  			}
		  		}
				if(r.getServiceId() == service.getServiceId()) {
					listrole.put(r.getRoleName()); 
					rolecnt++;
				}
		    }
		   if(rolecnt>0){
			   out.print(listrole); //NO OUTPUTENCODING //No I18N
		   }
		 }	
		return;
}else{
%>
<div class="maincontent">
    <div class="menucontent">
	<div class="topcontent"><div class="contitle">Assign Role</div></div><%--No I18N--%>
	<div class="subtitle">Admin Services</div><%--No I18N--%>
    </div>

    <div class="field-bg">
	<%
	if(isIAMServiceAdmin && isUserAllowedServices.isEmpty()) {
	%>
		<div class="emptyobjmain">
	    	<dl class="emptyobjdl"><dd><p align="center" class="emptyobjdet"> No Service enabled to assign role </p></dd></dl><%-- No I18N --%>
		</div>
	<%
	} else {
	%>
	<form name="addaccount" method="post" class="zform" onsubmit="return saveAccount(this, '<%=request.isUserInRole("IAMAdmininistrator")%>')"><%-- NO OUTPUTENCODING --%>
	    <div class="labelmain">
			<div class="labelkey">Service Name :</div>
			<div class="labelvalue">
			<%if(isIAMServiceAdmin) {%>
				<!-- service admin role users view -->
				<select name="serviceName" class="select" id="servicehtml5" onchange="fetchRoleNames(document.addaccount, this.value)">
					<option>--Select--</option><%--No I18N--%>
					<%for(String sname: isUserAllowedServices){%><option value='<%=IAMEncoder.encodeHTMLAttribute(sname)%>'><%=IAMEncoder.encodeHTML(sname)%></option><%}%>
				</select>
			<%} else {%>
				<!-- non Html5 supported browser -->
				<select name="serviceName" class="select" id="servicehtml5" onchange="getRoleNames(document.addaccount)">
					<%for(Service s: ss){%><option value='<%=IAMEncoder.encodeHTMLAttribute(s.getServiceName())%>'><%=IAMEncoder.encodeHTML(s.getServiceName())%></option><%}%>
					<option value='all'>All Services</option><%--No I18N--%>
				</select>
				<!-- Html5 supported browser -->
				<div class='canvascheck'>
					<input class="input" name="serviceName" list="services" onblur="getRoleNames(document.addaccount)"/>
		    		<datalist id="services" class="canvascheck"> <%--No I18N--%>
						<%for(Service s: ss){%><option value='<%=IAMEncoder.encodeHTMLAttribute(s.getServiceName())%>'><%}%>
						<option value='all'><%--No I18N--%>
 					</datalist><%--No I18N--%>
 				</div>
			<%}%>
			</div>
		<div class="labelkey">Role Name :</div>
		<div class="labelvalue">
		<div id=roleparent>
		<select id="roles" name="roleName" class="select" disabled><%--No I18N--%>
			<option value="select role">select role</option> <%--No I18N--%>  
		</select>
		</div>
		</div>	
		<div class="labelkey">Login Name :</div>
		<div class="labelvalue"><textarea name="loginName" class="textarea"  onfocus="clearsampletxt(this)" placeholder="Use comma ',' for multiple Email Address"></textarea></div><%--No I18N--%>
		<div class="labelkey">Is Enabled :</div>
		<div class="labelvalue" style="padding:6px 0px;"><input type="checkbox" name="isEnabled" class="check"></div>
		<div class="accbtn Hbtn">
		    <div class="savebtn" onclick="saveAccount(document.addaccount, '<%=request.isUserInRole("IAMAdmininistrator")%>')"><%-- NO OUTPUTENCODING --%>
			<span class="btnlt"></span>
			<span class="btnco">Save</span>
			<span class="btnrt"></span>
		    </div>
		    <div onclick="loadservice();">
			<span class="btnlt"></span>
			<span class="btnco">Cancel</span>
			<span class="btnrt"></span>
		    </div>
		</div>
		<input type="submit" class="hidesubmit" />
	    </div>
	</form>
	<% } %>
    </div>
</div>
<% }%>