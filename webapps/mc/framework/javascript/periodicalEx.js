PeriodicalExecuter.prototype.registerCallback = function() {
	this.intervalID = setInterval(this.onTimerEvent.bind(this), this.frequency);
}

PeriodicalExecuter.prototype.stop = function() {
	clearInterval(this.intervalID);
}