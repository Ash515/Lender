<%-- $Id$ --%>
<%@page import="com.zoho.accounts.AccountsProto.Account.AuthDomain.AuthorizedIp"%>
<%@ include file="includes.jsp" %>
<div class="maincontent">
    <div class="menucontent">
	<div class="topcontent"><div class="contitle">Reset IPs</div></div>
	<div class="subtitle">Admin Services</div>
    </div>

    <div class="field-bg">
	<input type="hidden" id="ips_user" value='<%=IAMEncoder.encodeHTMLAttribute(request.getParameter("user"))%>'/>
<%
    if(request.getParameter("user") != null) {
	String username = request.getParameter("user");
	long zoid = -1;
	UserEmail ue = null;

	try { zoid = Long.parseLong(username); }
	catch (Exception e) { ue = Util.USERAPI.getEmail(username); }
%>
	<div class="Hcbtn topbtn">
	    <div class="addnew" onclick="loadui('/ui/admin/reset_ips.jsp')">
		<span class="cbtnlt"></span>
		<span class="cbtnco">Bach to Search</span>
		<span class="cbtnrt"></span>
	    </div>
	</div>
<%
	if(ue != null && zoid == -1) {
	    List<IPRange> ipRange = Util.USERAPI.getAllowedIPRanges(ue.getZUID());
	    if(ipRange!=null) {
%>
	<div class="ipstitle"><%=IAMEncoder.encodeHTML(username)%>'s configure IPAddress</div> <%--No I18N--%>
	<div class="apikeyheader" id="headerdiv">
	    <div class="apikeytitle" style="width:35%;">From IP</div> <%--No I18N--%>
	    <div class="apikeytitle" style="width:35%;">To IP</div> <%--No I18N--%>
	    <div class="apikeytitle" style="width:10%;">Action</div>
	</div>
	<div id="overflowdiv" class="content1">
<%
		for (IPRange ipr : ipRange) {
%>
	<div class="apikeycontent">
	    <div class="apikey" style="width:35%;"><%=IAMEncoder.encodeHTML(ipr.getFromIPAsString())%></div>
	    <div class="apikey" style="width:35%;"><%=ipr.getToIPAsString()==null ? "&nbsp" : IAMEncoder.encodeHTML(ipr.getToIPAsString())%></div>
	    <div class="apikey" style="width:10%;padding-left:14px;">
		<div class="Hbtn" style="margin-top:-2px;">
		    <div class="savebtn" onclick="deleteIPs('<%=ue.getZUID()%>','<%=ipr.getFromIP()%>','<%=ipr.getToIP()%>','<%=IAMEncoder.encodeJavaScript(username)%>')"> <%-- NO OUTPUTENCODING --%>
			<span class="cbtnlt"></span>
			<span class="cbtnco">Delete</span>
			<span class="cbtnrt"></span>
		    </div>
		</div>
	    </div>
	    <div class="clrboth"></div>
	</div>
<%
		}
		out.println("</div>");
	    }
	    else {
%>
	<div class="emptyobjmain">
	    <dl class="emptyobjdl">
		<dd><p align="center" class="emptyobjdet">No IPRange(s) configured for this user</p></dd>
	    </dl>
	</div>
<%
	    }
	}
	else if(ue == null && zoid == -1) {
%>
	<div class="emptyobjmain">
	    <dl class="emptyobjdl">
		<dd><p align="center" class="emptyobjdet">Invalid user found</p></dd>
	    </dl>
	</div>
<%
	}
	else if(ue == null && zoid != -1) {
	    Org org = Util.ORGAPI.getOrg(zoid);
	    List<AuthorizedIp> orgIpRanges = null;
	    if(org == null) {
%>
	<div class="emptyobjmain">
	    <dl class="emptyobjdl"> <%--No I18N--%>
		<dd><p align="center" class="emptyobjdet">No such Org for Id of <%=IAMEncoder.encodeHTML(username)%>.</p></dd> <%--No I18N--%>
	    </dl> <%--No I18N--%>
	</div>
<%
	    }
	    else if(org != null && (orgIpRanges = Util.authDomainAPI.getAllAuthorizedIPsOfOrg(zoid,Util.getIAMServiceName()))!= null) {
%>
	<div class="ipstitle"><%=IAMEncoder.encodeHTML(org.getDisplayName())%>'s configure IPAddress</div> <%--No I18N--%>
	<div class="apikeyheader" id="headerdiv">
	    <div class="apikeytitle" style="width:14%;">Role</div> <%--No I18N--%>
	    <div class="apikeytitle" style="width:14%;">IPID</div> <%--No I18N--%>
	    <div class="apikeytitle" style="width:25%;">From IP</div> <%--No I18N--%>
	    <div class="apikeytitle" style="width:25%;">To IP</div> <%--No I18N--%>
	    <div class="apikeytitle" style="width:10%;">Action</div> <%--No I18N--%>
	</div>
	<div id="overflowdiv" class="content1">
<%
		for(AuthorizedIp orgIpRange : orgIpRanges) {
		    if(orgIpRange != null){
			    String roleName = orgIpRange.getParent().getDomainName(); %>
	
	    <div class="apikeycontent">
	    <div class="apikey" style="width:14%;"><%=IAMEncoder.encodeHTML(roleName)%></div>
	    <div class="apikey" style="width:14%;"><%=orgIpRange.getIpid()%></div> <%-- NO OUTPUTENCODING --%>
	    <div class="apikey" style="width:25%;"><%=IAMEncoder.encodeHTML(orgIpRange.getFromIp())%></div>
	    <div class="apikey" style="width:25%;"><%=orgIpRange.getToIp()==null ? "&nbsp" : IAMEncoder.encodeHTML(orgIpRange.getToIp())%></div>
	    <div class="apikey" style="width:10%;padding-left:14px;">
		<div class="Hbtn" style="margin-top:-2px;">
		    <div class="savebtn" onclick="deleteOrgIPs('<%=orgIpRange.getParent().getZaid()%>','<%=roleName%>','<%=orgIpRange.getFromIp()%>', '<%=orgIpRange.getToIp()%>')"> <%-- NO OUTPUTENCODING --%>
			<span class="cbtnlt"></span>
			<span class="cbtnco">Delete</span> <%--No I18N--%>
			<span class="cbtnrt"></span>
		    </div>
		</div>
	    </div>
	    <div class="clrboth"></div>
	</div>
<%
		    }
		}
		out.println("</div>");
	    }
	    else {
%>
	<div class="emptyobjmain">
	    <dl class="emptyobjdl"> <%--No I18N--%>
		<dd><p align="center" class="emptyobjdet">No IPRange(s) configured for this OrgId</p></dd> <%--No I18N--%>
	    </dl> <%--No I18N--%>
	</div>
<%
	    }
	}
    }
    else {
%>
	<form name="resetips" id="resetips" class="zform" onsubmit="return getIPRange(this);" method="post">
	    <div class="labelmain">
		<div class="labelkey">Enter UserName or Email Address or OrgId :</div> <%--No I18N--%>
		<div class="labelvalue"><input type="text" name="user" id="user" class="input"/></div>
		<div class="accbtn Hbtn">
		    <div class="savebtn" onclick="getIPRange(document.resetips)">
			<span class="btnlt"></span>
			<span class="btnco">Get IPs</span>
			<span class="btnrt"></span>
		    </div>
		    <div onclick="loadservice();">
			<span class="btnlt"></span>
			<span class="btnco">Cancel</span>
			<span class="btnrt"></span>
		    </div>
		</div>
		<input type="submit" class="hidesubmit" />
	    </div>
	</form>
<%
    }
%>
    </div>
</div>
