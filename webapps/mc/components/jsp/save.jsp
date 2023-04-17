<!--$Id$-->
<%@page contentType="text/html charset=UTF-8" import="com.adventnet.db.persistence.metadata.util.*, java.io.*, java.util.*, com.adventnet.ds.query.*, com.adventnet.persistence.*, com.adventnet.db.persistence.metadata.*, com.adventnet.ds.adapter.mds.*, com.adventnet.db.adapter.*, com.adventnet.db.adapter.mysql.*, com.adventnet.db.api.*, com.adventnet.persistence.xml.*, com.adventnet.ds.query.util.*, com.adventnet.i18n.*"%>
<%
PrintWriter pw = new PrintWriter(out);
request.setCharacterEncoding("UTF-8");
String msgKey=request.getParameter("msgKey");
String msgStr=request.getParameter("msgStr");
if( msgStr!=null && msgKey!=null)
{
	//I18N.updateLMap(msgKey,msgStr);
	pw.println("SUCCESS");
}
else
{
	pw.println("FAILURE");
}

%>
