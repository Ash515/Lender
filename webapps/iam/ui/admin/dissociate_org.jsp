<%-- $Id$ --%>
<%@ include file="includes.jsp" %>
<div class="maincontent">
    <div class="menucontent">
	<div class="topcontent"><div class="contitle" id="deletetitle">Delete ORG</div></div> <%--No I18N--%>
	<div class="subtitle">Admin Services</div> <%--No I18N--%>
    </div>
    
    <div class="field-bg">

        <div class="restorelink">
            <a href="javascript:;" id="dolink" onclick="showdeletefrm(this, true)"class="disablerslink">Delete ORG</a> / <%--No I18N--%>
            <a href="javascript:;" id="dufolink" onclick="showdeletefrm(this, false)" class="activerslink">Dissociate User from ORG</a> <%--No I18N--%>
        </div>
        
	<form name="deleteorg" id="deleteorg" class="zform" onsubmit="return deleteOrg(this);" method="post">
	    <div class="labelmain">
                <div class="labelkey">Enter EMAIL of the User :</div> <%--No I18N--%>
		<div class="labelvalue"><input type="text" name="emailid" class="input"/></div>               
		 <div class="labelkey">Enter Admin password :</div> <%--No I18N--%>
                <div class="labelvalue"><input type="password" class="input" name="pwd"/></div>
		<div class="accbtn Hbtn">
		    <div class="savebtn" onclick="deleteOrg(document.deleteorg)">
			<span class="btnlt"></span>
			<span class="btnco">Delete ORG</span> <%--No I18N--%>
			<span class="btnrt"></span>
		    </div>
		    <div onclick="document.deleteorg.reset();">
			<span class="btnlt"></span>
			<span class="btnco">Cancel</span> <%--No I18N--%>
			<span class="btnrt"></span>
		    </div>
		</div>
		<input type="submit" class="hidesubmit" />
	    </div>
	</form>

        <form name="dissociateuserfromorg" id="dissociateuserfromorg" class="zform" onsubmit="return dissociateUserFromOrg(this);" method="post" style="display:none;">
            <div class="labelmain">
                <div class="labelkey">Enter Email Address :</div> <%--No I18N--%>
                <div class="labelvalue"><input type="text" name="user" class="input"/></div>
                <div class="labelkey">Enter Admin password :</div> <%--No I18N--%>
                <div class="labelvalue"><input type="password" class="input" name="pwd"/></div>
		<div class="accbtn Hbtn">
		    <div class="savebtn" onclick="dissociateUserFromOrg(document.dissociateuserfromorg)">
			<span class="btnlt"></span>
			<span class="btnco">Dissociate</span> <%--No I18N--%>
			<span class="btnrt"></span>
		    </div>
		    <div onclick="document.dissociateuserfromorg.reset();">
			<span class="btnlt"></span>
			<span class="btnco">Cancel</span> <%--No I18N--%>
			<span class="btnrt"></span>
		    </div>
		</div>
		<input type="submit" class="hidesubmit" />
            </div>
        </form>
    </div>
</div>