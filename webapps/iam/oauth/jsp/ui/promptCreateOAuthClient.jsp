<%--$Id$--%>
<%@page import="com.zoho.accounts.Accounts"%>
<%@page import="com.adventnet.iam.security.SecurityUtil"%>
<%@page import="com.adventnet.iam.internal.Util"%>
<%@ include file="../../../static/includes.jspf" %>
<%

User user = IAMUtil.getCurrentUser();

if(!user.isConfirmed()){
	out.println(Util.getI18NMsg(request, "IAM.DEVELOPERCONSOLE.USER.UNCONFIRMED"));
	return;
}

String serviceUrl=request.getParameter("serviceurl");
String serviceName = request.getParameter("servicename");
String clientType = request.getParameter("client_type");

if(!IAMUtil.isTrustedDomain(user.getZUID(), serviceUrl)){
	out.println("Invalid Service URL");//No I18N
	return;
}
if(serviceUrl.equalsIgnoreCase(Util.getIAMURL())){
	out.println("No such service");//No I18N
	return;
}
%>
<html>
<head>
<script src="<%=jsurl%>/jquery-1.12.2.min.js" type="text/javascript"></script> <%-- NO OUTPUTENCODING --%>
<script src="<%=jsurl%>/jquery.ztooltip.js" type="text/javascript"></script> <%-- NO OUTPUTENCODING --%>
<script src="<%=jsurl%>/common.js" type="text/javascript"></script> <%-- NO OUTPUTENCODING --%>

<link href="<%=cssurl_st%>/ui.ztooltip.css" type="text/css" rel="stylesheet"  /><%-- NO OUTPUTENCODING --%>
<style type="text/css">
body,table {
	font-family: lucida grande, Roboto, Helvetica, sans-serif;
	font-size: 12px;
	padding:0px;
	margin:0px;
}
.home_circledmain {
	margin: 2% 0 2%;
}
.home_circlediv {
	height: 90px;
	width: 90px;
	border-radius: 50px;
	background-color: #1e85d2;
	margin: 0px auto;
	color: #ffffff;
	text-align: center;
}
.home_circle_api {
	font-size: 24px;
	padding-top: 17px;
}
.home_circle_crdl {
	font-size: 13px;
}
/** button css - start **/
.client_button_red, .client_button_white, .client_button_blue {
    border-radius: 2px;
    color: #fff;
    cursor: pointer;
    font-size: 14px;
    padding: 5px 10px;
    text-align: center;
}
.client_button_blue {
    background-color: #1e85d2;
    border: 1px solid #1e85d2;
    padding: 5px 10px;
    font-size: 14px;
}
.client_button_red {
    background-color: #f04b2f;
    border: 1px solid #f04b2f;
}
.client_button_white {
	background-color: #fff;
	border:1px solid #c1c1c1;
	color:#333;
}
.client_button_red:hover {
    background-color: #e64226;
}
.client_button_white:hover {
	border:1px solid #999;
}
.client_button_spacer {
	margin-left: 10px;
}
.hidesubmit {
    width:0;height:0;
    border:0;padding:0;
    display:none;
}
/** button css - end **/
/** input text css - start **/
.client_form_field_input, .client_form_field_input_err, .client_form_field_input_disabled {
	height: 23px;
	width: 500px;
	font-size: 13px;
	padding: 4px 0px;
	white-space: pre-line;
	display: inline-block;
}
.client_form_field_input {
	border: 1px solid transparent;
	border-bottom: 1px solid #aaaaaa;
}
.client_form_field_input:focus {
	border: 1px solid transparent;
	border-bottom: 1px solid #797979;
}
.client_form_field_input_disabled {
	color:#A8A8A8;
	background-color: #ccc;
	border: none;
}
.client_form_field_input_err {
	border: 1px solid transparent;
	border-bottom: 1px solid #E24520;
}
button:focus, input:focus {
    outline: none;
}
/** input text css - end **/
/** add client css - start **/
.add_client_message a {
	color: #007edd;
	text-decoration:none;
}
.add_client_message a:hover {
	text-decoration:underline;
}
.add_client_message {
	margin: 0px auto;
	text-align: center;
	line-height: 22px;
	width: 510px;
	font-size: 13px;
}
.add_client_main_div {
	margin: 0px auto;
	width: 600px;
	border: 1px solid #d9d9d9;
}
.add_client_header {
	background-color: #f7f7f7;
	padding: 15px 15px;
	font-size: 18px;
}
.add_client_formdiv {
	padding: 2% 6%;
	font-size: 13px;
}
.add_client_form_field_main_div {
	margin-bottom: 25px;
}
.add_client_form_field_label {
	padding: 0px 0px 10px 0px;
}
.form_field_alert_msg {
	color: #E24520;
	font-size: 13px;
	padding-left: 1px;
	display: inline-block;
}
.add_client_success_container {
	margin: 45px 0px;
}
.add_client_success_icon {
	display: block;
	margin: 0px auto;
	height: 90px;
	width: 90px;
}
.add_client_success_msg {
	text-align: center;
	margin-top: 10px;
	line-height:2;
}
.add_client_resp_btn_div {
	width: -moz-min-content;
	width: -webkit-min-content;
	width: min-content;
	margin: 35px auto 0px;
}
/** add client css - end **/
/** view client css - start **/
.add_client_btn_div_list {
	width: 90%;
	margin: -35px auto 0px;
}
.view_client_outer_container {
	margin: 10px auto 45px;
	border: 1px solid #d9d9d9;
	width: 90%;
}
.view_client_inner_container {
	overflow:auto;
}
.view_clients_header {
	display: inline-block;
	padding: 15px 0px;
	background-color: #f7f7f7;
	font-weight: bold;
	display: flex;
}
.view_clients_inner_header {
	display: inline-block;
	padding: 0px 15px;
}
.view_clients_rows {
	display: flex;
	border: 1px solid #f7f7f9;
	overflow: hidden;
}
.view_clients_rows_hover {
	background-color: #f7f7f7;
	border: 1px solid #dbdbdb;
	border-left: 1px solid transparent;
	border-right: 1px solid transparent;
}
.view_clients_inner_rows {
	display: inline-block;
	padding: 15px;
}
.message_banner{
	z-index:200000000;
    position:absolute;
    top:0;
  	left:45%;
    display:inline-block;
    border-radius: 0 0 4px 4px;
    color: #ffffff;
    font-size: 14px;
    padding: 10px;
    text-align: center;
}
.multi-dc{
	float:left;
	cursor: pointer;
}
.black_background{
    position: fixed; 
    z-index: 200000000; 
    left: 0;
    top: 0;
    width: 100%; 
    height: 100%; 
    overflow: auto; 
    background-color: rgb(0,0,0); 
    background-color: rgba(0,0,0,0.6); 
}
.delete_alert{
	margin: 0px auto;
	width: 400px;
	border: 1px solid #d9d9d9;
	text-align:center;
	top:35%;
	position:relative;
}
.delete_alert_btn{
	background-color: #f7f7f7;
	padding:15px;
}
.delete_alert_header{
	background-color: #fff;
	padding: 30px 15px;
	font-size: 14px;
}
.client_icons_box{
    position: absolute;
    background-color: #fff;
    min-width: 140px;
    overflow: auto;
    box-shadow: 0px 0px 10px 0px rgba(0,0,0,0.2);
    margin-left: -55px;
    margin-top: -1px;
}
.client_icons_value{
	color: black;
    padding: 12px 16px;
    text-decoration: none;
    display: block;
    cursor: pointer;
}
.client_icons_value:hover{
	background-color: #f9f9f9;
}
.multiDc_enable{
	display:inline-block;
	background-color:#63b951;
	padding:5px 9px;
	position:relative;
	width:60px;
	border:1px solid #63b951;
	color:#fff;
	text-align:center;
	font-size:14px;	
	height:16px;
	cursor:pointer;
}
.menu_icon {
    cursor: pointer;
    display: block;
    height: 21px;
    padding: 12px;
    width: 7px;
}
.dot {
    background-color: #666;
    border-radius: 3px;
    display: block;
    height: 4px;
    margin: 3px;
    width: 4px;
}
.multi_dc_checkbox_div{
	float:left;
	width:12px;
	height:16px;
	padding:5px 9px;
	border:1px solid #c1c1c1;
}
.multi_dc_view{
	cursor:pointer;
	color:#1e85d2;
	display:inline-block;
	position:relative;
	left:10px;
}
.multi_dc_view_box{
	display: none;    
    background-color: #fff;   
    box-shadow: 0px 8px 16px 0px rgba(0,0,0,0.2);
    padding: 7px;
    position:absolute;
    margin-left:-65px;
} 
.drop-down-arrow{
	background: transparent url("../images/icons.png") no-repeat scroll -51px -152px;
    height: 14px;
    width: 21px;
    display: inline-block;
    margin-left: -30px;
}
input[name='expiry']{
	width:100px;
	cursor:pointer;
}
.expiry_dropdown{
	background-color: #fff;
    box-shadow: 0 8px 16px 0 rgba(0, 0, 0, 0.2);
    display:none;
    margin-left: 49px;
    min-width: 100px;
    overflow: auto;
    position: absolute;
}
.noscroll { 
	position: fixed; 
	overflow: static;
}
.expiry_input{
	background: transparent url("../images/icons.png") no-repeat scroll 25px -146px;;
 	display:inline-block;
 	width: 100px;
}
.client_icons_arrow_up{
  position:relative;
  z-index:1;
  width: 0; 
  height: 0; 
  border-left: 10px solid transparent;
  border-right: 10px solid transparent;  
  border-bottom: 10px solid #fff;
}
.client_icons{
  display:none;
}
.add_client_success_msg_1{
  text-align: center;
    margin-top: 10px;
    line-height: 2;
    font-size: 14;
}
/** view client css - end **/
</style>
<script type="text/javascript">
var csrfParam = '<%=SecurityUtil.getCSRFParamName(request)+"="+SecurityUtil.getCSRFCookie(request)%>'; //NO OUTPUTENCODING
var clientzid='';
function addAPIClient(f){
	var params = csrfParam;
	if(<%=Util.isValid(clientType)%>){params +="&client_type=" + <%=IAMEncoder.encodeURL(clientType)%>};//No I18N
	var resp = getPlainResponse("/oauth/v2/create/OAuthClient", params); //No I18N
	resp = resp.trim();
	var path = getServiceUri();
	if(resp.indexOf("success_") !== -1) {
		clientzid = resp.split("_")[1];
		window.location.href=redirectToServiceUrl();
	}else if(resp.indexOf("error__") !== -1){
		var errorReason = resp.split("__")[1];
		window.location.href = path + 'error='+errorReason;
	}else{
		window.location.href = path + 'error=general_error';
	}
	return false;
}
function showAPIClientError(ele, cause) {
	ele.className = "client_form_field_input_err";
	ele.parentNode.getElementsByClassName('form_field_alert_msg')[0].innerHTML = cause;//No I18N
	ele.focus();
}
function urlPattern(url){
	 var pattern = new RegExp('[a-z]\:\/\/[-.\w]*(\/?)([a-zA-Z0-9\-\.\?\,\:\'\/\\\+=&amp;%\$#_@]*)?$');	
	 if(!pattern.test(url)) {
		return false; 
	 }
	 return true;
}

function mobileurlPattern(url){
	 var pattern = new RegExp('[a-zA-Z0-9\-_]\:\/\/[-.\w]*(\/?)([a-zA-Z0-9\-\.\?\,\:\'\/\\\+=&amp;%\$#_@]*)?$');	
	 if(!pattern.test(url)) {
		return false; 
	 }
	 return true;
}
function checkForSpecialChar(str){
	var pattern = new RegExp('^[a-zA-Z0-9\ ]+$');
	if(!pattern.test(str)) {
		return false; 
	 }
	 return true;
}

function validDomain(dm) {
	var pattern = new RegExp('([a-z]\:\/\/)*[-.\w]*(\/?)([a-zA-Z0-9\-\.\?\,\:\'\/\\\+=&amp;%\$#_@]*)?$');	
	 if(!pattern.test(dm)) {
		return false; 
	 }
	 return true;
}
var getPath = function(href) {
    var l = document.createElement("a");
    l.href = href;
    return l;
};
function getServiceUri(){
	var path = getPath('<%=IAMEncoder.encodeJavaScript(serviceUrl)%>');
	var redirectUrl = '<%=IAMEncoder.encodeJavaScript(serviceUrl)%>';
	if(path.search != ""){
		return redirectUrl + "&";
	}else{
		return redirectUrl + "?";
	}
}
function redirectToServiceUrl(){
	var path = getServiceUri();
	return path+"client_zid="+clientzid;//NO I18N
}
function goToClientHome(){
	var path = getServiceUri();
	window.location.href=path+"error=user_denied";
}
</script>
<link href="<%=cssurl_st%>/ui.ztooltip.css" type="text/css" rel="stylesheet"  /><%-- NO OUTPUTENCODING --%>
<title><%=Util.getI18NMsg(request, "IAM.ZOHO.ACCOUNTS")%></title>
</head>
<body>
<div class="ztb-topband"></div>
	<div class="home_circledmain">
		<div class="home_circlediv" >
			<div class="home_circle_api"><%=Util.getI18NMsg(request, "IAM.DEVELOPERCONSOLE.API")%></div>
			<div class="home_circle_crdl"><%=Util.getI18NMsg(request, "IAM.DEVELOPERCONSOLE.CREDENTIALS")%></div>
		</div>
	</div>
<div class="add_client_main_div" id="add_client_form_container">
	<div class="add_client_header" align="center">Create OAuth Client Id for the Integration</div>
	<div class="add_client_formdiv">
		<form name="add_api_client" method="POST" onsubmit="return addAPIClient(this)">
			<input type="submit" class="hidesubmit" />
		</form>
	<div align="center">	<button class="client_button_red" onclick="addAPIClient(document.add_api_client)"><%=Util.getI18NMsg(request, "IAM.CREATE")%></button>
		<button class="client_button_white" onclick="goToClientHome()"><%=Util.getI18NMsg(request, "IAM.CANCEL")%></button></div>
	</div>
</div>
<div class="add_client_main_div" id="add_client_container_response" style="display:none;">
	<div class="add_client_success_container">
		<img src="<%=imgurl%>/round-tick.png" class="add_client_success_icon"/> <%-- NO OUTPUTENCODING --%>
		<div class="add_client_success_msg"><%=Util.getI18NMsg(request, "IAM.DEVELOPERCONSOLE.SUCCESS.CREATE.CLIENT")%>
			<div><%=Util.getI18NMsg(request, "IAM.DEVELOPERCONSOLE.SUCCESS.CREATE.CLIENT.CLIENT.ID")%>&nbsp;<span  id="add_client_success_msg_client_id"></span></div>
			<div><%=Util.getI18NMsg(request, "IAM.DEVELOPERCONSOLE.SUCCESS.CREATE.CLIENT.CLIENT.SECRET")%>&nbsp;<span id="add_client_success_msg_client_secret"></span></div>
		</div>
	</div>
</div>
<div class="add_client_main_div_1" id="add_client_container_response_1" style="display:none;">
	<div class="add_client_success_msg_1">
		<div><b><%=Util.getI18NMsg(request, "IAM.DEVELOPERCONSOLE.SUCCESS.REDIRECT.ON.SUCESS",serviceName)%></b></div>
	</div>
</div>
</body></html>
