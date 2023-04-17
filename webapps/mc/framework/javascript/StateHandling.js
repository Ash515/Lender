var p = parent;
var w = window;
var d = document;
var Global = new Object();
function getCookie (name,win) 
{
var doc = (win == null)?document:win.document;
var arg = name + "=";  
var alen = arg.length;  
var clen = doc.cookie.length;  
var i = 0;  
while (i < clen) {    
var j = i + alen;    
if (doc.cookie.substring(i, j) == arg)      
return getCookieVal (j,doc);    
i = doc.cookie.indexOf(" ", i) + 1;    
if (i == 0) break;   
}  
return null;
}
function getCookieVal(offset,doc) 
{
var endstr = doc.cookie.indexOf (";", offset);
if (endstr == -1)
endstr = doc.cookie.length;
return decodeURIComponent(doc.cookie.substring(offset, endstr));
}
function setCookie (name, value) 
{  
var argv = setCookie.arguments;  
var argc = setCookie.arguments.length;  
var expires = (argc > 2) ? argv[2] : null;  
var path = (argc > 3) ? argv[3] : null;  
var domain = (argc > 4) ? argv[4] : null;  
var secure = (argc > 5) ? argv[5] : false;  
document.cookie = name + "=" + fixedEncodeURIComponent(value) + 
((expires == null) ? "" : ("; expires=" + expires.toGMTString())) + 
((path == null) ? "" : ("; path=" + path)) +  
((domain == null) ? "" : ("; domain=" + domain)) +    
(secure ? "; secure" : "");
}
function deleteCookie (name,path,win) 
{  
var doc = (win == null)?document:win.document;
var exp = new Date();  
exp.setTime (exp.getTime() - 1000);  
var cval = getCookie(name, win);  
if(cval == null){return;}
if(!path){path="/";}
doc.cookie = name + "=" + cval + "; expires=" + exp.toGMTString()  +"; path=" + path;
}
function getUniqueId(variable){
if(variable == null)
{
return null;
}
if(isNaN(variable)){
return variable;
}
return referenceIds[variable]; 
}
function getReferenceId(variable){
if(isNaN(variable)){
if(stateData[variable] == null)
{
return null;
}
return stateData[variable]["ID"]; 
}
return variable;
}
function initializeMainView(win,rootViewId,context,themedir, restful, sasmode)
{
win.postInvokeScripts = new Array();      
if(!win.stateData)
{
win.stateData = new Object();
win.urlstateData = new Object();
win.referenceIds = new Object();
win.oldViews = new Object();
}
if(!win.ROOT_VIEW_ID)
{
win.ROOT_VIEW_ID= rootViewId;
win.CONTEXT_PATH=context;
win.THEME_DIR=themedir;   
win.RESTFUL=restful;
win.SASMODE=sasmode;
}
}
function createView(win,uniqueId,viewName,requestParams,parentView,parentDCA,refId,viewGenTime)
{
urlstateData[uniqueId] = new Object();	
var newView = new Object();
newView["_VN"] = viewName;
newView.ID = refId;
if(requestParams != null)
{
newView["_D_RP"] = requestParams;
urlstateData[uniqueId]["_D_RP"] = requestParams;
}
newView.PDCA = parentDCA;
if(parentView != null)
{
newView["_PV"] = getReferenceId(parentView);
}
else if(stateData[uniqueId] != null)
{
newView["_PV"] = stateData[uniqueId]["_PV"];
}
stateData[uniqueId] = newView;
referenceIds[refId] = uniqueId;
deleteCookie("STATE_COOKIE","/");
for(var cnum = 0;cnum < 4;cnum++)
{
deleteCookie("STATE_COOKIE" + cnum,"/");
}
return newView;
}
function getViewState(refId)
{
return stateData[getUniqueId(refId)];
}
function getViewURLState(refId)
{
return urlstateData[getUniqueId(refId)];
}
function updateExistingView(uniqueId,parentViewId,parentDCA)
{
stateData[uniqueId]["_PV"]= parentViewId;
stateData[uniqueId]["PDCA"] = parentDCA;
}
function updateState(id,stateName,stateValue,updateVMDFlag)
{
var uniqueId = getUniqueId(id);
if(typeof stateData[uniqueId] != "undefined")
{
stateData[uniqueId][stateName]= stateValue;
}
if(updateVMDFlag)
{
stateData[uniqueId]["_VMD"]= '1';
}
}
function updateURLState(id,stateName,stateValue,updateVMDFlag)
{
var uniqueId = getUniqueId(id);
if(typeof urlstateData[uniqueId] != "undefined")
{
urlstateData[uniqueId][stateName]= stateValue;
}
}
function updateStateAndUrlState(id,stateName,stateValue,updateVMDFlag)
{
var uniqueId = getUniqueId(id);
stateData[uniqueId][stateName]= stateValue;
urlstateData[uniqueId][stateName]= stateValue;
if(updateVMDFlag)
{
stateData[uniqueId]["_VMD"]= '1';
urlstateData[uniqueId]["_VMD"]= '1';
}
}
function getState(id,stateName)
{
var uniqueId = getUniqueId(id);
return stateData[uniqueId][stateName];
}
function getURLState(id,stateName)
{
var uniqueId = getUniqueId(id);
return urlstateData[uniqueId][stateName];
}
function getStateOrUrlState(id,stateName)
{
var uniqueId = getUniqueId(id);
var state=stateData[uniqueId][stateName];
if(RESTFUL == true  && state==null)
{
return  urlstateData[uniqueId][stateName];
}
else
{
return state;
}
}
function encodeStateAsString(stateName,stateVal)
{
var sTypeOf = typeof stateVal;
var val ="";
var stName = stateName;
if(sTypeOf == "string")
{ 
val =  stateVal;
} 
else if(sTypeOf != "object")
{
val = "" + stateVal;
}
else
{
var fConstructor = stateVal.constructor;
if( fConstructor == Array)
{
for(var i =0; i < stateVal.length; i++)
{
if(stateVal[i]!=null)
val += stateVal[i] + ",";
}
var len=parseInt(stateVal.length) ;
var limit=200;
if(len > limit )
{
val="";
return;
}
stName  = stateName + "_COLL_";
}
else 
{     
for( var i in stateVal)
{
var childTypeOf = typeof stateVal[i];
if(childTypeOf == "string")
{         
val += i + "," + stateVal[i] + ",";
}
}
stName = stateName + "_MAP_";
}
}
val = fixedEncodeURIComponent(val);
var regex = new RegExp("\/","g");
val = val.replace(regex,"//");
return "/"  + stName + "/" + val;
}
function fixedEncodeURIComponent(str) {  
return encodeURIComponent(str).replace(/!/g, '%21').replace(/'/g, '%27').
replace(/\(/g, '%28').replace(/\)/g, '%29').
replace(/\*/g, '%2A');  
} 
/**
* call this method in onsubmit event of form
* this method will take care of appending
* the state string to the form action url.
*/
function handleStateForForm(frm,id,rootViewId,isSubReq,target)
{
var uniqueId = getUniqueId(id);
if(isSubReq)
{
if(target == null)
{
target = ROOT_VIEW_ID + "_RESPONSEFRAME"
}  
addHiddenInput(frm,"SUBREQUEST","true");
}
if(target != null)
{
setAttrOnFrm(frm,"target",target);
}
var actionurl = frm.action;
if(RESTFUL == true && actionurl.indexOf('view') != -1)
{
//added additional check for url containing view as, the action
// can be absolute url like localhost:8080/DoSomeThing.do
//For rest case, the action url value will be wrong
//in cases where the top address bar url is of 
// the form //localhost:8080/mc/view/validationhome/TestRestForm
// so for these cases we have to convert the action url
// to its relative form.
var adbarurl = location.href;
adbarurl = adbarurl.substring(0,adbarurl.lastIndexOf('/'));
actionurl = actionurl.substring(adbarurl.length + 1);
}
url = updateStateCookieAndAppendSid(actionurl,rootViewId);
if(uniqueId != null)
{
url =  getURLSuffixed(url);
url += "ACTION_SOURCE=" + uniqueId;
}
frm.action=url;
return true;
}
/**
* Adds new statecookie, and appends stateid value to
* the url
*/
function updateStateCookieAndAppendSid(url,rootViewId,stateId)
{
var type = getURLType(url);
if(type ==  "OUT")
{// An outside url. State need not be passed.
return url;
}
if(stateId == null)
{
stateId = addNewStateCookie(rootViewId);    
}
var stateStr;
if(RESTFUL == true)
{
stateStr = "STATE_ID";  	
}
else
{
stateStr = "STATE_ID/" + stateId;
}
var newUrl = null;
/* If type is ABS and restful 
* and the input url is //localhost:8080/mc/view/TableDoc
* or //localhost:8080/mc/STATE_ID/AllViews.cc, need not
* do anything
*/
if(type == "ABS")
{
if(RESTFUL == true) 
{
if((url.indexOf('view') == -1) && (url.indexOf('STATE_ID') == -1))
{
var prefix = getCurProtoAndHostPrefix() + CONTEXT_PATH;        
newUrl = prefix + "/" + stateStr + url.substring(prefix.length);  		
}
else
{
newUrl = url;
}
}
else
{
if(url.indexOf("STATE_ID") > -1)
{
newUrl = url.replace(/STATE_ID\/[^\/]*/g,stateStr);
}
else
{
var prefix = getCurProtoAndHostPrefix() + CONTEXT_PATH;        
newUrl = prefix + "/" + stateStr + url.substring(prefix.length);
}
}
}
else if(type == "HREL")
{
newUrl = CONTEXT_PATH + "/" + stateStr + url.substring(CONTEXT_PATH.length);
}
else if(type == "REL")
{
var newPath  = window.location.pathname;
newPath = newPath.substring(0,newPath.lastIndexOf('/'));
if(newPath.indexOf("STATE_ID/") > -1)
{
newPath =  newPath.replace(/STATE_ID\/[^\/]*/g,stateStr) + "/" + url;        
}      
else
{
if(RESTFUL == true)
{
// if the url already contains STATE_ID and is REST url,
// then no need to append state_id, just add the end part 
// to the url
// urls to handle //localhost:8080/mc/STATE_ID/xyz.cc
// or //localhost:8080/mc/view/xyz/abcd
// or //localhost:8080/mc/Examples.cc
if(newPath.indexOf("STATE_ID") <= -1)
{
var ctxIndex = newPath.indexOf(CONTEXT_PATH)+ CONTEXT_PATH.length +1;
if(newPath.indexOf("view") <= -1)
{
newPath = newPath.substring(0,ctxIndex) + "/" + stateStr + "/" + url;	
}
else
{
newPath = newPath.substring(0,ctxIndex) + stateStr + "/" + url;      	
}
}
else
{
newPath = newPath + "/" + url;
}
} 
else
{
var ctxIndex = newPath.indexOf(CONTEXT_PATH)+ CONTEXT_PATH.length +1;
newPath = newPath.substring(0,ctxIndex) + "/" + stateStr + "/" + url;
}
}
newUrl = getCurProtoAndHostPrefix() + newPath;
}
else
{ //Not Possible
return url;
}
return newUrl;
}
/**
* appends the information in urlstatedata array as url query parameters
*/
function appendURLStateParameters(url)
{
var queryStr = "";	
for(var name in urlstateData)
{
for( var i in urlstateData[name])
{
var val = urlstateData[name][i];
if(val && val != null)
{      
queryStr = queryStr + "s:" + getReferenceId(name);
queryStr  = queryStr + ":" + i + "=";
queryStr = queryStr + encodeURIComponent(val) + "&" ;
}
}
}
url = getURLSuffixed(url);	
url = url + queryStr;
return url;
}
/**
* If provided url is of format /mc/Examples.cc - then type is HREL
* meaning Host relative url. Else type is OUT, meaning different context
* If url provided is of format Example.cc, then type is REL
* If url provided is of format //mickeyclient:8080/mc/Examples.cc,
* then type is ABS, meaning absolute URL. Else OUT
*/
function getURLType(url)
{
if(url.charAt(0) == '/')
{
if(url.indexOf(CONTEXT_PATH) == 0)
{
//Host relative url!!
return "HREL";
}
else
{//Different context!!
return "OUT";
}
}
if(url.indexOf(":") == -1)
{//Relative URL
return "REL"
}  
if(url.indexOf("?") > -1)
{
if(url.indexOf(":") > url.indexOf("?"))
{ // ':' is after '?'. So it cannot be a absolute url.
return "REL";
}
}
var prefix = getCurProtoAndHostPrefix();
prefix += CONTEXT_PATH;
if(url.indexOf(prefix) == 0)
{ //Absolute URL , but of same host and context.
return "ABS";
}         
else
{ // An outside url. State need not be passed.
return "OUT";
}
}
/**
* Method returns string matching //<host>:<port>
*/
function getCurProtoAndHostPrefix()
{
var curLocation = window.location; 
var curHost = curLocation.host;
if((curLocation.port != null) && (curLocation.port != "") && (curHost.indexOf(":" + curLocation.port) < 1))
{
curHost += ":" + curLocation.port;
} 
return curLocation.protocol + "//" + curHost;
}
/**
* 
*/
function addNewStateCookie(rootViewId)
{
var stateTime = new Date().getTime(); 
var stateStr;
if(RESTFUL == true)
{
stateStr = "STATE_ID";	
updateStateCookie("/",stateTime,rootViewId);	 
}
else
{
stateStr = "STATE_ID/" + stateTime;
updateStateCookie(CONTEXT_PATH + "/"  + stateStr,stateTime,rootViewId);
}
return stateTime;
}
/**
* Updates the state cookie with values from stateData array
* also updates state time and rootviewid passed as parameters
* to the state cookie
*/
function updateStateCookie(path,stateTime,rootViewId)
{
var queryStr = "";
if(!rootViewId)
{
rootViewId = ROOT_VIEW_ID;
}
checkForCacheSize();
for(var name in stateData)
{
//This check breaks the state handling, so I'm commenting that
queryStr += "&" + name;
for( var i in stateData[name])
{
var val = stateData[name][i];
if(val && ((i != "_VN") || (val != name)))
{ 
if(i == "_D_RP"){
val = getEscapedQueryString(val);
}
queryStr += encodeStateAsString(i,val) 	
}
}
}
if(!rootViewId)
{
rootViewId = ROOT_VIEW_ID;
}
queryStr += "&_REQS/_RVID/" + rootViewId +"/_TIME/"+ stateTime;
if(rootViewId != ROOT_VIEW_ID)
{
queryStr += "/_ORVID/" + ROOT_VIEW_ID;
}
setCookieBasedOnSize(queryStr,path);
}
function setCookieBasedOnSize(stateStr,path)
{
for(var cnum = 0;cnum < 4;cnum++)
{
deleteCookie("STATE_COOKIE" + cnum,path);
}
if(stateStr.length > 1000){
var number = Math.floor(stateStr.length / 1000);
var startIdx = 0;
var endIdx = 0;
for(var count = 0; count <= number; count++){
if(count == 0){
startIdx = 0;	
}
else{
startIdx = count*1000 + 1;
}
if(count == number){
endIdx = stateStr.length;
}
else {
endIdx = (count+1)*1000 + 1;
}
var str = stateStr.substring(startIdx, endIdx);
setCookie("STATE_COOKIE" + count,str,null,path,null,isSecure());
}
deleteCookie("STATE_COOKIE",path);
}
else {
setCookie("STATE_COOKIE",stateStr,null,path,null,isSecure());
}
}
function isSecure()
{
return (location.protocol=="https:")?true:false;
}
function removeStateForView(viewToRemove)
{
var toProcessList = new Array();
toProcessList.push(viewToRemove);
var removedViewsNum = 0;
while(toProcessList.length > 0)
{
var curUniqueId = toProcessList.pop();
var curRefId = getReferenceId(curUniqueId);
if(curRefId == null) {return;}
internalRemoveStateForView(curUniqueId); 
removedViewsNum++;
for(var name in stateData)
{
if(stateData[name] && (stateData[name]["_PV"] == curRefId))
{
toProcessList.push(name);
} 
} 
}  
defragState();
return removedViewsNum;
}
function defragState()
{
stateData = defragObject(stateData);
oldViews = defragObject(oldViews);
referenceIds = defragObject(referenceIds);
}
function internalRemoveStateForView(viewToRemove)
{
stateData[viewToRemove] = null;
oldViews[viewToRemove] = null;
referenceIds[viewToRemove]= null;      
}
function defragObject(sparseObj)
{
var newObj = new Object();
for(var name in sparseObj)
{
if(sparseObj[name])
{
newObj[name] = sparseObj[name];
}
}
return newObj;
}
function copyObject(oldObj)
{
var newObj = new Object();
for(var i in oldObj)
{ 
newObj[i] = oldObj[i];
}
return newObj;
}
function checkForCacheSize()
{
var viewsToRemove = new Array();
var cursor = 0;
for(var name in stateData)
{
viewsToRemove[cursor++] = name;
}
var size = viewsToRemove.length;
if(size < 50)
{
return;
}
var toRemove = removeCachedViewsState(viewsToRemove,true,size - 30);
if(toRemove > 0)
{
removeCachedViewsState(viewsToRemove,false,toRemove);
}
}
function removeCachedViewsState(viewsToRemove,checkReqParam,toRemove)
{
for(var i = 0; i < viewsToRemove.length; i++)
{
var name = viewsToRemove[i];
if(!stateData[name])
{
continue;
}
if(!checkReqParam || (stateData[name]["_D_RP"] != null))
{
if(!isViewStateNeeded(name))
{
toRemove = toRemove - removeStateForView(name);
if(toRemove < 1)
{
break;
}
}
}
} 
return toRemove;
}
function getObjectSize(obj)
{
var i = 0;
for(var name in obj)
{
i++;
}
return i;
}
function getEscapedQueryString(str){
var charCode,modValue,diff = null;
var hexStr = "";
for (var i=0; i < str.length; i++) {
var chr = str.charAt(i);
if(chr == " " || chr == "+"){
charCode = str.charCodeAt(i);
modValue = charCode % 16;
diff = (charCode - modValue)/16;
hexStr += '%' + "0123456789ABCDEF".charAt(diff) + "0123456789ABCDEF".charAt(modValue);
}
else{
hexStr = hexStr + chr;
}
}
return hexStr;
}
function handleURL(url)
{
if(RESTFUL == true)
{
var type = getURLType(url);		
if(type == "REL")	
{
url = CONTEXT_PATH + "/" + url;
}		
}
return url;
}
function updateStateString(uniqueId,stateName,el,bool) 
{
var stateString; 	
var stateArray=new Array();
if(typeof stateData[uniqueId] != "undefined")
{
stateArray=stateData[uniqueId][stateName];
}
if(stateArray==null)
{
stateArray=new Array();
}
var len=stateArray.length;
if(bool)
{
for(var i=0;i<len;i++)
{
if(stateArray[i]==el)
return;
}
stateArray[len+1]=el;
}
else
{
for(var i=0;i<len;i++)
{
if(stateArray[i]==el)
stateArray[i]=null;
}
}
if(typeof stateData[uniqueId] != "undefined")
{
stateData[uniqueId][stateName]= stateArray;
}
if(typeof urlstateData[uniqueId] != "undefined")
{
urlstateData[uniqueId][stateName]= stateArray;
}
} 
