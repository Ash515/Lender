Tooltip = Class.create(); 
window.tooltips = [];
Tooltip.prototype = {
initialize: function(link_id, tooltip_id, options) {
this.link_el = $(link_id);
this.tooltip_el = $(tooltip_id);
this.runningEffect = null;
this.options = {
queue: { 
position: "end", 
scope: "tooltip"+window.tooltips.length, 
limit: 1
},
duration: 1.0,
effect:"appear",
offsetLeft: 20,
offsetTop: 10,
showEvent: "mouseover",
hideEvent: "mouseout",
displayAt:"mousePosition"
};		
this.tooltip_el.style.zIndex = "1000";
this.tooltip_el.style.position = "absolute";
Element.hide(this.tooltip_el);		
Object.extend(this.options, options||{});
Event.observe(this.link_el, this.options.showEvent, this.show.bind(this));
if(this.options.closelinkId)
{
Event.observe($(this.options.closelinkId), this.options.hideEvent, this.hide.bind(this));
}
else
{
if(this.options.hideEvent != "none")
{
Event.observe(this.link_el, this.options.hideEvent, this.hide.bind(this));
}
else
{
Event.observe(this.tooltip_el,  "mouseout", this.hide.bind(this));
}
}
window.tooltips.push(this);
Event.observe(document.getElementsByTagName("body").item(0), "click", this.hide.bind(this));
},
show: function(event) {
if(window._currentTT)
{
window._currentTT.hide();
}
window._currentTT = this;	
var duration = this.options.duration;	
var position=getPosition(this.link_el);
var x = (this.options.displayAt != "linkPosition")?(Event.pointerX(event) + this.options.offsetLeft):(position[0] + this.options.offsetLeft);
Position.prepare();		
var triggerY =(this.options.displayAt != "linkPosition")?( Position.cumulativeOffset(this.link_el)[1]):position[1];
var y = triggerY + this.link_el.offsetHeight + this.options.offsetTop;
var popUp = Element.getDimensions(this.tooltip_el);
var visibleWidth = 
(window.opera) ? document.body.clientWidth || document.documentElement.clientWidth || window.innerWidth
: document.documentElement.clientWidth || window.innerWidth || document.body.clientWidth;
var visibleHeight = 
(window.opera) ? document.body.clientHeight || document.documentElement.clientHeight || window.innerHeight
: window.innerHeight || document.body.clientHeight || document.documentElement.clientHeight;
if (x + popUp.width + this.options.offsetLeft > (Position.deltaX + visibleWidth)) 
x = Math.max( this.options.offsetLeft, ((Position.deltaX + visibleWidth) - popUp.width - 130 - this.options.offsetLeft));
if (y + popUp.height + this.options.offsetTop > (Position.deltaY + visibleHeight)) {
y = triggerY - popUp.height - this.options.offsetTop;
}
this.tooltip_el.style.left = x+"px";
this.tooltip_el.style.top = y+"px";	
if(this.options.effect != "none")
{
if (this.runningEffect) {
var queue = Effect.Queues.get(this.options.queue.scope);
queue.remove(this.runningEffect);
}
this.runningEffect = Effect[Effect.PAIRS[this.options.effect][0]](this.tooltip_el,
{duration: duration, queue: this.options.queue});
}		
else
{
this.tooltip_el.style.display = "block";
}					
},
hide: function(event) {
if(event && event.type == "click" && Event.element(event) == this.link_el)
{
return;
}
if(event && this.options.hideEvent == "none" && event.type == "mouseout")
{
var tg = Event.element(event);
if (tg.nodeName != 'DIV') 
{
return;
}
var reltg = (event.relatedTarget) ? event.relatedTarget : event.toElement;
while (reltg && reltg != tg && reltg.nodeName != 'BODY')
{
reltg = reltg.parentNode
}
if (reltg == tg) 
{	
return;
}
}
var duration = this.options.hideduration;
if(!duration)
{
duration = this.options.duration;
}
if(this.options.effect != "none")
{		
if (this.runningEffect) {
var queue = Effect.Queues.get(this.options.queue.scope);
queue.remove(this.runningEffect);
}		
this.runningEffect = Effect[Effect.PAIRS[this.options.effect][1]](this.tooltip_el, {duration: duration,queue: this.options.queue,afterFinish: function(){this.tooltip_el.style.display = "none";}.bind(this)});
}
else
{
this.tooltip_el.style.display = "none";
}					
}
}
function registerNormalTooltip(link_id, tooltip_id)
{
var ttip = new Tooltip(link_id, tooltip_id,
{duration:0.5});
}
function registerMouseMoveTooltip(link_id, tooltip_id)
{
var ttip = new Tooltip(link_id, tooltip_id, {duration:0.0,showEvent:"mousemove",effect:"none"});
}
function registerMenuPopupTooltip(link_id, tooltip_id,offsetleft,offsettop,showevent,hideevent)
{
if(offsetleft==null||offsetleft=="")
{
offsetleft=document.getElementById(tooltip_id).getAttribute("offsetleft");
}
if(offsettop==null||offsettop=="")
{
offsettop=document.getElementById(tooltip_id).getAttribute("offsettop");
}
if(showevent==null||showevent=="")
{
showevent=document.getElementById(tooltip_id).getAttribute("showevent");
}
if(hideevent==null||hideevent=="")
{
hideevent=document.getElementById(tooltip_id).getAttribute("hideevent");
}
var ttip = new Tooltip(link_id, tooltip_id,
{
effect:"none",
offsetLeft:parseInt(offsetleft), offsetTop:parseInt(offsettop),
displayAt:"linkPosition",
showEvent: showevent,
hideEvent:hideevent,
duration:0.5});
}
function registerCalloutTooltip(link_id, tooltip_id)
{
var ttip = new Tooltip(link_id, tooltip_id,
{showEvent:"mousemove",offsetLeft: 5, offsetTop: 5, duration:0.1});
}
function registerClickBubbleTooltip(link_id, tooltip_id,closelink_id)
{
var ttip = new Tooltip(link_id, tooltip_id,
{showEvent:"click",hideEvent:"click", offsetLeft: 5, offsetTop: 5,
closelinkId:closelink_id, duration:0.1});
}
function registerMouseClickTooltip(link_id, tooltip_id, closelink_id)
{
var ttip = new Tooltip(link_id, tooltip_id,
{showEvent:"click",
hideEvent:"click",
closelinkId:closelink_id, duration:0.1});
}
function getPosition(element) 
{
var left =0;
var top = 0;
if (element.offsetParent)
{
left = element.offsetLeft
top = element.offsetTop
while (element = element.offsetParent) 
{
left += element.offsetLeft
top += element.offsetTop
}
}
return [left,top];
}
function registerFormHints(hints, options)
{
var tooltipoptions = {duration:0.0,showEvent:"mouseover",effect:"none",offsetLeft:35,offsetTop:-15};
Object.extend(tooltipoptions, options||{});
for(var key in hints)
{
var value = hints[key];
var hintdiv = document.getElementById(value);
hintdiv.className="hint";
var ttip = new Tooltip(key, value, tooltipoptions);
}
}
function registerOnFocusFormHints(hints, options)
{
var tooltipoptions = {duration:0.0,showEvent:"focus",hideEvent:"blur",effect:"none",
offsetLeft:225,offsetTop:-20,displayAt:'linkPosition'};
Object.extend(tooltipoptions, options||{});	
for(var key in hints)
{
var value = hints[key];
var hintdiv = document.getElementById(value);
var ttip = new Tooltip(key, value, tooltipoptions);
}	
}
