(function(){
MC.ColChooserComponent = Ember.Component.extend(MC.AjaxApiMixin,{
layoutName : "components/col-chooser",
didInsertElement : function()
{
if ((this.get('_state') || this.get('state')) !== 'inDOM') {
return false;
}
var list = this.$("#"+this.get("dialog.refId") + "_id");
jQuery(list).sortable({ items: "li:not(.unsortable)" });
},
getId : function()
{
return this.get("dialog.refId") + "_id";
}.property(),
close : "close",
actions : 
{
submitColChooser : function()
{
var showList = this.get("dialog.dialogModel").filterBy("isVisible", true).getEach("name");
var colChooserDisabledColumns = this.get("dialog.dialogModel").filterBy("isChoosable", false).getEach("name");
var tableController = this.get("parentView.parentView.controller");
var orderedArray = this.$("#"+this.get("dialog.refId") + "_id").sortable("toArray");
var temp = [];
for(i=0, len=orderedArray.length; i<len; i++)
{
if(showList.contains(orderedArray[i]))
{
temp.push(orderedArray[i]);
}
}
tableController.send("columnChooser", temp);
this.sendAction("close");
},
close : function()
{
this.sendAction("close");	
}
}
});
Ember.Handlebars.helper('col-chooser', MC.ColChooserComponent);})();
