/*
	Extension of prototype's Element object
	Licenses:
	(c) Creative Commons 2006
	http://creativecommons.org/licenses/by-sa/2.5/		
	
	Free to use with my prior permission
	Author: Kevin Hoang Le | http://pragmaticobjects.org
	Date: 2006-06-30
*/

Element.Ex = {
  removeAllChildren: function(element) {
    while ($(element).firstChild)
		$(element).removeChild($(element).firstChild);
  }
}

Object.extend(Element, Element.Ex);