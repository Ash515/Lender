<%@page import="com.zoho.accounts.oncloud.mail.transmail.TransMailUtil"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="org.json.JSONArray"%>
<%@page import="com.adventnet.iam.security.SecurityUtil"%>
<%@page import="com.zoho.accounts.AccountsConstants.CharacterEncoding"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="org.json.JSONObject"%>
<%@page import="com.zoho.accounts.internal.util.CSUtil"%>
<%@page import="com.zoho.accounts.AccountsConfiguration"%>
<%@page import="com.adventnet.iam.IAMUtil"%>
<%@page import="com.adventnet.iam.internal.Util"%>
<%@page import="com.adventnet.iam.xss.IAMEncoder"%>

<%@ include file="includes.jsp" %>

<%
    String qry = request.getParameter("qry");
    qry = Util.isValid(qry) ? qry : "";
%>

<div class="menucontent">
	<div class="topcontent"><div class="contitle">User Mail Info</div></div><%--No I18N--%>
	<div class="subtitle">Mail send status of Last 10 days</div><%--No I18N--%>
</div>
<div class="maincontent">
    <div class="field-bg">
	<div class="labelmain" id="searchuser">
	    <div class="labelkey" style="width:375px;">Enter UserName or Email Address or ZUID :</div><%--No I18N--%>
	    <div class="searchfielddiv">
                <input type="text" name="search" id="search" style="height:22px;*height:12px;" value="<%=IAMEncoder.encodeHTMLAttribute(qry)%>" class="input" onmouseover="this.focus()" onkeypress="if(event.keyCode == 13){ searchMail();return false;}"/>
	    </div>
	    <div class="Hbtn searchbtn">
		<div class="savebtn" onclick="searchMail()" style="margin:0px;">
			<span class="btnlt"></span>
			<span class="btnco">Search</span> <%--No I18N--%>
			<span class="btnrt"></span>
		</div>
	    </div>
	</div>
    </div>
</div>
<%
	if(Util.isValid(qry)) {
	JSONArray jar =  TransMailUtil.getMailInfo(qry, false);
	if(jar==null || jar.length() ==0 ) {
%>
	<div class="emtokendiv">
        <div class="nodata"></div>
        <div class="groupdet" style="font-size: 13px;">No Mail Details Found</div> <%--No I18N--%>
    </div>
<%
	} else {
		
%>					
		<div>
			<div class="apikeyheader" style="margin-top: 50px; height: 45px;">
				<div class="apikeytitle" style=" width: 22%;">MessageID</div> <%--No I18N--%>
				<div class="apikeytitle" style="width: 19%;">Email</div> <%--No I18N--%>
				<div class="apikeytitle" style="width: 13%;">Mail Type</div> <%--No I18N--%>
				<div class="apikeytitle" style="width: 10%;">Status</div> <%--No I18N--%>
				<div class="apikeytitle" style="width: 10%;">Event</div> <%--No I18N--%>
				<div class="apikeytitle" style="width: 10%;">Date</div> <%--No I18N--%>
			</div>
			<%
				for (int i = 0; i < jar.length(); i++) {
					JSONObject jobFul = jar.getJSONObject(i);
					JSONArray jarDet = jobFul.getJSONArray("Details"); //No I18N
					String type = jobFul.getString("mailStatus");
					type = "toemails".equals(type) ? "Email Send to the Email Address" : type; //No I18N
					type = "currentUseremail".equals(type) ? "Email Send by this User" : type; //No I18N
			%>
								
				<div style="font-size:15px; background: #b3c4e0; font-weight: bold; min-height: 31px;"> 	<%=type %> </div>		<%-- NO OUTPUTENCODING --%>			
			<%
				for (int j = 0; j < jarDet.length(); j++) {	
					JSONObject job = jarDet.getJSONObject(j);
			%>
				<div style="color: #030203;font-size: 13px; margin: 1px auto; min-height: 45px;">
								
			<%
					String status = "unknown"; //No I18N
					String subject = "unknown";  //No I18N
					String sentTime = "unknown"; //No I18N
					
					//event_data variables
					String object = "None" ; //No I18N
					JSONArray objectDetails = null;
					
					String hardBounce = "unknown";  //No I18N
					String softBounce = "unknown";  //No I18N
					
					String fullemail = job.getString("OrginalTo");
					String email = fullemail.length() > 35 ? fullemail.subSequence(0, 28) + ".." : fullemail; 
					String currentUserZuid = job.has("CurrentUserZuid") ? job.getString("CurrentUserZuid") : "Unauthenticated";  //No I18N
					
					String strDate= "unknown";  //No I18N
					JSONArray bounar =  null;
					
					if(job.has("transMailRespose")) { 
						JSONObject transMailRespose = job.getJSONObject("transMailRespose");  //No I18N
						
						JSONArray details = transMailRespose.getJSONArray("details"); //No I18N
						
						JSONObject emailInfo = details.getJSONObject(0).getJSONObject("email_info"); //No I18N
						JSONArray eventData =  details.getJSONObject(0).has("event_data") ?  details.getJSONObject(0).getJSONArray("event_data") : null; //No I18N
						
						subject = emailInfo.has("subject") ? emailInfo.getString("subject") : subject; //No I18N
						status = emailInfo.has("status") ? emailInfo.getString("status") : status ; //No I18N
						sentTime = emailInfo.has("processed_time") ? emailInfo.getString("processed_time") : sentTime ;  //No I18N
						
						if(eventData != null){
							object =  eventData.getJSONObject(0).optString("object"); //No I18N
							objectDetails =   eventData.getJSONObject(0).has("details") ? eventData.getJSONObject(0).getJSONArray("details") : null;  //No I18N
						}
									 
		    %>
				<div  class="apikey" style="width: 22%;" title="<%=IAMEncoder.encodeHTMLAttribute(subject)%> Send by <%=currentUserZuid %>"><%=IAMEncoder.encodeHTML(job.getString("MessageID"))%></div><%-- NO OUTPUTENCODING --%>
				<div  class="apikey" style="width: 19%;" title="<%=fullemail %>"><%=IAMEncoder.encodeHTML(email) %></div><%-- NO OUTPUTENCODING --%>
				<div  class="apikey" style="width: 13%;"><%=IAMEncoder.encodeHTML(job.getString("MailType"))%></div>
				<div  class="apikey" style="width: 10%;"><%=IAMEncoder.encodeHTML(status) %></div>
									
			<%	
				boolean haveEvent = objectDetails != null;
				if(haveEvent) { 
			%>
					<div class="apikey" style="width: 10%;"><a href="javascript:showDivByID('addemailid-<%=j%>')"><%=object%></a></div><%-- NO OUTPUTENCODING --%>	
					<div class="addnewemail" id="addemailid-<%=j%>" style="display:none;margin-left: 10%" >
						<div class="popupheader">Event Details</div> <%-- No I18N --%>
						<div class="closePop" onclick="hideDivByID('addemailid-<%=j%>');$('#opacity').hide();" ></div>
						<%	
								for(int e=0 ; e < objectDetails.length(); e++){
									JSONObject boun = objectDetails.getJSONObject(e);
									Iterator bouncekeys  = boun.keys();
								    while(bouncekeys.hasNext()) {
										String key = (String)bouncekeys.next();
										Object value = boun.get(key);
						%>
										<div class="label">
											<span class="inlineLabel" style="width: 30%"><%=IAMEncoder.encodeHTML(key) %></span>
											<span><%=IAMEncoder.encodeHTML(String.valueOf(value))%></span>
										</div>
						<%
									}
								}
						%>


					</div>
							
			<%	
    			} else {
			%>
<div  class="apikey" style="width: 10%;"><%=object%></div><%-- NO OUTPUTENCODING --%>

			<%}%>
			<div  class="apikey" style="width: 10%;" title="<%= sentTime%>"><%= sentTime %></div><%-- NO OUTPUTENCODING --%>
			<%}%>
			</div>	
										
	<%					
	 		} 
		}
	%>
	</div>	
<%
	  }
	}
%>  
	
