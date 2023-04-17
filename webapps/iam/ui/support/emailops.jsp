<%-- $Id$ --%>
<%@ include file="includes.jsp" %>
<div class="maincontent">
    <div class="menucontent">
		<div class="topcontent"><div class="contitle">Email Operations</div></div> <%--No I18N--%>
		<div class="subtitle">Support Services</div> <%--No I18N--%>
    </div>
    
    <div class="field-bg">
    	<div id="getEmailsDiv">
    		<form name="getEmails" class="zform" onsubmit="return getUserEmails(document.getEmails);" method="post">
   				<div class="labelkey">Enter UserName or Email Address : </div><%--No I18N--%>
   				<div class="labelvalue"><input type="text" class="input" name="email" value='' placeholder='EmailAddress/UserName'></div>
	   			<div class="accbtn Hbtn">
			    	<div class="savebtn" onclick="getUserEmails(document.getEmails)">
						<span class="btnlt"></span>
						<span class="btnco">Fetch Emails</span> <%--No I18N--%>
						<span class="btnrt"></span>
		    		</div>
				</div>
   			</form>
    	</div>
   	
   		<div id="emailListDiv" style="display:none;">
 		</div>
   		<div id="nouser" class="nosuchusr" style="display:none;">
        	<p align="center">No such User</p> <%--No I18N--%>
		</div>	
    </div>
</div>