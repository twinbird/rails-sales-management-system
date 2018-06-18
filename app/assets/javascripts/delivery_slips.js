$(document).on('turbolinks:load', function() {
	replaceSelectOptions = function($select, results) {
		$select.html('<option>');
		$.each(results, function() {
			var option = $('<option>').val(this.id).text(this.product_name);
			$select.append(option);
		});
	};

	replaceOrderDetailOptions = function(orderSelect, detailSelect) {
		detailPath = orderSelect.find('option:selected').data().detailPath;
		if(detailPath) {
			$.ajax({
				url:detailPath,
				detaType:"json",
			}).done(function(results) {
				replaceSelectOptions(detailSelect, results);
			}).fail(function() {
				alert('通信エラーが発生しました');
			});
		}
	};

	replaceAllOrderDetailOptions = function() {
		detailPath = $(this).find('option:selected').data().detailPath;
		$selectDetails = $('.delivery_slip_detail');
		if(detailPath) {
			$.ajax({
				url:detailPath,
				detaType:"json",
			}).done(function(results) {
				$.each($selectDetails, function() {
					replaceSelectOptions($(this), results);
				});
			}).fail(function() {
				alert('通信エラーが発生しました');
			});
		}
	};

	$('#delivery_slip_order_id').on('change', replaceAllOrderDetailOptions);
	$('#delivery_slip_details').on('cocoon:after-insert', function(e, insertedItem) {
		var orderSelect = $('#delivery_slip_order_id');
		replaceOrderDetailOptions(orderSelect, $(insertedItem).find('select'));
	});
});
