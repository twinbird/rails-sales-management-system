class DeliverySlipsController < ApplicationController
  before_action :authenticate_user!
  before_action :initialized_user!
  before_action :set_delivery_slip, only: [:show, :edit, :update, :destroy]
  before_action :set_orders
  before_action :set_user_profiles

  # GET /delivery_slips
  # GET /delivery_slips.json
  def index
    @delivery_slips = current_user_company.delivery_slips.search(params[:query]).order(:created_at).paginate(page: params[:page], per_page: 20)
    @query = params[:query]
  end

  # GET /delivery_slips/1
  # GET /delivery_slips/1.json
  def show
  end

  # GET /delivery_slips/new
  def new
    @delivery_slip = current_user_company.delivery_slips.build
    @order_details = []
    @order_details = @delivery_slip.order.order_details if @delivery_slip&.order&.order_details
  end

  # GET /delivery_slips/1/edit
  def edit
  end

  # POST /delivery_slips
  # POST /delivery_slips.json
  def create
    @delivery_slip = current_user_company.delivery_slips.build(delivery_slip_params)
    @order_details = []
    @order_details = @delivery_slip.order.order_details if @delivery_slip&.order&.order_details

    respond_to do |format|
      if @delivery_slip.save
        format.html { redirect_to @delivery_slip, notice: t('.delivery_slip_was_successfully_created') }
        format.json { render :show, status: :created, location: @delivery_slip }
      else
        format.html { render :new }
        format.json { render json: @delivery_slip.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /delivery_slips/1
  # PATCH/PUT /delivery_slips/1.json
  def update
    respond_to do |format|
      if @delivery_slip.update(delivery_slip_params)
        format.html { redirect_to @delivery_slip, notice: t('.delivery_slip_was_successfully_updated') }
        format.json { render :show, status: :ok, location: @delivery_slip }
      else
        format.html { render :edit }
        format.json { render json: @delivery_slip.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /delivery_slips/1
  # DELETE /delivery_slips/1.json
  def destroy
    @delivery_slip.destroy
    respond_to do |format|
      format.html { redirect_to delivery_slips_url, notice: t('.delivery_slip_was_successfully_destroyed') }
      format.json { head :no_content }
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_delivery_slip
      @delivery_slip = DeliverySlip.find_by(id: params[:id], company_information: current_user_company)
      @order_details = []
      @order_details = @delivery_slip.order.order_details if @delivery_slip&.order&.order_details
    end

    def set_orders
      @orders = current_user_company.orders
    end

    def set_user_profiles
      @user_profiles = current_user_company.user_profiles
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def delivery_slip_params
      params.require(:delivery_slip).permit(:company_information_id, :order_id, :delivery_date, :remarks, :tax_rate, :submitted_flag, :user_profile_id, delivery_slip_details_attributes: [:id, :_destroy, :display_order, :order_detail_id])
    end
end
