includeJS(CONTEXT_PATH + '/components/javascript/Utils.js',window);
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
var height = 75;
if(viewProps["ROWSPAN"] > 1){
height = 90 * viewProps["ROWSPAN"];
}
if(currentViewInEdit == viewName){
var html = document.getElementById("EditMode").innerHTML;
var newHtml = html.replace("$TOPIMAGES", getTopButtons(viewProps));
newHtml = newHtml.replace("$LEFTIMAGES", getLeftButtons(viewProps));
newHtml = newHtml.replace("$RIGHTIMAGES", getRightButtons(viewProps));
newHtml = newHtml.replace("$BOTTOMIMAGES", getBottomButtons(viewProps));
newHtml = newHtml.replace("$TITLE", title);
newHtml = newHtml.replace('$HEIGHT', height - 15);
innerTable = innerTable.concat(newHtml);
}
else {
var html = document.getElementById("PlacedView").innerHTML;
if(viewName.indexOf("DummyEnd") >= 0){
html = document.getElementById("EndDummyView").innerHTML;
height = 95;
}
else if(viewName.indexOf("Dummy") >= 0){
html = document.getElementById("DummyView").innerHTML;
height = 95;
}
var newHtml = html.replace(/\$ID/g, index);
newHtml = newHtml.replace('$HEIGHT', height);
newHtml = newHtml.replace('$VN', viewName);
newHtml = newHtml.replace('$DESC', description);
newHtml = newHtml.replace(/\$RID/g, rowIndex);
newHtml = newHtml.replace(/\$CID/g, colIndex);
newHtml = newHtml.replace(/\$TITLE/g, title);
innerTable = innerTable.concat(newHtml);				
}
return innerTable;
}
function submitValues(tableLayoutForm){
if(!promptViewTitleIfReq(tableLayoutForm)){
return false;
}         
var size = viewNames.length;
var tempArray = new Array();
var count = 0;
for(var i = 0; i < size; i++){
var rowObject = viewObjects[viewNames[i]];
var isDummy = rowObject["ISDUMMY"];
if(!isDummy){
tempArray[count] = viewNames[i];
count++;
}
}
size = tempArray.length;
for(var i = 0; i < size; i++){
var rowObject = viewObjects[tempArray[i]];
var newrIdx = parseInt(rowObject["ROWINDEX"],10) - 1;
var newcIdx = parseInt(rowObject["COLUMNINDEX"],10) - 1;
tableLayoutForm.TL_VIEWNAMES.options[i] = new Option(rowObject["VIEWID"], rowObject["VIEWID"], true);
tableLayoutForm.TL_TITLE.options[i] = new Option(rowObject["TITLE"], rowObject["TITLE"], true);
tableLayoutForm.TL_DESCRIPTION.options[i] = new Option(rowObject["DESCRIPTION"], rowObject["DESCRIPTION"], true);
tableLayoutForm.TL_ROWINDEX.options[i] = new Option(newrIdx, newrIdx, true);
tableLayoutForm.TL_COLUMNINDEX.options[i] = new Option(newcIdx, newcIdx, true);
tableLayoutForm.TL_ROWSPAN.options[i] = new Option(rowObject["ROWSPAN"], rowObject["ROWSPAN"], true);
tableLayoutForm.TL_COLSPAN.options[i] = new Option(rowObject["COLSPAN"], rowObject["COLSPAN"], true);
tableLayoutForm.TL_VIEWNAMES.options[i].selected = true;;
tableLayoutForm.TL_TITLE.options[i].selected = true;;
tableLayoutForm.TL_DESCRIPTION.options[i].selected = true;;
tableLayoutForm.TL_ROWINDEX.options[i].selected = true;;
tableLayoutForm.TL_COLUMNINDEX.options[i].selected = true;
tableLayoutForm.TL_ROWSPAN.options[i].selected = true;;
tableLayoutForm.TL_COLSPAN.options[i].selected = true;
}
AjaxAPI.submit(tableLayoutForm);
}
function getCellConstructForView(values){
var colWidth = 100/_columnCount;
var outerTable = "<TD valign='top' ";
outerTable = outerTable.concat("colspan = '" + values[0] + "' ");
outerTable = outerTable.concat("rowspan = '" + values[1] + "' ");
outerTable = outerTable.concat("width = '" + (colWidth*values[0]) + "%'");
outerTable = outerTable.concat("height = '" + (75 * values[1]) + "px'");
if(values[2]){
outerTable = outerTable.concat(" class='lastDragged' ")
}
outerTable = outerTable.concat(">");
return outerTable;
}
