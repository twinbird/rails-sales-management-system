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
	var set_payment_term_from_customer = function() {
		var payment_term = $('#estimate_payment_term').val();
		if (payment_term !== '') {
			return;
		}
		var customer_id = $('#estimate_customer_id').val();
		$.ajax({
			url:"/customers/" + customer_id + ".json",
			type:"get"
		}).done((data) => {
			$('#estimate_payment_term').val(data.payment_term);
		});
	};
	var set_title_and_customer_from_prospect_id = function() {
		var customer_id = $('#estimate_customer_id').val();
		var title = $('#estimate_title').val();
		if (customer_id !== '' && title !== '') {
			return;
		}
		var prospect_id = $('#estimate_prospect_id').val();
		$.ajax({
			url:"/prospects/" + prospect_id + ".json",
			type:"get"
		}).done((data) => {
			// title
			$('#estimate_title').val(data.title);
			// customer
			var $customer_id_tag = $('#estimate_customer_id').select2({language: 'ja'});
			$customer_id_tag.val(data.customer_id).trigger('change');
		});
	};
	var set_product_name_and_default_price_from_product_id = function() {
		var product_id = $(this).val();
		var $product_tag = $(this);
		$.ajax({
			url:"/products/" + product_id + ".json",
			type:"get"
		}).done((data) => {
			var $tr = $product_tag.closest('tr');
			var $product_name = $tr.find('.product-name');
			var $default_price = $tr.find('.default-price');
			$product_name.val(data.name);
			$default_price.val(data.default_price);
		});
	};
	var attach_detail_display_order = function() {
		$('.estimate-detail-display-order').each(function(index) {
			$(this).val(index+1);
		});
		return true;
	};
	var attach_detail_change_event = function() {
		$('.product-select').on('change', set_product_name_and_default_price_from_product_id);
	};
	var change_due_date_pending_button = function() {
		var disabled = $('#estimate_due_date').prop('disabled');
		set_due_date_disabled(!disabled);
	};
	var set_due_date_disabled = function(disabled) {
		if (disabled === true) {
			$('#estimate_due_date').val('');
			$('#estimate_due_date').prop('disabled', true);
		} else {
			$('#estimate_due_date').prop('disabled', false);
		}
	};

	$('#estimate_details').on('cocoon:after-insert', toggle_add_detail_button);
	$('#estimate_details').on('cocoon:after-insert', toggle_remove_detail_button);
	$('#estimate_details').on('cocoon:after-remove', toggle_add_detail_button);
	$('#estimate_details').on('cocoon:after-remove', toggle_remove_detail_button);
	$('#estimate_details').on('cocoon:after-insert', calc_total_amount);
	$('#estimate_details').on('cocoon:after-remove', calc_total_amount);
	$('#estimate_details').on('cocoon:after-insert', attach_detail_change_event);
	$('#estimate_customer_id').on('change', set_payment_term_from_customer);
	$('#estimate_prospect_id').on('change', set_title_and_customer_from_prospect_id);
	$('#tax-rate').on('change', calc_total_amount);
	$('.estimate-detail-quantity').on('change', calc_price);
	$('.estimate-detail-unit-price').on('change', calc_price);
	$('.remove-detail-button').addClass('disabled');
	$('#estimate-submit-form').on('submit', attach_detail_display_order);
	$('#estimate_due_date_pending_flag').on('change', change_due_date_pending_button);
	calc_total_amount();
	attach_detail_change_event();

	var disabled = $('#estimate_due_date_pending_flag').val();
	set_due_date_disabled(disabled);
});
