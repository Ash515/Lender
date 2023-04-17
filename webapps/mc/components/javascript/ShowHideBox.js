var NOBOXCOLLAPSE="false";
function changeBoxState(boxId)
{
if(NOBOXCOLLAPSE=="true")
{
return;
}
var parentBox=DOMUtils.getParentWithAttr(boxId,"boxid");
var showeffect = parentBox.getAttribute("showmethod");
var hideeffect = parentBox.getAttribute("hidemethod");
var effectduration = parentBox.getAttribute("effectduration");
if(effectduration == null)
{
effectduration = '0.5';
}
if(showeffect == null)
{
showeffect = "Effect.BlindDown";
}
if(hideeffect == null)
{
hideeffect = "Effect.BlindUp";
}	
var enclosingBox=DOMUtils.getParentWithAttr(parentBox,"boxid");
if(enclosingBox == null)
{
enclosingBox=DOMUtils.getParentWithAttr(parentBox,"accordian");
}
if(enclosingBox)
{
var el=checkState(parentBox);
if(!el){
var children=DOMUtils.getChildElsWithAttr(enclosingBox,"AutoSlideUp","true");
var siblingstate;
var siblingid;
var siblingcontent;
var siblingParent;
var siblingelements;
for(var i=0;i<children.length;i++)
{
if(children[i].getAttribute!=null)
{ 
siblingid=children[i].getAttribute("id");
siblingstate=checkState(children[i]);
if(siblingid!=parentBox.getAttribute("id") && (siblingstate)&&(siblingid!=null))
{
toggleBoxState(children[i]);
}
else
{
continue;
}
siblingcontent = document.getElementById(siblingid + "_ICN");
if (!siblingcontent){
siblingParent = DOMUtils.getFirstChild(children[i],"childtype","content","childtype","content");;
siblingParent.id = siblingid + "_C";
siblingcontent = DOMUtils.filterElements(siblingParent.childNodes,"DIV",null,null)[0];
siblingcontent.id = siblingid + "_ICN";
}
if(siblingid!=parentBox.getAttribute("id") && siblingstate && (children[i].getAttribute("AutoSlideUp")=="true")){
executeFunctionAsString(hideeffect,window , siblingid + "_ICN" ,"{duration:" + effectduration + "}");
}
}
}	  
} 
}
var boxIde=parentBox.getAttribute("boxid");
var cntId = boxIde + "_ICN";
var content = document.getElementById(cntId);
if (!content)
{
var parent =DOMUtils.getFirstChild(parentBox,'childtype',"content","childtype","content");
content = DOMUtils.filterElements(parent.childNodes,"DIV",null,null)[0];
content.id = cntId; 
}
var state = toggleBoxState(parentBox);
if (state == "true")
{
executeFunctionAsString(showeffect,window, cntId ,"{duration:" + effectduration + "}");
}
else
{ 
executeFunctionAsString(hideeffect ,window, cntId ,"{duration:" + effectduration + "}");
}
var childDiv = ViewAPI.getEnclosingViewDiv(document.getElementById(boxIde));
var childID = childDiv.getAttribute("unique_id");
var parentDiv = ViewAPI.getEnclosingViewDiv(childDiv);
if(parentDiv != null)
{
var parentId= parentDiv.getAttribute("unique_id");
updateState(parentId,"S_" + childID,state,true);
}
}
function toggleBoxState(parentEl)
{
var boxMaxContentNode = DOMUtils.getFirstChild(parentEl,"childtype","content","childtype","content");
var boxMinContentNode =DOMUtils.getFirstChild(parentEl,'childtype',"MC","childtype","content");
var boxMaxImgNode = DOMUtils.getFirstChild(parentEl,'childtype',"maxbtn","childtype","content");
var boxMinImgNode = DOMUtils.getFirstChild(parentEl,'childtype',"minbtn","childtype","content");
if(boxMaxContentNode == null)
{ 
throw new Error("No Element with childtype " + "content" + "present");
}
var state;
if ((boxMaxContentNode.getAttribute("state") == "false") || (boxMaxContentNode.className == "hideBoxContent"))
{
state="true";
if(boxMinContentNode  != null)
{
boxMinContentNode.className ="hideBoxContent";
}
if(boxMaxImgNode != null)
{
boxMaxImgNode.className="hide";
} 
if(boxMinImgNode != null)
{
boxMinImgNode.className="minButton";
} 
}
else 
{
state="false";
if(boxMinContentNode != null)
{ 
boxMinContentNode.className =''; 
} 
if(boxMaxImgNode != null)
{
boxMaxImgNode.className='maxButton';
} 
if(boxMinImgNode != null)
{
boxMinImgNode.className="hide";
} 
}
boxMaxContentNode.setAttribute("state",state);
boxMaxContentNode.className = "boxContent";
return state;
}
function checkState(boxIde)
{
var boxMaxContentNode = DOMUtils.getChildElsWithAttr(boxIde, "childtype","content")[0];
var boxMinContentNode = DOMUtils.getChildElsWithAttr(boxIde, "childtype", "MC")[0];
var boxMaxImgNode = DOMUtils.getChildElsWithAttr(boxIde, "childtype", "maxbtn")[0];
var boxMinImgNode = DOMUtils.getChildElsWithAttr(boxIde, "childtype", "minbtn")[0];
if ((boxMaxContentNode.getAttribute("state") == "false") || (boxMaxContentNode.className == "hideBoxContent"))
{
return false;
}
else
{
return true;
}
}
function boxClosed(requestOptions)
{
var closedBox=document.getElementById(requestOptions["BOX"]);
var a=requestOptions["BOX"];
DOMUtils.getFirstChild(closedBox,'childtype','content',"childtype","content").className= "hideBoxContent";
}
function boxClose(requestOptions)
{
DOMUtils.getChildElsWithAttr(requestOptions["BOX"],"childtype","content").className = "hideBoxContent";
}
