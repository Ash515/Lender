// $Id: $
// This file work standlone even without any dependencies like jQuery, common.js, etc., as this file is included in SignUp / SignIn pages (static-loader.jspf) before loading jQuery.
(function() {
	var ua = navigator.userAgent;
	var isIE = /msie/i.test(ua);
	if (!isIE) {
		return;
	}

	// HTML5 tags are consider as unknown tags in IE < 9, it won't apply CSS styles for unknown-tags. Hence, creating an element to make IE know about the tag names.
	var html5Tags = [ "article", "aside", "figure", "footer", "header", "hgroup", "menu", "nav", "section" ]; // No I18N
	for ( var i = 0, len = html5Tags.length; i < len; i++) {
		document.createElement(html5Tags[i]);
	}
	// Make it block level element, Default styles of HTML5 tags
	var docHead = document.head || document.getElementsByTagName("head")[0] || document.documentElement;
	var cssText = html5Tags.join() + "{display:block;}"; // No I18N

	var p = document.createElement("p");
	p.innerHTML = "p<style>" + cssText + "</style>"; // No I18N
	docHead.appendChild(p.lastChild);
})();