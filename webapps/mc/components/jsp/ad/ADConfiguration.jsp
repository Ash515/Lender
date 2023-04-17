<%-- $Id$ --%>
<%@ page import = "com.adventnet.ds.query.*, com.adventnet.persistence.*,com.adventnet.client.util.*, java.util.*"%>
<%@include file='/framework/jsp/StatusMsg.jspf'%>
<%@include file='/components/jsp/CommonIncludes.jspf'%>
<%
DataObject dataObject = (DataObject) request.getAttribute("AD_DETAILS");	
String serverName = "";
String domainName = "";
String userName = "";
boolean isNew = true;
if(dataObject != null && dataObject.containsTable("ActiveDirectoryInfo")){
	Row row = dataObject.getFirstRow("ActiveDirectoryInfo");	
	serverName = (String) row.get("SERVERNAME");
	userName = (String) row.get("USERNAME");
	domainName = (String) row.get("DEFAULTDOMAIN");
	isNew = false;
}

String aaSelected = (String) request.getAttribute("AAASelected");
String adSelected = (String) request.getAttribute("ADSelected");
%>

<form name="ADConfiguration">

	<table class="formTable" cellspacing="0">
		<tr>
			<td class="FieldNameClass"> AD Server Name </td>
			<td class="FormElementClass">
				<input type="text" name="serverName" displayname='Server Name' isnullable='true' validatemethod='isNotEmpty' id='AdServer' errormsg="Server Name cannot be null" value="<%=IAMEncoder.encodeHTMLAttribute(serverName)%>">
			</td>
		</tr>
		<tr>
			<td class="FieldNameClass">Domain Name</td>
			<td class="FormElementClass"><input type="text" name="domainName" value="<%=IAMEncoder.encodeHTMLAttribute(domainName)%>"></td>
		</tr>
		<tr>
			<td class="FieldNameClass">User Name</td>
			<td class="FormElementClass"><input type="text" name="userName" value="<%=IAMEncoder.encodeHTMLAttribute(userName)%>"></td>
		
		</tr>
		<tr>
			<td class="FieldNameClass">Password</td>
			<td class="FormElementClass"><input type="password" name="password"</td>
		</tr>
		<tr>
			<td colspan="2" align="center" class="ButtonPanelClass">
				<%
				if(!isNew){
				%>
				<input type="hidden" name="AD_ID" value='<%=IAMEncoder.encodeHTMLAttribute(request.getParameter("AD_ID"))%>'>
				<input type="submit" name="submit" value="Save" class='btn'>
				<%
				}
				else
				{
				%>
					<input type="submit" name="submit" value="Add" class="btn">
				<%
				}
				%>
			</td>
		</tr>				
	</table>
</form>
