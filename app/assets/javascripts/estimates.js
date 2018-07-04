$(document).on('turbolinks:load', function() {
	$('#estimate_details').on('cocoon:after-insert', function(e, insertedItem) {
		$('.searchable').select2({
			language: 'ja'
		});
	});
	var toggle_add_detail_button = function(e, item) {
		if ($('#estimate_details .nested-fields').length >= 10) {
			$('#add-detail-btn').addClass('disabled');
		} else {
			$('#add-detail-btn').removeClass('disabled');
		}
	};
	var toggle_remove_detail_button = function(e, item) {
		if ($('#estimate_details .nested-fields').length <= 1) {
			$('.remove-detail-button').addClass('disabled');
		} else {
			$('.remove-detail-button').removeClass('disabled');
		}
	};
	$('#estimate_details').on('cocoon:after-insert', toggle_add_detail_button);
	$('#estimate_details').on('cocoon:after-insert', toggle_remove_detail_button);
	$('#estimate_details').on('cocoon:after-remove', toggle_add_detail_button);
	$('#estimate_details').on('cocoon:after-remove', toggle_remove_detail_button);
	$('.remove-detail-button').addClass('disabled');
});
