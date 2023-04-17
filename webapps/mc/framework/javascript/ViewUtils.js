var showError = false;
var REFRESH_THROUGH_IFRAME = false;
var globalURL = new Array();
var selView = -1;
var viewCount = 0;
function refreshCurrentView()
{ 
openURL(getViewURL(ROOT_VIEW_ID));
}
function asynchRefreshSubView(id, previousTime) 
{
AjaxAPI.sendRequest({
PRETIME: previousTime,
TARGET: "_view_" + id,
ASYNCHRONOUS: true,
ONSUCCESSFUNC: refreshSuccess,
URL: updateStateCookieAndAppendSid('/' + id + ".cc")
});}
function refresh(previousTime) {
var viewName = document.getElementById("showedView").value;
tmpTime = document.getElementById("time").value;
if (previousTime != "-1") {
asynchRefreshSubView(viewName, previousTime);
}
}
function refreshSuccess(res,reqOpt)
{
var pretime=reqOpt["PRETIME"];
res.responseText+="<script>sRefresh('"+pretime+"')</script>";
}
function sRefresh(previousTime)
{
alert("sRefresh"+previousTime);
var index = -1;
var i = 0;
while (true) {
var obj = document.getElementById(viewName + "_h_" + i);
if (obj) {
var idx = obj.innerHTML.indexOf("Time");
if (idx != -1) {
index = i;
break;
}
} else {
break;
}
i++;
}
if (index == -1) {
return;
}
timeValue = document.getElementById(viewName + "_r_0_" + index).innerHTML;
if (previousTime != "-1") {
console.log("inside if previousTime");
if (timeValue != previousTime) {
var isIgnore = document.getElementById("ignore").value;
if (isIgnore == "false") {
document.getElementById("msg").style.visibility = "visible";
setTimeout("hideMsg()", 8000);
} else {
document.getElementById("ignore").value = "false";
}
}
}
if (time != "-1") {
console.log("inside if time-->" + time * 1000);
setTimeout("refresh(timeValue)", time * 1000);
}
}
function openURL(url,windowname,windowparams, appendstate)
{
if( (appendstate == null) || (appendstate == true))
{
url = updateStateCookieAndAppendSid(url);
}
if((!windowname) || (windowname == ""))
{
windowname="_self";
}
if(windowname == "_self")
{
window.location.href=url; 
}
else
{
window.open(url,windowname,windowparams);
}
}
function handleEvent(actionSource,selId,refreshLevel, isAuthReq,callbackInSynch,hideStatusOnSuccess,param)
{
var actionURL = actionSource + ".ve";
actionURL += "?" + "SELECTEDVIEWIDX=" +selId;
if(isAuthReq && !_GEN_ISUSER_CREDENTIAL_PRESENT){
var url = "Authenticate.acc";
var callBack = function()
{ 
_GEN_ISUSER_CREDENTIAL_PRESENT = true;
processURLBasedOnLevel(actionURL,actionSource,refreshLevel,false,callbackInSynch,hideStatusOnSuccess,param);
}
AjaxAPI.sendRequest({URL:url,ONSUCCESSFUNC:callBack});
}
else
{
processURLBasedOnLevel(actionURL,actionSource,refreshLevel,selId,callbackInSynch,hideStatusOnSuccess,param);
}
}
function processURLBasedOnLevel(url,id,refreshLevel,selId,callbackInSynch,hideStatusOnSuccess,param)
{
globalURL=url;
var viewUniqueId = getUniqueId(id);
var callback =function(response,requestOptions)
{
response.responseText+="<script>  hideTabLoadingStatus();</script>";
}
var callbackSynch =function(response,requestOptions){}		
if(refreshLevel == -1)
{    
openURL(url);
}
else if(refreshLevel == -3 ||refreshLevel == -4)
{    
var viewDiv = document.getElementById(viewUniqueId + "_CT");
var dca = viewDiv.getAttribute("associateddca");
var target="_mcframe_"+dca;
url=(url.indexOf("?")!=-1)?url+="&&AjaxTab=true":url+="?AjaxTab=true";
url+="&&"+param;
if(refreshLevel == -4) 
{
url+="&&BackSupport=true";
}
if(callbackInSynch==true && hideStatusOnSuccess)
{	
AjaxAPI.sendRequest({METHOD:"GET",URL:url,ASYNCHRONOUS:false,ONSUCCESSFUNC:callback,TARGET:target,MCFRAMEACTION:'replace'});
}
else if(callbackInSynch==true)
{	
AjaxAPI.sendRequest({METHOD:"GET",URL:url,ASYNCHRONOUS:false,ONSUCCESSFUNC:callbackSynch,TARGET:target,MCFRAMEACTION:'replace'});
}
else
{
showTabLoadingStatus();
AjaxAPI.sendRequest({METHOD:"GET",URL:url,ASYNCHRONOUS:true,ONSUCCESSFUNC:callback,TARGET:target,MCFRAMEACTION:'replace'});
}
}
else if(refreshLevel == 0)
{
handleSubRequest(url,viewUniqueId);
}
else if(refreshLevel == -2)
{
var viewDiv = document.getElementById(viewUniqueId + "_CT");
var dca = viewDiv.getAttribute("associateddca");
var parView = getParentViewForDCA(dca);
handleSubRequest(url,parView);
}
else
{
var viewToRefresh = viewUniqueId;
for(var i = 0; i < refreshLevel; i++)
{
viewToRefresh = getUniqueId(stateData[viewToRefresh]["_PV"]);
if(viewToRefresh == null)
{
break;
}
}
if((viewToRefresh == ROOT_VIEW_ID) || (viewToRefresh == null))
{
openURL(url);
}
else
{
handleSubRequest(url,viewToRefresh);
}
}
}
function refreshSubView(id,useOldState)
{
var navigate=true;
if(REFRESH_THROUGH_IFRAME!="undefined" && REFRESH_THROUGH_IFRAME==false)
{
navigate=false;
}	  
ViewAPI.refreshView({VIEWTOREFRESH_RN:id,USEOLDSTATE_RN:(useOldState == true),NAVIGABLE_RN:navigate,STATUSFUNC:AjaxAPI.dummyFunction});
}
function handleSubRequest(reqUrl,rootViewId,useOldState,navigable)
{
var reqOptions = {URL:reqUrl,ONSUCCESSFUNC:"updateViewInResp",ROOTVIEWID_RN:rootViewId,USEOLDSTATE_RN :useOldState,NAVIGABLE_RN:navigable,METHOD:"GET"};
ViewAPI.sendAjaxRequest(reqOptions);
}
function appendSubRequestArgs(reqUrl)
{
return getURLSuffixed(reqUrl) + "SUBREQUEST=true";
}
function getViewURL(id, extension)
{
var uniqueId = getUniqueId(id);
var viewUrl = "";
if(window.stateData && window.stateData[uniqueId])
{
if (extension == null) {
extension = "cc";
}
viewUrl = stateData[uniqueId]._VN + "." + extension + "?UNIQUE_ID=" + uniqueId;
var params = stateData[uniqueId]["_D_RP"];
if (params != null) {
params = getEscapedQueryString(params);
viewUrl += "&" + params;
}
}
else
{
if (extension == null) {
extension = "ec";
}
var viewUrl = uniqueId + "." + extension + "?UNIQUE_ID=" + uniqueId;
}
return viewUrl;
}
function addRequestParams(id, reqParams)
{
var uniqueId = getUniqueId(id);
if(reqParams == null)
{
return; 
}
var params = stateData[uniqueId]["_D_RP"];
if(params != null)
{
params = params + "&" + reqParams;
}
else 
{
params = reqParams;
}
stateData[uniqueId]["_D_RP"] = params;
}
function updateTimeToLoad(timeToLoad,win)
{
var timeEl = win.document.getElementById("timeToLoad");
if(timeEl)
{
timeEl.innerHTML = "" + timeToLoad;
}
}
function scheduleViewForRefresh(id,initSchedTime,reScheduleInterval)
{
var viewUniqueId = getUniqueId(id);
if(!window._RSC)
{
_RSC=new Object();
}
if(_RSC[viewUniqueId] != null)
{
return;
} 
if(!reScheduleInterval)
{
reScheduleInterval = -1;
}
_RSC[viewUniqueId]= reScheduleInterval;
setTimeout("refreshScheduled('" + viewUniqueId + "')",initSchedTime);
}
function stopScheduledRefreshForView(id)
{
var viewUniqueId = getUniqueId(id);
if(window["_RSC"])
{
_RSC[viewUniqueId] = null;
delete _RSC[viewUniqueId];
}
}
function refreshScheduled(viewUniqueId)
{
if(!_RSC[viewUniqueId])
{
return;
}
if(!isViewVisible(viewUniqueId))
{
stopScheduledRefreshForView(viewUniqueId);
return;
}
refreshSubView(viewUniqueId,true,false);   
if(_RSC[viewUniqueId] == -1)
{
stopScheduledRefreshForView(viewUniqueId);
}
else
{
setTimeout("refreshScheduled('" + viewUniqueId + "')",_RSC[viewUniqueId]);    
} 
}
function createForm(action,target,method,name)
{
var newFrm = document.createElement("form");
setAttrOnFrm(newFrm,"name",name);
setAttrOnFrm(newFrm,"method",method);
setAttrOnFrm(newFrm,"target",target);
setAttrOnFrm(newFrm,"action",action);
return newFrm;
}
function setAttrOnFrm(frm,attrName,attrValue)
{
if(attrValue != null)
{
frm.setAttribute(attrName,attrValue);
}
}
function addHiddenInput(frm,name,value)
{
var newElement = document.createElement("input");
newElement.setAttribute("type","hidden");
newElement.setAttribute("name",name);
newElement.setAttribute("value",value);
frm.appendChild(newElement);
}
function submitFormAsSubReq(frm,target,actionSrc,rootViewId)
{
if(rootViewId == null)
{
rootViewId = actionSrc;
}
handleStateForForm(frm,actionSrc,rootViewId,true,target);
var reqOptions = {"URL":frm.action,"ONSUCCESSFUNC":"updateViewInResp"};
frm.action = AjaxAPI.getAsNavigableAjaxURL(reqOptions);
frm.className = "hide";
document.body.appendChild(frm);
frm.submit();
}
function isViewVisible(uniqueId)
{
return document.getElementById(uniqueId + "_CT") != null;  
}
function isViewStateNeeded(uniqueId)
{
if(isViewVisible(uniqueId))
{
return true;
}
var dac = getContentAreaFromState(uniqueId);
if(dac != null)
{
return true;
}
}
function replaceWithResponseView(response, viewToReplace)
{
var replacingView = getRootViewEl(response);
var replacedEl = document.getElementById(viewToReplace + "_CT");
if(replacedEl == null)
{
var replacedEl = document.getElementById(viewToReplace);
if(replacedEl != null)
{
replacedEl.appendChild(replacingView);
}
}
else
{
replacedEl.parentNode.replaceChild(replacingView, replacedEl);     
}
}
function  replaceView(viewToReplace,replacingView)
{
var replacedEl = document.getElementById(viewToReplace + "_CT");
if(replacedEl == null) 
{
throw new Error("The html content for viewToReplace arg ("+ viewToReplace +") passed is not present");
}
oldViews[viewToReplace] = replacedEl;
if(oldViews[replacingView] == null)
{
throw new Error("The html content for replacingView ("+ replacingView +") passed is not present in the client cache"); 
}
replacedEl.parentNode.replaceChild(oldViews[replacingView],replacedEl);
}
function getParentView(viewRefId)
{
return getUniqueId(getState(viewRefId,"_PV"));
}
var ViewAPI = new function(){}
ViewAPI.refreshView = function(reqOptions)
{
reqOptions = AjaxOptions.getAsAjaxOptions(reqOptions);
var viewUniqueId = getUniqueId(reqOptions.v("VIEWTOREFRESH_RN"));
if(!(isViewVisible(viewUniqueId)))
{
return;
}
var viewUrl = getViewURL(viewUniqueId);
if(RESTFUL == true)
{
viewUrl = updateStateCookieAndAppendSid(viewUrl, viewUniqueId);	
}  
reqOptions.update({URL:viewUrl,SRCVIEW:viewUniqueId,ROOTVIEWID_RN:viewUniqueId,ONSUCCESSFUNC:"updateViewInResp",METHOD:"GET"});
ViewAPI.sendAjaxRequest(reqOptions);
}
ViewAPI.sendAjaxRequest = function(reqOptions)
{
reqOptions = AjaxOptions.getAsAjaxOptions(reqOptions);
if(!reqOptions.isTrue("USEOLDSTATE_RN",false))
{
var reqUrl = reqOptions["URL"];
reqUrl = updateStateCookieAndAppendSid(reqUrl,reqOptions["ROOTVIEWID_RN"]);
reqOptions["URL"] = reqUrl;
}
else
{
var reqUrl = reqOptions["URL"];
reqUrl = reqUrl + (reqUrl.indexOf("?") == -1 ? "?" : "&") + (new Date()).getTime();
reqOptions["URL"] = reqUrl;
}
if(RESTFUL == true)
{
var url = reqOptions["URL"];
url = appendURLStateParameters(url);
reqOptions["URL"] = url;
}
var navigable = reqOptions.isTrue("NAVIGABLE_RN",false);
if(navigable && AjaxAPI.navigFrameName)
{
AjaxAPI.sendNavigableRequest(reqOptions);
}
else
{
AjaxAPI.sendRequest(reqOptions);
}
}
ViewAPI.getEnclosingViewDiv = function(srcEl)
{
return DOMUtils.getParentWithAttr(srcEl,"unique_id","*");
}
ViewAPI.setAttributesOnViewDiv = function(viewId,attributes)
{
var viewDiv = document.getElementById(viewId + "_CT");
for(var attrName in attributes)
{
viewDiv.setAttribute(attrName,attributes[attrName]);
}
}
function registerTabEvent(refid,id,viewname)
{
var currentHash=window.location.hash.substring(1);
selView=refid+"t"+id;
var newHash;
if(currentHash.indexOf(refid)!=-1)
{
newHash=currentHash.substring(0,currentHash.indexOf(refid))+selView;
}
else
{
if(currentHash=='')
newHash=selView;
else
newHash=currentHash+"/"+selView;
}
if(window["lastObserved"]!=null && window["lastObserved"]!="undefined" && window["lastObserved"] !="")
{
if(window["lastHash"]!=null && window["lastHash"]!="undefined")
{
var elArray=window["lastHash"].split("/");
var lastEl=elArray[elArray.length-1];
if(lastEl==selView){
window['sameTabException']=true;
Event.observe(viewname+"_"+id, "click", function(event) {
browserHistory.onBrowserAddressChanged();
});
return;
}
}
}
window["lastObserved"]=selView;
Event.observe(viewname+"_"+id, "click", function(event) {
if(window["lastUpdate"]!=newHash )
{
showTabLoadingStatus();
window['sameTabException']=false;
browserHistory.put(newHash);
window["lastUpdate"]=newHash;
}
}); 
return;
}
function updateURLHash()
{
var hashString="";
var tabEls=DOMUtils.getChildElsWithAttr(document.body,'tabid','*');
for(var i=0;i<tabEls.length;i++)
{
var classname=tabEls[i].className;
if(classname.indexOf("notselected")==-1)
{
if(hashString!="")
{
hashString+="/"+tabEls[i].getAttribute('tabid');
}
else
{
hashString=tabEls[i].getAttribute('tabid');
}
}
}
window['hashString']=hashString;
if(hashString!=''&& hashString!=null && hashString!="undefined")
document.location.hash=hashString;
}
function addToURLHash(selId,viewno)
{
var hash=document.location.hash;
if(hash.indexOf(viewno)==-1)
{
var newHash=hash+"/"+viewno+"t"+selId;
if(browser_ie)
{
window.location.hash=newHash;
}
}
return;
}
function showTabLoadingStatus(id)
{
if(id!=null)
{
var el=document.getElementById(id);	
var parentel=el.parentNode;
var className=parentel.className;
if(className.indexOf("not")==-1)
{
return;
}
}
if(window["TabLoading"] )
{
return;
}
else{
window["TabLoading"]=true;
if(document.getElementById("tabloading")!=null && document.getElementById("tabloading")!="undefined")
{
showDialog(document.getElementById("tabloading").innerHTML,"position=absmiddle,closePrevious=false",null,"dummyfunc",false);
}
else
{
var loadingDiv="<div id='tabloading' class='status-window-table'>Loading ...<div class='dialogtype'/></div>";
showDialog(loadingDiv,"position=absmiddle,closePrevious=false",null,"dummyfunc",false);
}
}
}
function hideTabLoadingStatus()
{
if(!window["TabLoading"])
{
return;
}
if(document.getElementById("tabloading")!=null)
{
closeDialog(null,document.getElementById("tabloading"));
}
window["TabLoading"]=false;
}
