function includeMainScripts(contextPath)
{
var scriptsToInclude = "";
if(window["StateHandling.js"] != null)
{
return;
}
CONTEXT_PATH=contextPath;
scriptsToInclude += getScriptInc(contextPath + "/framework/javascript/StateHandling.js");
scriptsToInclude += getScriptInc(contextPath + "/framework/javascript/ViewUtils.js");
scriptsToInclude += getScriptInc(contextPath + "/framework/javascript/ResponseHandling.js");
scriptsToInclude += getScriptInc(contextPath + "/framework/javascript/DynamicContent.js");
scriptsToInclude += getScriptInc(contextPath + "/framework/javascript/MenuAPI.js");
scriptsToInclude += getScriptInc(contextPath + "/framework/javascript/ParamsParser.js");
scriptsToInclude += getScriptInc(contextPath + "/framework/javascript/prototype.js");
scriptsToInclude += getScriptInc(contextPath + "/framework/javascript/effects.js");  
scriptsToInclude += getScriptInc(contextPath + "/framework/javascript/AjaxAPI.js");
scriptsToInclude += getScriptInc(contextPath + "/framework/javascript/MCFrame.js");  
scriptsToInclude += getScriptInc(contextPath + "/framework/javascript/JSOverrides.js");
scriptsToInclude += getScriptInc(contextPath + "/framework/javascript/elementEx.js");
scriptsToInclude += getScriptInc(contextPath + "/framework/javascript/periodicalEx.js");
scriptsToInclude += getScriptInc(contextPath + "/framework/javascript/history.js");
scriptsToInclude += getScriptInc(contextPath + "/framework/javascript/app.js");	
scriptsToInclude += getScriptInc(contextPath + "/components/javascript/commonUtils.js");
scriptsToInclude += getScriptInc(contextPath + "/components/javascript/Utils.js");
scriptsToInclude += getScriptInc(contextPath + "/components/javascript/ComponentActions.js");
scriptsToInclude += getScriptInc(contextPath + "/components/javascript/DropDown.js");
scriptsToInclude += getScriptInc(contextPath + "/components/javascript/ShowHideBox.js");
scriptsToInclude += getScriptInc(contextPath + "/components/javascript/TableHandling.js");
scriptsToInclude += getScriptInc(contextPath + "/components/javascript/FormHandling.js");
scriptsToInclude += getScriptInc(contextPath + "/components/javascript/ListUtils.js");
scriptsToInclude += getScriptInc(contextPath + "/components/javascript/listColumnChooser.js");
scriptsToInclude += getScriptInc(contextPath + "/components/javascript/Dialog.js");
scriptsToInclude += getScriptInc(contextPath + "/components/javascript/MCEffects.js");
scriptsToInclude += getScriptInc(contextPath + "/components/javascript/TableModel.js");
scriptsToInclude += getScriptInc(contextPath + "/components/javascript/TabCust.js");
scriptsToInclude += getScriptInc(contextPath + "/components/javascript/TooltipHandling.js");  
scriptsToInclude += getScriptInc(contextPath + "/components/javascript/Localize.js"); 
document.writeln(scriptsToInclude);
window["StateHandling.js"] = true;  
}
function getScriptInc(scriptFilePath)
{
return "<script src='" + scriptFilePath + "' type='text/javascript'></script>";
}
var docAlreadyLoaded = false;
function includeJS(scriptFilePath)
{
var index = scriptFilePath.lastIndexOf('/');
var fileName = scriptFilePath;
if(index > -1)
{ 
fileName = scriptFilePath.substring(index + 1);
}
if(window[fileName] != null)
{
return;
}
if(!docAlreadyLoaded)
{ 
document.writeln(getScriptInc(scriptFilePath));
}
else
{
includeScriptInDoc(document,scriptFilePath);
}
window[fileName] = true;
}
function includeScriptInDoc(doc,scriptFilePath)
{
var e = doc.createElement("script");
e.src = scriptFilePath;
e.type="text/javascript";
doc.getElementsByTagName("head")[0].appendChild(e);  
}
