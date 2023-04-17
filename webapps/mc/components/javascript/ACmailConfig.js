<!--$Id$-->
function validateAddEmailFormAndSubmit(form)
{
var address = form.EMAIL_ADDRESS.value;
if( address.length == 0 )
{
alert("Enter email address");
return;
}
if(!checkEmailAddress(address))
{
return;
}
handleStateForForm(form); 
form.submit();
}
function validateRemoveEmailFormAndSubmit(form)
{
var index = form.EMAIL_SELECT.selectedIndex;
if( index == -1 )
{
alert("Select atleast one email address to delete");
return;
}
if(! confirm("Do you really want to delete selected email address(es) ?") )
{
return;
}
handleStateForForm(form);
form.submit();
}
function showEditTable(showvalue)
{
var viewTableObj=MM_findObj('mailserversettings_view');
var editTableObj=MM_findObj('mailserversettings_edit');
var editLinkObj=MM_findObj('edit_link');
if(showvalue)
{
viewTableObj.className='hide';
editLinkObj.className='hide';
editTableObj.className='';
}
else
{
viewTableObj.className='tabletdgeneral';
editLinkObj.className='tableheader';
editTableObj.className='hide';
}
}
function validateTestMailServer(form)
{
var servername = form.MAIL_SERVER_NAME.value;
var serverport = form.MAIL_SERVER_PORT.value;
var acname     = form.MAIL_ACCOUNT_NAME.value;
var acpassword = form.MAIL_ACCOUNT_PASSWORD.value;
if( servername.length == 0 )
{
alert("Enter SMTP server name");
return "false";
}else if( serverport.length == 0 )
{
alert("Enter SMTP port");
return "false";
}
if( !isContainOnlyNumericValues(form.MAIL_SERVER_PORT,"Port") )
{
return "false";
}
if( acname.length != 0 && acpassword.length == 0 ||
acname.length == 0 && acpassword.length != 0 )
{
alert("Enter username & password");
return "false" ;
}
return "true";
} 
function validateMailForDuplication(newEmailAddress,selectComp) 
{
var existingEmails = selectComp.options;
for(var i=0;i<existingEmails.length;i++) 
{  
if(existingEmails[i].value == newEmailAddress.toLowerCase())
{  alert("This email ID already exists");
return false;
}
}
return true;
}
function validateUsedValues(selectComp)
{  
var select=selectComp.selectedIndex;
if(select!=-1)
{
var existingEmails = selectComp.options;
existingEmails[select] = null;
}
else
{
alert("Please select an Email Address to remove");
}
}
function populateOptions(targetComp,sourceComp)
{
var options = sourceComp.options;
for(var i=0;i<options.length;i++)
{
var newoption = new Option(options[i].value,options[i].value,true);
newoption.selected = true;
targetComp.options[i] = newoption;
}
}
function showHideComponent(componentId, isShow)
{
var showHideObjects = MM_findObj(componentId);
if(isShow == true)
{
showHideObjects.className = 'tablerowslight';
}
else
{
showHideObjects.className = 'hide';
}
}
function addValueInSelectComp(value,selectComp)
{
var existingValues = selectComp.options;
var rowLen = existingValues.length;
var newOption = new Option(value.toLowerCase(),value.toLowerCase());
existingValues[rowLen] = newOption;
}
function MM_findObj(n, d) { 
var p,i,x;  
if(!d) 
d=document; 
if((p=n.indexOf("?"))>0&&parent.frames.length) {
d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);
}
if(!(x=d[n])&&d.all) 
x=d.all[n]; 
for(i=0;!x&&i<d.forms.length;i++) 
x=d.forms[i][n];
for(i=0;!x&&d.layers&&i<d.layers.length;i++) 
x=MM_findObj(n,d.layers[i].document);
if(!x && d.getElementById) 
x=d.getElementById(n); 
return x;
}
