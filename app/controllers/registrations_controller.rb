class RegistrationsController < Devise::RegistrationsController
  def new
    super do
      resource.build_user_profile
    end
  end

  def create
    CompanyInformation.transaction do
      @company_name = params[:company_name]
      company = CompanyInformation.create(name: params[:company_name])
      super do
        profile = resource.build_user_profile(sign_up_params[:user_profile_attributes])
        profile.company_information = company
        resource.save!
      end
    end
  rescue ActiveRecord::RecordInvalid
    render 'new'
  end

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation, user_profile_attributes: [:name])
  end
end
