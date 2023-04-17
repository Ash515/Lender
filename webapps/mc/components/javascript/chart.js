var ToolTip = new function()
{ 
this.show = function(event,el)
{ 
if(event == null){event = window.event;}
if(this.toolTipArea == null)
{
var toolTipIdEl = DOMUtils.getParentWithAttr(el, "toolTipId");
var toolTipId = toolTipIdEl.getAttribute("toolTipId");
this.toolTipArea=document.getElementById(toolTipId);
document.body.appendChild(this.toolTipArea);
}
this.toolTipArea.innerHTML=el.getAttribute("value");
this.toolTipArea.style.left=event.clientX+"px";
this.toolTipArea.style.top=event.clientY+25+"px";
this.toolTipArea.style.display="block";
el.onmouseout=ToolTip.hide;
el.onmousemove = ToolTip.move;
}
this.move = function(event,el)
{
if(event == null){event = window.event;}
ToolTip.toolTipArea.style.position="absolute";
ToolTip.toolTipArea.style.left=event.clientX+"px";
ToolTip.toolTipArea.style.top=event.clientY+25+"px";
}
this.hide = function()
{
ToolTip.toolTipArea.style.display="none";
}
}
