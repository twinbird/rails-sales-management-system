$(document).on('turbolinks:load', function() {
	$('#estimate_details').on('cocoon:after-insert', function(e, insertedItem) {
		$('.searchable').select2({
			language: 'ja'
		});
		$('.estimate-detail-quantity').on('change', calc_price);
		$('.estimate-detail-unit-price').on('change', calc_price);
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
	var calc_total_amount = function() {
		var amount = 0;
		$('.estimate-detail-price').each(function(index) {
			var txt_amount = $(this).val();
			amount += Number(txt_amount);
		});
		var tax_rate = $('#tax-rate').val();
		amount *= (Number(tax_rate) / 100) + 1;
		$('#total-amount').text(amount.toString(10));
	};
	var calc_price = function() {
		var rows = $('#estimate_details .nested-fields');
		rows.each(function(index) {
			var quantity = $(this).find('.estimate-detail-quantity').val();
			var unit_price = $(this).find('.estimate-detail-unit-price').val();
			var price = (Number(quantity) * Number(unit_price));
			$(this).find('.estimate-detail-price').val(price);
		});
		calc_total_amount();
	};
	$('#estimate_details').on('cocoon:after-insert', toggle_add_detail_button);
	$('#estimate_details').on('cocoon:after-insert', toggle_remove_detail_button);
	$('#estimate_details').on('cocoon:after-remove', toggle_add_detail_button);
	$('#estimate_details').on('cocoon:after-remove', toggle_remove_detail_button);
	$('#estimate_details').on('cocoon:after-insert', calc_total_amount);
	$('#estimate_details').on('cocoon:after-remove', calc_total_amount);
	$('#tax-rate').on('change', calc_total_amount);
	$('.estimate-detail-quantity').on('change', calc_price);
	$('.estimate-detail-unit-price').on('change', calc_price);
	$('.remove-detail-button').addClass('disabled');
	calc_total_amount();
});
