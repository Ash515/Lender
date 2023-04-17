var _viewDataObject = new Array();
var _viewNames = new Array();
var _originalViewNames = new Array();
var _insId = null;
var _layoutType = 'SingleColumn';
var _configName = "";
function initPSLayout(dataObject, insertionId, type){
_layoutType = type;
_viewDataObject = dataObject;
var viewDetails = _viewDataObject.getRowsForTable("TmpViewDetails");
viewDetails[0][COMPONENTNAME] = "ACPSTable";
viewDetails[0]["PSCONFIG"] = _configName;
_configName = viewDetails[0][VIEWNAME];
var validViewCount = 0;
if(!_viewDataObject.containsTable('ACPSConfiguration')){
var tablerows = _viewDataObject.getRowsForTable("TmpViewColumn");
for(var index in tablerows){
var colAl = tablerows[index][COLUMNALIAS];
if(tablerows[index][VISIBLE]== "true"){
addPSConfigTable(validViewCount,"0","Label",tablerows[index][DISPLAYNAME]);
addPSConfigTable(validViewCount,"1","FieldValue",colAl);
validViewCount++;
}
}		
}
validViewCount = 0;
var psConfigRows = _viewDataObject.getRowsForTable("ACPSConfiguration");
for(var index in psConfigRows){
if(psConfigRows[index]["DATATYPE"] == "FieldValue"){
_viewNames[validViewCount] = psConfigRows[index]["DATAVALUE"];
_originalViewNames[validViewCount] = psConfigRows[index]["DATAVALUE"];
validViewCount++;
}
}
_insId = insertionId;
showGrid(constructLayout());
}
function constructLayout() {
_viewDataObject.deleteAllRowsInTable("ACPSConfiguration","CONFIGNAME",_configName);
for(var name in _viewNames){
var rowObj = _viewDataObject.getFirstRow("TmpViewColumn",COLUMNALIAS,_viewNames[name]);
addPSConfigTable(name,"0","Label",rowObj[DISPLAYNAME]);
addPSConfigTable(name,"1","FieldValue",rowObj[COLUMNALIAS]);
}
if(_layoutType == 'SingleColumn'){
return constructSingleColumnGrid();
}
draggedViewName = null;
}
function constructSingleColumnGrid() {
var grid = "<TABLE id='editTable' cellspacing='2' align='center' border='0'>";
var size = _viewNames.length;
for(var count = 0; count < size; count++){
var html = document.getElementById("GridView").innerHTML;
var rowObject = _viewDataObject.getFirstRow("TmpViewColumn",COLUMNALIAS,_viewNames[count]);
var colRow = _viewDataObject.getFirstRow("ACPSConfiguration",COLUMNALIAS,_viewNames[count]);
var newHtml = html.replace(/\$ID/g, count);
newHtml = newHtml.replace('$VN', "");
newHtml = newHtml.replace('$DISPLAYNAME', rowObject[DISPLAYNAME]);
newHtml = newHtml.replace(/\$TITLE/g, rowObject[COLUMNALIAS]);
grid = grid.concat("<TR><TD ");
if(draggedViewName != null && draggedViewName == colRow[COLUMNALIAS]){
grid = grid.concat(" class='lastDragged'")
}
grid = grid.concat(" id='_evInd' onMouseOver='enableViewSelection(document.getElementById(\"_ev" + count + "\"))'>"+newHtml+"</TD></TR>");
}
grid = grid.concat("</TR></TABLE>");
return grid;
}
var currentGrid = null;
var draggedViewName = null;
function showGrid(grid){
currentGrid = grid;
setTimeout("dummy()",1);
}
function dummy(){
document.getElementById(_insId).parentNode.parentNode.parentNode.innerHTML = "<table style='border:1px #FF0000' cellpadding='0' cellspacing='1' bgcolor='#CBC0AB'><tr id='previewTableContainerRow' class='tableHeader'><td>" + currentGrid + "</td></tr></table>";
}
function insertView(draggedViewObj, insertId){
draggedViewName  = draggedViewObj.getAttribute("viewName");
var draggedViewTitle  = draggedViewObj.getAttribute("title");
var viewObject = new Array(draggedViewName, draggedViewTitle);
var insertBefore = document.getElementById(insertId).getAttribute('viewId');
var valid = false;
if(insertId.indexOf('_ev') >= 0){
if(insertBefore >= 0){
_viewNames.splice(insertBefore, 0, viewObject);	
valid = true;
}
else {
_viewNames[_viewNames.length] = viewObject;
valid = true;
}
}
if(valid) {
showGrid(constructLayout());
}
return valid;
}
function changeView(htmlObject, insertId){
var insertBefore = document.getElementById(insertId).getAttribute('viewId');
var currentId = htmlObject.getAttribute('viewId');
draggedViewName  = htmlObject.getAttribute("viewName");
var viewObject = _viewNames[currentId];
var valid = false;
if(insertId.indexOf('_ev') >= 0){
if(insertBefore >= 0){
if(insertBefore < currentId){
_viewNames.splice(currentId, 1);	
_viewNames.splice(insertBefore, 0, viewObject);	
}
else {
_viewNames.splice(insertBefore, 0, viewObject);	
_viewNames.splice(currentId, 1);	
}
valid = true;
}
else {
_viewNames.splice(currentId, 1);	
_viewNames[_viewNames.length] = viewObject;
valid = true;
}
}
if(valid) {
showGrid(constructLayout());
}
return valid;
}
function resetGrid(){
_viewNames = new Array();
for(var i = 0; i < _originalViewNames.length; i++){
_viewNames[i] = _originalViewNames[i];
}
showGrid(constructLayout());
}
function addPSConfigTable(rowIndex, columnIndex, dataType, dataValue){
_viewDataObject.addRowsForTable("ACPSConfiguration",
new Array(new Array("CONFIGNAME", _configName),
new Array("ROWINDEX",rowIndex),
new Array("COLUMNINDEX",columnIndex),
new Array("DATATYPE",dataType),
new Array("DATAVALUE",dataValue)
));
}
