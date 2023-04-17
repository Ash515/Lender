function getRootViewEl(response)
{
var holderDiv = document.createElement("div");
holderDiv.innerHTML = response.getOnlyHtml();
var rootView = DOMUtils.getFirstMatchingElement(holderDiv.getElementsByTagName("div"),null,"unique_id","*");
return rootView;
}
function updateViewInResp(response,reqOptions)
{
var viewToRefreshDiv = getRootViewEl(response);
updateViewFromReq(viewToRefreshDiv);
response.invokeScripts();
updateParentCookie();
return StatusMsgAPI.OPSTATUS.FINISHED;
}
function updateViewFromReq(viewToRefreshEl)
{
var toReplaceViewId = viewToRefreshEl.getAttribute("unique_id");
var currentEl = document.getElementById(toReplaceViewId + "_CT");
if(!currentEl)
{
throw new Error("The corresponding html content for " + toReplaceViewId + " not present in parent window.");
}
currentEl.parentNode.replaceChild(viewToRefreshEl,currentEl);
}
function createElementDiv(uniqueId,isHolder)
{
var el = document.createElement("div");
el.id= uniqueId + "_CT";
el.className="uicomponent";   
el.setAttribute("unique_id",uniqueId);
if(isHolder)
{
el.setAttribute("viewholder","true");
}
return el;
}
function updateParentCookie()
{
var urlStr = window.location.href;
var index = urlStr.indexOf("STATE_ID");
if(index < 0)
{
return;
}
var newIndex = urlStr.indexOf("/","STATE_ID".length + index + 1);
var path = CONTEXT_PATH + "/" + urlStr.substring(index,newIndex);
var curDate = new Date();
if(RESTFUL == true)
{
updateStateCookie("/",curDate.getTime(),null);	
}
else
{
updateStateCookie(path,curDate.getTime(),null);
} 
}
function addToOnLoadScripts(script,win)
{
win.postInvokeScripts.push([script,arguments]);     
}
function execOnLoadScripts(win)
{
docAlreadyLoaded = true;
AjaxAPI.showPersMsg(0);
for(var i = 0; i < win.postInvokeScripts.length; i++)
{
try
{
executeFunctionAsString(win.postInvokeScripts[i][0],win,win.postInvokeScripts[i][1]);
}
catch(e)
{
if(showError)
{ 
StatusMsgAPI.showMsg("Exception occurred when executing post invoke script " + win.postInvokeScripts[i] + " .Msg : " + e.message,false);
}
}
}
}
