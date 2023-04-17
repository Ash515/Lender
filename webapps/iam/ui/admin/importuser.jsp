<%-- $Id$ --%>
<%@ page import="com.adventnet.iam.security.SecurityUtil"%>
<%@ include file="includes.jsp" %>
<div class="maincontent">
    <div class="menucontent" id="headerdiv">
	<div class="topcontent"><div class="contitle">Import User</div></div>
	<div class="subtitle">Admin Services</div>
    </div>

    <div class="field-bg">
	<div id="overflowdiv">
	<form method="post" class="zform" action="<%=request.getContextPath()%>/admin/importuser" target="uploadaction" enctype="multipart/form-data" id="importuser" name="importuser" onsubmit="return importUser(this);"> <%-- NO OUTPUTENCODING --%>
	    <div class="labelmain">
		<div class="labelkey">Import User :</div>
		<div class="labelvalue">
		    <input type="file" name="file" id="file" class="input"/>
		    <div class="labelvalue">(Supported file formats: .csv)</div>
		</div>
		<div class="labelkey">Import Type :</div>
		<div class="labelvalue">
                    <select class="select" onchange="changeImportType(this)">
                        <option value="personal" selected>Personal</option>
                        <option value="org">Org</option>
                    </select>
		</div>
		<div id="importusertype" style="display:none;">
                    <div class="labelkey">ZOID :</div>
                    <div class="labelvalue">
                        <input type="text" name="zoid" class="input"/>
                    </div>
                </div>
		<div class="labelkey">Is Confirmed :</div>
		<div class="labelvalue" style="padding:6px 0px;">
                    <input type="checkbox" name="isconfirm" class="check"/>
		</div>
	    </div>
	    <div class="accbtn Hbtn">
		<div class="savebtn" onclick="importUser(document.importuser)">
		    <span class="btnlt"></span>
		    <span class="btnco">Import</span>
		    <span class="btnrt"></span>
		</div>
		<div onclick="loadservice();">
		    <span class="btnlt"></span>
		    <span class="btnco">Cancel</span>
		    <span class="btnrt"></span>
		</div>
	    </div>
	    <input type="submit" class="hidesubmit" />
	    <input type="hidden" name="<%=SecurityUtil.getCSRFParamName(request)%>" value="<%=SecurityUtil.getCSRFCookie(request)%>"/> <%-- NO OUTPUTENCODING --%>
	    
	    <div id="details" style="display:none;">
		<a href="javascript:;" onclick="de('result').style.display='';">Details &raquo;</a>
	    </div>
	    <div id="result" style="display:none;"></div>
	</form>
            
	<div id="note">
	    <span class="fieldtitle">Importing Fields are :-</span>
	    <ol>
		<li>EMAIL_ID  - Email Address of the User (<font color='#F60000'>Mandatory</font>)</li> <%--No I18N--%>
		<li>LOGIN_ID  - Login Id of the User</li>
		<li>PASSWORD  - Password of the User</li>
		<li>FULL_NAME - FullName of the User</li>
                <li>DISPLAY_NAME - Display name of the User. If it is not present FULL_NAME will set as DISPLAY_NAME</li>
                <li>COUNTRY - User's country</li>
                <li>LANGUAGE - User's language</li>
                <li>TIMEZONE - User's timezone</li>
                <li>IPADDRESS - Requested ipAddress</li>
                <li>REFERRER - Referrer of the User</li>
	    </ol>

	    <span class="fieldtitle">Note :-</span>
	    <div class="fieldnotes">If LOGIN_ID or PASSWORD or FULL_NAME of the User is Empty,then Empty feild are filled by before the '@' part of Email Address.</div> <%--No I18N--%>
	    <span class="fieldtitle">Example :-</span>
	    <div class="fieldsample">
		    <div>If LOGIN_ID and PASSWORD and FULL_NAME of the User(xyz@zohocorp.com) is Empty.</div>
		    <div>LOGIN_ID  = xyz</div>
		    <div>PASSWORD  = xyz</div>
		    <div>FULL_NAME = xyz</div>
	    </div>
	</div>
	</div>
    </div>
</div>
<iframe name="uploadaction" id="uploadaction" class="hide" frameborder="0" height="0%" width="0%"></iframe>
