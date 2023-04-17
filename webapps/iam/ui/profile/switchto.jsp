<%-- $Id$ --%>
<%@page import="com.zoho.accounts.internal.util.I18NUtil"%>
<%@page import="java.util.Arrays"%>
<%@page import="java.util.List"%>
<%@ include file="../../static/includes.jspf" %>
<%
            if (request.getHeader("X-Proxied-for") != null) {
                response.setHeader("Content-Encoding", "nogzip"); //No I18N
            }
            boolean secureonly = "true".equals(request.getParameter("https")); // No I18N
            String bgClr = request.getParameter("bgClr");
            String headerClr = request.getParameter("headerClr");
            String borderClr = request.getParameter("borderClr");
            String txtClr = request.getParameter("txtClr");
            String hoverClr = request.getParameter("hoverClr");
            String dropDown = request.getParameter("dropDownClass");
            String fontStyle = request.getParameter("fontStyle");
            boolean zapps = request.getParameter("zapps") == null ? true : Boolean.parseBoolean(request.getParameter("zapps"));

            borderClr = borderClr == null ? "#8FCBE5" : borderClr; // No I18N
            headerClr = headerClr == null ? "#005D92" : headerClr; // No I18N
            bgClr = bgClr == null ? "#C2E5FA" : bgClr; // No I18N
            txtClr = txtClr == null ? "#0172BA" : txtClr; // No I18N
            hoverClr = hoverClr == null ? "#E5F1F8" : hoverClr; // No I18N
            fontStyle = fontStyle == null ? "DejaVu Sans,Roboto,Helvetica,sans-serif" : fontStyle; // No I18N

            List<Service> serviceList = Util.SERVICEAPI.getAllServicesByOrder();
            String iamservie = Util.getIAMServiceName();
            String currentServiceName = request.getParameter("servicename");
            String[] exclude = request.getParameterValues("exclude");
            List<String> excludeServiceList = exclude == null ? null : Arrays.asList(exclude);
            StringBuffer productSB = new StringBuffer();
            StringBuffer collabSB = new StringBuffer();
            StringBuffer bizSB = new StringBuffer();

            for (Service service : serviceList) {
                String name = service.getServiceName();
                if (!service.isPublic() || name.equals(iamservie) || name.equals(currentServiceName) || (excludeServiceList != null && excludeServiceList.contains(name))) {
                    continue;
                }
                String gotourl = service.getWebUrl();
                gotourl = secureonly ? IAMUtil.toHTTPS(gotourl) : gotourl;
                String i18nKey = "ZOHO." + name + ".DESC";//No I18N
                String title = gotourl;
                if (!Util.isBaihui()) {
                    title = I18NUtil.getMessageOrDefault(i18nKey, service.getDescription());
                }
                String ui = "<a href ='" + gotourl + "' target='_blank' title='" + title + "' class='zc-switch-serv-row'>" + service.getDisplayName() + "</a>";
                if (service.getServiceType() == Service.COLLABORATION) {
                    collabSB.append(ui);
                } else if (service.getServiceType() == Service.BUSINESS) {
                    bizSB.append(ui);
                } else {
                    productSB.append(ui);
                }
            }
%>
<style type="text/css">
    .zc-switch-apps-txt {
        width: 100%;
        text-align: center;
        font-size: 11px;
        font-family: <%=IAMEncoder.encodeCSS(fontStyle)%>;
    }
    .zc-switch-apps-txt div {
        border: 1px solid <%=IAMEncoder.safeEncodeCSS(borderClr)%>; background-color: #FFF; display: inline; padding: 5px 10px; border-bottom: none;
        line-height: 23px;<%=dropDown != null ? "_height: 25px;" : "_line-height:27px;"%>color: <%=IAMEncoder.safeEncodeCSS(txtClr)%>;cursor: pointer;
        -moz-border-radius-topleft: 3px;
        -moz-border-radius-topright: 3px;
        -webkit-border-top-left-radius:3px;
        -webkit-border-top-right-radius:3px;
    }
    .zc-switch-container {
        margin-top: -1px;
        border: 1px solid <%=IAMEncoder.safeEncodeCSS(borderClr)%>;
        -moz-border-radius: 5px;
        -webkit-border-radius: 5px;
        width: 100%;
        font-size: 11px;
        font-family: <%=IAMEncoder.encodeCSS(fontStyle)%>;
        background-color: #fff;
    }
    .zc-switch-col { padding: 2px 10px 2px 7px;table-layout: fixed;-moz-border-radius: 5px; }
    .zc-switch-col td { vertical-align: top;padding: 0 15px; }
    .zc-switch-h {
        color: <%=IAMEncoder.safeEncodeCSS(headerClr)%>;
        font-size: 14px;
        font-weight: bold;
        padding-bottom: 7px;
    }
    a.zc-switch-serv-row {
        padding: 7px 0px;
        clear: both;
        border-bottom: 1px dotted <%=IAMEncoder.safeEncodeCSS(bgClr)%>;
        font-size: 12px;
        color: <%=IAMEncoder.safeEncodeCSS(txtClr)%>;
        text-indent: 7px;
        text-decoration: none;
        display: block;
    }
    a.zc-switch-serv-row:hover { background-color: <%=IAMEncoder.safeEncodeCSS(hoverClr)%>; }
</style>
<%if (zapps) {%>
<div class="zc-switch-apps-txt">
    <div id="zc-switch-zapps">
        <%if (dropDown == null) {%>
        <span><%=Util.getI18NMsg(request, "IAM.ZOHO.APPS")%></span><span>&#9660;</span>
        <%} else {%>
        <span><%=Util.getI18NMsg(request, "IAM.ZOHO.APPS")%></span><span class="<%=IAMEncoder.encodeHTMLAttribute(dropDown)%>"></span>
        <%}%>
    </div>
</div>
<%}%>
<div class="zc-switch-container">
    <table width="100%" class="zc-switch-col">
        <tr>
<%if (collabSB.length() > 0) {%>
            <td>
		<div class="zc-switch-h"><%=Util.getI18NMsg(request, "IAM.SWITCHTO.COLLABORATION")%></div>
		<%=collabSB.toString()%> <%-- NO OUTPUTENCODING --%>
            </td>
<%} if (bizSB.length() > 0) {%>
            <td>
                <div class="zc-switch-h"><%=Util.getI18NMsg(request, "IAM.SWITCHTO.BUSINESS")%></div> <%-- No I18N --%>
                <%=bizSB.toString()%> <%-- NO OUTPUTENCODING --%>
            </td>
<%}%>
            <td>
                <div class="zc-switch-h"><%=Util.getI18NMsg(request, "IAM.SWITCHTO.PRODUCTIVITY")%></div>
                <%=productSB.toString()%> <%-- NO OUTPUTENCODING --%>
            </td>
        </tr>
    </table>
</div>
