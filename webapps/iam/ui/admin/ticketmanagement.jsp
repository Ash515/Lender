<%-- $Id$ --%>
<%@page import="com.zoho.accounts.internal.util.I18NUtil"%>
<%@page import="org.json.JSONObject"%>
<%@page import="org.json.JSONArray"%>
<%@page import="com.zoho.accounts.OAuthResourceProto.OAuthAppGroup.OAuthClient.OAuthApiToken"%>
<%@page import="com.zoho.accounts.OAuthResourceProto.OAuthAppGroup.OAuthClient.OAuthRefreshToken"%>
<%@page import="com.zoho.accounts.internal.oauth2.OAuth2Util"%>
<%@page import="com.zoho.accounts.AccountsProto.Account.User.AuthToken.AuthTokenScope"%>
<%@page import="com.zoho.accounts.internal.util.ClientPortalUtil"%>
<%@page import="com.zoho.accounts.AccountsProto.Account.User.AuthToken"%>
<%@page import="java.util.concurrent.TimeUnit"%>
<%@ include file="includes.jsp" %>
<script>
var ticketType="<%=IAMEncoder.encodeJavaScript(request.getParameter("tname"))%>";
</script>
<%
	String userName = request.getParameter("uname");
	userName = Util.isValid(userName) ? userName : "";
	String ticketType = request.getParameter("tname");
	boolean isClientPortal = Util.isValid(request.getParameter("isclientportal")) ? Boolean.parseBoolean(request.getParameter("isclientportal")) : false;
	String zaid = Util.isValid(request.getParameter("zaid")) ? request.getParameter("zaid") : "-1";
%>
  <%@page import="com.adventnet.iam.UserSession"%>
<div class="maincontent">  
    <div class="menucontent">
	<div class="topcontent"><div class="contitle">Ticket Management</div></div> <%-- No I18N --%>
	<div class="subtitle">Admin Services</div> <%-- No I18N --%>
	<div class="field-bg">
	<form name="ticketinfo" id="ticketinfo" class="zform" method="post" onsubmit="return getTickets(this);">
    <div class="labelkey">Enter UserName or Email Address:</div> <%-- No I18N --%>
    <div class="labelvalue">
     <div class="searchfielddiv">
		    <input type="text" name="loginName"  id="loginName" class="input" value="<%=IAMEncoder.encodeHTMLAttribute(userName)%>" />
		</div>
		</div>
		<div class="labelmain">
		<div class="labelkey">is Client Portal :</div>  <%--No I18N--%>
		<div class="labelvalue" style="padding:6px 0px;"><input name="isClientPortal" class="check" type="checkbox" onchange="showzaid(this)" <%=isClientPortal ? "checked" : ""%>></div>
		<div id="show_zaid" style='<%= isClientPortal ? "" : "display:none;"%>'>
			<div class="labelkey">ZAID(Portal ID) :</div> <%--No I18N--%>
			<div class="labelvalue"><input type="text" class="input" name="zaid" value='<%=Util.isValid(zaid) ? zaid : "-1" %>'/></div><%-- NO OUTPUTENCODING --%>
			<div class="labelkey">Select the ticket :</div> <%-- No I18N --%>
			<div class="labelvalue">
			<%
				String ticket = AccountsConfiguration.getConfiguration("ticketmanagement.tickets.clientportal.value","authtoken,oauthtoken"); //No I18N
				String[] tiCket = ticket.split(",");%> <%-- NO OUTPUTENCODING --%>
			     <select name="portalticketName" id="portalticketName" class="select">
			     <%
			     	for (String tickets : tiCket) {
			     %>
			    <option value='<%=IAMEncoder.encodeHTMLAttribute(tickets)%>' <%=tickets.equalsIgnoreCase(ticketType) ? "selected" : ""%>><%=IAMEncoder.encodeHTML(tickets)%></option>
			<%
				}
			%>
			</select>
			</div>
		</div>
		<div id="hide_zaid" style='<%= isClientPortal ? "display:none;" : ""%>'>
		<div class="labelkey">Select the ticket :</div> <%-- No I18N --%>
		<div class="labelvalue">
			<%
			ticket = AccountsConfiguration.getConfiguration("ticketmanagement.tickets.value","authtoken,iamagentticket,iscticket,oauthtoken"); //No I18N
				tiCket = ticket.split(",");%> <%-- NO OUTPUTENCODING --%>
			     <select name="ticketName" id="ticketName" class="select">
			     <%
			     	for (String tickets : tiCket) {
			     %>
			    <option value='<%=IAMEncoder.encodeHTMLAttribute(tickets)%>' <%=tickets.equalsIgnoreCase(ticketType) ? "selected" : ""%>><%=IAMEncoder.encodeHTML(tickets)%></option>
			<%
				}
			%>
			</select>
			</div>
		</div>
			<div class="accbtn Hbtn">
		    <div class="savebtn" onclick="getTickets(document.ticketinfo)">
			<span class="btnlt"></span>
			<span class="btnco">Get Tickets</span> <%-- No I18N --%>
			<span class="btnrt"></span>
		    </div>
		</div>
		    </div>
		    </form>
		   <%ServiceAPI sapi = Util.SERVICEAPI;
		   if(!isClientPortal){
		   	if (userName != null && ticketType != null) {
		   		User user1 = Util.USERAPI.getUser(userName);
		   		if (user1 != null) {
		   			if (ticketType.equalsIgnoreCase("authtoken")|| ticketType.equalsIgnoreCase("iscticket")) {
		   				List<ISCTicket> userticket = null;
		   				boolean internal = "iscticket".equalsIgnoreCase(ticketType) ? true : false; //No I18N
		   				userticket = Util.USERAPI.getAllISCTickets(user1.getZUID(), internal);
		   				if (userticket != null) {
		   %>   
		        <div class="policytypetxt" style="margin:8px 0 8px 3px;">No. Of <%=IAMEncoder.encodeHTML(ticketType)%> : <%= userticket.size()%></div><%-- NO OUTPUTENCODING --%> <%-- No I18N --%>
			    <div class="topbtn Hcbtn" style="margin-top: -20px;float: right;margin-right: 6px;">
			    <div class="addnew" style="margin: 0;" onclick="deleteuserticket('<%=IAMEncoder.encodeJavaScript(userName)%>','<%=IAMEncoder.encodeJavaScript(ticketType)%>',false,'')">
				<span class="cbtnlt"></span>
				<span class="cbtnco"><%=Util.getI18NMsg(request,"IAM.TFA.USERSESSIONS.REMOVE.ALL")%> </span> <%-- No I18N --%>
				<span class="cbtnrt"></span>
			    </div>
			</div>
			    <table class="apitokentbl" border="0" align="center">
		                        <tr>
					    <td class="apitokenheader" style="border-left: 1px solid #b7d4f0;text-align: center;"><%=Util.getI18NMsg(request,"IAM.ACTIVETOKEN")%></td>
		                            <td class="apitokenheader">
		                                <table border="0" cellpadding="0" align="center" class="scopeheadertbl">
		                                    <tr>
		                                        <td width="50%"><%=Util.getI18NMsg(request, "IAM.SCOPENAME")%></td>
		                                        <td width="50%"><%=Util.getI18NMsg(request,"IAM.SERVICENAME")%></td>
		                                    </tr>
		                                </table>
		                            </td>
					    <td class="apitokenheader"><%=Util.getI18NMsg(request,"IAM.IPADDRESS")%></td>
					    <td width="15%" class="apitokenheader"><%=Util.getI18NMsg(request,"IAM.GROUP.DESCRIPTION")%></td>
					    <td class="apitokenheader"><%=Util.getI18NMsg(request,"IAM.ACTIVETOKEN.LAST.ACCESS.TIME")%></td>
					    <td class="apitokenheader" style="text-align: center;border-right:1px solid #b7d4f0;"><%=Util.getI18NMsg(request, "IAM.ACTION")%></td>
					</tr>
		<%
			for (ISCTicket tickets : userticket) {
								List<ISCScope> iscScopes = tickets.getScopes();
								if (iscScopes == null || iscScopes.isEmpty()) {
									continue;
								}
		%>
			 <tr>
		                            <td class="apitokentbltd"><%=tickets.getTicket()%></td> <%-- NO OUTPUTENCODING --%>
					    <td class="apitokentbltd" style="padding:0px;">
		                                <table class="scopetbl" style="" border="0" align="center">
		                                <%
		                                	int scopecount = 0;
		                                						for (ISCScope scopes : iscScopes) {
		                                							Service service = scopes.serviceID != -1 ? sapi.getService(scopes.serviceID): null;
		                                							if (service == null) {
		                                								continue;
		                                							}
		                                							scopecount++;
		                                							String serviceDispName = I18NUtil.getMessageOrDefault("ZOHO." + service.getServiceName()+ ".DISP",  service.getDisplayName());//No i18n
		                                %>
		                                 <tr>
		                                        <td class="scopetbltdlt" width="50%"><%=IAMEncoder.encodeHTML(scopes.scope)%></td> <%-- NO OUTPUTENCODING --%>
		                                        <td class="scopetbltdrt" width="50%"><%=serviceDispName%></td> <%-- NO OUTPUTENCODING --%>
		                                    </tr>
		                                    
		                              <% }  %>
		                               </table>
		                            </td>
		                            <%
		                            Map<String, Object> usage = CSPersistenceAPIImpl.getISCTicketUsageDetails(tickets.getTicket());
       						     	
		                            Date lastAccessTime = usage != null ? new Date((Long)usage.get("LAST_ACCESSED_TIME")) : new Date(tickets.getGeneratedTime());
       								Date currentDate = new Date(System.currentTimeMillis());
       						    	
       								long numberOfdaysdiff = currentDate.getTime() - lastAccessTime.getTime();
       						    	long numberOfdays = TimeUnit.DAYS.convert(numberOfdaysdiff, TimeUnit.MILLISECONDS);
       						    	long numberofHours = 0;
       						    	
       						    	if(numberOfdays==0){
       						    		numberofHours = TimeUnit.HOURS.convert(numberOfdaysdiff, TimeUnit.MILLISECONDS);
       						    	}
		                            %>
		                            <td class="apitokentbltd"><%=tickets.getIPAddress()%></td> <%-- NO OUTPUTENCODING --%>
		                            <td width="15%" class="apitokentbltd"><%=Util.isValid(tickets.getDisplayName()) ? IAMEncoder.encodeHTML(tickets.getDisplayName()) : "&nbsp;"%></td>
		                            <%if(numberOfdays==0){ %> 
		                            	<td class="apitokentbltd" title="<%=lastAccessTime %>"><%if(numberofHours==0){%><%=lastAccessTime %><%}else{%><%=numberofHours%>&nbsp;hours ago<%} %></td> <%-- NO OUTPUTENCODING --%>
		                            <%}else{ %>
		                            	<td class="apitokentbltd" title="<%=lastAccessTime %>"><%=numberOfdays %>&nbsp;<%=Util.getI18NMsg(request, "IAM.DAYS.AGO")%></td> <%-- NO OUTPUTENCODING --%>
		                            <%} %>
					                <td class="apitokentbltd">
		                                <div class="apitokenaccdiv Hcbtn">
		                                    <div class="cbtn" onclick="deleteuserticket('<%=IAMEncoder.encodeJavaScript(userName)%>','<%=IAMEncoder.encodeJavaScript(ticketType)%>',true,'<%=IAMEncoder.encodeHTML(tickets.getTicket())%>')"> <%-- NO OUTPUTENCODING --%>
		                                        <span class="cbtnlt"></span>
		                                        <span class="cbtnco"><a href="javascript:;"><%=Util.getI18NMsg(request,"IAM.REMOVE")%></a></span>
		                                        <span class="cbtnrt"></span>
		                                    </div>
		                                    <div style="padding :0px 1px; float: left;">&nbsp;</div>
		                                </div>
		                            </td>
					</tr>
					<%
						}
					%>
		</table>
			     <%
			     	} else {
			     %>
			   
					<div class="emptyobjmain">
				    <dl class="emptyobjdl"style="margin:18px;"> <%--No I18N--%>
					<dd><p align="center" class="emptyobjdet">No Tickets</p></dd> <%--No I18N--%>
				    </dl> <%--No I18N--%>
				</div>
			   <%
			   	}
			   			} else if ("iamagentticket".equalsIgnoreCase(ticketType)) { //No I18N
			   				List<UserSession> userSessions = Util.USERAPI.getAllSessions(user1.getZUID());
			   				boolean isCurrentUserRequest = user.getZUID() == user1.getZUID();
			   				if (userSessions != null) {
			   %>
			     <div class="policytypetxt"style="margin:8px 0 8px 3px;">No. Of <%=IAMEncoder.encodeHTML(ticketType) %>:<%=userSessions.size()%></div><%-- NO OUTPUTENCODING --%><%-- No I18N --%>
			     <div class="topbtn Hcbtn" style="margin-top: -20px;float: right;margin-right: 6px;">
			    <div class="addnew" style="margin: 0;" onclick="deleteuserticket('<%=IAMEncoder.encodeJavaScript(userName)%>','<%=IAMEncoder.encodeJavaScript(ticketType)%>',false,'')">
				<span class="cbtnlt"></span>
				<span class="cbtnco"><%=Util.getI18NMsg(request,"IAM.TFA.USERSESSIONS.REMOVE.ALL")%></span> <%--No I18N--%>
				<span class="cbtnrt"></span>
			    </div>
			</div>
			<div class="apikeyheader" id="headerdiv" style="margin:0px auto;width:100%">
		    <div class="apikeytitle" style="width:25%;">Token</div> <%--No I18N--%>
		    <div class="apikeytitle" style="width:24%">Created Time</div> <%--No I18N--%>
		    <div class="apikeytitle" style="width:25%;">Ip Address</div> <%--No I18N--%>
		    <div class="apikeytitle" style="width:23%;padding:7px 1px 6px 6px;">Action</div><%--No I18N--%>
		    </div>
		    <%
		    	for (UserSession usersession : userSessions) {
		    %>
					<div class="apikeycontent">
				    <div class="apikey" style="width:25%;"><%=IAMEncoder.encodeHTML(usersession.getTicket())%></div>
			        <div class="apikey" style="width:24%;"><%=new Date(usersession.getStartTime())%></div>  <%-- NO OUTPUTENCODING --%>
			        <div class="apikey" style="width:25%;"><%=IAMEncoder.encodeHTML(usersession.getFromIP())%></div>
			         <div class="apikey apikeyaction">
			        <div class="Hbtn flrt">
			       <%
			       	if (isCurrentUserRequest&& IAMUtil.getCurrentTicket().equals(usersession.getTicket())) {
			       %>
			         <div class="apikey" style="width:94%;">Current Session</div> <%--No I18N--%>
			       <%
			       	} else {
			       %>
			        <div onclick="deleteuserticket('<%=IAMEncoder.encodeJavaScript(userName)%>','<%=IAMEncoder.encodeJavaScript(ticketType)%>',true,'<%=IAMEncoder.encodeHTML(usersession.getTicket())%>')">
		            <span class="cbtnlt"></span>
					<span class="cbtnco" style="width:43px;"><%=Util.getI18NMsg(request,"IAM.REMOVE")%></span> <%--No I18N--%>
					<span class="cbtnrt"></span>
					</div>
			       <%
			       	}
			       %>
				    </div>
				    </div>
				    <div class="clrboth">
			    </div>
		</div>
			    		
			    	 <%
			    					    	 	}
			    					    	 %>
				 
			  <%
				 			  	} else {
				 			  %>
				<div class="topbtn Hcbtn" style="margin-top: -20px;float: right;margin-right: 6px;">
		        <div class="addnew" style="margin: 0;" onclick="loadui('/ui/admin/ticketmanagement.jsp')">
				<span class="cbtnlt"></span>
				<span class="cbtnco">Back</span> <%--No I18N--%>
				<span class="cbtnrt"></span>
			    </div>
			    </div>
						<div class="emptyobjmain">
					    <dl class="emptyobjdl"style="margin:18px;"> <%--No I18N--%>
						<dd><p align="center" class="emptyobjdet">No Tickets</p></dd> <%--No I18N--%>
					    </dl> <%--No I18N--%>
					</div>
						 
						   <%
						 						   	}
						 						   %>
			    
		    	<%
			    		    		}
		   		}
		   	}
		   		if ("oauthtoken".equalsIgnoreCase(ticketType)) { //No I18N
			    	JSONObject tokentypeToTokenList = OAuth2Util.getOAuthTokenOfUser(userName);
		   			JSONArray tokenDetails = tokentypeToTokenList.optJSONArray("tokenDetails");//NO I18N
		   					if ((tokenDetails == null || tokenDetails.length() == 0)&& tokentypeToTokenList.has("is_user")) {
						   	%>
						   					<div class="nosuchusr">
							        	       <p align="center"><%=tokentypeToTokenList.getBoolean("is_user") ? "No Tokens for user" : "No Tokens for AppAccount/ServiceOrg"%></p><%-- NO OUTPUTENCODING --%><%--No I18N--%>
							        	   </div>
							        	   <%
						   							return;
						   	} else if(tokentypeToTokenList.has("error")){// NO I18N
			    		    				%>
						   					<div class="nosuchusr">
							        	       <p align="center"><%=IAMEncoder.encodeHTML(tokentypeToTokenList.getString("error"))%></p> <%--No I18N--%>
							        	   </div>
							        	   <%
			    		    				return;
			    		    }else{
						   					 
						   %>
						     <div class="policytypetxt"style="margin:8px 0 8px 3px;">No. Of <%=IAMEncoder.encodeHTML(ticketType) %>:<%=tokenDetails.length()%></div><%-- NO OUTPUTENCODING --%><%-- No I18N --%>
						     <div class="topbtn Hcbtn" style="margin-top: -20px;float: right;margin-right: 6px;">
						</div>
				<table class="apitokentbl" border="0" align="center">
		             <tr>
					    <td class="apitokenheader">Client Id </td><%--No I18N--%>
					    <td class="apitokenheader">Client Name </td><%--No I18N--%>
					    <td class="apitokenheader">Client Type</td><%--No I18N--%>
					    <td width="15%" class="apitokenheader">token type</td><%--No I18N--%>
					    <td class="apitokenheader">Number of tokens</td><%--No I18N--%>
					    <td class="apitokenheader" style="text-align: center;border-right:1px solid #b7d4f0;"><%=Util.getI18NMsg(request, "IAM.ACTION")%></td>
					</tr>
			 
					<%for(int i=0;i<tokenDetails.length(); i++){
						JSONObject clientDetails = tokenDetails.getJSONObject(i);
						%>
						<tr>
						<td class="apitokentbltd"><%=IAMEncoder.encodeHTML(clientDetails.getString("clientId")) %></td><%-- NO OUTPUTENCODING --%>
						<td class="apitokentbltd"><%=IAMEncoder.encodeHTML(clientDetails.getString("clientName")) %></td><%-- NO OUTPUTENCODING --%>
						<td class="apitokentbltd"><%=IAMEncoder.encodeHTML(clientDetails.getString("clientType")) %></td><%-- NO OUTPUTENCODING --%>
						<td class="apitokentbltd"><%=IAMEncoder.encodeHTML(clientDetails.getString("token_type")) %></td><%-- NO OUTPUTENCODING --%>
						<td class="apitokentbltd"><%=IAMEncoder.encodeHTML(clientDetails.getLong("count")+"") %></td><%-- NO OUTPUTENCODING --%>
						<td class="apitokentbltd">
							<div class="apitokenaccdiv Hcbtn">
								<div class="cbtn" onclick="deleteuserticket('<%=IAMEncoder.encodeJavaScript(userName)%>','<%=IAMEncoder.encodeJavaScript(clientDetails.getString("token_type"))%>',true,'<%=IAMEncoder.encodeHTML(clientDetails.getString("clientId"))%>')"> <%-- NO OUTPUTENCODING --%>
									<span class="cbtnlt"></span>
									<span class="cbtnco"><a href="javascript:;"><%=Util.getI18NMsg(request,"IAM.REMOVE")%></a></span>
		                            <span class="cbtnrt"></span>
		                        </div>
		                    <div style="padding :0px 1px; float: left;">&nbsp;</div>
		                    </div>
		                </td>
						</tr>
						<%
						}
						   				
					%>
		</table><%
		}
		   			}else if (Util.isValid(userName) && user == null){
			    		    			%>
			    		    			<div class="nosuchusr">
		        	       <p align="center"> Invaild User email</p> <%--No I18N--%>
		        	   </div>
			    		    			<%
			    		    		}
		   }else if(zaid.equalsIgnoreCase("-1")){
				   %>
				   <div class="nosuchusr">
	        	       <p align="center">Invalid Zaid.</p> <%--No I18N--%>
	        	   </div>
				   <%
				   return;
			   }else{
			   if(Util.isValid(ticketType) && ticketType.equalsIgnoreCase("authtoken")){
				   AuthToken[] authtokens = null;
				   try{
					   authtokens = ClientPortalUtil.getClientPortalUserAuthtokens(zaid, userName);
					   %><div class="policytypetxt" style="margin:8px 0 8px 3px;">No. Of <%=IAMEncoder.encodeHTML(ticketType)%> : <%= authtokens.length%></div><%-- NO OUTPUTENCODING --%> <%-- No I18N --%>
					    <div class="topbtn Hcbtn" style="margin-top: -20px;float: right;margin-right: 6px;">
					    <div class="addnew" style="margin: 0;" onclick="deleteclientportalticket('<%=IAMEncoder.encodeJavaScript(userName)%>','<%=IAMEncoder.encodeJavaScript(ticketType)%>',false,'','true')">
						<span class="cbtnlt"></span>
						<span class="cbtnco"><%=Util.getI18NMsg(request,"IAM.TFA.USERSESSIONS.REMOVE.ALL")%> </span> <%-- No I18N --%>
						<span class="cbtnrt"></span>
					    </div>
					</div>
					    <table class="apitokentbl" border="0" align="center">
				                        <tr>
							    <td class="apitokenheader" style="border-left: 1px solid #b7d4f0;text-align: center;"><%=Util.getI18NMsg(request,"IAM.ACTIVETOKEN")%></td>
				                            <td class="apitokenheader">
				                                <table border="0" cellpadding="0" align="center" class="scopeheadertbl">
				                                    <tr>
				                                        <td width="50%"><%=Util.getI18NMsg(request, "IAM.SCOPENAME")%></td>
				                                        <td width="50%"><%=Util.getI18NMsg(request,"IAM.SERVICENAME")%></td>
				                                    </tr>
				                                </table>
				                            </td>
							    <td class="apitokenheader" style="text-align: center;border-right:1px solid #b7d4f0;"><%=Util.getI18NMsg(request, "IAM.ACTION")%></td>
							</tr>
				<%
					for (AuthToken token : authtokens) {
										List<AuthTokenScope> authtokenScope = token.getAuthTokenScopeList();
										if (authtokenScope == null || authtokenScope.isEmpty()) {
											continue;
										}
				%>
					 <tr>
				                            <td class="apitokentbltd"><%=token.getToken()%></td> <%-- NO OUTPUTENCODING --%>
							    <td class="apitokentbltd" style="padding:0px;">
				                                <table class="scopetbl" style="" border="0" align="center">
				                                <%
				                                	int scopecount = 0;
				                                						for (AuthTokenScope scope : authtokenScope) {
				                                							ISCScope scopeId = CSPersistenceAPIImpl.getISCScope(Integer.parseInt(scope.getScopeId()+""));
				                                							Service service = scopeId.serviceID != -1 ? sapi.getService(scopeId.serviceID): null;
				                                							if (service == null) {
				                                								continue;
				                                							}
				                                							scopecount++;
				                                							String serviceDispName = I18NUtil.getMessageOrDefault("ZOHO." + service.getServiceName()+ ".DISP",  service.getDisplayName());//No i18n
				                                %>
				                                 <tr>
				                                        <td class="scopetbltdlt" width="50%"><%=IAMEncoder.encodeHTML(scopeId.scope)%></td> <%-- NO OUTPUTENCODING --%>
				                                        <td class="scopetbltdrt" width="50%"><%=serviceDispName%></td> <%-- NO OUTPUTENCODING --%>
				                                        </tr>
				                                         <% }  %>
				                                        </table>
				                                        </td>
				                                        <td>
		                                <div class="apitokenaccdiv Hcbtn">
		                                    <div class="cbtn" onclick="deleteclientportalticket('<%=IAMEncoder.encodeJavaScript(userName)%>','<%=IAMEncoder.encodeJavaScript(ticketType)%>',true,'<%=IAMEncoder.encodeHTML(token.getToken())%>','true','<%=IAMEncoder.encodeHTML(zaid)%>')"> <%-- NO OUTPUTENCODING --%>
		                                        <span class="cbtnlt"></span>
		                                        <span class="cbtnco"><a href="javascript:;"><%=Util.getI18NMsg(request,"IAM.REMOVE")%></a></span>
		                                        <span class="cbtnrt"></span>
		                                    </div>
		                                    <div style="padding :0px 1px; float: left;">&nbsp;</div>
		                                </div>
				                                    </td>
				                            </tr>
				                            

				<%}
				   }catch(Exception e){
					   %>
					   <div class="nosuchusr">
		        	       <p align="center"><%=IAMEncoder.encodeHTML(e.getMessage()) %></p><%--No I18N--%>
		        	   </div>
					   <%
					   return;
				   }
				   %>
				   </table>
				   <%
			   } else if(Util.isValid(ticketType) && ticketType.equalsIgnoreCase("oauthtoken")){//No i18N
				   JSONObject tokentypeToTokenList = ClientPortalUtil.getClientPortalOAuthTokens(zaid, userName);
		   			JSONArray tokenDetails = tokentypeToTokenList.optJSONArray("tokenDetails");//NO I18N
		   					if ((tokenDetails == null || tokenDetails.length() == 0)&& tokentypeToTokenList.has("is_user")) {
						   	%>
						   					<div class="nosuchusr">
							        	       <p align="center"><%=tokentypeToTokenList.getBoolean("is_user") ? "No Tokens for user" : "No tokens for org"%></p> <%--No I18N--%>
							        	   </div>
							        	   <%
						   							return;
						   	} else if(tokentypeToTokenList.has("error")){// NO I18N
			    		    				%>
						   					<div class="nosuchusr">
							        	       <p align="center"><%=IAMEncoder.encodeHTML(tokentypeToTokenList.getString("error"))%></p> <%--No I18N--%>
							        	   </div>
							        	   <%
			    		    				return;
			    		    }else{
						   					 
						   %>
						     <div class="policytypetxt"style="margin:8px 0 8px 3px;">No. Of <%=IAMEncoder.encodeHTML(ticketType) %>:<%=tokenDetails.length()%></div><%-- NO OUTPUTENCODING --%><%-- No I18N --%>
						     <div class="topbtn Hcbtn" style="margin-top: -20px;float: right;margin-right: 6px;">
						    <div class="addnew" style="margin: 0;" onclick="deleteuserticket('<%=IAMEncoder.encodeJavaScript(userName)%>','<%=IAMEncoder.encodeJavaScript(ticketType)%>',false,'')">
							<span class="cbtnlt"></span>
							<span class="cbtnco"><%=Util.getI18NMsg(request,"IAM.TFA.USERSESSIONS.REMOVE.ALL")%></span> <%--No I18N--%>
							<span class="cbtnrt"></span>
						    </div>
						</div>
				<table class="apitokentbl" border="0" align="center">
		             <tr>
					    <td class="apitokenheader">Client Id </td><%--No I18N--%>
					    <td class="apitokenheader">Client Name </td><%--No I18N--%>
					    <td class="apitokenheader">Client Type</td><%--No I18N--%>
					    <td width="15%" class="apitokenheader">token type</td><%--No I18N--%>
					    <td class="apitokenheader">Number of tokens</td><%--No I18N--%>
					    <td class="apitokenheader" style="text-align: center;border-right:1px solid #b7d4f0;"><%=Util.getI18NMsg(request, "IAM.ACTION")%></td>
					</tr>
			 
					<%for(int i=0;i<tokenDetails.length(); i++){
						JSONObject clientDetails = tokenDetails.getJSONObject(i);
						%>
						<tr>
						<td class="apitokentbltd"><%=IAMEncoder.encodeHTML(clientDetails.getString("clientId")) %></td>
						<td class="apitokentbltd"><%=IAMEncoder.encodeHTML(clientDetails.getString("clientName")) %></td>
						<td class="apitokentbltd"><%=IAMEncoder.encodeHTML(clientDetails.getString("clientType")) %></td>
						<td class="apitokentbltd"><%=IAMEncoder.encodeHTML(clientDetails.getString("token_type")) %></td>
						<td class="apitokentbltd"><%=IAMEncoder.encodeHTML(clientDetails.getLong("count")+"") %></td>
						<td class="apitokentbltd">
							<div class="apitokenaccdiv Hcbtn">
								<div class="cbtn" onclick="deleteclientportalticket('<%=IAMEncoder.encodeJavaScript(userName)%>','<%=IAMEncoder.encodeJavaScript(clientDetails.getString("token_type"))%>',true,'<%=IAMEncoder.encodeHTML(clientDetails.getString("clientId"))%>','true','<%=IAMEncoder.encodeHTML(zaid)%>')"> <%-- NO OUTPUTENCODING --%>
									<span class="cbtnlt"></span>
									<span class="cbtnco"><a href="javascript:;"><%=Util.getI18NMsg(request,"IAM.REMOVE")%></a></span>
		                            <span class="cbtnrt"></span>
		                        </div>
		                    <div style="padding :0px 1px; float: left;">&nbsp;</div>
		                    </div>
		                </td>
						</tr>
						<%
						}
						   				
					%>
		</table><%
		}
			   }
		   }
		   
			 %>
			 
			 </div>
			 </div>
			 </div>
