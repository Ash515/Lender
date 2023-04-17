//$Id: $
(function($) {
	var params = Util.parseParameter(location.search);
	$.fn.zaRejectInvitation = function(options) {
		var args = null;
		if (!options || typeof options == "object") { // First Time
			args = [ $.extend(true, {}, $.fn.zaRejectInvitation.defaults, options) ];
			this.attr({
				novalidate : true,
				autocomplete : "off" // No I18N
			});
		}
		return this.form.apply(this, args || arguments);
	};
	// Default Values
	$.fn.zaRejectInvitation.defaults = {
		url : function() {
			return ZAConstants.contextpath + "/rejectinvite.ac"; // No I18N
		},
		params : {
			servicename : params.servicename,
			digest : params.digest,
			redirecturl : params.redirecturl
		},
		success : function() {
			var ar = new AjaxResponse(data); // No I18N
			if (ar.error && !ar.error.msg) {
				Form.Message.error(I18N.get(ar.error)); // No I18N
			} else if (ar.data && ar.data.url) {
				$("#beforeclick").hide(); // No I18N
				$("#afterclick").show(); // No I18N
				$("#afterclick").children("a")[0].href = ar.data.url; // No I18N
			} else {
				Form.Message.error(this.element, I18N.get("IAM.ERROR.GENERAL")); // No I18N
			}
		}
	};
})(jQuery);