var viewNames = new Array();
var insId = null;
var originalGridViews = new Array();
var layoutType = 'Grid';
var removedViews = new Array();
function initLayout(views, insertionId, type){
layoutType = type;
for(var i = 0; i < views.length; i++){
originalGridViews[i] = views[i];
}
viewNames = views;
insId = insertionId;
showGrid(constructLayout());
}
function constructLayout() {
constructRemovedViews();
disableSelectedViews();
if(layoutType == 'Grid'){
return constructGrid();
}
else if(layoutType == 'HTab'){
return constructHorizontalTab();
}
else if(layoutType == 'VTab'){
return constructVerticalTab();
}
draggedViewName = null;
}
function constructGrid() {
if(layoutType == 'Grid'){
var grid = "<TABLE id='editTable' class='customLayout'>";
var size = viewNames.length;
for(var count = 0; count < size; count++){
var html = document.getElementById("GridView").innerHTML;
var newHtml = html.replace(/\$ID/g, count);
newHtml = newHtml.replace('$HEIGHT', 75);
newHtml = newHtml.replace('$VN', viewNames[count][0]);
newHtml = newHtml.replace('$DESC', viewNames[count][2]);
newHtml = newHtml.replace(/\$TITLE/g, viewNames[count][1]);
grid = grid.concat("<TR><TD ");
if(draggedViewName != null && draggedViewName == viewNames[count][0]){
grid = grid.concat(" class='lastDragged'")
}
grid = grid.concat(" id='_evInd' onMouseOver='enableViewSelection(document.getElementById(\"_ev" + count + "\"))'>"+newHtml+"</TD></TR>");
}
grid = grid.concat("<TR><TD><TABLE align='center' width='275px'><TR><TD align='center' class='emptyCell' id='_evl' viewId = '" + -1 + "' onMouseOver='enableViewSelection(this)' onMouseDown=\"startDrag(event, '_evl')\" onMouseOut='disableViewSelection(this)'>(Drag & Drop here to add components to the last)</TD></TR></TABLE></TD></TR></TABLE>");
grid = grid.concat("</TABLE>");
return grid;
}
}
function constructHorizontalTab() {
var grid = "<TABLE align='center' id='tabCustom' class='customLayout' height='95px'><TR>";
var size = viewNames.length;
for(var count = 0; count < size; count++){
var html = document.getElementById("TabView").innerHTML;
var newHtml = html.replace(/\$ID/g, count);
newHtml = newHtml.replace('$VN', viewNames[count][0]);
newHtml = newHtml.replace('$DESC', viewNames[count][2]);
newHtml = newHtml.replace(/\$TITLE/g, viewNames[count][1]);
grid = grid.concat("<TD ");
if(draggedViewName != null && draggedViewName == viewNames[count][0]){
grid = grid.concat(" class='lastDragged'")
}
grid = grid.concat(" width='75px' nowrap id='_evInd' onMouseOver='enableViewSelection(document.getElementById(\"_ev" + count + "\"))'>"+newHtml+"</TD>");
}
grid = grid.concat("<TD width='75px'  onMouseOver='enableViewSelection(document.getElementById(\"_evl\"))' onMouseOut='disableViewSelection(document.getElementById(\"_evl\"))'nowrap id='_evlInd'><table><tr><td class='emptyCell' id='_evl' viewId = '" + -1 + "' align='center'>(Empty Tab)</td></tr></table></TD>");
grid = grid.concat("</TR>");
grid = grid.concat("</TABLE>");
return grid;
}
function constructVerticalTab() {
var grid = "<TABLE align='center' class='vtabClass' id='tabCustom' cellspacing='0' width='90%' border='0'>";
grid = grid.concat("<TR><TD class='sideBarHdr' align='center'>"+CUSTOMIZE_VIEWNAME+"</TD></TR>");
var size = viewNames.length;
for(var count = 0; count < size; count++){
var html = document.getElementById("VTabView").innerHTML;
var newHtml = html.replace(/\$ID/g, count);
newHtml = newHtml.replace(/\$VN/g, viewNames[count][0]);
newHtml = newHtml.replace(/\$DESC/g, viewNames[count][2]);
newHtml = newHtml.replace(/\$TITLE/g, viewNames[count][1]);
grid = grid.concat("<TR><TD ");
if(draggedViewName != null && draggedViewName == viewNames[count][0]){
grid = grid.concat(" class='lastDragged'");
}
grid = grid.concat(" width='100%' nowrap>"+newHtml+"</TD></TR>");
}
grid = grid.concat("<TR><TD width='75px' nowrap id='_evl' viewId = '" + -1 + "' onMouseOver='enableViewSelection(this)' onMouseDown=\"startDrag(event, '_evl')\" onMouseOut='disableViewSelection(this)' align='center' class='emptyCell'>Drag & Drop to add links</TD></TR>");
grid = grid.concat("</TABLE>");
return grid;
}
function showGrid(grid){
currentGrid = grid;
setTimeout("dummy()",1);
}
var currentGrid;
function dummy(){
var element = document.getElementById(insId);
element.innerHTML = currentGrid;
}
var draggedViewName = null;
function insertView(draggedViewObj, insertId){
draggedViewName  = draggedViewObj.getAttribute("viewName");
var draggedViewTitle  = draggedViewObj.getAttribute("title");
var viewObject = new Array(draggedViewName, draggedViewTitle);
var insertBefore = document.getElementById(insertId).getAttribute('viewId');
var valid = false;
if(insertId.indexOf('_ev') >= 0){
if(insertBefore >= 0){
var message = "'" + viewObject[1] + "' &nbsp;&nbsp;inserted before&nbsp;&nbsp; '" + viewNames[insertBefore][1] + "'";
viewNames.splice(insertBefore, 0, viewObject);	
valid = true;
}
else {
viewNames[viewNames.length] = viewObject;
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
var viewObject = viewNames[currentId];
var valid = false;
if(insertId.indexOf('_ev') >= 0){
if(insertBefore >= 0){
var message = "'" + viewNames[currentId][1] + "' &nbsp;&nbsp;inserted before&nbsp;&nbsp; '" + viewNames[insertBefore][1] + "'";
if(insertBefore < currentId){
viewNames.splice(currentId, 1);	
viewNames.splice(insertBefore, 0, viewObject);	
}
else {
viewNames.splice(insertBefore, 0, viewObject);	
viewNames.splice(currentId, 1);	
}
valid = true;
}
else {
viewNames.splice(currentId, 1);	
viewNames[viewNames.length] = viewObject;
valid = true;
}
}
if(valid) {
showGrid(constructLayout());
}
return valid;
}
function removeView(index){
for(var i=0; i<removedViews.length;i++){
if(removedViews[i][0] == viewNames[index][0]){
removedViews.splice(i,1);
}
}
removedViews[removedViews.length] = viewNames[index];	
viewNames.splice(index, 1);	
showGrid(constructLayout());
}
function resetGrid(){
viewNames = new Array();
for(var i = 0; i < originalGridViews.length; i++){
viewNames[i] = originalGridViews[i];
}
disableSelectedViews();
showGrid(constructLayout());
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
if(viewName == viewNames[j][0]){
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
function constructRemovedViews(){
var size = removedViews.length;
if(size == 0){
return;
}
var content = "";
var count = 0;
var html = document.getElementById('RemovedGridView').innerHTML;
for(var i = size-1; i >= 0; i--){
var isPresent = false;
for(var j = 0; j < viewNames.length; j++){
if(viewNames[j][0] == removedViews[i][0]){
isPresent = true;
break;
}
}
if(!isPresent && count < 5){
var obj = viewObjects[removedViews[i]]
var newHtml = html.replace(/\$ID/g, i);
newHtml = newHtml.replace('$VN', removedViews[i][0]);
newHtml = newHtml.replace('$DESC', removedViews[i][2]);
newHtml = newHtml.replace(/\$TITLE/g, removedViews[i][1]);
content = content.concat(newHtml);
count++
}
}
if(document.getElementById('_RmTab') != null && document.getElementById('_RmTab') != 'undefined'){
if(count > 0){
document.getElementById('_RmTab').innerHTML = "<br>" + content + "";
}
else {
document.getElementById('_RmTab').innerHTML = "<br>No recently removed components<br><br>";
}
}
}
function submitValuesForTabAndGrid(customizeFrm)
{         
if(!promptViewTitleIfReq(customizeFrm)){
return false;
}         
var size = viewNames.length;
var tempArray = new Array();
var count = 0;
for(var i = 0; i < size; i++){
customizeFrm.selectedViewList[i] = new Option(viewNames[i][0], viewNames[i][0], true);
customizeFrm.selectedViewList.options[i].selected = true;;
}
AjaxAPI.submit(customizeFrm);
}
