//$Id: $
(function($) {
	var params = Util.parseParameter(location.search);
	$.fn.zaResetPassword = function(options) {
		var args = null;
		if (!options || typeof options == "object") { // First Time
			args = [ $.extend(true, {}, $.fn.zaResetPassword.defaults, options) ];
			this.attr({
				novalidate : true,
				autocomplete : "off" // No I18N
			});
		}
		return this.form.apply(this, args || arguments);
	};
	// Default Values
	$.fn.zaResetPassword.defaults = {
		url : function() {
			return ZAConstants.contextpath + "/reset.ac"; // No I18N
		},
		params : {
			servicename : params.servicename,
			digest : params.digest,
			redirecturl:params.redirecturl
		},
		passwordStrength : "[name='password']", // No I18N
		success : function(data) {
			var ar = new AjaxResponse(data), f = this.element.get(0), $f = $(f);
			if (ar.data != null) {
				if (ar.data.password == "success") {
					$(".resetoutersection").hide();
					var url_val = ar.data.url || (window.location.protocol + "//" + window.location.hostname);
					var innerhtml = document.createElement('a');
					innerhtml.setAttribute('href', url_val);// No I18N
					innerhtml.setAttribute('target', '_top');// No I18N
					innerhtml.innerHTML=I18N.get('IAM.CONFIRMATION.CONTINUE');
					$(".successmsg").append(innerhtml);// No I18N
					$(".successmsg").show();
				} else {
					this.showErrors(I18N.get("IAM.ERROR.GENERAL"));// No I18N
				}
			} else if(ar.error && ar.error.password){
				var message = ar.error.password;
				this.showErrors(I18N.get(message));// No I18N
				this.element.find("[name='password'], [name='cpassword']").val("");
			} else if(ar.error && ar.error.msg){
				Form.Message.error($f, ar.error.msg);
			} else {
				Form.Message.error($f, I18N.get("IAM.ERROR.GENERAL")); // No I18N
			}
		},
		onsubmit : function() {
			var f = this.element.get(0);
			var passMessage = Validator.newPassword(f.password.value);
			if (passMessage) {
				Form.Message.error(f.password, passMessage);
				f.password.focus();
			} else if (f.password.value.trim() != f.cpassword.value.trim()) {
				this.hideErrors([ f.password ]);
				Form.Message.error(f.cpassword, I18N.get("IAM.ERROR.WRONG.CONFIRMPASS")); // No I18N
				f.cpassword.focus();
			} else {
				this.hideErrors([ f.password, f.cpassword ]);
				return true;
			}
			return false;
		}
	};
})(jQuery);