Effect = function() { 
};
Effect.init = function(params) {
if (typeof params != "undefined") {
this.type = (typeof params.type != "undefined") ? params.type : "boxIn( { } )";
this.speed = (typeof params.speed != "undefined") ? params.speed : 10;
this.layer = document.getElementById(params.layerId);
this.layerId = params.layerId;
this.layerLeft = params.layerLeft;
this.layerTop = params.layerTop;
if (typeof params.layerContent == "undefined" || params.layerContent == null || params.layerContent == "") this.layerContent = this.layer.innerHTML;
else this.layerContent = params.layerContent;
if (typeof params.layerWidth == "undefined" || params.layerWidth == null || params.layerWidth == "") this.layerWidth = this.layer.offsetWidth;
else this.layerWidth = params.layerWidth;
if (typeof params.layerHeight == "undefined" || params.layerHeight == null || params.layerHeight == "")	this.layerHeight = this.layer.offsetHeight;
else this.layerHeight = params.layerHeight;
} else {
this.speed = 10;
}
};
var xPoint, yPoint;
Effect.drawPath = function(x1, y1, x2, y2) {
xPoint = new Array();
yPoint = new Array();
var dist = Math.sqrt((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1));
var dx = (x2 - x1) / dist;
var dy = (y2 - y1) / dist;
for (var i = 0; i < dist; i++) {
xPoint[i] = x1 += dx;
yPoint[i] = y1 += dy;
}
};
var wArray, hArray;
Effect.buildSize = function() {
wArray = new Array();
hArray = new Array();
var dimRatio = this.layerHeight / this.layerWidth;
for (var i = 0, j = 0; i <= this.layerWidth; i += 1, j++) {
wArray[j] = i;
hArray[j] = i * dimRatio;
}
};
var pitStops = 0, dim = 0, movCnt = 0, dimCnt = 0, effectIntvl;
Effect.display = function() {
var midX = this.layerLeft + parseInt(this.layerWidth / 2);
var midY = this.layerTop + parseInt(this.layerHeight / 2);
this.layer.style.left = midX + "px"
this.layer.style.top = midY + "px"
this.layer.style.width = this.layer.style.height = "0px";
this.layer.style.overflow = "hidden";
this.drawPath(this.layerLeft, this.layerTop, midX, midY);
movCnt = xPoint.length - 1;
pitStops = (xPoint.length > 5) ? (xPoint.length - 1) / 5 : 1;
this.buildSize();	
dim = wArray.length / (movCnt / pitStops);
effectIntvl = setInterval(executeFunctionAsString("this."+this.type,window), this.speed);
};
Effect.boxIn = function() {
if (movCnt > 0) {
Effect.layer.style.left = xPoint[movCnt] + "px";
Effect.layer.style.top = yPoint[movCnt] + "px";
if (wArray[dimCnt]) {
Effect.layer.style.width = wArray[dimCnt] + "px";
Effect.layer.style.height = hArray[dimCnt] + "px";
}
movCnt -= Math.round(pitStops);
dimCnt += Math.round(dim);;
} else {
Effect.layer.style.left = Effect.layerLeft + "px";
Effect.layer.style.top = Effect.layerTop + "px";
Effect.layer.style.width = Effect.layerWidth + "px";
Effect.layer.style.height = Effect.layerHeight + "px";
Effect.layer.style.overflow = "";
pitStops = dim = movCnt = dimCnt = 0;
window.clearInterval(effectIntvl);		
}
};
