<%-- $Id$ --%>
<%@page import="com.zoho.accounts.internal.AuditUtil"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.logging.Level"%>
<%@page import="java.util.logging.Logger"%>
<%@page import="org.json.JSONObject"%>
<%@page import="com.zoho.resource.internal.ResultTableHandler"%>
<%@ page import="java.sql.Timestamp"%>
<%@ include file="includes.jsp" %>
<%@ include file="../../static/includes.jspf" %>
<%@page import="com.zoho.resource.internal.AuditQueue"%>
<%@page import="com.zoho.resource.Criteria.Comparator"%>
<%@page import="com.zoho.resource.internal.AuditQueue.Args" %>
<%@page import="com.zoho.resource.Criteria"%>
<%@page import="com.zoho.accounts.AccountsProto"%>
<%@page import="com.zoho.accounts.AccountsProto.Account"%>
<%@page import="com.zoho.accounts.AccountsProto.Account.Policy"%>
<%@page import="com.zoho.accounts.Accounts"%>	

<%  if(AccountsConfiguration.getConfiguration("resourceaudit.changehistory.enabletime")==null){ %> 
			<div class="nosuchusr"><p align="center">Please add the Accounts Configuration</p></div> <%-- No I18N --%>
			
		
	<% return; 
	} 
        long Zuid = IAMUtil.getLong(request.getParameter("zuid"));
        User u = Util.isValid(Util.USERAPI.getUser(Zuid))?Util.USERAPI.getUser(Zuid):null;
		long lastmodifiedTime = u.getLastModifiedTime()!=-1?Util.getUserLastModifiedTime(u):-1;
		int start = Integer.parseInt(request.getParameter("start"));
		start = start == -1 ? 0 : start;
		int size = 0;
		int limit = 10;
		
		ResultTableHandler rt = null;
		if(lastmodifiedTime!=-1 && Zuid!=-1) {
			rt = AuditUtil.getResourceAudit(lastmodifiedTime, Zuid+"", start);
		} 
		if (rt != null && !rt.isEmpty()) {
			size = rt.rows.size();
	%> 
	  <table width="98%" style="font-size:11px;margin:10px auto 0px;">
	   <tr>
	        <td valign="top" align="right">
	   <%
	   	if (start == 0) {
	   %>
	    <a href="javascript:;" style="color:#c3c3c3;" class="elementtext"><%} else {%>
	   		<a href="javascript:;"  class="elementtext" onclick="search_moreresource('<%=Zuid%>','previous')"><%}%>Previous</a> 
	        <%if (size % limit == 0 || size==0) { %>
	   		<a href="javascript:;" class="elementtext" onclick="search_moreresource('<%=Zuid%>','next')"><%} else {%>
	   		<a href="javascript:;" style="color:#c3c3c3;" class="elementtext"><%}%>Next</a>
	   
	   <input type="hidden" id="hide_next" value="<%=start + size%>"/>
	   <input type="hidden" id="hide_prev" value="<%=start%>"/>
	   		</td>
	   	</tr>
	   	</table>
	   	
	   <table class="usremailtbl" cellpadding="4" style="margin-top:0px;">
	 
            <tr>
            <td class="usrinfoheader">Resource Type </td> <%--No I18N--%>
            <td class="usrinfoheader">Operation</td>  <%--No I18N--%>
		    <td class="usrinfoheader">Modified Time</td> <%--No I18N--%>
		    <td class="usrinfoheader">Old Data </td> <%--No I18N--%>
		    <td class="usrinfoheader">New Data </td> <%--No I18N--%>
		    <td class="usrinfoheader">Details</td> <%--No I18N--%>
		
	    </tr>
	<%
		int cnt = 1;
			for (Object[] row : rt.rows) {
				Map<String, Object> map = rt.convertToMap(row);
				cnt++;
				String OldData = (String) map.get("OLD_DATA");
				        if (OldData != null) {
						OldData = OldData.substring(1, OldData.length() - 1);
						JSONObject json = new JSONObject(OldData);
						json.remove("parent"); //NO I18N
						json.remove("modified_time");  //NO I18N
						OldData = json.toString();
		           }
				        String NewData = (String) map.get("NEW_DATA");
				         if (NewData != null) {
								NewData = NewData.substring(1, NewData.length() - 1);
								JSONObject json1 = new JSONObject(NewData);
								json1.remove("parent"); //NO I18N
								json1.remove("modified_time");  //NO I18N
								NewData = json1.toString();
				         }
				         if(OldData!=null && NewData!=null){
				         if(OldData.equals(NewData)){
				        	 continue;
				          }
				     }
				         
	%>
	<tr>
	    <td class="usremailtd">&nbsp;<%=IAMEncoder.encodeHTML(map.get("RESOURCE_TYPE").toString())%></td>
	    <td class="usremailtd"><%=IAMEncoder.encodeHTML(map.get("OPERATION").toString())%></td>
		<td class="usremailtd"><%=(new Date((Long) (map.get("AUDITED_TIME"))))%></td> <%-- NO OUTPUTENCODING --%>  
		<td class="usremailtd">
			<%              if(OldData!=null){
							OldData=OldData.substring(1,OldData.length()-1);
							String[] oldData = OldData.split(",");
							for (String olddata : oldData) {
			%> <%=IAMEncoder.encodeHTML(olddata.replace('"', ' '))%> <br> <%
							}
 	}
 %>
		</td>
		<td class="usremailtd">
			<%              if(NewData!=null){
							NewData=NewData.substring(1, NewData.length()-1);
							String newData1[] = NewData.split(",");
							for (String newdata : newData1) {
			%> <%=IAMEncoder.encodeHTML(newdata.replace('"', ' '))%><br> <%
							}
 	}
 %>
		</td>

		
		<%--No I18N--%>
		<td class="usremailtd"><a href="javascript:;"onclick="document.getElementById('div_<%=cnt%>').style.display='';">More Details</a><br> <%--No I18N--%>
			<div class="usrdetails" id="div_<%=cnt%>" style="display: none;">
				<div class="close_div" onclick="closeDetails('div_<%=cnt%>')">x</div><%--No I18N--%>
				<div>
				<div class="displayConLeft"><b>Resource Type : </b></div><%--No I18N--%>
				<div class="displayConRight">&nbsp;&nbsp;<%= IAMEncoder.encodeHTML((String)map.get("RESOURCE_TYPE"))%></div>
				</div>
				<div>
				<div class="displayConLeft"><b>Operation : </b></div><%--No I18N--%>
				<div class="displayConRight">&nbsp;&nbsp;<%=IAMEncoder.encodeHTML((String)map.get("OPERATION"))%></div>
				</div>
				<div>
				<div class="displayConLeft"><b>Thread ID : </b></div><%--No I18N--%>
				<div class="displayConRight">&nbsp;&nbsp;<%=IAMEncoder.encodeHTML((String)map.get("THREAD_ID"))%></div>
				</div>
				<div>
				<div class="displayConLeft"><b>Request ID : </b></div><%--No I18N--%>
				<div class="displayConRight">&nbsp;&nbsp;<%=IAMEncoder.encodeHTML((String)map.get("REQUEST_ID"))%></div>
				</div>
				<div>
				<div class="displayConLeft"><b>RemoteIp : </b></div><%--No I18N--%>
				<div class="displayConRight">&nbsp;&nbsp;<%=IAMEncoder.encodeHTML((String)map.get("REMOTE_IP"))%></div>
				</div>
				<div>
				<div class="displayConLeft"><b>App IP : </b></div><%--No I18N--%>
				<div class="displayConRight">&nbsp;&nbsp;<%=IAMEncoder.encodeHTML((String)map.get("APP_IP"))%></div>
				</div>
				<div>
				<div class="displayConLeft"><b>APP Name : </b></div><%--No I18N--%>
				<div class="displayConRight">&nbsp;&nbsp;<%=IAMEncoder.encodeHTML((String)map.get("APP_NAME"))%></div>
				</div>
				<div>
				<div class="displayConLeft"><b>Rest Url : </b></div><%--No I18N--%>
				<div class="displayConRight">&nbsp;&nbsp;<%=IAMEncoder.encodeHTML((String)map.get("REST_URL"))%></div>
				</div>
				<div>
				<div class="displayConLeft"><b>UserAgent : </b></div><%--No I18N--%>
				<div class="displayConRight">&nbsp;&nbsp;<%=IAMEncoder.encodeHTML((String)map.get("USER_AGENT"))%></div>
				</div>
				<div>
				<div class="displayConLeft"><b>Zuid : </b></div><%--No I18N--%>
				<div class="displayConRight">&nbsp;&nbsp;<%=IAMEncoder.encodeHTML((String)map.get("ZUID"))%></div>
				</div>
				<div><div class="displayConLeft"><b>OwnerZuid : </b></div><%--No I18N--%>
				<div class="displayConRight">&nbsp;&nbsp;<%=IAMEncoder.encodeHTML((String)map.get("OWNER_ZUID"))%></div>
				</div>
				<div><div class="displayConLeft"><b>OldData : </b></div><%--No I18N--%>
				<div class="displayConRight">&nbsp;&nbsp;<%=IAMEncoder.encodeHTML((String)map.get("OLD_DATA"))%></div>
				</div>
				<div>
			    <div class="displayConLeft"><b>NewData : </b></div><%--No I18N--%>
			    <div class="displayConRight">&nbsp;&nbsp;<%=IAMEncoder.encodeHTML((String)map.get("NEW_DATA"))%></div>
				</div>
				<div>
				<div class="displayConLeft"><b>Token Digest : </b></div><%--No I18N--%>
				<div class="displayConRight">&nbsp;&nbsp;<%=IAMEncoder.encodeHTML((String)map.get("TOKEN_DIGEST"))%></div>
				</div>
				<div class="mrpBtn">
				<input type="button" value="Close" onclick="closeDetails('div_<%=cnt%>')">
				</div>
			    </div>
			    
			</td>
	</tr>


	<%
		}
	%>

  <%
  	} else {
  %> 
	     <div class="nosuchusr"><p align="center">No recent activity</p></div> <%-- No I18N --%>
	    
	     <%
	    	     	}
	    	     %> 

 </table>
	</div>