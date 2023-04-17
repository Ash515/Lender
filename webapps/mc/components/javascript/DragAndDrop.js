var tx;
var ty;
var _enabledView = null;
var dragobject = null;
var draggedViewId = null;
var draging = false;
document.onmouseup = endDrag;
document.onmousemove = drag;
function startDrag(event, id){
draggedViewId = id;
var currObj = document.getElementById(id);
if(currObj.className.indexOf('viewNotSelected') < 0 && currObj.className.indexOf('wkContent') < 0){
return;
}
var data = currObj.innerHTML;
var obj = document.getElementById("movableDiv");
document.getElementById('movableDivContent').setAttribute('height', currObj.getAttribute('height')+'px');
document.getElementById('movableDivContent').setAttribute('width', currObj.getAttribute('width')+'px');
document.getElementById('movableDivContent').innerHTML = currObj.getAttribute('title');
obj.style.left = findPosX(getObj(id));
obj.style.top = findPosY(getObj(id)) - 10;
obj.className = 'show';
dragobject = obj;
draging = true;
if( browser_nn4 || browser_nn6 ) {				
ty = event.pageY - findPosY(dragobject);
tx = event.pageX - findPosX(dragobject);
}
else {
ty = window.event.clientY - findPosY(dragobject);
tx = window.event.clientX - findPosX(dragobject);
}
}
function endDrag(event) {
if(draging){
var currElement = null;
if (browser_ie){
currElement=window.event.srcElement;
}
else if (browser_nn4 || browser_nn6){
currElement=event.target;
}
if(_enabledView  == null){
resetDragData();
return;
}
var elemId = currElement.id;
if(elemId.indexOf('_ev') < 0 && elemId.indexOf('_indicator') < 0 && elemId.indexOf('_PH') < 0){
disableViewSelection();
resetDragData();
return;
}
var draggedViewObj = document.getElementById(draggedViewId);
if(draggedViewId.indexOf('LV') >= 0){
if(insertView(draggedViewObj, _enabledView)){
draggedViewObj.className = 'viewSelected';
}
}
if(draggedViewId.indexOf('_ev') >= 0){
changeView(draggedViewObj, _enabledView);
}
resetDragData();
}
}
function resetDragData() {
draging = false;
dragobject = null;
_enabledView = null;
draggedViewId = null;
document.getElementById('movableDiv').className = 'hide';
}
function drag(e) {
if (browser_nn4 || browser_nn6)
window.getSelection().removeAllRanges(); 
if (dragobject) {
if (browser_ie)
document.selection.empty();
if( browser_nn4 || browser_nn6 ) {				
if (e.pageX >= 0 && e.pageY >= 0) {
dragobject.style.left = e.pageX;
dragobject.style.top = e.pageY+1;
}
}
else {
if (window.event.clientX >= 0 && window.event.clientY >= 0) {
dragobject.style.left = window.event.clientX;
dragobject.style.top = window.event.clientY + 1;
}
}
}
}
function enableViewSelection(object){
showDescription(object);
if(draging){
var id = object.id;
var index = object.getAttribute("viewId");
disableViewSelection();
showDescription(object);
_enabledView = id;
if(id.indexOf("_evl") >= 0 || id.indexOf("_dv") >= 0){
if(object.className == 'emptyCell'){
object.className = 'emptyCellHover';
}
else {
object.className = 'emptyCellEndHover';
}
}
else if(id.indexOf("_ev") >= 0){
document.getElementById("_indicator1" + index).className = 'show';
}
}
}
function disableViewSelection(){
if(_enabledView != null){
var preIndex = document.getElementById(_enabledView).getAttribute("viewId");
if(_enabledView.indexOf("_evl") >= 0 || _enabledView.indexOf("_dv") >= 0){
if(document.getElementById(_enabledView).className == 'emptyCellHover'){
document.getElementById(_enabledView).className = 'emptyCell';
}
else {
document.getElementById(_enabledView).className = 'emptyCellEnd';
}
}
else {
document.getElementById("_indicator1" + preIndex).className = 'hide';
}
hideDescription();
}
}
function showDescription(obj){
var id = obj.id;
var desc = obj.getAttribute('desc');
if(document.getElementById("_ViewDesc") != null){
if(desc != 'null'){
document.getElementById('_ViewDesc').innerHTML = desc;
}
else {
document.getElementById('_ViewDesc').innerHTML = 'No description available for <i>' + obj.getAttribute('title') + '</i>';
}
}
}
function hideDescription(){
if(document.getElementById("_ViewDesc") != null){
document.getElementById('_ViewDesc').innerHTML = "";
}
}
