var localizeMsgColor = "#FFFF00"; 
var localizedMsgColor = "#FF9900";
var saveLocalizedMsgURL= CONTEXT_PATH + "/components/jsp/save.jsp";
var localizeText = new Array();
var localizeLayer, localizeIEHack, localizeHintLayer, currLocalizeMsg;
var editonscreenhome="Opmanager.cc";
var gpreview_username="www";
var gpreview_passwd="wwwwww";
var messagetranslated=false;
function startLocalize()
{
setCookie('__i18n','1',null,"/");
document.location.href=document.location.href;	
}
function stopLocalize()
{
deleteCookie('__i18n',"/");
document.location.href=document.location.href;	
}
function localize() {
if(getCookie('__i18n') != null)
{
localizeHintLayer = document.getElementById("localizeHint");
if(localizeHintLayer != null)
{   
localizeHintLayer.id = "localizeHint";
localizeHintLayer.style.height = "1px";
localizeHintLayer.style.overflow = "hidden";
localizeHintLayer.style.display= "block";
}  
localizeLayer = document.createElement("DIV");
localizeLayer.id = "localizeLayer";
localizeLayer.style.zIndex = "500";
innerHTML = '<table cellspacing="0" cellpadding="0" width="100"><tr><td class="boxTL"></td><td class="boxTC"></td><td class="boxTR"></td></tr>';
innerHTML += '<tr><td class="boxML"></td><td class="boxContent">';
innerHTML += '<table width="100%" border="0" cellspacing="0" cellpadding="0"><tr><td class="heading">Localize:</td>';
innerHTML += '<td class="heading"><div align="right"><button class="closeButton" onClick="hideLocalizeLayer()"></button></div></td>';
innerHTML += '</tr><tr><td nowrap>English Phrase:</td><td id="englishPhrase"></td></tr><tr><td nowrap>Local Phrase:</td>';
innerHTML += '<td><input name="localPhrase" id="localPhrase" type="text" size="30" onkeypress="updateLocalizeMsg(event)"></td></tr>';
innerHTML += '<tr><td></td><td height="30"><input type="submit" class="btn" value="Save" onClick="updateLocalizeMsg(event)">';
innerHTML += '<input type="button" class="btn" value="Cancel" onClick="hideLocalizeLayer()"></td>';
innerHTML += '</tr></table></td><td class="boxMR"></td></tr><tr><td class="boxBL"></td><td class="boxBC"></td>';
innerHTML += '<td class="boxBR"></td></tr></table>';
localizeLayer.innerHTML = innerHTML;
document.body.appendChild(localizeLayer);
if (browser_ie && !browser_opera) {
localizeIEHack = document.createElement("IFRAME");
localizeIEHack.scrolling = "no";
localizeIEHack.frameBorder = 0;
localizeIEHack.style.position = "absolute";
localizeIEHack.style.zIndex = "499";
localizeIEHack.style.filter = 'progid:DXImageTransform.Microsoft.Alpha(style=0,opacity=0)';
document.body.appendChild(localizeIEHack);
}
if (browser_nn4 || browser_nn6 || browser_opera) localizeHintHeight = 33;
else if (browser_ie) localizeHintHeight = 36;
if(localizeHintLayer != null)
{
localizeHintIntvl = window.setInterval("showLocalizeHint()", 100);
}
}
}
function localizeOpenBubble(ths,ev)
{
showLocalizeLayer(this.spanTag);
if (browser_ie) window.event.cancelBubble = true;
else if (browser_nn6) ev.stopPropagation();
return false;
}
var localizeHintCurrHeight = 1, localizeHintHeight;
function showLocalizeHint() {
if (localizeHintCurrHeight <= localizeHintHeight) {
localizeHintLayer.style.height = localizeHintCurrHeight + "px";
localizeHintCurrHeight += 5;
} else {
window.clearInterval(localizeHintIntvl);
}
}
var localizeLink;
function showLocalizeLink(spanEl,event)
{
if(localizeLink == null)
{
localizeLink = document.createElement("img");
localizeLink.src =  CONTEXT_PATH + "/components/images/editicon.gif";
localizeLink.onclick=localizeOpenBubble;
localizeLink.style.position = "absolute";
localizeLink.style.zIndex = "200";
document.body.appendChild(localizeLink);
}
localizeLink.style.left = (findPosX(spanEl) + spanEl.offsetWidth) + "px";
localizeLink.style.top = findPosY(spanEl) +"px";
localizeLink.spanTag = spanEl;
}
function showLocalizeLayer(spanTag) {
currLocalizeMsg = spanTag;
if (browser_ie && !browser_opera) {
localizeIEHack.style.display = "block";
localizeIEHack.style.top = (parseInt(findPosY(currLocalizeMsg)) + currLocalizeMsg.offsetHeight) + "px";
localizeIEHack.style.left = findPosX(currLocalizeMsg) + "px";
}		
localizeLayer.style.display = "block";
localizeLayer.style.top = (parseInt(findPosY(currLocalizeMsg)) + currLocalizeMsg.offsetHeight) + "px";
localizeLayer.style.left = findPosX(currLocalizeMsg) + "px";
if (currLocalizeMsg.className == "localizeMsg") {
getObj("englishPhrase").innerHTML = currLocalizeMsg.getAttribute('msgfmt');
getObj("localPhrase").value = "";		
} else {
getObj("englishPhrase").innerHTML = currLocalizeMsg.getAttribute('msgfmt');
getObj("localPhrase").value = currLocalizeMsg.innerHTML;
}
window.setTimeout("localizeFocus()", 100);
}
function localizeFocus() {
getObj("localPhrase").focus();
}
function hideLocalizeLayer() {
localizeLayer.style.display = "none";
if (browser_ie && !browser_opera) localizeIEHack.style.display = "none";	
}
function updateLocalizeMsg(ev) {
if (browser_ie) var ev = window.event;
if ((ev.type == "keypress" && ev.keyCode == 13) || ev.type == "click") {
var lMsgStr=getObj("localPhrase").value;
if(lMsgStr == '')
{
alert('Local Phrase is Empty, enter value.');
return;
}
messagetranslated=true;
var lMsgKey=currLocalizeMsg.getAttribute('msgid');
var flag=0;
saveLocalizedMsg(lMsgKey,lMsgStr,saveLocalizedMsgURL);	
currLocalizeMsg.innerHTML =lMsgStr;
hideLocalizeLayer();
if (currLocalizeMsg.className == "localizeMsg") {
delta = 0;
fadeOutIntvl = window.setInterval("fadeOutLocalizeMsg()", 1);
} else {
delta = -255;
currLocalizeMsg.style.backgroundColor = DarkenColor(currLocalizeMsg.style.backgroundColor, -255);
fadeInIntvl = window.setInterval("fadeInLocalizeMsg()", 1);
}
}
}
function getXMLhttp() {
if(window.XMLHttpRequest) {
var xmlhttp = new XMLHttpRequest();
} else {
try {
var xmlhttp = new ActiveXObject( 'Microsoft.XMLHTTP' );
} catch(ee) {
try { 
var xmlhttp = new ActiveXObject( 'Microsoft.XMLDOM' );
} catch(e) { 
var xmlhttp = new ActiveXObject( 'Msxml2.XMLHTTP' ); 
}
}
}
return xmlhttp;   
}
function saveLocalizedMsg(msgKey,msgStr,url)
{
AjaxAPI.sendRequest({URL:saveLocalizedMsgURL,
PARAMETERS:'msgKey='+msgKey+'&msgStr='+msgStr,
METHOD:'POST',OPSTATUSID:'savestatdiv'});
}
var fadeColor, delta = 0;
function fadeOutLocalizeMsg() {
fadeColor = LightenColor(localizeMsgColor, delta);
if (delta <= 255) {
currLocalizeMsg.style.backgroundColor = fadeColor;
delta += 75;
} else {
window.clearInterval(fadeOutIntvl);
currLocalizeMsg.style.backgroundColor = DarkenColor(currLocalizeMsg.style.backgroundColor, -255);
delta = -255;
fadeInIntvl = window.setInterval("fadeInLocalizeMsg()", 1);
}
}
function fadeInLocalizeMsg() {
fadeColor = DarkenColor(localizedMsgColor, delta);
if (delta < 0) {
var code = DarkenColor(localizeMsgColor, delta);
currLocalizeMsg.style.backgroundColor = fadeColor;
delta += 75;
} else {
delta = 0;
currLocalizeMsg.className = "localizedMsg";
currLocalizeMsg.style.backgroundColor = localizedMsgColor;
window.clearInterval(fadeInIntvl);
}
}
function getLocalizedMsg(msgKey)
{	
if(typeof i18nJSON != 'undefined')
{
return I18N.getMsg(msgKey);
}
if(typeof jsi18nmessages != 'undefined')
{
return jsi18nmessages.bindings[0][msgKey]
}
if(frames['jskeysframe'] == null)
{
return msgKey;
}
var divEL = frames['jskeysframe'].document.getElementById(msgKey);
if(divEL == null)
{
return msgKey;
}
return divEL.innerHTML;
}
function setLocaleID(menuItemName,refId,additionalParams,index)
{
var tblModel = getTableModel(refId);
var colInd2  = tblModel.getColumnIndex("LocaleID");
var locale_id = tblModel.getValueAt(index,colInd2);
alert("Locale id is " + locale_id);    
setCookie('__locale_id',locale_id,null,"/");
document.location.href=document.location.href;	
}
function editTranslation(locale_id)
{
deleteCookie('__locale_id', '/');
setCookie('__i18n', '1', null,'/');
setCookie('__locale_id', locale_id, null,'/');
document.location.href='I18nEditTranslation.ma?locale_id=' + locale_id + '&fwd_path=' + '/' + editonscreenhome;
}
function previewTranslation(locale_id)
{
deleteCookie('__locale_id', '/');
deleteCookie('__i18n','/');
setCookie('__locale_id', locale_id, null,'/');
document.location.href=CONTEXT_PATH + '/' + editonscreenhome;
}
function previewOthersTranslation(locale_id)
{
deleteCookie('__locale_id', '/');
deleteCookie('__i18n','/');
setCookie('__locale_id', locale_id, null,'/');
setCookie('__preview_mode', 'true', null,'/');
document.location.href=CONTEXT_PATH + '/' + editonscreenhome;
}
function gotoAdvancedEdit(locale_id)
{
deleteCookie('__locale_id','/');
deleteCookie('__i18n', '/');
setCookie('__locale_id', locale_id, null,'/');
parent.location.href="advancededit.cc";
}
function deleteAllI18nCookies()
{
deleteCookie('__locale_id','/');
deleteCookie('__i18n', '/');
deleteCookie('__preview_mode', '/');
}
function setEndUserInfo(servername, serverport)
{
if(servername != 'null')
{
setCookie('__endusermc_name', servername, null,'/');
setCookie('__endusermc_port', serverport, null,'/');
}
}
function guestLogin(locale_id, count)
{
var url = "Authenticate.cc";
var params = "SUBREQUEST=true";
if(count > 2)
{
return;
}
if(count > 0)
{
url = 'j_security_check?';
params = params + "&j_username=" + gpreview_username + "&j_password=" + gpreview_passwd;
}
AjaxAPI.sendRequest({URL:url,LOCALE_ID:locale_id, COUNT: count, ONSUCCESSFUNC:'checkLoginResponse',PARAMETERS:params});
return false;
}
function checkLoginResponse(response,reqOptions)
{
var count = reqOptions["COUNT"];
var locale_id = reqOptions["LOCALE_ID"];
if(response.responseText.indexOf("Authenticate Success") >= 0){
previewOthersTranslation(locale_id);
}
else {
guestLogin(locale_id,count+1);
}
}
function changeLanguage(view)
{
if(view == null)
{
document.location.href='guestviewotherstranslations.ucc?lang_id=' + document.language_form.lang_id.value;
}
else
{
document.location.href=view + '?lang_id=' + document.language_form.lang_id.value;
}
}
var I18N = new function(){} 
I18N.getMsg= function(key,valary)
{
var value;
if(typeof i18nJSON !="undefined" && i18nJSON != null)
{
key = key.trim();
value = (i18nJSON[key]!=null)?i18nJSON[key]:key;
}
else
{
value = key;
}
if(valary)
{
for(var i=0; i < valary.length; i++)
{
var regExp = new RegExp("\\\{" + i + "\\\}");   
value = value.replace(regExp, valary[i]);  
}
}
return value;  
}
