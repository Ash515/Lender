App.LandingServerComponent = Ember.Component.extend(MC.AjaxApiMixin,{
init : function()
{
this._super.apply(this,arguments);
this.setModel();
},
setModel : function()
{
this.sendRequest({ url: "MenuInTable.ec", target: "landingServerModel"} );
}
});
