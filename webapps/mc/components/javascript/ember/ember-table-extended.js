(function() {
Ember.LazyContainerView.reopen({
viewportDidChange: Ember.observer(function() {
var clength, content, numShownViews, startIndex;
content = this.get('content') || [];
clength = content.get('length');
numShownViews = Math.min(this.get('length'), clength);
var old_start_index = this.get('startIndex');
startIndex = this.get('startIndex');
if (startIndex + numShownViews >= clength) {
startIndex = clength - numShownViews;
}
if (startIndex < 0) {
startIndex = 0;
}
var tableComponent = this.get("tableComponent");
if (tableComponent.get("isScrollTable") && (startIndex < old_start_index) && tableComponent.get("tableViewController.currentActionName") !== "sort") {
tableComponent.sendAction("scroll");
}
return this.forEach(function(childView, i) {
var item, itemIndex;
if (i >= numShownViews) {
childView = this.objectAt(i);
childView.set('content', null);
return;
}
itemIndex = startIndex + i;
childView = this.objectAt(itemIndex % numShownViews);
item = content.objectAt(itemIndex);
if (item !== childView.get('content')) {
childView.teardownContent();
childView.set('itemIndex', itemIndex);
childView.set('content', item);
return childView.prepareContent();
}
}, this);
}, 'content.length', 'length', 'startIndex')
});
Ember.Table.BodyTableContainer.reopen({
onScroll: function(event) {
this.get("tableComponent.tableViewController").clearAllPopups();
this.get("tableComponent.tableViewController").set("currentActionName", "scroll");
this.set('scrollTop', event.target.scrollTop);
return event.preventDefault();
}
});
window.Ember.MouseWheelHandlerMixin.reopen({
didInsertElement: function() {}
});
window.Ember.Table.EmberTableComponent.reopen({
init: function() {
try
{
this._super();	
}
catch(e){}
}
});
window.Ember.Table.ShowHorizontalScrollMixin.reopen({
mouseEnter: function(event) {
var $tablesContainer = Ember.$(event.target).parents('.ember-table-tables-container');
var $horizontalScroll = $tablesContainer.find('.antiscroll-scrollbar-horizontal');
var innerWidth = $tablesContainer.find(".antiscroll-inner").get(1).clientWidth;
var panelWidth = $tablesContainer.find(".ember-table-scroll-panel").get(0).clientWidth;
if(innerWidth < panelWidth)
{
$horizontalScroll.addClass('antiscroll-scrollbar-shown');
}
}
});
})();
