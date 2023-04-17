App.TabLayoutView = Ember.View.extend({
didInsertElement: function() {
jQuery(function() {
jQuery('.verticalTab').antiscroll();
});
}
});
(function(){
MC.HeaderCheckComponent = Ember.Checkbox.extend({
attributeBindings: ['rowIdx']
});
Ember.Handlebars.helper('header-check', MC.HeaderCheckComponent);})();
(function(){
MC.CoolCheckComponent = Ember.Checkbox.extend({
attributeBindings : ["coolCheckStyles:style"],
coolCheckStyles : "margin-left : 7px;",
hookup: function() {
this.on('change', this, this.sendHookup);
}.on('init'),
sendHookup: function(ev) {
var controller = this.get('controller');
var model = controller.get("dialog.dialogModel");
var showListColumnNames = model.filterBy("isVisible",true);
var isColumnVisible = this.$().prop("checked");
var colChooserDisabledList = model.filterBy("isChoosable",false);
if(!isColumnVisible)
{
if(colChooserDisabledList.length > 0 && showListColumnNames.length == 2)
{
alert("Atleast one column should be selected");
this.$().prop("checked", true);	
}
else if (showListColumnNames.length == 1) {
alert("Atleast one column should be selected");
this.$().prop("checked", true);
}
}
},
cleanup: function() {
this.off('change', this, this.sendHookup);
this.destroy();
}.on('willDestroyElement')
});
Ember.Handlebars.helper('cool-check', MC.CoolCheckComponent);})();
App.ContainerView = Ember.View.extend({
attributeBindings: ['vname'],
mouseEnter: function() {
var trigger = jQuery(".ember-table-content > .Tooltipster").attr("trigger");
jQuery(".ember-table-content > .Tooltipster").tooltipster({
updateAnimation: false,
multiple: true,
position: "bottom-left",
trigger: trigger,
interactive: true,
maxWidth: 500,
offsetY: -4,
offsetX: -12
});
}
});
App.TabLayoutMenuAction2View = Ember.View.extend({
template: function() {
var template = "hi";
var controller = App.__container__.lookup("controller:tabLayoutMenuAction2");
return Ember.Handlebars.compile(controller.get("model"));
}.property(),
didInsertElement: function() {
var controller = this.get("controller");
new Function(controller.get("scriptToExecute"))();
}
});
App.ColumnComboBoxView = Ember.Select.extend({
attributeBindings: ['name'],
name: "columnCombos"
});
App.ComparatorComboBoxView = Ember.Select.extend({
attributeBindings: ['name'],
name: "comparatorCombos"
});
App.ValueComboBoxView = Ember.Select.extend({
attributeBindings: ['name'],
name: "valueCombos"
});
Ember.Table.ECTableRow = Ember.Table.TableRow.extend({
mouseEnter: function(event) {
var row;
row = this.get('row');
if (row) {
return row.set('isHovered', this.get("tableComponent.rowHoverEnabled"));
}
},
watchLastRow: function(event) {
if (this.get("isLastRow")) {
var controller = this.get("tableComponent");
controller.sendAction("secondFetch", this.get("tableComponent.viewName"));
}
}.observes("isLastRow")
});
Ember.Table.ECTableCell = Ember.Table.TableCell.extend({
classNameBindings: ['column.textAlign', 'column.borderEnabled:ember-table-cell-border', 'column.columnCss'],
templateName : "mc-cell"
});
Ember.Table.ECTableCheckCell = Ember.Table.ECTableCell.extend({
templateName : "row-cell"
});
Ember.Table.ECTableRadioCell = Ember.Table.ECTableCell.extend({
templateName : "radio-cell"
});
Ember.Table.ECHeaderCell = Ember.Table.HeaderCell.extend({
templateName : "mc-header-cell",
classNameBindings: ['column.isSortable:sortable', 'column.textAlign', 'column.borderEnabled:ember-table-cell-border', 'sortIndicator', 'column.headerCss'],
sortIndicator: function() {
var column = this.get("column");
if (column.sortEnabled) {
if (column.columnName == this.get('tableComponent.sortBy')) {
if (this.get('tableComponent.sortOrder')) {
return "ember-table-column-sort-asc-indicator";
} else {
return "ember-table-column-sort-desc-indicator";
}
} else {
return "ember-table-column-sort-both-indicator";
}
}
}.property('tableComponent.sortOrder', 'tableComponent.sortBy'),
click: function(event) {
var column = this.get('column');
column.sort(event);
event.stopPropagation();
},
onColumnResize: function(event, ui) {
var newWidth = Math.round(ui.size.width);
if (this.get('tableComponent.columnMode') === 'standard') {
this.get('column').resize(newWidth);
} else {
var diff = this.get('width') - newWidth;
this.get('column').resize(newWidth);
this.get('nextResizableColumn').resize(
this.get('nextResizableColumn.width') + diff);
}
this.elementSizeDidChange();
if (event.type === 'resizestop') {
this.get('tableComponent').elementSizeDidChange();
}
},
recomputeResizableHandle: function() {
if ((this.get('_state') || this.get('state')) !== 'inDOM') {
return;
}
if (this.get('_isResizable')) {
this.$().resizable(this.get('resizableOption'));
} else {
if (this.$().is('.ui-resizable')) {
this.$().resizable('destroy');
}
}
}
});
Ember.Table.ECHeaderCheckboxCell = Ember.Table.ECHeaderCell.extend({
attributeBindings : ["name"],
templateName : "row-selection-header",
click: function(event) {
var type = jQuery(event.target).attr("type");
if (type && (type === "checkbox" || type === "radio")) 
{
ele = event.target;
isChecked = jQuery(ele).is(":checked");
var selectedRowIndices = [];
var selectedPkcols = [];
var viewName = this.get("tableComponent.viewName");
var rows = this.get("tableComponent.content");
var selectableRows = Ember.copy(rows);
var pkcolName = this.get("tableComponent.pkcol");
var $rowView = Ember.$(ele).parents(".ember-table-tables-container").find('.ember-table-table-row');
var tableDOMModel = ClientTableModel.getInstance(viewName);
for(i=0;i<$rowView.length;i++)
{
var view = Ember.View.views[jQuery($rowView[i]).attr('id')];
if (view) {
var row = view.get('row');
if(row)
{
if(!row.content.isDisabled && !row.content.isSearchRow)
{
var rowIndex = row.content.rowIdx;
var checkboxEle = jQuery($rowView[i]).find("input[name='rowSelection']");
jQuery(checkboxEle).prop("checked",isChecked);
row.set("isSelected",isChecked);
selectedRowIndices.pushObject(rowIndex);
selectableRows.removeObject(selectableRows.filterBy("rowIdx", rowIndex)[0]);
var pkcol = tableDOMModel.getValueAt(rowIndex, tableDOMModel.getColumnIndex(pkcolName));
if(pkcol){ selectedPkcols.pushObject(pkcol);}
}
}
}
}
var remainingRows = selectableRows.filterBy("isDisabled", false);
remainingRows.setEach("isSelected", isChecked);
selectedRowIndices  = selectedRowIndices.concat(remainingRows.getEach("rowIdx"));
for(i=0; i<remainingRows.length;i++)
{
var rowIndex = rows.indexOf(remainingRows[i]);
var pkcol = tableDOMModel.getValueAt(rowIndex, tableDOMModel.getColumnIndex(pkcolName));
if(pkcol){ selectedPkcols.pushObject(pkcol);}
}
var rowSelkeyName = "rowSelectionReq";
var selectedIndiceskeyName = "selectedRowIndices";
if(isChecked)
{
this.set("tableComponent.selectedRowIndices", selectedRowIndices);
if(selectedPkcols.length > 0)
{
this.get('tableComponent.tableViewController.stateData').addSelectedRowIndexList(rowSelkeyName, selectedPkcols);
}
if(selectedRowIndices.length > 0)
{
this.get('tableComponent.tableViewController.stateData').addSelectedRowIndexList(selectedIndiceskeyName, selectedRowIndices);
}
}
else
{
this.set("tableComponent.selectedRowIndices", Em.A([]));
if(selectedPkcols.length > 0)
{
this.get('tableComponent.tableViewController.stateData').removeSelectedRowIndexList(rowSelkeyName, selectedPkcols);
}
if(selectedRowIndices.length > 0)
{
this.get('tableComponent.tableViewController.stateData').removeSelectedRowIndexList(selectedIndiceskeyName, selectedRowIndices);
}
}
}
event.stopPropagation();
}
});
App.ActionCell = Ember.Table.ECTableCell.extend({
templateName: "action-cell"
});
App.GmailStarredCell = Ember.Table.ECTableCell.extend({
templateName: "gmail-starred-cell",
visible : true,
click : function(e)
{
if(jQuery(e.target).attr("class").indexOf("glyphicon-star") > -1)
{
this.toggleProperty("visible");
e.stopPropagation();			
}
}
});
App.MultipleLinksSourceCell = Ember.Table.ECTableCell.extend(MC.McDialogMixin,{
templateName: "multipleLinksSourceCell"
});
App.DrillDownViewSourceCell = Ember.Table.ECTableCell.extend(MC.McDialogMixin,{
templateName: "drillDownViewSourceCell"
});
App.JSActionCell = Ember.Table.ECTableCell.extend({
templateName: "jsaction-cell",
actions: {
jsActionTrigger: function(functionString) {
new Function(functionString)();
}
}
});
App.MultipleLinksActionCell = Ember.Table.ECTableCell.extend({
templateName: "multipleLinkActionCell"
});
App.DrillDownViewAsMenuItemStatusCell = Ember.Table.ECTableCell.extend({
templateName: "drillDownViewAsMenuItemStatusCell"
});
App.MenuPopupActionCell = Ember.Table.ECTableCell.extend(Ember.Table.RegisterTableComponentMixin, {
templateName: "menuPopupActionCell",
click : function(event)
{
var tableController = this.get("tableComponent.tableViewController");
tableController.clearAllPopups();
tableController.get("popupQueue").pushObject({target :event.target, controller : tableController});
}
});
