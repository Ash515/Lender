/*
	A history Javascript object 
	Licenses:
	(c) Creative Commons 2006
	http://creativecommons.org/licenses/by-sa/2.5/		
	
	Free to use with my prior permission
	Author: Kevin Hoang Le | http://pragmaticobjects.org
	Date: 2006-08-16
	
	Credits: 
	1. Adapted from Hash Listener 1.0 by Erik Arvidsson
	2. With concepts and some code snippets by Brad Neuberg's dhtmlHistory.js
	   a. checkIE function is copied from Brad Neuberg's dhtmlHistory's isInternetExplorer function
	   b. removeHash is copied from Brad Neuberg's dhtmlHistory's removeHash
	   c. sessionExists is from Brad Neuberg's article: http://codinginparadise.org/weblog/2005/08/ajax-tutorial-saving-session-across.html
	
	Version 0.8: Initial release
*/

//<script type="text/javascript">

var historyStack = Class.create();
historyStack.prototype = {
	isIE : true,
	isOpera : true,
	pe : 0,
	interval : 1,
	current : 0,
	ieFrameLiteral : "historyFrame",
	ieFrame : 0,	
	histVarName : "",
	protocol : 0,

	checkIE : function() {
		var userAgent = navigator.userAgent.toLowerCase();
		if (document.all && userAgent.indexOf('msie')!=-1) {
			return true;
		}
		else {
			return false;
		}
	},
	checkOpera : function() {
		var userAgent = navigator.userAgent.toLowerCase();
		if(userAgent.indexOf("opera")!=-1){
			var versionindex=userAgent.indexOf("opera")+6;
			if (parseInt(userAgent.charAt(versionindex))>=8) {
				return true;
			}
			else
				return false;	
		} else
			return false;
	},
	initialize : function(histVarName, protocol) {
		this.isIE = this.checkIE();
		this.isOpera = this.checkOpera();
		this.protocol = protocol;
		if (this.isIE) {
			this.histVarName = histVarName;
			this.ieFrame = document.createElement("iframe");
			this.ieFrame.id = this.ieFrameLiteral;
			this.ieFrame.style.display = "none";
			if (this.protocol == "https") this.ieFrame.src = "stupidIE.html";		
			if (document.body.firstChild) 
				document.body.insertBefore(this.ieFrame, document.body.firstChild);
			else
				document.body.appendChild(this.ieFrame);
		}
		this.pe = new PeriodicalExecuter(this.getUrl.bind(this), this.interval);		
	},
	put : function(s) {
		if (this.isIE) {
			this.writeFrame(s);			
		}

		this.pe.stop();
		document.location.hash = s;
		this.current = s;
		this.pe = new PeriodicalExecuter(this.getUrl.bind(this), this.interval);
	},
	get : function() {
		return document.location.hash;
	},
	getUrl : function() {
		var h = this.removeHash(document.location.hash);
		if (h != this.current) {
			this.current = h;
			this.onBrowserAddressChanged();
		}
	},
	onBrowserAddressChanged : function () {
	},
	removeHash: function(hashValue) {
		if (hashValue == null || hashValue == undefined)
			return null;
		else if (hashValue == "")
			return "";
		else if (hashValue.length == 1 && hashValue.charAt(0) == "#")
			return "";
		else if (hashValue.length > 1 && hashValue.charAt(0) == "#")
			return hashValue.substring(1);
		else
			return hashValue;
	},
	writeFrame:	function (s) {
		var f = $(this.ieFrameLiteral);
		var d = f.contentDocument || f.contentWindow.document;
		var str = "<script>window._hash = '" + s + "'; window.onload = parent." + this.histVarName + ".syncHash;<\/script>";
		var state = "session";
		d.open();
		d.write(str);
		d.write(state);
		d.close();
	},
	syncHash:	function () {
		var s = this._hash;
		if (s != document.location.hash) {
			document.location.hash = s;
		}
	},
	sessionExists : function() {		
		var f = $(this.ieFrameLiteral);
		var doc = f.contentDocument || f.contentWindow.document;		
		try {
			if (doc.body.innerHTML == "")
				return false;
			else
				return true;
		}
		catch (exp) {
			// sometimes an exception is thrown if a 
			// value is already in the iframe
			return true;
		}		
	}
};

//</script>
