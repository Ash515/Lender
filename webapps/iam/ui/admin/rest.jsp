<%--$Id: $ --%>
<%@page import="com.zoho.accounts.AccountsConstants.Header"%>
<%@page import="com.zoho.resource.util.RESTConstants.HTTPHeader"%>
<%@ include file="includes.jsp" %>
<div class="maincontent">
    <div class="menucontent">
		<div class="topcontent"><div class="contitle">REST Operations</div></div>	<%--No I18N--%>
		<div class="subtitle">Do REST client operations like POST, GET, DELETE and PUT</div>	<%--No I18N--%>
    </div>
	<div class="field-bg">
		<form id="restform" method="post">
			<div class="labelmain">
			<div>
				<div class="labelkey">Request Method :</div>	<%--No I18N--%>
				<div class="labelvalue">
					<select name="method" onChange="changeRESTColor(this)">
						<option value="get">GET</option> <%--No I18N--%>
						<option value="post">POST</option>	<%--No I18N--%>
						<option value="put">PUT</option>	<%--No I18N--%>
						<option value="delete">DELETE</option>	<%--No I18N--%>
					</select>
				</div>
			</div>
			<div>
				<div class="labelkey">Enter Relative URI : </div>	<%--No I18N--%>
				<div class="labelvalue">
					<input type="text" size="100" name="uri" placeholder="eg: account/system" maxlength="250"/>
				</div>
			</div>
			<div>
				<div class="labelkey">Select Headers</div>	<%--No I18N--%>
				<div class="labelvalue" id='edipadd'>
					<div class='edipdiv' name='addheader'>
						<select class='select' name='header' style="width:350px;">
							<option value=''>Select Header</option> <%--No I18N--%>
							<%for(HTTPHeader head : HTTPHeader.values() ){ %>
								<option value='<%=head.getName() %>'><%=head %> </option>
							<%} for (Header head : Header.values()) {%>
								<option value='<%=head.getValue() %>'><%=head %> </option>
							<%} %>
						</select>
						<input type="text" name="headervalue" placeholder="Header Value" maxlength="20"/>
						<span class='addEDicon hideicon chaceicon' onclick='addElement(this,3,3)'>&nbsp;</span>
					</div>
				</div>
			</div>
			<div>
				<div class="labelkey">Enter Attributes : </div>	<%--No I18N--%>
				<div class="labelvalue" id='edipadd'>
					<div class='edipdiv' name='addattribute'>
						<input type="text" name="attributename" placeholder="Attribute Name" value="" style="width:342px;"/>
						<input type="text" name="headervalue" placeholder="Attribute Value" maxlength="20"/>
						<span class='addEDicon hideicon chaceicon' onclick='addElement(this,3,3)'>&nbsp;</span>
					</div>
				</div>
			</div>
			<div>
				<div class="labelkey">Enter Admin Password : </div>	<%--No I18N--%>
				<div class="labelvalue">
					<input type="password" name="password"/>
				</div>
			</div>
			<div style="display:none;" id="jsonbodydiv">
				<div class="labelkey">Body (In JSON) : </div>	<%--No I18N--%>
				<div class="labelvalue">
					<textarea style="font-size:10px;" name="body" rows="10" cols="50" placeholder="eg: {'account_name':'testaccount'}"></textarea>
				</div>
			</div>
			<div>
				<div class="labelkey"></div>
				<div class="labelvalue">
					<input type="button" id="submitbutton" value="Send" style="height:30px;width:70px;background-color:green" onclick="validateRESTInputs()"/>
				</div>
			</div>
			<div id="jsonresponsediv">
				<div class="labelkey">Response (In JSON) : </div>	<%--No I18N--%>
				<div class="labelvalue">
					<textarea id="jsonresponse" readonly style="font-size:10px;background-color:#BDBDBD" name="response" rows="15" cols="70"></textarea>
				</div>
			</div>
			</div>
		</form>
	</div>
</div>