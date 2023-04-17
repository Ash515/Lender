<%-- $Id$ --%>

<%@page import="com.zoho.resource.cluster.RedisNode"%>
<%@page import="com.adventnet.iam.User"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.TreeSet"%>
<%@page import="java.util.Map"%>
<%@page import="com.zoho.resource.redis.JedisPoolUtil"%>
<%@page import="com.zoho.resource.redis.JedisPoolUtil.Pools"%>
<%@page import="com.zoho.resource.RESTProperties"%>
<%@page import="com.zoho.accounts.internal.util.AccountsInternalConst"%>
<%@page import="com.zoho.accounts.AccountsConstants"%>
<%@ include file="../../static/includes.jspf"%>
<%

	boolean isRedisCacheEnabled = RESTProperties.getInstance(AccountsConstants.REST_CONTEXT).getRedisCacheEnabledProperty();
	List<String> list =null;
	boolean broken = false;
    Map<String,String> map=null;
    String RSKey = "REDIS_STATS_MONITOR";//No I18N
	try {
		RedisNode jedis = (RedisNode)JedisPoolUtil.getCorrectNode(Pools.DATA_POOL, RSKey);
		if (jedis != null) {
			map = jedis.hgetall(RSKey);
		}
	    } catch (Exception e) {
		        }
	    //generating final map containing values
	    TreeSet<String> service = new TreeSet<String>();
	    TreeSet<String> funct = new TreeSet<String>();
	    TreeSet<String> classes = new TreeSet<String>();
	    String api="";
	    if(map!=null){
	    HashMap<String,HashMap<String,String>> finalMap = new HashMap<String,HashMap<String,String>>();
	    for(String key : map.keySet()){
	    String instanceStat[]=key.split("@");
	    if(!finalMap.containsKey(instanceStat[0])){
	    finalMap.put(instanceStat[0],new HashMap<String,String>());
	    }
	        finalMap.get(instanceStat[0]).put(instanceStat[1],map.get(key));
	    }
	        ArrayList<ArrayList<String>> dataList=getList(map,finalMap);
	        ArrayList<ArrayList<String>> data=getStats(dataList, "");
	        service = new TreeSet<String>(data.get(0));
	        String split[];
	        for(String s: data.get(1)){
	        	split=s.split("\\.");
	        	funct.add(split[1]);
	        	classes.add(split[0]);
	        	api+=s+",";
	        }
	    }
	        
%>

<%!
//MOVED FROM JEDISPOOLUTIL


	public static ArrayList<ArrayList<String>> getList(Map<String, String> map,HashMap<String,HashMap<String,String>> finalMap) {
        ArrayList<ArrayList<String>> dataList = new ArrayList<ArrayList<String>>();
        ArrayList<String> a=new ArrayList<String>();
        ArrayList<String> b=new ArrayList<String>();
        for (String key : finalMap.keySet()) {
            if(key.equals("AgentCache")){
                for (java.util.Map.Entry<String, String> e : finalMap.get(key).entrySet()) {
                    a.add(e.getKey());
                    b.add(e.getValue());
                }
            }

        }
        dataList.add(a);
        dataList.add(b);
        return dataList;
    }
	
	public static ArrayList<ArrayList<String>> getStats(ArrayList<ArrayList<String>> dataList,String order) {
		ArrayList<String> services = new ArrayList<String>();
		ArrayList<String> nullHit = new ArrayList<String>();
		ArrayList<String> exception = new ArrayList<String>();
		ArrayList<String> api = new ArrayList<String>();
		ArrayList<String> hit = new ArrayList<String>();
		ArrayList<String> miss = new ArrayList<String>();
		ArrayList<String> cacheStatus = dataList.get(0);
		ArrayList<String> cacheCount = dataList.get(1);
		int cnt=0,temp=0;
		for(String s : cacheStatus)
		{
			String data[]=s.split("-");       	
			if(services.contains(data[0])){
				for(int j=0;j<services.size();j++){
					if(data.length==4){
						
						if(services.get(j).equals(data[0]) && api.get(j).equals(data[3])){
							if(data[2].equals("HIT")){
								nullHit.set(j,cacheCount.get(cnt)); 
								cnt++;
								temp++;
								break;
							}
						}
					}else{
						if(services.get(j).equals(data[0]) && api.get(j).equals(data[2])){
							if(data[1].equals("HIT")){
								hit.set(j,cacheCount.get(cnt)); 
								cnt++;
								temp++;
								break;
							}else if(data[1].equals("MISS")){//No I18n
								miss.set(j,cacheCount.get(cnt));
								cnt++;
								temp++;
								break;
							}else if(data[1].equals("EXCEPTION")){//No I18n
								exception.set(j,cacheCount.get(cnt));
								cnt++;
								temp++;
								break;
							}
						}
					}
				}
				if(temp>0){
					temp=0;
					continue;
				}
			}
			services.add(data[0]);
			if(data.length==4){
				api.add(data[3]);
				if(data[2].equals("HIT")){
					nullHit.add(cacheCount.get(cnt));
					hit.add("0");
					miss.add("0");
					exception.add("0");
					cnt++;
				}
			}else{
				api.add(data[2]);
				if(data[1].equals("HIT"))
				{
					hit.add(cacheCount.get(cnt));
					miss.add("0");
					nullHit.add("0");
					exception.add("0");
					cnt++;
				}
				else if(data[1].equals("MISS"))
				{
					hit.add("0");
					miss.add(cacheCount.get(cnt));
					nullHit.add("0");
					exception.add("0");
					cnt++;
				}
				else if(data[1].equals("EXCEPTION"))
				{
					hit.add("0");
					miss.add("0");
					exception.add(cacheCount.get(cnt));
					nullHit.add("0");
					cnt++;
				}
			}
		}
		ArrayList<ArrayList<String>> dataLists = new ArrayList<ArrayList<String>>();
		dataLists.add(services);
		dataLists.add(api);
		dataLists.add(hit);
		dataLists.add(miss);
		dataLists.add(nullHit);
		dataLists.add(exception);
		return dataLists;

	}
%>
<div class="maincontent">  <%--No I18N--%>
    <div class="menucontent">
	<div class="topcontent"><div class="contitle" id="restoretitle">Agent Cache Report</div></div> <%--No I18N--%>
	<div class="subtitle">Admin Services</div> <%--No I18N--%>
    </div>
	
    <div class="restorelink" >
            <a href="javascript:;" id="serlink" onclick="switchTab('service');" class="activerslink">View By Service</a> / <%--No I18N--%>
            <a href="javascript:;" id="apilink" onclick="switchTab('api');" class="activerslink">View By Api</a> <%--No I18N--%>
        </div>
			<div class="tabpage" id="tabpage_1" >
		<div class='labelkey1'>Select By Service:</div>  <%--No I18N--%>
		<select id ='s' class='select' onchange=displayTable('service');>
		<option value='SELECT' selected>SELECT</option>  <%--No I18N--%>
		<%
		for(String s:service){%>
		<option value='<%=IAMEncoder.encodeHTMLAttribute(s)%>'><%=IAMEncoder.encodeHTMLAttribute(s)%></option>
		<%} %>
		</select>
		</div><br>

			<div class="tabpage" id="tabpage_2a" style="display: none;">
		<div class='selectalign'>Select By Class:    <%--No I18N--%>
		<select id ='class' class='select' onchange=selectFromClass('<%=IAMEncoder.encodeHTMLAttribute(api)%>');>
		<option value='SELECT' selected>SELECT</option>  <%--No I18N--%>
		<%
		for(String s:classes){%>
		<option value='<%=IAMEncoder.encodeHTMLAttribute(s)%>'><%=IAMEncoder.encodeHTMLAttribute(s)%></option>
		<%} %>
		</select>
		</div>
		</div>

			
			<div class="tabpage" id="tabpage_2b" style="display: none;">
		<div class='selectalign'>Select By Function:  <%--No I18N--%>
		<select id ='func' class='select' onchange=displayTable('func');>

		</select>
		</div>
		</div>
        </div>
	
<div id='table' class = "reporttableAgentCache" style="display:none">
</div>


