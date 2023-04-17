<%-- $Id$ --%>
<%@page import="com.zoho.accounts.Accounts"%>
<%@page import="com.adventnet.iam.internal.PartnerAccountUtil"%>
<%@ include file="../../static/includes.jspf" %>
<%@ include file="includes.jsp" %>
<div class="maincontent">
    <div class="menucontent">
		<div class="topcontent"><div class="contitle">Partner Signup</div></div><%--No I18N--%>
		<div class="subtitle">Admin Services</div><%--No I18N--%>
    </div>

    <div class="field-bg">
<%
    String type = request.getParameter("t");
	if("clear".equals(type)) {
%>
	<div class="topbtn Hcbtn" style="margin: 3px 0px 8px 0px;">
		<div class="addnew" style="margin: 0;" onclick="loadui('/ui/admin/partner_signup.jsp?t=view')">
			<span class="cbtnlt"></span>
			<span class="cbtnco">Back to List</span> <%--No I18N--%>
			<span class="cbtnrt"></span>
		</div>
	</div>
	<form name="clearcachepartner" class="zform"  target="dummy" id="partnerclear" onsubmit="return clearPartnerAccountAgentCache(this);" method="post">
    	<div class="labelmain">
			<div class="labelkey">Service Name :</div> <%--No I18N--%>
			<div class="labelvalue">
				<!-- non Html5 supported browser -->
				<select name="servicename" class="select" id="servicehtml5">
					<%for(Service s: ss){%><option value='<%=IAMEncoder.encodeHTMLAttribute(s.getServiceName())%>'><%=IAMEncoder.encodeHTML(s.getServiceName())%></option><%}%>
					<option value='all'>All Services</option><%--No I18N--%>
				</select>
				<!-- Html5 supported browser -->

				<div class='canvascheck'>
					<input class="input" name="servicename" list="services" />
	    			<datalist id="services"> <%--No I18N--%>
						<%for(Service s: ss){%><option value='<%=IAMEncoder.encodeHTMLAttribute(s.getServiceName())%>'><%}%>
						<option value='all'><%--No I18N--%>
						</datalist><%--No I18N--%>
					</div>
			</div>
			<div class="labelkey">Enter Admin Password :</div><%--No I18N--%>
			<div class="labelvalue"><input type="password" name="pwd" class="input"/></div>
			<div class="accbtn Hbtn">
	    		<div class="savebtn" onclick="clearPartnerAccountAgentCache(document.clearcachepartner)">
					<span class="btnlt"></span>
					<span class="btnco" id="resetbtn">Clear Cache</span><%--No I18N--%>
					<span class="btnrt"></span>
	    		</div>
	    		<div onclick="loadui('/ui/admin/partner_signup.jsp?t=view')">
					<span class="btnlt"></span>
					<span class="btnco">Cancel</span><%--No I18N--%>
					<span class="btnrt"></span>
	    		</div>
			</div>
			<input type="submit" class="hidesubmit" />
    	</div>
    	<div id="details" style="display:none;">
		<a href="javascript:;" onclick="de('result').style.display='';">Details &raquo;</a> <%--No I18N--%> 
	    </div>
	    <div id="result" style="display:none;"></div>
    </form>
<%} else if("view".equals(type)){ %>
		<div class="topbtn Hcbtn" style="margin:3px 0px 8px 0px;">
			<div class="addnew" style="margin: 0;float:left;" onclick="loadui('/ui/admin/partner_signup.jsp?t=add')">
				<span class="cbtnlt"></span>
				<span class="cbtnco">Add New Domain</span> <%--No I18N--%>
				<span class="cbtnrt"></span>
			</div>
			<div class="addnew" style="margin: 0;" onclick="loadui('/ui/admin/partner_signup.jsp?t=clear');showSupportedList();">
				<span class="cbtnlt"></span>
				<span class="cbtnco">Clear Agent Cache</span> <%--No I18N--%>
				<span class="cbtnrt"></span>
			</div>
		</div>
		<div style="padding: 15px 0px 5px;">
<%
		boolean isEnabledPartnerAccountRegistration = "true".equalsIgnoreCase(AccountsConfiguration.getConfiguration("iam.partneraccount.enabled", "false")); //No I18N
		String partnerDomainOrId = request.getParameter("domain");
		partnerDomainOrId = Util.isValid(partnerDomainOrId) ? partnerDomainOrId.trim() : "";
		PartnerAccount partnerAccount = PartnerAccountUtil.getPartnerAccount(partnerDomainOrId);
		
		if(!isEnabledPartnerAccountRegistration) {
			%>
			<div class="partner_disabled_txt">PartnerAccount feature is disabled now. Can enable this by adding the system configuration "iam.partneraccount.enabled"</div> <%-- No I18N --%>
			<%
		}
%>
			<div class="labelmain">
	    		<div class="labelkey" style="width:375px;">Enter PartnerDomain :</div><%--No I18N--%>
	    		<div class="searchfielddiv">
	    			<input type="text" name="partnerdomain" id="partnerdomain" class="input" value="<%=IAMEncoder.encodeHTMLAttribute(partnerDomainOrId)%>" onmouseover="this.focus()" onkeypress="if(event.keyCode == 13){ searchPartnerAccountDomain();return false;}"/>
	    		</div>
	    		<div class="Hbtn searchbtn">
					<div class="savebtn" onclick="searchPartnerAccountDomain()" style="margin:0px;">
						<span class="btnlt"></span>
						<span class="btnco">Search</span> <%-- No I18N --%>
						<span class="btnrt"></span>
					</div>
	    		</div>
			</div>
<%
if(Util.isValid(partnerDomainOrId) && partnerAccount == null) {
%>
			<div class="emptyobjmain">
	    		<dl class="emptyobjdl"><dd><p align="center" class="emptyobjdet">No Partner Account(s) registered with "<%=IAMEncoder.encodeHTML(partnerDomainOrId)%>"</p></dd></dl><%--No I18N--%>
			</div>
<%
} else if(partnerAccount != null) {
%>
			<div class="apikeyheader">
		    	<div class="apikeytitle" style="width:26%;">Partner Name</div> <%--No I18N--%>
	    		<div class="apikeytitle" style="width:15%;">Partner Domain </div> <%--No I18N--%>
	    		<div class="apikeytitle" style="width:26%;">Display Name</div><%--No I18N--%>
	    		<div class="apikeytitle" style="width:auto;float:none;">Action</div><%--No I18N--%>
			</div>
			<div class="apikeycontent content1">
	    		<div class="apikey" style="width:26%;"><%=IAMEncoder.encodeHTML(partnerAccount.getPartnerName())%></div>
	    		<div class="apikey" style="width:15%;"><%=IAMEncoder.encodeHTML(partnerAccount.getPartnerDomain())%></div>
	   			<div class="apikey" style="width:26%;"><%=IAMEncoder.encodeHTML(partnerAccount.getDisplayName())%></div>
	   			<div class="apikey apikeyaction" style="width:auto; float:none;">
					<div class="Hbtn">
		    			<div class="savebtn" onclick="loadui('/ui/admin/partner_signup.jsp?t=edit&domain=<%=IAMEncoder.encodeJavaScript(partnerAccount.getPartnerDomain())%>')">
							<span class="cbtnlt"></span>
							<span class="cbtnco">Edit</span> <%--No I18N--%>
							<span class="cbtnrt"></span>
		    			</div>
		    			<div onclick="loadui('/ui/admin/partner_signup.jsp?t=viewconfig&domain=<%=IAMEncoder.encodeJavaScript(partnerAccount.getPartnerDomain())%>')">
		    				<span class="cbtnlt"></span>
		    				<span class="cbtnco">Manage Configuration</span> <%--No I18N--%>
			    			<span class="cbtnrt"></span>
			    		</div>
			 		</div>
	   			</div>
	  			<div class="clrboth"></div>
			</div>
<%
}
%>
		</div>
<%
	}else if("add".equals(type)){// No i18N
%>
		<form name="partnerSignup" class="zform" id="partnersignup" onsubmit="return createPartner(this);" method="post">
	   		<div class="labelmain">
				<div class="labelkey">Enter Partner Name :</div> <%--No I18N--%>
				<div class="labelvalue"><input type="text" name="partner_name" class="input"/></div>
				<div class="labelkey">Enter Display Name :</div> <%--No I18N--%>
				<div class="labelvalue"><input type="text" name="partner_display" class="input"/></div>
				<div class="labelkey">Enter Domain Name:</div><%--No I18N--%>
				<div class="labelvalue"><input type="text" class="input" name="partner_domain"/></div>
				<div class="labelkey" style="padding-top:4px;">Enter Partner Email Id :</div><%--No I18N--%>
				<div class="labelvalue"><input type="text" name="partner_emailid" class="input"/></div>
				<div class="labelkey">Enter the Admin Password :</div><%--No I18N--%>
				<div class="labelvalue"><input type="password" name="pwd" class="input"/></div>
				<div class="accbtn Hbtn">
	    			<div class="savebtn" onclick='createPartner(document.partnerSignup)'>
						<span class="btnlt"></span>
						<span class="btnco" id="resetbtn">Create</span><%--No I18N--%>
						<span class="btnrt"></span>
		    		</div>
		   			<div onclick="loadui('/ui/admin/partner_signup.jsp?t=view')">
						<span class="btnlt"></span>
						<span class="btnco">Cancel</span><%--No I18N--%>
						<span class="btnrt"></span>
		    		</div>
				</div>
				<input type="submit" class="hidesubmit" />
    		</div>
		</form>
<%
	} else if("edit".equals(type)) {//No I18N
		String partnerDomain = request.getParameter("domain");
		PartnerAccount partnerAccount = PartnerAccountUtil.getPartnerAccount(partnerDomain);
		UserEmail paum = Util.USERAPI.getPrimaryEmail(partnerAccount.getOwnerZUID());
		String partnerAdminEmail = paum != null ? paum.getEmailId() : "NOT_EXISTS"; //No I18N
%>
	    <div class="emptydiv"></div>
	   	<div class="partnerlogo">
	   		<img src="/file?t=org&fs=thumb&ID=<%=partnerAccount.getPartnerID()%>&nocache=<%=System.currentTimeMillis()%>" id="partnerimg"/></br> <%-- NO OUTPUTENCODING --%>
			<div><a href="javascript:;" onclick="openLogoWindow()">Change Logo</a></div><%--No I18N--%>
		</div>
	 	<div class='partnerlogoform'>
	 		<div class="confirmheader">
	   			<span class="fllt mtop" style="font-size:14px">Upload partner logo</span><%--No I18N--%>
				<span class="popupclose" onclick="closeLogoWindow()"></span>
				<span style="display: inline-block;">&nbsp;</span>
	    	</div>
	   		<div class="border-dotted">&nbsp;</div>
	   		<form name="logoupdate" class="zform" target="dummy" enctype="multipart/form-data" id="partnerlogo" onsubmit="return false;" method="post" action="<%=IAMEncoder.encodeHTMLAttribute(cPath)%>/admin/partneraccount/uploadlogo">
				<div class="labelmain" style="clear: both;">
					<div class="labelkey">Partner Logo :</div> <%--No I18N--%>
					<div class="labelvalue"><input type="file" name="partner_logo" class="input"/></div>	
					<input type="hidden" name="iamcsrcoo" value="<%=IAMEncoder.encodeHTMLAttribute(IAMUtil.getCookie(request, "iamcsr"))%>"/>
					<div class="accbtn Hbtn">
					    <div class="savebtn" onclick='uploadPartnerLogo(document.logoupdate)'>
							<span class="btnlt"></span>
							<span class="btnco" id="resetbtn">Save</span><%--No I18N--%>
							<span class="btnrt"></span>
						</div>
						<div onclick="closeLogoWindow()">
							<span class="btnlt"></span>
							<span class="btnco">Cancel</span><%--No I18N--%>
							<span class="btnrt"></span>
						</div>
					</div>
				</div>
				<input type="hidden" name="partnerid" value="<%=partnerAccount.getPartnerID()%>"/><%-- NO OUTPUTENCODING --%>
	   		</form>
	    	<iframe src="<%=cPath%>/static/blank.html" frameborder="0" height="0" width="0" style='display: none;' name=dummy id=dummy></iframe>  <%-- NO OUTPUTENCODING --%>
	   	</div>

		<form name="partnerUpdate" class="zform" id="partnerupdate" onsubmit="return updatePartnerAccount(this);" method="post">
		  	<div class="labelmain" style="clear: both;">
				<div class="labelkey">Enter Partner Name :</div> <%--No I18N--%>
				<div class="labelvalue"><input type="text" name="partner_name" class="input" value="<%=IAMEncoder.encodeHTMLAttribute(partnerAccount.getPartnerName())%>"/></div>
				<div class="labelkey">Enter Display Name :</div> <%--No I18N--%>
				<div class="labelvalue"><input type="text" name="partner_display" class="input" value="<%=IAMEncoder.encodeHTMLAttribute(partnerAccount.getDisplayName())%>"/></div>
				<div class="labelkey">Enter Domain Name:</div><%--No I18N--%>
				<div class="labelvalue"><input type="text" class="input" name="partner_domain" value="<%=IAMEncoder.encodeHTMLAttribute(partnerAccount.getPartnerDomain())%>"/></div>
				<div class="labelkey" style="padding-top:4px;">Enter Partner Email Id :</div><%--No I18N--%>
				<div class="labelvalue"><input type="text" name="partner_emailid" class="input" disabled="disabled" value="<%=IAMEncoder.encodeHTMLAttribute(partnerAdminEmail) %>"/></div>
				<div class="labelkey">Enter the Admin Password :</div><%--No I18N--%>
				<div class="labelvalue"><input type="password" name="pwd" class="input"/></div>
				<div class="accbtn Hbtn">
		    		<div class="savebtn" onclick='updatePartnerAccount(document.partnerUpdate)'>
						<span class="btnlt"></span>
						<span class="btnco" id="resetbtn">Update</span><%--No I18N--%>
						<span class="btnrt"></span>
		    		</div>
		   			<div onclick="loadui('/ui/admin/partner_signup.jsp?t=view&domain=<%=IAMEncoder.encodeJavaScript(partnerAccount.getPartnerDomain())%>')">
						<span class="btnlt"></span>
						<span class="btnco">Cancel</span><%--No I18N--%>
						<span class="btnrt"></span>
		    		</div>
				</div>
				<input type="submit" class="hidesubmit" />
				<input type="hidden" name="partnerid" value="<%=partnerAccount.getPartnerID() %>"/> <%-- NO OUTPUTENCODING --%>
	   		</div>
		</form>
<%
	} else if("viewconfig".equals(type)) { //No I18N
		String domain = request.getParameter("domain");
		PartnerAccount partnerAccount = PartnerAccountUtil.getPartnerAccount(domain);
		Map<String, Object> confMap = partnerAccount.getConfigurations().getData();
%>
		<div class="topbtn Hcbtn" style="margin-top: -20px; float: right; margin-right: 11px;">
			<div class="addnew" style="margin: 0;" onclick="loadui('/ui/admin/partner_signup.jsp?t=view&domain=<%=IAMEncoder.encodeJavaScript(domain)%>')">
				<span class="cbtnlt"></span>
				<span class="cbtnco">Back to List</span> <%--No I18N--%>
				<span class="cbtnrt"></span>
			</div>
			<div class="addnew" style="margin: 0;" onclick="addPartnerConfigWindow('show')">
				<span class="cbtnlt"></span>
				<span class="cbtnco">Add New Configuration</span> <%--No I18N--%>
				<span class="cbtnrt"></span>
			</div>
		</div>
<%
		if(confMap != null && !confMap.isEmpty()) {
			Iterator<String> keys = confMap.keySet().iterator();
%>
		<div class="content1">
			<div class="partnerconfigtitle"><%=IAMEncoder.encodeHTML(partnerAccount.getPartnerName())%>'s configuration details</div><%-- No I18N --%>
		</div>
		<div class="apikeyheader" id="headerdiv">
	   		<div class="apikeytitle" style="width:33%;">Name</div> <%--No I18N--%>
	   		<div class="apikeytitle" style="width:33%;">Value</div> <%--No I18N--%>
	   		<div class="apikeytitle" style="width:30%;">Actions</div> <%--No I18N--%>
		</div>
		<div class="content1" id="overflowdiv">
<%
	    	while(keys.hasNext()) {
	    		String configName = keys.next();
	    		String configValue = String.valueOf(confMap.get(configName));
%>
			<div class="apikeycontent">
	    		<div class="apikey" style="width:33%;"><%=IAMEncoder.encodeHTML(configName)%></div>
	   			<div class="apikey" style="width:33%;"><%=IAMEncoder.encodeHeader(configValue)%></div>
	   			<div class="apikey apikeyaction">
					<div class="Hbtn">
	    				<div class="savebtn" onclick="de('updatepartnerconfigname').value='<%=IAMEncoder.encodeJavaScript(configName)%>';de('updatepartnerconfigvalue').value='<%=IAMEncoder.encodeJavaScript(configValue)%>';updatePartnerConfigWindow('show')">
							<span class="cbtnlt"></span>
							<span class="cbtnco">Edit</span> <%--No I18N--%>
							<span class="cbtnrt"></span>
		    			</div>
		    			<div onclick="deletePartnerConfiguration('<%=IAMEncoder.encodeJavaScript(partnerAccount.getPartnerDomain())%>', '<%=IAMEncoder.encodeJavaScript(configName)%>')">
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
		} else {
%>
			<div class="emptyobjmain">
	    		<dl class="emptyobjdl"><dd><p align="center" class="emptyobjdet">Configurations does not registered for <%=IAMEncoder.encodeHTML(partnerAccount.getPartnerName())%></p></dd></dl><%--No I18N--%>
			</div>
<%
		}
%>
		</div>

		<div id="addPartnerConfig" style="display:none;">
			<div><b class="mrptop outbg"><b class="mrp1"></b><b class="mrp2"></b><b class="mrp3"></b><b class="mrp4"></b></b></div>
			<div class="mrpheader">
				<span class="close" onclick="addPartnerConfigWindow('hide')"></span> <span>PartnerAccount Configuration - <%=IAMEncoder.encodeHTML(partnerAccount.getPartnerName())%></span><%-- No I18N --%>
			</div>
			<div class="mprcontent">
				<div><b class="mrptop inbg"><b class="mrp2"></b><b class="mrp3"></b><b class="mrp4"></b></b></div>
				<div class="mrpcontentdiv">
					<form class="zform" name="addpartnerconfiguration" onsubmit="return addPartnerConfiguration(this)" method="post">
						<table cellspacing="5" cellpadding="0" border="0" width="100%">
							<tr>
								<td align="right" width="33%">Name :</td> <%--No I18N--%>
								<td><input type="text" class="input" name="name" /></td>
							</tr>
							<tr>
								<td align="right">Value :</td> <%--No I18N--%>
								<td><input type="text" class="input" name="value" /></td>
							</tr>
							<tr>
								<td align="right">Admin Password :</td><%--No I18N--%>
								<td><input type="password" class="input" name="pwd" /></td>
							</tr>
						</table>
						<div class="mrpBtn">
							<input type="submit" value="Add" /> <input type="button" value="Cancel" onclick="addPartnerConfigWindow('hide')" />
						</div>
						<input type="hidden" name="domain" value="<%=IAMEncoder.encodeHTMLAttribute(partnerAccount.getPartnerDomain())%>"/>
					</form>
				</div>
				<div><b class="mrpbot inbg"><b class="mrp4"></b><b class="mrp3"></b><b class="mrp2"></b></b></div>
			</div>
			<div><b class="mrpbot outbg"><b class="mrp4"></b><b class="mrp3"></b><b class="mrp2"></b><b class="mrp1"></b></b></div>
		</div>

		<div id="updatePartnerConfig" style="display:none;">
			<div><b class="mrptop outbg"><b class="mrp1"></b><b class="mrp2"></b><b class="mrp3"></b><b class="mrp4"></b></b></div>
			<div class="mrpheader">
				<span class="close" onclick="updatePartnerConfigWindow('hide')"></span> <span>PartnerAccount Configuration - <%=IAMEncoder.encodeHTML(partnerAccount.getPartnerName())%></span><%-- No I18N --%>
			</div>
			<div class="mprcontent">
				<div><b class="mrptop inbg"><b class="mrp2"></b><b class="mrp3"></b><b class="mrp4"></b></b></div>
				<div class="mrpcontentdiv">
					<form name="updatepartnerconfiguration" class="zform" onsubmit="return updatePartnerConfiguration(this)" method="post">
						<table cellspacing="5" cellpadding="0" border="0" width="100%">
							<tr>
								<td align="right">Name :</td> <%--No I18N--%>
								<td><input type="text" class="input" id="updatepartnerconfigname" name="name" disabled /></td>
							</tr>
							<tr>
								<td align="right">Value :</td> <%--No I18N--%>
								<td><input type="text" class="input" id="updatepartnerconfigvalue" name="value" /></td>
							</tr>
							<tr>
								<td align="right">Admin Password :</td><%--No I18N--%>
								<td><input type="password" class="input" name="pwd" /></td>
							</tr>
						</table>
						<div class="mrpBtn">
							<input type="submit" value="Update" /> <input type="button" value="Cancel" onclick="updatePartnerConfigWindow('hide')" />
						</div>
						<input type="hidden" name="domain" value="<%=IAMEncoder.encodeHTMLAttribute(partnerAccount.getPartnerDomain())%>"/>
					</form>
				</div>
				<div><b class="mrpbot inbg"><b class="mrp4"></b><b class="mrp3"></b><b class="mrp2"></b></b></div>
			</div>
			<div><b class="mrpbot outbg"><b class="mrp4"></b><b class="mrp3"></b><b class="mrp2"></b><b class="mrp1"></b></b></div>
		</div>
<%
	}
%>
	</div>
</div>