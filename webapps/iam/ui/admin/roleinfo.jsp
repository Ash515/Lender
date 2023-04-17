<%-- $Id$ --%>
<%@page import="com.zoho.iam2.rest.ProtoToZliteUtil"%>
<%@page import="com.zoho.accounts.AppResource.RESOURCE.USERSYSTEMROLES"%>
<%@page import="com.zoho.resource.Criteria"%>
<%@page import="com.zoho.iam2.rest.RestProtoUtil"%>
<%@page import="com.zoho.accounts.AppResourceProto.App.AppSystemRole"%>
<%@page import="com.zoho.accounts.AppResource"%>
<%@page import="com.zoho.accounts.AppResourceProto.App.AppSystemRole.UserSystemRoles"%>
<%@page import="com.zoho.accounts.Accounts"%>
<%@ include file="includes.jsp" %>
<div class="maincontent">
    <div class="menucontent">
    <div class="topcontent"><div class="contitle"id="roleinfotitle">Role Info</div></div> <%--No I18N--%>
    <div class="subtitle">Admin Services</div>
    </div>
    <div class="field-bg">
    
<%
    String serviceName = request.getParameter("sname");
    String loginName = request.getParameter("uname");
    String roleName=request.getParameter("rname");
    boolean isMulti = Boolean.parseBoolean(request.getParameter("ismulti"));
    serviceName = Util.isValid(serviceName) ? serviceName : "";//No I18N
    String roleNameStr = Util.isValid(roleName) ? roleName : "Select Role"; //NO I18N
    loginName=Util.isValid(loginName)?loginName:"";//No I18N
    
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
	if(isIAMServiceAdmin && isUserAllowedServices.isEmpty()) {
	%>
		<div class="emptyobjmain">
	    	<dl class="emptyobjdl"><dd><p align="center" class="emptyobjdet"> No service enabled to view user associated roles</p></dd></dl><%-- No I18N --%>
		</div>
	<%
	} else {
%>
    <div class="restorelink" >
            <a href="javascript:;" id="usrlink" onclick="showroleinfofrm(this, true)" class="<%=!isMulti ? "disablerslink" : "activerslink"%>" >View By User</a> / <%--No I18N--%>
            <a href="javascript:;" id="ssrlink" onclick="showroleinfofrm(this, false)" class="<%=isMulti ? "disablerslink" : "activerslink"%>">View By Service</a> <%--No I18N--%>
        </div>
    <form name="userroleinfo" id="userroleinfo" class="zform" method="post" onsubmit="return getuserRoles(this, '<%=request.isUserInRole("IAMAdmininistrator")%>');" <%if(isMulti) { %>style="display:none;"<%}%>><%-- NO OUTPUTENCODING --%>
        <div class="labelmain">
        <div class="labelkey">Service Name :</div>
        <div class="labelvalue">
        <%if(isIAMServiceAdmin) {%>
        	<!-- service admin role users view -->
			<select name="serviceName" class="select" id="servicehtml5">
				<option value="--Select--">--Select--</option><%--No I18N--%>
				<%for(String sname: isUserAllowedServices){%>
				<option value='<%=IAMEncoder.encodeHTMLAttribute(sname)%>' <%if(!isMulti && sname.equalsIgnoreCase(serviceName)) {%>selected<%}%>><%=IAMEncoder.encodeHTML(sname)%></option>
				<%}%>
			</select>
        <%} else {%>
        	<select name="serviceName" class="select" id="servicehtml5">
				<%for(Service s: ss) { %>
            	<option value='<%=IAMEncoder.encodeHTMLAttribute(s.getServiceName())%>'><%=IAMEncoder.encodeHTML(s.getServiceName())%></option>
				<%}%>
        	</select>
            <!-- html5 -->
         	<div class='canvascheck'>
         		<% if(isMulti){ %>
            	<input class="input" name="serviceName" list="services" onblur="getRoleNames(document.serviceroleinfo)" value=""/>
            	<% }else{%>
            	<input class="input" name="serviceName" list="services" onblur="getRoleNames(document.serviceroleinfo)" value="<%=IAMEncoder.encodeHTMLAttribute(serviceName)%>"/>
            	<%} %>
            	<datalist id="services"> <%--No I18N--%>
            		<%for(Service s: ss){%><option value='<%=IAMEncoder.encodeHTMLAttribute(s.getServiceName())%>'><%}%>
            		<option value='all'><%--No I18N--%>
             	</datalist><%--No I18N--%>
             	<!-- html5 -->
         	</div>
         <%}%>
        </div>
        <div class="labelkey">User Name or Email Address :</div> <%--No I18N--%>
        <div class="labelvalue">
            <input type="text" name="loginName" class="input" value="<%=IAMEncoder.encodeHTMLAttribute(loginName)%>"/>
        </div>
        <div class="accbtn Hbtn">
            <div class="savebtn" onclick="getuserRoles(document.userroleinfo, '<%=request.isUserInRole("IAMAdmininistrator")%>')"><%-- NO OUTPUTENCODING --%>
            <span class="btnlt"></span>
            <span class="btnco">Get Roles</span>
            <span class="btnrt"></span>
            </div>
            <div onclick="document.userroleinfo.reset();">
            <span class="btnlt"></span>
            <span class="btnco">Cancel</span>
            <span class="btnrt"></span>
            </div>
        </div>
        <input type="submit" class="hidesubmit" />
        </div>
        </form>
    <form name="serviceroleinfo" id="serviceroleinfo" class="zform" method="post" onsubmit="return getserviceRoles(this, '<%=request.isUserInRole("IAMAdmininistrator")%>');" <%if(!isMulti) {%>style="display:none;"<%}%>><%-- NO OUTPUTENCODING --%>
          <div class="labelmain">
        <div class="labelkey">Service Name :</div> <%--No I18N--%>
        <div class="labelvalue">
        <%if(isIAMServiceAdmin) {%>
        	<!-- service admin role users view -->
			<select name="serviceName" class="select" id="servicehtml5" onchange="fetchRoleNames(document.serviceroleinfo, this.value)">
				<option value="--Select--">--Select--</option><%--No I18N--%>
				<%for(String sname: isUserAllowedServices){%>
				<option value='<%=IAMEncoder.encodeHTMLAttribute(sname)%>' <%if(isMulti && sname.equalsIgnoreCase(serviceName)) {%>selected<%}%>><%=IAMEncoder.encodeHTML(sname)%></option>
				<%}%>
			</select>
        <%} else {%>
        	<!-- non Html5 supported browser -->
        	<select name="serviceName" class="select" id="servicehtml5" onchange="getRoleNames(document.serviceroleinfo)">
        		<%for(Service s: ss){%><option value='<%=IAMEncoder.encodeHTMLAttribute(s.getServiceName())%>'><%=IAMEncoder.encodeHTML(s.getServiceName())%></option><%}%>
        		<option value='all'>All Services</option><%--No I18N--%>
        	</select>
        	<!-- Html5 supported browser -->
        	<div class='canvascheck'>
        		<% if(!isMulti){ %>
            	<input class="input" name="serviceName" list="services" onblur="getRoleNames(document.serviceroleinfo)" value=""/>
            	<% }else{%>
            	<input class="input" name="serviceName" list="services" onblur="getRoleNames(document.serviceroleinfo)" value="<%=IAMEncoder.encodeHTMLAttribute(serviceName)%>"/>
            	<%} %>
            	<datalist id="services" class="canvascheck"> <%--No I18N--%>
            		<%for(Service s: ss){%><option value='<%=IAMEncoder.encodeHTMLAttribute(s.getServiceName())%>'><%}%>
            		<option value='all'><%--No I18N--%>
             	</datalist><%--No I18N--%>
         	</div>
         <%}%>
        </div>
        <div class="labelkey">Role Name :</div> <%--No I18N--%>
        <div class="labelvalue">
        <div id=roleparent>
        <select id="roles" name="roleName" class="select"><%--No I18N--%>
            <option value="<%=IAMEncoder.encodeHTMLAttribute(roleNameStr)%>"><%=IAMEncoder.encodeHTML(roleNameStr)%></option> <%--No I18N--%>  
        </select>
        </div>
        </div>    
        <div class="accbtn Hbtn">
            <div class="savebtn" onclick="getserviceRoles(document.serviceroleinfo, '<%=request.isUserInRole("IAMAdmininistrator")%>')"><%-- NO OUTPUTENCODING --%>
            <span class="btnlt"></span>
            <span class="btnco">View  users</span> <%--No I18N--%>
            <span class="btnrt"></span>
            </div>
            <div onclick="document.serviceroleinfo.reset();">
            <span class="btnlt"></span>
            <span class="btnco">Cancel</span> <%--No I18N--%>
            <span class="btnrt"></span>
            </div>
        </div>
        <input type="submit" class="hidesubmit" />
        </div>
    </form>
<div id="user_role">
<%
UserAPI uapi = Util.USERAPI;
ServiceAPI sapi = Util.SERVICEAPI;
Service service = null;
if(Util.isValid(serviceName)){
    service = sapi.getService(serviceName);
}
boolean canUserViewRole = request.isUserInRole("IAMAdmininistrator");
if((!canUserViewRole && isIAMServiceAdmin) && service != null){
	canUserViewRole = isUserAllowedServices.contains(service.getServiceName());
}
if(Util.isValid(serviceName) && Util.isValid(loginName)){
	if(canUserViewRole) {
		User ue = uapi.getUser(loginName);
    	if(ue != null && service != null) {
        	UserAccount ua = uapi.getAccount(ue.getZUID(), service.getServiceId());
			AppSystemRole[] roles = (AppSystemRole[]) RestProtoUtil.GETS(AppResource.getAppSystemRoleURI(serviceName).getQueryString().setCriteria(new Criteria(USERSYSTEMROLES.ZUID, ue.getZUID())).build());
        	int rolecnt = 0;
        	String[] blockedRoles = AccountsConfiguration.getConfiguration("iam.serviceadmin.blocked.roles", (Role.IAM_SERVICE_ADMIN+",SASAdmin")).split(","); //No I18N
			for(AppSystemRole arole : roles) { 
				Role role = ProtoToZliteUtil.toRole(serviceName, arole);
            	if(isIAMServiceAdmin && (!Util.isDevelopmentSetup())) {
            		boolean isBlockedRole = false;
		  			for(String blockedRole : blockedRoles) {
						if(blockedRole.equalsIgnoreCase(role.getRoleName())) {
							isBlockedRole = true;
							break;
						}
					}
		  			if(isBlockedRole) {
						//don't allow to manage sasadmin and iamserviceadmin roles to iamserviceadmin role users
		  				continue;
		  			}
            	}
            	rolecnt++;   
            	if(rolecnt>0) {
                	if(rolecnt == 1) {
%>
            <div class="ipstitle"><%=IAMEncoder.encodeHTML(loginName)%>'s Roles (<%=ue.isActive() ? "Active" : "InActive" %>)</div>
            <div class="apikeyheader" id="headerdiv">
                <div class="apikeytitle" style="width:28%;">Role Name</div>
                <div class="apikeytitle" style="width:31%;">Description</div>
                <div class="apikeytitle" style="width:20%;">Is Default</div><%--No I18N--%>
                <div class="apikeytitle" style="width:14%;">Action</div>
            </div>
            <div id="overflowdiv" class="content1">
<%
                	}
%>
            <div class="apikeycontent">
                <div class="apikey" style="width:28%;"><%=IAMEncoder.encodeHTML(role.getRoleName())%></div>
                <div class="apikey" style="width:31%;"><%=IAMEncoder.encodeHTML(role.getRoleDescription())%></div>
                <div class="apikey" style="width:20%;"><%=role.isDefault()%></div> <%-- NO OUTPUTENCODING --%>
                <div class="apikey" style="width:10%;padding-left:14px;margin-left:22px;">
                <div class="Hbtn" style="margin-top:-2px;">
                    <div class="savebtn" onclick="deleteRole('<%=IAMEncoder.encodeJavaScript(loginName)%>', '<%=IAMEncoder.encodeJavaScript(serviceName)%>', '<%=role.getRoleId()%>')"> <%-- NO OUTPUTENCODING --%>
                    <span class="cbtnlt"></span>
                    <span class="cbtnco">Delete</span>
                    <span class="cbtnrt"></span>
                    </div>
                </div>
                </div>
                <div class="clrboth"></div>
            </div>
<%
            	}
        	}
        	if(rolecnt >= 1) {
        		out.println("</div>");
        	}
        	if(rolecnt == 0) {
%>
            <div class="emptyobjmain">
                <dl class="emptyobjdl">
                <dd><p align="center" class="emptyobjdet">No Role(s) configured for this user</p></dd>
                </dl>
            </div>
        <%
			}
		} else {
		%>
			<div class="emptyobjmain">
            	<dl class="emptyobjdl">
            		<dd><p align="center" class="emptyobjdet">Invalid user found</p></dd>
            	</dl>
        	</div>
        <%
		}
    } else {
    	%>
			<div class="emptyobjmain">
            	<dl class="emptyobjdl"><%-- No I18N --%>
            		<dd><p align="center" class="emptyobjdet">Requested service is not enabled to view user roles</p></dd> <%--No I18N--%>
            	</dl>
        	</div>
    	<%
    }
}
%>
</div>
<div id ="service_role">
<%
if(Util.isValid(roleName) && Util.isValid(serviceName)){
	if(canUserViewRole) {
		boolean isBlockedRole = false;
    	if(isIAMServiceAdmin && (!Util.isDevelopmentSetup())) {
			String[] blockedRoles = AccountsConfiguration.getConfiguration("iam.serviceadmin.blocked.roles", (Role.IAM_SERVICE_ADMIN+",SASAdmin")).split(","); //No I18N
  			for(String blockedRole : blockedRoles) {
				if(blockedRole.equalsIgnoreCase(roleName)) {
					isBlockedRole = true;
					break;
				}
			}
    	}
    	UserSystemRoles[] userRoles = isBlockedRole ? null : AppResource.getUserSystemRolesURI(serviceName, roleName).GETS();
    	if(userRoles!=null){
        	int roleId=Util.SERVICEAPI.getRoleId(roleName);
%>
    <div class="ipstitle"><%=IAMEncoder.encodeHTML(roleName)%> Role</div> <%--No I18N--%>
    <div class="apikeyheader" id="headerdiv">
        <div class="apikeytitle" style="width:50%;">Email Address</div> <%--No I18N--%>
        <div class="apikeytitle" style="width:20%;">Action</div> <%--No I18N--%>
	</div>
	<div id="overflowdiv" class="content1">
<%
        	for(UserSystemRoles userRole:userRoles){
        		User roleUser = Util.USERAPI.getUser(IAMUtil.getLong(userRole.getZuid()));
        		String roleUserEmail = roleUser == null || roleUser.isClosed() ? userRole.getZuid() + "(Closed ZUID)" : roleUser.getPrimaryEmail(); //No I18N
        		String roleUserEmail1 = roleUser == null || roleUser.isClosed() ? "" : roleUser.getPrimaryEmail(); //No I18N
				roleUserEmail += ""+ ((roleUser != null && !roleUser.isActive()) ? " (InActive)" : "");
%>
        <div class="apikeycontent">
        	<div class="apikey" style="width:50%;"><%=IAMEncoder.encodeHTML(roleUserEmail)%></div>
           	<div class="apikey" style="width:20%;padding-left:14px;margin-left:22px;">
                <div class="Hbtn" style="margin-top:-2px;">
                   	<div class="savebtn" onclick="deleteRole('<%=IAMEncoder.encodeJavaScript(roleUserEmail1)%>', '<%=IAMEncoder.encodeJavaScript(serviceName)%>', '<%=roleId%>')">
                        <span class="cbtnlt"></span>
                       	<span class="cbtnco">Delete</span> <%--No I18N--%>
                       	<span class="cbtnrt"></span>
                    </div>
                </div>
            </div>
           	<div class="clrboth"></div>
        </div>
<%
        	}
%>
	</div>
<%
    	} else if(isBlockedRole) {
%>
	<div class="emptyobjmain">
		<dl class="emptyobjdl"> <%--No I18N--%>
			<dd><p align="center" class="emptyobjdet">Requested role is not enabled to view users list</p></dd> <%--No I18N--%>
		</dl>
	</div>
<%
    	}else{
%>
	<div class="emptyobjmain">
		<dl class="emptyobjdl"> <%--No I18N--%>
			<dd><p align="center" class="emptyobjdet">No User is having this Role</p></dd> <%--No I18N--%>
		</dl>
	</div>
<%
     	}
    } else {
%>
	<div class="emptyobjmain">
		<dl class="emptyobjdl"> <%--No I18N--%>
			<dd><p align="center" class="emptyobjdet">Requested service is not enabled to view users list</p></dd> <%--No I18N--%>
		</dl>
	</div>
<%
    }
}
}
%>
</div>
</div>
</div>
</div>