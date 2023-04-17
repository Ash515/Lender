<%@page import="com.zoho.accounts.internal.util.AccountsInternalConst.OrgTypeDetail"%>
<%@page import="com.zoho.accounts.AccountsConstants.OrgType"%>
<%@page import="com.zoho.sas.util.GridUtil"%>
<%@page import="com.adventnet.mfw.bean.BeanUtil"%>
<%@page import="com.adventnet.collaboration.Collaboration"%>
<%@page import="com.zoho.iam2.rest.ServiceOrgUtil"%>
<%@ include file="../../static/includes.jspf" %>
<%@ include file="includes.jsp"%>
<div class="maincontent">
    <div class="menucontent">
        <div class="topcontent"><div class="contitle">ServiceOrg DB details</div></div> <%--No I18N--%>
	<div class="subtitle">Admin Services</div> <%--No I18N--%>
    </div>
    <div class="field-bg">
        
        	<div class="sorTable">
        	<div class="sorTableRow">
        	<div class="sorTableHead"><strong>Service Name</strong></div>   <%--No I18N--%>
        	<div class="sorTableHead"><span style="font-weight: bold;">SoidType</span></div>  <%--No I18N--%>
        	<div class="sorTableHead"><span style="font-weight: bold;">DB Name</span></div>  <%--No I18N--%>
        	<div class="sorTableHead"><span style="font-weight: bold;">Is Space Exist</span></div>  <%--No I18N--%>
        	<div class="sorTableHead"><span style="font-weight: bold;">Is Space Associated</span></div>  <%--No I18N--%>
        	</div>
        	<%
        	Collaboration collaboration = (Collaboration) BeanUtil.lookup("CollaborationBean"); // No I18N
        
        OrgType[] newTypes = OrgType.values();
        for(OrgType sot : newTypes) {
        	OrgTypeDetail det = OrgTypeDetail.getOrgTypeDetailsbyServiceOrgType(sot);
        	String resourceSpace = "N/A";//No I18N
        	boolean isSpaceExist = false;
        	boolean isSoidAssociated = false;
        	if(det != null && det.isServiceOrgSpaceNeeded()) {
        		
	        	resourceSpace = ServiceOrgUtil.getResourceSpace(sot.getType());
	        	isSpaceExist = false;
	        	isSoidAssociated = false;
	        	if (collaboration.dataSpaceExists(resourceSpace)) {
	        		isSpaceExist = true;
	        		//GridUtil.getDBInfo(resourceSpace,false);
	    		}
	        	String zaid = det.getZaid();
	        	if(isSpaceExist) {
	        		if (collaboration.dataSpaceExists(zaid)) {
	            		isSoidAssociated = true;
	        		}
	        	}
        	} else {
        		isSpaceExist = true;
        		isSoidAssociated = true;
        	}
        	 %>
        	 
        	 <div class="sorTableRow">
				<div class="sorTableCell"><%=sot.getServiceName() %></div> <%-- NO OUTPUTENCODING --%>
				<div class="sorTableCell"><%=String.valueOf(sot.getType()) %></div> <%-- NO OUTPUTENCODING --%>
				<div class="sorTableCell"><%=resourceSpace%></div> <%-- NO OUTPUTENCODING --%>
				<div class="sorTableCell"><%=String.valueOf(isSpaceExist) + (!isSpaceExist ? "<dt class=\"sorgcrd\" onclick=\"createSpace('" +resourceSpace+"')\"> createDb</dt>" : "") %></div> <%-- NO OUTPUTENCODING --%>
				<div class="sorTableCell"><%=String.valueOf(isSoidAssociated) + (isSpaceExist && !isSoidAssociated ? "<dt class=\"sorgcrd\" onclick=\"associateSorgDiv('" +sot.name()+"')\">associateSorg</dt>" : "") %> </div> <%-- NO OUTPUTENCODING --%>
			</div>
    		
    		
    		<%
        }
        %>
        </div>
		<div id="updatesys" style="display: none;">
			<div>
				<b class="mrptop outbg"><b class="mrp1"></b><b class="mrp2"></b><b
					class="mrp3"></b><b class="mrp4"></b></b>
			</div>
			<div class="mrpheader">
				<span class="close" onclick="updatesysconfigform('hide')"></span> <span>Create DB</span> <%--No I18N--%>
			</div>
			<div class="mprcontent">
				<div>
					<b class="mrptop inbg"><b class="mrp2"></b><b class="mrp3"></b><b
						class="mrp4"></b></b>
				</div>
				<div class="mrpcontentdiv">
				<div id="createSOrgDBID" style="display: none;">
					<form name="updatesys" class="zform" onsubmit="return createSorgDB(this)" method="post">
						<table cellspacing="5" cellpadding="0" border="0" width="100%">
							<tr>
								<td align="right">SOID DB Name :</td> <%--No I18N--%>
								<td><input type="text" class="input" id="IddbName" name="dbName" disabled /></td>
							</tr>
							<tr>
								<td align="right">Cluster Name :</td> <%--No I18N--%>
								<td><input type="text" class="input" id="IdclusterName" name="clusterName" value="ClientPortal" /></td>
							</tr>
							<tr>
								<td align="right">Admin Password :</td> <%--No I18N--%>
								<td><input type="password" class="input" name="pwd" /></td>
							</tr>
						</table>
						<div class="mrpBtn">
							<input type="submit" value="Create" /> 
							<input type="button" value="Cancel" onclick="updatesysconfigform('hide')" />
						</div>
					</form>
					</div>
					<div id="associateSOrgDBID" style="display: none;">
					<form name="associateSOrgDBname" class="zform" onsubmit="return associateSorg(this)" method="post">
						<table cellspacing="5" cellpadding="0" border="0" width="100%">
							<tr>
								<td align="right">Servie Org Name :</td> <%--No I18N--%>
								<td><input type="text" class="input" id="IdsOrgName" name="sorgName" disabled /></td>
							</tr>
							<tr>
								<td align="right">Admin Password :</td> <%--No I18N--%>
								<td><input type="password" class="input" name="pwd" /></td>
							</tr>
						</table>
						<div class="mrpBtn">
							<input type="submit" value="Associate" /> 
							<input type="button" value="Cancel" onclick="updatesysconfigform('hide')" />
						</div>
					</form>
					</div>
				</div>
				<div>
			<b class="mrpbot outbg"><b class="mrp4"></b><b class="mrp3"></b><b class="mrp2"></b><b class="mrp1"></b></b>
		</div>
			</div>
		</div>

    </div>
</div>
