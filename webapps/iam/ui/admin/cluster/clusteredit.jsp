<%--$Id$ --%>
<%@page import="com.zoho.accounts.AppResourceProto.CacheCluster.ClusterNode.NodeRange"%>
<%@page import="com.zoho.accounts.AppResourceProto.CacheCluster.ClusterNode"%>
<%@page import="com.zoho.accounts.AppResource"%>
<%@page import="com.zoho.accounts.AppResource.ClusterNodeURI"%>
<%@ include file="../../../static/includes.jspf" %>
<%@ include file="../includes.jsp"%>
<%
String cluster = request.getParameter("cluster");//No I18N
String node = request.getParameter("node");//No I18N
ClusterNodeURI uri = AppResource.getClusterNodeURI(cluster,node);
uri.addSubResource("noderange");//No I18N
ClusterNode cnode = uri.GET();
%>
<style>
table{
	font-size: 10px;
	border-collapse:collapse;
	width:100%;
	vertical-align:middle;
}
.addnode{
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
	<div class="topcontent"><div class="contitle" id="restoretitle">Cluster Admin - <%=IAMEncoder.encodeHTML(cluster.toUpperCase())%> </div><button class="addnode" onclick='addCluster()'>+</button></div> <%--No I18N--%>
	<div class="subtitle">Admin Services</div> <%--No I18N--%>
 </div>
<%
if(cnode!=null){
%>
<div id='adddiv'>
    <div id="headerdiv">&nbsp;</div>
    	<div id="overflowdiv">	
		<form name="nodeform"  method="POST" onsubmit="return cachefromvalue(this)" >
		<div class="labelmain">
			<input type="hidden" value="<%=IAMEncoder.encodeHTMLAttribute(cluster)%>" name="cluster"/>
			<div class="labelkey"> NodeName : </div> <%-- No I18N --%>
			<div class="labelvalue"><input type="text" value="<%=IAMEncoder.encodeHTMLAttribute(cnode.getNodeName()) %>" name="node" id="chackpool" class="input"/></div>
			
			<div class="labelkey"> CacheType : </div> <%-- No I18N --%>
			<div class="labelvalue"><input type="text" value="<%=IAMEncoder.encodeHTMLAttribute(cnode.getCacheType()) %>" name="ctype" value="memcached"  class="input"/></div>
			
			<div class="labelkey">  ServerIpPort : </div> <%-- No I18N --%>
			<div class="labelvalue"><input type="text" required name="serverip" value="<%=IAMEncoder.encodeHTMLAttribute(cnode.getServerIpPort())%>" id="chackserver"  class="input"/></div>
			<div class="labelkey" id="dwndiv"> CacheProperties :  </div> <%-- No I18N --%>
			<div class="labelvalue">
			<div  id="cprops">
			<%String cprops = cnode.getCacheProperties();
			if(cprops!=null&&!cprops.isEmpty()){
			for(String prop : cprops.split(",")){
				String components[] = prop.split("=");
			%>
				<div class="edipdiv">
            	  	<input type="text" value="<%=IAMEncoder.encodeHTMLAttribute(components[0])%>" class="input" placeholder="Key" />
            	    <input type="text" value="<%=IAMEncoder.encodeHTMLAttribute(components[1])%>" class="input" placeholder="Value"/>
            	    <span class="addEDicon hideicons chaceicon" onclick="addIcon(this)">&nbsp;</span>
       			</div>
       		<%}}else{ %>
       			<div class="edipdiv">
            	  	<input type="text" class="input" placeholder="Key" />
            	    <input type="text" class="input" placeholder="Value"/>
            	    <span class="addEDicon hideicons chaceicon" onclick="addIcon(this)">&nbsp;</span>
       			</div>
       		<%}%>
       		</div>	
       		</div>
       		<div class="labelkey" id="dwndiv"> Ranges :  </div> <%-- No I18N --%>
			<div class="labelvalue">
			<div  id="cranges">
				<%
				if(cnode.getNodeRangeCount()>0){
					for(NodeRange r : cnode.getNodeRangeList()){%>
				<div class="edipdiv">
            	  	<input type="text" class="input" value="<%=IAMEncoder.encodeHTMLAttribute(r.getStart()+"") %>" placeholder="Start" />
            	    <input type="text" class="input" value = "<%=IAMEncoder.encodeHTMLAttribute(r.getEnd()+"")%>" placeholder="End"/>
            	    <span class="addEDicon hideicons chaceicon" onclick="addIcon(this)">&nbsp;</span>
       			</div>
       			<%}}else{%>
       				<div class="edipdiv">
            	  	<input type="text" class="input" placeholder="Start" />
            	    <input type="text" class="input" placeholder="End"/>
            	    <span class="addEDicon hideicons chaceicon" onclick="addIcon(this)">&nbsp;</span>
       			</div>
       			<%} %>
       		</div>	
       		</div>
       		
			<div class="accbtn Hbtn">
				<div class="savebtn" onclick="postNode(nodeform,'update')">
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

<%}%>