(function(){
MC.PaginationViewComponent = Ember.Component.extend({
selectedPage : null,
viewChanged: function() {
this.set('layoutName',this.get('layoutName'));
this.rerender();
var navigConfig = this.get("navigConfig");
if (navigConfig) {
var navigType = navigConfig.type;
if (Ember.isEqual(navigType, "SELECT")) {
var pageList = navigConfig.pageList;
this.set("selectedPage", pageList.filterBy("pageNo", navigConfig.currentPage)[0]);
}
}
}.on("init").observes("layoutName","navigConfig.currentPage"),
selectPage: function() {
var selectedPage = this.get("selectedPage");
if (selectedPage && (selectedPage.pageNo != this.get("navigConfig.currentPage"))) 
{
this.sendAction("setPage", selectedPage.pageNo);
}
}.observes('selectedPage'),
change: function(event) {
if (Ember.isEqual(jQuery(event.target).attr("class"), "SliderRange")) {
this.sendAction("setPage", event.target.value);
}
},
actions: {
firstPage: function() {
this.sendAction('firstPage');
},
prevPage: function() {
this.sendAction('previousPage');
},
nextPage: function() {
this.sendAction('nextPage');
},
lastPage: function() {
this.sendAction('lastPage');
},
setPage: function(index) {
this.sendAction("setPage", index);
},
setPageLength: function(length) {
this.sendAction('setPageLength', length);
},
getCount : function()
{
this.sendAction('getCount');	
}
}
});
Ember.Handlebars.helper('pagination-view', MC.PaginationViewComponent);})();
