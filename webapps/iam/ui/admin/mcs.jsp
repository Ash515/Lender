<%-- $Id$ --%>
<%@page import="com.zoho.accounts.cache.IAMCacheFactory.CacheType"%>
<%@page import="com.zoho.accounts.cache.IAMCacheFactory"%>
<%@page import="com.adventnet.cache.CacheFactory"%>
<%@page import="com.zoho.accounts.cache.MemCacheConstants"%>
<%@page import="com.adventnet.cache.memcache.admin.MemcacheAdmin"%>
<%@page import="com.adventnet.iam.IAMUtil"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.zoho.accounts.cache.MemCacheUtil"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.adventnet.iam.xss.IAMEncoder"%>
<!DOCTYPE html>
<html>
<head>
<meta content="text/html; charset=UTF-8" http-equiv="content-type">
<title>IAM2 MemCache Server Statistics</title> <%--No I18N--%>
<style type="text/css">
body {
	font-size: 12px;
	font-family: DejaVu Sans, Roboto, Helvarica;
	margin: 0;
	padding: 5px;
}

table,tr,td {
	border-collapse: collapse;
	border: 1px solid #AAA;
}

th {
	background-color: #339999;
	color: #FFF;
	padding: 5px;
}

.header {
	font-size: 15px;
	font-weight: bold;
	border-bottom: 2px solid #C7C7C7;
	margin-bottom: 5px;
	padding-bottom: 2px;
}

td {
	text-align: center;
	padding: 5px;
}

#audit-container {
	margin-top: 20px;
}

#audit-container .t-not_in_cache,#audit-container .t-forced_to_db {
	display: none;
}

#audit-container.t-not_in_cache .t-not_in_cache {
	display: block;
}

#audit-container.t-forced_to_db .t-forced_to_db {
	display: block;
}

.audit-table td:first-child {
	text-align: left;
}

#audit-details a {
	float: right;
	font-size: 11px;
}

#audit-details div div {
	margin-top: 5px;
	border-bottom: 1px dotted #C7C7C7;
	padding: 5px;
}

#audit-details span:nth-of-type(odd) {
	color: #777;
	font-weight: bold;
	padding: 3px;
}

#audit-details {
	display: none;
	overflow: auto;
	position: fixed;
	top: 15%;
	left: 20%;
	border: 8px solid #C7C7C7;
	background-color: #FFF;
	padding: 5px;
	width: 600px;
	max-height: 350px;
}

.sortHeader {
	cursor: pointer;
}

.sortHeader:after {
	content: " \21D5 ";
}

.headerSortDown:after {
	content: " \21D1 "; /*Up Arrow*/
}

.headerSortUp:after {
	content: " \21D3 "; /*Down Arrow*/
}
</style>
<body>
	<div class="header">IAM2 MemCache Server Statistics</div> <%--No I18N--%>
	<table border="1" width="100%">
		<tr align="center">
			<th>Pool</th> <%--No I18N--%>
            <th>Server</th> <%--No I18N--%>
            <th>Hits</th> <%--No I18N--%>
            <th>Missed</th> <%--No I18N--%>
            <th>Hit Ratio</th> <%--No I18N--%>
            <th>Total Items</th> <%--No I18N--%>
            <th>Current Items</th> <%--No I18N--%>
            <th>Eviction</th> <%--No I18N--%>
            <th title="Days : Hr : Min : Sec">Uptime</th> <%--No I18N--%>
            <th>Total Get</th> <%--No I18N--%>
            <th>Total Set</th> <%--No I18N--%>
            <th>Diff [Get -Set]</th> <%--No I18N--%>
            <th>Free Space</th> <%--No I18N--%>
		</tr>
		<%
			MemcacheAdmin admin = MemcacheAdmin.getInstance();
			HashMap stats = new HashMap();
			MemCacheConstants[] pools = new MemCacheConstants[] { MemCacheConstants.USER, MemCacheConstants.ORG, MemCacheConstants.GROUP, MemCacheConstants.SERVICEORG, MemCacheConstants.TICKET, MemCacheConstants.PHOTO };
			for (MemCacheConstants pool : pools) {
				Map statMap = CacheFactory.getInstance().getCache(pool.getPoolName()).getStats();
				if (statMap != null) {
					if(IAMCacheFactory.getCache(pool.getPoolName()).getCacheType()==CacheType.CLUSTER){
						stats.put(pool.getPoolName()+"_sync", statMap);//No I18N
					}else{
						stats.put(pool.getPoolName(), statMap);
					}
				}
			}
			Iterator iter = stats.keySet().iterator();
			Iterator innerIter = stats.keySet().iterator();
			Map tempMap = null;
			Map sMap = null;
			String poolName = null;
			String server = null;
			NumberFormat nf = NumberFormat.getInstance();
			NumberFormat percentNF = NumberFormat.getPercentInstance();
			percentNF.setMinimumFractionDigits(2);
			while (iter.hasNext()) {
				poolName = (String) iter.next();
				tempMap = (Map) stats.get(poolName);
				innerIter = tempMap.keySet().iterator();
				while (innerIter.hasNext()) {
					server = (String) innerIter.next();
					sMap = (Map) tempMap.get(server);
					long totalGet = IAMUtil.getLong(((String) sMap.get("cmd_get")).trim()); //No I18N
					long totalSet = IAMUtil.getLong(((String) sMap.get("cmd_set")).trim()); //No I18N
					long maxbytes = IAMUtil.getLong(((String) sMap.get("limit_maxbytes")).trim()); //No I18N
					long bytes = IAMUtil.getLong(((String) sMap.get("bytes")).trim()); //No I18N
					long hits = IAMUtil.getLong(((String) sMap.get("get_hits")).trim()); //No I18N
					long misses = IAMUtil.getLong(((String) sMap.get("get_misses")).trim()); //No I18N
					float hitRatio = hits / ((float) hits + misses);
		%>
		<tr>
			<td title="Process ID : <%=IAMEncoder.encodeHTMLAttribute(String.valueOf(sMap.get("pid")))%>"><%=IAMEncoder.encodeHTML(poolName)%></td>
			<%--No I18N--%>
			<td><%=IAMEncoder.encodeHTML(server)%></td>
			<td><%=IAMEncoder.encodeHTML(nf.format(hits))%></td>
			<td><%=IAMEncoder.encodeHTML(nf.format(misses))%></td>
			<td title="(hits / hits + misses) = <%=hitRatio%>"><%=IAMEncoder.encodeHTML(percentNF.format(hitRatio))%></td>
			<%--No I18N--%>
			<td><%=IAMEncoder.encodeHTML(nf.format(IAMUtil.getLong(((String) sMap.get("total_items")).trim())))%></td>
			<%--No I18N--%>
			<td><%=IAMEncoder.encodeHTML(nf.format(IAMUtil.getLong(((String) sMap.get("curr_items")).trim())))%></td>
			<%--No I18N--%>
			<td><%=IAMEncoder.encodeHTML(nf.format(IAMUtil.getLong(((String) sMap.get("evictions")).trim())))%></td>
			<%--No I18N--%>
			<td>
				<%
					String uptimeStr = (String) sMap.get("uptime"); //No I18N
							if (uptimeStr != null) {
								long uptime = IAMUtil.getLong(uptimeStr.trim());
								out.print(IAMEncoder.encodeHTML(admin.getFormattedUpTime(uptime)));
							}
				%>
			</td>
			<td><%=IAMEncoder.encodeHTML(nf.format(totalGet))%></td>
			<td><%=IAMEncoder.encodeHTML(nf.format(totalSet))%></td>
			<td><%=IAMEncoder.encodeHTML(nf.format(totalGet - totalSet))%></td>
			<td title="Total : <%=IAMEncoder.encodeHTMLAttribute(nf.format(maxbytes))%>, Used : <%=IAMEncoder.encodeHTMLAttribute(nf.format(bytes))%>"><%=IAMEncoder.encodeHTML(nf.format(maxbytes - bytes))%></td> <%--No I18N--%>
		</tr>
		<%
				}
			}
		%>
	</table>
</body>
</html>