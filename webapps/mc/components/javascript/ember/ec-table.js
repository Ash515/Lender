(function(){
MC.EcTableComponent = Ember.Table.EmberTableComponent.extend({
rowHeight: 33,
maxTableHeight: 17,
tableRowView: 'Ember.Table.ECTableRow',
tableCellView: 'Ember.Table.ECTableCell',
headerCellView : 'Ember.Table.ECHeaderCell',
isRestrictedToContainerHeight: true,
init : function(){
this._super.apply(this,arguments);
var _this = this;
jQuery(window).bind('resize', function(event) {
Ember.run(_this, _this.handleResize, event);
});
},
onColumnSort: function(column, newIndex) {
var prevLastColumn = this.get("prevLastColumn");
var numFixedColumns = this.get('fixedColumns.length');
var columns = this.get('columns');
columns.removeObject(column);
columns.insertAt(numFixedColumns + newIndex, column);
var lastColumn = columns[columns.length - 1];
if(lastColumn !== prevLastColumn)
{
var lastColIndex = columns.indexOf(prevLastColumn);
var colTobeRemoved = columns.objectAt(lastColIndex);
columns.removeObject(prevLastColumn);
colTobeRemoved.set("isResizable", prevLastColumn.get("prevStateOfIsResizable"));
colTobeRemoved.set("borderEnabled", true);
columns.insertAt(lastColIndex, colTobeRemoved);
}
if (!lastColumn.get("prevStateOfIsResizable")) {
lastColumn.set("prevStateOfIsResizable", lastColumn.get("isResizable"));
}
lastColumn.set("isResizable", false);
lastColumn.set("canAutoResize", true);
lastColumn.set("borderEnabled", false);
columns.removeObject(lastColumn);
columns.pushObject(lastColumn);
this.set("prevLastColumn", lastColumn);
this.prepareTableColumns();
Ember.run.next(this, function(){
this.sendAction("columnReorderAction", columns);
});
return;
},
doForceFillColumns: function() {
var allColumns = this.get('columns');
if(!allColumns)
{
return;
}
var columnsToResize = allColumns.filterProperty('canAutoResize');
var unresizableColumns = allColumns.filterProperty('canAutoResize', false);
var availableWidth = this.get('_width') - this._getTotalWidth(unresizableColumns)-3;
var doNextLoop = true;
var nextColumnsToResize = [];
var totalResizableWidth;
var newWidth;
while (doNextLoop) {
doNextLoop = false;
nextColumnsToResize = [];
totalResizableWidth = this._getTotalWidth(columnsToResize);
var len = 0;
for (var i = 0, len = columnsToResize.length; i < len; i++) {
var column = columnsToResize[i];
newWidth = Math.floor((column.get('width') / totalResizableWidth) * availableWidth);
if (newWidth < column.get('minWidth')) {
doNextLoop = true;
column.set('width', column.get('minWidth'));
availableWidth -= column.get('width');
} else if (newWidth > column.get('maxWidth')) {
doNextLoop = true;
column.set('width', column.get('maxWidth'));
availableWidth -= column.get('width');
} else {
column.set('width', newWidth);
nextColumnsToResize.pushObject(column);
}
}
columnsToResize = nextColumnsToResize;
}
Ember.run.next(this, this.reinitScroll);
},
didInsertElement: function() {
this._super();
Ember.run.next(this,this.updateWidthIfNecessary);
},
updateWidthIfNecessary : function()
{
if ((this.get('_state') || this.get('state')) !== 'inDOM') {
return;
}
if(this.get("_width") != this.$().parent().width())
{
this.elementSizeDidChange();
}
},
elementSizeDidChange: function() {
if ((this.get('_state') || this.get('state')) !== 'inDOM') {
return;
}
this.set('_width', this.$().parent().width());
this.set('_height', (this.get("maxTableHeight") * this.get("rowHeight") + this.get("rowHeight")));
Ember.run.next(this, this.updateLayout);
},
updateLayout: function() {
this.reinitScroll();
if (this.get('columnsFillTable') && this.get("columns")) {
this.doForceFillColumns();
}
},
reinitScroll: function() {
if ((this.get('_state') || this.get('state')) !== 'inDOM') {
return;
}
var antiscroll = this.$('.antiscroll-wrap').antiscroll().data('antiscroll');
var actionName = this.get("tableViewController.currentActionName");
if (!this.get("isScrollTable") || (this.get("isScrollTable") && (actionName !== "scroll" && actionName !== "navigation"))) {
this.resetScrollTop(antiscroll);
}
antiscroll.rebuild();
},
resetScrollTop: function(antiscroll) {
antiscroll.inner.get(0).scrollTop = 0;
},
handleResize: function(event) {
if (event.target == window) {
this.elementSizeDidChange();
this.notifyPropertyChange('_tablesContainerHeight');
}
},
willDestroyElement: function() {
this._super();
jQuery(window).unbind('resize');
},
_tablesContainerHeight: Ember.computed(function() {
var height = this.get('_height');
var contentHeight = this.get('_tableContentHeight') + (this.get("hasHeader") ? this.get('_headerHeight') : 0) + (this.get("hasFooter") ? this.get('_footerHeight') : 0);
var windowHeight = jQuery(window).height();
if (this.get('isRestrictedToContainerHeight')) {
return Math.min(contentHeight, height);
} else {
return Math.min(contentHeight, Math.max(windowHeight, height));
}
}).property('_height', '_tableContentHeight', '_headerHeight', '_footerHeight', 'isRestrictedToContainerHeight'),
getPKColValue : function(rowIndex)
{
var pkcolName = this.get("pkcol");
var tableDOMModel = ClientTableModel.getInstance(this.get("viewName"));
return tableDOMModel.getValueAt(rowIndex, tableDOMModel.getColumnIndex(pkcolName));
},
click: function(event) {
var row = this.getRowForEvent(event);
var type = jQuery(event.target).attr("type");
var isChecked = false;
var ele = null;
if (type && (type === "checkbox" || type === "radio")) {
ele = event.target;
isChecked = jQuery(ele).is(":checked");
} else if (jQuery(event.target).attr("class") === "ember-table-content") {
if (!jQuery(event.target).attr("class") === "Tooltipster" || !(row && row.content && row.content.isAdvancedSearch && row.content.isSearchRow)) {
ele = jQuery(event.target).parents(".ember-table-table-row").find("input[name='rowSelection']");
isChecked = !jQuery(ele).is(":checked");
}
} else { return; }
if (jQuery(ele).length <= 0 || jQuery(ele).is(':disabled')) { return; }
switch (this.get('selectionMode')) 
{
case 'none':
break;
case 'single':
this.get('persistedSelection').clear();
var index = row.content.rowIdx;
var pkcolValue = this.getPKColValue(index);
if (pkcolValue) {
var key = "rowSelectionReq";
this.get('tableViewController.stateData').remove(key);
if (isChecked) {
this.get('tableViewController.stateData').addSelectedRowIndex(key, pkcolValue);
} else {
this.get('tableViewController.stateData').removeSelectedRowIndex(key, pkcolValue);
}
}
var selectedRowIndices = Em.A([]);
if (isChecked) {
selectedRowIndices.push(index);
} 
else {
selectedRowIndices.removeObject(index);
}
this.get('tableViewController.stateData').remove("selectedRowIndices");
this.get('tableViewController.stateData').set("selectedRowIndices", selectedRowIndices);
row.set("isSelected", isChecked);
jQuery(ele).prop("checked", isChecked);
break;
case 'multiple':
var index = row.content.rowIdx;
var pkcolValue = this.getPKColValue(index);
if (pkcolValue) {
var key = "rowSelectionReq";
if (isChecked) {
this.get('tableViewController.stateData').addSelectedRowIndex(key, pkcolValue);
} else {
this.get('tableViewController.stateData').removeSelectedRowIndex(key, pkcolValue);
}
}
var selectedRowIndices = this.get("selectedRowIndices") || Em.A([]);
if (isChecked) {
if (selectedRowIndices.indexOf(index) == -1) {
selectedRowIndices.push(index);
}
} else {
if (selectedRowIndices.indexOf(index) > -1) {
selectedRowIndices.removeObject(index);
}
}
this.get('tableViewController.stateData').set("selectedRowIndices", selectedRowIndices);
row.set("isSelected", isChecked);
var rows = this.get("content");
var rowIndices = rows.getEach("rowIdx");
var isAllRowsSelected = true;
for (i = 0, len = rowIndices.length; i < len; i++) {
if (selectedRowIndices.indexOf(rowIndices[i]) == -1) {
isAllRowsSelected = false;
break;
}
}
var headerCheckboxEle = Ember.$(ele).parents(".ember-table-tables-container").find('.ember-table-header-container .ember-table-header-cell .ember-checkbox');
Ember.$(headerCheckboxEle).prop("checked", isAllRowsSelected);
jQuery(ele).prop("checked", isChecked);
break;
}
},
actions: {
drillDownView: function(param) {
this.get("tableViewController").send("drillDownView", param);
},
actionTrigger: function(obj) {
this.get("tableViewController").send("actionTrigger", obj);
}
}
});
Ember.Handlebars.helper('ec-table', MC.EcTableComponent);})();
