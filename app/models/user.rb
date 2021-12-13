class User < ApplicationRecord
  validates :handle, presence: true, uniqueness: true
  validates :twitterid, presence: true, uniqueness: true

  has_and_belongs_to_many :followers
  has_many :reports, -> { order "date DESC" }

  def generate_unfollow_report
    return unless enable_report

    # fetched current followers from API, map to new Follower to use equal?
    fetched = get_followers.map(&:Follower.new)
    # retrieve followers for user from db
    old = followers.to_a
    unfollowed = []
    old.each do |old_f|
      i = fetched.find_index { |fetched_f| old_f.equal?(fetched_f) }
      if i.nil?
        unfollowed << old_f
      else
        fetched.delete_at(i)
      end
    end
    # the remaining fetched are new followers over the week
    fetched.each do |new_follower|
      new_follower.save!
      followers << new_follower
    end
    # delete the unfollowed associations
    followers.destroy(unfollowed)
    # create the weekly report
    report = reports.create!(date: Date.today, total: unfollowed.length)
    report << unfollowed
  end

  def load_followers
    followers << get_followers.map do |f|
      Follower
        .create_with(handle: f[:handle])
        .find_or_create_by(twitterid: f[:twitterid])
    end
  end

  def get_followers
    url = "https://api.twitter.com/2/users/#{twitterid}/followers"
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
