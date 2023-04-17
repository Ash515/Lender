function DataObject()
{
this.tableToRowList = new Object(); 
this.tableArray = new Array(0);
this.getRowsForTable = getRowsForTable;
this.addRowsForTable = addRowsForTable; 
this.containsTable = containsTable; 
this.addNewTable = addNewTable;
this.setColumn = setColumn;
this.deleteFirstRow = deleteFirstRow; 
this.deleteAllRowsInTable = deleteAllRowsInTable;  
this.getTables = getTables;
this.getRows = getRows; 
this.getFirstRow = getFirstRow; 
this.displayDO = displayDO; 
this.constructXML = constructXML; 
}
function getRowsForTable(tableName)
{
return this.tableToRowList[tableName]; 
}
function addRowsForTable(tableName,arr)
{
if(!this.containsTable(tableName))
{  
this.addNewTable(tableName);
}
var arrRows =  this.tableToRowList[tableName]; 
arrRows[arrRows.length]  = createRow(arr);   
return true;
}
function createRow(col)
{
var row = new Object();    
for(var i=0;i<col.length;i++ )
{
row[col[i][0]] = col[i][1]; 
}
return row;
}
function containsTable(tableName)
{
var count =  this.tableArray.length;
for (var i=0;i<count;i++)
{
if(this.tableArray[i] == tableName)
{
return true; 
}      
}
return false;
}
function addNewTable(tableName)
{ 
this.tableArray.push(tableName);
this.tableToRowList[tableName] = new Array(0);
return;
}
function setColumn(tableName,colName,value)
{
if(!this.containsTable(tableName))
{
return false;
}
var objArray = this.tableToRowList[tableName];
for(var i in objArray)
{
if(i=="each"||i=="prototype")
{
break;
}
for(var j in  objArray[i])
{
if(j=="each"||j=="prototype")
{
break;
}
if(j == colName)              
{ 
objArray[i][j]  = value;
}
} 
} 
return true; 
}
function deleteFirstRow(tableName,colName,value)  
{
if(!this.containsTable(tableName))
{
return false;
}
var objArray = this.tableToRowList[tableName];
var deleteRowObjectIndex = null;
for(var i in objArray)
{
if(i=="each"||i=="prototype")
{
break;
}
for(var j in  objArray[i])
{
if(j=="each"||j=="prototype")
{
break;
}
if(j == colName  && objArray[i][j] == value  )              
{ 
deleteRowObjectIndex = i;          
}
} 
}
objArray.splice(deleteRowObjectIndex,1);
this.tableToRowList[tableName] = objArray 
return true; 
}
function deleteAllRowsInTable(tableName,colName,value)    
{
if(!this.containsTable(tableName))
{
return false;
}
var objArray = this.tableToRowList[tableName];
var delRows = new Array(0);
for(var i in objArray)
{
if(i=="each"||i=="prototype")
{
break;
}  
for(var j in  objArray[i])
{
if(j=="each"||j=="prototype")
{
break;
}
if(j == colName  && objArray[i][j] == value  )              
{
delRows.push(i);   
}
} 
}
var tempArray = new Array(0);
var deleteRow = false; 
for(var i in objArray)
{
if(i=="each"||i=="prototype")
{
break;
}
deleteRow = false;
for(var j in delRows)
{
if(j=="each"||j=="prototype")
{
break;
}
if(i == delRows[j])
{
deleteRow = true;
} 
}  
if(!deleteRow) 
{
tempArray.push(objArray[i]);
}
}  
objArray = tempArray;
this.tableToRowList[tableName] = objArray 
return true; 
}
function getTables()
{
return this.tableArray;
}
function getFirstRow(tablename,columnname,value)
{
var tables = this.getTables(); 
var rows = this.getRowsForTable(tablename);
for(var index in rows)
{
if(index=="each"||index=="prototype")
{
break;
}
for(var name in rows[index]) 
{	
if(name=="each"||name=="prototype")
{
break;
}
if(rows[index][name] == value )     
{
return rows[index] ;    
}
}
}
return null;
}
function getRows(tablename,columnname,value)
{
var returnRows = new Array(0);
var rows = this.getRowsForTable(tablename);
for(var index in rows)
{
if(index=="each"||index=="prototype")
{
break;
}
for(var name in rows[index]) 
{
if(name=="each"||name=="prototype")
{
break;
}
if(name == columnname && rows[index][name] == value )     
{
returnRows.push(rows[index]) ;    
}
}
}
return returnRows;
}
function displayDO()
{
var tables = this.getTables(); 
var content = ""; 
for(var k in tables)
{
if(k=="each"||k=="prototype")
{
break;
}
var rows = this.getRowsForTable(tables[k]);
content = content + "<br>Table  :"+tables[k]; 
for(var index in rows)
{
if(index=="each"||index=="prototype")
{
break;
}
for(var name in rows[index]) 
{
if(name=="each"||name=="prototype")
{
break;
}
content = content + "<br>Row number"+ index + ":    " +"<i>Property name </i>   " + name + "   <i>Value</i>   " +rows[index][name] + "      ";
}
content = content + "<br>"; 
}
}
return content;
}
function constructXML()
{
var tables = this.getTables();
var outputXML = "<Data>"; 
for(var k in tables)
{
if(k=="each"||index=="prototype")
{
break;
}
var rows = this.getRowsForTable(tables[k]);
for(var index in rows)
{
if(index=="each"||index=="prototype")
{
break;
}
outputXML = outputXML + "<" + tables[k] ;
for(var columnname in rows[index])
{
if(columnname=="prototype"||columnname=="each")
{
break;
}
if(isNaN(columnname)){
if( typeof(rows[index][columnname]) == "string" &&  rows[index][columnname].indexOf("null") == -1  && (!((rows[index][columnname]).length == 0)))
{
var value = rows[index][columnname];
if(value.indexOf("&") != -1)
{
value = value.replace("&","&amp;");
}
outputXML = outputXML +" " + columnname+ "=\"" + value +"\" " ;
}   
else if(typeof(rows[index][columnname]) != "string"  && (!((rows[index][columnname]).length == 0)))
{
outputXML = outputXML +" " + columnname+ "=\"" + rows[index][columnname] +"\" " ;
}
}
}
outputXML = outputXML + "/>"
}
} 
outputXML = outputXML +  "</Data>";
return outputXML;
}
function demo()
{
var daob = new DataObject();
daob.addRowsForTable("table1",new Array(new Array("prop1","value1"),new Array("prop2","value2")));
daob.addRowsForTable("table1",new Array(new Array("prop1","value3"),new Array("prop2","value4")));
daob.addRowsForTable("table2",new Array(new Array("prop1","value1"),new Array("prop2","value2")));
var rows = daob.getRowsForTable("table1");
document.write("<B>Initial values</B><br>"); 
document.write(daob.displayDO());
daob.setColumn("table1","prop1","newValue") ;
document.write("<br><br><B>After Updation:</B><br>")
document.write(daob.displayDO());
document.write("<br><br><B>Get Tables:</B><br>")
var tableNameArray = daob.getTables()
for(var k in tableNameArray)
{
if(k=="each"||k=="prototype")
{
break;
}
document.write("<br>Table "+ k + " :  "+tableNameArray[k])   
}
daob.deleteAllRowsInTable("table1","prop1","newValue")   
document.write("<br><br><B>After Deletion:</B><br>")
document.write(daob.displayDO());
}
