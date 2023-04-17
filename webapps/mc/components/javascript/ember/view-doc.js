(function(){
MC.ViewDocComponent = Ember.Component.extend(MC.AjaxApiMixin, MC.McDialogMixin, {
classNames : ["container","viewDoc"],
isTemplatePresent : false,
layoutName : "components/view-doc",
codeSnippet : null,
queue : Ember.computed(function(){
return Em.A([]);
}),
init : function()
{
this._super.apply(this,arguments);
this.setTemplate();
},
willDestroy : function()
{
this.clearAllDialogs();
},
setTemplate : function()
{
this.clearAllDialogs();
if(this.container.resolve("template:"+this.get("tempName")))
{
this.set("isTemplatePresent",true);
}
else
{
this.set("isTemplatePresent",false);
}
var self=this;
Ember.run.next(function(){
if ((self.get('_state') || self.get('state')) !== 'inDOM') {
return;
}
self.rerender();
});
}.observes("tempName"),
getViewName : function()
{
var viewName = this.get("viewName");
if(!viewName)
{
viewName = this.get("tempName");
}
return viewName;
},
_getDialogRefId : function()
{
return this.getViewName()+"_viewDoc"+this.get("queue").length;
},
showXml : function(colName,colValue)
{
this.showURLInDialog("ViewXML.cc?" + colName + "=" + colValue, {},  {width:600, "refId" : this._getDialogRefId(), show:{effect:"explode",duration: 500}, hide:{effect:"explode",duration: 500}});
},
showPersXml : function(persName,pkColName,pkColValue)
{
this.showURLInDialog("ViewXML.cc?PERSONALITY=" + persName + "&PKCOLNAME=" + pkColName + "&PKCOLVALUE=" + pkColValue , {}, {width:600, "refId" : this._getDialogRefId(),show:{effect:"clip",duration: 500}, hide:{effect:"clip",duration: 500}});
}, 
actions :
{
showColumnConfig : function(configName,columnAlias)
{
this.showURLInDialog("ViewXML.cc?CONFIGNAME=" + configName  + "&COLUMNALIAS=" + columnAlias, {}, {width:600, "refId" : this._getDialogRefId(),show:{effect:"clip",duration: 500}, hide:{effect:"clip",duration: 500}});
},
showViewXml: function(viewName) {
this.showXml("VIEWNAME", viewName);
},
showViewJSP : function(viewName)
{	
this.showURLInDialog("ViewJSP.cc?VIEWNAME=" + viewName,{},{});
},
showMenuItem: function(menuItemId) {
this.showXml("MENUITEMID", menuItemId);
},
showMenu: function(menuId) {
this.send("showPersXml", "Menu", "MENUID", menuId);
},
showPersXml : function(persName,pkColName,pkColValue)
{
this.showURLInDialog("ViewXML.cc?PERSONALITY=" + persName + "&PKCOLNAME=" + pkColName + "&PKCOLVALUE=" + pkColValue , {}, {width:600, "refId" : this._getDialogRefId(),show:{effect:"clip",duration: 500}, hide:{effect:"clip",duration: 500}});
},
showCodeSnippet : function(viewName, columnAlias, tableName, hiliteArray)
{
var reqParams = "&VIEWNAME=" + viewName;
if(columnAlias != null){
reqParams = reqParams + "&COLUMNALIAS=" + columnAlias;
}	
if(tableName != null){
reqParams = reqParams + "&TABLENAME=" + tableName;
}
hiliteArray = hiliteArray.split(",");
if(hiliteArray != null){
for(var i=0; i<hiliteArray.length; i++){
reqParams = reqParams + "&HILITE=" + hiliteArray[i];
}
}
var url = "examples/codeSnatcher.jsp?"+reqParams;
this.showURLInDialog(url, {}, {dialogClass: "no-close", "refId" : this._getDialogRefId(), show:{effect:"puff",duration: 500}, hide:{effect:"puff",duration: 500}, width:900, minHeight: 125});
}
}
});
Ember.Handlebars.helper('view-doc', MC.ViewDocComponent);})();
