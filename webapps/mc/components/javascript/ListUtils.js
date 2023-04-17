function moveUp(SHOW_LIST)
{
var temptext = SHOW_LIST.options[0].text; 
var tempvalue = SHOW_LIST.options[0].value;
var i=1 ,opt,canmove="false",j=0;
while(opt = SHOW_LIST.options[i])
{
if (opt.selected)
{
j=i-1;
while(j>=0)
{
if(!SHOW_LIST.options[j].selected)
{
canmove="true";
break;
}
j--;
}
if(canmove == "true")
{
SHOW_LIST.options[i-1].value = SHOW_LIST.options[i].value;
SHOW_LIST.options[i-1].text = SHOW_LIST.options[i].text;
SHOW_LIST.options[i].value = tempvalue;
SHOW_LIST.options[i].text = temptext;
SHOW_LIST.options[i-1].selected = true;
SHOW_LIST.options[i].selected = false;
}
}
temptext = SHOW_LIST.options[i].text;
tempvalue = SHOW_LIST.options[i++].value;
canmove="false";
}
return false;
}
function moveDown(SHOW_LIST)
{
var temptext = SHOW_LIST.options[SHOW_LIST.options.length-1].text; 
var tempvalue = SHOW_LIST.options[SHOW_LIST.options.length-1].value;
var i=SHOW_LIST.options.length-2 ,opt,j,canmove="false";
while(opt = SHOW_LIST.options[i])
{
if (opt.selected)
{
j=i+1;
while(j<=SHOW_LIST.options.length-1)
{
if(!SHOW_LIST.options[j].selected)
{
canmove="true";
break;
}
j++;
}
if(canmove == "true")
{
SHOW_LIST.options[i+1].value = SHOW_LIST.options[i].value;
SHOW_LIST.options[i+1].text = SHOW_LIST.options[i].text;
SHOW_LIST.options[i].value = tempvalue;
SHOW_LIST.options[i].text = temptext;
SHOW_LIST.options[i+1].selected = true;
SHOW_LIST.options[i].selected = false;
}
}
temptext = SHOW_LIST.options[i].text;
tempvalue = SHOW_LIST.options[i--].value;
canmove="false";
if(i < 0){
break;
}
}
return false;
}
function updateLists(sourceList,destList)
{
var opt,i=0;
while(opt = sourceList.options[i++] )
{
if(opt.selected &&(opt.index >=0))
{
destList.options[destList.options.length] = new Option(opt.text, opt.value, true, false);
sourceList.options[i-1] = null;
i--;
}
}
return false;
}
function moveAll(sourceList, destList)
{
var opt,i=0;
while(opt = sourceList.options[i])
{
destList.options[destList.options.length] = new Option(opt.text, opt.value, true, false);
sourceList.options[i]=null;
}
return false;
}
function selectAllFromList(selectElement){
for(i = 0; i < selectElement.options.length; i++)
{
selectElement.options[i].selected = true;
}
}
var formClicked = false;
function submitCCSelectForm(form)
{
var i=0,opt;
var selectedValues="";
var queryStr = ""	  
if (form.SHOW_LIST.options.length ==0)
{
form.HIDE_LIST.focus();
alert("Atleast one value should be selected");
return false;
}
formClicked = true;
for(i=0;i<form.SHOW_LIST.options.length;i++)
{
opt = form.SHOW_LIST.options[i];
queryStr = queryStr.concat("&SHOW_LIST=");
queryStr = queryStr.concat(opt.value);
}
for(i=0;i<form.HIDE_LIST.options.length;i++)
{
opt = form.HIDE_LIST.options[i];
queryStr = queryStr.concat("&HIDE_LIST=");
queryStr = queryStr.concat(opt.value);
}
queryStr = queryStr.concat("&View_Name=" + form.View_Name.value);
var callBack =function() {
stateData[form.View_Name.value]["_VMD"]= '1';
refreshSubView(form.View_Name.value);
closeDialog();
};
AjaxAPI.sendRequest({URL:"ChooserSelectTypeInline.cc",PARAMETERS:queryStr,ONSUCCESSFUNC:callBack});
}
