class CompanyInformationsController < ApplicationController
  before_action :authenticate_user!

  def edit
    @company_information = current_user_company
  end

  def update
    @company_information = current_user_company
    if @company_information.update(company_information_params)
      flash.now[:notice] = t('.updated')
    end
    render 'edit'
  end

  private

    def company_information_params
      params.require(:company_information).permit(:name)
    end
end
