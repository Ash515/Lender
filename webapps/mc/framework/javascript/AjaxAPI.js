var AjaxAPI = new function(){}
DEFAULT_REQUEST_OPTIONS = {};
DEFAULT_REQUEST_OPTIONS.beforeRequest = null;
DEFAULT_REQUEST_OPTIONS.afterResponse = null;
AjaxAPI.navigFrameName = null;  
AjaxAPI.getXMLHttpRequest = function()
{
var http_request = null;
if (window.XMLHttpRequest) 
{ 
http_request = new XMLHttpRequest();
} 
else if (window.ActiveXObject) 
{ 
try 
{
http_request = new ActiveXObject("Msxml2.XMLHTTP");
} 
catch (e) 
{
http_request = new ActiveXObject("Microsoft.XMLHTTP");
}
}
return http_request;
}
AjaxAPI.sendRequest = function(requestOptions)
{
requestOptions = AjaxOptions.getAsAjaxOptions(requestOptions);
var reqURL = requestOptions["URL"];
var xmlHttpReq = AjaxAPI.getXMLHttpRequest();
var parameters = requestOptions["PARAMETERS"];
var url = requestOptions.v("URL");
if(typeof RESTFUL != 'undefined' && RESTFUL == true)
{
url = updateStateCookieAndAppendSid(url);
}
var target = requestOptions["TARGET"];
if (target != null && target.indexOf("_opener_view_this") == 0 && requestOptions["FORWARDURL"] == null)
{
var srcViewRefId = requestOptions["SRCVIEW"];
var sourceEl = document.getElementById(srcViewRefId + "_CT");
var parent = DOMUtils.getParentWithAttr(sourceEl, "opener");
if(parent)
{
requestOptions["FORWARDURL"] = parent.getAttribute("opener") + ".cc?" + stateData[parent.getAttribute("opener")]["_D_RP"];
}
}
if(url.indexOf('_previousurl_') != -1)
{
var viewtoforward = url.substring("_previousurl_".length);
if(viewtoforward.indexOf("?") != -1)
{
viewtoforward = viewtoforward.substring(0,viewtoforward.indexOf("?"));
}  	   	  
var mcframe = AjaxAPI.getMCFrame(requestOptions);
url = mcframe.history.getPreviousURL(viewtoforward);  	   	 
}
else if(url.indexOf('_previousurl') != -1)
{
var mcframe = AjaxAPI.getMCFrame(requestOptions);  	   
url = mcframe.history.getPreviousURL();
}
else if(url.indexOf('_currenturl') != -1)
{
var mcframe = AjaxAPI.getMCFrame(requestOptions);  	   
url = mcframe.history.getCurrentURL();  
}
else if(target != null && target.indexOf('_mcframe') != -1)
{
AjaxAPI.getMCFrame(requestOptions);
}
if (parameters && (requestOptions.vu("METHOD") == 'GET'))
{
url = appendParamsToUrl(url, parameters);
} 
url = appendParamsToUrl(url,"SUBREQUEST=XMLHTTP");
var forwardurl = requestOptions["FORWARDURL"];
if(forwardurl != null)
{
if(forwardurl.indexOf('_previousurl_') != -1)
{
var viewtoforward = forwardurl.substring("_previousurl_".length);
var mcframe = AjaxAPI.getMCFrame(requestOptions);
forwardurl = mcframe.history.getPreviousURL(viewtoforward);  	   	 
}
else if(forwardurl.indexOf('_previousurl') != -1)
{
var mcframe = AjaxAPI.getMCFrame(requestOptions);  	   
forwardurl = mcframe.history.getPreviousURL();
}
else if(forwardurl.indexOf('_currenturl') != -1)
{
var mcframe = AjaxAPI.getMCFrame(requestOptions);  	   
forwardurl = mcframe.history.getCurrentURL();  
}
else if(target.indexOf('_mcframe') != -1)
{
AjaxAPI.getMCFrame(requestOptions);
}
if(requestOptions.vu("METHOD") == 'GET')
{
url = appendParamsToUrl(url,"FORWARDURL=" + encodeURIComponent(forwardurl));
}
else
{
var urlarr = splitURL(forwardurl);
var replacedparams;
if(hasTplReference(urlarr['query']) == true)
{
replacedparams =  constructURLParams(urlarr['query'],requestOptions['SRCVIEW']);
}
else
{
replacedparams = urlarr['query'];
}
forwardurl = urlarr['resource'] + "?" + replacedparams;
parameters = parameters + '&' + "FORWARDURL=" 
+ encodeURIComponent(forwardurl);
}
}
if(requestOptions.vu("METHOD")!="GET" && requestOptions.CSRF != "FALSE" )
{
if(typeof CSRFParamName!="undefined" && CSRFParamName!=null && (typeof CSRFCookieName!="undefined" && CSRFCookieName!=null) && getCookie(CSRFCookieName) != null)
{
var CSRFParamValue  = getCookie(CSRFCookieName);
if(typeof parameters!="undefined" && parameters !=null )
{
parameters+="&"+CSRFParamName+"="+CSRFParamValue;
}
else if(typeof parameters=="undefined" || parameters ==null)
{
parameters=CSRFParamName+"="+CSRFParamValue;
}
}	
}   
xmlHttpReq.open(requestOptions.vu("METHOD"), url,
requestOptions.isTrue("ASYNCHRONOUS"));
var requestHeaders = new Object();
requestHeaders["X-Requested-With"] = 'XMLHttpRequest';
if (requestOptions.vu("METHOD") == 'POST') 
{
requestHeaders['Content-type']= 'application/x-www-form-urlencoded;charset=UTF-8';
}
else
{
requestHeaders["If-Modified-Since"]='Thu, 1 Jan 1970 00:00:00 GMT';
}
if (xmlHttpReq.overrideMimeType)
{
requestHeaders['Connection'] = 'close';
}
AjaxUtils.updateObject(requestHeaders, requestOptions["REQUESTHEADERS"]);
var body = requestOptions["POSTBODY"] ? requestOptions["POSTBODY"] : parameters;
body = (requestOptions.vu("METHOD") == 'POST')? body : null;
if(body != null)
{
requestHeaders['Content-length',body.length];
}
else if(requestOptions.vu("METHOD") == 'POST')
{
body="___DUMMYDATA=aa";
requestHeaders['Content-length',body.length];
}
for (var header in requestHeaders)
{
if(header != "Connection")
{
xmlHttpReq.setRequestHeader(header,requestHeaders[header]);  
}
}
var resp = new AjaxResponse(xmlHttpReq);
xmlHttpReq.onreadystatechange = function(){AjaxUtils.handleAjaxResponse(resp,requestOptions);};
if(requestOptions["STATUSFUNC"])
{
requestOptions.fn("STATUSFUNC",resp,requestOptions);
}
if(requestOptions["BEFOREREQUEST"]){
requestOptions.fn("BEFOREREQUEST", xmlHttpReq, requestOptions); 
}
xmlHttpReq.send(body);
}
AjaxAPI.sendNavigableRequest = function(requestOptions)
{
requestOptions = AjaxOptions.getAsAjaxOptions(requestOptions);
if(requestOptions["METHOD"] != "GET"){throw new Error("Currently only Get is supported.");}
var url = AjaxAPI.getAsNavigableAjaxURL(requestOptions);
if(AjaxAPI.navigFrameName != null)
{
if(window.frames[AjaxAPI.navigFrameName].location.href == url)
{
window.frames[AjaxAPI.navigFrameName].location.reload();
}
else
{  	
window.frames[AjaxAPI.navigFrameName].location.href = url;
}
}
else
{
throw new Error("AjaxAPI.navigFrameName has not been set");
}
}
AjaxAPI.getMCFrame = function(requestOptions)
{
if(requestOptions["CONTENTAREANAME"] != null)
{
return MCFrame.getMCFrame(requestOptions["CONTENTAREANAME"]);
}
else if(requestOptions["NAME"] != null 
&& requestOptions["TARGET"].indexOf("_mcframe_this") != -1)
{
var frm = DOMUtils.getForm(requestOptions["NAME"]);
var mcframe = MCFrame.getMCFrame(frm);
requestOptions["CONTENTAREANAME"] = mcframe.contentareaname;
return mcframe;
}
else
{
var target = requestOptions["TARGET"];
var contentAreaName = target.substring("_mcframe_".length);
return MCFrame.getMCFrame(contentAreaName);
}	
}
AjaxAPI.getAsNavigableAjaxURL = function(requestOptions)
{
requestOptions = AjaxOptions.getAsAjaxOptions(requestOptions);
var encodedOptions = requestOptions.encode(); 
var url = requestOptions["URL"];
if(url.indexOf("SUBREQUEST") == -1){ url = appendSubRequestArgs(url);}
if(url.lastIndexOf('#') > -1)
{
url= url.substring(0,url.lastIndexOf('#'));
}
url += "#" + encodeURIComponent(encodedOptions);
return url;
}
AjaxAPI.checkIfBlankPage = function(resFrame)
{
if((resFrame.location.href == "about:blank")
|| (resFrame.location.href.indexOf("blank.html") > 0) 
|| (resFrame.location.href.indexOf("empty.html") > 0))
{
return true;
}
return false;
}
AjaxAPI.handleIframeResponse = function(respFrameEl)
{
if(AjaxAPI.navigFrameName == null)
{
AjaxAPI.navigFrameName = respFrameEl.getAttribute("name");
}
var respFrame = window.frames[respFrameEl.getAttribute("name")];
if(AjaxAPI.checkIfBlankPage(respFrame))
{
return;
}
var encodedOptions = respFrame.location.hash;
if((encodedOptions == null) || (encodedOptions.length < 2))
{
return;
}
encodedOptions = encodedOptions.substring(1);
encodedOptions = decodeURIComponent(encodedOptions);
var reqOptions = new AjaxOptions(encodedOptions);
reqOptions.setV("URL",respFrame.location.href);
var ifTransport = new Object();
ifTransport.iframe = respFrame;
ifTransport.readyState = 4;
ifTransport.status = 200;
ifTransport.responseText = "";
var isTextPlain = false;
var nodeList = respFrame.document.getElementsByTagName("*");
var lastNode = nodeList[nodeList.length -1];
if(lastNode.nodeName == "PRE")
{
var childNodes = lastNode.childNodes;
for(var i = 0; i < childNodes.length; i++)
{
ifTransport.responseText += childNodes[i].nodeValue;
}
var dummyPrefix = "                    ";
if(ifTransport.responseText.indexOf(dummyPrefix) == 0)
{
isTextPlain = true;
}
}
if(!isTextPlain)
{
ifTransport.responseText = nodeList[0].innerHTML;
}
var resp = new AjaxResponse(ifTransport);
AjaxUtils.handleAjaxResponse(resp,reqOptions);
}
AjaxAPI.invokeNavigableAction = function(requestOptions)
{
var encodedOptions = requestOptions.encode();
requestOptions.fn("NAVIGFUNCTION_N",requestOptions);
AjaxUtils.ignoreNavigFrameLoad= true;
window.frames["AJAXNAVIG"].location.href = CONTEXT_PATH + "/framework/html/blank.html?" + encodedOptions;
}
AjaxAPI.submit = function(frm)
{
var frmOptions = AjaxAPI.getFormAttrsAsOptions(frm);
try
{
if(frmOptions["VALIDATEFUNC"])
{
if(!frmOptions.fn("VALIDATEFUNC",frm))
{
return false;
}
}
var reqURL = frm.getAttribute("action");
var params=frm.getAttribute("additionalparams");
var tableName = document.getElementsByName("TABLENAME")[0];
if(tableName != undefined && (tableName.value == "" || tableName.value == null))
{
alert(I18N.getMsg("Please enter table name"));
return false;
}
if(params!=null && params!="undefined")
reqURL+="?"+params;
reqURL = updateStateCookieAndAppendSid(reqURL,null);
if(!frmOptions.isTrue("USEIFRAME",false))
{
var params = AjaxAPI.serialize(frm);
frmOptions.update({URL:reqURL,parameters: params});
var srcview = frmOptions["SRCVIEW"];
if(srcview == null)
{
srcview = DOMUtils.getParentWithAttr(frm, "unique_id");
if(srcview != null)
{
frmOptions.update({SRCVIEW:srcview.getAttribute("unique_id")});
}
}
AjaxAPI.sendRequest(frmOptions);
}
else
{
frm.target=AjaxAPI.navigFrameName;
var ajaxOpt = new AjaxOptions(frmOptions);
ajaxOpt.update({URL:reqURL,ONSUCCESSFUNC:'AjaxAPI.iframeSubmitResponse',ONFAILUREFUNC:'AjaxAPI.iframeSubmitFailure',FORMNAME:frm.name});
var url = AjaxAPI.getAsNavigableAjaxURL(ajaxOpt);
StatusMsgAPI.showOperationStatus(StatusMsgAPI.OPSTATUS.STARTED,ajaxOpt["OPSTATUSID"]);
frm.action=url;
frm.submit();
}
}
catch(e)
{
StatusMsgAPI.showMsg("Script Error Occurred : " + e,false,true,frmOptions["STATUSMSGID"]);
}
return false;
}
AjaxAPI.getFormAttrsAsOptions = function(frm)
{
var attrList = frm.attributes;
var frmOptions = new AjaxOptions({submittedFrm:frm.name});
for(var i = 0; i < attrList.length; i++)
{
frmOptions.setV(attrList.item(i).nodeName, attrList.item(i).nodeValue);
}
return frmOptions;
}
AjaxAPI.serialize = function(form) 
{
var forms = new Array();
for (var i = 0; i < arguments.length; i++) 
{
var element = arguments[i];
if (typeof element == 'string')
{
element = document.getElementById(element);
}
if (arguments.length == 1) 		
{
forms = element;
break;
}
forms.push(element);
}
var elements = new Array();
for (var tagName in Form.Element.Serializers) {
var tagElements = forms.getElementsByTagName(tagName);
for (var j = 0; j < tagElements.length; j++)
elements.push(tagElements[j]);
}
var queryComponents = new Array();
for (var i = 0; i < elements.length; i++) 
{
if(!elements[i].disabled)
{	
var queryComponent = Form.Element.serialize(elements[i]);
if (queryComponent)
{
queryComponents.push(queryComponent);
}
}
}
return queryComponents.join('&');
}
AjaxAPI.iframeSubmitResponse = function(response,reqOptions)
{
var frm = DOMUtils.getForm(reqOptions['FORMNAME']);
var frmOptions = AjaxAPI.getFormAttrsAsOptions(frm);
StatusMsgAPI.showOperationStatus(response.opStatus,reqOptions["OPSTATUSID"]);  
if(frmOptions["ONSUCCESSFUNC"] != null)
{
frmOptions.fn("ONSUCCESSFUNC",response,frmOptions);
}
}
AjaxAPI.iframeSubmitFailure = function(response,reqOptions)
{
var frm =  DOMUtils.getForm(reqOptions['FORMNAME']);
var frmOptions = AjaxAPI.getFormAttrsAsOptions(frm);
AjaxAPI.showRespMsg(response,frmOptions);
}
AjaxAPI.dummyFunction = function(response,requestOptions)
{
return StatusMsgAPI.OPSTATUS.FINISHED;
}
AjaxAPI.refreshView = function(response,requestOptions)
{
requestOptions.update({VIEWTOREFRESH_RN:requestOptions.v("SRCVIEW"),NAVIGABLE_RN:false});
ViewAPI.refreshView(requestOptions);
return StatusMsgAPI.OPSTATUS.INPROGRESS;
}
AjaxAPI.closeViewAndRefreshDCA = function(response,requestOptions)
{
var uniqueId = requestOptions["SRCVIEW"];
var dca = getContentAreaFromState(uniqueId);
var parentId = getParentViewForDCA(dca);
closeView(uniqueId,true);
requestOptions.update({VIEWTOREFRESH_RN:parentId});
ViewAPI.refreshView(requestOptions);
return StatusMsgAPI.OPSTATUS.INPROGRESS;
}
AjaxAPI.closeView = function(response,requestOptions)
{
var uniqueId = requestOptions["SRCVIEW"];
AjaxUtils.showAjaxResponseOnNextPageLoad(response.responseText,true);
if(window.opener == null)
{
closeView(uniqueId);
}
else
{
window.opener.refreshCurrentView();
setTimeout('window.close()',100);
}
return StatusMsgAPI.OPSTATUS.INPROGRESS;
}
AjaxAPI.close = function(element)
{
var parent = DOMUtils.getParentWithAttr(element,"closefunc");
var func = parent.getAttribute("closefunc");
executeFunctionAsString(func,window,element);
return false;
}
AjaxAPI.closeAndRefreshOpener = function(response, requestOptions)
{
var srcViewRefId = requestOptions["SRCVIEW"];
var uniqueId = getUniqueId(srcViewRefId);
var sourceEl = document.getElementById(srcViewRefId + "_CT");
var parent = DOMUtils.getParentWithAttr(sourceEl, "closefunc");
var func = parent.getAttribute("closefunc");
executeFunctionAsString(func,window,sourceEl,true);
return StatusMsgAPI.OPSTATUS.FINISHED;
}
AjaxAPI.refreshOpener = function(opener)
{
if (typeof opener == "object")
{
opener = opener["OPENER"];
}
var requestOptions = {VIEWTOREFRESH_RN:opener, NAVIGABLE_RN:false};
ViewAPI.refreshView(requestOptions);
}
AjaxAPI.forwardView = function(response,requestOptions)
{
AjaxUtils.showAjaxResponseOnNextPageLoad(response.responseText,true);
var paramObj = response.getResponseParams(response.responseText);
var params = getAsQueryString(paramObj);
updateViewInCA(requestOptions['VIEWTOFORWARD'],requestOptions['SRCVIEW'],null,getContentAreaFromState(requestOptions['SRCVIEW']),null,false,null,params);
return StatusMsgAPI.OPSTATUS.INPROGRESS;
}
AjaxAPI.showInDialog = function(response,requestOptions)
{
var oDialog = showDialog(response.responseText,requestOptions["WINPARAMS"],null,null,true);
oDialog.setAttribute("closefunc", "closeParentDialog");
if(requestOptions["OPENERVIEW"]!=null && requestOptions["OPENERVIEW"]!="undefined" && requestOptions["OPENERVIEW"]!="")
{
oDialog.setAttribute("opener", requestOptions["OPENERVIEW"]);
}
else
{
oDialog.setAttribute("opener", requestOptions["SRCVIEW"]);
}
return StatusMsgAPI.OPSTATUS.FINISHED;
}
AjaxAPI.addResponseToElement = function(response,requestOptions)
{
document.getElementById(requestOptions.v('CONTAINERID')).innerHTML = response.getOnlyHtml();
var effectstr = requestOptions["EFFECT"];
if(effectstr == null)
{
effectstr = 'Effect.Grow';
}
if(response.getScripts()!=null && response.getScripts()!="undefined")
response.getScripts().push('<script>' + effectstr + '(\'' + requestOptions.v('CONTAINERID') + '\')</script>');
return StatusMsgAPI.OPSTATUS.FINISHED;
}
AjaxAPI.setOnNextPageLoadScript = function(script)
{
setCookie("PERSMSG",script,null,CONTEXT_PATH + "/framework/html");
}
AjaxAPI.showPersMsg = function(count)
{
var win = window.frames[ROOT_VIEW_ID + "_RESPONSEFRAME"];
if((win == null) || (win.document == null) || (!win.document.isLoaded))
{
if(count < 50)
{
setTimeout("AjaxAPI.showPersMsg(" + ++count +")",30);
}
return;
}
var msgStr = getCookie("PERSMSG",win);
if(msgStr != null)
{
deleteCookie("PERSMSG",CONTEXT_PATH+ "/framework/html",win);
executeFunctionAsString(msgStr,window);
}
}
AjaxAPI.setAjaxAttributes = function(ajaxOptions)
{
ajaxOptions = new AjaxOptions(ajaxOptions);
var frm = ajaxOptions.form("FORMNAME");
for(var i in ajaxOptions)
{
if((typeof ajaxOptions[i]) != "string")
{
continue;
}
existValue = ajaxOptions[i];
frm.setAttribute(i.toLowerCase(),existValue);
}
if(!frm.onsubmit)
{
frm.onsubmit = function(){return AjaxAPI.submit(this);}; 
}
frm.requestOptions = ajaxOptions;
}
AjaxAPI.showRespMsg = function(response,reqOptions)
{
var opStatus = response.opStatus;
var statusDiv = reqOptions["OPSTATUSDIV"];
if(statusDiv != null)
{
StatusMsgAPI.showOperationStatus(opStatus,statusDiv);
}
else
{
StatusMsgAPI.showOperationStatus(opStatus,reqOptions["OPSTATUSID"],reqOptions["OPSTATUSTYPE"],reqOptions["OPSTATUSMESSAGE"], reqOptions["OPSTATUSLOADINGCLASS"], reqOptions["OPSTATUSLOADEDCLASS"]);	
}
if(opStatus == StatusMsgAPI.OPSTATUS.STARTED)
{
StatusMsgAPI.closeMsgImmediately(reqOptions["STATUSMSGID"]);
return;
}
else if(opStatus == StatusMsgAPI.OPSTATUS.FAILED_SCRIPT)
{
throw response["EXCEP"];
}
else if(opStatus == StatusMsgAPI.OPSTATUS.FAILED)
{
if(reqOptions["ONFAILUREFUNC"] != null)
{
reqOptions.fn("ONFAILUREFUNC",response,reqOptions);
}
var respMsg = response.getResponsePart("STATUS_MESSAGE");
if(respMsg == null)
{
showDialog(response.getOnlyHtml(),"title=Error Occurred");
}
else
{
StatusMsgAPI.showMsg(respMsg,(opStatus == StatusMsgAPI.OPSTATUS.FINISHED),true,reqOptions["STATUSMSGID"]);
}
}
else if(opStatus == StatusMsgAPI.OPSTATUS.FINISHED)
{
var respMsg = response.getResponsePart("STATUS_MESSAGE");
if(respMsg == null)
{
var prevResp = reqOptions["PREVRESPONSE_RN"];
if(prevResp != null)
{
respMsg = prevResp.getResponsePart("STATUS_MESSAGE");
}
}
if(respMsg != null)
{
var fadeIn = (reqOptions["FADEIN"] == "false")?false:true;
StatusMsgAPI.showMsg(respMsg,(opStatus == StatusMsgAPI.OPSTATUS.FINISHED),fadeIn,reqOptions["STATUSMSGID"],
reqOptions["OPSTATUSTYPE"],reqOptions["STATUSMSGPOSITION"],
reqOptions["STATUSMSGOFFSETTOP"],reqOptions["STATUSMSGOFFSETLEFT"],
reqOptions["STATUSMSGRELEL"], reqOptions["STATUSMSGEFFECT"],
reqOptions["STATUSMSGEFFECTOPTIONS"]);
}
}
else if(opStatus == StatusMsgAPI.OPSTATUS.INPROGRESS)
{
reqOptions["PREVRESPONSE_RN"] = response;
}
response.invokeScripts();
if(reqOptions["TARGET"] != null)
{
var target = reqOptions["TARGET"]; 
var mcframeaction = reqOptions["MCFRAMEACTION"];
var replacingView = getRootViewEl(response);
if(replacingView != null)
{
var viewtoforward = replacingView.getAttribute("unique_id");
var mcframe = AjaxAPI.getMCFrame(reqOptions);  	  
if(target.indexOf("_mcframe") == 0
&& mcframeaction != null && mcframeaction.indexOf("replace") != -1)
{
mcframe.history.replace(viewtoforward);
}
else if(target.indexOf("_mcframe") == 0
&& mcframeaction != null && mcframeaction.indexOf("clear") != -1)
{
mcframe.history.clear(viewtoforward);
}  	  
else if(target.indexOf("_mcframe") == 0)
{
mcframe.history.update(viewtoforward);
}
} 
}  
}
function AjaxOptions(options)
{
this.v = function(optName,defaultValue)
{
var value = this[optName.toUpperCase()];
if(value == null)
{
value = defaultValue;
}
if(value == null) 
{
throw new Error("OptionNotPresent:" + optName + " is not present");
}
return value;
}
this.vu = function(optName)
{
return this.v(optName).toUpperCase();
}
this.isTrue = function(optName,defaultValue)
{
var value =  this.v(optName,defaultValue);
return ((value == true) || (value == "true"));
}
this.fn = function(optName)
{
var value = this.v(optName);
if(value instanceof Function)
{
return value.apply(window, Array.prototype.slice.call(arguments).splice(1));
}
try{ 
return executeFunctionAsString(value,window,arguments);
}
catch(exp)
{
throw new Error("IllegalOption : " + value + " is not a function.");
}
}
this.form = function(optName)
{
var frm = DOMUtils.getForm(this.v(optName));
if(frm == null)
{
throw new Error(" FormNotFound : " + this.v(optName) + " not found");  
}
return frm;
}
this.setV = function(optName,optValue)
{
this[optName.toUpperCase()] = optValue;
}
this.update = function(newOptions)
{
for (property in newOptions) 
{
var val = newOptions[property];
this[property.toUpperCase()] = val;
}
}
this.encode = function()
{
var encodedStr ="";
var defaults = new AjaxOptions();
for(var i in this)
{    
if(this[i] instanceof Object)
{continue;}
if(defaults[i] == this[i])
{ continue;}
if((i == "URL") || (i =="METHOD"))
{ continue;}
var index = i.lastIndexOf("_RN");
if(index == i.length - "_RN".length)
{
continue;
}
var name = (i == "ONSUCCESSFUNC")? "_OS":i;
encodedStr += name + "=" + this[i] + "&";
}
if(encodedStr.length > 1)
{
encodedStr = encodedStr.substring(0,encodedStr.length -1);
}
return encodedStr;
}
this.update({METHOD:'POST',
ASYNCHRONOUS:true,
STATUSFUNC:'AjaxAPI.showRespMsg',
BEFOREREQUEST:DEFAULT_REQUEST_OPTIONS.beforeRequest,
AFTERRESPONSE: DEFAULT_REQUEST_OPTIONS.afterResponse
});
if((typeof options) == "string")
{
options = parseRequestParams(options);
for(var i in options)
{
options[i]= options[i][0];
}
if(options["_OS"] != null){options["ONSUCCESSFUNC"] = options["_OS"]}
}
this.update(options);
}
AjaxOptions.getAsAjaxOptions = function(options)
{
if(!(options instanceof AjaxOptions))
{
options = new AjaxOptions(options);
}  
return options;
}
function AjaxResponse(transportUsed)
{
this.responseText = null;
this.htmlContent = null;
this.scripts = null;
this.transport = transportUsed;
this.opStatus = StatusMsgAPI.OPSTATUS.STARTED;
this.isHttpReqSuccess = function() 
{
return this.transport.status == undefined
|| this.transport.status == 0 
|| (this.transport.status >= 200 && this.transport.status < 300);
}
this.getResponsePart = function(responsePart)
{
return AjaxUtils.extractFromResponse(this.responseText,responsePart);
}
this.getResponseParams = function()
{
var paramString = AjaxUtils.extractFromResponse(this.responseText,"RESPONSE_PARAMS");
return (paramString != null) ? JSON.parse(paramString) : {};
}
this.getOnlyHtml = function()
{
this.splitResponse();
return this.htmlContent;
}
this.getScripts = function()
{
this.splitResponse();
return this.scripts;
}
this.invokeScripts = function()
{
if(!this["alreadyInvoked"])
{
AjaxUtils.invokeScripts(this.getScripts());
this["alreadyInvoked"] = true;
}
}
this.splitResponse = function()
{
if(this.htmlContent !=null)
{
return;
}
var split = AjaxUtils.separateScriptAndHtml(this.responseText);
this.htmlContent = split["html"];
this.scripts = split["scripts"];
}
}
var AjaxUtils = new function(){}
AjaxUtils.ignoreNavigFrameLoad = false;
AjaxUtils.handleNavigFrameLoad = function()
{
var queryStr = window.frames["AJAXNAVIG"].location.search;
window.status = "handle NavigFrameLoad called. " + queryStr + " " + AjaxUtils.ignoreNavigFrameLoad;
if(AjaxUtils.ignoreNavigFrameLoad) 
{
AjaxUtils.ignoreNavigFrameLoad = false;
return;
}
if((queryStr == null) || (queryStr == ""))
{
return;
}
var requestOptions = new AjaxOptions(queryStr);
requestOptions.fn("NAVIGFUN_N",requestOptions);
}
AjaxUtils.invokeScriptsInHtml = function(html)
{
var match    = new RegExp(Prototype.ScriptFragment, 'img');
var scriptTags  = html.match(match);
AjaxUtils.invokeScripts(scriptTags);
}
AjaxUtils.separateScriptAndHtml = function(htmlSnippet)
{
var sepHash = new Object();
var match    = new RegExp(Prototype.ScriptFragment, 'img');
sepHash["html"] = htmlSnippet.replace(match, '');
match    = new RegExp(Prototype.ScriptFragment, 'img');
sepHash["scripts"] = htmlSnippet.match(match);
return sepHash;
}
AjaxUtils.invokeScripts = function(scriptTags)
{
if(scriptTags == null){return;}
var div = document.createElement("div");
var scriptStr = "";
for (var i = 0; i < scriptTags.length; i++) {
scriptStr += "\n" + scriptTags[i];
}
var match    = new RegExp("<script>", 'img');
scriptStr = scriptStr.replace(match,"<SCRIPT>");
match    = new RegExp("<\/script>", 'img');
scriptStr = scriptStr.replace(match,"</SCRIPT>");
div.innerHTML = "<html><body>" + scriptStr + "</body></html>";
scriptTags = div.getElementsByTagName("SCRIPT");
for (var i = 0; i < scriptTags.length; i++) {
AjaxUtils.scheduleScript(scriptTags[i].text,scriptTags[i].src);
}
}
AjaxUtils.scheduleScript = function(script,scriptFile){
var scriptTag = document.createElement("SCRIPT");
if ((scriptFile != null) && (scriptFile != ""))
{ scriptTag.src = scriptFile;}
scriptTag.text = script;
if (!document.getElementsByTagName("HEAD")[0]) {
document.createElement("HEAD").appendChild(scriptTag)
} else {
if(window["uniqueId"] != null)
{
scriptTag.id = "script_"+window["uniqueId"];	
removeScriptsFromHead(window["uniqueId"]);
}
document.getElementsByTagName("HEAD")[0].appendChild(scriptTag);
}
}
AjaxUtils.handleAjaxResponse = function(ajaxResp,requestOptions)
{
if(requestOptions["AFTERRESPONSE"])
{
requestOptions.fn("AFTERRESPONSE", ajaxResp, requestOptions);
}
if(ajaxResp.transport.readyState !=4 )
{
return;
}
ajaxResp.responseText = ajaxResp.transport.responseText;
ajaxResp.opStatus = StatusMsgAPI.OPSTATUS.INPROGRESS;
if(requestOptions["ORIGOPTIONS"])
{
requestOptions = requestOptions["ORIGOPTIONS"];
closeDialog();
}
ajaxResp.opStatus = AjaxUtils.internalHandleAjaxResponse(ajaxResp,requestOptions);
if(requestOptions["STATUSFUNC"])
{    
requestOptions.fn("STATUSFUNC",ajaxResp,requestOptions);
}
}
AjaxUtils.internalHandleAjaxResponse = function(response,requestOptions)
{
if(response.responseText.indexOf("__ERROR__LOGIN") > -1)
{
if(response.responseText.indexOf("__HIDE__BOX")>-1)
{
AjaxUtils.handleReLogin(response,requestOptions,true);
return StatusMsgAPI.OPSTATUS.INPROGRESS_LOGIN;
}
else
{
AjaxUtils.handleReLogin(response,requestOptions,false);
return StatusMsgAPI.OPSTATUS.INPROGRESS_LOGIN;
}
}
else if((response.responseText.indexOf("__ERROR__") > -1)
|| !response.isHttpReqSuccess())
{
return StatusMsgAPI.OPSTATUS.FAILED;
}
var opStatus = StatusMsgAPI.OPSTATUS.FINISHED;
if(requestOptions["ONSUCCESSFUNC"])
{
try
{
opStatus = requestOptions.fn("ONSUCCESSFUNC",response,requestOptions);
if(!opStatus){opStatus = StatusMsgAPI.OPSTATUS.FINISHED;}
}
catch(ex)
{
response["EXCEP"] = ex;
return StatusMsgAPI.OPSTATUS.FAILED_SCRIPT;
}
}
if(requestOptions["TARGET"])
{
var target = requestOptions["TARGET"];
var srcViewRefId = requestOptions["SRCVIEW"];
var sourceEl = document.getElementById(srcViewRefId + "_CT");
if (target.indexOf("_opener_view_this") == 0)
{
var parent = DOMUtils.getParentWithAttr(sourceEl, "opener");
if(parent)
{
replaceWithResponseView(response, parent.getAttribute("opener"));
setTimeout(function(){closeDialog(null,sourceEl);},100, sourceEl);
}
else
{
window.opener.replaceWithResponseView(response, window.name);
setTimeout('window.close()',100);			
}
} 
else if (target.indexOf("_opener_view_") == 0)
{
var viewToReplace = target.substring("_opener_view_".length);
if(window.opener)
{  	       
window.opener.replaceWithResponseView(response, viewToReplace);
setTimeout('window.close()',100);
}
else
{
replaceWithResponseView(response, viewToReplace);
setTimeout(function() {closeDialog(null,sourceEl);},100, sourceEl);
}
} 	  	   
else if (target.indexOf("_view_this") == 0)
{
var viewToReplace = requestOptions['SRCVIEW'];
replaceWithResponseView(response, viewToReplace);
}  	  
else if(target.indexOf("_mcframe") == 0)  
{
var mcframe = AjaxAPI.getMCFrame(requestOptions);
var dArr = mcframe.dacarray;
if(dArr == null || dArr.length == 0)
{
replaceWithResponseView(response, mcframe.contentareaname);  	  
}
else
{
var viewToReplace = getUniqueId(dArr[dArr.length -1]);
replaceWithResponseView(response, viewToReplace);
}
}	  
else if (target.indexOf("_divpopup") == 0)
{
if(requestOptions["ONSUCCESSFUNC"] != "AjaxAPI.showInDialog")
{
AjaxAPI.showInDialog(response, requestOptions);
}
}
else if(target.indexOf("_div_") == 0)
{
var divid = target.substring("_div_".length);  	
requestOptions["CONTAINERID"] = divid;
if(requestOptions["ONSUCCESSFUNC"] != "AjaxAPI.addResponseToElement")
{  	       
AjaxAPI.addResponseToElement(response, requestOptions);
}
}
else if (target.indexOf("_view_") == 0)
{
var viewToReplace = target.substring("_view_".length);
replaceWithResponseView(response, viewToReplace);
}
}
return opStatus;
}
AjaxUtils.handleReLogin = function(response,requestOptions,hideBox)
{
if(hideBox)
{
showDialog(response.responseText,"dialogBoxType=none,title=ReLogin(Session Timed Out),modal=yes,closePrevious=false");
}
else
{
showDialog(response.responseText,"title=ReLogin(Session Timed Out),modal=yes,closePrevious=false");
}
var frm = DOMUtils.getFirstMatchingElement(oDialog.getElementsByTagName("form"),null,"name","login");
if(frm == null)
{
throw new Error("Login Page should contain a form with name as \"login\"");
}
frm["REQUESTOPTIONS"] = requestOptions;
frm.onsubmit = function(){AjaxUtils.submitReLoginFrm(frm);return false;};
return;
}
AjaxUtils.submitReLoginFrm = function(frm)
{
var validateFunc = frm.getAttribute("validatefunc");
if(validateFunc)
{
if(!(executeFunctionAsString(frm.getAttribute("validatefunc"),window,frm)))
{
return false;
}
}
var params = AjaxAPI.serialize(frm);
AjaxAPI.sendRequest({URL:frm.action,PARAMETERS:params,ORIGOPTIONS:frm["REQUESTOPTIONS"]});
return false;
}
AjaxUtils.updateObject = function(destination, source) {
if(source == null){return;}
for (property in source) {
destination[property] = source[property];
}
return destination;
}
AjaxUtils.extractFromResponse = function(responseText,responsePart)
{
var div = document.createElement("div");
div.innerHTML = responseText;
var respPart = DOMUtils.getFirstMatchingElement(div.getElementsByTagName("div"),null,"part",responsePart);
return (respPart != null)? respPart.innerHTML: null;
}
AjaxUtils.getContentFromResponseElements = function(responseText,tag,attr,attrValue)
{
var div = document.createElement("div");
div.innerHTML = responseText;
var respPart = DOMUtils.getFirstMatchingElement(div.getElementsByTagName(tag),null,attr,attrValue);
return (respPart != null)? respPart.innerHTML: null;
}
AjaxUtils.showAjaxResponseOnNextPageLoad = function(responseText,isSuccess)
{
var respMsg = AjaxUtils.extractFromResponse(responseText,"STATUS_MESSAGE");
if(respMsg == null)
{
return;
}
StatusMsgAPI.showMsgOnNextPageLoad(respMsg,isSuccess);
}
var StatusMsgAPI = new function(){}
StatusMsgAPI.showOperationStatus = function(opStatus,opDivId,opstatustype,opstatusmessage, opstatusloadingclass, opstatusloadedclass)
{
var opStatus = ((opStatus == StatusMsgAPI.OPSTATUS.STARTED)  ||  (opStatus == StatusMsgAPI.OPSTATUS.INPROGRESS) || (opStatus == StatusMsgAPI.OPSTATUS.INPROGRESS_LOGIN))
if(opstatusmessage == null)
{
opstatusmessage = "Loading ...";
}
if(opstatustype == "gmail")
{
if((opStatus))
{
document.getElementById("mc_loading").innerHTML = '<div class="gmailtype"  >'+ opstatusmessage +  '</div> ';
}
else
{
document.getElementById("mc_loading").innerHTML = "";
}
}
else if(opstatustype == "dialog")
{
if(opStatus)
{
var dlghtml =  '<div class="status-window-table">' + opstatusmessage +'<div class="dialogtype">'  + '</div></div> ';
showDialog(dlghtml,"title=Loading,modal=yes,position=absmiddle,closeOnEscKey=no",null,'abcd');
}
else
{
closeDialog();
}
}
else if(opstatustype == "statusbar")
{
if(opStatus)
{
document.getElementById("mc_loading").innerHTML = '<div class="statusbar"><button ' + 'class="imagestyle"></button>'+ opstatusmessage +'</div> ';                    
}
else
{
document.getElementById("mc_loading").innerHTML = "";                      
}
}
else      
{
if(opDivId == null)
{
opDivId = "mc_loading";
}
var el = document.getElementById(opDivId);
if(el != null)
{
if(opstatusloadedclass == null)
{
opstatusloadedclass = 'mcLoaded';
}
if(opstatusloadingclass == null)
{
opstatusloadingclass = 'mcLoading';
}            	        	
if(opStatus)
{
DOMUtils.replaceCSSClass(el,opstatusloadingclass,opstatusloadedclass);
}
else
{
DOMUtils.replaceCSSClass(el,opstatusloadedclass,opstatusloadingclass);
}
}
}
}
StatusMsgAPI.showMsgOnNextPageLoad = function(msg,isSuccess)
{
msg = msg.replace(/\n/g,"\\n");
var regex = new RegExp("'","g");
msg = msg.replace(regex,"\\'");
AjaxAPI.setOnNextPageLoadScript("StatusMsgAPI.showMsg('" + msg + "'," + isSuccess + ")");
}
StatusMsgAPI.showMsg = function(message, isSuccess, fadeout,msgDivId, opstatustype, 
statusmsgposition, statusmsgoffsettop, statusmsgoffsetleft, statusmsgrelel, statusmsgeffect,
statusmsgeffectoptions)
{
msgDivId = StatusMsgAPI.getDivId(msgDivId,"MSGDIV","mc_msg");
var msgContainer = document.getElementById(msgDivId);
if(msgContainer != null)
{
var msgTextEl = document.getElementById(msgDivId +"_txt");
if(msgTextEl == null)
{
msgTextEl = msgContainer;
}
if(statusmsgposition == "absmiddle")
{
var dlgel = document.getElementById('_DIALOG_LAYER');
if(dlgel != null)
{
dlgel.className="";
dlgel.style.opacity=100;
}
var tmpcontainer = msgContainer.cloneNode(true);
tmpcontainer.setAttribute("id", tmpcontainer.id + "_copy");
tmpcontainer.innerHTML=message;
var dlg = showDialog(tmpcontainer,"title=Loading,position=absmiddle,closeOnEscKey=no",null,'abcd');
dlg.style.display="";
statusMsgEffect(statusmsgeffect, statusmsgeffectoptions, tmpcontainer);
return;  			
}
else if (statusmsgposition == "relative")
{
if(statusmsgoffsetleft == null)  				
{
statusmsgoffsetleft = "25";
}
if(statusmsgoffsettop == null)
{
statusmsgoffsettop = "10";
}
var dlgel = document.getElementById('_DIALOG_LAYER');
if(dlgel != null)
{
dlgel.className="";
}
var tmpcontainer = msgContainer.cloneNode(true);
tmpcontainer.setAttribute("id", tmpcontainer.id + "_copy");
tmpcontainer.innerHTML=message;       			
var dlg = showDialog(tmpcontainer,"srcElement=" + statusmsgrelel + ",top=" + statusmsgoffsettop 
+ ",left=" + statusmsgoffsetleft 
+ ",title=Loading,position=relative,closeOnEscKey=no",null,'abcd');
dlg.style.display="";
statusMsgEffect(statusmsgeffect, statusmsgeffectoptions, tmpcontainer);
return;  			  			
}
msgContainer.className = (isSuccess)?"successMsg":"failureMsg";  
msgContainer.style.opacity=100;  			
msgTextEl.innerHTML = message;    		
if(fadeout == null)
{
fadeout = true;
}
if(isSuccess && (fadeout == true))
{
if(statusmsgeffect == "highlight")
{
var effectoptions = {startcolor:'#9EFF7F', endcolor:'#FAD163',afterFinish:closeDialog,queue:'end'};
var tmpeffoptions =statusmsgeffectoptions;       				       	
Object.extend(effectoptions, tmpeffoptions||{});								
new Effect.Highlight(msgDivId, effectoptions);
effectoptions = { duration: 2.0, transition: Effect.Transitions.linear, 
from: 1.0, to: 0.0 ,queue:'end',afterFinish:closeStatus,msgDivId:msgDivId};
tmpeffoptions = statusmsgeffectoptions;
Object.extend(effectoptions, tmpeffoptions||{});								       						
new Effect.Opacity(msgDivId,effectoptions);
}
else
{
StatusMsgAPI.closeMsg(msgDivId);
}
}
else if(!isSuccess)
{
msgContainer.style.visibility = 'visible';
window.clearInterval(msgContainer.f_intvl);
}
}
else if(!isSuccess)
{
showDialog(message,"title=Error Occurred");
}
}
function statusMsgEffect(statusmsgeffect, statusmsgeffectoptions, tmpcontainer)
{
if(statusmsgeffect == "highlight")
{
var effectoptions = {startcolor:'#9EFF7F', endcolor:'#FAD163',afterFinish:closeDialog};
var tmpeffoptions =statusmsgeffectoptions;
Object.extend(effectoptions, tmpeffoptions||{});
new Effect.Highlight(tmpcontainer.id, effectoptions);
}
else
{
new Effect.Opacity(tmpcontainer.id,{ duration: 2.0, transition: Effect.Transitions.linear, 
from: 1.0, to: 0.0 ,afterFinish:closeDialog});
}	
}
function closeStatus(obj)
{
StatusMsgAPI.removeMsg(obj['element'].id);	
}
StatusMsgAPI.closeMsg =function(msgDivId)
{
msgDivId = StatusMsgAPI.getDivId(msgDivId,"MSGDIV","mc_msg");
if(document.getElementById(msgDivId) == null)
{
return;
}  
MCEffect.FadeOut(msgDivId, {ONCLOSE:"StatusMsgAPI.removeMsg",MSGDIV:msgDivId});
}
StatusMsgAPI.closeMsgImmediately =function(msgDivId)
{
msgDivId = StatusMsgAPI.getDivId(msgDivId,"MSGDIV","mc_msg");
var divobj = document.getElementById(msgDivId);	
if(divobj != null)
{
divobj.visibility = 'hidden';
}
}
StatusMsgAPI.removeMsg =function(msgDivId)
{
msgDivId = StatusMsgAPI.getDivId(msgDivId,"MSGDIV","mc_msg");
var divobj = document.getElementById(msgDivId);
if(divobj != null)
{
divobj.className = 'hide';
}
}
StatusMsgAPI.getDivId = function(msgDivId,reqParamName,defaultId)
{
if(msgDivId instanceof Object) { msgDivId = msgDivId[reqParamName];}
if(msgDivId == null){ msgDivId = defaultId;} 
return msgDivId;
}
StatusMsgAPI.OPSTATUS= new function(){ 
this.STARTED =1;
this.INPROGRESS=2;
this.INPROGRESS_LOGIN=3;
this.FINISHED=4;
this.FAILED=5;
this.FAILED_SCRIPT=6;
}
var DOMUtils = new function(){
this.addCSSClass = function(els, cssClass) 
{
for(var i =0; i < els.length; i++)
{
var curClass = els[i].className;
if(curClass == null)
{
curClass = cssClass;
}
else
{
var index = curClass.indexOf(cssClass);
if(index == -1)
{
curClass = curClass.trim();
curClass += " " + cssClass;
}
}
els[i].className = curClass;
}
}
this.replaceCSSClass = function(el,newClass,oldClass)
{
var curClass = el.className;    
if((curClass == null) || (curClass == oldClass))
{
curClass = newClass;
}
else
{
var index = curClass.indexOf(oldClass);
if(index == -1)
{
if(curClass.indexOf(newClass) == -1)
{
curClass +=" " + newClass;      
}
}
else
{
curClass = curClass.substring(0,index) + newClass + curClass.substring(index + oldClass.length);
}
}
el.className = curClass;
}
this.removeCSSClass = function(elList, cssClass)
{
for(var i =0; i < elList.length; i++)
{
var curClass = elList[i].className;
if(curClass == null)
{
continue;
}
var index = curClass.indexOf(cssClass);
if(index > -1)
{
if(curClass == cssClass)
{ curClass = null;}
else
{curClass = curClass.substring(0,index) + curClass.substring(index + cssClass.length + 1);}
}
elList[i].className = curClass;
}
}
this.filterElements = function(elList,elType,attrName,attrValue)
{
var filteredList = new Array();
var j = 0;
var anyVal  = (attrValue == "*");
for(var i =0;i < elList.length ; i++)
{
if((elType == null) || (elList[i].nodeName == elType))
{
if((attrName == null)|| (elList[i].getAttribute(attrName) == attrValue)
|| ((anyVal) &&(elList[i].getAttribute(attrName) != null)))
{
filteredList[j++] = elList[i];
}
}
}
return filteredList;
}
this.getFirstMatchingElement = function(elList,elType,attrName,attrValue)
{
for(var i =0;i < elList.length ; i++)
{
if((elType == null) || (elList[i].nodeName == elType))
{
if((attrName == null)|| (elList[i].getAttribute(attrName) == attrValue)
|| ((attrValue == "*") &&(elList[i].getAttribute(attrName) != null)))
{
return elList[i];
}
}
}
return null;
}
this.getChildElsWithAttr = function(parentEl,attrName,attrValue)
{
var childNodes = parentEl.getElementsByTagName("*");
return this.filterElements(childNodes,null,attrName,attrValue);
}
this.getFirstChild = function(parentEl,attrName,attrValue,filterAttr,filterValue)
{
var b;
var a=DOMUtils.getChildElsWithAttr(parentEl,attrName,attrValue);
for(i=0 ; i<a.length ; i++)
{       
b=a[i].parentNode;
while(b != parentEl)
{	
if(b.getAttribute(filterAttr) == filterValue)
{
break;
}
b = b.parentNode;
}
if(b == parentEl) 
{
return a[i];
}
}
}
this.getParentWithAttr = function(childNode,parentAttrName)
{
var parNode = childNode.parentNode;
while((parNode != null) && (parNode.getAttribute != null))
{
if(parNode.getAttribute(parentAttrName) != null)
{
return parNode;
}
parNode = parNode.parentNode;
}
return null;
}
this.getParentWithAttrValue = function(childNode,parentAttrName,attrValue)
{
var parentNode = childNode.parentNode;
while((parentNode != null) && (parentNode.getAttribute != null))
{
if(parentNode.getAttribute(parentAttrName) == attrValue)
{
return parentNode;
}
parentNode = parentNode.parentNode;
}
return parentNode;
}
this.getForm = function(frmName)
{
var frm = document.forms[frmName];
if(frm != null)
{
return frm;
}
for(var i=0; i<document.forms.length; i++)
{
if(document.forms[i].name == frmName)
{
return document.forms[i];
}
}
return null;
}
this.getForm = function(frmName)
{
var frm = document.forms[frmName];
if(frm != null)
{
return frm;
}
for(var i=0; i<document.forms.length; i++)
{
if(document.forms[i].name == frmName)
{
return document.forms[i];
}
}
return null;
}
this.setAttribute = function(elList,attrName,attrValue)
{
for(var i = 0; i < elList.length; i++)
{
elList[i].setAttribute(attrName,attrValue);
}
}
this.setProperty = function(elList,propName,propValue)
{
for(var i = 0; i < elList.length; i++)
{
elList[i][propName] = propValue;
}
}
this.fillData = function(elements,data)
{
for(var count=0; count < elements.length; count++)
{
this.setValueOnEl(elements[count],data[elements[count].getAttribute("name")]);
}
}
this.setValueOnEl = function(curEl,value)
{
var type = curEl.type;
var nodeName = curEl.nodeName;
if(value == null){ return;}
if((type == "radio") || (type == "checkbox"))
{
curEl.checked = (value == curEl.value);
}
else if(type == "select-one")
{
for(var i =0;i < curEl.options.length; i++)
{
if( (curEl.options[i].value && curEl.options[i].value == value)
|| (curEl.options[i].innerHTML == value))
{
curEl.options[i].selected = true;
}
}
}
else if((nodeName == "DIV") || (nodeName == "SPAN"))
{
curEl.innerHTML = value;
}
else
{
curEl.value = value;
}
}
}
LangUtils = new function(){}
LangUtils.cloneArray = function(arrayToClone)
{
var clonedArray = new Array();
for(var i =0; i < arrayToClone.length; i++)
{
clonedArray[i] = arrayToClone[i];
}
return clonedArray;
}
function printfire()
{
if (document.createEvent)
{
printfire.args = arguments;
var ev = document.createEvent("Events");
ev.initEvent("printfire", false, true);
dispatchEvent(ev);
}
}
function removeScriptsFromHead(id)
{
var headElement=document.getElementsByTagName("HEAD")[0];
var scriptTagsToBeRemoved=DOMUtils.getChildElsWithAttr(headElement,"id","script_"+id);
for(var i=(scriptTagsToBeRemoved.length)-1;i>0;i--)
{
headElement.removeChild(scriptTagsToBeRemoved[i]);
}
}
function executeFunctionAsString(functionName, context) {
var namespaces = functionName.split(".");
var func = namespaces.pop();
for (var i = 0; i < namespaces.length; i++) {
context = context[namespaces[i]];
}
if (typeof context[func] === "function") 
{
var spliceDelCount = (arguments[2].length - 1) || 999999;
if ((arguments[2]).callee)
{
var index = isWindow(arguments[2]);
if (index == -1) {
return context[func].apply(context, Array.prototype.slice.call(arguments[2]).splice(1, spliceDelCount));
} else {
return context[func].apply(context, Array.prototype.slice.call(arguments[2]).splice(index + 1, spliceDelCount));
}
} 
else if (arguments.length > 1) 
{
return context[func].apply(context, Array.prototype.slice.call(arguments).splice(2, spliceDelCount));
} 
else {
return context[func].apply(context);
}
}
throw new Error("The given function "+functionName+" is not defined");
}
function isWindow(params)
{
for (var i = 0; i < params.length; ++i) {
if (params[i].toString() == "[object Window]") {
return i;
}
}
return -1;
}
LangUtils.log = printfire;
