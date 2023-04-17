<%-- $Id$ --%>
<%@page import="com.zoho.sas.pool.TarantoolDBConnection"%>
<%@page import="com.zoho.sas.pool.TarantoolConnectionPoolHandler"%>
<%@page import="java.util.logging.Level"%>
<%@page import="java.util.logging.Logger"%>
<%@page import="com.zoho.sas.pool.TRow"%>
<%@page import="com.zoho.sas.pool.TResultSet"%>
<%@page import="com.zoho.zat.guava.common.net.HostAndPort"%>
<%@page import="java.util.Set"%>
<%@page import="org.yaml.snakeyaml.nodes.NodeId"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList" %>
<%@page import="java.util.Map"%>
<%@page import="com.zoho.resource.redis.JedisPoolUtil.Pools"%>
<%@page import="com.zoho.resource.cluster.impl.TarantoolSchemaResolver"%>
<%@page import="com.adventnet.iam.IAMUtil"%>
<%@page import="com.zoho.resource.redis.JedisPoolUtil"%>
<%@page import="com.adventnet.swissqlapi.sql.functions.aggregate.max"%>
<%@page import="com.adventnet.iam.xss.IAMEncoder"%>
<%@page import="com.zoho.accounts.internal.DeploymentSpecificConfiguration"%>
<%@page import="com.zoho.accounts.AppResourceProto.CacheCluster.ClusterNode.NodeRange"%>
<%@page import="com.zoho.accounts.AppResourceProto.CacheCluster.ClusterNode"%>
<%@page import="com.zoho.accounts.AppResource.RESOURCE.CLUSTERNODE"%>
<%@page import="com.zoho.accounts.AppResource.RESOURCE.NODERANGE"%>
<%@page import="com.zoho.accounts.AppResource"%>
<%@page import="com.zoho.accounts.AppResource.CacheClusterURI"%>
<%@page import="com.zoho.accounts.AppResourceProto.CacheCluster"%>
<%@page import="com.zoho.accounts.internal.util.Util"%>
<%@page import="com.zoho.accounts.internal.util.AccountsInternalConst"%>
<%@page import="com.zoho.accounts.AccountsConfiguration"%>
<%@page import="java.util.Iterator"%>
<%@page import="org.json.JSONObject"%>
<%@page import="com.zoho.jedis.v320.Jedis"%>
<%@page import="java.util.Properties"%>
<%@page import="com.zoho.accounts.cache.IAMCacheFactory"%>
<%@page import="org.json.JSONArray"%>
<%@page import="com.zoho.resource.RESTProperties"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>R/C Stats</title> <%--NO I18N--%>
<style>
table{
	width:90%;
	margin-top:4%;
	word-wrap:break-word;
	margin-left:5%;
	table-layout:fixed;
	border:1px solid black;
	text-align:center;
	border-collapse:collapse;
}

h1{
	text-align:center;
}
th{
background-color: black;
color:white;
}

th,td{
padding-top:1%;
padding-bottom:1%;
}

.failed{
	background-color: red;
	color:white;
}

.user{
	background:none repeat scroll 0 0 rgba(194, 223, 255, 0.6);
}
.photo{
	background:none repeat scroll 0 0 #f1c40f;
}
.org{
	background-color: rgba(195, 253, 184, 0.6);
}
.ticket{
	background:none repeat scroll 0 0  rgba(253, 227, 163, 0.6);
}

.serviceorg{
	background-color: #FDE3A7;
}

.group{
	background-color: #ecf0f1;
}

.hidden{
	display:none;
}
.rediscached{
		background-color: lightgreen;
}
.tarantool{
		background-color: lightblue;
}
.redis{
		background-color: lightgreen;
}
.abs{
	border:0px;
	background-color:lightgreen;
	position: absolute;
	right: 20px;
	top:20px;s
}
.cachetype{
	color: black;
	padding: 0 3px 0 3px;
	margin-left: 2%;
}
.legend{
	float: right;
	height: 10px;
	padding : 10px;
	margin-left:auto;
	margin-right:0;
}

.legend div{
    display: inline-block;
    border-radius: 50%;
    width: 12px;
    height: 12px;
    margin-right: 5px;
}
.alignm{
     margin-left: 5%;
}
</style>
</head>
<body class='hidden'>
	<button class="refresh abs">Refresh</button><%--NO I18N--%>
	<h1> REDIS CLUSTER STATS </h1> <%--No I18N--%>
	<%CacheCluster [] pools = (CacheCluster[])AppResource.getCacheClusterURI().addSubResource(NODERANGE.table()).addSubResource(CLUSTERNODE.table()).GETS(); %>
	<form action = "" method = get >
		<select class = "cachetype alignm" name="cachetype" id = "cachetype">
			<option value ="all" >All</option>
			<option value ="redis">Redis</option>
			<option value ="tarantool">Tarantool</option>
		</select>
		<select class = "cachetype" name ="dep" id="dep"  >
			<option value = "" >DEFAULT</option><%--NO I18N--%>
			<%
				for(DeploymentSpecificConfiguration.DEPLOYMENTS dep : DeploymentSpecificConfiguration.DEPLOYMENTS.values()){
					if(!dep.name().equals("DEFAULT")){
						%><option value ="<%= "_"+IAMEncoder.encodeHTML(dep.name()) %>">
						<%= IAMEncoder.encodeHTML(dep.name()) %>
						</option><% 
					}
				}
			%> 
			<option value = "_DEP">DEP</option><%--NO I18N--%>
			
		</select>
		<button class ="cachetype">Submit</button><%--NO I18N--%>
		<div class="legend">
		<span><div class="redis"></div>Redis</span><%--NO I18N--%>
		<span><div class="tarantool"></div>Tarantool</span><%--NO I18N--%>
		<span><div class="failed"></div>Failed</span><%--NO I18N--%>
		</div>
	</form>
	<table border=1>
		<tr>
			<th>PoolName</th><%--NO I18N--%>
			<th>IP</th><%--NO I18N--%>
			<th>Node</th><%--NO I18N--%>
			<th>Keys</th><%--NO I18N--%>
			<th>Used Memory</th><%--NO I18N--%>
			<th>Max Memory</th><%--NO I18N--%>
			<th>Memory Peak</th><%--NO I18N--%>
			<th>Hits</th><%--NO I18N--%>
			<th>Hit Rate</th><%--NO I18N--%>
			<th>IOPS (#Clients)</th><%--NO I18N--%>
			<th>Evicted Keys</th><%--NO I18N--%>
			<th>Range %</th><%--NO I18N--%>
			<th>Sync Status</th><%--NO I18N--%>
		</tr>
<% 
String depcheck = request.getParameter("dep")==null? DeploymentSpecificConfiguration.getConfiguration("cachepool_suffix","") :request.getParameter("dep"); // No I18N
String cacheType = request.getParameter("cachetype")==null?"all":request.getParameter("cachetype");
int flag =0;
if(cacheType.equals("redis"))
	flag = 1;
if(cacheType.equals("tarantool"))
	flag = 2;
if(cacheType.equals("all"))
	flag = 0;
if(pools!=null){
	List<CacheCluster> depPool = new ArrayList<CacheCluster>();
	List<ClusterNode> Nodes = new ArrayList<ClusterNode>();
	for(CacheCluster pool : pools){
		String clusterName = pool.getClusterName();	
		if(depcheck=="" && clusterName.equals(clusterName.toLowerCase())){
			depPool.add(pool);
		}
		else if(!(depcheck.equals("")) && clusterName.toLowerCase().endsWith(depcheck.toLowerCase())){
			depPool.add(pool);
		}
	}
	for(CacheCluster pool : depPool){
		Nodes = pool.getClusterNodeList();
		String syncStatus = pool.getIsSyncEnabled()?(pool.getIsSyncEnabledForGet()?"ONLINE(GET)":"ONLINE"):"OFFLINE";//No I18N
		String ipPort = null;
		Double rangePercentage = 0.0,hitRate = 0.0;
		String keysCount="0",cliCount = "0";//No I18N
		String iops = null;
		Long hits = null,misses = null;
		String memorypeak=null,evictedKeys=null,memory=null,maxmem=null;
		Properties props = null;
		if(pool.getClusterNodeCount()>0){
			for(ClusterNode node : Nodes){
				try{
					Long accum = 0L;
					ipPort = node.getServerIpPort();
					if(!(node.getNodeRangeCount()==0)){
						for(int j=0;j<node.getNodeRangeCount();j++){
							NodeRange range = node.getNodeRange(j);
							accum+=(range.getEnd()-range.getStart());//No I18N
						}
					}
					rangePercentage = (Double) ((accum/(1.0*Long.MAX_VALUE))*100.0);
					if((flag==0 || flag ==1)&& !node.getCacheType().toLowerCase().equals("tarantool")){
						int db=1;
						if(node.getCacheProperties()!=null && node.getCacheProperties().contains("database")){
							for(String prop : node.getCacheProperties().split(",")){
								if(prop.startsWith("database")){
									db = Integer.parseInt(prop.split("=")[1]);	
								}									
							}
						}
						HostAndPort hostPort = HostAndPort.fromString(ipPort);
	                    Jedis cli = new Jedis(hostPort.getHost(),hostPort.getPort());
	                    cli.select(db);
						String tmp = cli.info("stats");//No I18N
						for (String line : tmp.split("\n")) {//No I18N
							if (line.contains("keyspace_hits")){//No I18N
								String spl[] = line.split(":");//No I18N
								hits  = Long.valueOf(spl[1].trim());
							}else if(line.contains("keyspace_misses")) {//No I18N
								String spl[] = line.split(":");//No I18N
								misses  = Long.valueOf(spl[1].trim());
							}else if(line.contains("instantaneous_ops_per_sec")){//No I18N
								String spl[] = line.split(":");//No I18N
								iops  = spl[1];
							}else if(line.contains("evicted_keys")){//No I18N
								String spl[]=line.split(":");
								evictedKeys = spl[1];
							}
						}
						hitRate = (Double) ((hits/(1.0*(hits+misses)))*100.0);
						tmp = cli.info("memory");//No I18N
						for (String line : tmp.split("\n")) {
							if (line.contains("used_memory_human")){//No I18N
								String spl[] = line.split(":");//No I18N
								memory  = spl[1];
							}else if(line.contains("used_memory_peak_human")) {//No I18N
								String spl[] = line.split(":");//No I18N
								memorypeak  = spl[1];
							}	
						}
						keysCount = Long.toString(cli.dbSize());
						tmp = cli.info("clients");//No I18N
						for(String line: tmp.split("\n")){ //No I18N
							if(line.contains("connected_clients")){
								cliCount = line.split(":")[1];//No I18N 
							}
						}
						maxmem = cli.configGet("maxmemory").get(1);//No I18N
						cli.close();
						if(!maxmem.equals("0")){//No I18N
							Double tmpMaxmem = Long.valueOf(maxmem)/((1024*1024*1024)*1.0);
							maxmem = String.format("%.2fG",tmpMaxmem);//No I18N
						}
						out.print("<tr id='"+IAMEncoder.encodeHTMLAttribute(ipPort+db)+"' class='cluster "+IAMEncoder.encodeHTML(pool.getClusterName())+" "+IAMEncoder.encodeHTML(node.getCacheType())+"'><td id='pname'>"+IAMEncoder.encodeHTML(pool.getClusterName())+"</td><td>"+IAMEncoder.encodeHTML(ipPort)+" ("+IAMEncoder.encodeHTML(String.valueOf(db))+")</td><td>"+IAMEncoder.encodeHTML(node.getNodeName())+"</td><td>"+IAMEncoder.encodeHTML(keysCount) +"</td><td>"+IAMEncoder.encodeHTML(memory)+"</td><td>"+IAMEncoder.encodeHTML(maxmem)+"</td><td>"+IAMEncoder.encodeHTML(memorypeak)+"</td><td>"+hits+"</td><td>"+IAMEncoder.encodeHTML(String.format("%.2f",hitRate.isNaN()?0.0:hitRate))+"%</td><td>"+IAMEncoder.encodeHTML(iops)+   " ("+IAMEncoder.encodeHTML(cliCount)+")</td><td>"+IAMEncoder.encodeHTML(evictedKeys)+"</td><td>"+IAMEncoder.encodeHTML(String.format("%.2f",rangePercentage))+"%</td><td>"+ IAMEncoder.encodeHTML(syncStatus)+"</td></tr>");//NO OUPUTENCODING //No I18N					
					}
					if((flag==0 || flag==2)&&node.getCacheType().toLowerCase().equals("tarantool")){
						if(pool.getClusterName().contains("pool") && !"true".equals(AccountsConfiguration.getConfiguration("iam3.tarantool.cache.enable", "false"))){
							throw new Exception("Tarantool not enabled for IAM3");//No I18N
						}
						if(!pool.getClusterName().contains("pool") && !"true".equals(AccountsConfiguration.getConfiguration("iam2.tarantool.enabled", "false"))){
							throw new Exception("Tarantool not enabled for IAM2");//No I18N
						}
						TarantoolConnectionPoolHandler.initialize(node.getServerIpPort().split(":")[0]);
						TarantoolDBConnection n = TarantoolConnectionPoolHandler.getConnection(node.getServerIpPort().split(":")[0]);
					if(n!=null){
						List result = null;
						result = n.eval("return tonumber(box.stat().SELECT.total) - tonumber(box.stat().INSERT.total)");//No I18N
						hits = 0l;
						if(result!=null){
							if(result.get(0) instanceof Integer){
								hits = Long.valueOf(((Integer)result.get(0)).longValue());
							}else if(result.get(0) instanceof Long){
								hits = (Long)result.get(0);
							}
						}
						result = null;
						result = n.eval("return box.stat().INSERT.total");//No I18N
						misses = 0l;
						if(result!=null){
							if(result.get(0) instanceof Integer){
								misses = Long.valueOf(((Integer)result.get(0)).longValue());
							}else if(result.get(0) instanceof Long){
								misses = (Long)result.get(0);
							}
						}
						hitRate = 0d;
						if(hits!=0l && misses!=0l){
							hitRate = (Double) ((hits/(1.0*(hits+misses)))*100.0);
						}
						result = null;
						result = n.eval("return box.slab.info().quota_size");//No I18N
						maxmem = "0";//No I18N
						if(result!=null){
							if(result.get(0) instanceof Integer){
								maxmem = Long.valueOf(((Integer)result.get(0)).longValue())+"";
							}else if(result.get(0) instanceof Long){
								maxmem = (Long)result.get(0)+"";
							}
						}
						result = null;
						result = n.eval("return box.slab.info().quota_used");//No I18N
						memory = "0";//No I18N
						if(result!=null){
							if(result.get(0) instanceof Integer){
								memory = Long.valueOf(((Integer)result.get(0)).longValue())+"";
							}else if(result.get(0) instanceof Long){
								memory = (Long)result.get(0)+"";
							}
						}
						if(!memory.equals("0")){//No I18N
							Double tmpmem = Long.valueOf(memory)/((1024*1024*1024)*1.0);
							memory = String.format("%.2fG",tmpmem);//No I18N
						}
						long opcnt = 0; 
						try{
							List statRes = n.eval("return box.stat()");//No I18N
							Map allStat = (Map)statRes.get(0);//No I18N
							for(Object opName : allStat.keySet()){
								Map opStats = (Map)allStat.get(opName);//No I18N
								for(Object opStat : opStats.keySet()){
									String opType = new String((byte[])opStat);//No I18N
									if("rps".equalsIgnoreCase(opType)){//No I18N
										Object opVal = opStats.get(opStat);//No I18N
										if(opVal instanceof Integer){
											opcnt+= Long.valueOf(((Integer)opVal).longValue());//No I18N
										}else if(opVal instanceof Long){//No I18N
											opcnt+=(Long)opVal;//No I18N
										}
									}
								}
							}
						}catch(Exception e){
							Logger.getLogger("RCSTATS").log(Level.WARNING, e.getMessage());//No I18N
						}
						iops = opcnt+"";
						opcnt = 0;
						try{
							if(node.getParent().getClusterName().contains("datapool")){
								result = null;
								result = n.eval("return box.space.iam3_data:len()");//No I18N
								if(result!=null){
									if(result.get(0) instanceof Integer){
										opcnt += Long.valueOf(((Integer)result.get(0)).longValue());
									}else if(result.get(0) instanceof Long){
										opcnt += (Long)result.get(0);
									}
								}
								result = null;
								result = n.eval("return box.space.data_invalidation_space:len()");//No I18N
								if(result!=null){
									if(result.get(0) instanceof Integer){
										opcnt += Long.valueOf(((Integer)result.get(0)).longValue());
									}else if(result.get(0) instanceof Long){
										opcnt += (Long)result.get(0);
									}
								}
								result = null;
								result = n.eval("return box.space.iam_counters:len()");//No I18N
								if(result!=null){
									if(result.get(0) instanceof Integer){
										opcnt += Long.valueOf(((Integer)result.get(0)).longValue());
									}else if(result.get(0) instanceof Long){
										opcnt += (Long)result.get(0);
										}
									}
								}else{
									for(String spaceName : TarantoolSchemaResolver.getAllSpaces()){
										if(spaceName.equals("iam3_data") || spaceName.equals("iam_counters") || spaceName.equals("data_invalidation_space")){
											continue;
										}
										result = null;
										result = n.eval("return box.space."+ spaceName + ":len()");//No I18N
										if(result!=null){
											if(result.get(0) instanceof Integer){
												opcnt += Long.valueOf(((Integer)result.get(0)).longValue());
											}else if(result.get(0) instanceof Long){
												opcnt += (Long)result.get(0);
											}
										}
									}
								}
							}catch(Exception e){
								Logger.getLogger("RCSTATS").log(Level.WARNING, e.getMessage());//No I18N
							}
							keysCount = opcnt+ "";
							cliCount = "N/A";//No I18N
							memorypeak = "N/A";//No I18N
							evictedKeys = "N/A";//No I18N
						}else{
							out.print("<br>NULL<br>");//No I18N
						}
						if(!maxmem.equals("0")){//No I18N
							Double tmpMaxmem = Long.valueOf(maxmem)/((1024*1024*1024)*1.0);
							maxmem = String.format("%.2fG",tmpMaxmem);//No I18N
						}
						out.print("<tr id='"+IAMEncoder.encodeHTMLAttribute(ipPort)+"' class='cluster "+IAMEncoder.encodeHTML(pool.getClusterName())+" "+IAMEncoder.encodeHTML(node.getCacheType())+"'><td id='pname'>"+IAMEncoder.encodeHTML(pool.getClusterName())+"</td><td>"+IAMEncoder.encodeHTML(ipPort)+"</td><td>"+IAMEncoder.encodeHTML(node.getNodeName())+"</td><td>"+IAMEncoder.encodeHTML(keysCount) +"</td><td>"+IAMEncoder.encodeHTML(memory)+"</td><td>"+IAMEncoder.encodeHTML(maxmem)+"</td><td>"+IAMEncoder.encodeHTML(memorypeak)+"</td><td>"+hits+"</td><td>"+IAMEncoder.encodeHTML(String.format("%.2f",hitRate.isNaN()?0.0:hitRate))+"%</td><td>"+IAMEncoder.encodeHTML(iops)+   " ("+IAMEncoder.encodeHTML(cliCount)+")</td><td>"+IAMEncoder.encodeHTML(evictedKeys)+"</td><td>"+IAMEncoder.encodeHTML(String.format("%.2f",rangePercentage))+"%</td><td>"+ IAMEncoder.encodeHTML(syncStatus)+"</td></tr>");//NO OUPUTENCODING //No I18N											
					}			
				}
				catch(Exception e)
				{
					out.print("<tr id='"+IAMEncoder.encodeHTMLAttribute(ipPort) +"' class='cluster failed'><td id='pname'>"+IAMEncoder.encodeHTML(pool.getClusterName())+"</td><td>"+IAMEncoder.encodeHTML(ipPort)+"</td><td colspan=11>"+IAMEncoder.encodeHTML(e.getMessage())+"</td></tr>");//No I18N			}
				}				
			}
		}		
	}
}			

%>
	</table>
</body>
<%
	String cPath = request.getContextPath() + "/accounts";//No I18N
    String jsurl = (AccountsConfiguration.USE_STATIC_SERVER.toBooleanValue() ? Util.getJSStaticURL(AccountsInternalConst.STATIC_SERVER_CONTEXT) : cPath) +"/js"; //No I18N
%>
<script type="text/javascript"
	src="<%=jsurl%>/tplibs/jquery/jquery-1.12.2.min.js">
</script>


<script type="text/javascript">

var dep = '<%= IAMEncoder.encodeJavaScript(depcheck) %>';
var ct = '<%= IAMEncoder.encodeJavaScript(cacheType) %>';
document.getElementById("dep").value = dep;
document.getElementById("cachetype").value = ct;  



var change = true;
function removeDuplicates(){
var presentIds = {};
$('.cluster').each (function () {//No I18N
    if (this.id in presentIds) {
    	if($(presentIds[this.id]).find("#pname").length>0&&$(this).find("#pname").length>0){//No I18N
    	   	if($(presentIds[this.id]).find("#pname").text().indexOf($(this).find("#pname").text())==-1){//No I18N
    			$(presentIds[this.id]).find("#pname").append("<br/>"+$(this).find("#pname").text());//No I18N
       		}
    	}
    	$(this).remove();
   	} else {
       presentIds[this.id] = this;
    }
});
$(".hidden").toggleClass("hidden");//No I18N
}
function refresh(){
	$.ajax({
		success:function(d){
		url:'/accounts/rcstats.jsp',//No I18N
			$("html").html(d);//No I18N
		}
	});
}

$(".refresh").click(refresh);//No I18N
$(function() { removeDuplicates() });
;
</script>
</html>
