<%-- $Id$ --%>
<%@ include file="includes.jsp" %>
<div class="maincontent">
    <div class="menucontent">
		<div class="topcontent"><div class="contitle">External Users</div></div><%--No I18N--%>
		<div class="subtitle">Support Services</div><%--No I18N--%>
    </div>
    
    <div class="field-bg">
    	<div id="getZaaidDiv">
    		<form name="getZaaid" class="zform" onsubmit="return getExternalUsers(document.getZaaid);" method="post">
   				<div class="labelkey">Enter Zoho One OrgID : </div><%--No I18N--%>
   				<div class="labelvalue"><input type="text" class="input" name="zaaid" placeholder="ZOneOrgID(ZohoDirectoryZaaid)" value=''></div>
	   			<div class="accbtn Hbtn">
			    	<div class="savebtn" onclick="getExternalUsers(document.getZaaid)">
						<span class="btnlt"></span>
						<span class="btnco">Fetch Users</span> <%--No I18N--%>
						<span class="btnrt"></span>
		    		</div>
				</div>
   			</form>
    	</div>
   	
   		<div id="externalUsersDiv" style="display:none;">
   		<form name='externalusers' class='zform' onsubmit='return removeAllUsers(this)' method='post'>
   			<div class='labelValue' id='externalList'></div>
   			<div class="accbtn Hbtn">
			  	<div class="savebtn" onclick="removeAllUsers(document.getZaaid)">
					<span class="btnlt"></span>
					<span class="btnco">Clear All</span> <%--No I18N--%>
					<span class="btnrt"></span>
		    	</div>
			</div>
   		</form>
 		</div>
   		<div id="nouser" class="nosuchusr" style="display:none;">
        	<p align="center">No such ZohoOne Org</p> <%--No I18N--%>
		</div>	
    </div>
</div>