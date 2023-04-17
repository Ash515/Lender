<%-- $Id$ --%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@page import="com.zoho.accounts.AppResource"%>
<%@page import="com.zoho.accounts.AppResourceProto.App.Configuration"%>
<%@page import="com.zoho.accounts.AppResourceProto.App"%>
<%@ include file="../../static/includes.jspf"%>
<%@ include file="includes.jsp"%>
<%
	boolean isFirst = true;
	String app_name = request.getParameter("appname");
	isFirst = app_name != null ? false : true;
	
	if (isFirst) {
		app_name = "AaaServer";//NO I18N
	}
%>
<div class="maincontent">
	<div class="menucontent">
		<div class="topcontent">
			<div class="contitle">System Configuration</div><%--No I18N--%>
		</div>
		<div class="subtitle">Admin Services</div>
		<div style="margin:10px 0px 0px 6px;font-size:13px;">
			App Name : <select class="select select2Div" name="appname" id="appname" onchange="changeAppName(this,'/ui/admin/systemconfig.jsp')"><%--No I18N--%>
				<%
					for (Service s : ss) {
				%>
				<option value="<%=IAMEncoder.encodeHTMLAttribute(s.getServiceName())%>" <%if (app_name.equals(s.getServiceName())) {%> <%="selected"%> <%}%>><%=IAMEncoder.encodeHTML(s.getServiceName())%></option>
				<%
					}
				%>
			</select>

		</div>
	</div>

	<div class="field-bg">
		<div id="addsys" style="display: none;">
			<div>
				<b class="mrptop outbg"><b class="mrp1"></b><b class="mrp2"></b><b class="mrp3"></b><b class="mrp4"></b></b>
			</div>
			<div class="mrpheader">
				<span class="close" onclick="addsysconfigform('hide')"></span> <span>System Configuration</span>
				<%--No I18N--%>
			</div>
			<div class="mprcontent">
				<div>
					<b class="mrptop inbg"><b class="mrp2"></b><b class="mrp3"></b><b class="mrp4"></b></b>
				</div>
				<div class="mrpcontentdiv">
					<form class="zform" name="addsys" onsubmit="return addSysConfig(this)" method="post">
						<table cellspacing="5" cellpadding="0" border="0" width="100%">
							<tr>
								<td align="right" width="25%">Name :</td> <%--No I18N--%>
								<td><input type="text" class="input" name="addsysname" /></td>
							</tr>
							<tr>
								<td align="right">Value :</td> <%--No I18N--%>
								<td><input type="text" class="input" name="addsysvalue" /></td>
							</tr>
							<tr>
								<td align="right">RoValue :</td>
								<%--No I18N--%>
								<td><input type="text" class="input" name="addsysrovalue" /></td>
							</tr>
						</table>
						<div class="mrpBtn">
							<input type="submit" value="Add" /> <input type="button" value="Cancel" onclick="addsysconfigform('hide')" />
						</div>
					</form>
				</div>
				<div>
					<b class="mrpbot inbg"><b class="mrp4"></b><b class="mrp3"></b><b class="mrp2"></b></b>
				</div>
			</div>
			<div>
				<b class="mrpbot outbg"><b class="mrp4"></b><b class="mrp3"></b><b class="mrp2"></b><b class="mrp1"></b></b>
			</div>
		</div>

		<div id="sysview">
			<%
				Configuration[] appconfig = AppResource.getConfigurationURI(app_name).GETS();
				if (request.isUserInRole("IAMAdmininistrator") || request.isUserInRole("IAMSystemAdmin")) {
			%>
			<div class="Hcbtn topbtn" id="addnewbtn">
				<div class="addnew" onclick="addsysconfigform('show')">
					<span class="cbtnlt"></span> <span class="cbtnco">Add New</span> <span class="cbtnrt"></span>
				</div>
			</div>
			<%
				}
				if(appconfig != null){
			%>
			<div class="apikeyheader" id="headerdiv">
				<div class="systitle" style="width: 20%;">Name</div>
				<%--No I18N--%>
				<div class="systitle" style="width: 24%;">Value</div>
				<%--No I18N--%>
				<div class="systitle" style="width: 25%;">RoValue</div>
				<%--No I18N--%>
				<div class="sysbtn">Actions</div>
				<%--No I18N--%>
			</div>
			<div class="content1" id="overflowdiv">
				<%
							for (Configuration conf : appconfig) {
							String sysconfName = conf.getConfigName();
							String sysconfValue = conf.getConfigValue();
							String sysconfRoValue = conf.getConfigRoValue();
				%>
				<div class="apikeycontent">
					<div class="sysname" style="width: 20%;"><%=IAMEncoder.encodeHTML(sysconfName)%></div>
					<div class="sysname" style="width: 25%;"><%=IAMEncoder.encodeHTML(sysconfValue)%></div>
					<div class="sysname" style="width: 25%;"><%=IAMEncoder.encodeHTML(sysconfRoValue)%></div>
					<div class="sysbtn">
						<div class="Hbtn">
							<%
								if (request.isUserInRole("IAMAdmininistrator") || request.isUserInRole("IAMSystemAdmin")) {
							%>
							<div class="savebtn" onclick="de('updatesysname').value='<%=IAMEncoder.encodeJavaScript(sysconfName)%>';de('updatesysvalue').value='<%=IAMEncoder.encodeJavaScript(sysconfValue)%>';de('updatesysrovalue').value='<%=IAMEncoder.encodeJavaScript(sysconfRoValue)%>';updatesysconfigform('show');">
								<span class="cbtnlt"></span> <span class="cbtnco">Edit</span>
								<%--No I18N--%>
								<span class="cbtnrt"></span>
							</div>
							<div onclick="deleteSysConfig('<%=IAMEncoder.encodeJavaScript(sysconfName)%>')">
								<span class="cbtnlt"></span> <span class="cbtnco">Delete</span>
								<%--No I18N--%>
								<span class="cbtnrt"></span>
							</div>
							<%
								} else if (request.isUserInRole("IAMOperator")) {
							%>
							<div class="savebtn" onclick="de('updatesysname').value='<%=IAMEncoder.encodeJavaScript(sysconfName)%>';de('updatesysvalue').value='<%=IAMEncoder.encodeJavaScript(sysconfValue)%>';de('updatesysrovalue').value='<%=IAMEncoder.encodeJavaScript(sysconfRoValue)%>';updatesysconfigform('show');">
								<span class="cbtnlt"></span> <span class="cbtnco">Edit</span>
								<%--No I18N--%>
								<span class="cbtnrt"></span>
							</div>
							<%
								}
							%>
						</div>
					</div>
					<div class="clrboth"></div>
				</div>
				<%
						}
						out.println("</div>");
					}
				else{
				%>
				<dl class="emptyobjdl"><dd><p align="center" class="emptyobjdet">No Configuration(s) added</p></dd></dl>
				<%} %>
			</div>
		</div>
	</div>

	<div id="updatesys" style="display: none;">
		<div>
			<b class="mrptop outbg"><b class="mrp1"></b><b class="mrp2"></b><b class="mrp3"></b><b class="mrp4"></b></b>
		</div>
		<div class="mrpheader">
			<span class="close" onclick="updatesysconfigform('hide')"></span> <span>System Configuration</span>
			<%--No I18N--%>
		</div>
		<div class="mprcontent">
			<div>
				<b class="mrptop inbg"><b class="mrp2"></b><b class="mrp3"></b><b class="mrp4"></b></b>
			</div>
			<div class="mrpcontentdiv">
				<form name="updatesys" class="zform" onsubmit="return updateSysConfig(this)" method="post">
					<table cellspacing="5" cellpadding="0" border="0" width="100%">
						<tr>
							<td align="right">Name :</td>
							<%--No I18N--%>
							<td><input type="text" class="input" id="updatesysname" name="updatesysname" disabled /></td>
						</tr>
						<%
							if (request.isUserInRole("IAMAdmininistrator") || request.isUserInRole("IAMSystemAdmin")) {
						%>
						<tr>
							<td align="right">Value :</td>
							<%--No I18N--%>
							<td><input type="text" class="input" id="updatesysvalue" name="updatesysvalue" /></td>
						</tr>
						<tr>
							<td align="right">RoValue :</td><%--No I18N--%>
							<td><input type="text" class="input" id="updatesysrovalue" name="updatesysrovalue" /></td>
						</tr>
						<tr>
							<td align="right">Admin Password :</td><%--No I18N--%>
							<td><input type="password" class="input" name="pwd" /></td>
						</tr>
						<%
							} else if (request.isUserInRole("IAMOperator")) {
						%>
						<tr>
							<td align="right">Value :</td><%--No I18N--%>
							<td><textarea id="updatesysvalue" class="txtarea"></textarea></td>
						</tr>
						<tr>
							<td align="right">RoValue :</td><%--No I18N--%>
							<td><textarea id="updatesysrovalue" class="txtarea"></textarea></td>
						</tr>
						<%
							}
						%>
					</table>
					<%
						if (request.isUserInRole("IAMAdmininistrator") || request.isUserInRole("IAMSystemAdmin")) {
					%>
					<div class="mrpBtn">
						<input type="submit" value="Update" /> <input type="button" value="Cancel" onclick="updatesysconfigform('hide')" />
					</div>
					<%
						}
					%>
				</form>
			</div>
			<div>
				<b class="mrpbot inbg"><b class="mrp4"></b><b class="mrp3"></b><b class="mrp2"></b></b>
			</div>
		</div>
		<div>
			<b class="mrpbot outbg"><b class="mrp4"></b><b class="mrp3"></b><b class="mrp2"></b><b class="mrp1"></b></b>
		</div>
	</div>
</div>