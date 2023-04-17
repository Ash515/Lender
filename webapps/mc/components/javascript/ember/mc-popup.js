(function(){
MC.McPopupComponent = Ember.Component.extend(MC.AjaxApiMixin, MC.McDialogMixin, {
tagName : "ul",
classNames : ["menu"],
attributeBindings : "style",
style : "position:absolute; z-index:100",
layoutName : "components/mc-popup",
init: function() {
this._super.apply(this, arguments);
this.setLayout();
},
setLayout : function()
{
var popup = get(this, "popup");
var layoutName = popup.layoutName;
if (layoutName && layoutName.trim().length > 0) {
this.set("layoutName", layoutName);
}
},
didInsertElement: function() {
if ((this.get('_state') || this.get('state')) !== 'inDOM') {
return;
}
this.set("popup.popupComponent", this);
var popup = this.get("popup");
var self = this;
var position = popup.position
if(!position)
{
position = { my : "left top", at : "left+40 bottom", of : $(popup.target), collision: "none" };
}
this.$().position(position);
var option = popup.option;
if(!option || !option.select)
{
option = {};
option.select = function ( event, ui ) {
self.destroyPopup(event , ui);
}
}
var menu = this.$().menu();
menu.menu("option", option);
},
destroyPopup : function(event, ui)
{
var popup = get(this, "popup");
this.get("popup.controller.popupQueue").removeObject(popup);
if(this.$())
{
this.$().menu("destroy");	
}
jQuery(this.$()).remove();
this.destroy();
}
});
Ember.Handlebars.helper('mc-popup', MC.McPopupComponent);})();
