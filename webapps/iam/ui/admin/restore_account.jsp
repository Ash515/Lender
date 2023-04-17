<%-- $Id$ --%>
<%@ include file="includes.jsp" %>
<div class="maincontent">
    <div class="menucontent">
	<div class="topcontent"><div class="contitle" id="restoretitle">Restore Account</div></div>
	<div class="subtitle">Admin Services</div>
    </div>
    
    <div class="field-bg">

        <div class="restorelink">
            <a href="javascript:;" id="ralink" onclick="showrestorefrm(this, true)"class="disablerslink">Restore Account</a> /
            <a href="javascript:;" id="auolink" onclick="showrestorefrm(this, false)" class="activerslink">Assign User To Org</a>
        </div>
        
	<form name="restoreaccount" id="restoreaccount" class="zform" onsubmit="return restoreAccount(this);" method="post">
	    <div class="labelmain">
                <div class="labelkey">Enter ZUID of the User :</div>
		<div class="labelvalue"><input type="text" name="userid" class="input"/></div>
		<div class="labelkey">Enter Email Address :</div>
		<div class="labelvalue"><input type="text" name="email" class="input"/></div>
                <div class="labelkey">Enter Admin password :</div>
                <div class="labelvalue"><input type="password" class="input" name="pwd"/></div>
		<div class="accbtn Hbtn">
		    <div class="savebtn" onclick="restoreAccount(document.restoreaccount)">
			<span class="btnlt"></span>
			<span class="btnco">Restore Account</span>
			<span class="btnrt"></span>
		    </div>
		    <div onclick="document.assignuserorg.reset();">
			<span class="btnlt"></span>
			<span class="btnco">Cancel</span>
			<span class="btnrt"></span>
		    </div>
		</div>
		<input type="submit" class="hidesubmit" />
	    </div>
	</form>

        <form name="assignuserorg" id="assignuserorg" class="zform" onsubmit="return assignUserToOrg(this);" method="post" style="display:none;">
            <div class="labelmain">
                <div class="labelkey">Enter UserName or Email Address :</div>
                <div class="labelvalue"><input type="text" name="user" class="input"/></div>
                <div class="labelkey">Enter Organization Id :</div>
                <div class="labelvalue"><input type="text" name="zoid" class="input"/></div>
                <div class="labelkey">Enter Admin password :</div>
                <div class="labelvalue"><input type="password" class="input" name="pwd"/></div>
		<div class="accbtn Hbtn">
		    <div class="savebtn" onclick="assignUserToOrg(document.assignuserorg)">
			<span class="btnlt"></span>
			<span class="btnco">Assign</span>
			<span class="btnrt"></span>
		    </div>
		    <div onclick="document.assignuserorg.reset();">
			<span class="btnlt"></span>
			<span class="btnco">Cancel</span>
			<span class="btnrt"></span>
		    </div>
		</div>
		<input type="submit" class="hidesubmit" />
            </div>
        </form>
    </div>
</div>