<!--$Id$-->
var app = Class.create();
window["ExecuteHistoryAction"]=true;
window["lastHash"]="";
app.prototype = {	
initialize : function() {		
browserHistory = new historyStack("browserHistory", "");				
browserHistory.onBrowserAddressChanged = function(){	
if(this.current=="")
{
window.location.href=unescape(window.location.pathname);
return;
}
if(!window["ExecuteHistoryAction"])
{
return;
}		
window["ExecuteHistoryAction"]=false;
var currHash=this.current;
if(window["lastHash"]==currHash && !window['sameTabException'])
{
window["ExecuteHistoryAction"]=true;
return;
}
showTabLoadingStatus();	
lastHash=window["lastHash"];
var currentHash=currHash;
currHash=currHash.split('/');
var lastHashArray=lastHash.split('/');
var viewId;
var selId;
var continueLoop=true;
var noofRequests=0;
for(var i=0;i<currHash.length;i++)
{
viewId=currHash[i].substring(0,currHash[i].indexOf('t'));
selId=currHash[i].substring(currHash[i].indexOf('t')+1,currHash[i].length);
if(window['sameTabException'])
{
if(i==currHash.length-1)
{
window["TABARRAY_"+viewId]=null;
continueLoop=false;
}
}
if((lastHash.indexOf(viewId))!=-1 && window["TABARRAY_"+viewId]!=null 
&& window["TABARRAY_"+viewId]!="undefined" && (window["TABARRAY_"+viewId]==(selId+"")) 
&& (i!=(currHash.length-1))&& continueLoop)
continue;
continueLoop=false;
if(i==currHash.length-1)
{
tabSelected(viewId,selId,-4,false,true,true);
noofRequests++;
}
else
{
tabSelected(viewId,selId,-4,false,true,false);	
noofRequests++;
}
}
if(noofRequests==0)
hideTabLoadingStatus();
window["ExecuteHistoryAction"]=true;	
window["lastHash"]=currentHash;
window['sameTabException']=false;
};
}
}
