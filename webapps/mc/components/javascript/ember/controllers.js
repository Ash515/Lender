App.TabLayoutController = Ember.ObjectController.extend({
actions: 
{
success: function() {
get(this, 'flashes').success('success msg');
},
warning: function() {
get(this, 'flashes').warning('warning msg');
},
info: function() {
get(this, 'flashes').info('info msg');
},
danger: function() {
get(this, 'flashes').danger('danger msg');
},
clearMessages: function() {
get(this, 'flashes').clearMessages();
}
}
});
App.ApplicationController = Ember.ObjectController.extend({
actions : 
{
linkClick : function(){}
},
currentPathChange: function() {
switch(this.get('currentPath')){
case 'index.tabLayout.index':
this.transitionToRoute('bodyContent',store.get("currentView"));
break;
}
}.observes('currentPath')
});
App.MultipleTableTemplateController = Ember.Controller.extend({
viewModel: {},
init: function() {
this._super();
this.setModel();
},
setModel: function() {
var viewName = store.get("currentView");
var self = this;
jQuery.ajax(viewName + ".ec").complete(function(data) {
var val = JSON.parse(data.responseText);
self.set("viewModel", val);
});
}.observes("model")
});
App.TabLayoutMenuAction2Controller = Ember.ObjectController.extend({
scriptToExecute: "",
actions: {
editAlarm: function(action, formName) {
var url = action+"?"+jQuery("form[name='"+formName+"']").serialize();
var self = this;
jQuery.ajax(url).done(function(data, textStatus, jqXHR){
get(self, "flashes").success(data, 1500);
history.back();
}).fail(function(jqXHR, textStatus, errorThrown){
get(self, 'flashes').danger(textStatus.htmlSafe(), 1500);
});
}
}
});
