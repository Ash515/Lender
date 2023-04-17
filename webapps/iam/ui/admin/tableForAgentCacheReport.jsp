<%-- $Id$ --%>

<%@page import="java.text.DecimalFormat"%>
<%@page import="com.adventnet.iam.xss.IAMEncoder"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>  <%--No I18N--%>
<%@page import="com.adventnet.iam.User"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="com.zoho.resource.redis.JedisPoolUtil"%>
<%@page import="com.zoho.resource.redis.JedisPoolUtil.Pools"%>
<%@page import="com.zoho.jedis.v320.Jedis"%>
<%@page import="com.zoho.jedis.v320.exceptions.JedisConnectionException"%>
<%@page import="com.zoho.resource.RESTProperties"%>
<%@page import="com.zoho.accounts.internal.util.AccountsInternalConst"%>
<%@page import="com.zoho.accounts.AccountsConstants"%>

<div id='headerdiv' class='apikeyheader'><%--No I18N--%>
<div class='sysname' style='width: 12%;'> SERVICE NAME</div> <%--No I18N--%>
<div class='sysname' style='width: 19%;'> API </div><%--No I18N--%>
<div class='sysname' style='width: 9%;'> HIT </div><%--No I18N--%>
<div class='sysname' style='width: 9%;'> MISS </div><%--No I18N--%>
<div class='sysname' style='width: 9%;'> NULL HIT </div><%--No I18N--%>
<div class='sysname' style='width: 9%;'> EXCEPTION </div><%--No I18N--%>

</div>
<div id='overflowdiv' class='content1'>
	<div class='field-bg'>
		<div id='sysview'>

			<%
				boolean isRedisCacheEnabled = RESTProperties.getInstance(
						AccountsConstants.REST_CONTEXT)
						.getRedisCacheEnabledProperty();
				Jedis jedis = null;
				List<String> list = null;
				boolean broken = false;
				Map<String, String> map = null;
				try {
					jedis = JedisPoolUtil.getResource(Pools.DATA_POOL);
					if (jedis != null) {
						map = jedis.hgetAll("REDIS_STATS_MONITOR");//No I18N
					}
				    } catch (JedisConnectionException e) {
					broken = true;
				} finally {
					JedisPoolUtil.returnResource(Pools.DATA_POOL, jedis, broken);
				}
				//generating final map containing values
				HashMap<String, HashMap<String, String>> finalMap = new HashMap<String, HashMap<String, String>>();
				for (String key : map.keySet()) {
					String instanceStat[] = key.split("@");
					if (!finalMap.containsKey(instanceStat[0])) {
						finalMap.put(instanceStat[0], new HashMap<String, String>());
					}
					finalMap.get(instanceStat[0])
							.put(instanceStat[1], map.get(key));
				}
				ArrayList<ArrayList<String>> dataList = JedisPoolUtil.getList(map,
						finalMap);
				String order = request.getParameter("order");
				String className = request.getParameter("class");
				ArrayList<ArrayList<String>> data = JedisPoolUtil.getStats(
						dataList, order);
				for (int i = 0; i < data.get(0).size(); i++) {
				if ((!order.equals("") && (data.get(0).get(i).indexOf(order) > -1) || (data.get(1).get(i).indexOf(order) > -1 && data.get(1).get(i).length()> className.length() && data.get(1).get(i).charAt(className.length())=='.')) && data.get(1).get(i).indexOf(className) > -1) {
					double total=0;
					String hitPercent="0",missPercent="0",nullHitPercent="0";
					for(int j=2;j<5;j++){
						total+=Integer.parseInt(data.get(j).get(i));
					}
					if(total!=0){
						DecimalFormat f = new DecimalFormat("##.00");
						hitPercent=f.format((Integer.parseInt(data.get(2).get(i))/total*100));
						missPercent=f.format(Integer.parseInt(data.get(3).get(i))/total*100);
						nullHitPercent=f.format(Integer.parseInt(data.get(4).get(i))/total*100);
					}
			%>
			<div class='sysname' style='width: 12%;'>
				<%=IAMEncoder.encodeHTMLAttribute(data.get(0).get(i))%></div>  
			<div class='sysname' style='width: 19%;'>
				<%=IAMEncoder.encodeHTMLAttribute(data.get(1).get(i))%></div>
			<div class='sysname' style='width: 10%;'>
				<%=IAMEncoder.encodeHTMLAttribute(data.get(2).get(i)+" ("+hitPercent +"%)")%></div>
			<div class='sysname' style='width: 9%;'>
				<%=IAMEncoder.encodeHTMLAttribute(data.get(3).get(i)+" ("+missPercent +"%)")%></div>
			<div class='sysname' style='width: 9%;'>
				<%=IAMEncoder.encodeHTMLAttribute(data.get(4).get(i)+" ("+nullHitPercent +"%)")%></div>
			<div class='sysname' style='width: 9%;'>
			<%=IAMEncoder.encodeHTMLAttribute(data.get(5).get(i))%></div>
			<div class='clrboth'></div>
			<%
				}
				}
			%>
		</div>
	</div>
</div>
</div>
</div>
