<%-- $Id: $ --%>
(function() { <%-- No I18N --%>
	<%@include file="../../jspf/static-loader.jspf" %>
	function onZAScriptLoad() {
		Util.redirectToHTTPS(); <%-- No I18N --%>
		
		Util.paramConfigure({ <%-- No I18N --%>
			"_sh" : "header,footer", <%-- No I18N --%>
			"_embed" : { <%-- No I18N --%>
				".signinoutersection" : { <%-- No I18N --%>
					style : "width: 100%;" <%-- No I18N --%>
				}
			}
		});

		ZAConstants.load(zaConstants); <%-- No I18N --%>
		
		var zaSignInOptions = $.fn.zaSignIn.defaults; <%-- No I18N --%>
		$.extend(true, zaSignInOptions, {  <%-- No I18N --%>
			x_signin : ${signInConfig} <%-- No I18N --%>
		});
		
		// Service teams must definie `onSignupReady` function to initialize SignUp form.
		if(window.onSigninReady) {
			window.onSigninReady(); <%-- No I18N --%>
		}
	}
})();