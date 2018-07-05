class UserProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:edit, :update, :destroy]

  def index
    @query = params[:query]
    @user_profiles = current_user_company.user_profiles.actives.search(@query).order(:name).paginate(page: params[:page], per_page: 20)
  end

  def new
    @user = User.new
    @user_profile = @user.build_user_profile
    @user_profile.company_information = current_user_company
  end

  def create
    @user = User.new(user_params)
    @user.user_profile.company_information = current_user_company
    if @user.save
      flash[:info] = t('.user_created')
      redirect_to user_profiles_url
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      sign_in(@user, bypass: true)
      flash[:info] = t('.user_updated')
      redirect_to user_profiles_url
    else
      render 'edit'
    end
  end

  def destroy
    if @user.disable
      flash[:info] = t('.user_was_disabled')
    else
      flash[:danger] = t('.user_disable_was_failed')
    end
    redirect_to user_profiles_url
  end

  private

    def user_params
      if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
        params[:user].delete(:password)
        params[:user].delete(:password_confirmation)
      end
      params.require(:user).permit(:id, :email, :password, :password_confirmation, user_profile_attributes: [:id, :name])
    end

    def set_user
      user_id = params[:id]
      @user = current_user_company.user_profiles.find_by(user_id: user_id).user
    end

end
