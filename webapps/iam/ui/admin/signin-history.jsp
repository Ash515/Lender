<%-- $Id$ --%>
<%@page import="com.zoho.accounts.internal.audit.SignInHistoryUtil"%>
<%@page import="java.util.logging.Logger"%>
<%@page import="java.util.logging.Level"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="java.io.OutputStream"%>
<%@page import="com.zoho.data.DBUtil"%>
<%@page import="com.zoho.accounts.internal.AccountsService"%>
<%@page import="com.adventnet.iam.security.SecurityUtil"%>
<%@page import="java.io.IOException"%>
<%@page import="com.adventnet.ds.DataSourceBean"%>
<%@page import="com.zoho.resource.internal.ResultTableHandler"%>
<%@page import="com.zoho.accounts.AccountsConstants"%>
<%@page import="java.io.ByteArrayInputStream"%>
<%@page import="java.io.InputStream"%>
<%@ include file="includes.jsp" %>
<%!
	private SortedMap<String,SortedMap<Integer,SortedSet<Integer>>> dbSpaceMap = null;
	private static String getMonthForNumber(Integer month) {
		switch(month) {
		case 1:
			return "January"; //No I18N
		case 2:
			return "Febrauary"; //No I18N
		case 3:
			return "March"; //No I18N
		case 4:
			return "April"; //No I18N
		case 5:
			return "May"; //No I18N
		case 6:
			return "June"; //No I18N
		case 7:
			return "July"; //No I18N
		case 8:
			return "August"; //No I18N
		case 9:
			return "September"; //No I18N
		case 10:
			return "October"; //No I18N
		case 11:
			return "November"; //No I18N
		case 12:
			return "December"; //No I18N
		default:
			return null;
		}
	}
%>
<%    
    InputStream req_file = Util.getUploadedFile(request);
    String action = request.getParameter("mode");
    if("read".equals(action)) {
    	String uid = request.getParameter("uid");
    	User u = null;
    	try {
    		long zuid = Long.parseLong(uid);
    		u = Util.USERAPI.getUser(zuid);
		} catch(Exception e) {
			u = Util.USERAPI.getUser(uid);
		}
    	if(u == null) {
    		out.println("<script>parent.handleLoginDetailsResp('Invalid user specified')</script>"); //No I18N
    		return;
    	}
        ByteArrayInputStream in = null;
        String tableSubfixRequest = request.getParameter("tbl_subfix");
        String tableName, dbSpace;
        if(!Util.isValid(tableSubfixRequest)) {
        	tableName = "IAMAccountAuditTemplate"; //No I18N
        	dbSpace = AccountsService.Space.AUDIT.getValue();
        } else {
        	String[] tableSubfixArray = tableSubfixRequest.split(",");
        	if(tableSubfixArray.length == 2) {
        		dbSpace = tableSubfixArray[0];
        		if(!AccountsConfiguration.AVALAIBLE_DB_SPACE_AUDIT.checkCommaSpearatedList(dbSpace, false)) {
        			out.println("<script>parent.handleLoginDetailsResp('Illegal dbSpace in parameter')</script>"); //No I18N
            		return;
        		}
        		String[] monthAndYear = tableSubfixArray[1].split("_");
        		if(monthAndYear.length == 2) {
        			tableName = "IAMAccountAuditTemplate_"+monthAndYear[0]+"_"+monthAndYear[1]; //No I18N
        		} else {
        			out.println("<script>parent.handleLoginDetailsResp('Illegal value in parameter')</script>"); //No I18N
            		return;
        		}        		
        	} else {
        		out.println("<script>parent.handleLoginDetailsResp('Illegal value in parameter')</script>"); //No I18N
        		return;
        	}
        }
        try {

        	String delim = ",";
        	String quote = "\"";
        	String operation, operator, resultHeader, fileName;
        	String operationString = request.getParameter("operation");
        	int operationInt = IAMUtil.getInt(operationString);
        	switch(operationInt) {
        		case 1:
        			fileName = "SignIn";
        			operation = "%SIGN_IN";
        			operator = "like";
        			resultHeader = "LOGIN_ID"+delim+"SERVICE_NAME"+delim+"IP_ADDRESS"+delim+"SIGNIN_TIME"+delim+"LOGIN_IDP"+delim+"REFERRER"+delim+"USER_AGENT\n";
        			break;
        		case 2:
        			fileName = "SignOut";
        			operation = "SIGN_OUT";
        			operator = "=";
        			resultHeader = "USER_ID"+delim+"SERVICE_NAME"+delim+"IP_ADDRESS"+delim+"SIGNOUT_TIME"+delim+"OPERATION"+delim+"REFERRER"+delim+"USER_AGENT\n";
        			break;
        		default:
        			out.println("<script>parent.handleLoginDetailsResp('Illegal value in parameter')</script>"); //No I18N
            		return;
        	}
        	DataSourceBean dsb = (DataSourceBean) DBUtil.getDataSourceBean(dbSpace);
        	ResultTableHandler queryResult = dsb.executeQuery(ResultTableHandler.class, "select * from "+tableName+" where ZUID=? and OPERATION "+operator+" '"+operation+"' limit 2000", String.valueOf(u.getZUID())); //No I18N
        	List<Object[]> queryRows = queryResult != null ? queryResult.rows : null;
        	if(queryRows == null || queryRows.isEmpty()) {
        		out.println("<script>parent.handleLoginDetailsResp('No "+fileName+" history found for selected month')</script>"); //No I18N
        		return;
        	}
        	if(queryRows.size() >= 2000) {
        		out.println("<script>parent.handleLoginDetailsResp('User has more than 2000 records')</script>"); //No I18N
        		return;
        	}
        	StringBuilder sb = new StringBuilder(resultHeader); //No I18N
        	for (Object[] objects : queryRows) {
        		Map map = objects != null ? queryResult.convertToMap(objects) : null;
        		if(map == null || map.isEmpty()) {
        			continue;
        		}
        		Timestamp time = new Timestamp(IAMUtil.getLong(map.get("CREATED_TIME").toString())); //No I18N

        		sb.append(quote).append(map.get("SCREEN_NAME")).append(quote).append(delim);
        		sb.append(quote).append(map.get("APP_NAME")).append(quote).append(delim);
        		sb.append(quote).append(map.get("IP_ADDRESS")).append(quote).append(delim);
        		sb.append(quote).append(time).append(quote).append(delim);
        		sb.append(quote).append(map.get("OPERATION")).append(quote).append(delim);
        		sb.append(quote).append(map.get("REFERRER")).append(quote).append(delim);
        		sb.append(quote).append(map.get("USER_AGENT")).append(quote).append("\n"); //No I18N
        	}
        	out.println("<script>parent.handleLoginDetailsResp('SUCCESS')</script>"); //No I18N
        	String output = sb.toString();
        	String charset = "UTF-8"; //No I18N
        	response.setContentType("application/download;charset=" + charset); //No I18N
        	String file = uid+"_"+fileName+"_History.csv"; //No I18N
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
        	OutputStream os = response.getOutputStream();
        	os.write(bytes);
        	os.flush();
        	os.close();
        	out.clear();
        	out = pageContext.pushBody();
        }catch(SQLException e){
        	if("42S02".equals(e.getSQLState())){ //SQLSTATE: 42S02 (table does not exist)
        		out.println("<script>parent.handleLoginDetailsResp('Data unavailable for selected month')</script>"); //No I18N
        	} else {
        		out.println("<script>parent.handleLoginDetailsResp('Data access error occurred')</script>"); //No I18N
        	}
        } catch(Exception ex) {
            out.println("<script>parent.handleLoginDetailsResp('"+IAMEncoder.encodeJavaScript(ex.getMessage())+"')</script>"); //No I18N
        } finally {
            try {
                if (in != null) {
                    in.close();
                }
            } catch (IOException ioe) {
            }
        }
        return;
    } else {
%>
<div class="maincontent">
    <div class="menucontent">
		<div class="topcontent"><div class="contitle">SignIn History</div></div> <%--No I18N--%>
		<div class="subtitle">Admin Services</div> <%--No I18N--%>
    </div>
	<%
		try {
			dbSpaceMap = SignInHistoryUtil.getSpaceDBMap();
		} catch (SQLException e) {
			if ("42S02".equals(e.getSQLState())) { //SQLSTATE: 42S02 (table does not exist)
				Logger.getLogger("SIGNIN_HISTORY").log(Level.SEVERE, "Table does not exist  "+e.getMessage());//No I18N
				out.println("<div class='checkiplist'>Unable to Get Month Details</div>"); //No I18N
				return;
			} else {
				Logger.getLogger("SIGNIN_HISTORY").log(Level.SEVERE, "SQLException  "+e.getMessage());//No I18N
				out.println("<div class='checkiplist'>Unable to Get Month Details</div>"); //No I18N
				return;
			}
		} catch (Exception ex) {
			Logger.getLogger("SIGNIN_HISTORY").log(Level.SEVERE, "General Exception  "+ex.getMessage());//No I18N
			out.println("<div class='checkiplist'>Unable to Get Month Details</div>"); //No I18N
			return;
		}
	%>
    <div class="field-bg">
		<form method="post" class="zform" target="downloadaction" name="loginhistoryform" id="zloginhistoryform" onsubmit="return downloadLoginDetails(this);" onchange="return resetLoginHistoiryForm(this);">
			<div class="labelmain">
				<div class="labelkey">Enter UserName or Email Address or ZUID :</div> <%--No I18N--%>
				<div class="labelvalue">
					<input type="text" name="uid" style="height:22px;*height:12px;" class="input" onmouseover="this.focus()"/>
				</div>
			</div>
			<div class="labelmain">
				<div class="labelkey">Operation :</div> <%--No I18N--%>
				<div class="labelvalue">
					<select name="operation" class="select">
						<option value="1">SIGN_IN</option>
						<option value="2">SIGN_OUT</option>
					</select>
				</div>
			</div>
			<div class="labelmain">
				<div class="labelkey">Select a Month :</div> <%--No I18N--%>
				<div class="labelvalue">
					<select name="tbl_subfix" class="select">
						<%
						out.println("<option value='"+null+"'>"+"Current Month"+"</option>"); //No I18N
						if(IAMUtil.isValid(dbSpaceMap) && !dbSpaceMap.isEmpty()) {
							for(Map.Entry<String,SortedMap<Integer,SortedSet<Integer>>> dbSpaceEntry : dbSpaceMap.entrySet()) {
								String dbSpace = dbSpaceEntry.getKey();
								for(Map.Entry<Integer,SortedSet<Integer>> yearEntry : dbSpaceEntry.getValue().entrySet()) {
									Integer year = yearEntry.getKey();
									String value="";
									String tblSuffix = "";
									for(Integer month : yearEntry.getValue()) {
										String monthString = getMonthForNumber(month);
										if(!IAMUtil.isValid(monthString)) {
											Logger.getLogger("SIGNIN_HISTORY").log(Level.INFO, "Unable to get valid month name from "+dbSpace+" "+year+" "+month);//No I18N
											continue;
										}
										value = monthString+" "+year;
										tblSuffix = dbSpace+","+String.format("%02d", month)+"_"+year;
						%>
						<option value="<%=IAMEncoder.encodeHTMLAttribute(tblSuffix)%>"><%=IAMEncoder.encodeHTML(value)%></option>
						<%										
									}
								}
							}
						}
						%>
					</select>
				</div>
			</div>
			<div class="labelmain" style="border: 1px solid transparent;">
				<div class="labelkey">&nbsp;</div>
				<div class="labelvalue">
					<button onclick="downloadLoginDetails(document.loginhistoryform)" id="actionbtn">Download SignIn History</button> <%--No I18N--%>
				</div>
			</div>
			<input type="hidden" name="<%=SecurityUtil.getCSRFParamName(request)%>" value="<%=SecurityUtil.getCSRFCookie(request)%>"/> <%-- NO OUTPUTENCODING --%>
			<input type="hidden" name="mode" value="read"/>
		</form>
    </div>
</div>
<iframe name="downloadaction" id="downloadaction" class="hide" frameborder="0" height="0%" width="0%"></iframe>
<%
}
%>

