$(document).on('turbolinks:load', function() {
	$('#estimate_details').on('cocoon:after-insert', function(e, insertedItem) {
		$('.searchable').select2({
			language: 'ja'
		});
	});
})
