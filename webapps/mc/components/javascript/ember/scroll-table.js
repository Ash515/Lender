(function(){
MC.ScrollTableComponent = MC.TableViewComponent.extend({
scrollTriggered: false,
tempModel: Ember.computed(function(){
return Em.A([]);
}),
resetTableProps : function()
{
this._super.apply(this, arguments);
this.set("tempModel", Em.A([]));
this.set("scrollTriggered", false);
},
init : function()
{
var uniqueId = this.getViewName();
if(!uniqueId)
{
uniqueId = this.get("viewName");
if(!uniqueId)
{
uniqueId = this.get("viewModel.name");
}
}
this.set('stateData',StateData.getInstance(uniqueId));
this.get('stateData').remove("navigReq");
var viewParams = this.get("viewParams");
viewParams = (isNotNullString(viewParams) ? (viewParams+"&") : "") + "ajaxTableUpdate=true";
this.beginPropertyChanges();
this.set("viewParams", viewParams);
this._super.apply(this, arguments);
this.endPropertyChanges();
},
modelObserver: function() {
var viewModel = this.get("viewModel");
var reqParams = null;
if (viewModel) {
reqParams = viewModel.reqParams;
setTableDOMModel(viewModel.TableModel);
if (reqParams && reqParams.length > 0) {
this.get('stateData').set("reqParams", reqParams);
}
var columnNames = this.get("columnNames");
if (columnNames && columnNames.length > 0) {
var tableData = [];
var data = viewModel.data;
if (data && data.length > 0) 
{
this.setRowDisableProp(data);
var selectedRowIndices = data.filterBy("isSelected", true).getEach("rowIdx");
this.get('stateData').remove("selectedRowIndices");
this.set("selectedRowIndices", selectedRowIndices);
if(selectedRowIndices.length > 0)
{
this.get('stateData').set("selectedRowIndices", selectedRowIndices);
}
tableData = this.getRows(data, viewModel.headers);
}
if (this.get("scrollTriggered")) {
var append_model = this.get("tempModel");
append_model.pushObjects(tableData);
this.set("scrollTriggered", false);
this.set("tempModel", Ember.copy(append_model, true));
this.set("model", append_model);
this.updateHeaderCheckbox(tableData);
return;
}
this.set("tempModel", Ember.copy(tableData, true));
this.set("model", tableData);
this.updateHeaderCheckbox(tableData);
}
}
}.observes("viewModel", "viewModel.data"),
getNavigConfig: function() {
var navigConfig = this.get("navigConfig");
var limit = (Ember.isEqual(0, this.get("limit"))) ? (navigConfig ? navigConfig.itemsPerPage : 0) : this.get("limit");
var page = this.get("page");
var fromIndex = (((page - 1) * limit) + 1);
return {"_PN":page, "_FI":fromIndex, "_TI":limit, "_PL":limit};
},
actions : 
{
refreshView : function()
{
if(!Ember.isNone(this.get("viewModel.navigation"))) {
this.set("page", 1);
this.setStateForNavig();
}
this.send("updateView", "navigation");
},
scroll: function() {
if (this.get("viewModel.isScrollTable")) {
this.set("scrollTriggered", true);
if(this.get("viewModel.navigation.to") != this.get("viewModel.navigation.total"))
{
this.send("nextPage");	
}
}
},
columnReorder: function(columns) {
var colChooserReq = {};
var showList = Ember.A();
for (i = 0; i < columns.length; i++) {
showList.push(columns[i].get('columnName'));
}
this.get('stateData').set("colChooserReq", showList);
if(!Ember.isNone(this.get("viewModel.navigation"))) {
this.set("page", 1);
this.setStateForNavig();
}
this.send("updateView", "all");
}
}
});
Ember.Handlebars.helper('scroll-table', MC.ScrollTableComponent);})();
