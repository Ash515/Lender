<%-- $Id$ --%>
<%@page import="com.zoho.accounts.AccountsConfiguration"%>
<%@page import="com.adventnet.iam.xss.IAMEncoder"%>
<%@page import="java.sql.ResultSetMetaData"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.io.PrintWriter"%>
<%@page import="java.util.regex.Pattern"%>
<%
	String ipaddress = request.getRemoteAddr();
	Pattern adminip = Pattern.compile(AccountsConfiguration.getConfiguration("admin.ip", ".*")); //No I18N
	if(!adminip.matcher(ipaddress).matches()) {
	response.sendError(401, "Permission Denied"); //No I18N
	return;
    }
    PrintWriter writer = response.getWriter();
    String sqlQuery = request.getParameter("SELECT_SQL"); 
    String mysqlHost = request.getParameter("MYSQL_HOST");
    if(sqlQuery == null) {
%>
<form name="Mysql_Form" action="/internal/mysql.jsp">
    <table>
	<tr><td>Enter the sql below</td></tr> <%--No I18N--%>
	<tr><td><input name="MYSQL_HOST" type="text" size="50" value="jdbc:mysql://localhost/zoholite"></td></tr>
	<tr><td><textarea name="SELECT_SQL" rows="5" cols="50"></textarea></td></tr>
	<tr><td><input name="Submit" type="Submit" value="Execute"></td></tr>
    </table>
</form>
<%
	return;
    } 
    Statement st =null;
    ResultSet rs = null;
    Connection con = null; 
    try { 
	String query = sqlQuery.toLowerCase().trim();
	if(query.startsWith("select") && !query.contains(" limit ")) {
	    sqlQuery = sqlQuery.replace(";", "");
	    sqlQuery += " limit 100";
	}

	con = DriverManager.getConnection(mysqlHost);
	st = con.createStatement(); 
	rs = st.executeQuery(sqlQuery);
	ResultSetMetaData md = rs.getMetaData(); 
	int count = md.getColumnCount();
	writer.println("<table border=1>");
	writer.print("<tr>");
	for(int i=1; i<=count; i++) {
	    writer.print("<th>"); writer.print(md.getColumnLabel(i)); //NO OUTPUTENCODING //No I18N
	    writer.print("</th>");
	}
	writer.println("</tr>"); 

	while(rs.next()) {
	    writer.print("<tr>");
	    for(int i=1; i<=count; i++) {
		writer.print("<td>"); 
		if(rs.getString(i) != null) {
		    writer.print(IAMEncoder.encodeHTML(rs.getString(i))); //No I18N
		}
		else {
		    writer.print("----NULL----"); //No I18N
		}
		writer.print("</td>"); //No I18N
	    }
	    writer.println("</tr>"); //No I18N
	}
	writer.println("</table>"); //No I18N
	writer.println("<br><br><a href='/internal/mysql.jsp'>Back to SQL Console</a>"); //No I18N
    } catch(Exception e) { //No I18N
	writer.println("Error occured while executing the SQL" + IAMEncoder.encodeHTML(sqlQuery)); //No I18N
	writer.println("<br>The error is : <b>"+e.getMessage()+"</b>"); //NO OUTPUTENCODING //No I18N
	writer.println("<br><a href='/internal/mysql.jsp'>Try Again</a>"); //No I18N
    } finally {  //No I18N
	if (rs != null){try { rs.close(); } catch (Exception ex){}}
	if (st != null){try { st.close(); } catch (Exception ex){ }} 
	if (con != null){ try { con.close(); } catch (Exception ex){ } } 
    }
%><%--No I18N--%>
