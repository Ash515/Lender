var _RAD_SEL_TABLENAMES = new Array();
function updateApplicationID(selectObj){
var uniqueId = "TableNamesView";
var value = selectObj.value;
if(value == "None" || value == null){
value = " ";
}
updateState(uniqueId, "_D_RP", "&APP_ID=" + value);
refreshSubView(uniqueId);
}
function addTableToList(tableName){
_RAD_SEL_TABLENAMES[_RAD_SEL_TABLENAMES.length] = tableName;
disableSelectedTables();
constructTableList();
}
function removeTableFromList(tableName){
var index = 0;
for(var i=0; i < _RAD_SEL_TABLENAMES.length; i++){
if(_RAD_SEL_TABLENAMES[i] == tableName){
index = i;
}
}
_RAD_SEL_TABLENAMES.splice(index,1);
disableSelectedTables();
constructTableList();
}
function constructTableList(){
var htmlCode = "<Table cellspacing='1' class='tableComponent'><tr><td class='tableHeader'>Table Name</td><td class='tableHeader'>&nbsp;</td></tr>"
for(var i=0; i < _RAD_SEL_TABLENAMES.length; i++){
htmlCode = htmlCode.concat("<tr><td class='oddRow'>" + _RAD_SEL_TABLENAMES[i] + "</td><td class='oddRow'><a href=javascript:removeTableFromList('"+_RAD_SEL_TABLENAMES[i]+"') >Remove</a></tr>");
}
htmlCode = htmlCode.concat("</table>");
document.getElementById("SelectedTablesView").innerHTML = htmlCode;
}
function disableSelectedTables(curDoc){
reqDoc = document;
if(curDoc != null){
reqDoc = curDoc;
}
var elements = reqDoc.getElementsByTagName("A");
for(var i = 0;  i < elements.length; i++){
var elemId = elements[i].id;
if(elemId.indexOf("_AE") > 0 ){
var tableName = elements[i].getAttribute("tablename");
var contains = false;
for(var j=0; j < _RAD_SEL_TABLENAMES.length; j++){
if(_RAD_SEL_TABLENAMES[j] == tableName){
contains = true;
}
}
if(contains){
reqDoc.getElementById(tableName + "_AE").className = "hide";
reqDoc.getElementById(tableName + "_AD").className = "show";
reqDoc.getElementById(tableName + "_RE").className = "show";
reqDoc.getElementById(tableName + "_RD").className = "hide";
}
else {
reqDoc.getElementById(tableName + "_AE").className = "show";
reqDoc.getElementById(tableName + "_AD").className = "hide";
reqDoc.getElementById(tableName + "_RE").className = "hide";
reqDoc.getElementById(tableName + "_RD").className = "show";
}
}
}
}
function constructReqParamsForNewView(mds, joinType){
var selectedTablesParam = "";
if(_RAD_SEL_TABLENAMES.length == 0){
alert("No tables selected");
return false;
}
if(joinType == "MANUAL"){
if(_RAD_SEL_TABLENAMES.length == 1){
alert("Atleast two tables should be selected for Manual Join.");
return false;
}
}
for(var i=0; i<_RAD_SEL_TABLENAMES.length; i++){
selectedTablesParam += "selectedTables=" + _RAD_SEL_TABLENAMES[i] + "&";
}
if(mds != null){
var elements = document.getElementsByTagName("select");
for(var i = 0; i < elements.length;i++){
if(elements[i].name == "MDSApplicationDropDown"){
for(var j = 0; j < elements[i].options.length; j++){
if(elements[i].options[j].selected == true){
selectedTablesParam += "MDS="+elements[i].options[j].text + "&";
}
}
}
}
}
return selectedTablesParam;
}
function selectTablesAndSubmit(mds, joinType){
var result = constructReqParamsForNewView(mds, joinType);
if(!result){
return false;
}
if(joinType == "AUTO"){
addViewWithParamsToCA("SelectJoins","aa",null, result + "LayoutType=" + document.SC.LayoutType.value + "&JOINTYPE=AUTO");
}
if(joinType == "MANUAL"){
addViewWithParamsToCA("SelectJoins","aa",null, result + "LayoutType=" + document.SC.LayoutType.value + "&JOINTYPE=MANUAL");
}
return false;
}
