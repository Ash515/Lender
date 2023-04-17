<%-- $Id$ --%>
<%@ include file="includes.jsp" %>
<%
    String serviceUrl = Util.getBackToURL(request.getParameter("servicename"), request.getParameter("serviceurl"));
    serviceUrl = Util.getTrustedURL(-1, serviceUrl);
    boolean isIAMAdmin = request.isUserInRole("IAMAdmininistrator");
    boolean isIAMSupportAdmin = request.isUserInRole("IAMSupportAdmin");
    boolean isIAMServiceAdmin = !isIAMAdmin && request.isUserInRole(Role.IAM_SERVICE_ADMIN);
%>
<div class="maincontent">
    <div class="menucontent">
	<div class="topcontent"><div class="contitle">Reset Password</div></div>
	<div class="subtitle">Admin Services</div>
    </div>

    <div class="field-bg">
	<form name="resetpassword" class="zform" id="resetpassword" onsubmit="return resetPassword(this);" method="post">
	    <div class="labelmain">
		<div class="labelkey">Enter UserName or Email Address :</div> <%--No I18N--%>
		<div class="labelvalue"><input type="text" name="user" class="input"/></div>
		<%if(isIAMAdmin || isIAMSupportAdmin || (isIAMServiceAdmin && Util.isDevelopmentSetup())) {%>
		<div class="labelkey" style="padding-top:4px;">Action :</div><%--No I18N--%>
		<div class="labelvalue">
		    <input type="radio" name="enable" value="true" class="activateradio"  checked="checked" style="_margin-top:-3px;"  id="resetpwd" onclick='makeResetpassword(this)' >
		    <div class="fllt">Reset Password</div><%--No I18N--%>
		    <input type="radio" name="enable" value="false" class="inactivateradio" style="_margin-top:-3px;" id="resetpasswordlink" onclick='makeResetpassword(this)'>
		    <div>Generate Link</div><%--No I18N--%>
		</div>
		<div id="resetoption">
		<div class="labelkey">Enter User's new password :</div>
		<div class="labelvalue"><input type="password" class="input" name="password"/></div>
		</div>
		<div id="valPeriod" style="display: none;">
		<div class="labelkey">select validity period for password reset link :</div> <%--No I18N--%>
		<div class="labelvalue">
			 <select id="validityperiod" name="validityperiod">
			  <option value="6">6 hr</option><%--No I18N--%>
			  <option value="12">12 hr</option><%--No I18N--%>
			  <option value="18">18 hr</option><%--No I18N--%>
			  <option value="24">24 hr</option><%--No I18N--%>
			  <option value="32">32 hr</option><%--No I18N--%>
			  <option value="38">38 hr</option><%--No I18N--%>
			  <option value="42">42 hr</option><%--No I18N--%>
			</select> 
			<span  style="font-size: 13px;text-align: center;padding-right: 0%;color: #ff0909;"><b>(Note :</b> validity should be Based on user's previous mail response)</span> <%--No I18N--%>
		</div>
		</div>
		<%}%>
		<div class="labelkey">Reason :</div> <%--No I18N--%>
		<div class="labelvalue"><textarea name="reason" class="txtarea tmpcolor"  onfocus="clearsampletxt(this)" placeholder="Enter the reason with support ticket ID"></textarea></div><%--No I18N--%>
		<div class="labelkey">Enter Admin password :</div>
		<div class="labelvalue"><input type="password" class="input" name="pwd"/></div>
		<div class="accbtn Hbtn">
		    <div class="savebtn" onclick='resetPassword(document.resetpassword,"<%=IAMEncoder.encodeJavaScript(Util.encode(serviceUrl))%>")'>
			<span class="btnlt"></span>
			<span class="btnco" id="resetbtn">Save</span><%--No I18N--%>
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
	    <div class='resetoptionlink'>
	    <div class="resetusercontainer">Email Address : <span id="resetusername"></span></div><%--No I18N--%>
	    <textarea readonly id="resetpasswordurl" onclick="this.focus();this.select()"></textarea>
	    </div>
	</form>
    </div>
</div>