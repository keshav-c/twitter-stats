class DashboardController < ApplicationController
  include Secured

  def show
    # symbol keys become strings on redirect
    @user = get_userinfo(session['data']['userid'])

    app_user = User.find_or_create_by!(
      handle: @user[:username],
      twitterid: @user[:twitter_id]
    )
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
      twitter_id: data['id'],
      username: data['username'],
      name: data['name'],
      tweet_count: data['public_metrics']['tweet_count'],
      followers_count: data['public_metrics']['followers_count'],
      following_count: data['public_metrics']['following_count'],
    }
  end
end
