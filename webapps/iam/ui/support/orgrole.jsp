<%-- $Id$ --%>
<%@ include file="includes.jsp" %>
<div class="maincontent">
    <div class="menucontent">
		<div class="topcontent"><div class="contitle">Org Role Change</div></div><%--No I18N--%>
		<div class="subtitle">Support Services</div><%--No I18N--%>
    </div>
    
    
	<div class="field-bg">
		<div name='changerole'>
			<form name="getzuid" class="zform" onsubmit="return changeUserRole(this);">
				<div class="labelkey">Enter The ZUID : </div><%--No I18N--%>
				<div class="labelvalue"><input type="text" class="input" name="zuid" id="zuid" placeholder='ZUID' value=''></div>
				<div class="labelkey">Select The Role : </div><%--No I18N--%>
				<div class="labelvalue">
					<select name='role' class='select'>
						<option value=''>Select The ROLE</option><%--No I18N--%>
						<option value='0'>User</option><%--No I18N--%>
						<option value='1'>Admin</option><%--No I18N--%>
						<option value='2'>Super Admin</option><%--No I18N--%>
					</select>
				</div>
				<div class="accbtn Hbtn">
					<div class="savebtn" onclick="changeUserRole(document.getzuid)">
						<span class="btnlt"></span> 
						<span class="btnco">Change Role</span><%--No I18N--%>
						<span class="btnrt"></span>
					</div>
				</div>
			</form>
		</div>
	</div>
</div>