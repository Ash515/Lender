MC.McDialogMixin = Ember.Mixin.create({
showURLInDialog: function(url, ajaxFeatures, dialogConfig) {
if (typeof dialogConfig === 'string') {
dialogConfig = JSON.parse(dialogConfig);
}
if(dialogConfig)
{
dialogConfig.url = url;
}
if (typeof ajaxFeatures === 'string') {
ajaxFeatures = JSON.parse(ajaxFeatures);
}
if(!ajaxFeatures){ ajaxFeatures = {};}
try {
var param = null;
if (url.indexOf('?') != -1) {
param = url.substring(url.indexOf('?') + 1, url.length);
url = url.substring(0, url.indexOf('?'));
}
if (typeof ajaxFeatures === "object") {
ajaxFeatures.url = url;
if (param && param.length > 0) {
ajaxFeatures.data = param;
}
if (!ajaxFeatures.onSuccessFunc) {
ajaxFeatures.onSuccessFunc = "_addToQueue";
}
ajaxFeatures.onSuccessFuncArg = dialogConfig;
this.sendRequest(ajaxFeatures);
}
} catch (e) {
get(this, 'flashes').danger(e.message);
}
},
showContentInDialog: function(model, dialogConfig) {
if (typeof dialogConfig === 'string') {
dialogConfig = JSON.parse(dialogConfig);
}
this._addToQueue(dialogConfig, model);
},
_addToQueue: function(dialogConfig, model) {
var dialogs = get(this, 'queue');
var dialog = this._newDialog(this, model, dialogConfig, dialogs.length, dialogConfig.refId);
dialogs.pushObject(dialog);
return dialog;
},
_newDialog: function(service, model, config, index, refId) {
if(!isNotNullString(refId))
{
refId = this.getViewName();
}
return MC.Dialog.create({
dialogModel: model,
dialogService: service,
dialogConfig: config,
index: index,
refId: refId
});
},
deleteAllChildDialogs : function(refId)
{
var childDialogs = this.getChildDialogs(refId);
for(var i=0, len=childDialogs.length; i<len; i++)
{
childDialogs[i].get("controller").send("close");
}
return;
},
getChildDialogs : function(refId)
{
var queue = get(this, "queue");
return queue ? queue.filterBy("refId",refId) : Em.A([]);
},
clearAllDialogs: function() {
var dialogs = get(this, 'queue');
while(dialogs.length > 0)
{
var controller = get(dialogs[0], "controller");
if(controller)
{
controller.send("close");	
}
else
{
dialogs.removeObject(dialogs[0]);
}
}
},
actions : 
{
clearAllChildDialogs : function(index)
{
this.deleteAllChildDialogs(index);
}
}
});
MC.Dialog = Ember.Object.extend({
queue: computed.alias('dialogService.queue'),
destroyDialog: function() {
this._destroyDialog();
},
_destroyDialog: function() {
var queue = get(this, "queue");
if (queue) {
queue.removeObject(this);
}
this.destroy();
}
});
(function(){
MC.McDialogComponent = Ember.Component.extend(MC.McDialogMixin, MC.AjaxApiMixin, {
clearAllChildDialogs: "clearAllChildDialogs",
init: function() {
this._super.apply(this, arguments);
this.setLayout();
},
setLayout : function()
{
var dialogModel = get(this, "dialog.dialogModel");
var layoutName = get(this, "dialog.dialogConfig.layoutName");
if (layoutName && layoutName.trim().length > 0) {
this.set("layoutName", layoutName);
} else if (dialogModel && dialogModel.templateName) {
this.set("layoutName", dialogModel.templateName);
} else if (dialogModel){
this.set("layout", Ember.Handlebars.compile(dialogModel));
}
},
updateDialogModel: function(url, ajaxFeatures, dialogConfig) {
var dialogProps = dialogConfig;
if(typeof dialogProps === "string")
{
dialogProps = JSON.parse(dialogProps);
}
if (typeof dialogConfig === "string") {
dialogConfig = JSON.parse(dialogConfig);
}
var dialogConfig = this.get("dialog.dialogConfig");
dialogConfig.position = this.$().dialog("option", "position");
dialogConfig.width = this.$().dialog("option", "width");
dialogConfig.height = this.$().dialog("option", "height");
var keysToUpdate = Object.keys(dialogProps);
for(i=0;i<keysToUpdate.length;i++)
{
dialogConfig[keysToUpdate[i]] = dialogProps[keysToUpdate[i]];
}
get(this, "dialog.dialogService").showURLInDialog(url, ajaxFeatures, dialogConfig);
this.send("close");
},
invokeAllScripts: function(responseText) {
var scriptsToInvoke = extractScripts(responseText);
jQuery(scriptsToInvoke).each(function(key1, element1) {
jQuery(element1).each(function(key2, element2) {
var scriptEle = document.createElement('script');
scriptEle.text = element2.innerHTML;
document.body.appendChild(scriptEle);
});
});
},
updateDialogContent : function(data)
{
var dialogConfig = this.get("dialog.dialogConfig");
dialogConfig.position = this.$().dialog("option", "position");
dialogConfig.width = this.$().dialog("option", "width");
dialogConfig.height = this.$().dialog("option", "height");
get(this, "dialog.dialogService").showContentInDialog(data, dialogConfig);
this.send("close");
},
didInsertElement: function() {
var dialogObj = get(this, "dialog");
if (dialogObj) {
set(this, "dialog.controller", this);
var self = this;
var obj = this.$().dialog({
autoOpen: false,
resize: function(event, ui) {
jQuery(window).resize();
},
close: function() {
self._destroyDialog();
jQuery(this).remove();
}
});
obj.dialog("option", dialogObj.get("dialogConfig"));
obj.dialog("open");
set(this, "dialog.widget", this.$().dialog("widget"));
run.next(this, "invokeAllScripts", dialogObj.get("dialogModel"));
}
},
_destroyDialog: function() {
var dialog = get(this, 'dialog');
if(!dialog){
return; 
}
var index = dialog.index;
this.sendAction("clearAllChildDialogs", index);
dialog.destroyDialog();
},
removeDialog: function() {
var dialogWidget = get(this, 'dialog.widget');
jQuery(dialogWidget).remove();
},
actions: 
{
close: function() {
if (this.get('_state') == 'inDOM') {
this.$().dialog("close");
}
this.removeDialog();
this._destroyDialog();
},
createChildDialog: function(url, ajaxConfig, dialogConfig) {
var config = dialogConfig;
if (typeof dialogConfig === "string") {
config = JSON.parse(dialogConfig);
}
config.refId = get(this, "dialog.index");
get(this, "dialog.dialogService").showURLInDialog(url, ajaxConfig, config);
},
updateModel: function(url, ajaxFeatures, dialogConfig) {
this.updateDialogModel(url, ajaxFeatures, dialogConfig);
}
}
});
Ember.Handlebars.helper('mc-dialog', MC.McDialogComponent);})();
