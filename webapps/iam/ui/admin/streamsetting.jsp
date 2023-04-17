<%-- $Id$ --%>
<%@page import="com.zoho.accounts.internal.util.AppConfiguration"%>
<%@page import="com.zoho.accounts.notification.RedisStream"%>
<%@page import="com.zoho.accounts.notification.IAMStreamUtil"%>
<%@page import="com.zoho.accounts.messaging.RedisMessageHandler"%>
<%@page import="com.zoho.accounts.internal.zac.ZACUtil"%>
<%@page import="com.adventnet.iam.Service"%>
<%@page import="java.util.Collection"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Arrays"%>
<%@page import="com.zoho.accounts.AccountsConfiguration"%>
<%@page import="com.adventnet.iam.internal.Util"%>
<%@page import="com.adventnet.iam.xss.IAMEncoder"%>
<%@ include file="includes.jsp" %>
<%
String enabledconf = AccountsConfiguration.getConfiguration("redis.streams.enabled.services", "AaaServer").toLowerCase(); // No I18N
List<String> streamEnabledServices = Arrays.asList(enabledconf.split(",")); //No I18N
String type = request.getParameter("type");
if(type == null) {
%>
<div class="maincontent">
	<div class="menucontent">
		<div class="topcontent">
			<div class="contitle" id="restoretitle">Stream Settings</div>	<%--No I18N--%>
		</div>

		<div class="subtitle">Admin Services</div> <%--No I18N--%>
	</div>
		<%
	 		boolean isStreamsEnabled = AccountsConfiguration.getConfigurationTyped("redis.streams.enabled", false); //No I18N
		%>
	
			<div style="position: fixed; height: 30%; overflow: scroll; width:71%" >

				<table class="usremailtbl" style="border:none; text-align: center; max-height: 40%; overflow-y: scroll; padding-top: 10px;">
					<tr>
						<td class="usremailtd" style="border:none;" width="20%">Stream Status</td> <%--No I18N--%>
						<td class="usremailtd" style="border:none;" width="65%">
							<div class="togglebtn_div">
								<input class="real_togglebtn suscription_radio" id="streamenabled" <%=isStreamsEnabled ? "checked" : ""%> onchange="changeStreamStatus()" type="checkbox">
								<div class="togglebase">
									<div class="toggle_circle"></div>							
								</div>
							</div>
						</td>
						<td></td>
					</tr>
					<tr>
						<td class="usremailtd" style='border:none;' width="20%">Stream Enabled Services</td> <%--No I18N--%>
						<td class="usremailtd" style='border:solid lightgray;' width="65%">
							<div style="max-height: 120px;overflow-y: scroll; margin-right: 4% !important">
								<%for(String service : streamEnabledServices) { %>
									<span style="cursor:pointer;" onclick="showStream('<%=service %>')"><%=service %></span>,
								<%} %>
							</div>
						</td>
						<td width=15%>
							<%if(!"all".equals(enabledconf)) {%>
								<div class="accbtn Hbtn" style="width: 100%">
									<div class="savebtn" onclick="openPopUp('addService')">
										<span class="btnlt"></span> 
										<span class="btnco">Add Services</span> <%--No I18N--%>
										<span class="btnrt"></span>
									</div>
								</div>							
							<%}
							if(!"aaaserver".equals(enabledconf)) {%>
								<div class="accbtn Hbtn" style="width: 100%">
									<div class="savebtn" onclick="openPopUp('deleteService')">
										<span class="btnlt"></span> 
										<span class="btnco">Delete Services</span> <%--No I18N--%>
										<span class="btnrt"></span>
									</div>
								</div>								
							<%}%>
						</td>
					</tr>
				</table>
			</div>
			<div style="margin-top: 10%; position: fixed; width: 72%">
				<div id='streamactionshow' style="background: lightgrey;">
					<hr><div id="streamaction" style="margin:0 auto"><center>Stream Configuration</center></div><hr>	<%--No I18N--%>
				</div>
			</div>
			
		<div style="max-height: 65%; overflow: scroll; position: fixed; margin-top: 210px; width: 71%">
			<div id="streamout" style='margin : 1%;'>
				<table style="width:100%; border-collapse:collapse;">
					<tr>
						<th class="streamtableth" width="15%">Stream Name</th> <%--No I18N--%>
						<th class="streamtableth" width="15%">Consume Count</th> <%--No I18N--%>
						<th class="streamtableth" width="15%">Wait Time in ms</th> <%--No I18N--%>
						<th class="streamtableth" width="15%">Total Stream size</th> <%--No I18N--%>
						<th class="streamtableth" width="15%">Current Stream size</th> <%--No I18N--%>
						<th class="streamtableth" width="15%">Action</th> <%--No I18N--%>
					</tr>
					<tr>
						<td class="streamtabletd"><%=IAMEncoder.encodeHTML(RedisMessageHandler.GLOBAL_CHANNEL)%></td>
						<td class="streamtabletd"><input id="<%=RedisMessageHandler.GLOBAL_CHANNEL.toLowerCase()%>_count" class="input noborder" style="text-align: center;" type='text' disabled="disabled" value='<%=IAMEncoder.encodeHTML(AccountsConfiguration.getConfiguration("redis.streams.global.count","100"))%>'/></td>
						<td class="streamtabletd"><input id="<%=RedisMessageHandler.GLOBAL_CHANNEL.toLowerCase()%>_waittime" class="input noborder" style="text-align: center;" type='text' disabled="disabled" value='<%=IAMEncoder.encodeHTML(AccountsConfiguration.getConfiguration("redis.streams.global.waittime", "100"))%>'/></td>
						<td class="streamtabletd"><input id="<%=RedisMessageHandler.GLOBAL_CHANNEL.toLowerCase()%>_size" class="input noborder" style="text-align: center;" type='text' disabled="disabled" value='<%=IAMEncoder.encodeHTML(AccountsConfiguration.getConfiguration("redis.streams.global.size","10000"))%>'/></td>
						<td class="streamtabletd">
							<%
									RedisStream stream = IAMStreamUtil.getCorrectStream(RedisMessageHandler.GLOBAL_CHANNEL);
									String len = "Stream Node not configured"; //No I18N
									if(stream != null) {
										len = stream.xlen(RedisMessageHandler.GLOBAL_CHANNEL.toLowerCase())+"";
									}
								%>
							<%=IAMEncoder.encodeHTML(len)%>
						</td>
						<td class="streamtabletd">
							<div class="Hbtn fllt" style="width: 67%;">
			                    <div id="<%=RedisMessageHandler.GLOBAL_CHANNEL.toLowerCase()%>_button" class="savebtn" onclick="editStream('<%= RedisMessageHandler.GLOBAL_CHANNEL.toLowerCase()%>')">
									<span class="cbtnlt"></span>
									<span id="<%=RedisMessageHandler.GLOBAL_CHANNEL.toLowerCase()%>_buttontxt" class="cbtnco" style="width:35px;">Edit</span>	<%--No I18N--%>
									<span class="cbtnrt"></span>
								</div>
								<div id="<%=RedisMessageHandler.GLOBAL_CHANNEL.toLowerCase()%>_cancelbutton" style="display: none;" class="savebtn" onclick="cancelEdit('<%=RedisMessageHandler.GLOBAL_CHANNEL.toLowerCase()%>')">
									<span class="cbtnlt"></span>
									<span class="cbtnco" style="width:35px;">Cancel</span>	<%--No I18N--%>
									<span class="cbtnrt"></span>
								</div>
							</span>
							</div>
						</td>
					</tr>
					<%  
						String consumeCountConf = "redis.streams.consume.count"; //No I18N
						String waittimeConf = "redis.streams.waittime"; //No I18N
						String streamSizeConf = "redis.streams.size"; // No I18N
						for(Service s : ss) {
							String service = s.getServiceName();
							AppConfiguration conf = AppConfiguration.getInstance(service);
						%>
						<tr id="<%= service%>">
							
							<td class="streamtabletd"><%=IAMEncoder.encodeHTML(conf.getAppName())%></td>
							<td class="streamtabletd"><input id="<%=service%>_count" class="input noborder" style="text-align: center;" type='text' disabled="disabled" value='<%=IAMEncoder.encodeHTML(conf.getAccountsValueIfNull(consumeCountConf,"100"))%>'/></td>
							<td class="streamtabletd"><input id="<%=service%>_waittime" class="input noborder" style="text-align: center;" type='text' disabled="disabled" value='<%=IAMEncoder.encodeHTML(conf.getAccountsValueIfNull(waittimeConf, "100"))%>'/></td>
							<td class="streamtabletd"><input id="<%=service%>_size" class="input noborder" style="text-align: center;" type='text' disabled="disabled" value='<%=IAMEncoder.encodeHTML(Util.SERVICEAPI.getRedisStreamConfiguration(service, streamSizeConf, "2000"))%>'/></td>
							<td class="streamtabletd">
								<%
									stream = IAMStreamUtil.getCorrectStream(service);
									len = "Stream Node not configured"; //No I18N
									if(stream != null) {
										len = stream.xlen(service.toLowerCase())+"";
									}
								%>
								<%=IAMEncoder.encodeHTML(len)%>
							</td>
							<td class="streamtabletd">
								<div class="Hbtn fllt" style="width: 67%;">
				                    <div id="<%=service%>_button" class="savebtn" onclick="editStream('<%=service%>')">
										<span class="cbtnlt"></span>
										<span id="<%=service%>_buttontxt" class="cbtnco" style="width:35px;">Edit</span>	<%--No I18N--%>
										<span class="cbtnrt"></span>
									</div>
									
									<div id="<%=service%>_cancelbutton" style="display: none;" class="savebtn" onclick="cancelEdit('<%=service%>')">
										<span class="cbtnlt"></span>
										<span class="cbtnco" style="width:35px;">Cancel</span>	<%--No I18N--%>
										<span class="cbtnrt"></span>
									</div>
								</div>
							</td>
						</tr>							
						<%}
						
						%>
							
					
				</table>
				
				<!-- POPUP -->
				
			</div>
		</div>
</div>
<%}
else if(type.equals("addService")) {
%>
<form class='zform' name='addservice' onsubmit="return updateEnabledStreams(this,'add');">
	<div class="labelmain">
		<div class="labelkey">Services :</div> <%--No I18N--%>
		<div class="labelvalue">
			<select class="select select2Div" name="services" multiple="multiple">
				<option value='all'>All</option> <%--No I18N--%>
				<%
					for(Service s : ss) {
						String sname = s.getServiceName().toLowerCase();
						if(streamEnabledServices.contains(sname) || "aaaserver".equals(sname)) {
							continue;
						}
				%>
				<option value="<%=sname%>"><%=sname%></option>
				<%	
					}
				%>
			</select>
		</div>
		<div class="labelkey">SyncRO :</div> <%--No I18N--%>
		<div class="labelvalue">
			<input type="checkbox" name="syncro">
		</div>
		<div class="accbtn Hbtn">
			<div class="savebtn" onclick="updateEnabledStreams(document.addservice, 'add')">
				<span class="btnlt"></span> 
				<span class="btnco">Add Services</span> <%--No I18N--%>
				<span class="btnrt"></span>
			</div>
			<div class="savebtn" onclick="loadui('/ui/admin/streamsetting.jsp')">
				<span class="btnlt"></span> 
				<span class="btnco">Cancel</span> <%--No I18N--%>
				<span class="btnrt"></span>
			</div>
		</div>
	</div>

</form>
<%}
else if(type.equals("deleteService")) {
%>
<form class='zform' name='deleteservice' onsubmit="return updateEnabledStreams(this,'delete');">
	<div class="labelmain">
		<div class="labelkey">Services :</div> <%--No I18N--%>
		<div class="labelvalue">
			<select class="select select2Div" name="services" multiple="multiple">
				<option value='all'>All</option>  <%--No I18N--%>
				<%if("all".equals(enabledconf)) {
					for(Service s : ss) {
						String sname = s.getServiceName().toLowerCase();
						if("aaaserver".equals(sname)) {
							continue;
						}
				%>
					<option value="<%=sname%>"><%=sname %></option>
				<%	}
				}
				else {%>
				<%
					for(String s : streamEnabledServices) {
						if("aaaserver".equals(s)) {
							continue;
						}
				%>
				<option value="<%=s%>"><%=s %></option>
				<%	
					}
				}
				%>
			</select>
		</div>
		<div class="labelkey">SyncRO :</div> <%--No I18N--%>
		<div class="labelvalue">
			<input type="checkbox" name="syncro">
		</div>
		<div class="accbtn Hbtn">
			<div class="savebtn" onclick="updateEnabledStreams(document.deleteservice,'delete')">
				<span class="btnlt"></span> 
				<span class="btnco">Delete Services</span> <%--No I18N--%>
				<span class="btnrt"></span>
			</div>
			<div class="savebtn" onclick="loadui('/ui/admin/streamsetting.jsp')">
				<span class="btnlt"></span> 
				<span class="btnco">Cancel</span> <%--No I18N--%>
				<span class="btnrt"></span>
			</div>
		</div>
	</div>

</form>
<%
}
%>