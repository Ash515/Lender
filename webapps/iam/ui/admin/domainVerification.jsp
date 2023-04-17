<%-- $Id$ --%>

<div class="maincontent">
    <div class="menucontent">
	<div class="topcontent"><div class="contitle">Domain Verification</div> </div><%--No I18N--%>
	<div class="subtitle">Admin Services</div> <%--No I18N--%>
    </div>
    <div class="field-bg">
	
	<div id="eDdomain" class="tfafield-body" style="display:block;background:none;border:none">
     <div class="labelkey">Enter Domain Name :</div> <%--No I18N--%>
     <div class="labelvalue"><input type="text" id="domain" required class="input"></div>
     <div class="labelkey">Reason :</div><%--No I18N--%>
	<div class="labelvalue"><textarea name="loginName" required class="textarea" id="reason" onfocus="clearsampletxt(this)" placeholder="Why manual verification is needed"></textarea></div><%--No I18N--%>
	<div class="labelkey">Validations done :</div><%--No I18N--%>
	<div class="labelvalue"><textarea name="loginName" required class="textarea" id="validations" onfocus="clearsampletxt(this)" placeholder="What are all the validations completed"></textarea></div><%--No I18N--%>
     <div class="labelkey">Verified : </div> <%--No I18N--%>
     <div class="labelvalue">
     <input type="radio" name="changeprefradio" id="isverified"  >
     <label for="enable">Yes</label> <%--No I18N--%>
     <input type="radio" name="changeprefradio" checked="checked" id="not_verified">
     <label for="disable">No</label> <%--No I18N--%>
     </div>
     <div class="accbtn Hbtn">
		    <div class="savebtn" onclick="verifyDomain();">
			<span class="btnlt"></span>
			<span class="btnco">Save</span> <%--No I18N--%>
			<span class="btnrt"></span>
		    </div>
		</div>
	</div>
	
    </div>
</div>
