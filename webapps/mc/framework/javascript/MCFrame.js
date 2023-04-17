function MCFrame(contentAreaName, dacArray)
{
this.contentareaname = contentAreaName;
this.dacarray = dacArray;
this.history = new MCFrameHistory(this);
this.location = new MCFrameLocation(this);
}
function MCFrameHistory(obj)
{
this.MCFrame = obj;
}
function MCFrameLocation(obj)
{
this.MCFrame = obj;
}
MCFrame.getMCFrame = function(argObj)
{
var contentAreaName = null;
if(typeof argObj == "object")
{
contentAreaName = MCFrame.getMCFrameName(argObj);
}
else if(typeof argObj == "string")
{
contentAreaName = getContentAreaName(argObj);
}
return new MCFrame(contentAreaName, getDacArray(contentAreaName));
}
MCFrame.getMCFrameName = function(elObj)
{
var parent = DOMUtils.getParentWithAttr(elObj,"contentareaname");
return parent.getAttribute("contentareaname");	
}
MCFrameHistory.prototype.getPreviousURL = function(viewname)
{
if(viewname == null)
{
var dacArray = this.MCFrame.dacarray;
return getViewURL(dacArray[dacArray.length -2]);
}
else
{
var dacArr = this.MCFrame.dacarray;
var refid = getReferenceId(viewname);
if(refid != null)
{
for(var i = dacArr.length -1 ; i >= 0; i--)
{
if(dacArr[i] == refid)
{
return getViewURL(dacArr[i]);
}
}
}
}
}
MCFrameHistory.prototype.getCurrentURL = function()
{
var dacArray = this.MCFrame.dacarray;
return getViewURL(dacArray[dacArray.length -1]);
}
MCFrameHistory.prototype.update = function(viewName)
{
var dacArr = this.MCFrame.dacarray;
var refid = getReferenceId(viewName);
var addflag = true;
if(dacArr != null && refid != null)
{
for(var i =0; i < dacArr.length; i++)
{
if(dacArr[i] == refid)
{
popContentArea(i, this.MCFrame.contentareaname, true);
addflag = false;
break;
}
}
}
if(addflag == true)
{
var dacList = null;
if(dacArr != null)
{
dacList = dacArr[0];
for(var i=1; i<dacArr.length; i++)
{
dacList = dacList + "-" + dacArr[i];
}
dacList = dacList + "-" + refid;
}
else
{
dacList = refid;
}
updateDac(dacList, this.MCFrame.contentareaname);    		
}
updateViewsBasedOnDCA(this.MCFrame.contentareaname);
var breadCrumbDiv = document.getElementById("BreadCrumbs");
if(breadCrumbDiv != null)
{
this.MCFrame.updateBreadCrumb();
}
}
MCFrame.prototype.updateBreadCrumb = function()
{
var breadcrumbdiv = document.getElementById(this.contentareaname + "_BC");
if(breadcrumbdiv == null)
{
breadcrumbdiv = document.createElement("DIV");
breadcrumbdiv.style.display="none";
breadcrumbdiv.id = this.contentareaname + "_BC";
document.body.appendChild(breadcrumbdiv);
}
var breadcrumbcontent = null;
var dacArr = getDacArray(this.contentareaname);
for(var i =0; i < dacArr.length - 1; i++)
{
var content=getUniqueId(dacArr[i]);
var trimlength=5;
if(breadcrumbcontent == null)
{
breadcrumbcontent = "<a id='crumb"+ i +"' href='javascript:popContentArea(" + i + ",\""
+ this.contentareaname + "\")'>" + trimText(content,trimlength) + "</a>"
+ getPopUP(content,i,trimlength)
+ "<img src='" + THEME_DIR + "/images/arrow_right.gif'/>";
}
else
{
breadcrumbcontent = breadcrumbcontent 
+ "<a id='crumb"+ i +"' href='javascript:popContentArea(" + i + ",\""
+ this.contentareaname + "\")'>" + trimText(content,trimlength) + "</a>"
+ getPopUP(content,i,trimlength)
+ "<img src='" + THEME_DIR + "/images/arrow_right.gif'/>";
}
}	
if(breadcrumbcontent == null)
{
breadcrumbcontent = "";
}
else
{
breadcrumbcontent = breadcrumbcontent + getUniqueId(dacArr[dacArr.length - 1]);
}
breadcrumbdiv.innerHTML = breadcrumbcontent;
createBreadCrumbs(this.contentareaname, self);
}
MCFrameHistory.prototype.clear = function(viewName)
{
updateDac(null,this.MCFrame.contentareaname);
updateDac(getReferenceId(viewName), this.MCFrame.contentareaname);
updateViewsBasedOnDCA(this.MCFrame.contentareaname);
this.MCFrame.updateBreadCrumb();    
}
MCFrameHistory.prototype.replace = function(viewName)
{
var dacArr = this.MCFrame.dacarray;
var refid = getReferenceId(viewName);
var dacList;
if(dacArr.length > 1)
{
popContentArea(dacArr.length - 2, this.MCFrame.contentareaname, true);
dacArr = getDacArray(this.MCFrame.contentareaname);
dacList = dacArr[0];
for(var i=1; i<dacArr.length; i++)
{
dacList = dacList + "-" + dacArr[i];
}
dacList = dacList + "-" + refid;
}
else
{
dacList = refid;
}
updateDac(dacList, this.MCFrame.contentareaname);   
updateViewsBasedOnDCA(this.MCFrame.contentareaname); 
this.MCFrame.updateBreadCrumb();    		
}
MCFrameHistory.prototype.go = function(arg)
{
var dacArr = this.MCFrame.dacarray;
if(typeof arg == "string")
{
var refid = getReferenceId(viewName);	
for(var i =0; i < dacArr; i++)
{
if(dacArr[i] == refid)
{
popContentArea(i, this.MCFrame.contentareaname, true);
}
}		
}
else if(typeof arg == "number")
{
popContentArea(arg, this.MCFrame.contentareaname, true);
}
dacArr = getDacArray(this.MCFrame.contentareaname);
var url = getViewURL(dacArr[dacArr.length -1]);
var urlparts = splitURL(url);
AjaxAPI.sendRequest({URL:urlparts["resource"],PARAMETERS:urlparts["query"],
TARGET:"_MCFRAME"});
}
MCFrameHistory.prototype.back = function()
{
this.MCFrame.history.go(1);
}
MCFrameHistory.prototype.view_ids = function(elObj)
{
var contentAreaName = MCFrame.getMCFrameName(elObj);
var mcfobj = MCFrame.getMCFrame(contentAreaName);
var dacArray = mcfobj.dacarray;
return dacArray;
}
function trimText(text,no)
{
if(text.length > no)
{
return (text.substring(0,no)+"...");
}
else
{
return text;
}
}	
function getPopUP(content,i,trimLength)
{
if(content.length<=trimLength)return "";
var link="crumb"+i;
var div="crumbdiv"+i;
var popup="<script>" +
"new Tooltip('"+link+"','"+div+"',"
+"{ hideEvent:'none',"
+   "effect:'none',"
+	"offsetLeft: -10, offsetTop: 0,"
+	"duration:0.5,"
+	"displayAt:'linkPosition'});"
popup="<div id='crumbdiv"+i+"'>" + content +"</div>" +popup;
}
