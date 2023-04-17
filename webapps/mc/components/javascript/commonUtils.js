function clearState() {
localStorage.clear();
}
function displayURLAndShow(url) {
openURL(url);
return false;
}
function getTableModel(viewRefId) {
var tblModel = null;
if(window.EmberTableModel)
{
tblModel = EmberTableModel._TBL_TABLEMODEL_MGR[getUniqueId(viewRefId)];
}
if(!tblModel)
{
tblModel = TableModel._TBL_TABLEMODEL_MGR[getUniqueId(viewRefId)];
}
return tblModel;
}
String.prototype.visualLength = function(viewName) {
var id = "#ruler_" + viewName;
var ruler = jQuery(id);
ruler.text(this);
return ruler.width();
};
function appendReturnIfNeeded(functionStr)
{
if(!functionStr || functionStr.trim().length == 0){return functionStr;}
return (functionStr.indexOf("return ") == -1) ? "return "+functionStr : functionStr;
}
function isHTMLSafe(str) {
return (str && (typeof str.toString) === "function");
}
function getAllComparators() {
return [{
"TYPE": "CHAR",
"OPTION": [{
"disp": I18N.getMsg("contains"),
"val": 12
}, {
"disp": I18N.getMsg("doesn't contain"),
"val": 13
}, {
"disp": I18N.getMsg("ends with"),
"val": 11
}, {
"disp": I18N.getMsg("starts with"),
"val": 10
}, {
"disp": I18N.getMsg("is"),
"val": 0
}, {
"disp": I18N.getMsg("isn't"),
"val": 1
}]
}, {
"TYPE": "ALLOWEDSTRING",
"OPTION": [{
"disp": I18N.getMsg("is"),
"val": 0
}, {
"disp": I18N.getMsg("isn't"),
"val": 1
}]
}, {
"TYPE": "DATE",
"OPTION": [{
"disp": I18N.getMsg("is"),
"val": 0
}, {
"disp": I18N.getMsg("isn't"),
"val": 1
}, {
"disp": I18N.getMsg("is after"),
"val": 5
}, {
"disp": I18N.getMsg("is before"),
"val": 7
}]
}, {
"TYPE": "INTEGER",
"OPTION": [{
"disp": I18N.getMsg("is"),
"val": 0
}, {
"disp": I18N.getMsg("isn't"),
"val": 1
}, {
"disp": I18N.getMsg("is higher than"),
"val": 5
}, {
"disp": I18N.getMsg("is lower than"),
"val": 7
}]
}, {
"TYPE": "DATEASLONG",
"OPTION": [{
"disp": I18N.getMsg("is"),
"val": 54
}, {
"disp": I18N.getMsg("isn't"),
"val": 55
}, {
"disp": I18N.getMsg("is after"),
"val": 45
}, {
"disp": I18N.getMsg("is before"),
"val": 47
}]
}, {
"TYPE": "ALLOWEDSTRING1",
"OPTION": [{
"disp": I18N.getMsg("is"),
"val": 0
}]
}, {
"TYPE": "YESNOBOOLEAN",
"OPTION": [{
"disp": I18N.getMsg("is"),
"val": 0
}, {
"disp": I18N.getMsg("isn't"),
"val": 1
}]
}, {
"TYPE": "TFBOOLEAN",
"OPTION": [{
"disp": I18N.getMsg("is"),
"val": 0
}, {
"disp": I18N.getMsg("isn't"),
"val": 1
}]
}, {
"TYPE": "FLOAT",
"OPTION": [{
"disp": I18N.getMsg("is"),
"val": 0
}, {
"disp": I18N.getMsg("isn't"),
"val": 1
}, {
"disp": I18N.getMsg("is higher than"),
"val": 5
}, {
"disp": I18N.getMsg("is lower than"),
"val": 7
}]
}, {
"TYPE": "ALLOWEDNUMERIC",
"OPTION": [{
"disp": I18N.getMsg("is"),
"val": 0
}, {
"disp": I18N.getMsg("isn't"),
"val": 1
}, {
"disp": I18N.getMsg("is higher than"),
"val": 5
}, {
"disp": I18N.getMsg("is lower than"),
"val": 7
}]
}];
}
function isNotNullString(str)
{
if(typeof str === "number")	
{
return true;
}
if(str && typeof str === "string" && str.trim().length > 0 && str !== "undefined" && str !== "null")
{
return true;
}
return false;
}
function isJSON(data)
{
try
{
JSON.parse(data);
}
catch(e)
{
return false;
}
return true;
}
function decode(str) {
return decodeURIComponent(str.replace(/\+/g, ' ')); 
}
function extractScripts(data)
{
return jQuery("<div>").html(data).find('script');
}
