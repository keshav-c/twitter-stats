class DashboardController < ApplicationController
  include Secured

  def show
    # symbol keys become strings on redirect
    userid = session['data']['userid']
    @user = get_userinfo(userid)

    if !User.exists?(twitterid: userid)
      user = User.create!(
        handle: @user[:username],
        twitterid: userid
      )
      user.followers << get_followers(userid).map do |f|
        Follower
          .create_with(handle: f[:handle])
          .find_or_create_by(twitterid: f[:twitterid])
      end
      # puts "yeah found it"
    else
      # Do nothing
    end

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

  def get_followers(userid)
    url = "https://api.twitter.com/2/users/#{userid}/followers"
    header = "Bearer #{ENV['TWITTER_STATS_BEARER']}"
    params = { max_results: 500 }
    followers = []
    loop do
      response = HTTP.auth(header).get(url, params: params)
      data = JSON.parse(response.body)
      followers += data['data']
      next_token = data['meta']['next_token']
      break if next_token.nil?
      params[:pagination_token] = next_token
    end
    followers.map! { |f| { twitterid: f['id'], handle: f['username'] } }
  end
end
