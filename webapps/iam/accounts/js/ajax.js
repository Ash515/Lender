// $Id: $
function AjaxResponse(json) {
	if (typeof json == "string") {
		json = $.parseJSON(json);
	}
	this.json = json;
	this.type = json[AjaxResponse.FIELDS.TYPE];
	this.error = json[AjaxResponse.FIELDS.ERROR];
	this.data = json[AjaxResponse.FIELDS.DATA];
}
AjaxResponse.FIELDS = {
	TYPE : "t", // No I18N
	ERROR : "error", // No I18N
	DATA : "data" // No I18N
};