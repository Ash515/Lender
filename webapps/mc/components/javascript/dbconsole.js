function validateValues()
{
var query = document.ExecuteQueryForm.query.value;
var firstSix = query.substring(0,6);
var firstFour = query.substring(0,4);
firstSix = firstSix.toLowerCase();
firstFour= firstFour.toLowerCase();
if(firstFour == "drop" || firstSix == "delete")
{
alert("Operation not permitted");
return false;
}
if((firstSix == "select" ||
firstSix == "insert" ||
firstSix == "update" ||
firstFour == "show" ||
firstFour == "desc"))
{
document.ExecuteQueryForm.execute.value = "true";
return true;
}
else
{
alert("Error in SQL syntax. Please check the query");
return false;
}
}
