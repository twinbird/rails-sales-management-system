class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include ApplicationHelper

  def after_sign_in_path_for(resource)
    mysetting_path
  end

end
