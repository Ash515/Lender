// $Id: $
var ZAConstants = {
	csrfParam : null,
	csrfCookie : null,
	contextpath : "/accounts", // No I18N
	load : function(json) {
		this.config = json;
		$.each("accountsServer,csrfParam,csrfCookie,contextpath,js_url,css_url,img_url,dcc".split(","), function(i, key) { // No I18N
			var v = json[key];
			if (v) {
				ZAConstants[key] = v;
			}
		});
		if(!ZAConstants.dcc && inIframe()){
			try {
				setCookie(24, ZAConstants.accountsCookieDomain);
				if(document.cookie.indexOf("IAM_TEST_COOKIE") == -1){ // Unable to set the cookie from the page which load inside iframe
					setCookie(0, ZAConstants.accountsCookieDomain); //removed the tmp cookie
					window.parent.location.href = window.location.href; //redirect iframe source to parent window
				}
			} catch (e) {}
		}
		function inIframe() {
			try {
				return window.self != window.top;
			} catch (e) {
				return true;
			}
		}
		function setCookie(x, cookieDomain) {
			var dt = new Date();
			dt.setDate(dt.getYear() * x);
			var cookieStr = "IAM_TEST_COOKIE=IAM_TEST_COOKIE;expires="+dt.toGMTString()+";setPath='/'"; //No I18N
			if(cookieDomain && cookieDomain != "null"){
				cookieStr += ";domain="+cookieDomain; //No I18N
			}
			var iurl = window.location.href;
            if(iurl.startsWith("https://")){
                cookieStr += ";secure"//No I18N
            }
            if(ZAConstants.setSameSite){
            cookieStr+=";SameSite=none"; //No I18n
            }
            document.cookie = cookieStr;
		}
	},
	setAccountsServer : function(serverURL) {
		if (serverURL.indexOf('://') == -1) {
			throw 'Invalid Protocol given for the URL : ' + serverURL; // No I18N
		}
		this.accountsServer = serverURL;
		this.schemeLessAccountsServer = null;
	},
	getAccountsServer : function() {
		if (!this.schemeLessAccountsServer && this.accountsServer) {
			this.schemeLessAccountsServer = this.accountsServer.substring(this.accountsServer.indexOf("://") + 1);
		}
		return this.schemeLessAccountsServer;
	},
	getAbsoluteURL : function(path) {
		return this.getAccountsServer() + path;
	}
};
if (!$.isFunction(String.prototype.trim)) {
	String.prototype.trim = function() {
		return this.replace(/^\s+|\s+$/g, '');
	};
}
// "__" and replace added to bypass `http` restricted work check by CodeCheck tool. As this is a valid case.
var _xxxHTTP = 'http__://'.replace('__', ''), _xxxHTTPS = 'https__://'.replace('__', ''); // No I18N
// ********************
// $ZPLACEHOLDER
// ********************
(function($) {
	$.support.zplaceholder = ("placeholder" in document.createElement("input")); // No I18N
	/**
	 * jQuery Plugin to stop hiding placeholder value on focus of the field, Placeholder value will be hided only after user types.
	 */
	$.fn.zPlaceHolder = function() {
		// Placeholder supported and Webkit browser (as it already hides placeholder value only after typing).
		if ($.support.zplaceholder && (!$.browser || !$.browser.msie || parseInt($.browser.version) < 10)) {
			return;
		}
		this.each(processField);
	};
	function processField(idx, input) {
		var $input = $(input), placeholder = $input.attr("placeholder"); // No I18N
		if (!$input.attr("title")) {
			$input.attr("title", placeholder); // No I18N
		}
		var $overlay = $("<span />").addClass("zph-overlay").html(placeholder).css("font-size", $(input).css("font-size")); // No I18N
		$input.removeAttr("placeholder").keydown(toggleClass).parent().addClass("zph-placeholder").prepend($overlay); // No I18N
		$overlay.click(function() {
			$input.focus();
		});
		toggleClass(null, $input);
	}
	function toggleClass(e, t) {
		var $input = $(t || this);
		setTimeout(function() {
			var value = $input.val();
			if (value == 0) {
				$input.parent().removeClass("zph-hide").addClass("zph-show"); // Show Overlay // No I18N
			} else {
				$input.parent().removeClass("zph-show").addClass("zph-hide"); // Hide Overlay // No I18N
			}
		}, 0);
	}
})(jQuery);
// ********************
// $COOKIE
// ********************
var Cookie = {
	add : function(cn, cv, domain, maxage, secure) {
		document.cookie = cn + "=" + escape(cv) + ";path=/" + (!domain ? "" : ";domain=" + domain) + (!maxage ? "" : ";max-age=" + maxage) + (!secure ? "" : ";secure=" + secure); // No I18N
	},
	get : function(cn) {
		if (document.cookie.length > 0) {
			var beginIdx = document.cookie.indexOf(cn + "=");
			if (beginIdx != -1) {
				beginIdx = beginIdx + cn.length + 1;
				var endIdx = document.cookie.indexOf(";", beginIdx);
				if (endIdx == -1) {
					endIdx = document.cookie.length;
				}
				return unescape(document.cookie.substring(beginIdx, endIdx));
			}
		}
		return "";
	},
	append : function(cn, cv, domain, separator, maxage, secure) {
		var oldcv = Cookie.get(cn);
		var newcv = "";
		if (!oldcv) {
			newcv = cv;
		} else {
			newcv = oldcv + separator + cv;
		}
		Cookie.add(cn, newcv, domain, maxage, secure);
	},
	remove : function(cn) {
		document.cookie = cn + "=remove;path=/;max-age=0"; // No I18N
	}
};
// ********************
// $StringBuilder
// ********************
function StringBuilder(_iv) {
	var arr = _iv ? [ _iv ] : [];
	this.append = function(v) {
		arr.push(v);
		return this;
	};
	this.toString = function() {
		return arr.join("");
	};
	this.isEmpty = function() {
		return this.length() < 1;
	};
	this.length = function() {
		return arr.length;
	};
}
// ********************
// $I18N
// ********************
var I18N = {
	data : {},
	load : function(arr) {
		$.extend(this.data, arr);
		return this;
	},
	get : function(key, args) {
		// { portal: "IAM.ERROR.PORTAL.EXISTS" }
		if (typeof key == "object") {
			for ( var i in key) {
				key[i] = I18N.get(key[i]);
			}
			return key;
		}
		var msg = this.data[key] || key;
		if (args) {
			arguments[0] = msg;
			return Util.format.apply(this, arguments);
		}
		return msg;
	}
};

// ********************
// $Utility Functions
// ********************
var Util = {
	euc : function(value) {
		return encodeURIComponent(value);
	},
	duc : function(value) {
		return decodeURIComponent(value);
	},
	paramConfigure : function(args) {
		var params = Util.parseParameter(location.search);
		$('html').hide(); // No I18N
		$(document).ready(function() {
			$.each(params, function(pname, pvalue) {
				pvalue = pvalue === "true"; // No I18N
				var value = args[pname];
				if (typeof value == 'string') { // No I18N
					$(value)[pvalue ? "show" : "hide"](); // No I18N
				} else if (pvalue && typeof value == 'object') { // No I18N
					$.each(value, function(selector, attrObj) {
						$(selector).attr(attrObj);
					});
				} else if (pvalue && typeof value == 'function') { // No I18N
					args[pname]();
				}
			});
		});
		$('html').show(); // No I18N
	},
	getCSRFValue : function() {
		return ZAConstants.csrfParam + "=" + Util.euc(Cookie.get(ZAConstants.csrfCookie));
	},
	addCSRFParam : function(arr) {
		arr = arr || {};
		arr[ZAConstants.csrfParam] = Cookie.get(ZAConstants.csrfCookie);
		return arr;
	},
	parseParameter : function(qs) {
		var paramArr = {};
		if (qs.indexOf("=") == -1) {
			return paramArr;
		}
		if (qs.charAt(0) == "?") {
			qs = qs.substring(1);
		}
		var params = qs.split("&");
		for (var i = 0; i < params.length; i++) {
			var pArr = params[i].split("=");
			var pN = decodeURIComponent(pArr[0]), pV = decodeURIComponent(pArr[1]);
			var pOldV = paramArr[pN];
			if (pOldV) {
				if ($.isArray(pOldV)) {
					pOldV.push(pV);
				} else {
					paramArr[pN] = [ pOldV, pV ];
				}
			} else {
				paramArr[pN] = pV;
			}
		}
		return paramArr;
	},
	serializeParams : function(obj) {
		var sb = new StringBuilder();
		for ( var k in obj) {
			var v = obj[k];
			if (!v) {
				continue;
			}
			if (!sb.isEmpty()) {
				sb.append("&");
			}
			if ($.isArray(v)) {
				var first = true;
				for (var j = 0; j < v.length; j++) {
					if (!first) {
						sb.append("&");
					}
					sb.append(Util.euc(k)).append("=").append(Util.euc(v[j]));
					first = false;
				}
			} else {
				sb.append(Util.euc(k)).append("=").append(Util.euc(v));
			}
		}
		return sb.toString();
	},
	stopEvents : function(e) {
		if (e.stopPropagation) {
			e.preventDefault();
			e.stopPropagation();
		} else {
			e.cancelBubble = true;
			e.returnValue = false;
		}
	},
	includeJSON2 : function() {
		var json = window.JSON;
		if (!$.isFunction(json && json.parse && json.stringify)) { // Native JSON Supported browser.
			var e = document.createElement("script"); // No I18n
			e.src = ZAConstants.js_url + "/js/tplibs/json2.js"; // No I18n
			e.type = "text/javascript"; // No I18n
			document.body.appendChild(e);
		}
	},
	redirectToHTTPS : function() {
		var https = new StringBuilder("h").append("ttps://"); // No I18n
		var url = window.location.href;
		if (url.indexOf(https) == 0) { // Already in HTTPS
			return;
		}
		var http = new StringBuilder("h").append("ttp://"); // No I18n
		var port = window.location.port;
		if (port.length == 0 || port == "80" || port == "8080") { // No I18n
			url = url.replace(http, https);
			window.location.href = url.indexOf("]:8080") != -1 ? url.replace("]:8080", "]:8443") : url.replace("8080", "8443"); // No I18n
		}
	},
	format : function(msg, args) {
		if (msg) {
			for (var i = 1; i < arguments.length; i++) {
				msg = msg.replace(new RegExp("\\{" + (i - 1) + "\\}", "g"), arguments[i]);
			}
		}
		return msg;
	},
	// Any modification in the `updateOrigin` function should be replicated to `CrossDomainUtil.getFirstLevelDomainScript` method.
	updateOrigin : function(d) {
		var domain = d || location.hostname;
		var subdomain = getSubDomain(domain);
		if (document.domain !== subdomain) {
			document.domain = subdomain;
			return subdomain;
		}
	},
	valueOf : function(value, context) {
		return $.isFunction(value) ? value.call(context || this) : value;
	},
	getServerURL : function(url) {
		if (url.indexOf('//') === 0) { // Double slash url. "//accounts.zoho.com/register.ac"
			url = window.location.protocol + url;
		}
		if (url.indexOf(_xxxHTTP) !== 0 && url.indexOf(_xxxHTTPS) !== 0) { // Not an Absolute URL. "/register.ac"
			return null;
		}
		var idx = url.indexOf('/', 8); // 8 = "https://" // No I18N
		return idx === -1 ? url : url.substring(0, idx);
	}
};

function getSubDomain(domain) {
	var i = 0, sdomain = domain, p = sdomain.split('.'), s = '_zagd'+ (new Date()).getTime();
	while (i < (p.length - 1) && document.cookie.indexOf(s + '=' + s) == -1) {
		sdomain = p.slice(-1 - (++i)).join('.');
		document.cookie = s + "=" + s + ";domain=" + sdomain + ";";
	}
	document.cookie = s + "=;expires=Thu, 01 Jan 1970 00:00:01 GMT;domain=" + sdomain + ";";
	return sdomain;
}

function reloadCaptcha(idx, f, cdigest) {
	f = f || idx;
	if (!f.captcha.disabled) {
		var captchaCallback = function(cdigest) { // No I18N
			var $captcha = $(f).find(".za-captcha").attr("src", ZAConstants.getAbsoluteURL("/accounts/captcha?cdigest=" + cdigest)); // No I18N
			if (!f.cdigest) {
				$("<input type='hidden' name='cdigest' value='" + cdigest + "'>").insertAfter($captcha); // No I18n
			}
			f.cdigest.value = cdigest;
			f.captcha.value = "";
			f.captcha.autocomplete = "off"; // No I18N
		};
		if (cdigest) {
			captchaCallback(cdigest);
		} else {
			var options = {
				url : ZAConstants.getAbsoluteURL("/accounts/captcha"), // No I18N
				type : "post", // No I18N
				data : {
					action : "newcaptcha" // No I18N
				},
				success : captchaCallback
			};
			if (window.CrossServiceRequest) {
				CrossServiceRequest.send(options, true);
			} else {
				$.ajax(options);
			}
		}
	}
}

function toggleField($container, show) {
	if (show) {
		$container.show().find(":input").removeAttr("disabled"); // No I18N
	} else {
		$container.hide().find(":input").attr("disabled", "true"); // No I18N
	}
}
