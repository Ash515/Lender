var get            = Ember.get;
var set            = Ember.set;
var computed       = Ember.computed;
var getWithDefault = Ember.getWithDefault;
var run            = Ember.run;
var on             = Ember.on;
var assert         = Ember.assert;
Ember.Application.initializer({
name: 'flash-messages',
initialize: function(container, application){
application.register('service:flash-messages', MC.FlashMessagesService, { singleton: false });
application.inject('controller', 'flashes', 'service:flash-messages');
application.inject('route', 'flashes', 'service:flash-messages');
application.inject('component', 'flashes', 'service:flash-messages');
}
});
MC.FlashMessagesService = Ember.Object.extend({
queue          : Ember.A([]),
isEmpty        : computed.equal('queue.length', 0),
defaultTimeout : 1000,
success: function(message, timeout) {
timeout = (timeout === undefined) ? get(this, 'defaultTimeout') : timeout;
return this._addToQueue(message, 'success', timeout);
},
info: function(message, timeout) {
timeout = (timeout === undefined) ? get(this, 'defaultTimeout') : timeout;
return this._addToQueue(message, 'info', timeout);
},
warning: function(message, timeout) {
timeout = (timeout === undefined) ? get(this, 'defaultTimeout') : timeout;
return this._addToQueue(message, 'warning', timeout);
},
danger: function(message, timeout) {
timeout = (timeout === undefined) ? get(this, 'defaultTimeout') : timeout;
return this._addToQueue(message, 'danger', timeout);
},
addMessage: function(message, type, timeout) {
type    = (type === undefined) ? 'info' : type;
timeout = (timeout === undefined) ? get(this, 'defaultTimeout') : timeout;
return this._addToQueue(message, type, timeout);
},
clearMessages: function() {
var flashes = get(this, 'queue');
flashes.clear();
return flashes;
},
_addToQueue: function(message, type, timeout) {
var flashes = get(this, 'queue');
var flash   = this._newFlashMessage(this, message, type, timeout);
flashes.pushObject(flash);
return flash;
},
_newFlashMessage: function(service, message, type, timeout) {
type    = (type === undefined) ? 'info' : type;
timeout = (timeout === undefined) ? get(this, 'defaultTimeout') : timeout;
Ember.assert('Must pass a valid flash service', service);
Ember.assert('Must pass a valid flash message', message);
return MC.FlashMessage.create({
type         : type,
message      : message,
timeout      : timeout,
flashService : service
});
}
});
MC.FlashMessage = Ember.Object.extend({
isSuccess      : computed.equal('type', 'success'),
isInfo         : computed.equal('type', 'info'),
isWarning      : computed.equal('type', 'warning'),
isDanger       : computed.equal('type', 'danger'),
defaultTimeout : computed.alias('flashService.defaultTimeout'),
queue          : computed.alias('flashService.queue'),
timer          : null,
destroyMessage: function() {
this._destroyMessage();
},
willDestroy: function() {
this._super();
var timer = get(this, 'timer');
if (timer) {
run.cancel(timer);
set(this, 'timer', null);
}
},
_destroyLater: function() {
var defaultTimeout = get(this, 'defaultTimeout');
var timeout        = getWithDefault(this, 'timeout', defaultTimeout);
var destroyTimer   = run.later(this, '_destroyMessage', timeout);
set(this, 'timer', destroyTimer);
}.on('init'),
_destroyMessage: function() {
var queue = get(this, 'queue');
if (queue) {
queue.removeObject(this);
}
this.destroy();
}
});
(function(){
MC.FlashMessageComponent = Ember.Component.extend({
classNames:        [ 'alert' ],
classNameBindings: [ 'alertType' ],
alertType : computed('flash.type', function() {
var flashType = get(this, 'flash.type');
return 'alert-' + flashType;
}),
click: function(event) {
if(jQuery(event.target).attr("class") === "close")
{
this._destroyFlashMessage();
}
},
_destroyFlashMessage: function() {
var flash = get(this, 'flash');
flash.destroyMessage();
}
});
Ember.Handlebars.helper('flash-message', MC.FlashMessageComponent);})();
