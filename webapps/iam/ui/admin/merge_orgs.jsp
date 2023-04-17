<div class="maincontent">
    <div class="menucontent">
	<div class="topcontent"><div class="contitle" id="deletetitle">Merge ORG</div></div> <%--No I18N--%>
	<div class="subtitle">Admin Services</div> <%--No I18N--%>
    </div>
	
	<div id="getDetailsdiv">
<form name="fetchOrgdetail" id="fetchOrgdetail" class="zform" onsubmit="return fetchOrgdetails(this);" method="post">
	    <div class="labelmain">
                <div class="labelkey">Enter from Org ID :</div> <%--No I18N--%>
		<div class="labelvalue"><input type="text" name="fromOrgId" class="input"/></div>               
		 <div class="labelkey">Enter To Org Id :</div> <%--No I18N--%>
                <div class="labelvalue"><input type="text" class="input" name="toOrgId"/></div>
		<div class="accbtn Hbtn">
		    <div class="savebtn" onclick="fetchOrgdetails(document.fetchOrgdetail)">
			<span class="btnlt"></span>
			<span class="btnco">Fetch Details</span> <%--No I18N--%>
			<span class="btnrt"></span>
		    </div>
		</div>
		<input type="submit" class="hidesubmit" />
	    </div>
	</form>
</div>
<div id="showDetailsdiv" style="display: none;">
 <form name="mergeOrgdetailfrm" class="zform" method="post" onsubmit="return mergeOrgdetails(this);">
 <div class="labelmain">
               <div class="labelkey">From Org ID :</div> <%--No I18N--%>
		<div class="labelvalue"><input type="text" id="idsfromOrgId" name="fromOrgId" class="input noborder" disabled="disabled"/></div>               
		 <div class="labelkey">To Org Id :</div> <%--No I18N--%>
                <div class="labelvalue"><input type="text" id="idstoOrgId"  class="input noborder" name="toOrgId" disabled="disabled"/></div>
                <div class="labelkey">From Org Name :</div> <%--No I18N--%>
                <div class="labelvalue"><input type="text" id="idsfromorgName"  class="input noborder" name="fromorgName" disabled="disabled"/></div>
                <div class="labelkey">From Org Contact :</div> <%--No I18N--%>
                <div class="labelvalue"><input type="text" id="idsfromOrgContact" class="input noborder" name="fromOrgContact" disabled="disabled"/></div>
                <div class="labelkey">From Org Groups :</div> <%--No I18N--%>
                <div class="labelvalue"><input type="text" id="idsfromorggroup" class="input noborder" name="fromorggroup" disabled="disabled"/></div>
                <div class="labelkey">From Org Domains :</div> <%--No I18N--%>
                <div class="labelvalue"><input type="text" id="idsfromorgdomain" class="input noborder" name="fromorgdomain" disabled="disabled"/></div>
                <div class="labelkey">From Org Domains :</div> <%--No I18N--%>
                <div class="labelvalue"><input type="text" id="idsfromorgdomain" class="input noborder" name="fromorgdomain" disabled="disabled"/></div>
                
                <div class="labelkey">To Org Name :</div> <%--No I18N--%>
                <div class="labelvalue"><input type="text" id="idstoorgName" class="input noborder" name="toorgName" disabled="disabled"/></div>
                <div class="labelkey">To Org Contact :</div> <%--No I18N--%>
                <div class="labelvalue"><input type="text" id="idstoOrgContact" class="input noborder" name="toOrgContact" disabled="disabled"/>
                </div>
                <div class="labelkey">Retain Org Role :</div> <%--No I18N--%>
                <div class="labelvalue"><input type="checkbox" id="idsisExposed" class="check" name="retailRole"/></div>
			<div class="labelkey" style="padding: 5px 5px 5px 0">DataLoss AppAccount  :</div> <%--No I18N--%>
	        <div class="labelvalue"><input type="text" id="idsdataLossappacc" class="input noborder" name="dataLossappacc" disabled="disabled"/></div>
	        <div class="labelkey">Manitory AppAccount  :</div> <%--No I18N--%>
	        <div class="labelvalue"><input type="text" id="idsmantappacc" class="input noborder" name="mantLossappacc" disabled="disabled"/></div> <%--No I18N--%>
	        <div class="labelkey">Migrated to Org ServiceOrgs  :</div> <%--No I18N--%>
	        <div class="labelvalue"><input type="text" id="idsmigorgappacc" class="input noborder" name="migorgappacc" disabled="disabled"/> <div style="display:inline; font-size:11.5px; color:gray; margin-left:10%;"> --- If IP_RESTRICTION is enabled, user has to enable IP_RESTRICTION again in new org</div></div> <%--No I18N--%>
	        
	         <div class="labelkey">Admin Password :</div> <%--No I18N--%>
				<div class="labelvalue"><input type="password" id="adminpassid" name="aminpass" class="input" /></div>
		<div class="labelkey">Select Appaccounts to migrate :</div> <%--No I18N--%>
         <select name="subIds" id="idsappaccs" data-placeholder="Select AppAccounts to merge" style="width:350px;" class="chosen-mergeorg-admin-select labelvalue" multiple tabindex="6">
          
		</select>
		<div class="accbtn Hbtn">
		    <div class="savebtn" onclick="mergeOrgdetails(document.mergeOrgdetailfrm)">
			<span class="btnlt"></span>
			<span class="btnco">Merge</span><%--No I18N--%>
			<span class="btnrt"></span>
		    </div>
		    <div onclick="loadui('/ui/admin/merge_orgs.jsp')">
			<span class="btnlt"></span>
			<span class="btnco">Cancel</span> <%--No I18N--%>
			<span class="btnrt"></span>
		    </div>
		</div>
		<input type="submit" class="hidesubmit" />
	    </div>
	</form>
</div>

<div id="resultDetailsdiv" style="display: none;">
 <div class="labelmain">
               <div class="labelkey">Users Migrated :</div> <%--No I18N--%>
		<div class="labelvalue"><input type="text" id="idsusrmig" name="usrmig" class="input" disabled="disabled"/></div>               
		 <div class="labelkey">AppAccount Migrated :</div> <%--No I18N--%>
                <div class="labelvalue"><input type="text" id="idsappaccmig"  class="input" name="appaccmig" disabled="disabled"/></div>
                <div class="labelkey">AppAccount Skiped :</div> <%--No I18N--%>
                <div class="labelvalue"><input type="text" id="idsappaccskp"  class="input" name="idsappaccskp" disabled="disabled"/></div>
                <div class="labelkey">Groups Migrated :</div> <%--No I18N--%>
                <div class="labelvalue"><input type="text" id="idsgrpmig" class="input" name="grpmig" disabled="disabled"/></div>
                <div class="labelkey">Domains Migrated :</div> <%--No I18N--%>
                <div class="labelvalue"><input type="text" id="idsdomainmig" class="input" name="domainmig" disabled="disabled"/></div>
		<div class="accbtn Hbtn">
		    <div onclick="loadui('/ui/admin/merge_orgs.jsp')">
			<span class="btnlt"></span>
			<span class="btnco">OK</span> <%--No I18N--%>
			<span class="btnrt"></span>
		    </div>
		</div>
		<input type="submit" class="hidesubmit" />
	    </div>
</div>
	
</div>