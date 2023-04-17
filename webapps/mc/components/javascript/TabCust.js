TabCustomize = function(url, features, saveFunc) {
document["tabCust"] = this;
var callBack = function(xmlhttp) {
document["tabCust"].saveFunc = (typeof saveFunc != "undefined") ? saveFunc : "";
document["tabCust"].setup(xmlhttp.responseText, features);
};
AjaxAPI.sendRequest({METHOD:"GET",URL:url,ONSUCCESSFUNC:callBack});
};
TabCustomize.prototype.setup = function(xmlStr, features) {
if (browser_opera || browser_nn4 || browser_nn6) {
var parser = new DOMParser();
var xmlDoc = parser.parseFromString(xmlStr, "text/xml");
var nodes = xmlDoc.documentElement.childNodes;
} else if (browser_ie) {
var	xmlDoc = new ActiveXObject("Microsoft.XMLDOM");
xmlDoc.async = "false";
xmlDoc.loadXML(xmlStr);
var nodes = xmlDoc.documentElement.childNodes;
}
var tableStr = "<table cellspacing='0' cellpadding='0' class='TabCustomize' id='_TAB_CUSTOMIZATION_DIALOG'>\n";
for (var i = 0, k = 1; i < nodes.length; i++, k++) {
if (browser_opera || browser_nn4 || browser_nn6) {
if (nodes[i].nodeName == "#text") {
k++;
continue;
}
var value = nodes[i].childNodes[0].nodeValue;
} else {
var value = nodes[i].text;
}
var id = nodes[i].getAttribute('id');
var state = nodes[i].getAttribute('state');
var edit = nodes[i].getAttribute('edit');
var type = nodes[i].getAttribute('type');
var rowClass = (k % 2 == 0) ? "evenTab" : "oddTab";
tableStr += "  <tr class = '" + rowClass + "' id = '" + id + "' state = '" + state + "' edit = '" + edit + "' type = '" + type + "'>\n";
if (state == "active") tableStr += "    <td nowrap><input type='button' class='tabActive' title='Deselect'><input type='button' class='tabInActive' title='Select' style='display:none'></td>\n";
else if (state == "inactive") tableStr += "    <td nowrap><input type='button' class='tabActive' title='Deselect' style='display:none'><input type='button' title='Select' class='tabInActive'></td>\n";
else tableStr += "    <td nowrap>&nbsp;</td>\n";
tableStr += "    <td class = '" + state + "Item' title='Drag to reorder' style='cursor:move'>" + value + "</td>\n";
if (edit == "yes") tableStr += "    <td nowrap><input type='button' class='tabEdit' title='Rename'></td>";
else tableStr += "    <td nowrap>&nbsp;</td>";
if (type == "custom") tableStr += "    <td nowrap><input type='button' class='tabDelete' title='Delete'></td>";
else tableStr += "    <td nowrap>&nbsp;</td>";
tableStr += "  </tr>\n";
}
tableStr += "</table>";
tableStr += "<table width='100%' cellspacing='0' cellpadding='0'>\n<tr>\n";
tableStr += "<td align='center'><input type='button' id='_TAB_CUSTOMIZATION_SAVE_BUTTON' value='Save' class='btn'> <input type='button' value='Cancel' class='btn' onclick='closeDialog()'></td>";
tableStr += "\n</tr>\n</table>\n";
showDialog(tableStr, features);
this.tableId = "_TAB_CUSTOMIZATION_DIALOG";
this.oTable = getObj(this.tableId);
if (typeof this.oTable != "undefined" && this.oTable != null) {
this.oTR = this.oTable.rows;
for (var i = 0; i < this.oTR.length; i++) {
oTD = this.findChild(this.oTR[i], "TD");
oTD[1]["dragLis"] = this;
oTD[1].onmousedown = function(ev) {
this["dragLis"].captureTab(ev);
}
oStateBtn = this.findChild(oTD[0], "INPUT");
if (oStateBtn.length > 0) {
oActiveBtn = oStateBtn[0];
oActiveBtn["clickLis"] = this;
oActiveBtn.onclick = function() {
this["clickLis"].toggleState(this.parentNode.parentNode, this.parentNode);
}
oInActiveBtn = oStateBtn[1];
oInActiveBtn["clickLis"] = this;
oInActiveBtn.onclick = function() {
this["clickLis"].toggleState(this.parentNode.parentNode, this.parentNode);
}
oTD[0].appendChild(oActiveBtn);
oTD[0].appendChild(oInActiveBtn);
}
oEditBtn = this.findChild(oTD[2], "INPUT");
if (oEditBtn.length > 0) {
oEditBtn[0]["clickLis"] = this;
oEditBtn[0].onclick = function() {
this["clickLis"].renameTab(this.parentNode.parentNode);
}
}
oDelBtn = this.findChild(oTD[3], "INPUT");
if (oDelBtn.length > 0) {
oDelBtn[0]["clickLis"] = this;
oDelBtn[0].onclick = function() {
this["clickLis"].deleteTab(this.parentNode.parentNode);
}
}
}
this.keyDownFunc = document.onkeydown;
document["tabCust"] = this;	
this.oRenameField = document.createElement("INPUT");
this.oRenameField.style.width = "100%";
this.oRenameField["blurLis"] = this;
this.oRenameField.onblur = function(ev) {
this["blurLis"].updateTab(ev);
}
this.oRenameField["keyDownLis"] = this;
this.oRenameField.onkeypress = function(ev) {
this["keyDownLis"].keyDown(ev);
}
this.oMoveTab = document.createElement("DIV");
this.oMoveTab.className = "tabMove";
this.oMoveTab.style.cursor = "move";
this.oMoveTab.style.zIndex = "200";
this.oMoveTab.style.position = "absolute";	
this.oMoveTab.style.left = "-1000px";
this.oMoveTab.style.top = "-1000px";
document.body.appendChild(this.oMoveTab);
this.oSaveBtn = getObj("_TAB_CUSTOMIZATION_SAVE_BUTTON");
this.oSaveBtn["clickLis"] = this;
this.oSaveBtn.onclick = function() {
this["clickLis"].save();
}
}
};
TabCustomize.prototype.toggleState = function(oCurrTab, oFirstTD) {
if (this.renameAction) this.cancelEdit();
oTD = this.findChild(oCurrTab, "TD");
oState = this.findChild(oFirstTD, "INPUT");
if (oCurrTab.getAttribute("state") == "active") {
oCurrTab.setAttribute("state", "inactive");
oTD[1].className = "inactiveItem";
oState[0].style.display = "none";
oState[1].style.display = "";
} else {
oCurrTab.setAttribute("state", "active");
oTD[1].className = "activeItem";
oState[0].style.display = "";
oState[1].style.display = "none";
}
};
TabCustomize.prototype.renameTab = function(oCurrTab) {
if (this.renameAction) this.cancelEdit();
this.currEditTab = oCurrTab;
oTD = this.findChild(oCurrTab, "TD");
this.currContentTD = oTD[1];
this.currEditTD = oTD[2];
oCurrTab.removeChild(oTD[2]);
oTD[1].colSpan = 2;
this.currContentTD.title = "";
this.currContentTD.style.cursor = "";
this.currContent = oTD[1].innerHTML;
oTD[1].innerHTML = "";
oTD[1].appendChild(this.oRenameField);
this.oRenameField.value = this.currContent;
this.oRenameField.focus();
this.oRenameField.focus();
document.onkeydown = function(ev) {
if (browser_ie) var keyCode = window.event.keyCode;
else if (browser_nn4 || browser_nn6) var keyCode = ev.which;
if (keyCode == 27) {
if (document["tabCust"].renameAction) 
document["tabCust"].cancelEdit();
}
}
this.renameAction = true;
};
TabCustomize.prototype.keyDown = function(ev) {
if (browser_ie) var keyCode = window.event.keyCode;
else if (browser_nn4 || browser_nn6) var keyCode = ev.which;
if (keyCode == 13) this.updateTab();
}
TabCustomize.prototype.updateTab = function() {
this.cancelEdit();
this.currContentTD.innerHTML = this.oRenameField.value;
};
TabCustomize.prototype.cancelEdit = function() {
this.currContentTD.colSpan = 1;
this.currContentTD.innerHTML = this.currContent;
this.currContentTD.title = "Drag to reorder";
this.currContentTD.style.cursor = "move";
oTD = this.findChild(this.currEditTab, "TD");
this.currEditTab.insertBefore(this.currEditTD, oTD[2]);
this.renameAction = false;
document.onkeydown = this.keyDownFunc; 
};
TabCustomize.prototype.deleteTab = function(oCurrTab) {
if (this.renameAction) this.cancelEdit();
oTBody = this.findChild(this.oTable, "TBODY"); 
oTBody[0].removeChild(oCurrTab);
this.oTR = this.oTable.rows;
};
TabCustomize.prototype.captureTab = function(ev) {
if (browser_ie) srcElement = window.event.srcElement;
else if (browser_nn4 || browser_nn6) srcElement = ev.target;
this.transPosCnt = 0;
this.transXPoints = this.transYPoints = null;
window.clearInterval(this.transIntervalId);
this.oMoveTab.style.left = this.oMoveTab.style.top = "-1000px";
for (var i = 0; i < this.oTable.rows.length; i++)
this.oTable.rows[i].style.visibility = "";
if (typeof srcElement != "undefined" && srcElement != null) {
if (!this.renameAction || (this.renameAction && this.currContentTD != srcElement && srcElement != this.oRenameField)) {
this.oCurrTab = srcElement.parentNode;
this.oMoveTab.style.width = this.oCurrTab.offsetWidth;
this.oMoveTab.style.height = this.oCurrTab.offsetHeight;
this.oMoveTab.style.left = findPosX(this.oCurrTab) + "px";
this.oMoveTab.style.top = findPosY(this.oCurrTab) + "px";
this.oMoveTab.innerHTML = "<table class='TabCustomize' style='width:" + (this.oTable.offsetWidth) + "' cellspacing='0' cellpadding='0'>" + this.oCurrTab.outerHTML + "</table>";
this.oMoveTab.style.clip = "rect(0, " + this.oMoveTab.style.width + ", 100, 1)";
oMoveTable = this.findChild(this.oMoveTab, "TABLE");
oMoveTD = this.findChild(oMoveTable[0].rows[0], "TD");
oCurrTD = this.findChild(this.oCurrTab, "TD");
for (var i = 0; i < oMoveTD.length; i++) 
oMoveTD[i].style.width = oCurrTD[i].offsetWidth + "px";
this.oCurrTab.style.visibility = "hidden";
if (browser_ie) {
this.diffLeft = window.event.clientX + document.body.scrollLeft - parseInt(this.oMoveTab.style.left);
this.diffTop = window.event.clientY + document.body.scrollTop - parseInt(this.oMoveTab.style.top);
} else if (browser_nn4 || browser_nn6) {
this.diffLeft = ev.pageX - parseInt(this.oMoveTab.style.left);
this.diffTop = ev.pageY - parseInt(this.oMoveTab.style.top);
}
document["dragLis"] = this;
document.onmousemove = function(ev) {
document["dragLis"].moveTab(ev);
};
document.onmouseup = function(ev) {
document["dragLis"].releaseTab(ev);
};
}
}
};
TabCustomize.prototype.moveTab = function(ev) {
clearTextSelection();
if (browser_ie) {
if (window.event.clientY + window.screenTop + 50 >= window.screen.height - 50) document.body.scrollTop += 20;
else if (window.event.clientY <= 50) document.body.scrollTop -= 20;
var currTop = (window.event.clientY - this.diffTop) + document.body.scrollTop;
} else if (browser_nn4 || browser_nn6) {
var currTop = (ev.pageY - this.diffTop);
document.body.style.cursor = "move";
}
if (currTop >= findPosY(this.oTable) && currTop <= (findPosY(this.oTable) + this.oTable.offsetHeight - this.oCurrTab.offsetHeight)) {
this.oMoveTab.style.top = currTop + "px";
var layerMidY = currTop + (parseInt(this.oMoveTab.style.height) / 2);
this.oTR = this.oTable.rows;
for (var i = 0; i < this.oTR.length; i++) {
if (layerMidY >= findPosY(this.oTR[i]) && layerMidY <= (findPosY(this.oTR[i]) + this.oTR[i].offsetHeight)) {
var oHoverTR = this.oTR[i];
var diff = findPosY(this.oMoveTab) - findPosY(this.oTR[i])
if (i == this.oTR.length - 1 && diff >= -5) oHoverTR.parentNode.appendChild(this.oCurrTab);
else oHoverTR.parentNode.insertBefore(this.oCurrTab, oHoverTR);
break;
}
}
}
};
TabCustomize.prototype.releaseTab = function() {
document.onmousemove = null;
document.onmouseup = null;
document.body.style.cursor = "";
for (var i = 0, k = 1; i < this.oTable.rows.length; i++, k++) 
this.oTable.rows[i].className = (k % 2 == 0) ? "evenTab" : "oddTab";
this.transXPoints = new Array();
this.transYPoints = new Array();
this.drawPath(parseInt(this.oMoveTab.style.left), parseInt(this.oMoveTab.style.top), findPosX(this.oCurrTab), findPosY(this.oCurrTab));
this.transPitStops = (this.transXPoints.length > 10) ? (this.transXPoints.length - 1) / 10 : 1; 
this.transPosCnt = 0;
var positionTab =  "document['dragLis'].positionTab();"
this.transIntervalId = window.setInterval(positionTab, 15);
}
TabCustomize.prototype.positionTab = function() {
if (this.transXPoints != null) {
if (this.transPosCnt < this.transXPoints.length - 1) {
this.oMoveTab.style.left = this.transXPoints[this.transPosCnt] + "px";
this.oMoveTab.style.top = this.transYPoints[this.transPosCnt] + "px";
this.transPosCnt = this.transPosCnt + Math.round(this.transPitStops);
} else {
this.transPosCnt = 0;
this.transXPoints = this.transYPoints = null;
window.clearInterval(this.transIntervalId);
this.oMoveTab.style.left = this.oMoveTab.style.top = "-1000px";
this.oCurrTab.style.visibility = "";
}
}
};
TabCustomize.prototype.drawPath = function(x1, y1, x2, y2) {
var dist = Math.sqrt((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1));
var dx = (x2 - x1) / dist;
var dy = (y2 - y1) / dist;
for (var i = 0; i < dist; i++) {
this.transXPoints[i] = x1 += dx;
this.transYPoints[i] = y1 += dy;
}
};
TabCustomize.prototype.findChild = function(oParent, tagName) {
if (oParent != null && typeof oParent.childNodes != "undefined") {
var oChild = new Array();
for (var i = 0, k = 0; i < oParent.childNodes.length; i++) {
if (browser_ie) {
if (oParent.childNodes[i].tagName == tagName) {
oChild[k] = oParent.childNodes[i];
k++;
}
} else if (browser_nn4 || browser_nn6) {
if (oParent.childNodes.item(i).tagName == tagName) {
oChild[k] = oParent.childNodes[i];
k++;
}
}
}
return oChild;
}
};
TabCustomize.prototype.save = function() {
this.oTR = this.oTable.rows;
result = "<?xml version='1.0' encoding='iso-8859-1'?>\\n  <tabs>\\n";
for (var i = 0; i < this.oTR.length; i++) {
var id =  this.oTR[i].getAttribute('id');
var state =  this.oTR[i].getAttribute('state');
var edit =  this.oTR[i].getAttribute('edit');
var type =  this.oTR[i].getAttribute('type');
var value = this.findChild( this.oTR[i], "TD")[1].innerHTML;
result += "    <tab id = '" + id + "' state = '" + state + "' edit = '" + edit + "' type = '" + type + "'>" + value + "</tab>\\n";
}
result += "  </tabs>";
executeFunctionAsString(this.saveFunc,window,result);
};
function addTab() {
var tableStr = "<table id=_ADD_TAB_DIALOG><tr><td><input type=text name=_ADD_TAB id=_ADD_TAB>&nbsp;<input type=button value=Save onclick='createTab(getObj(\"_ADD_TAB\").value)'></td></tr></table>";
showDialog(tableStr, 'title=Add Tab, position=relative');
getObj("_ADD_TAB").focus();
getObj("_ADD_TAB").focus();
getObj("_ADD_TAB").onkeypress = function(ev) {
if (browser_ie) var keyCode = window.event.keyCode;
else if (browser_nn4 || browser_nn6) var keyCode = ev.which;
if (keyCode == 13) {
createTab(getObj("_ADD_TAB").value);
document.body.focus();
}
}
}
function createTab(tabValue) {
closeDialog();
}
function customizeTab(url) {
MickeyTab = new TabCustomize(url, 'title=Customize Tab, position=relative', 'updateTab');
}
function updateTab(result) {
closeDialog();
}
