jQuery("body").on('mouseenter', function() {
jQuery(".btn-group > .btn").click(function() {
var selected = jQuery(this)[0];
jQuery(".btn-group > .btn").each(function() {
(this.innerText == selected.innerText) ? jQuery(this).addClass("active"): jQuery(this).removeClass("active");
});
});
});
Handlebars.registerHelper('accordionView', function(arg, options) {
return "href=#" + arg.data.view.content.viewName;
});
jQuery(document).ready(function() {
jQuery(window).resize(function() {
var bodyheight = $(window).height();
jQuery(".verticalTab").height(bodyheight);
}); 
});
jQuery(window).click(function(event){
if(jQuery(event.target).attr("class") !== "renderMenuPopup")
{
jQuery(".menu").hide();
}
});
