function addViewWithParamsToCA(viewToOpen,id,contentAreaName,requestParams,newViewId)
{
updateViewInCA(viewToOpen,id,null,contentAreaName,null,true,newViewId,requestParams);
}
function addViewToCA(viewToOpen,id,tplParams,contentAreaName,index,newViewId)
{
updateViewInCA(viewToOpen,id,tplParams,contentAreaName,index,true,newViewId);
}
function updateViewInCA(viewToOpen,id,tplParams,contentAreaName,index,addToList,newViewId,requestParams,isAjax)
{
if(typeof isAjax != 'undefined' && isAjax == true)
{
var mcframcaction = "update";
if(addToList == false)
{
mcframcaction = "clear";
}
AjaxAPI.sendRequest({URL:viewToOpen + ".cc", PARAMETERS: requestParams, TARGET:"_mcframe_" + contentAreaName, MCFRAMEACTION:mcframcaction});
return true;
}
var uniqueId = getUniqueId(id);
var actUrl = "ShowViewInContentAreaAction.do?VIEW_TO_OPEN=" + viewToOpen;
if(contentAreaName != null){
actUrl = actUrl + "&CONTENTAREANAME=" + contentAreaName;
}
if(newViewId != null)
{
actUrl = actUrl + "&VIEW_UNIQUEID=" + newViewId;
}
if(addToList)
{
actUrl = actUrl + "&ADDTOLIST=true";
}
if(id != null)
{
actUrl += "&ACTION_SOURCE=" + getUniqueId(id);
}
if(tplParams != null)
{
actUrl  += constructURLParams(tplParams,id,[index]);
}
if(requestParams != null){
actUrl = actUrl + "&" + requestParams;
}
contentAreaName = getContentAreaName(contentAreaName);
var parView = getParentViewForDCA(contentAreaName);
if(parView != null)
{
var actionFunc = document.getElementById(parView +"_CT").getAttribute("actionfunc");
if(actionFunc != null)
{
executeFunctionAsString(actionFunc,window,parView,contentAreaName,actUrl);
return;
}
}
openURL(actUrl);
}
function getDacArray(contentAreaName)
{
contentAreaName = getContentAreaName(contentAreaName);
var dac = stateData[ROOT_VIEW_ID][contentAreaName+"_LIST"];
if(!dac){  return null; }
return dac.split("-");
}
function associateParentViewForDCA(contentAreaName,parentView)
{
if(window["dcaParView"] == null)
{
window["dcaParView"] = new Object();
}
window["dcaParView"][contentAreaName] = parentView; 
}
function getParentViewForDCA(contentAreaName)
{
if(window["dcaParView"] != null)
{
return window["dcaParView"][contentAreaName];
}
else
{
return null;
}
}
function clearContentArea(dcaName,dontRefresh)
{
updateDac(null,dcaName);
_handleRefresh(dontRefresh,dcaName);
}
function updateDac(dacString,contentAreaName)
{
contentAreaName = getContentAreaName(contentAreaName);
stateData[ROOT_VIEW_ID][contentAreaName +"_LIST"] = dacString;
addToOnLoadScripts("updateViewsBasedOnDCA",window,contentAreaName);
}
function updateViewsBasedOnDCA(contentAreaName)
{
var viewDivs = DOMUtils.filterElements(document.getElementsByTagName("div"),null,"associateddca",contentAreaName);
var dacArray = getDacArray(contentAreaName);
for(var i =0; i < viewDivs.length; i++)
{
executeFunctionAsString(viewDivs[i].getAttribute("dcalistenerfunc"),window,viewDivs[i],contentAreaName,dacArray);
}
}
function popContentArea(index,contentAreaName,dontRefresh)
{
var dacArr = getDacArray(contentAreaName);
contentAreaName = getContentAreaName(contentAreaName);
if(index == -1)
{
index = dacArr.length -1;
}
while( (dacArr.length-1) > index)
{
dacArr.pop();
}
var dacList = dacArr[0];
for(var i=1; i<dacArr.length; i++)
{
dacList = dacList + "-" + dacArr[i];
}
updateDac(dacList,contentAreaName);
_handleRefresh(dontRefresh,contentAreaName);
}
function _handleRefresh(dontRefresh,dacName)
{
if(!dontRefresh)
{
dacName = getContentAreaName(dacName);
var parView = getParentViewForDCA(dacName);
if(parView != null)
{
var actionFunc = document.getElementById(parView +"_CT").getAttribute("refreshfunc");
if(actionFunc != null)
{
executeFunctionAsString(actionFunc,window,parView,dacName);
return;
}
}
refreshCurrentView();
}
}
function replaceContentArea(replacingView,contentAreaName,removeState)
{
var dacArr = getDacArray(contentAreaName);
if(!dacArr){return;}
var viewToReplace = getUniqueId(dacArr.pop());
if(viewToReplace == replacingView)
{
return;
}
replaceView(viewToReplace,replacingView);
if(removeState)
{     
for(var i = 0; i < dacArr.length; i++)
{
var curId = dacArr[i];
if(replacingView != getUniqueId(curId))
{ 	
removeStateForView(getUniqueId(curId));
}
}
}
var breadCrumbDiv = document.getElementById("BreadCrumbs");
if(breadCrumbDiv)
{
breadCrumbDiv.innerHTML = "";
}
updateDac(getReferenceId(replacingView),contentAreaName);
}
function closeSrcView(element)
{
var parent = DOMUtils.getParentWithAttr(element,"closefunc");
var uid = parent.getAttribute("unique_id");
closeView(uid, false);
}
function closeView(uniqueId,dontRefresh)
{
if(uniqueId == ROOT_VIEW_ID)
{
window.close();
return;
}
var pos = getDCAPosition(uniqueId);
if(pos == -1)
{
return;
}
var dca = getContentAreaFromState(uniqueId);
if(pos > 0)
{
popContentArea(pos -1,dca,dontRefresh);
}
else 
{
clearContentArea(dca,dontRefresh);
}
}
function getDCAPosition(uniqueId)
{
var dca = getContentAreaFromState(uniqueId);
var arr = getDacArray(dca);
var refId = getReferenceId(uniqueId);
for(var i = 0; i < arr.length; i++)
{
if(arr[i] == refId)
{
return i;
} 
} 
return -1;
}
function getContentAreaName(contentAreaName)
{
if((contentAreaName == null) || ("DEFAULTCONTENTAREA" == contentAreaName))
{
return ROOT_VIEW_ID + "_CONTENTAREA";
}
return contentAreaName;
} 
function getContentAreaFromState(uniqueId)
{
var dca =  stateData[uniqueId]["PDCA"];
var curView= uniqueId;
var viewId = getReferenceId(uniqueId);
while(dca == null)
{
var parentViewId = stateData[curView]["_PV"];
if(parentViewId == null)
{
return null;
}
curView = getUniqueId(parentViewId);
var parentState = stateData[curView];
if(parentState == null)
{
return null;
}
dca = parentState["PDCA"];
viewId = parentViewId;
}
if(dca != null)
{
var dcArr = getDacArray(dca);
if(dcArr == null)
{
return null;
}
for(var i = 0; i < dcArr.length;i++)
{
if(dcArr[i] == viewId)
{
return dca;
}
}
}
return null;
}
function createBreadCrumbs(contentAreaName,win)
{
var contentAreaName = getContentAreaName(contentAreaName);
var breadCrumbDiv = win.document.getElementById("BreadCrumbs");
if(breadCrumbDiv != null)
{
var hiddenDiv = win.document.getElementById(contentAreaName + "_BC");
if(hiddenDiv != null)
{
breadCrumbDiv.innerHTML = hiddenDiv.innerHTML;   
breadCrumbDiv.className = "breadCrumbs";   
}
else
{
breadCrumbDiv.innerHTML = "";   
breadCrumbDiv.className = "breadCrumbs";       
}
}
}
function moveBreadCrumb(direction)
{
var incr = -1;
if(direction == 1)
{
incr = 1;
}
startBCIndex += incr;
endBCIndex += incr;
createBreadCrumbs(null);
}
