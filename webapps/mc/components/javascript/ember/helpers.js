Ember.Handlebars.helper('icon', function(value, options) {
if(!value || !value.icon)
{
return;
}
var val = "<img src='"+value.icon+"'";
if(value.icontitle){val += " title="+value.icontitle;}
if(value.iconCss){val += " class="+value.iconCss;}
val += " />";
return new Ember.Handlebars.SafeString(val);
});
Ember.Handlebars.helper('displayText', function(obj, options) {
if(!obj)
{
return;
}
if(!obj.value)
{
return new Ember.Handlebars.SafeString(obj);
}
var value = obj.value;
if(obj.css)
{
value = "<span class='"+obj.css+"'>"+obj.value+"</span>";
}
return new Ember.Handlebars.SafeString(value);
});
Ember.Handlebars.helper('search-row', function(value, options) {
if(!value)
{
return;
}
var cellObj = value;
var val = "<input ";
val += "type='" + cellObj.type + "' "; 
if(cellObj.type === "date")
{
val += "format='" + cellObj.format +"' "; 
}
val += "class='" + cellObj.class +"' "; 
val += "sqlType='" + cellObj.sqlType +"' "; 
val += "columnName='" + cellObj.columnName +"' "; 
val += "name='" + cellObj.name +"' "; 
val += "placeholder='" + cellObj.placeholder +"' "; 
val += "value='" + cellObj.searchVal +"' "; 
val += "{{action '" + cellObj.action + "'}}"; 
val += " />"
return new Ember.Handlebars.SafeString(val);
});
Ember.Handlebars.helper('adv-search-row', function(value, options) {
var cellObj = value;
if(!cellObj || !cellObj.options)
{
return;
}
var val = "<select class='"+cellObj.class+"' name='"+cellObj.name+"' "+cellObj.event+">";
var option = "";
cellObj.options.forEach(function(opt) {
option = option + "<option ";
if (opt.selected) {
option = option + "selected=\"selected\"";
}
option = option + " value = \"" + opt.value + "::" + opt.criteria + "\">" + opt.criteria + "</option>";
});
val = val + option + "</select>";
return new Ember.Handlebars.SafeString(val);
});
Ember.Handlebars.helper('prefix-suffix-link', function(value, options) {
var cellObj = value;
if(!cellObj)
{
return;
}
var val = "<a target='_blank' href="+cellObj.href;
if(cellObj.css){val += " class="+cellObj.css;}
val += " >"+cellObj.value + "</a>";
return new Ember.Handlebars.SafeString(val);
});
Ember.Handlebars.helper('val', function(value, options) {
var cellObj = value;
if(!cellObj || !cellObj.value)
{
return;
}
var val = "";
if(cellObj.autoLink)
{
val = "<a target='_blank' href="+cellObj.link;
if(cellObj.linkId){val += " id="+linkId;}
if(cellObj.linkTitle){val += " title="+linkTitle;}
if(cellObj.invokeStyle){val += " class="+invokeStyle;}
val += ">";
}
if(cellObj.tooltipValue)
{
if(cellObj.tooltipDisplayer === "showMessageOnTextMouseOver")
{
val += "<span class='Tooltipster' trigger='hover' title='"+cellObj.tooltipValue+"'>";
}
else if(cellObj.tooltipDisplayer === "defaultTrimmedMessageDisplayer")
{
val += "<span class='Tooltipster' trigger='click' title='"+cellObj.tooltipValue+"'>";
}
}
if(cellObj.replaceIcon){
val += "<img src='"+cellObj.replaceIcon+"' />";
}
else
{
if(cellObj.cssClass)
{
val += "<span class='"+cellObj.cssClass+"'>"+cellObj.value+"</span>";
}
else
{
val += cellObj.value;	
}
}
if(cellObj.tooltipValue)
{
if(cellObj.tooltipDisplayer === "showTrimmedMessageOnImageClick")
{
val += " <img src=\"themes/wifi/images/pulldown_big.gif\" class=\"Tooltipster\" title=\"" + cellObj.tooltipValue + "\" trigger=\"click\"/>";
}
else if(cellObj.tooltipDisplayer === "showTrimmedMessageOnMouseOver")
{
val += " <img src=\"themes/wifi/images/pulldown_big.gif\" class=\"Tooltipster\" title=\"" + cellObj.tooltipValue + "\" trigger=\"hover\"/>";
}
else
{
val += "</span>";
}
}
if(cellObj.autoLink)
{
val += "</a>";
}
return new Ember.Handlebars.SafeString(val);
});
Ember.Handlebars.helper('suffixIcon', function(value, options) {
if(!value || !value.suffixIcon)
{
return;
}
var val = "<img src='"+value.suffixIcon+"'";
if(value.sicontitle){val += " title="+value.sicontitle;}
if(value.suffixIconCss){val += " class="+value.suffixIconCss;}
val += " />";
return new Ember.Handlebars.SafeString(val);
});
