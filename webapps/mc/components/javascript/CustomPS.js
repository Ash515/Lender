var _viewDataObject = null;
var _layoutType = 'Table';
var _formType = "Create";
var _configName = "";
var _mdsName = "";
var _PSConfigName = "";
var _CVName = "";
function initCPSLayout(dataObject, insertionId, type, formType, mdsName){
_layoutType = type;
_mdsName = mdsName;
if(formType != null && formType != "null"){
_formType = formType;
}
_viewDataObject = dataObject;
var currentViewNames = new Array();
var rIndex = -1;
var cIndex = -1;
var psTableLayoutCustomization = new Object();
psTableLayoutCustomization["getTableCellConstruct"] = getCellConstructForField;
psTableLayoutCustomization["constructRemovedViews"] = skipRemovedViews;
psTableLayoutCustomization["addRuntimeObject"] = addNewColumn;
psTableLayoutCustomization["createTable"] = createTableAndSelectColumn;
parent["psTableLayoutCustomization"] = psTableLayoutCustomization;
initMethodContainer("psTableLayoutCustomization");
var viewDetails = _viewDataObject.getRowsForTable("TmpViewDetails");
_configName = viewDetails[0][VIEWNAME];
var validViewCount = 0;
if(_layoutType == 'Table'){
canAddPlaceHolders = false;
currentViewNames = populateDataForTable();
}
else if(_layoutType == 'CPS' || _layoutType == 'CPSForm'){
currentViewNames = populateDataForCPS();
}
var size = currentViewNames.length;
for(var i = 0; i < size; i++){
var viewProps = viewObjects[currentViewNames[i]];
if(viewProps != null){
if(parseInt(viewProps["ROWINDEX"]) > rIndex){
rIndex = parseInt(viewProps["ROWINDEX"]) + parseInt(viewProps["ROWSPAN"]) - 1;
}
if(parseInt(viewProps["COLUMNINDEX"]) > cIndex){	
cIndex = parseInt(viewProps["COLUMNINDEX"]) + parseInt(viewProps["COLSPAN"]) - 1;
}
}
}
init(currentViewNames,cIndex+1,rIndex+1, insertionId);					
}
function populateDataForTable(){
var vNames = new Array();
if(_viewDataObject.containsTable("ACColumnConfiguration")){
var ccRow = _viewDataObject.getRowsForTable("ACColumnConfiguration");
for(var index in ccRow)
{
if(index=="each"||index=="prototype")    
{
break;
}
var ccProps = ccRow[index];
_configName = ccProps["CONFIGNAME"];
var colName = ccProps["COLUMNALIAS"];
var displayName = ccProps["DISPLAYNAME"];
var tableName = colName.substring(0, colName.length - displayName.length - 1);
vNames[parseInt(ccProps["COLUMNINDEX"],10)] = colName;
addViewObject(new Array(colName, displayName, "FieldValue",parseInt(ccProps["COLUMNINDEX"],10),0,1,1));
_viewDataObject.addRowsForTable("TmpViewColumn",new Array(new Array(COLUMNID,colName),new Array(TABLENAME,tableName),new Array(COLUMNNAME,colName),new Array(COLUMNINDEX, index),new Array(DISPLAYNAME,displayName),new Array(COLUMNALIAS,colName),new Array(VISIBLE,ccProps["VISIBLE"]),new Array(SORTENABLED,ccProps["SORTENABLED"]),	new Array(SEARCHENABLED,ccProps["SEARCHENABLED"]),new Array(ACTIONNAME,ccProps["ACTIONNAME"]),new Array(CREATORCONFIG,ccProps["CREATORCONFIG"]), new Array(DEFAULT_TEXT,ccProps["DEFAULT_TEXT"]),new Array(DATE_FORMAT,ccProps["DATE_FORMAT"]),new Array(TRIM_LENGTH,ccProps["TRIM_LENGTH"]),	new Array(TRIM_MSG_LINK,ccProps["TRIM_MSG_LINK"]),new Array(PREFIX_TEXT,ccProps["PREFIX_TEXT"]),new Array(SUFFIX_TEXT,ccProps["SUFFIX_TEXT"]),new Array(SUFFIX_ICON,ccProps["SUFFIX_ICON"]),new Array(PREFIX_ICON,ccProps["ICON"]),new Array(TABLEALIAS,ccProps["TABLEALIAS"]),new Array(LINKVIEWNAME,ccProps["VIEWNAME"]),new Array(VIEWNAME,ccProps["CONFIGNAME"]),new Array("STATIC_TEXT",ccProps["STATIC_TEXT"]),new Array("ISNULLABLE",ccProps["ISNULLABLE"]), new Array("CSSCLASS",ccProps["CSSCLASS"]), new Array("ISHEADERVISIBLE", ccProps["ISHEADERVISIBLE"]), new Array("MENUID", ccProps["MENUID"]), new Array("TRANSFORMER",ccProps["TRANSFORMER"])));
}
}
return vNames;
}
function populateDataForCPS(){
var vNames = new Array();
if(_viewDataObject.containsTable("ACPSConfiguration")){
var psConfigRows = _viewDataObject.getRowsForTable("ACPSConfiguration");
var actualCount = 0;
for(var index in psConfigRows){
if(index=="each"||index=="prototype")
{
break;
}
_configName = psConfigRows[index]["CONFIGNAME"];
_PSConfigName = _configName;
var colName = null;
var displayName = null;
if(psConfigRows[index]["DATATYPE"] != "FieldValue" && psConfigRows[index]["DATATYPE"] != "FormElement"){
colName = psConfigRows[index]["DATATYPE"] + psConfigRows[index]["ROWINDEX"] + psConfigRows[index]["COLUMNINDEX"];
displayName = psConfigRows[index]["DATAVALUE"];
}
else {
colName = psConfigRows[index]["DATAVALUE"];
var row = _viewDataObject.getFirstRow("SelectColumn","COLUMNALIAS",colName);
if(row == null){
displayName = colName;
}
else {
displayName = row["COLUMNNAME"]; 
}
}
if(_layoutType == "CPS" || _layoutType == "CPSForm"){
vNames[index] = colName;
addViewObject(new Array(colName, displayName, psConfigRows[index]["DATATYPE"],psConfigRows[index]["ROWINDEX"],psConfigRows[index]["COLUMNINDEX"],psConfigRows[index]["COLSPAN"], psConfigRows[index]["ROWSPAN"]));
viewObjects[colName]["CREATORCONFIG"] = psConfigRows[index]["CREATORCONFIG"];
}
else if(_layoutType == "SingleColumn"){
if(psConfigRows[index]["DATATYPE"] != "FieldName"){
vNames[actualCount] = colName;
actualCount++;
addViewObject(new Array(colName, displayName, psConfigRows[index]["DATATYPE"],psConfigRows[index]["ROWINDEX"],0,1,1));
}
}
}
}
if(_viewDataObject.containsTable("ACColumnConfiguration")){
var ccRow = _viewDataObject.getRowsForTable("ACColumnConfiguration");
for(var index in ccRow){
if(index=="each"||index=="prototype")
{
break;
}
var ccProps = ccRow[index];
_configName = ccProps["CONFIGNAME"];
var colName = ccProps["COLUMNALIAS"];
var displayName = ccProps["DISPLAYNAME"];
var tableName = colName.substring(0, colName.length - displayName.length - 1);
_viewDataObject.addRowsForTable("TmpViewColumn",new Array(new Array(COLUMNID,colName),new Array(TABLENAME,tableName),new Array(COLUMNNAME,colName),new Array(COLUMNINDEX, index),new Array(DISPLAYNAME,displayName),new Array(COLUMNALIAS,colName),new Array(VISIBLE,ccProps["VISIBLE"]),new Array(SORTENABLED,ccProps["SORTENABLED"]),	new Array(SEARCHENABLED,ccProps["SEARCHENABLED"]),new Array(ACTIONNAME,ccProps["ACTIONNAME"]),new Array(CREATORCONFIG,ccProps["CREATORCONFIG"]), new Array(DEFAULT_TEXT,ccProps["DEFAULT_TEXT"]),new Array(DATE_FORMAT,ccProps["DATE_FORMAT"]),new Array(TRIM_LENGTH,ccProps["TRIM_LENGTH"]),	new Array(TRIM_MSG_LINK,ccProps["TRIM_MSG_LINK"]),new Array(PREFIX_TEXT,ccProps["PREFIX_TEXT"]),new Array(SUFFIX_TEXT,ccProps["SUFFIX_TEXT"]),new Array(SUFFIX_ICON,ccProps["SUFFIX_ICON"]),new Array(PREFIX_ICON,ccProps["ICON"]),new Array(TABLEALIAS,ccProps["TABLEALIAS"]),new Array(LINKVIEWNAME,ccProps["VIEWNAME"]),new Array(VIEWNAME,ccProps["CONFIGNAME"]),new Array(STATIC_TEXT,ccProps["STATIC_TEXT"]), new Array("ReferenceTable",""), new Array("ServerValue",""), new Array("ClientValue",""), new Array("TRUE",""), new Array("FALSE",""), new Array("ISNULLABLE",ccProps["ISNULLABLE"]),new Array("CSSCLASS",ccProps["CSSCLASS"]), new Array("ISHEADERVISIBLE", ccProps["ISHEADERVISIBLE"]), new Array("MENUID", ccProps["MENUID"]), new Array("TRANSFORMER",ccProps["TRANSFORMER"])));
if(viewObjects[colName] != null){
viewObjects[colName]["CREATORCONFIG"] = ccProps["CREATORCONFIG"];
}
var acrenderer = _viewDataObject.getRows("ACRendererConfiguration","COLUMNALIAS",colName);
var row = _viewDataObject.getFirstRow("TmpViewColumn","COLUMNALIAS",colName);
for(idx in acrenderer){
if(idx=="each"||idx=="prototype")
{
break;
}
if(acrenderer[idx]["PROPERTYNAME"] == 'ReferenceTable' || acrenderer[idx]["PROPERTYNAME"] == 'ServerValue' || acrenderer[idx]["PROPERTYNAME"] == 'ClientValue' || acrenderer[idx]["PROPERTYNAME"] == 'TRUE' || acrenderer[idx]["PROPERTYNAME"] == 'FALSE'){
row[acrenderer[idx]["PROPERTYNAME"]] = acrenderer[idx]["PROPERTYVALUE"];
}
}
}
}
return vNames;
}
function dummy(){
document.getElementById(_insId).parentNode.parentNode.parentNode.innerHTML = "<table style='border:1px #FF0000' cellpadding='0' cellspacing='1' bgcolor='#CBC0AB'><tr id='previewTableContainerRow' class='tableHeader'><td>" + currentGrid + "</td></tr></table>";
}
function addPSConfigTable(rowIndex, columnIndex, dataType, dataValue,rowspan,colspan, creatorConfig){
var colWidth = 100/_columnCount;
var width = parseInt(colspan * colWidth);
if(creatorConfig != null){
_viewDataObject.addRowsForTable("ACPSConfiguration",
new Array(new Array("CONFIGNAME", _PSConfigName),
new Array("ROWINDEX",rowIndex),
new Array("COLUMNINDEX",columnIndex),
new Array("DATATYPE",dataType),
new Array("DATAVALUE",dataValue),
new Array("ROWSPAN",rowspan),
new Array("COLSPAN",colspan),
new Array("WIDTH",width),
new Array("CREATORCONFIG",creatorConfig)
));
}
else {
_viewDataObject.addRowsForTable("ACPSConfiguration",
new Array(new Array("CONFIGNAME", _configName),
new Array("ROWINDEX",rowIndex),
new Array("COLUMNINDEX",columnIndex),
new Array("DATATYPE",dataType),
new Array("DATAVALUE",dataValue),
new Array("ROWSPAN",rowspan),
new Array("WIDTH",width),
new Array("COLSPAN",colspan)
));
}
}
function getCellConstructForField(values){
var colWidth = 100/_columnCount;
var outerTable = "<TD valign='top' ";
outerTable = outerTable.concat("colspan = '" + values[0] + "' ");
outerTable = outerTable.concat("rowspan = '" + values[1] + "' ");
outerTable = outerTable.concat("width = '" + (colWidth*values[0]) + "%'");
outerTable = outerTable.concat("height = '" + values[1] + "px'");
if(values[2]){
outerTable = outerTable.concat(" class='lastDragged' ")
}
outerTable = outerTable.concat(">");
return outerTable;
}
function createInnerTable(values){
var viewProps = values[0];
var index = values[1];
var innerTable = "";
var viewName = viewProps["VIEWID"];
var description = viewProps["DESCRIPTION"];
var title = viewProps["TITLE"];
var isDummy = viewProps["ISDUMMY"];
var rowIndex = viewProps["ROWINDEX"];
var colIndex = viewProps["COLUMNINDEX"];
var type = description;
var css = "";
var inpObj = document.getElementById(viewName + "_IN");
var inputClass = "";
if(inpObj != null && inpObj.value != ""){
title = inpObj.value;
viewProps["TITLE"] = inpObj.value;
}
if(type == "Label"){
css = "PSLabel";
}
else if(type == "FieldName"){
css = "PSFieldName";
}
else if(type == "Text"){
css = "PSText";
}
else if(type == "ButtonPanel"){
css = "PSButtonPanel";
}
else {
css = "PSFieldValue";
inputClass = "hide";
}
var height = 20;
if(viewProps["ROWSPAN"] > 1){
height = 20 * viewProps["ROWSPAN"];
}
if(currentViewInEdit == viewName){
var html = document.getElementById("EditMode").innerHTML;
var newHtml = html.replace("$TOPIMAGES", getTopButtons(viewProps));
newHtml = newHtml.replace("$LEFTIMAGES", getLeftButtons(viewProps));
newHtml = newHtml.replace("$RIGHTIMAGES", getRightButtons(viewProps));
newHtml = newHtml.replace("$BOTTOMIMAGES", getBottomButtons(viewProps));
if(inputClass != "hide"){
newHtml = newHtml.replace("$IPTITLE", title);
newHtml = newHtml.replace("$TITLE", "");
}
else {
newHtml = newHtml.replace("$TITLE", title);
newHtml = newHtml.replace("$IPTITLE", "");
}
newHtml = newHtml.replace("$CLASS", inputClass);
newHtml = newHtml.replace("$VIEWNAME", viewName);
newHtml = newHtml.replace('$HEIGHT', height - 5);
innerTable = innerTable.concat(newHtml);
}
else {
var html = document.getElementById("PlacedView").innerHTML;
if(_layoutType == "SingleColumn" || _layoutType == "Table"){
html = document.getElementById("SingleColumnView").innerHTML;
}
if(viewName.indexOf("DummyEnd") >= 0){
html = document.getElementById("EndDummyView").innerHTML;
height = 20;
}
else if(viewName.indexOf("Dummy") >= 0){
html = document.getElementById("DummyView").innerHTML;
height = 20;
}
var newHtml = html.replace(/\$ID/g, index);
newHtml = newHtml.replace('$HEIGHT', height);
newHtml = newHtml.replace(/\$CLASS/g, css);
newHtml = newHtml.replace(/\$VN/g, viewName);
newHtml = newHtml.replace(/\$DESC/g, description);
newHtml = newHtml.replace(/\$RID/g, rowIndex);
newHtml = newHtml.replace(/\$CID/g, colIndex);
newHtml = newHtml.replace(/\$TITLE/g, getTrimmedString(title, 15, "..."));
newHtml = newHtml.replace(/\$METHOD/g, "invokeColumnProperties(document.getElementById('_ev"+index+"'));");
if(type == "FieldValue" || type == "FormElement"){
var row = _viewDataObject.getFirstRow("TmpViewColumn","COLUMNALIAS",viewName);
newHtml = newHtml.replace(/\$ICON/g, row[ICON]);
newHtml = newHtml.replace(/\$SI/g, row[SUFFIX_ICON]);
newHtml = newHtml.replace(/\$PT/g, getTrimmedString(row[PREFIX_TEXT],3,"."));
newHtml = newHtml.replace(/\$ST/g, getTrimmedString(row[SUFFIX_TEXT],3,"."));
}
else {
newHtml = newHtml.replace(/\$ICON/g, "");
newHtml = newHtml.replace(/\$SI/g, "");
newHtml = newHtml.replace(/\$PT/g, "");
newHtml = newHtml.replace(/\$ST/g, "");
}
innerTable = innerTable.concat(newHtml);				
}
if(document.getElementById("RVL1") != null){
document.getElementById("RVL1").className = "cursor viewNotSelected psContent";
}
return innerTable;
}
function getTrimmedString(string, charCount, sufText){
if(string == null){
return "";
}
if(string.length > charCount){
return string.substring(0, charCount) + sufText;
}
return string;
}
function invokeChangeLabel(curLabelObj){
selectedView = curLabelObj.getAttribute("viewName");
document.ViewCreationPropsForm.labelType.value = curLabelObj.getAttribute("desc");
var title = viewObjects[selectedView]["TITLE"];
document.ViewCreationPropsForm.DISPLAYNAME.value = title;
}
function updateDisplayNameforFormElement(elem){
var val = elem.value;
var name = elem.name;
var viewProps = viewObjects[selectedView];
if(val != null && val != ""){
viewProps["TITLE"] = val;
selectedObj.setAttribute("title", val);
var charCount = elem.getAttribute("charsize");
var sufText = elem.getAttribute("suftext");
document.getElementById(selectedView+"_"+name+"_PH").innerHTML="&nbsp;" + getTrimmedString(val, charCount, sufText) + "&nbsp;";
}
else {
viewProps["TITLE"] = "";
selectedObj.setAttribute("title", "");
document.getElementById(selectedView+"_"+name+"_PH").innerHTML="";
}
}
var selectedView = null;
var selectedObj = null;
function showElementById(elementId){
if(document.getElementById(elementId) != null){
document.getElementById(elementId).className = "show";
}
}
function hideElementById(elementId){
if(document.getElementById(elementId) != null){
document.getElementById(elementId).className = "hide";
}
}
function invokeColumnProperties(obj){
if(selectedView != null){
if(_viewDataObject.getFirstRow("TmpViewColumn","COLUMNALIAS",selectedView) != null){
focusLost(selectedView);
}
if(_layoutType != "Table" && document.getElementById(selectedView + "_R") != null){
document.getElementById(selectedView + "_R").className = "hide";
}
selectedObj.className = selectedObj.className.substring(0, selectedObj.className.indexOf("lastDragged"));
}
selectedObj = obj;
selectedObj.className = selectedObj.className + "  lastDragged";
selectedView = obj.getAttribute('viewName');
if(_layoutType != "Table" && document.getElementById(selectedView + "_R") != null){
document.getElementById(selectedView + "_R").className = "resizeButton";
}
var title = viewObjects[selectedView]["TITLE"];
var dataType = obj.getAttribute("desc");
var formElements = document.ViewCreationPropsForm.elements;
var colProps = _viewDataObject.getFirstRow("TmpViewColumn","COLUMNALIAS",selectedView);
if(colProps != null){
document.getElementById("selCol").innerHTML = " - " + title + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>TableName</b> : " + colProps["TABLENAME"];
}
else {
document.getElementById("selCol").innerHTML = " - " + title;
}
for(var count=0; count < formElements.length; count++){
var type = formElements[count].type;
var name = formElements[count].name;
if(name == "LINKVIEW_OR_ACTIONNAME" && dataType != "FieldName" && dataType != "Label"){
if(colProps[LINKVIEWNAME]) 
{
formElements[count].value = colProps[LINKVIEWNAME] ;
}
else
{
formElements[count].value = colProps[ACTIONNAME] ;
}
}
else if(colProps != null){
if(type == "text"){
formElements[count].value = colProps[name];
}
else if(type == "radio" || type == "checkbox"){
if(colProps[name].indexOf("true") != -1){
formElements[count].checked = true;
}
else{
formElements[count].checked = false;
}
}
else if(type == "select-one"){
formElements[count].options[0].selected = true;
formElements[count].value = colProps[name];
if(name == "CREATORCONFIG"){
hideElementById("SelectProps");
hideElementById("BooleanProps");
for(var i = 0; i < formElements[count].options.length; i++)
{
if(formElements[count].options[i].value == colProps[name]){
type = formElements[count].options[i].getAttribute("type");
}
}
if(type == "Select"){
showElementById("SelectProps");
}
else if(type == "Radio"){
showElementById("BooleanProps");
}
}
}
}
}
hideLinkProps();
constructLinkParams();
if(dataType == "FieldValue" || dataType == "FormElement"){
showElementById("FieldValueProps");
hideElementById("FieldNameProps");
}
else {
showElementById("FieldNameProps");
hideElementById("FieldValueProps");
invokeChangeLabel(obj);
}
}
function skipRemovedViews(){
}
function updateDOForCPS(){
var size = viewNames.length;
_viewDataObject.deleteAllRowsInTable("ACPSConfiguration","CONFIGNAME",_PSConfigName);
for(var i=0; i< size;i++){
var viewProps = viewObjects[viewNames[i]];
if(viewProps["TITLE"] == "Dummy"){
addPSConfigTable(viewProps["ROWINDEX"],viewProps["COLUMNINDEX"],"DummyCell"," ",viewProps["ROWSPAN"],viewProps["COLSPAN"]);
}
else {
if(_layoutType == "CPSForm"){
if(viewProps["CREATORCONFIG"] != null && viewProps["CREATORCONFIG"] != ""){
if(viewProps["DESCRIPTION"] == "FieldValue"){
viewProps["DESCRIPTION"] = "FormElement";
}
}
}
addPSConfigTable(viewProps["ROWINDEX"],viewProps["COLUMNINDEX"],viewProps["DESCRIPTION"],viewProps["TITLE"],viewProps["ROWSPAN"],viewProps["COLSPAN"], viewProps["CREATORCONFIG"]);
}
}
if(!_viewDataObject.containsTable('ACFormConfig') && _layoutType == "CPSForm"){
_viewDataObject.addRowsForTable("ACFormConfig",
new Array(new Array("NAME", _configName),
new Array("ISREADMODE","false"),
new Array("COLUMNCONFIGLIST",_configName),
new Array("LAYOUTCONFIGLIST",_configName),
new Array("FORMTYPE",_formType),
new Array("CVNAME",_configName),
new Array("FAILUREMESSAGE","Failure"),
new Array("SUCCESSMESSAGE","Success")
));
}
}
function updateCreatorConfig(selectObj){
if(selectedView != null){
var tmpRow = _viewDataObject.getFirstRow("TmpViewColumn","COLUMNALIAS",selectedView);
tmpRow["CREATORCONFIG"] = selectObj.value;
}
for(var i = 0; i < selectObj.options.length; i++)
{
if(selectObj.options[i].value == selectObj.value){
var type = selectObj.options[i].getAttribute("type");
hideElementById('SelectProps');
hideElementById('BooleanProps');
var tmpRow = _viewDataObject.getFirstRow("TmpViewColumn","COLUMNALIAS",selectedView);
if(type == 'Select'){
showElementById('SelectProps');
}
else if(type == 'Radio'){
showElementById('BooleanProps');
}
else {
tmpRow["ReferenceTable"] = "";
tmpRow["ServerValue"] = "";
tmpRow["ClientValue"] = "";
tmpRow["TRUE"] = "";
tmpRow["FALSE"] = "";
}
}
}
}
function constructSelectColumnViews(selectObj){
var rows = _viewDataObject.getRowsForTable("SelectTable");
var obj = document.getElementById(selectObj);
if(rows != null && rows != "Undefined"){
for(var index in rows){
if(index=="each"||index=="prototype")
{
break;
}
var tableAlias = rows[index]["TABLEALIAS"]; 
obj.options[obj.options.length] = new Option(tableAlias, tableAlias, true, false);
}
obj.options[1].selected = true;
fetchColumnsForTable(rows[0]["TABLEALIAS"]);
}
}
var _totalColumnsForTable = 0;
function fetchColumnsForTable(tableName){
var rows = null;
if(tableName == "*"){
rows = _viewDataObject.getRowsForTable("SelectColumn");
}
else{
rows = _viewDataObject.getRows("SelectColumn","TABLEALIAS",tableName); 
}
var completeCode = "";
for(var index in rows){
if(index=="each"||index=="prototype")
{
break;
}
var colAlias = rows[index]["COLUMNALIAS"]; 
var html = "<table cellspacing='0' id='LVAC" + index + "' class='cursor viewNotSelected' idx='"+index+"' onMouseDown=\"startDrag(event,'LVAC"+index+"')\" viewName='"+colAlias+"' title='"+rows[index]["COLUMNNAME"]+"' desc='FieldValue'><tr><td width='24px;'><button class='smDragButton' value=' ' onClick='return false;'></button></td><td class='smContent'>" + rows[index]["COLUMNNAME"] + "&nbsp;</td></tr></table>";
completeCode = completeCode.concat(html);
_totalColumnsForTable = index;
}
if(index > 10){
completeCode = completeCode.concat("<table cellspacing='0' cellpadding='0' width='200px'><tr><td><span class='show' id='disablePrevious'>Previous</span><span class='hide' id='enablePrevious'><a href='javascript:showPreviousSetOfColumns()'>Previous</a></span></td><td align='right'><span id='disableNext' class='hide'>Next</span><span class='show' id='enableNext'><a href='javascript:showNextSetOfColumns()'>Next</a></span></td></tr></table>");
}
document.getElementById("availableViews").innerHTML = completeCode;
disableSelectedViews(document);
showColumnsInRange(0,10);
}
var currentToIndex = 0;
function showPreviousSetOfColumns(){
if(currentToIndex - 10 <= 0){
document.getElementById('disablePrevious').className = "show";
document.getElementById('enablePrevious').className = "hide";
}
document.getElementById('enableNext').className = "show";
document.getElementById('disableNext').className = "hide";
showColumnsInRange(currentToIndex-20, currentToIndex-10);
}
function showNextSetOfColumns(){
if((currentToIndex + 10) >= _totalColumnsForTable){
document.getElementById('disableNext').className = "show";
document.getElementById('enableNext').className = "hide";
}
document.getElementById('enablePrevious').className = "show";
document.getElementById('disablePrevious').className = "hide";
showColumnsInRange(currentToIndex, currentToIndex + 10);
}
function showColumnsInRange(fromIndex, toIndex){
var elements = document.getElementsByTagName("table");
for(var count = 0; count < elements.length; count++){
var elem = elements[count];
if(elem.id.indexOf("LVAC") >= 0){
var idx = parseInt(elem.getAttribute("idx"),10);
if(idx >= fromIndex && idx < toIndex){
elem.style.display = "block";
}
else {
elem.style.display = "none";
}
}
}
currentToIndex = toIndex;
}
var addCount = 0;
var newLabels = new Array;
function createLabel(labelType){
var newTitle = document.newViewForm.newViewText.value;
if(newTitle != null && newTitle != ""){
addEmptyRow();
var newViewName = labelType + "_" + addCount + "0";
newLabels.splice(0,0,new Array(newViewName,newTitle));
addCount++;
}
constructLabelsView();
disableSelectedViews(document);
}
function constructLabelsView(){
var completeCode = ""
for(var i = 0; i<newLabels.length;i++){
var html = "<br><table cellspacing='0' cellpadding='0' width='200px' id='LVL" + i + "' class='cursor viewNotSelected' onMouseDown=\"startDrag(event,'LVL"+i+"')\" viewName='"+newLabels[i][0]+"' title='"+newLabels[i][1]+"' desc='FieldName'><tr><td width='24px;'><button class='smDragButton' value=' ' onClick='return false;'></button></td><td class='smContent'>" + newLabels[i][1] + "&nbsp;</td></tr></table>";
completeCode = completeCode.concat(html);
}
document.getElementById("newViewPH").innerHTML = completeCode;
}
function updatePropsForFormColumn(elem, preview){
var val = elem.value;
var name = elem.name;
var rowObj = _viewDataObject.getFirstRow("TmpViewColumn", "COLUMNALIAS", selectedView);
if(name == "LINKVIEW_OR_ACTIONNAME"){
if(document.getElementById("ISLINKVIEW").value == "true")
{
rowObj[LINKVIEWNAME] = val;
rowObj[ACTIONNAME] = null;
}
else
{
rowObj[ACTIONNAME] = val;
rowObj[LINKVIEWNAME] = null;
}
return;
}
if(elem.type == "checkbox"){
if(elem.checked){
rowObj[name] = "true";
}
else {
rowObj[name] = "false";
}
}
else if(val != null && val != ""){
rowObj[name] = val;
if(preview){
var charCount = elem.getAttribute("charsize");
var sufText = elem.getAttribute("suftext");
document.getElementById(selectedView+"_"+name+"_PH").innerHTML="&nbsp;" + getTrimmedString(val, charCount, sufText) + "&nbsp;";
}
}
else {
rowObj[name] = "";
if(preview){
document.getElementById(selectedView+"_"+name+"_PH").innerHTML="";
}
}
}
function showRequiredSections(linkNames){
for(var i=0; i< linkNames.length;i++){
document.getElementById(linkNames[i]).className="";
}
}
function hideUnwantedSections(linkNames){
for(var i=0; i< linkNames.length;i++){
document.getElementById(linkNames[i]).className="hide";
}
}
function updateLabelType(elem){
var viewProps = viewObjects[selectedView];
viewProps["DESCRIPTION"] = elem.value;
invokeMethod("createTable");
}
var _newViewTitle = null;
var _newViewName = null;
function fetchViewName(){
if(!_isViewAlreadyCreated || _newViewName == null){
_viewDataObject.deleteAllRowsInTable("ViewConfiguration","VIEWNAME",_newViewName);
_viewDataObject.deleteAllRowsInTable("CustomViewConfiguration","CVNAME",_newViewName);
_viewDataObject.deleteAllRowsInTable("ACColumnConfigurationList","NAME",_newViewName);
_viewDataObject.deleteAllRowsInTable("ACPSConfigList","NAME",_newViewName);
_viewDataObject.deleteAllRowsInTable("ACTableViewConfig","NAME",_newViewName);
_viewDataObject.deleteAllRowsInTable("ACFormConfig","NAME",_newViewName);
_newViewTitle = prompt("Enter a Name for the view ?");
if(_newViewTitle == null){
return;
}
_newViewName = _newViewTitle.replace(/\ /g,"_");
_configName = _newViewName;
_PSConfigName = _newViewName;
}
else {
_newViewTitle = _newViewName;
}
}
function addViewConfigurationTable(){
var tableRows = _viewDataObject.getRowsForTable("ViewConfiguration");
if(tableRows == null || tableRows.length <= 0 ){
var componentName = "ACTable";
if(_layoutType == "CPS" || _layoutType == "SingleColumn"){
componentName = "ACPSTable";
}
if(_layoutType == "CPSForm"){
componentName = "ACForm";
}
_viewDataObject.addRowsForTable("ViewConfiguration", new Array(new Array("VIEWNAME",_newViewName), new Array("COMPONENTNAME",componentName),new Array("TITLE",_newViewTitle), new Array("DESCRIPTION", _newViewTitle)));
}
}
function addCustomViewConfigurationTable(){
var tableRows = _viewDataObject.getRowsForTable("CustomViewConfiguration");
if(tableRows == null || tableRows.length <= 0 ){
var rows = _viewDataObject.getRowsForTable("SelectColumn");
if(rows != "" && rows != null){
var queryId = rows[0]["QUERYID"];
_viewDataObject.addRowsForTable("CustomViewConfiguration", new Array(new Array("QUERYID",queryId), new Array("CVNAME",_newViewName),new Array("CVID","CustomViewConfiguration:CVID:" + _newViewName)));
_CVName = _newViewName;
}
}
else{
_CVName = tableRows[0]["CVID"];
}
}
function addACColumnConfigurationTable(){
_viewDataObject.deleteAllRowsInTable("ACColumnConfiguration","CONFIGNAME",_configName);
_viewDataObject.deleteAllRowsInTable("ACColumnConfiguration","CONFIGNAME","Untitled");
_viewDataObject.deleteAllRowsInTable("ACRendererConfiguration","CONFIGNAME",_configName);
_viewDataObject.deleteAllRowsInTable("ACColumnConfiguration","CONFIGNAME",_newViewName);
var count = 0;
for(var index in viewNames){
if(index=="each"||index=="prototype")
{
break;
}
var viewProps = viewObjects[viewNames[index]];
if(viewProps["DESCRIPTION"] == 'FieldValue' || viewProps["DESCRIPTION"] == 'FormElement'){
var rows = _viewDataObject.getRows("TmpViewColumn","COLUMNALIAS",viewProps["VIEWID"]);
var row = rows[0];
var displayName = viewProps["TITLE"];
var transformer = row["TRANSFORMER"];
if(row["ReferenceTable"] != "undefined" && row["ReferenceTable"] != null && row["ServerValue"] != null && row["ReferenceTable"] != "" && row["ServerValue"] != ""){
transformer = 'com.adventnet.client.components.form.web.DiscreteFormTransformer';
_viewDataObject.addRowsForTable("ACRendererConfiguration", new Array(new Array("CONFIGNAME", _configName), new Array("COLUMNALIAS", row["COLUMNALIAS"]), new Array("PROPERTYNAME", "ReferenceTable"), new Array("PROPERTYVALUE", row["ReferenceTable"])));
_viewDataObject.addRowsForTable("ACRendererConfiguration", new Array(new Array("CONFIGNAME", _configName), new Array("COLUMNALIAS", row["COLUMNALIAS"]), new Array("PROPERTYNAME", "ServerValue"), new Array("PROPERTYVALUE", row["ServerValue"])));
if(row["ClientValue"] != null && row["ClientValue"] != ""){
_viewDataObject.addRowsForTable("ACRendererConfiguration", new Array(new Array("CONFIGNAME", _configName), new Array("COLUMNALIAS", row["COLUMNALIAS"]), new Array("PROPERTYNAME", "ClientValue"), new Array("PROPERTYVALUE", row["ClientValue"])));
}
}
else if(row["TRUE"] != "undefined" && row["TRUE"] != null && row["FALSE"] != null && row["TRUE"] != "" && row["FALSE"] != ""){
transformer = 'com.adventnet.client.components.form.web.BooleanFormTransformer';
_viewDataObject.addRowsForTable("ACRendererConfiguration", new Array(new Array("CONFIGNAME", _newViewName), new Array("COLUMNALIAS", row["COLUMNALIAS"]), new Array("PROPERTYNAME", "TRUE"), new Array("PROPERTYVALUE", row["TRUE"])));
_viewDataObject.addRowsForTable("ACRendererConfiguration", new Array(new Array("CONFIGNAME", _newViewName), new Array("COLUMNALIAS", row["COLUMNALIAS"]), new Array("PROPERTYNAME", "FALSE"), new Array("PROPERTYVALUE", row["FALSE"])));
}
_viewDataObject.addRowsForTable("ACColumnConfiguration",new Array(new Array("CONFIGNAME",_configName), new Array("COLUMNINDEX", count),new Array("COLUMNALIAS",row["COLUMNALIAS"]),new Array("DISPLAYNAME", displayName),new Array("VISIBLE",row["VISIBLE"]),new Array("SORTENABLED",row["SORTENABLED"]),new Array("ACTIONNAME",row["ACTIONNAME"]),new Array("SEARCHENABLED", row["SEARCHENABLED"]),new Array("CREATORCONFIG", row["CREATORCONFIG"]), new Array("DEFAULT_TEXT", row[DEFAULT_TEXT]), new Array("DATE_FORMAT", row[DATE_FORMAT]),new Array("ICON",row[PREFIX_ICON]), new Array("SUFFIX_ICON", row[SUFFIX_ICON]), new Array("PREFIX_TEXT", row[PREFIX_TEXT]), new Array("SUFFIX_TEXT", row[SUFFIX_TEXT]), new Array("VIEWNAME", row["LINKVIEWNAME"]), new Array("TRANSFORMER", transformer), new Array("ISNULLABLE",row["ISNULLABLE"]), new Array("CSSCLASS",row["CSSCLASS"]), new Array("STATIC_TEXT", row[STATIC_TEXT]), new Array("TRIM_LENGTH", row["TRIM_LENGTH"]),new Array("TRIM_MSG_LINK", row["TRIM_MSG_LINK"]), new Array("ISHEADERVISIBLE", row["ISHEADERVISIBLE"]), new Array("MENUID", row["MENUID"])));
count++;
}
}
}
function populateRequiredRows(){
if(_newViewTitle == null){
return false;
}
if(selectedView != null){
var viewProps = viewObjects[selectedView];
if(viewProps["DESCRIPTION"] == "FieldValue"){
focusLost(selectedView);
}
}
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
canAddPlaceHolders = false;
reCalculateTableData();
var size = viewNames.length;
addViewConfigurationTable();
addCustomViewConfigurationTable();
var tableRows = _viewDataObject.getRowsForTable("ACColumnConfigurationList");
if(tableRows == null || tableRows.length <= 0 ){
_viewDataObject.addRowsForTable("ACColumnConfigurationList", new Array(new Array("NAME",_newViewName)));
}
else{
_configName=tableRows[0]["NAME_NO"]
}
tableRows = _viewDataObject.getRowsForTable("ACPSConfigList");
if(tableRows == null || tableRows.length <= 0 ){
_viewDataObject.addRowsForTable("ACPSConfigList", new Array(new Array("NAME",_newViewName)));
}
addACColumnConfigurationTable();
_viewDataObject.deleteAllRowsInTable("ACPSConfiguration","CONFIGNAME",_PSConfigName);
_viewDataObject.deleteAllRowsInTable("ACPSConfiguration","CONFIGNAME","Untitled");
_viewDataObject.setColumn("ACLinkParams","CONFIGNAME",_configName);
if(_viewDataObject.containsTable("TemplateViewParams")){
_viewDataObject.setColumn("TemplateViewParams","VIEWNAME",_newViewName);
}
if(_viewDataObject.getRowsForTable("SelectQuery") != null && _viewDataObject.getRowsForTable("SelectQuery") != "Undefined"){
var queryId = _viewDataObject.getRowsForTable("SelectQuery")[0]["QUERYID"];	
if(_viewDataObject.containsTable("TemplateViewParams") && _layoutType=="CPSForm" ){
_viewDataObject.deleteAllRowsInTable("SelectQuery","QUERYID",queryId);
_viewDataObject.deleteAllRowsInTable("SelectColumn","QUERYID",queryId);
_viewDataObject.deleteAllRowsInTable("SelectTable","QUERYID",queryId);
_viewDataObject.deleteAllRowsInTable("JoinTable","QUERYID",queryId);
_viewDataObject.deleteAllRowsInTable("JoinColumns","QUERYID",queryId);
_viewDataObject.deleteAllRowsInTable("Criteria","QUERYID",queryId);
_viewDataObject.deleteAllRowsInTable("RelationalCriteria","QUERYID",queryId);
_viewDataObject.deleteAllRowsInTable("CustomViewConfiguration","QUERYID",queryId);
}
}
var tmpRows = _viewDataObject.getRowsForTable("TmpViewDetails");
tmpRows[0]["VIEWNAME"]  = _newViewName;
tmpRows[0]["TITLE"]  = _newViewTitle;
delete tmpRows[0]["VIEWNAME_NO"];
if(_layoutType != "Table"){
for(var i=0; i< size;i++){
var viewProps = viewObjects[viewNames[i]];
if(viewProps["TITLE"] == "Dummy"){
addPSConfigTable(viewProps["ROWINDEX"],viewProps["COLUMNINDEX"],"DummyCell"," ",viewProps["ROWSPAN"],viewProps["COLSPAN"]);
}
else {
if(_layoutType == "CPSForm"){
if(viewProps["CREATORCONFIG"] != null && viewProps["CREATORCONFIG"] != ""){
if(viewProps["DESCRIPTION"] == "FieldValue"){
viewProps["DESCRIPTION"] = "FormElement";
}
}
}
var dataValue = viewProps["VIEWID"];
if(viewProps["DESCRIPTION"] != "FieldValue" && viewProps["DESCRIPTION"] != "FormElement")
{
dataValue = viewProps["TITLE"];
}
if(_layoutType == "SingleColumn"){
addPSConfigTable(viewProps["ROWINDEX"],0,"FieldName",viewProps["TITLE"],1,1);
addPSConfigTable(viewProps["ROWINDEX"],1,"FieldValue",dataValue,1,1);
}
else {
if(viewProps["DESCRIPTION"] == "ButtonPanel"){
addPSConfigTable(viewProps["ROWINDEX"],viewProps["COLUMNINDEX"],viewProps["DESCRIPTION"],dataValue,viewProps["ROWSPAN"],viewProps["COLSPAN"], viewProps["CREATORCONFIG"]);
}
else{
addPSConfigTable(viewProps["ROWINDEX"],viewProps["COLUMNINDEX"],viewProps["DESCRIPTION"],dataValue,viewProps["ROWSPAN"],viewProps["COLSPAN"], "");
}
}
}
}
}
var tmpColRows = _viewDataObject.getRowsForTable("TmpViewColumn");
for(idx in tmpColRows){
if(idx=="each"||idx=="prototype")
{
break;
}
tmpColRows[idx][COLUMNID] = idx;
}
if(_layoutType == "CPSForm"){
tableRows = _viewDataObject.getRowsForTable("ACFormConfig");
if(tableRows == null || tableRows.length <= 0 ){
_viewDataObject.addRowsForTable("ACFormConfig", new Array(new Array("NAME", _newViewName), new Array("ISREADMODE","false"), new Array("COLUMNCONFIGLIST",_configName), new Array("LAYOUTCONFIGLIST",_configName), new Array("FORMTYPE",_formType), new Array("CVNAME",_configName), new Array("FAILUREMESSAGE","Failure"), new Array("SUCCESSMESSAGE","Success")));
}
_viewDataObject.setColumn("ACFormConfig","CVNAME",_newViewName);
}
else {
tableRows = _viewDataObject.getRowsForTable("ACTableViewConfig");
if(tableRows == null || tableRows.length <= 0 ){
_viewDataObject.addRowsForTable("ACTableViewConfig", new Array(new Array("NAME", _newViewName), new Array("CVNAME",_newViewName), new Array("COLUMNCONFIGLIST",_newViewName), new Array("PSCONFIGLIST",_newViewName), new Array("DISPLAYTYPE","Horizontal"), new Array("NAVIGATIONCONFIG","Normal_Top_10_20"), new Array("DATASOURCENAME",'')));
var navigConfig =  tmpRows[0]["NAVIGATION"];
if(navigConfig != null && navigConfig != ""){
_viewDataObject.setColumn("ACTableViewConfig","NAVIGATIONCONFIG",navigConfig);
}
}
_viewDataObject.setColumn("ACTableViewConfig","CVNAME",_CVName);
_viewDataObject.setColumn("ACTableViewConfig","COLUMNCONFIGLIST",_configName);
_viewDataObject.setColumn("ACTableViewConfig","PSCONFIGLIST",_PSConfigName);
_viewDataObject.setColumn("ACTableViewConfig","NAME",_newViewName);
if(_mdsName != "" && _mdsName != null){
_viewDataObject.setColumn("ACTableViewConfig","DATASOURCENAME",_mdsName);
}
}
}
var _isViewAlreadyCreated = false;
function setExistingViewName(viewName, existingViewName){
_isViewAlreadyCreated = true;
_newViewName = viewName;
}
function addNewColumn(viewProperties){
addRuntimeObject(viewProperties);
var colName = viewProperties[0];
var colTitle = viewProperties[1];
var props = viewObjects[colName];
var tableName = colName.substring(0, colName.length - colTitle.length - 1);
var row = _viewDataObject.getRows("TmpViewColumn","COLUMNALIAS",colName);
if(row.length == 0){
_viewDataObject.addRowsForTable("TmpViewColumn",new Array(new Array(COLUMNID,colName),new Array(TABLENAME,tableName),new Array(COLUMNNAME,colName),new Array(COLUMNINDEX, -1),new Array(DISPLAYNAME,colTitle),new Array(COLUMNALIAS,colName),new Array(VISIBLE,"true"),new Array(SORTENABLED,"true"),	new Array(SEARCHENABLED,"false"),new Array(ACTIONNAME,""),new Array(CREATORCONFIG,""), new Array(DEFAULT_TEXT,""),new Array(DATE_FORMAT,""),new Array(TRIM_LENGTH,""),	new Array(TRIM_MSG_LINK,""),new Array(PREFIX_TEXT,""),new Array(SUFFIX_TEXT,""),new Array(SUFFIX_ICON,""),new Array(PREFIX_ICON,""),new Array(TABLEALIAS,""),new Array(LINKVIEWNAME,""),new Array(VIEWNAME,""),new Array(STATIC_TEXT,""), new Array("ISNULLABLE",""), new Array("CSSCLASS",""), new Array("ISHEADERVISIBLE", ""), new Array("MENUID",""), new Array("TRANSFORMER","com.adventnet.client.components.table.web.DefaultTransformer")));
}
}
function createTableAndSelectColumn(){
var currentViewName = draggedViewName;
createTable();
for(var count=0; count<viewNames.length;count++){
if(viewNames[count] == currentViewName || viewNames[count] == selectedView){
invokeColumnProperties(document.getElementById("_ev"+count));
}
}
}
function showAdvancedProps(){
if(document.getElementById("tableProperties") != null){
document.getElementById("tableProperties").className = "";
document.getElementById("advProps").innerHTML = "<a href='javascript:hideAdvancedProps();'>Hide Advanced Properties</a>";
}
}
function hideAdvancedProps(){
if(document.getElementById("tableProperties") != null){
document.getElementById("tableProperties").className = "hide";
document.getElementById("advProps").innerHTML = "<a href='javascript:showAdvancedProps();'>Show Advanced Properties</a>";
}
}
function showLinkProps(){
if(document.getElementById("linkProperties") != null){
document.getElementById("linkProperties").className = "";
document.getElementById("linkProps").innerHTML = "<a href='javascript:hideLinkProps();'>Hide Link Properties</a>";
}
}
function hideLinkProps(){
if(document.getElementById("linkProperties") != null){
document.getElementById("linkProperties").className = "hide";
document.getElementById("linkProps").innerHTML = "<a href='javascript:showLinkProps();'>Show Link Properties</a>";
}
}
function editTableProperties(){
var data=document.getElementById("EditTableProps").innerHTML;
data = "<form name='TablePropsForm'>" + data  + "</form>";
showDialog(data,"modal=yes");
var rowObj = _viewDataObject.getFirstRow("ACTableViewConfig", "NAME", _configName);
if(rowObj == null){
addACTableViewConfigTable();
}
invokeTableProperties();
}
function addLinkParams() {
if(selectedView == null){
alert("Select a column to configure the link");
return;
}
_viewDataObject.addRowsForTable("ACLinkParams",new Array(new Array("CONFIGNAME", _configName),new Array("COLUMNALIAS", selectedView),new Array("NAME", ""),new Array("VALUE", ""),new Array("SCOPE","")));
constructLinkParams();
alternateRows("propsTable3", "evenRow","oddRow");
}
function constructLinkParams() {
var tableCode = "<table id='propsTable3' width='95%' align='center'><tr class='tableHeader'><th>Scope</th><th> Param Name</th><th> Param Value</th><th nowrap> </th></tr>";
var paramsRow = _viewDataObject.getRows("ACLinkParams","COLUMNALIAS", selectedView);
var avlScopes = new Array("STATIC","REQUEST","STATE","DATAMODEL");
for(var index in paramsRow){
if(index=="each"||index=="prototype")
{
break;
}
var linkProps = paramsRow[index];
tableCode = tableCode.concat("<tr><td><select name=" + linkProps["SCOPE"] + index + " value='" + linkProps["SCOPE"]+ "' onchange='updateLinkParams("+index+", this, \"SCOPE\")'>");
for(var i=0; i<avlScopes.length; i++){
if(avlScopes[i] == linkProps["SCOPE"]){
tableCode = tableCode.concat("<option selected value='" + avlScopes[i] + "'>" + avlScopes[i] + "</option>");
}
else {
tableCode = tableCode.concat("<option value='" + avlScopes[i] + "'>" + avlScopes[i] + "</option>");
}
}
tableCode = tableCode.concat("</select></td>");	
tableCode = tableCode.concat("<td><input onkeyup='updateLinkParams("+index+", this, \"NAME\")' name=" + linkProps["NAME"] + index + " value='" + linkProps["NAME"]+ "' class='txtField'/></td>");
if(linkProps["SCOPE"] == "DATAMODEL"){
tableCode = tableCode.concat("<select name=" + linkProps["VALUE"] + index + " value='" + linkProps["VALUE"]+ "' onchange='updateLinkParams("+index+", this,\"VALUE\")'><option>----------</option>");
var selCols = _viewDataObject.getRowsForTable("SelectColumn");
for(var i=0; i<selCols.length;i++){
var column = selCols[i];
if(linkProps["VALUE"] == column["COLUMNALIAS"]){
tableCode = tableCode.concat("<option value='"+column["COLUMNALIAS"]+"' selected>"+column["COLUMNALIAS"]+"</option>");
}
else {
tableCode = tableCode.concat("<option value='"+column["COLUMNALIAS"]+"'>"+column["COLUMNALIAS"]+"</option>");
}
}
tableCode = tableCode.concat("</select>");
}
else{
tableCode = tableCode.concat("<td><input onkeyup='updateLinkParams("+index+", this, \"VALUE\")' name=" + linkProps["VALUE"] + index + " value='" + linkProps["VALUE"]+ "' class='txtField'/></td>");
}
tableCode = tableCode.concat("<td><a href='javascript:deleteLinkParam(" +index+")'>Delete</a></td></tr>")
}
tableCode = tableCode.concat("</table>");
if(document.getElementById("LinkParams") != null){
document.getElementById("LinkParams").innerHTML = tableCode;
}
}
function deleteLinkParam(ind){
var paramsRow = _viewDataObject.getRows("ACLinkParams","COLUMNALIAS", selectedView);
paramsRow.splice(ind,1);
_viewDataObject.deleteAllRowsInTable("ACLinkParams","COLUMNALIAS",selectedView);
for(var index in paramsRow){
if(index=="each"||index=="prototype")
{
break;
}
var linkProps = paramsRow[index];
_viewDataObject.addRowsForTable("ACLinkParams",new Array(new Array("CONFIGNAME", _configName),new Array("COLUMNALIAS", selectedView),new Array("NAME", linkProps["NAME"]),new Array("VALUE", linkProps["VALUE"]),new Array("SCOPE",linkProps["SCOPE"])));
}
constructLinkParams();
alternateRows("propsTable3", "evenRow","oddRow");
}
function updateLinkParams(index, inpObj, key){
var paramsRow = _viewDataObject.getRows("ACLinkParams","COLUMNALIAS", selectedView);
var linkProps = paramsRow[index];
linkProps[key] = inpObj.value;
if(key == "SCOPE"){
constructLinkParams();
}
}
function updatePropsForTable(elem){
var val = elem.value;
var name = elem.name;
var rowObj = _viewDataObject.getFirstRow("ACTableViewConfig","NAME",_configName);
if(val != null && val != ""){
if(name == "NAVIGATIONCONFIG" && val.indexOf("None") >= 0){
rowObj[name] = "";
}
else{
rowObj[name] = val;
}
}
else {
rowObj[name] = "";
}
}
function invokeTableProperties(){
var colProps = _viewDataObject.getFirstRow("ACTableViewConfig","NAME",_configName);
var formElements = document.TablePropsForm.elements;
for(var count=0; count < formElements.length; count++){
var type = formElements[count].type;
var name = formElements[count].name;
if(colProps != null){
if(type == "text"){
formElements[count].value = colProps[name];
}
else if(type == "select-one"){
formElements[count].options[0].selected = true;
formElements[count].value = colProps[name];
}
}
}
}
function addACTableViewConfigTable(){
_viewDataObject.addRowsForTable("ACTableViewConfig", new Array(new Array("NAME", _configName), new Array("CVNAME",_configName), new Array("COLUMNCONFIGLIST",_configName), new Array("PSCONFIGLIST",_configName), new Array("DISPLAYTYPE","Horizontal"), new Array("NAVIGATIONCONFIG","Normal_Top_10_20"), new Array("DATASOURCENAME",''), new Array("EMPTY_TABLE_MESSAGE","No rows found"), new Array("PAGELENGTH", "10"), new Array("SORTORDER","ASC"), new Array("SORTCOLUMN",""), new Array("COLUMNCHOOSERMENUITEM","CCListInline")));
}
function updateMenuForColumn(elem){
updatePropsForFormColumn(elem, false);
}
