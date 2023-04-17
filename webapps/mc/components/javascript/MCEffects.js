var MCEffect = new function(){}
MCEffect.CONFIG = {INTERVAL:10,SCROLL_INTERVAL:3,FADE_INTERVAL:5};
MCEffect.getValue = function(propName,overrideMap,defaultMap)
{
if (overrideMap != null)
{
if (overrideMap[propName] != null)
{
return overrideMap[propName];
}
}
if (defaultMap != null)
{
if (defaultMap[propName] != null)
{
return defaultMap[propName];
}
}
return null;
}
MCEffect.getDimensions = function(element)
{
if (element.style.display != 'none')
{
return {width: element.offsetWidth, height: element.offsetHeight};
}
var els = element.style;
var originalVisibility = els.visibility;
var originalPosition = els.position;
els.display = 'block';
els.visibility = 'hidden';
els.position = 'absolute';
var originalWidth = element.offsetWidth;
var originalHeight = element.offsetHeight;
els.display = 'none';
els.position = originalPosition;
els.visibility = originalVisibility;
return {width: originalWidth, height: originalHeight};
}
MCEffect.SlideDown = function(elementID, reqOptions)
{
var content = document.getElementById(elementID);
if (content == null)
{
return;
}
if (MCEffect.getValue("INTERVAL", reqOptions, MCEffect.CONFIG) == -1)
{
content.style.display = 'block';
if (reqOptions != null)
{
var obj = reqOptions["ONOPEN"];
if (obj != null)
{
executeFunctionAsString(obj,window,reqOptions);
}
}
return;
}
window.clearInterval(content._intvl);
window.clearInterval(content.s_intvl);
content._reqOptions = reqOptions;
appendParent(content);
var contentHeight = MCEffect.getDimensions(content).height;
var margin = -1 * contentHeight;
content.style.marginTop = margin + "px";
content.setAttribute("__margin", margin);
var openIntvl = window.setInterval("MCEffect.openContent('" + elementID  + "')", 1);
content._intvl = openIntvl;
}
MCEffect.openContent = function(elementID)
{
var content = document.getElementById(elementID);
var margin = parseInt(content.getAttribute('__margin'));
var reqOptions = content._reqOptions;
if (margin <= 0)
{
content.style.marginTop = (margin) + "px";    
margin += MCEffect.getValue("INTERVAL", reqOptions, MCEffect.CONFIG);
content.setAttribute("__margin", margin);
content.style.display = 'block';
var top = parseInt(findPosY(content));
var contentHeight = content.offsetHeight;
var docHeight = document.body.clientHeight;
var scrollTop = document.body.scrollTop;
if (top + contentHeight - scrollTop > docHeight)
{
replaceParent(content);
content.style.marginTop = "0px";
window.clearInterval(content._intvl);
MCEffect.ScrollToView(elementID,reqOptions);
}
}
else 
{
replaceParent(content);
content.style.marginTop = "0px";    
window.clearInterval(content._intvl);
if (reqOptions != null)
{
var obj = reqOptions["ONOPEN"];
if (obj != null)
{
executeFunctionAsString(obj,window,reqOptions);
}
}
}
}
MCEffect.ScrollToView = function (id, reqOptions)
{
var element = document.getElementById(id);
if (!element) return;
window.clearInterval(element.s_intvl);
var top = parseInt(findPosY(element));
var height = element.offsetHeight;
var docHeight = document.body.clientHeight;
var scrollTop = document.body.scrollTop;
var intvl = null;
if (top - scrollTop < 0)
{
if (reqOptions != null)
{
reqOptions._scroll = top;
}
else
{
reqOptions = {_scroll:top};
}
element._reqOptions = reqOptions;
intvl = window.setInterval("MCEffect.scrollUp('" + id + "')", 1);
}
else if (top + height - scrollTop > docHeight)
{
var scrollDownCnt = (top + height) - docHeight;
if (reqOptions != null)
{
reqOptions._scroll = scrollDownCnt;
}
else
{
reqOptions = {_scroll:scrollDownCnt};
}
element._reqOptions = reqOptions;
intvl = window.setInterval("MCEffect.scrollDown('" + id + "')", 1);
}
element.s_intvl = intvl;
}
MCEffect.scrollUp = function(elementID)
{
var scrollTop = document.body.scrollTop;
var element = document.getElementById(elementID);
var reqOptions = element._reqOptions;
if (!reqOptions)
{
window.clearInterval(element.s_intvl);
return;
}
var scrollUpCnt = reqOptions._scroll;
if (scrollTop > scrollUpCnt)
{
document.body.scrollTop -= 3;
}
else
{
scrollUpCnt = 0;
window.clearInterval(scrollUpIntvl);
if (reqOptions != null)
{
var obj = reqOptions["ONOPEN"];
if (obj != null)
{
executeFunctionAsString(obj,window,reqOptions);
}
}
}
}
MCEffect.scrollDown = function(elementID)
{
var scrollTop = document.body.scrollTop;
var element = document.getElementById(elementID);
var reqOptions = element._reqOptions;
if (!reqOptions)
{
window.clearInterval(element.s_intvl);
return;
}
var scrollDownCnt = reqOptions._scroll;
if (scrollTop < scrollDownCnt)
{
document.body.scrollTop += 3;
}
else
{
scrollDownCnt = 0;
window.clearInterval(element.s_intvl);
if (reqOptions != null)
{
var obj = reqOptions["ONOPEN"];
if (obj != null)
{
executeFunctionAsString(obj,window,reqOptions);
}
}
}
}
function appendParent(content)
{
var parent = content.parentNode;
parent.style.overflow='hidden';
var div = document.createElement("div");  
div.style.overflow='hidden';
div.className ='innerDiv';
div.setAttribute("__MC_HOLDERDIV","true");
parent.replaceChild(div, content);
div.appendChild(content);
}
function replaceParent(content)
{
var parent = content.parentNode;
if(parent.getAttribute("__MC_HOLDERDIV") == null)
{
return;
}
parent.parentNode.replaceChild(content,parent);
}
MCEffect.SlideUp = function(elementID, reqOptions)
{
var content = document.getElementById(elementID);
if (content == null)
{
return;
}
if (MCEffect.getValue("INTERVAL", reqOptions, MCEffect.CONFIG) == -1)
{
content.style.display = 'none';
if (reqOptions != null)
{
var obj = reqOptions["ONCLOSE"];
if (obj != null)
{
executeFunctionAsString(obj,window,reqOptions);
}
}
return;
}
window.clearInterval(content._intvl);
content._reqOptions = reqOptions;
appendParent(content);
content.style.display = 'block';
var contentHeight = content.offsetHeight;
var margin = 0;
content.setAttribute("__margin", margin);
content.setAttribute("_conHeight", contentHeight);
var closeIntvl = window.setInterval("MCEffect.closeContent('" + elementID  + "')",1);
content._intvl = closeIntvl;
}
MCEffect.closeContent = function(elementID)
{
var content = document.getElementById(elementID);
var contentHeight = content.getAttribute("_conHeight");
var margin = parseInt(content.getAttribute('__margin'));
if (margin >= contentHeight * -1)
{
content.style.marginTop = (margin) + "px";
margin -= MCEffect.getValue("INTERVAL", reqOptions, MCEffect.CONFIG);
content.setAttribute("__margin", margin);
}
else
{
content.style.display = "none";
replaceParent(content);
window.clearInterval(content._intvl);
var reqOptions = content._reqOptions;
if (reqOptions != null)
{
var obj = reqOptions["ONCLOSE"];
if (obj != null)
{
executeFunctionAsString(obj,window,reqOptions);
}
}
}
}
MCEffect.FadeOut = function(elementID, reqOptions)
{
var element = document.getElementById(elementID);
if(element == null)
{
return;
}  
window.clearInterval(element.f_intvl);
element.style.visibility = 'visible';
if (browser_ie)
{
element.style.filter="progid:DXImageTransform.Microsoft.Fade(duration=6)";
element.filters[0].Apply();
element.style.visibility = 'hidden';
element.filters[0].Play();
if (reqOptions != null)
{
var obj = reqOptions["ONCLOSE"];
if (obj != null)
{
element["___REQOPT"] = reqOptions;
setTimeout("closeOnFade('" + elementID + "')",6000);
}
}
return;
}
var intvl = window.setInterval("MCEffect.fadeOut('" + elementID + "')",1);
element.f_intvl = intvl;
element._cnt = 3;
element.style.opacity = element._cnt;
element._reqOptions = reqOptions;
}
function closeOnFade(elementID)
{
var element = document.getElementById(elementID);
var reqOptions= element["___REQOPT"];  
var obj = reqOptions["ONCLOSE"];
if (obj != null)
{
executeFunctionAsString(obj,window,reqOptions);
}
}
MCEffect.fadeOut = function(elementID)
{
var element = document.getElementById(elementID);
if(element == null)
{
return;
}  
var cnt = parseFloat(element._cnt);
if (cnt > 0)
{
var def = "" + MCEffect.getValue("FADE_INTERVAL", MCEffect.CONFIG);
if (def.length > 2)
{
cnt = (cnt - 0.09);
if (cnt < 1)
{
element.style.opacity = cnt;
}
}
else
{
var temp = "0.0"
if (def.length == 1)
{
temp = "0.00";
}
cnt = cnt - parseFloat(temp + def);
if (cnt < 1)
{
element.style.opacity = cnt;
}
}
element._cnt = cnt;
}
else
{
element.style.opacity = '';
element.style.visibility = 'hidden';
window.clearInterval(element.f_intvl);
var reqOptions = element._reqOptions;
if (reqOptions != null)
{
var obj = reqOptions["ONCLOSE"];
if (obj != null)
{
executeFunctionAsString(obj,window,reqOptions);
}
}
}
}
