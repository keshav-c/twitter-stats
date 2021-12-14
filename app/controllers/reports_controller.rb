class ReportsController < ApplicationController
  include Secured

  def index
    userid = session['data']['userid']
    @user = User.find_by! twitterid: userid
    @reports = @user.reports
  end

  def show
    userid = session['data']['userid']
    user = User.find_by! twitterid: userid
    if user.reports.exists?(params[:id])
      @report = Report.find(params[:id])
    else
      redirect_to reports_url
    end
  end
end
