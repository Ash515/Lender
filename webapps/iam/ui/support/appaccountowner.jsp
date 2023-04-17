<%-- $Id$ --%>
<%@page import="com.zoho.accounts.AccountsConstants.ServiceOrgType"%>
<%@page import="com.zoho.accounts.AccountsConstants.OrgType"%>
<%@page import="com.zoho.accounts.AccountsConstants"%>
<%@ include file="includes.jsp" %>
<div class="maincontent">
    <div class="menucontent">
		<div class="topcontent"><div class="contitle" id='appacctitle'>Change AppAccount Owner</div></div> <%--No I18N--%>
		<div class="subtitle">Support Services</div> <%--No I18N--%>
	</div>
    <div class="field-bg">
    
    	<div id="appaccowner">
    		<form name="appaccowner" class="zform" onsubmit="return updateAppAccOwner(document.appaccowner);" method="post">
    			<div class="labelkey">Enter the AppAccountID</div> <%--No I18N--%>
    			<div class="labelvalue"><input type='text' name='zaaid' class='input' placeholder='ZAAID' value=''></div>
    			<div class="labelkey">Select the Service</div> <%--No I18N--%>
    			<div class="labelvalue">
    				<select class='select select2Div' name='subtype' onchange='getRoles(document.appaccowner)'>
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
    			<div class="labelkey">Enter the ZUID</div> <%--No I18N--%>
    			<div class="labelvalue"><input type='text' name='zuid' class='input' placeholder='ZUID' value=''></div>
    			<div class="labelkey">Select the Role For Current Owner</div> <%--No I18N--%>
    			<div class="labelvalue">
    				<select class="select select2Div" name='role'>
    				</select>
    			</div>    			
    			<div class="accbtn Hbtn">
			    	<div class="savebtn" onclick="updateAppAccOwner(document.appaccowner)">
						<span class="btnlt"></span>
						<span class="btnco">Update AppAccount Owner</span> <%--No I18N--%>
						<span class="btnrt"></span>
		    		</div>
				</div>
    		</form>
    	</div>
    </div>
</div>