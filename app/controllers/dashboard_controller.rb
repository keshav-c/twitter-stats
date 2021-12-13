class DashboardController < ApplicationController
  include Secured

  def show
    # symbol keys become strings on redirect
    userid = session['data']['userid']
    # Not an ActiveRecord because stats refreshed from API not in record
    @user = get_userinfo(userid)
    user_record = nil
    if User.exists?(twitterid: userid)
      user_record = User.find_by! twitterid: userid
    else
      user_record = User.create!(
        handle: @user[:username],
        twitterid: userid
      )
      # job to get followers for new user
      GetFollowersWorker.perform_async(userid)

      Sidekiq::Cron::Job.create(
        name: "report-#{userid}",
        class: 'CreateReportWorker',
        cron: '0 0 * * SUN',
        args: { twitterid: userid }
      )
    end
    @user[:enable_report] = user_record[:enable_report]
  end

  def update
    userid = session['data']['userid']
    user = User.find_by! twitterid: userid
    enable_report = params[:enable] == "true"
    user.update!(enable_report: enable_report)
    # over-riding redirect status, results in hanging at some info page!
    redirect_to dashboard_url
  end

  private 
  
  def get_userinfo(userid)
    url = "https://api.twitter.com/2/users/#{userid}"
    header = "Bearer #{ENV['TWITTER_STATS_BEARER']}"
    params = {
      "user.fields" => "public_metrics"
    }
    response = HTTP.auth(header).get(url, params: params)
    data = JSON.parse(response.body)['data']
    {
      username: data['username'],
      name: data['name'],
      tweet_count: data['public_metrics']['tweet_count'],
      followers_count: data['public_metrics']['followers_count'],
      following_count: data['public_metrics']['following_count'],
    }
  end
end
