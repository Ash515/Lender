function ClientTableModel(uniqueId, columnNames) {
this.uniqueId = uniqueId;
this.columnNames = columnNames;
this.tableRows = new Array();
ClientTableModel._TBL_TABLEMODEL_MGR[uniqueId] = this;
this.addRows = function(tableModelRows) {
for (var i = 0; i < tableModelRows.length; i++) {
this.tableRows[this.tableRows.length] = tableModelRows[i];
}
}
this.getRow = function(rowIndex) {
return this.tableRows[rowIndex];
}
this.getValueAt = function(rowIndex, columnIndex) {
if (!this.tableRows || this.tableRows.length == 0) {
return;
}
if (rowIndex < 0 || columnIndex < 0) {
return;
}
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
ClientTableModel._TBL_TABLEMODEL_MGR = {};
ClientTableModel.getInstance = function(srcViewRefId) {
return ClientTableModel._TBL_TABLEMODEL_MGR[getUniqueId(srcViewRefId)];
}
function ClientTableDOMModel(srcViewRefId, columnNames, viewCols, rowSelection) {
this.viewCols = viewCols;
this.base = ClientTableModel;
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
var _selectedRowIndices = StateData.getInstance(this.uniqueId).getSelectedRowIndices("selectedRowIndices");
if (!_selectedRowIndices) {
return [];
}
return _selectedRowIndices;
}
}
ClientTableDOMModel.prototype = new ClientTableModel();
function getSelectedRows(uniqueId) {
return ClientTableModel.getInstance(uniqueId).getSelectedRowIndices();
}
function setTableDOMModel(tableModel) {
var _ETM = new ClientTableDOMModel(tableModel.uniqueId,
tableModel.columnNames, tableModel.viewColumns,
tableModel.rowSelectionType);
_ETM.addRows(tableModel.tableModelRows);
}
