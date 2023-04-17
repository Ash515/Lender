var oDialog,oDialogMin, doc, srcEl, closeOnEscKey = true, closeOnBodyClick = false, iframeIEHack;
var dialogProperties = new Array("position", "top", "left", "height", "width", "srcElement", "modal", "draggable",
"title", "closeButton", "closeOnEscKey", "transitionType", "transitionInterval","closeOnBodyClick","dialogBoxType","closePrevious","overflow","minWidth","minHeight","fadeBackground","zAdjust","removemodal","focusId");
var temp = new Array(0);
var boxNo="";
var previousBox="";
var escapeDetails=new Array(0);
var freezeDetails=new Array(0);
var closeOnBodyClickDetails=new Array(0);
var SHADOW_DIALOG=false; 
function showDialog(contentCode, features, callBackFunc,dialogConfig, isAjaxCall) {
if (typeof(features) == "undefined") var features = "position=absmiddle";
features = features.split(",");
var featurePresent;
for (var i = 0; i < dialogProperties.length; i++) {
featurePresent = false;
for (var j = 0; j < features.length; j++) {
if (features[j].indexOf(dialogProperties[i]) >= 0) {
featurePresent = true;
break;
}
}
self["dialog_" + dialogProperties[i]] = (featurePresent) ? features[j].substr(features[j].indexOf("=") + 1, features[j].length).trim() : "undefined";
}
if(dialog_dialogBoxType!=null && dialog_dialogBoxType!="undefined")
{
dialogConfig=dialog_dialogBoxType;
}
var el=document.createElement("DIV");
el.innerHTML=contentCode;
var className=null;
var boxel=DOMUtils.getFirstChild(el,"id","TemplateDialog",null,null);
if(boxel!=null && boxel!="undefined")
{
className=boxel.className;
}
if(className!=null && className!="undefined")
{
dialogConfig="EmptyDialogBox";
}
if(dialog_closePrevious =="false")
{
if(boxNo=="")
{
boxNo="0";
}
else
{boxNo=(parseInt(boxNo)+ 1) + "";}
}
else
{
clearAllDialogs();
boxNo="0";
clearAllDialogs();
}
if (dialog_removemodal != "undefined" )
{
freezeDetails["Dialog"+boxNo]=dialog_removemodal;
}
else
{
freezeDetails["Dialog"+boxNo]="true";	
}
if (document.getElementById("_DIALOG_LAYER") == null || boxNo!="") {
oDialog = document.createElement("DIV");
oDialog.id = "_DIALOG_LAYER"+boxNo;
document.body.appendChild(oDialog);
} else {
oDialog = document.getElementById("_DIALOG_LAYER");
if(oDialog.firstChild != null){oDialog.removeChild(oDialog.firstChild);}
oDialog.innerHTML = "";
oDialog.style.left = "";
oDialog.style.top = "";
oDialog.style.width = "";
oDialog.style.height = "";
closeDialog();
}
var isHtmlEl = ((typeof contentCode) != "string")
var contId="__DIALOG_CONTENT"+boxNo;
if(dialog_zAdjust==null ||dialog_zAdjust=="undefined")
{
dialog_zAdjust="true";
}
if((!isHtmlEl) && (!(dialogConfig==null)))
{
contentCode = '<div id="'+contId+'" boxno="'+ boxNo +'" zAdjust="'+dialog_zAdjust+'">' + contentCode + '</div>';
}
else
{
if(!isHtmlEl)
{
var box = '<table class="DialogBox" border="0" cellspacing="0" cellpadding="0"><tr><td class="boxTL">&nbsp;</td>';
var bheadid =  boxNo;
if(bheadid == "")
{
bheadid = "0";
}
if (dialog_draggable != "undefined" && dialog_draggable == "no") box += '<td id="boxHeader_' + bheadid + '" class="boxHeader">';
else box += '<td id="boxHeader_' + bheadid + '" class="boxHeader drag" onMouseDown="captureDialog(event,this)">';
if (dialog_title != "undefined") {
if (dialog_title.charAt(0) == "'" && dialog_title.charAt(dialog_title.length - 1) == "'") 
{              
dialog_title = dialog_title.substr(1, dialog_title.length - 2);
if(findScriptTags(dialog_title))
{
throw new Error("SCRIPT tags not allowed in title attribute");
}
}
if (dialog_title.trim().length == 0) 
dialog_title = "&nbsp;";
} else dialog_title = "&nbsp;";
if(findScriptTags(dialog_title))
{
throw new Error("SCRIPT tags not allowed in title attribute");
}
box += dialog_title + '</td><td class="boxCtrlButtonPane">';
if (dialog_closeButton != "undefined" && dialog_closeButton == "no") box += '&nbsp;</td>';
else box += '<input type="button" class="closeButton" onClick="closeDialog(null,this)"></td>';
box += '<td class="boxTR">&nbsp;</td></tr><tr><td colspan="4" class="boxContent">' + contentCode + '</td></tr>';
box +='<tr><td class="boxBL"></td><td class="boxBC" colspan="2"></td><td class="boxBR"></td></tr>' +'</table>';
var showInBox = true;
if (dialog_closeButton != "undefined")
if (dialog_title == "&nbsp;" && dialog_closeButton == "no") showInBox = false;
if (showInBox) 
oDialog.innerHTML ="<table id='"+contId+"' cellpadding='0'" +" boxno='"+ boxNo + "' cellpadding='0' cellspacing='0'><tr><td height='100%' style='display:block'>" + box + "</td></tr></table>";	
else
oDialog.innerHTML = "<table id='"+contId+"' cellpadding='0'" +" boxno='"+ boxNo + "' cellspacing='0'><tr><td height='100%' style='display:block'>" + contentCode + "</td></tr></table>";	
}
else
{ 
oDialog.appendChild(contentCode);
oDialog.htmlEl = contentCode;
}
}
if(!(dialogConfig==null) && !isHtmlEl)
{
oDialog.innerHTML =("<table cellpadding='0' cellspacing='0'><tr><td height='100%'>" + contentCode + "</td></tr></table>");      
}  
oDialog.style.display = "block";
oDialog.style.position = "absolute";
oDialog.style.left = "-1000px";
oDialog.style.top = "-1000px";
if(boxNo=="")
{
oDialog.style.zIndex = 100+"";
}
else
{	
oDialog.style.zIndex = (100+(2*parseInt(boxNo)))+"";
}
if(!isHtmlEl && (isAjaxCall == null || !isAjaxCall))
{
var scriptTags = oDialog.getElementsByTagName("SCRIPT");
for (var i = 0; i < scriptTags.length; i++) {
var scriptTag = document.createElement("SCRIPT");
scriptTag.type = "text/javascript";
scriptTag.language = "javascript";
if (scriptTags[i].src != "") { scriptTag.src = scriptTags[i].src;}
scriptTag.text = scriptTags[i].text;
if (typeof document.getElementsByTagName("HEAD")[0] == "undefined") {
document.createElement("HEAD").appendChild(scriptTag)
} else {
document.getElementsByTagName("HEAD")[0].appendChild(scriptTag);
}			
}
}
if (browser_opera) {
var temp = contentCode;
var styleTags = oDialog.getElementsByTagName("STYLE");
for (var i = 0; i < styleTags.length; i++) {
styleTags[i].innerHTML = temp.substring(temp.indexOf("<style>") + 7, temp.indexOf("</style>") - 1);
temp = temp.substring(temp.indexOf("</style>") + 8, temp.length);
}
}
if (dialog_width != "undefined") {
if (browser_ie)	oDialog.childNodes[0].style.width = parseInt(dialog_width) + "px";
else if (browser_nn4 || browser_nn6) oDialog.childNodes.item(0).style.width = parseInt(dialog_width) + "px";
}
if (dialog_height != "undefined") {
if (browser_ie) oDialog.childNodes[0].style.height = parseInt(dialog_height) + "px";
else if (browser_nn4 || browser_nn6) oDialog.childNodes.item(0).style.height = parseInt(dialog_height) + "px";
}
var oDialogContent = (isHtmlEl)? contentCode:(document.getElementById("__DIALOG_CONTENT"+boxNo));
var left = 0, top = 0;
if (browser_opera) {
if (dialog_width != "undefined") {
oDialogContent.style.width = parseInt(dialog_width) + "px";
} else {
oDialogContent.style.width = oDialogContent.offsetWidth + "px";
oDialog.style.width = oDialogContent.offsetWidth + "px";
}
}
if (browser_nn4 || browser_nn6) {
if (dialog_width != "undefined") oDialogContent.style.width = parseInt(dialog_width) + "px";
else oDialogContent.style.width = (oDialogContent.offsetWidth + 20) + "px";
}
if (dialog_height != "undefined") {
if (browser_ie && (parseInt(dialog_height) < oDialogContent.offsetHeight)) left = -15;
oDialogContent.style.height = parseInt(dialog_height) + "px";
}
oDialogContent.style.overflow="hidden";
if(dialog_overflow!="undefined")
{
oDialogContent.style.overflow =dialog_overflow;
}
var width = oDialog.offsetWidth;
var height = oDialog.offsetHeight;
doc = findDocDim();
if (dialog_closeOnEscKey != "undefined" && dialog_closeOnEscKey == "no") closeOnEscKey = false;
else closeOnEscKey = true;
if (dialog_closeOnBodyClick != "undefined" && dialog_closeOnBodyClick == "yes")
{
closeOnBodyClick = true;
closeOnBodyClickDetails[parseInt(boxNo)]=true;
}
else 
{
closeOnBodyClick = false;
closeOnBodyClickDetails[parseInt(boxNo)]=false;
}
if (!browser_opera) {
if (document.getElementById("FreezeLayer") != null) document.body.removeChild(document.getElementById("FreezeLayer"));
if (dialog_modal != "undefined" && dialog_modal == "yes") 
{
suspendSchedules();
freezeBackground(oDialog);
}
}
if (dialog_left != "undefined")	left += parseInt(dialog_left);
if (dialog_top != "undefined") top += parseInt(dialog_top);
var scrlBarWd = (document.body.scrollLeft > 0) ? 15 : 0;
var scrlBarHt = (document.body.scrollTop > 0) ? 15 : 0;
if (dialog_position != "undefined" && dialog_position == "relative") {
if (dialog_srcElement != "undefined") srcEl = document.getElementById(dialog_srcElement);
else if (srcEl == null) srcEl = document.body;
var srcElWidth = (srcEl.offsetWidth) ? srcEl.offsetWidth : 0;
var srcElHeight = (srcEl.offsetHeight) ? srcEl.offsetHeight : 0;
if(dialog_left!="undefined")
{		
left = findPosX(srcEl)+ parseInt(dialog_left);					
}
else
{
if (findPosX(srcEl) + width > doc.width - scrlBarWd) left += findPosX(srcEl) + srcElWidth - width;
else left += findPosX(srcEl);
}
if(dialog_top!="undefined")
{	
top = findPosY(srcEl) + parseInt(dialog_top);
}
else
{
if (findPosY(srcEl) + srcElHeight + height > doc.height - scrlBarHt) top += findPosY(srcEl) - height;
else top += findPosY(srcEl) + srcElHeight + 2;
}
} else if (dialog_position != "undefined" && dialog_position == "current") {
if (dialog_cursor_left != null && dialog_cursor_top != null) {
left = dialog_cursor_left;
top = dialog_cursor_top;
} else left = top = 0;
left = (dialog_cursor_left != null) ? dialog_cursor_left : 0;
top = (dialog_cursor_top != null) ? dialog_cursor_top : 0;
if (left + width > doc.width - scrlBarWd) left -= width;		
if (top + height > doc.height - scrlBarHt) top -= height;
} else if (dialog_position != "undefined" && dialog_position == "absolute") {
left += document.body.scrollLeft;
top += document.body.scrollTop;
} else if(dialog_position != "absolute") {
var docwidth=doc.width-document.body.scrollLeft;
var docHeight=doc.height - document.body.scrollTop;
left = document.body.scrollLeft+(docwidth/ 2 ) - (width / 2) ;
top = document.body.scrollTop+(docHeight/ 2) - (height / 2) ;		
}
left = (left > 0) ? left : 0;
top = (top > 0) ? top : 0;
if (dialog_transitionType != "undefined") {
if (dialog_transitionInterval == "undefined") dialog_transitionInterval = 1;	
oDialog.style.left = parseInt(left) + "px";
oDialog.style.top = parseInt(top) + "px";
oDialog.style.display="none";
if(dialog_transitionType == "boxIn")
{
dialog_transitionType = "Effect.Appear";
}
executeFunctionAsString(dialog_transitionType,window,"_DIALOG_LAYER"+boxNo,"{duration:" + dialog_transitionInterval + "}");
} else {
oDialog.style.left = parseInt(left) + "px";
oDialog.style.top = parseInt(top) + "px";
}
if (browser_ie && !browser_opera) {
iframeIEHack = document.createElement("IFRAME");
iframeIEHack.scrolling = "no";
iframeIEHack.frameBorder = 0;
iframeIEHack.id="iframe_"+boxNo;
if(window["CONTEXT_PATH"] != null)
{
iframeIEHack.src= CONTEXT_PATH + "/framework/html/blank.html";
}
iframeIEHack.style.position = "absolute";
iframeIEHack.style.zIndex = oDialog.style.zIndex- 1;
iframeIEHack.style.filter = 'progid:DXImageTransform.Microsoft.Alpha(style=0,opacity=0)';
if (dialog_modal != "undefined" && dialog_modal == "yes") {
iframeIEHack.style.width = document.getElementById("FreezeLayer").style.width;
iframeIEHack.style.top = "0px";
iframeIEHack.style.left = "0px";
} else { 
iframeIEHack.style.width = oDialog.offsetWidth + "px";
iframeIEHack.style.height = oDialog.offsetHeight + "px"; 
iframeIEHack.style.top = parseInt(top) + "px";
iframeIEHack.style.left = parseInt(left) + "px";
}
document.body.appendChild(iframeIEHack);
}
if (!browser_opera) {
if (dialog_modal != "undefined" && dialog_modal == "yes") {
var docDim = findDocDim();
document.getElementById("FreezeLayer").style.width = docDim.width + "px";
document.getElementById("FreezeLayer").style.height = getWindowHeight() + "px";
if (browser_ie) iframeIEHack.style.height = document.getElementById("FreezeLayer").style.height;
}
}
if (callBackFunc != null && typeof callBackFunc != "undefined") callBackFunc();	
if(closeOnEscKey)
{
document.onkeydown = dialogEscEvnt;
escapeDetails["ESC"+boxNo]="true";	 
}
if(dialog_minWidth!="undefined")
{
if((parseInt(dialog_width)) < (parseInt(dialog_minWidth)))
{
document.getElementById("__DIALOG_CONTENT"+boxNo).style.width=dialog_minWidth+"px";
}
}
if(dialog_minHeight!="undefined")
{
if((parseInt(dialog_height)) < (parseInt(dialog_minHeight)))
{
document.getElementById("__DIALOG_CONTENT"+boxNo).style.height=dialog_minHeight+"px";
}
}
if(dialog_focusId!=null && dialog_focusId!="undefined")
document.getElementById(dialog_focusId).focus();
return oDialog;
}
function setTopLeftOfDialog(eTtop,eLeft)
{
if(eTtop=="undefined"|| eTtop==null)
{
eTtop="null";
}
if(eLeft=="undefined"|| eLeft==null)
{
eLeft="null";
}
if(getCookie("DIALOGPOSITION")!=null)
{
deleteCookie("DIALOGPOSITION","/");
}
setCookie("DIALOGPOSITION",eTtop+","+eLeft,null,"/");
}
function freezeBackground(oDialog) {
var oFreezeLayer = document.createElement("DIV");
oFreezeLayer.id = "FreezeLayer";
oFreezeLayer.className = "freezeLayer";
oFreezeLayer.style.width = "100%";
oFreezeLayer.style.zIndex = oDialog.style.zIndex- 1;
document.body.appendChild(oFreezeLayer);
}
var diffLeft=0, diffTop=0;
function checkBoxAndAdjustZIndex(el)
{
var boxno=null;
if(DOMUtils.getParentWithAttr(el,"boxno")!=null){
boxno = DOMUtils.getParentWithAttr(el,"boxno").getAttribute("boxno");
} 
if(boxno==null)
{
boxno="";
}
var contentEl = document.getElementById("__DIALOG_CONTENT"+boxno);
var adjust=contentEl.getAttribute("zAdjust");
if(adjust=="false")
{
return;
}
else
{
adjustZIndex(boxno);
}
return boxno;
}
function captureDialog(ev,el) {
var boxno=checkBoxAndAdjustZIndex(el);
oDialog = document.getElementById("_DIALOG_LAYER"+boxno);
oDialog.style.cursor = "move";
if (browser_ie) {
diffLeft = window.event.clientX + document.body.scrollLeft - parseInt(findPosX(oDialog));
diffTop = window.event.clientY + document.body.scrollTop - parseInt(findPosY(oDialog));
} else if (browser_nn4 || browser_nn6) {
diffLeft = ev.pageX - parseInt(findPosX(oDialog));
diffTop = ev.pageY - parseInt(findPosY(oDialog));
}
document.onmousemove = moveDialog;
document.onmouseup = releaseDialog;
}
function moveDialog(ev) {
clearTextSelection();
if (browser_ie) {
var left = window.event.clientX + document.body.scrollLeft - diffLeft;
var top = window.event.clientY + document.body.scrollTop - diffTop;
left = (left >= 0) ? left : 0;
top = (top >= 0) ? top : 0;
if (document.getElementById("FreezeLayer") != null || browser_opera) 
{
oDialog.style.left = left + "px";
oDialog.style.top = top + "px";
} 
else 
{
oDialog.style.left = iframeIEHack.style.left = left + "px";
oDialog.style.top = iframeIEHack.style.top = top + "px";
}
} else if (browser_nn4 || browser_nn6) {
oDialog.style.left = ((ev.pageX - diffLeft > 0) ? ev.pageX - diffLeft : 0) + "px";
oDialog.style.top = ((ev.pageY - diffTop > 0) ? ev.pageY - diffTop : 0) + "px";	
}
}
function resizeDialogRB(ev,el) {
var boxno=checkBoxAndAdjustZIndex(el);
oDialog = document.getElementById("_DIALOG_LAYER"+boxno);
window["boxno"]=boxno;
if (browser_ie) {
diffLeft = window.event.clientX + document.body.scrollLeft - parseInt(findPosX(oDialog));
diffTop = window.event.clientY + document.body.scrollTop - parseInt(findPosY(oDialog));
} else if (browser_nn4 || browser_nn6) {
diffLeft = ev.pageX - parseInt(findPosX(oDialog));
diffTop = ev.pageY - parseInt(findPosY(oDialog));
}
document.onmousemove = resizeRB;
document.onmouseup = releaseDialog;
}
function resizeRB(ev)	
{
boxno=window["boxno"];
document.getElementById("resize").style.cursor = "nw-resize";
var con=document.getElementById("__DIALOG_CONTENT"+boxno);
var lay=document.getElementById("_DIALOG_LAYER"+boxno);
var initialX=parseInt((lay.style.left).substring(0,((lay.style.left).length)-2));
var initialY=parseInt((lay.style.top).substring(0,((lay.style.top).length)-2));
clearTextSelection();
if (browser_ie) {
var left = window.event.clientX + document.body.scrollLeft - initialX;
var top = window.event.clientY +document.body.scrollTop - initialY;
left = (left >= 0) ? left : 0;
top = (top >= 0) ? top : 0;
if(dialog_minWidth!="undefined")
{
if(((left+3)> parseInt(dialog_minWidth))&& ((top+6)> parseInt(dialog_minWidth)))
{
con.style.width = left+3 + "px";
con.style.height = top+6 + "px";
}
}
else
{
con.style.width = left+3 + "px";
con.style.height = top+6 + "px";
}
} else if (browser_nn4 || browser_nn6) {
if(dialog_minWidth!="undefined")
{
if((((ev.pageX - initialX)+4)> parseInt(dialog_minWidth)) && (((ev.pageY - initialY)+4)> parseInt(dialog_minHeight)))
{
con.style.width = ((ev.pageX - initialX > 0) ? (ev.pageX - initialX)+4 : 0) + "px";
con.style.height = ((ev.pageY - initialY > 0) ? (ev.pageY - initialY)+8 : 0) + "px";
}
}
else
{
con.style.width = ((ev.pageX - initialX > 0) ? (ev.pageX - initialX)+4 : 0) + "px";
con.style.height = ((ev.pageY - initialY > 0) ? (ev.pageY - initialY)+8 : 0) + "px";
}
}
}
function resizeDialogB(ev,el) {
var boxno=checkBoxAndAdjustZIndex(el);
oDialog = document.getElementById("_DIALOG_LAYER"+boxno);
window["boxno"]=boxno;
document.onmousemove = resizeB;
document.onmouseup = releaseDialog;
}
function resizeB(ev)
{
boxno=window["boxno"];
var con=document.getElementById("__DIALOG_CONTENT"+boxno);
var lay=document.getElementById("_DIALOG_LAYER"+boxno);
var initialY=parseInt((lay.style.top).substring(0,((lay.style.top).length)));
clearTextSelection();
if (browser_ie) {
con.style.height = window.event.clientY + document.body.scrollTop - initialY + "px";
} else if (browser_nn4 || browser_nn6) {
con.style.height = ((ev.pageY - initialY > 0) ? (ev.pageY - initialY)+3: 0) + "px";	
}
}
function resizeDialogT(ev,el) {
var boxno=checkBoxAndAdjustZIndex(el);
oDialog = document.getElementById("_DIALOG_LAYER"+boxno);
window["boxno"]=boxno;
var len=findPosY(DOMUtils.getChildElsWithAttr(oDialog,"id","bottom")[0]);
window["len"]=len;
document.onmousemove = resizeT;
document.onmouseup = releaseDialog;
}
function resizeT(ev)
{
boxno=window["boxno"];
var con=document.getElementById("__DIALOG_CONTENT"+boxno);
var lay=document.getElementById("_DIALOG_LAYER"+boxno);
var initialY=parseInt((lay.style.top).substring(0,((lay.style.top).length)));
var height=parseInt((con.style.height).substring(0,((con.style.height).length)));
var len=window["len"];
clearTextSelection();
if (browser_ie)
{
lay.style.top =window.event.clientY + document.body.scrollTop +"px";
con.style.height = len  - window.event.clientY - document.body.scrollTop + "px";
} 
else if (browser_nn4 || browser_nn6)
{
lay.style.top=((ev.pageY >0)? ev.pageY : 0)+ "px";
con.style.height = ((len-ev.pageY > 0) ? (len-ev.pageY ) : 0) + "px";	
}
}
function resizeDialogL(ev,el) {
var boxno=checkBoxAndAdjustZIndex(el);
oDialog = document.getElementById("_DIALOG_LAYER"+boxno);
window["boxno"]=boxno;
var len=findPosX(DOMUtils. getChildElsWithAttr(oDialog,"id","right")[0]);
window["len"]=len;
document.onmousemove = resizeL;
document.onmouseup = releaseDialog;
}
function resizeL(ev)
{
boxno=window["boxno"];
var con=document.getElementById("__DIALOG_CONTENT"+boxno);
var lay=document.getElementById("_DIALOG_LAYER"+boxno);
var initialX=parseInt((lay.style.left).substring(0,((lay.style.left).length)));
var width=parseInt((con.style.width).substring(0,((con.style.width).length)));
len=window["len"];
clearTextSelection();
if (browser_ie)
{
if(dialog_minWidth!="undefined")
{
if((len  - window.event.clientX - document.body.scrollLeft)> parseInt(dialog_minWidth))
{
lay.style.left =window.event.clientX + document.body.scrollLeft +"px";
con.style.width = len  - window.event.clientX - document.body.scrollLeft+ "px";
}
}
else
{
lay.style.left =window.event.clientX + document.body.scrollLeft +"px";
con.style.width = len  - window.event.clientX - document.body.scrollLeft+ "px";
}
} 
else if (browser_nn4 || browser_nn6)
{
if(dialog_minWidth!="undefined")
{
if((len-ev.pageX)> parseInt(dialog_minWidth))
{
lay.style.left=((ev.pageX >0)? ev.pageX : 0)+ "px";
con.style.width = ((len-ev.pageX > 0) ? (len-ev.pageX) : 0) + "px";	
}
}
else
{
lay.style.left=((ev.pageX >0)? ev.pageX : 0)+ "px";
con.style.width = ((len-ev.pageX > 0) ? (len-ev.pageX) : 0) + "px";	
}
}
}
function resizeDialogR(ev,el) {
var boxno=checkBoxAndAdjustZIndex(el);
oDialog = document.getElementById("_DIALOG_LAYER"+boxno);
window["boxno"]=boxno;
var con=document.getElementById("__DIALOG_CONTENT"+boxno);
var lay=document.getElementById("_DIALOG_LAYER"+boxno);
window["con"]=con;
window["lay"]=lay;
document.onmousemove = resizeR;
document.onmouseup = releaseDialog;
}
function resizeR(ev)
{
var con=window["con"];
var lay=window["lay"];
var initialX=parseInt((lay.style.left).substring(0,((lay.style.left).length)))-2;
clearTextSelection();
if (browser_ie) {
if(dialog_minWidth!="undefined")
{
if((window.event.clientX + document.body.scrollLeft - initialX)> parseInt(dialog_minWidth))
{
con.style.width = window.event.clientX + document.body.scrollLeft - initialX + "px";
}
}
else
{
con.style.width = window.event.clientX + document.body.scrollLeft - initialX + "px";
}
} else if (browser_nn4 || browser_nn6) {
if(dialog_minWidth!="undefined")
{
if((ev.pageX - initialX)> parseInt(dialog_minWidth))
{
con.style.width = ((ev.pageX - initialX > 0) ? (ev.pageX - initialX): 0) + "px";	
}
}
else
{
con.style.width = ((ev.pageX - initialX > 0) ? (ev.pageX - initialX): 0) + "px";	
}
}
}
function releaseDialog() {
oDialog.style.cursor = "default";
document.onmousemove = null;
document.onmouseup = null;
}
function closeDialog(callBackFunc,el) {
var boxno =null;
if(el!=null && DOMUtils.getParentWithAttr(el,"boxno")!=null)
{
boxno = DOMUtils.getParentWithAttr(el,"boxno").getAttribute("boxno"); 
}
if(el!=null && el.getAttribute && el.getAttribute("boxno")!=null && el.getAttribute("boxno")!="undefined")
{
boxno=el.getAttribute("boxno");
}
if(boxno==null)
{
boxno="0";
}
if(freezeDetails["Dialog"+boxno]=="true")
{
restartSchedules();	
var iframeEl =document.getElementById("iframe_"+boxno);
if (browser_ie && !browser_opera) {
if(iframeEl!= null && iframeEl!="undefined")
document.body.removeChild(iframeEl);
iframeEl = null;
}
if (document.getElementById("FreezeLayer") != null) document.body.removeChild(document.getElementById("FreezeLayer"));
}
oDialog = document.getElementById("_DIALOG_LAYER"+boxno);
if (oDialog != null && oDialog.style.display != "none") {
oDialog.style.display = "none";
if (callBackFunc!=null && typeof callBackFunc != "undefined" && callBackFunc.srcElement == "undefined" )
{
executeFunctionAsString(callBackFunc,window);
}
if((oDialog.htmlEl != null) && (oDialog.htmlEl.parentNode == oDialog))
{
oDialog.removeChild(oDialog.htmlEl);
oDialog.htmlEl = null;
}
var par=document.getElementById("_DIALOG_LAYER" + boxno) .parentNode;
par.removeChild(document.getElementById("_DIALOG_LAYER" + boxno) );
}
}
function  dialogEscEvnt(ev) {
if (browser_ie) var keyCode = window.event.keyCode;
else if (browser_nn4 || browser_nn6) var keyCode = ev.which;
if (keyCode == 27 && closeOnEscKey == true && oDialog != null && oDialog.style.display != "none")
{
closeDialog(null,document.getElementById("__DIALOG_CONTENT"+boxNo));
boxno=parseInt(boxNo);
if(!(isNaN(boxno)))
{
for(var i=1;i<=boxno;i++)
{
if(escapeDetails["ESC"+i]!="undefined" && escapeDetails["ESC"+i]=="true")
{
oDialog=document.getElementById("_DIALOG_LAYER"+i);
if(oDialog == null)
{
continue;
}			
if(oDialog.firstChild != null){oDialog.removeChild(oDialog.firstChild);}
oDialog.innerHTML = "";
oDialog.style.left = "";
oDialog.style.top = "";
oDialog.style.width = "";
oDialog.style.height = "";
closeDialog();
}
}
}}
}
var dialog_cursor_left, dialog_cursor_top;
var bodyClickHandlingFunction=function(ev) {
if (browser_ie) {
srcEl = window.event.srcElement;		
} else if (browser_nn4 || browser_nn6) {
srcEl = ev.target;
}
if(DOMUtils.getParentWithAttr(srcEl,"boxno")==null)
{
closeDialogs(null);
}
else
{
var exceptionId="";
exceptionId=DOMUtils.getParentWithAttr(srcEl,"boxno").getAttribute("boxno");
closeDialogs(parseInt(exceptionId));
}
}
document.onmousedown = bodyClickHandlingFunction;
function closeDialogs(exceptionId)
{
for(var i=0;i<closeOnBodyClickDetails.length;i++)
{
if((document.getElementById("__DIALOG_CONTENT"+i))!=null  && (document.getElementById("__DIALOG_CONTENT"+i))!="undefined")
if(closeOnBodyClickDetails[i]==true)
if(exceptionId!=i)
closeDialog(null,document.getElementById("__DIALOG_CONTENT"+i));
}
}
function getCursorPos(ev) {
if (browser_ie) {
var x = window.event.clientX + document.body.scrollLeft;
var y = window.event.clientY + document.body.scrollTop;
} else if (browser_nn6) {
var x = ev.pageX;
var y = ev.pageY;
}
return { x : x, y : y };
}
var scrollEnd = 0, cnt = 0;
function scrollPage() {
if (cnt <= scrollEnd) {
document.body.scrollTop += 10;
cnt += 10;
} else {
scrollEnd = cnt = 0;
clearInterval(scrollInterval);
}
}
function showURLInDialog(url, features, callBackFunc, openerId) {
var isBoxPresent;
var dialogConfig;
var title = null;
var uniqueId;
var opstatusdiv = null;
var draggable = "yes";
var closeButton = "yes";
if(features!=null){
featureArray = features.split(",");
var method="POST";
for (var j = 0; j < featureArray.length; j++)
{
if (featureArray[j].indexOf("dialogBoxType")!=-1) 
{
dialogConfig=featureArray[j].substring(14,featureArray[j].length)
isBoxPresent = true;
}
if (featureArray[j].indexOf("title")!=-1) 
{
title=featureArray[j].substring(featureArray[j].indexOf("=")+1,featureArray[j].length)
}
if (featureArray[j].indexOf("draggable")!=-1) 
{
draggable = featureArray[j].substring(featureArray[j].indexOf("=")+1,featureArray[j].length);
}
if (featureArray[j].indexOf("method")!=-1) 
{
method = featureArray[j].substring(featureArray[j].indexOf("=")+1,featureArray[j].length);
}
if (featureArray[j].indexOf("opstatusdiv")!=-1) 
{
opstatusdiv = featureArray[j].substring(featureArray[j].indexOf("=")+1,featureArray[j].length);
}
if (featureArray[j].indexOf("closeButton")!=-1) 
{
closeButton = featureArray[j].substring(featureArray[j].indexOf("=")+1,featureArray[j].length);
}
}
}
if(dialogConfig == null && SHADOW_DIALOG)
{
var p="";
if(closeButton=="no")
{
p="NoCloseButton";
}
if(draggable == "yes")
{
dialogConfig = "ShadowDialogBox"+p;
}
else
{
dialogConfig = "NoDragShadowDialogBox"+p;
}
isBoxPresent = true;
}
callBack = function(xmlhttp) 
{
try
{
var oDialog = showDialog(xmlhttp.getOnlyHtml(), features, callBackFunc,null, true);
if(openerId)
{
oDialog.setAttribute("opener", openerId);
}
}
catch(e)
{
StatusMsgAPI.showMsg("Script Error Occurred : " + e,false,true);
}
}	
if(isBoxPresent && url.indexOf("?")==-1)
{
if(title!=null)
{
url+="?dialogBoxType="+dialogConfig+"&title="+title;
}
else
{
url+="?dialogBoxType="+dialogConfig;
}
}
else if(isBoxPresent)
{
if(title!=null)
{
url+="&dialogBoxType="+dialogConfig+"&title="+title;
}
else
{
url+="&dialogBoxType="+dialogConfig;
}
}
try
{
var param="";	
if(method=="POST"){
if(url.indexOf('?')!=-1)
{
param=url.substring(url.indexOf('?')+1,url.length);
url=url.substring(0,url.indexOf('?'));
}	
}
AjaxAPI.sendRequest({METHOD:method,URL:url,ONSUCCESSFUNC:callBack,PARAMETERS:param,OPSTATUSDIV:opstatusdiv});
}
catch(e)
{
StatusMsgAPI.showMsg("Script Error Occurred : " + e,false,true);
}  
}
function openURLInDIV(url,divId,callback)
{
callBack = function(xmlhttp) 
{
try
{
document.getElementById(divId).innerHTML=xmlhttp.responseText;
}
catch(e)
{
StatusMsgAPI.showMsg("Script Error Occurred : " + e,false,true);
}
}
try
{
AjaxAPI.sendRequest({METHOD:"GET",URL:url,ONSUCCESSFUNC:callBack});
}
catch(e)
{
StatusMsgAPI.showMsg("Script Error Occurred : " + e,false,true);
}  
}
function closeParentDialog(element, refreshOpener)
{
closeDialog();
if (refreshOpener)
{
var parent = DOMUtils.getParentWithAttr(element, "opener");
AjaxAPI.refreshOpener({OPENER:parent.getAttribute("opener")});
}
}
function minimise(el)
{
var boxno = DOMUtils.getParentWithAttr(el,"boxno").getAttribute("boxno"); 
if(boxno==null)
{
boxno="";
}
oDialog = document.getElementById("_DIALOG_LAYER"+boxno);
window["boxno"]=boxno;
var titlediv= DOMUtils.getChildElsWithAttr(oDialog,"id","title")[0]; 
var lay=document.getElementById("_DIALOG_LAYER"+boxno);
lay.style.display="none";
if(!(temp["minExists"]=="true"))
{
oDialogMin = document.createElement("DIV");
oDialogMin.id = "_DIALOG_LAYER_MIN";
oDialogMin.style.display="block";
oDialogMin.style.overflow="auto";
oDialogMin.style.height="30px";
oDialogMin.style.cursor="normal";
oDialogMin.style.width="100px";
oDialogMin.style.left="0px";
oDialogMin.style.zIndex="110";
oDialogMin.innerHTML =("<table  class='DialogBox' cellpadding='0' cellspacing='0'><tr id='minRow'><td id='min"+boxno+"' onclick='normalise("+boxno+")' width='100px' height='30px'  class='boxHeaderType3'>" + ((titlediv.innerHTML!="")?(titlediv.innerHTML):("untitled"+boxno)) + "</td></tr></table>");      
if(browser_ie)
{
oDialogMin.style.position="absolute";
oDialogMin.style.top= (document.body.clientHeight+document.body.scrollTop -30) +"px";
document.body.onscroll=function(){
if(oDialogMin!=null){
oDialogMin.style.top=(document.body.clientHeight+document.body.scrollTop -30) +"px";
}
};
}
else
{
oDialogMin.style.position="fixed";
oDialogMin.style.top= (document.body.clientHeight-30) +"px";
oDialogMin.style.background="rgb(0, 104, 28) none repeat scroll 0%";
}
oDialogMin.style.visibility = "visible";
document.body.appendChild(oDialogMin);
temp["minExists"]="true";
}
else
{
var min=(document.getElementById("minRow"));
var divnode=(document.getElementById("_DIALOG_LAYER_MIN"));
divnode.style.width=(parseInt(oDialogMin.style.width)+100)+"px";
if(document.getElementById("min"+boxno)==null)
{
var existing=min.innerHTML;
divnode.innerHTML ="<table class='DialogBox' cellpadding='0' cellspacing='0'><tr id='minRow'>"+existing+("<td id='min"+boxno+"' onclick='normalise("+boxno +")' width='100px' height='30px'  class='boxHeaderType3'>" + ((titlediv.innerHTML!="")?(titlediv.innerHTML):("untitled"+boxno)) + "</td></tr></table>");      
}
}
}
function toggleDialogState(el)
{
var boxno = DOMUtils.getParentWithAttr(el,"boxno").getAttribute("boxno"); 
if(boxno==null)
{
boxno="";
}
oDialog = document.getElementById("_DIALOG_LAYER"+boxno);
if(!(temp["isMaximised"+boxno]=="true"))
{
var lay=document.getElementById("_DIALOG_LAYER"+boxno);
temp["zindex"]=lay.style.zIndex;
lay.style.zIndex="125";
var con=document.getElementById("__DIALOG_CONTENT"+boxno);
temp["top"+boxno]=lay.style.top;
temp["left"+boxno]=lay.style.left;
lay.style.top=document.body.scrollTop+"px";
lay.style.left=document.body.scrollLeft+"px";
temp["width"+boxno]=con.style.width;
temp["height"+boxno]=con.style.height;
con.style.width=document.body.clientWidth;
con.style.height=document.body.clientHeight;
el.className="maximisedButtonType2";
setMaximised(boxno);
}
else
{
el.className="maxButtonType2";
var lay=document.getElementById("_DIALOG_LAYER"+boxno);
var con=document.getElementById("__DIALOG_CONTENT"+boxno);
lay.style.zIndex=temp["zindex"];
lay.style.top=temp["top"+boxno];
lay.style.left=temp["left"+boxno];
con.style.width=temp["width"+boxno];
con.style.height=temp["height"+boxno];
setNormal(boxno);
}
}
function normalise(no)
{		
var minRow=document.getElementById("minRow");		
minRow.removeChild(document.getElementById("min"+no));
var lay=document.getElementById("_DIALOG_LAYER"+no);
lay.style.display="block";
var divnode=(document.getElementById("_DIALOG_LAYER_MIN"));
divnode.style.width=(parseInt(oDialogMin.style.width)-100)+"px";
adjustZIndex(no);
}
function setMaximised(boxno)
{
temp["isMaximised"+boxno]="true";
temp["isMinimised"+boxno]="false";
temp["is Normal"+boxno]="false";
}
function setMinimised(boxno)
{
temp["isMaximised"+boxno]="false";
temp["isMinimised"+boxno]="true";
temp["is Normal"+boxno]="false";
}
function setNormal(boxno)
{
temp["isMaximised"+boxno]="false";
temp["isMinimised"+boxno]="false";
temp["is Normal"+boxno]="true";
}
function adjustZIndex(no)
{
var total=null;
if(no != null && no != "")
{
total = parseInt(boxNo); 
}
else
{
total = 0;
}
var popDialog=document.getElementById("_DIALOG_LAYER"+no);	
var zInd=popDialog.style.zIndex;
popDialog.style.zIndex=(100+total)+"";
if(browser_ie)
{
document.getElementById("iframe_"+no).style.zIndex=(99+total)+"";
}
for(var i=total; i>0; i--)
{
var id="_DIALOG_LAYER"+i;
var el=document.getElementById(id);
if(el== null)
{
continue;
}	 
var	zi=document.getElementById(id).style.zIndex;
if(parseInt(zi) >= parseInt(zInd))
{
if(i!=parseInt(no))
{
var style=parseInt(zi);
el.style.zIndex=(style-1)+"";
if (browser_ie && !browser_opera) {
var iframehack=document.getElementById("iframe_"+i);
iframehack.style.zIndex=(style-2)+"";	
}				
}
}
}
}
function showConfirmDialog(message, features, okhandler, cancelhandler)
{
features = features + ",dialogBoxType=ConfirmDialogBox";
var url = "components/jsp/FetchDialogTemplate.jsp?message=" + message;
if(typeof okhandler != "undefined")
{
url +=  "&okhandler=" + okhandler;
}
if(typeof cancelhandler != "undefined")
{
url +=  "&cancelhandler=" + cancelhandler;
}
showURLInDialog(url, features);
}
function showAlertDialog(message, features, okhandler)
{
features = features + ",dialogBoxType=AlertDialogBox";
var url = "components/jsp/FetchDialogTemplate.jsp?message=" + message;
if(typeof okhandler != "undefined")
{
url +=  "&okhandler=" + okhandler;
}
showURLInDialog(url, features);
}
function showPromptDialog(message, features, prompthandler, cancelhandler)
{
features = features + ",dialogBoxType=PromptDialogBox";
var url = "components/jsp/FetchDialogTemplate.jsp?message=" + message;
if(typeof prompthandler != "undefined")
{
url +=  "&prompthandler=" + prompthandler;
}
if(typeof cancelhandler != "undefined")
{
url +=  "&cancelhandler=" + cancelhandler;
}
showURLInDialog(url, features);	
}
function prompthandler(promptvalue)
{
closeDialog();
return false;
}
function suspendSchedules()
{
if(!window._RSC)
{
return;
}
if(!window._RSCTEMP)
{
_RSCTEMP=new Object();
}
for(var i in _RSC)
{
_RSCTEMP[i]=_RSC[i];
_RSC[i]=null;
}
}
function restartSchedules()
{
if(!window._RSCTEMP)
{
return;
}
for(var i in _RSCTEMP)
{
scheduleViewForRefresh(i,0,_RSCTEMP[i]);
}
}
function clearAllDialogs()
{
if(document.getElementById("_DIALOG_LAYER")!=null)
{
closeDialog(null,document.getElementById("_DIALOG_LAYER"));
}
var count=1;
if(document.getElementById("_DIALOG_LAYER0")!=null)
{
count=0;
}
while(document.getElementById("_DIALOG_LAYER"+count)!=null)
{
var par=document.getElementById("_DIALOG_LAYER"+count).parentNode;
par.removeChild(document.getElementById("_DIALOG_LAYER"+count));
closeDialog(null,document.getElementById("_DIALOG_LAYER"+count));
count++;
}
}
function getWindowHeight()
{
var ht;
var pageHeight;
if (window.innerHeight && window.scrollMaxY) {
ht = window.innerHeight + window.scrollMaxY;
} else if (document.body.scrollHeight > document.body.offsetHeight){
ht = document.body.scrollHeight;
} else {
ht = document.body.offsetHeight;
}
var windowHeight;
if (self.innerHeight) {
windowHeight = self.innerHeight;
} else if (document.documentElement && document.documentElement.clientHeight) {
windowHeight = document.documentElement.clientHeight;
} else if (document.body) {
windowHeight = document.body.clientHeight;
}
if(ht < windowHeight){
pageHeight = windowHeight;
} else {
pageHeight = ht;
}
return pageHeight;
} 
