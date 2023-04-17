function handleScriptForDropDownTab(viewName,index,tabViewName,typeFlag,buttonExists)
{
if(window[tabViewName+"_"+index]=="true")
{
return;
}
window[tabViewName+"_"+index+"_typeFlag"]=typeFlag;
var id=tabViewName+"_div_"+index;
var div=createDivWithId(id,viewName,index);
var uniqueid=tabViewName;
if(executeFunctionAsString(uniqueid+"_"+index+"_overflow",window) && executeFunctionAsString(uniqueid+"_"+index+"_overflow")!="null",window)
{
div.style.overflow=executeFunctionAsString(uniqueid+"_"+index+"_overflow",window);
}
else
{
div.style.overflow="auto";
}
div.style.display="none";
if(executeFunctionAsString(uniqueid+"_"+index+"_zIndex",window)!="null")
{
div.style.zIndex=executeFunctionAsString(uniqueid+"_"+index+"_zIndex",window);
}
else
{
div.style.zIndex="90";
}
div.style.position="absolute";
window[tabViewName+"_"+index]="true";
var mouseEvent="mouseover";
var displayType=executeFunctionAsString(uniqueid+"_"+index+"_displayType",window);
if(displayType!="null")
{
if(displayType.toLowerCase().indexOf("click")!=-1)
{
mouseEvent="click";
}
}
var link=document.getElementById(tabViewName+"_"+index);
if(buttonExists=="true")
{
if(displayType.toLowerCase().indexOf("text")!=-1)
{
addEvent(link,mouseEvent,showElement,true);
}
link=document.getElementById(tabViewName+"_dropbutton_"+index);
}
else
{
if(displayType.toLowerCase().indexOf("click")!=-1)
{
var link1=document.getElementById(tabViewName+"_link_"+index);
addEvent(link1,mouseEvent,showElement,true);
}
}
addEvent(link,mouseEvent,showElement,true);
if(typeFlag!=2)
{
openURLInDIV(viewName+".cc",id);
div.className="TabDropDownView";
}
else
{
openDivContentInDIV(tabViewName+"_div_hide_"+index,id);
}
}
function openDivContentInDIV(sourceId,destinationId)
{
var source=document.getElementById(sourceId);
var destination=document.getElementById(destinationId);	
var content=source.innerHTML;
destination.innerHTML=content;
}
function createDivWithId(id,viewName,index)
{
var oDialog=document.createElement("DIV");
oDialog.id=id;
oDialog.viewName=viewName;
oDialog.index=index;
document.body.appendChild(oDialog);
return oDialog;
}
function hideElement(event)
{
var srcEl;
if (browser_ie) {
srcEl = window.event.srcElement;		
} else if (browser_nn4 || browser_nn6) {
srcEl = event.target;
}
if((srcEl.className)==("TabDropDownView"))
{
srcEl.style.display="none";
}	
}
function showElement(event)
{	
var uniqueid;
var index;
var srcEl;
if (browser_ie) {
srcEl = window.event.srcElement;		
} else if (browser_nn4 || browser_nn6) {
srcEl = event.target;
}
var previousDropDownId=getLastSeperation(window["existingDropDown"]);
if(srcEl.getAttribute("viewName")!=null && srcEl.getAttribute("viewName")!="undefined")
{
uniqueid=srcEl.getAttribute("viewName");
index=srcEl.getAttribute("index");
}
else
{
return;
}
var parentEl=DOMUtils.getParentWithAttrValue(srcEl,"id",previousDropDownId);
var shownDivs="";
if(window["existingDropDown"])
{
shownDivs=window["existingDropDown"];
}
if(parentEl.id!=previousDropDownId ||shownDivs=="")
{
var parentId=uniqueid+"_div_"+index;
if((shownDivs!= "undefined") && (shownDivs!="")&& (shownDivs!="null"))
{
if(shownDivs.indexOf(parentId)!=-1)
{
var toBeHidden=shownDivs.substring(shownDivs.indexOf(parentId)+parentId.length+1,shownDivs.length);
if(toBeHidden!="")
{
shownDivs=shownDivs.substring(0,shownDivs.indexOf(toBeHidden)-1);
}
hideDropDowns(null,null,toBeHidden);
}
else if(shownDivs.indexOf(uniqueid)!=null)
{
var toBeHidden=shownDivs.substring(shownDivs.indexOf(uniqueid),shownDivs.length);
if(toBeHidden!="")
{
shownDivs=shownDivs.substring(0,shownDivs.indexOf(toBeHidden)-1);
}
hideDropDowns(null,null,toBeHidden);	
if(shownDivs=="")
{
shownDivs=parentId;	
}
else
{
shownDivs+=	","+ parentId;	
}
}
else
{
hideDropDowns(null,null,shownDivs);
shownDivs=uniqueid+"_div_"+index;
}
}
else
{
shownDivs=parentId;
}
}
else
{
shownDivs+=","+uniqueid+"_div_"+index;
}
window["existingDropDown"]=shownDivs;
var flag=parseInt(window[uniqueid+"_"+index+"_typeFlag"]);
var div= document.getElementById(uniqueid+"_div_"+index);
var link= document.getElementById(uniqueid+"_"+index);
div.style.display="block";
var offsetWidth;
var offsetHeight;
var offsetTop;
var offsetLeft;
if(executeFunctionAsString(uniqueid+"_"+index+"_offsetWidth",window)!="null")
{
offsetWidth=parseInt(executeFunctionAsString(uniqueid+"_"+index+"_offsetWidth",window));
}
else
{
offsetWidth=0;
}
if(executeFunctionAsString(uniqueid+"_"+index+"_offsetHeight",window)!="null")
{
offsetHeight=parseInt(executeFunctionAsString(uniqueid+"_"+index+"_offsetHeight",window));
}
else
{
offsetHeight=0;
}
if(executeFunctionAsString(uniqueid+"_"+index+"_offsetTop",window)!="null")
{
offsetTop=parseInt(executeFunctionAsString(uniqueid+"_"+index+"_offsetTop",window));
}
else
{
offsetTop=0;
}
if(executeFunctionAsString(uniqueid+"_"+index+"_offsetLeft",window)!="null")
{
offsetLeft=parseInt(executeFunctionAsString(uniqueid+"_"+index+"_offsetLeft",window));
}
else
{
offsetLeft=0;
}
if(executeFunctionAsString(uniqueid+"_"+index+"_isVerticalTab",window)=="true")
{
div.style.top= findPosY(link.parentNode)+offsetTop;
div.style.left= findPosX(link.parentNode)+link.parentNode.offsetWidth+offsetLeft;
}
else
{
div.style.top= findPosY(link.parentNode)+link.parentNode.offsetHeight+ offsetTop;
div.style.left= findPosX(link.parentNode)+ offsetLeft;
}
if(flag==1)
{
div.style.width=link.parentNode.offsetWidth+offsetWidth;
if(executeFunctionAsString(uniqueid+"_"+index+"_overflow",window) && executeFunctionAsString(uniqueid+"_"+index+"_overflow",window)!="null")
{
div.style.overflow=executeFunctionAsString(uniqueid+"_"+index+"_overflow",window);
}
else
{
div.style.overflow="hidden";
}
}
else
{
if(offsetWidth!=0)
{
div.style.width=offsetWidth;
}
}
if(offsetHeight!=0)
{
div.style.height=offsetHeight;
}
document.onkeydown = dropDownEscEvnt;
document.onmousedown = dropDownMousePressCloseEvnt;
}
function dropDownEscEvnt(event)
{
if (browser_ie){
var keyCode = window.event.keyCode;
}
else if (browser_nn4 || browser_nn6){
var keyCode = event.which;
}
if (keyCode == 27 )
{
hideDropDowns(event);
}
}
function dropDownMousePressCloseEvnt(ev)
{
var srcEl;
if (browser_ie) {
srcEl = window.event.srcElement;		
} else if (browser_nn4 || browser_nn6) {
srcEl = ev.target;
}
var shown=window["existingDropDown"];
var shownDivs=getAsArray(window["existingDropDown"]);
var isParentPresent=false;
for(var i=0;i<shownDivs.length;i++)
{
var parentEl=DOMUtils.getParentWithAttrValue(srcEl,"id",shownDivs[i]);
if((shownDivs[i]!="") && (parentEl.id!=shownDivs[i]))
{
continue;
}
else
{
isParentPresent=true;
break;
}
}
if(isParentPresent)
{
return;
}   
else
{
window["existingDropDown"]="";
hideDropDowns(ev,null,shown);
}
}
function hideDropDowns(event,exceptId,idlist)
{
if(idlist=="")
{
return;
}
var idList=window["existingDropDown"];
if(idlist!=null && idlist!="undefined")
{
idList=idlist;
}
var idArray=getAsArray(idList);
var dropDown;
for(var i=0;i<idArray.length;i++)
{
if(idArray[i]!="undefined" && exceptId!=idArray[i])
{
dropDown=document.getElementById(idArray[i]);
if(dropDown!=null && dropDown!="undefined")
{
dropDown.style.display="none";
}
}
}
}
function getAsArray(list)
{
var array = new Array();
var counter=0;
while(list.indexOf(',')!=-1)
{
array[counter]=list.substring(0,list.indexOf(','));
counter++;
list=list.substring(list.indexOf(',')+1,list.length);
}
array[counter]=list;
return array;
}
function addEvent(el,evType,fn,useCapture){
var retur=false;
if(el!=null){
if(el.addEventListener){
el.addEventListener(evType,fn,useCapture);
retur=true;
}
else if(el.attachEvent){
el.attachEvent("on"+evType,fn);retur=true;
}
}
return retur;
}		
function getLastSeperation(str)
{
if(str!=null&& str!="undefined")
{
if(str.indexOf(",")==-1)
{
return str;
}
while(str.indexOf(",")!=-1)
{
str=str.substring(str.indexOf(",")+1,str.length);
}
return str;
}
else
{
return null;
}
}
