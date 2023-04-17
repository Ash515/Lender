<%-- $Id$ --%>
<%@ include file="includes.jsp" %>
<div class="maincontent">
    <div class="menucontent">
		<div class="topcontent"><div class="contitle">User Mobile and ScreenName</div></div><%--No I18N--%>
		<div class="subtitle">Support Services</div><%--No I18N--%>
    </div>    
    
    <div class="field-bg">
    	
    	<div id="email">
			<form class="zform" name="getEmail" method="post" onsubmit="return getScreenMobile(this);">
				<div class="labelkey">Enter UserName or Email Address : </div><%--No I18N--%>
				<div class="labelvalue"><input type="text" class="input" name="email" placeholder="EmailAddress/UserName"></div>
				<div class="accbtn Hbtn">
					<div class="savebtn" onclick="getScreenMobile(document.getEmail)">
						<span class="btnlt"></span> 
						<span class="btnco">Fetch Details</span><%--No I18N--%>
						<span class="btnrt"></span>
					</div>
				</div>
			</form>
		</div>
    
   		<div id="screenname" style="display:none">
    	</div>

		<div id="usermobile" style="display:none">
		</div>
    
    </div>
</div>