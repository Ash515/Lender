<%-- $Id$ --%>
<%@page import="com.zoho.protobuf.Message"%>
<%@page import="com.adventnet.iam.Arg"%>
<%@page import="com.zoho.jedis.v320.Tuple"%>
<%@page import="java.util.Set"%>
<%@page import="com.zoho.resource.redis.JedisPoolUtil.Pools"%>
<%@page import="com.zoho.resource.redis.JedisPoolUtil"%>
<%@page import="com.zoho.resource.cluster.RedisNode"%>
<%@page import="com.adventnet.iam.internal.admin.AdminServlet"%>
<%@page import="java.util.Map.Entry"%>
<%@page import="com.zoho.accounts.cache.impl.IAMCacheHashIterator"%>
<%@page import="com.zoho.accounts.cache.impl.IAMCacheSetIterator"%>
<%@page import="com.zoho.accounts.cache.MemCacheKey"%>
<%@page import="java.util.LinkedHashMap"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.adventnet.iam.Org"%>
<%@page import="com.adventnet.iam.OrgLocation"%>
<%@page import="com.adventnet.iam.OrgDomain"%>
<%@page import="com.adventnet.iam.IPRange"%>
<%@page import="com.adventnet.iam.OrgIPRange"%>
<%@page import="com.adventnet.iam.IAMUtil"%>
<%@page import="com.adventnet.iam.UserEmail"%>
<%@page import="com.adventnet.iam.UserSession"%>
<%@page import="com.adventnet.iam.CryptoUtil"%>
<%@page import="com.adventnet.iam.internal.Util"%>
<%@page import="com.adventnet.iam.Service"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.zoho.accounts.cache.MemCacheUtil"%>
<%@page import="com.adventnet.iam.xss.IAMEncoder"%>
<%@page import="java.util.logging.Level"%>
<%@page import="java.util.List"%>
<%@page import="java.util.logging.Logger"%>
<%@page import="com.adventnet.iam.User"%>
<%@page import="com.zoho.accounts.AccountsConstants"%>
<%@page import="com.zoho.accounts.cache.MemCacheConstants"%>
<style>
hr{
	color: #d4d4d4;
    background-color: #d4d4d4;
    border: none;
    height: 1px;
}
</style>

<%!

private static final Logger LOGGER = Logger.getLogger("viewmc.jsp"); // No I18N

private String convertToString(Object memCacheValue) {
	if (memCacheValue == null) {
		return null;
	}
	try {
		Arg arg = new Arg();
		String dat = String.valueOf(memCacheValue);
		arg.initialize(dat);
		Object val = arg.getValue();
		if(val instanceof Message){
			dat+="\n\n"+val; //No I18N
		}
		return dat;
	} catch(Exception e) {
		LOGGER.log(Level.FINE, null, e);
	}
	return String.valueOf(memCacheValue);
}

public String getNext(Iterator itr,String datatype){
	int count = 0;
	String ax = "";
	while(itr.hasNext()){
		count++;
		ax +="<li class='memcachekeyval'>";
		
		if(datatype.equals("set")){
			ax += itr.next()+"<hr>";
		}
		if(datatype.equals("hash")){
			Entry<String,String> dat = ((IAMCacheHashIterator) itr).next();
			ax += dat.getKey() + "=<br>" + dat.getValue()+"<hr>";
		}
		if(datatype.equals("sortedset")){
			Tuple tup = (Tuple) itr.next();
			Double score =tup.getScore();
			ax += score.longValue() + " :<br>" + tup.getElement()+"<hr>";
		}
		ax += "</li>";
		if(count==25){
			break;
		}
	}
	return ax;
}
%>

<%
    String splitKey = "-!@#-";
    // view action
    if("view".equals(request.getParameter("action"))) {
	String poolType = request.getParameter("pool");
	String uniqueId = request.getParameter("uid");
	boolean isKey = "true".equalsIgnoreCase(request.getParameter("iskey"));
	HashMap<String, Object> map = new LinkedHashMap();
	String datatype = request.getParameter("datatype")!=null ? request.getParameter("datatype") : "string"; //No I18N
	if (isKey) {
		switch (datatype){
		case "string" : //No I18N
			if(poolType.equalsIgnoreCase(Pools.EPHEMERAL_POOL.getPoolName())) {
				RedisNode node =  ((RedisNode) JedisPoolUtil.getCorrectNode(Pools.EPHEMERAL_POOL, uniqueId));
				map.put(poolType + splitKey + uniqueId, convertToString(node.get(uniqueId)));
			} else {
				map.put(poolType + splitKey + uniqueId, convertToString(MemCacheUtil.getValue(MemCacheConstants.valueOf(poolType), new MemCacheKey(uniqueId))));				
			}
			break;
		case "set" : //No I18N
			map.put(poolType + splitKey + uniqueId, MemCacheUtil.getValuesFromSet(MemCacheConstants.valueOf(poolType), new MemCacheKey(uniqueId)));
			break;
		case "hash" : //No I18N
			map.put(poolType + splitKey + uniqueId, MemCacheUtil.getValuesFromMap(MemCacheConstants.valueOf(poolType), new MemCacheKey(uniqueId)));
			break;
 		case "sortedset" : //No I18N
			RedisNode node =  ((RedisNode) JedisPoolUtil.getCorrectNode(Pools.OPT_POOL, uniqueId));
			map.put(poolType + splitKey + uniqueId, node.getFromSortedSet(uniqueId, 0, 25, true));
			break;
		}
	}
	else {
		MemCacheConstants pool =  MemCacheConstants.valueOf(poolType);
	    if (MemCacheConstants.USER.equals(pool)) {
		long ZUID = Long.parseLong(uniqueId);
		User cache_user = Util.USERAPI.getUser(ZUID);
		map.put(MemCacheConstants.USER + splitKey + MemCacheConstants.getUserZUIDKey(ZUID), MemCacheUtil.get(MemCacheConstants.USER, MemCacheConstants.getUserZUIDKey(ZUID)));
		if (cache_user != null) {
		    if (cache_user.getEmails() != null) {
			for (UserEmail email : cache_user.getEmails()) {
			    map.put(MemCacheConstants.USER + splitKey + MemCacheConstants.getUserEmailKey(email.getEmailId()), MemCacheUtil.get(MemCacheConstants.USER, MemCacheConstants.getUserEmailKey(email.getEmailId())));
			}
		    }
		    map.put(MemCacheConstants.ALLOWED_IP + splitKey + MemCacheConstants.getAllowedIPKey(cache_user.getZUID()), MemCacheUtil.get(MemCacheConstants.ALLOWED_IP, MemCacheConstants.getAllowedIPKey(cache_user.getZUID())));
		}

		List<UserSession> listSessions = Util.USERAPI.getAllSessions(ZUID);
		if (listSessions != null) {
		    for (UserSession us : listSessions) {
				String ticket = null;
				try {
					ticket = CryptoUtil.decrypt(Util.IAM_SECRET_KEYLABEL, us.getTicket());
				}catch(Exception e) {
					ticket = null;//us.getTicket();
				}
				map.put(MemCacheConstants.TICKET + splitKey + MemCacheConstants.getTicketKey(ticket), MemCacheUtil.get(MemCacheConstants.TICKET, MemCacheConstants.getTicketKey(ticket)));
		    }
		}

		for (Service service : Util.SERVICEAPI.getAllServices()) {
		    map.put(MemCacheConstants.USER_SERVICE + splitKey + MemCacheConstants.getUserServiceKey(ZUID, service.getServiceId()), MemCacheUtil.get(MemCacheConstants.USER_SERVICE, MemCacheConstants.getUserServiceKey(ZUID, service.getServiceId())));
		}
		List<Long> userGroups = Util.USERAPI.getUserGroupIds(ZUID);
		if (userGroups != null) {
		    for (long g : userGroups) {
			map.put(MemCacheConstants.GROUP + splitKey + MemCacheConstants.getGroupZGIDKey(g), MemCacheUtil.get(MemCacheConstants.GROUP, MemCacheConstants.getGroupZGIDKey(g)));
		    }
		}
		map.put(MemCacheConstants.USER + splitKey + MemCacheConstants.getUserPreferenceKey(ZUID), MemCacheUtil.get(MemCacheConstants.USER, MemCacheConstants.getUserPreferenceKey(ZUID)));
		map.put(MemCacheConstants.GROUP + splitKey + MemCacheConstants.getUserPersonalGroupZGIDsListKey(ZUID), MemCacheUtil.get(MemCacheConstants.GROUP, MemCacheConstants.getUserPersonalGroupZGIDsListKey(ZUID)));
		map.put(MemCacheConstants.GROUP + splitKey + MemCacheConstants.getUserOrgGroupZGIDsListKey(ZUID), MemCacheUtil.get(MemCacheConstants.GROUP, MemCacheConstants.getUserOrgGroupZGIDsListKey(ZUID)));
		map.put(MemCacheConstants.GROUP + splitKey + MemCacheConstants.getUserGroupsCountKey(ZUID), MemCacheUtil.get(MemCacheConstants.GROUP, MemCacheConstants.getUserGroupsCountKey(ZUID)));
		map.put(MemCacheConstants.USER + splitKey + MemCacheConstants.getUserLoginTimeKey(String.valueOf(ZUID)), MemCacheUtil.get(MemCacheConstants.USER, MemCacheConstants.getUserLoginTimeKey(String.valueOf(ZUID))));

		String usedServiceIds = MemCacheUtil.get(MemCacheConstants.USER, MemCacheConstants.getUsedUserAccountsListKey(ZUID));
		map.put(MemCacheConstants.USER + splitKey + MemCacheConstants.getUsedUserAccountsListKey(ZUID), usedServiceIds);
		if(usedServiceIds != null) {
			String[] usedServiceIdsArr = usedServiceIds.split(",");
			for(String serviceId : usedServiceIdsArr) {
				map.put(MemCacheConstants.USER + splitKey + MemCacheConstants.getUsedUserAccountKey(ZUID, IAMUtil.getInt(serviceId)), MemCacheUtil.get(MemCacheConstants.USER, MemCacheConstants.getUsedUserAccountKey(ZUID, IAMUtil.getInt(serviceId))));
			}
		}
	    }
	    else if (MemCacheConstants.GROUP.equals(pool)) {
		long ZGID = Long.parseLong(uniqueId);
		map.put(MemCacheConstants.GROUP + splitKey + MemCacheConstants.getGroupZGIDKey(ZGID), MemCacheUtil.get(MemCacheConstants.GROUP, MemCacheConstants.getGroupZGIDKey(ZGID)));
	    }
	    else if (MemCacheConstants.ORG.equals(pool)) {
		long ZOID = Long.parseLong(uniqueId);
		List<OrgIPRange> orgIpRanges = Util.ORGAPI.getAllowedIPsForOrg(ZOID);
		if (orgIpRanges != null) {
		    for (OrgIPRange orgIpRange : orgIpRanges) {
			if (orgIpRange.getIPRanges() != null) {
			    for (IPRange range : orgIpRange.getIPRanges()) {
				map.put(MemCacheConstants.ALLOWED_IP + splitKey + MemCacheConstants.getAllowedIPKey(range.getIPID()), MemCacheUtil.get(MemCacheConstants.ALLOWED_IP, MemCacheConstants.getAllowedIPKey(range.getIPID())));
			    }
			}
		    }
		}
		Org org = Util.ORGAPI.getOrg(ZOID);
		if (org != null) {
		    map.put(MemCacheConstants.ORG + splitKey + MemCacheConstants.getOrgScreenNameKey(org.getScreenName()), MemCacheUtil.get(MemCacheConstants.ORG, MemCacheConstants.getOrgScreenNameKey(org.getScreenName())));
		}
		map.put(MemCacheConstants.ORG + splitKey + MemCacheConstants.getOrgZOIDKey(ZOID), MemCacheUtil.get(MemCacheConstants.ORG, MemCacheConstants.getOrgZOIDKey(ZOID)));
		map.put(MemCacheConstants.ORG_POLICY + splitKey + MemCacheConstants.getOrgPolicyKey(ZOID), MemCacheUtil.get(MemCacheConstants.ORG_POLICY, MemCacheConstants.getOrgPolicyKey(ZOID)));
		map.put(MemCacheConstants.ORG_LOCATION + splitKey + MemCacheConstants.getOrgPolicyKey(ZOID), MemCacheUtil.get(MemCacheConstants.ORG_LOCATION, MemCacheConstants.getOrgPolicyKey(ZOID)));

		List<OrgDomain> allOrgDomain = Util.ORGAPI.getAllOrgDomain(ZOID);
		if (allOrgDomain != null) {
		    for (OrgDomain domain : allOrgDomain) {
			map.put(MemCacheConstants.ORG_DOMAIN + splitKey + MemCacheConstants.getOrgDomainKey(domain.getDomainName()), MemCacheUtil.get(MemCacheConstants.ORG_DOMAIN, MemCacheConstants.getOrgDomainKey(domain.getDomainName())));
		    }
		}

		List<OrgLocation> locations = Util.ORGAPI.getAllOrgLocation(ZOID);
		if (locations != null) {
		    for (OrgLocation location : locations) {
			if (location != null) {
			    map.put(MemCacheConstants.ORG_LOCATION + splitKey + MemCacheConstants.getOrgLocationKey(ZOID, location.getLocationName()), MemCacheUtil.get(MemCacheConstants.ORG_LOCATION, MemCacheConstants.getOrgLocationKey(ZOID, location.getLocationName())));
			}
		    }
		}

		map.put(MemCacheConstants.ORG + splitKey + MemCacheConstants.getOrgAllowedIPKey(ZOID), MemCacheUtil.get(MemCacheConstants.ORG, MemCacheConstants.getOrgAllowedIPKey(ZOID)));
		map.put(MemCacheConstants.ORG + splitKey + MemCacheConstants.getOrgUserListKey(ZOID, -1), MemCacheUtil.get(MemCacheConstants.ORG, MemCacheConstants.getOrgUserListKey(ZOID, -1)));
		map.put(MemCacheConstants.ORG + splitKey + MemCacheConstants.getOrgUserListKey(ZOID, User.ACTIVE), MemCacheUtil.get(MemCacheConstants.ORG, MemCacheConstants.getOrgUserListKey(ZOID, User.ACTIVE)));
		map.put(MemCacheConstants.ORG + splitKey + MemCacheConstants.getOrgUserListKey(ZOID, User.INACTIVE), MemCacheUtil.get(MemCacheConstants.ORG, MemCacheConstants.getOrgUserListKey(ZOID, User.INACTIVE)));
		map.put(MemCacheConstants.ORG + splitKey + MemCacheConstants.getOrgUserListKey(ZOID, User.CLOSED), MemCacheUtil.get(MemCacheConstants.ORG, MemCacheConstants.getOrgUserListKey(ZOID, User.CLOSED)));
		map.put(MemCacheConstants.ORG + splitKey + MemCacheConstants.getOrgUsersCountKey(ZOID, -1), MemCacheUtil.get(MemCacheConstants.ORG, MemCacheConstants.getOrgUsersCountKey(ZOID, -1)));
		map.put(MemCacheConstants.ORG + splitKey + MemCacheConstants.getOrgUsersCountKey(ZOID, User.INACTIVE), MemCacheUtil.get(MemCacheConstants.ORG, MemCacheConstants.getOrgUsersCountKey(ZOID, User.INACTIVE)));
		map.put(MemCacheConstants.ORG + splitKey + MemCacheConstants.getOrgUsersCountKey(ZOID, User.ACTIVE), MemCacheUtil.get(MemCacheConstants.ORG, MemCacheConstants.getOrgUsersCountKey(ZOID, User.ACTIVE)));
		map.put(MemCacheConstants.ORG + splitKey + MemCacheConstants.getOrgUsersCountKey(ZOID, User.CLOSED), MemCacheUtil.get(MemCacheConstants.ORG, MemCacheConstants.getOrgUsersCountKey(ZOID, User.CLOSED)));
		map.put(MemCacheConstants.ORG_GROUP + splitKey + MemCacheConstants.getOrgGroupListKey(ZOID), MemCacheUtil.get(MemCacheConstants.ORG_GROUP, MemCacheConstants.getOrgGroupListKey(ZOID)));
		map.put(MemCacheConstants.ORG_GROUP + splitKey + MemCacheConstants.getOrgGroupsCountKey(ZOID), MemCacheUtil.get(MemCacheConstants.ORG_GROUP, MemCacheConstants.getOrgGroupsCountKey(ZOID)));
		map.put(MemCacheConstants.ORG_LOCATION + splitKey + MemCacheConstants.getOrgLocationListKey(ZOID), MemCacheUtil.get(MemCacheConstants.ORG_LOCATION, MemCacheConstants.getOrgLocationListKey(ZOID)));
		map.put(MemCacheConstants.ORG_DOMAIN + splitKey + MemCacheConstants.getOrgDomainListKey(ZOID), MemCacheUtil.get(MemCacheConstants.ORG_DOMAIN, MemCacheConstants.getOrgDomainListKey(ZOID)));
		map.put(MemCacheConstants.PASSWORD_POLICY + splitKey + MemCacheConstants.getPasswordPolicyKey(ZOID), MemCacheUtil.get(MemCacheConstants.PASSWORD_POLICY, MemCacheConstants.getPasswordPolicyKey(ZOID)));

	    }
	    else if (MemCacheConstants.TICKET.equals(pool)) {
		map.put(MemCacheConstants.TICKET + splitKey + MemCacheConstants.getTicketKey(uniqueId), MemCacheUtil.get(MemCacheConstants.TICKET, MemCacheConstants.getTicketKey(uniqueId)));
	    }
	}
%>
	
	
	<table class="memcacheviewtbl">
	    <tr>
		<td width="15%" class="memcacheviewheader">Pool Name</td>  <%-- No I18N --%>
		<td width="16%" class="memcacheviewheader">Key Name</td>  <%-- No I18N --%>
		<td width="60%" class="memcacheviewheader">Key Value</td>  <%-- No I18N --%>
		<td width="7%" class="memcacheviewheader">Action</td>  <%-- No I18N --%>
	    </tr>
<%
	boolean hasValue = false;
	for (Map.Entry<String, Object> entry : map.entrySet()) {
	    if (entry.getValue() == null) {
		continue;
	    }
	    String[] keyAndPool = entry.getKey().split(splitKey);
	    Object memValue = entry.getValue();
	    hasValue = true;
%>
	    <tr id="<%=IAMEncoder.encodeHTMLAttribute(keyAndPool[1] + "_" + keyAndPool[0])%>">
		<td width="15%"><%=IAMEncoder.encodeHTML(keyAndPool[0])%></td>
		<td width="16%"><%=IAMEncoder.encodeHTML(keyAndPool[1])%><div id='valsize'></div></td>
		<td width="60%"">
			<div id="keyval" style="word-break: break-all;max-height: 500px;overflow: auto;">
				<%
				String value = "";
				switch (datatype){
					case "string" : //No I18N
					    if (MemCacheUtil.isInternalNullValue(memValue)) {
							value = " ---  Null Key In MemCache  --- "; //No I18N
					    }else{
					    	value = convertToString(memValue);
					    }
					    out.print(IAMEncoder.encodeHTML(value));
					   	break;
					case "set" :  //No I18N
					case "hash" : //No I18N
							Iterator itr = (Iterator) memValue;
						%>
						<ul id="itrlis">
						<%out.print(getNext(itr,datatype));%>
						</ul>
						<%
							if(itr.hasNext()){
						%>
						<a href="javascript:;" id="loadmoree" onclick="loadall('<%=keyAndPool[0] %>','<%=keyAndPool[1]%>','<%=datatype%>')">Load More</a>  <%-- No I18N --%>
						<%
						}
						break;
					case "sortedset" : //No I18N 
						Set values = (Set)memValue;
						%>
						<ul id="sortedlis">
						<%out.print(getNext(values.iterator(),datatype));%>
						</ul>
						<a href="javascript:;" id='sortedload' onclick="loadSortedSet('<%=keyAndPool[1]%>',25)">Load More</a>  <%-- No I18N --%>
						<%
						break;
				}
				
				%>
			</div>
		</td>
		<td width="7%"><a href="javascript:;" onclick="clearThisCache('<%=IAMEncoder.encodeJavaScript(keyAndPool[1])%>', '<%=IAMEncoder.encodeJavaScript(keyAndPool[0])%>')">Clear</a></td> <%-- No I18N --%>
	    </tr>
	<%} if(!hasValue) {%>
	<tr><td colspan="5" align="center">Nothing found for "<%= IAMEncoder.encodeHTML(uniqueId) %>"</td></tr> <%-- No I18N --%>
	<% } %>
	</table>
    <%
    } else {
	%>
<div class="maincontent">
    <div class="menucontent">
	<div class="topcontent"><div class="contitle">Memcache</div></div> <%-- No I18N --%>
	<div class="subtitle">Admin Services</div> <%-- No I18N --%>
    </div>

    <div class="field-bg">

	<div class="Hcbtn topbtn">
	    <div class="addnew" onclick="loadui('/ui/admin/clearmc.jsp'); initSelect2();">
		<span class="cbtnlt"></span>
		<span class="cbtnco">Clear Memcache</span> <%-- No I18N --%>
		<span class="cbtnrt"></span>
	    </div>
	</div>

	<%-- Memcache by ZUID. ZOID ZGID --%>
	<div class="memcachelink">
            <a href="javascript:;" id="cachebyid" class="disablememcachelink" onclick="showcacheform('viewmc')">Viewing Memcache by ZUID, ZOID, ZGID, TICKET</a> / <%-- No I18N --%>
            <a href="javascript:;" id="cachebykey" class="activememcachelink" onclick="showcacheform('cleark')">Viewing Memcache by computing the key</a> <%-- No I18N --%>
	</div>

	<div class="viewmc" id="headerdiv">
	    <form name="clear" id="viewmc" method="post" onsubmit="return viewCache(this)">
			<div class="labelmain">
			    <div class="labelkey">Select the pool :</div> <%-- No I18N --%>
			    <div class="labelvalue">
				<input type="hidden" name="action" value="view"/>
				<select name="pool" onchange="getSuffixes(this)" class="select select2Div">
				    <%for (MemCacheConstants pool : MemCacheConstants.values()) {%>
				    	<option value="<%=pool%>"><%=pool%></option> <%-- NO OUTPUTENCODING --%>
				    <% }%>
			    	<option value="<%=Pools.EPHEMERAL_POOL.getPoolName()%>"><%=Pools.EPHEMERAL_POOL.getPoolName()%></option> <%-- NO OUTPUTENCODING --%>
				</select>
			    </div>
			    <div class="labelkey">Enter the corresponding ID :</div> <%-- No I18N --%>
			    <div class="labelvalue"><input type="text" name="uniqueId" class="input" autocomplete="off" /></div>
			    <div class="accbtn Hbtn">
					<div class="savebtn" onclick="viewCache(document.clear)">
					    <span class="btnlt"></span>
					    <span class="btnco">View</span> <%-- No I18N --%>
					    <span class="btnrt"></span>
					</div>
					<div onclick="loadui('/ui/admin/viewcache.jsp'); initSelect2();">
					    <span class="btnlt"></span>
					    <span class="btnco">Cancel</span> <%-- No I18N --%>
					    <span class="btnrt"></span>
					</div>
			    </div>
			    <input type="submit" class="hidesubmit" />
			</div>
	    </form>

	    <form name="cleark" id="cleark" method="post" onsubmit="return viewCacheByKey(this)" style="display:none;">
		    <input type="hidden" name="action" value="view"/>
		    <div style="float:left;width:45%;">
	  		  	<div class="labelkey">Select the pool : </div> <%-- No I18N --%>
	 		   	<div class="labelvalue">
	 		   		<select name="pool" class=" pool select select2Div" onchange="showHelpCard(this)" style="margin-left:-3px;">
						 <%for (MemCacheConstants pool : MemCacheConstants.values()) {%>
				    	<option value="<%=pool%>"><%=pool%></option> <%-- NO OUTPUTENCODING --%>
				    <% }%>
			    	<option value="<%=Pools.EPHEMERAL_POOL.getPoolName()%>"><%=Pools.EPHEMERAL_POOL.getPoolName()%></option> <%-- NO OUTPUTENCODING --%>
			   		</select>
	 		   	</div>
	 		   	<div class="labelkey">Enter the computed key : </div> <%-- No I18N --%>
	 		   	<div class="labelvalue"><input type="text" name="uniqueId" class="input" autocomplete="off" /></div>
	 		   	<div class="labelkey">Select Data Type : </div> <%-- No I18N --%>
	 		   	<div class="labelvalue">
	 		   		<select style="width:200px;" class="select datatype" onchange="selectOpt(this)" name='datatype'><option value="string">String</option><option value='hash'>HashMap</option><option value='set'>Set</option><option value='sortedset'>Sorted Set</option></select> <%-- No I18N --%>
	 		   	</div>
		    	<div class="clearkbtn Hbtn" style="margin:10px auto;">
					<div class="savebtn" onclick="viewCacheByKey(document.cleark)">
					    <span class="btnlt"></span>
					    <span class="btnco">View</span> <%-- No I18N --%>
					    <span class="btnrt"></span>
					</div>
					<div onclick="loadui('/ui/admin/viewcache.jsp'); initSelect2();">
					    <span class="btnlt"></span>
					    <span class="btnco">Cancel</span> <%-- No I18N --%>
					    <span class="btnrt"></span>
					</div>
			    </div>
		    </div>
		    <div style="width:55%;float:right;">
	    		<table class="cachehelptbl" id="hc_user"><tr>
				    <td class="cachehelptitle">Pool</td> <%-- No I18N --%>
				    <td class="cachehelptitle">Value Type</td> <%-- No I18N --%>
				    <td class="cachehelptitle">Sample</td> <%-- No I18N --%>
				    <td class="cachehelptitle">Key value for the sample</td> <%-- No I18N --%>
				</tr><tr>
				    <td class="cachehelp"><%=MemCacheConstants.USER%></td> <%-- NO OUTPUTENCODING --%>
				    <td class="cachehelp">User Object</td> <%-- No I18N --%>
				    <td class="cachehelp">santhosh@zohocorp.com</td>  <%-- No I18N --%>
				    <td class="cachehelp"><%=MemCacheConstants.getUserEmailKey("santhosh@zohocorp.com")%></td> <%-- NO OUTPUTENCODING --%>
				</tr><tr>
				    <td class="cachehelp"><%=MemCacheConstants.USER%></td> <%-- NO OUTPUTENCODING --%>
				    <td class="cachehelp">User Object</td> <%-- No I18N --%>
				    <td class="cachehelp">283094</td> <%-- No I18N --%>
				    <td class="cachehelp"><%=MemCacheConstants.getUserZUIDKey(283094)%></td> <%-- NO OUTPUTENCODING --%>
				</tr><tr>
				    <td class="cachehelp"><%=MemCacheConstants.USER%></td> <%-- NO OUTPUTENCODING --%>
				    <td class="cachehelp">UserPreference Object</td> <%-- No I18N --%>
				    <td class="cachehelp">283094 (ZUID)</td> <%-- No I18N --%>
				    <td class="cachehelp"><%=MemCacheConstants.getUserPreferenceKey(283094)%></td> <%-- NO OUTPUTENCODING --%>
				</tr><tr>
				    <td class="cachehelp"><%=MemCacheConstants.USER_SERVICE%></td> <%-- NO OUTPUTENCODING --%>
				    <td class="cachehelp">UserAccount objects</td> <%-- No I18N --%>
				    <td class="cachehelp">ZUID "283094" and service id "2345"</td> <%-- No I18N --%>
				    <td class="cachehelp"><%=MemCacheConstants.getUserServiceKey(283094, 2345)%></td> <%-- NO OUTPUTENCODING --%>
				</tr></table>
		
				<%--group object help --%>
				<table class="cachehelptbl" id="hc_group" style="display:none;"><tr>
				    <td class="cachehelptitle">Pool</td> <%-- No I18N --%>
				    <td class="cachehelptitle">Value Type</td> <%-- No I18N --%>
				    <td class="cachehelptitle">Sample</td> <%-- No I18N --%>
				    <td class="cachehelptitle">Key value for the sample</td> <%-- No I18N --%>
				</tr><tr>
				    <td class="cachehelp"><%=MemCacheConstants.GROUP%></td> <%-- NO OUTPUTENCODING --%>
				    <td class="cachehelp">Group Object</td> <%-- No I18N --%>
				    <td class="cachehelp">12345 (ZGID)</td> <%-- No I18N --%>
				    <td class="cachehelp"><%=MemCacheConstants.getGroupZGIDKey(12345)%></td> <%-- NO OUTPUTENCODING --%>
				</tr><tr>
				    <td class="cachehelp"><%=MemCacheConstants.GROUP%></td> <%-- NO OUTPUTENCODING --%>
				    <td class="cachehelp">Comma separated ZGID's for an user</td> <%-- No I18N --%>
				    <td class="cachehelp">283094 (ZUID)</td> <%-- No I18N --%>
				    <td class="cachehelp"><%=MemCacheConstants.getUserPersonalGroupZGIDsListKey(283094)%></td> <%-- NO OUTPUTENCODING --%>
				</tr><tr>
				    <td class="cachehelp"><%=MemCacheConstants.GROUP%></td> <%-- NO OUTPUTENCODING --%>
				    <td class="cachehelp">Comma separated user/org ZGID's for an user(zid_oid)</td><%-- No I18N --%>
				    <td class="cachehelp">283094 (ZUID)</td><%-- No I18N --%>
				    <td class="cachehelp"><%=MemCacheConstants.getUserOrgGroupZGIDsListKey(283094)%></td> <%-- NO OUTPUTENCODING --%>
				</tr><tr>
				    <td class="cachehelp"><%=MemCacheConstants.GROUP%></td> <%-- NO OUTPUTENCODING --%>
				    <td class="cachehelp">Comma separated ZGID's</td> <%-- No I18N --%>
				    <td class="cachehelp">ZUID "283094"</td> <%-- No I18N --%>
				    <td class="cachehelp"><%=MemCacheConstants.getUserInvitedGroupListKey(283094)%></td> <%-- NO OUTPUTENCODING --%>
				</tr></table>
		
				<%--org object help --%>
				<table class="cachehelptbl" id="hc_org" style="display:none;"><tr>
				    <td class="cachehelptitle">Pool</td> <%-- No I18N --%>
				    <td class="cachehelptitle">Value Type</td> <%-- No I18N --%>
				    <td class="cachehelptitle">Sample</td> <%-- No I18N --%>
				    <td class="cachehelptitle">Key value for the sample</td> <%-- No I18N --%>
				</tr><tr>
				    <td class="cachehelp"><%=MemCacheConstants.ORG%></td> <%-- NO OUTPUTENCODING --%>
				    <td class="cachehelp">Org Object</td> <%-- No I18N --%>
				    <td class="cachehelp">zohocorp</td> <%-- No I18N --%>
				    <td class="cachehelp"><%=MemCacheConstants.getOrgScreenNameKey("zohocorp")%></td> <%-- NO OUTPUTENCODING --%>
				</tr><tr>
				    <td class="cachehelp"><%=MemCacheConstants.ORG%></td> <%-- NO OUTPUTENCODING --%>
				    <td class="cachehelp">Org Object</td> <%-- No I18N --%>
				    <td class="cachehelp">456089</td> <%-- No I18N --%>
				    <td class="cachehelp"><%=MemCacheConstants.getOrgZOIDKey(456089)%></td> <%-- NO OUTPUTENCODING --%>
				</tr><tr>
				    <td class="cachehelp"><%=MemCacheConstants.ORG_GROUP%></td> <%-- NO OUTPUTENCODING --%>
				    <td class="cachehelp">Comma separted org groups ZGID</td> <%-- No I18N --%>
				    <td class="cachehelp">456089 (ZOID)</td> <%-- No I18N --%>
				    <td class="cachehelp"><%=MemCacheConstants.getOrgGroupListKey(456089)%></td> <%-- NO OUTPUTENCODING --%>
				</tr><tr>
				    <td class="cachehelp"><%=MemCacheConstants.ORG_POLICY%></td> <%-- NO OUTPUTENCODING --%>
				    <td class="cachehelp">Org Policy Object</td> <%-- No I18N --%>
				    <td class="cachehelp">456089 (ZOID)</td> <%-- No I18N --%>
				    <td class="cachehelp"><%=MemCacheConstants.getOrgPolicyKey(456089)%></td> <%-- NO OUTPUTENCODING --%>
				</tr><tr>
				    <td class="cachehelp"><%=MemCacheConstants.ORG%></td> <%-- NO OUTPUTENCODING --%>
				    <td class="cachehelp">Comma separated user list</td> <%-- No I18N --%>
				    <td class="cachehelp">456089 (ZOID)</td> <%-- No I18N --%>
				    <td class="cachehelp"><%=MemCacheConstants.getOrgUserListKey(456089, User.ACTIVE)%></td> <%-- NO OUTPUTENCODING --%>
				</tr><tr>
				    <td class="cachehelp"><%=MemCacheConstants.ORG_LOCATION%></td> <%-- NO OUTPUTENCODING --%>
				    <td class="cachehelp">Location list</td> <%-- No I18N --%>
				    <td class="cachehelp">456089 (ZOID)</td> <%-- No I18N --%>
				    <td class="cachehelp"><%=MemCacheConstants.getOrgLocationListKey(456089)%></td> <%-- NO OUTPUTENCODING --%>
				</tr><tr>
				    <td class="cachehelp"><%=MemCacheConstants.ORG_LOCATION%></td> <%-- NO OUTPUTENCODING --%>
				    <td class="cachehelp">Location Object</td> <%-- No I18N --%>
				    <td class="cachehelp">"456089" (ZOID) , "chennai-office" (location name)</td> <%-- No I18N --%>
				    <td class="cachehelp"><%=MemCacheConstants.getOrgLocationKey(456089, "chennai-office")%></td> <%-- NO OUTPUTENCODING --%>
				</tr><tr>
				    <td class="cachehelp"><%=MemCacheConstants.ORG_DOMAIN%></td> <%-- NO OUTPUTENCODING --%>
				    <td class="cachehelp">OrgDomain object</td> <%-- No I18N --%>
				    <td class="cachehelp">adventnet.com (Domain Name)</td> <%-- No I18N --%>
				    <td class="cachehelp"><%=MemCacheConstants.getOrgDomainKey("adventnet.com")%></td> <%-- NO OUTPUTENCODING --%>
				</tr><tr>
				    <td class="cachehelp"><%=MemCacheConstants.ORG_DOMAIN%></td> <%-- NO OUTPUTENCODING --%>
				    <td class="cachehelp">Org domain list by ZOID</td> <%-- No I18N --%>
				    <td class="cachehelp">456089 (ZOID)</td> <%-- No I18N --%>
				    <td class="cachehelp"><%=MemCacheConstants.getOrgDomainListKey(456089)%></td> <%-- NO OUTPUTENCODING --%>
				</tr><tr>
				    <td class="cachehelp"><%=MemCacheConstants.PASSWORD_POLICY%></td> <%-- NO OUTPUTENCODING --%>
				    <td class="cachehelp">PasswordPolicy object</td> <%-- No I18N --%>
				    <td class="cachehelp">456089 (ZOID)</td> <%-- No I18N --%>
				    <td class="cachehelp"><%=MemCacheConstants.getPasswordPolicyKey(456089)%></td> <%-- NO OUTPUTENCODING --%>
				</tr><tr>
				    <td class="cachehelp"><%=MemCacheConstants.ALLOWED_IP%></td> <%-- NO OUTPUTENCODING --%>
				    <td class="cachehelp">IPRanges for IPID</td> <%-- No I18N --%>
				    <td class="cachehelp">54321 (IPID)</td> <%-- No I18N --%>
				    <td class="cachehelp"><%=MemCacheConstants.getAllowedIPKey(54321)%></td> <%-- NO OUTPUTENCODING --%>
				</tr><tr>
				    <td class="cachehelp"><%=MemCacheConstants.ORG%></td> <%-- NO OUTPUTENCODING --%>
				    <td class="cachehelp">Status specific Count value</td>	<%-- No I18N --%>
				    <td class="cachehelp">456089 (ZOID)</td>	<%-- No I18N --%>
				    <td class="cachehelp"><%=MemCacheConstants.getOrgUsersCountKey(456089, 0)%></td> <%-- NO OUTPUTENCODING --%>
				</tr><tr>
				    <td class="cachehelp"><%=MemCacheConstants.ORG_GROUP%></td> <%-- NO OUTPUTENCODING --%>
				    <td class="cachehelp">Org groups count</td>	<%-- No I18N --%>
				    <td class="cachehelp">456089 (ZOID)</td>	<%-- No I18N --%>
				    <td class="cachehelp"><%=MemCacheConstants.getOrgGroupsCountKey(456089)%></td> <%-- NO OUTPUTENCODING --%>
				</tr></table>
		
				<%--ticket object help --%>
				<table class="cachehelptbl" id="hc_ticket" style="display:none;"><tr>
				    <td class="cachehelptitle">Pool</td> <%-- No I18N --%>
				    <td class="cachehelptitle">Value Type</td> <%-- No I18N --%>
				    <td class="cachehelptitle">Sample</td> <%-- No I18N --%>
				    <td class="cachehelptitle">Key value for the sample</td> <%-- No I18N --%>
				</tr><tr>
				    <td class="cachehelp"><%=MemCacheConstants.TICKET%></td> <%-- NO OUTPUTENCODING --%>
				    <td class="cachehelp">Ticket Object</td> <%-- No I18N --%>
				    <td class="cachehelp">SAMPLE-TICKET</td> <%-- No I18N --%>
				    <td class="cachehelp"><%=MemCacheConstants.getTicketKey("SAMPLE-TICKET")%></td> <%-- NO OUTPUTENCODING --%>
				</tr><tr>
				    <td class="cachehelp"><%=MemCacheConstants.TICKET%></td> <%-- NO OUTPUTENCODING --%>
				    <td class="cachehelp">Comma separated ISCTickets</td> <%-- No I18N --%>
				    <td class="cachehelp">283094</td> <%-- No I18N --%>
				    <td class="cachehelp"><%=MemCacheConstants.getISCTicketZUIDKey(283094, true)%></td> <%-- NO OUTPUTENCODING --%>
				</tr></table>
		
				<%--photo object help --%>
				<table class="cachehelptbl" id="hc_photo" style="display:none;"><tr>
				    <td class="cachehelptitle">Pool</td> <%-- No I18N --%>
				    <td class="cachehelptitle">Value Type</td> <%-- No I18N --%>
				    <td class="cachehelptitle">Sample</td> <%-- No I18N --%>
				    <td class="cachehelptitle">Key value for the sample</td> <%-- No I18N --%>
				</tr><tr>
				    <td class="cachehelp"><%=MemCacheConstants.PHOTO%></td> <%-- NO OUTPUTENCODING --%>
				    <td class="cachehelp">Photo stream</td> <%-- No I18N --%>
				    <td class="cachehelp">id "283094" and size "1"</td> <%-- No I18N --%>
				    <td class="cachehelp"><%=MemCacheConstants.getPhotoKey("" + 283094, 1)%></td> <%-- NO OUTPUTENCODING --%>
				</tr><tr>
				    <td class="cachehelp"><%=MemCacheConstants.PHOTO%></td> <%-- NO OUTPUTENCODING --%>
				    <td class="cachehelp">Last Modified time</td> <%-- No I18N --%>
				    <td class="cachehelp">Photo key for last modified time "283094"</td> <%-- No I18N --%>
				    <td class="cachehelp"><%=MemCacheConstants.getPhotoKeyForLastModifiedTime("" + 283094)%></td> <%-- NO OUTPUTENCODING --%>
				</tr></table>
		
				<%--serviceorg object help --%>
				<table class="cachehelptbl" id="hc_serviceorg" style="display:none;"><tr>
				    <td class="cachehelptitle">Pool</td> <%-- No I18N --%>
				    <td class="cachehelptitle">Value Type</td> <%-- No I18N --%>
				    <td class="cachehelptitle">Sample</td> <%-- No I18N --%>
				    <td class="cachehelptitle">Key value for the sample serviceorgserviceorgserviceorg</td> <%-- No I18N --%>
				</tr>
				<tr>
				    <td class="cachehelp"><%=MemCacheConstants.SERVICEORG%></td> <%-- NO OUTPUTENCODING --%>
				    <td class="cachehelp">Integer: Org Type</td> <%-- No I18N --%>
				    <td class="cachehelp">20</td>
				    <td class="cachehelp"><%=MemCacheConstants.getZSOIDOrgTypeKey(200158L)%></td> <%-- NO OUTPUTENCODING --%>
				</tr>
				<tr>
				    <td class="cachehelp"><%=MemCacheConstants.SERVICEORG%></td> <%-- NO OUTPUTENCODING --%>
				    <td class="cachehelp">String : ZSOID associated to the ZAID</td> <%-- No I18N --%>
				    <td class="cachehelp">456089</td>
				    <td class="cachehelp"><%=MemCacheConstants.getServiceOrgByZAIDKey(8, 456089L) %></td> <%-- NO OUTPUTENCODING --%>
				</tr>
				<tr>
				    <td class="cachehelp"><%=MemCacheConstants.SERVICEORG%></td> <%-- NO OUTPUTENCODING --%>
				    <td class="cachehelp">ServiceOrg object</td> <%-- No I18N --%>
				    <td class="cachehelp">ServiceOrg xml string</td> <%-- No I18N --%>
				    <td class="cachehelp"><%=MemCacheConstants.getServiceOrgKey(5, 356622L)%></td> <%-- NO OUTPUTENCODING --%>
				</tr>
				<tr>
				    <td class="cachehelp"><%=MemCacheConstants.SERVICEORG%></td> <%-- NO OUTPUTENCODING --%>
				    <td class="cachehelp">Comma separated zsoids</td> <%-- No I18N --%>
				    <td class="cachehelp">200158,9289112,12302002</td>
				    <td class="cachehelp"><%=MemCacheConstants.getAllServiceOrgsListKey(8, 846192L)%></td> <%-- NO OUTPUTENCODING --%>
				</tr>
				<tr>
				    <td class="cachehelp"><%=MemCacheConstants.SERVICEORG%></td> <%-- NO OUTPUTENCODING --%>
				    <td class="cachehelp">ServiceOrgMember object</td> <%-- No I18N --%>
				    <td class="cachehelp">ServiceOrgMember XML String</td> <%-- No I18N --%>
				    <td class="cachehelp"><%=MemCacheConstants.getServiceOrgMemberKey(18, 200158L, 846202L)%></td> <%-- NO OUTPUTENCODING --%>
				</tr>
				<tr>
				    <td class="cachehelp"><%=MemCacheConstants.SERVICEORG%></td> <%-- NO OUTPUTENCODING --%>
				    <td class="cachehelp">Comma separated member ZUIDs by role. -1, 0, 1, 2 (All, Normal, Moderator, Admin)</td> <%-- No I18N --%>
				    <td class="cachehelp">846192,926192,846021</td>
				    <td class="cachehelp"><%=MemCacheConstants.getServiceOrgMemberListKey(20, 200158L, -1)%></td> <%-- NO OUTPUTENCODING --%>
				</tr>
				<tr>
				    <td class="cachehelp"><%=MemCacheConstants.SERVICEORG%></td> <%-- NO OUTPUTENCODING --%>
				    <td class="cachehelp">ServiceOrgDomain object</td> <%-- No I18N --%>
				    <td class="cachehelp">ServiceOrgDomain XML String</td> <%-- No I18N --%>
				    <td class="cachehelp"><%=MemCacheConstants.getServiceOrgDomainKey(20, "zohocorp.com")%></td> <%-- NO OUTPUTENCODING --%>
				</tr>
				<tr>
				    <td class="cachehelp"><%=MemCacheConstants.SERVICEORG%></td> <%-- NO OUTPUTENCODING --%>
				    <td class="cachehelp">Comma sepatated domain names</td> <%-- No I18N --%>
				    <td class="cachehelp">zohocorp,zohocorp.com,teamiam</td> <%-- No I18N --%>
				    <td class="cachehelp"><%=MemCacheConstants.getServiceOrgDomainListKey(20, 200158L)%></td> <%-- NO OUTPUTENCODING --%>
				</tr>
				<tr>
				    <td class="cachehelp"><%=MemCacheConstants.SERVICEORG%></td> <%-- NO OUTPUTENCODING --%>
				    <td class="cachehelp">Properties VO object</td> <%-- No I18N --%>
				    <td class="cachehelp">VO XML String</td> <%-- No I18N --%>
				    <td class="cachehelp"><%=MemCacheConstants.getServiceOrgProperties(20, 200158L)%></td> <%-- NO OUTPUTENCODING --%>
				</tr>
				<tr>
				    <td class="cachehelp"><%=MemCacheConstants.SERVICEORG%></td> <%-- NO OUTPUTENCODING --%>
				    <td class="cachehelp">Comma sepatated ZAIDs</td> <%-- No I18N --%>
				    <td class="cachehelp">200158,456089</td>
				    <td class="cachehelp"><%=MemCacheConstants.getServiceOrgZAIDListKey(20, 200158L)%></td> <%-- NO OUTPUTENCODING --%>
				</tr>
				<tr>
				    <td class="cachehelp"><%=MemCacheConstants.SERVICEORG%></td> <%-- NO OUTPUTENCODING --%>
				    <td class="cachehelp">Default ZSOID choosen by the user</td> <%-- No I18N --%>
				    <td class="cachehelp">200158</td>
				    <td class="cachehelp"><%=MemCacheConstants.getDefaultServiceOrgKey(20, 846202L, AccountsConstants.Environment.PRODUCTION.getasInt())%></td> <%-- NO OUTPUTENCODING --%>
				</tr>
				<tr>
				    <td class="cachehelp"><%=MemCacheConstants.SERVICEORG%></td> <%-- NO OUTPUTENCODING --%>
				    <td class="cachehelp">Comma separated ZSOID of this user</td> <%-- No I18N --%>
				    <td class="cachehelp">200158,456089</td>
				    <td class="cachehelp"><%=MemCacheConstants.getUserServiceOrgsRoleBased(846202L,-1)%></td> <%-- NO OUTPUTENCODING --%>
				</tr>
				<tr>
				    <td class="cachehelp"><%=MemCacheConstants.SERVICEORG%></td> <%-- NO OUTPUTENCODING --%>
				    <td class="cachehelp">VO object of Address</td> <%-- No I18N --%>
				    <td class="cachehelp">-</td>
				    <td class="cachehelp"><%=MemCacheConstants.getServiceOrgAddressKey(20, 200158L, 1)%></td> <%-- NO OUTPUTENCODING --%>
				</tr>
				</table>
		
				<%--general help --%>
				<table class="cachehelptbl" id="hc_general" style="display:none;"><tr>
				    <td class="cachehelptitle">Pool</td> <%-- No I18N --%>
				    <td class="cachehelptitle">Value Type</td> <%-- No I18N --%>
				    <td class="cachehelptitle">Sample</td> <%-- No I18N --%>
				    <td class="cachehelptitle">Key value for the sample</td> <%-- No I18N --%>
				</tr><tr>
				    <td class="cachehelp"><%=MemCacheConstants.GENERAL%></td> <%-- NO OUTPUTENCODING --%>
				    <td class="cachehelp">Captcha String for the specified digest</td> <%-- No I18N --%>
				    <td class="cachehelp">SAMPLE-DIGEST</td> <%-- No I18N --%>
				    <td class="cachehelp"><%=MemCacheConstants.getCaptchaKey("SAMPLE-DIGEST")%></td> <%-- NO OUTPUTENCODING --%>
				</tr></table>
		
				<%--AUTHDOMAIM help --%>
				<table class="cachehelptbl" id="hc_authdomain" style="display:none;"><tr>
				    <td class="cachehelptitle">Pool</td> <%-- No I18N --%>
				    <td class="cachehelptitle">Value Type</td> <%-- No I18N --%>
				    <td class="cachehelptitle">Sample</td> <%-- No I18N --%>
				    <td class="cachehelptitle">Key value for the sample</td> <%-- No I18N --%>
				</tr>
				<tr>
				    <td class="cachehelp"><%=MemCacheConstants.AUTHDOMAIN%></td> <%-- NO OUTPUTENCODING --%>
				    <td class="cachehelp">AuthorizedIp Proto Message object</td> <%-- No I18N --%>
				    <td class="cachehelp">-</td> <%-- No I18N --%>
				    <td class="cachehelp"><%=MemCacheConstants.getAuthDomainIPListKey(456089L, "$domain")%></td> <%-- NO OUTPUTENCODING --%>
				</tr>
				<tr>
				    <td class="cachehelp"><%=MemCacheConstants.AUTHDOMAIN%></td> <%-- NO OUTPUTENCODING --%>
				    <td class="cachehelp">Comma separated AuthDomain names in the Org</td> <%-- No I18N --%>
				    <td class="cachehelp">default,admin,crm-group1</td> <%-- No I18N --%>
				    <td class="cachehelp"><%=MemCacheConstants.getOrgAuthDomainsKey(456089L)%></td> <%-- NO OUTPUTENCODING --%>
				</tr>
				<tr>
				    <td class="cachehelp"><%=MemCacheConstants.AUTHDOMAIN%></td> <%-- NO OUTPUTENCODING --%>
				    <td class="cachehelp">Comma separated AuthDomain Names of User</td> <%-- No I18N --%>
				    <td class="cachehelp">admin,crm-group2</td> <%-- No I18N --%>
				    <td class="cachehelp"><%=MemCacheConstants.getUserAuthDomainsKey(200158L,true)%></td> <%-- NO OUTPUTENCODING --%>
				</tr>
				<tr>
				    <td class="cachehelp"><%=MemCacheConstants.AUTHDOMAIN%></td> <%-- NO OUTPUTENCODING --%>
				    <td class="cachehelp">Comma separated ZUID list of users in AuthDomain</td> <%-- No I18N --%>
				    <td class="cachehelp">200158,12321312,58788</td> <%-- No I18N --%>
				    <td class="cachehelp"><%=MemCacheConstants.getAuthDomainUsersKey(456089L, "$domain")%></td> <%-- NO OUTPUTENCODING --%>
				</tr>
				</table>
				<table class="cachehelptbl" id="hc_appaccount" style="display:none;"><tr>
				    <td class="cachehelptitle">Pool</td> <%-- No I18N --%>
				    <td class="cachehelptitle">Value Type</td> <%-- No I18N --%>
				    <td class="cachehelptitle">Sample</td> <%-- No I18N --%>
				    <td class="cachehelptitle">Key value for the sample</td> <%-- No I18N --%>
				</tr>
				<tr>
				    <td class="cachehelp"><%=MemCacheConstants.APPACCOUNT%></td> <%-- NO OUTPUTENCODING --%>
				    <td class="cachehelp">AppAccount Proto Message object</td> <%-- No I18N --%>
				    <td class="cachehelp">-</td> <%-- No I18N --%>
				    <td class="cachehelp"><%=MemCacheConstants.getAppAccountKey(456089L, 533312L)%></td> <%-- NO OUTPUTENCODING --%>
				</tr>
				<tr>
				    <td class="cachehelp"><%=MemCacheConstants.APPACCOUNT%></td> <%-- NO OUTPUTENCODING --%>
				    <td class="cachehelp">AppAccountMember Proto Message object</td> <%-- No I18N --%>
				    <td class="cachehelp">-</td> <%-- No I18N --%>
				    <td class="cachehelp"><%=MemCacheConstants.getAppAccountMemberKey(456089L, 533312L, 200158L)%></td> <%-- NO OUTPUTENCODING --%>
				</tr>
				<tr>
				    <td class="cachehelp"><%=MemCacheConstants.APPACCOUNT%></td> <%-- NO OUTPUTENCODING --%>
				    <td class="cachehelp">Comma separated ZAAIDs of the User's AppAccount</td> <%-- No I18N --%>
				    <td class="cachehelp">533312,633312,9273821</td> <%-- No I18N --%>
				    <td class="cachehelp"><%=MemCacheConstants.getAllAppAccountsKey(456089L, 200158L)%></td> <%-- NO OUTPUTENCODING --%>
				</tr>
				<tr>
				    <td class="cachehelp"><%=MemCacheConstants.APPACCOUNT%></td> <%-- NO OUTPUTENCODING --%>
				    <td class="cachehelp">Boolean: True if Admin</td> <%-- No I18N --%>
				    <td class="cachehelp">true</td> <%-- No I18N --%>
				    <td class="cachehelp"><%=MemCacheConstants.getIsServiceAdminKey(456089L, 200158L)%></td> <%-- NO OUTPUTENCODING --%>
				</tr>
				</table>
				<table class="cachehelptbl" id="hc_audit" style="display:none;"><tr>
				    <td class="cachehelptitle">Pool</td> <%-- No I18N --%>
				    <td class="cachehelptitle">Value Type</td> <%-- No I18N --%>
				    <td class="cachehelptitle">Sample</td> <%-- No I18N --%>
				    <td class="cachehelptitle">Key value for the sample</td> <%-- No I18N --%>
				</tr>
				<tr>
				    <td class="cachehelp"><%=MemCacheConstants.AUDIT%></td> <%-- NO OUTPUTENCODING --%>
				    <td class="cachehelp">User successful signin count for the specified date</td> <%-- No I18N --%>
				    <td class="cachehelp">ZUID "283094" and Date "<%=MemCacheConstants.getDate()%>"</td> <%-- NO OUTPUTENCODING --%> <%-- No I18N --%>
				    <td class="cachehelp"><%=MemCacheConstants.getUserSuccessSigninAuditKey("283094", MemCacheConstants.getDate())%></td> <%-- NO OUTPUTENCODING --%>
				</tr>
				</table>
		    </div>
	    </form>
   	</div>
   	<div id="overflowdiv" style="float:left;width:100%; "><div id="output_mc" style="display:none;"></div></div>
   </div>
</div>
<%
    }
%>