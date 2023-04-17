var _NO_ACTION=false;
String.prototype.trim = function() {
var x=this;
x=x.replace(/^\s*(.*)/, "$1");
x=x.replace(/(.*?)\s*$/, "$1");
return x;
}
function resetNavigationState(id)
{
var uniqueId = getUniqueId(id);
if(RESTFUL != true)
{
updateState(uniqueId, "_FI", "1");      
updateState(uniqueId, "_TI", null);
updateState(uniqueId, "_PN", "1");
}
else
{
updateURLState(uniqueId, "_FI", "1");      
updateURLState(uniqueId, "_TI", null);
updateURLState(uniqueId, "_PN", "1");  	
}
stateData[uniqueId]["_VMD"]= '1';
}
function sortData(id, columnName){
var uniqueId = getUniqueId(id);
if(TableModel.getInstance(uniqueId).ISCLIENTSORT)
{
TableDOMModel.clientSortData(uniqueId,columnName);
return;
}
if(RESTFUL == true)    
{
updateURLState(uniqueId, "_SB", columnName);
}
else
{
updateState(uniqueId, "_SB", columnName);
}
resetNavigationState(uniqueId);
var order = stateData[uniqueId]["_SO"];
if(RESTFUL == true)
{
order = urlstateData[uniqueId]["_SO"];
}
if(order == "D"){
if(RESTFUL == true)
{
updateURLState(uniqueId, "_SO","A");
}
else
{
updateState(uniqueId, "_SO","A");
}
order = "ASC";
}
else{
if(RESTFUL == true)
{
updateURLState(uniqueId, "_SO","D");
}
else
{
updateState(uniqueId, "_SO","D");
}
order = "DESC";
}
stateData[uniqueId]["_MP"] = "_SB";
if(RESTFUL)
{
updateURLState(uniqueId, "_FI", 0);
}
else
{
updateState(uniqueId, "_FI", 0);
}
refreshSubView(uniqueId);
}
function sortData_template(id){
var uniqueId;
var columnName;
var parent=DOMUtils.getParentWithAttr(id,"mc:id");
uniqueId=parent.getAttribute("mc:id");
parent=DOMUtils.getParentWithAttr(id,"mc:columnName");
columnName=parent.getAttribute("mc:columnName");
sortData(uniqueId, columnName);
}
function resetSearchParams(uniqueId)
{
if(RESTFUL != true)
{
updateState(uniqueId, "SEARCH_COLUMN", "");
updateState(uniqueId, "SEARCH_VALUE", "");
updateState(uniqueId, "SEARCHCOMBO_VALUE", "");
updateState(uniqueId, "SEARCHVAL_COMB", "");
}
else
{
updateURLState(uniqueId, "SEARCH_COLUMN", "");
updateURLState(uniqueId, "SEARCH_VALUE", "");
updateURLState(uniqueId, "SEARCHCOMBO_VALUE", "");
updateURLState(uniqueId, "SEARCHVAL_COMB", "");			
}
}
function showRange(id, fromIndex){
var uniqueId = getUniqueId(id);
var _pl = stateData[uniqueId]["_PL"];
if(RESTFUL == true && _pl == null)
{
_pl = urlstateData[uniqueId]["_PL"];
}
_pl = parseInt(_pl,10);
var _pn = 1;
_pn = parseInt(fromIndex / _pl, 10);
if(parseInt(fromIndex % _pl) > 0)
{
_pn = _pn + 1;	
}
if(RESTFUL != true)
{
updateState(uniqueId, "_FI", fromIndex); 
updateState(uniqueId, "_PN", _pn + "");
}
else
{
updateURLState(uniqueId, "_FI", fromIndex);
updateURLState(uniqueId, "_PN", _pn + "");		
}
stateData[uniqueId]["_VMD"]= '1';
refreshSubView(uniqueId);
}
function showRangewithStateURL(id, url)
{
AjaxAPI.sendNavigableRequest({URL:url,METHOD:"GET",TARGET:"_view_"+id});
}
function showRangeForLength(id, pageLength){
var uniqueId = getUniqueId(id);
if(RESTFUL != true)
{	
updateState(uniqueId, "_PL", pageLength);
}
else
{
updateURLState(uniqueId, "_PL", pageLength);
}
resetNavigationState(uniqueId);
if(RESTFUL != true)
{
stateData[uniqueId]["_MP"] = "_PL";
}
else
{
urlstateData[uniqueId]["_MP"] = "_PL";
}
refreshSubView(uniqueId);
}
function replaceScriptTags(value){
var match    = new RegExp("<script>", 'img');
value = value.replace(match,"&lt;SCRIPT&gt;");
match    = new RegExp("<\/script>", 'img');
value  = value.replace(match,"&lt;/SCRIPT&gt;");
return value;
}
function fetchSpotSearchData(el,id, url){
var uniqueId = DOMUtils.getParentWithAttr(el,"unique_id").getAttribute("unique_id");
var searchRow =DOMUtils.getChildElsWithAttr(DOMUtils.getParentWithAttr(el,"unique_id"),"table_el","SEARCHROW")[0];
var searchRowCombo = TableModel.getInstance(uniqueId).getNamedEl("SEARCHROWCOMBO");
var searchInputs = searchRow.getElementsByTagName("input");
var isAdvancedSearch = false;
if(searchRowCombo != undefined)
{
var searchInputsCombo = searchRowCombo.getElementsByTagName("select");
isAdvancedSearch = true;
}
if(!validateFormElements(searchInputs,searchRow)){
return false;
}
var searchColumns = "";
var searchValues = "";
var initial = true;
var searchValuesCombo = "";
var searchValComb = "";
var initialCombo = true;
for(var i = 0; i < searchInputs.length; i++)
{
var valueCombo;
var valComb;
if(isAdvancedSearch && i <= searchInputsCombo.length-1)
{			
valueCombo = searchInputsCombo[i].value;
var opt = searchInputsCombo[i].getElementsByTagName("option");
for(var k = 0; k < opt.length; k++)
{
var isComboSelected = opt[k].selected;
if(isComboSelected)
{
valComb = opt[k].text;
}
}
}
var name = searchInputs[i].name;
var value = searchInputs[i].value;
value = value.trim();
if(value.search(',')!=-1) value = value.replace(/,/g,"&#44;");
if(value) searchRow.getElementsByTagName("span")[i].style.visibility='hidden';
if(searchInputs[i].disabled || value != null && value.trim() != "")
{
if(!initial)
{
searchColumns = searchColumns + ",";
searchValues = searchValues + ",";
if(isAdvancedSearch)
{
searchValuesCombo = searchValuesCombo + ",";
searchValComb = searchValComb + ",";
}
}
if(isAdvancedSearch)
{
searchValuesCombo = searchValuesCombo + valueCombo;
searchValComb = searchValComb + valComb;
}
searchColumns = searchColumns + name;
searchValues = searchValues + value;
initial = false;
}
}
if(RESTFUL == true && (1 == 0))
{
url = getURLSuffixed(url);
url = url + "s:SEARCH_COLUMN=" + searchColumns + "&s:SEARCH_VALUE=" + searchValues;
AjaxAPI.sendNavigableRequest({URL:url,METHOD:"GET",TARGET:"_view_"+id});		
}
else
{
if(RESTFUL != true)
{
updateState(uniqueId, "SEARCH_COLUMN", searchColumns);
updateState(uniqueId, "SEARCH_VALUE", searchValues);
updateState(uniqueId, "SEARCHCOMBO_VALUE", searchValuesCombo);
updateState(uniqueId, "SEARCHVAL_COMB", searchValComb);
}
else
{
updateURLState(uniqueId, "SEARCH_COLUMN", searchColumns);
updateURLState(uniqueId, "SEARCH_VALUE", searchValues);
updateURLState(uniqueId, "SEARCHCOMBO_VALUE", searchValuesCombo);
updateURLState(uniqueId, "SEARCHVAL_COMB", searchValComb);			
}
resetNavigationState(uniqueId);
refreshSubView(uniqueId);
}
return false;
}
function alternateRows(id) {
var even = false;
var evenClass = arguments[1] ? arguments[1] : "#fff";
var oddClass = arguments[2] ? arguments[2] : "#eee";
var table = document.getElementById(id);
if (! table) { return; }
var tbodies = table.getElementsByTagName("tbody");
for (var h = 0; h < tbodies.length; h++) {
var trs = tbodies[h].getElementsByTagName("tr");
for (var i = 0; i < trs.length; i++) {
var tds = trs[i].getElementsByTagName("td");
for (var j = 0; j < tds.length; j++) {
var mytd = tds[j];
mytd.setAttribute("class",even ? evenClass : oddClass);
}
even =  ! even;
}
}
}
function closeSearch(sourceEl, id, url)
{
var uniqueId = DOMUtils.getParentWithAttr(sourceEl,"unique_id").getAttribute("unique_id");
var tblDOMModel = TableModel.getInstance(uniqueId);  
var searchRow =DOMUtils.getChildElsWithAttr(DOMUtils.getParentWithAttr(sourceEl,"unique_id"),"table_el","SEARCHROW")[0];
var searchRowCombo = tblDOMModel.getNamedEl("SEARCHROWCOMBO");
tblDOMModel.getNamedEl("OSBTN").className = "tableSearchButton";
tblDOMModel.getNamedEl("CSBTN").className = "hide";
var isValPresent = false;
var inputs = searchRow.getElementsByTagName("input");
var inputsCombo;
var valueCombo;
if(searchRowCombo != undefined)
{
inputsCombo = searchRowCombo.getElementsByTagName("select");	
}
var size = inputs.length;
for(var count = 0; count < size; count++)
{
var element = inputs[count];
if(inputsCombo != undefined && !(count >= inputsCombo.length))
{
valueCombo = inputsCombo[count].value;
}
if(element.disabled || ((element.value != "")&& (element.value != null)))
{
element.value = "";
isValPresent = true;
}
}
if(isValPresent)
{
if(searchRowCombo == undefined)
{
if(RESTFUL == true)
{
fetchSpotSearchData(sourceEl, id, url);	
}
else
{
fetchSpotSearchData(sourceEl);
}
}
else
{
updateStateAndUrlState(uniqueId, "SEARCH_COLUMN", "");
updateStateAndUrlState(uniqueId, "SEARCH_VALUE","");
updateStateAndUrlState(uniqueId, "SEARCHCOMBO_VALUE", "");
updateStateAndUrlState(uniqueId, "SEARCHVAL_COMB", "");
refreshSubView(uniqueId);
}
}
else
{
searchRow.className = "hide";
if(searchRowCombo != undefined)
{
searchRowCombo.className = "hide";
}
}
}
function closeSearch_template(sourceEl)
{
var uniqueId = DOMUtils.getParentWithAttr(sourceEl,"mc:id").getAttribute("mc:id");
var tblDOMModel = TableModel.getInstance(uniqueId);  
var searchRow = tblDOMModel.getNamedEl("SEARCHROW");
if(tblDOMModel.getNamedEl("OSBTN").getAttribute("mc:tempClass")==null)
{
tblDOMModel.getNamedEl("OSBTN").className = "tableSearchButton";
}
else
{
tblDOMModel.getNamedEl("OSBTN").className = tblDOMModel.getNamedEl("OSBTN").getAttribute("mc:tempClass");
}
if(tblDOMModel.getNamedEl("CSBTN").getAttribute("mc:tempClass")==null)
{
tblDOMModel.getNamedEl("CSBTN").className = "hide";
}
else
{
tblDOMModel.getNamedEl("CSBTN").className = tblDOMModel.getNamedEl("CSBTN").getAttribute("mc:tempClass");
}
var isValPresent = false;
var inputs = searchRow.getElementsByTagName("input");
var size = inputs.length;
for(var count = 0; count < size; count++){
var element = inputs[count];
if((element.value != "")
&& (element.value != null)){
element.value = "";
isValPresent = true;
}
}
if(isValPresent){
fetchSpotSearchData(sourceEl);
}
else
{
if(searchRow.getAttribute("mc:tempClass")==null)
{
searchRow.className = "hide";
}
else
{
searchRow.className = searchRow.getAttribute("mc:tempClass");
}
}
}
function openSearch(sourceEl)
{
var uniqueId = DOMUtils.getParentWithAttr(sourceEl,"unique_id").getAttribute("unique_id");
var tblDOMModel = TableModel.getInstance(uniqueId);  
var searchRow =DOMUtils.getChildElsWithAttr(DOMUtils.getParentWithAttr(sourceEl,"unique_id"),"table_el","SEARCHROW")[0];
var searchRowCombo = tblDOMModel.getNamedEl("SEARCHROWCOMBO");
searchRow.className = "searchRow";  
if(searchRowCombo != undefined)
{
searchRowCombo.className = "searchRow";
}
tblDOMModel.getNamedEl("OSBTN").className = "hide";
tblDOMModel.getNamedEl("CSBTN").className = "tableSearchCloseButton";
var inputs = searchRow.getElementsByTagName("input");
var formatSpan = searchRow.getElementsByTagName("span");
if(searchRowCombo!=undefined)
{
if(searchRowCombo.getElementsByTagName("select")!=null)
{
var searchInputsCombo = searchRowCombo.getElementsByTagName("select");
for(var i = 0; i < inputs.length; i++)
{
if(searchInputsCombo[i]){
var opt = searchInputsCombo[i].getElementsByTagName("option");
var valComb;
for(var k = 0; k < opt.length; k++)
{
var isComboSelected = opt[k].selected;
if(isComboSelected)
{
valComb = opt[k].text;
if(valComb=="--------------"){
inputs[i].disabled=true;
formatSpan[i].style.visibility='hidden';
}
}
}
}
}
}
}
inputs[0].focus();
}
function openSearch_template(sourceEl)
{
var uniqueId = DOMUtils.getParentWithAttr(sourceEl,"unique_id").getAttribute("unique_id");
var tblDOMModel = TableModel.getInstance(uniqueId);  
var searchRow = tblDOMModel.getNamedEl("SEARCHROW");
var searchRowCombo = tblDOMModel.getNamedEl("SEARCHROWCOMBO");
if(searchRow.getAttribute("mc:onSearchClass")==null)
{
searchRow.className = "searchRow";  
}
else
{
searchRow.setAttribute("mc:tempClass",searchRow.getAttribute("class"))
searchRow.className = searchRow.getAttribute("mc:onSearchClass");  
}
if(searchRowCombo != undefined && searchRowCombo.getAttribute("mc:onSearchClass")==null)
{
searchRowCombo.className = "searchRow";  
}
else if(searchRowCombo != undefined )
{
searchRowCombo.setAttribute("mc:tempClass",searchRowCombo.getAttribute("class"))
searchRowCombo.className = searchRowCombo.getAttribute("mc:onSearchClass");  
}
if( tblDOMModel.getNamedEl("OSBTN").getAttribute("mc:onSearchClass")==null)
{
tblDOMModel.getNamedEl("OSBTN").className = "hide";
}
else
{
tblDOMModel.getNamedEl("OSBTN").setAttribute("mc:tempClass",tblDOMModel.getNamedEl("OSBTN").getAttribute("class"));
tblDOMModel.getNamedEl("OSBTN").className = tblDOMModel.getNamedEl("OSBTN").getAttribute("mc:onSearchClass");
}
if(tblDOMModel.getNamedEl("CSBTN").getAttribute("mc:onSearchClass")==null)
{
tblDOMModel.getNamedEl("CSBTN").className = "tableSearchCloseButton";
}
else
{
tblDOMModel.getNamedEl("CSBTN").setAttribute("mc:tempClass",tblDOMModel.getNamedEl("CSBTN").getAttribute("class"));
tblDOMModel.getNamedEl("CSBTN").className = tblDOMModel.getNamedEl("CSBTN").getAttribute("mc:onSearchClass");
}
var inputs = searchRow.getElementsByTagName("input");
inputs[0].focus();
}
function updateSearchData(id, select){
var uniqueId = getUniqueId(id);
searchColumn = select.name;
searchValue = select.value;
updateState(uniqueId, "SEARCH_COLUMN", searchColumn);
updateState(uniqueId, "SEARCH_VALUE", searchValue);
updateState(uniqueId, "_SB", null);
stateData[uniqueId]["_VMD"]= '1';
resetNavigationState(uniqueId);
refreshSubView(uniqueId);
return false;
}
function showCompleteMessage(curId){
var message = window[curId]["MSG"];
message = message.replace(/\n\n/gi,"<br>");
message = message.replace(/\n/gi,"<br>");
showCustomMessage(message, document.getElementById(curId), 'completeMessage');
}
function hideCompleteMessage(){
document.getElementById("completeMsgDiv").className = "hide";
}
function defaultTrimmedMessageDisplayer(trimmedMsg, completeMsg, insertionId, action, destDoc){
window[insertionId] = new Object();
window[insertionId]["MSG"] = completeMsg;
var data = "<a  href=\"javascript:showCompleteMessage('" + insertionId + "')\">" + trimmedMsg + "</a>";
destDoc.getElementById(insertionId).innerHTML = data;
}
function showTrimmedMessage(trimmedMsg, completeMsg, insertionId, action, destDoc){
var data = "";
if(action != null && action != "" && action != "null"){
data = data.concat("<a href=\"" + action + "\">");
}
data = data.concat(trimmedMsg);
if(action != null && action != "" && action != "null"){
data = data.concat("</a>");
}	
destDoc.getElementById(insertionId).innerHTML = data;
}
function showTrimmedMessageOnImageClick(trimmedMsg, completeMsg, insertionId, action, destDoc){
var data = "";
if(action != null && action != "" && action != "null"){
data = data.concat("<a href=\"" + action + "\">");
}
data = data.concat(trimmedMsg);
if(action != null && action != "" && action != "null"){
data = data.concat("</a>");
}	
window[insertionId] = new Object();
window[insertionId]["MSG"] = completeMsg;
data = data.concat("<button class='messageInvoker' onClick=\"javascript:showCompleteMessage('" + insertionId + "');return false\"></button>");
destDoc.getElementById(insertionId).innerHTML = data;
}
function showTrimmedMessageOnMouseOver(trimmedMsg, completeMsg, insertionId, action, destDoc){
var data = "";
if(action != null && action != "" && action != "null"){
data = data.concat("<a href=\"" + action + "\">");
}
data = data.concat(trimmedMsg);
if(action != null && action != "" && action != "null"){
data = data.concat("</a>");
}	
window[insertionId] = new Object();
window[insertionId]["MSG"] = completeMsg;
data = data.concat("<button class='messageInvoker' onMouseOver=\"javascript:showCompleteMessage('" + insertionId + "');return false\" onMouseOut=\"hideCustomMessage();return false;\"></button>");
destDoc.getElementById(insertionId).innerHTML = data;
}
function showMessageOnTextMouseOver(trimmedMsg, completeMsg, insertionId, action, destDoc){
var data = "";
if(action != null && action != "" && action != "null"){
data = data.concat("<a href=\"" + action + "\">");
}
window[insertionId] = new Object();
window[insertionId]["MSG"] = completeMsg;
data = data.concat("<span onMouseOver=\"javascript:showCompleteMessage('" + insertionId + "');return false\" onMouseOut=\"hideCustomMessage();return false;\">");
data = data.concat(trimmedMsg);
data = data.concat("</span>");
if(action != null && action != "" && action != "null"){
data = data.concat("</a>");
}	
destDoc.getElementById(insertionId).innerHTML = data;
}
function displayColumnChooser(menuItemId, srcViewRefId, additionalParams,index) {
var menuItemObj = getMenuItemObj(menuItemId);
var url = CONTEXT_PATH + "/" + getURLSuffixed(menuItemObj.ACTIONLINK) + additionalParams;
var div=document.getElementById("ChooserListTypeInline_CT");
if(div!="undefined" && div!=null)
{
closeDialog(null,div);
}
var reqParams = null;
if(srcViewRefId != null)
{
reqParams = stateData[srcViewRefId]["_D_RP"];      
}
if(reqParams != null)
{
url = url + "&" + reqParams;
}        
showURLInDialog(url, menuItemObj.WINPARAMS);
}
function selectFilter(id,filterName,viewname,contentAreaName)
{
var uniqueId = getUniqueId(id);
if(RESTFUL == true)
{
updateURLState(uniqueId,'SELFILTER',filterName);
}
else
{
updateState(uniqueId,'SELFILTER',filterName);
}
if(viewname != undefined && contentAreaName != undefined)
{
updateViewInCA(uniqueId,viewname,null,contentAreaName,null,false,null,"FILTERCHECK=true&SELFILTER="+filterName,true);
}
else
{
resetNavigationState(id);
var linkedViewName = getState(id,"linkedView");
refreshSubView(uniqueId,null,"SELFILTER="+filterName);
if(linkedViewName != undefined)
{
refreshSubView(linkedViewName);
}
}
}
function showWrappedMessageOnImageClick(trimmedMsg, completeMsg, insertionId, action, destDoc)
{
var data = "";
var len = trimmedMsg.length-4;
if(action != null && action != "" && action != "null"){
if(autolink=="true")
{
data = data.concat("<a href='" + action+"'"+"target=_blank" +">");	
}
else
{
data = data.concat("<a href='" + action+"'>");
}
}
data = data.concat(trimmedMsg);
if(action != null && action != "" && action != "null"){
data = data.concat("</a>");
}	
window[insertionId] = new Object();
window[insertionId]["MSG"] = completeMsg;
data = data.concat("<button class='messageInvoker' onClick=\"javascript:showWrappedMessage('" + insertionId + "', '" + completeMsg + "',"+ len+");return false\"></button>");
destDoc.getElementById(insertionId).innerHTML = data;
}
function showWrappedMessageOnTextMouseOver(trimmedMsg, completeMsg, insertionId, action, destDoc)
{
var data = "";
var len = trimmedMsg.length-16;
if(action != null && action != "" && action != "null"  )
{
if(autolink=="true")
{
data = data.concat("<a href='" + action+"'"+"target=_blank" +">");
}
else
{
data = data.concat("<a href='" + action+"'>");
}
}
parent[insertionId] = new Object();
data = data.concat("<span  onMouseOver=\"javascript:showWrappedMessage('" + insertionId + "', '" + completeMsg + "',"+ len+");return false\" onMouseOut=\"hideCustomMessage();return false;\">");
data = data.concat(trimmedMsg);
data = data.concat("</span>");
if(action != null && action != "" && action != "null"){
data = data.concat("</a>");
}   
destDoc.getElementById(insertionId).innerHTML = data;
}
function showWrappedMessage(insertionId, completeMsg,length)
{
var newmsg = "";
var len = completeMsg.length;
var brstr = "<br>";
while(len > length)
{
newmsg =  newmsg + completeMsg.substring(0, length) + brstr;
completeMsg = completeMsg.substring(length , len);
len = completeMsg.length;
}
newmsg = newmsg + completeMsg;
parent[insertionId]["MSG"] = newmsg;
showCompleteMessage(insertionId);
}
function navigationSliderOnChange(value,uniqueId,pages)
{
var index=Math.round(value*pages);
if(index+1<pages){
showRange(uniqueId,index*10,index+1);
}
else{
index=index-1;
showRange(uniqueId,index*10,index+1);
}
navigationSliderOnSlide(value,uniqueId,pages);
}
function navigationSliderOnSlide(value,uniqueId,pages)
{
var index=Math.round(value*pages);
var el=document.getElementById(uniqueId+"_page_div");
if(index+1<pages){
el.innerHTML="page: "+(index+1)+"";
}
else{
el.innerHTML="page: "+(index)+"";
}
}
function openExport(url,exportwithstate)
{
if(exportwithstate != null && exportwithstate == true)
{
openURL(url);
}
else
{
location.href = getCurProtoAndHostPrefix() + CONTEXT_PATH + "/" + url;
}
}
function exportTablePDF(viewname, url)
{
if(typeof url == 'undefined')
{
url = getViewURL(viewname, 'pdf');	
}
var temptm = getTableModel(viewname);
var tbl = document.getElementById(viewname + "_TABLE");
var width = tbl.offsetWidth;
if(width > 800)
{
url = getURLSuffixed(url);
url = url + "landscape=true";
}
openExport(url,true);
}
function handleWidthOfScrollTable(viewname,noOfCols)
{
var totalWidthRow=(document.getElementById(viewname+"_ROWSTABLE")).offsetWidth;
var totalWidthHeader=(document.getElementById(viewname+"_TABLE")).offsetWidth;
var avgWidthRow=(totalWidthRow*.98)/(parseInt(noOfCols));
var avgWidthHeader=(totalWidthHeader*.98)/(parseInt(noOfCols));
for(var i=0; i<noOfCols-1; i++)
{
document.getElementById(viewname+"_h_"+i).style.width=avgWidthHeader+"px";
if(document.getElementById(viewname+"_r_0_"+i))
document.getElementById(viewname+"_r_0_"+i).style.width=(avgWidthHeader)+"px";
}
}
function handleDynamicTable(viewname,totCols,preFetched)
{
var tblBody =document.getElementById(viewname+"_ROWSTABLE").tBodies[0];
if(tblBody){
window[viewname+"_0"]=tblBody.rows[0];
window[viewname+"_1"]=tblBody.rows[1];
}
}
function handleScrollTable(viewName,preFetched,stopFetching)
{
var reloadPercent=95;
var scrollDiv=document.getElementById(viewName+"_scrolldiv");
var totalHeight=scrollDiv.scrollHeight;
var topPortionHeight=scrollDiv.scrollTop;
var shownHeight=scrollDiv.clientHeight;
var scrollPercent=((shownHeight+topPortionHeight)/(totalHeight))*100;
if(window[viewName+"_TL"]==null || window[viewName+"_TL"]=="undefined")
window[viewName+"_TL"]=getStateOrUrlState(viewName,"_TL");
if((scrollPercent>reloadPercent))
{
var tempflag=window[viewName+"_stopajax"]+"";
if(tempflag=="true")
{
return;
}
var fetched=window[viewName+"_fetched"];
if(fetched==null||fetched=="undefined" ||fetched=="")
{
fetched=preFetched;
}
if(window[viewName+"_TL"]) 
{
if(parseInt(fetched) >parseInt(getStateOrUrlState(viewName,"_TL")))
return;
}
else
{
window[viewName+"_TL"]=getStateOrUrlState(viewName,"_TL");
if(parseInt(fetched) > parseInt(getStateOrUrlState(viewName,"_TL")))
return; 
}
var fromIndex;
var toIndex;
if(!window[viewName+"_flag"]){
fromIndex=parseInt(getStateOrUrlState(viewName,"_TI"))+1;
updateStateAndUrlState(viewName,"_FI",fromIndex);
window[viewName+"_FI"]=fromIndex;
toIndex=parseInt(getStateOrUrlState(viewName,"_TI"))+ Math.round(0.3*preFetched);
updateStateAndUrlState(viewName,"_TI",toIndex);
window[viewName+"_TI"]=toIndex;
window[viewName+"_flag"]=true;
}
else
{
fromIndex=parseInt(window[viewName+"_TI"])+1;
updateStateAndUrlState(viewName,"_FI",fromIndex);
window[viewName+"_FI"]=fromIndex;
toIndex=parseInt(window[viewName+"_TI"])+Math.round(0.3*preFetched);
updateStateAndUrlState(viewName,"_TI",toIndex);
window[viewName+"_TI"]=toIndex;
}
var url=updateStateCookieAndAppendSid(viewName+".cc");
url=url+"?ajaxTableUpdate=true";
window[viewName+"_stopajax"]="true";
var statDiv=document.getElementById(viewName+"_statusbar");
if(statDiv!=null && statDiv!="undefined")
{
var ajaxUpdateStat=DOMUtils.getChildElsWithAttr(statDiv,"id","ajaxUpdateStatus")[0];
var tableStat=DOMUtils.getChildElsWithAttr(statDiv,"id","tableStatus")[0];
ajaxUpdateStat.style.display="block";
tableStat.style.display="none";
window[viewName+"_statusDiv"]=statDiv;
window[viewName+"_statusAjaxUpdateDiv"]=ajaxUpdateStat;
window[viewName+"_statusTableStat"]=tableStat;
}
AjaxAPI.sendRequest({METHOD:"GET",URL:url,ONSUCCESSFUNC:"AjaxTableUpdate",VIEWNAME:viewName,FETCHED:fetched,PREFETCHED:preFetched,RELOADPERCENT:reloadPercent,TOBEFETCHED:(toIndex-fromIndex+1)});
}
else
{
setTimeout("handleScrollTable('"+viewName+"','"+preFetched+"')",500);
}
}
function AjaxTableUpdate(response,reqOptions)
{
var viewName=reqOptions["VIEWNAME"];
var reloadPercent=reqOptions["RELOADPERCENT"];
var scrollDiv=document.getElementById(viewName+"_scrolldiv");
var tblBody =document.getElementById(viewName+"_ROWSTABLE").tBodies[0];
var swapRow;
var fetched=parseInt(reqOptions["FETCHED"]);
var preFetched=parseInt(reqOptions["PREFETCHED"]);
var toBeFetched=parseInt(reqOptions["TOBEFETCHED"]);
if(window[viewName+"_SwapRow"] && window[viewName+"_SwapRow"]!=null)
{
swapRow=window[viewName+"_SwapRow"];
}
else
{
swapRow=preFetched%2;
}
var iter=toBeFetched;
var stopFlag=false
var totLen=parseInt(getStateOrUrlState(viewName,"_TL"));
if(totLen <=(toBeFetched+fetched))
{
iter=totLen-fetched;
stopFlag=true;
}
window["response_parent_"+viewName]=document.createElement("div");
window["response_"+viewName]=document.createElement("div");
window["response_"+viewName].innerHTML = response.responseText;
window["response_parent_"+viewName].appendChild(window["response"+"_"+viewName]);
window[viewName+"_ELS"]=window["response"+"_"+viewName].getElementsByTagName("span");
for(var i=0 ;i<iter; i++)
{
var newNode=window[viewName+"_"+swapRow].cloneNode(true);
var colcount=updateID(newNode,fetched+i,viewName,swapRow);
fillValue(newNode,i,response,colcount,fetched+i,viewName);
tblBody.appendChild(newNode);
delete newNode;
if(swapRow==0)swapRow=1;
else swapRow=0;
}
window["response_parent_"+viewName].removeChild(window["response"+"_"+viewName]);
if(stopFlag)
{
window[viewName+"_fetched"]=fetched+iter;
if(window[viewName+"_statusDiv"])
{
window[viewName+"_statusAjaxUpdateDiv"].style.display="none";
window[viewName+"_statusTableStat"].style.display="block";
}
updateStatus(viewName);
return;
}
else
{
window[viewName+"_SwapRow"]=swapRow;
window[viewName+"_fetched"]=fetched+toBeFetched;
window[viewName+"_stopajax"]="false";
window["response"+"_"+viewName].innerHTML="";
}
if(window[viewName+"_statusDiv"])
{
window[viewName+"_statusAjaxUpdateDiv"].style.display="none";
window[viewName+"_statusTableStat"].style.display="block";
}
updateStatus(viewName);
}
function startFetching(time,viewName,preFetched)
{
setTimeout("handleScrollTable('"+viewName+"','"+preFetched+"')",time);
}
function updateID(node,rowno,viewName,no)
{
var i=0;
node.setAttribute("rowidx",rowno);
while(1)
{
var el=DOMUtils.getChildElsWithAttr(node,"id",viewName+"_r_"+no+"_"+i)[0];
if(el=="undefined"||el==null)
{
break;
}
el.id=viewName+"_r_"+rowno+"_"+i;
i++;
}
return i;
}
function fillValue(node,id,response,colCount,rowCount,viewName)
{
var sel=DOMUtils.getChildElsWithAttr(node,'name','rowSelection')[0];
sel.value=rowCount;
for(var i=0;i<colCount;i++)
{
var el=DOMUtils.getChildElsWithAttr(node,"id",viewName+"_r_"+rowCount+"_"+i)[0];
el.innerHTML=getContentFromResponseOfDynamicTable(response.responseText,"span","id",viewName+"_"+id+"_"+i+"_content",viewName);
}	
}
function getContentFromResponseOfDynamicTable(responseText,tag,attr,attrValue,viewName)
{
var respPart = DOMUtils.getFirstMatchingElement(window[viewName+"_ELS"],null,attr,attrValue);
return (respPart != null)? respPart.innerHTML: null;
}
function clearWindowObjects(viewName)
{
window[viewName+"_SwapRow"]="";
window[viewName+"_fetched"]="";
window[viewName+"_stopajax"]="";
window["response"+"_"+viewName]="";
window[viewName+"_TI"]="";
window[viewName+"_FI"]="";
window[viewName+"_flag"]="";
window[viewName+"_fetched"]="";
}
function updateStatus(viewName,prefetched)
{
var statDiv=document.getElementById(viewName+"_statusbar");
if(statDiv!=null && statDiv!="undefined")
{
var fetched=DOMUtils.getChildElsWithAttr(statDiv,"id","fetchedRows")[0];
var total=DOMUtils.getChildElsWithAttr(statDiv,"id","totalRows")[0];
if(window[viewName+"_fetched"]!=null && window[viewName+"_fetched"]!="undefined" && window[viewName+"_fetched"]!="" && window[viewName+"lessrows"]==null)
{
fetched.innerHTML=window[viewName+"_fetched"];
}
else
{
if(prefetched>getStateOrUrlState(viewName,"_TL"))
{
fetched.innerHTML=getStateOrUrlState(viewName,"_TL")+"";
}
else if(prefetched==-1)
{
fetched.innerHTML=getStateOrUrlState(viewName,"_TL")+"";
}
else
{
fetched.innerHTML=prefetched;
}
}
total.innerHTML=getStateOrUrlState(viewName,"_TL");
}
}
function hideSearchBox(searchBox,arg)
{
var nodeList = document.getElementsByTagName("input");
for(var i = 0; i < nodeList.length; i++)
{	
var node = nodeList.item(i);
if(searchBox+'txt' == node.id)
{
if(arg==0)
{
node.value = "";
document.getElementById(searchBox+'sp').style.visibility='hidden';
node.disabled = true;
}
else
{
node.disabled = false;
}
}
}
}
function asynchUpdateTableView(tablename,columnname,params)
{
if(document.getElementById(tablename+"_CT")==null)
{
return;
}
var model=TableModel.getInstance(tablename);
model.tableRows=new Array();
var url=updateStateCookieAndAppendSid(tablename+".cc?ajaxReplace=true");
url=handleTemplateViewParams(tablename,url);
if(params!=null && params!="undefined")
{
url+=params;
}
AjaxAPI.sendRequest({METHOD:"GET",URL:url,TARGET:("_div_"+tablename+"_hidden"),COLUMNNAME:columnname,ONSUCCESSFUNC:addScriptToUpdate,TABLENAME:tablename});	
}
function handleTemplateViewParams(tablename,url)
{
var statedata=stateData[tablename]["_D_RP"];
if(statedata!=null && statedata!="undefined" && statedata!="")
{
return (url+"&"+statedata);
}
else
{
return url;
}
}
function addScriptToUpdate(response,reqOptions)
{
var tablename=reqOptions["TABLENAME"];
var columnname=reqOptions["COLUMNNAME"];
var resp=response.responseText;
response.responseText=resp+"<script>updateClientTable('"+tablename+"','"+columnname+"')</script>";
}
function updateClientTable(tablename,columnname)
{
var parentEl=document.getElementById(tablename+"_TABLE");
var newmodel=TableModel.getInstance(tablename);
var newDOMmodel=TableDOMModel.getInstanceFor(parentEl);
var columns=columnname.split(",");
if(columnname=="*")
{
columns=newDOMmodel.viewCols;
}
var tds=parentEl.getElementsByTagName("td");
for(var i=0;i<columns.length;i++)
{
var columnindex=newDOMmodel.getViewIndexForCol(columns[i]);
for(var j=0;j<tds.length;j++)
{
if(tds[j].id!=null && tds[j].id.indexOf(tablename+"_")!=-1)
{
var el=tds[j];
var idx=tds[j].id;
var str=idx.split("_");
var len=str.length;
var colIn=parseInt(str[len-1]);
var rowIn=parseInt(str[len-2]);
if(colIn==columnindex)
{
var val=DOMUtils.getChildElsWithAttr(document.getElementById(tablename+"_hidden"),"id",tablename+"_r_"+rowIn+"_"+colIn+"_AF")[0].innerHTML;
el.innerHTML=val;
}
}
}	
}
document.getElementById(tablename+"_hidden").innerHTML="";
}	
function selectRowsInStack(uniqueId)
{
var arr=window["array_"+uniqueId];
for(var i=0;i<arr.length;i++)
{
var el=document.getElementById(arr[i]);
el.checked=true;
TableDOMModel.toggle(el);
}
}
function changeStatusText(uniqueId)
{
var text="";
if(document.getElementById(uniqueId+"_loading_text")!=null)
{
text=document.getElementById(uniqueId+"_loading_text").innerHTML;
var statusel=document.getElementById(uniqueId+"_loading");
statusel.innerHTML=text;
}
}
function selectRowsWithMatchingPK(uniqueId,pkColName,pkColumnValues)
{
var model=getTableModel(uniqueId);
var colNames=model.columnNames;
var pkColId=null;
var rowIdList=null;
var tableRows=model.tableRows;
var pkValueArray=pkColumnValues.split(",");
var i;
for(i=0;i<colNames.length;i++)
{
if(colNames[i]==pkColName)
{
pkColId=i;
break;		
}
}
for(i=0;i<tableRows.length;i++)
{
var pkval=tableRows[i][pkColId];
if(pkColumnValues.indexOf(pkval))
{
for(var j=0;j<pkValueArray.length;j++)
{
if(pkValueArray[j]==pkval)
{
if(rowIdList==null)
{
rowIdList=""+i;
}
else
{
rowIdList+=","+i
}
}
}
}
}
var rowIdArray=rowIdList.split(",");
var tableEl=document.getElementById(uniqueId+"_CT");
for(i=0;i<rowIdArray.length;i++)
{
var rowidx=rowIdArray[i];
var row= DOMUtils.getChildElsWithAttr(tableEl,"rowidx",rowidx)[0];
row.setAttribute("class","selected");
var checkboxel=DOMUtils.getChildElsWithAttr(row,"onclick","TableDOMModel.toggle(this);")[0];
checkboxel.checked=true;
TableDOMModel.toggle(checkboxel);
}
}
function isValidDate(value,element)
{
value=value.trim();
var column_type = (typeof element=="string")?element:element.getAttribute("coltype");
if(column_type=='DATE' || column_type=='date')
{	
var matches = /^(\d{4})[-\/](\d{2})[-\/](\d{2})$/.exec(value);
if (matches == null) return false;
var y = matches[1];
var m = matches[2] - 1;
var d = matches[3];
var composedDate = new Date(y, m, d);
return composedDate.getDate() == d &&
composedDate.getMonth() == m &&
composedDate.getFullYear() == y;
}
else
return false;
}
function isValidNumeric(value,element){
value = value.trim();
return isNumeric(value);
}
function isStringSet(value,element){
return true;
}
function isTime(value,element){
value=value.trim();
var column_type = (typeof element=="string")?element:element.getAttribute("coltype");
if(column_type=='TIME' || column_type=='time')
{
var matches = /^(\d{2})[\:](\d{2})[\:](\d{2})$/.exec(value);
if (matches == null) return false;
var cur_date = new Date();
var y=cur_date.getFullYear();
var m=cur_date.getMonth()+1;
var d=cur_date.getDate();
var hr = matches[1];
var min = matches[2];
var sec = matches[3];
var composedTime = new Date(y,m,d,hr, min, sec);
return composedTime.getSeconds() == sec &&
composedTime.getMinutes() == min &&
composedTime.getHours() == hr;
}
else
return false;
}
function isTimeStamp(value,element){
value=value.trim();
var column_type = (typeof element=="string")?element:element.getAttribute("coltype");
if(column_type=='TIMESTAMP' || column_type=='timestamp')
{
var matches = /^(\d{4})[-\/](\d{2})[-\/](\d{2})[\s](\d{2})[\:](\d{2})[\:](\d{2})$/.exec(value);
if (matches == null) return false;
var y = matches[1];
var m = matches[2] - 1;
var d = matches[3];
var hr = matches[4];
var min = matches[5];
var sec = matches[6];
var composedDate = new Date(y, m, d,hr,min,sec);
return composedDate.getDate() == d &&
composedDate.getMonth() == m &&
composedDate.getFullYear() == y &&
composedDate.getHours() == hr &&
composedDate.getMinutes() == min &&
composedDate.getSeconds() == sec;
}
else
return false;
}
function validateNO_COLUMN(value,element){
return true;
}
function hideFormat(element)
{
document.getElementById(element+'sp').style.visibility='hidden';
document.getElementById(element+'txt').focus();
}
function showFormat(element,value)
{
value=value.trim();
if(value==null || value==""){
document.getElementById(element+'sp').style.visibility='visible';
}
}
function hideOptions(columnName)
{
var input_id = columnName+'txt';
var span_id = columnName+'sp';
if(document.getElementById(input_id)){
document.getElementById(input_id).value="";
document.getElementById(input_id).disabled=true;
document.getElementById(span_id).style.visibility='hidden';			
}		
}
function showOptions(columnName,searchValue)
{
var input_id = columnName+'txt';
var span_id = columnName+'sp';
if(document.getElementById(input_id) && searchValue!=null && searchValue!=""){
var search_val = searchValue;
search_val = search_val.replace(/&#44;/g,",");
search_val = search_val.replace(/&#39;/g,"'");
if(search_val!=null){
document.getElementById(input_id).value= search_val;
if(search_val!="")
{
document.getElementById(span_id).style.visibility='hidden';
}
}	
else{
document.getElementById(input_id).disabled=true;
document.getElementById(span_id).style.visibility='hidden';	
}
}
}
function adjustOption(columnName)
{
var span_id=document.getElementById(columnName+'sp');
if(span_id){ span_id.style.top='-15px';span_id.style.right='0px';}
}
function setTextFocus(element)
{
document.getElementById(element+'txt').focus();
}
