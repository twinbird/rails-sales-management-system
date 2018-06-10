class ProspectsController < ApplicationController
  before_action :authenticate_user!
  before_action :initialized_user!
  before_action :set_prospect, only: [:show, :edit, :update, :destroy]
  before_action :set_customers, only: [:new, :edit, :create, :update]
  before_action :set_users, only: [:new, :edit, :create, :update]

  # GET /prospects
  # GET /prospects.json
  def index
    @prospects = current_user_company.prospects.order(:updated_at).paginate(page: params[:page])
  end

  # GET /prospects/1
  # GET /prospects/1.json
  def show
  end

  # GET /prospects/new
  def new
    @prospect = current_user_company.prospects.build
  end

  # GET /prospects/1/edit
  def edit
  end

  # POST /prospects
  # POST /prospects.json
  def create
    @prospect = current_user_company.prospects.build(prospect_params)

    respond_to do |format|
      if @prospect.save
        format.html { redirect_to @prospect, notice: t('.prospect_was_successfully_created') }
        format.json { render :show, status: :created, location: @prospect }
      else
        format.html { render :new }
        format.json { render json: @prospect.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /prospects/1
  # PATCH/PUT /prospects/1.json
  def update
    respond_to do |format|
      if @prospect.update(prospect_params)
        format.html { redirect_to @prospect, notice: t('.prospect_was_successfully_updated') }
        format.json { render :show, status: :ok, location: @prospect }
      else
        format.html { render :edit }
        format.json { render json: @prospect.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /prospects/1
  # DELETE /prospects/1.json
  def destroy
    @prospect.destroy
    respond_to do |format|
      format.html { redirect_to prospects_url, notice: t('.prospect_was_successfully_destroyed') }
      format.json { head :no_content }
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_prospect
      @prospect = Prospect.find_by(id: params[:id], company_information: current_user_company)
    end

    def set_customers
      @customers = current_user_company.customers
    end

    def set_users
      @users = current_user_company.user_profiles
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def prospect_params
      params.require(:prospect).permit(:title, :description, :customer_id, :rank, :prospect_amount, :prospect_order_date, :prospect_earning_date, :distribute, :user_profile_id)
    end
end
