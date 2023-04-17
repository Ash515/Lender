function replaceUndefinedOrNull(key, value) {
if (!value) {
return undefined;
}
return value;
}
function getUniqueId(variable) {
if (variable == null) {
return null;
}
if(isNaN(variable)){
return variable;
}
return referenceIds[variable];
}
function StateData(uniqueId) {
this.uniqueId = uniqueId;
StateData._STATE_MGR[uniqueId]=this;
this.get=function(key) {
if (this.hasProperty(key)){
var value=store.get(uniqueId+"_"+key);
return (value.startsWith('{') || value.startsWith('['))?JSON.parse(value):value;
}
return null;
}
this.remove=function(key) {
store.remove(uniqueId+"_"+key);
}
this.set=function(key, value) {
typeof value === "string" ? store.set(uniqueId+"_"+key, value) : store.set(uniqueId+"_"+key, JSON.stringify(value));
}
this.hasProperty=function(key){
return store.hasProperty(uniqueId+"_"+key);
}
this.getAllStates=function() {
var state = {};
if (this.hasProperty("searchReq")) {
state = jQuery.extend(state, this.get("searchReq"));
}
if (this.hasProperty("sortReq")) {
state = jQuery.extend(state, this.get("sortReq"));
}
if (this.hasProperty("navigReq")) {
state = jQuery.extend(state, this.get("navigReq"));
}
if (this.hasProperty("colChooserReq")) {
state.colChooserReq = this.get("colChooserReq");
}
if (this.hasProperty("rowSelectionReq")) {
state._RS = this.get("rowSelectionReq");
}
if (this.hasProperty("filterConfigReq")) {
var filterConfigReq = this.get("filterConfigReq");
state.SELFILTER = filterConfigReq.filterName;
}
if (this.hasProperty("columnResizeReq")) {
state.columnResizeReq = JSON.stringify(this.get("columnResizeReq"));
}
return jQuery.param(state);
}
this.removeAllStates=function() {
this.remove("searchReq");
this.remove("sortReq");
this.remove("navigReq");
this.remove("colChooserReq");
this.remove("rowSelectionReq");
this.remove("filterConfigReq");
this.remove("columnResizeReq");
this.remove("selectedRowIndices");
}
this.getSelectedRowIndices = function(key) {
if (store.hasProperty(uniqueId + "_"+key)) {
var rows = store.get(uniqueId + "_"+key).replace('[', '').replace(']', '').split(',');
if (rows.toString().length > 0) {
return rows;
}
return Ember.A();
}
return Ember.A();
}
this.addSelectedRowIndex=function(key, pkcol){
var selectedRows = this.getSelectedRowIndices(key);
if (!Ember.isEmpty(selectedRows)) {
if (selectedRows.indexOf(pkcol + "") == -1) {
selectedRows.pushObject(pkcol);
}
} else {
selectedRows.pushObject(pkcol);
}
this.setSelectedRowIndices(key, selectedRows);
}
this.removeSelectedRowIndex=function(key, pkcol){
var selectedRows = this.getSelectedRowIndices(key);
if (!Ember.isEmpty(selectedRows)) {
if (selectedRows.indexOf(pkcol+"") > -1) {
selectedRows.removeObject(pkcol+"");
this.setSelectedRowIndices(key, selectedRows);
}
}
}
this.isRowSelected=function(index, key){
var selectedRows = this.getSelectedRowIndices(key);
if (!Ember.isNone(selectedRows) && selectedRows.length > 0) {
return selectedRows.indexOf(index + "") > -1;
}
return false;
}
this.setSelectedRowIndices=function(key, selectedRows){
if (!Ember.isNone(selectedRows)) {
store.set(uniqueId + "_"+key, selectedRows);
}
}
this.addSelectedRowIndexList=function(key, list){
var selectedRows = this.getSelectedRowIndices(key);
if (!Ember.isEmpty(selectedRows)) 
{
for(i=0;i<list.length;i++)
{
var index = list[i];
if (selectedRows.indexOf(index + "") == -1)
{
selectedRows.pushObject(index);
}
}
} else {
selectedRows = list;
}
this.setSelectedRowIndices(key, selectedRows);
}
this.removeSelectedRowIndexList=function(key, list){
var selectedRows = this.getSelectedRowIndices(key);
if (!Ember.isEmpty(selectedRows)) {
var isSelectedRowsModified = false;
for(i=0;i<list.length;i++)
{
var index = list[i];
if (selectedRows.indexOf(index+"") > -1) {
selectedRows.removeObject(index+"");
isSelectedRowsModified = true;
}
}
if(isSelectedRowsModified)
{
this.setSelectedRowIndices(key, selectedRows);
}
}
}
}
StateData._STATE_MGR={};
StateData.getInstance = function(srcViewRefId) {
return new StateData(srcViewRefId);
}
