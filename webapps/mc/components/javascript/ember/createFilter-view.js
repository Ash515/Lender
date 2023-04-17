(function(){
MC.CreateFilterViewComponent = Ember.Component.extend({
comparator: {},
selComparator: {},
isSelect: false,
isDate: false,
criteriaValue: {},
selCriteriaValue: "",
TYPE : "",
layoutName : "components/createFilter-view",
init: function() {
this._super.apply(this, arguments);
this.beginPropertyChanges();
this.setComparator(this.get("customFilterConfig")[0]);
this.endPropertyChanges();
},
setComparator: function(selColumn) 
{
var allComparator = getAllComparators();
if(!selColumn || !selColumn.COLNAME)
{
this.set("selectedCriteriaValue", null);
}
var selectedColumn = this.get("selectedColumn") || selColumn;
if(!selectedColumn)
{
selectedColumn = this.get("customFilterConfig")[0];
if(!selectedColumn)
{
return;
}
}
var type = selectedColumn.TYPE;
var comparator = allComparator.filterBy("TYPE", type)[0];
this.set("comparator", comparator);
if (!this.get("selectedComparator")) {
this.set("selComparator", comparator.OPTION[0]);
} else {
var index = parseInt(this.get("selectedComparator"));
this.set("selComparator", comparator.OPTION.filterBy("val", index)[0]);
}
var allowedValues = selectedColumn.allowedValues;
if (type.indexOf("DATE") > -1) {
this.set("isDate", true);
jQuery('body').on('click', "[id^=datetimepicker]", function() {});
jQuery('body').on('mouseenter', "[id^=datetimepicker]", function() {});
} else {
this.set("isDate", false);
}
if (allowedValues) 
{
this.set("criteriaValue", allowedValues);
this.set("isSelect", true);
if (!this.get("selectedCriteriaValue")) {
var self = this;
Ember.run.later(function() {
self.set("selCriteriaValue", allowedValues[0]);	
});
} else {
this.set("selCriteriaValue", this.get("selectedCriteriaValue"));
}
} 
else 
{
this.set("isSelect", false);
this.set("TYPE", type);
if (!this.get("selectedCriteriaValue")) {
this.set("selCriteriaValue", "");
} else {
this.set("selCriteriaValue", this.get("selectedCriteriaValue"));
}
}
}.observes("selectedColumn"),
hasRemoveOption: function() {
return this.get("index") != 1;
}.property(),
actions: {
removeCriteria: function(index) {
this.sendAction("remove", index);
}
}
});
Ember.Handlebars.helper('createFilter-view', MC.CreateFilterViewComponent);})();
