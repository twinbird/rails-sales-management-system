module OrdersHelper
  def submitted_order_message(order)
    if order.submitted_flag
      t('orders.helper.submitted')
    else
      t('orders.helper.unsubmitted')
    end
  end
end
