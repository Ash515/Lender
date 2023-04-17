<%-- $Id$ --%>
<%@page import="com.zoho.accounts.AppResource.RESOURCE.USERSYSTEMROLES"%>
<%@page import="com.zoho.resource.Criteria"%>
<%@page import="com.zoho.resource.URI"%>
<%@page import="com.zoho.accounts.AppResource"%>
<%@page import="com.zoho.iam2.rest.RestProtoUtil"%>
<%@page import="com.zoho.accounts.AppResourceProto.App.AppSystemRole"%>
<%@ include file="includes.jsp" %>
<div class="maincontent">
    <div class="menucontent">
		<div class="topcontent"><div class="contitle">Add Role</div></div>
		<div class="subtitle">Admin Services</div>
    </div>
    
    <%
    boolean isIAMAdmin = request.isUserInRole("IAMAdmininistrator");
    boolean isIAMServiceAdmin = !isIAMAdmin && request.isUserInRole(Role.IAM_SERVICE_ADMIN) && Util.isDevelopmentSetup();
	List<String> isUserAllowedServices = new ArrayList<String>(); 
	if(isIAMServiceAdmin) {
	    long userid = IAMUtil.getCurrentUser().getZUID();
		AppSystemRole[] appRoles = (AppSystemRole[]) RestProtoUtil.GETS(AppResource.getAppSystemRoleURI(URI.JOIN, Role.IAM_SERVICE_ADMIN).getQueryString().setCriteria(new Criteria(USERSYSTEMROLES.ZUID, userid)).build());
		if(appRoles != null) {
    		for (AppSystemRole appRole : appRoles) {//Populate permission enabled services
    			if(appRole.getParent().getAppName().equalsIgnoreCase(Util.getIAMServiceName())) {
    				continue;
    			}
				isUserAllowedServices.add(appRole.getParent().getAppName().toLowerCase());
    		}
		}
	}
    %>

    <div class="field-bg">
	<form name="addrole" id="addrole" class="zform" onsubmit="javascript:return saveRole(this);" method="post">
	    <div class="labelmain">
		<div class="labelkey">Service Name :</div>
		<div class="labelvalue">
		<!-- non Html5 supported browser -->
		<select name="serviceName" class="select" id="servicehtml5">
		<%for(Service s: ss){%>
		<%if(isIAMServiceAdmin && !isUserAllowedServices.contains(s.getServiceName().toLowerCase())) {
			continue;
		}%>
		<option value='<%=IAMEncoder.encodeHTMLAttribute(s.getServiceName())%>'><%=IAMEncoder.encodeHTML(s.getServiceName())%></option>
		<% %>
		<%}%>
		<%if(isIAMAdmin) { %> <option value='all'>All Services</option><%--No I18N--%><%} %>
		</select>
		<!-- Html5 supported browser -->
		<div class='canvascheck'>
			<input class="input" name="serviceName" list="services" />
		    <datalist id="services"> <%--No I18N--%>
			<%for(Service s: ss){%>
			<%if(isIAMServiceAdmin && !isUserAllowedServices.contains(s.getServiceName().toLowerCase())) {
				continue;
			}%>
			<option value='<%=IAMEncoder.encodeHTMLAttribute(s.getServiceName())%>'>
			<%}%>
			<%if(isIAMAdmin) { %> <option value='all'><%--No I18N--%><%} %>
 			</datalist><%--No I18N--%>
 		</div>
		</div>
		<div class="labelkey">Role Name :</div>
		<div class="labelvalue"><input type="text" name="roleName" class="input"/></div>
		<div class="labelkey">Description :</div>
		<div class="labelvalue"><input type="text" class="input" name="description"/></div>
		<div class="labelkey">Is Default :</div>
		<div class="labelvalue"><input type="checkbox" class="check" name="isDefault"></div>
		<div class="accbtn Hbtn">
		    <div class="savebtn" onclick="saveRole(document.addrole)">
			<span class="btnlt"></span>
			<span class="btnco"><%=Util.getI18NMsg(request,"IAM.SAVE")%></span>
			<span class="btnrt"></span>
		    </div>
		    <div onclick="loadservice();">
			<span class="btnlt"></span>
			<span class="btnco"><%=Util.getI18NMsg(request,"IAM.CANCEL")%></span>
			<span class="btnrt"></span>
		    </div>
		</div>
		<input type="submit" class="hidesubmit" />
	    </div>
	</form>
    </div>
</div>
