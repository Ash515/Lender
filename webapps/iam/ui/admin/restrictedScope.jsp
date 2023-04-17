<%@page import="com.adventnet.iam.internal.Util"%>
<div class="maincontent">
    <div class="menucontent">
        <div class="topcontent"><div class="contitle" id="restoretitle">Restricted Scope Addition</div></div> <%--No I18N--%>
	<div class="subtitle">Admin Services</div> <%--No I18N--%>
    </div>
     <div class="field-bg">
     <div class="restorelink">
            <a href="javascript:;" id="addlink" onclick="showrestrictedfrm(this, true)"class="disablerslink">Add Restricted Scope</a>/ <%--No I18N--%>
            <a href="javascript:;" id="dellink" onclick="showrestrictedfrm(this, false)" class="activerslink">Delete Restricted Scopes</a><%--No I18N--%>
        </div>   
	<form name="addScope" id="addScope" class="zform" onsubmit="return addRestrictedScope(this);" method="post">
	      <div class="labelmain">
		<div class="labelkey">User Email Id :</div><%--No I18N--%>
		<div class="labelvalue"><input type="text" name="userEmail" class="input"/></div>
		<div class="labelkey">is Api Key :</div>  <%--No I18N--%>
		<div class="labelvalue" style="padding:6px 0px;"><input name="isApiKey" class="check" type="checkbox" ></div>
		<div class="labelkey">Scopes :(Seperated by comma)</div><%--No I18N--%>
		<div class="labelvalue"><input type="text" class="input" name="scope"/></div>
		<div class="accbtn Hbtn">
		    <div class="savebtn" onclick="addRestrictedScope(document.addScope)">
			<span class="btnlt"></span>
			<span class="btnco"><%=Util.getI18NMsg(request,"IAM.ADD")%></span>
			<span class="btnrt"></span>
		    </div>
		    <div onclick="loadservice();">
			<span class="btnlt"></span>
			<span class="btnco"><%=Util.getI18NMsg(request,"IAM.CANCEL")%></span>
			<span class="btnrt"></span>
		    </div>
		</div>
		<input type="submit" class="hidesubmit" />
	    </div>
	</form>
	
	<form name="delScope" id="delScope" class="zform" onsubmit="return deleteRestrictedScope(this);" method="post" style="display:none;">
	      <div class="labelmain">
		<div class="labelkey">User Email Id :</div><%--No I18N--%>
		<div class="labelvalue"><input type="text" name="userEmail" class="input"/></div>
		<div class="labelkey">is Api Key :</div>  <%--No I18N--%>
		<div class="labelvalue" style="padding:6px 0px;"><input name="isApiKey" class="check" type="checkbox" ></div>
		<div class="labelkey">Scopes :(Seperated by comma)</div><%--No I18N--%>
		<div class="labelvalue"><input type="text" class="input" name="scope"/></div>
		<div class="accbtn Hbtn">
		    <div class="savebtn" onclick="deleteRestrictedScope(document.delScope)">
			<span class="btnlt"></span>
			<span class="btnco"><%=Util.getI18NMsg(request,"IAM.REMOVE")%></span>
			<span class="btnrt"></span>
		    </div>
		    <div onclick="loadservice();">
			<span class="btnlt"></span>
			<span class="btnco"><%=Util.getI18NMsg(request,"IAM.CANCEL")%></span>
			<span class="btnrt"></span>
		    </div>
		</div>
		<input type="submit" class="hidesubmit" />
	    </div>
	</form>
    </div>
    </div>