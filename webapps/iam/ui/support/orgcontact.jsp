<%-- $Id$ --%>
<%@ include file="includes.jsp" %>
<div class="maincontent">
    <div class="menucontent">
		<div class="topcontent"><div class="contitle">Change Org Contact</div></div><%--No I18N--%>
		<div class="subtitle">Support Services</div><%--No I18N--%>
    </div>
    
    <div class="field-bg">
    	<div id="fetchorg">
			<form name="getzoid" class="zform" onsubmit="return getOrgDetails(this);">
				<div class="labelkey">Enter The ZOID : </div><%--No I18N--%>
				<div class="labelvalue"><input type="text" class="input" name="zoid" id="zoid" value='' placeholder='ZOID'></div>
				<div class="accbtn Hbtn">
					<div class="savebtn" onclick="getOrgDetails(document.getzoid)">
						<span class="btnlt"></span> 
						<span class="btnco">Fetch</span><%--No I18N--%>
						<span class="btnrt"></span>
					</div>
				</div>
			</form>
		</div>
    
    
    	<div id="orgdetailsdiv" style="display : none;">
    		<form name="orgdetails" class="zform" onsubmit="return updateOrgDetails(this);">
    			<div class="labelkey">ZOID : </div><%--No I18N--%>
				<div class="labelvalue"><input type="text" class="input noborder" name="zoid" value='' disabled='disabled'></div>
				<div class="labelkey">Current Org Contact : </div><%--No I18N--%>
				<div class="labelvalue"><input type="text" class="input noborder" name="oldcontact" value='' disabled='disabled'></div>
				<div class="labelkey">New Org Contact </div><%--No I18N--%>
				<div class="labelvalue"><input type="text" class="input" name="newcontact" value='' placeholder='Email Address'></div>
				<div class="accbtn Hbtn">
					<div class="savebtn" onclick="updateOrgDetails(document.orgdetails)">
						<span class="btnlt"></span> 
						<span class="btnco">Update</span><%--No I18N--%>
						<span class="btnrt"></span>
					</div>
					<div class="savebtn" onclick="document.getzoid.reset(); document.orgdetails.reset(); de('orgdetailsdiv').style.display='none'; de('fetchorg').style.display='block'">
						<span class="btnlt"></span> 
						<span class="btnco">Cancel</span><%--No I18N--%>
						<span class="btnrt"></span>
					</div>
				</div>
								
    		</form>
    	</div>
    </div>
</div>