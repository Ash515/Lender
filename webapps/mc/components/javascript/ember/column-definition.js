Ember.ECTable.ColumnDefinition = Ember.Table.ColumnDefinition.extend({
isSortable: true,
isSearchEnabled: false,
borderEnabled: true,
checkedProp :false,
sortEnabled: false,
savedWidth : 180,
textAlign: 'text-align-left',
headerCellView: 'Ember.Table.ECHeaderCell',
tableCellView: 'Ember.Table.ECTableCell',
canAutoResize : true,
sort: function(event) {},
getCellContent: function(row) {
var columnName = this.columnName;
var colIndex = this.get("tableComponent.columnVsIndex")[columnName];
if (row.get("cells"))
{
var cellObj = row.get("cells")[colIndex];
if(cellObj)
{
return cellObj;
}
else {return {"value" : ""};}
}
}
});
