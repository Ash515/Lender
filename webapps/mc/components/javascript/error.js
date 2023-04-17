function sendErrorReport(themeDir)
{
var win = window.open('about:blank','ErrorRpt','width=550,height=300,scrollbars=1,resizable=yes');
var err = document.getElementById("StackTrace").innerHTML;
document.forms["feedBackFrm"]["STACKTRACE"].value = err;
var el = document.getElementById('feedBackForm');
win.document.open();
win.document.write(el.innerHTML); 
win.document.close();
var doc = win.document;
var e = doc.createElement("link");
e.href =  themeDir + "/styles/style.css";
e.rel="stylesheet";
e.type="text/css";
doc.getElementsByTagName("head")[0].appendChild(e); 
}
function showCompError()
{
showDialog(document.getElementById("completeErrorDiv").innerHTML,"overflow=visible,closeOnEscKey=yes,title=Error",null,'true');
document.getElementById("completeErrorDiv").innerHTML="";
}
function showDiv(divId)
{
var el = document.getElementById(divId);
el.className="";
}
function hideShowError(id)
{
var slideObj = document.getElementById('exception'+id);
var bulletObj=document.getElementById('bullet'+id)
if(slideObj.className == 'hide' )
{
slideObj.className="";
bulletObj.src=CONTEXT_PATH + "/themes/common/images/arrow_down.png";
}
else
{
slideObj.className="hide";
bulletObj.src=CONTEXT_PATH + "/themes/common/images/arrow_up.png";
}
}
