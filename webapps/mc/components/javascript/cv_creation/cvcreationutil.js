function moveUp(selectedColumns) 
{
var selectedColumnsObj = document.getElementById(selectedColumns);
var currpos=selectedColumnsObj.options.selectedIndex
if (currpos>0) 
{
var prevpos=selectedColumnsObj.options.selectedIndex-1
if (browser_ie) 
{
temp=selectedColumnsObj.options[prevpos].innerText
selectedColumnsObj.options[prevpos].innerText=selectedColumnsObj.options[currpos].innerText
selectedColumnsObj.options[currpos].innerText=temp     
} 
else if (browser_nn4 || browser_nn6) 
{
temp=selectedColumnsObj.options[prevpos].text
selectedColumnsObj.options[prevpos].text=selectedColumnsObj.options[currpos].text
selectedColumnsObj.options[currpos].text=temp
}
temp=selectedColumnsObj.options[prevpos].value
selectedColumnsObj.options[prevpos].value=selectedColumnsObj.options[currpos].value
selectedColumnsObj.options[currpos].value=temp
selectedColumnsObj.options[prevpos].selected=true
selectedColumnsObj.options[currpos].selected=false
}
}
function moveDown(selectedColumns) 
{
var selectedColumnsObj = document.getElementById(selectedColumns);
var currpos=selectedColumnsObj.options.selectedIndex
if (currpos<selectedColumnsObj.options.length-1)	
{
var nextpos=selectedColumnsObj.options.selectedIndex+1
if (browser_ie) 
{	
temp=selectedColumnsObj.options[nextpos].innerText
selectedColumnsObj.options[nextpos].innerText=selectedColumnsObj.options[currpos].innerText
selectedColumnsObj.options[currpos].innerText=temp
}
else if (browser_nn4 || browser_nn6) 
{
temp=selectedColumnsObj.options[nextpos].text
selectedColumnsObj.options[nextpos].text=selectedColumnsObj.options[currpos].text
selectedColumnsObj.options[currpos].text=temp
}
temp=selectedColumnsObj.options[nextpos].value
selectedColumnsObj.options[nextpos].value=selectedColumnsObj.options[currpos].value
selectedColumnsObj.options[currpos].value=temp
selectedColumnsObj.options[nextpos].selected=true
selectedColumnsObj.options[currpos].selected=false
}
}
function formSubmit()
{
if (emptyCheck("customviewname","View Name") && checkForSelectedElements()) 
{
selectAllElements(document.getElementById("selectedColumns"),true);
selectAllElements(document.getElementById("availableColumns"),true);
handleStateForForm(document.CVCreationForm);
return true;
}
else 
{
return false;
}
}
function handleMovingOfColumns(type,destination,source)
{
if(type == 'add')
{
selectAllElements(source,true);
updateList(type,destination,source);
}
else if( type == 'remove')
{
selectAllElements(destination,true);
updateList(type,destination,source);
}
}
function checkForSelectedElements()
{
var options = document.getElementById("selectedColumns").options;
var len = options.length;
if( len <= 0 )
{
alert('Select atleast one column to view');
return false;
}
return true;
}
function selectAllElements(selectComp, selected)
{
var options = selectComp.options;
var len = options.length;
for(var i=0;i<len;i++)
{
options[i].selected = selected;
}
}
