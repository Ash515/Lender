//$Id: $
(function($) {
	var params = Util.parseParameter(location.search);
	$.fn.zaConfirmation = function(options) {
		var args = null;
		if (!options || typeof options == "object") { // First Time
			args = [ $.extend(true, {}, $.fn.zaConfirmation.defaults, options) ];
			this.attr({
				novalidate : true,
				autocomplete : "off" // No I18N
			});
		}
		return this.form.apply(this, args || arguments);
	};
	// Default Values
	$.fn.zaConfirmation.defaults = {
		url : function() {
			return ZAConstants.contextpath + "/secureconfirm.ac"; // No I18N
		},
		params : {
			servicename : params.servicename,
			digest : params.digest
		},
		success : function(data) {
			var ar;
			try {
				ar = new AjaxResponse(data);
			}catch (e) {
				if(data.trim() == "URL_ROLLING_THROTTLES_LIMIT_EXCEEDED") {
					Form.Message.error(this.element.get(0), I18N.get("IAM.REGISTER.REMOTE.IP.LOCKED")); // No I18N
					return false;
				}
			}
			var f = this.element.get(0), $f = $(f);
			if (ar.data && ar.data.result) {
				if (ar.data.result.trim() == "success") {
					$("#confirmpassword").hide();
					$("#msgboard").show();
				} else {
					Form.Message.error($f, I18N.get("IAM.ERROR.GENERAL")); // No I18N
				}
			} else if(ar.error && ar.error.msg){
				Form.Message.error($f, ar.error.msg);
			} else {
				Form.Message.error($f, I18N.get("IAM.ERROR.GENERAL")); // No I18N
			}
		},
		onsubmit : function() {
			var f = this.element.get(0);
			if (!Validator.isValid(f.password.value)) {
				Form.Message.error(f, I18N.get("IAM.ERROR.ENTER.LOGINPASS")); //No I18N
				f.password.focus();
			} else {
				Form.Message.hideError(f);
				return true;
			}
			return false;
		}
	};
})(jQuery);
function hideMsg(t){
	var f = $(document.confirmationform).get(0);
	Form.Message.hideError(f);
}