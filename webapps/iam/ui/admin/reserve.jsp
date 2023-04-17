<%-- $Id$ --%>
<%@ include file="includes.jsp" %>
<div class="maincontent">
    <div class="menucontent">
	<div class="topcontent"><div class="contitle">Reserve</div></div>
	<div class="subtitle">Admin Services</div>
    </div>

    <div class="field-bg">
	<form name="reserve" id="reserve" class="zform" onsubmit="return reserveUser(this);" method="post">
	    <div class="labelmain">
		<div class="labelkey">User Name :</div>
		<div class="labelvalue">
		    <input type="text" name="user" class="input"/>
		</div>
		<div class="labelkey" style="padding-top:4px;">Action :</div>
		<div class="labelvalue">
		    <input type="radio" name="action" class="activateradio">
		    <div class="fllt">Reserve</div>
		    <input type="radio" name="action" class="inactivateradio">
		    <div>Unreserve</div>
		</div>
		<div class="labelkey">Enter Admin password :</div>
		<div class="labelvalue"><input type="password" class="input" name="pwd"/></div>
		<div class="accbtn Hbtn">
		    <div class="savebtn" onclick="reserveUser(document.reserve)">
			<span class="btnlt"></span>
			<span class="btnco">Submit</span>
			<span class="btnrt"></span>
		    </div>
		    <div onclick="loadservice()">
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
