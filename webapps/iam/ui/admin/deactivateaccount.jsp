<%-- $Id$ --%>
<%@ page import="com.adventnet.iam.security.SecurityUtil"%>
<%@ include file="includes.jsp" %>
<div class="maincontent">
    <div class="menucontent">
	<div class="topcontent"><div class="contitle">Deactivate Account</div></div>
	<div class="subtitle">Admin Services</div>
    </div>

    <div class="field-bg">
        <div class="restorelink">
            <a href="javascript:;" id="single_acc_link" onclick="changedeactivateform(this, true)" class="disablerslink">Single user account</a> /
            <a href="javascript:;" id="multi_acc_link" onclick="changedeactivateform(this, false)" class="activerslink">Multiple user accounts</a>
        </div>
	<form name="deactivate" id="deactivate" class="zform" onsubmit="return deactivateAccount(this);" method="post" action="<%=request.getContextPath()%>/admin/deactivateaccount" target="deactivateaction" enctype="multipart/form-data"> <%-- NO OUTPUTENCODING --%>
	    <div class="labelmain">
		<div class="labelkey">Service Name :</div>
		<div class="labelvalue">
		    <select name="serviceName" class="select" id="servicehtml5" onchange="loadDeactivateOption();">
			<option value="select">----select----</option>
			<option value='all'>All Services</option>
			<%for(Service s: ss) { %>
    			<option value='<%=IAMEncoder.encodeHTMLAttribute(s.getServiceName())%>'><%=IAMEncoder.encodeHTML(s.getServiceName())%></option>
			<% } %>
		    </select>
		       <!-- html5 -->
		 <div class='canvascheck'>
			<input class="input" name="serviceName" list="services" onchange="loadDeactivateOption();" id='serviceslist'/>
		    <datalist id="services"> <%--No I18N--%>
			<%for(Service s: ss){%><option value='<%=IAMEncoder.encodeHTMLAttribute(s.getServiceName())%>'><%}%>
			<option value='all'><%--No I18N--%>
 			</datalist><%--No I18N--%>
 			<!-- html5 -->
 		</div>
		</div>
                <div id="single_acc">
                    <div class="labelkey">User Name (or) Email Address :</div>
                    <div class="labelvalue"><input type="text" name="user" class="input"/></div>
                </div>
                <div id="multi_acc" style="display:none;">
                    <div class="labelkey">Choose a file</div>
                    <div class="labelvalue">
                        <div><input type="file" name="file" id="file" class="input"/></div>
                        <div class="deactivate_help_div">
                            <span>1. Supported file format is .txt (contains only EmailAddress or Username or ZUID)</span><br>
                            <span>2. Maximum 50 user accounts can allowed attached txt file.</span>
                        </div>
                    </div>
                </div>
		<div class="labelkey" style="padding-top:4px;">Status :</div>
		<div class="labelvalue">
		    <select id="dropdown" name="enable" style="width: 220px;" class="select" >
		    	<option value="activate" selected="selected">Activate</option><%--No I18N--%>
		    	<option value="deactivate">Deactivate</option><%--No I18N--%>
		    </select>
		</div>
		<div class="labelkey">Comment :</div> <%--No I18N--%>
		<div><textarea class="labelvalue" name="comment"  rows="4" cols="30"></textarea></div>
		<div class="labelkey">Enter Admin password :</div>
		<div class="labelvalue"><input type="password" name="pwd" class="input"/></div>
		<div class="accbtn Hbtn">
		    <div class="savebtn" onclick="deactivateAccount(document.deactivate)">
			<span class="btnlt"></span>
			<span class="btnco">Submit</span>
			<span class="btnrt"></span>
		    </div>
		    <div onclick="loadservice();">
			<span class="btnlt"></span>
			<span class="btnco">Cancel</span>
			<span class="btnrt"></span>
		    </div>
		</div>
		<input type="submit" class="hidesubmit" />
                <input type="hidden" name="<%=SecurityUtil.getCSRFParamName(request)%>" value="<%=SecurityUtil.getCSRFCookie(request)%>"/> <%-- NO OUTPUTENCODING --%>
	    </div>
	</form>
        <span class="smalltxt" id="deactivate_resp_link" onclick="de('deactivate_resp').style.display='';" style="display:none;">
            <a href="javascript:;">Click here to view the results &raquo;</a>
        </span>
        <div id="deactivate_resp" style="display:none;"></div>
    </div>
</div>
<iframe name="deactivateaction" id="deactivateaction" class="hide" frameborder="0" height="0%" width="0%"></iframe>
