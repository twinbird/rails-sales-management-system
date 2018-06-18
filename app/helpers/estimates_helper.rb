module EstimatesHelper
  def display_due_date(estimate)
    return estimate.due_date.to_s(:date) unless estimate.due_date_pending_flag
    t('estimates.helper.due_date_pending')
  end

  def submitted_message(estimate)
    if estimate.submitted_flag
      t('estimate.helper.submitted')
    else
      t('estimate.helper.unsubmitted')
    end
  end
end
