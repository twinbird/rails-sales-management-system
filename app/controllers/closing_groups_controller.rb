class ClosingGroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :initialized_user!
  before_action :set_closing_group, only: [:show, :edit, :update, :destroy]

  # GET /closing_groups
  # GET /closing_groups.json
  def index
    @closing_groups = current_user_company.closing_groups.order(:name).paginate(page: params[:page], per_page: 20)
  end

  # GET /closing_groups/1
  # GET /closing_groups/1.json
  def show
  end

  # GET /closing_groups/new
  def new
    @closing_group = current_user_company.closing_groups.build
  end

  # GET /closing_groups/1/edit
  def edit
  end

  # POST /closing_groups
  # POST /closing_groups.json
  def create
    @closing_group = current_user_company.closing_groups.build(closing_group_params)

    respond_to do |format|
      if @closing_group.save
        format.html { redirect_to @closing_group, notice: t('.closing_group_was_successfully_created') }
        format.json { render :show, status: :created, location: @closing_group }
      else
        format.html { render :new }
        format.json { render json: @closing_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /closing_groups/1
  # PATCH/PUT /closing_groups/1.json
  def update
    respond_to do |format|
      if @closing_group.update(closing_group_params)
        format.html { redirect_to @closing_group, notice: t('.closing_group_was_successfully_updated') }
        format.json { render :show, status: :ok, location: @closing_group }
      else
        format.html { render :edit }
        format.json { render json: @closing_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /closing_groups/1
  # DELETE /closing_groups/1.json
  def destroy
    @closing_group.destroy
    respond_to do |format|
      format.html { redirect_to closing_groups_url, notice: t('.closing_group_was_successfully_destroyed') }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_closing_group
      @closing_group = current_user_company.closing_groups.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def closing_group_params
      params.require(:closing_group).permit(:name)
    end
end
