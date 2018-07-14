class CustomersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_customer, only: [:show, :edit, :update, :destroy]
  before_action :set_latest_prospects, only: [:show]
  before_action :set_latest_sales_reports, only: [:show]

  # GET /customers
  # GET /customers.json
  def index
    @customers = current_user_company.customers.search(params[:query]).order(:name)
    @query = params[:query]

    respond_to do |format|
      format.html do
        @customers = @customers.paginate(page: params[:page], per_page: 20)
        render :index
      end
      format.csv { send_data render_to_string, filename: 'customers.csv', type: 'text/csv; charset=shift_jis' }
    end
  end

  # GET /customers/1
  # GET /customers/1.json
  def show
  end

  # GET /customers/new
  def new
    @customer = current_user_company.customers.build
  end

  # GET /customers/1/edit
  def edit
  end

  # POST /customers
  # POST /customers.json
  def create
    @customer = current_user_company.customers.build(customer_params)

    respond_to do |format|
      if @customer.save
        format.html { redirect_to @customer, notice: t('.customer_was_successfully_created') }
        format.json { render :show, status: :created, location: @customer }
      else
        format.html { render :new }
        format.json { render json: @customer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /customers/1
  # PATCH/PUT /customers/1.json
  def update
    respond_to do |format|
      if @customer.update(customer_params)
        format.html { redirect_to @customer, notice: t('.customer_was_successfully_updated') }
        format.json { render :show, status: :ok, location: @customer }
      else
        format.html { render :edit }
        format.json { render json: @customer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /customers/1
  # DELETE /customers/1.json
  def destroy
    @customer.destroy
    respond_to do |format|
      format.html { redirect_to customers_url, notice: t('.customer_was_successfully_destroyed') }
      format.json { head :no_content }
    end
  end

  def import_form
  end

  def import
    if params[:file].nil?
      flash[:danger] = t('.file_must_be_spec')
      render 'import_form'
      return
    end

    @error_line, @error_customer = Customer.import(params[:file], current_user_company)
    flash[:info] = t('.import_success') unless @error_customer
    render 'import_form'
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_customer
      @customer = Customer.find_by!(id: params[:id], company_information: current_user_company)
    end

    def set_latest_prospects
      @latest_prospects = @customer.latest_prospects(5)
    end

    def set_latest_sales_reports
      @latest_sales_reports = @customer.latest_sales_reports(5)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def customer_params
      params.require(:customer).permit(:name, :payment_term)
    end
end
