<%-- $Id$ --%>
<%@page import="com.zoho.accounts.AccountsProto.Account.Digest"%>
<%@page import="com.zoho.accounts.Accounts.RESOURCE.DIGEST"%>
<%@page import="com.zoho.resource.Criteria"%>
<%@page import="com.zoho.accounts.Accounts"%>
<%@page import="com.zoho.accounts.Accounts.DigestURI"%>
<%@page import="com.zoho.accounts.AccountsConstants"%>
<%@page import="com.zoho.accounts.AccountsProto.Account.Digest"%>
<%@ include file="includes.jsp" %>
<%
    String value = request.getParameter("val");
	String type = request.getParameter("type");
	value = Util.isValid(value) ? value : "";
%>

<div class="menucontent">
	<div class="topcontent"><div class="contitle">Digest Info</div></div><%--No I18N--%>
	<div class="subtitle">Admin Services</div><%--No I18N--%>
</div>
<div class="maincontent">
    <div class="field-bg">
    	<div class="restorelink">
            <a href="javascript:;" id="plain_text_digest_link" onclick="showDigestForm(this, false)" class="disablerslink">PlainText Digest Info</a> /	<%--No I18N--%>
            <a href="javascript:;" id="encrypted_digest_link" onclick="showDigestForm(this, true)" class="activerslink">Encrypted Digest Info</a>	<%--No I18N--%>
        </div>
		<div class="labelmain" id="searchDigest">
			<div class="labelkey">
	    		<select id="mode" class="inputSelect chosen-select unauthinputSelect-tfa" style="background-color: white;width: 98px;b;background-position-x: 19px;">
	    			<option value="ZID" <%if("ZID".equals(type)){ %>selected<%} %>>ZID</option> <%--No I18N--%>
	    			<option value="EMAIL" <%if("EMAIL".equals(type)){ %>selected<%} %>>EmailId</option> <%--No I18N--%>
	    			<option value="DIGEST" <%if("DIGEST".equals(type)){ %>selected<%} %>>Digest</option> <%--No I18N--%>
	    		</select>
	    	</div>
		    <div class="searchfielddiv">
	                <input type="text" name="search" id="search" style="height:22px;margin: 3px;" value="<%=IAMEncoder.encodeHTMLAttribute(value)%>" class="input" onmouseover="this.focus()" onkeypress="if(event.keyCode == 13){ searchDigest(false);return false;}"/>
		    </div>
		    <div class="Hbtn searchbtn">
			<div class="savebtn" onclick="searchDigest(false)" style="position:  relative;top: 7px;">
				<span class="btnlt"></span>
				<span class="btnco">Search</span> <%--No I18N--%>
				<span class="btnrt"></span>
			</div>
		    </div>
		</div>
		<div class="labelmain" id="decryptDigest" style="display: none;">
			<div class="labelkey" style="padding: 11px 5px 2px 0px;"> Enter the digest : </div> <%--No I18N--%>
			<div class="searchfielddiv">
	                <input type="text" name="search1" id="search1" style="height:22px;margin: 3px;" value="<%=IAMEncoder.encodeHTMLAttribute(value)%>" class="input" onmouseover="this.focus()" onkeypress="if(event.keyCode == 13){ searchDigest(true);return false;}"/>
		    </div>
		    <div class="Hbtn searchbtn">
			<div class="savebtn" onclick="searchDigest(true)" style="position:  relative;top: 7px;">
				<span class="btnlt"></span>
				<span class="btnco">Search</span> <%--No I18N--%>
				<span class="btnrt"></span>
			</div>
		</div>
    </div>
</div>
<% if (Util.isValid(value)) {
		if(type != null) {
			DigestURI digestURI = Accounts.getDigestURI(AccountsConstants.SYSTEM_SPACE);
			Criteria criteria;
			if (type.equals("ZID")) {
				criteria = new Criteria(DIGEST.ZID,value);
			} else if (type.equals("EMAIL")) {
				criteria = new Criteria(DIGEST.EMAIL_ID,value);
			} else {
				criteria = new Criteria(DIGEST.DIGEST,CryptoUtil.encrypt(com.adventnet.iam.internal.Util.IAM_SECRET_KEYLABEL, value));
			}
			digestURI = (Accounts.DigestURI)digestURI.getQueryString().setCriteria(criteria).setOrderBy(DIGEST.CREATED_TIME.toString(), false).setLimit(1, 25).build();
			Digest[] digestObj = digestURI.GETS();  %>
			<div class="usrinfomaindiv" id = "digestInfo">
			<% if (digestObj != null) { %>
			    	<div id="userinfo">
			    		<table class="usremailtbl" cellpadding="4">
		    				<tr>
		    					<td class="usrinfoheader">ZID</td> <%--No I18N--%>
								<td class="usrinfoheader">Email Address</td> <%--No I18N--%>
								<td class="usrinfoheader">Digest Type</td> <%--No I18N--%>
								<td class="usrinfoheader">Encrypted Digest</td> <%--No I18N--%>
								<td class="usrinfoheader">Is Validated</td> <%--No I18N--%>
								<td class="usrinfoheader">Created Time</td> <%--No I18N--%>
								<td class="usrinfoheader">Expiry Time</td> <%--No I18N--%>
		    				</tr>
		    				<% for (Digest digest : digestObj) { %>
		    				<tr>
		    					<td class="usremailtd"><%=digest.getZid()%></td> <%-- NO OUTPUTENCODING --%>
	                			<td class="usremailtd"><%=IAMEncoder.encodeHTML(digest.getEmailId())%></td>
								<td class="usremailtd"><%=digest.getDigestType()%></td> <%-- NO OUTPUTENCODING --%>
								<td class="usremailtd"><%=digest.getDigest()%></td> <%-- NO OUTPUTENCODING --%>
								<td class="usremailtd"><%=digest.getIsValidated()%></td> <%-- NO OUTPUTENCODING --%>
								<td class="usremailtd"><%=digest.getCreatedTime() != -1 ? new Date(digest.getCreatedTime()) : ""%></td><%-- NO OUTPUTENCODING --%>
								<td class="usremailtd"><%=digest.getExpiryTime() != -1 ? new Date(digest.getExpiryTime()) : ""%></td><%-- NO OUTPUTENCODING --%>
		    				</tr>
		    				<%} %>
		    			</table>
		    		</div>
			<% } else { %>
					<div class="nosuchusr">
						<p align="center"> Digest not available, Might be deleted.</p><%--No I18N--%>
					</div>
			<% } 
			if (type.equals("DIGEST")) {%>
				<table class="usrinfotbl">
					<tr>
						<td>
						    <table cellpadding="3">
								<tr>
								    <td class="usrinfotdlt">Encrypted Digest</td> <%--No I18N--%>
								    <td class="usrinfotdrt"><%=CryptoUtil.encrypt(com.adventnet.iam.internal.Util.IAM_SECRET_KEYLABEL, value)%></td><%-- NO OUTPUTENCODING --%>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			<% } %>
			</div>
			<% } else {
				String decryptedValue;
				try {
					decryptedValue = CryptoUtil.decrypt(com.adventnet.iam.internal.Util.IAM_SECRET_KEYLABEL, value);
			    } catch(Exception e) {
			    	decryptedValue = e.toString();
			    }%>
				<table class="usrinfotbl" id = "decryptedDigest">
				<tr>
					<td>
					    <table cellpadding="3">
							<tr>
							    <td class="usrinfotdlt">Decrypted Digest</td> <%--No I18N--%>
							    <td class="usrinfotdrt"><%=decryptedValue%></td><%-- NO OUTPUTENCODING --%>
							</tr>
						</table>
					</td>
				</tr>
				</table>
	<%
		}
	}
	%>
