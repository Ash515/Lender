<%-- $Id: $ --%>
<%@taglib prefix="s" uri="/struts-tags" %>
(function() { <%-- No I18N --%>
	window.zdtdomain='${zdtdomainUrl}';<%-- No I18N --%>
	<%@include file="../../jspf/static-loader.jspf" %>
	function onZAScriptLoad() {
		<s:if test="isSigninSignup">
			Validator.addDefaultMethods(); <%-- No I18N --%>
		</s:if> <%-- No I18N --%>
		Util.redirectToHTTPS(); <%-- No I18N --%>

		Util.paramConfigure({ <%-- No I18N --%>
			"_sh" : "header,footer" <%-- No I18N --%>
		});

		ZAConstants.load(zaConstants); <%-- No I18N --%>
		
		I18N.load(${i18nArray}); <%-- No I18N --%>
		
		window.NewsLetterSubscriptionMode = JSON.parse('${newsletter_subscription_mode}');<%-- No I18N --%>
		window.PasswordPolicyInfo = JSON.parse('${zaPasswordPolicy}');<%-- No I18N --%>
		
		Util.includeJSON2(); <%-- No I18N --%> 
		var zaSignUpOptions = $.fn.zaSignUp.defaults;  <%-- No I18N --%>
		$.extend(true, zaSignUpOptions, { <%-- No I18N --%>
			x_signup : ${signUpConfig} <%-- No I18N --%>
		}); 
		CrossServiceRequest.appURLs[zaSignUpOptions.x_signup.appName] = zaSignUpOptions.x_signup.appURL; <%-- No I18N --%>
		<s:if test="isValidInvitation">
		$.extend($.fn.zaSignUp.defaults, {url : function() { <%-- No I18N --%>
				return ZAConstants.getAbsoluteURL("/accounts/registerbyinvite.ac?digest=${digest}"); // No I18N
			},
			handleConfirmation : function(data) { <%-- No I18N --%>
				$(".za-confirm").hide(); <%-- No I18N --%>
				data.doAction(); <%-- No I18N --%>
			}, 
			csrf : true, <%-- No I18N --%>
			crossdomain : false <%-- No I18N --%>
		});
		</s:if> <%-- No I18N --%>
		<s:else><%-- No I18N --%>
    		$(".za-invitation-desc").hide();<%-- No I18N --%>
		</s:else><%-- No I18N --%>
		// Service teams must definie `onSignupReady` function to initialize SignUp form.
		if(window.onSignupReady) {
			window.onSignupReady(); <%-- No I18N --%>
			var $email = document.getElementById("firstname"); <%-- No I18N --%>
			if($email){
				$email.focus(); <%-- No I18N --%>
			}
	 	}
	    window.onbeforeunload = unloadpopup; <%-- No I18N --%>
		   function unloadpopup(){ <%-- No I18N --%>
	 	      if(formvalidated){ <%-- No I18N --%>
		         return "Signup in progress"; <%-- No I18N --%>
	 	      }
		   }
	}
})();