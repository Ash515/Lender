var onfocusElem;
var columnCount = 0;
var firstInputFieldID;
var DISPLAYNAMEMAXLENGTH = 20;  
var SEARCH_IMG = "_srch_img";
var SORT_IMG = "_sort_img";
var LINK_CONTENT = "_link_content";  
var PREFIX_CONTENT = "_prefix";
var SUFFIX_CONTENT = "_suffix";
var PREFIX_ICON_CONTENT = "_prefix_icon";
var SUFFIX_ICON_CONTENT = "_suffix_icon";
var _showPreview = true;           
function setMouseHoverSelection(topCellId)
{   
var topCell = getObj(topCellId);  
var tableObj = getTable(topCell);
if(onfocusElem != null && tableObj.id != onfocusElem.id)
{
tableObj.className = "MouseHoverStyle";
}
}
function setMouseOut(topCellId)
{   
var topCell = getObj(topCellId);  
var tableObj = getTable(topCell);                
if(onfocusElem != null && tableObj.id != onfocusElem.id)
{
tableObj.className = "MouseOutStyle";   
}
}
function TableSelection(topCellId)
{   
var topCell = getObj(topCellId);  
var tableObj = getTable(topCell);
var prevFocus = onfocusElem;
onfocusElem = tableObj;
if(prevFocus != null)
{
prevFocus.className = "MouseOutStyle";      
focusLost(prevFocus.id);
}
tableObj.className = "TableSelection";        
resetAllUIComponents();
showColumnPropertiesInUI(tableObj.id);
}
function getTable(tdObj)
{
var parent = tdObj.parentNode;                  
var flag = true;
while(parent != null && flag )
{ 
if(parent.tagName.indexOf("TABLE") != -1 || parent.tagName.indexOf("table") != -1  )
{  
flag = false;
return parent;  
}
else
{
parent = parent.parentNode; 
}
}
}
function getObj(n,d) {
var p,i,x; 
if(!d)
d=document;
if((p=n.indexOf("?"))>0 && parent.frames.length) {
d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);
}
if(!(x=d[n])&&d.all)
{
x=d.all[n];
}
for(i=0;!x&&i<d.forms.length;i++)
{
x=d.forms[i][n];
}
for(i=0;!x&&d.layers&&i<d.layers.length;i++)
{
x=getObj(n,d.layers[i].document);
}
if(!x && d.getElementById)
{
x=d.getElementById(n);
}
return x;
}
function initializeEmptyDataObject()
{
daob.addRowsForTable("TmpViewDetails",new Array(new Array(VIEWNAME,""),new Array(TITLE,""),new Array(ICON,""),new Array(IMAGE,""),new Array(DESCRIPTION,""),new Array(DISPLAYTYPE,"Horizontal"),new Array(EMPTY_TABLE_MESSAGE,""),
new Array(ENABLECOLUMNCHOOSER,""),new Array(ENABLEROWSELECTION,""),new Array(OPERATOR,""),new Array(COMPONENTNAME,"ACTable")));  
}
function addColumnToTable(isDummy,colId,continous)
{
var idAndName ;
var isCreate = false;
var previewTableContainerRow = document.getElementById('previewTableContainerRow');                 
if(!colId)
{
isCreate = true;  
}
if(previewTableContainerRow.cells.length == 0 && isCreate)
{
initializeEmptyDataObject();
}
var static_text = "";
if(isDummy == "true")
{
resetForStaticColumn();
static_text = "TEXT";
}
if(isCreate)    
{ 
if(isDummy == "true")    
{ 
idAndName = "$S_UVH@" + previewTableContainerRow.cells.length;                   
}
else
{ 
idAndName = "UVH@" + previewTableContainerRow.cells.length;                 
}
var columnName = "Untitled Column "+ columnCount  ;
columnCount++;  
daob.addRowsForTable("TmpViewColumn",new Array(new Array(COLUMNID,idAndName),new Array(TABLENAME,""),
new Array(COLUMNNAME,""),new Array(COLUMNINDEX, previewTableContainerRow.cells.length  ),
new Array(DISPLAYNAME,columnName),new Array(COLUMNALIAS,idAndName), 
new Array(VISIBLE,"true"),new Array(SORTENABLED,"true"), 
new Array(SEARCHENABLED,"false"),new Array(ACTIONNAME,""), 
new Array(CREATORCONFIG,""),new Array(DEFAULT_TEXT,""),
new Array(DATE_FORMAT,""),new Array(TRIM_LENGTH,""),
new Array(TRIM_MSG_LINK,""),new Array(PREFIX_TEXT,""),
new Array(SUFFIX_TEXT,""),new Array(SUFFIX_ICON,""),  
new Array(PREFIX_ICON,""),new Array(TABLEALIAS,""),  
new Array(LINKVIEWNAME,""),new Array(VIEWNAME,""),new Array(STATIC_TEXT,static_text)));
}  
else
{
var tmpViewCol = daob.getFirstRow("TmpViewColumn",COLUMNID,colId) ;
idAndName = colId;
}
if(!firstInputFieldID)
{
firstInputFieldID = idAndName;
}
var tableName = "tb" + (previewTableContainerRow.cells.length + 1); 
var row1id = (tableName+"rw1");
var row2id = (tableName+"rw2");
var row3id = (tableName+"rw3");
var dispNameId = "dispName" +idAndName;
var searchDivId = idAndName + SEARCH_IMG ;
var sortDivId = idAndName + SORT_IMG ;
var linkDivId = idAndName + LINK_CONTENT ;  
var prefixDivId = idAndName + PREFIX_CONTENT ;   
var suffixDivId = idAndName + SUFFIX_CONTENT ;     
var prefixIconDivId = idAndName + PREFIX_ICON_CONTENT ;   
var suffixIconDivId = idAndName + SUFFIX_ICON_CONTENT ;     
var existingHtml =    previewTableContainerRow.innerHTML;
existingHtml = existingHtml + "<td width='150' align=center>"+
"<table cellpadding='2' cellspacing='2' border='1' id=\"" + idAndName + "\" style='text-align: left; width: 100%; table-layout: fixed;' >"+
"<tbody><tr><td width='150' class='tableHeader'  id=\"" + row1id  +"\" onmouseover='setMouseHoverSelection(\""+ row1id  +"\")'  onmouseout='setMouseOut(\""+ row1id  +"\")'  onmousedown='TableSelection(\""+ row1id  +"\")' >"+                                                
"<TABLE  style='width: 100%; '><tbody>" +                                                                                        
"<tr><td><label id=\""+ dispNameId + "\">" + columnName    + " </label></td>" +                                             
"<td align='right'><DIV id=\"" + searchDivId  + "\"><br></DIV></td>"+
"<td align='right'><DIV id=\"" + sortDivId  + "\"><br></DIV></td>"+
"</tr></tbody></TABLE>"+
"</td></tr><tr><td  width='150'   class='evenRow'  id=\"" + row2id  +"\"  onmouseover='setMouseHoverSelection(\""+ row1id  +"\")' onmouseout='setMouseOut(\""+ row1id  +"\")'  onmousedown='TableSelection(\""+ row1id  +"\")' >"+
"<Table  cellpadding='0' cellspacing='0' style='width: 100%; ' ><tbody>" +                                                                                        
"<tr>" + 
"<td width='10%' align='right'><DIV id=\"" + prefixIconDivId + "\" align='right' ></DIV></td>"+ 
"<td width='15%' align='right'><DIV id=\"" + prefixDivId + "\" align='right' ></DIV></td>"+
"<td width='50%' align='center'><DIV id=\"" + linkDivId + "\" align='center' ></DIV></td>"+
"<td width='25%' align='left'><DIV id=\"" + suffixDivId  + "\" align='left'><br></DIV></Td>"+
"<td width='10%' align='left'><DIV id=\"" + suffixIconDivId + "\" align='left' ></DIV></td>"+ 
"</tr></tbody></Table>"+
"</td></tr><tr><td  width='150' class='oddRow' id=" + row3id  +"   onmouseover='setMouseHoverSelection(\""+ row1id +"\")' onmouseout='setMouseOut(\""+ row1id  +"\")'  onmousedown='TableSelection(\""+ row1id  +"\")' ><br>"+
"</td></tr></tbody></table></td>";
previewTableContainerRow.parentNode.parentNode.parentNode.innerHTML = "<table style='border:1px #FF0000' cellpadding='0' cellspacing='1' bgcolor='#CBC0AB'><tr id='previewTableContainerRow' class='tableHeader'>" + existingHtml + "</tr></table>";
updatePreview(idAndName);
resetAllSelection();
if(!continous)
{
var prevFocus = onfocusElem;
if(prevFocus != null)
{
prevFocus.className = "MouseOutStyle";      
focusLost(prevFocus.id);
}
onfocusElem = document.getElementById(idAndName);
onfocusElem.className = "TableSelection";                
resetAllUIComponents();
showColumnPropertiesInUI(onfocusElem.id);
}
}
function deleteColumnFromTable(colId)
{
var delColId = colId;  
if(!colId)
{
delColId = onfocusElem.id;
} 
if(delColId)
{
var delRow = daob.getFirstRow("TmpViewColumn",COLUMNID,delColId)      
var delColIndex = delRow[COLUMNINDEX] ;              
daob.deleteFirstRow("TmpViewColumn",COLUMNID,delColId);
var colRows = daob.getRowsForTable("TmpViewColumn"); 
for(var i=0;i<colRows.length;i++)
{
if( colRows[i][COLUMNINDEX] > delColIndex )
{ 
colRows[i][COLUMNINDEX] = (colRows[i][COLUMNINDEX] ) - 1;
}  
}    
var previewTableContainerRow = document.getElementById('previewTableContainerRow');                 
previewTableContainerRow.parentNode.parentNode.parentNode.innerHTML = "<table style='border:1px #FF0000' cellpadding='0' cellspacing='1' bgcolor='#CBC0AB'><tr id='previewTableContainerRow' class='tableHeader'></tr></table>";
constructTableFromDO();
var nextRow = daob.getFirstRow("TmpViewColumn",COLUMNINDEX,delColIndex);
var tableElem ; 
if(nextRow)            
{                
tableElem =  document.getElementById(nextRow[COLUMNID]);    
}
else
{
var prevRow = daob.getFirstRow("TmpViewColumn",COLUMNINDEX,delColIndex-1);
if(prevRow)            
{                     
tableElem =  document.getElementById(prevRow[COLUMNID]);    
}
} 
if(tableElem)
{
onfocusElem = tableElem;
tableElem.className = "TableSelection";
resetAllUIComponents();
showColumnPropertiesInUI(tableElem.id,true);                    
updatePreview(tableElem.id);
}
else
{
resetAllUIComponents();
} 
}
}
function showColumnPropertiesInUI(colId, showPreview)
{
_showPreview = showPreview;
var row = daob.getFirstRow("TmpViewColumn",COLUMNID,colId)    
var tableElem = document.getElementById("COLUMN_PROPERTIES");     
var inputList = tableElem.getElementsByTagName("INPUT");
if(colId.indexOf("$S_") == 0)
{
resetForStaticColumn();
}
for(var i=0;i<inputList.length;i++)
{
if(inputList.item(i).type != "button"  )
{ 
switch(inputList.item(i).name){
case "LINKVIEW_OR_ACTIONNAME" :
if(row[LINKVIEWNAME]) 
{
inputList.item(i).value = row[LINKVIEWNAME] ;
}
else
{
inputList.item(i).value = row[ACTIONNAME] ;                                                 
}
break;
case SORTENABLED :
case SEARCHENABLED :
case VISIBLE :
case "ISNULLABLE" :
case "ISHEADERVISIBLE" :
if((row[inputList.item(i).name]).indexOf("true") != -1)
{
inputList.item(i).checked = true;
}
else
{
inputList.item(i).checked = false;
}
break; 
case "TABLENAME_COLNAME" :                       
if(colId.indexOf("$S_") == 0)
{
inputList.item(i).value = row[STATIC_TEXT];
}   
else if(row[TABLENAME]  && row[COLUMNNAME])   
{  
var tableName = row[TABLENAME];
var colName = row[COLUMNNAME];                             
inputList.item(i).value = tableName + "." + colName;
}
break;
case "ISLINKVIEW" :
if(row[LINKVIEWNAME]) 
{
inputList.item(i).value = "true" ;
}
else
{
inputList.item(i).value = "false" ;                                                 
}
break;
default:             
inputList.item(i).value = row[inputList.item(i).name];
}     
}
}
updatePreview(colId);                  
var selectList = tableElem.getElementsByTagName("select");
for(var i=0;i<selectList.length;i++)
{
switch(selectList.item(i).name){
case DATE_FORMAT :
selectList.item(i).value = row[selectList.item(i).name];
break;
}
}
}
function focusLost(storeId)
{
var prevId ;  
if(storeId)
{
prevId = storeId;       
}
else
{
if(onfocusElem){
prevId = onfocusElem.id;
}
else if(selectedView != null){
prevId = selectedView;
}
}
var row = daob.getFirstRow("TmpViewColumn",COLUMNID,prevId)    
var tableElem = document.getElementById("COLUMN_PROPERTIES");     
var inputList = tableElem.getElementsByTagName("INPUT");
for(var i=0;i<inputList.length;i++)
{
switch(inputList.item(i).name){
case "LINKVIEW_OR_ACTIONNAME" :
if(document.getElementById("ISLINKVIEW").value == "true") 
{
row[LINKVIEWNAME] = inputList.item(i).value;
}
else
{
row[ACTIONNAME] = inputList.item(i).value;
}
break;
case SORTENABLED :
case SEARCHENABLED :
case VISIBLE :
case "ISNULLABLE" :
case "ISHEADERVISIBLE" :
if(inputList.item(i).checked)
{
row[inputList.item(i).name]  = "true";
}
else
{
row[inputList.item(i).name]  = "false"; 
}
break; 
case "TABLENAME_COLNAME" : 
if(storeId.indexOf("$S_") == 0) 
{
row[STATIC_TEXT] = inputList.item(i).value;
}  
else
{  
var comboName = inputList.item(i).value;
var values = comboName.split(".");
var tableName = values[0];
var colName = values[1];                             
if(tableName) 
{    
row[TABLENAME] = tableName;                          
}
if(colName)  
{   
row[COLUMNNAME] = colName;                          
row[COLUMNALIAS] = colName;                          
}
} 
break;
default:             
row[inputList.item(i).name] = inputList.item(i).value ;
}
}
var selectList = tableElem.getElementsByTagName("select");
for(var i=0;i<selectList.length;i++)
{
switch(selectList.item(i).name){
case DATE_FORMAT :                            
row[selectList.item(i).name] = selectList.item(i).value ;                             
break;
}
}
}
function resetAllUIComponents()
{ 
var tableElem = document.getElementById("COLUMN_PROPERTIES");     
var inputList = tableElem.getElementsByTagName("INPUT");  
for(var i=0;i<inputList.length;i++)
{
if(inputList.item(i).type != "button"   )
{
inputList.item(i).value = "";
}
}
var selectList = tableElem.getElementsByTagName("SELECT");  
for(var i=0;i<selectList.length;i++)
{
selectList.item(i).selectedIndex = 0;
}
var DBColumnLabel = document.getElementById("DBColumn");                                                                                 
DBColumnLabel.innerHTML = "DB Column";
document.ViewCreationPropsForm.SEARCHENABLED.disabled = false;
document.ViewCreationPropsForm.SORTENABLED.disabled = false;
var defText = document.getElementById("DEFAULT_TEXT");                                                                                 
defText.disabled  = false;
var dateFormat = document.getElementById("DATE_FORMAT");                                                                                 
dateFormat.disabled  = false;
}
function newWin(url, name, w, h) {
l = (screen.availWidth-10 - w) / 2;
t = (screen.availHeight-20 - h) / 2;
features = "width="+w+",height="+h+",left="+l+",top="+t;
features += ",screenX="+l+",screenY="+t;
features += ",scrollbars=0,resizable=0,location=0";
features += ",menubar=0,toolbar=0,status=0";
window.open(url, name, features);
}
function handleSubmit()
{
if(document.ViewCreationPropsForm.submitted)
{
if(onfocusElem)
{
focusLost(onfocusElem.id);
}
var viewDetails = daob.getRowsForTable("TmpViewDetails")    
var viewDetailsRow = viewDetails[0];
var viewCols = daob.getRowsForTable("TmpViewColumn")    
for(var index in viewCols)   
{   
if(index=="each"||index=="prototype")
{
break;
}
if(!viewCols[index][COLUMNNAME].length > 0 &&  (!viewCols[index][STATIC_TEXT].length > 0))  
{
alert("Enter the column name for column "+viewCols[index][COLUMNINDEX]);  
return false; 
}
if(!viewCols[index][DISPLAYNAME].length > 0)  
{
alert("Enter the display name for column "+viewCols[index][COLUMNINDEX]);  
return false; 
}
}
if(!viewDetailsRow[TITLE] && document.ViewCreationPropsForm.viewtitle.value.length == 0)
{
newWin("components/jsp/cvtab/viewcreation/GetViewTitle.html","Custom View Title",250,50);
return false;
}
if(!viewDetailsRow[TITLE])
{
var title =document.ViewCreationPropsForm.viewtitle.value;
viewDetailsRow[TITLE] = title;
viewDetailsRow[VIEWNAME] = title.replace(" ","_") ;
}
var viewColumns = daob.getRowsForTable("TmpViewColumn")    
for(var index in viewColumns)   
{   if(index=="each"||index=="prototype")
{
break;
}
if((viewColumns[index][COLUMNID].indexOf("$S_") != -1 ) )  
{ 
var tempStr = viewColumns[index][COLUMNID];
viewColumns[index][COLUMNID] =  tempStr.substr(3,tempStr.length)                                              
}
}
document.ViewCreationPropsForm.xmlData.value = daob.constructXML();     
AjaxAPI.submit(document.ViewCreationPropsForm);
return true; 
}
else 
return false;
}
function handleMoreElements()
{
alert("Handle if there are more elements here")
}
function updateDisplayName(dispName,colId)
{
var dispNameLabel = document.getElementById("dispName"+colId);                                                                                
if(dispNameLabel != null)
{
dispName = getTruncatedValue(dispName);
dispNameLabel.innerHTML = dispName;
}
}
function keyUpUpdate(inFld,toUpdateFld){
var valueToUpdate = inFld.value;
switch(toUpdateFld)
{
case "DISPLAYNAME"  :
updateDisplayName(valueToUpdate,onfocusElem.id);
focusLost();
break;
case "PREFIX_TEXT" :                 
case "SUFFIX_TEXT" :                        
case "PREFIX_ICON" :                        
case "SUFFIX_ICON" :                        
focusLost();
updatePreview();
break; 
}
}
function updatePreview(colId)
{
if(!_showPreview){
return;
}
var columnIdentity; 
if(!colId)
{ 
if(onfocusElem){
columnIdentity = onfocusElem.id; 
}
else if(selectedView != null){
columnIdentity = selectedView;
}
} 
else
{
columnIdentity = colId; 
}   
var row = daob.getFirstRow("TmpViewColumn",COLUMNID,columnIdentity)    
var dispName = row[DISPLAYNAME];                
updateDisplayName(dispName,columnIdentity);
var searchEnabled = row[SEARCHENABLED];                
var searchDiv = document.getElementById( columnIdentity + SEARCH_IMG );     
if(searchEnabled.indexOf("true")  ==  -1) 
{
searchDiv.innerHTML = "<br>" ;
}
else
{
searchDiv.innerHTML = "<IMG SRC='themes/opmanager/images/search.gif' >" ; 
}
var sortEnabled = row[SORTENABLED];                
var sortDiv = document.getElementById( columnIdentity + SORT_IMG );     
if(sortEnabled.indexOf("true")  ==  -1) 
{
sortDiv.innerHTML = "<br>" ; 
}
else
{
sortDiv.innerHTML = "<IMG SRC='themes/opmanager/images/sortDesc.gif' >" ;
}
var linkAction = row[ACTIONNAME];                
var linkViewName = row[LINKVIEWNAME];  
var linkDiv = document.getElementById( columnIdentity + LINK_CONTENT );     
var linkContent;
if(linkAction)              
{
linkContent = linkAction;
} 
else if(linkViewName)
{
linkContent = linkViewName;     
}
if(linkContent)
{
linkContent = getTruncatedValue(linkContent);    
linkDiv.innerHTML =  "<a href='#'>"+ linkContent +"</a>";
}
else
{
linkDiv.innerHTML = "<br>";  
}
var prefixDiv = document.getElementById( columnIdentity + PREFIX_CONTENT );     
var prefixData = row[PREFIX_TEXT];                
if(prefixData)
{
prefixData = getTruncatedValue(prefixData,4);    
prefixDiv.innerHTML =  "&lt;"+ prefixData +"&gt;";
}
else
{
prefixDiv.innerHTML = "<br>";  
}
var suffixDiv = document.getElementById( columnIdentity + SUFFIX_CONTENT );     
var suffixData = row[SUFFIX_TEXT];                
if(suffixData)
{
suffixData = getTruncatedValue(suffixData,4);    
suffixDiv.innerHTML =  "&lt;"+ suffixData +"&gt;";
}
else
{
suffixDiv.innerHTML = "<br>";  
}
var prefixIcon  = row[PREFIX_ICON];                
var prefixIconDiv = document.getElementById( columnIdentity + PREFIX_ICON_CONTENT );     
if(!prefixIcon) 
{
prefixIconDiv.innerHTML = "<br>" ;
}
else
{
prefixIconDiv.innerHTML = "<IMG SRC='themes/opmanager/images/search.gif' >" ; 
}
var suffixIcon  = row[SUFFIX_ICON];                
var suffixIconDiv = document.getElementById( columnIdentity + SUFFIX_ICON_CONTENT );     
if(!suffixIcon) 
{
suffixIconDiv.innerHTML = "<br>" ;
}
else
{
suffixIconDiv.innerHTML = "<IMG SRC='themes/opmanager/images/search.gif' >" ; 
}
}
function getTruncatedValue(toTruncateValue,len)
{
var trunLen ;
if(len)          
{
trunLen = len
}
else
{
trunLen = DISPLAYNAMEMAXLENGTH;
}    
if(toTruncateValue.length  > trunLen)
{
toTruncateValue = toTruncateValue.substr(0,trunLen-2) ;           
toTruncateValue += "..";
}
return toTruncateValue;
}
function toggleAdvanced()
{
var adv =  document.getElementById("advanced");
if(adv.style.display == "block")
{ 
adv.style.display = "none";
}
else
{
adv.style.display = "block";
}
}
function constructTableFromDO()
{
var rows = daob.getRowsForTable("TmpViewColumn");
var tempArr = new Array();
for(var index in rows)
{ 
if(index=="each"||index=="prototype")
{
break;
}
tempArr.push(rows[index][COLUMNINDEX]);
}
tempArr = tempArr.sort(); 
for(var index in tempArr)
{
if(index=="each"||index=="prototype")
{
break;
}
for(var i in rows)
{  
if(index=="each"||index=="prototype")
{
break;
}
if(rows[i][COLUMNINDEX]  == tempArr[index]) 
{ 
if(rows[i][COLUMNID].indexOf("$S_"))
{ 
addColumnToTable("false",rows[i][COLUMNID] , "true");    
_showPreview = true;
updatePreview(rows[i][COLUMNID]);  
}
else
{
addColumnToTable("true",rows[i][COLUMNID] , "true");    
_showPreview = true;
updatePreview(rows[i][COLUMNID]);   
}     
} 
}
}
}
function resetAllSelection()
{
var tables =  document.getElementsByTagName("Table");
for(var i=0;i<tables.length;i++) 
{
if( tables[i].className  == "TableSelection"     ) 
{
tables[i].className = "MouseOutStyle";
} 
} 
}
function resetForStaticColumn()
{
document.ViewCreationPropsForm.SEARCHENABLED.disabled = true;
document.ViewCreationPropsForm.SORTENABLED.disabled = true;
var DBColumnLabel = document.getElementById("DBColumn");                                                                                 
DBColumnLabel.innerHTML = "STATIC TEXT";
var defText = document.getElementById("DEFAULT_TEXT");                                                                                 
defText.disabled  = true;
var dateFormat = document.getElementById("DATE_FORMAT");                                                                                 
dateFormat.disabled  = true;
}
