var _methodContainer = null;
var viewObjects = new Object();
var originalViewObjects = new Object(); 
var originalViewNames = new Array();
var viewNames = new Array();
var _columnCount = 0;
var rowCount = 0;
var tableMatrix = new Array();
var _viewPropertyNames = new Array("VIEWID", "TITLE", "DESCRIPTION", "ROWINDEX", "COLUMNINDEX", "COLSPAN", "ROWSPAN");
var isStructureChanged = true;
var _dacName = "layoutDAC"; 
function initMethodContainer(personalizedView){
if(parent[personalizedView] != null){
_methodContainer = parent[personalizedView];
}
}
function invokeMethod(methodName, dataObj){
if(_methodContainer != null && _methodContainer[methodName] != null){
return _methodContainer[methodName](dataObj);
}
else
{
return parent[methodName](dataObj);
}
}
function addViewObject(viewProperties){
var count = _viewPropertyNames.length;
var rowObject = new Object();
var duplicateRow = new Object();
for(var i = 0; i < count; i++){
duplicateRow[_viewPropertyNames[i]] = viewProperties[i];
rowObject[_viewPropertyNames[i]] = viewProperties[i];
}
viewObjects[viewProperties[0]] = rowObject;
originalViewObjects[viewProperties[0]] = duplicateRow;
}
function addRuntimeObject(viewProperties){
var count = _viewPropertyNames.length;
var rowObject = new Object();
for(var i = 0; i < count; i++){
rowObject[_viewPropertyNames[i]] = viewProperties[i];
}
viewObjects[viewProperties[0]] = rowObject;
}
function init(views, columns, rows, dacName){
if(dacName != null){
_dacName = dacName;
}
originalViewNames = views;
_columnCount = columns;
rowCount = rows;
isStructureChanged = false;
if(views.length == 0){
_columnCount = 1; 
rowCount = 1;
isRowColAdded = true;
}
tableMatrix = new Array(rowCount);
for(var i = 0; i < rowCount; i++){
tableMatrix[i] = new Array(_columnCount);
}
isStructureChanged = true;
initTableMatrix();
reCalculateTableData();
invokeMethod("createTable");
}
function initTableMatrix(){
var size = originalViewNames.length;
for(var i = 0; i < size; i++){
var viewProps = viewObjects[originalViewNames[i]];
if(viewProps != null){
var viewName = viewProps["VIEWID"];
var rowSpan = parseInt(viewProps["ROWSPAN"]);
var colspan = parseInt(viewProps["COLSPAN"]);
var rowIndex = parseInt(viewProps["ROWINDEX"]);
var columnIndex = parseInt(viewProps["COLUMNINDEX"]);
if(rowIndex < 0){
continue;
}
tableMatrix[rowIndex][columnIndex] = viewName;
if(rowSpan > 1){
for(var rows = 1; rows < rowSpan; rows++){
tableMatrix[rowIndex + rows][columnIndex] = viewName;
}
}
if(colspan > 1){
for(var cols = 1; cols < colspan; cols++){
tableMatrix[rowIndex][parseInt(columnIndex,10) + cols] = viewName;
for(var rows = 1; rows < rowSpan; rows++){
tableMatrix[rowIndex + rows][columnIndex + cols] = viewName;
}
}
}
}
}
}
var canAddPlaceHolders = true
function reCalculateTableData(){
reset();
checkTableMatrix();
if(!isRowColAdded){
removeEmptyRows();
removeEmptyColumns();
}
else{
isRowColAdded = false;
}
if(canAddPlaceHolders){
checkAndAddEndPlaceHolders();
}
var size = tableMatrix.length;
var tempViews = new Array();
for(var rows = 0; rows < size; rows ++) {
var columns = tableMatrix[rows];
for(var cols = 0; cols < columns.length; cols++){
var viewName = tableMatrix[rows][cols];
if(viewName == "Dummy"+rows+cols){
invokeMethod("addRuntimeObject", new Array(viewName, "Dummy", null, rows, cols, 1, 1,rows,cols));		
var viewProps = viewObjects[viewName];
viewProps["ISDUMMY"] = true;
}
else if(viewName == "DummyEnd"+rows+cols){
invokeMethod("addRuntimeObject", new Array(viewName, "DummyEnd", null, rows, cols, 1, 1,rows,cols));		
var viewProps = viewObjects[viewName];
viewProps["ISDUMMY"] = true;
}
else{
var viewProps = viewObjects[viewName];
var x = viewProps["X"];
var y = viewProps["Y"];
if(cols != y){
var colspan = viewProps["COLSPAN"];
if(viewProps["ROWINDEX"] == -1 || viewProps["ROWINDEX"] == rows){
viewProps["COLSPAN"] = colspan + 1;
}
}
if(rows != x){
var rowspan = viewProps["ROWSPAN"];
viewProps["ROWSPAN"] = rowspan + 1;
}
}
var present = false;
for(var count = 0; count < tempViews.length; count ++){
if(tempViews[count] == viewName){
present = true;
break;
}
}
if(!present){
tempViews[tempViews.length] = viewName;
}
if(viewProps["ROWINDEX"] == -1){
viewProps["ROWINDEX"] = rows;
viewProps["COLUMNINDEX"] = cols;
}
viewProps["Y"] = cols;
viewProps["X"] = rows;
}
}
viewNames = tempViews;
invokeMethod("disableSelectedViews");
}
function reset(){
var size = originalViewNames.length;
if(rowCount <= 0 || _columnCount <= 0){
rowCount = 1;
_columnCount = 1;
tableMatrix = new Array(rowCount);
for(var i = 0; i < rowCount; i++){
tableMatrix[i] = new Array(_columnCount);
}
}
if(viewNames.length > 0){
size = viewNames.length;
}
for(var count = 0; count < size; count++){
var viewProps = null;;
if(viewNames.length > 0){
viewProps = viewObjects[viewNames[count]];
}
else {
viewProps = viewObjects[originalViewNames[count]];
}
if(viewProps != null){
viewProps["ROWSPAN"] = 0;
viewProps["COLSPAN"] = 0;
viewProps["ROWINDEX"] = -1;
viewProps["COLUMNINDEX"] = -1;
viewProps["X"] = -1;
viewProps["Y"] = -1;
}
}
}
function checkTableMatrix(){
removeDuplicateRows();
fillEmptyCells();
removeScatteredViews();
}
function removeDuplicateRows(){
for(rows = 0; rows < tableMatrix.length; rows ++) {
columns = tableMatrix[rows];
if(rows + 1 < tableMatrix.length){
columns1 = tableMatrix[rows + 1];
if(columns.toString() == columns1.toString()){
tableMatrix.splice(rows, 1);
rows--;
rowCount--;
}
}
}
}
function fillEmptyCells(){
for(var rows = 0; rows < rowCount; rows ++){
var columns = tableMatrix[rows];
for(cols = 0; cols < _columnCount; cols++){
iteratedViewName = tableMatrix[rows][cols];
if(iteratedViewName == null || iteratedViewName == _columnCount){
tableMatrix[rows][cols] = "Dummy" + rows + cols;
}
}
}
}
function removeScatteredViews(){
for(var viewCount = 0; viewCount < originalViewNames.length; viewCount++){
var minX = minY = maxX = maxY = 0;
var viewName = originalViewNames[viewCount];
var viewProps = viewObjects[viewName];
var isFirst = false;
for(var rows = 0; rows < tableMatrix.length; rows ++){
var columns = tableMatrix[rows];
for(var cols = 0; cols < columns.length; cols++){
var iteratedViewName = tableMatrix[rows][cols];
if(iteratedViewName == viewName){
if(!isFirst){
minX = rows;
minY = cols;
}
isFirst = true;
maxX = rows;
maxY = cols;
}
}
}
var isBreak = false;
for(var rows = minX; rows <= maxX; rows++){
for(var cols = minY; cols <= maxY; cols++){
var value = tableMatrix[rows][cols];
if(isBreak){
tableMatrix[rows][cols] = "Dummy" + rows + cols;
}
if(value != viewName){
isBreak = true;
}
}
}
}
}
var currentViewInEdit = null;
function enableEdit(index){
currentViewInEdit = viewNames[index];
isStructureChanged = false;
invokeMethod("createTable");
}
function disableEdit(){
currentViewInEdit = null;
isStructureChanged = false;
invokeMethod("createTable");
}
function constructRemovedViews(){
var size = removedViews.length;
if(size == 0){
return;
}
var count = 0;
var content = "";
var html = document.getElementById('RemovedGridView').innerHTML;
for(var i = size-1; i >= 0; i--){
var isPresent = false;
for(var j = 0; j < viewNames.length; j++){
if(viewNames[j] == removedViews[i]){
isPresent = true;
break;
}
}
if(!isPresent && count < 5){
var obj = viewObjects[removedViews[i]]
var newHtml = html.replace(/\$ID/g, i);
newHtml = newHtml.replace('$VN', obj["VIEWID"]);
newHtml = newHtml.replace('$DESC', obj["DESCRIPTION"]);
newHtml = newHtml.replace(/\$TITLE/g, obj["TITLE"]);
content = content.concat(newHtml);
count++
}
}
if(count > 0){
document.getElementById('_RmTab').innerHTML = "<TD><br>" + content + "</TD>";
}
else {
document.getElementById('_RmTab').innerHTML = "<TD align='center'><br>No recently removed components<br><br></TD>";
}
}
var removedViews = new Array();
function removeView(index, reload){
for(var i=0; i<removedViews.length;i++){
if(removedViews[i] == viewNames[index]){
removedViews.splice(i,1);
}
}
removedViews[removedViews.length] = viewNames[index];	
if(reload){
var viewName = viewNames[index];
replaceCellsWithDummyValue(viewName);
reCalculateTableData();
invokeMethod("createTable");
}
}
function replaceCellsWithDummyValue(viewName){
for(rows = 0; rows < rowCount; rows ++){
columns = tableMatrix[rows];
for(cols = 0; cols < _columnCount; cols++){
iteratedViewName = tableMatrix[rows][cols];
if(iteratedViewName == viewName){
tableMatrix[rows][cols] = "Dummy" + rows + cols;
}
}
}
}
function replaceCellsWithUpdatedValue(oldViewName, viewName){
for(rows = 0; rows < rowCount; rows ++){
columns = tableMatrix[rows];
for(cols = 0; cols < _columnCount; cols++){
iteratedViewName = tableMatrix[rows][cols];
if(iteratedViewName == oldViewName){
tableMatrix[rows][cols] = viewName;
}
}
}
}
function updateCellValues(colIndex){
if(colIndex == _columnCount - 1){
return;
}
for(var count=0; count < rowCount; count++){
if(tableMatrix[count][colIndex-1] == tableMatrix[count][colIndex+1]){
tableMatrix[count][colIndex] = tableMatrix[count][colIndex+1]
}
}
}
function updateRowValues(rowIndex){
if(rowIndex == rowCount - 1){
return;
}
for(var count=0; count < _columnCount; count++){
if(tableMatrix[rowIndex-1][count] == tableMatrix[rowIndex+1][count]){
tableMatrix[rowIndex][count] = tableMatrix[rowIndex-1][count]
}
}
}
function isInvasionPossibleHorizontally(x, y, direction){
var viewName = currentViewInEdit;
viewProps = viewObjects[viewName];
rowspan = viewProps["ROWSPAN"];
isPossible = true;
if(direction>0 && y==0){
return false;
}
if(direction == 0){
if(y == _columnCount-1){
return false;
}
for(i=0; i<rowspan;i++){
if(tableMatrix[x - i][y + 1].indexOf("Dummy") < 0){
isPossible = false;
}
}
}
else {
for(i=0; i<rowspan;i++){
if(tableMatrix[x - i][y - 1].indexOf("Dummy") < 0){
isPossible = false;
}
}
}
return isPossible;
}
function isInvasionPossibleVertically(x, y, direction){
var viewName = currentViewInEdit;
viewProps = viewObjects[viewName];
colspan = viewProps["COLSPAN"];
isPossible = true;
if(direction>0 && x==0){
return false;
}
if(direction == 0){
if(x == rowCount-1){
return false;
}
for(i=0; i<colspan;i++){
if(tableMatrix[x + 1][y - i].indexOf("Dummy") < 0){
isPossible = false;
}
}
}
else {
for(i=0; i<colspan;i++){
if(tableMatrix[x - 1][y - i].indexOf("Dummy") < 0){
isPossible = false;
}
}
}
return isPossible;
}
function increaseWidthRight(x, y){
var viewName = currentViewInEdit;
viewProps = viewObjects[viewName];
rowspan = viewProps["ROWSPAN"];
if(!isInvasionPossibleHorizontally(x,y,0)){
for(var i=0; i<rowCount;i++){
tableMatrix[i].splice(y+1,0,"Dummy"+i+(y+1));
}
_columnCount++;
updateCellValues(y+1);
updateDummyValues();
}
if(rowspan > 1){
for(i=0; i<rowspan;i++){
tableMatrix[x - i][y + 1] = viewName;
}
}
else{
tableMatrix[x][y + 1] = viewName;	
}
reCalculateTableData();
invokeMethod("createTable");
}
function increaseWidthLeft(x, y){
var viewName = currentViewInEdit;
viewProps = viewObjects[viewName];
rowspan = viewProps["ROWSPAN"];
colspan = viewProps["COLSPAN"];
if(colspan > 1){
y = y - colspan + 1;
}
if(!isInvasionPossibleHorizontally(x,y,1)){
for(var i=0; i<rowCount;i++){
tableMatrix[i].splice(y,0,"Dummy"+i+(y));
}
_columnCount++;
updateCellValues(y);
updateDummyValues();
y++;
}
if(rowspan > 1){
for(i=0; i<rowspan;i++){
tableMatrix[x - i][y-1] = viewName;
}
}
else{
tableMatrix[x][y-1] = viewName;	
}
reCalculateTableData();
invokeMethod("createTable");
}
function increaseHeightBottom(x, y){
var viewName = currentViewInEdit;
viewProps = viewObjects[viewName];
colspan = viewProps["COLSPAN"];
if(!isInvasionPossibleVertically(x,y,0)){
tableMatrix.splice(x+1,0,new Array(_columnCount));
for(count = 0; count < _columnCount; count++){
tableMatrix[x+1][count] = "Dummy" + (x +1)+ count;
}
rowCount++;
updateRowValues(x+1);
updateDummyValues();
}
if(colspan > 1){
for(i=0; i<colspan;i++){
tableMatrix[x + 1][y - i] = viewName;
}
}
else{
tableMatrix[x + 1][y] = viewName;	
}
reCalculateTableData();
invokeMethod("createTable");
}
function increaseHeightTop(x, y){
var viewName = currentViewInEdit;
viewProps = viewObjects[viewName];
colspan = viewProps["COLSPAN"];
rowSpan = viewProps["ROWSPAN"];
if(rowSpan > 1){
x = x - rowSpan + 1;
}
if(!isInvasionPossibleVertically(x,y,1)){
tableMatrix.splice(x,0,new Array(_columnCount));
for(count = 0; count < _columnCount; count++){
tableMatrix[x][count] = "Dummy" + x + count;
}
rowCount++;
updateRowValues(x);
updateDummyValues();
x++;
}
if(colspan > 1){
for(i=0; i<colspan;i++){
tableMatrix[x - 1][y - i] = viewName;
}
}
else{
tableMatrix[x - 1][y] = viewName;	
}
reCalculateTableData();
invokeMethod("createTable");
}
function decreaseWidthLeft(x, y){
var viewName = currentViewInEdit;
viewProps = viewObjects[viewName];
rowspan = viewProps["ROWSPAN"];
if(rowspan > 1){
for(i=0; i<rowspan;i++){
tableMatrix[x-i][y] = "Dummy"+(x-i)+(y);
}
}
else{
tableMatrix[x][y] = "Dummy"+x+y;
}
reCalculateTableData();
invokeMethod("createTable");
}
function decreaseWidthRight(x, y){
var viewName = currentViewInEdit;
viewProps = viewObjects[viewName];
rowspan = viewProps["ROWSPAN"];
colspan = viewProps["COLSPAN"];
if(colspan > 1){
y = y - (colspan - 1);
}
if(rowspan > 1){
for(i=0; i<rowspan;i++){
tableMatrix[x-i][y] = "Dummy"+(x-i)+y;
}
}
else{
tableMatrix[x][y] = "Dummy"+x+y;
}
reCalculateTableData();
invokeMethod("createTable");
}
function decreaseHeightBottom(x, y){
var viewName = currentViewInEdit;
viewProps = viewObjects[viewName];
colspan = viewProps["COLSPAN"];
if(colspan > 1){
for(i=0; i<colspan;i++){
tableMatrix[x][y-i] = "Dummy"+x+(y-i);
}
}
else{
tableMatrix[x][y] = "Dummy"+x+y;
}
reCalculateTableData();
invokeMethod("createTable");
}
function decreaseHeightTop(x, y){
var viewName = currentViewInEdit;
viewProps = viewObjects[viewName];
colspan = viewProps["COLSPAN"];
rowspan = viewProps["ROWSPAN"];
if(rowspan > 1){
x = x - (rowspan - 1);
}
if(colspan > 1){
for(i=0; i<colspan;i++){
tableMatrix[x][y-i] = "Dummy"+(x)+(y-i);
}
}
else{
tableMatrix[x][y] = "Dummy"+(x)+y;
}
reCalculateTableData();
invokeMethod("createTable");
}
function addEmptyRow(){
tableMatrix[rowCount] = new Array(_columnCount);
for(count = 0; count < _columnCount; count++){
tableMatrix[rowCount][count] = "Dummy" + rowCount + count;
}
rowCount++;
}
function addRow(){
isRowColAdded = true;
addEmptyRow();
reCalculateTableData();
invokeMethod("createTable");
}
function deleteRow(){
for(var count = 0; count < _columnCount; count++) {
var viewName = tableMatrix[rowCount - 1][count];
for(var i = 0; i < viewNames.length;i++){
if(viewNames[i] == viewName){
removeView(i, false);
}
}
}
tableMatrix.splice(rowCount - 1, 1);
rowCount--;
reCalculateTableData();
invokeMethod("createTable");
}
var isRowColAdded = false;
function addColumn(){
isRowColAdded = true;
for(count = 0; count < rowCount; count++){
tableMatrix[count][_columnCount] = "Dummy" + count + _columnCount;
}
_columnCount++;
reCalculateTableData();
invokeMethod("createTable");
}
function deleteColumn(){
for(var count = 0; count < rowCount; count++) {
var viewName = tableMatrix[count][_columnCount - 1];
for(var i = 0; i < viewNames.length;i++){
if(viewNames[i] == viewName){
removeView(i, false);
}
}
}
for(count = 0; count < rowCount; count++){
rowArray = tableMatrix[count];
rowArray.splice(_columnCount - 1, 1);
}
_columnCount--;
reCalculateTableData();
invokeMethod("createTable");
}
var draggedViewName = null;
function insertView(draggedViewObj, insertId){
currentViewInEdit = null;
draggedViewName  = draggedViewObj.getAttribute("viewName");
var draggedViewTitle  = draggedViewObj.getAttribute("title");
var draggedViewDesc  = draggedViewObj.getAttribute("desc");
var htmlObject = invokeMethod("addRuntimeObject", new Array(draggedViewName, draggedViewTitle, draggedViewDesc, -1, -1, 1, 1));
var insertBefore = document.getElementById(insertId).getAttribute('viewId');
viewNames[viewNames.length] = draggedViewName;
if(insertId.indexOf('_ev') >= 0){
if(insertBefore >= 0){
var insObj = viewObjects[viewNames[insertBefore]];
var insRowIndex = insObj["ROWINDEX"];
if(insObj["VIEWID"].indexOf("Dummy") >= 0){
tableMatrix[insObj["X"]][insObj["Y"]] = draggedViewName;
}
else {
tableMatrix.splice(insRowIndex, 0, new Array(_columnCount));
for(var i = 0; i < _columnCount; i++){
tableMatrix[insRowIndex][i] = "Dummy" + insRowIndex + i;
}	
rowCount++;
tableMatrix[insRowIndex][insObj["COLUMNINDEX"]] = draggedViewName;
updateDummyValues();
}
}
else {
tableMatrix.splice(rowCount, 0, new Array(_columnCount));
for(var i = 0; i < _columnCount; i++){
tableMatrix[rowCount][i] = "Dummy" + insRowIndex + i;
}
tableMatrix[rowCount][0] = draggedViewName;
rowCount++;
}
reCalculateTableData();
invokeMethod("createTable");
}
return true;	
}
function changeView(htmlObject, insertId){
currentViewInEdit = null;
var insertBefore = document.getElementById(insertId).getAttribute('viewId');
var currentId = htmlObject.getAttribute('viewId');
draggedViewName  = htmlObject.getAttribute("viewName");
var insObj = viewObjects[viewNames[insertBefore]];
var currObj = viewObjects[viewNames[currentId]];
if(insertId.indexOf('_ev') >= 0){
replaceCellsWithDummyValue(currObj["VIEWID"]);
if(insertBefore >= 0){
if(insObj["VIEWID"].indexOf("Dummy") >= 0){
tableMatrix[insObj["X"]][insObj["Y"]] = currObj["VIEWID"];
}
else {
moveView(currObj, insObj);
}
}
else {
tableMatrix.splice(rowCount, 0, new Array(_columnCount));
for(var i = 0; i < _columnCount; i++){
tableMatrix[rowCount][i] = "Dummy" + rowCount + i;
}
tableMatrix[rowCount][0] = draggedViewName;
rowCount++;
}
updateDummyValues();
reCalculateTableData();
invokeMethod("createTable");
}
}
function removeEmptyRows(){
for(var i = 0; i < tableMatrix.length; i++){
var isPresent = false;
for(var j = 0; j < tableMatrix[0].length; j++) {
if(tableMatrix[i][j].indexOf("Dummy") < 0){
isPresent = true;
}
}
if(!isPresent){
tableMatrix.splice(i, 1);
rowCount--;
}
}
if(tableMatrix.length == 0){
rowCount = 1;
_columnCount = 1;
tableMatrix = new Array(rowCount);
for(var i = 0; i < rowCount; i++){
tableMatrix[i] = new Array(_columnCount);
}
fillEmptyCells();
}
updateDummyValues();
} 
function removeEmptyColumns(){
for(var i = 0; i < tableMatrix[0].length; i++){
var isPresent = false;
for(var j = 0; j < tableMatrix.length; j++) {
if(tableMatrix[j][i].indexOf("Dummy") < 0){
isPresent = true;
}
}
if(!isPresent){
for(var j = 0; j < tableMatrix.length; j++) {
tableMatrix[j].splice(i, 1);
}
_columnCount--;
}
}
if(tableMatrix[0].length == 0){
rowCount = 1;
_columnCount = 1;
tableMatrix = new Array(rowCount);
for(var i = 0; i < rowCount; i++){
tableMatrix[i] = new Array(_columnCount);
}
fillEmptyCells();
}
updateDummyValues();
} 
function moveView(currObj, insObj){
var insRowIndex = insObj["ROWINDEX"];
var insColIndex = insObj["COLUMNINDEX"];
var rowSpan = currObj["ROWSPAN"];
var columnSpan = currObj["COLSPAN"];
for(var i = 0; i < rowSpan; i++){
tableMatrix.splice(insRowIndex, 0, new Array(_columnCount));
rowCount++;
}
for(var j = insRowIndex; j < insRowIndex + rowSpan; j++){
for(var i = 0; i < _columnCount; i++){
tableMatrix[j][i] = "Dummy" + j + i;
}	
}
if(insColIndex + columnSpan > _columnCount){
for(var j = _columnCount; j < insColIndex + columnSpan; j++){
for(var i = 0; i < rowCount; i++){
tableMatrix[i][j] = "Dummy" + i + j;
}	
_columnCount++;
}
}
for(var i = 0; i < rowSpan; i++){
for(var j = 0; j < columnSpan; j++){
tableMatrix[i + insRowIndex][j + insColIndex] = currObj["VIEWID"];
}
}
}
function updateDummyValues(){
for(rows = 0; rows < rowCount; rows ++){
columns = tableMatrix[rows];
for(cols = 0; cols < _columnCount; cols++){
iteratedViewName = tableMatrix[rows][cols];
if(iteratedViewName.indexOf("DummyEnd")>= 0){
tableMatrix[rows][cols] = "DummyEnd" + rows + cols;
}
else if(iteratedViewName.indexOf("Dummy") >= 0){
tableMatrix[rows][cols] = "Dummy" + rows + cols;
}
}
}
}
function disableSelectedViews(doc){
if(doc == null || doc == 'undefined'){
doc = document;
}
if(doc != null){
var obj = doc.getElementsByTagName("table");
for(var i = 0; i < obj.length; i++){
var id = obj[i].id;
if(id.indexOf("LV") < 0){
continue;
}
var viewName = obj[i].getAttribute("viewName");
var present = false;
for(var j = 0; j < viewNames.length; j++){
if(viewName == viewNames[j]){
present = true;
obj[i].className = 'viewSelected';
}
}
if(!present){
obj[i].className = 'viewNotSelected cursor';
}
}
}
}
var undoRedoIndex = -1;
var isFromUndoRedo = false;
var undoRedoArray = new Array();
function undo(){
undoRedoIndex--;
var tempMatrix = undoRedoArray[undoRedoIndex];
tableMatrix = getDuplicateMatrix(tempMatrix);	
_columnCount = tableMatrix[0].length;
rowCount = tableMatrix.length;
isFromUndoRedo = true;
reCalculateTableData();
invokeMethod("createTable");
}
function redo(){
undoRedoIndex++;
var tempMatrix = undoRedoArray[undoRedoIndex];
tableMatrix = getDuplicateMatrix(tempMatrix);	
_columnCount = tableMatrix[0].length;
rowCount = tableMatrix.length;
isFromUndoRedo = true;
reCalculateTableData();
invokeMethod("createTable");
}
function hidePane(){
document.getElementById("_HIDEPANE").className = 'paneBg hide';
document.getElementById("_SHOWPANE").className = 'paneBg show';
document.getElementById("_PANE").className = 'rightBg hide';
}
function showPane(){
document.getElementById("_HIDEPANE").className = 'paneBg show';
document.getElementById("_SHOWPANE").className = 'paneBg hide';
document.getElementById("_PANE").className = 'rightBg show';
}
function getDuplicateMatrix(originalMatrix){
var duplicateMatrix = new Array(originalMatrix.length);
for(var rc = 0; rc < originalMatrix.length; rc++){
duplicateMatrix[rc] = new Array(originalMatrix[0].length);
for(var cc = 0; cc < originalMatrix[0].length; cc++){
duplicateMatrix[rc][cc] = originalMatrix[rc][cc];  
}
}
return duplicateMatrix;
}
function createTable(){
if(!isFromUndoRedo && isStructureChanged){
++undoRedoIndex;
undoRedoArray[undoRedoIndex] = getDuplicateMatrix(tableMatrix);
}
else{
isStructureChanged = true;
}
if(!isFromUndoRedo ){
undoRedoArray.splice(undoRedoIndex+1, undoRedoArray.length-undoRedoIndex);
}
else {
isFromUndoRedo = false;
}
if(undoRedoIndex > 0){
document.getElementById('undoDisable').className = 'hide';
document.getElementById('undoEnable').className = '';
}
else {
document.getElementById('undoEnable').className = 'hide';
document.getElementById('undoDisable').className = '';
}
if(undoRedoArray.length -1 > undoRedoIndex){
document.getElementById('redoDisable').className = 'hide';
document.getElementById('redoEnable').className = '';
}
else {
document.getElementById('redoEnable').className = 'hide';
document.getElementById('redoDisable').className = '';
}
var outerTable = "<TABLE class='customLayout'>";
var size = viewNames.length;
var previousRowIndex = -1;
for(var i = 0; i < size; i++){
var viewProps = viewObjects[viewNames[i]];
var rowIndex = viewProps["ROWINDEX"];
var rowSpan = viewProps["ROWSPAN"];
var columnIndex = viewProps["COLUMNINDEX"];
var columnSpan = viewProps["COLSPAN"];
var description = viewProps["DESCRIPTION"];
var isDummy = viewProps["ISDUMMY"];
if(previousRowIndex != rowIndex){
if(rowIndex > 1){
outerTable = outerTable.concat("</TR>");
}
previousRowIndex = rowIndex;
outerTable = outerTable.concat("<TR>");
}
var isLastDragged = false;
if(draggedViewName != null && draggedViewName == viewProps["VIEWID"]){
isLastDragged = true;
}
outerTable = outerTable.concat(invokeMethod("getTableCellConstruct",new Array(columnSpan, rowSpan, isLastDragged)));
if(currentViewInEdit == viewNames[i]){
}
outerTable = outerTable.concat(invokeMethod("createInnerTable", new Array(viewProps, i)));
outerTable = outerTable.concat("</TD>");
}
outerTable = outerTable.concat("</TR></TABLE>");
element = document.getElementById(_dacName);
if(element != null){
element.innerHTML = outerTable;
}
invokeMethod("constructRemovedViews");
draggedViewName = null;
}
function addMethod(buffer, method, x, y, viewName){
buffer = buffer.concat(method);
buffer = buffer.concat("(");
buffer = buffer.concat(x);
buffer = buffer.concat(", ");
buffer = buffer.concat(y);
if(viewName != null){
buffer = buffer.concat(", ");
buffer = buffer.concat("'");
buffer = buffer.concat(viewName);
buffer = buffer.concat("'");
}
buffer = buffer.concat(")");
return buffer;
}
function getTopButtons(viewProps){
var y = viewProps["Y"];
var x = viewProps["X"];
var viewName = viewProps["VIEWID"];
var colspan = viewProps["COLSPAN"];
var rowspan = viewProps["ROWSPAN"];
var isDummy = viewProps["ISDUMMY"];
var toolbarTable = "";
toolbarTable = toolbarTable.concat("<BUTTON class = 'expandTop' ");
toolbarTable = toolbarTable.concat("onClick= 'return ");
toolbarTable = addMethod(toolbarTable, 'increaseHeightTop', x, y);
toolbarTable = toolbarTable.concat("' >&nbsp;</BUTTON>");
if(rowspan > 1){
toolbarTable = toolbarTable.concat("<BUTTON class = 'expandBottom' ");
toolbarTable = toolbarTable.concat("onClick= 'return ");
toolbarTable = addMethod(toolbarTable, 'decreaseHeightTop', x, y);
toolbarTable = toolbarTable.concat("' >&nbsp;</BUTTON>");
}
else {
toolbarTable = toolbarTable.concat("<BUTTON class = 'expandBottomDis' >&nbsp;</BUTTON>");
}
return toolbarTable;	
}
function getBottomButtons(viewProps){
var y = viewProps["Y"];
var x = viewProps["X"];
var viewName = viewProps["VIEWID"];
var colspan = viewProps["COLSPAN"];
var rowspan = viewProps["ROWSPAN"];
var isDummy = viewProps["ISDUMMY"];
var toolbarTable = "";
toolbarTable = toolbarTable.concat("<BUTTON class = 'expandBottom' ");
toolbarTable = toolbarTable.concat("onClick= 'return ");
toolbarTable = addMethod(toolbarTable, 'increaseHeightBottom', x, y);
toolbarTable = toolbarTable.concat("' >&nbsp;</BUTTON>");
if(rowspan > 1){
toolbarTable = toolbarTable.concat("<BUTTON class = 'expandTop' ");
toolbarTable = toolbarTable.concat("onClick= 'return ");
toolbarTable = addMethod(toolbarTable, 'decreaseHeightBottom', x, y);
toolbarTable = toolbarTable.concat("' >&nbsp;</BUTTON>");
}
else {
toolbarTable = toolbarTable.concat("<BUTTON class = 'expandTopDis' >&nbsp;</BUTTON>");
}
return toolbarTable;
}
function getLeftButtons(viewProps){
var y = viewProps["Y"];
var x = viewProps["X"];
var viewName = viewProps["VIEWID"];
var colspan = viewProps["COLSPAN"];
var rowspan = viewProps["ROWSPAN"];
var isDummy = viewProps["ISDUMMY"];
var toolbarTable = "";
toolbarTable = toolbarTable.concat("<BUTTON class = 'expandLeft' ");
toolbarTable = toolbarTable.concat("onClick= 'return ");
toolbarTable = addMethod(toolbarTable, 'increaseWidthLeft', x, y);
toolbarTable = toolbarTable.concat("' >&nbsp;</BUTTON>");
if(colspan > 1){
toolbarTable = toolbarTable.concat("<BUTTON class = 'expandRight' ");
toolbarTable = toolbarTable.concat("onClick= 'return ");
toolbarTable = addMethod(toolbarTable, 'decreaseWidthRight', x, y);
toolbarTable = toolbarTable.concat("' >&nbsp;</BUTTON>");
}
else {
toolbarTable = toolbarTable.concat("<BUTTON class = 'expandRightDis' >&nbsp;</BUTTON>");
}
return toolbarTable;
}
function getRightButtons(viewProps){
var y = viewProps["Y"];
var x = viewProps["X"];
var viewName = viewProps["VIEWID"];
var colspan = viewProps["COLSPAN"];
var rowspan = viewProps["ROWSPAN"];
var isDummy = viewProps["ISDUMMY"];
var toolbarTable = "";
toolbarTable = toolbarTable.concat("<BUTTON class = 'expandRight' ");
toolbarTable = toolbarTable.concat("onClick= 'return ");
toolbarTable = addMethod(toolbarTable, 'increaseWidthRight', x, y);
toolbarTable = toolbarTable.concat("' >&nbsp;</BUTTON>");
if(colspan > 1){
toolbarTable = toolbarTable.concat("<BUTTON class = 'expandLeft' ");
toolbarTable = toolbarTable.concat("onClick= 'return ");
toolbarTable = addMethod(toolbarTable, 'decreaseWidthLeft', x, y);
toolbarTable = toolbarTable.concat("' >&nbsp;</BUTTON>");
}
else {
toolbarTable = toolbarTable.concat("<BUTTON class = 'expandLeftDis' >&nbsp;</BUTTON>");
}
return toolbarTable;
}
function checkAndAddEndPlaceHolders(){
if(rowCount > 0 && _columnCount > 0){
for(var rows = 0; rows < rowCount; rows ++){
for(var cols = 0; cols < _columnCount; cols++){
var iteratedViewName = tableMatrix[rows][cols];
if(iteratedViewName.indexOf("Dummy")>= 0){
tableMatrix[rows][cols] = "Dummy" + rows + cols;
}
}
}
removeEmptyRows();
removeEmptyColumns();
addPlaceHolders();
updateDummyValues();
}
}
function addPlaceHolders(){
var isPresent = true;
for(var i = 0; i < _columnCount;i++){
var viewName = tableMatrix[0][i];
if(viewName.indexOf("DummyEnd") < 0){
isPresent = false;
}
}
if(!isPresent){
tableMatrix.splice(0,0,new Array(_columnCount));
for(var count = 0; count < _columnCount; count++){
tableMatrix[0][count] = "DummyEnd" + 0 + count;
}
rowCount++;
}
isPresent = true;
for(var i = 0; i < _columnCount;i++){
var viewName = tableMatrix[rowCount-1][i];
if(viewName.indexOf("DummyEnd") < 0){
isPresent = false;
}
}
if(!isPresent){
tableMatrix[rowCount] = new Array(_columnCount);
for(var count = 0; count < _columnCount; count++){
tableMatrix[rowCount][count] = "DummyEnd" + rowCount + count;
}
rowCount++;
}
isPresent = true;
for(var i = 0; i < rowCount; i++){
var viewName = tableMatrix[i][0];
if(viewName.indexOf("DummyEnd") < 0){
isPresent = false;
}
}
if(!isPresent){
for(var j=0;j<rowCount;j++){
tableMatrix[j].splice(0,0,"DummyEnd"+j+"0");
}
_columnCount++;
}
isPresent = true;
for(var i = 0; i < rowCount; i++){
var viewName = tableMatrix[i][_columnCount - 1];
if(viewName.indexOf("DummyEnd") < 0){
isPresent = false;
}
}
if(!isPresent){
for(var count = 0; count < rowCount; count++){
tableMatrix[count][_columnCount] = "DummyEnd" + count + _columnCount;		
}
_columnCount++;
}
}
