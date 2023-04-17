var browser_opera = false;
var browser_ie = false;
var browser_nn6 = false;
var browser_nn4 = false;
if (document.all)
{
if (window.navigator.appName.toUpperCase=="OPERA")
browser_opera=true;
else
browser_ie=true;
}
else if (document.layers || (!document.all && document.getElementById))
browser_nn6=true;
else if (document.layers)
browser_nn4=true; 
function findPosX(obj) {
var curleft = 0;
if (document.getElementById || document.all) {
curleft += document.body.offsetLeft;
while (obj.offsetParent) {
curleft += obj.offsetLeft;
obj = obj.offsetParent;
}
} 
else if (document.layers) {
curleft += obj.x;
}
return curleft;
}
function findPosY(obj) {
var curtop = 0;
if (document.getElementById || document.all) {
curtop += document.body.offsetTop;
while (obj.offsetParent) {
curtop += obj.offsetTop;
obj = obj.offsetParent;
}
} else if (document.layers) {
curtop += obj.y;
}
return curtop;
}
function findDocDim() {
if (browser_ie) {
return {
width : document.body.offsetWidth + document.body.scrollLeft,
height : document.body.offsetHeight + document.body.scrollTop
}
} else if (browser_nn4 || browser_nn6) {
return {
width : window.innerWidth + document.body.scrollLeft,
height : window.innerHeight + document.body.scrollTop
}
}
}
function getCursorPos(ev) {
if (browser_ie) {
var x = window.event.clientX + document.body.scrollLeft;
var y = window.event.clientY + document.body.scrollTop;
} else if (browser_nn6) {
var x = ev.pageX;
var y = ev.pageY;
}
return { x : x, y : y };
}
var scrollConst = 0;
var scrX = 0, scrY = 0, pgeX = 0, pgeY = 0, srcElement;
if (browser_ie) {
document.attachEvent("onclick", popUpListener);
} else if (browser_nn4 || browser_nn6) {
document.addEventListener("click", popUpListener, true);
}
function popUpListener(e) {
if (browser_ie) {
srcElement = window.event.srcElement;
} else if (browser_nn4 || browser_nn6) {
srcElement = e.target;
scrX = e.screenX;
scrY = e.screenY;
pgeX = e.pageX;
pgeY = e.pageY;
}
}
function getObj(n,d) {
var p,i,x; 
if(!d)
d=document;
if((p=n.indexOf("?"))>0&&parent.frames.length) {
d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);
}
if(!(x=d[n])&&d.all){
x=d.all[n];
}
for(i=0;!x&&i<d.forms.length;i++){
x=d.forms[i][n];
}
for(i=0;!x&&d.layers&&i<d.layers.length;i++){
x=getObj(n,d.layers[i].document);
}
if(!x && d.getElementById){
x=d.getElementById(n);
}
return x;
}
String.prototype.trim = function() {
var x = this;
x = x.replace(/^\s*(.*)/, "$1");
x = x.replace(/(.*?)\s*$/, "$1");
return x;
}
if(!(document.all) && !(document.createElement('div').outerHTML))
{
HTMLElement.prototype.outerHTML
setter =  function(str)
{
var r = this.ownerDocument.createRange();
r.setStartBefore(this);
var df = r.createContextualFragment(str);
this.parentNode.replaceChild(df, this);
return str;
};
HTMLElement.prototype.outerHTML
getter =  function ()
{
return getOuterHTML(this)
};
function getOuterHTML(node)
{
var str = "";
var empties = ["IMG", "HR", "BR", "INPUT"];
switch (node.nodeType)
{
case 1: 
str += "<" + node.nodeName;
for(var i = 0; i < node.attributes.length; i++)
{
if(node.attributes.item(i).nodeValue != null)
{
str += " "
str += node.attributes.item(i).nodeName;
str += "=\"";
str += node.attributes.item(i).nodeValue;
str += "\"";
}
}
var index = -1;
for(var i = 0; i < empties.length; i++)
{
if(empties[i] == node.nodeName)
{
index = i;
break;
}
}
if(node.childNodes.length == 0 && index > 0)
str += ">";
else
{
str += ">";
str += node.innerHTML;
str += "</" + node.nodeName + ">"
}
break;
case 3:  
str += node.nodeValue;
break;
case 4: 
str += "<![CDATA[" + node.nodeValue + "]]>";
break;
case 5: 
str += "&" + node.nodeName + ";"
break;
case 8: 
str += "<!--" + node.nodeValue + "-->"
break;
}
return str;
}
}
function LightenColor(rgbtext, delta) {
var r, g, b, txt;
r = parseInt(rgbtext.substr(1, 2), 16),
g = parseInt(rgbtext.substr(3, 2), 16),
b = parseInt(rgbtext.substr(5, 2), 16),
r += delta;  if (r > 255) r = 255;  if (r < 0) r = 0;
g += delta;  if (g > 255) g = 255;  if (g < 0) g = 0;
b += delta;  if (b > 255) b = 255;  if (b < 0) b = 0;
txt = b.toString(16);	if (txt.length < 2) txt = "0" + txt;
txt = g.toString(16) + txt;	if (txt.length < 4) txt = "0" + txt;
txt = r.toString(16) + txt;	if (txt.length < 6) txt = "0" + txt;
return "#" + txt.toUpperCase();
}
function DarkenColor(rgbtext, delta) {
return LightenColor(rgbtext, delta * -1);
}
function reloadAndCloseWindow(additionalParamsToPass)
{
if(self.parent.window.opener != null)
{
self.parent.window.opener.addRequestParams(self.parent.window.opener.ROOT_VIEW_ID, additionalParamsToPass);
self.parent.window.opener.refreshCurrentView();
}
self.parent.window.close();
}
function enableCustomization(){
var previousData = stateData[ROOT_VIEW_ID]["_D_RP"];
if(previousData != null){
stateData[ROOT_VIEW_ID]["_D_RP"] = previousData + "PERSONALIZE=TRUE";
}
else {
stateData[ROOT_VIEW_ID]["_D_RP"] = "PERSONALIZE=TRUE";
}
refreshCurrentView();
}
function enableViewMode(){
var previousData = stateData[ROOT_VIEW_ID]["_D_RP"];
if(previousData != null){
stateData[ROOT_VIEW_ID]["_D_RP"] = previousData + "PERSONALIZE=FALSE";
}
else {
stateData[ROOT_VIEW_ID]["_D_RP"] = "PERSONALIZE=FALSE";
}
refreshCurrentView();
}
function showBorder(elementId){
element = document.getElementById(getUniqueId(elementId) + "_CT");
element.className = 'showDivBorder';
}
function hideBorder(elementId){
element = document.getElementById(getUniqueId(elementId) + "_CT");
element.className = 'uicomponent';
}
function searchViews(searchObject){
document.getElementById('views').className = 'show';
return updateSearchData('ListViewConfigurations', searchObject);
}
function expandCollapse(elemId, imgID){
var ids = new Array('rmImg', 'avlImg');
var tabs = new Array('_RmTab', '_AvlTab');
if(document.getElementById('_NewTab') != null){
ids[ids.length] = 'newImg';
tabs[tabs.length] = '_NewTab';
}
if(document.getElementById('_SearchTab') != null){
ids[ids.length] = 'srcImg';
tabs[tabs.length] = '_SearchTab';
}
for(var i = 0; i < tabs.length; i++){
currId = tabs[i];
if(currId == elemId){
if(document.getElementById(elemId).className == 'show'){
document.getElementById(elemId).className = 'hide';
document.getElementById(imgID).className = 'collapse';
document.getElementById('views').className = 'hide';
}
else {
document.getElementById(elemId).className = 'show';
document.getElementById(imgID).className = 'expand';
if(currId == '_SearchTab'){
document.getElementById('views').className = 'hide';
document.getElementById('orgTab1').className = 'hide';
document.getElementById('orgTab2').className = 'hide';
document.getElementById('dummyTab1').className = 'show';
document.getElementById('dummyTab2').className = 'show';
}
if(currId == '_AvlTab'){
document.getElementById('views').className = 'show';
document.getElementById('orgTab1').className = 'show';
document.getElementById('orgTab2').className = 'show';
document.getElementById('dummyTab1').className = 'hide';
document.getElementById('dummyTab2').className = 'hide';
if(stateData["ListViewConfigurations"]){
updateSearchData('ListViewConfigurations', document.getElementById('groupSearch'));
}
}
if(currId == '_RmTab'){
document.getElementById('views').className = 'hide';
document.getElementById('orgTab1').className = 'show';
document.getElementById('orgTab2').className = 'show';
document.getElementById('dummyTab1').className = 'hide';
document.getElementById('dummyTab2').className = 'hide';
}
if(currId == '_NewTab'){
document.getElementById('views').className = 'hide';
}
}
}
else {
document.getElementById(currId).className = 'hide';
document.getElementById(ids[i]).className = "collapse";
}
}
}
function enableForm(formName){
document.getElementById(formName + "ReadMode").className = 'hide';
document.getElementById(formName + "EditMode").className = 'show';
}
var customize_uniqueId = null;
function showCustomizeLinks(linksId, id, event,referenceId){
customize_uniqueId = referenceIds[referenceId];
linksId = linksId + referenceId;
getObj(linksId).style.display="block";
getObj(linksId).style.left=findPosX(getObj(id));
getObj(linksId).style.top=findPosY(getObj(id))+getObj(id).offsetHeight;
}
function hideCustomizationMenu(ev)
{
if (browser_ie){
currElement=window.event.srcElement;
}
else if (browser_nn4 || browser_nn6){
currElement=ev.target;
}
var id = currElement.id;
if(id.indexOf("ICM") < 0 && customize_uniqueId != null){
var refId = stateData[customize_uniqueId]["ID"];
var element = document.getElementById("GridCustomizationLinks" + refId);
if(element != null){
if (getObj("GridCustomizationLinks" + refId).style.display=="block"){
getObj("GridCustomizationLinks" + refId).style.display="none";
}
}
element = document.getElementById("TabCustomizationLinks" + refId);
if(element != null){
if (getObj("TabCustomizationLinks" + refId).style.display=="block"){
getObj("TabCustomizationLinks" + refId).style.display="none";
}
}
}
}
function openCustomizationWindow(url, params){
url = url + "&UNIQUEID=" + customize_uniqueId;
window.open(url, customize_uniqueId, params);
}
function openCW(url, type, refId, reqParams, winParams){
var uId = referenceIds[refId];
var vName = stateData[uID]["_VN"];
url = url + "?VIEWNAME=" + vName + "&UNIQUEID=" + uId;
if(type != null){
url = ul + "&TYPE=" + type;
}
if(reqParams != null){
url = url + "&" + reqParams;
}
window.open(url, uId, winParams);
}
function popWindow(url,name,x,y,isResizable)
{
var posX = (screen.width/2)-(x/2);
var posY = (screen.height/2)-(y/2);
var winPref = "width=" + x + ",height=" + y
+ ",innerWidth=" + x + ",innerHeight=" + y
+ ",left=" + posX + ",top=" + posY
+ ",screenX=" + posX + ",screenY=" + posY
+ ",toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=yes,"
+ "resizable="+isResizable;
var newWin = window.open(url,name,winPref);
if (window.focus)
{
newWin.focus();
}
}
function promptViewTitleIfReq(frm)
{
var isNew = frm.ISNEWVIEW.value;
if(isNew != "true"){return true;}
var title = prompt("Enter View Title");
if(title == null)
{
return false;
}
frm.VIEWNAME.value = title;
frm.TITLE.value = title;
return true;
}
function isCookieEnabled(){
var isCookieEnabled = true;
if(document.cookie == ""){
document.cookie = "AcceptsCookiesCheck=yes";
if(document.cookie.indexOf('AcceptsCookiesCheck=yes') == -1){
isCookieEnabled = false;
}
}
document.cookie = "";
return isCookieEnabled;
}
function isBrowserSupported()
{
var agt=navigator.userAgent.toLowerCase();
this.major = parseInt(navigator.appVersion);
this.minor = parseFloat(navigator.appVersion);
this.nav  = ((agt.indexOf('mozilla')!=-1) && (agt.indexOf('spoofer')==-1)
&& (agt.indexOf('compatible') == -1) && (agt.indexOf('opera')==-1)
&& (agt.indexOf('webtv')==-1));
this.nav5up = (this.nav && (this.major >= 5));
this.ie   = (agt.indexOf("msie") != -1);
this.ie5up  = (this.ie && (this.major == 4) && (agt.indexOf("msie 6.0")> 0) );
this.ie5up=this.ie5up||(typeof document.body.style.maxHeight != "undefined");
this.opera = (agt.indexOf("opera") != -1);
if((this.nav5up || this.ie5up) && !this.opera){
return true;
}
else {
return false;
}
}
function clearTextSelection() {
if (window.getSelection) {
window.getSelection().removeAllRanges();
} else if (document.getSelection) {
var s = document.getSelection();
if (s.collapse) s.collapse(true);
if (s.removeAllRanges) s.removeAllRanges();
} else if (document.selection) {
document.selection.empty();
}	
}
function checkForAD(form){
var val = form.j_username.value;
if(val.indexOf("\\") > 0){
var val1 = val.substring(0, val.indexOf("\\"));
val1 = val1.toLowerCase();
var val2 = val.substring(val.indexOf("\\") + 1);
val2 = val2.toLowerCase();
form.j_username.value = val2;
var obj = document.createElement("input");
obj.type = "hidden";
obj.value = val1;
obj.name = "domainName";
form.appendChild(obj);
}
}
function showDropDownMenu(menuId,srcEl,ev, transitionType)
{
var srcObj = document.getElementById(menuId + "_BTN");
var menuItemDiv = document.getElementById(menuId + "_PDM");
var xpos = findPosX(srcObj);
var ypos = findPosY(srcObj) + srcObj.offsetHeight;
if(typeof transitionType == "undefined")
{
transitionType = "Effect.BlindDown";
}
var modal=false;
if(document.getElementById("FreezeLayer")!=null)
{
modal=true;
}
if(modal)
{
showDialog(menuItemDiv.innerHTML,"position=relative, srcElement=" + menuId + "_BTN,closeButton=no,closePrevious=false,draggable=no,closeOnBodyClick=yes,closeOnBodyClick=yes,zAdjust=false,overflow=hidden,modal=yes,removemodal=false,transitionInterval=0.0,transitionType=" + transitionType);
}
else
{
showDialog(menuItemDiv.innerHTML,"position=relative,srcElement=" + menuId + "_BTN,closeButton=no,closePrevious=false,draggable=no,closeOnBodyClick=yes,closeOnBodyClick=yes,zAdjust=false,overflow=hidden,transitionInterval=0.0,transitionType=" + transitionType);
}
}
function enableMenu(menuId, contentId)
{
if(typeof contentId == "undefined")
{
contentId = 'commondropdown';
}
var menuItemDiv = document.getElementById(menuId + "_PDM");
var commonmenuDiv = document.getElementById(contentId + '_PDM');
commonmenuDiv.innerHTML = menuItemDiv.innerHTML;
}
function findScriptTags(val)
{
var outText = false;
var testChk = false;
if(val.indexOf("<script") >= 0 || val.indexOf("<SCRIPT")>=0)
{
var div = document.createElement("div");
div.innerHTML = val;
var eles = div.getElementsByTagName("script");
if(browser_ie){testChk = eles.length>=0;}
else{testChk = eles.length>0;}
if(testChk){ 
outText = true; }
else{
outText = false; }
if(!outText){
var eles = div.getElementsByTagName("SCRIPT");
if(testChk){
outText = true; }
else{
outText = false; } 
}
}
return outText;
} 
function closeMenuDropDown(el)
{
closeDialog(null,el);
}
function getCount(viewName)
{
AjaxAPI.sendRequest({URL:updateStateCookieAndAppendSid("countOnDemand.ma",viewName),METHOD:"GET",PARAMETERS:"viewName="+viewName,STATUSFUNC:"AjaxAPI.showRespMsg"});
}
function setFetchPrevPageAndRefreshView(viewName)
{
var viewUniqueId = (viewName && (typeof viewName === "string") && viewName.trim().length > 0 && viewName.trim() !== "undefined" && viewName.trim() !== "null") ? viewName : ROOT_VIEW_ID;
ajaxOptions = AjaxOptions.getAsAjaxOptions({});
var viewUrl = getViewURL(viewUniqueId);
if (RESTFUL == true) {
viewUrl = updateStateCookieAndAppendSid(viewUrl, viewUniqueId);
}
ajaxOptions.update({ URL: viewUrl, SRCVIEW: viewUniqueId, PARAMETERS : "fetchPrevPage=true", ROOTVIEWID_RN: viewUniqueId, ONSUCCESSFUNC: "updateViewInResp", METHOD: "GET"});
ViewAPI.sendAjaxRequest(ajaxOptions);
}
