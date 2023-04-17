<%-- $Id$ --%>
<%@ include file="includes.jsp" %>
<div class="maincontent">
    <div class="menucontent">
		<div class="topcontent"><div class="contitle">Email Digest</div></div><%--No I18N--%>
		<div class="subtitle">Support Services</div><%--No I18N--%>
    </div>    
	<div class="field-bg">
		<div id="email">
			<form class="zform" name="getEmail" method="post" onsubmit="return getEmailDigest(this);">
				<div class="labelkey">Enter the Email Address : </div><%--No I18N--%>
				<div class="labelvalue"><input type="text" class="input" name="email" placeholder="Email Address"></div>
				<div class="accbtn Hbtn">
					<div class="savebtn" onclick="getEmailDigest(document.getEmail)">
						<span class="btnlt"></span> 
						<span class="btnco">Fetch Digests</span><%--No I18N--%>
						<span class="btnrt"></span>
					</div>
				</div>
			</form>
		</div>
		
		<div id="digestDetails" style="display:none;">
		</div>
		
	</div>
</div>