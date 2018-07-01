class StaticPagesController < ApplicationController

  def index
    redirect_to sales_reports_url if signed_in?
  end

end
