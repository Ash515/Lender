<%--$Id$--%>

<div class="maincontent">
    <div class="menucontent">
		<div class="topcontent"><div class="contitle" id="grouptitle">Clear Invite Restriction</div></div><%--No I18N--%>
		<div class="subtitle">Support Services</div><%--No I18N--%>
    </div>
    
    <div class="field-bg">
    
    	<div class="restorelink">
            <a href="javascript:;" id="dolink" onclick="showInviteClear(this, true)"class="disablerslink">Clear Invitation</a> / <%--No I18N--%>
            <a href="javascript:;" id="dufolink" onclick="showInviteClear(this, false)" class="activerslink">Clear AppAccount specfic Invitation</a> <%--No I18N--%>
        </div>
        
        <div id="clearinvitation">
           <form name="clearinv" class="zform" onsubmit="return clearInvitation(this);">
              	<div class="labelkey">Enter the ZOID : </div><%--No I18N--%>
				<div class="labelvalue"><input type="text" class="input" name="zoid" value='' placeholder='ZOID'></div>
				<div class="labelkey">Enter the User EMAIL: </div><%--No I18N--%>
				<div class="labelvalue"><input type="text" class="input" name="email" value='' placeholder='Email Address'></div>
				<div class="accbtn Hbtn">
					<div class="savebtn" onclick="clearInvitation(document.clearinv)">
						<span class="btnlt"></span> 
						<span class="btnco">Clear Restrictions</span><%--No I18N--%>
						<span class="btnrt"></span>
					</div>
					<div class="savebtn" onclick="document.clearinv.reset();">
						<span class="btnlt"></span> 
						<span class="btnco">Cancel</span><%--No I18N--%>
						<span class="btnrt"></span>
					</div>
				</div>
           </form>
        </div>
        
        
        <div id="clearinvitationdetails" style="display:none;">
          <form name="clearinvdet" class="zform" onsubmit="return clearInvitationDetails(this);">
              	<div class="labelkey">Enter the ZOID : </div><%--No I18N--%>
				<div class="labelvalue"><input type="text" class="input" name="zoid" value='' placeholder='ZOID'></div>
				<div class="labelkey">Enter the User Email : </div><%--No I18N--%>
				<div class="labelvalue"><input type="text" class="input" name="email" value='' placeholder='EmailAddress'></div>
	            <div class="labelkey">Enter the Appaccount Invitation ID : </div><%--No I18N--%>
				<div class="labelvalue"><input type="text" class="input" name="invid" value='' placeholder='AppAccount Invitation ID'></div>
				<div class="accbtn Hbtn">
					<div class="savebtn" onclick="clearInvitationDetails(document.clearinvdet)">
						<span class="btnlt"></span> 
						<span class="btnco">Clear Restrictions</span><%--No I18N--%>
						<span class="btnrt"></span>
					</div>
					<div class="savebtn" onclick="document.clearinvdet.reset();">
						<span class="btnlt"></span> 
						<span class="btnco">Cancel</span><%--No I18N--%>
						<span class="btnrt"></span>
					</div>
				</div>
          </form>
        </div>
    
    </div>
</div>