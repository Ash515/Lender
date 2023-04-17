<%-- $Id$ --%>
<%@page import="com.zoho.accounts.AccountsConstants"%>
<%@ include file="includes.jsp" %>
<div class="maincontent">
    <div class="menucontent">
		<div class="topcontent"><div class="contitle">Change Default ZSOID</div></div><%--No I18N--%>
		<div class="subtitle">Support Services</div><%--No I18N--%>
    </div>
    
    <div class="field-bg">
    
    	<div id="getUser">
    		<form class="zform" name="useremail" onsubmit="return getServiceOrgs(document.useremail)">
    			<div class="labelkey">Enter UserName or Email Address : </div>  <%--No I18N--%>
    			<div class="labelvalue"><input class="input" value="" name="email"></div>
    			<div class="labelkey">Select the ServiceOrg Type : </div><%--No I18N--%>
    			<div class="labelvalue">
    				<select class="select" name="serviceorgtype">
    					<option value='' >Select A Service</option><%--No I18N--%>
    					<%
    						for(AccountsConstants.ServiceOrgType type : AccountsConstants.ServiceOrgType.values() ){
    					%>
    					<option value='<%=IAMEncoder.encodeHTML(Integer.toString(type.getType())) %>' ><%= IAMEncoder.encodeHTML(type.getServiceName()) %></option>		
    					<%
    						}
    					%>
    				</select>
    			</div>
    			<div class="accbtn Hbtn">
					<div class="savebtn" onclick="getServiceOrgs(document.useremail)">
						<span class="btnlt"></span> 
						<span class="btnco">Fetch</span><%--No I18N--%>
						<span class="btnrt"></span>
					</div>
				</div>
    		</form>
    		
    	</div>
		
		
		<div id="serviceorgdetails" style="display:none">
		
		</div>
		
    
    </div>
</div>