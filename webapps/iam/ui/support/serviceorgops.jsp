<%-- $Id$ --%>
<%@page import="com.zoho.accounts.AccountsConstants.ServiceOrgType"%>
<%@page import="com.zoho.accounts.AccountsConstants"%>
<%@ include file="includes.jsp" %>
<div class="maincontent">
    <div class="menucontent">
		<div class="topcontent"><div class="contitle" id='appacctitle'>ServiceOrg Ops</div></div> <%--No I18N--%>
		<div class="subtitle">Support Services</div> <%--No I18N--%>
	</div>
    <div class="field-bg">
    
     	<div class="restorelink">
            <a href="javascript:;" id="sorg" onclick="showSorgOption(this)"class="disablerslink">ServiceOrg</a> / <%--No I18N--%>
            <a href="javascript:;" id="sorgsub" onclick="showSorgOption(this)" class="activerslink">ServiceOrgSubService</a> / <%--No I18N--%>
            <a href="javascript:;" id="sorgmem" onclick="showSorgOption(this)" class="activerslink">ServiceOrgMember</a> <%--No I18N--%>
        </div>
        
        <div id="sorgdiv">
        	<form name="sorgget" class="zform" onsubmit="return getServiceOrg(document.sorgget);" method="post">
    			<div class="labelkey">Select ServiceOrg Type</div> <%--No I18N--%>
    			<div class="labelvalue">
    				<select class="select select2Div" name='type'>
    					<option value=''>Select ServiceOrgType</option> <%--No I18N--%>
    				<% for(ServiceOrgType type : ServiceOrgType.values()) { %>
    					<option value='<%=type.getType() %>'><%=type.getServiceName() %></option>
    				<%}%>
    				</select>
    			</div>
    			<div class="labelkey">Enter the ServiceOrg Id</div> <%--No I18N--%>
    			<div class="labelvalue"><input type='text' name='zsoid' class='input' placeholder='ZSOID' value=''></div>
    			<div class="accbtn Hbtn">
			    	<div class="savebtn" onclick="getServiceOrg(document.sorgget);">
						<span class="btnlt"></span>
						<span class="btnco">Fetch ServiceOrg</span> <%--No I18N--%>
						<span class="btnrt"></span>
		    		</div>
				</div>
    		</form>
    		
    		<form name='sorgop' class='zform' onsubmit='return false;' style='display:none;' method="post">
    			<div class="labelkey">ServiceOrgType : </div> <%--No I18N--%>
    			<div class="labelvalue"><input type='text' name='type' class='input' disabled='disabled' value=''></div>
    			<div class="labelkey">ServiceOrg ID (ZSOID) : </div> <%--No I18N--%>
    			<div class="labelvalue"><input type='text' name='zsoid' class='input' disabled='disabled' value=''></div>
    			<div class="labelkey">Org Name : </div> <%--No I18N--%>
    			<div class="labelvalue"><input type='text' name='orgname' class='input' value=''></div>
    			
    			<div class="accbtn Hbtn">
			    	<div class="savebtn" onclick="updateServiceOrg(document.sorgop);">
						<span class="btnlt"></span>
						<span class="btnco">Update ServiceOrg</span> <%--No I18N--%>
						<span class="btnrt"></span>
		    		</div>
		    		<div class="savebtn" name='cancel' onclick="document.sorgop.reset();document.sorgop.style.display='none';document.sorgget.reset();document.sorgget.style.display='block'; initSelect2();">
						<span class="btnlt"></span>
						<span class="btnco">Cancel</span> <%--No I18N--%>
						<span class="btnrt"></span>
	    			</div>
				</div>
    
    		</form>
        </div>
        
        
        <div id="sorgsubdiv" style='display:none;'>
        	<form name="sorgsubget" class="zform" onsubmit="return getServiceOrgSubService(document.sorgsubget);" method="post">
    			<div class="labelkey">Select ServiceOrg Type</div> <%--No I18N--%>
    			<div class="labelvalue">
    				<select class="select select2Div" name='type' onchange='getChildOrgTypes(document.sorgsubget)'>
    					<option value=''>Select ServiceOrgType</option> <%--No I18N--%>
    				<% for(ServiceOrgType type : ServiceOrgType.values()) { %>
    					<option value='<%=type.getType() %>'><%=type.getServiceName() %></option>
    				<%}%>
    				</select>
    			</div>
    			<div class="labelkey">Enter the ServiceOrg Id</div> <%--No I18N--%>
    			<div class="labelvalue"><input type='text' name='zsoid' class='input' placeholder='ZSOID' value=''></div>
    			<div class="labelkey">Select SubServiceOrg Type</div> <%--No I18N--%>
    			<div class="labelvalue">
    				<select class="select select2Div" name='subtype'>
    				</select>
    			</div>
    			<div class="accbtn Hbtn">
			    	<div class="savebtn" onclick="getServiceOrgSubService(document.sorgsubget);">
						<span class="btnlt"></span>
						<span class="btnco">Fetch ServiceOrg</span> <%--No I18N--%>
						<span class="btnrt"></span>
		    		</div>
				</div>
    		</form>
    		
    		<form name='sorgsubop' class='zform' onsubmit='return false;' style='display:none;' method="post">
    			<div class="labelkey">ServiceOrgType : </div> <%--No I18N--%>
    			<div class="labelvalue"><input type='text' name='type' class='input' disabled='disabled' value=''></div>
    			<div class="labelkey">ServiceOrg ID (ZSOID) : </div> <%--No I18N--%>
    			<div class="labelvalue"><input type='text' name='zsoid' class='input' disabled='disabled' value=''></div>
    			<div class="labelkey">SubServiceOrgType : </div> <%--No I18N--%>
    			<div class="labelvalue"><input type='text' name='subtype' class='input' disabled='disabled' value=''></div>
    			<div class="labelkey">Account Status : </div> <%--No I18N--%>
    			<div class="labelvalue"><input type='text' name='status' class='input' value=''></div>
    			<div class="labelkey">ZUID : </div> <%--No I18N--%>
    			<div class="labelvalue"><input type='text' name='zuid' class='input' value=''></div>
    			
    			<div class="accbtn Hbtn">
			    	<div id='sorgsubupbutton' class="savebtn" onclick="updateServiceOrgSubService(document.sorgsubop);">
						<span class="btnlt"></span>
						<span class="btnco">Update SubService</span> <%--No I18N--%>
						<span class="btnrt"></span>
		    		</div>
		    		<div class="savebtn" name='cancel' onclick="document.sorgsubop.reset();document.sorgsubop.style.display='none';document.sorgsubget.reset();document.sorgsubget.style.display='block';initSelect2();">
						<span class="btnlt"></span>
						<span class="btnco">Cancel</span> <%--No I18N--%>
						<span class="btnrt"></span>
	    			</div>
				</div>
    
    		</form>
    		
        </div>
        
        
        <div id="sorgmemdiv" style='display:none;'>
        	<form name="sorgmemop" class="zform" onsubmit="return updateServiceOrgMember(document.sorgmemop);" method="post">
    			<div class="labelkey">Select ServiceOrg Type</div> <%--No I18N--%>
    			<div class="labelvalue">
    				<select class="select select2Div" name='type'>
    					<option value=''>Select ServiceOrgType</option> <%--No I18N--%>
    				<% for(ServiceOrgType type : ServiceOrgType.values()) { %>
    					<option value='<%=type.getType() %>'><%=type.getServiceName() %></option>
    				<%}%>
    				</select>
    			</div>
    			<div class="labelkey">Enter the ServiceOrg Id</div> <%--No I18N--%>
    			<div class="labelvalue"><input type='text' name='zsoid' class='input' placeholder='ZSOID' value=''></div>
    			<div class='labelkey'>Action</div> <%--No I18N--%>
    			<div class='labelvalue'>
    				<select class='select' name='action' onchange='chooseAction(this.value)'>
    					<option value=''>Choose Action</option> <%--No I18N--%>
    					<option value='add'>Add Member</option> <%--No I18N--%>
    					<option value='update'>Update Member</option> <%--No I18N--%>
    					<option value='delete'>Delete Member</option> <%--No I18N--%>
    				</select>
    			</div>
    			
    			<div id='sorgmemact' style='display:none;'>
    				
    				<div id='sorgmemadd' style='display:none;'>
    					<div class='labelkey'>Enter The Zuid and the Role : </div> <%--No I18N--%>
    					<div class='labelvalue' id='edipadd'>
    						<div class='edipdiv' name='sorgmemadd'>
    							<input type='text' class='input' name='zuid' placeholder='ZUID' value=''>
	    						<select class='select' style='margin-left: 10px;' name='role'>
	    							<option value=''>Choose Role</option>  <%--No I18N--%>
	    							<option value='0'>User</option> <%--No I18N--%>
	    							<option value='1'>Admin</option> <%--No I18N--%>
	    							<option value='2'>Super Admin</option> <%--No I18N--%>
	    						</select>
    							<span class='addEDicon hideicon chaceicon' onclick='addElement(this,3)'>&nbsp;</span>
    						</div>
						</div>
    				</div>
    				
    				<div id='sorgmemupdate' style='display:none;'>
    					
    					<div style="margin-left:10%"><b>ROLE</b><hr></div> <%--No I18N--%>
						<div class='labelvalue' id='edipuprole'>
							<div class='edipdiv' name='sorgmemuprole'>
		    					<div class='labelkey'>
		    						<select class='select'>
		    							<option value=''>Select Role</option> <%--No I18N--%>
		    							<option value='10'>User</option> <%--No I18N--%>
		    							<option value='11'>Admin</option> <%--No I18N--%>
		    							<option value='12'>Super Admin</option> <%--No I18N--%>
		    						</select>
		    					</div>
		    					<textarea class='textarea' name='zuids' placeholder="Use ',' for multiple zuids"></textarea>
    							<span class='addEDicon hideicon chaceicon' id='plusroles' onclick='addElement(this,3,3)'>&nbsp;</span>
    						</div>
						</div>
						<div style="margin-left:10%"><b>STATUS</b><hr></div> <%--No I18N--%>
						<div class='labelvalue' id='edipupstatus'>
							<div class='edipdiv' name='sorgmemupstatus'>
		    					<div class='labelkey'>
		    						<select class='select'>
		    							<option value=''>Select Status</option> <%--No I18N--%>
		    							<option value='1'>Active</option> <%--No I18N--%>
		    							<option value='0'>InActive</option> <%--No I18N--%>
		    						</select>
		    					</div>
		    					<textarea class='textarea' name='zuids' placeholder="Use ',' for multiple zuids"></textarea>
    							<span class='addEDicon hideicon chaceicon' onclick='addElement(this,3,2)'>&nbsp;</span>
    						</div>
						</div>
    					
    				</div>
    				
    				<div id='sorgmemdelete' style='display:none;'>
    					<div class='labelkey'>Enter The Zuids </div> <%--No I18N--%>
						<div class='labelvalue'><textarea class='textarea' name='delzuids' placeholder="Use ',' for Multiple Zuids"></textarea></div>
    				</div>
    				
	    			<div class="accbtn Hbtn">
				    	<div class="savebtn" onclick="updateServiceOrgMember(document.sorgmemop);">
							<span class="btnlt"></span>
							<span id='memberbtn' class="btnco">Update Member</span> <%--No I18N--%>
							<span class="btnrt"></span>
			    		</div>
			    		
			    		<div class="savebtn" name='cancel' onclick="chooseAction('');document.sorgmemop.reset();initSelect2();">
							<span class="btnlt"></span>
							<span class="btnco">Cancel</span> <%--No I18N--%>
							<span class="btnrt"></span>
	    				</div>
					</div>

    			</div>
    			
    		</form>
        
        </div>
                 
    </div>
</div>