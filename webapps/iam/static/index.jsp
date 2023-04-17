<!-- $Id$ -->
<%@page import="com.zoho.accounts.internal.util.AccountsInternalConst"%>
<%@page import="com.adventnet.iam.internal.PartnerAccountUtil"%>
<%@ include file="includes.jspf" %>
<%
	//Temporary Fix for ss_id Cookie 
	String ss_id_cookie = IAMUtil.getCookie(request, "ss_id");//No I18N
	IAMUtil.addCookie(response, "ss_id", ss_id_cookie, -1, true);//No I18N
	String rook_cook_cookie = IAMUtil.getCookie(request, AccountsInternalConst.ROOK_COOK);
	IAMUtil.addCookie(response, AccountsInternalConst.ROOK_COOK, rook_cook_cookie, -1, true);
	
	String servicename = (String) request.getSession().getAttribute("servicename");
	servicename = Util.isValid(servicename) ? servicename : request.getParameter("servicename");
	servicename = Util.isValid(servicename) ? servicename : Util.getIAMServiceName();
	
	String serviceurl = (String) request.getSession().getAttribute("serviceurl");
	serviceurl = Util.isValid(serviceurl) ? serviceurl : request.getParameter("serviceurl");
	
	String mobileLoginURL = Util.getIAMURL() + "/signin?servicename=" + servicename; //No I18N
	String usingGoogleYahoo = AccountsConfiguration.getConfiguration("using.googleyahoo", "true"); //No I18N
    String loginURL = request.getContextPath() + "/signin?servicename=" + servicename;//No I18N
    String loginId = request.getParameter("LOGIN_ID");
    loginId = Util.isValid(loginId) ? loginId : "";
    if(Util.isValid(loginId)){
    	loginURL += "&LOGIN_ID=" + Util.encode(loginId); //No I18N
    }

	PartnerAccount partnerAccount = PartnerAccountUtil.getCurrentPartnerAccount();
	boolean partnerLogoExists = partnerAccount != null && PartnerAccountUtil.isPartnerLogoExists(partnerAccount.getPartnerID());
%>
<script type="text/javascript">
    <%if ("true".equals(AccountsConfiguration.getConfiguration("use.https", "true"))) {%>
        var loc_port = window.location.port;
        if(loc_port =="" || loc_port == "80") {
            var iurl=window.location.href;if(iurl.indexOf("http://")==0){iurl=iurl.replace("http://", "https://");window.location.href=iurl;}
        }
    <%}%>
</script>
<html>
    <head>
	<meta http-equiv="x-xrds-location"> <%-- NO OUTPUTENCODING --%>
	<title><%=Util.getI18NMsg(request,"IAM.ZOHO.ACCOUNTS")%></title>
	<style>
	body{
	  font-family: Open Sans,helvetica,Roboto,sans-serif;
      margin:0px;
      padding:0px;
	}
	    #zohoiam {
			margin:0;
            width:100%;
            height:660px;
	    }
		#main-all {
			margin: 0px;
			padding:0px;
			font-size:13px;
			color:#141823;
		}
		.logindiv {
			margin:0px auto 0px;
			display:table;
			text-align:center;
			height:90%;
		}
		.footer {
    		clear: both;
    		color: #999;
    		font-size: 11px;
    		font-weight: normal;
    		text-align: center;
    		width: 100%;
    		margin-top:20px;
		}
		.footer a, .footer span {
    		color: #999;
		}
 	#form-main{
 		width: 530px;
 	}
	</style>
	<script type="text/javascript">
		var serviceurl = '<%=IAMEncoder.encodeJavaScript(serviceurl)%>';
		function createLoginFrame() {
			var loginURL = '<%=IAMEncoder.encodeJavaScript(loginURL)%>';
			<%if(IAMUtil.isValid(serviceurl)){%>
				loginURL += "&serviceurl="+encodeURIComponent(serviceurl); //No I18N
			<%}%>
			var iframe = document.createElement('iframe');
			iframe.id="zohoiam";
			iframe.frameBorder=0;
			iframe.scrolling="no";
			iframe.marginWidth=0;
			iframe.marginHeight=0;
			iframe.setAttribute('allowtransparency', 'true');
			iframe.setAttribute("src", loginURL);
			document.getElementById("form-main").appendChild(iframe);
		}
		function escapeServiceUrlHash(locationUrl) {
			var tmpserviceurl = serviceurl;
			try {
				if(locationUrl.indexOf('serviceurl=') !== -1) {
					var surl = decodeURIComponent(locationUrl.substring(locationUrl.indexOf('serviceurl=')+11));
					if(surl.indexOf('#') !== -1) {
						if(surl.indexOf('&') !== -1) {
							surl = surl.substr(0, surl.indexOf('&'));
						}
						serviceurl = surl;	
					}
				}
			}catch (e) {
				serviceurl = tmpserviceurl;
			}
		}
		function openMobileLogin() {
			var mobileLoginURL = '<%=IAMEncoder.encodeJavaScript(mobileLoginURL)%>';
			mobileLoginURL += "&serviceurl="+encodeURIComponent(serviceurl); //No I18N
			window.parent.location.href = mobileLoginURL;
		}
	    window.onload = function() {
    		var locationUrl = window.location.href;
    		if(locationUrl.indexOf('#') !== -1) {
    			escapeServiceUrlHash(locationUrl);
    		}
			<%if(Util.isMobileUserAgent(request)) {%>
			openMobileLogin();
			<%} else {%>
	    		createLoginFrame();
	    	<%}%>
	    }
	</script>
    </head>
    <body>		
		<div id="main-all">
			<div class="logindiv"><div id="form-main"></div></div>
    		<div class="footer"><span><%=Util.getI18NMsg(request, "IAM.FOOTER.COPYRIGHT", Util.getCopyRightYear())%></span></div>
		</div>
    </body>
</html>
