(function(){
MC.VerticalTableComponent = MC.TableViewComponent.extend({
layoutName : "components/vertical-table",
getRows : function(data, columns)
{
var rows = Ember.A([]);
for (var i = 0; i < columns.length; i++) {
var columnName = columns[i].columnName;
if (columnName.toUpperCase() === "CHECKBOX" || columnName.toUpperCase() === "RADIO"){	continue; }
var cellData = {}, cell = {};
cellData[0] = {"value" : Ember.String.htmlSafe("<b>" + columnName + "</b>")};
for (var j = 0, len = data.length; j < len; j++) {
cellData[(j + 1)] = {};
cellData[(j + 1)].value = Ember.String.htmlSafe(data[j].cells[columns[i].colIndex].value);
}
cell.cells = cellData;
rows.pushObject(cell);
}
return rows;		
},
updateTableColumns : function(tableColumns, rows)
{
var index = tableColumns.length;
var j = 0 ;
for (index; j < rows.length + 1; index++, j++) 
{
tableColumns[index] = this.getColumnDefinition();
var colName = "COLNAME" + j;
tableColumns[index].set('columnName', colName);
tableColumns[index].set('colIndex', j);
tableColumns[index].set('displayName', colName);
tableColumns[index].set('headerClass', "ember-table-content");
tableColumns[index].set('borderEnabled', true);
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
Ember.Handlebars.helper('vertical-table', MC.VerticalTableComponent);})();
