function populateValuesForForm(dataObject, formObj){
var formElements = formObj.elements;
for(var count=0; count < formElements.length; count++){
var name = formElements[count].name;
var type = formElements[count].type;
var tableName = formElements[count].getAttribute("tablename");
if(tableName != null && dataObject.containsTable(tableName)){
var colProps = dataObject.getRowsForTable(tableName)[0];
if(colProps){
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
}
}
}
}
}
function updateDataObjectFromForm(dataObject, formObj, mainColumnName, mainColumnTable){
var formElements = formObj.elements;
for(var count=0; count < formElements.length; count++){
var name = formElements[count].name;
var type = formElements[count].type;
var value = formElements[count].value;
var tableName = formElements[count].getAttribute("tablename");
if(tableName != null && !dataObject.containsTable(tableName) && value != null && value != ""){
var mainColumnValue = dataObject.getRowsForTable(mainColumnTable)[0][mainColumnName];
dataObject.addRowsForTable(tableName, new Array(new Array(mainColumnName, mainColumnValue)));
}
if(tableName != null && dataObject.containsTable(tableName)){
var colProps = dataObject.getRowsForTable(tableName)[0];
if(colProps != null && value != null && value != ""){
if(type == "text"){
colProps[name] = formElements[count].value;
}
else if(type == "radio" || type == "checkbox"){
if(formElements[count].checked){
colProps[name] = "true"
}
else{
colProps[name] = "false"
}
}
else if(type == "select-one"){
colProps[name] = formElements[count].value;
}
}
}
}
formObj.DOasXML.value = dataObject.constructXML(); 
}
