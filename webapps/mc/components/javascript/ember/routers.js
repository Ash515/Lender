App.Router.map(function() {
this.resource('index', { path: "/" }, function() {
this.resource('tabLayout', { path: ":tabLayout_id" }, function() {
this.resource('bodyContent', { path: "/:bodyContent_id/:templateName" }, function() {
this.route('dropDownTab', { path: ":dropDownTab_id" });
});
this.route('menuAction');
this.route('menuAction2');
this.route('menuAction3');
});
});
});
App.IndexRoute = Ember.Route.extend({
selectedView: null,
model: function() {
var self = this;
return jQuery.getJSON("ExampleTabs.ec").done(function(data) {
if (data) {
self.set("selectedView", data.selectedView);
}
return data;
});
},
redirect: function() {
var selectedView = store.hasProperty("currentTabLayout") ? store.get("currentTabLayout") : this.get("selectedView");
this.transitionTo('/' + selectedView);
}
});
App.IndexIndexRoute = Ember.Route.extend({
model: function() {
window.history.back();
}
});
App.TabLayoutIndexRoute = Ember.Route.extend({
model: function() {
if(window.location.hash == "#/" + store.get("currentTabLayout"))
{
window.history.back();		
}
else
{
this.transitionTo('/' + store.get("currentTabLayout") + "/" + store.get("currentView") + "/" + store.get("currentViewTemplate"));	
}
}
});
App.TabLayoutRoute = Ember.Route.extend(MC.AjaxApiMixin, MC.McDialogMixin, {
queue : function()
{
return Em.A([]);
}.on("init").property(),
willDestroy : function()
{
this._super.apply(this, arguments);
this.clearAllDialogs();
},
model: function(params) {
var self = this;	
var viewName = params.tabLayout_id;
if (store.hasProperty("currentTabLayout") && !Ember.isEqual(store.get("currentTabLayout"), viewName)) {
if (store.hasProperty("currentView")) {
store.remove("currentView");
store.remove("currentViewTemplate");
}
}
store.set("currentTabLayout", viewName);
return jQuery.getJSON("verticalTabJson?viewName=" + viewName).done(function(data) {
return data;
}).error(function(XMLHttpRequest, textStatus, errorThrown) {
if (self.get("errorStatus") === "parsererror") {
window.location.reload();
}
});
},
redirect: function(data) {
var selectedView = null;
if (store.hasProperty("currentView")) {
selectedView = store.get("currentView");
}else{
selectedView = data.selectedView;
}
var selectedViewTemplate = "htmlView";
if(data.childGridArray)
{
var childGridArray = data.childGridArray;
for(i=0;i<childGridArray.length;i++)
{
if(childGridArray[i].childGrid)
{
var tabs = childGridArray[i].childGrid.tabs;
var selectedTab = tabs.filterBy("name", selectedView);
if(selectedTab.length > 0)
{
selectedViewTemplate = selectedTab[0].templateName;
}
}
}
}
this.transitionTo('/' + data.currentView + "/" + selectedView + "/" + selectedViewTemplate);
},
actions: {
error: function(error, transition) 
{
}
}
});
App.BodyContentRoute = Ember.Route.extend({
viewTemplate : null,
renderTemplate: function() {
this.render(this.get("viewTemplate"), { model: this.currentModel });
},
model: function(params) {
var viewName = params.bodyContent_id;
this.set("viewTemplate",params.templateName);
var self = this;
store.set("currentView", viewName);
store.set("currentViewTemplate",params.templateName);
return viewName;
}
});
App.TabLayoutMenuActionRoute = Ember.Route.extend({
actionUrl : null,
model: function() {
var url = null;
var params = this.get('actionUrl');
if (params.viewToOpen) {
url = getUrlForDrillDownAction(params.viewToOpen, params.id, params.linkParams, null, params.index, null);
} else {
url=invokeClientMenuAction(params);
}
var self = this;
return jQuery.getJSON(url).done(function(data) {
return data;
});
},
actions: {
queryParamsDidChange: function(changedQueryParams) {
this.set("actionUrl",changedQueryParams.id);
this.refresh();
}
}
});
App.TabLayoutMenuAction2Route = Ember.Route.extend({
actionUrl : null,
renderTemplate: function() {
this.render("tabLayout/menuAction2", { model: this.currentModel });
},
setupController: function(controller, model) {
var scpt = model.substring(model.indexOf("<script>") + ("<script>".length), model.indexOf(";</script>"));
controller.set('scriptToExecute', scpt);
controller.set('model', model);
},
model: function() {
var menuInvoker=this.get("actionUrl");
var url = invokeClientMenuAction(menuInvoker);
return jQuery.ajax(url).complete(function(data) {
return data.responseText;
});
},
actions: {
queryParamsDidChange: function(changedQueryParams) {
this.set("actionUrl",changedQueryParams.id);
this.refresh();
}
}
});
App.TabLayoutMenuAction3Route = Ember.Route.extend({
actionUrl : null,
model: function() {
var url = new Function(appendReturnIfNeeded(this.get("actionUrl")))();
return jQuery.getJSON(url).done(function(data) {
return data.responseText;
});
},
actions: {
queryParamsDidChange: function(changedQueryParams) {
this.set("actionUrl",changedQueryParams.id);
this.refresh();
}
}
});
