<%-- $Id$ --%>
<%@ include file='/components/jsp/CommonIncludes.jspf'%>
<%@ page import="java.util.Vector"%>
<%@ page import="java.util.Hashtable"%>
<%@ page import="com.adventnet.client.util.web.WebClientUtil"%>
<%@ page import="com.adventnet.client.components.tools.web.ExecuteQueryController"%>
<script src="<%out.print(request.getContextPath());//NO OUTPUTENCODING%>/components/javascript/dbconsole.js"></script><%--NO OUTPUTENCODING --%>

<script>
window.focus();
</script>

<%
String task = (String)request.getAttribute("task");
Hashtable hash = (Hashtable)request.getAttribute("hash");
String message = (String)request.getAttribute("message");
String query = (String)request.getAttribute("query");
String rowsAffected = (String)request.getAttribute("rowsAffected");
Vector header = null;
Vector tabular = null;
%>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<%
String formaction = null;
if(WebClientUtil.isRestful(request))
{
	formaction = request.getContextPath() + "/STATE_ID/" + uniqueId + ".ve";
}
else
{
	formaction = uniqueId + ".ve";
}
%>
<form name="ExecuteQueryForm" action='<%=IAMEncoder.encodeHTMLAttribute(formaction)%>' method="post" onSubmit="handleStateForForm(this)">
<input type="hidden" name="execute" value="">

<table width="100%" border="0" cellspacing="0" cellpadding="0" style="padding-left:12px">
    <tr>
    <td valign="top">

  <table border="0" cellpadding="1" cellspacing="0" width="100%">
    <tr>
      <td width="66%"><b><span class="helpText">Enter the query to execute</span></b></td>
      <td width="34%">&nbsp;</td>
    </tr>
    <tr>
            <td valign="top">
              <textarea id="query" name="query" rows="6" cols="55" class="mysqlTextarea" width="60%"><%=IAMEncoder.encodeHTML(query)%></textarea>
            </td>
            <td align="left" valign="top" width="34%"> <table width="95%" height="106" border="0" cellpadding="2" cellspacing="0" class="msgBox">
                <tr>
                  <td colspan="2"><strong><span class="msgBoxHeaderTxt">Quick
                    Note:</span></strong></td>
                </tr>
                <tr>
                  <td width="7%" align="right" valign="top"><strong>*</strong></td>
                  <td width="93%" valign="top">Table names and Table column names
                    are <strong>Case sensitive</strong></td>
                </tr>
                <tr>
                  <td align="right" valign="top"><strong>*</strong></td>
                  <td valign="top">Set Row limit between 1 and 500 for select
                    queries.</td>
                </tr>
                <tr>
                  <td align="right" valign="top"><strong>*</strong></td>
                  <td valign="top">Default Row limit is set to 10.</td>
                </tr>
                <tr>
                  <td align="right" valign="top"><strong>*</strong></td>
                  <td valign="top">Delete and Drop operations are not permitted</td>
                </tr>
              </table></td>
    </tr>
    <tr valign="top">
            <td>
              <input class="btnStyle" onclick="return validateValues();" readonly type="submit" value="Execute Query">
            </td>
			<td>&nbsp;</td>
    </tr>

	<tr>
    <td colspan="2">
    <table border="0" cellpadding="0" cellspacing="0" width="100%">
<%
		if(message!=null && message.equals(""))
		{
			if((task.equalsIgnoreCase("select") ||
			   (task.substring(0,4)).equalsIgnoreCase("desc") ||
			   (task.substring(0,4)).equalsIgnoreCase("show")) &&
			    hash != null)
			{
				header = (Vector)hash.get("header");
				tabular = (Vector)hash.get("tabular");
		%>
        <tr>
			<td valign="top" align="left" height="10"></td>
		</tr>
        <tr>
          <td valign="top" align="left" class="resultsTxt">Result:</td>
        </tr>
        <tr>
          <td valign="top" align="left" height="10"></td>
        </tr>
		<tr>
        <td align="left" valign="top">
          <table width="100%" border="0" cellspacing="0" cellpadding="4" class="resultsTableBorder">
		<%
				if(header != null)
				{
					for(int i=0;i<header.size();i++)
					{
		%>
            		  <th class="resultsTableHdr" height="23"><%=(String)header.get(i)%></th>
        <%
        			}
				}
				if(tabular!=null)
				{
					for(int j=0; j<tabular.size(); j++)
					{
		%>
            <tr>
        <%
						String bgClass = "oddrow";
						if(j % 2 != 0)
							bgClass = "oddrow";

						Vector oneRow = (Vector)tabular.get(j);
						if(oneRow!=null)
							for(int k=0; k<oneRow.size(); k++)
							{
		%>
            	  				<td align="left" class="<%=bgClass%>"><%=(String)oneRow.get(k)%></td>
        <%
        					}
        %>
        	</tr>
        <%
        			}
				}
%>
            </table>
<%

			}
			else if(task.equalsIgnoreCase("insert") ||
			        task.equalsIgnoreCase("update") ||
			        task.equalsIgnoreCase("delete"))
			{
		%>
            	<tr>
            	  <td align="center" class="oddrow">Query successfully executed. <%=IAMEncoder.encodeHTML(rowsAffected)%>
            	    rows affected.<%=IAMEncoder.encodeHTML(message)%></td>
            	</tr>
        <%
            }
		}

		if(message!=null && !message.equals(""))
		{
		%>
            <tr>
              <td align="center" class="oddRow"><%=IAMEncoder.encodeHTML(message)%></td>
            </tr>
        <%
        }
        %>
          <tr><td>&nbsp;</td></tr>
          </table>
      </td>
	</tr>
   </table>
   </td>
 </tr>
</table>


</form>
</body>

