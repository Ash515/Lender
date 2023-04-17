<%--$Id$--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="includes.jsp"%>
<div class="menuheader">Admin<br /><span class="spanemail"><%=IAMEncoder.encodeHTML(user.getPrimaryEmail())%></span></div>
<div class="maincontent">
    <div class="menucontent">
        <div class="topcontent"><div class="contitle">Reorder Services</div></div>
        <div class="subtitle">Reorder services as you wish to display in Switch To menu of other Apps.</div>
    </div>
    <div class="field-bg">
        <table width="100%" style="table-layout: fixed;">
            <tr>
                <%
                            StringBuffer productSB = new StringBuffer();
                            StringBuffer collabSB = new StringBuffer();
                            StringBuffer bizSB = new StringBuffer();
                            String productSids = "";
                            String collabSids = "";
                            String bizSids = "";
                            for (Service service : CSPersistenceAPIImpl.getAllServicesByListingOrder()) {
                                if (!service.isPublic() || service.getServiceName().equals(iamservie)) {
                                    continue;
                                }
                                String ui = "<li sid='" + service.getServiceId() + "'>" + IAMEncoder.encodeHTML(service.getDisplayName()) + "</li>";
                                if (service.getServiceType() == Service.COLLABORATION) {
                                    collabSB.append(ui);
                                    collabSids += service.getServiceId() + ",";
                                } else if (service.getServiceType() == Service.BUSINESS) {
                                    bizSB.append(ui);
                                    bizSids += service.getServiceId() + ",";
                                } else {
                                    productSB.append(ui);
                                    productSids += service.getServiceId() + ",";
                                }
                            }
                            productSids = productSids.endsWith(",") ? productSids.substring(0, productSids.length() - 1) : productSids;
                            collabSids = collabSids.endsWith(",") ? collabSids.substring(0, collabSids.length() - 1) : collabSids;
                            bizSids = bizSids.endsWith(",") ? bizSids.substring(0, bizSids.length() - 1) : bizSids;
                %>
                <td valign="top" style="padding: 0 25px;">
                    <div class="service-title">Productivity</div><%--No I18N--%>
                    <ul class='servicesortable' id='product-sortable' oldIds="<%=productSids%>"> <%-- NO OUTPUTENCODING --%>
                        <%=productSB.toString()%> <%-- NO OUTPUTENCODING --%>
                    </ul>
                </td>
                <%
                            if (collabSB.length() > 0) {
                %>
                <td valign="top" style="padding: 0 25px;">
                    <div class="service-title">Collabaration</div>
                    <ul class='servicesortable' id='collab-sortable' oldIds="<%=collabSids%>"> <%-- NO OUTPUTENCODING --%>
                        <%=collabSB.toString()%> <%-- NO OUTPUTENCODING --%>
                    </ul>
                </td>
                <%          }
                            if (bizSB.length() > 0) {
                %>
                <td valign="top" style="padding: 0 25px;">
                    <div class="service-title">Business</div>
                    <ul class='servicesortable' id='biz-sortable' oldIds="<%=bizSids%>"> <%-- NO OUTPUTENCODING --%>
                        <%=bizSB.toString()%> <%-- NO OUTPUTENCODING --%>
                    </ul>
                </td>
                <%
                            }
                %>
            </tr>
            <tr>
                <td colspan="3" align="left">
                    <div class="accbtn Hbtn" tyle="width: auto;">
                        <div onclick="updateServiceOrder();" class="savebtn">
                            <span class="btnlt"></span>
                            <span class="btnco">Save</span>
                            <span class="btnrt"></span>
                        </div>
                        <div onclick="loadui('/ui/admin/service.jsp?t=view');">
                            <span class="btnlt"></span>
                            <span class="btnco">Cancel</span>
                            <span class="btnrt"></span>
                        </div>
                    </div>
                </td>
            </tr>
        </table>
    </div>
</div>
<iframe src="<%=request.getContextPath()%>/static/blank.html" frameborder="0" height="0" width="0" style='display:none;' onload="$('ul.servicesortable').disableSelection().sortable({ containment: 'document' });"></iframe> <%-- NO OUTPUTENCODING --%>