<%-- $Id: $ --%>
<%@page import="com.zoho.accounts.internal.oauth2.OAuth2Util"%>
<%@page import="com.zoho.accounts.dcl.DCLUtil"%>
<%@ include file="includes.jsp"%>
<%@page import="com.adventnet.iam.xss.IAMEncoder"%>
<%@page import="com.zoho.accounts.SystemResourceProto.DCLocation"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<HTML>
<body>
	<div class="maincontent">
		<div class="menucontent">
			<div class="topcontent" style="border-bottom: 1px solid #dfdfdf">
				<div class="contitle">Operations on Client ID</div><%--No I18N--%>
			</div>
		</div>
		<div class="field-bg">
			<form id="oauthconfigform" name="oauthconfigform" method="post">
				<div class="labelmain">
					<div class="labelkey">Enter Client ID :</div><%--No I18N--%>
					<div class="labelvalue">
						<input type="text" size="20" name="clientid" id="clientid" maxlength="200" />
					</div>
					<div class="labelkey">Configuration Type :</div><%--No I18N--%>
					<div class="labelvalue">
						<select name="configtype" id="configtype" onchange="showoauthsublist(this)">
							<option value="1">Client Scopes</option><%--No I18N--%>
							<option value="2">Client Properties</option><%--No I18N--%>
							<option value="3">Enable Multi-DC</option><%--No I18N--%>
							<option value="4">Client Redirect URL</option><%--No I18N--%>
						</select>
					</div>
					<div id="hiddenDiv1" style="display: none;">
					    <div class="labelkey">Input own value :</div><%--No I18N--%>
						<div class="labelvalue">
						       <input type="checkbox" class="check" name="ownproperty" onchange="enterclientpropertykey(this)">
						</div>
						<div class="labelkey">Sub Configuration Type :</div><%--No I18N--%>
						<div class="labelvalue" id="subconfiglist">
							<select name="subconfigtype" id="subconfigtype">
								<%
									int i = 0;
								%>
								<c:set var="subconfigtypes"
									value="<%=AccountsInternalConst.OAuthClientPropertiesConstants.values()%>" /><%--No I18N--%>
								<c:forEach items="${subconfigtypes}" var="subconfigtype">
									<option value=<%=i%>>${subconfigtype}</option><%--No I18N--%>
									<%
										i++;
									%>
								</c:forEach>
							</select>
						</div>
						<div class="labelvalue" id="subconfiginput" style="display: none;">
						<input type="text" size="20" name="subconfigtype1" id="subconfigtype1" maxlength="200"  />
						</div>
						
					</div>
					<div id="hiddenDiv2" style="display: none;">
						<div class="labelkey">Enter Sub Configuration value</div><%--No I18N--%>
						<div class="labelvalue">
							<input type="text" size="20" name="subconfigval"
								id="subconfigval" maxlength="200" />
						</div>
					</div>
					<div id="hiddenDiv3">
						<div class="labelkey">Enter Client Scopes :</div><%--No I18N--%>
						<div class="labelvalue">
							<textarea style="font-size: 10px;" name="clientscopes" rows="5" cols="50" placeholder="eg: servicename.scopename.operation_type <comma-separated> <no white spaces allowed>"></textarea> <%--No I18N--%>
						</div>
					</div>
					<div id="hiddenDiv4" style="display: none;">
						<div class="labelkey">MultiDC setups :</div><%--No I18N--%>
						<div class="labelvalue">
							<div id="cb">
								<%
									String currentloc = IAMEncoder.encodeHTML(DCLUtil.getLocation());
									int setup = 0;
									String md = "MultiDCSupport"; //NO I18N
									Collection<DCLocation> locations = DCLUtil.getLocationList();
									DCLocation presentLocation = DCLUtil.getPresentLocation();
									if (locations != null && presentLocation != null) {
										for (DCLocation location : locations) {
											if (!presentLocation.getLocation().equals(location.getLocation())) {
								%>
								<%
									setup = setup + 1;
												String dcvalue = md + setup;
								%>
								<input type="checkbox" class="check" id=<%=IAMEncoder.encodeHTML(dcvalue)%> value=<%=IAMEncoder.encodeHTML(location.getLocation())%> />
								<%=IAMEncoder.encodeHTML(location.getLocation())%> <!-- No I18N -->
								<%
									}
										}
									}
								%>
							</div>
						</div>
						<div class="labelkey">unified secret</div><%--No I18N--%>
						<div class="labelvalue">
						       <input type="checkbox" class="check" name="unifiedsecret">
						</div>
					</div>
					<div id="hiddenDiv5" style="display: none;">
						<div class="labelkey">Response:</div><%--No I18N--%>
						<div class="labelvalue">
							<textarea id="multidc" readonly style="font-size: 10px; background-color: #BDBDBD" name="response" rows="10" cols="50">		
			                </textarea>
						</div>
					</div>
					<div id="hiddenDiv6" style="display: none;">
						<div class="labelkey">Enter RedirectURL value</div><%--No I18N--%>
						<div class="labelvalue">
						     <textarea style="font-size: 10px;" name="redirecturl" rows="5"
								cols="50"
								placeholder="eg: https://sample1,https://sample2 <comma-separated> <no white spaces allowed>"></textarea> <%--No I18N--%>
						</div>
					</div>
					<div>
						<div class="labelkey">Enter Admin Password :</div><%--No I18N--%>
						<div class="labelvalue">
							<input type="password" name="password" id="password" />
						</div>
					</div>
					<div>
						<div class="labelkey"></div>
						<div class="labelvalue">
							<input type="button" id="submitbutton" value="Send"
								style="height: 30px; width: 70px; background-color: green"
								onclick="validateinputsonaddingoauthconfigurations('<%=setup%>')" />
						</div>
					</div>
				</div>
			</form>
		</div>
	</div>
</body>
</HTML>