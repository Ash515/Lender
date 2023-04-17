var _FRM_CURRENT_ERROR_FIELD = null;
var _FRM_SET_FAILED_FOCUS = true;
function executeFunction(functionName, formObj) 
{
if(functionName == null || formObj == null) {
return;
}
var formObjName = formObj.name + "Obj";
var result = true;
if(window[formObjName] && (window[formObjName][functionName]))
{
result = window[formObjName][functionName](formObj);
}
else
{
result = validateForm(formObj);
}
if(result)
{
return handleStateForForm(formObj);
}
else
{
return false;
}
}
function createFormMethodContainer(formName){
var methodContainer = null;
if(window[formName + "Obj"] != null){
methodContainer = window[formName + "Obj"];
}
else {
methodContainer = new Object();
window[formName + "Obj"] = methodContainer;
}
if(methodContainer[ "ValidateForm"] == null){
methodContainer["ValidateForm"] = validateForm;
}
}
function validateAndSubmitForm(frm)
{
return executeFunction("validateForm",frm);   
}
function setFailedFocus(formObject){
if(formObject.getAttribute("setfailedfocus") != null && formObject.getAttribute("setfailedfocus") == "false"){
_FRM_SET_FAILED_FOCUS = false;
}	
}
function validateForm(formObject, skipElements)
{
return validateFormElements(formObject.elements,formObject,skipElements);
}
function canSkip(skipElements,name)
{
if ( skipElements == undefined || skipElements == null )
{
return false;
}
for(var ele = 0; ele <= skipElements.length; ele++)
{	
if(name == skipElements[ele])
{
return true;
}
}
return false;
}
function validateFormElements(formElements,parentEl,skipElements)
{
var size = formElements.length;
var isFailure = false;
var failedObj = null;
setFailedFocus(parentEl);
for(var count = 0; count < size; count++){
var element = formElements[count];
if ( canSkip(skipElements,element.name) )
{
continue;
}    
var elVisible  = isElVisible(element,parentEl);
var validateMethod = element.getAttribute("validatemethod");
var displaystyle = element.style.display;
if(validateMethod != null && validateMethod != "" && !element.disabled
&& displaystyle != 'none' && elVisible){
if(!executeElementCall(validateMethod,element)){
isFailure = true;
var alertType = parentEl.getAttribute("alerttype");
if(alertType == null || alertType.indexOf("Complete") < 0){
return false;
}
if(failedObj == null){
failedObj = element;
}
}
}
}
if(failedObj != null){
if(_FRM_SET_FAILED_FOCUS){
failedObj.focus();
}
failedObj = null;
}
if(isFailure){
return false;
}
return true;
}
function executeElementCall(methodName, formElement){
var formObj = formElement.form;
var isNullable = formElement.getAttribute("isnullable");
var elemVal = formElement.value;
if(isNullable == "true" && (elemVal == "" || elemVal == null)){
return true;
}
if((formObj != null) &&  window[formObj.name + "Obj"] != null && window[formObj.name + "Obj"][methodName] != null){
return window[formObj.name + "Obj"][methodName](formElement.value, formElement);
}
else
{
return validateElement(methodName,formElement);
}
}
function disableEditMode(value, formElement){
var formObj = formElement.form;
var formName = formObj.name;
if(formObj.getAttribute("viewname") != null){
formName = formObj.getAttribute("viewname");
}
document.getElementById(formName + "ReadMode").className = 'show';
document.getElementById(formName + "EditMode").className = 'hide';
}
function trimAll(str)
{
if(str == null)
{
return "";
}  
var objRegExp =/^(\s*)$/;
if (objRegExp.test(str))
{
str = str.replace(objRegExp,''); 
if (str.length == 0)
return str; 
} 
objRegExp = /^(\s*)([\W\w]*)(\b\s*$)/;
if(objRegExp.test(str))
{
str = str.replace(objRegExp, '$2');
}
return str;
}
function isEmailId(str)
{
str = trimAll(str);
var objRegExp = /^[a-zA-Z0-9]([\w-.+]*)@([\w-.]*)(.[a-zA-Z]{2,6}(.[a-zA-Z]{2}){0,2})$/i;
return objRegExp.test(str); 
}
function isEmailIdWithSingleQuote(str)
{
str = trimAll(str);
var objRegExp = /^([\w-]+(?:\'[\w-]+)*)([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/i;
return objRegExp.test(str); 
}
/**
* To validate for multiple email ids.
* 
* @param 	{String} str   The email ids to be validated.
* 
* @type boolean  
*/
function isMultipleEmailId(str)
{
var emailIds = str.split(',');
for(var i = 0; i < emailIds.length; i++)
{
if(!isEmailId(emailIds[i]))
{
return false;
}
}
return true;
}
/**
* To check if the given string is empty.
* 
* @param	{String} str	The string to be checked. 
*
* @type  boolean
*/
function isNotEmpty(str)
{
var temp = trimAll(str);
if (temp.length > 0 )
return true;
return false;
}
/**
* To check the ip Address.
*
* @param 	{String} str 	The String to be checked. 
*
* @type boolean
*/
function isIpAddress(str)
{
var ipAddress = str.split(".");
if(ipAddress.length != 4)
{
return false;
}
for(i=0;i<ipAddress.length;i++)
{
if(isPositiveInteger(ipAddress[i]))
{
var temp = parseInt(ipAddress[i],10);
if(temp > 255)
{
return false;
}
}
else
{
return false;
}
}
return true;
}
/**
* To check if number is integer. 
*
* @param  {String} str 	The string to be checked.
*
* @type boolean
*/
function isInteger(str)
{
var objRegExp = /(^-?\d\d*$)/;
return objRegExp.test(str);
}
/**
* To check if number is positive integer.
*
* @param   {String} str 	The String to be checked. 
*
* @type boolean
*/
function isPositiveInteger(str)
{
var temp  = parseInt(str,10);
if ( isNaN(temp) || temp.toString().length != str.length) {
return false;
}
var objRegExp = /(^\d\d*$)/;
return objRegExp.test(temp);
}
/**
*  To check if given string is in date format.
*
*  @param {String} str  The String to be checked.
*
*  @type boolean
*/
function isDate(str)
{
var objRegExp = /^\d{1,2}(\-|\/|\.)\d{1,2}\1\d{4}$/
return objRegExp.test(str); 
}
/**
* To check if given string contains only characters.
*
* @param  {String} str The String to be checked.
*
* @type boolean
*/
function isCharacter(str)
{
var objRegExp = /^\w$/;
return objRegExp.test(str);
}
/**
* To check if given str contains only true or false. 
*
* @param  {String} str  The String to be checked.
*
* @type  boolean 
*/ 
function isTrueFalse(str)
{
if((str!="true")&&(str!="false"))
{
return false;
}	
else
{
return true;
}
}
/**
* To check if given string is contained in the given array.
*
* @param 	{String} str	The String to be checked.
* @param   arr    The array in which the str resides.
*
* @type boolean
*
* @private
*/
function isInArray(str,arr)
{
var len =arr.length;
for(var i =0;i<len;i++)
{
if (str==arr[i])
{
return true;
}
}
return false;
}
/**
* This function checks the given string is in the array or not.
* 
* <ul><li><code>allowed values</code> :  The values which is given in the form by using the comma separators.</li></ul>
* 
* @type boolean
*/
function  isInAllowedValues(value,formElement)
{
var allowedvalues= formElement.getAttribute("allowedvalues");
var arr  = allowedvalues.split(','); 
return isInArray(value,arr);
}
/**
*  Checks whether the value is within a particular range. 
*  <br><b>Custom Attributes</b> 
*  <ul><li><code>maxvalue</code> :  The maximum allowed value</li>
<li><code>minvalue </code>: The minimum allowed value</li></ul>
*/
function isWithinRange(value,formElement)
{
if(!isInteger(value))
{
return false;
}
value = parseInt(value);
if(formElement.getAttribute("maxvalue") != null)
{
maxValue = parseInt(formElement.getAttribute("maxvalue"));
if(value > maxValue)
return false;
}
if(formElement.getAttribute("minvalue") != null)
{
minValue = parseInt(formElement.getAttribute("minvalue"));
if(value < minValue)
return false;
}
return true;
}
/**
* Validates the value entered in the formElement by executing method specified
* by the methodName argument. If validation fails, then if any errormsg is
* specified, then an alert is generated for the same else returned. While
* displaying the alert message, the ${COLUMNALIAS} is replaced by the
* displayname attribute of the formElement. 
*
*@private
*/
function validateElement(methodName,formElement)
{
setFailedFocus(formElement.form);
if(window[methodName] == null)
{
alert("Wrong configuration.The validation method : " + methodName + " is not loaded");
return false;
}
var message = null;
var isNullable = formElement.getAttribute("isnullable");
var elemVal = formElement.value;
if(isNullable == "true" && (elemVal == "" || elemVal == null)){
return true;
}
var result;
if(elemVal == null || elemVal == ""){
result = false;
}
else {
result = window[methodName](elemVal, formElement);
}
if(result == true)
{
var alertType = formElement.form.getAttribute("alerttype");
if(alertType != null && alertType.indexOf("Complete")>=0){
if(document.getElementById(formElement.name+"_DIV") != null){
document.getElementById(formElement.name+"_DIV").style.display = "none";
highlightErrorElement(formElement, false);
}
else if(document.getElementById(formElement.id+"_DIV") != null){
document.getElementById(formElement.id+"_DIV").style.display = "none";
highlightErrorElement(formElement, false);					
}
else {
hideCustomMessage();
}			
}
return true;
}
else if(result == false)
{
message = formElement.getAttribute("errormsg");
}
else 
{
message = result;
}
if(message != null) 
{
if(formElement.getAttribute("displayname") != null)
{
message = message.replace("${COLUMNALIAS}", formElement.getAttribute("displayname"));
}
var alertType = formElement.form.getAttribute("alerttype");
if(alertType != null && alertType == 'Custom')
{
showCustomMessage(message, formElement);
}
else if(alertType != null && alertType.indexOf("Complete")>=0){
if(document.getElementById(formElement.name+"_DIV") != null){
document.getElementById(formElement.name+"_DIV").innerHTML = message;
document.getElementById(formElement.name+"_DIV").style.display = "block";
document.getElementById(formElement.name+"_DIV").className = "errorMsg";
highlightErrorElement(formElement, true);
}
else if(document.getElementById(formElement.id+"_DIV") != null){
document.getElementById(formElement.id+"_DIV").innerHTML = message;
document.getElementById(formElement.id+"_DIV").style.display = "block";
document.getElementById(formElement.id+"_DIV").className = "errorMsg";
}
else
{
// Stop! Stop ! Stop. Dont think this as a debugging alert. This is also
// functionality alert. So do not remove                        
alert(message);                          
}
}
else 
{
alert(message);
}
}
if(_FRM_SET_FAILED_FOCUS){
formElement.focus();
}
return false;
}
function highlightErrorElement(formElement, highlight)
{
//code for highlighting the field when a validation error occurs
var myClassName = formElement.className;
var index = myClassName.indexOf("_error");
if(highlight == true)
{  
if(index < 0)
{
formElement.className = myClassName+"_error";
}
}    
else
{
if ( index != -1 )
{
var newClassName = myClassName.substring(0,index);
formElement.className = newClassName;
}			               	
}             
}
/**
* Returns the html code for a custom alert. An element by the name
* <b><i>CUSTOM_BUBBLE</i></b> will be searched. If present, then it will be
* used for displaying the bubble, else a default one will be created. The
* location of the message in the element should be specified as $MESSAGE[The
* value will be updated dynamically.]
* 
* @private
*/
function getCustomAlert(cssName){
if(cssName == null){
cssName = 'customAlert';
}	
var code = document.getElementById("CUSTOM_BUBBLE");
if(code == null){
code = "<Table class='"+cssName+"' cellspacing=0 cellpadding=0  border=0 ><tr><td class='caTopLeft'></td><td class='caTopCenter' colspan='2'></td><td class='caTopRight'></td></tr>";
code = code.concat("<tr><td class='caMiddleLeft'></td><td class='caMessage'>$MESSAGE</td><td class='caClose'><button class='caCloseButton' onClick='hideCustomMessage()'></td><td class='caMiddleRight'></td></tr>");
code = code.concat("<tr><td class='caBottomLeft'></td><td class='caBottomCenter' colspan='2'></td><td class='caBottomRight'></td></tr>");
code = code.concat("</table>");
}
else {
code = code.innerHTML;
}
return code;
}
/**
* This function is used to show the message like a custom box when error occurs. 
*
* @param     message
* @param     curId
* @param    cssName
* 
*/
function showCustomMessage(message, curId, cssName){
_FRM_CURRENT_ERROR_FIELD = curId;
var obj = document.getElementById("customAlertMessage");
var ifrmObj = document.getElementById("_CUSTOMALERTFRAME");
if (ifrmObj == null) {
var newObj = document.createElement("iframe");
if(browser_ie){
newObj.id="_CUSTOMALERTFRAME";
newObj.style.position="absolute";
newObj.style.cursor="default";
newObj.style.display = "none";
newObj.style.border = "0px solid";
newObj.frameBorder = "0";
newObj.scrolling = "no";
if(window["CONTEXT_PATH"] != null)
{
newObj.src= CONTEXT_PATH + "/framework/html/blank.html";
}
}
else if (browser_nn4 || browser_nn6){
newObj.setAttribute("id","_CUSTOMALERTFRAME");
newObj.setAttribute("frameBorder","0");
newObj.setAttribute("style","position: absolute; cursor: default; display:none;");
}
document.body.appendChild(newObj);
ifrmObj = newObj;
}
if(obj == null){
var newObj = document.createElement("DIV");
if(browser_ie){
newObj.id="customAlertMessage";
newObj.style.position="absolute";
newObj.style.cursor="default";
newObj.style.display = "none";
}
else if (browser_nn4 || browser_nn6){
newObj.setAttribute("id","customAlertMessage");
newObj.setAttribute("style","position: absolute; cursor: default; display:none;");
}
document.body.appendChild(newObj);
obj = newObj;
}
var code = getCustomAlert(cssName);
code = code.replace("$MESSAGE", message);
obj.innerHTML = code;
obj.style.left = findPosX(curId) + "px";
obj.style.top = findPosY(curId) + curId.offsetHeight + "px";
obj.style.width = curId.parentNode.offsetWidth + "px";
/** zIndex modified to 150 for voip, because zIndex for dialog is 100. when custom alert first created, dialog hides this alert message. so zindex of custom alert message changed greater than the dialog's zindex.
*/
obj.style.zIndex = 150;
ifrmObj.style.left = findPosX(curId);
ifrmObj.style.top = findPosY(curId) + curId.offsetHeight + 15;
ifrmObj.style.width = curId.parentNode.offsetWidth - 5 + "px";
ifrmObj.style.height = "0px";
ifrmObj.style.zIndex = obj.style.zIndex - 1;
ifrmObj.style.display = 'block';
obj.style.display = "block";
}
function hideCustomMessage(){
if(_FRM_CURRENT_ERROR_FIELD != null){
document.getElementById("_CUSTOMALERTFRAME").style.display = "none";
document.getElementById("customAlertMessage").style.display = "none";
if(_FRM_SET_FAILED_FOCUS && _FRM_CURRENT_ERROR_FIELD.focus){
_FRM_CURRENT_ERROR_FIELD.focus();
}
_FRM_CURRENT_ERROR_FIELD = null;
}
}
function isNumeric(str, formElement){
var objRegExp = /^[0-9]+$/;
if(objRegExp.test(str)){
return true;
}
return false;
}
function isAlphaNumeric(str, formElement){
var objRegExp = /^[a-zA-Z0-9]+$/;
if(objRegExp.test(str)){
return true;
}
return false;
}
function isAlphaNumericWithMinus(str,formElement)
{
var objRegExp = /^[a-zA-Z0-9\-]+$/;
if(objRegExp.test(str)){
return true;
}
return false;
}
function isAlphaNumericWithMinusAndSpace(str,formElement)
{
var objRegExp = /^[a-zA-Z0-9\-_\ ]+$/;
if(objRegExp.test(str)){
return true;
}
return false;
}
function isString(str, formElement){
var objRegExp = /^[a-zA-Z]+$/;
if(objRegExp.test(str)){
return true;
}
return false;
}
function isMinute(str, formElement){
str = trimAll(str);
if(str==""){
return false;
}
var regEx = /^[0-9]+$/;
if(regEx.test(str)){
if(str <= 59){
return true;
}
}
return false;
}
function isHour(str, formElement){
str = trimAll(str);
if(str==""){
return false;
}
var regEx = /^[0-9]+$/;
if(regEx.test(str)){
if(str <= 23){
return true;
}
}
return false;
}
function isSearchDataNumeric(str, formElement){
trimAll(str);
if(str != null && str != ''){
return isNumeric(str, formElement);
}
return true;
}
function compareValues(str, formElement){
var elemVal = trimAll(formElement.value);
var formObj = formElement.form;
var compareFieldName = formElement.getAttribute("checkwith");
var compareFieldValue = trimAll(formObj.elements[compareFieldName].value);
var checkType = trimAll(formElement.getAttribute("checktype").toUpperCase());
if (isNaN(elemVal) || elemVal.length == 0) elemVal = "'" + elemVal + "'";
if (isNaN(compareFieldValue) || compareFieldValue.length == 0) compareFieldValue = "'" + compareFieldValue + "'";
return executeFunctionAsString(elemVal + checkType + compareFieldValue,window);
}
function isDummyNotSelected(formElValue,formEl)
{
return (formElValue != formEl.getAttribute("dummyvalue"))
} 
function isAtleastOneChecked(formElValue,formEl)
{
var els = formEl.form[formEl.name];
for(var i =0; i < els.length;i++)
{
if(els[i].checked){return true;};
}
return false;
}
function updateFormWithData(frmName,frmData)
{
var formElements = DOMUtils.getChildElsWithAttr(DOMUtils.getForm(frmName),"name","*");
DOMUtils.fillData(formElements,frmData);
}
function isElVisible(node,rootNode)
{
while(node.style.display != 'none')
{
node = node.parentNode;
if(node == rootNode){break;}
}
return  (node.style.display != 'none');
}
function isValidInput(value,type){
switch (type) {
case "CHAR" : {
return true;
break;
}
case "INTEGER" : {
return !isNaN(value);
break;
}
case "BOOLEAN" : {
return value.toString() == "true" ;
break;
}
default : {
return true;
}
}
}
