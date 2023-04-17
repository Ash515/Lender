var urlHash=true;
var initialHash;
function tabSelected(id,selectedViewIdx,refreshLevel, isAuthReq,callbackInSynch,hideStatusOnSuccess,param)
{
window["TABARRAY_"+id]=selectedViewIdx+"";
var uniqueId = getUniqueId(id);    
handleEvent(uniqueId,selectedViewIdx,refreshLevel, isAuthReq,callbackInSynch,hideStatusOnSuccess,param);
}
function associateDCAForView(uniqueId,dcaName,functionName)
{
var viewDiv = document.getElementById(uniqueId + "_CT");
dcaName = getContentAreaName(dcaName);
viewDiv.setAttribute("associateddca",dcaName);
viewDiv.setAttribute("dcalistenerfunc",functionName);
}
function selectTabBasedOnDCA(viewDiv,dcaName,dacArray)
{
var tagList = DOMUtils.getChildElsWithAttr(viewDiv,"cref","*");
var dcaArray = getDacArray(dcaName);
var selectedRef = null;
if((dcaArray != null) || (dcaArray.length > 0))
{
selectedRef = dcaArray[0];
}
for(var i = 0; i < tagList.length; i++)
{
var val =  tagList[i].getAttribute("cref");
if(val != null)
{
if(val == selectedRef)
{
tagList[i].className = "selected";
}
else if("selected" == tagList[i].className)
{
tagList[i].className = "notselected";
} 
}
}
if(RESTFUL != true)
{
updateState(viewDiv.getAttribute("unique_id"),"selectedView",getUniqueId(selectedRef),false);
}
if(urlHash && window["AjaxBackSupport"]==true)
{
urlHash=false;
initialHash=window.location.hash;
}
if(window["AjaxBackSupport"]==true && initialHash=="" )
{
updateURLHash();
}
}
function deleteLink(viewUniqueId,menuItemId)
{
url= CONTEXT_PATH + "/" + viewUniqueId + ".ve";
var callBack = function() {
refreshSubView(viewUniqueId,true,new AjaxOptions({USEXMLHTTPFORREFRESH:true,NAVIGABLE:false}));
}
AjaxAPI.sendRequest({URL:url,PARAMETERS:"LINKNAME=" + menuItemId + "&EVENT_TYPE=DELETE",ONSUCCESSFUNC:callBack});
}
function getFavLinkTitle(menuItemName,refId,additionalParams,index)
{
showURLInDialog(CONTEXT_PATH + "/"+ "ACQLTitle.cc?MENUITEMID=" + menuItemName + "&" + getMenuItemObj(menuItemName).getParams(additionalParams),"title=Add To Favorites,position=relative");
}
function addLink(menuItemId,linkViewName,frm)
{
if(! validateForm(frm))
{
return false;
}
var title = document.getElementById("favTitleField").value;
var url= getMenuItemObj(menuItemId).getActionURL() + "&LINKTITLE=" + title;
url = updateStateCookieAndAppendSid(url);
var callBack = function() {
closeDialog();
refreshSubView(linkViewName,true);
}
AjaxAPI.sendRequest({URL:url,ONSUCCESSFUNC:callBack});
return false;
}
function changeClass(el,viewName)
{
window[viewName+"_tabclass"]=el.className;
el.className="hover "+el.className;
}
function replaceClass(el,viewName)
{
var addClass="hover";
var classname=el.className;
if(classname.indexOf(addClass)!=-1)
{ 
classname=classname.substring(addClass.length+1,classname.length);
el.className=classname;
}
}
function restTabSelect(str)
{
location.href=str;
}
