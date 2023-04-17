<%-- $Id: $ --%>
<%@page import="com.zoho.accounts.internal.oauth2.OAuth2Util"%>
<%@page import="com.zoho.accounts.dcl.DCLUtil"%>
<%@ include file="includes.jsp"%> 
<%@page import="com.adventnet.iam.xss.IAMEncoder"%>
<%@page import="com.zoho.accounts.SystemResourceProto.DCLocation"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<HTML>     
<body>
<div class="maincontent">
    <div class="menucontent">
		<div class="topcontent" style="border-bottom:1px solid #dfdfdf"><div class="contitle">Auth to OAuth Conversion API Configuration</div></div>	<%--No I18N--%>
    </div> 
	<div class="field-bg">	
		<form id="auth2oauthconfigform" name="auth2oauthconfigform" method="post">
			<div class="labelmain">
			    <div class="labelkey">Enter Client ID : </div>	<%--No I18N--%>
				<div class="labelvalue">
					<input type="text" size="20" name="clientid" id="clientid" maxlength="200"/>
				</div>
				<div class="labelkey">Enter Auth Scopes : </div>  <%--No I18N--%>
		        <div class="labelvalue">
		            <textarea style="font-size:10px;" name="authscopes" rows="5" cols="30" placeholder="eg: servicename.scopename <comma-separated> <no white spaces allowed>"></textarea> <%--No I18N--%>
				</div>
				<div class="labelkey">Enter OAuth Scopes : </div>	<%--No I18N--%>
				<div class="labelvalue">
					<textarea style="font-size:10px;" name="oauthscopes" rows="5" cols="50" placeholder="eg: servicename.scopename.operation_type <comma-separated> <no white spaces allowed>"></textarea> <%--No I18N--%>
				</div>
			    <div>
			    <div class="labelkey">Enter API Expiry Time ( in number of days) : </div>  <%--No I18N--%>
			    <div class="labelvalue">
	                <input type="number" size="20" name="apiexpiry" id="apiexpiry" maxlength="200"/>
	            </div>
			    <div class="labelkey">Enter Token Expiry Time ( in number of days) : </div>  <%--No I18N--%>
		        <div class="labelvalue">
					<input type="number" size="20" name="tokenexpiry" id="tokenexpiry" maxlength="200"/>
				</div>
				<div class="labelkey">Enter Admin Password : </div>	<%--No I18N--%>
				<div class="labelvalue">
					<input type="password" name="password" id="password"/>
				</div>
			    </div>		
			    <div>
			    <div class="labelkey"></div>
				<div class="labelvalue"> 
					<input type="button" id="submitbutton" value="Send" style="height:30px;width:70px;background-color:green" onclick="configureauthtooauth()" />
				</div>
			    </div>
			    </div>
		</form>
	</div>
</div>
</body>
</HTML>