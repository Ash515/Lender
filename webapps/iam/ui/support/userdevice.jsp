<%-- $Id$ --%>
<%@page import="com.zoho.accounts.AccountsProto.Account.User.OneAuthPreference"%>
<%@page import="com.zoho.accounts.internal.util.AccountsInternalConst"%>
<%@page import="com.zoho.accounts.AccountsProto.Account.User.UserDevice"%>
<%@page import="com.zoho.accounts.Accounts"%>
<%@ include file="includes.jsp" %>
<div class="maincontent">
    <div class="menucontent">
		<div class="topcontent"><div class="contitle">User Device</div></div><%--No I18N--%>
		<div class="subtitle">Support Services</div><%--No I18N--%>
    </div>    
    
    <%
		String zuid = request.getParameter("zuid");
		User user = null;
		if (zuid != null) {
			user = Util.USERAPI.getUserFromZUID(zuid);
		}
	%>


	<div class="field-bg">
		<div id="zuiddiv">
			<form method="post" class="zform" onsubmit='return getUserDevices(this);' name="userdevice">
				<div class="labelkey">Enter Zuid :</div><%--No I18N--%>
				<div class="labelvalue">
					<input type="text" class="input" id="zuid" name="zuid" placeholder="Zuid" value='<%=IAMEncoder.encodeHTMLAttribute(zuid != null ? zuid : "")%>'>
				</div>
				<div class="accbtn Hbtn">
					<div class="savebtn" onclick="getUserDevices(document.userdevice)">
						<span class="btnlt"></span> 
						<span class="btnco">Fetch Details</span><%--No I18N--%>
						<span class="btnrt"></span>
					</div>
				</div>
			</form>
		</div>


	<%
		if (user != null && zuid != null) {
	%>
		<%
			UserDevice[] devices = Accounts.getUserDeviceURI(user.getZaid(), user.getZuid()).GETS();
			if(devices != null && devices.length > 0) {
				OneAuthPreference pref = Accounts.getOneAuthPreferenceURI(user.getZaid(), user.getZuid()).GET();
		%> 
			<div id="userdeviceinfo" style="padding-top:100px;">
				<table class="orgpolicy_details" style="margin: 8px 0px 8px 20px; width:90%;" cellpadding="4" border="1" width="100%">
					<tr>
						<td class="usrinfoheader">Device Name</td> <%--No I18N--%>
						<td class="usrinfoheader">Device Type</td> <%--No I18N--%>
						<td class="usrinfoheader">Is Primary</td> <%--No I18N--%>
						<td class="usrinfoheader">Model</td> <%--No I18N--%>
						<td class="usrinfoheader">OS Version</td> <%--No I18N--%>
						<td class="usrinfoheader">One Auth Version</td> <%--No I18N--%>
						<td class="usrinfoheader">Is Restricted</td> <%--No I18N--%>
						<td class="usrinfoheader"></td>
					</tr>
					<%
						for(UserDevice device : devices) {
					%>
						<tr>
							<td><%=device.getDeviceName() %></td>
							<td><%=AccountsInternalConst.MobileDevicesType.getDeviceType(device.getDeviceType()).name() %></td>
							<td><%=device.getIsPrimary() %></td>
							<td><%=device.getDeviceInfo() %></td>
							<td><%=device.getDeviceOsVersion() %> </td>
							<%
								String version = device.getAppVersion();
								boolean isRestriced = device.getIsLocked();
								if(!IAMUtil.isValid(version)) {
									version = "1";
									if(pref != null) {
										isRestriced = pref.getRestrictSignin();
									}
								}
							%>
							<td><%=version %></td>
							<td>
								<div class="togglebtn_div">
									<input class="real_togglebtn suscription_radio" id="<%=device.getDeviceTokenApl()%>" <%=isRestriced ? "checked" : ""%> onchange="updateDevice(<%=user.getZuid() %>, '<%=device.getDeviceTokenApl()%>','restrict','<%=!isRestriced %>')" type="checkbox">
									<div class="togglebase">
										<div class="toggle_circle"></div>							
									</div>
								</div>
							</td>
							<td>
								<div class="savebtn" onclick="updateDevice(<%=user.getZuid() %>, '<%=device.getDeviceTokenApl()%>','delete')">
									<span class="cbtnlt"></span> 
									<span class="cbtnco">Delete</span><%--No I18N--%>
									<span class="cbtnrt"></span>
								</div>
							</td>
						</tr>
					<%
						}
					%>
				</table>
			</div>
		<% 
			}
			else {
		%>
			<div class="nosuchusr">
				<p align="center">No Devices configured </p><%--No I18N--%>
			</div>
		<%
			}
		%>
	
	<%
		}else if(zuid!=null && user==null){
	%>
	<div class="nosuchusr">
		<p align="center">No Such User </p><%--No I18N--%>
	</div>
	<%
		}
	%>
	</div>
</div>