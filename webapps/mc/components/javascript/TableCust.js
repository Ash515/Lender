TableCustomize = function(layoutAreaId, saveFunc) {
this.layoutAreaId = layoutAreaId;
this.saveFunc = saveFunc;
var oTBODY = this.findChild(getObj(layoutAreaId), "TBODY")
var oTR = this.findChild(oTBODY[0], "TR")[0];
this.layoutArea = this.findChild(oTR, "TD")[0];
this.oMoveLayer = document.createElement("DIV");
this.oMoveLayer.style.cursor = "move";
this.oMoveLayer.style.zIndex = "100";
this.oHiliteLayer = document.createElement("DIV");
this.oHiliteLayer.style.border = "1px dashed #F00";
this.oHiliteLayer.style.zIndex = "99";
this.oMoveLayer.style.position = this.oHiliteLayer.style.position = "absolute";	
this.oMoveLayer.style.left = this.oHiliteLayer.style.left = "-1000px";
this.oMoveLayer.style.top = this.oHiliteLayer.style.top = "-1000px";	
document.body.appendChild(this.oMoveLayer);
document.body.appendChild(this.oHiliteLayer);
var oTR = new Array();
var oTD = new Array();
var oDIV = new Array();
var oDragEl = new Array();
var oRows = new Array();
oRows = this.findChild(this.layoutArea, "DIV");
for (var i = 0; i < oRows.length; i++) {
oTR = this.getTR(oRows[i]);
oTD[i] = this.findChild(oTR, "TD");
for (var j = 0; j < oTD[i].length; j++) {
oTD[i][j].width = (100 / oTD[i].length) + "%";
oTD[i][j].className += " tableColumn";
oDIV = this.findChild(oTD[i][j], "DIV");
for (var k = 0; k < oDIV.length; k++) {
oDIV[k].className += " tableItem";
}
}
}
this.splitLayers(false); 
};
TableCustomize.prototype.regEventByAttrib = function(elType, customAttrib) {
var oTD = this.layoutArea.getElementsByTagName(elType);
for (var k = 0; k < oTD.length; k++) {
if (oTD[k].getAttribute(customAttrib) != null || oTD[k].getAttribute(customAttrib) != "") {
this.registerEventForEl(oTD[k]);
}
}
};
TableCustomize.prototype.regEventByClass = function(elType, className) {
var oTD = this.layoutArea.getElementsByTagName(elType);
for (var k = 0; k < oTD.length; k++) {
if (oTD[k].className != null && (oTD[k].className.indexOf(className) > -1)) {
this.registerEventForEl(oTD[k]);
}
}
};
TableCustomize.prototype.registerEventForEl = function(elToReg) {
elToReg["dragLis"] = this;
elToReg.onmousedown = function(ev) {
this["dragLis"].captureLayer(ev);
};
elToReg.style.cursor="move";
};
TableCustomize.prototype.captureLayer = function(ev) {
if (browser_ie) srcElement = window.event.srcElement;
else if (browser_nn4 || browser_nn6) srcElement = ev.target;
if (typeof srcElement != "undefined" && srcElement != null) {
var prevEl = srcElement.parentNode;
var pathEl = new Array();
cnt = 0;
while (prevEl) {
if (prevEl == this.layoutArea) {
this.oCurrRow = pathEl[cnt - 1];
this.oCurrLayer = pathEl[cnt - 6];
break;
}
pathEl[cnt] = prevEl;
prevEl = prevEl.parentNode;
cnt++;
}
var oCurrTD = this.oCurrLayer.parentNode;
var oTDs = this.findChild(oCurrTD.parentNode, "TD");
for (var i = 0; i < oTDs.length; i++) {
if (oTDs[i] == oCurrTD) {
this.currColNum = i;
break;
}
}
if (oTDs.length == 1) this.splitLayers(true);
else this.mergeLayers();
this.oMoveLayer.style.width = this.oCurrLayer.offsetWidth;
this.oMoveLayer.style.height = this.oCurrLayer.offsetHeight;
this.oMoveLayer.style.left = findPosX(this.oCurrLayer) + "px";
this.oMoveLayer.style.top = findPosY(this.oCurrLayer) + "px";
this.oMoveLayer.innerHTML = this.oCurrLayer.innerHTML;
this.showHiliteLayer(this.oCurrLayer);
this.oCurrLayer.style.visibility = "hidden";
this.moveObj = "";
if (browser_ie) {
this.diffLeft = window.event.clientX + document.body.scrollLeft - parseInt(this.oMoveLayer.style.left);
this.diffTop = window.event.clientY + document.body.scrollTop - parseInt(this.oMoveLayer.style.top);
} else if (browser_nn4 || browser_nn6) {
this.diffLeft = ev.pageX - parseInt(this.oMoveLayer.style.left);
this.diffTop = ev.pageY - parseInt(this.oMoveLayer.style.top);
}
document["dragLis"] = this;
document.onmousemove = function(ev) {
document["dragLis"].moveLayer(ev);
};
document.onmouseup = function(ev) {
document["dragLis"].releaseLayer(ev);
};
this.scrollEnd = document.body.scrollHeight - document.body.offsetHeight;
}
};
TableCustomize.prototype.moveLayer = function(ev) {
clearTextSelection();
if (browser_ie) {
if (window.event.clientY + window.screenTop + 50 >= window.screen.height - 50) {
if ((document.body.scrollTop + 20) < this.scrollEnd)
document.body.scrollTop += 20;
} else if (window.event.clientY <= 50) {
document.body.scrollTop -= 20;		
}
var currLeft = (window.event.clientX - this.diffLeft) + document.body.scrollLeft;
var currTop = (window.event.clientY - this.diffTop) + document.body.scrollTop;
} else if (browser_nn4 || browser_nn6) {
var currLeft = (ev.pageX - this.diffLeft);
var currTop = (ev.pageY - this.diffTop);
}
this.oMoveLayer.style.left = currLeft + "px";
this.oMoveLayer.style.top = currTop + "px";
var layerMidX = parseInt(currLeft + (parseInt(this.oMoveLayer.style.width) / 2));
var layerMidY = parseInt(currTop + (parseInt(this.oMoveLayer.style.height) / 2));
oCurrColumn = this.oCurrLayer.parentNode;
oCurrTR = oCurrColumn.parentNode;
this.currColCnt = this.findChild(oCurrTR, "TD").length;
oRows = new Array();
oRows = this.findChild(this.layoutArea, "DIV");
var totalRows = oRows.length;
for (var i = 0; i < totalRows; i++) {
if (layerMidX >= findPosX(oRows[i]) && layerMidX <= (findPosX(oRows[i]) + oRows[i].offsetWidth)) {
if (layerMidY >= findPosY(oRows[i]) && layerMidY <= (findPosY(oRows[i]) + oRows[i].offsetHeight)) {
var oHoverRow = oRows[i];
break;
}
}
}
if (typeof oHoverRow == "undefined" || oHoverRow == null) oHoverRow = this.oCurrRow;
var oHoverTR = this.getTR(oHoverRow);
this.oColumns = new Array();
this.oColumns = this.findChild(oHoverTR, "TD");
if (i > oRows.length) {
if (this.currColCnt == 1) this.moveObj = "endofsection";
} else if (i == oRows.length) {
this.moveObj = "endofsection";
} else {
if (this.oColumns.length == this.currColCnt) {
this.moveObj = "layer";
} else {
if (this.currColCnt != 1) {
var oNextRow = oRows[i - 1];
if (typeof oNextRow != "undefined" && oNextRow != null) {
var oNextTR = this.getTR(oNextRow);
var nextColLen = this.findChild(oNextTR, "TD").length
if (nextColLen == this.currColCnt) {
this.moveObj = "layer";
oHoverRow = oNextRow;
oHoverTR = this.getTR(oHoverRow);			
this.oColumns = new Array();
this.oColumns = this.findChild(oHoverTR, "TD");
} else {
this.moveObj = "section";
}
} else {
this.moveObj = "section";
}
} else {
this.moveObj = "section";
}
}
}
for (var j = 0; j < this.oColumns.length; j++) {
if (layerMidX >= findPosX(this.oColumns[j]) && layerMidX <= (findPosX(this.oColumns[j]) + this.oColumns[j].offsetWidth)) {
var oHoverColumn = this.oColumns[j];
break;
}
}
if (oHoverColumn != null && typeof oHoverColumn != "undefined") {
var oLayers = new Array();
oLayers = this.findChild(oHoverColumn, "DIV");
for (var k = 0; k < oLayers.length; k++) {
if (currTop <= findPosY(oLayers[k]) + 20) {
var oHoverLayer = oLayers[k];
break;
}
}
if (this.moveObj == "layer" && this.currColCnt != 1) {
var oNewLayer = this.oCurrLayer;
if (oHoverLayer) oHoverLayer.parentNode.insertBefore(this.oCurrLayer, oHoverLayer);
else oHoverColumn.appendChild(this.oCurrLayer);
var layersFound = this.isRowToBeRemoved(oCurrTR);
if (!layersFound) this.layoutArea.removeChild(this.oCurrRow);
this.oCurrLayer = oNewLayer;
this.showHiliteLayer(oNewLayer);
} else {
var oNewRow = document.createElement("DIV");
var width = 100 / this.currColCnt;
var newHTML = "<table border='0' width='100%' cellspacing='0' cellpadding='0'><tr>";
for (var l = 0; l < this.currColCnt; l++) {
if (l == this.currColNum) var placeHolderCol = l;
newHTML += "<td class='tableColumn' width = '" + parseInt(width) + "%'></td>";
}
newHTML += "</tr></table>";
oNewRow.innerHTML = newHTML;
this.createAttributes(this.oCurrRow, oNewRow);
if (this.moveObj == "endofsection") this.layoutArea.appendChild(oNewRow);
else this.layoutArea.insertBefore(oNewRow, oHoverRow);
oNewLayer = this.oCurrLayer;
var oNewHoverTR = this.getTR(oNewRow);
var oNewCols = this.findChild(oNewHoverTR, "TD");
for (var o = 0; o < oNewCols.length; o++) {
if (o == parseInt(placeHolderCol)) {
oNewCols[placeHolderCol].appendChild(this.oCurrLayer);
}
}
var layersFound = this.isRowToBeRemoved(oCurrTR);
if (!layersFound) this.layoutArea.removeChild(this.oCurrRow);
this.oCurrLayer = oNewLayer;
this.oCurrRow = oNewRow;
this.showHiliteLayer(oNewLayer);
}
}
};
TableCustomize.prototype.releaseLayer = function() {
document.onmousemove = null;
document.onmouseup = null;
this.transXPoints = new Array();
this.transYPoints = new Array();
this.drawPath(parseInt(this.oMoveLayer.style.left), parseInt(this.oMoveLayer.style.top), findPosX(this.oCurrLayer), findPosY(this.oCurrLayer));
this.transPitStops = (this.transXPoints.length > 10) ? (this.transXPoints.length - 1) / 10 : 1; 
this.transPosCnt = 0;
var positionLayer =  "document['dragLis'].positionLayer();"
this.transIntervalId = window.setInterval(positionLayer, 10);
}
TableCustomize.prototype.positionLayer = function() {
if (this.transPosCnt < this.transXPoints.length - 1) {
this.oMoveLayer.style.left = this.transXPoints[this.transPosCnt] + "px";
this.oMoveLayer.style.top = this.transYPoints[this.transPosCnt] + "px";
this.transPosCnt = this.transPosCnt + Math.round(this.transPitStops);
} else {
this.resetLayers();
this.transPosCnt = 0;
this.transXPoints = this.transYPoints = null;
window.clearInterval(this.transIntervalId);
}
};
TableCustomize.prototype.resetLayers = function() {
this.oMoveLayer.style.left = this.oMoveLayer.style.top = "-1000px";
this.oHiliteLayer.style.left = this.oHiliteLayer.style.top = "-1000px";
this.oCurrRow.style.visibility = "";
this.oCurrLayer.style.visibility = "";
this.moveObj = "";
this.mergeLayers();
this.save();
this.splitLayers(false); 
}
TableCustomize.prototype.splitLayers = function(isNotFineTuning) {
var oTR = new Array();
var oTD = new Array();
var rowCreated;
oRows = new	Array();
oRows = this.findChild(this.layoutArea, "DIV");
for (var i = oRows.length - 1; i >= 0; i--) {
var oTR = this.getTR(oRows[i]);
oTD[i] = this.findChild(oTR, "TD");
if (oTD[i].length > 1) {
oSplitLayers = new Array();
oSplitLayers[0] = new Array();
rowCreated = false;
var oFirstColLayers = this.findChild(oTD[i][0], "DIV");
for (var k = oFirstColLayers.length - 1, c1 = 0; k > 0; k--) {
oSplitLayers[0][c1] = oFirstColLayers[k];
j = 1;
oSplitLayers[j] = new Array();
var createRow = false;
var oOtherColLayers = this.findChild(oTD[i][j], "DIV");
if (oOtherColLayers.length > 0) {
for (var l = oOtherColLayers.length - 1, c2 = 0; l >= 0 ; l--, c2++) {
oSplitLayers[j][c2] = oOtherColLayers[l];
var y1 = findPosY(oFirstColLayers[k]);
var y2 = findPosY(oOtherColLayers[l]);
if (l == oOtherColLayers.length - 1) {
if ((y2 + oOtherColLayers[l].offsetHeight - 20) < y1) {
if (j != oTD[i].length - 1) {
j++;
c2 = 0;
oSplitLayers[j] = new Array();
oOtherColLayers = this.findChild(oTD[i][j], "DIV");
continue;
} else {
oSplitLayers[j] = new Array();
createRow = true;
}
}
}
if (l != 0) {
var diff = ((y2 - y1) < 0) ? ((y2 - y1) * -1) : (y2 - y1);
if (diff <= 20) {
if (j == oTD[i].length - 1) {
createRow = true;
} else {
j++;
c2 = 0;
oSplitLayers[j] = new Array();
oOtherColLayers = this.findChild(oTD[i][j], "DIV");
continue;
}
}
}
if (createRow) {
var oNewRow = document.createElement("DIV");
var width = 100 / oTD[i].length;
var newHTML = "<table border='0' width='100%' cellspacing='0' cellpadding='0'><tr>";
for (var m = 0; m < oTD[i].length; m++) {
newHTML += "<td class='tableColumn' width = '" + parseInt(width) + "%'></td>";
}
newHTML += "</tr></table>";
oNewRow.innerHTML = newHTML;
var oNewTABLE = this.findChild(oNewRow, "TABLE"); 
var oNewTBODY = this.findChild(oNewTABLE[0], "TBODY");
var oNewTR = this.findChild(oNewTBODY[0], "TR");
var oNewTD = this.findChild(oNewTR[0], "TD");
var newLayers = "";
for (var n = 0; n < oNewTD.length; n++) {
for (var o = oSplitLayers[n].length - 1; o >= 0; o--) {
oNewTD[n].appendChild(oSplitLayers[n][o]);
}
}
oNewRows = new Array();
oNewRows = this.findChild(this.layoutArea, "DIV");
if (typeof oNewRows[i + 1] == "undefined") this.layoutArea.appendChild(oNewRow);
else this.layoutArea.insertBefore(oNewRow, oNewRows[i + 1]);
rowCreated = true;
break;
}
}
if (rowCreated == true) {
c1 = 0;
var oFirstColLayers = this.findChild(oTD[i][0], "DIV");
oSplitLayers[0] = new Array();
rowCreated = false;
} else {
c1++;
}
} else {
var oNewRow = document.createElement("DIV");
var width = 100 / oTD[i].length;
var newHTML = "<table border='0' width='100%' cellspacing='0' cellpadding='0'><tr>";
for (var m = 0; m < oTD[i].length; m++) {
newHTML += "<td class='tableColumn' width = '" + parseInt(width) + "%'></td>";
}
newHTML += "</tr></table>";
oNewRow.innerHTML = newHTML;
var oNewTABLE = this.findChild(oNewRow, "TABLE"); 
var oNewTBODY = this.findChild(oNewTABLE[0], "TBODY");
var oNewTR = this.findChild(oNewTBODY[0], "TR");
var oNewTD = this.findChild(oNewTR[0], "TD");
var newLayers = "";
for (var n = 0; n < oNewTD.length; n++) {
if (oSplitLayers[n].length > 0) {
for (var o = oSplitLayers[n].length - 1; o >= 0; o--) {
oNewTD[n].appendChild(oSplitLayers[n][o]);
}
}
}
oNewRows = new Array();
oNewRows = this.findChild(this.layoutArea, "DIV");
if (typeof oNewRows[i + 1] == "undefined") this.layoutArea.appendChild(oNewRow);
else this.layoutArea.insertBefore(oNewRow, oNewRows[i + 1]);
}
}
}
}
if (isNotFineTuning) {
oRows = new	Array();
oRows = this.findChild(this.layoutArea, "DIV");
for (var i = oRows.length - 1; i >= 0; i--) {
var oTR = this.getTR(oRows[i]);
oTD[i] = this.findChild(oTR, "TD");
if (oTD[i].length > 1) {
oSplitLayers = new Array();
oSplitLayers[oTD[i].length - 1] = new Array();
rowCreated = false;
var oLastColLayers = this.findChild(oTD[i][oTD[i].length - 1], "DIV");
for (var k = oLastColLayers.length - 1, c1 = 0; k > 0; k--) {
oSplitLayers[oTD[i].length - 1][c1] = oLastColLayers[k];
j = oTD[i].length - 2;
oSplitLayers[j] = new Array();
var createRow = false;
var oOtherColLayers = this.findChild(oTD[i][j], "DIV");
if (oOtherColLayers.length > 0) {
for (var l = oOtherColLayers.length - 1, c2 = 0; l >= 0 ; l--, c2++) {
oSplitLayers[j][c2] = oOtherColLayers[l];
var y1 = findPosY(oLastColLayers[k]);
var y2 = findPosY(oOtherColLayers[l]);
if (l == oOtherColLayers.length - 1) {
if ((y2 + oOtherColLayers[l].offsetHeight - 20) < y1) {
if (j != 0) {
j--;
c2 = 0;
oSplitLayers[j] = new Array();
oOtherColLayers = this.findChild(oTD[i][j], "DIV");
continue;
} else {
oSplitLayers[j] = new Array();
createRow = true;
}
}
}
if (l != 0) {
var diff = ((y2 - y1) < 0) ? ((y2 - y1) * -1) : (y2 - y1);
if (diff <= 20) {
if (j == 0) {
createRow = true;
} else {
j--;
c2 = 0;
oSplitLayers[j] = new Array();
oOtherColLayers = this.findChild(oTD[i][j], "DIV");
continue;
}
}
}
if (createRow) {
var oNewRow = document.createElement("DIV");
var width = 100 / oTD[i].length;
var newHTML = "<table border='0' width='100%' cellspacing='0' cellpadding='0'><tr>";
for (var m = 0; m < oTD[i].length; m++) {
newHTML += "<td class='tableColumn' width = '" + parseInt(width) + "%'></td>";
}
newHTML += "</tr></table>";
oNewRow.innerHTML = newHTML;
var oNewTABLE = this.findChild(oNewRow, "TABLE"); 
var oNewTBODY = this.findChild(oNewTABLE[0], "TBODY");
var oNewTR = this.findChild(oNewTBODY[0], "TR");
var oNewTD = this.findChild(oNewTR[0], "TD");
var newLayers = "";
for (var n = 0; n < oNewTD.length; n++) {
for (var o = oSplitLayers[n].length - 1; o >= 0; o--) {
oNewTD[n].appendChild(oSplitLayers[n][o]);
}
}
oNewRows = new Array();
oNewRows = this.findChild(this.layoutArea, "DIV");
if (typeof oNewRows[i + 1] == "undefined") this.layoutArea.appendChild(oNewRow);
else this.layoutArea.insertBefore(oNewRow, oNewRows[i + 1]);
rowCreated = true;
break;
}
}
if (rowCreated == true) {
c1 = 0;
var oLastColLayers = this.findChild(oTD[i][oTD[i].length - 1], "DIV");
oSplitLayers[oTD[i].length - 1] = new Array();
rowCreated = false;
} else {
c1++;
}
} else {
var oNewRow = document.createElement("DIV");
var width = 100 / oTD[i].length;
var newHTML = "<table border='0' width='100%' cellspacing='0' cellpadding='0'><tr>";
for (var m = 0; m < oTD[i].length; m++) {
newHTML += "<td class='tableColumn' width = '" + parseInt(width) + "%'></td>";
}
newHTML += "</tr></table>";
oNewRow.innerHTML = newHTML;
var oNewTABLE = this.findChild(oNewRow, "TABLE"); 
var oNewTBODY = this.findChild(oNewTABLE[0], "TBODY");
var oNewTR = this.findChild(oNewTBODY[0], "TR");
var oNewTD = this.findChild(oNewTR[0], "TD");
var newLayers = "";
for (var n = 0; n < oNewTD.length; n++) {
if (oSplitLayers[n].length > 0) {
for (var o = oSplitLayers[n].length - 1; o >= 0; o--) {
oNewTD[n].appendChild(oSplitLayers[n][o]);
}
}
}
oNewRows = new Array();
oNewRows = this.findChild(this.layoutArea, "DIV");
if (typeof oNewRows[i + 1] == "undefined") this.layoutArea.appendChild(oNewRow);
else this.layoutArea.insertBefore(oNewRow, oNewRows[i + 1]);
}
}
}
}
}
}
TableCustomize.prototype.mergeLayers = function() {
var oRows = new Array();
var oTD = new Array();
oRows = this.findChild(this.layoutArea, "DIV");
for (var i = 0; i < oRows.length;) {
var oTR = this.getTR(oRows[i]);
oTD[i] = this.findChild(oTR, "TD");
if (i > 0 && (oTD[i].length > 1 && (oTD[i].length == oTD[i - 1].length))) {
for (var j = 0; j < oTD[i].length; j++) {
var oDIV = this.findChild(oTD[i][j], "DIV");
for (var k = 0; k < oDIV.length; k++) {
oTD[i - 1][j].appendChild(oDIV[k]);	
}
}
this.layoutArea.removeChild(oRows[i]);
oRows = this.findChild(this.layoutArea, "DIV");
} else {
i++;
}
}
}
TableCustomize.prototype.showHiliteLayer = function(oLayer) {
this.oHiliteLayer.style.width = oLayer.offsetWidth;
this.oHiliteLayer.style.height = oLayer.offsetHeight;
this.oHiliteLayer.style.left = findPosX(oLayer) + "px";
this.oHiliteLayer.style.top = findPosY(oLayer) + "px";
};
TableCustomize.prototype.drawPath = function(x1, y1, x2, y2) {
var dist = Math.sqrt((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1));
var dx = (x2 - x1) / dist;
var dy = (y2 - y1) / dist;
for (var i = 0; i < dist; i++) {
this.transXPoints[i] = x1 += dx;
this.transYPoints[i] = y1 += dy;
}
};
TableCustomize.prototype.findChild = function(oParent, tagName) {
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
TableCustomize.prototype.getTR = function(oLayer) {
if (browser_nn4 || browser_nn6 || browser_opera) {
oTABLE = new Array();
oTBODY = new Array();
oTR = new Array();
oTABLE = this.findChild(oLayer, "TABLE");
oTBODY = this.findChild(oTABLE[0], "TBODY");
oTR = this.findChild(oTBODY[0], "TR");
return oTR[0];
} else if (browser_ie) {
return oLayer.childNodes[0].childNodes[0].childNodes[0];
}
};
TableCustomize.prototype.isRowToBeRemoved = function(oCurrRow) {
var layersFound = false;
var oTDs = this.findChild(oCurrRow, "TD");
for (var i = 0; i < oTDs.length; i++) {
var oLayers = this.findChild(oTDs[i], "DIV");
if (oLayers.length > 0) {
layersFound = true;
break;
}
}
return layersFound;
}
TableCustomize.prototype.createAttributes = function(oFromObj, oToObj) {
for (var i = 0; i < oFromObj.attributes.length; i++) {
var attribName = oFromObj.attributes[i].nodeName;
var attribValue = oFromObj.attributes[i].nodeValue;
if (attribValue != null && attribValue != false && attribValue != "inherit") {
if (attribName == "class") {
if (browser_ie)	oToObj.setAttribute("className", attribValue);
else if (browser_nn4 || browser_nn6) oToObj.setAttribute(attribName, attribValue);
} else {
oToObj.setAttribute(attribName, attribValue);
}
}
}
};
TableCustomize.prototype.save = function() {
var oTR = new Array();
var oTD = new Array();
var oRows = this.findChild(this.layoutArea, "DIV");
var result = ""
for (var i = 0; i < oRows.length; i++) {
var oTR = this.getTR(oRows[i]);
oTD[i] = this.findChild(oTR, "TD");
result += "___" + oTD[i].length;
for (var j = 0; j < oTD[i].length; j++) {
result += "__";
var oLayer = this.findChild(oTD[i][j], "DIV");
for (var k = 0; k < oLayer.length; k++) {
result += oLayer[k].id;
if (k != oLayer.length - 1) result += "_"
}
}
}
executeFunctionAsString(this.saveFunc,window,result);
}
