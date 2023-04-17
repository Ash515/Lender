<%-- $Id$ --%>
<%@page import="com.zoho.accounts.Accounts"%>
<%@page import="com.zoho.accounts.AccountsConstants"%>
<%@ include file="includes.jsp" %>
<div class="maincontent">
    <div class="menucontent">
		<div class="topcontent"><div class="contitle">Org Policy</div></div><%--No I18N--%>
		<div class="subtitle">Support Services</div><%--No I18N--%>
    </div>
    
    
	<div class="field-bg">
		<div id="fetchorg">
			<form name="getzoid" class="zform" onsubmit="return getOrgPolicy(this);">
				<div class="labelkey">Enter The ZOID : </div><%--No I18N--%>
				<div class="labelvalue"><input type="text" class="input" name="zoid" id="zoid" placeholder='ZOID' value=''></div>
				<div class="accbtn Hbtn">
					<div class="savebtn" onclick="getOrgPolicy(document.getzoid); initSelect2()">
						<span class="btnlt"></span> 
						<span class="btnco">Fetch Policy</span><%--No I18N--%>
						<span class="btnrt"></span>
					</div>
				</div>
			</form>
		</div>
	
		
		<div id="addNewPolicy" style="display:none;">
			<form name ="newPolicy" class="zform" onsubmit="return updateOrgPolicy(this,'add');">
				<br><br><br>
				<div class="labelmain">
				<div class="labelkey">Select New Policy Type : </div><%--No I18N--%>
				<div class="labelvalue" id="custompolicylist"></div>
				<div id="applist" style="display:none;">
					<div class="labelkey">Select The Service : </div><%--No I18N--%>
					<div class="labelvalue" id="applistitems"></div>
				</div>
				<div class="labelkey">Enter the Policy Value : </div><%--No I18N--%>
				<div class="labelvalue"><input type="text" class="input" name="policyvalue"></div>
				<div class="accbtn Hbtn" >
					<div class="savebtn" onclick="updateOrgPolicy(document.newPolicy,'add')">
						<span class="btnlt"></span> 
						<span class="btnco">Add Policy</span><%--No I18N--%>
						<span class="btnrt"></span>
					</div>
					<div class="savebtn" onclick="document.newPolicy.reset(); de('applist').style.display='none'; de('addNewPolicy').style.display='none'; de('orgpolicy').style.display='block';">
						<span class="btnlt"></span> 
						<span class="btnco">Cancel</span><%--No I18N--%>
						<span class="btnrt"></span>
					</div>
				</div>
				
				</div>
			</form>
		</div>
							
		<div id="orgpolicy" style="display : none;">
			<div class="Hcbtn topbtn" id="addNewPolicyButton">
	    		<div class="addnew" onclick="	de('addNewPolicy').style.display='block'; de('orgpolicy').style.display='none'; document.updatePolicy.reset();">
					<span class="cbtnlt"></span>
					<span class="cbtnco">Add New</span> <%--No I18N--%>
					<span class="cbtnrt"></span>
	    		</div>
			</div><br>
			<form name ="updatePolicy" class="zform" onsubmit="return false;">
			<table class="orgpolicy_details" cellpadding="4" border="1" width="100%">
				<tr>
					<td class="usrinfoheader">Policy Name</td> <%--No I18N--%>
					<td class="usrinfoheader">Applied Value</td> <%--No I18N--%>
					<td class="usrinfoheader">New Value</td> <%--No I18N--%>
					<td class="usrinfoheader" id="actions">Actions</td> <%--No I18N--%>
				</tr>
				<tr>
					<td id="policyMap"></td>
					<td id="appliedValue"></td>
					<td id="newValue"></td>
					<td id="actions">
							<div class="savebtn" onclick="updateOrgPolicy(document.updatePolicy,'update')">
								<span class="cbtnlt"></span> 
								<span class="cbtnco">Update</span><%--No I18N--%>
								<span class="cbtnrt"></span>
							</div>
							<div class="savebtn" onclick="updateOrgPolicy(document.updatePolicy,'delete')">
								<span class="cbtnlt"></span> 
								<span class="cbtnco">Delete</span><%--No I18N--%>
								<span class="cbtnrt"></span>
							</div>
					</td>
				</tr>
			</table>
			</form>
		</div>
				
	</div>
</div>