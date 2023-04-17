var ERROR_MSG = "" ;
function MenuItem(menuItemName, properties,jsoptions){  
this.MENUITEMID = menuItemName;
this.DISPLAYNAME = properties[0];
this.IMAGE = properties[1];
this.CONFIRMSTRING = properties[2];
this.ACTIONLINK = getURLSuffixed(properties[3]);
this.LINKPARAMS = properties[4];
this.TARGET = properties[5];
this.WINPARAMS = properties[6];
this.ACTIONTYPE = properties[7];
this.ONSUCCESSFUNC = properties[8];
this.STATUSFUNC = properties[9];        
this.JSMETHODNAME = properties[10];
this.ATLEASTSELECTONESTRING = properties[11];  
for(var i in jsoptions)
{
this[i] = jsoptions[i];
}
}
MenuItem.prototype.getParams = function(additionalParams)
{
if(additionalParams != null)
{
if(this.LINKPARAMS == null)
{
return additionalParams;
}       
else  
{
return this.LINKPARAMS + "&" + additionalParams;
}
}
else
{
return this.LINKPARAMS;
}
}
MenuItem.prototype.getConfiguredParameter = function(paramName)
{
return  parseRequestParams(this.getParams())[paramName];
}
function invokeMenuAction(menuItemId, srcViewRefId, additionalParams,index){
var menuItemObj = getMenuItemObj(menuItemId);
if(menuItemObj.JSMETHODNAME != null)
{ 
executeFunctionAsString(menuItemObj.JSMETHODNAME,window,menuItemId, srcViewRefId, additionalParams,index);
}
else
{
menuItemObj.invokeMenuAction(srcViewRefId,additionalParams,index);
}
}
function invokeMenuAction_template(sourceEl)
{
var menuItemId=sourceEl.getAttribute("mc:columnChooserType");
var srcViewRefId=DOMUtils.getParentWithAttr(sourceEl,"mc:id").getAttribute("mc:id");
var additionalParams="viewName="+srcViewRefId+"&TABLEVIEWID="+srcViewRefId;
var index=null;
var menuItemObj = getMenuItemObj(menuItemId);
if(menuItemObj.JSMETHODNAME != null)
{ 
executeFunctionAsString(menuItemObj.JSMETHODNAME,window,menuItemId, srcViewRefId, additionalParams,index);
}
else
{
menuItemObj.invokeMenuAction(srcViewRefId,additionalParams,index);
}
}
MenuItem.prototype.invokeMenuAction = function(srcViewRefId, additionalParams,index){
if(_NO_ACTION)
{
return;
}
if(!this.isAtleastOneChecked(srcViewRefId,additionalParams,index))
{
return;
}     
if(!this.confirmAction()){
return;
}     
this.invokeActionURL(this.getActionURL(srcViewRefId,
additionalParams,index),srcViewRefId, index);
}
MenuItem.prototype.isAtleastOneChecked = function(srcViewRefId, additionalParams,index)
{
if(index != null)
{
return true;
}
if(hasDataModelTplReference(this.getParams(additionalParams)))
{
if(typeof this.ATLEASTSELECTONESTRING != 'undefined' && this.ATLEASTSELECTONESTRING != null)
{
if(!getTableModel(srcViewRefId).isAtleastOneChecked(this.ATLEASTSELECTONESTRING))
{
return false;
}       
}
if(ERROR_MSG=="" && this.ATLEASTSELECTONESTRING!=null && typeof this.ATLEASTSELECTONESTRING!='undefined')
{
if(!getTableModel(srcViewRefId).isAtleastOneChecked(this.ATLEASTSELECTONESTRING+" "+ this.DISPLAYNAME))
{
return false;
}
} 
else if(ERROR_MSG!="")
{
if(!getTableModel(srcViewRefId).isAtleastOneChecked(I18N.getMsg(ERROR_MSG, new Array(this.DISPLAYNAME))))
{
return false;
}
}
}
return true;
}
MenuItem.prototype.confirmAction = function()
{
var confirmStr = this.CONFIRMSTRING;
var confirmResult = true;
if(confirmStr) {
confirmResult = confirm(confirmStr);
}
return confirmResult;
}
function getPassedParams(menuItemId, refId, additionalParams,index)
{
var menuItemObj = getMenuItemObj(menuItemId);
if(!menuItemObj.isAtleastOneChecked(refId,additionalParams,index))
{
return;
}     
if(!menuItemObj.confirmAction()){
return;
} 
var linkParams = menuItemObj.getParams(additionalParams);
var selectedIndices = null;
if(hasDataModelTplReference(linkParams))
{
selectedIndices = (index == null || index == -1)? getTableModel(refId).getSelectedRowIndices():[index];
}
if(refId == null){ return linkParams;}
var uniqueId = getUniqueId(refId);
var paramsMap = parseTemplateParams(linkParams);
var reqParams = stateData[uniqueId]["_D_RP"];      
var reqMap = null;
var url = "";
var tblModel = getTableModel(uniqueId);
if(reqParams != null){
reqMap = parseRequestParams(reqParams);
}
for(var i = 0; i < paramsMap.length; i++){
var details = paramsMap[i];
if(details[2] == 1 && (reqMap!=null) && reqMap[details[1]] != null) {
var value = reqMap[details[1]];
for(var cnt = 0; cnt < value.length; cnt++){
url = ":"+details[0] + "=" + value[cnt];
}
}
else if(details[2] == 2) { 
url =url+":"+details[0] + "," + stateData[uniqueId][details[1]];
}
else if(details[2] == 3){
var colName = details[1];
var colIndex = tblModel.getColumnIndex(colName);  
if(selectedIndices != null && selectedIndices.length > 0){
for(var count=0; count < selectedIndices.length; count++){
var rowVal = selectedIndices[count];
var colVal = tblModel.getValueAt(rowVal, colIndex);
if(colVal != null)
{
url = url +":"+details[0] + "," + colVal;
}
}
}
else {m
if(tblModel.getValueAt(0,colIndex) != null)
{
url = url +":"+details[0] + "," + tblModel.getValueAt(0, colIndex);
}
}
}
else if(details[2] == 0){
url = url +":"+details[0] + "," + details[1];
}
}
return url;
}
MenuItem.prototype.getActionURL = function(srcViewRefId, additionalParams,index) {
var url ;
if(RESTFUL == true && this.ACTIONLINK.indexOf(CONTEXT_PATH) == -1)
{
url = CONTEXT_PATH + "/" + this.ACTIONLINK;
}
else
{
url = this.ACTIONLINK;
}
if(srcViewRefId != null) {
url += "ACTION_SOURCE=" + getUniqueId(srcViewRefId) + "&";
}
var params = this.getParams(additionalParams);
if(params != null) {
var selIndices = null;
if(hasDataModelTplReference(params))
{
selIndices = (index == null || index == -1)? getTableModel(srcViewRefId).getSelectedRowIndices():[index];
}
url = url + constructURLParams(params, srcViewRefId,selIndices);
}
return url;
}
var appendstate = true;
MenuItem.prototype.invokeActionURL = function(url,srcViewRefId,index)
{
var winParams = this.WINPARAMS;
var target = this.TARGET;
if(this.ACTIONTYPE == "POST"){
var urlParts = splitURL(url); 
var formObj = createForm(urlParts["resource"], this.TARGET, "POST", "MI_" + this.MENUITEMID);
var params = urlParts["query"].split("&");
for(var i=0; i<params.length;i++){
var param = params[i];
if(param.indexOf("=") != 0 && param.length>3){
var paramName = param.substring(0, param.indexOf("="));
var paramValue = param.substring(param.indexOf("=")+1, param.length);
addHiddenInput(formObj,decodeURIComponent(paramName),decodeURIComponent(paramValue));
}
}
if(typeof CSRFParamName!="undefined" && CSRFParamName!=null && (typeof CSRFCookieName!="undefined" && CSRFCookieName!=null) && getCookie(CSRFCookieName) != null)
{
var CSRFParamValue  = getCookie(CSRFCookieName);
addHiddenInput(formObj,decodeURIComponent(CSRFParamName),decodeURIComponent(CSRFParamValue));
}  
document.body.appendChild(formObj);
handleStateForForm(formObj, srcViewRefId);
formObj.submit();
return;
}
else if(this.ACTIONTYPE == "AJAXGET")
{
if(url.indexOf("_previousurl") == -1)
{
url = updateStateCookieAndAppendSid(url);
}
var ajaxOptions = new AjaxOptions({URL:url,SRCVIEW:getUniqueId(srcViewRefId),MENUITEMID:this.MENUITEMID,SELINDEX:index,method:"GET"});
ajaxOptions.update(this);
this.sendRequest(ajaxOptions,target);
}
else if(this.ACTIONTYPE == "AJAXPOST")
{
if(url.indexOf("_previousurl") == -1)
{
url = updateStateCookieAndAppendSid(url);
}
var urlParts = splitURL(url); 
var ajaxOptions = new AjaxOptions({URL:urlParts["resource"],SRCVIEW:getUniqueId(srcViewRefId),method:"POST",PARAMETERS:urlParts["query"],MENUITEMID:this.MENUITEMID,SELINDEX:index});
ajaxOptions.update(this);
this.sendRequest(ajaxOptions,target);
}
else
{
openURL(url, target, winParams, appendstate);
}
}
MenuItem.prototype.sendRequest = function (ajaxOptions,target)
{
if (target == null)
{
AjaxAPI.sendRequest(ajaxOptions);
return;
}
if (target.indexOf("_FN_") == 0)
{
var methodName = target.substring("_FN_".length);
executeFunctionAsString(methodName,window,ajaxOptions);
}
else if (target.indexOf("_divpopup") == 0)
{
ajaxOptions["ONSUCCESSFUNC"] = "AjaxAPI.showInDialog";
AjaxAPI.sendRequest(ajaxOptions);
}
else if  (target.indexOf("_div_") == 0)
{
ajaxOptions["CONTAINERID"] = target.substring("_div_".length);
ajaxOptions["ONSUCCESSFUNC"] = "AjaxAPI.addResponseToElement";
AjaxAPI.sendRequest(ajaxOptions);
}
else if (target.indexOf("_REFRESHSELF_") == 0)
{
ajaxOptions["ONSUCCESSFUNC"] = "AjaxAPI.refreshView";
AjaxAPI.sendRequest(ajaxOptions);
}
else if (target.indexOf("_TABLEDETAILS") == 0)
{
TableDOMModel.showDetails(ajaxOptions);  
}  
else if(target.indexOf("_mcframe") == 0 ||
target.indexOf("_view_this") == 0)
{
ajaxOptions["ONSUCCESSFUNC"] = null; 
if(target.indexOf("_mcframe") != -1){
ajaxOptions["MCFRAMEACTION"]="REPLACE";
}
AjaxAPI.sendRequest(ajaxOptions);  
}  
else if (target.indexOf("_view_") == 0)
{
ajaxOptions["ONSUCCESSFUNC"] = null;  
AjaxAPI.sendRequest(ajaxOptions);  
}  
else
{
AjaxAPI.sendRequest(ajaxOptions);
}
}
function evalViewFun(funName,funString)
{
if(window[funName])
{
return;
} 
window[funName] = new Function("index","viewName","el",funString);
}
function constructURLParams(linkParams,refId,selectedIndices)
{
if(refId == null){ return linkParams;}
var uniqueId = getUniqueId(refId);
var paramsMap = parseTemplateParams(linkParams);
var reqParams = stateData[uniqueId]["_D_RP"];      
var reqMap = null;
var url = "";
var tblModel = getTableModel(uniqueId);
if(reqParams != null){
reqMap = parseRequestParams(reqParams);
}
for(var i = 0; i < paramsMap.length; i++){
var details = paramsMap[i];
if(details[2] == 1 && (reqMap!=null) && reqMap[details[1]] != null) {
var value = reqMap[details[1]];
for(var cnt = 0; cnt < value.length; cnt++){
url = url + "&" + details[0] + "=" + value[cnt];
}
}
else if(details[2] == 2) { 
url = url + "&" + details[0] + "=" + stateData[uniqueId][details[1]];
}
else if(details[2] == 3){
var colName = details[1];
var colIndex = tblModel.getColumnIndex(colName);  
if(selectedIndices != null && selectedIndices.length > 0){
for(var count=0; count < selectedIndices.length; count++){
var rowVal = selectedIndices[count];
var colVal = tblModel.getValueAt(rowVal, colIndex);
if(colVal != null)
{
url = url + "&" + details[0] + "=" + colVal;
}
}
}
}
else if(details[2] == 0){
url = url + "&" + details[0] + "=" + details[1];
}
}
return url;
}
_MENU_MODEL_MGR = new Object();
function createMenuItem(menuItemName, properties,jsoptions){
var menuItemObj = new MenuItem(menuItemName, properties,jsoptions);
_MENU_MODEL_MGR[menuItemName] = menuItemObj;
}
function getMenuItemObj(menuItemName)
{
return _MENU_MODEL_MGR[menuItemName];
}
function getSelectedRows(viewname)
{
var rs= stateData[viewname]["_RS"];
if(rs=="undefined" || rs==null)
{
return "";
}
var str="";
for(var i=0; i<rs.length;i++)
{
if(rs[i]!=null && rs[i]!="undefined" && rs[i]!="")
{
str+=rs[i]+",";
} 
}
return str;
}
