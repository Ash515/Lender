function deleteFilter(viewId,listId,filterName,controllerViewName)
{
var confirmString = I18N.getMsg("Do you want to delete the Filter?");
var confirmVar = confirm(confirmString);
if(confirmVar == true)
{
AjaxAPI.sendRequest({URL:controllerViewName+".ve",PARAMETERS:"EVENT_TYPE=Delete&FILTERNAME="+ filterName +"&LISTID="+ listId,SRCVIEW:viewId,ONSUCCESSFUNC:"clearFilter"});
}
}
function clearFilter(response,requestOptions)
{
selectFilter(requestOptions.v('SRCVIEW'),null);
}
function createFilter(viewId,eventType,listId,filterName,controllerViewName)
{
AjaxAPI.sendRequest({URL:controllerViewName+".cc",PARAMETERS:"VIEWNAME=" + viewId +"&EVENT_TYPE=" + eventType +"&FILTERNAME="+ filterName +"&LISTID="+ listId ,CONTAINERID:viewId + "_FILTERPOS",ONSUCCESSFUNC:"showFilterInDiv"});
}
function showFilterInDiv(response,requestOptions)
{
document.getElementById(requestOptions.v('CONTAINERID')).innerHTML = response.getOnlyHtml();
document.getElementById(requestOptions.v('CONTAINERID')).style.display = "";
}
function closeFilter(viewId)
{
var div = document.getElementById(viewId + "_FILTERPOS");        
div.innerHTML = " ";
div.style.display="none";
}
function filterSaved(response,requestOptions)
{
var viewId = requestOptions['TABLEVIEW'];
closeFilter(viewId);
selectFilter(viewId,response.getResponseParams()['FILTERNAME']);
}
