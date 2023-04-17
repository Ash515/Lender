(function(){
MC.TableViewComponent = Ember.Component.extend(MC.AjaxApiMixin, MC.McDialogMixin, MC.TableComponentActionsMixin, App.FrameworkActionsMixin, {
model: Ember.computed(function(){
return Em.A([]);
}),
drillDownViewModel: null,
isSearchTriggered: false,
viewModel: null,
page: 1,
limit: 0,
total: 0,
tableColumns: Ember.computed(function(){
return Em.A([]);
}),
selectedRowIndices: Ember.computed(function(){
return Em.A([]);
}),
prevLastColumn: null,
isTransCommitted : false,
queue : Ember.computed(function(){
return Em.A([]);
}),
popupQueue : Ember.computed(function(){
return Em.A([]);
}),
tableHeight:  15,
getDocViewName: function() {
var viewName = this.getViewName();
if (viewName) {
return "docs/" + viewName;
}
return "emptyDOC";
}.property("viewModel.name"),
init: function() {
this._super.apply(this, arguments);
this.changeView();
},
didInsertElement : function()
{
this.updateHeaderCheckbox(this.get("viewModel.data"));
},
willDestroy: function() {
this._super.apply(this, arguments);
var viewName = this.getViewName();
if(viewName){ this.get('stateData').removeAllStates();}
this.resetTableProps();
},
resetTableProps : function()
{
this.set("isTransCommitted", false);
this.set("showTotal", false);
this.set("tableColumns", Em.A([]));
this.clearAllDialogs();
this.clearAllPopups();
this.set("limit", 0);
this.set("page",1);
this.set("navigConfig", null);
this.set("drillDownViewModel", null);
},
initTableProps : function(model)
{
try
{
this.columnNamesObserver(model.headers);
this.setColumnVsIndex(model.headers);
this.set("isFilterTable", model.filterConfig!=null);
this.set("isColumnChooserEnabled", model.colList!=null);
this.set("isSearchEnabled", model.headers.isAny("isSearchEnabled", true));
if(!this.get("menuTemplate"))
{
this.set("menuTemplate", "components/mc-menu");
}
if(!this.get("filterTemplate"))
{
this.set("filterTemplate", "components/mc-filter");
}
var self = this;
Ember.run.later(function() {
self.modelUpdated(model);
});
}
catch(e){}
},
keyUp : function(event)
{
if(this.get("isSearchTriggered") && event.keyCode === 27 && confirm("Do u wanna discard this search ?"))
{
this.send("search");
}
},
getViewState : function(viewName)
{
viewName = isNotNullString(viewName) ? viewName : this.getViewName();
return this.get('stateData').getAllStates();
},
changeView: function() {
this.resetTableProps();
var tableModel = this.get("tableModel");
var viewName = this.get("viewName");
var queryParams = this.get("viewParams");
queryParams = queryParams ? "?" + queryParams : "";
if (viewName && typeof viewName === "string") 
{
this.addRuler(this.get('viewName'));
if (!this.get("layoutName")) {
this.set("layoutName", "components/default-table");
}
this.set('stateData',StateData.getInstance(viewName));
var state = this.get('stateData').getAllStates();
var url = viewName + ".ec" + queryParams;
this.sendRequest({ url: url, type:"POST", data: state, target: "viewModel", onSuccessFunc: "initTableProps"});
} 
else if (tableModel && typeof tableModel != "string") 
{
this.set('stateData',StateData.getInstance(tableModel.name));
this.addRuler(tableModel.name);
if (!this.get("layoutName")) {
this.set("layoutName", "components/default-table");
}
this.beginPropertyChanges();
this.set("viewModel", tableModel);
this.columnNamesObserver(tableModel.headers);
this.columnsObserver();
this.modelObserver();
this.navigConfigObserver();
this.setMenuModel();
this.modelUpdated(tableModel);
this.initTableProps(tableModel);
this.endPropertyChanges();
}
}.observes("viewName", "viewParams", "tableModel"),
columnNamesObserver: function(headers) {
var columnNames = [];
if (headers) {
columnNames = headers.getEach("columnName");
}
this.set("columnNames", columnNames);
},
setRowDisableProp : function(rows)
{
var colNames = this.get("columnNames");
var rowSelColKeyName = null;
for(i=0;i<colNames.length;i++)
{
if (colNames[i].toUpperCase() === "CHECKBOX")
{
rowSelColKeyName = colNames[i];
break;
}
}
if(rowSelColKeyName)
{
var columnVsIndex = this.get("columnVsIndex");
if(isNotNullString(columnVsIndex)){return;}
var colIndex = columnVsIndex[rowSelColKeyName];
for(i=0;i<rows.length;i++)
{
var colVal = rows[i].cells[colIndex].payload;
if(isJSON(colVal))
{
colVal = JSON.parse(colVal);
}
rows[i].isDisabled = (colVal && colVal.hasOwnProperty("isDisabled")) ? colVal.isDisabled : false;
}
}
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
this.set("model", tableData);
this.updateHeaderCheckbox(tableData);
}
}
}.observes("viewModel", "viewModel.data"),
updateHeaderCheckbox : function(data)
{
if ((this.get('_state') || this.get('state')) !== 'inDOM') {
return;
}
var headerCheckboxEle = this.$().find('.ember-table-tables-container .ember-table-header-container .ember-table-header-cell .ember-checkbox');
if(headerCheckboxEle.length > 0)
{
$(headerCheckboxEle).prop("checked", this.isAllRowsSelected(data));
}
},
getRows : function(data, columns){
return data;
},
modelUpdated: function(vm) {
var isSearchPresent = vm.isSearchPresent;
this.set("isSearchTriggered", isSearchPresent);
if(vm.headers)
{
this.set('isSearchEnabled', vm.headers.isAny("isSearchEnabled", true));
}
if (isSearchPresent){
this.addSearchRow(vm.headers);
}
},
columnsObserver: function() {
var viewModel = this.get("viewModel");
if(!viewModel) {return;}
var tableColumns = [];
var headers = viewModel ? viewModel.headers : [];
if(!headers){return;}
this.setColumnVsIndex(headers);
var columnNames = this.get("columnNames");
var no_of_rows_for_verticalTable = 0;
var rows = this.get("viewModel.data");
if (rows) {
no_of_rows_for_verticalTable = rows.length + 1;
}
var col = 0;
if (columnNames && columnNames.length > 0) 
{
this.updateTableColumns(tableColumns, rows);
}
if (tableColumns.length > 0) {
var lastColumn = tableColumns[tableColumns.length - 1];
if (!lastColumn.get("prevStateOfIsResizable")) {
lastColumn.set("prevStateOfIsResizable", lastColumn.get("isResizable"));
}
lastColumn.set("isResizable", false);
lastColumn.set("canAutoResize", true);
lastColumn.set("borderEnabled", false);
this.set("prevLastColumn", lastColumn);
}
this.set("columns", tableColumns);
}.observes("viewModel", "viewModel.headers"),
columnVsIndex : null,
setColumnVsIndex : function(tableColumns)
{
if(!tableColumns || tableColumns.length==0){return}
var columnVsIndex = {};
for(i=0;i<tableColumns.length;i++)
{
var col = tableColumns[i];
columnVsIndex[col.columnName] = col.colIndex;
}
this.set("columnVsIndex", columnVsIndex);
},
updateTableColumns : function(tableColumns, rows)
{
var headers = this.get("viewModel.headers");
if(!headers){return;}
var index = tableColumns.length;
var j = 0;
for (index; j < headers.length; index++, j++) 
{
tableColumns[index] = Ember.ECTable.ColumnDefinition.create();
tableColumns[index].setProperties(headers[j]);
tableColumns[index].set("tableComponent", this);
var displayName = headers[j].displayName;
tableColumns[index].set("displayName", displayName.htmlSafe());
if (jQuery('<div></div>').html(displayName).text().trim() === displayName) {
var sortEnabled = tableColumns[index].get("sortEnabled");
var size = displayName.visualLength(this.get("viewName")) + 15;
if (sortEnabled) {
size += 18;
}
var givenMinWidth = tableColumns[index].get("minWidth");
if (givenMinWidth) {
tableColumns[index].set("minWidth", Math.max(size, givenMinWidth));
}
}
if (headers[j].menuScriptInclusion && headers[j].menuScriptInclusion.length > 0) {
var script = document.createElement("script")
script.type = "text/javascript";
script.src = headers[j].menuScriptInclusion;
document.body.appendChild(script);
}
if (headers[j].createMenuScript) {
var menuscript = headers[j].createMenuScript;
ClientMenuAPI.createMenuItem(menuscript.menuItemId, menuscript.menuDataProps, menuscript.jsOptions);
}
if (headers[j].createMenuScripts != null) {
var menuIDScript = headers[j].createMenuScripts;
for (var i = 0; i < menuIDScript.length; i++) {
ClientMenuAPI.createMenuItem(menuIDScript[i].menuItemId, menuIDScript[i].menuDataProps, menuIDScript[i].jsOptions);
}
}
this.addColumnDefinition(tableColumns[index], this.isAllRowsSelected(this.get("viewModel.data")));
}
},
pages: function() {
if (!Ember.isNone(this.get("viewModel.navigation"))) {
return this.get("viewModel.navigation.pages");
}
}.property('model'),
navigConfigObserver: function() {
var navigation = this.get("viewModel.navigation");
if(navigation)
{
this.set("page", navigation.currentPage);
this.set("limit", navigation.itemsPerPage);
this.set("navigConfig", navigation);
this.set("navigConfig.pageList", this.getPages(navigation.startLinkIndex, navigation.endLinkIndex, navigation.currentPage));
this.set("navigConfig.rangeList", this.getRangeList(navigation.range, navigation.itemsPerPage, navigation.total));
this.set("navigConfig.navigLayout",navigation.naviglayout?navigation.naviglayout:this.getDefaultNavigTemplate(navigation.type));
}	
}.observes("viewModel.navigation"),
getDefaultNavigTemplate: function(type) {
switch (type) {
case "SELECT":
return "components/select-navigation";
case "BACKNEXT":
return "components/backNext-navigation";
case "SLIDEBAR":
return "components/slider-navigation";
case "NOCOUNT":
return "components/nocount-navigation";
case "NOCOUNTONDEMAND":
return "components/nocountondemand-navigation";
case "NORMAL":
return "components/default-navigation";
default:
throw new Error('NO template found for navigation');
}
},
getPages : function(pagesFrom, pagesTo, currentPage)
{
var pages = [];
for (var i = pagesFrom; i <= pagesTo; i++) {
var page = {};
page.pageNo = i;
page.isActive = (i == currentPage);
pages.pushObject(page);
}
return pages;
},
getRangeList : function (ranges, currentPageLength, totalRecords)
{
if(!ranges){ return [];}
var rangeList = [];
var rangeLimit = 99999999;
var calculatedPL = currentPageLength;
if((totalRecords != -1) && (calculatedPL >= totalRecords))
{
var idx = ranges.indexOf(currentPageLength);
for (var i = idx-1; i >= 0; i--){
if(totalRecords <= ranges[i])
{
calculatedPL = ranges[i];
break;
}
}	
}
var flag = true;
for (var i = 0; i < ranges.length; i++) {
var _PL =  ranges[i];
var range = {};
range.pageLength = _PL;
range.isActive = (_PL == calculatedPL);
if((totalRecords != -1) && (totalRecords <= _PL) && flag)
{
flag = false;
rangeLimit = _PL;
}
range.isDisabled = _PL > rangeLimit;
rangeList.pushObject(range);
}
return rangeList;
},
changeNavigConfig: function(setMPState) {
if(!Ember.isNone(this.get("viewModel.navigation"))) {
this.setStateForNavig(setMPState);
this.send("updateView", "navigation");
}
},
setStateForNavig: function(setMPState) {
this.get('stateData').set("navigReq", this.getNavigConfig(setMPState));
},
setNoRowMsg: function() {
var noRowMsg = this.get("viewModel.noRowMsg");
return this.set("noRowMsg", !Ember.isNone(noRowMsg) ? noRowMsg.htmlSafe() : "No Rows found".htmlSafe());
}.observes('viewModel'),
setMenuModel: function() {
var menuModel = this.get("viewModel.showMenu");
if (menuModel) {
for (i = 0; i < menuModel.menuItems.length; i++) {
var menuItem = menuModel.menuItems[i];
var createMenuToBeExec = menuItem.createMenu;
if(!menuItem.disabled){
ClientMenuAPI.createMenuItem(createMenuToBeExec.menuItemId, createMenuToBeExec.menuDataProps, createMenuToBeExec.jsOptions);
}
var value = "";
if (menuItem.imageSrc) {
value += "<img src='" + menuItem.imageSrc + "'/>  ";
}
if (menuItem.displayName) {
value += menuItem.displayName;
}
menuModel.menuItems[i].arg = menuItem.menuInvoker;
if (menuItem.displayName === "Add Alarm") {
menuModel.menuItems[i].showAsRouteLink = true;
} else {
menuModel.menuItems[i].showAsRouteLink = false;
}
menuModel.menuItems[i].displayName = value.htmlSafe();
}
}
this.set("menuModel", menuModel);
}.observes("viewModel.showMenu"),
addRuler: function(viewName) {
if(!document.getElementById("ruler_" + viewName)){
var rulerDiv = document.createElement("span");
rulerDiv.setAttribute("id", "ruler_" + viewName);
rulerDiv.setAttribute("style", "visibility:hidden;white-space:nowrap;display:none;"); 
document.querySelector("body").appendChild(rulerDiv);
}
},
willDestroyElement: function() {
this._super();
this.deleteRuler(this.getViewName());
},
deleteRuler: function(viewName) {
var rulerDiv=document.getElementById("ruler_" + viewName);
if(rulerDiv){
rulerDiv.parentNode.removeChild(rulerDiv);
}
}
});
Ember.Handlebars.helper('table-view', MC.TableViewComponent);})();
