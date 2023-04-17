function EmberTableModel(uniqueId, columnNames) {
this.uniqueId = uniqueId;
this.columnNames = columnNames;
this.tableRows = new Array();
EmberTableModel._TBL_TABLEMODEL_MGR[uniqueId] = this;
this.add = function(colValues) {
var curRow = new Array();
var argv = arguments;
for (var i = 0; i < argv.length; i++) {
curRow[i] = argv[i];
}
this.tableRows[this.tableRows.length] = curRow;
}
this.getRow = function(rowIndex) {
return this.tableRows[rowIndex];
}
this.getValueAt = function(rowIndex, columnIndex) {
if (!this.tableRows || this.tableRows.length == 0) { return;}
if(rowIndex < 0 || columnIndex < 0) {return;}
return this.tableRows[rowIndex][columnIndex];
}
this.getColumnName = function(colIndex) {
return this.columnNames[colIndex];
}
this.getColumnIndex = function(columnName) {
return this.columnNames.indexOf(columnName);
}
this.getRowCount = function() {
return this.tableRows.length;
}
this.getColumnCount = function() {
return this.columnNames.length;
}
}
EmberTableModel._TBL_TABLEMODEL_MGR = {};
EmberTableModel.getInstance = function(srcViewRefId) {
return EmberTableModel._TBL_TABLEMODEL_MGR[getUniqueId(srcViewRefId)];
}
function EmberTableDOMModel(srcViewRefId, columnNames, viewCols, rowSelection) {
this.viewCols = viewCols;
this.base = EmberTableModel;
this.base(srcViewRefId, columnNames);
this.isAtleastOneChecked = function(errorMsg) {
if (this.rowSelection == "NONE") {
return true;
}
if (this.getRowCount() == 0) {
alert(I18N.getMsg("No Rows present in the table"));
return false;
}
var atleastOneChecked = this.getSelectedRowIndices().length > 0;
if (errorMsg && !atleastOneChecked) {
alert(errorMsg);
}
return atleastOneChecked;
}
this.getSelectedRowIndices = function() {
var _selectedRowIndices = store.getSelectedRowIndices(this.uniqueId + "_selectedRowIndices");
if (!_selectedRowIndices) {
return [];
}
return _selectedRowIndices;
}
}
EmberTableDOMModel.prototype = new EmberTableModel();
function getSelectedRows(uniqueId)
{
return EmberTableModel.getInstance(uniqueId).getSelectedRowIndices();
}
