$(document).on('turbolinks:load', function() {
	$('#estimate_details').on('cocoon:after-insert', function(e, insertedItem) {
		$('.searchable').select2({
			language: 'ja'
		});
	});
	var toggle_add_detail_button = function(e, item) {
		if ($('#estimate_details .nested-fields').length >= 10) {
			$('#add-detail-btn').hide();
		} else {
			$('#add-detail-btn').show();
		}
	};
	$('#estimate_details').on('cocoon:after-insert', toggle_add_detail_button);
	$('#estimate_details').on('cocoon:after-remove', toggle_add_detail_button);
})
