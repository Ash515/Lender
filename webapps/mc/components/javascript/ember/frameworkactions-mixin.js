App.FrameworkActionsMixin = Ember.Mixin.create({
actions : 
{
dummy1 : function()
{
this.showURLInDialog("MenuInTemplateTableParent.ec", "{}", "{\"width\":1200, \"refId\":\""+this.getViewName()+"\"}");
},
dummy2 : function()
{
this.showURLInDialog("simplejsppage.ec", "{}", "{\"width\":300, \"refId\":\""+this.getViewName()+"\"}");
},
warning: function() {
get(this, 'flashes').warning('warning msgf from table components --- Its working');
},
drillDownView: function(menuParam) {
var url=invokeClientMenuAction(menuParam);
this.sendRequest({ url: url, target: "drillDownViewModel"});
},
actionTrigger: function(menuParam) {	
var url=invokeClientMenuAction(menuParam);
this.sendRequest({ url: url, onSuccessFunc: "updateView", onSuccessFuncArg: "menuAction", statusMsgFunc : "default"});
}
}
});
