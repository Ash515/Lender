(function(){
MC.PsTableComponent = MC.TableViewComponent.extend({
layoutName : "components/ps-table",
getRowsForVertical : function(data, columns)
{
var rows = Ember.A([]);
for (var i = 0; i < columns.length; i++) {
var colName = columns[i].columnName;
if (colName.toUpperCase() === "CHECKBOX" || colName.toUpperCase() === "RADIO"){	continue; }
var cells = [];
cells.pushObject({"value" : Ember.String.htmlSafe("<b>"+colName+"</b>")});
cells.pushObject({"value" : Ember.String.htmlSafe(data.cells[columns[i].colIndex].value)});
rows.pushObject({"cells" : cells});
}
return rows;
},
getRows : function(data, columns)
{
tableData = Ember.A([]);
for (var j = 0; j < data.length; j++) {
tableData.push(this.getRowsForVertical(data[j], columns));
}
return tableData;	
},
updateTableColumns : function(tableColumns, rows)
{
var index = tableColumns.length;
var j = 0 ;
for (index; j < 2; index++, j++) {
tableColumns[index] = this.getColumnDefinition();
var colName = "COLNAME" + j;
tableColumns[index].set('columnName', colName);
tableColumns[index].set('displayName', colName);
tableColumns[index].set('colIndex', j);
tableColumns[index].set('headerClass', "ember-table-content");
tableColumns[index].set('isResizable', false);
tableColumns[index].set('canAutoResize', true);
}
},
getColumnDefinition : function()
{
return Ember.ECTable.ColumnDefinition.create({
getCellContent: function(row) {
if (row.get("cells"))
{	
return row.get("cells")[this.colIndex];
}
return "";
}
});
}
});
Ember.Handlebars.helper('ps-table', MC.PsTableComponent);})();
