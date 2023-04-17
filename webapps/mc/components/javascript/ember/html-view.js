(function(){
MC.HtmlViewComponent = Ember.Component.extend(MC.AjaxApiMixin, MC.McDialogMixin, {
viewModel: null,
attributeBindings: ['style', 'id'],
queue : function()
{
return Em.A([]);
}.on("init").property(),
willDestroy : function()
{
this._super.apply(this, arguments);
this.clearAllDialogs();
},
clearAllDialogs: function() {
var dialogs = get(this, 'queue');
while(dialogs.length > 0)
{
get(dialogs[0], "controller").send("close");
}
},
init: function() {
this._super.apply(this, arguments);
if (this.get("viewName")) {
this.getResponse();
}
if (this.get("viewModel")) {
this.setLayout();
}
},
getResponse: function() {
var viewName = this.get("viewName");
var viewParams = this.get("viewParams");
var url = viewName + ".ec";
this.sendRequest({
url: url,
data : viewParams,
crossDomain: true,
target: "viewModel",
onFailureFunc : "fail"
});
}.observes("viewName", "viewParams"),
invokeAllScripts : function(responseText)
{
var scriptsToInvoke = extractScripts(responseText);
jQuery(scriptsToInvoke).each(function(key1, element1) {
jQuery(element1).each(function(key2, element2) {
var scriptEle = document.createElement('script');
scriptEle.text = element2.innerHTML;
document.body.appendChild(scriptEle);
});
});
},
setLayout: function() {
var responseText = this.get("viewModel");
if (responseText) {
this.set("layout", Ember.Handlebars.compile(responseText));
this.rerender();
}
}.observes("viewModel"),
didInsertElement: function() {
var responseText = this.get("viewModel");
if (responseText) {
this.invokeAllScripts(responseText);
}
},
getViewName : function()
{
return this.get("viewName");
},
actions: {
updateView: function(arg) {
this.sendAction("updateView", arg);
}
}
});
Ember.Handlebars.helper('html-view', MC.HtmlViewComponent);})();
