

<%--$Id$--%>



<%@ page import="com.adventnet.ds.query.*" %>
<%@ page import="com.adventnet.persistence.*" %>
<%@ page import="com.adventnet.client.util.LookUpUtil" %>
<%

String reqType = request.getParameter("reqType");
if(reqType.equals("isunique"))
{
    String table = request.getParameter("table");
    String colName = request.getParameter("col");
    String colVal = request.getParameter("colVal");

    Column queryColumn = new Column(table,colName);
    Criteria queryCriteria = new Criteria(queryColumn,colVal,QueryConstants.EQUAL);

    DataObject dobj = LookUpUtil.getPersistence().get(table,queryCriteria);
	if(colVal!=null){
        if(dobj.containsTable(table))
        {
            %>
            false
            <%
        }
        else
        {
	        %>
            true
	        <%
	    }
	}
	else{
		if(dobj.containsTable(table)){
			Row row = dobj.getRow(table);
			Object obj = row.get(colName);
			if(obj!=null && !obj.toString().equals("")){
	        %>
            true
	        <%
			}
			else{
	        %>
            false
	        <%
			}
		}
		else
		{
	        %>
            false
	        <%
		}

	}
}
%>

