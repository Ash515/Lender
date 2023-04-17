App.AjaxTreeComponent = Ember.Component.extend({
didInsertElement: function() {
var viewName = this.get("viewName");
var leftContainerStatus = this.get("leftContainerStatus");
var isAdmin = this.get("isAdmin");
var isPassAdmin = this.get("isPassAdmin");
var isNotSlave = this.get("isNotSlave");
var landingServerId = this.get("landingServerId");
var isGlobalTree = this.get("isGlobalTree");
var self = this;
var js_tree = {
"core": { 
"data": { 
"url": function(node) { 
var userId = node.id;
if (userId.charAt(0) === '0') { 
userId = userId.substr(1);
}
var nodeId = node.id;
return node.data === userId ? '/jsp/home/ajaxtree/AjaxTreeParent.jsp?VIEW_NAME=' + viewName + '&LANDINGSERVERID=' + landingServerId + '&USERID=' + userId : '/jsp/home/ajaxtree/AjaxTreeParent.jsp?VIEW_NAME=' + viewName + '&LANDINGSERVERID=' + landingServerId + '&USERID='; 
},
"data": function(node) { 
var userId = node.id;
if (userId.charAt(0) === '0') { 
userId = userId.substr(1);
}
if (node.data === userId) {
var id = "0"; 
return {
"id": id
}; 
} else {
return {
"id": node.id
}; 
}
}
},
"multiple": true, 
"themes": {
"dots": false
} 
}
};
if ((isAdmin == "true" || isPassAdmin == "true") && isNotSlave == "true" && viewName != "SHOWTREEVIEW") 
{ 
js_tree.core.crrm = {
"input_width_limit": 2000
}; 
js_tree.core.check_callback = function(operation, node, node_parent, node_position, more) {
if (operation === 'move_node') { 
if (node.parent === node_parent.id) {
return false;
} else if (node_position != 0) {
return false;
} else if ((node_parent.type === "node" || node_parent.type === "resourcegroup") && (node.type === "resource" || node.type === "node")) {
return {
after: false,
before: false,
inside: true
}
} else {
return false;
}
}
};
js_tree.contextmenu = {
"items": customMenu, 
"select_node": false, 
"seperator_after": true, 
"seperator_before": false 
};
js_tree.rules = {
"createat": "top"
}; 
if (isGlobalTree == "true") 
{
js_tree.dnd = { 'check_while_dragging': true	}; 
js_tree.types = { 
"predefined": { 
"draggable": false 
},
"resourcegroup": { 
"draggable": false 
},
"foreignresource": { 
"draggable": false 
},
"resource": { 
"draggable": true 
},
"node": { 
"draggable": true, 
"select_node": false, 
"hover_node": false 
}
};
js_tree.plugins = ["themes", "core", "contextmenu", "crrm", "dnd", "types"]; 
self.$().on("hover_node.jstree", function(e, node) { 
var url = node.node.data;
if (url != "node" || (node.node.type != "foreignresource" && viewName == "SHOWTREEVIEW")) {
return;
}
self.$().jstree(true).dehover_node(node.node); 
});
self.$().on("select_node.jstree", function(e, node) {
var url = node.node.data;
if ((node.node.type == "foreignresource" && (viewName == "ResourceTabView" || viewName == "LSResAssociationView")) || (url == "node")) {
self.$().jstree(true).deselect_node(node.node); 
} else if (url != "node") {
myCreateNode(node, viewName, leftContainerStatus, true);
}
});
} 
else 
{
jstree.plugins = ["themes", "core", "contextmenu", "crrm", "types"]; 
self.$().on("hover_node.jstree", function(e, node) { 
var url = node.node.data;
if (url == "node") {
self.$().jstree(true).dehover_node(node.node); 
}
});
self.$().on("select_node.jstree", function(e, node) {
var url = node.node.data;
if (url != "node") {
myCreateNode(node, viewName, leftContainerStatus, true);
} else {
self.$().jstree(true).deselect_node(node.node); 
}
});
}
self.$().on('create_node.jstree', function(e, data) { 
jQuery.get('?operation=create_node', {
'id': data.node.id,
'parent': data.node.parent,
'position': data.position,
'text': data.node.text,
'type': data.node.type
}) 
.done(function(d) {})
.fail(function() {
data.instance.refresh();
});
});
self.$().on('rename_node.jstree', function(e, data) { 
id = renameNode(data);
jQuery.get('?operation=rename_node', {
'id': data.node.id,
'text': data.text
}) 
.done(function(d) {
if (id != null) {
data.instance.set_id(data.node, id);
data.instance.set_type(data.node, "node"); 
} else {
data.instance.refresh_node(data.node.parent);
}
})
.fail(function() {
data.instance.refresh();
});
});
self.$().on('move_node.jstree', function(e, data) { 
moveNode(data);
jQuery.get('?operation=move_node', {
'id': data.node.id,
'parent': data.parent,
'position': data.position
}) 
.done(function(d) {})
.fail(function() {
data.instance.refresh();
});
});
self.$().on('delete_node.jstree', function(e, data) { 
deleteNode(data);
jQuery.get('?operation=delete_node', {
'id': data.node.id
}) 
.done(function(d) {})
.fail(function() {
data.instance.refresh();
});
});
} 
else 
{
js_tree.plugins = ["themes", "core"]; 
self.$().on("hover_node.jstree", function(e, node) { 
self.$().jstree(true).dehover_node(node.node); 
});
if (viewName != "SHOWTREEVIEW") {
self.$().on("select_node.jstree", function(e, node) {
var url = node.node.data;
if (url != "node") {
myCreateNode(node, viewName, leftContainerStatus, false);
}
});
} else {
self.$().on("select_node.jstree", function(e, node) { 
self.$().jstree(true).deselect_node(node.node); 
});
self.$().on("hover_node.jstree", function(e, node) { 
self.$().jstree(true).dehover_node(node.node); 
});
}
}
}
});
