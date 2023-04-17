(function(){
MC.MenuViewComponent = Ember.Component.extend(MC.AjaxApiMixin, {
addDCView : "toggleAddDCView",
delDCView : "toggleDelDCView",
actions: {
invokeMenuAction: function(arg) {
this.sendAction("invokeMenuAction", arg);
},
addDCView: function(arg) {
this.sendAction("addDCView", arg);
},
delDCView: function(arg) {
this.sendAction("delDCView", arg);
}
}
});
Ember.Handlebars.helper('menu-view', MC.MenuViewComponent);})();
