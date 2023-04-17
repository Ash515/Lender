<%--$Id$--%>
<!DOCTYPE html>
<%@ include file="../../static/includes.jspf" %>
<%@page import="com.zoho.accounts.Accounts"%>
<%@page import="com.zoho.accounts.AccountsProto.Account.User.Properties"%>
<%
String dconsole_url = AccountsConfiguration.getConfiguration("iam.apiconsole.newurl", null); //No I18N
if(dconsole_url != null) {
	response.sendRedirect(dconsole_url);
	return;
}
User user = IAMUtil.getCurrentUser();
long zuId = user.getZUID();
String userid = CryptoUtil.encryptWithSalt("photo", zuId+"", ":", IAMUtil.getCurrentTicket(), true); //No I18N
String iamHelpLink = ""; 
String baseurl = IAMProxy.getIAMServerURL();
String dconsoleurl = AccountsConfiguration.getConfiguration("iam.apiconsole.newurl", null); //No I18N
if(dconsoleurl != null){
	String apiconsoleNewVersion  = "accounts.apiconsole.newversion"; //No I18N
	Properties prop = Accounts.getPropertiesURI(user.getZaid(), user.getZUID(), apiconsoleNewVersion).GET();
	if(prop != null && "true".equals(prop.getPropValue())) {
		response.sendRedirect(dconsoleurl);
		return;
	}
}

%>
<html>
<head>
<script src="<%=jsurl%>/jquery-1.12.2.min.js" type="text/javascript"></script> <%-- NO OUTPUTENCODING --%>
<script src="<%=jsurl%>/jquery.ztooltip.js" type="text/javascript"></script> <%-- NO OUTPUTENCODING --%>
<script src="<%=jsurl%>/common.js" type="text/javascript"></script> <%-- NO OUTPUTENCODING --%>

<link href="<%=cssurl_st%>/ui.ztooltip.css" type="text/css" rel="stylesheet"  /><%-- NO OUTPUTENCODING --%>
<style type="text/css">
@font-face {
	font-family: 'DCfonts';
	src: url('../../images/fonticon/DCfonts.eot') format('embedded-opentype'),
		url('../../images/fonticon/DCfonts.ttf') format('truetype'),
		url('../../images/fonticon/DCfonts.woff') format('woff'),
		url('../../images/fonticon/DCfonts.svg') format('svg');
	font-weight: normal;
	font-style: normal;
}

[class^="icon-"], [class*=" icon-"] {
  /* use !important to prevent issues with browser extensions that change fonts */
  font-family: 'DCfonts' !important;
  speak: none;
  font-style: normal;
  font-weight: normal;
  font-variant: normal;
  text-transform: none;
  line-height: 1;

  /* Better Font Rendering =========== */
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

body,table {
	font-family: lucida grande, Roboto, Helvetica, sans-serif;
	font-size: 12px;
	padding:0px;
	margin:0px;
}
.home_circledmain {
	margin: 5% 0 2%;
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
.client_button_blue, .client_button_red, .client_button_white {
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
	height: 20px;
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
	background-color: #fff;
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
	background: transparent url("../images/icons.png") no-repeat scroll 25px -146px;
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
.icon-cross:before {
	content: "\e902";
}
.close_icon {
    float: right;
    top: -10px;
    right: 5px;
    padding: 6px;
    margin: 0px auto;
    border-radius: 50%;
    background-color: #6442c1;
    box-shadow: 0 2px 4px #c6c0c0;
    color: white;
    font-size: 6px;
    cursor: pointer;
    font-weight: 900;
}
.new_ui_banner {
	background: transparent url("../../images/dc_banner.png") no-repeat;
	width: 400px;
	height: 150px;
	background-size: auto 100%;
	position: fixed;
	bottom: 40px;
	right: 39px;
	border-radius: 10px;
    box-shadow: 0 2px 5px rgba(173, 165, 165, .5);
    z-index: 1000000;
}
.content_container {
	text-align: center;
	width: 65%;
	margin-left: 10px;
}
.banner_content {
	padding-top: 10px;
	padding-left: 0px;
	line-height: 25px;
	text-align: center;
}
.banner_button {
	background-color: #6442c1;
	border-radius: 15px;
	width: 100px;
	color: white;
	height: 30px;
	cursor: pointer;
	border: none;
}
.notification_bell {
    background: transparent url(../../images/alarm.png) no-repeat;
    width: 35px;
    height: 35px;
    background-size: 100%;
    position: fixed;
    top: 2px;
    right: 43px;
    margin: 0px 10px;
    z-index: 1000000;
    cursor: pointer;
}
.banner_top {
    position: absolute;
    width: 0px;
    height: 0px;
    border-left: 12px solid transparent;
    border-right: 12px solid transparent;
    border-bottom: 12px solid #f0eefd;
    float: right;
    top: -11px;
    right: 20px;
}
.alarm {
    width: 41px;
    height: 41px;
	background: transparent url(../../images/alarm.png) no-repeat;
	background-size: 100%;
	float:right;
	margin-right: 10px;
}	
.circle {
	width:5px;
	height: 5px;
	border-radius: 50%;
	display:inline-block;
	background: red;
	position: absolute;
	margin-left: 22px;
	margin-top:12px; 
	border:1px solid #fff;
	animation-name: circleblur;
	animation-duration: 2s;
	animation-iteration-count: infinite;
}
@keyframes circleblur {
	from{    box-shadow: 0 0 0 0 rgba(254,57,5,0.7);}
	to{    box-shadow: 0 0 0 10px rgba(254,57,5,0);}		
}

/** view client css - end **/
</style>
<script type="text/javascript">
var contextpath = '<%=request.getContextPath()%>'; //NO OUTPUTENCODING
var csrfParam = '<%=SecurityUtil.getCSRFParamName(request)+"="+SecurityUtil.getCSRFCookie(request)%>'; //NO OUTPUTENCODING
var clientZid_delete=null;
var rowId_delete=null;
function loadDeveloperPage(url) {
	var resp = getPlainResponse(url,"");
	de('ajax_content_div').innerHTML = resp; //No I18N
	de('ajax_content_div').style.display = '';
}
function goToClientHome() {
	loadDeveloperPage(contextpath+"/ui/dconsole/api-clients.jsp"); //No I18N
}
function goToAddClient() {
	loadDeveloperPage(contextpath+'/ui/dconsole/api-clients.jsp?mode=addclient'); //No I18N
}
function updateAPIClient(f) {
	var client_id = f.client_id.value.trim();
	var old_client_redirect_uri = f.old_client_redirect_uri.value.trim();
	var old_client_js_domain = f.old_client_js_domain.value.trim();
 	addAPIClient(f, client_id, old_client_redirect_uri, old_client_js_domain);
	return false;
}

function mobilePattern(url){
	 var pattern = new RegExp('[a-zA-Z0-9\-_]\:\/\/[-.\w]*(\/?)([a-zA-Z0-9\-\.\?\,\:\'\/\\\+=&amp;%\$#_@]*)?$');	
	 if(!pattern.test(url)) {
		return false; 
	 }
	 return true;
}

function urlPattern(url){
	 var pattern = new RegExp('[a-z]\:\/\/[-.\w]*(\/?)([a-zA-Z0-9\-\.\?\,\:\'\/\\\+=&amp;%\$#_@]*)?$');	
	 if(!pattern.test(url)) {
		return false; 
	 }
	 return true;
}
function addAPIClient(f, client_id, old_client_redirect_uri, old_client_js_domain) {
	var client_name = f.client_name.value.trim();
	var client_domain = f.client_domain.value.trim();
	var client_redirect_uri = f.client_redirect_uri.value.trim();
	var clientType = f.client_type.value.trim();
	if(client_name === '') {
		showAPIClientError(f.client_name, "<%=Util.getI18NMsg(request, "IAM.DEVELOPERCONSOLE.ENTER.CLIENTNAME")%>");
		return false;
	} else if(client_name.toLowerCase().indexOf("zoho") !=-1){
		showAPIClientError(f.client_name, "<%=Util.getI18NMsg(request, "IAM.DEVELOPERCONSOLE.ENTER.CLIENTNAME.NO.ZOHO","ZOHO")%>");
		return false;
	} else if(client_domain === ''|| !validDomain(client_domain)) {
		showAPIClientError(f.client_domain, "<%=Util.getI18NMsg(request, "IAM.DEVELOPERCONSOLE.ENTER.CLIENTDOMAIN")%>");
		return false;
	} else if(client_redirect_uri === '') {
		showAPIClientError(f.client_redirect_uri, "<%=Util.getI18NMsg(request, "IAM.DEVELOPERCONSOLE.ENTER.CLIENTREDIRECTURL")%>");
		return false;
	} else if((clientType === "JS" || clientType === "WEB") && !urlPattern(client_redirect_uri)){ //No I18N
		showAPIClientError(f.client_redirect_uri, "<%=Util.getI18NMsg(request, "IAM.DEVELOPERCONSOLE.ENTER.CLIENTREDIRECTURL")%>");
		return false;
	}
	
	if((clientType === "Mobile") && !mobilePattern(client_redirect_uri)) {
		showAPIClientError(f.client_redirect_uri, "<%=Util.getI18NMsg(request, "IAM.DEVELOPERCONSOLE.ENTER.CLIENTREDIRECTURL")%>");
		return false;
	}
	var params = "action=addclient&client_name=" + euc(client_name) + "&client_domain=" + euc(client_domain) + "&client_redirect_uri=" + euc(client_redirect_uri)+ "&clientType=" + euc(clientType)+ "&" + csrfParam; //No I18N
	if(clientType === "JS") {
		var client_js_domain = f.client_js_domain.value.trim();
		var client_js_domain_validated = "";
		if( old_client_js_domain !== '' && client_js_domain === ''){
			showAPIClientError(f.client_js_domain, "<%=Util.getI18NMsg(request, "IAM.DEVELOPERCONSOLE.ENTER.JS.DOMAIN")%>");
			return false;
		} else {
			var domains = client_js_domain.split(",");
			var arrayLength = domains.length;
			for (var i = 0; i < arrayLength; i++) {
				var client_redirect_uri_i  = domains[i].trim();
				if(!urlPattern(client_redirect_uri_i)){
					showAPIClientError(f.client_js_domain, "<%=Util.getI18NMsg(request, "IAM.DEVELOPERCONSOLE.ENTER.JS.DOMAIN")%>");
					return false;
				}
				client_js_domain_validated = client_js_domain_validated + client_redirect_uri_i ;
				if(arrayLength-1 != i) {
					client_js_domain_validated = client_js_domain_validated + ",";
				}
			}
		}
		params =  params  + "&client_js_domain=" + euc(client_js_domain_validated); //No I18N
	}
	if(client_id && client_id !== '') {
		params += "&client_id=" + euc(client_id); //No I18N
	}
	if(old_client_redirect_uri && old_client_redirect_uri !== '') {
 		params += "&old_client_redirect_uri=" + euc(old_client_redirect_uri); //No I18N
	}
	var resp = getPlainResponse(contextpath+"/ui/dconsole/api-clients.jsp", params); //No I18N
	resp = resp.trim();
	if(resp.indexOf("success_") !== -1) {
		var clientId = resp.split("_")[1];
		var clientSecret = resp.split("_")[2];
		de('add_client_form_container').style.display = 'none';
		if(!(client_id && client_id !== '')) {
			de('add_client_success_msg_client_id').innerHTML = clientId;//No I18N
			de('add_client_success_msg_client_secret').innerHTML = clientSecret;//No I18N
		}
		de('add_client_container_response').style.display = '';
	} else {
		de('client_common_error_panel').style.display = '';
	}
	return false;
}
function displayDeleteAlert(client_zid,id){
	de('delete_alert').style.display = '';
	clientZid_delete = client_zid;
	rowId_delete = id;
}
function deleteAPIClient() {
	de('delete_alert').style.display = 'none';
	var params = "action=deleteclient&client_zid=" + euc(clientZid_delete) + "&" + csrfParam; //No I18N
	var resp = getPlainResponse(contextpath+"/ui/dconsole/api-clients.jsp", params); //No I18N
	resp = resp.trim();
	if(resp === 'success') { 
			var parentId = rowId_delete.parentNode.parentNode.parentNode.parentNode; 
			de('delete_client_id_success').style.background = '#63b951'; //No I18N
			$('#delete_client_id_success').show();
			$('#delete_client_id_success').fadeOut(3000);
			if($(parentId).siblings().size() > 0){
					parentId.remove();
			}
			else {
					location.reload();
			}
		} else {
			de('delete_client_id_failed').style.background = '#f04b2f'; //No I18N
			$('#delete_client_id_failed').show();
			$('#delete_client_id_failed').fadeOut(3000);
		}
}
function hideDeleteAlert(){
	de('delete_alert').style.display = 'none';
}
function goToMultiDCSupport(clientZid){
	loadDeveloperPage(contextpath+"/ui/dconsole/api-clients.jsp?mode=multidcsupport&client_zid="+euc(clientZid)); //No I18N
}
function multiDcCheckbox(location,clientId,clientType,id,text){
	var resp = null;
	var params = "location=" + location + "&client_id=" + euc(clientId) + "&client_type=" + euc(clientType) + "&" + csrfParam; //No I18N
	if(text === "Disabled"){
		resp = getPlainResponse(contextpath+"/oauth/dc/addclient",params); //No I18N
		resp=resp.trim();
		if(resp === 'success'){
			$(id).css("background","#63b951").css("border","1px solid #63b951").css("color","#fff");//No I18N
			$(id).text("<%=Util.getI18NMsg(request, "IAM.TFA.ENABLED")%>");
			$(id).siblings('.multi_dc_view').show(); //No I18N
			$('#multi_dc_support_banner').css("background","#63b951");//No I18N
			$('#multi_dc_support_banner').text("<%=Util.getI18NMsg(request, "IAM.DEVELOPERCONSOLE.ZOHO.MULTI.DC.ENABLE.SUCCESS")%>").show().fadeOut(3000);
		}else{
			$('#multi_dc_support_banner').css("background","#f04b2f");//No I18N
			$('#multi_dc_support_banner').text("<%=Util.getI18NMsg(request, "IAM.DEVELOPERCONSOLE.ZOHO.MULTI.DC.ENABLE.FAILURE")%>").show().fadeOut(3000);
		}
	}else{		
		resp = getPlainResponse(contextpath+"/oauth/dc/deleteClient",params); //No I18N
		resp=resp.trim();
		if(resp === 'success'){
			$(id).css("background","#fff").css("border","1px solid #c1c1c1").css("color","#000"); //No I18N
			$(id).text("<%=Util.getI18NMsg(request, "IAM.DEVELOPERCONSOLE.ZOHO.DISABLED")%>");
			$(id).siblings('.multi_dc_view').hide(); //No I18N
			$(id).siblings('.multi_dc_view_box').hide(); //No I18N
			$('#multi_dc_support_banner').css("background","#63b951"); //No I18N
			$('#multi_dc_support_banner').text("<%=Util.getI18NMsg(request, "IAM.DEVELOPERCONSOLE.ZOHO.MULTI.DC.DISABLE.SUCCESS")%>").show().fadeOut(3000);
		}else{
			$('#multi_dc_support_banner').css("background","#f04b2f"); //No I18N
			$('#multi_dc_support_banner').text("<%=Util.getI18NMsg(request, "IAM.DEVELOPERCONSOLE.ZOHO.MULTI.DC.DISABLE.FAILURE")%>").show().fadeOut(3000);
		}
	}
}
function multiDcView(location,clientId,clientType,id){
		var resp = null;
		var params = "location=" + location + "&client_id=" + euc(clientId) + "&client_type=" + euc(clientType) + "&" + csrfParam; //No I18N
		resp = getPlainResponse(contextpath+"/oauth/dc/getRemoteSecret",params); //No I18N
		resp=resp.trim();
		$(id).siblings('.multi_dc_view_box').children().text(resp); //No I18N
		$(id).siblings('.multi_dc_view_box').css("display","inline-block"); //No I18N		
}
function goToSelfClient(clientZid){
	loadDeveloperPage(contextpath+"/ui/dconsole/api-clients.jsp?mode=selfclient&client_zid="+euc(clientZid)); //No I18N
}
function displayIcons(id){
	console.log(id);
	var visible = $(".client_icons").is(":visible");
	var prev_visible = $('.client_icons:visible').parent().parent();
	if(visible){
		$(".client_icons").hide(); //No I18N
		$(prev_visible).removeClass('view_clients_rows_hover');
	}
	$(id).children('.client_icons').show(); //No I18N
	var parent_id = $(id).parent();
	$(parent_id).addClass('view_clients_rows_hover');
}
function selfClient(f){
	var resp = null;
	var scope = f.scope.value.trim();
	var expiry = f.expiry.id.trim();
	var clientId = f.client_id.value.trim();
	var redirect_uri = f.redirect_uri.value.trim();
	if(scope){
		var state = "state"; //No I18N
		var response_type = "code"; //No I18N
		var access_type  = "offline"; //No I18N
		var params = "&approvedScope=" + scope + "&scope=" + scope + "&expiry=" + expiry + "&client_id=" + euc(clientId) + "&redirect_uri=" + euc(redirect_uri) + "&state=" + state + "&response_type="+ response_type + "&access_type=" + access_type + "&" + csrfParam; //No I18N
		var resp = getPlainResponse(contextpath+"/oauth/v2/self/token/generate", params); //No I18N
		var respJson = JSON.parse(resp);
		if(respJson.code) {
			de('self_client').style.display = 'none';
			de('self_client_token_code').innerHTML = respJson.code;//No I18N
			de('self_client_token').style.display = '';
		} else if(respJson.error){
			var error = respJson.error;
			if(error == "invalid_scope") {
				de('self_client_scope_error').innerHTML = "<%=Util.getI18NMsg(request,"IAM.DEVELOPERCONSOLE.ENTER.SCOPE")%>"; 
				$('input[name="scope"]').focus();
			} else {
				de('selfclient_common_error_panel').style.display='';
			}
		} else {
			de('selfclient_common_error_panel').style.display='';
		}
	} else {
		de('self_client_scope_error').innerHTML = "<%=Util.getI18NMsg(request,"IAM.DEVELOPERCONSOLE.SCOPE.EMPTY")%>";
		$('input[name="scope"]').focus();
	}
}
function showExpiryDropDown(id){
	$(id).siblings('.expiry_dropdown').css("display","block"); //No I18N		
}
function changeExpiryValue(id,value){
	$('input[name=expiry]').val($(id).text());
	$('input[name=expiry]').attr('id',value);//No I18N
}
window.onclick = function(event){
 	  if (!event.target.matches('.menu_icon')){ 		 
 	  var visible = $(".client_icons").is(":visible");
 	  var prev_visible = $('.client_icons:visible').parent().parent();
 		if(visible){
 			$(".client_icons").hide();
 			$(prev_visible).removeClass('view_clients_rows_hover');
 		}
 	  }
 	  if(!(event.target.matches('input[name="expiry"]') || event.target.matches('.drop-down-arrow'))){	 
 	  var visible = $(".expiry_dropdown").is(":visible");
  		if(visible){
  			$(".expiry_dropdown").hide();
  		} 
 	  }
}

function validDomain(dm) {
	var pattern = new RegExp('([a-z]\:\/\/)*[-.\w]*(\/?)([a-zA-Z0-9\-\.\?\,\:\'\/\\\+=&amp;%\$#_@]*)?$');	
	 if(!pattern.test(dm)) {
		return false; 
	 }
	 return true;
}
function goToThisClient(clientZid) {
	loadDeveloperPage(contextpath+"/ui/dconsole/api-clients.jsp?mode=viewclient&client_zid="+euc(clientZid)); //No I18N
}
function showAPIClientError(ele, cause) {
	ele.className = "client_form_field_input_err";
	ele.parentNode.getElementsByClassName('form_field_alert_msg')[0].innerHTML = cause;//No I18N
	ele.focus();
}
function clearAPIClientError(ele) {
	ele.className = "client_form_field_input";
	ele.parentNode.getElementsByClassName('form_field_alert_msg')[0].innerHTML = "&nbsp;";//No I18N
	if(de('client_common_error_panel')) {
		de('client_common_error_panel').style.display = 'none';
	}
}
function resetJavaScript(ele){
	if(ele.value.trim() == 'JS') {
        de('js_client').style.display = '';
	}else {
		de('js_client').style.display = 'none';
	}
}
<% if(dconsoleurl != null) { %>
function switch_to_new() {
	 $.ajax({
	      type: "POST",// No I18N
	      url: "/u/apiconsole/switch",//NO I18N
	      data: csrfParam,
	      success: function(){
	    	   window.location.href='<%=IAMEncoder.encodeJavaScript(dconsoleurl)%>';
	    }
	   });
}
<% } %>
function close_banner() {
	$(".notification_bell").fadeIn(200);
	$("#new_ui_banner").fadeOut(200); //NO I18N
}
$(document).ready(function(){
	$(document).ztooltip();
	$("#ztb-change-photo,#ztb-help").hide();
	$(".notification_bell").unbind("click").click(function(e){
		$(".banner_top").css("display", "block");//NO I18N
		$("#close_icon").css("display", "none");//NO I18N
		$("#new_ui_banner").fadeIn(200).css("top", "40px"); //NO I18N
		$("#new_ui_banner").unbind("click").click(function(eve){
			$("#new_ui_banner, .banner_top").fadeOut(200); //NO I18N
			eve.stopPropagation();
		});
		$("body").unbind("click").click(function(eve){
			$("#new_ui_banner, .banner_top").fadeOut(200); //NO I18N
			eve.stopPropagation();
		});
		e.stopPropagation();
	});
});
window.onload=function() {
	goToClientHome();
}
</script>
<title><%=Util.getI18NMsg(request, "IAM.ZOHO.ACCOUNTS")%></title>
</head>
<body>
	<div class="ztb-topband" id="ztb-topband"><%@ include file="../../ui/profile/header.jspf" %></div>
	<div class="home_circledmain">
		<div class="home_circlediv" >
			<div class="home_circle_api"><%=Util.getI18NMsg(request, "IAM.DEVELOPERCONSOLE.API")%></div>
			<div class="home_circle_crdl"><%=Util.getI18NMsg(request, "IAM.DEVELOPERCONSOLE.CREDENTIALS")%></div>
		</div>
	</div>
	<div class="ajax_content_div" id="ajax_content_div" style="display: none;"></div>	
	<% if(dconsoleurl != null) { %>
		<div id="new_ui_banner" class="new_ui_banner">
		<div class="content_container">
		<p class="banner_content"><%=Util.getI18NMsg(request, "IAM.DEVELOPERCONSOLE.OLDTONEW.BANNER")%></p>
		<button onclick='switch_to_new();' class="banner_button"><%=Util.getI18NMsg(request, "IAM.DEVELOPERCONSOLE.BANNER.BUTTON")%></button>
		</div>
		<span class="banner_top" style="display: none;"></span>
		<div style="position: absolute;" id="close_icon" class="icon-cross close_icon" onclick="close_banner();"></div>
		</div>
		<div class="notification_bell" style="display: none;"><span class="circle"></span>
		</div>
	<% } %>

</body>
</html>