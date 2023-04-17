<%--$Id$ --%>
<%@page import="org.json.JSONObject"%>
<%@page import="com.zoho.accounts.cache.IAMCacheFactory"%>
<%
JSONObject obj = new JSONObject();
if(IAMCacheFactory.getCache("user").getStats()!=null){//No I18N
	obj.put("user","Memcached");//No I18N
}else{
	obj.put("user","Redis Cluster");//No I18N
}

if(IAMCacheFactory.getCache("serviceorg").getStats()!=null){//No I18N
	obj.put("serviceorg","Memcached");//No I18N
}else{
	obj.put("serviceorg","Redis Cluster");//No I18N
}

if(IAMCacheFactory.getCache("org").getStats()!=null){//No I18N
	obj.put("org","Memcached");//No I18N
}else{
	obj.put("org","Redis Cluster");//No I18N
}

if(IAMCacheFactory.getCache("photo").getStats()!=null){//No I18N
	obj.put("photo","Memcached");//No I18N
}else{
	obj.put("photo","Redis Cluster");//No I18N
}

if(IAMCacheFactory.getCache("group").getStats()!=null){//No I18N
	obj.put("group","Memcached");//No I18N
}else{
	obj.put("group","Redis Cluster");//No I18N
}

if(IAMCacheFactory.getCache("ticket").getStats()!=null){//No I18N
	obj.put("ticket","Memcached");//No I18N
}else{
	obj.put("ticket","Redis Cluster");//No I18N
}
response.setContentType("application/json");//No I18N
response.getWriter().print(obj.toString(1));//NO OUTPUTENCODING
%>