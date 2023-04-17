var ParamsParser = function(){}
function parseRequestParams(params){
var ampIdx = params.indexOf("&");
var qstIdx = params.indexOf("?");
if(qstIdx >= 0 && qstIdx < ampIdx){
params = params.substring(qstIdx + 1, params.length);
}
var paramsArray = params.split("&");
var paramsMap = new Object();
for(var count = 0; count < paramsArray.length; count ++){
var curParam = paramsArray[count];
var keyName = curParam.substring(0, curParam.indexOf("="));
var keyValue = curParam.substring(curParam.indexOf("=") + 1, curParam.length);
if(paramsMap[keyName] == null){
paramsMap[keyName] = new Array();
}
var val = paramsMap[keyName];
val[val.length] = keyValue;
}
return paramsMap;
}
function parseTemplateParams(params){
var paramsMap = parseRequestParams(params);
var paramDetails = new Array();
for(var keyName in paramsMap){
var details = new Array();
var keyValue = paramsMap[keyName][paramsMap[keyName].length -1];
details[0] = keyName;
if(keyValue.indexOf("$R{") >= 0){
details[1] = keyValue.substring(keyValue.indexOf("$R{") + 3, keyValue.length - 1);
details[2] = 1;
}
else if(keyValue.indexOf("$S{") >= 0) {
details[1] = keyValue.substring(keyValue.indexOf("$S{") + 3, keyValue.length - 1);
details[2] = 2;
}
else if(keyValue.indexOf("$D{") >= 0) {
details[1] = keyValue.substring(keyValue.indexOf("$D{") + 3, keyValue.length -1);
details[2] = 3;
}
else {
details[1] = paramsMap[keyName];
details[2] = 0;
}
paramDetails[paramDetails.length] = details;
}
return paramDetails;
}
function getURLSuffixed(url)
{
if(url == null) {return null;}
if(url.lastIndexOf('?') == -1)
{
url += "?";
}
else if(url.indexOf('?') > 0 && url.charAt(url.length-1) != '?' && url.charAt(url.length-1) != '&')
{
url += "&";
}
return url;
}
function appendParamToUrl(url,paramname,paramvalue)
{
if(paramvalue == null) return url;
return getURLSuffixed(url)+  paramname + "=" + encodeURIComponent(paramvalue);
}
function appendParamsToUrl(url,params)
{
if(params == null) return url;
return getURLSuffixed(url)+  params;
}
function hasDataModelTplReference(templateQueryStr)
{
if(templateQueryStr == null){
return false;
}
var paramsMap = parseTemplateParams(templateQueryStr);
for(var i = 0; i < paramsMap.length; i++){
var details = paramsMap[i];
if(details[2] == 3){
return true;
}
}
return false;
}
function hasTplReference(templateQueryStr)
{
if(templateQueryStr == null){
return false;
}
var paramsMap = parseTemplateParams(templateQueryStr);
for(var i = 0; i < paramsMap.length; i++){
var details = paramsMap[i];
if(details[2] == 3 || details[2] == 2 || details[2] == 1){
return true;
}
}
return false;
}
function splitURL(url)
{
var qindex = url.indexOf("?");
if(qindex == -1)
{
return {resource:url,query:""};
}
return {resource:url.substring(0,qindex),query:url.substring(qindex +1)};
}
function getAsQueryString(paramsObj)
{
var queryStr = ""
for(var i in paramsObj)
{
queryStr += i + "=" + encodeURIComponent(paramsObj[i]) + "&";
}
return queryStr;
}
ParamsParser.getAsQueryParam = function(paramName,paramValue)
{
return encodeURIComponent(paramName) + "=" + encodeURIComponent(paramValue);
}
