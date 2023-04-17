<%-- $Id$ --%>
<%@ include file="includes.jsp" %>
<div class="maincontent">
    <div class="menucontent">
		<div class="topcontent"><div class="contitle">Security Questions</div></div><%--No I18N--%>
		<div class="subtitle">Support Services</div><%--No I18N--%>
    </div>
    
    
	<div class="field-bg">
		<div id="securityqadiv">
			<form method="post" class="zform" onsubmit="return getSecurityqa(this);" name="securityqa" style="display : block;">
				<div class="labelkey">Enter UserName or Email Address : </div><%--No I18N--%>
				<div class="labelvalue"><input type="text" class="input" name="email" placeholder="EmailAddress/UserName"></div>
				<div class="accbtn Hbtn">
					<div class="savebtn" onclick="getSecurityqa(document.securityqa)">
						<span class="btnlt"></span> 
						<span class="btnco">Fetch Details</span><%--No I18N--%>
						<span class="btnrt"></span>
					</div>
				</div>
			</form>
		</div>
		
		<div id="securityqainfo">
			<form method="post" style="display : none;" class="zform" onsubmit="return deleteSecurityqa(this);" name="deletesecurityqa">
				<div class="labelkey">Email Address : </div><%--No I18N--%>
				<div class="labelvalue"><input type="text" class="input noborder" name="email" disabled="true"></div>
				<div class="labelkey">ZUID : </div><%--No I18N--%>
				<div class="labelvalue"><input type="text" class="input noborder" name="zuid" disabled="true"></div>
				<div class="labelkey">Question : </div><%--No I18N--%>
				<div class="labelvalue"><input type="text" class="input noborder" name="question" disabled="true"></div>
				<div class="labelkey">Answer : </div><%--No I18N--%>
				<div class="labelvalue"><input type="text" class="input noborder" name="answer" disabled="true"></div>
				<div class="accbtn Hbtn">
					<div class="savebtn" onclick="deleteSecurityqa(document.deletesecurityqa)">
						<span class="btnlt"></span> 
						<span class="btnco">Delete</span><%--No I18N--%>
						<span class="btnrt"></span>
					</div>
					<div class="savebtn" onclick="document.deletesecurityqa.reset(); document.deletesecurityqa.style.display='none'; document.securityqa.style.display='block';">
						<span class="btnlt"></span> 
						<span class="btnco">Cancel</span><%--No I18N--%>
						<span class="btnrt"></span>
					</div>
				</div>					
			</form>
		</div>

	</div>
</div>