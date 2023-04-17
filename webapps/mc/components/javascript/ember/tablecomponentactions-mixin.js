MC.TableComponentActionsMixin = Ember.Mixin.create({
clearAllPopups: function() {
var popupQueue = get(this, 'popupQueue');
while(popupQueue.length > 0)
{
var popupComponent = get(popupQueue[0], "popupComponent");
if(popupComponent)
{
popupComponent.destroyPopup();	
}
}
},
addColumnDefinition: function(tableColumns, isAllRowsSelected) {
var self = this;
var colName = tableColumns.columnName;
if (colName.toUpperCase() === "CHECKBOX" || colName.toUpperCase() === "RADIO") {
tableColumns.reopen({
checkedProp: isAllRowsSelected,
columnName: colName,
isSortable: false,
isResizable: false,
borderEnabled: false,
headerCellView: colName.toUpperCase() === "CHECKBOX"?'Ember.Table.ECHeaderCheckboxCell':'Ember.Table.ECHeaderCell',
tableCellView: colName.toUpperCase() === "CHECKBOX"?'Ember.Table.ECTableCheckCell':'Ember.Table.ECTableRadioCell',
width: 50,
textAlign: 'text-align-center',
canAutoResize: false,
getCellContent: function(row) {
var selectedRowIndices = self.get("selectedRowIndices");
row.set("isSelected", (selectedRowIndices && selectedRowIndices.indexOf(row.content.rowIdx) != -1));
if (row.get("isSearchRow") || row.get("isAdvancedSearch")) {
row.set("setEmptyVal", true);
}
return row;
}
});
}
else
{
tableColumns.reopen({
sort: function() {
if (this.get("sortEnabled")) {
self.send("sort", this);
}
},
resize: function(width) {
self.send("resize", this.columnName, width);
this.set('canAutoResize', false);
this.set('savedWidth', width);
return this.set('width', width);
},
actionTrigger: function(params) {
self.send("actionTrigger", params);
}
});
}
},
getAdvSearchRow: function(columns, viewName) {
var searchRow = {};
var row = [];
columns.forEach(function(column) {
var obj = {};
var columnName = column.columnName;
var advanceSearchOptions = column.advanceSearchOptions;
var advSearchEle = null;
if (column.columnType !== "rowSel" && column.isSearchEnabled && advanceSearchOptions.length > 0) 
{
var key = (viewName + "_" + columnName).replace(".","_");
advSearchEle = {};
advSearchEle.class = "form-control "+ viewName+ " " + key;
advSearchEle.name ="selectedComboValues[]";
advSearchEle.event = " onchange='myselect(\""+key+"\")' ";
advSearchEle.options = advanceSearchOptions;
}
obj.isAdvancedSearch = true;
obj.value = advSearchEle;
row[column.colIndex] = obj;
});
searchRow.isAdvancedSearch = true;
searchRow.cells = row;
return searchRow;
},
addSearchRow: function(headers) {
var row = [];
var columns = (headers && headers.length > 0) ? headers : this.get("viewModel.headers");
var j = 1;
var viewName = this.getViewName();
var columnOrder = this.get('stateData').get("colChooserReq");
columnOrder = columnOrder ? columnOrder.toArray() : columns.getEach("columnName");
for(i=0, len=columnOrder.length; i<len;i++)	
{
var column = columns.filterBy("columnName",columnOrder[i])[0];
var obj = {};
obj.tooltip = false;
var columnName = column.columnName;
var val = null;
if (column.columnType !== "rowSel" && column.isSearchEnabled) {
val = {};
var searchVal = column.searchValue;
var key = (viewName + "_" + columnName).replace(".","_");
val.class = "form-control text-sm "+ key + " " + (column.disabled ? "hide " : "") + viewName;
if(Ember.isEqual(column.sqlType, "DATE"))
{
val.type = "date";
val.format = column.format.replace("yyyy", "YYYY").replace("dd", "DD");
}
else
{
val.type = "text";
}
val.sqlType = column.sqlType;
val.columnName=columnName;
val.name='searchValues';
val.searchVal = (searchVal) ? searchVal : "";
val.placeholder=column.format;
val.action='go';
} 
obj.isSearchRow = true;
obj.value = val;
var colIndex = this.get("columnVsIndex")[columnName];
row[colIndex] = obj;
}
var searchRow = {};
searchRow.cells = row;
searchRow.isSearchRow = true;
var searchRowIndex = 0;
if (this.get("viewModel.isAdvancedSearch")) {
this.get("model").insertAt(0, this.getAdvSearchRow(columns, viewName));
searchRowIndex++;
}
this.get("model").insertAt(searchRowIndex, searchRow);
},
removeSearchRow: function() {
if (this.get("model").length > 0 && this.get("model").objectAt(0).isAdvancedSearch) {
this.get("model").removeAt(0);
}
if (this.get("model").length > 0 && this.get("model").objectAt(0).isSearchRow) {
this.get("model").removeAt(0);
this.beginPropertyChanges();
this.set("page", 1);
this.setStateForNavig();
this.get('stateData').set("searchReq", {});
this.send("updateView", "all");
this.endPropertyChanges();
}
},
getNavigConfig: function(setMPState) {
var navigConfig = this.get("navigConfig");
var limit = (Ember.isEqual(0, this.get("limit"))) ? (navigConfig ? navigConfig.itemsPerPage : 0) : this.get("limit");
var page = this.get("page");
var fromIndex = (((page - 1) * limit) + 1);
var toIndex = Math.min((page * limit), (navigConfig ? navigConfig.total : 0));
var navigReq = {};
navigReq._PN = page;
navigReq._FI = fromIndex;
navigReq._TI = toIndex;
navigReq._PL = limit;
if(setMPState)
{
navigReq._MP = "_PL"; 
}
return navigReq;
},
keyPress: function(ev) {
if (ev && (ev.which == 13 || ev.which == 1) && Ember.isEqual(ev.target.name, "searchValues")) {
this.send("go");
}
},
isExtraComponentBarNeeded: function() {
return ((this.get("isSearchEnabled") || this.get("viewModel.navigation.hasPaginationTop") || this.get("isColumnChooserEnabled")) && (this.get("viewModel.showHeader"))) ? true : false;
}.property("isSearchEnabled", "viewModel"),
isMenuActionPresent: function() {
return this.get("viewModel.showMenu") != null;
}.property("viewModel"),
getViewName: function() {
return this.get("viewModel.name");
},
isModelEmpty: Ember.computed.equal('viewModel.data.length', 0),
getColChoosermodel : function()
{
var cc = this.get("viewModel.colList");
var ccList = Em.A([]);
var tableColumns = this.get("columns");
for(i=0, len=cc.length; i<len; i++)
{
if (cc[i].name.toUpperCase() === "CHECKBOX" || cc[i].name.toUpperCase() === "RADIO") {
cc[i].isChoosable = false;
}
var temp = {};
temp.name = cc[i].name;
temp.display = cc[i].display;
temp.isVisible = cc[i].isVisible;
temp.isChoosable = cc[i].isChoosable;
temp.isSortable = cc[i].isSortable;
var selectedCol = tableColumns.findBy("columnName", cc[i].name);
var index = tableColumns.indexOf(selectedCol);
if(index == -1)
{
index = ccList.length;
}
ccList[index] = temp;
}
return ccList;
},
click : function(event)
{
var tagName = jQuery(event.target).prop("tagName");
if(jQuery(event.target).attr("class") && (jQuery(event.target).attr("class").indexOf("colchooser") > -1) && (tagName === "BUTTON" || tagName === "SPAN") && jQuery("ul."+this.getViewName()).length == 0)
{
this.send("showColChooserDialog", "components/col-choose", jQuery(event.target));
}
},
isAllRowsSelected : function(rows)
{
if(rows.length == 0){return false;}
var disabledRowsCount = rows.filterBy("isDisabled", true).length;
var selectedRowsCount = rows.filterBy("isSelected",true).length;
if(disabledRowsCount > 0 && selectedRowsCount > 0)
{
return ((selectedRowsCount+disabledRowsCount) == rows.length);
}
return rows.isEvery("isSelected",true);
},
showTotal : false,
totalRecordsCount : -1,
addDC : false,
delDC : false,
showCount : function(count)
{
this.set("totalRecordsCount", count);
this.set("showTotal",true);
},
actions: 
{
getCount : function()
{
this.sendRequest({url:"countOnDemand.ma?viewName="+this.getViewName(), data : this.getViewState(), onSuccessFunc : "showCount"});
},
showColChooserDialog : function(dialogLayoutName, target)
{
this.showContentInDialog(this.getColChoosermodel(), {"title" : "Column Chooser","refId" : this.getViewName(), "position": { my: "left top", at: "left bottom", of: target }, "layoutName" : dialogLayoutName});
},
refreshView : function()
{
this.send("updateView", "navigation");
},
updateView: function(actionName) {
if(!this.get("isTransCommitted"))
{
this.set("isTransCommitted", true);
actionName = (!actionName || actionName.trim().length == 0) ? "navigation" : actionName;
var viewName = this.getViewName();
var stateData = this.getViewState();
var url = viewName + ".ec";
var queryParams = this.get("viewParams");
if(!queryParams || queryParams.length == 0)
{
queryParams = this.get("viewModel.reqParams");
}
if (queryParams) {
url = (url.indexOf("?") > -1) ? url + "&" + queryParams : url + "?" + queryParams;
}
this.sendRequest({
url: url,
onSuccessFunc: "refreshTable",
onSuccessFuncArg: actionName,
onFailureFunc:"postActionHandler",
dataType: "json",
type:"POST",
data: stateData
});
}
},
postActionHandler : function()
{
return this.set("isTransCommitted", false);
},
refreshTable: function(actionName, viewModel) {
this.send("postActionHandler");
if(actionName === "resize")
{
return;
}
this.clearAllPopups();
this.set("viewModel.TableModel", viewModel.TableModel);
this.setColumnVsIndex(viewModel.headers);
this.set("currentActionName", actionName);
if(this.get("viewModel.isScrollTable") && (actionName !== "scroll" && actionName !== "navigation"))
{
this.set("tempModel", Em.A([]));
}
this.get('stateData').remove("columnResizeReq");
this.get('stateData').remove("colChooserReq");
switch (actionName) {
case "sort":
this.set("viewModel.data", viewModel.data);
this.set('viewModel.sortOrder', viewModel.sortOrder);
this.set('viewModel.sortBy', viewModel.sortBy);
this.set('viewModel.navigation', viewModel.navigation);
this.modelUpdated(viewModel);
break;
case "filter":
this.set("showTotal",false);
this.set("viewModel.data", viewModel.data);
this.set('viewModel.sortOrder', viewModel.sortOrder);
this.set('viewModel.sortBy', viewModel.sortBy);
this.set('viewModel.navigation', viewModel.navigation);
this.set('viewModel.filterConfig', viewModel.filterConfig);
this.modelUpdated(viewModel);
break;
case "ajaxCallBack":
case "menuAction":
case "navigation":
this.set("showTotal",false);
this.set("viewModel.data", viewModel.data);
this.set('viewModel.navigation', viewModel.navigation);
this.modelUpdated(viewModel);
break;
case "colchooser":
this.set("viewModel.headers", viewModel.headers);
this.set('viewModel.colList', viewModel.colList);
this.set('viewModel.data', viewModel.data);
this.columnNamesObserver(viewModel.headers);
this.modelUpdated(viewModel);
Ember.run.next(function()
{
jQuery(window).resize();
}, 100);
break;
case "search":
this.set("showTotal",false);
this.set("viewModel.data", viewModel.data);
this.set('viewModel.navigation', viewModel.navigation);
this.set('viewModel.isSearchPresent', viewModel.isSearchPresent);
this.modelUpdated(viewModel);
break;
default:
this.set("showTotal",false);
this.set("viewModel", viewModel);
this.columnNamesObserver(viewModel.headers);
this.modelUpdated(viewModel);
}
},
exportAs: function(extension) {
var viewName = this.getViewName();
var state = this.getViewState();
if(state && state.length > 0)
{
state = "&"+state;
}
window.location.href = viewName+"."+extension+"?UNIQUE_ID="+ viewName + state;
},
invokeMenuAction: function(arg) {
var menuInvoker = arg.menuInvoker;
var menuActionUrl = "";
if (menuInvoker.jsMethodName) {
if (typeof window[menuInvoker.jsMethodName] === "function") {
window[menuInvoker.jsMethodName].apply(window, [arg.menuItemId, menuInvoker.uniqueId, menuInvoker.reqParams, menuInvoker.rowIndex]);
} else {
throw new Error('No such method found for Menu implementation in this context'); 
}
} else {
menuActionUrl = invokeClientMenuAction(menuInvoker);
}if (menuActionUrl) {
this.sendRequest({url: menuActionUrl, onSuccessFunc: "refreshView", statusMsgFunc:"default"});
}
},
toggleAddDCView : function(arg){
this.toggleProperty("addDC");
this.set("delDC", false);
},
toggleDelDCView : function(arg){
this.toggleProperty("delDC");
this.set("addDC", false);
},
dcViewCallback : function(typeOfAction,model)
{
this.send("updateView", "all");
this.send(typeOfAction);
},
resize: function(columnName, width) {
this.beginPropertyChanges();
this.clearAllPopups();
var key = "columnResizeReq";
var obj = this.get('stateData').get(key);
if(!obj)
{
obj = {};
}
obj[columnName] = width;
this.get('stateData').set(key, obj);
this.send("updateView", "resize");
this.endPropertyChanges();
},
search: function() {
this.toggleProperty("isSearchTriggered");
this.set("currentActionName", "search");
if (this.get("isSearchTriggered")) {
this.addSearchRow();
} else {
this.removeSearchRow();
}
},
changeFilter: function(filterName) {
var filterConfigReq = {};
filterConfigReq.filterName = filterName;
this.set("page", 1);
var navigation = this.get("viewModel.navigation");
if(navigation)
{
var initialRange = navigation.rangeList.toArray()[0];
this.set("limit", initialRange.pageLength);
}
this.setStateForNavig();
this.get('stateData').set("filterConfigReq", filterConfigReq);
this.send("updateView", "filter");
},
columnReorder: function(columns) {
var colChooserReq = {};
var showList = Ember.A();
for (i = 0; i < columns.length; i++) {
showList.push(columns[i].get('columnName'));
}
this.get('stateData').set("colChooserReq", showList);
this.send("updateView", "colchooser");
},
setPageLength: function(limit) {
var pageLength = this.get("viewModel.navigation.itemsPerPage");
pageLength = !Ember.isNone(pageLength) ? pageLength : 0;
var limit = Ember.isNone(limit) ? pageLength : limit;
this.beginPropertyChanges();
this.set('page', 1);
this.set("limit", limit);
this.changeNavigConfig(true);
this.endPropertyChanges();
},
setPage: function(index) {
this.set('page', index);
this.changeNavigConfig(true);
},
firstPage: function() {
this.set('page', 1);
this.changeNavigConfig(true);
},
previousPage: function() {
this.set('page', Math.max((this.get('page') - 1), 1));
this.changeNavigConfig(true);
},
nextPage: function() {
this.set('page', (this.page + 1));
this.changeNavigConfig(true);
},
lastPage: function() {
this.set('page', this.get("pages"));
this.changeNavigConfig(true);
},
sort: function(column) {
var sortReq = {};
var prevSortOrder = this.get("viewModel.sortOrder");
var prevSortBy = this.get("viewModel.sortBy");
if (Ember.isEqual(prevSortBy, column.columnName)) {
sortReq._SO = prevSortOrder ? "D" : "A";
} else {
sortReq._SO = "A";
}
sortReq._SB = this.get("viewModel.SQLTable") ? column.sqlTblColindex : column.columnName;
sortReq._MP = "_SB";
if(!Ember.isNone(this.get("viewModel.navigation"))) {
this.set("page", 1);
this.setStateForNavig();
}
this.get('stateData').set("sortReq", sortReq);
this.send("updateView", "sort");
},
columnChooser: function(showList) {	
var state=this.get('stateData');
state.set("colChooserReq", showList);
var searchState=state.get("searchReq");
if(searchState && searchState.hasOwnProperty('SEARCH_COLUMN')){
var columns=searchState['SEARCH_COLUMN'].split(",");
if(columns.length==1 && showList.indexOf(columns[0])==-1){
state.remove('searchReq');
}else{
var values=searchState['SEARCH_VALUE'].split(",");
var searchValComb=searchState.hasOwnProperty('SEARCHVAL_COMB')?searchState['SEARCHVAL_COMB'].split(","):null;
var searchComboVal=searchState.hasOwnProperty('SEARCHCOMBO_VALUE')?searchState['SEARCHCOMBO_VALUE'].split(","):null;
for(var i=columns.length-1;i>=0;i--)
{
if(showList.indexOf(columns[i])==-1){
columns.splice(i,1);
values.splice(i,1);
searchValComb?searchValComb.splice(i,1):"";
searchComboVal?searchComboVal.splice(i,1):"";
}
}
if(columns.length==0){
state.remove('searchReq');
}else{
searchState['SEARCH_COLUMN']=columns.join();
searchState['SEARCH_VALUE']=values.join();
if(searchValComb){
searchState['SEARCHVAL_COMB']=searchValComb.join();
searchState['SEARCHCOMBO_VALUE']=searchComboVal.join();
}
state.set('searchReq',searchState);
}
}
this.set("page", 1);
this.setStateForNavig();
}
this.send("updateView", "colchooser");
},
go: function() {
var searchColNames = [];
var viewName = this.getViewName();
var searchVals = jQuery('input.' + viewName + '[name="searchValues"]').map(function() {
var value = this.value;
searchColNames.push(jQuery(this).attr("columnName"));
if (value.search(',') != -1) {
value = value.replace(/,/g, "&#44;");
}
return value;
}).get();
var searchComboValues = jQuery('select.' + viewName + '[name="selectedComboValues[]"]').map(function() {
var value = this.value.trim();
if (value.search(',') != -1) {
value = value.replace(/,/g, "&#44;");
}
return value;
}).get();
var searchColumns = "", searchValues = "", searchComboVals = "", searchValCombos = "";
var searchReq = {};
var columns = this.get("columns");
for (i = 0; i < searchVals.length; i++) {
var colName = searchColNames[i];
if (searchVals[i].length > 0 || ((columns.filterBy("columnName", colName)[0]) && Ember.isEqual((columns.filterBy("columnName", colName)[0]).sqlType, "BOOLEAN") && searchComboValues[i] && searchComboValues[i].trim().split("::")[0] != 25)) {
if (searchColumns.length > 0) {
searchColumns = searchColumns + ",";
searchValues = searchValues + ",";
}
if (searchComboVals.length > 0) {
searchComboVals = searchComboVals + ",";
searchValCombos = searchValCombos + ",";
}
searchColumns = searchColumns + colName;
searchValues = searchValues + searchVals[i].trim();
if (!Ember.isNone(searchComboValues[i])) {
var val = searchComboValues[i].trim().split("::");
searchValCombos = searchValCombos + val[1];
searchComboVals = searchComboVals + val[0];
}
}
}
if (searchColumns.length > 0) {
searchReq.SEARCH_COLUMN = searchColumns;
searchReq.SEARCH_VALUE = searchValues;
if (searchComboVals.length > 0) {
searchReq.SEARCHCOMBO_VALUE = searchComboVals;
searchReq.SEARCHVAL_COMB = searchValCombos;
}
}
this.beginPropertyChanges();
this.set("page", 1);
this.setStateForNavig();
this.get('stateData').set("searchReq", searchReq);
this.send("updateView", "search");
this.endPropertyChanges();
}
}
});
