//$Id: $
(function($) {
	var params = Util.parseParameter(location.search);
	$.fn.zaAddPassword = function(options) {
		var args = null;
		if (!options || typeof options == "object") { // First Time
			args = [ $.extend(true, {}, $.fn.zaAddPassword.defaults, options) ];
			this.attr({
				novalidate : true,
				autocomplete : "off" // No I18N
			});
		}
		return this.form.apply(this, args || arguments);
	};

	$.fn.zaAddPassword.defaults = {
		url : function() {
			return ZAConstants.contextpath + "/addpass.ac"; // No I18N
		},
		params : {
			is_ajax : true,
			servicename : params.servicename,
			digest : params.digest,
			serviceurl : params.serviceurl,
			language : params.language	
		},
		passwordStrength : "[name='password']", // No I18N
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
				if(f.submit) {
					f.submit.disabled = true;
				}
				return true;
			}
			return false;
		},
		success : function(data) {
			var ar = new AjaxResponse(data), f = this.element.get(0), $f = $(f);
			if (ar.data && ar.data.url) {
				window.top.location.href = ar.data.url;
			} else if(ar.error && ar.error.msg) {
				Form.Message.error($f, I18N.get(ar.error.msg));
			} else {
				Form.Message.error($f, I18N.get("IAM.ERROR.GENERAL")); // No I18N
			}
		},
		error : function(data) {
			var ar = new AjaxResponse(data), f = this.element.get(0), $f = $(f);
			if(ar.json.responseJSON.error && ar.json.responseJSON.error.msg) {
				Form.Message.error($f, I18N.get(ar.json.responseJSON.error.msg));
			} 	
		}
	};
})(jQuery);