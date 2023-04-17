function invokeActionForCVAddition(menuItemId, uniqueId, tableAlias, index)
{
var parentViewName = executeFunctionAsString(uniqueId+"_PARENT_CV",window);
tableAlias = getTableNameForMenuItem(menuItemId, uniqueId, tableAlias);
var url = getActionURL(menuItemId, uniqueId, tableAlias, uniqueId);
url += "&CVC_PARENT_VIEWNAME="+parentViewName;
openActionURL(menuItemId, url, uniqueId);
}
function invokeActionForCVUpdation(menuItemId, uniqueId, tableAlias, index)
{
var cvtabarray = executeFunctionAsString(uniqueId+"_CHILD_CV",window);
var childname = cvtabarray[index];
var parentname = stateData[uniqueId]["VIEW_NAME"];
tableAlias = getTableNameForMenuItem(menuItemId, uniqueId, tableAlias);
if(false == confirmAction(menuItemId))
{
return;
}
var url = getActionURL(menuItemId, uniqueId, tableAlias, uniqueId);
url += "&CVC_CURRENT_VIEWNAME="+childname;
openActionURL(menuItemId, url, uniqueId);
}
