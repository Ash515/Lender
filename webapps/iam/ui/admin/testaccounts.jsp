<%--$Id$ --%>
<%@page import="com.adventnet.iam.UserEmail"%>
<%@page import="com.adventnet.iam.User"%>
<%@page import="com.adventnet.iam.IAMUtil"%>
<%@page import="java.util.Date"%>
<%@page import="com.adventnet.iam.internal.Util"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.List"%>
<%@page import="java.io.OutputStream"%>
<%@page import="java.util.logging.Level"%>
<%@page import="java.util.Map"%>
<%@page import="com.zoho.data.DBUtil"%>
<%@page import="com.zoho.accounts.internal.AccountsService"%>
<%@page import="com.zoho.resource.internal.ResultTableHandler"%>
<%@page import="java.util.logging.Logger"%>
<%@page import="java.io.ByteArrayInputStream"%>

<%!private static Logger LOGGER = Logger.getLogger("testaccounts.jsp");%>
<html>
<body>
	<%
String operation = request.getParameter("operation"); //No I18N
if(("download").equals(operation)){ //No I18N
	ResultTableHandler queryResult = null;
	ByteArrayInputStream in =null;
	OutputStream os = null;
	try{
		String sql = "select IAMEmail.ZUID,IAMEmail.EMAIL_ID from IAMEmail where EMAIL_ID like '%zohotest.com' limit 20000"; //No I18N
		queryResult = DBUtil.getResultTable(AccountsService.Space.SYSTEM.getValue(), sql, true, new Object[]{});
    	if(queryResult!=null && queryResult.rows.size()>0){
    		List<Object[]> objectList = queryResult.rows;
    		StringBuilder sb = new StringBuilder();
    		sb.append("ZUID,EMAIL_ID,IS_PRIMARY,IS_VERIFIED,EMAIL_CREATED_TIME").append("\n"); //No I18N
    		for (Object[] objects : objectList) {
        		Map map = objects != null ? queryResult.convertToMap(objects) : null;
        		if(map == null || map.isEmpty()) {
        			continue;
        		}
        		long zuid = Util.getLong(String.valueOf(map.get("ZUID"))); //No I18N
        		String email = String.valueOf(map.get("EMAIL_ID")); //No I18N
        		
        		User user = Util.USERAPI.getUser(zuid);
        		UserEmail userEmail = Util.USERAPI.getEmail(email);
        		
        		if(user!=null && userEmail!=null){
        			Date mailDate = new Date(userEmail.getCreatedTime());
        			sb.append(zuid).append(","); //No I18N
            		sb.append(email).append(","); //No I18N
            		sb.append(userEmail.isPrimary()).append(","); //No I18N
            		sb.append(userEmail.isConfirmed()).append(","); //No I18N
            		sb.append(mailDate.toString()).append("\n"); //No I18N
        		}
    		}
    		String output = sb.toString();
        	String charset = "UTF-8"; //No I18N
        	response.setContentType("application/download;charset=" + charset); //No I18N
        	Calendar calendar = Calendar.getInstance();
        	String file = "zohotest_mailIDs_"+calendar.get(Calendar.DATE)+"_"+calendar.get(Calendar.MONTH)+"_"+calendar.get(Calendar.YEAR)+".csv"; //No I18N
        	String userAgent = request.getHeader("USER-AGENT");
        	if (userAgent != null && userAgent.indexOf("Gecko") != -1 && userAgent.indexOf("Firefox") != -1) {
        		response.setHeader("Content-Disposition", "attachment;filename*=\"" + Util.encode(file).replace("+", " ") + "\""); //No I18N
        	} else {
        		response.setHeader("Content-Disposition", "attachment;filename=\"" + Util.encode(file).replace("+", " ") + "\""); //No I18N
        	}
        	response.setHeader("Pragma", "public"); //No I18N
	    	response.setHeader("Cache-Control", "max-age=0"); //No I18N
	    	byte bytes[] = output.getBytes(charset);
	    	in = new ByteArrayInputStream(bytes);
	    	int size = in.available();
	    	response.setContentLength(size);
	    	in.read(bytes);
	    	os = response.getOutputStream();
	    	os.write(bytes);
	    	os.flush();
        	os.close();
        	out.clear();
        	out = pageContext.pushBody();
    	}
	}catch(Exception e){
		LOGGER.log(Level.WARNING, "Exception in downloading users list",e);
		response.getWriter().println("ERROR"); //No I18N
		return;
	}finally{
		if(in!=null){
			try{ in.close(); }catch(Exception e2){ LOGGER.log(Level.WARNING,"unable to close inputStream obj",e2); }
		}
		if(os!=null){
			try{ os.flush(); os.close(); }catch(Exception e3){ LOGGER.log(Level.WARNING,"unable to close output streams obj",e3); }
		}
	}
 }else if(("close").equals(operation)){ //No I18N
	 String from = request.getParameter("fromTime");
	 String to = request.getParameter("toTime");
	 ResultTableHandler queryResult = null;
	try{
		String sql = "select IAMEmail.ZUID from IAMEmail where EMAIL_ID like '%zohotest.com' limit 20000"; //No I18N
		/* queryResult = DBUtil.getResultTable(AccountsService.Space.SYSTEM.getValue(), sql, true, new Object[]{});
	    if(queryResult!=null && queryResult.rows.size()>0){
	    	List<Object[]> objectList = queryResult.rows;
	    	for (Object[] objects : objectList) {
	        	Map map = objects != null ? queryResult.convertToMap(objects) : null;
	        	if(map == null || map.isEmpty()) {
	        		continue;
	        	}
	        	Long zuid = IAMUtil.getLong(String.valueOf(map.get("ZUID"))); //No I18N
	        	Date date = new Date();
	        	try{
	        		boolean b = Util.USERAPI.closeUserAccount(zuid, "zoho test account admin tool closing", date.toString()); //No I18N
	        	}catch(Exception e){
	        		LOGGER.log(Level.WARNING, "exception in closing account",e);
	        	}
	    	}
	    }else{  */
	    	response.getWriter().println("NO ACCOUNTS"); //No I18N
	    	return;
	   /*  } */
	}catch(Exception e){
		LOGGER.log(Level.WARNING, "exception in test account closing tool",e);
	}
 
 }else{
%>
	<div class='maincontent'>
		<div class='menucontent'>
			<div class='topcontent'>
				<div class='contitle' id='restoretitle'>Zoho Test Accounts</div> <%--No I18N--%>
			</div>
			<div class='subtitle'>Admin Services</div> <%--No I18N--%>
		</div>
		<div class='restorelink' id='view'>
			<a href='javascript:;' id='schelink' onclick='displaySchedulerSpace("schedulerselect");loadSche();' class='disablerslink'>Download</a>&nbsp/&nbsp<%--No I18N--%>
			<a href='javascript:;' id='spacelink' onclick='displaySchedulerSpace("spaceselect");loadSche();' class='activerslink'>Close Users</a><%--No I18N--%>
		</div>

		<div id='sche'>
			<div class='labelkey'>Download :</div><%--No I18N--%>
			<div id='labelvalue'>
				<div class="accbtn Hbtn">
					<div class="savebtn" onclick="downloadTestAccounts()">
						<span class="btnlt"></span> <span class="btnco">Download</span><%--No I18N--%>
						<span class="btnrt"></span>
					</div>
					<div id='downloadOut'></div>
				</div>
			</div>
		</div>
		<div id='space' style="display: none">
			<form name="deleteAccounts" class="zform"
				onsubmit="return false;" method='post'>
				<table class="orgpolicy_details" cellpadding="4" border="1"
					width="100%">
					<tr>
						<td>Created From Date</td><%--No I18N--%>
						<td><input type='date' class='input' name='fromTime' /></td>
					</tr>
					<tr>
						<td>Created To Date</td><%--No I18N--%>
						<td><input type='date' class='input' name='toTime' /></td>
					</tr>
				</table>
				<div class='mrpBtn'>
					<input type='submit' value='Submit'
						onclick="closeTestAccounts(document.deleteAccounts)" />
				</div>
			</form>
			<div id='closeResp'></div>
		</div>
	</div>
	<%
}
%>
</body>
</html>