(function(){
MC.TabViewComponent = Ember.Component.extend(MC.AjaxApiMixin, {
tagName: "",
selectedView: "",
init: function() {
this._super.apply(this, arguments);
if (this.get("tempName")) {
this.set("layoutName", this.get("tempName"));
this.rerender();
}
if (this.get("viewName")) {
this.setTabModel();
this.setSelectedView();
}
},
constructTemplate: function() {
var tabs = this.get("tabModel.tabs");
var routerName = this.get("tabModel.routerName");
var template = "";
if (tabs) {
for (i = 0; i < tabs.length; i++) {
template = template + '<li class="childTab"><a data-toggle="tab" href="/' + routerName + '/' + tabs[i].name + '" >' + tabs[i].title + '</a></li>';
}
}
this.set("layout", Ember.Handlebars.compile(template));
},
setTabModel: function() {
var viewName = this.get("viewName");
var self = this;
if (viewName) {
this.sendRequest({
url: viewName + ".ec",
target: "tabModel"
});
}
},
setSelectedView: function() {
var selectedView = this.get("tabModel.selectedView");
if (selectedView) {
this.set("selectedView", selectedView);
}
}.observes("tabModel.@each"),
actions: {
switchTab: function(tabName) {
this.set("selectedView", tabName);
}
}
});
Ember.Handlebars.helper('tab-view', MC.TabViewComponent);})();
