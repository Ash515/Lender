<%-- $Id$ --%>
<%@ page import = "com.adventnet.authentication.lm.*, java.util.Properties,com.adventnet.persistence.*,com.adventnet.authentication.*"%>
<script>
function updatePB(count, total){
	var reqPer = (100 * (count+1)) / total;
	document.getElementById("pb").style.width = reqPer + "%";
	document.getElementById('status').innerHTML = (count + 1 )+ "/" + total;
}
</script>
<%
ADUtil util = ADUtil.getInstance();
String[] users = util.getADUsers("wesat-w2kads1","wesat-sym","administrator","vembu");
ADHandler adh = new ADHandler();
%>
<table width="75%">
	<tr>
		<td width="75%">
			<table id="pb"><tr><td bgcolor="green"></td></tr></table>
		</td>
		<td id='status'>0/<%out.print(users.length);//NO OUTPUTENCODING%></td><%--NO OUTPUTENCODING --%>
	</tr>
</table>
<div id="count"></div>
<%
out.flush();
for(int i=0; i<users.length;i++){
%>
<script>
document.getElementById("count").innerHTML = document.getElementById("count").innerHTML + "<br>Importing User .... <%out.print(users[i]);//NO OUTPUTENCODING%>";updatePB(<%out.print(i);//NO OUTPUTENCODING%>,<%out.print(users.length);//NO OUTPUTENCODING%>);</script><%--NO OUTPUTENCODING --%>
<%
Thread.sleep(100);
out.flush();
}
%>

