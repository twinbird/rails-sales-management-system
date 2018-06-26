class SalesReportsController < ApplicationController
  before_action :authenticate_user!
  before_action :initialized_user!
  before_action :set_sales_report, only: [:show, :edit, :update, :destroy]
  before_action :set_customers
  before_action :set_users
  before_action :set_latest_prospects, only: [:show]
  before_action :set_latest_estimates, only: [:show]

  # GET /sales_reports
  # GET /sales_reports.json
  def index
    @sales_reports = current_user_company.sales_reports.search(params[:query]).order(updated_at: :desc).paginate(page: params[:page], per_page: 20)
    @query = params[:query]
  end

  # GET /sales_reports/1
  # GET /sales_reports/1.json
  def show
  end

  # GET /sales_reports/new
  def new
    @sales_report = current_user_company.sales_reports.build
  end

  # GET /sales_reports/1/edit
  def edit
  end

  # POST /sales_reports
  # POST /sales_reports.json
  def create
    @sales_report = current_user_company.sales_reports.build(sales_report_params)

    respond_to do |format|
      if @sales_report.save
        format.html { redirect_to @sales_report, notice: t('.sales_report_was_successfully_created') }
        format.json { render :show, status: :created, location: @sales_report }
      else
        format.html { render :new }
        format.json { render json: @sales_report.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sales_reports/1
  # PATCH/PUT /sales_reports/1.json
  def update
    respond_to do |format|
      if @sales_report.update(sales_report_params)
        format.html { redirect_to @sales_report, notice: t('.sales_report_was_successfully_updated') }
        format.json { render :show, status: :ok, location: @sales_report }
      else
        format.html { render :edit }
        format.json { render json: @sales_report.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sales_reports/1
  # DELETE /sales_reports/1.json
  def destroy
    @sales_report.destroy
    respond_to do |format|
      format.html { redirect_to sales_reports_url, notice: t('.sales_report_was_successfully_destroyed') }
      format.json { head :no_content }
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_sales_report
      @sales_report = SalesReport.find_by(id: params[:id], company_information: current_user_company)
    end

    def set_customers
      @customers = Customer.ours(current_user)
    end

    def set_users
      @users = UserProfile.ours(current_user)
    end

    def set_latest_estimates
      @latest_estimates = @sales_report.customer.estimates.order(issue_date: :desc).limit(5)
    end

    def set_latest_prospects
      @latest_prospects = @sales_report.customer.prospects.order(created_at: :desc).limit(5)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sales_report_params
      params.require(:sales_report).permit(:customer_id, :user_profile_id, :occur_date, :description)
    end
end
