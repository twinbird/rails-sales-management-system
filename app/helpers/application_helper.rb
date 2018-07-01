module ApplicationHelper
  def initialized?
    !current_user.user_profile.nil?
  end

  def initialized_user!
    unless initialized?
      flash[:notice] = t('layout.please_entry_user_information')
      redirect_to mysetting_path
    end
  end

  def current_user_company
    return current_user if current_user.nil?
    return current_user.user_profile if current_user.user_profile.nil?
    current_user.user_profile.company_information
  end

  def welcome_message
    t('layout.login_now') + current_user.user_profile.name
  end
end
