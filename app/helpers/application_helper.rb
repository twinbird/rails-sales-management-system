module ApplicationHelper

  def is_initialized?
    !current_user.user_profile.nil?
  end

  def initialized_user!
    unless is_initialized?
      flash[:notice] = t('layout.please_entry_user_information')
      redirect_to mysetting_path
    end
  end

end
