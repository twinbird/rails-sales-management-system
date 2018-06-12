module EstimatesHelper
  def display_due_date(estimate)
    return estimate.due_date.to_s(:date) unless estimate.due_date_pending_flag
    t('estimates.helper.due_date_pending')
  end
end
