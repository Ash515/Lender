function log(message)
{
if(navigator.appName == "Netscape")
{	
console.log(message);
}
else
{
if (!log.window_ || log.window_.closed) 
{
var newWindow = window.open("", null,"width=400,height=200,scrollbars=yes,resizable=yes");
log.window_ = newWindow;
}
var logDiv = log.window_.document.createElement("div");
logDiv.appendChild(log.window_.document.createTextNode(message));
log.window_.document.body.appendChild(logDiv);
}
}
