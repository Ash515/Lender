GridCustomize = function(layoutAreaId, saveFunc) {
this.layoutAreaId = layoutAreaId;
this.layoutArea = getObj(layoutAreaId).rows[0];
this.saveFunc = saveFunc;
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
this.oColumns = new Array();
this.oColumns = this.findChild(this.layoutArea, "TD");
for (var i = 0; i < this.oColumns.length; i++) {
this.oColumns[i].width = (100 / this.oColumns.length) + "%";
this.oColumns[i].className += " gridColumn";
var oDIV = this.findChild(this.oColumns[i], "DIV");
for (var j = 0; j < oDIV.length; j++) {
oDIV[j].className += " gridItem";
}
}
};
GridCustomize.prototype.regEventByAttrib = function(elType, customAttrib) {
var oTD = this.layoutArea.getElementsByTagName(elType);
for (var k = 0; k < oTD.length; k++) {
if (oTD[k].getAttribute(customAttrib) != null || oTD[k].getAttribute(customAttrib) != "") {
this.registerEventForEl(oTD[k]);
}
}
};
GridCustomize.prototype.regEventByClass = function(elType, className) {
var oTD = this.layoutArea.getElementsByTagName(elType);
for (var k = 0; k < oTD.length; k++) {
if (oTD[k].className != null && (oTD[k].className.indexOf(className) > -1)) {
this.registerEventForEl(oTD[k]);
}
}
};
GridCustomize.prototype.registerEventForEl = function(elToReg) {
elToReg["dragLis"] = this;
elToReg.onmousedown = function(ev) {
this["dragLis"].captureLayer(ev);
};
elToReg.style.cursor="move";
};
GridCustomize.prototype.captureLayer = function(ev) {
if (browser_ie) srcElement = window.event.srcElement;
else if (browser_nn4 || browser_nn6) srcElement = ev.target;
if (typeof srcElement != "undefined" && srcElement != null) {
var prevEl = srcElement.parentNode;
var pathEl = new Array();
cnt = 0;
while (prevEl) {
if (prevEl == this.layoutArea) {
this.oCurrLayer = pathEl[cnt - 2];
break;
}
pathEl[cnt] = prevEl;
prevEl = prevEl.parentNode;
cnt++;
}
this.oMoveLayer.style.width = this.oCurrLayer.offsetWidth;
this.oMoveLayer.style.height = this.oCurrLayer.offsetHeight;
this.oMoveLayer.style.left = findPosX(this.oCurrLayer) + "px";
this.oMoveLayer.style.top = findPosY(this.oCurrLayer) + "px";
this.oMoveLayer.innerHTML = this.oCurrLayer.innerHTML;
this.showHiliteLayer(this.oCurrLayer);
this.oCurrLayer.style.visibility = "hidden";
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
}
};
GridCustomize.prototype.moveLayer = function(ev) {
clearTextSelection();
if (browser_ie) {
if (window.event.clientY + window.screenTop + 50 >= window.screen.height - 50) document.body.scrollTop += 20;
else if (window.event.clientY <= 50) document.body.scrollTop -= 20;		
var currLeft = (window.event.clientX - this.diffLeft) + document.body.scrollLeft;
var currTop = (window.event.clientY - this.diffTop) + document.body.scrollTop;
} else if (browser_nn4 || browser_nn6) {
var currLeft = (ev.pageX - this.diffLeft);
var currTop = (ev.pageY - this.diffTop);
}
this.oMoveLayer.style.left = currLeft + "px";
this.oMoveLayer.style.top = currTop + "px";
var layerMidX = currLeft + (parseInt(this.oMoveLayer.style.width) / 2);
var layerMidY = currTop + (parseInt(this.oMoveLayer.style.height) / 2);
for (var i = 0; i < this.oColumns.length; i++) {
if (layerMidX >= findPosX(this.oColumns[i]) && layerMidX <= (findPosX(this.oColumns[i]) + this.oColumns[i].offsetWidth)) {
var oHoverColumn = this.oColumns[i];
break;
}
}
if (oHoverColumn != null && typeof oHoverColumn != "undefined") {
var oLayers = new Array();
oLayers = this.findChild(oHoverColumn, "DIV");
for (var j = 0; j < oLayers.length; j++) {
if (currTop <= findPosY(oLayers[j])) {
var oHoverLayer = oLayers[j];
break;
}
}
oNewLayer = this.oCurrLayer;
if (oHoverLayer) oHoverLayer.parentNode.insertBefore(this.oCurrLayer, oHoverLayer);
else oHoverColumn.appendChild(this.oCurrLayer);
this.oCurrLayer = oNewLayer;
this.showHiliteLayer(oNewLayer);
}
};
GridCustomize.prototype.releaseLayer = function() {
document.onmousemove = null;
document.onmouseup = null;
this.transXPoints = new Array();
this.transYPoints = new Array();
this.drawPath(parseInt(this.oMoveLayer.style.left), parseInt(this.oMoveLayer.style.top), findPosX(this.oCurrLayer), findPosY(this.oCurrLayer));
this.transPitStops = (this.transXPoints.length > 10) ? (this.transXPoints.length - 1) / 10 : 1; 
this.transPosCnt = 0;
var positionLayer =  "document['dragLis'].positionLayer();"
this.transIntervalId = window.setInterval(positionLayer, 15);
}
GridCustomize.prototype.positionLayer = function() {
if (this.transPosCnt < this.transXPoints.length - 1) {
this.oMoveLayer.style.left = this.transXPoints[this.transPosCnt] + "px";
this.oMoveLayer.style.top = this.transYPoints[this.transPosCnt] + "px";
this.transPosCnt = this.transPosCnt + Math.round(this.transPitStops);
} else {
this.transPosCnt = 0;
this.transXPoints = this.transYPoints = null;
window.clearInterval(this.transIntervalId);
this.oMoveLayer.style.left = this.oMoveLayer.style.top = "-1000px";
this.oHiliteLayer.style.left = this.oHiliteLayer.style.top = "-1000px";
this.oCurrLayer.style.visibility = "";
parent[this["saveFunc"]](this);
}
};
GridCustomize.prototype.showHiliteLayer = function(oLayer) {
this.oHiliteLayer.style.width = oLayer.offsetWidth;
this.oHiliteLayer.style.height = oLayer.offsetHeight;
this.oHiliteLayer.style.left = findPosX(oLayer) + "px";
this.oHiliteLayer.style.top = findPosY(oLayer) + "px";
};
GridCustomize.prototype.drawPath = function(x1, y1, x2, y2) {
var dist = Math.sqrt((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1));
var dx = (x2 - x1) / dist;
var dy = (y2 - y1) / dist;
for (var i = 0; i < dist; i++) {
this.transXPoints[i] = x1 += dx;
this.transYPoints[i] = y1 += dy;
}
};
GridCustomize.prototype.findChild = function(oParent, tagName) {
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
GridCustomize.prototype.getCurrentOrderAsString = function() {
var result = "";
for (var i = 0; i < this.oColumns.length; i++) {
var oDIV = this.findChild(this.oColumns[i], "DIV");
result += "__";
for (var j = 0; j < oDIV.length; j++) {
result += oDIV[j].id;
if (j != oDIV.length - 1) result += "_"
}
}	
return result;
}
GridCustomize.prototype.getCurrentOrderAsMatrix = function(attrib) {
var result = new Array();
for (var i = 0; i < this.oColumns.length; i++) {
result[i] = new Array();
var oDIV = this.findChild(this.oColumns[i], "DIV");
for (var j = 0; j < oDIV.length; j++) {
result[i][j] = oDIV[j].getAttribute(attrib);
}
}	
return result;
}
function enableDAndDForGrid(uniqueId)
{
var gc = new GridCustomize(uniqueId + "_TABLE","saveDandDResultForGrid");
gc.regEventByClass("td","boxHeader");
gc["uniqueId"] = uniqueId;
}
function saveDandDResultForGrid(cusObj)
{
var childMat = cusObj.getCurrentOrderAsMatrix("childView");
updateState(cusObj["uniqueId"],"GDLIST",childMat[0],true);
}
