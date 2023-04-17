<%-- $Id$ --%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@page import="com.adventnet.sas.util.StatisticsProvider"%>
<%@ include file="includes.jsp" %>
<%-- $Id$ --%>
<%@ page import="com.adventnet.sas.ds.QueryProvider"%>
<%@ page import="com.adventnet.sas.util.DBUtil"%>
<div class="maincontent">
    <div class="menucontent">
	<div class="topcontent"><div class="contitle">Clear Cache</div></div><%--No I18N--%>
	<div class="subtitle">Admin Services</div><%--No I18N--%>
    </div>
    <div class="field-bg">
        <div class="restorelink">
            <a href="javascript:;" id="iam_cache_link" onclick="changeClearCacheForm(this, true)"class="disablerslink">Clear IAM local server cache</a> / <%--No I18N--%>
            <%if(request.isUserInRole("IAMAdmininistrator")) {  %>
            	<a href="javascript:;" id="agent_cache_link" onclick="changeClearCacheForm(this, false)" class="activerslink">Clear IAM AGENT(Services) cache</a><%--No I18N--%>
            <%} %>
        </div>
	<form name="clearcacheinvoker" id="iam_clearcache" class="zform" onsubmit="javascript:return c(this);" method="post">
		<div>
		    <div class="clearcache_list">
		    	<div class="checkiplist" style="font-weight: bold;margin-left:0px;"><input type="checkbox" onclick="checkAllIps(this.checked)"/>Select All</div><%--No I18N--%>
		    	<div class="innerips">
		    	<%
		    	List appServerList = DBUtil.getResultAsList(StatisticsProvider.get_AppServers , 15);
		    	Map<String,List<String>> groupVsIPS = new HashMap<String,List<String>>(); 
		    	for(int i=0;i<appServerList.size();i++) {
					 List<String> dataProp = (List)appServerList.get(i);
					 String port = dataProp.get(9).trim();
		             String nodeIp = dataProp.get(0);
		             String appGroup = dataProp.get(13);
		             
		             if(!groupVsIPS.containsKey(appGroup)){
		            	 groupVsIPS.put(appGroup, new ArrayList<String>());
		             }
		             
		             if(port.equals("8080")){
		            	 groupVsIPS.get(appGroup).add(nodeIp);
		             }else{
			    		nodeIp = nodeIp.contains(":") ? "["+nodeIp+"]" : nodeIp;
			    		String prePort = nodeIp+":"+port;
			    		groupVsIPS.get(appGroup).add(prePort);	
		             }
		        }
		    	
		    	if(!groupVsIPS.isEmpty()){
		    		for(String group : groupVsIPS.keySet()){		    			
		    			%>
		    			<span class="clearcachegroupname"><%=IAMEncoder.encodeHTMLAttribute(String.valueOf(group))%>-</span>
		    			<%
		    			for(String nodeIp : groupVsIPS.get(group)){		    			
		    		%>
	    				<div class="checkiplist"><input type="checkbox" value="<%=IAMEncoder.encodeHTMLAttribute(String.valueOf(nodeIp))%>" name="checkips"><%=IAMEncoder.encodeHTML(String.valueOf(nodeIp))%></div>
	    			<%
		    			}
		    		}
		    	}
		    	
				%>
		    	</div>
		    </div>
		    <div class="clearcachebutton"><input type="button" value="Clear" class="buttonholder_next" onclick="clearSelectedAppServers('Do you want to Clear cache in selected app servers?',true)"></div>
		</div>
		<br/><hr><br/>
		<div class="clearcache_list">
			<p>Clear IAM local server cache by ip's</p><%--No I18N--%>
	    	<div class="labelvalue">
				<textarea style="font-size:10px;" id="iplist" name="body" rows="10" cols="50" placeholder="127.0.0.1,127.0.0.2,127.0.0.3"></textarea>
			</div>
			<div><input type="button" value="Clear" class="buttonholder_next" onclick="clearCacheAppserverByInput()"></div>
	    </div>
	
	</form>
	<form name="clearagentcache" id="agent_clearcache" class="zform" onsubmit="return clearAgentConfigurationCache(this);" method="post" style="display:none;">
	    <div class="labelmain">
			<div class="labelkey">Service Name :</div> <%--No I18N--%>
			<div class="labelvalue">
		    	<select name="serviceName" class="select" id="servicehtml5">
					<option value="select">----select----</option><%--No I18N--%>
					<%for(Service s: ss) { %><option value='<%=IAMEncoder.encodeHTMLAttribute(s.getServiceName())%>'><%=IAMEncoder.encodeHTML(s.getServiceName())%></option><% } %>
					<option value='all'>All Services</option><%--No I18N--%>
		    	</select>
		       	<!-- html5 -->
		 		<div class='canvascheck'>
					<input class="input" name="serviceName" list="services" />
		    		<datalist id="services"> <%--No I18N--%>
						<%for(Service s: ss){%><option value='<%=IAMEncoder.encodeHTMLAttribute(s.getServiceName())%>'><%}%>
						<option value='all'><%--No I18N--%>
 					</datalist><%--No I18N--%>
 				</div>
 				<!-- html5 -->
			</div>
			<div class="labelkey">Configuration :</div><%--No I18N--%>
			<div class="labelvalue">
				<select name="url_param" class="select"><%--No I18N--%>
				<option value="select">Select</option> <%--No I18N--%>
				<option value="clearconfig">L7IPs Cache</option> <%--No I18N--%>
				<option value="clearcryptoinstance">Crypto Instance</option> <%--No I18N--%>
				<option value="cleargeodetailscache">service InJVM cache</option> <%--No I18N--%>
				<!-- <option value="iaminternalurlcache">IAMServer internal Url Cache</option> --> <%--No I18N--%>
				<!-- <option value="clearappconfig">App Configurations Cache</option> --> <%--No I18N--%>  
				</select>
			</div>
			<div class="labelkey">Enter Admin Password :</div><%--No I18N--%>
			<div class="labelvalue"><input type="password" name="pwd" class="input"/></div>
			<div class="accbtn Hbtn">
	    		<div class="savebtn" onclick="clearAgentConfigurationCache(document.clearagentcache)">
					<span class="btnlt"></span>
					<span class="btnco" id="resetbtn">Clear</span><%--No I18N--%>
					<span class="btnrt"></span>
	    		</div>
	    		<div onclick="">
					<span class="btnlt"></span>
					<span class="btnco">Cancel</span><%--No I18N--%>
					<span class="btnrt"></span>
	    		</div>
			</div>
			<input type="submit" class="hidesubmit" />
			<input type="hidden" name="clr_status" value="1"/> <%-- NO OUTPUTENCODING --%>
		</div>
    	<div id="details" style="display:none;">
		<a href="javascript:;" onclick="de('result').style.display='';">Details &raquo;</a> <%--No I18N--%> 
	    </div>
	    <div id="result" style="display:none;"></div>
	</form>
    </div>
</div>
