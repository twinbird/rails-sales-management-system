module ApplicationHelper
  def current_user_company
    return current_user if current_user.nil?
    return current_user.user_profile if current_user.user_profile.nil?
    current_user.user_profile.company_information
  end

  def welcome_message
    t('layout.login_now') + current_user.user_profile.name
  end

  def active_class(controller_name = "")
    return "active" if controller_name == controller.controller_name

    if controller_name == "" &&
       SalesReportsController.controller_name != controller.controller_name &&
       ProspectsController.controller_name != controller.controller_name &&
       EstimatesController.controller_name != controller.controller_name
      return "active"
    end

    return ""
  end
end
