<%-- $Id$ --%>
<%@ include file="../../static/includes.jspf" %>
<%@ include file="includes.jsp"%>
<%@ page import="com.adventnet.iam.internal.EnterpriseUtil" %>
<div class="maincontent">
    <div class="menucontent">
        <div class="topcontent"><div class="contitle">Enterprises</div></div>
	<div class="subtitle">Enterprise is a customer who is hosting our Zoho service with their domain.</div>
    </div>
    <div class="field-bg">
        <%if("add".equals(request.getParameter("action"))) {    %>
        <form name="addEtrDomain" class="zform" method="POST" onsubmit="return createEtrDomain(this, true)">
            <table class="addEDtbl" cellspacing="4" cellpadding="0">
                <tr>
                    <td class="addEDtbltd">Domain Name :</td>
                    <td><input type="text" name="domain" class="input"/></td>
                </tr>
                <tr>
                    <td class="addEDtbltd">Owner Email Address :</td>
                    <td><input type="text" name="email" class="input"/></td>
                </tr>
                <tr>
                    <td class="addEDtbltd">Internal :</td>
                    <td>
                    	<select class="select" name="type">
                        	<option value="<%=EnterpriseDomain.SSO%>" selected>SSO</option><%-- NO OUTPUTENCODING --%> <%-- No I18N --%>
                        	<option value="<%=EnterpriseDomain.SSOP%>">SSOP</option><%-- NO OUTPUTENCODING --%> <%-- No I18N --%>
                        	<option value="<%=EnterpriseDomain.PARTNER_SSO%>">Partner SSO (Airtel Africa)</option><%-- NO OUTPUTENCODING --%> <%-- No I18N --%>
                        	<option value="<%=EnterpriseDomain.PARTNER_USER%>">Partner SSO (LiveDesk Integ)</option><%-- NO OUTPUTENCODING --%> <%-- No I18N --%>
                        	<option value="<%=EnterpriseDomain.ZOHO_API%>">Zoho Reseller (Payments)</option><%-- NO OUTPUTENCODING --%> <%-- No I18N --%>
                    	</select>
                    </td>
                </tr>
                <tr>
                    <td class="addEDtbltd">Service Name :</td>	<%-- No I18N --%>
                    <td>
                    	<select name="serviceName" class="select" id="servicehtml5">
                    		<option value="select">----select----</option><%--No I18N--%>
							<%for(Service s: ss) { %><option value='<%=IAMEncoder.encodeHTMLAttribute(s.getServiceName())%>'><%=IAMEncoder.encodeHTML(s.getServiceName())%></option><% } %>
						</select>
                    </td>
                </tr>
                <tr>
                    <td class="addEDtbltd">Allowed IP(s) :</td>
                    <td id="etripstd">
                        <div class="edipdiv">
                            <input type="text" class="input disableEDtxt" value="From IPAddress" onfocus="clearETRIPtxt(this, true, true)" onblur="clearETRIPtxt(this, true, false)"/><span>&nbsp;</span>
                            <input type="text" class="input disableEDtxt" value="To IPAddress" onfocus="clearETRIPtxt(this, false, true)" onblur="clearETRIPtxt(this, false, false)"/>
                            <span class="addEDicon" onclick="addEDIcon(this)">&nbsp;</span>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td class="addEDtbltd">&nbsp;</td>
                    <td>
                        <div class="savebtn" onclick="createEtrDomain(document.addEtrDomain, true)">
                            <span class="btnlt"></span>
                            <span class="btnco">Create</span>
                            <span class="btnrt"></span>
                        </div>
                        <div onclick="loadui('/ui/admin/enterprise.jsp?action=list')" class="fllt">
                            <span class="btnlt"></span>
                            <span class="btnco">Cancel</span>
                            <span class="btnrt"></span>
                        </div>
                        <input type="submit" class="hidesubmit" />
                    </td>
                </tr>
            </table>
        </form>
        <%
         }
         else if("list".equals(request.getParameter("action"))) {   //No I18N
        %>
        <div class="topbtn Hcbtn">
	    <div class="addnew" onclick="loadui('/ui/admin/enterprise.jsp?action=add')">
		<span class="cbtnlt"></span>
		<span class="cbtnco">Add New</span>
		<span class="cbtnrt"></span>
	    </div>
	</div>
        <%
            List<EnterpriseDomain> etrpriseList = EnterpriseUtil.getAllEnterpriseDomains();
            if(etrpriseList != null && !etrpriseList.isEmpty()) {
        %>
        <table class="usremailtbl" cellpadding="4">
            <tr>
                <td class="edheader">API Key</td>
                <td class="edheader">Domain Name</td>
                <td class="edheader">Owner Email</td>
                <td class="edheader">Internal</td>
                <td class="edheader">Status</td>
                <td class="edheader">Action</td>
            </tr>
            <%
            for(EnterpriseDomain etrDomain : etrpriseList) {
                UserEmail owner = Util.USERAPI.getPrimaryEmail(etrDomain.getOwnerZUID());
                String ownerEmail = owner != null ? owner.getEmailId() : "Not Available";
                String typeStr = etrDomain.getEDType() == EnterpriseDomain.SSO ? "SSO" : etrDomain.getEDType() == EnterpriseDomain.SSOP ? "SSOP" : etrDomain.getEDType() == EnterpriseDomain.PARTNER_SSO ? "Partner SSO (Airtel Africa)" : etrDomain.getEDType() == EnterpriseDomain.PARTNER_USER ? "Partner SSO (LiveDesk Integ)" : etrDomain.getEDType() == EnterpriseDomain.ZOHO_API ? "Zoho Reseller" : etrDomain.getEDType()+""; //No I18N
                
            %>
            <tr>
                <td class="iptbltd"><%=IAMEncoder.encodeHTML(etrDomain.getApiKey())%></td>
		<td class="iptbltd"><%=IAMEncoder.encodeHTML(etrDomain.getDomainName())%></td>
		<td class="iptbltd"><%=IAMEncoder.encodeHTML(ownerEmail)%></td>
                <td class="iptbltd"><%=IAMEncoder.encodeHTML(typeStr)%></td>
                <td class="iptbltd"><%=etrDomain.isActive() ? "Enabled" : "Disabled"%></td>
                <td class="iptbltd">
		    <span class="editicon edediticon" title="Edit" onclick="loadui('/ui/admin/enterprise.jsp?action=view&domain=<%=IAMEncoder.encodeJavaScript(etrDomain.getDomainName())%>')">&nbsp;</span>
		    <span class="deleteicon eddlticon" title="Delete" onclick="deleteED('<%=IAMEncoder.encodeJavaScript(etrDomain.getDomainName())%>')">&nbsp;</span>
                </td>
            </tr>
            <%}%>
        </table>
        <%
            } else {
        %>
        <div class="emptyobjmain">
	    <dl class="emptyobjdl"><dd><p align="center" class="emptyobjdet">No EnterpriseDomain(s) added</p></dd></dl>
	</div>
        <%
            }
         }
         else if("view".equals(request.getParameter("action"))) {
            String domain = request.getParameter("domain");
            EnterpriseDomain etrDomain = null;
            if(IAMUtil.isValid(domain) && IAMUtil.isValidDomainName(domain)) {
                etrDomain = EnterpriseUtil.getEnterpriseDomain(domain);
            }
            if(etrDomain != null) {
                UserEmail owner = Util.USERAPI.getPrimaryEmail(etrDomain.getOwnerZUID());
                String ownerEmail = owner != null ? owner.getEmailId() : "Null";
                String typeStr = etrDomain.getEDType() == EnterpriseDomain.SSO ? "SSO" : etrDomain.getEDType() == EnterpriseDomain.SSOP ? "SSOP" : etrDomain.getEDType() == EnterpriseDomain.PARTNER_SSO ? "Partner SSO (Airtel Africa)" : etrDomain.getEDType() == EnterpriseDomain.PARTNER_USER ? "Partner SSO (LiveDesk Integ)" : etrDomain.getEDType() == EnterpriseDomain.ZOHO_API ? "Zoho Reseller" : etrDomain.getEDType()+""; //No I18N
        %>
        <table class="etrdomaintbl" cellpadding="4" id="editEDtbl">
            <tr>
                <td class="etrdomainHeader">EnterpriseDomain Details</td>
                <td class="etrdomainHeader editetrlink" align="right">
                    <a href="javascript:;" onclick="updateEDF('show')">Edit Details</a>&emsp;
                    <a href="javascript:;" onclick="loadui('/ui/admin/enterprise.jsp?action=list')">&laquo; Back to List</a>
                </td>
            </tr>
            <tr>
                <td class="iptbltd">Api Key</td>
                <td class="iptbltd"><%=IAMEncoder.encodeHTML(etrDomain.getApiKey())%></td>
            </tr>
            <tr>
                <td class="iptbltd">Domain Name</td>
		<td class="iptbltd"><%=IAMEncoder.encodeHTML(etrDomain.getDomainName())%></td>
            </tr>
            <tr>
                <td class="iptbltd">Owner Email Address</td>
		<td class="iptbltd"><%=IAMEncoder.encodeHTML(ownerEmail)%></td>
            </tr>
            <tr>
                <td class="iptbltd">IPID</td>
                <td class="iptbltd"><%=etrDomain.getIPID()%></td> <%-- NO OUTPUTENCODING --%>
            </tr>
            <tr>
                <td class="iptbltd">Internal</td>
                <td class="iptbltd"><%=IAMEncoder.encodeHTML(typeStr)%></td>
            </tr>
            <tr>
                <td class="iptbltd">Status</td>
                <td class="iptbltd"><%=etrDomain.isActive() ? "Enabled" : "Disabled"%></td>
            </tr>
            <tr>
                <td class="iptbltd">Allowed IP(s)</td>
<%
                List<IPRange> ipRangeList = etrDomain.getIPRangeList();
                if(ipRangeList != null && !ipRangeList.isEmpty()) {
%>
                <td class="iptbltd">
                    <table class="ediptbl" cellspacing="0" cellpadding="0">
                        <tr><th>From IPAddress</th><th>To IPAddress</th></tr>
<%
                    for(IPRange ipRange : ipRangeList) {
			out.println("<tr><td>"+IAMEncoder.encodeHTML(ipRange.getFromIPAsString())+ "</td><td>" +IAMEncoder.encodeHTML(ipRange.getToIPAsString())+"</td></tr>");
                    }
%>
                    </table>
                </td>
<%
                } else {
                    out.println("<td class=\"iptbltd\">Not Configured</td>");
                }
                %>
            </tr>
            <tr>
                <td class="iptbltd">Created Time</td>
                <td class="iptbltd"><%=etrDomain.getCreatedTime() != -1 ? new Date(etrDomain.getCreatedTime()) : "Not Available"%></td> <%-- NO OUTPUTENCODING --%>
            </tr>
            <tr>
                <td class="iptbltd">Modified Time</td>
                <td class="iptbltd"><%=etrDomain.getModifiedTime() != -1 ? new Date(etrDomain.getModifiedTime()) : "Not Available"%></td> <%-- NO OUTPUTENCODING --%>
            </tr>
        </table>

        <form name="updateEtrDomain" class="zform" method="POST" onsubmit="return createEtrDomain(this, false)" id="editEDfrm" style="display:none;">
            <table class="addEDtbl" cellspacing="4" cellpadding="0">
                <tr>
                    <td class="addEDtbltd">API Key :</td>
                    <td><input type="text" name="apikey" class="input disable" disabled value="<%=IAMEncoder.encodeHTMLAttribute(etrDomain.getApiKey())%>"/></td>
                </tr>
                <tr>
                    <td class="addEDtbltd">Domain Name :</td>
		    <td><input type="text" name="domain" class="input" value="<%=IAMEncoder.encodeHTMLAttribute(etrDomain.getDomainName())%>"/></td>
                </tr>
                <tr>
                    <td class="addEDtbltd">Owner Email Address :</td>
		    <td><input type="text" name="email" class="input" value="<%=IAMEncoder.encodeHTMLAttribute(ownerEmail)%>"/></td>
                </tr>
                <tr>
                    <td class="addEDtbltd">Internal :</td>
                    <td>
                    	<select class="select" name="type">
                        	<option value="<%=EnterpriseDomain.SSO%>" <%if(etrDomain.getEDType() == EnterpriseDomain.SSO) {%>selected<%}%>>SSO</option><%-- NO OUTPUTENCODING --%> <%-- No I18N --%>
                        	<option value="<%=EnterpriseDomain.SSOP%>" <%if(etrDomain.getEDType() == EnterpriseDomain.SSOP) {%>selected<%}%>>SSOP</option><%-- NO OUTPUTENCODING --%> <%-- No I18N --%>
                        	<option value="<%=EnterpriseDomain.PARTNER_SSO%>" <%if(etrDomain.getEDType() == EnterpriseDomain.PARTNER_SSO) {%>selected<%}%>>Partner SSO (Airtel Africa)</option><%-- NO OUTPUTENCODING --%> <%-- No I18N --%>
                        	<option value="<%=EnterpriseDomain.PARTNER_USER%>" <%if(etrDomain.getEDType() == EnterpriseDomain.PARTNER_USER) {%>selected<%}%>>Partner SSO (LiveDesk Integ)</option><%-- NO OUTPUTENCODING --%> <%-- No I18N --%>
                        	<option value="<%=EnterpriseDomain.ZOHO_API%>" <%if(etrDomain.getEDType() ==  EnterpriseDomain.ZOHO_API) {%>selected<%}%>>Zoho Reseller (Payments)</option><%-- NO OUTPUTENCODING --%> <%-- No I18N --%>
                    	</select>
                    </td>
                </tr>
                <tr>
                    <td class="addEDtbltd">Status :</td>
                    <td>
                        <select name="status" class="select">
                            <option value="true" <%if(etrDomain.isActive()) {%>selected<%}%>>Enabled</option>
                            <option value="false" <%if(!etrDomain.isActive()) {%>selected<%}%>>Disabled</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td class="addEDtbltd">Allowed IP(s) :</td>
                    <td id="etripstd">
<%
                        if(ipRangeList != null && !ipRangeList.isEmpty()) {
                            int ipcnt = 1;
                            int totalcnt = ipRangeList.size();
                            for(IPRange ipRange : ipRangeList) {
%>
                        <div class="edipdiv">
			    <input type="text" class="input" value="<%=IAMEncoder.encodeHTMLAttribute(ipRange.getFromIPAsString())%>"/>
                            <span class="ipspacerspan"></span>
			    <input type="text" class="input" value="<%=IAMEncoder.encodeHTMLAttribute(ipRange.getToIPAsString())%>"/>
                                <%if(ipcnt == totalcnt) {%>
                            <span class="addEDicon" onclick="addEDIcon(this)">&nbsp;</span>
                                <%} else {%>
                            <span class="removeEDicon" onclick="removeEDIcon(this)">&nbsp;</span>
                                <%}%>
                        </div>
<%
                                ipcnt++;
                            }
                        } else {
%>
                        <div class="edipdiv">
                            <input type="text" class="input disableEDtxt" value="From IPAddress"/>
                            <span class="ipspacerspan"></span>
                            <input type="text" class="input disableEDtxt" value="To IPAddress"/>
                            <span class="addEDicon" onclick="addEDIcon(this)">&nbsp;</span>
                        </div>
                        <%}%>
                    </td>
                </tr>
                <tr>
                    <td class="addEDtbltd">Enter Admin password :</td>
                    <td>
                        <input type="password" name="pwd" class="input"/>
                    </td>
                </tr>
                <tr>
                    <td class="addEDtbltd">&nbsp;</td>
                    <td>
                        <div class="savebtn" onclick="createEtrDomain(document.updateEtrDomain, false)">
                            <span class="btnlt"></span>
                            <span class="btnco">Update</span>
                            <span class="btnrt"></span>
                        </div>
                        <div onclick="updateEDF('hide')" class="fllt">
                            <span class="btnlt"></span>
                            <span class="btnco">Cancel</span>
                            <span class="btnrt"></span>
                        </div>
                        <input type="submit" class="hidesubmit" />
                    </td>
                </tr>
            </table>
        </form>
        <%
            } else {
%>
        <div class="emptyobjmain">
	    <dl class="emptyobjdl"><dd><p align="center" class="emptyobjdet">EnterpriseDomain not found for <%=IAMEncoder.encodeHTML(domain)%></p></dd></dl>
	</div>
<%
            }
         }
         %>
    </div>
</div>
