<%--$Id$ --%>
<%@page import="com.zoho.accounts.SystemResource.DCLocationURI"%>
<%@page import="com.zoho.accounts.SystemResourceProto.DCLocation"%>
<%@page import="com.zoho.accounts.SystemResourceProto.DCLocation"%>
<%@page import="com.zoho.accounts.SystemResource"%>
<%@page import="com.zoho.accounts.SystemResourceProto.DCLocation"%>
<%@page import="com.zoho.accounts.AppResource.CacheClusterURI"%>
<%@page import="com.zoho.accounts.AppResource"%>
<%@page import="com.zoho.accounts.AppResourceProto.CacheCluster"%>
<%@ include file="../../../static/includes.jspf" %>
<%@ include file="../includes.jsp"%>
<style>
.addbut{
	float:right;
	color:green;
}
#listdiv,#adddiv{
	font-size: 10px;
	margin:10px auto 0px;
	width: 99%;
}
input[disabled="disabled"]{
	background: transparent;
	border: 0px solid transparent;
	color:black;
	text-align: center;
}
td{
	padding:10px;

}
th{
	background: url("../images/common-bg.gif") repeat-x scroll 0 -385px transparent;
	padding-bottom:10px;
}
.hide{
	display:none;
}
table{
border-collapse:collapse;
width:100%;
text-align: center;
}
</style>
<div class="maincontent">
    <div class="menucontent">
	<div class="topcontent"><div class="contitle" id="restoretitle">DC Location Admin</div></div> <%--No I18N--%>
	<div class="subtitle">Admin Services<button class="addbut hide" onclick='addCluster()'><- Back</button> <button class="addbut" onclick='addCluster()'>Add</button> <button class="addbut" onclick='addLink()'>Link</button> </div> <%--No I18N--%>
    </div>
    
    <div id='listdiv'>
    	<table cols=5>
    	<tr><th>DC Location</th><th>URL</th><th>Description</th><th>Public Key</th><th>Delete</th></tr><%--No I18N--%>
    	<%
    	DCLocationURI uri = SystemResource.getDCLocationURI();
    	DCLocation[] locationList = uri.GETS();
    	if(locationList!=null){
    	for(DCLocation location:locationList){%>
    	<tr>
    	<td><%=IAMEncoder.encodeHTML(location.getLocation())%></td>
		<td><%=IAMEncoder.encodeHTML(location.getServerUrl())%></td>
		<td><%=IAMEncoder.encodeHTML(location.getDescription())%></td>
		<td><form method="get" action="/admin/dclocation/download?location=<%=IAMEncoder.encodeJavaScript(location.getLocation())%>"><button type="submit">Download</button></form></td><%--No I18N--%>
    	<td><button onclick='deleteLocation("<%=IAMEncoder.encodeJavaScript(location.getLocation())%>")'>Delete</button></td><%--No I18N--%>
    	</tr>
    	<%}
    	}else{
    	%>
    	<tr><td colspan="5">No DC config found maybe add a new one?</td></tr><%--No I18N--%>
    	<%
    	}%>
    	</table>
    </div>
    <div id='adddiv' class='hide'>
    <div id="headerdiv">&nbsp;</div>
    	<div id="overflowdiv">	
		<form name="locationform"  method="POST">
		<div class="labelmain">
			<div class="labelkey"> Location : </div> <%-- No I18N --%>
			<div class="labelvalue"><input type="text" name="location" class="input"/></div>
			
			<div class="labelkey"> URL : </div> <%-- No I18N --%>
			<div class="labelvalue"><input type="text" name="url" class="input"/></div>
				
			<div class="labelkey"> User Readable Location : </div> <%-- No I18N --%>
			<div class="labelvalue"><input type="text" name="uloc" class="input"/></div>
				
			<div class="labelkey"> BaseDomain : </div> <%-- No I18N --%>
			<div class="labelvalue"><input type="text" name="bd" class="input"/></div>
			
			<div class="labelkey"> Equivalent BaseDomains : </div> <%-- No I18N --%>
			<div class="labelvalue"><input type="text" name="ebd" class="input"/></div>
			
			<div class="labelkey"> Is Prefixed : </div> <%-- No I18N --%>
			<div class="labelvalue"><input type="checkbox" name="ipfx" class="input"/></div>
					
			<div class="accbtn Hbtn">
				<div class="savebtn" onclick="postLocation(locationform)">
					<span class="btnlt"></span>
					<span class="btnco">Add</span> <%-- No I18N --%>
					<span class="btnrt"></span>
				</div>
				
				<div onclick="loadui('/ui/admin/dclocation/dclocations.jsp');">
					<span class="btnlt"></span>
					<span class="btnco">Cancel</span> <%-- No I18N --%>
					<span class="btnrt"></span>
				</div>
		 </div>
		</div>
	</form>
	</div>
    </div>
    
    <div id='ladddiv' class='hide'>
    <div id="lheaderdiv">&nbsp;</div>
    	<div id="loverflowdiv">	
		<form name="linkaddform"  method="POST">
		<div class="labelmain">
			<div class="labelkey"> Entity Name : </div> <%-- No I18N --%>
			<div class="labelvalue"><input type="text" name="ename" class="input"/></div>
			
			<div class="labelkey"> Location : </div> <%-- No I18N --%>
			<div class="labelvalue"><input type="text" name="location" class="input"/></div>
			
			<div class="labelkey"> Original Domain : </div> <%-- No I18N --%>
			<div class="labelvalue"><input type="text" name="od" class="input"/></div>
				
			<div class="labelkey"> Transformed Domain : </div> <%-- No I18N --%>
			<div class="labelvalue"><input type="text" name="td" class="input"/></div>
			
			<div class="accbtn Hbtn">
				<div class="savebtn" onclick="postLink(linkaddform)">
					<span class="btnlt"></span>
					<span class="btnco">Add</span> <%-- No I18N --%>
					<span class="btnrt"></span>
				</div>
				
				<div onclick="loadui('/ui/admin/dclocation/dclocations.jsp');">
					<span class="btnlt"></span>
					<span class="btnco">Cancel</span> <%-- No I18N --%>
					<span class="btnrt"></span>
				</div>
		 </div>
		</div>
	</form>
	</div>
    </div>
    
    
</div>