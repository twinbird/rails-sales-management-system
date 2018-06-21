class EarningsController < ApplicationController
  before_action :authenticate_user!
  before_action :initialized_user!
  before_action :set_earning, only: [:show, :edit, :update, :destroy]
  before_action :set_orders

  # GET /earnings
  # GET /earnings.json
  def index
    @earnings = current_user_company.earnings.search(params[:query]).order(created_at: :desc).paginate(page: params[:page], per_page: 20)
  end

  # GET /earnings/1
  # GET /earnings/1.json
  def show
  end

  # GET /earnings/new
  def new
    @earning = current_user_company.earnings.build
  end

  # GET /earnings/1/edit
  def edit
  end

  # POST /earnings
  # POST /earnings.json
  def create
    @earning = current_user_company.earnings.build(earning_params)

    respond_to do |format|
      if @earning.save
        format.html { redirect_to @earning, notice: t('.earning_was_successfully_created') }
        format.json { render :show, status: :created, location: @earning }
      else
        format.html { render :new }
        format.json { render json: @earning.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /earnings/1
  # PATCH/PUT /earnings/1.json
  def update
    respond_to do |format|
      if @earning.update(earning_params)
        format.html { redirect_to @earning, notice: t('.earning_was_successfully_updated') }
        format.json { render :show, status: :ok, location: @earning }
      else
        format.html { render :edit }
        format.json { render json: @earning.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /earnings/1
  # DELETE /earnings/1.json
  def destroy
    @earning.destroy
    respond_to do |format|
      format.html { redirect_to earnings_url, notice: t('.earning_was_successfully_destroyed') }
      format.json { head :no_content }
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_earning
      @earning = current_user_company.earnings.find(params[:id])
    end

    def set_orders
      @orders = current_user_company.orders
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def earning_params
      params.require(:earning).permit(:company_information_id, :order_id, :occur_date, :amount)
    end
end
