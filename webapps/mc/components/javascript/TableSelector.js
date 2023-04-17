function TablePickList(srcTableViewId,destTableViewId,indexColumns,modelChangedListener)
{
this.indexColumns = indexColumns;
this.srcTableViewId = srcTableViewId;
this.destTableViewId = destTableViewId;
this.iColIndexMapping = null;
this.diColIndexMapping = null;
this.allColIndexMapping = null;
this.modelChangedListener = modelChangedListener;
this.getSrcRowIndices = function()
{
var srcTblModel = TableModel.getInstance(this.srcTableViewId);
var destTblModel = TableModel.getInstance(this.destTableViewId);
var selectedRows = new Array();
for(var i =0,j = srcTblModel.getRowCount(); i < j;i++)
{
for(var k=0,l = destTblModel.getRowCount();k < l;k++)
{
if(this.isEqual(srcTblModel.getRow(i),destTblModel.getRow(k)))
{
selectedRows.push(i);
break;
}
}
}
return selectedRows;
}
this.isEqual = function(srcRow,destRow)
{
this.genColIndexPos();
for(var i = 0; i < this.iColIndexMapping.length; i++)
{
if(srcRow[this.iColIndexMapping[i]] != destRow[this.diColIndexMapping[i]])
{
return false;
}
}
return true;
}
this.genColIndexPos = function()
{
if(this.iColIndexMapping != null)
{
return;
}
var srcTblModel = TableModel.getInstance(this.srcTableViewId);
var destTblModel = TableModel.getInstance(this.destTableViewId);
this.iColIndexMapping = new Array(indexColumns.length);
this.diColIndexMapping = new Array(indexColumns.length);
for(var i =0;i < this.indexColumns.length; i++)
{
this.iColIndexMapping[i] = srcTblModel.getColumnIndex(this.indexColumns[i]);
this.diColIndexMapping[i] = destTblModel.getColumnIndex(this.indexColumns[i]);
}
}
this.updateSrcColumn = function(colName,htmlValue)
{
var srcTblModel = TableModel.getInstance(this.srcTableViewId);
var colIndex = srcTblModel.getViewIndexForCol(colName);
var rows = this.getSrcRowIndices();
for(var i =0; i < rows.length; i++)
{
srcTblModel.getCell(rows[i],colIndex).innerHTML = htmlValue; 
}
}
}
