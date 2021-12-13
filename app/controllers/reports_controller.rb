class ReportsController < ApplicationController
  include Secured

  def index
    userid = session['data']['userid']
    @user = User.find_by! twitterid: userid
    @reports = @user.reports
  end

  def show
    @report = Report.find(params[:id])
  end
end
