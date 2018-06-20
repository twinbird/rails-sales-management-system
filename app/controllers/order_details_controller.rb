class OrderDetailsController < ApplicationController
  before_action :authenticate_user!
  before_action :initialized_user!

  def show
    @order_details = current_user_company.orders.find(params[:id]).order_details
    respond_to do |format|
      format.json { render json: @order_details.select(:id, :display_order, :product_name) }
    end
  end

end
