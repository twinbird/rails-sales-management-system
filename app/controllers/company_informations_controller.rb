class CompanyInformationsController < ApplicationController
  before_action :authenticate_user!

  def edit
    if current_user.user_profile.nil?
      @company_information = CompanyInformation.new
      @company_information.user_profiles.build.user = current_user
    else
      @company_information = current_user.user_profile.company_information
    end
  end

  def create
    @company_information = CompanyInformation.new(company_information_params)
    @company_information.user_profiles.first.user = current_user
    if @company_information.save
      flash.now[:notice] = t('.created')
    end
    render 'edit'
  end

  def update
    @company_information = current_user.user_profile.company_information
    if @company_information.update_attributes(company_information_params)
      flash.now[:notice] = t('.updated')
    end
    render 'edit'
  end

  private

    def company_information_params
      params.require(:company_information).permit(:name, user_profiles_attributes: [:id, :name])
    end

end
