<%-- $Id$ --%>
<%@page import="com.zoho.accounts.AppResource.RESOURCE.USERSYSTEMROLES"%>
<%@page import="com.zoho.resource.Criteria"%>
<%@page import="com.zoho.accounts.AppResource"%>
<%@page import="com.zoho.accounts.AppResourceProto.App.AppSystemRole"%>
<%@page import="com.zoho.accounts.SystemResourceProto.DCLocation"%>
<%@page import="com.zoho.accounts.dcl.DCLUtil"%>
<%@page import="com.zoho.accounts.internal.oauth2.OAuthMobileDetails"%>
<%@page import="org.json.JSONArray"%>
<%@page import="org.json.JSONObject"%>
<%@page import="com.zoho.resource.Representation"%>
<%@page import="com.zoho.accounts.OAuthResource.RESOURCE.OAUTHMOBILEAPPNAME"%>
<%@page import="com.zoho.resource.URI"%>
<%@page import="com.zoho.accounts.OAuthResourceProto.OAuthMobileAppService.OAuthMobileAppName"%>
<%@page import="com.zoho.accounts.internal.util.AccountsInternalConst.MobileAppType"%>
<%@page import="com.zoho.accounts.internal.util.AccountsInternalConst.MobileClientTypes"%>
<%@page import="com.zoho.accounts.internal.util.AccountsInternalConst.MobileDevicesType"%>
<%@page import="com.zoho.accounts.OAuthResource.RESOURCE.OAUTHMOBILEDEVICESDETAILS"%>
<%@page import="com.zoho.accounts.OAuthResourceProto.OAuthMobileAppService.OAuthMobileAppName.OAuthMobileDevices"%>
<%@page import="com.zoho.accounts.OAuthResource.RESOURCE.OAUTHMOBILEDEVICES"%>
<%@page import="com.zoho.accounts.OAuthResourceProto.OAuthMobileAppService"%>
<%@page import="com.zoho.accounts.OAuthResourceProto.OAuthMobileAppService.OAuthMobileAppName"%>
<%@page import="com.zoho.accounts.OAuthResourceProto.OAuthAppGroup.OAuthClient.OAuthRedirectURL"%>
<%@page import="com.zoho.accounts.internal.oauth2.OAuth2Util"%>
<%@page import="com.adventnet.iam.internal.Util"%>
<%@page import="java.util.Set"%>
<%@page import="com.adventnet.iam.xss.IAMEncoder"%>
<%@page import="com.zoho.accounts.actions.oauth2.OAuthMobileSSOUtil"%>
<%@page import="java.util.Map"%>
<%@page import="com.zoho.accounts.OAuthResource"%>
<%@page import="com.zoho.accounts.OAuthResourceProto.OAuthMobileAudience"%>
<%@page import="com.zoho.accounts.OAuthResourceProto.OAuthMobileAppDetails"%>
<%@ include file="../../static/includes.jspf" %>
<%@ include file="includes.jsp"%>
<%
        long userid = IAMUtil.getCurrentUser().getZUID();
        boolean isIAMAdmin = request.isUserInRole("IAMAdmininistrator");
        //boolean isOAuthAdmin = request.isUserInRole("OAuthAdmin");
        boolean isIAMServiceAdmin = !isIAMAdmin && request.isUserInRole(Role.IAM_SERVICE_ADMIN);
    	List<String> isUserAllowedServices = new ArrayList<String>(); 
    	if(isIAMServiceAdmin) {
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
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<style>
.mobileServiceRow {
	display: grid;
	grid-template-columns: 10% 90%;
	width: 100%;
	font-size: 13px;
	padding: 0px 0px 6px 6px;
    border-bottom-style: dashed;
    border-bottom-width: 1px;
    border-bottom-color: black;
	
}

.mobileServiceName {
	align-self: center;
}

.mobileAppRow {
	display: grid;
	grid-template-columns: 11% 89%;
 	padding: 0px 0px 0px 6px; 
}

.mobileAppName {
	align-self: center;
}

.mobileAppCatagory {
	display: grid;
	grid-template-columns: 30% 23% 14% 14% 42%;
 	padding: 0px 0px 0px 6px;
 	border-bottom-style: dashed;
    border-bottom-width: 1px;
    border-bottom-color: black;
}

.appColumn{
	overflow: hidden;
	float: left;
	align-self: center;
}

.selectablebox{
	font-size: 13px; 
	padding: 0px 0px 4px 0px
}

.modal{
  display: none; 
  position: fixed; 
  left: 0;
  top: 0;
  width: 100%; 
  height: 100%; 
  overflow: auto; 
  background-color: rgb(0,0,0); 
  background-color: rgba(0,0,0,0.4); 
}
.modal-content{
  background-color: #fefefe;
  margin: auto;
  padding: 20px;
  border: 1px solid #888;
  width: 30%;
  margin-top: 15%;
  overflow: auto;
  border-radius: 5px;
}
.modal-content{
font-size: 13px;
}
.checkboxStyle{
      margin-bottom: 5px;
}
</style>
<body>
<div class="maincontent">
    <div class="menucontent">
        <div class="topcontent"><div class="contitle" id="deletetitle">Mobile App Creation</div></div> <%--No I18N--%>
		<div class="subtitle">Admin Services</div> <%--No I18N--%>
	</div>
<%
String type = request.getParameter("t");
String operation = request.getParameter("op");

if(type.equalsIgnoreCase("view")){
	%>
	<div>
    	<a href="javascript:;" id="dolink" onclick="showmobileform(this, true)" class="disablerslink" style="font-size:13px">Mobile Apps</a> / <%--No I18N--%>
        <a href="javascript:;" id="dufolink" onclick="showmobileform(this, false)" class="activerslink" style="font-size:13px">Add new app Category</a> <%--No I18N--%>
    </div>
<%--
=============================================================
@@@@ View Mobile Apps Configured @@@@ 
--%>
    <div id="showMobileApps">
	<div class="Hcbtn topbtn">
	  	<div class="addnew" onclick="loadui('/ui/admin/mobileregistration.jsp?t=addNewMobileApp'); initSelect2();">
			<span class="cbtnlt"></span>
			<span class="cbtnco">Add New Mobile App</span>  <%--No I18N--%>
			<span class="cbtnrt"></span>
		</div>
	</div>
	<br>
	<div class="apikeyheader" id="headerdiv">
		<div class="apikeytitle" style="width:10%;">Service Name</div>  <%--No I18N--%>
		<div class="apikeytitle" style="width:10%;">App Name</div>  <%--No I18N--%>
		<div class="apikeytitle" style="width:23%;">Client Id</div>  <%--No I18N--%>
	    <div class="apikeytitle" style="width:18%;">PackageName</div>  <%--No I18N--%>
	    <div class="apikeytitle" style="width:10%;">AppType</div>  <%--No I18N--%>
	    <div class="apikeytitle" style="width:11%;">ClientType</div>  <%--No I18N--%>	
	    <div class="apikeytitle">Actions</div> <%--No I18N--%>
	</div>
	 <div class="content1" id="overflowdiv">
	<%
	Collection<DCLocation> dcLocations = DCLUtil.getLocationList();
	String loc = "";
	for(DCLocation d : dcLocations){
		if(Util.isValid(loc)){
			loc += ",";
		}
		loc+=d.getLocation();
	}
	OAuthMobileAppService[] services = OAuthResource.getOAuthMobileAppServiceURI().GETS();
	if(services != null){
	for(OAuthMobileAppService ser : services){	
		if(Util.isDevelopmentSetup() && isIAMServiceAdmin) {
			if(!isUserAllowedServices.contains(ser.getServiceName().toLowerCase())) {
				continue;
			}
		}
		OAuthMobileAppName[] apps = (OAuthMobileAppName[])OAuthResource.getOAuthMobileAppNameURI(ser.getServiceName()).addSubResource(OAUTHMOBILEDEVICES.table()).GETS();
		if(apps == null){
			continue;
		}
	%>
	<div class="mobileServiceRow" >
	<div class="mobileServiceName" >
	<%= ser.getServiceName()%>
	</div>
	<div class="mobileAppRow" >
	<%
	for(OAuthMobileAppName app :apps){
		List<OAuthMobileDevices> devices = app.getOAuthMobileDevicesList();
		%>
		<div class="mobileAppName" >
		<%=app.getMobileAppName() %>
		</div>
		<div class="mobileAppCatagory">
		<%
		for(OAuthMobileDevices device : devices){
			%>
        		<div class="appColumn"><%=IAMEncoder.encodeHTML(device.getOauthClientId()) %></div>
                <div class="appColumn"><%=IAMEncoder.encodeHTML(device.getPackageName())%></div>
                <div class="appColumn"><%=IAMEncoder.encodeHTML(MobileDevicesType.getDeviceType(device.getAppType()).name())%></div>
                <div class="appColumn"><%=IAMEncoder.encodeHTML(MobileClientTypes.getMobileClientType(device.getClientType()).name())%></div>
                <div class="apikey apikeyaction">
                    <div class="Hbtn">
                        <div class="savebtn" onclick="loadui('/ui/admin/mobileregistration.jsp?t=editMobileApp&client_id=<%=device.getOauthClientId()%>');  initSelect2();"><%--  NO OUTPUTENCODING--%> 
                            <span class="cbtnlt"></span>
                            <span class="cbtnco">Edit</span> <%-- No I18N --%>
                            <span class="cbtnrt"></span>
                        </div>
                        <br>
                        <div class="savebtn" onclick='showSyncWindow("mobileapp","<%=ser.getServiceName()%>","<%=device.getOauthClientId()%>", "<%=loc%>")'> <%-- NO OUTPUTENCODING --%>
        					<span class="cbtnlt"></span>
	            			<span class="cbtnco">Sync</span> <%--No I18N--%>
    	        			<span class="cbtnrt"></span>
        				</div>
                    </div>
                </div>
			
			<%
		}
		%>
		</div>
		<%
	}
	%>
	</div>
	</div>
	<%
	}
	}
	%>
	</div>
	</div>
<%--
=============================================================
@@@@ Show all mobile apps category @@@@ 
--%>
	<div id="showAppCategory" style="display:none;">
	<div class="Hcbtn topbtn">
	  	<div class="addnew" onclick="loadui('/ui/admin/mobileregistration.jsp?t=addNewMobileCategory'); initSelect2();">
			<span class="cbtnlt"></span>
			<span class="cbtnco">Add New Mobile Category</span>  <%--No I18N--%>
			<span class="cbtnrt"></span>
		</div>
	</div>
	<br>
	<div class="apikeyheader" id="headerdiv">
		<div class="apikeytitle" style="width:10%;">Service Name</div>  <%--No I18N--%>
		<div class="apikeytitle" style="width:10%;">App Name</div>  <%--No I18N--%>
		<div class="apikeytitle" style="width:10%;">App Type</div>  <%--No I18N--%>
	    <div class="apikeytitle" style="width:15%;">DisplayName</div>  <%--No I18N--%>
	    <div class="apikeytitle">Actions</div> <%--No I18N--%>
	</div>
	<%
	if(services != null){
	for(OAuthMobileAppService ser : services){
		if(Util.isDevelopmentSetup() && isIAMServiceAdmin) {
			if(!isUserAllowedServices.contains(ser.getServiceName().toLowerCase())) {
				continue;
			}
		}
		OAuthMobileAppName[] apps = (OAuthMobileAppName[]) OAuthResource.getOAuthMobileAppNameURI(ser.getServiceName()).GETS();
		if(apps == null){
			continue;
		}
	%>
	
	 <div class="content1" id="overflowdiv">
	 <% for(OAuthMobileAppName app : apps){%>
	 <div class="apikeycontent">
	 	<div class="apikey" style="width:10%;"><%=ser.getServiceName() %></div>`
	 	<div class="apikey" style="width:10%;"><%=app.getMobileAppName() %></div>
	 	<div class="apikey" style="width:10%;"><%=MobileAppType.getMobileAppType(app.getAppType()).name() %></div>
	 	<div class="apikey" style="width:15%;"><%=app.getDisplayName() %></div>
	 	<div class="apikey apikeyactionOauth">
        	<div class="savebtn" onclick="loadui('/ui/admin/mobileregistration.jsp?t=editMobileAppCategory&serviceName=<%=ser.getServiceName()%>&appName=<%=IAMEncoder.encodeJavaScript(app.getMobileAppName())%>'); initSelect2();"> <%-- NO OUTPUTENCODING --%>
        		<span class="cbtnlt"></span>
	            <span class="cbtnco">Edit</span> <%--No I18N--%>
    	        <span class="cbtnrt"></span>
        	</div>
        	<div class="savebtn" onclick='showSyncWindow("mobileappcategory","<%=ser.getServiceName()%>","<%=app.getMobileAppName()%>", "<%=loc%>")'> <%-- NO OUTPUTENCODING --%>
        		<span class="cbtnlt"></span>
	            <span class="cbtnco">Sync</span> <%--No I18N--%>
    	        <span class="cbtnrt"></span>
        	</div>
        </div>
        <div class="clrboth"></div>
	 </div>
	<%
	}
	 %>
	</div>
	<%
	}
	}
	%>
	</div>
	<div id="myModal" class="modal">
		<div class="modal-content">
		<div style="margin-bottom: 10px;"> Select a DC to Sync to: </div><%-- No I18N --%>
		<div class="modal-innertag" id="modal-innertag"></div>
  		</div>
  		</div>
	<%
}
//=============================================================
//			@@@@Add new Mobile App @@@@

else if(type.equals("addNewMobileApp")){
	OAuthMobileAppService[] services = (OAuthMobileAppService[])OAuthResource.getOAuthMobileAppServiceURI().addSubResource(OAUTHMOBILEAPPNAME.table()).GETS();
	if(services == null){
		out.println("No services configured");//No I18N
		%>
		<div class="Hcbtn topbtn">
	  	<div class="addnew" onclick="loadui('/ui/admin/mobileregistration.jsp?t=addNewMobileCategory'); initSelect2();">
			<span class="cbtnlt"></span>
			<span class="cbtnco">Configure Mobile Category</span>  <%--No I18N--%>
			<span class="cbtnrt"></span>
		</div>
	</div>
		<%
		return;
	}
	JSONObject servToApp = new JSONObject();
	for(OAuthMobileAppService s : services){
		if(Util.isDevelopmentSetup() && isIAMServiceAdmin) {
			if(!isUserAllowedServices.contains(s.getServiceName().toLowerCase())) {
				continue;
			}
		}
		JSONArray app = new JSONArray();
		for(OAuthMobileAppName appName : s.getOAuthMobileAppNameList()){
			app.put(appName.getMobileAppName());
		}
		servToApp.put(s.getServiceName(), app);
	}
	%>
		<form name="addMobileApp" id="addMobileApp" class="zform" method="post" onsubmit="return configureNewMobileApp(this);">
			<div class="labelkey">Service Name: </div> <%--No I18N--%>
			<div class="selectablebox">
				<select name="serviceName" class="select select2Div" onchange='setAppName(this,<%=servToApp%>)'>
				<option value='null'>Select an option</option><%-- No I18N --%>
				<% for(OAuthMobileAppService s : services){
					if(Util.isDevelopmentSetup() && isIAMServiceAdmin) {
						if(!isUserAllowedServices.contains(s.getServiceName().toLowerCase())) {
							continue;
						}
					}
					%>
					<option value='<%=IAMEncoder.encodeHTML(s.getServiceName())%>'><%=IAMEncoder.encodeHTML(s.getServiceName()) %></option>
				<%} %>
				</select>
			</div>
			<div class="labelkey">App Name: </div> <%--No I18N--%>
			<div style="font-size: 13px">
				<select name="appName" class="select select2Div" id="appName" placeholder="Without spaces"></select>
			</div>
			<div class="labelkey">Package Name:</div><%--No I18N--%>
			<div class="labelvalue"><input type="text" class="input" name="packageName"/></div>
			<div class="labelkey">Client Type:</div><%--No I18N--%>
			<div class="selectablebox">
				<select name="clientType" class="select select2Div">
					<% for(MobileClientTypes clientType : MobileClientTypes.values()){ %>
					<option value='<%=clientType.getType() %>'><%=clientType.name() %></option>
					<%} %>
				</select>
			</div>
			<div class="labelkey">App Type:</div><%--No I18N--%>
			<div class="selectablebox">
				<select name="mobileappType" class="select select2Div" onchange="return changeMobileDetails(this);">
					<% for(MobileDevicesType deviceType : MobileDevicesType.values()) {%>
					<option value='<%=IAMEncoder.encodeHTML(String.valueOf(deviceType.ordinal()))%>'><%=IAMEncoder.encodeHTML(deviceType.name()) %></option>
					<%} %>
				</select>
			</div>
			<div class="labelkey">Signature:</div><%--No I18N--%>
			<div class="labelvalue"><input type="text" class="input" name="signature"/></div>
			<div class="labelkey">Url Scheme:</div><%--No I18N--%>
			<div class="labelvalue"><input type="text" class="input" name="urlScheme"/></div>
			<div id="android_select" style="display: none;">
				<div class="labelkey">App Client Id:</div><%--No I18N--%>
				<div class="labelvalue"><input type="text" class="input" name="appClientId"/></div>
				<div class="labelkey">Project Id:</div><%--No I18N--%>
				<div class="labelvalue"><input type="text" class="input" name="projectId"/></div>
				<div class="labelkey">Audience Id:</div><%--No I18N--%>
				<div class="labelvalue"><input type="text" class="input" name="audienceId"/></div>
			</div>
			<div class="accbtn Hbtn">
		    	<div class="savebtn" onclick="configureNewMobileApp(document.addMobileApp); initSelect2();">
				<span class="btnlt"></span>
				<span class="btnco">Add</span>  <%--No I18N--%>
				<span class="btnrt"></span>
		    	</div>
		    	<div onclick="loadui('/ui/admin/mobileregistration.jsp?t=view'); initSelect2();">
				<span class="btnlt"></span>
				<span class="btnco">Cancel</span>  <%--No I18N--%>
				<span class="btnrt"></span>
		    	</div>
			</div>
			<input type="submit" class="hidesubmit" />
		</form>
		<div id="clientresponse">
		<div class="labelkey">Response: </div>	<%--No I18N--%>
		<div class="labelvalue">
			<textarea id="clientId" readonly style="font-size:10px;background-color:#BDBDBD" name="response" rows="10" cols="50"></textarea>
		</div>
		</div>
	
	<%
}
//=============================================================
//@@@@ Edit Mobile App Category @@@@
else if(type.equalsIgnoreCase("editMobileApp")){
	String clientId = request.getParameter("client_id");
	OAuthMobileDetails mobileDetails = OAuthMobileSSOUtil.getAppDetails(clientId);
	if(Util.isDevelopmentSetup() && isIAMServiceAdmin) {
		if(!isUserAllowedServices.contains(mobileDetails.getAppService().toLowerCase())) {
			out.print("Not Allowed to view for "+mobileDetails.getAppService()); //No I18N
			return;
		}
	}
	if(mobileDetails == null){
		out.println("No such client");//No I18N
		return;
	}
	%>
	<form name="editMobileApp" id="editMobileApp" class="zform" method="post" onsubmit="return updateMobileApp(this);">
			<div class="labelkey">Service Name: </div> <%--No I18N--%>
			<div class="labelvalue"><input type="text" class="input" name="serviceName" value="<%=mobileDetails.getAppService()%>" disabled="disabled"/></div>
			<div class="labelkey">App Name: </div> <%--No I18N--%>
			<div class="labelvalue"><input type="text" class="input" name="appName" value="<%=mobileDetails.getAppName()%>" disabled="disabled"/></div>
			<div class="labelkey">Client Id: </div> <%--No I18N--%>
			<div class="labelvalue"><input type="text" class="input" name="client_id" value="<%=mobileDetails.getDevice().getOauthClientId()%>" disabled="disabled"/></div>
			<div class="labelkey">Package Name:</div><%--No I18N--%>
			<div class="labelvalue"><input type="text" class="input" name="packageName" value="<%=mobileDetails.getDevice().getPackageName()%>"/></div>
			<div class="labelkey">Client Type:</div><%--No I18N--%>
			<div class="selectablebox">
				<select name="clientType" class="select select2Div">
					<% for(MobileClientTypes clientType : MobileClientTypes.values()){ %>
					<option value='<%=clientType.getType() %>' <%if(mobileDetails.getDevice().getClientType() == clientType.getType()){%> selected="selected" <%}%>><%=clientType.name() %></option>
					<%} %>
				</select>
			</div>
			<div class="labelkey">App Type:</div><%--No I18N--%>
			<div class="selectablebox">
				<select name="mobileappType" class="select select2Div" onchange="return changeMobileDetails(this);">
					<% for(MobileDevicesType deviceType : MobileDevicesType.values()) {%>
					<option value='<%=IAMEncoder.encodeHTML(String.valueOf(deviceType.ordinal()))%>' <%if(mobileDetails.getDevice().getAppType() == deviceType.getDeviceOrdinal()){%> selected="selected" <%}%>><%=IAMEncoder.encodeHTML(deviceType.name()) %></option>
					<%} %>
				</select>
			</div>
			<div class="labelkey">Signature:</div><%--No I18N--%>
			<div class="labelvalue"><input type="text" class="input" name="signature" value="<%=mobileDetails.getDevice().getSignature()%>"/></div>
			<div class="labelkey">Url Scheme:</div><%--No I18N--%>
			<div class="labelvalue"><input type="text" class="input" name="urlScheme" value="<%=mobileDetails.getRedirectUrl()%>"/></div>
			<div id="android_select" <%if(mobileDetails.getDevice().getAppType() != 1){%>style="display: none;"<%} %>>
				<div class="labelkey">App Client Id:</div><%--No I18N--%>
				<div class="labelvalue"><input type="text" class="input" name="appClientId" value="<%=mobileDetails.getDeviceDetails() != null ? mobileDetails.getDeviceDetails().getAppClientId() : ""%>"/></div>
				<div class="labelkey">Project Id:</div><%--No I18N--%>
				<div class="labelvalue"><input type="text" class="input" name="projectId" value="<%=mobileDetails.getDeviceDetails() != null ? mobileDetails.getDeviceDetails().getProjectId() : ""%>"/></div>
				<div class="labelkey">Audience Id:</div><%--No I18N--%>
				<div class="labelvalue"><input type="text" class="input" name="audienceId" value="<%=mobileDetails.getDeviceDetails() != null ? mobileDetails.getDeviceDetails().getAudienceId() : ""%>"/></div>
			</div>
			<div class="accbtn Hbtn">
		    	<div class="savebtn" onclick="updateMobileApp(document.editMobileApp); initSelect2();">
				<span class="btnlt"></span>
				<span class="btnco">Update</span>  <%--No I18N--%>
				<span class="btnrt"></span>
		    </div>
		    <div onclick="loadui('/ui/admin/mobileregistration.jsp?t=view'); initSelect2();">
				<span class="btnlt"></span>
				<span class="btnco">Cancel</span>  <%--No I18N--%>
				<span class="btnrt"></span>
		    </div>
		</div>
		</form>
	<%
	
}
//=============================================================
//			@@@@Add new Mobile App Category @@@@
else if( type.equalsIgnoreCase("addNewMobileCategory")){
	%>
		<br>
		<form name="addMobileCategory" id="addMobileCategory" class="zform" method="post" onsubmit="return addNewMobileCategory(this);">
			<div>
				<div class="labelkey">Service Name: </div> <%--No I18N--%>
				<div class="selectablebox">
					<select name="serviceName" class="select select2Div">
					<% for(Service s : ss){
						if(Util.isDevelopmentSetup() && isIAMServiceAdmin) {
							if(!isUserAllowedServices.contains(s.getServiceName().toLowerCase())) {
								continue;
							}
						}
						%>
						<option value='<%=IAMEncoder.encodeHTML(s.getServiceName())%>'><%=IAMEncoder.encodeHTML(s.getServiceName()) %></option>
					<%} %>
					</select>
				</div>
			</div>
			<div class="labelkey">Mobile App Name: </div> <%--No I18N--%>
			<div class="labelvalue"><input type="text" class="input" name="mobileAppName"/></div>
			<div class="labelkey">Display Name:</div><%--No I18N--%>
			<div class="labelvalue"><input type="text" class="input" name="displayName"/></div>
			<div class="labelkey">Description:</div><%--No I18N--%>
			<div class="labelvalue"><input type="text" class="input" name="description"/></div>
			<div class="labelkey">App Logo:</div><%--No I18N--%>
			<div class="labelvalue"><input type="text" class="input" name="appLogo"/></div>
			<div class="labelkey">MobileAppType:</div><%--No I18N--%>
			<div class="selectablebox">
				<select name="mobileappType" class="select select2Div">
					<% for(MobileAppType appType : MobileAppType.values()) {%>
					<option value='<%=IAMEncoder.encodeHTML(String.valueOf(appType.getType()))%>'><%=IAMEncoder.encodeHTML(appType.name()) %></option>
					<%} %>
				</select>
			</div>
			<div class="accbtn Hbtn">
		    	<div class="savebtn" onclick="addNewMobileCategory(document.addMobileCategory);initSelect2();">
				<span class="btnlt"></span>
				<span class="btnco">Add</span>  <%--No I18N--%>
				<span class="btnrt"></span>
		    </div>
		    <div onclick="loadui('/ui/admin/mobileregistration.jsp?t=view'); initSelect2();">
				<span class="btnlt"></span>
				<span class="btnco">Cancel</span>  <%--No I18N--%>
				<span class="btnrt"></span>
		    </div>
		</div>
		</form>
	<%
}
//============================================================
//			@@@@ Edit Mobile App Category @@@@
else if(type.equalsIgnoreCase("editMobileAppCategory")){
	String appName = request.getParameter("appName");
	String serviceName = request.getParameter("serviceName");
	if(Util.isDevelopmentSetup() && isIAMServiceAdmin) {
		if(!isUserAllowedServices.contains(serviceName.toLowerCase())) {
			out.print("Not Allowed to edit for "+serviceName); //No I18N
			return;
		}
	}
	OAuthMobileAppName app = OAuthResource.getOAuthMobileAppNameURI(serviceName, appName).GET();
	if(app == null){
		out.println("No Such App");//No I18N
	}
	%>
		<form name="editMobileCategory" id="editMobileCategory" class="zform" method="post" onsubmit="return editMobileAppCategory(this);">
			<div class="labelkey">Service Name: </div> <%--No I18N--%>
			<div class="labelvalue"><input type="text" class="input" name="serviceName" value="<%=serviceName %>" disabled/></div>
			<div class="labelkey">Mobile App Name: </div> <%--No I18N--%>
			<div class="labelvalue"><input type="text" class="input" name="mobileAppName" value="<%=appName %>" disabled/></div>
			<div class="labelkey">Display Name:</div><%--No I18N--%>
			<div class="labelvalue"><input type="text" class="input" name="displayName" value="<%=app.getDisplayName()%>"/></div>
			<div class="labelkey">Description:</div><%--No I18N--%>
			<div class="labelvalue"><input type="text" class="input" name="description" value="<%=app.getDescription()%>"/></div>
			<div class="labelkey">App Logo:</div><%--No I18N--%>
			<div class="labelvalue"><input type="text" class="input" name="appLogo" value="<%=app.getAppLogo()%>"/></div>
			<div class="labelkey">MobileAppType:</div><%--No I18N--%>
			<div class="selectablebox">
			<select name="mobileappType" class="select select2Div">
				<% for(MobileAppType appType : MobileAppType.values()) {%>
				<option value='<%=IAMEncoder.encodeHTML(String.valueOf(appType.getType()))%>' <% if(appType.getType() == app.getAppType()) {out.println("selected");}%>><%=IAMEncoder.encodeHTML(appType.name()) %></option>
				<%} %>
			</select>
			</div>
			<div class="accbtn Hbtn">
		    	<div class="savebtn" onclick="editMobileAppCategory(document.editMobileCategory); initSelect2();">
				<span class="btnlt"></span>
				<span class="btnco">Update</span>  <%--No I18N--%>
				<span class="btnrt"></span>
		    </div>
		    <div onclick="loadui('/ui/admin/mobileregistration.jsp?t=view'); initSelect2();">
				<span class="btnlt"></span>
				<span class="btnco">Cancel</span>  <%--No I18N--%>
				<span class="btnrt"></span>
		    </div>
		</div>
		</form>
	
	<% 
}
%>
</div>
</body>
</html>