<%--$Id$--%>
<%@page import="com.zoho.zat.guava.common.net.HostAndPort"%>
<%@page import="com.zoho.accounts.AccountsConfiguration"%>
<%@page import="com.zoho.accounts.internal.admin.CacheMetrics"%>
<%@page import="java.util.Map.Entry"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.zoho.jedis.v320.exceptions.JedisDataException"%>
<%@page import="com.adventnet.iam.IAMUtil"%>
<%@page import="com.zoho.resource.RedisMessageProto.IAMNotification"%>
<%@page import="com.zoho.accounts.AppResource.RESOURCE.CLUSTERNODE"%>
<%@page import="com.zoho.accounts.messaging.RedisMessageHandler"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.adventnet.iam.IAMProxy"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="java.io.InputStreamReader"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="com.zoho.accounts.AccountsConstants"%>
<%@page import="com.zoho.resource.ResourceProto.ResourceMetaData.ChildResource"%>
<%@page import="com.zoho.resource.ResourceProto.ResourceMetaData"%>
<%@page import="com.zoho.resource.ResourceMetaDataUtil"%>
<%@page import="java.util.Random"%>
<%@page import="org.json.JSONObject"%>
<%@page import="java.util.TreeSet"%>
<%@page import="com.zoho.jedis.v320.Jedis"%>
<%@page import="com.zoho.resource.Representation"%>
<%@page import="org.json.JSONArray"%>
<%@page import="com.zoho.accounts.AppResourceProto.CacheCluster"%>
<%@page import="com.zoho.accounts.AppResource.RESOURCE.CLUSTERNODE"%>
<%@page import="com.zoho.accounts.AppResource.RESOURCE.CACHECLUSTER"%>
<%@page import="com.zoho.accounts.AppResource"%>
<%@page import="com.zoho.resource.URI"%>
<%@page import="com.zoho.resource.redis.RedisStats"%>
<%
	response.setHeader("Content-Type", "application/json"); //No I18N
	if(request.getParameter("instances")!=null){
		CacheMetrics.getInstances(out);
	} else if (request.getParameter("refresh") != null) {
		CacheMetrics.refreshStats();
	} else if(request.getParameter("flush")!= null){
		if(AccountsConfiguration.getConfiguration("redis.stats.flush.allow","$a").matches(IAMUtil.getCurrentUser().getZUID()+"")){ //No I18N
			CacheMetrics.flushStats();
		}
	} else if (request.getParameter("get") != null) {
		CacheMetrics.get(request.getParameter("instance"), null, out);
	} else if (request.getParameter("pget") != null) {
		CacheMetrics.get(request.getParameter("instance"), request.getParameter("pattern") + ".*", out);
	} else if (request.getParameter("cachestats")!=null){
		int op = Integer.valueOf(request.getParameter("op"));
		switch (op) {
		case 1: {
			getInstances(out);
			break;
		}
		case 2: {
			getConnectedServices(request.getParameter("ip"), Integer.valueOf(request.getParameter("port")), out);
			break;
		}
		case 3: {
			getDistribution(out);
			break;
		}
		case 4: {
			CacheMetrics.reInitServiceMap();
			break;
		}
		}
	} else if (request.getParameter("message") != null) {
		if ("all".equals(request.getParameter("pool"))) {
			String target = request.getParameter("target");
			String dep = request.getParameter("dep");
			out.append("" + publishMessage(target, "user", dep));
			out.append("" + publishMessage(target, "org", dep));
			out.append("" + publishMessage(target, "serviceorg", dep));
			out.append("" + publishMessage(target, "group", dep));
			out.append("" + publishMessage(target, "photo", dep));
			out.append("" + publishMessage(target, "ticket", dep));
			out.flush();
		} else {
			out.println(publishMessage(request.getParameter("target"), request.getParameter("pool"), request.getParameter("dep")));//NO OUTPUTENCODING
		}
	}

	else {
%>
	{"status":false}<%--No I18N--%>
<%
	}
%>

<%!//Temp Cache mon f/n s follow
void getInstances(JspWriter out) throws Exception{
	URI clusterURI = AppResource.getCacheClusterURI();
	clusterURI.addSubResource(CLUSTERNODE.table());
	JSONArray response = new JSONArray();
	for(CacheCluster c : (CacheCluster[])clusterURI.GETS()){
		response.put(Representation.toJSONString(c.getClusterNode(0)));
	}
	out.print(response.toString());
}

String lookupServiceFromIP(String ip){
	return CacheMetrics.getServiceName(ip);
}

void getConnectedServices(String ip, int port, JspWriter out) throws Exception{
	JSONObject total = new JSONObject();
	JSONArray response = new JSONArray();
	try{
		Jedis cli = new Jedis(ip, port);
		TreeSet<String> serviceSet = new TreeSet<String>();
		String clients[] = cli.clientList().split("\n"); //No I18N
		String mem = cli.info("memory");//No I18N
		String repl = cli.info("replication");//No I18N
		cli.close();
		total.put("repl", repl);//No I18N
		total.put("mem", mem);//No I18N
		for(String client : clients){
			String comp[] = client.split(" ");
			String cmd = comp[17].toLowerCase();
			if (cmd.contains("hincrby") || cmd.contains("ping")|| cmd.contains("replconf")) {
				continue;
			}	
			HostAndPort hostPort = HostAndPort.fromString(comp[1].split("=")[1]);
			serviceSet.add(lookupServiceFromIP(hostPort.getHost()));
		}
		for(String service : serviceSet){
			response.put(service);
		}
		total.put("data", response);//No I18N
	}catch(Exception e){
		response.put(e.toString());
	}
	out.print(total);
}

void getAllTables(ResourceMetaData rmd, StringBuilder builder){
	builder.append("\""+rmd.getTableName()+"\",");
	for(ChildResource cr : rmd.getChildResourceList()){
		getAllTables(ResourceMetaDataUtil.getInstance(cr.getResourceName()), builder);
	}
}

long publishMessage(String target, String pool, String deployment){
	String method = "clearCacheConfiguration";//No I18N
	String className = RedisMessageHandler.class.getName();
	long recvCount = 0;
	Jedis pubsubClient = null;
	try {
		URI u = AppResource.getCacheClusterURI("messagepool"+deployment);//No I18N
		u.addSubResource(CLUSTERNODE.table());
		HostAndPort hostPort = HostAndPort.fromString(((CacheCluster)u.GET()).getClusterNode(0).getServerIpPort());
		pubsubClient = new Jedis(hostPort.getHost());
		IAMNotification.Builder proto = IAMNotification.newBuilder();
		proto.setCreatedtime(System.currentTimeMillis());
		proto.setDestination(target);
		proto.setHandler(className);
		proto.setMethod(method);
		proto.setSource("AaaServer");//No I18N
		JSONArray arr = new JSONArray();
		arr.put(IAMUtil.getCurrentTicket());
		arr.put(pool);
		proto.setMessage(arr.toString());
		recvCount = pubsubClient.publish(target, proto.build().toByteString().toString("ISO-8859-1"));//No I18N
		pubsubClient.close();
	}  catch (Exception e) {
		
	}
	return recvCount;
}

void getDistribution(JspWriter out) throws Exception{
	JSONArray response = new JSONArray();
	try{
		URI clusterURI = AppResource.getCacheClusterURI();
		clusterURI.addSubResource(CLUSTERNODE.table());
		CacheCluster [] allClusters = (CacheCluster[])clusterURI.GETS();
			for (CacheCluster cluster : allClusters) {
				if(!cluster.getClusterName().contains("_") || cluster.getClusterName().endsWith("_RC")){//No I18N
					continue;
				}	
				HostAndPort hostPort = HostAndPort.fromString(cluster.getClusterNode(0).getServerIpPort());
				Jedis cli = new Jedis(hostPort.getHost(), hostPort.getPort());
				HashMap<String,JSONArray> serviceSet = new HashMap<String, JSONArray>();
				String clients[] = cli.clientList().split("\n"); //No I18N
				cli.close();
				for (String client : clients) {
					String comp[] = client.split(" ");//No I18N
					String cmd = comp[17].toLowerCase();
					String ip = HostAndPort.fromString(comp[1].split("=")[1]).getHost();//No I18N
					if (cmd.contains("hincrby") || cmd.contains("subscribe") || cmd.contains("ping")|| cmd.contains("replconf")) {//No I18N
						continue;
					}
					String sName = lookupServiceFromIP(ip)+'_'+hostPort.getHost();
					if(serviceSet.get(sName)==null){
						serviceSet.put(sName, new JSONArray());
					}
					serviceSet.get(sName).put(ip);
				}
				for(Entry<String,JSONArray> service : serviceSet.entrySet()){
					JSONObject obj = new JSONObject(); 
					obj.put("name", service.getKey().split("_")[0]);//No I18N
					obj.put("redis", service.getKey().split("_")[1]);//No I18N
					obj.put("ips", service.getValue());//No I18N
					obj.put("value", 30);//No I18N
					if(cluster.getClusterName().endsWith("_SV4") || cluster.getClusterName().endsWith("_LZ") || cluster.getClusterName().endsWith("_eu1")){//No I18N
						obj.put("className", "sv4");//No I18N
					}else {
						obj.put("className", "ny4");//No I18N
					}
					response.put(obj);
				}
			}
		} catch (Exception e) {
		}
		out.print(response.toString());
	}%>