<%--$Id$ --%>
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
	<div class="topcontent"><div class="contitle" id="restoretitle">Cluster Admin</div></div> <%--No I18N--%>
	<div class="subtitle">Admin Services<button class="addbut hide" onclick='addCluster()'><- Back</button> <button class="addbut" onclick='addCluster()'>+ Add</button></div> <%--No I18N--%>
    </div>
    
    <div id='listdiv'>
    	<table cols=5>
    	<tr><th>Cluster</th><th>Node Count</th><th>Sync</th><th>Sync (get)</th><th>Sync Cluster</th><th>View</th><th>Edit</th><th>Delete</th></tr><%--No I18N--%>
    	<%
    	CacheClusterURI uri = AppResource.getCacheClusterURI();
		uri.addSubResource("clusternode");//No I18N
    	CacheCluster[] clusterlist = uri.GETS();
    	if(clusterlist!=null){
    	for(CacheCluster cluster:clusterlist){
    	if(!cluster.hasSyncClusterName() || cluster.hasSyncClusterName()) {%>
    	<tr>
    	<td><%=IAMEncoder.encodeHTML(cluster.getClusterName())%></td>
		<td><%=IAMEncoder.encodeHTML(""+cluster.getClusterNodeCount())%></td>
    	<td><input class='editable rest <%=IAMEncoder.encodeHTMLAttribute(cluster.getClusterName()) %>' restname="sync" type='text' disabled="disabled" value="<%=IAMEncoder.encodeHTMLAttribute(""+cluster.getIsSyncEnabled()) %>"/></td>
    	<td><input class='editable rest <%=IAMEncoder.encodeHTMLAttribute(cluster.getClusterName()) %>' restname="syncget" type='text' disabled="disabled" value="<%=IAMEncoder.encodeHTMLAttribute(""+cluster.getIsSyncEnabledForGet()) %>"/></td>
    	<td><input class='editable rest <%=IAMEncoder.encodeHTMLAttribute(cluster.getClusterName()) %>' restname="syncname" value="<%=IAMEncoder.encodeHTMLAttribute(cluster.getSyncClusterName()) %>" type='text' disabled="disabled"/></td>
    	<td><button onclick='loadui("/ui/admin/cluster/clusterview.jsp?cluster=<%=IAMEncoder.encodeJavaScript(cluster.getClusterName())%>");'>View</button></td><%--No I18N--%>
    	<td><button id='editbutton' onclick="editToggle(this)" cluster="<%=IAMEncoder.encodeHTMLAttribute(cluster.getClusterName())%>">Edit</button></td><%--No I18N--%>
    	<td><button onclick='deleteCluster("<%=IAMEncoder.encodeJavaScript(cluster.getClusterName())%>")'>Delete</button></td><%--No I18N--%>
    	</tr>
    	<%}
    	}
    	}else{
    	%>
    	<tr><td colspan="8">No nodes present maybe add a new one?</td></tr><%--No I18N--%>
    	<%
    	}%>
    	</table>
    </div>
    <div id='adddiv' class='hide'>
    <div id="headerdiv">&nbsp;</div>
    	<div id="overflowdiv">	
		<form name="clusterform"  method="POST" onsubmit="return cachefromvalue(this)" >
		<div class="labelmain">
			<div class="labelkey"> ClusterName : </div> <%-- No I18N --%>
			<div class="labelvalue"><input type="text" name="cluster" id="chackpool" class="input"/></div>
			
			<div class="labelkey"> Sync Enabled : </div> <%-- No I18N --%>
			<div class="labelvalue"><input type="checkbox" name="sync"  id="sync"/></div>
			
			<div class="labelkey"> Sync (get) : </div> <%-- No I18N --%>
			<div class="labelvalue"><input type="checkbox" name="syncget"  id="syncget"/></div>
			
			<div class="labelkey"> Sync Server Name : </div> <%-- No I18N --%>
			<div class="labelvalue"><input type="text" placeholder="can leave blank" name="syncname"  id="syncname"/></div>
			
			<div class="accbtn Hbtn">
				<div class="savebtn" onclick="postCluster(clusterform)">
					<span class="btnlt"></span>
					<span class="btnco">Add</span> <%-- No I18N --%>
					<span class="btnrt"></span>
				</div>
				
				<div onclick="loadui('/ui/admin/cluster/clusteradmin.jsp?op=view');">
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