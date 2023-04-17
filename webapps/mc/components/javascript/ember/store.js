store = new function() {
this.get=function(key){
return localStorage.getItem(key);
}
this.set=function(key,value){
localStorage.setItem(key,value);
}
this.remove = function(key) {
localStorage.removeItem(key);
}
this.hasProperty = function(key){
return localStorage.hasOwnProperty(key);
}
this.clear = function(){
localStorage.clear();
}
}
