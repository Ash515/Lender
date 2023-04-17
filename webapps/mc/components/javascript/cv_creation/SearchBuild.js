Search = function () {
};
Search.rowcnt=1;
if (document.all)
Search.browser_ie=true
else if (document.layers)
Search.browser_nn4=true
else if (document.layers || (!document.all && document.getElementById))
Search.browser_nn6=true
var divSearchLayer, objSearchTable, objMatchOperator
Search.setDefaultValues = function(mode)	
{
divSearchLayer=getObj("searchlayer");
objSearchTable=getObj("searchtable");
objMatchOperator=getObj("booleanoperator");
if (mode == "create")
{	
if (Search.defaultMatch=="all")	objMatchOperator[0].checked=true
else objMatchOperator[1].checked=true
}
var calimg=getObj("cal1");
var addrowbtn=getObj("addrowbtn");
var searchbtn=getObj("searchbtn");
if (calimg) 
{	
calimg.src=Search.calImageSrc
calimg.alt=Search.calAltText
}
addrowbtn.value=Search.addRowBtnText
if(searchbtn != null)
{
searchbtn.value=Search.searchBtnText
}
if (mode == "create")	
{
with (Search) 
{
createOption(getObj('searchfield1'),'Search._FLD',Search._TOTFLD)
if (getObj('divlist1')) {
createOption(getObj('listcondition1'),'Search._LSTCOND',Search._LSTCOND.length)
createOption(getObj('searchvalue1'),'Search._LSTVAL1',Search._LSTVAL1.length)
}
if (getObj('divtext1')) {
createOption(getObj('textcondition1'),'Search._TXTCOND',Search._TXTCOND.length)
}
if (getObj('divdate1')) {
createOption(getObj('datecondition1'),'Search._DATECOND',Search._DATECOND.length)
}
if (getObj('divnum1')){ 
createOption(getObj('numcondition1'),'Search._NUMCOND',Search._NUMCOND.length)
}
}
}
};
Search.createOption = function(selectField,arrayName,arrayLen,prevSelectField)
{
var fieldidx,fieldarr
for (i=0;i<arrayLen;i++)
{
var objOption=document.createElement("OPTION")
if (arrayName=="Search._FLD")
{
fieldidx=arrayName+(i+1)
fieldarr=executeFunctionAsString(fieldidx,window)
if (Search.browser_ie)
{
objOption.value=fieldarr[0]
objOption.id=fieldarr[2]
if (prevSelectField)
{
if (i==prevSelectField.selectedIndex)
{
objOption.selected=true
}
}
objOption.innerText=fieldarr[1]
}
else if (Search.browser_nn4 || Search.browser_nn6)
{
objOption.setAttribute("value",fieldarr[0])
objOption.setAttribute("id",fieldarr[2])
if (prevSelectField)
if (i==prevSelectField.selectedIndex)
objOption.setAttribute("selected","selected")
objOption.text=fieldarr[1]
}
}
else 
{
fieldarr=executeFunctionAsString(arrayName,window)
if (Search.browser_ie)
{
objOption.value=fieldarr[i]
if (prevSelectField)
if (i==prevSelectField.selectedIndex)
objOption.selected=true
objOption.innerText=fieldarr[i]
}
else if (Search.browser_nn4 || Search.browser_nn6)
{
objOption.setAttribute("value",fieldarr[i])
if (prevSelectField)
if (i==prevSelectField.selectedIndex)
objOption.setAttribute("selected","selected")
objOption.text=fieldarr[i]
}
}
selectField.appendChild(objOption)		
}
};
Search.createSpace = function(spanId)
{
var objSpace = document.createTextNode("\u00a0");
spanId.appendChild(objSpace)
};
Search.changeField = function(currFieldName)	
{
var rowId=currFieldName.substring(currFieldName.lastIndexOf("d")+1,currFieldName.length)
var divList=getObj("divlist"+rowId);
var divText=getObj("divtext"+rowId);
var divDate=getObj("divdate"+rowId);
var divNum=getObj("divnum"+rowId);
var objSearchfield=getObj("searchfield"+rowId)
var objFieldtype=getObj("searchfieldtype"+rowId)
switch(objSearchfield.options[objSearchfield.selectedIndex].id)
{
case "L": 
objFieldtype.value="L"
if (divList) divList.className=""
if (divText) divText.className="searchHide"
if (divDate) divDate.className="searchHide"
if (divNum) divNum.className="searchHide"
break;
case "T": 
objFieldtype.value="T"
if (divList) divList.className="searchHide"
if (divText) divText.className=""
if (divDate) divDate.className="searchHide"
if (divNum) divNum.className="searchHide"
break;
case "D":	
objFieldtype.value="D"
if (divList) divList.className="searchHide"
if (divText) divText.className="searchHide"
if (divDate) divDate.className=""
if (divNum) divNum.className="searchHide"
break;
case "N": 
objFieldtype.value="N"
if (divList) divList.className="searchHide"
if (divText) divText.className="searchHide"
if (divDate) divDate.className="searchHide"
if (divNum) divNum.className=""
break;
}
};
Search.changeSearchVal = function()
{
}
Search.addCriteria = function()
{
var objTable=document.createElement("TABLE")
var objTBody=document.createElement("TBODY")
var objTR=document.createElement("TR")
var objTD1=document.createElement("TD")
var objTD2=document.createElement("TD")
var objTD3=document.createElement("TD")
objTD3.className="searchRow";
var objDiv=document.createElement("DIV")
if (Search.listCriteriaAvailable) 
{
var objSpan1=document.createElement("SPAN")
var objListCond=document.createElement("SELECT")
var objListVal=document.createElement("SELECT")
}
if (Search.textCriteriaAvailable) 
{
var objSpan2=document.createElement("SPAN")
var objText=document.createElement("INPUT")
var objTextCond=document.createElement("SELECT")
}
if (Search.dateCriteriaAvailable) 
{
var objSpan3=document.createElement("SPAN")
var objDateCond=document.createElement("SELECT")
var objMonthList=document.createElement("SELECT")
var objDay=document.createElement("INPUT")
var objYear=document.createElement("INPUT")
var objDate=document.createElement("INPUT")
var objA=document.createElement("A")	
var objCal=document.createElement("IMG")
var objFormatText=document.createElement("INPUT")
}
if (Search.numCriteriaAvailable) 
{
var objSpan4=document.createElement("SPAN")
var objNumCond=document.createElement("SELECT")
var objNum=document.createElement("INPUT")
}
var objCheck=document.createElement("INPUT")
var objMatch=document.createElement("INPUT")
var objFieldList=document.createElement("SELECT")
var objFieldType=document.createElement("INPUT")
Search.rowcnt++
rowbgclass=(Search.rowcnt%2) ? "searchTROdd" : "searchTREven"
var matchtext=(objMatchOperator[0].checked) ? "and" : "or"
if (Search.browser_ie)
{
objTable.id="searchcriteria"+Search.rowcnt
objTable.width="100%"
objTable.border=0
objTable.cellpadding=2
objTable.cellspacing=0
objTable.className=rowbgclass
divSearchLayer.appendChild(objTable)
objTable.appendChild(objTBody)
objTBody.appendChild(objTR)
objTD1.width=20
objTD1.height=25
objTR.appendChild(objTD1)
objDiv.align="center"
objTD1.appendChild(objDiv)
objCheck.type="button"
objCheck.name="check"+Search.rowcnt
objCheck.id="check"+Search.rowcnt
objCheck.onclick=function() {
Search.removeCriteria(Search.rowcnt);
};
objCheck.className="cvCriteriaEditRmvBtn";
objDiv.appendChild(objCheck)
objTD2.width=10
objTR.appendChild(objTD2)
objMatch.type="text"
objMatch.className="searchMatchText"
objMatch.name="match"+Search.rowcnt
objMatch.id="match"+Search.rowcnt
objMatch.value=matchtext
objMatch.size=3
objMatch.readOnly=true
objTD2.appendChild(objMatch)
objTR.appendChild(objTD3)
objFieldList.name="searchfield"+Search.rowcnt
objFieldList.id="searchfield"+Search.rowcnt
objFieldList.className="select"
objFieldList.onchange=function() 
{
Search.changeField(objFieldList.id);
};
objTD3.appendChild(objFieldList)
Search.createOption(objFieldList,'Search._FLD',Search._TOTFLD,getObj('searchfield'+(Search.rowcnt-1)))
if (Search.listCriteriaAvailable) {	
objSpan1.id="divlist"+Search.rowcnt
objSpan1.className=getObj("divlist"+(Search.rowcnt-1)).className
objTD3.appendChild(objSpan1)
Search.createSpace(objSpan1)
objListCond.name="listcondition"+Search.rowcnt
objListCond.id="listcondition"+Search.rowcnt
objListCond.className="select"
objSpan1.appendChild(objListCond)
Search.createOption(objListCond,'Search._LSTCOND',Search._LSTCOND.length)
Search.createSpace(objSpan1)
objListVal.name="searchvalue"+Search.rowcnt
objListVal.id="searchvalue"+Search.rowcnt
objListVal.className="select"
objSpan1.appendChild(objListVal)
Search.createOption(objListVal,'Search._LSTVAL1',Search._LSTVAL1.length)
}
if (Search.textCriteriaAvailable) {	
objSpan2.id="divtext"+Search.rowcnt
objSpan2.className=getObj("divtext"+(Search.rowcnt-1)).className
objTD3.appendChild(objSpan2)
Search.createSpace(objSpan2)
objTextCond.name="textcondition"+Search.rowcnt
objTextCond.id="textcondition"+Search.rowcnt
objTextCond.className="select"
objSpan2.appendChild(objTextCond)
Search.createOption(objTextCond,'Search._TXTCOND',Search._TXTCOND.length)
Search.createSpace(objSpan2)
objText.type="text"
objText.name="searchtext"+Search.rowcnt
objText.id="searchtext"+Search.rowcnt
objText.size=25
objText.className="textField"
objSpan2.appendChild(objText)
Search.createSpace(objSpan2)
}
if (Search.dateCriteriaAvailable) {			
objSpan3.id="divdate"+Search.rowcnt
objSpan3.className=getObj("divdate"+(Search.rowcnt-1)).className
objTD3.appendChild(objSpan3)
Search.createSpace(objSpan3)
objDateCond.name="datecondition"+Search.rowcnt
objDateCond.id="datecondition"+Search.rowcnt		
objDateCond.className="select"
objSpan3.appendChild(objDateCond)
Search.createOption(objDateCond,'Search._DATECOND',Search._DATECOND.length)
Search.createSpace(objSpan3)
objDate.type="text"
objDate.className="textField"
objDate.name="searchdate"+Search.rowcnt
objDate.id="searchdate"+Search.rowcnt
objDate.size=25
objSpan3.appendChild(objDate)
Search.createSpace(objSpan3)
objA.href="javascript:;"
objSpan3.appendChild(objA)
objCal.name='cal'+Search.rowcnt
objCal.id='cal'+Search.rowcnt
objCal.src=Search.calImageSrc
objCal.border=0
objCal.align="absmiddle"
objCal.alt="searchdate"+Search.calAltText
addCalendar("Calendar"+Search.rowcnt,"Select Date",objDate.id,"")
objCal.onclick=function() {
return Search.showCal(this.id);
};
objA.appendChild(objCal)
Search.createSpace(objSpan3)
objFormatText.type="text"
objFormatText.id="formattext"+Search.rowcnt		
objFormatText.name="formattext"+Search.rowcnt
objFormatText.className="searchFormatText"
objFormatText.value="[yyyy-MM-dd]"
objFormatText.readOnly=true
objSpan3.appendChild(objFormatText)
}
if (Search.numCriteriaAvailable) {
objSpan4.id="divnum"+Search.rowcnt
objSpan4.className=getObj("divnum"+(Search.rowcnt-1)).className
objTD3.appendChild(objSpan4)
Search.createSpace(objSpan4)
objNumCond.name="numcondition"+Search.rowcnt
objNumCond.id="numcondition"+Search.rowcnt		
objNumCond.className="select"
objSpan4.appendChild(objNumCond)
Search.createOption(objNumCond,'Search._NUMCOND',Search._NUMCOND.length)
Search.createSpace(objSpan4)
objNum.type="text"
objNum.name="searchnum"+Search.rowcnt
objNum.id="searchnum"+Search.rowcnt
objNum.className="textField"
objNum.size=25
objNum.onkeypress=function() {
return Search.numCheck(this,event);
};
objSpan4.appendChild(objNum)
objFieldType.type="hidden"
objFieldType.name="searchfieldtype"+Search.rowcnt
objFieldType.id="searchfieldtype"+Search.rowcnt
objFieldType.value=getObj("searchfield"+Search.rowcnt).options[getObj("searchfield"+Search.rowcnt).selectedIndex].id
objTD3.appendChild(objFieldType)
}
}
else if(Search.browser_nn4 || Search.browser_nn6)
{
objTable.setAttribute("id","searchcriteria"+Search.rowcnt)	
objTable.setAttribute("width","100%")
objTable.setAttribute("border",0)
objTable.setAttribute("cellpadding",2)
objTable.setAttribute("cellspacing",0)
objTable.setAttribute("class",rowbgclass)
divSearchLayer.appendChild(objTable)
objTable.appendChild(objTBody)
objTBody.appendChild(objTR)
objTD1.setAttribute("width",20)
objTD1.setAttribute("height",25)
objTR.appendChild(objTD1)
objDiv.setAttribute("align","center")
objTD1.appendChild(objDiv)
objCheck.setAttribute("type", "button");
objCheck.setAttribute("name","check"+Search.rowcnt);    
objCheck.className="cvCriteriaEditRmvBtn";
objCheck.setAttribute("onClick","Search.removeCriteria(" + Search.rowcnt + ");");
objDiv.appendChild(objCheck)
objTD2.setAttribute("width",10)
objTR.appendChild(objTD2)
objMatch.setAttribute("type","text")
objMatch.setAttribute("class","searchMatchText")
objMatch.setAttribute("name","match"+Search.rowcnt)
objMatch.setAttribute("value",matchtext)
objMatch.setAttribute("size",5)
objMatch.setAttribute("readonly",true)
objTD2.appendChild(objMatch)
objTR.appendChild(objTD3)
objFieldList.setAttribute("name","searchfield"+Search.rowcnt)
objFieldList.setAttribute("class","select")
objFieldList.setAttribute("onchange","Search.changeField(this.name)")
objTD3.appendChild(objFieldList)
Search.createOption(objFieldList,'Search._FLD',Search._TOTFLD)
if (Search.listCriteriaAvailable) {		
objSpan1.setAttribute("id","divlist"+Search.rowcnt)
objSpan1.setAttribute("class","hide")
objTD3.appendChild(objSpan1)
Search.createSpace(objSpan1)
objListCond.setAttribute("name","listcondition"+Search.rowcnt)
objListCond.setAttribute("class","select")
objSpan1.appendChild(objListCond)
Search.createOption(objListCond,'Search._LSTCOND',Search._LSTCOND.length)
Search.createSpace(objSpan1)
objListVal.setAttribute("name","searchvalue"+Search.rowcnt)
objListVal.setAttribute("class","select")
objSpan1.appendChild(objListVal)
Search.createOption(objListVal,'Search._LSTVAL1',Search._LSTVAL1.length)
}
if (Search.textCriteriaAvailable) {			
objSpan2.setAttribute("id","divtext"+Search.rowcnt)
objSpan2.setAttribute("class","")
objTD3.appendChild(objSpan2)
Search.createSpace(objSpan2)
objTextCond.setAttribute("name","textcondition"+Search.rowcnt)
objTextCond.setAttribute("class","select")
objSpan2.appendChild(objTextCond)
Search.createOption(objTextCond,'Search._TXTCOND',Search._TXTCOND.length)
Search.createSpace(objSpan2)
objText.setAttribute("type","text")
objText.setAttribute("name","searchtext"+Search.rowcnt)
objText.setAttribute("size","25")
objText.setAttribute("class","textField")
objSpan2.appendChild(objText)
Search.createSpace(objSpan2)
}
if (Search.dateCriteriaAvailable) {			
objSpan3.setAttribute("id","divdate"+Search.rowcnt)
objSpan3.setAttribute("class","hide")
objTD3.appendChild(objSpan3)
Search.createSpace(objSpan3)
objDateCond.setAttribute("name","datecondition"+Search.rowcnt)
objDateCond.setAttribute("class","select")
objSpan3.appendChild(objDateCond)
Search.createOption(getObj('datecondition'+Search.rowcnt),'Search._DATECOND',Search._DATECOND.length)
Search.createSpace(objSpan3)
objDate.setAttribute("type","text")
objDate.setAttribute("class","textField")
objDate.setAttribute("name","searchdate"+Search.rowcnt)
objDate.setAttribute("size","25")
objSpan3.appendChild(objDate)
Search.createSpace(objSpan3)
objA.setAttribute("href","javascript:;")
objSpan3.appendChild(objA)
objCal.setAttribute("name",'cal'+Search.rowcnt)
objCal.setAttribute("id",'cal'+Search.rowcnt)
objCal.setAttribute("src",Search.calImageSrc)
objCal.setAttribute("border",0)
objCal.setAttribute("align","absmiddle")
objCal.setAttribute("alt","searchdate"+Search.calAltText)
objCal.setAttribute("onclick","return Search.showCal(this.id)")
objA.appendChild(objCal)
addCalendar("Calendar"+Search.rowcnt,"Select Date","searchdate"+Search.rowcnt,"")
Search.createSpace(objSpan3)
}
if (Search.numCriteriaAvailable) {
objFormatText.setAttribute("type","text")
objFormatText.setAttribute("name","formattext"+Search.rowcnt)
objFormatText.setAttribute("class","searchFormatText")
objFormatText.setAttribute("value","[yyyy-MM-dd]")
objFormatText.setAttribute("readonly",true)
objSpan3.appendChild(objFormatText)
objSpan4.setAttribute("id","divnum"+Search.rowcnt)
objSpan4.setAttribute("class","hide")
objTD3.appendChild(objSpan4)
Search.createSpace(objSpan4)
objNumCond.setAttribute("name","numcondition"+Search.rowcnt)
objNumCond.setAttribute("class","select")
objSpan4.appendChild(objNumCond)
Search.createOption(objNumCond,'Search._NUMCOND',Search._NUMCOND.length)
Search.createSpace(objSpan4)
objNum.setAttribute("type","text")
objNum.setAttribute("name","searchnum"+Search.rowcnt)
objNum.setAttribute("class","textField")
objNum.setAttribute("size","25")
objNum.setAttribute("onkeypress","return Search.numCheck(this,event)")
objSpan4.appendChild(objNum)
objFieldType.setAttribute("type","hidden")
objFieldType.setAttribute("name","searchfieldtype"+Search.rowcnt)
objFieldType.setAttribute("id","searchfieldtype"+Search.rowcnt)
objFieldType.setAttribute("value",getObj("searchfield"+Search.rowcnt).options[getObj("searchfield"+Search.rowcnt).selectedIndex].id)
objTD3.appendChild(objFieldType)
}
}
};
Search.removeCriteria = function(selNum)
{
var objCheck=getObj('check'+selNum)
var objSearchCriteria=getObj('searchcriteria'+selNum)		
divSearchLayer.removeChild(objSearchCriteria)
Search.rowcnt--;
atleastOneRowFound=true
for (i=1;i<=Search.rowcnt;i++)
{
rowbgclass=(i%2==0) ? "searchTREven" : "searchTROdd" 
if (!getObj("searchcriteria"+i))
{
if (Search.browser_ie)
var objChild=divSearchLayer.children
else if (Search.browser_nn4 || Search.browser_nn6)
var objChild=divSearchLayer.getElementsByTagName("table")
currRow=objChild.item(i-1).id
currId=currRow.substring(currRow.lastIndexOf("a")+1,currRow.length)
var objTable=getObj("searchcriteria"+currId)
if (Search.browser_ie)
{
objTable.className=rowbgclass
objTable.id="searchcriteria"+i
}
else if (Search.browser_nn4 || Search.browser_nn6)
{
objTable.setAttribute("class",rowbgclass)
objTable.setAttribute("id","searchcriteria"+i)
}
Search.changeIndex("check",currId,i)
Search.changeIndex("match",currId,i)
if (i == 1)
{
var objMatchText = getObj("match1")
objMatchText.value = ""
}
Search.changeIndex("searchfield",currId,i)
Search.changeIndex("searchfieldtype",currId,i)
if (Search.listCriteriaAvailable) {
Search.changeIndex("divlist",currId,i)
Search.changeIndex("listcondition",currId,i)
Search.changeIndex("searchvalue",currId,i)
}
if (Search.textCriteriaAvailable) {
Search.changeIndex("divtext",currId,i)
Search.changeIndex("textcondition",currId,i)
Search.changeIndex("searchtext",currId,i)
}
if (Search.dateCriteriaAvailable) {
Search.changeIndex("divdate",currId,i)
Search.changeIndex("datecondition",currId,i)
Search.changeIndex("searchdate",currId,i)
Search.changeIndex("cal",currId,i)
Search.changeIndex("formattext",currId,i)
}
if (Search.numCriteriaAvailable) {															
Search.changeIndex("divnum",currId,i)
Search.changeIndex("numcondition",currId,i)
Search.changeIndex("searchnum",currId,i)
}
}
}
};
Search.changeIndex = function(objPrefix,prevId,newId)
{
var tempObj=getObj(objPrefix+prevId)
if (Search.browser_ie)
{
tempObj.id=objPrefix+newId
if (objPrefix.indexOf("div")<0)
tempObj.name=objPrefix+newId
}
else if (Search.browser_nn4 || Search.browser_nn6)
{
tempObj.setAttribute("id",objPrefix+newId)
if (objPrefix.indexOf("div")<0)
tempObj.setAttribute("name",objPrefix+newId)
}
};
Search.changeMatch = function()
{
var matchoperator = (objMatchOperator[0].checked) ? "and" : "or"
for (i=2;i<=Search.rowcnt;i++)
{
var objMatch=getObj('match'+i)
objMatch.value=matchoperator
}
};
Search.numCheck = function(obj,e)
{
if (Search.browser_ie)
var key = window.event.keyCode
else if (Search.browser_nn4 || Search.browser_nn6)
var key = e.which
if ((key>=48 && key<=57) || (key==0 || key==13 || key==8) || (key==46)) {
if (key==46) {
if (obj.value.indexOf(".")==-1)
return true;
else
return false;
} else 
return true;
} else
return false;
};
Search.showCal = function(x)
{
x = x.substring(x.indexOf('l')+1,x.length)	
showCal('Calendar'+x)
};
