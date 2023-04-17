<%--$Id$--%>
<%@page import="com.zoho.accounts.AppResourceProto.CacheCluster.ClusterNode.NodeRange"%>
<%@page import="com.zoho.accounts.AppResourceProto.CacheCluster.ClusterNode"%>
<%@page import="com.zoho.accounts.AppResource"%>
<%@page import="com.zoho.accounts.AppResource.ClusterNodeURI"%>
<%@ include file="../../../static/includes.jspf" %>
<%@ include file="../includes.jsp"%>
<%
String cluster = request.getParameter("cluster");//No I18N
ClusterNodeURI uri = AppResource.getClusterNodeURI(cluster);
uri.addSubResource("noderange");//No I18N
ClusterNode nodelist[] = uri.GETS();
%>
<style>
table{
	font-size: 10px;
	border-collapse:collapse;
	width:100%;
	vertical-align:middle;
}
.addbut{
	float:right;
	color:green;
}
li{
	list-style: none;
}
td{
	text-align: center;
	vertical-align: middle;
	padding:10px;
}

th{
	background: url("../images/common-bg.gif") repeat-x scroll 0 -385px transparent;
	padding-bottom:10px;
}
</style>
<div class="menuheader">Admin<br /></div>  <%--No I18N--%>
<div class="maincontent">
    <div class="menucontent">
	<div class="topcontent"><div class="contitle" id="restoretitle">Cluster Admin - <%=IAMEncoder.encodeHTML(cluster.toUpperCase())%> </div> </div> <%--No I18N--%>
	<div class="subtitle">Admin Services   <button class="addbut" onclick="loadui('/ui/admin/cluster/clusteradmin.jsp?op=view')">|^| Home</button> <button class="addbut hide" onclick='addCluster()'><- Back</button> <button class="addbut" onclick='addCluster()'>+ Add</button></div> <%--No I18N--%>
 </div>
    <div id="listdiv">
<table>
<tr><th>Node</th><th>Cache Type</th><th>Ip Port</th><th>Cache Props</th><th>Ranges</th><th>Edit</th><th>Delete</th></tr><%--No I18N--%>
<%
if(nodelist!=null){
for(ClusterNode node: nodelist){%>
	<tr>
	<td><%=IAMEncoder.encodeHTML(node.getNodeName())%></td>
	<td><%=IAMEncoder.encodeHTML(node.getCacheType()) %></td>
	<td><%=IAMEncoder.encodeHTML(node.getServerIpPort()) %></td>
	<td><%=IAMEncoder.encodeHTML(node.getCacheProperties())%></td>
	<td><ul>
	<%for(NodeRange r:node.getNodeRangeList()){%>
			<li>start : <%=IAMEncoder.encodeHTML(r.getStart()+"")%> end:<%=IAMEncoder.encodeHTML(r.getEnd()+"")%></li><%--No I18N--%>
		<%} %>
	</ul></td>
	<td><button onclick='loadui("/ui/admin/cluster/clusteredit.jsp?cluster=<%=IAMEncoder.encodeJavaScript(cluster)%>&node=<%=IAMEncoder.encodeJavaScript(node.getNodeName())%>");'>Edit</button></td><%--No I18N--%>
	<td><button  onclick='delNode("<%=IAMEncoder.encodeJavaScript(cluster)%>","<%=IAMEncoder.encodeJavaScript(node.getNodeName())%>")'>Delete</button></td><%--No I18N--%>
	</tr>
<%}
}else{%>
	<tr><td colspan="7">No nodes present maybe add a new one?</td></tr><%--No I18N--%>
<%}%>
</table>

</div>

<div id='adddiv' class='hide'>
    <div id="headerdiv">&nbsp;</div>
    	<div id="overflowdiv">	
		<form name="nodeform"  method="POST" onsubmit="return cachefromvalue(this)" >
		<div class="labelmain">
			<input type="hidden" value="<%=IAMEncoder.encodeHTMLAttribute(cluster)%>" name="cluster"/>
			<div class="labelkey"> NodeName : </div> <%-- No I18N --%>
			<div class="labelvalue"><input type="text" name="node" id="chackpool" class="input"/></div>
			
			<div class="labelkey"> CacheType : </div> <%-- No I18N --%>
			<div class="labelvalue"><input type="text" name="ctype" value="memcached"  class="input"/></div>
			
			<div class="labelkey">  ServerIpPort : </div> <%-- No I18N --%>
			<div class="labelvalue"><input type="text" name="serverip" id="chackserver"  class="input"/></div>
		
			<div class="labelkey" id="dwndiv"> CacheProperties :  </div> <%-- No I18N --%>
			<div class="labelvalue">
			<div  id="cprops">
				<div class="edipdiv">
            	  	<input type="text" class="input" placeholder="Key" />
            	    <input type="text" class="input" placeholder="Value"/>
            	    <span class="addEDicon hideicons chaceicon" onclick="addIcon(this)">&nbsp;</span>
       			</div>
       		</div>	
       		</div>
       		<div class="labelkey" id="dwndiv"> Ranges :  </div> <%-- No I18N --%>
			<div class="labelvalue">
			<div  id="cranges">
				<div class="edipdiv">
            	  	<input type="text" class="input" placeholder="Start" />
            	    <input type="text" class="input" placeholder="End"/>
            	    <span class="addEDicon hideicons chaceicon" onclick="addIcon(this)">&nbsp;</span>
       			</div>
       		</div>	
       		</div>
       		
			<div class="accbtn Hbtn">
				<div class="savebtn" onclick="postNode(nodeform,'add')">
					<span class="btnlt"></span>
					<span class="btnco">Add</span> <%-- No I18N --%>
					<span class="btnrt"></span>
				</div>
				
				<div onclick="loadui('/ui/admin/cluster/clusterview.jsp?op=view&cluster=<%=IAMEncoder.encodeJavaScript(cluster)%>');">
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
