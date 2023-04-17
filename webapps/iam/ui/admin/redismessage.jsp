<%--$Id$--%>


<%@page import="com.adventnet.iam.xss.IAMEncoder"%>
<%@page import="com.adventnet.iam.internal.Util"%>
<style>
table{
	font-size: 10px;
	border-collapse:collapse;
	width:100%;
	vertical-align:middle;
}
.addbut{
	float:right;
	color:green;
}
li{
	list-style: none;
}
td{
	text-align: center;
	vertical-align: middle;
	padding:10px;
}

th{
	background: url("../images/common-bg.gif") repeat-x scroll 0 -385px transparent;
	padding-bottom:10px;
}

.hiddenuntilcustom{
	display:none;
}
</style>
<div class="maincontent">
    <div class="menucontent">
	<div class="topcontent"><div class="contitle" id="restoretitle">Redis Message Interface </div> </div> <%--No I18N--%>
	<div class="subtitle">Admin Services </div> <%--No I18N--%>
 </div>
    <div id="listdiv">
	<div id="headerdiv">&nbsp;</div>
    	<div id="overflowdiv">	
		<form name="msgform"  id="msgform" method="POST" >
		<div class="labelmain">
			<div class="labelkey"> Operation : </div> <%-- No I18N --%>
			<div class="labelvalue"><select name="template" id="TemplateChooser" onchange="bindCustomChecker(this)" class="input">
			<%for(String option:Util.getRedisMessageTemplates()){%>
				<option value="<%=IAMEncoder.encodeHTMLAttribute(option)%>"><%=IAMEncoder.encodeHTML(option.toUpperCase()) %></option>
			<%} %>
			<option value="Custom">Custom</option><%--No I18N--%>
			</select></div>
			
			<div class="labelkey"> Destination : </div> <%-- No I18N --%>
			<div class="labelvalue"><input type="text" name="dest" class="input"/></div>
			
			<div class="labelkey"> Source : </div> <%-- No I18N --%>
			<div class="labelvalue"><input type="text" name="source" id="chackserver"  class="input"/></div>
			<div class="labelkey hiddenuntilcustom"> Handler :  </div> <%-- No I18N --%>
       		<div class="labelvalue hiddenuntilcustom"><input type="text" name="handler" id="chackserver"  class="input"/></div>
			<div class="labelkey hiddenuntilcustom"> Method :  </div> <%-- No I18N --%>
       		<div class="labelvalue hiddenuntilcustom"><input type="text" name="method" id="chackserver"  class="input"/></div>
			<div class="labelkey"> Message :  </div> <%-- No I18N --%>
			<div class="labelvalue"><textarea cols="40" name="msg"></textarea></div>
       		</div>
       		
			<div class="accbtn Hbtn">
				<div class="savebtn" style="float:right;margin-right:60%;" onclick="sendRedisMessage(msgform)">
					<span class="btnlt"></span>
					<span class="btnco">Send</span> <%-- No I18N --%>
					<span class="btnrt"></span>
			</div>
		 </div>
	</form>
	</div>

	</div>    
	</div>