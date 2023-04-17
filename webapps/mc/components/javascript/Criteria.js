function Criteria(tableBodyId)
{
this.id = tableBodyId;
this.defn = new Object();
this.tableBody = document.getElementById(tableBodyId);
this.tableBody.CROBJ = this;
this.rowId = 0;
this.defnNames = new Array();
this.defnDispNames = new Array();
this.matchVal = "or";
Criteria._MODELS[this.id] = this;
this.addDfn = function(criteriaDfn)
{
this.defn[criteriaDfn["COLNAME"]] = criteriaDfn;
if(!this.defaultDfn)
{
this.defaultDfn = criteriaDfn;
}
this.defnNames.push(criteriaDfn["COLNAME"]);
this.defnDispNames.push(criteriaDfn["DISPLAYNAME"]);
}
this.addDefaultRow = function()
{
this.addRow(this.defaultDfn);
}
this.create = function(criteriaList)
{
if(this.matchVal == null){this.matchVal = "or";}
var matchEl = document.getElementById(this.id + "_" + this.matchVal);
if(matchEl != null)
{
matchEl.checked = true;
}
if((criteriaList == null) || (criteriaList.length == 0))
{
this.addDefaultRow();
}
else
{
for(var i =0; i < criteriaList.length; i++)
{
var curCriteria = criteriaList[i];
var curDefn =  this.defn[curCriteria["COLNAME"]];
this.addRow(curDefn,curCriteria); 
}
}
}
this.addOptions = function(selectEl,optionVals,optionDisplayVals)
{
for(var i =0; i < optionVals.length; i++)
{
var objOption=document.createElement("OPTION");
objOption.value = optionVals[i];
objOption.innerHTML= optionDisplayVals[i];
selectEl.appendChild(objOption);
}   
}
this.addRow = function(curDefn,curCriteria)
{
var trRow = document.createElement("tr");
trRow.className ="criteriaRowTR";
trRow.ROWIDX = ++this.rowId;
trRow.CROBJ = this;
this.tableBody.appendChild(trRow);
this.genCriteriaCr(this.rowId,trRow,curDefn,curCriteria);
}
this.colChanged = function(el,trRow)
{
var rowId = trRow.ROWIDX;
var newColName = el.value;
this.genCriteriaCr(rowId,trRow,this.defn[newColName],null);
}
this.genCriteriaCr = function(rowId,trRow,curDefn,curCriteria)
{
var curType = curDefn["TYPE"];
Criteria.removeAllChilds(trRow);
Criteria.appendInnerHTML(document.getElementById("PREFIX"),trRow);
Criteria.appendInnerHTML(document.getElementById(curType),trRow);
Criteria.appendInnerHTML(document.getElementById("SUFFIX"),trRow);
var values = new Object();
Criteria.update(curDefn,values);
if(curCriteria != null)
{
Criteria.update(curCriteria,values);
}
Criteria.update({ROWIDX:rowId,MATCHVAL:this.matchVal},values);
var idEls = Criteria.getChildElsWithAttr(trRow,"name","*");
for(var i =0; i  < idEls.length; i++)
{
var curEl = idEls[i];
var name = curEl.getAttribute("name");
if(name == "COLNAME")
{
this.addOptions(curEl,this.defnNames,this.defnDispNames);
}
else if(curEl.nodeName == "SELECT")
{
var optVal = values[name + "_OPTVAL"]; 
if(optVal != null)
{
this.addOptions(curEl,optVal,(values[name + "_OPTDISP"] != null)?values[name + "_OPTDISP"]:optVal);
}
}
var curVal = values[name];
var type = curEl.type;
if(curVal != null)
{
if((type == "radio") || (type == "checkbox"))
{
curEl.checked = (curVal == curEl.value);
}
else if((curEl.nodeName =="DIV") || (curEl.nodeName =="SPAN"))
{
curEl.innerHTML=curVal;
}
else
{
curEl.value = curVal;
}
}
if((curEl.getAttribute("hideforfirst") == "true") && (rowId == 1))
{
curEl.style.display= "none";
}        
if(name== "COLVALUEID")
{
curEl.id="COLVALUE_" + rowId + "_DIV";
}
if(curEl.getAttribute("fixedname") != "true")
{
curEl.setAttribute("name",name + "_" + rowId);
}
curEl.setAttribute("origname",name);
}
var idEls = Criteria.getChildElsWithAttr(trRow,"onupdatefunc","*");
for(var i =0; i  < idEls.length; i++)
{
if(idEls[i].onupdatefuncref == null)
{
var func = idEls[i].getAttribute("onupdatefunc");
executeFunctionAsString(func,window,idEls[i]);
}
else{
idEls[i].onupdatefuncref();
}
}
}
this.deleteRow = function(el,trRow)
{
trRow.parentNode.removeChild(trRow);
}
this.changeMatch = function(newVal)
{
this.matchVal = newVal;
var els = Criteria.getChildElsWithAttr(this.tableBody,"name","MATCHVAL");
for(var i =0; i < els.length; i++)
{
els[i].innerHTML = newVal;
}
}
this.getAsParams = function(names)
{
var params="";
for(var i =0; i < names.length; i++)
{
var els = Criteria.getChildElsWithAttr(this.tableBody,"origname",names[i]);
for(var j =0;  j < els.length; j++)
{
params += els[j].getAttribute("name") + "=" +els[j].value + "&";
}        
}
return params.substring(0,params.length -1);
}
}
Criteria._MODELS= new Object();
Criteria.getInstanceFor = function(id)
{
return Criteria._MODELS[id];
}
Criteria.update = function(srcObj,destObj)
{
for(var i in srcObj)
{
destObj[i] = srcObj[i];
}
}
Criteria.invoke = function(selectCol)
{  
var trRow = Criteria.getInstanceFor(selectCol);
trRow.CROBJ[selectCol.getAttribute("function")](selectCol,trRow);
}
Criteria.getAssociatedElFor = function(srcEl,name)
{
var trRow = Criteria.getInstanceFor(srcEl);
var elList =  Criteria.getChildElsWithAttr(trRow,"origname",name);
return (elList.length > 0)? elList[0]:null;
}
Criteria.getInstanceFor = function(el)
{
var parEl = el;
while((parEl != null) && (parEl.CROBJ == null))
{
parEl = parEl.parentNode;
}
return parEl;
}
Criteria.getChildElsWithAttr = function(parentEl,attrName,attrValue)
{
var childNodes = parentEl.getElementsByTagName("*");
return this.filterElements(childNodes,null,attrName,attrValue);
}
Criteria.filterElements = function(elList,elType,attrName,attrValue)
{
var filteredList = new Array();
var j = 0;
for(var i =0;i < elList.length ; i++)
{
if((elType == null) || (elList[i].nodeName == elType))
{
if((attrName == null)|| (elList[i].getAttribute(attrName) == attrValue)
|| ((attrValue == "*") &&(elList[i].getAttribute(attrName) != null)))
{
filteredList[j++] = elList[i];
}
}
}
return filteredList;
}
Criteria.removeAllChilds = function(srcEl)
{
childNodes = LangUtils.cloneArray(srcEl.childNodes); 
for(var i =0;i < childNodes.length;i++)
{
srcEl.removeChild(childNodes[i]);
} 
}
Criteria.appendInnerHTML = function(srcEl,destEl)
{
srcEl = srcEl.cloneNode(true);
childNodes = LangUtils.cloneArray(srcEl.childNodes); 
for(var i =0;i < childNodes.length;i++)
{
destEl.appendChild(childNodes[i]);
} 
}
Criteria.displayCalendar = function(button)
{
if(button.onclick== null)
{
var inputField =  Criteria.getAssociatedElFor(button,"COLVALUE");
Calendar.setup(
{
inputField     :   inputField ,     
ifFormat       :    "%m/%d/%Y",      
button         :    button,  
align          :    "Bl",              
singleClick    :    true
});
}
}
Criteria.handleNull = function(comparatorCombo)
{
var trEl = Criteria.getInstanceFor(comparatorCombo);
var elList = Criteria.getChildElsWithAttr(trEl,"nullhide","*");
for(var i =0; i < elList.length; i++)
{
elList[i].style.display = (comparatorCombo.value >= 30 && comparatorCombo.value < 40)? "none":"";
}
}
