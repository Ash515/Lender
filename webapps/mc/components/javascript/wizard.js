function nextPage(wizardMainView)
{
var newFrm = createForm(wizardMainView + ".ve","post","WizardData");
var currentForm = document.forms[stateData[wizardMainView]["CURRENTVIEW"] + "_FRM"]; 
appendFormData(currentForm,newFrm);
storeOldData(wizardMainView,newFrm);
document.body.appendChild(newFrm);
submitFormAsSubReq(newFrm,"WIZARDFRAME");
}
function storeOldData(wizardMainView,newFrm)
{
for(var i=0;i<prevViews.length;i++)
{
appendFormData(document.forms[prevViews[i] + "_FRM"],newFrm);
}
}
function appendFormData(form,newFrm)
{
var elements = form.elements;
var len = elements.length;
for(var k=0;k<len;k++)
{
elem = elements[k];
if(elem.type == "select-one" || elem.type == "select-multiple")
{
var selectedIndex = elem.selectedIndex;
if(selectedIndex >= 0)
{
var options = elem.options;
var optionsLen = options.length;
for(var i=0;i<optionsLen;i++)
{
if(options[i].selected)
{
var newElement = document.createElement("input"); 
newElement.setAttribute("type","hidden");
newElement.setAttribute("name",elem.name);
newElement.setAttribute("value",elem.options[i].value);
newFrm.appendChild(newElement);
}
}
}
}
else
{
var newElement = document.createElement("input"); 
newElement.setAttribute("type","hidden");
newElement.setAttribute("name",elem.name);
if(elem.type == "checkbox")
{
if(elem.checked)
{
newElement.setAttribute("value",elem.value);
newFrm.appendChild(newElement);
}
}
else if(elem.type == "radio")
{
if(elem.checked)
{
newElement.setAttribute("value",elem.value);
newFrm.appendChild(newElement);
}
}
else
{
newElement.setAttribute("value",elem.value);
newFrm.appendChild(newElement);
}
}
}
}
var prevViews = new Array();
function handleWizardResponse(response,reqOptions)
{
var index = -1;
var responseViewEl = getRootViewEl(response);
var responseViewId = responseViewEl.getAttribute("unique_id");
for(var i =0; i < prevViews.length; i++)
{
if(prevViews[i] == responseViewId)
{
index = i;
prevViews.splice(i, prevViews.length - (i));
break;
}
}
if(index == -1)
{
if(stateData[uniqueId]["CURRENTVIEW"] == responseViewId)
{
var currentNode = document.getElementById(stateData[uniqueId]["CURRENTVIEW"] + "_CT");
currentNode.parentNode.removeChild(currentNode);
}
else
{
index = prevViews.length;
prevViews[index] = stateData[uniqueId]["CURRENTVIEW"];
var oldNode = document.getElementById(prevViews[prevViews.length -1] + "_CT");
oldNode.className = 'hide';
}
}
stateData[uniqueId]["CURRENTVIEW"] = responseViewId;
var newNode = responseViewEl;
var visibleDivEle = document.getElementById(uniqueId + "_VISIBLE");
if(browser_nn6 == true)
visibleDivEle.appendChild(newNode);
else
visibleDivEle.innerHTML = newNode.parentNode.innerHTML + visibleDivEle.innerHTML;
if(visibleDivEle.getElementsByTagName("form").length == 0)
{
var form = document.createElement("form");
form.setAttribute("name",stateData[uniqueId]["CURRENTVIEW"] + "_FRM");
form.innerHTML = newNode.innerHTML;
var newCrNode = document.createElement("div");
var origAttributes = newNode.attributes;
for(var i =0; i < origAttributes.length;i++)
{
newCrNode.setAttribute(origAttributes[i].name,origAttributes[i].value);
}
newCrNode.appendChild(form);
visibleDivEle.innerHTML = "";
visibleDivEle.appendChild(newCrNode);
}
}
function previousPage(wizardMainView)
{
var prevView = prevViews.pop();
var currentNode = document.getElementById(stateData[wizardMainView]["CURRENTVIEW"] + "_CT");
stateData[wizardMainView]["CURRENTVIEW"] = prevView;
currentNode.parentNode.removeChild(currentNode);
var newCurrentNode = document.getElementById(stateData[wizardMainView]["CURRENTVIEW"] + "_CT");
newCurrentNode.className = '';
}
