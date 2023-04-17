var _viewObjects = null;
var _isInline;
var SELECT_ATLEASTONECOLUMN_ERROR;
function initColumnChooser(viewObjs, doc, isInline){
this._viewObjects = viewObjs;
this._isInline = isInline;
createAndShowCCTable(doc);
}
function createAndShowCCTable(doc){
var ccTable = "";
if (this._isInline)
ccTable = ccTable.concat("<Table cellspacing='0' cellpadding='2' width='100%'>");
else
ccTable = ccTable.concat("<Table cellspacing='0' class='ccListTable'><tr><td class='ccListHeader' colspan='2'>Columns</td></tr>");
var count = _viewObjects.length;
for(var i=0; i<count;i++){
var obj = _viewObjects[i];
var isVisible = obj[2];
var cssName = "ccNotSelected";
if(currentId != null && currentId == obj[0]){
cssName = "ccSelected";
}
ccTable = ccTable.concat("<TR><td class='"+cssName+"' width='20'><input type='checkbox' onClick='selectColumn(this, true)' column='" + obj[0] + "' name='" + obj[0] + "' id='" + obj[0] + "_INP' value='" + obj[1] + "' index='" + i + "'");
if(isVisible == 'true'){
ccTable = ccTable.concat(" checked");
}
ccTable = ccTable.concat("/></td><td onClick='selectColumn(this)' class='" + cssName + "' column='" + obj[0] + "' id='"+obj[0]+"_COL' index='"+i+"'>" + obj[1] + "</td></tr>");
}
ccTable = ccTable.concat("</table>");
if(doc == null){
document.getElementById('ccTable').innerHTML = ccTable;
}
else {
doc.getElementById('ccTable').innerHTML = ccTable;
}
}
var currentId = null;
function selectColumn(obj, isCheckbox){
var reqId = obj.getAttribute('column');
if(isCheckbox){
if(obj.checked == true){
var count = _viewObjects.length;
for(var i=0; i<count;i++){
var curObj = _viewObjects[i];
if(curObj[0] == reqId){
curObj[2] = 'true'
}
}
}
if(obj.checked == false){
var count = _viewObjects.length;
for(var i=0; i<count;i++){
var curObj = _viewObjects[i];
if(curObj[0] == reqId){
curObj[2] = 'false';
}
}
}
}
currentId = reqId;
createAndShowCCTable();
}
function moveColumnUp(){
if(currentId != null){
var obj = document.getElementById(currentId+"_INP");
var idx = obj.getAttribute("index");
if(idx > 0){
var idxObj = _viewObjects[idx];
_viewObjects.splice(idx,1); 	
_viewObjects.splice(idx-1,0,idxObj); 	
createAndShowCCTable();
}
}
return false;
}
function moveColumnDown(){
if(currentId != null){
var obj = document.getElementById(currentId+"_INP");
var idx = parseInt(obj.getAttribute("index"),10);;
if(idx < _viewObjects.length - 1){
var idxObj = _viewObjects[idx];
_viewObjects.splice(idx,1); 	
_viewObjects.splice(idx+1,0,idxObj); 	
createAndShowCCTable();
}
}
return false;
}
function submitCCListForm(form)
{
var queryStr = "";	  
var count = _viewObjects.length;
var isAtleastOneShown=false;
for(var i = 0; i < count; i++){
var curObj = _viewObjects[i];
if(curObj[2] == 'true'){
queryStr = queryStr.concat("&SHOW_LIST=");
queryStr = queryStr.concat(curObj[0]);
isAtleastOneShown=true;
}
else {
queryStr = queryStr.concat("&HIDE_LIST=");
queryStr = queryStr.concat(curObj[0]);
}
}
queryStr = queryStr.concat("&View_Name=" + form.View_Name.value);
if(!isAtleastOneShown)
{
var errorString="Select at least one column";
if(SELECT_ATLEASTONECOLUMN_ERROR!="undefined" && SELECT_ATLEASTONECOLUMN_ERROR!=null)
{
errorString=SELECT_ATLEASTONECOLUMN_ERROR;
}
alert(getLocalizedMsg(errorString));
return;
}
closeDialog(null,form);
var callBack =function(response,reqOptions) {
stateData[reqOptions.v("TABLEVIEWID")]["_VMD"]= '1';
refreshSubView(reqOptions.v("TABLEVIEWID"));
}	
var url;
if(RESTFUL == true)
{
url = CONTEXT_PATH + "/" + "ChooserListTypeInline.cc";
}
else
{
url = "ChooserListTypeInline.cc";
}
AjaxAPI.sendRequest({URL:url,PARAMETERS:queryStr,ONSUCCESSFUNC:callBack,TABLEVIEWID:form.TABLEVIEWID.value});
}
