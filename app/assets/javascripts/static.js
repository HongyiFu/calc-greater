$(document).on('turbolinks:load', function(){
	$("#warning").hide();
	if ($('form[action="/compute-return"]').length) $('#calculator-tab').addClass('active');
	else $('#portfolio-tab').addClass('active');
});
