<%-- $Id$ --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@ include file="includes.jsp"%>
<div class="maincontent">
	<div class="menucontent">
		<div class="topcontent">
			<div class="contitle">Domain Delete</div><%--No I18N--%>
		</div>
		<div class="subtitle">Support Services</div><%--No I18N--%>
	</div>
	<%
		String domainName = request.getParameter("domainName");
		OrgDomain orgDomain = null;
		if (domainName != null) {
			orgDomain = Util.ORGAPI.getOrgDomain(domainName);
		}
	%>

	<%
		if (orgDomain == null || domainName == null) {
	%>

	<div class="field-bg">
		<div id="domaindiv">
			<form method="post" class="zform" onsubmit='return getDomain(this);' name="domaindetails">
				<div class="labelkey">Enter Domain :</div><%--No I18N--%>
				<div class="labelvalue">
					<input type="text" class="input" id="domain" name="domain" placeholder="Domain Name" value='<%=IAMEncoder.encodeHTMLAttribute(domainName != null ? domainName : "")%>'>
				</div>
				<div class="accbtn Hbtn">
					<div class="savebtn" onclick="getDomain(document.domaindetails)">
						<span class="btnlt"></span> 
						<span class="btnco">Fetch Details</span><%--No I18N--%>
						<span class="btnrt"></span>
					</div>
				</div>
			</form>
		</div>


	<%
		}
		if (orgDomain != null && domainName != null) {
	%>
	<div id="domaininfo">
		<form  method="post" class="zform" onsubmit="return false" name="deleteD">
			<div class="labelkey">Domain : </div><%--No I18N--%>
			<div class="labelvalue">
				<input type="text" class="input noborder" name="domain" value='<%= IAMEncoder.encodeHTMLAttribute(orgDomain.getDomainName()) %>'>
			</div>
			<div class="labelkey">Created By : </div><%--No I18N--%>
			<div class="labelvalue">
				<input type="text" class="input noborder" name="created" value='<%= IAMEncoder.encodeHTMLAttribute(Long.toString(Util.ORGAPI.getOrg(orgDomain.getZOID()).getOrgContact())) %>'>
			</div>
			<div class="accbtn Hbtn">
				<div class="savebtn" onclick="deleteDomain(document.deleteD)">
					<span class="btnlt"></span> 
					<span class="btnco">Delete Domain</span><%--No I18N--%>
					<span class="btnrt"></span>
				</div>
				<div class="savebtn" onclick="loadui('ui/support/domain.jsp');">
					<span class="btnlt"></span> 
					<span class="btnco">Cancel</span><%--No I18N--%>
					<span class="btnrt"></span>
				</div>
			</div>
		</form>
	</div>
	<%
		}else if(domainName!=null && orgDomain==null){
	%>
	<div class="nosuchusr">
	<p align="center">No Such Domain </p><%--No I18N--%>
	</div>
	<%
		}
	%>
	</div>
</div>