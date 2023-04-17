<%-- $Id$ --%>

<%-- $Id$ --%>
<%@page import="com.zoho.accounts.webclient.util.WebClientUtil"%>
<%@page import="com.zoho.accounts.AccountsConstants.IdentityProvider"%>
<%@page import="com.zoho.accounts.internal.announcement.Announcement"%>
<%@page import="com.zoho.accounts.internal.util.AccountsInternalConst"%>
<%@page import="com.adventnet.iam.IAMUtil"%>
<%@page import="java.util.logging.Logger"%>
<%@page import="org.json.JSONObject"%>
<%@page import="com.zoho.accounts.internal.fs.FSConsumerUtil"%>
<%@page import="com.adventnet.iam.xss.IAMEncoder"%>
<%@page import="com.adventnet.iam.internal.Util"%>
<%@page import="com.adventnet.iam.xss.IAMEncoder"%>
<%@page import="com.adventnet.iam.internal.Util"%>
<%@ include file="../../static/includes.jspf" %>

<%
	String openidcookie = IAMUtil.getCookie(request, AccountsInternalConst.TMP_TOKEN_COOKIE_NAME);
	String cause = null, title = null,providerName = null;
	int errorCode = -1;
	String backToUrl = null;
	try{
	JSONObject fsJson = (JSONObject)request.getAttribute("token_details");
	String servicename = null;
	String serviceurl = null;
	if (IAMUtil.isValid(fsJson)){
		servicename = fsJson.optString("servicename");// No I18N
		serviceurl = fsJson.optString("serviceurl");// No I18N
	}
	servicename = Util.isValid(servicename) ? servicename : AccountsConstants.ACCOUNTS_SERVICE_NAME;
	serviceurl = Util.isValid(serviceurl) ? serviceurl : request.getParameter("serviceurl");
	backToUrl = Util.getBackToURL(servicename, serviceurl);	
	errorCode = (Integer)request.getAttribute("ERROR_CODE");
	Object idp = request.getAttribute("idp");
	Object dataString = request.getAttribute("data");
	String [] data = null;
	if(dataString !=null){
		data = dataString.toString().split(",");
	}
	
	cause = FSConsumerUtil.getErrorMessage(errorCode, request, idp!=null?idp.toString():null, data);
	title = FSConsumerUtil.getErrorTitle(errorCode, request);
	if(IdentityProvider.AZURE.name().equalsIgnoreCase((String)idp) && errorCode == FSConsumerUtil.ACCESS_DENIED){
		cause = Util.getI18NMsg(request,"IAM.OAUTH.AZURE.ACCESS.DENIED");	// No I18N
	}
    if (cause == null) {
            response.sendRedirect(backToUrl);
            return;
    }
	}catch(Exception e){
		cause =  Util.getI18NMsg(request,"IAM.FEDERATED.SIGNIN.ERROR");  // No I18N
		title = Util.getI18NMsg(request,"IAM.FEDERATED.SIGNIN.INTERNAL.ERROR");// No I18N
	}
	boolean showAppleError="true".equals(request.getAttribute("newAppleError"));
%>
<html>
<head>
<style>
body,table {
	font-family: lucida grande, Roboto, Helvetica, sans-serif;
	font-size: 12px;
	padding:0px;
	margin:0px;
}
.maindiv {
	border: 1px solid #dcddda;
	width: 900px;
	margin: 0px auto;
	background: url('<%=imgurl%>/banner-bg.jpg'); <%-- NO OUTPUTENCODING --%>
	border-radius: 2px;
	text-align: justify;
	margin-top: 5%;
}
.contentdiv {
	padding: 27px 35px 40px;
}
.titlemsg {
	border-bottom: 1px solid #c9c9c9;
	font-size: 18px;
	padding-bottom: 8px;
}
.msgcontent {
	clear: both;
	margin-top: 15px;
	line-height: 20px;
}
.btndiv {
	clear: both;
	margin-top: 30px;
	line-height: 20px;
}
.btndiv a {
	background-color: #6DA60A;
	border: 1px solid #65990B;
	color: #FFFFFF;
	font-size: 14px;
	padding: 6px 14px;
	text-decoration: none;
}
.container
{
    display: block;
    width: 90%;
    max-width: 600px;
    height: auto;
    min-height: 200px;
    border: 2px solid #EAEAEA;
    border-radius: 40px;
    margin: auto;
    box-sizing: border-box;
    box-shadow: 3px 6px 30px #00000008;
    overflow: hidden;
}

.zohologo
{
    display: block;
    height: 30px;
    width: 81px;
    margin: auto;
    margin-bottom: 20px;
    margin-top: 100px;
    background: url('<%=imgurl%>/zlogo.png') no-repeat transparent;
    background-size: 100% auto;
    background-position: center;
    
}
.content_box
{
    display: block;
    width:calc(100% + 4px);
    max-width: 600px;
    height: auto;
    border-radius: 40px;
    border: 2px solid #EAEAEA;
    box-sizing: border-box;
    margin: -2px;
    box-shadow: 0px 2px 10px #00000010;
}
.content_box_header
{
    display: block;
    font-size: 18px;
    line-height: 24px;
    font-weight: 600;
    margin-bottom: 10px;
}
.content_box_discription
{
    display: block;
    font-size: 14px;
    line-height: 24px;
    font-weight: 500;
    color: #00000080;
}





.Error_bg
{
    display: block;
    height: 100px;
    width: 100%;
    background-image: linear-gradient(#FFD9D9,#FFF);
    position: relative;
    z-index: 0;
}
.Error_icon
{
    display: block;
    height: 40px;
    width: 40px;
    margin: auto;
    margin-top: -60px;
    background: url('<%=imgurl%>/error_icon.png') no-repeat transparent;
    background-size: 100%;
    position: relative;
    z-index: 1;
}
.header_center
{
    display: block;
    margin: auto;
    margin-top: 20px;
    font-size: 18px;
    line-height: 30px;
    font-weight: 600;
    text-align: center;
}
.discription_center
{
    display: block;
    margin: auto;
    margin-top: 10px;
    font-size: 13px;
    line-height: 24px;
    width: 100%;
    box-sizing: border-box;
    padding:  0px 20px;
    font-weight: 500;
    text-align: center;
    margin-bottom: 40px;
    color: #000;
    opacity: .95;
}
.bottom_div
{
    display: block;
    padding: 25px 40px;
    transition: all .2s ease-in-out;
}
.bottom_div_expand
{
    padding: 40px 40px;
}
.blue_text
{
    display: block;
    font-weight: 600;
    font-size: 14px;
    color: #0091FF;
    line-height: 20px;
    cursor: pointer;   
}
.addblackcolor
{
    color: #000;
}
.expand
{
    display: none;
}
.bulletins
{
    display: block;
    margin-top: 20px;
}
.bulletins_style
{
    display: inline-block;
    height: 8px;
    width: 8px;
    margin-right: 10px;
    margin-top: 8px;
    background-color: #F66363;
    border-radius: 4px;
    float: left;
}
.bulletins_text
{
    display: inline-block;
    font-size: 13px;
    font-weight: 500;
    line-height: 24px;
    letter-spacing: -0.2;
    width: calc(100% - 20px);
    max-width: 482px;
    color: #000000;
    opacity: .95;
}
.semibold
{
    font-weight: 600;
}

@media only screen and (max-width: 480px)
{
    .zohologo
    {
        margin-top: 50px;
    }
    .container
    {
        width: 100%;
    }
    .content_box
    {
        width:calc(100% + 4px);
    }
    .discription_center, .header_center
    {
        width: 90%;
    }
    .bulletins_text
    {
        width: calc(100% - 20px);
    }
    .bottom_div
    {
        padding: 25px 30px;
    }
    .bottom_div_expand
    {
        padding: 30px;
    }
    
}
</style>
<script type="text/javascript" src="<%="true".equals(AccountsConfiguration.getConfiguration("iam.static.newui", "false"))? WebClientUtil.getTPJSURL(request) : cPath+"/v2/components/tp_pkg"%>/jquery-3_5_1.min.js"></script>
<title><%=Util.getI18NMsg(request, "IAM.ZOHO.ACCOUNTS")%></title>
</head>
<body>
	<%if(showAppleError){ %>
	<div class="zohologo"></div>
        <div class="container">
            <div class="content_box">
                <div class="Error_bg"></div>
                <div class="Error_icon"></div>
                <div class="header_center"><%=Util.getI18NMsg(request, "IAM.SIWA.SIGNUP.ERROR.ANNOUNCEMENT.TITLE")%></div>
                <div class="discription_center"><%=Util.getI18NMsg(request, "IAM.SIWA.SIGNUP.ERROR.ANNOUNCEMENT.DESC")%></div>
            </div>
            
            <div class="bottom_div">
                <div class="blue_text"><%=Util.getI18NMsg(request, "IAM.SIWA.SIGNUP.ERROR.RESOLVE.FIRST.DESC")%></div>
                
                <div class="expand">
                    
                    <div class="bulletins">
                        <span class="bulletins_style"></span>
                        <span class="bulletins_text"><%=Util.getI18NMsg(request, "IAM.SIWA.SIGNUP.ERROR.RESOLVE.FIRST.DESC")%></span>
                    </div>
                    <div class="bulletins">
                        <span class="bulletins_style"></span>
                        <span class="bulletins_text"><%=Util.getI18NMsg(request, "IAM.SIWA.SIGNUP.ERROR.RESOLVE.SEC.DESC")%></span>
                    </div>
                    <div class="bulletins">
                        <span class="bulletins_style"></span>
                        <span class="bulletins_text"><%=Util.getI18NMsg(request, "IAM.SIWA.SIGNUP.ERROR.RESOLVE.THIRD.DESC")%></span>
                    </div>
                    <div class="bulletins">
                        <span class="bulletins_style"></span>
                        <span class="bulletins_text"><%=Util.getI18NMsg(request, "IAM.SIWA.SIGNUP.ERROR.RESOLVE.FOURTH.DESC")%></span>
                    </div>
                    <div class="bulletins">
                        <span class="bulletins_style"></span>
                        <span class="bulletins_text"><%=Util.getI18NMsg(request, "IAM.SIWA.SIGNUP.ERROR.RESOLVE.FIFTH.DESC", backToUrl)%></span>
                    </div>
                    
                </div>
            </div>
            
        </div>
     <%}else{ %>
		<table width="100%" height="100%" align="center" cellpadding="0" cellspacing="0">
			<tr><td valign="top" style="height:40px;"><%@ include file="../../ui/unauth/header.jspf" %></td></tr>
			<tr><td valign="top">
				<div class="maindiv">
					<div class="contentdiv">
						<div class="titlemsg"><%=IAMEncoder.encodeHTML(title)%></div>
						<div class="msgcontent"><%=cause%></div> <%-- NO OUTPUTENCODING --%>
						<div class="btndiv">
							<a href="<%=IAMEncoder.encodeHTMLAttribute(backToUrl)%>"><%=Util.getI18NMsg(request, "IAM.BACKTO.HOME")%></a>
						</div>
					</div>
				</div>
			</td></tr>
			<tr><td valign="bottom"><%@ include file="../../ui/unauth/footer.jspf" %></td></tr>
		</table>
	<% }%>
</body>
    <script>
        $(".blue_text").click(function(){
            $(this).addClass("addblackcolor");
            $(".bottom_div").addClass("bottom_div_expand");
            $(".expand").slideDown(200);
        });
    </script>
</html>