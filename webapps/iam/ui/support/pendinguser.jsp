<%-- $Id$ --%>
<%@ include file="includes.jsp" %>
<div class="maincontent">
    <div class="menucontent">
		<div class="topcontent"><div class="contitle" id="grouptitle">Delete Pending User</div></div><%--No I18N--%>
		<div class="subtitle">Support Services</div><%--No I18N--%>
    </div>
    
    <div class="field-bg">
        <div id="pendinguserdiv">
			<form name="pendinguser" class="zform" onsubmit="return deletePendingUser(this);">
				<div class="labelkey">Enter The ZAID : </div><%--No I18N--%>
				<div class="labelvalue"><input type="text" class="input" name="zoid" value='' placeholder='ZAID'></div>
				<div class="labelkey">Enter The Invited User Email : </div><%--No I18N--%>
				<div class="labelvalue"><input type="text" class="input" name="email" value='' placeholder='EmailAddress'></div>
				<div class="accbtn Hbtn">
					<div class="savebtn" onclick="deletePendingUser(document.pendinguser)">
						<span class="btnlt"></span> 
						<span class="btnco">Delete User</span><%--No I18N--%>
						<span class="btnrt"></span>
					</div>
					<div class="savebtn" onclick="document.pendinguser.reset();">
						<span class="btnlt"></span> 
						<span class="btnco">Cancel</span><%--No I18N--%>
						<span class="btnrt"></span>
					</div>
				</div>
			</form>
		</div>
    
    
    </div>
</div>