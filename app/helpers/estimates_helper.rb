module EstimatesHelper
  def display_due_date(estimate)
    return estimate.due_date.to_s(:date) unless estimate.due_date_pending_flag
    t('estimates.helper.due_date_pending')
  end

  def submitted_estimate_message(estimate)
    if estimate.submitted_flag
      t('estimates.helper.submitted')
    else
      t('estimates.helper.unsubmitted')
    end
  end

  def ordered_estimate_message(estimate)
    if estimate.ordered_flag
      t('estimates.helper.ordered')
    else
      t('estimates.helper.non_ordered')
    end
  end
end
