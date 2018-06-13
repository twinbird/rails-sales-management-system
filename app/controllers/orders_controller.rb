class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :initialized_user!
  before_action :set_order, only: [:show, :edit, :update, :destroy]
  before_action :set_products
  before_action :set_estimates
  before_action :set_prospects
  before_action :set_user_profiles
  before_action :set_customers

  # GET /orders
  # GET /orders.json
  def index
    @orders = current_user_company.orders.search(params[:query]).order(created_at: :desc).paginate(page: params[:page], per_page: 20)
    @query = params[:query]
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
  end

  # GET /orders/new
  def new
    @order = current_user_company.orders.build
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders
  # POST /orders.json
  def create
    @order = current_user_company.orders.build(order_params)

    respond_to do |format|
      if @order.save
        format.html { redirect_to @order, notice: t('.order_was_successfully_created') }
        format.json { render :show, status: :created, location: @order }
      else
        format.html { render :new }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to @order, notice: t('.order_was_successfully_updated') }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url, notice: t('.order_was_successfully_destroyed') }
      format.json { head :no_content }
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find_by(id: params[:id], company_information: current_user_company)
    end

    def set_products
      @products = current_user_company.products
    end

    def set_prospects
      @prospects = current_user_company.prospects
    end

    def set_estimates
      return @estimates = current_user_company.estimates if params[:order].blank?
      return @estimates = current_user_company.estimates if params[:order][:prospect_id].blank?

      @estimates = current_user_company.estimates.where(prospect_id: params[:order][:prospect_id])
    end

    def set_customers
      @customers = current_user_company.customers
    end

    def set_user_profiles
      @user_profiles = current_user_company.user_profiles
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:order).permit(:company_information_id, :prospect_id, :estimate_id, :title, :customer_id, :customer_name, :order_no, :issue_date, :due_date, :payment_term, :tax_rate, :remarks, :user_profile_id, :submitted_flag, order_details_attributes: [:id, :_destroy, :display_order, :product_id, :product_name, :quantity, :unit_price])
    end
end
