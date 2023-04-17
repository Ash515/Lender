function TableModel(uniqueId, columnNames) {
this.uniqueId = uniqueId;
this.columnNames = columnNames;
this.tableRows = new Array();
TableModel._TBL_TABLEMODEL_MGR[uniqueId] = this;
this.add = function(colValues) {
var curRow = new Array();
var argv = arguments;
for(var i =0; i < argv.length;i++)
{
curRow[i] = argv[i];
}
this.tableRows[this.tableRows.length] = curRow;
}
this.getRow = function(rowIndex){
return this.tableRows[rowIndex];
}
this.getValueAt = function(rowIndex, columnIndex){
if(this.tableRows=="")
{
return;
}
return this.tableRows[rowIndex][columnIndex];
}
this.getColumnName = function(colIndex){
return this.columnNames[colIndex];
}
this.getColumnIndex = function(columnName){
for(var count = 0; count < this.columnNames.length; count++){
if(this.columnNames[count] == columnName){
return count;
}
}
return -1;
}
this.getRowCount = function() {
return this.tableRows.length;
}
this.getColumnCount = function() {
return this.columnNames.length;
}
this.addValuesAsHiddenInput = function(frm,rowIndices,colName,inputName,deleteExistingInputs)
{
var colIndex = this.getColumnIndex(colName);	
if(colIndex == -1)
{
throw new Error("Wrong Configuration. Column alias " + colName + " not present in table model.");
}
if(deleteExistingInputs)
{
var inputs = frm[inputName];
if(inputs != null)
{
if(inputs.length == null)
{
inputs = [inputs];
}
inputs = LangUtils.cloneArray(inputs);
for(var i =0;i < inputs.length;i++)
{
inputs[i].parentNode.removeChild(inputs[i]);
}
}
}
for(var count=0; count < rowIndices.length; count++){
var rowVal = rowIndices[count];
var colVal = this.getValueAt(rowVal, colIndex);
if(colVal != null)
{
addHiddenInput(frm,inputName,colVal);
}
}
}
this.getValuesAsURLParams = function(rowIndices,colName,paramName)
{
var colIndex = this.getColumnIndex(colName);	
if(colIndex == -1)
{
throw new Error("Wrong Configuration. Column alias " + colName + " not present in table model.");
}
var queryStr = "";
for(var count=0; count < rowIndices.length; count++){
var rowVal = rowIndices[count];
var colVal = this.getValueAt(rowVal, colIndex);
if(colVal != null)
{
queryStr += ParamsParser.getAsQueryParam(paramName, colVal) + "&";
}
}
if(queryStr.length > 1)
{
queryStr = queryStr.substring(0,queryStr.length -1);
}
return queryStr;
}
}
TableModel._TBL_TABLEMODEL_MGR = new Object();
TableModel.getInstance = function(srcViewRefId)
{
return TableModel._TBL_TABLEMODEL_MGR[getUniqueId(srcViewRefId)];
}
function TableDOMModel(srcViewRefId,columnNames,viewCols,rowSelection)
{
this.viewCols = viewCols;  
this.tBody = null;
this.namedEls = null;
this.rowSelection = rowSelection;
this.base = TableModel;
this.base(srcViewRefId,columnNames);
this.getTBody = function()
{
if(this.tBody == null)
{
var tbl;
if(document.getElementById(this.uniqueId + "_ROWSTABLE")!=null)
tbl = document.getElementById(this.uniqueId + "_ROWSTABLE");
else
tbl = document.getElementById(this.uniqueId + "_TABLE");
this.tBody = DOMUtils.filterElements(tbl.childNodes,"TBODY")[0];
}
return this.tBody;
}
this.getTREl = function(rowidx)
{
if(rowidx > -1)
{
return DOMUtils.filterElements(this.getTBody().childNodes,"TR","rowidx",rowidx)[0];
}
else
{
return this.getNamedEl("COMMONDETAILS").getElementsByTagName("TR")[0];
}
}
this.getViewIndexForCol = function(colName)
{
for(var i = 0; i < this.viewCols.length; i++)
{
if(this.viewCols[i] == colName)
{
return i;
}
}
return -1;
}
this.getCell = function(rowidx,colidx)
{
var tr =  DOMUtils.filterElements(this.getTBody().childNodes,"TR","rowidx",rowidx)[0];
return DOMUtils.filterElements(tr.childNodes,"TD","colidx",colidx)[0];
}
this.closeDetails = function(rowidx, requestOptions,additionalParams,swipe)
{
var filteredChildNodes = DOMUtils.filterElements(this.getTblCompDiv().getElementsByTagName("TR"),null,"details" + "_" + this.uniqueId,rowidx);
var removedNodes = new Array();
if(filteredChildNodes.length > 0)
{
var reqOptions = {ONCLOSE:"TableDOMModel.handleSwipeClose",TBLMODELINST:this, ROWIDX:rowidx};;
if (requestOptions != null)
{
reqOptions.pervOptions = requestOptions;
}
removedNodes[0] = filteredChildNodes[0].childNodes[0].childNodes[0];
if(swipe!="true")
{
removedNodes[0].style.display="none";
var obj = reqOptions.ONCLOSE;
if (obj != null)
{
executeFunctionAsString(obj,window,reqOptions);
}
}
else
{
MCEffect.SlideUp(removedNodes[0].id, reqOptions);
}
}
return removedNodes;
}
this.removeDetails = function(rowidx)
{
var filteredChildNodes = DOMUtils.filterElements(this.getTblCompDiv().getElementsByTagName("TR"),null,"details"+ "_" + this.uniqueId,rowidx);
var removedNodes = new Array();
if(filteredChildNodes.length > 0)
{
for(var i = 0; i < filteredChildNodes.length; i++)
{
filteredChildNodes[i].parentNode.removeChild(filteredChildNodes[i]);
var tr = filteredChildNodes[i].dataRow;
DOMUtils.removeCSSClass([tr],"detailsShown");
removedNodes[i] = filteredChildNodes[i].childNodes[0];
}
}
return removedNodes;
}
this.appendDetails = function(rowidx,details,requestOptions)
{
var detRow = document.createElement("TR");
var td = document.createElement("TD");
var dataRow = this.getTREl(rowidx);
td.colSpan = TableDOMModel.getColCount(dataRow);
if((typeof details ) == "string")
{
var tempDiv = document.createElement("div");
tempDiv.innerHTML = details;
details = tempDiv;
}
details.style.display = "none";
if (details.id == null || details.id.length == 0)
{
details.id = this.uniqueId + "_SHOWDETAILS_" + rowidx;
}
td.setAttribute("closefunc","TableDOMModel.closeDetailsEl");
if (requestOptions != null)
{
td.setAttribute("opener", requestOptions.SRCVIEW);
}
td.appendChild(details);
detRow.appendChild(td);
detRow.className="detailsRow";
detRow.setAttribute("details" + "_" + this.uniqueId,rowidx);
detRow.dataRow = dataRow;
DOMUtils.addCSSClass([dataRow],"detailsShown");
if(dataRow.nextSibling != null)
{
dataRow.parentNode.insertBefore(detRow,dataRow.nextSibling);
}
else
{
dataRow.parentNode.appendChild(detRow);
}
if(requestOptions.SWIPE!="true")
{
details.style.display="block"
} 
else
{
MCEffect.SlideDown(details.id);
}
}
this.getTblCompDiv = function()
{
return document.getElementById(this.uniqueId +"_CT");
}
this.getNamedEl = function(name)
{
if(this.namedEls == null)
{
this.namedEls = DOMUtils.getChildElsWithAttr(this.getTblCompDiv(),"table_el","*");
}
return DOMUtils.filterElements(this.namedEls,null,"table_el",name)[0];
}
this.getRowSelectionInputs = function()
{
var obj = DOMUtils.filterElements(this.getTBody().getElementsByTagName("input"),null,"name","rowSelection");
return this.filterDisabled(obj);
}
this.filterDisabled = function(elList)
{
var filteredList = new Array();
var j = 0;
for(var i =0;i < elList.length ; i++)
{
if(! elList[i].disabled)
{
filteredList[j++] = elList[i];
}
}
return filteredList;    	
}
this.isAllRowsSelected = function()
{
var nodes = this.getRowSelectionInputs();
for(var i = 0 ; i < nodes.length ; i++) {
if (!nodes[i].checked) {
return false;
}
}
return true;
}
this.updateHighLighting = function(rowSelEl)
{
var nodes = (rowSelEl != null)? [rowSelEl]:this.getRowSelectionInputs();
var selRows = new Array();
var unSelRows = new Array();
var bool=false;
if(nodes.length<200)
bool=true;
for(var i =0; i < nodes.length; i++)
{
if(nodes[i].getAttribute('pkcol') != null && bool)
{
updateStateString(this.uniqueId,"_RS",nodes[i].getAttribute('pkcol'), ((nodes[i].checked)?1:0));    		  
}      	
var rowEl = DOMUtils.getParentWithAttr(nodes[i],"rowidx");
if(nodes[i].checked)
{
selRows.push(rowEl);    
}
else
{
unSelRows.push(rowEl);
}
}
DOMUtils.addCSSClass(selRows,"selected");
DOMUtils.removeCSSClass(unSelRows,"selected");
}
this.clearAllRowSelection = function()
{
DOMUtils.setProperty(this.getRowSelectionInputs(),"checked",false);
}
this.selectAllRows = function()
{
if(_NO_ACTION)
{
return;
}
DOMUtils.setProperty(this.getRowSelectionInputs(),"checked",true);
}
this.isAtleastOneChecked = function(errorMsg)
{
if(this.rowSelection == "NONE"){
return true;
}
if(this.getRowCount() == 0){
alert(I18N.getMsg("No Rows present in the table"));
return false;
}
var atleastOneChecked = this.getSelectedRowIndices().length > 0;
if(errorMsg && !atleastOneChecked)
{           
alert(errorMsg);
}
return atleastOneChecked;
}
this.getSelectedRowIndices = function() {
var selectedIndices = new Array();
var tbl;
if (document.getElementById(this.uniqueId + "_ROWSTABLE") != null) {
tbl = document.getElementById(this.uniqueId + "_ROWSTABLE");
} else {
tbl = document.getElementById(this.uniqueId + "_TABLE");
}
var inputs = tbl.getElementsByTagName("input");
for (var i = 0; i < inputs.length; i++) {
var e = inputs[i];
if (e.name == "rowSelection") {
if (e.checked) {
selectedIndices.push(e.value);
}
}
}
return selectedIndices;
}
}
TableDOMModel.prototype = new TableModel;
TableDOMModel.getInstanceFor = function(sourceEl)
{
var uniqueId = DOMUtils.getParentWithAttr(sourceEl,"unique_id").getAttribute("unique_id");
return TableModel.getInstance(uniqueId);
}
TableDOMModel.rowHover = function(trEl,highLight)
{
if(highLight){DOMUtils.addCSSClass([trEl],"hilite")}else{DOMUtils.removeCSSClass([trEl],"hilite")};
}
TableDOMModel.toggle = function(rowSelEl)
{
if(rowSelEl.getAttribute("rowSel")!=null)
{
rowSelEl=DOMUtils.getChildElsWithAttr(rowSelEl,"name","rowSelection")[0];
if(rowSelEl.checked)rowSelEl.checked=false;
else rowSelEl.checked=true;
}		
var tblDomModel = TableDOMModel.getInstanceFor(rowSelEl);
if(rowSelEl.getAttribute('pkcol') != null)
{
updateStateString(tblDomModel.uniqueId,"_RS", rowSelEl.getAttribute('pkcol'), ((rowSelEl.checked)?1:0));    		  
}
if(rowSelEl.type && rowSelEl.type.toUpperCase() == "RADIO")
{
tblDomModel.updateHighLighting();
}
else
{
tblDomModel.updateHighLighting(rowSelEl);
}
var toggleAll = tblDomModel.getNamedEl("TOGGLEALL");
if(toggleAll != null)
{
toggleAll.checked = tblDomModel.isAllRowsSelected();
}  
}
TableDOMModel.toggleAll = function(rowSelEl)
{
var tblDomModel = TableDOMModel.getInstanceFor(rowSelEl);
if(rowSelEl.checked){tblDomModel.selectAllRows();} 
else {tblDomModel.clearAllRowSelection();}
tblDomModel.updateHighLighting();
}
TableDOMModel.getColCount = function(trEl)
{
return DOMUtils.filterElements(trEl.childNodes,"TD").length;
}
TableDOMModel.searchEnterKeyLis = function(sourceEl,ev, navigurl)
{
if(!ev){ev = window.event};
if(ev.keyCode == 13)
{
if(RESTFUL == true)
{
var uniqueId = DOMUtils.getParentWithAttr(sourceEl,"unique_id").getAttribute("unique_id");
fetchSpotSearchData(sourceEl, uniqueId, navigurl);  		
}
else
{
fetchSpotSearchData(sourceEl);  		
}
return false;
}
return true;
}
TableDOMModel.closeDetailsEl = function(srcEl,refreshTableView) 
{
var tempel = DOMUtils.getParentWithAttr(srcEl,"unique_id");
tempel = DOMUtils.getParentWithAttr(tempel,"unique_id");
var tempuid = tempel.getAttribute("unique_id");
var detailsEl = DOMUtils.getParentWithAttr(srcEl,"details"+ "_" + tempuid);
var tableView = DOMUtils.getParentWithAttr(detailsEl,"unique_id").getAttribute("unique_id");
var rowIdx = detailsEl.getAttribute("details"+ "_" + tempuid);
var tblDomModel = TableModel.getInstance(tableView);
var requestOptions = null;
if(refreshTableView)
{
requestOptions = {ONCLOSE:"AjaxAPI.refreshOpener", OPENER:tableView};
}
return tblDomModel.closeDetails(rowIdx, requestOptions);
}
TableDOMModel.showDetailsAction = function(menuItemId,srcViewRefId,additionalParams,index)
{  
if(index == null){index = -1;}
var menuItemObj = getMenuItemObj(menuItemId);
var tblDOMModel = TableModel.getInstance(srcViewRefId);
if(tblDOMModel.closeDetails(index,null,additionalParams,menuItemObj.SWIPE).length > 0)
{
return;
}
if(menuItemObj.CLOSE_PREVIOUS != "false")
{
tblDOMModel.removeDetails("*");
}
var url = menuItemObj.getActionURL(srcViewRefId,additionalParams,index);
var viewname=getViewName(url);
if(viewname!=null)
{
try{
resetNavigationState(viewname);
}
catch(e)
{
}
}
if(menuItemObj.SWIPE == "true")
{
AjaxAPI.sendRequest({URL:updateStateCookieAndAppendSid(url),ONSUCCESSFUNC:"TableDOMModel.appendDetailsAR",SRCVIEW:srcViewRefId,SELINDEX:index,SWIPE:"true"});
}
else
{
AjaxAPI.sendRequest({URL:updateStateCookieAndAppendSid(url),ONSUCCESSFUNC:"TableDOMModel.appendDetailsAR",SRCVIEW:srcViewRefId,SELINDEX:index,SWIPE:"false"});
}
}
function getViewName(url)
{
if(url.indexOf(".cc")!=-1)
{
url=url.substring(0,url.indexOf(".cc"));
if(url.substring(0,1)=="/")
{
url=url.substring(1,url.length);
}
}
return url;
}
TableDOMModel.showDetails = function(ajaxOptions)
{
var index = ajaxOptions.SELINDEX; 
if(index == null){index = -1;}
var tblDOMModel = TableModel.getInstance(ajaxOptions.SRCVIEW);
if(tblDOMModel.closeDetails(index).length > 0)
{
return;
}
if(ajaxOptions.CLOSE_PREVIOUS != "false")
{
tblDOMModel.removeDetails("*");
}
ajaxOptions.ONSUCCESSFUNC = "TableDOMModel.appendDetailsAR";
AjaxAPI.sendRequest(ajaxOptions);
}
TableDOMModel.appendDetailsAR = function(response,requestOptions)
{
var srcViewRefId = requestOptions.SRCVIEW;
var tblDomModel = TableModel.getInstance(srcViewRefId);
var selIndex = requestOptions.SELINDEX;
if(selIndex == null){selIndex = -1;}
tblDomModel.appendDetails(selIndex,response.getOnlyHtml(),requestOptions);
return StatusMsgAPI.OPSTATUS.FINISHED;
}
TableDOMModel.handleSwipeClose = function(reqOptions)
{
reqOptions.TBLMODELINST.removeDetails(reqOptions.ROWIDX);
var pervOptions = reqOptions.pervOptions;
if (pervOptions != null && pervOptions.ONCLOSE != null)
{
executeFunctionAsString(pervOptions.ONCLOSE,window,pervOptions);
}
}
TableDOMModel.handleSwipeOpen = function(reqOptions)
{
if(reqOptions.PS != null)
{
AjaxUtils.invokeScripts(reqOptions.PS);
}
}
TableDOMModel.closeDetailsDR = function(response,requestOptions)
{
var srcViewRefId = requestOptions.SRCVIEW; 
var sourceElemId = srcViewRefId + "_CT";
var sourceEl = document.getElementById(sourceElemId);
var tr = DOMUtils.getParentWithAttrValue(sourceEl,"class","detailsRow");
var td = DOMUtils.getChildElsWithAttr(tr, "opener", "*");
var tableView = td[0].getAttribute("opener");
requestOptions.update({NAVIGABLE_RN:false,VIEWTOREFRESH_RN:tableView});
requestOptions.ONCLOSE = "ViewAPI.refreshView";
MCEffect.SlideUp(sourceElemId, requestOptions);
return StatusMsgAPI.OPSTATUS.INPROGRESS;
}
TableDOMModel.closeDetailsAR = function(response,requestOptions)
{
var srcViewRefId = requestOptions.SRCVIEW; 
var uniqueId = getUniqueId(srcViewRefId);
var sourceEl = document.getElementById(srcViewRefId + "_TABLE");
var detailsEl = DOMUtils.getParentWithAttr(sourceEl,"details"+ "_" + this.uniqueId);
var tableView = DOMUtils.getParentWithAttr(detailsEl,"unique_id").getAttribute("unique_id");
var tblDomModel = TableModel.getInstance(tableView);
if(requestOptions.isTrue("REFRESHTABLE",false))
{ 
requestOptions.update({NAVIGABLE_RN:false,VIEWTOREFRESH_RN:tableView});
requestOptions.ONCLOSE = "ViewAPI.refreshView";
MCEffect.SlideUp(detailsEl.childNodes[0].childNodes[0].id, requestOptions);
return StatusMsgAPI.OPSTATUS.INPROGRESS;
}
else
{
tblDomModel.closeDetails(detailsEl.getAttribute("details"+ "_" + this.uniqueId));
return StatusMsgAPI.OPSTATUS.FINISHED;
}
}
TableDOMModel._TBL_TABLEDOMMODEL_MGR = new Object();
TableDOMModel.clientSortData = function(id,columnName)
{
var tblModel = TableModel.getInstance(id);
var tbody = tblModel.getTBody();
var colIdx = tblModel.getColumnIndex(columnName);
var tableRows = DOMUtils.filterElements(tbody.childNodes,"TR","rowidx","*");
var order = stateData[getUniqueId(id)]._SO;
order = (order == "D")? "A":"D";
updateState(getUniqueId(id),"_SO",order);
var clientSortFunc = function(trRow1,trRow2)
{
var val1 = tblModel.getValueAt(trRow1.getAttribute("rowidx"),colIdx);
var val2 = tblModel.getValueAt(trRow2.getAttribute("rowidx"),colIdx);
if (val1 == val2) {
return 0;
}
if (val1 > val2) {
return 1;
}
return -1;
};
tableRows.sort(clientSortFunc);
if(order == "D")
{
tableRows.reverse();
}
var childRows = LangUtils.cloneArray(tbody.childNodes);
for(var i =1; i < childRows.length; i++)
{
tbody.removeChild(childRows[i]);
}
for(var i =0; i < tableRows.length; i++)
{
tbody.appendChild(tableRows[i]);
}
}
function selectRow(event,el)
{
TableDOMModel.toggle(el);
event.cancelBubble = true;
if (event.stopPropagation) event.stopPropagation();
}
function invokeActionForACTable(uniqueId,str)
{
var strArray=str.split('::',2);
var columnName=strArray[0];
var columnValue=strArray[1];
var model=TableDOMModel.getInstanceFor(document.getElementById(uniqueId+"_TABLE"));
var columnIndex=model.getViewIndexForCol(columnName);
var i=0;
var el;
while(document.getElementById(uniqueId+"_r_"+i+"_"+columnIndex)!=null)
{
var tdel=document.getElementById(uniqueId+"_r_"+i+"_"+columnIndex);
var innerel=tdel.getElementsByTagName('a')[0];
var innertext=innerel.innerHTML.trim();
if(innertext==columnValue)
{
el=innerel;
break;
}
i++;
}
if(el==null || el=="undefined")
{
return;
}
var javascript=el.getAttribute("href");
executeFunctionAsString(javascript,window);
}
