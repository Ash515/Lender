<%-- $Id$ --%>
<%@page import="com.zoho.accounts.AccountsConstants.ServiceOrgType"%>
<%@page import="com.zoho.accounts.AccountsConstants.OrgType"%>
<%@page import="com.zoho.accounts.AccountsConstants"%>
<%@ include file="includes.jsp" %>
<div class="maincontent">
    <div class="menucontent">
		<div class="topcontent"><div class="contitle" id='appacctitle'>AppAccount Ops</div></div> <%--No I18N--%>
		<div class="subtitle">Support Services</div> <%--No I18N--%>
	</div>
    <div class="field-bg">
    
     	<div class="restorelink">
            <a href="javascript:;" id="appacc" onclick="showAppAccOption(this)"class="disablerslink">AppAccount</a> / <%--No I18N--%>
            <a href="javascript:;" id="appaccser" onclick="showAppAccOption(this)" class="activerslink">AppAccountService</a> / <%--No I18N--%>
            <a href="javascript:;" id="accmem" onclick="showAppAccOption(this)" class="activerslink">AppAccountMember</a> / <%--No I18N--%>
            <a href="javascript:;" id="accattr" onclick="showAppAccOption(this)" class="activerslink">AccountAttribute</a> / <%--No I18N--%>
            <a href="javascript:;" id="appacclic" onclick="showAppAccOption(this)" class="activerslink">AppAccountLicense</a> / <%--No I18N--%>
        </div>
    
    	<div id="appaccdiv">
    		<form name="appaccget" class="zform" onsubmit="return getAppAcc(document.appaccget);" method="post">
    			<div class="labelkey">Enter the AppAccountID</div> <%--No I18N--%>
    			<div class="labelvalue"><input type='text' name='zaaid' class='input' placeholder='ZAAID' value=''></div>
    			<div class="accbtn Hbtn">
			    	<div class="savebtn" onclick="getAppAcc(document.appaccget);">
						<span class="btnlt"></span>
						<span class="btnco">Fetch AppAccount</span> <%--No I18N--%>
						<span class="btnrt"></span>
		    		</div>
				</div>
    		</form>
    		
    		<form name='appaccop' class='zform' onsubmit='return false;' style="display:none;" method="post">
    			<div class="labelkey">AppAccount ID (ZAAID) : </div> <%--No I18N--%>
    			<div class="labelvalue"><input type='text' name='zaaid' class='input' disabled='disabled' value=''></div>
    			<div class="labelkey">AppAccount Status : </div> <%--No I18N--%>
    			<div class="labelvalue">
    			<div>
    				<input style='float:left;' type='text' name='currentstatus' class='input' disabled='disabled' value=''>
    				
    				<div id='editbtn' style='margin-left: 10px;' class="savebtn" onclick="this.style.display='none'; de('statusUpdate').style.display='block';">
						<span class="cbtnlt"></span> 
						<span class="cbtnco">Update</span><%--No I18N--%>
						<span class="cbtnrt"></span>
					</div>
					<div id="statusUpdate" style='display:none;'>
						<div id='statuscontent'></div>
						<div style='margin-left: 10px;' class="savebtn" onclick="updateAppAccountStatus(document.appaccop)">
							<span class="cbtnlt"></span> 
							<span class="cbtnco">Update</span><%--No I18N--%>
							<span class="cbtnrt"></span>
						</div>
					</div>
		    	</div>
    			</div>
    			<input type='hidden' name='zaid' value=''> 
       			<div class="accbtn Hbtn">
			    	<div class="savebtn" onclick="deleteAppAccount(document.appaccop);">
						<span class="btnlt"></span>
						<span class="btnco">Delete AppAccount</span> <%--No I18N--%>
						<span class="btnrt"></span>
		    		</div>
		    		<div class="savebtn" name='cancel' onclick="de('statusUpdate').style.display='none'; document.appaccop.reset();document.appaccop.style.display='none';document.appaccget.reset();document.appaccget.style.display='block';">
						<span class="btnlt"></span>
						<span class="btnco">Cancel</span> <%--No I18N--%>
						<span class="btnrt"></span>
	    			</div>
				</div>
    
    		</form>
    	</div>
    	
    	
    	<div id="appaccserdiv" style='display:none;'>
    		<form name="appaccserget" class="zform" onsubmit="return getAppAccSer(document.appaccserget);" method="post">
    			<div class="labelkey">Enter the AppAccountID</div> <%--No I18N--%>
    			<div class="labelvalue"><input type='text' name='zaaid' class='input' placeholder='ZAAID' value=''></div>
    			<div class="labelkey">Select the Service</div> <%--No I18N--%>
    			<div class="labelvalue">
    				<select class='select select2Div' name='subtype'>
    					<option value=''>Select The Service</option> <%--No I18N--%>
    					<% for(OrgType type : OrgType.values()) {
    						if(type == OrgType.BCOrgType || type == OrgType.DEFAULT) {
    							continue;
    						}
    					%>
    						<option value='<%=type.getType() %>'><%=type.getServiceName() %></option>
    					<% }
    					   for(ServiceOrgType type : ServiceOrgType.values()) { %>
    						<option value='<%=type.getType() %>'><%=type.getServiceName() %></option>
    					<% } %>
    				</select>
    			</div>
    			<div class="accbtn Hbtn">
			    	<div class="savebtn" onclick="getAppAccSer(document.appaccserget);">
						<span class="btnlt"></span>
						<span class="btnco">Fetch AppAccountService</span> <%--No I18N--%>
						<span class="btnrt"></span>
		    		</div>
				</div>
    		</form>
    		
    		<form name="appaccserop" class="zform" onsubmit="return updateAppAccountServiceStatus(document.appaccserget);" style="display:none;" method="post">
    			<div class="labelkey">AppAccount ID (ZAAID) : </div> <%--No I18N--%>
    			<div class="labelvalue"><input type='text' name='zaaid' class='input' disabled='disabled' value=''></div>
    			<div class="labelkey">AppAccountService Type: </div> <%--No I18N--%>
    			<div class="labelvalue"><input type='text' name='subtype' class='input' disabled="disabled" value=''></div>
    			<div class="labelkey">AppAccountService Status : </div> <%--No I18N--%>
    			<div class="labelvalue">
    				<div>
    					<input style='float:left;' type='text' name='currentstatus' class='input' disabled='disabled' value=''>
						<div id='appaccserstatuscontent'></div>
			    	</div>
				</div>
				<div class="accbtn Hbtn">
			    	<div class="savebtn" onclick="updateAppAccountServiceStatus(document.appaccserop);">
						<span class="btnlt"></span>
						<span class="btnco">Update AppAccountService</span> <%--No I18N--%>
						<span class="btnrt"></span>
		    		</div>
		    		<div class="savebtn" name='cancel' onclick="document.appaccserop.reset();document.appaccserop.style.display='none';document.appaccserget.reset();document.appaccserget.style.display='block';">
						<span class="btnlt"></span>
						<span class="btnco">Cancel</span> <%--No I18N--%>
						<span class="btnrt"></span>
	    			</div>
				</div>							
    		</form>
    	</div>


    	<div id="accmemdiv" style='display:none;'>
		
			<form name="accmemget" class="zform" onsubmit="return getAppAccountWithRoles(document.accmemget);" method="post">
    			<div class="labelkey">Enter the AppAccountID</div> <%--No I18N--%>
    			<div class="labelvalue"><input type='text' name='zaaid' class='input' placeholder='ZAAID' value=''></div>
			    <div class="labelkey">Select the Service</div> <%--No I18N--%>
    			<div class="labelvalue">
    				<select class='select select2Div' name='subtype'>
    					<option value=''>Select The Service</option> <%--No I18N--%>
    					<% for(OrgType type : OrgType.values()) {
    						if(type == OrgType.BCOrgType || type == OrgType.DEFAULT) {
    							continue;
    						}
    					%>
    						<option value='<%=type.getType() %>'><%=type.getServiceName() %></option>
    					<% }
    					   for(ServiceOrgType type : ServiceOrgType.values()) { %>
    						<option value='<%=type.getType() %>'><%=type.getServiceName() %></option>
    					<% } %>
    				</select>
    			</div>
    			<div class="accbtn Hbtn">
			    	<div class="savebtn" onclick="getAppAccountWithRoles(document.accmemget);">
						<span class="btnlt"></span>
						<span class="btnco">Fetch</span> <%--No I18N--%>
						<span class="btnrt"></span>
		    		</div>
				</div>
    		</form>
    		
    		<form name="accmemop" class="zform" onsubmit="return false" style="display:none;" method="post">
    			<div class="labelkey">AppAccount ID (ZAAID) : </div> <%--No I18N--%>
    			<div class="labelvalue"><input type='text' name='zaaid' class='input' disabled='disabled' value=''></div>
    			<div class="labelkey">AppAccountService Type: </div> <%--No I18N--%>
    			<div class="labelvalue"><input type='text' name='subtype' class='input' disabled="disabled" value=''></div>
    			<div class="labelkey">Option : </div> <%--No I18N--%>
    			<div class="labelvalue">
    				<select class='select' name='accmemoption' onchange="return openOption(this)">
    					<option value='' selected>Choose Option</option> <%--No I18N--%>
    					<option value='0'>Add Member</option> <%--No I18N--%>
    					<option value='1'>Update Member</option> <%--No I18N--%>
    					<option value='2'>Delete Member</option> <%--No I18N--%>
    				</select>
    			</div>
    			
    			<div id='accmemshow' style='display:none;'>
    			
    				<div id='accmem0' style='display:none;'>
    					<div class='labelkey'>Enter The Zuid and the Role : </div> <%--No I18N--%>
    					<div class='labelvalue' id='edipadd'>
    						<div class='edipdiv' name='accmemadd'>
    							<input type='text' class='input' name='zuid' placeholder='ZUID' value=''>
	    						<select class='select roles' style='margin-left: 10px;' name='zarid'></select>
    							<span class='addEDicon hideicon chaceicon' onclick='addElement(this,3)'>&nbsp;</span>
    						</div>
						</div>
    				</div>
    				
    				<div id='accmem1' style='display:none;'>
    					<div style="margin-left:10%"><b>ROLE</b><hr></div> <%--No I18N--%>
						<div class='labelvalue' id='edipuprole'>
							<div class='edipdiv' name='accmemuprole'>
		    					<div class='labelkey'><select class='select roles'></select></div>
		    					<textarea class='textarea' name='zuids' placeholder="Use ',' for multiple zuids"></textarea>
    							<span class='addEDicon hideicon chaceicon' id='plusroles' onclick='addElement(this,3)'>&nbsp;</span>
    						</div>
						</div>
						<div style="margin-left:10%"><b>STATUS</b><hr></div> <%--No I18N--%>
						<div class='labelvalue' id='edipupstatus'>
							<div class='edipdiv' name='accmemupstatus'>
		    					<div class='labelkey'>
		    						<select class='select'>
		    							<option value=''>Select Status</option> <%--No I18N--%>
		    							<option value='1'>Active</option> <%--No I18N--%>
		    							<option value='0'>InActive</option> <%--No I18N--%>
		    							<option value='2'>Closed</option> <%--No I18N--%>
		    						</select>
		    					</div>
		    					<textarea class='textarea' name='zuids' placeholder="Use ',' for multiple zuids"></textarea>
    							<span class='addEDicon hideicon chaceicon' onclick='addElement(this,3,2)'>&nbsp;</span>
    						</div>
						</div>
    				</div>
    			
    				<div id='accmem2' style='display:none;'>
						<div class='labelkey'>Enter The Zuids </div> <%--No I18N--%>
						<div class='labelvalue'><textarea class='textarea' name='delzuids' placeholder="Use ',' for Multiple Zuids"></textarea></div>
    				</div>
    				
    				
    			
					<div class="accbtn Hbtn">
				    	<div class="savebtn" id='accmemonclick' onclick="">
							<span class="btnlt"></span>
							<span class="btnco" id='accmemsubmit'></span> <%--No I18N--%>
							<span class="btnrt"></span>
		    			</div>
			    		<div class="savebtn" name='cancel' onclick="removeAllChildren(de('edipadd')); removeAllChildren(de('edipupstatus')); removeAllChildren(de('edipuprole')); de('accmemshow').style.display='none'; document.accmemop.reset(); document.accmemget.reset(); document.accmemop.style.display='none'; document.accmemget.style.display='block';">
							<span class="btnlt"></span>
							<span class="btnco">Cancel</span> <%--No I18N--%>
							<span class="btnrt"></span>
	    				</div>
					</div>							
    				
    			</div>			
    		</form>		
			    		
    	</div>
    	
    	
    	<div id="accattrdiv" style='display:none;'>
    		<form name="accattrget" class="zform" onsubmit="return getAccountAttribute(document.accattrget);" method="post">
    			<div class="labelkey">Enter the AppAccountID</div> <%--No I18N--%>
    			<div class="labelvalue"><input type='text' name='zaaid' class='input' placeholder='ZAAID' value=''></div>
    			<div class="labelkey">Enter the Attribute</div> <%--No I18N--%>
    			<div class="labelvalue"><input type='text' name='attribute' class='input' placeholder='Attribute Key' value=''></div>    			
    			<div class="accbtn Hbtn">
			    	<div class="savebtn" onclick="getAccountAttribute(document.accattrget);">
						<span class="btnlt"></span>
						<span class="btnco">Fetch</span> <%--No I18N--%>
						<span class="btnrt"></span>
		    		</div>
				</div>
    		</form>
    		
    		<form name="accattrop" class="zform" onsubmit="return updateAccountAttribute(document.accattrop);" style='display:none;' method="post">
    			<div class="labelkey">AppAccountID (ZAAID)</div> <%--No I18N--%>
    			<div class="labelvalue"><input type='text' name='zaaid' class='input' disabled="disabled"></div>
    			<div class="labelkey">Attribute Key</div> <%--No I18N--%>
    			<div class="labelvalue"><input type='text' name='attribute' class='input' disabled="disabled"></div>
    			<div class="labelkey">Attribute Value</div> <%--No I18N--%>
    			<div class="labelvalue"><textarea style="    border: 1px solid #BDC7D8;font-size: 13px;padding: 2px;" name='attrvalue' rows="10" cols="100" value=''></textarea></div>
    			<div class="accbtn Hbtn">
			    	<div class="savebtn" onclick="updateAccountAttribute(document.accattrop);">
						<span class="btnlt"></span>
						<span class="btnco">Update</span> <%--No I18N--%>
						<span class="btnrt"></span>
		    		</div>
		    		<div class="savebtn" name='cancel' onclick="document.accattrop.reset();document.accattrop.style.display='none';document.accattrget.reset();document.accattrget.style.display='block';">
						<span class="btnlt"></span>
						<span class="btnco">Cancel</span> <%--No I18N--%>
						<span class="btnrt"></span>
	    			</div>
		    		
				</div>
    		</form>
    		
    	</div>

    	<div id="appacclicdiv" style='display:none;'>
    		<form name="appacclicget" class="zform" onsubmit="return getAppAccountLicense(document.appacclicget);" method="post">
    			<div class="labelkey">Enter the AppAccountID</div> <%--No I18N--%>
    			<div class="labelvalue"><input type='text' name='zaaid' class='input' placeholder='ZAAID' value=''></div>
    			<div class="labelkey">Select the Service</div> <%--No I18N--%>
    			<div class="labelvalue">
    				<select class='select select2Div' name='subtype'>
    					<option value=''>Select The Service</option> <%--No I18N--%>
    					<% for(OrgType type : OrgType.values()) {
    						if(type == OrgType.BCOrgType || type == OrgType.DEFAULT) {
    							continue;
    						}
    					%>
    						<option value='<%=type.getType() %>'><%=type.getServiceName() %></option>
    					<% }
    					   for(ServiceOrgType type : ServiceOrgType.values()) { %>
    						<option value='<%=type.getType() %>'><%=type.getServiceName() %></option>
    					<% } %>
    				</select>
    			</div>
    			<div class="labelkey">Enter the License Attribute</div> <%--No I18N--%>
    			<div class="labelvalue"><input type='text' name='attribute' class='input' placeholder='Attribute Key' value=''></div>    			
    			<div class="accbtn Hbtn">
			    	<div class="savebtn" onclick="getAppAccountLicense(document.appacclicget)">
						<span class="btnlt"></span>
						<span class="btnco">Fetch</span> <%--No I18N--%>
						<span class="btnrt"></span>
		    		</div>
				</div>
    		</form>
    		
    		<form name="appacclicop" class="zform" onsubmit="return updateAppAccountLicense(document.appacclicop);" style='display:none;' method="post">
    			<div class="labelkey">AppAccountID (ZAAID)</div> <%--No I18N--%>
    			<div class="labelvalue"><input type='text' name='zaaid' class='input' disabled="disabled"></div>
    			<div class="labelkey">AppAccountService Type: </div> <%--No I18N--%>
    			<div class="labelvalue"><input type='text' name='subtype' class='input' disabled="disabled" value=''></div>
    			<div class="labelkey">License Attribute</div> <%--No I18N--%>
    			<div class="labelvalue"><input type='text' name='attribute' class='input' disabled="disabled"></div>
    			<div class="labelkey">License Value</div> <%--No I18N--%>
    			<div class="labelvalue"><textarea style="    border: 1px solid #BDC7D8;font-size: 13px;padding: 2px;" name='attrvalue' rows="10" cols="100" value=''></textarea></div>
    			<div class="accbtn Hbtn">
			    	<div class="savebtn" onclick="updateAppAccountLicense(document.appacclicop);">
						<span class="btnlt"></span>
						<span class="btnco">Update</span> <%--No I18N--%>
						<span class="btnrt"></span>
		    		</div>
		    		<div class="savebtn" name='cancel' onclick="document.appacclicop.reset();document.appacclicop.style.display='none';document.appacclicget.reset();document.appacclicget.style.display='block';">
						<span class="btnlt"></span>
						<span class="btnco">Cancel</span> <%--No I18N--%>
						<span class="btnrt"></span>
	    			</div>
		    		
				</div>
    		</form>
    	</div>
    	
    	
    </div>
</div>