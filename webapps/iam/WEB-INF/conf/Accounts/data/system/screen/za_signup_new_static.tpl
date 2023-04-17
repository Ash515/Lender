${za.config.js_content}
var docHead = document.head || document.getElementsByTagName("head" )[0] || document.documentElement;
window.userPasswordMinLen = '8'; 
window.userPasswordMaxLen = '254';
var zaConstants = ${zaConstants};
window.ZACountryCodeDetails = ${country_code_details};
window.ZADefaultCountry = '${default_country_code}';
window.ZACountryStateDetails = ${country_state_details};
window.loadCountryOptions = false;
<#if (('${load_country}')?has_content)>
	window.loadCountryOptions = "${load_country}";
</#if>
window.zdtdomain='${zdtdomainUrl}';
function zaOnLoadHandler() {
	var cssURLs,jsURLs;
	<#if (('${cssURLs}')?has_content)>
		cssURLs = "${cssURLs}";		
	</#if>
	<#if (('${jsURLs}')?has_content)>
		jsURLs = "${jsURLs}";		
	</#if>
	// Include CSS
	if(cssURLs) {
		cssURLs = cssURLs.split(","); 
		for(var i = 0, len = cssURLs.length; i < len; i++) {
			var style = document.createElement("link"); 
			style.href = zaConstants.css_url + cssURLs[i]; 
			style.rel = "stylesheet"; 
			docHead.appendChild(style); 
		}
	}
	
	// Synchronously Include Scripts
	if(jsURLs) {
		jsURLs = jsURLs.split(","); 
		var scriptIdx = 0; 
		(function _jsOnLoad() {
			if (scriptIdx == jsURLs.length) { // Last script, all scripts were loaded. So, call the users handler.  
				onZAScriptLoad();
			} else {
				var jsURL = jsURLs[scriptIdx++]; 
				if((jsURL.indexOf("jquery-1.12.2.min.js") != -1 && window.jQuery)||(jsURL.indexOf("common.js") != -1 && window.I18N)||(jsURL.indexOf("signin.min.js") != -1 && window.I18N)) { // Don't include jQuery, If it is already included in the page.
					 _jsOnLoad(); 
				} else { 
					if(jsURL.indexOf('http') != 0) { // is Relative URL ? 
						jsURL = zaConstants.js_url + jsURL; 
					}
					includeScript(jsURL, _jsOnLoad); 
				}
			}
		})();
	}
};

function includeScript(url, callback) {
	var script = document.createElement("script"); 
	script.src = url; 
	if (callback) { 
		script.onload = script.onreadystatechange = function() { 
			if (!this.readyState || this.readyState === "loaded" || this.readyState === "complete") {
				callback(); 
				script.onload = script.onreadystatechange = null; // To avoid calling repeatedly in IE 
			}
		};
	}
	docHead.appendChild(script); 
};

if(document.readyState == "complete") { // Call the handler if DOM already loaded.
	zaOnLoadHandler(); 
} else { 
	// Should not use `window.onload` as it might be overridden by service team  
	if (window.addEventListener) {
	  window.addEventListener('load', zaOnLoadHandler, false);  
	} else if (window.attachEvent)  { 
	  window.attachEvent('onload', zaOnLoadHandler); 
	}
}
function onZAScriptLoad() {
	Validator.addDefaultMethods();
	Util.redirectToHTTPS();
	Util.paramConfigure({ 
			"_sh" : "header,footer"
	});
	ZAConstants.load(zaConstants);
	I18N.load(${i18nArray});
	window.NewsLetterSubscriptionMode = JSON.parse('${newsletter_subscription_mode}');
		window.PasswordPolicyInfo = JSON.parse('${zaPasswordPolicy}');
		Util.includeJSON2();
		var zaSignUpOptions = $.fn.zaSignUp.defaults;  
		$.extend(true, zaSignUpOptions, { 
			x_signup : ${signUpConfig} 
		}); 
		var appserviceurl = zaSignUpOptions.x_signup.service_url;
		appserviceurl = appserviceurl.split("?")[0];
		var urlpathArray = appserviceurl.split( '/' );
		var urlProtocol = urlpathArray[0];
		var urlHost = urlpathArray[2];
		var appURL = urlProtocol + '//'+urlHost;
		CrossServiceRequest.appURLs[zaSignUpOptions.x_signup.service_name] = appURL;
		if(window.onSignupReady) {
			window.onSignupReady(); 
			var $email = document.getElementById("firstname"); 
			if($email){
				$email.focus(); 
			}
	 	}
	 	window.onbeforeunload = unloadpopup; 
		   function unloadpopup(){ 
	 	      if(formvalidated){ 
		         return "Signup in progress"; 
	 	      }
		   }
}