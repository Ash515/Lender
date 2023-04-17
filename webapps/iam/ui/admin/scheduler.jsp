<%--$Id$ --%>
<%@page import="com.adventnet.iam.xss.IAMEncoder"%>
<%@page import="com.zoho.accounts.internal.AccountsService.Space"%>
<%@page import="com.zoho.accounts.internal.AccountsService"%>
<%@page import="java.util.*"%>
<%@page import="java.text.*"%>
<%@page import="java.util.Map.Entry"%>
<%@page import='com.zoho.accounts.internal.admin.SchedulerUtil'%>
<%@page import='com.zoho.scheduler.*'%>

<html>
<head>
<style>
.td{
	padding:10px;
}
.th{
	background: url('../images/common-bg.gif') repeat-x scroll 0 -385px transparent;
	padding-bottom:10px;
}
.tab{
border-collapse:collapse;
width:100%;
text-align: center;
}
#listdiv{
	font-size: 11px;
	margin:10px auto 0px;
	width: 99%;
}
.hide{
	display:none;
}
.but{
	border: none;
    padding: 2px 15px;
    -moz-border-radius: 4px;
    -webkit-border-radius: 4px;
    border-radius: 4px;
    cursor: pointer;
}
#addsys {
width: 35%;
position: absolute;
top: 40%;
left: 37%;
}
.input {
border: 1px solid #BDC7D8;
font-size: 13px;
width: 200px;
padding: 2px 2px 3px;
}
.form{
text-align: left;
}
.divScroll-1 {
     white-space: -moz-pre-wrap !important;  
     white-space: -pre-wrap;
     white-space: -o-pre-wrap;
     white-space: pre-wrap;
     word-wrap: break-word;
     word-break: break-all;
     white-space: normal;
}
body, table, a, input, select, textarea {
font-family: 'Open sans';
font-weight: 400;
}
</style>
</head>
<body>
<%
String t = request.getParameter("t");//No I18N
%>
<div class='maincontent'>
	<div class='menucontent'>
		<div class='topcontent'><div class='contitle' id='restoretitle'>Scheduler</div></div> <%--No I18N--%>
		<div class='subtitle'>Admin Services</div> <%--No I18N--%>
    </div>
	<div class='restorelink' id='view'>
	    <a href='javascript:;' id='schelink' onclick='displaySchedulerSpace("schedulerselect");loadSche();' class='disablerslink'>View By Scheduler</a>&nbsp/&nbsp <%--No I18N--%>
	    <a href='javascript:;' id='spacelink' onclick='displaySchedulerSpace("spaceselect");loadSche();' class='activerslink'>View By Space</a> <%--No I18N--%>
    </div>
	<div class='restorelink'  id='addnewbtn' style='text-align: right;'>
	   	<a href='javascript:;' id='serlink' onclick='addNewScheduler("show")' class='activerslink'>Add New</a> <%--No I18N--%>
	</div>
	
	<div id='sche'>
		<div class='labelkey'>Schedulers : </div>	<%--No I18N--%>
		<div id='labelvalue'>
			<select id='view' name='schedulerselect' style='width: 220px;' class='select' onchange='loadSchedulerSpace("schedulerselect",this.value, this[this.selectedIndex].id);'><%--No I18N--%>
				<option value='SELECT'>select scheduler</option> <%--No I18N--%>
			<%	Map<String, Map<String, Object>> schedulerNames = SchedulerUtil.getSchedulers();
    			for(Entry<String, Map<String, Object>> entry : schedulerNames.entrySet()) {
    				String schedulerName = entry.getKey();
    				String schedulerType = (String) entry.getValue().get("type");	//No I18N
    		%>
    			<option value="<%=IAMEncoder.encodeHTMLAttribute(schedulerName)%>" id='<%=IAMEncoder.encodeHTMLAttribute(schedulerType)%>'><%=IAMEncoder.encodeHTML(schedulerName)%></option> <%--No I18N--%>
    	
    		<%
    			}
    		%>
    		</select>
    	</div>
    </div>

	<div id='space' style='display: none;'>
		<div class='labelkey'>Spaces : </div>	<%--No I18N--%>
		<div id='labelvalue'>
			<select id='view' name='spaceselect' style='width: 220px;' class='select' onchange='return loadSchedulerSpace("spaceselect",this.value, this[this.selectedIndex].id)'><%--No I18N--%>
				<option value='SELECT'>select space</option> <%--No I18N--%>
				
    		<%	
    			for(Space space : Arrays.asList(AccountsService.Space.values())) {
    		%>
    			<option value='<%=IAMEncoder.encodeHTMLAttribute(space.getKey())%>' id='<%=IAMEncoder.encodeHTMLAttribute(space.getValue())%>'><%=IAMEncoder.encodeHTML(space.getValue())%></option> <%--No I18N--%>
    		<%
    			}
    		%>
    		</select>
    	</div>
    </div>
	
	<div id='display'>
	<%	if(t.equalsIgnoreCase("edit")) {
			String name = request.getParameter("name");//No I18N
			if(SchedulerUtil.readSchedulerMetaData(name, "class") != null) {
				String schedulerName = name;
				Repetition repetition = SchedulerUtil.getSchedulerMetaDataFromDB(schedulerName);
				if(repetition instanceof PeriodicRepetition) {
	 				PeriodicRepetition p = (PeriodicRepetition) repetition;
    %>
 		<div id='persche'>
    		<div id='listdiv'>
    			<table class='tab' id='tab1'>
    				<tr><th class='th'>Property</th><th class='th'>Value</th></tr>	<%--No I18N--%>
    				<tr><td class='td'>Scheduler_Name</td><td class='td'><%=IAMEncoder.encodeHTML(p.getRepetitionName())%></td></tr><tr><td class='td'>Scheduler_Type</td><td class='td'>PeriodicRepetition</td></tr><tr><td class='td'>Time_Period</td><td class='td'><%=IAMEncoder.encodeHTML(""+p.getPeriodicity())%></td></tr>	<%--No I18N--%>
    			</table>
    		</div>
		</div>
		<%		} else if(repetition instanceof CalendarRepetition){
					CalendarRepetition c = (CalendarRepetition) repetition;
	%>
		<div id='calsche'>
    		<div id='listdiv'>
    			<table class='tab' id='tab2'>
    				<tr><th class='th'>Property</th><th class='th'>Value</th></tr>	<%--No I18N--%>
    				<tr><td class='td'>Scheduler_Name</td><td class='td'><%=IAMEncoder.encodeHTML(c.getRepetitionName()) %></td></tr><tr><td class='td'>Scheduler_Type</td><td class='td'>CalendarRepetition</td></tr><tr><td class='td'>Schedule_Type</td><td class='td'><%= IAMEncoder.encodeHTML(""+c.getRepetitionType()) %></td></tr>	<%--No I18N--%>
    				<%if(c.getDaysOfWeek() != null) { %>
    				<tr><td class='td'>Days_Of_Week</td><td class='td'><%=IAMEncoder.encodeHTML(""+c.getDaysOfWeek()[0]) %></td></tr>	<%--No I18N--%>
    				<%} %>
    				<tr><td class='td'>Time_Zone</td><td class='td'><%=IAMEncoder.encodeHTML(c.getTimeZone().getDisplayName()) %></td></tr><tr><td class='td'>Run_Atleast_Once</td><td class='td'><%=IAMEncoder.encodeHTML(""+c.isRunOnceAtleastSet()) %></td></tr>	<%--No I18N--%>
    			</table>
    		</div>
    	</div>
	<%			}
	%>
		<div id='spacelist'>
			<div id='listdiv1'>
				<table class='tab' id='tab1'>
					<tr><th class='th'>Space</th><th class='th'>Job ID</th><th class='th'>Class</th><th class='th'>Next Execution Time</th><th class='th'>Status</th><th class='th'>Action</th></tr>	<%--No I18N--%>
	<%			boolean jobExist = false;
				int count = 0;
				for(Space space : Arrays.asList(AccountsService.Space.values())) {	
					try {
						RepetitiveJob job = SchedulerUtil.getRepetitiveJob(schedulerName, space.getValue());
						jobExist = true;
						count++;
	%>
					<tr><td class='td'><%=IAMEncoder.encodeHTML(space.getValue()) %></td><td class='td' id='jobid'><%=IAMEncoder.encodeHTML(""+job.getJobID()) %></td>
					<td class='td' class='divScroll-1'><div style='width:290px' class='view-<%=count%>'><%=IAMEncoder.encodeHTML(SchedulerUtil.getClassName(job.getJobID(),space.getValue()))%></div><div class='edit-<%=count%>' style='display: none;'><input type='text' style='width:350px;' id='class-<%=count%>' value='<%=IAMEncoder.encodeHTMLAttribute(SchedulerUtil.getClassName(job.getJobID(),space.getValue()))%>'></div></td>
					<td class='td' id='time'>
					<%
						DateFormat dateFormatEdit = new SimpleDateFormat("yyyy/MM/d-HH:mm:ss");	//No I18N
						dateFormatEdit.setTimeZone(TimeZone.getTimeZone("IST"));	//No I18N
						String time = dateFormatEdit.format(new Date(job.getTimeOfExecution()));
					%><div class='view-<%=count%>'><%=IAMEncoder.encodeHTML(time)%></div><div class='edit-<%=count%>' style='display: none;'><input type='text' style='width:155px;' id='time-<%=count%>' value='<%=IAMEncoder.encodeHTMLAttribute(time)%>' placeholder='YYYY/MM/DD-HH:MM:SS'></div></td>
					<td class='td'  id='status'><%if(job.getAdminStatus() == true) { %><div class='view-<%=count%>'>Enabled</div><div class='edit-<%=count %>' style='display: none;'><input type='checkbox' name='status' id='status-<%=count%>' checked>Enable</div> <%} else { %><div class='view-<%=count%>'>Disabled</div><div class='edit-<%=count %>' style='display: none;'><input type='checkbox' name='status' id='status-<%=count%>'>Enable</div><%}%></td>	<%--No I18N--%>
					<td class='td' id='action'>
					<div class='view-<%=count%>'><a href='javascript:;' onclick='showHideDivs("edit-<%=count%>","view-<%=count%>")' style='margin-left:8px;'><span class='editicon' style='margin-left:20px;margin-right:-5px;cursor: pointer' title='Edit'></span></a><%--No I18N--%>
					<a href='javascript:;' onclick="deleteSchedulerJob('<%=IAMEncoder.encodeJavaScript(""+job.getJobID()) %>','<%=IAMEncoder.encodeJavaScript(space.getValue()) %>')" style='margin-left:2px;'><span class='dltalltokensicon ' title='Delete'></span></a></div>
					<div class='edit-<%=count%>' style='display: none;'><a href='javascript:;' id='serlink' onclick='editJob("<%=count%>","<%=IAMEncoder.encodeJavaScript(schedulerName)%>","<%=IAMEncoder.encodeJavaScript(space.getValue())%>","<%=IAMEncoder.encodeJavaScript(""+job.getJobID())%>");' class='activerslink'>save</a>&nbsp&nbsp<a href='javascript:;' id='serlink' onclick='reloadDiv()' class='activerslink'>cancel</a></div>	<%--No I18N--%>
					</td></tr>	<%--No I18N--%>
	<%
					} catch(Exception e) {
					}
				} 
				if(!jobExist) {
	%>
					<tr><td colspan='6' class='td' style='text-align: center;'>No Job Exists for this Scheduler</td></tr>	<%--No I18N--%>
	<%
				}
	%>
				</table>
			</div>
		</div>
	<%
			} else {
				String spaceName = name;
				String spaceDB = null;
				for(Space space : Arrays.asList(AccountsService.Space.values())) {
					if(space.getKey().equalsIgnoreCase(spaceName)) {
						spaceDB = space.getValue();
						break;
					}
				}
				if(spaceDB != null) {
	%>
		<div id='space'>
    		<div id='listdiv'>
    			<table class='tab' id='tab1'>
    				<tr><th class='th'>Space Name</th><th class='th'>Value</th></tr>	<%--No I18N--%>
    				<tr><td class='td'><%=IAMEncoder.encodeHTML(spaceName)%></td><td class='td'><%=IAMEncoder.encodeHTML(spaceDB)%></td></tr>
    			</table>
    		</div>
			<div id='listdiv'>
				<table class='tab' id='tab1'>
					<tr><th class='th'>Scheduler</th><th class='th'>Scheduler Type</th><th class='th'>Job ID</th><th class='th'>Class</th><th class='th'>Next Execution Time</th><th class='th'>Status</th><th class='th'>Action</th></tr>	<%--No I18N--%>
    <% 			Map<String, Map<String, Object>> schedulers = SchedulerUtil.getSchedulers();
    			boolean jobExist = false;
    			int count = 0;
    			for(Entry<String, Map<String, Object>> entry : schedulers.entrySet()) {
    				String scheduler = entry.getKey();
    				String schedulerType = (String) entry.getValue().get("type");	//No I18N
   					try{
    					RepetitiveJob  job = SchedulerUtil.getRepetitiveJob(scheduler, spaceDB);
    					jobExist = true;
    					count++;
    %>
    				<tr id="<%=IAMEncoder.encodeHTMLAttribute(scheduler)%>-<%=IAMEncoder.encodeHTMLAttribute(spaceDB)%>"><td class='td'><%=IAMEncoder.encodeHTML(scheduler) %></td><td class='td'><%=IAMEncoder.encodeHTML(schedulerType) %></td><td class='td' id='jobid'><%=IAMEncoder.encodeHTML(""+job.getJobID()) %></td>
    				<td  class='divScroll-1'><div style='width:209px;' class='view-<%=count%>'><%=IAMEncoder.encodeHTML(SchedulerUtil.getClassName(job.getJobID(),spaceDB))%></div><div class='edit-<%=count%>' style='display: none;'><input type='text' style='width:159px;' id='class-<%=count%>' value='<%=IAMEncoder.encodeHTMLAttribute(SchedulerUtil.getClassName(job.getJobID(),spaceDB))%>'></div></td>
					<td class='td' id='time'>
	<%
						DateFormat dateFormatEdit = new SimpleDateFormat("yyyy/MM/d-HH:mm:ss");	//No I18N
						dateFormatEdit.setTimeZone(TimeZone.getTimeZone("IST"));	//No I18N
						String time = dateFormatEdit.format(new Date(job.getTimeOfExecution()));
	%>					<div class='view-<%=count%>'><%=IAMEncoder.encodeHTML(time)%></div><div class='edit-<%=count%>' style='display: none;'><input type='text' style='width:155px;' id='time-<%=count%>' value='<%=IAMEncoder.encodeHTMLAttribute(time) %>' placeholder='YYYY/MM/DD-HH:MM:SS'></div></td>
					<td class='td'  id='status'><%if(job.getAdminStatus() == true) { %><div class='view-<%=count%>'>Enabled</div><div class='edit-<%=count %>' style='display: none;'><input type='checkbox' name='status' id='status-<%=count%>' checked>Enable</div> <%} else { %><div class='view-<%=count%>'>Disabled</div><div class='edit-<%=count %>' style='display: none;'><input type='checkbox' name='status' id='status-<%=count%>'>Enable</div><%}%></td>	<%--No I18N--%>
					<td class='td' id='action'><div class='view-<%=count%>'>
						<a href='javascript:;' onclick='showHideDivs("edit-<%=count%>","view-<%=count%>")' style='margin-left:-11px;'><span class='editicon ' style='margin-left:20px;' title='Edit'></span></a>&nbsp&nbsp&nbsp&nbsp<%--No I18N--%>
						<a href='javascript:;' onclick="deleteSchedulerJob('<%=IAMEncoder.encodeJavaScript(""+job.getJobID()) %>','<%=IAMEncoder.encodeJavaScript(spaceDB) %>')" ><span class='dltalltokensicon ' title='Delete'></span></a></div>
					<div class='edit-<%=count%>' style='display: none;'><a href='javascript:;' id='serlink' onclick='editJob("<%=count%>","<%=IAMEncoder.encodeJavaScript(scheduler)%>","<%=IAMEncoder.encodeJavaScript(spaceDB)%>","<%=IAMEncoder.encodeJavaScript(""+job.getJobID())%>");' class='activerslink'>save</a>&nbsp&nbsp<a href='javascript:;' id='serlink' onclick='reloadDiv()' class='activerslink'>cancel</a></div>	<%--No I18N--%>
    <%
   					} catch(Exception e) {
   					}
    			}
    			if(!jobExist) {
    	%>
    				<tr><td colspan='7' class='td' style='text-align: center;'>No Job Exists for this Space</td></tr>	<%--No I18N--%>
    	<%
    			}
    	%>
    			</table>
			</div>
    	</div>
	<%
				}
			}
		}
	%>
	</div>
	
	<div id='addsys' style='display: none;'>
		<div><b class='mrptop outbg'><b class='mrp1'></b><b class='mrp2'></b><b class='mrp3'></b><b class='mrp4'></b></b></div>
		<div class='mrpheader'><span class='close' onclick='addNewScheduler("hide")'></span> <span>Scheduler</span></div>	<%--No I18N--%>
		<div class='mprcontent'>
			<div><b class='mrptop inbg'><b class='mrp2'></b><b class='mrp3'></b><b class='mrp4'></b></b></div>
			<div class='mrpcontentdiv'><form id='addjob' class='zform' onsubmit='return addSchedulerJob(this)' method='post'>
					<table cellspacing='5' cellpadding='0' border='0' width='100%'>
						<tr><td align='right'>Scheduler :</td><td><select id='addscheduler' name='view' style='width: 220px;' class='select'><%--No I18N--%>
							<option value='SELECT'>select scheduler</option> <%--No I18N--%>
			<%				for(Entry<String, Map<String, Object>> entry : SchedulerUtil.getSchedulers().entrySet()) {
			    			String schedulerName = entry.getKey();
			    			String schedulerType = (String)entry.getValue().get("type");	//No I18N
    		%>
    						<option value="<%=IAMEncoder.encodeHTMLAttribute(schedulerName)%>"><%=IAMEncoder.encodeHTML(schedulerName)%></option> <%--No I18N--%>
    	
    		<%	
    						}
    		%>
    					</select></td></tr>
						<tr><td align='right'>Space :</td><td><select id='addspace' name='view' style='width: 220px;' class='select'><%--No I18N--%>
							<option value='SELECT'>select space</option> <%--No I18N--%>
    		<%					for(Space space : Arrays.asList(AccountsService.Space.values())) {
    		%>
    							<option value="<%=IAMEncoder.encodeHTMLAttribute(space.getValue())%>"><%=IAMEncoder.encodeHTML(space.getValue())%></option> <%--No I18N--%>
    		<%
    							}
    		%>
    						</select></td></tr>
						<tr><td align='right'>Job ID :</td><td><input type='number' class='input' id='addjobid'/></td></tr>	<%--No I18N--%>
						<tr><td align='right'>Time of Execution :</td><td><input type='text' class='input' id='addtime' placeholder='YYYY/MM/DD-HH:MM:SS'/></td></tr><tr><td></td>	<%--No I18N--%>
			<%
								SimpleDateFormat formatter = new SimpleDateFormat("yyyy/MM/d-HH:mm:ss");	//No I18N
								Calendar calendar = Calendar.getInstance();
							    calendar.setTimeInMillis(System.currentTimeMillis());
			%>
						<td>Ex : <%=IAMEncoder.encodeHTML(formatter.format(calendar.getTime()))%></td></tr>	<%--No I18N--%>
						<tr><td align='right'>Admin Password :</td><td><input type='password' class='input' id='pwd'/></td></tr>	<%--No I18N--%>
					</table>
					<%	if (request.isUserInRole("IAMAdmininistrator") || request.isUserInRole("IAMSystemAdmin")) {	%>
					<div class='mrpBtn'><input type='submit' value='Add'/> <input type='button' value='Cancel' onclick='addNewScheduler("hide")' /></div>
					<%	}	%>
			</form></div>
			<div><b class='mrpbot inbg'><b class='mrp4'></b><b class='mrp3'></b><b class='mrp2'></b></b></div>
		</div>
		<div><b class='mrpbot outbg'><b class='mrp4'></b><b class='mrp3'></b><b class='mrp2'></b><b class='mrp1'></b></b></div>
	</div>
</div>
</body>
</html>