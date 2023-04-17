<%-- $Id$ --%>
<%@ include file="includes.jsp" %>
<div class="maincontent">
    <div class="menucontent">
	<div class="topcontent"><div class="contitle">Confirm Client UserEmail</div></div> <%--No I18N--%>
	<div class="subtitle">Admin Services</div> <%--No I18N--%>
    </div>

    <div class="field-bg">
	<form name="confirmemail" id="confirmemail" class="zform" onsubmit="return confirmEmail(this);" method="post">
	    <div class="labelmain">
		<div class="labelkey">Enter Zuid :</div><%--No I18N--%> 
		<div class="labelvalue"><input type="text" name="zuid" class="input"/></div>
		<div class="labelkey">Enter Zaid :</div><%--No I18N--%> 
		<div class="labelvalue"><input type="text" name="zaid" class="input"/></div>
	
		<div class="accbtn Hbtn">
		    <div class="savebtn" onclick='confirmClientUserEmail(document.confirmemail)'>
			<span class="btnlt"></span>
			<span class="btnco">Generate Link</span> <%--No I18N--%>
			<span class="btnrt"></span>
		    </div>
		    <div onclick="loadui('/ui/admin/clientuseremailconfirm.jsp')">
			<span class="btnlt"></span>
			<span class="btnco">Cancel</span> <%--No I18N--%>
			<span class="btnrt"></span>
		    </div>
		</div>
		<input type="submit" class="hidesubmit" />
			</div>
			<div class='resetoptionlink'>
		 <div class="resetusercontainer">Email Address : <span id="confirmuser"></span></div><%--No I18N--%>
		<textarea readonly id="resetpasswordurl" onclick="this.focus();this.select()"></textarea>
	    </div>
	</form>
    </div>
</div>
