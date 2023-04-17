var ERROR_MSG = "";
var RESTFUL=false;
function ClientMenuItem(menuItemName, properties, jsoptions) {
this.MENUITEMID = menuItemName;
this.DISPLAYNAME = properties.displayName;
this.IMAGE = properties.imageName;
this.CONFIRMSTRING = properties.confirmString;
this.ACTIONLINK = properties.actionLink;
this.LINKPARAMS = properties.linkParams;
this.TARGET = properties.target;
this.WINPARAMS = properties.winparams;
this.ACTIONTYPE = properties.actionType;
this.ONSUCCESSFUNC = properties.onSuccessFunc;
this.STATUSFUNC = properties.statusFunc;
this.JSMETHODNAME = properties.jsMethodName;
this.ATLEASTSELECTONESTRING = properties.atleastSelectOneRow;
for (var i in jsoptions) {
this[i] = jsoptions[i];
}
}
ClientMenuItem.prototype.getParams = function(additionalParams) {
if (additionalParams) {
if (!this.LINKPARAMS) {
return additionalParams;
} else {
return this.LINKPARAMS + "&" + additionalParams;
}
} else {
return this.LINKPARAMS;
}
}
function invokeClientMenuAction(menuInvokerObj) {
var	menuItemId=menuInvokerObj.menuItemId;
var srcViewRefId=menuInvokerObj.uniqueId;
var additionalParams=menuInvokerObj.reqParams;
var index=menuInvokerObj.rowIndex;
var menuItemObj = ClientMenuAPI.getMenuItemObj(menuItemId);
return menuItemObj.invokeClientMenuAction(srcViewRefId, additionalParams, index);
}
ClientMenuItem.prototype.invokeClientMenuAction = function(srcViewRefId, additionalParams, index) {
if (!this.isAtleastOneChecked(srcViewRefId, additionalParams, index)) {
return;
}
if (!this.confirmAction()) {
return;
}
return this.getActionURL(srcViewRefId, additionalParams, index);
}
ClientMenuItem.prototype.isAtleastOneChecked = function(srcViewRefId, additionalParams, index) {
if (index != null) {
return true;
}
if (hasDataModelTplReference(this.getParams(additionalParams))) {
if (typeof this.ATLEASTSELECTONESTRING != 'undefined' && this.ATLEASTSELECTONESTRING != null) {
if (!ClientTableModel.getInstance(srcViewRefId).isAtleastOneChecked(this.ATLEASTSELECTONESTRING)) {
return false;
}
}
if (ERROR_MSG == "" && this.ATLEASTSELECTONESTRING != null && typeof this.ATLEASTSELECTONESTRING != 'undefined') {
if (!ClientTableModel.getInstance(srcViewRefId).isAtleastOneChecked(this.ATLEASTSELECTONESTRING + " " + this.DISPLAYNAME)) {
return false;
}
} else if (ERROR_MSG != "") {
if (!ClientTableModel.getInstance(srcViewRefId).isAtleastOneChecked(I18N.getMsg(ERROR_MSG, new Array(this.DISPLAYNAME)))) {
return false;
}
}
}
return true;
}
ClientMenuItem.prototype.getActionURL = function(srcViewRefId, additionalParams, index) {
var url;
if (RESTFUL == true && this.ACTIONLINK.indexOf(CONTEXT_PATH) == -1) {
url = CONTEXT_PATH + "/" + this.ACTIONLINK;
} else {
url = this.ACTIONLINK;
}
if (srcViewRefId != null) {
url += url.indexOf("?") > -1 ? "&" : "?";
url += "ACTION_SOURCE=" + getUniqueId(srcViewRefId);
}
var params = this.getParams(additionalParams);
if (params != null) {
var selIndices = null;
if (hasDataModelTplReference(params)) {
selIndices = (index == null || index == -1) ? ClientTableModel.getInstance(srcViewRefId).getSelectedRowIndices() : [index];
}
var constructedParams = ClientMenuAPI.constructURLParams(params, srcViewRefId, selIndices).trim();
url = url + ((constructedParams.length > 0) ? "&" + constructedParams : "");
}
return url;
}
ClientMenuItem.prototype.confirmAction = function() {
var confirmStr = this.CONFIRMSTRING;
if (confirmStr) {
return confirm(confirmStr);
}
return true;
}
ClientMenuAPI = new function() {
this.constructURLParams = function(linkParams, refId, selectedIndices) {
if (refId == null) {
return linkParams;
}
var uniqueId = getUniqueId(refId);
var paramsMap = parseTemplateParams(linkParams);
var reqParams = StateData.getInstance(uniqueId).get("reqParams");
var reqMap = null;
var url = "";
var tblModel = ClientTableModel.getInstance(uniqueId);
if (reqParams != null) {
reqMap = parseRequestParams(reqParams);
}
for (var i = 0; i < paramsMap.length; i++) {
if (url.length > 0 && url.charAt(url.length - 1) != '&') {
url += "&";
}
var details = paramsMap[i];
if (details[2] == 1 && (reqMap != null) && reqMap[details[1]] != null) {
var value = reqMap[details[1]];
for (var cnt = 0; cnt < value.length; cnt++) {
if (url.length > 0 && url.charAt(url.length - 1) != '&') {
url += "&";
}
url += details[0] + "=" + encodeURIComponent(value[cnt]);
}
} else if (details[2] == 2) {
url += details[0] + "=" + encodeURIComponent(stateData[uniqueId][details[1]]);
} else if (details[2] == 3) {
var colName = details[1];
var colIndex = tblModel.getColumnIndex(colName);
if (selectedIndices != null && selectedIndices.length > 0) {
for (var count = 0; count < selectedIndices.length; count++) {
if (url.length > 0 && url.charAt(url.length - 1) != '&') {
url += "&";
}
var rowVal = selectedIndices[count];
var colVal = tblModel.getValueAt(rowVal, colIndex);
if (colVal != null) {
url += details[0] + "=" + encodeURIComponent(colVal);
}
}
}
} else if (details[2] == 0) {
url += details[0] + "=" + encodeURIComponent(details[1]);
}
}
return url;
}
this._CLIENT_MENU_MODEL_MGR = {};
this.createMenuItem = function(menuItemName, properties, jsoptions) {
this._CLIENT_MENU_MODEL_MGR[menuItemName] = new ClientMenuItem(menuItemName, properties, jsoptions);
}
this.getMenuItemObj = function(menuItemName) {
return this._CLIENT_MENU_MODEL_MGR[menuItemName];
}
}
