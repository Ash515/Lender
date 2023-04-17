<%-- $Id$ --%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ include file="../../static/includes.jspf" %>
<%@ include file="includes.jsp"%>
<div class="maincontent">
    <div class="menucontent">
	<div class="topcontent"><div class="contitle">Partners</div></div>
	<div class="subtitle">Admin Services</div>
    </div>

    <div class="field-bg">
<%
    String type = request.getParameter("t");
    if("add".equals(type)) {
%>
	<form name="addpartner" class="zform" method="post" onsubmit="return savePartner(this)">
	    <div class="labelmain">
		<div class="labelkey">Partner Name :</div>
		<div class="labelvalue"><input type="text" class="input" name="pname"/></div>
		<div class="labelkey">Partner Domain :</div>
		<div class="labelvalue"><input type="text" class="input" name="pdomain"/></div>
		<div class="labelkey">Partner Email Address :</div> <%--No I18N--%>
		<div class="labelvalue"><input type="text" class="input" name="peid"/></div>
		<div class="labelkey">Activate :</div>
		<div class="labelvalue"><input type="checkbox" class="check" name="pstatus"/></div>
		<div class="accbtn Hbtn">
		    <div class="savebtn" onclick="savePartner(document.addpartner)">
			<span class="btnlt"></span>
			<span class="btnco">Add</span>
			<span class="btnrt"></span>
		    </div>
		    <div onclick="loadui('/ui/admin/partners.jsp?t=view')">
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
    else if("view".equals(type)) {
%>
	<div class="Hcbtn topbtn">
	    <div class="addnew" onclick="loadui('/ui/admin/partners.jsp?t=add')">
		<span class="cbtnlt"></span>
		<span class="cbtnco">Add New</span>
		<span class="cbtnrt"></span>
	    </div>
	</div>
<%
	List<Map> partners=CSPersistenceAPIImpl.getAllPartners();
	if(partners != null && !partners.isEmpty()) {
%>
	<div class="apikeyheader" id="headerdiv">
	    <div class="apikeytitle" style="width:26%;">Partner Name</div> <%--No I18N--%>
	    <div class="apikeytitle" style="width:27%;">Partner Domain</div>
	    <div class="apikeytitle" style="width:26%;">Partner Email Address</div> <%--No I18N--%>
	    <div class="apikeytitle" style="width:15%;">Actions</div>
	</div>

	<div id="overflowdiv" class="content1">
<%
	    for(Map map : partners) {
%>
	<div class="apikeycontent">
	    <div class="apikey" style="width:26%;"><%=IAMEncoder.encodeHTML((String)map.get("PARTNER_NAME"))%></div>
	    <div class="apikey" style="width:27%;"><%=IAMEncoder.encodeHTML((String)map.get("PARTNER_DOMAIN"))%></div>
	    <div class="apikey" style="width:26%;"><%=IAMEncoder.encodeHTML((String)map.get("PARTNER_EMAILID"))%></div>
	    <div class="apikey apikeyaction">
		<div class="Hbtn">
		    <div class="savebtn" onclick="loadui('/ui/admin/partners.jsp?t=edit&partner=<%=IAMEncoder.encodeJavaScript((String)map.get("PARTNER_DOMAIN"))%>')">
			<span class="cbtnlt"></span>
			<span class="cbtnco">Edit</span> <%--No I18N--%>
			<span class="cbtnrt"></span>
		    </div>
		    <div onclick="deletePartner('<%=IAMEncoder.encodeJavaScript((String)map.get("PARTNER_DOMAIN"))%>')">
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
	out.println("</div>");
	}
	else {
%>
	<div class="emptyobjmain">
	    <dl class="emptyobjdl"><dd><p align="center" class="emptyobjdet">No Partner(s) added</p></dd></dl>
	</div>
<%
	}
    }
    else if("edit".equals(type)) {
	String partner_domain = request.getParameter("partner");
	List<Map> partner=CSPersistenceAPIImpl.getPartner(partner_domain);
	if(partner != null && !partner.isEmpty()) {
	    for (Map map : partner) {
		String isActive = IAMUtil.getInt(map.get("PARTNER_STATUS").toString()) == 1 ? "checked" : "";
		String partnerid = CryptoUtil.encryptWithSalt("photo", (String)map.get("PARTNER_DOMAIN"), ":", IAMUtil.getCurrentTicket(), true); //No I18N
%>
	<form name="updatepartner" class="zform" onsubmit="return updatePartner(this);" method="post">
	    <div class="labelmain">
		<div class="emptydiv"></div>
		<div class="partnerlogo">
		    <img src="<%=cPath%>/file?t=partner&ID=<%=IAMEncoder.encodeHTMLAttribute(partnerid)%>" id="partner_<%=IAMEncoder.encodeHTMLAttribute(partnerid)%>"><br/> <%-- NO OUTPUTENCODING --%>
		    <div><a href="javascript:;" onClick="window.open('<%=cPath%>/ui/profile/photo.jsp?type=partner&EID='+euc('<%=IAMEncoder.encodeJavaScript(partnerid)%>'),'_photo','width=580,height=300,screenX=282,screenY=249');">Change Logo</a></div> <%-- NO OUTPUTENCODING --%> <%-- No I18N --%>
		</div>
		<div class="labelkey">Partner Domain :</div>
		<div class="labelvalue">
			<input type="text" class="input disable" name="editpdomain" value="<%=IAMEncoder.encodeHTMLAttribute((String)map.get("PARTNER_DOMAIN"))%>" disabled/>
		</div>
		<div class="labelkey">Partner Name :</div>
		<div class="labelvalue">
			<input type="text" class="input" name="editpname" value="<%=IAMEncoder.encodeHTMLAttribute((String)map.get("PARTNER_NAME"))%>"/>
		</div>
		<div class="labelkey">Partner Email Address :</div> <%--No I18N--%>
		<div class="labelvalue">
			<input type="text" class="input" name="editpeid" value="<%=IAMEncoder.encodeHTMLAttribute((String)map.get("PARTNER_EMAILID"))%>"/>
		</div>
		<div class="labelkey">Activate :</div>
		<div class="labelvalue" style="padding:6px 0px;">
			<input type="checkbox" class="check" name="pstatus" <%=isActive%> /> <%-- NO OUTPUTENCODING --%>
		</div>
		<div class="labelkey">Enter Admin password :</div>
		<div class="labelvalue"><input type="password" class="input" name="pwd"/></div>
		<div class="accbtn Hbtn">
		    <div class="savebtn" onclick="updatePartner(document.updatepartner)">
			<span class="btnlt"></span>
			<span class="btnco">Update</span>
			<span class="btnrt"></span>
		    </div>
		    <div onclick="loadui('/ui/admin/partners.jsp?t=view')">
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
	}
    }
%>
