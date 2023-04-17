<%-- $Id$ --%>
<%@ include file="includes.jsp" %>
<div class="maincontent">
    <div class="menucontent">
		<div class="topcontent"><div class="contitle" id="grouptitle">Delete Group</div></div><%--No I18N--%>
		<div class="subtitle">Support Services</div><%--No I18N--%>
    </div>
    
    <div class="field-bg">
    
        <div class="restorelink">
            <a href="javascript:;" id="dolink" onclick="showGroupOption(this, true)"class="disablerslink">Delete Group</a> / <%--No I18N--%>
            <a href="javascript:;" id="dufolink" onclick="showGroupOption(this, false)" class="activerslink">Delete User From Group</a> <%--No I18N--%>
        </div>
    
    	<div id="groupdeletediv">
			<form name="groupdelete" class="zform" onsubmit="return deleteGroup(this);">
				<div class="labelkey">Enter The ZGID/GroupEmail : </div><%--No I18N--%>
				<div class="labelvalue"><input type="text" class="input" name="zgid" value='' placeholder='ZGID/GroupEmail'></div>
				<div class="accbtn Hbtn">
					<div class="savebtn" onclick="deleteGroup(document.groupdelete)">
						<span class="btnlt"></span> 
						<span class="btnco">Delete Group</span><%--No I18N--%>
						<span class="btnrt"></span>
					</div>
					<div class="savebtn" onclick="document.groupdelete.reset();">
						<span class="btnlt"></span> 
						<span class="btnco">Cancel</span><%--No I18N--%>
						<span class="btnrt"></span>
					</div>
				</div>
			</form>
		</div>
		
		<div id="groupmemberdeletediv" style="display:none;">
			<form name="groupmemberdelete" class="zform" onsubmit="return deleteGroupMember(this);">
				<div class="labelkey">Enter The ZGID/GroupEmail : </div><%--No I18N--%>
				<div class="labelvalue"><input type="text" class="input" name="zgid" value='' placeholder='ZGID/GroupEmail'></div>
				<div class="labelkey">Enter The User Email : </div><%--No I18N--%>
				<div class="labelvalue"><input type="text" class="input" name="email" value='' placeholder='EmailAddress'></div>
	
				<div class="accbtn Hbtn">
					<div class="savebtn" onclick="deleteGroupMember(document.groupmemberdelete)">
						<span class="btnlt"></span> 
						<span class="btnco">Delete Group Member</span><%--No I18N--%>
						<span class="btnrt"></span>
					</div>
					<div class="savebtn" onclick="document.groupmemberdelete.reset();">
						<span class="btnlt"></span> 
						<span class="btnco">Cancel</span><%--No I18N--%>
						<span class="btnrt"></span>
					</div>
				</div>
			</form>
		</div>
		
    </div>
</div>