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
	<div class="topcontent"><div class="contitle">Confirm Email</div></div>
	<div class="subtitle">Admin Services</div>
    </div>

    <div class="field-bg">
	<form name="confirmemail" id="confirmemail" class="zform" onsubmit="return confirmEmail(this);" method="post">
	    <div class="labelmain">
		<div class="labelkey">Enter Email Address :</div> <%--No I18N--%>
		<div class="labelvalue"><input type="text" name="emailId" class="input"/></div>
		<div class="labelkey" style="padding-top:4px;">Action :</div><%--No I18N--%>
		<div class="labelvalue">
		    <input type="radio" name="enable" value="true" class="activateradio" checked="checked" style="_margin-top:-3px;"  id="confirmationlink" onclick='makeConfirmemail(this)' >
		    <div class="fllt">Generate Link</div><%--No I18N--%>
		    <%if(isIAMAdmin || isIAMSupportAdmin || (isIAMServiceAdmin && Util.isDevelopmentSetup())) {%>
		    <input type="radio" name="enable" value="false" class="inactivateradio"  style="_margin-top:-3px;" id="confirmmanually" onclick='makeConfirmemail(this)'>
		    <div>Manual Confirmation</div><%--No I18N--%>
		    <%}%>
		</div>
		<div class="labelkey">Reason :</div> <%--No I18N--%>
		<div class="labelvalue"><textarea name="reason" class="txtarea tmpcolor"  onfocus="clearsampletxt(this)" placeholder="Enter the reason with support ticket ID"></textarea></div><%--No I18N--%>
		<div class="labelkey">Enter Admin password :</div> <%--No I18N--%>
		<div class="labelvalue"><input type="password" class="input" name="pwd"/></div>
		<div class="accbtn Hbtn">
		    <div class="savebtn" onclick='confirmEmail(document.confirmemail,"<%=IAMEncoder.encodeJavaScript(Util.encode(serviceUrl))%>")'>
			<span class="btnlt"></span>
			<span class="btnco" id="confirmbtn">Generate</span> <%--No I18N--%>
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
	<div class='resetoptionlink'>
	    <div class="resetusercontainer">Email Address : <span id="confirmeail"></span></div><%--No I18N--%>
	    <textarea readonly id="resetpasswordurl" onclick="this.focus();this.select()"></textarea>
	    </div>
    </div>
</div>
