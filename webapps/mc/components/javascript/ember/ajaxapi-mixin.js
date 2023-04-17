MC.AjaxApiMixin = Ember.Mixin.create({
sendRequest: function(requestOptions, isCSRFIncludedAlready) {
if(!requestOptions || !requestOptions.url)
{
throw "Either requestOptions or url should not be null/undefined";
}
var self = this;
var type = requestOptions.type;
var csrfTokenObj = this.getCSRFToken();
var isSuccess = false;
if(!isCSRFIncludedAlready && type == "POST" && csrfTokenObj)
{
var dataPart = requestOptions.data;
if(!Ember.isNone(dataPart))
{
dataPart[csrfTokenObj.CSRFParamName] = csrfTokenObj.CSRFParamValue;
}
requestOptions.data = dataPart;
}
jQuery.ajax(requestOptions).done(function(data, textStatus, jqXHR) {
if(jqXHR.status == 206)
{
window.location.reload();
return;
}
isSuccess = true;
var callback = requestOptions.onSuccessFunc;
var callbackArg = requestOptions.onSuccessFuncArg;
if (isNotNullString(callback)) {
if(typeof self.get(callback) === "function")
{
Ember.run(function(){
callbackArg ? Ember.run.once(self, callback, callbackArg, data, textStatus, jqXHR) : Ember.run.once(self, callback, data, textStatus, jqXHR);
});
}
else
{
callbackArg ? self.send(callback, callbackArg, data, textStatus, jqXHR) : self.send(callback, data, textStatus, jqXHR);
}
}
}).fail(function(jqXHR, textStatus, errorThrown) {
if(jqXHR.status == 206)
{
window.location.reload();
return;
}
var callback = requestOptions.onFailureFunc;
if (isNotNullString(callback)) 
{
if(typeof self.get(callback) === "function")
{
Ember.run(function(){
Ember.run.once(self, callback, jqXHR, textStatus, errorThrown);
});
}
else
{
self.send(callback, jqXHR, textStatus);
}
}
}).always(function(arg1, textStatus, arg2) {
var target = requestOptions.target;
var statusFunc = requestOptions.statusMsgFunc;
if (isNotNullString(statusFunc)) 
{
if(statusFunc === "default")
{
if(isSuccess)
{
self.get('flashes').success(arg1.htmlSafe(), 3000);
}
else
{
get(self, 'flashes').danger((arg2 + " : "+arg1.responseText).htmlSafe(), 3000);
}
}
else
{
var index = statusFunc.indexOf('(');
var modifiedInput = statusFunc;
if(index > -1)
{
modifiedInput = statusFunc.substring(0, index);
}
if (new Function(appendReturnIfNeeded("typeof "+modifiedInput))() === "function")
{
new Function(appendReturnIfNeeded(statusFunc))();
}
else if(typeof self.get(statusFunc) === "function")
{
Ember.run(function(){
Ember.run.once(self, statusFunc, arg1, arg2, isSuccess);
});
}
else
{
self.send(statusFunc, arg1, arg2, isSuccess);
}
}
}
if (isNotNullString(target) && isSuccess) 
{
if (!(self.get('isDestroyed') || self.get('isDestroying'))) {
self.beginPropertyChanges();
self.set(target, arg1);
self.endPropertyChanges();
}
}
return true;
});
},
getCSRFToken : function()
{
var CSRFParamName =  store.get("CSRFParamName");
var CSRFName =  store.get("CSRFName");
if(isNotNullString(CSRFParamName) && isNotNullString(CSRFName))
{
return {CSRFParamName : CSRFParamName, CSRFParamValue :  store.get(CSRFName)};
}
return null;
},
actions: 
{
refreshView: function() {
this.send("updateView", "ajaxCallBack");
},
submitForm: function(formId) 
{
var requestOptions = {};
var self = this;
var formEle = jQuery("#" + formId);
var reqURL = formEle.attr("action");
if (!reqURL){ return;} 
var validateFunc = formEle.attr("validatefunc");
var isFormValidationPassed = true;
if(isNotNullString(validateFunc))
{
var index = validateFunc.indexOf('(');
var modifiedInput = validateFunc;
if(index > -1)
{
modifiedInput = validateFunc.substring(0, index);
}
if(typeof self.get(modifiedInput) === "function")
{
Ember.run(function(){
Ember.run.once(self, modifiedInput, formEle.attr("validatefuncarg"));
});
isFormValidationPassed = self.get("isFormValid");
}
else if (new Function(appendReturnIfNeeded("typeof "+modifiedInput))() === "function") 
{
isFormValidationPassed = new Function(appendReturnIfNeeded(validateFunc))();
}	
}
if(!isFormValidationPassed)
{
return false;
}
var params = isNotNullString(formEle.attr("additionalparams")) ? formEle.attr("additionalparams") : null;
requestOptions.url = reqURL;
requestOptions.type = isNotNullString(formEle.attr("type")) ? formEle.attr("type") : "POST";
var formData = null;
var csrfTokenObj = this.getCSRFToken();
if (formEle.attr("enctype") == "multipart/form-data") 
{
if (window.FormData !== undefined) 
{
formData = new FormData();
var files = jQuery(formEle).find('input[type="file"]');
for (var i = 0; i < files.length; i++) {
if(files[i].files.length > 0) 
{
formData.append(jQuery(files[i]).attr("name"), files[i].files[0]);	
}
}
var other_data = jQuery(formEle).serializeArray();
jQuery.each(other_data, function(index, input) {
formData.append(input.name, input.value);
});
var paramsArray = [];
if(params)
{
paramsArray = parseParams(params);
}
if(csrfTokenObj)
{
paramsArray[csrfTokenObj.CSRFParamName] = csrfTokenObj.CSRFParamValue;
}
jQuery.each(paramsArray, function(key, value) {
if(Array.isArray(value))
{
for(i=0, len=value.length; i<len; i++){
formData.append(key, value[i]);
}
}
else
{
formData.append(key, value);
}
});
requestOptions.contentType = false;
requestOptions.processData = false; 
}
else 
{
get(this, 'flashes').danger("Error : FormData isn't supported in this browser. Kindly check it and choose some advanced browser !", 3000);
return false;
}
}
else 
{
formData = formEle.serialize();
if(params)
{
formData += "&" + params;
}
if(csrfTokenObj)
{
formData += "&" + csrfTokenObj.CSRFParamName + "=" + csrfTokenObj.CSRFParamValue;
}
}
requestOptions.onSuccessFunc = formEle.attr("onsuccessfunc");
requestOptions.onSuccessFuncArg = formEle.attr("onsuccessfuncarg");
requestOptions.onFailureFunc = formEle.attr("onfailurefunc");
requestOptions.statusMsgFunc = formEle.attr("statusMsgFunc");
requestOptions.data = formData;
requestOptions.target = formEle.attr("target");
this.sendRequest(requestOptions, true);
}
}
});
