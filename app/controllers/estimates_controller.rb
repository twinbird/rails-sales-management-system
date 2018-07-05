class EstimatesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_estimate, only: [:show, :edit, :update, :destroy]
  before_action :set_users
  before_action :set_customers
  before_action :set_prospects
  before_action :set_products

  # GET /estimates
  # GET /estimates.json
  def index
    @estimates = current_user_company.estimates.search(params[:query]).order(created_at: :desc).paginate(page: params[:page], per_page: 20)
    @query = params[:query]
  end

  # GET /estimates/1
  # GET /estimates/1.json
  def show
  end

  # GET /estimates/new
  def new
    @estimate = current_user_company.estimates.build
    @estimate.estimate_details.build
  end

  # GET /estimates/1/edit
  def edit
  end

  # POST /estimates
  # POST /estimates.json
  def create
    @estimate = current_user_company.estimates.build(estimate_params)

    respond_to do |format|
      if @estimate.save
        format.html { redirect_to @estimate, notice: t('.estimate_was_successfully_created') }
        format.json { render :show, status: :created, location: @estimate }
      else
        format.html { render :new }
        format.json { render json: @estimate.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /estimates/1
  # PATCH/PUT /estimates/1.json
  def update
    respond_to do |format|
      if @estimate.update(estimate_params)
        format.html { redirect_to @estimate, notice: t('.estimate_was_successfully_updated') }
        format.json { render :show, status: :ok, location: @estimate }
      else
        format.html { render :edit }
        format.json { render json: @estimate.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /estimates/1
  # DELETE /estimates/1.json
  def destroy
    @estimate.destroy
    respond_to do |format|
      format.html { redirect_to estimates_url, notice: t('.estimate_was_successfully_destroyed') }
      format.json { head :no_content }
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_estimate
      @estimate = Estimate.find_by(id: params[:id], company_information: current_user_company)
    end

    def set_users
      @users = current_user_company.user_profiles
    end

    def set_customers
      @customers = current_user_company.customers
    end

    def set_prospects
      @prospects = current_user_company.prospects
    end

    def set_products
      @products = current_user_company.products
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def estimate_params
      params.require(:estimate).permit(:company_information_id, :prospect_id, :title, :customer_id, :customer_name, :estimate_no, :issue_date, :due_date, :due_date_pending_flag, :payment_term, :effective_date, :tax_rate, :remarks, :user_profile_id, :submitted_flag, :ordered_flag, estimate_details_attributes: [:id, :_destroy, :display_order, :product_id, :product_name, :quantity, :unit_price])
    end
end
