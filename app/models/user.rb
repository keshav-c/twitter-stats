class User < ApplicationRecord
  validates :handle, presence: true, uniqueness: true
  validates :twitterid, presence: true, uniqueness: true

  has_and_belongs_to_many :followers
  has_many :reports, -> { order "date DESC" }

  # This is run by a sidekiq-cron worker to create an unfollow
  # report for the user
  def generate_unfollow_report
    return unless enable_report

    fetched = get_followers()
    # retrieve followers (supposedly from last week)
    old = followers.to_a
    unfollowed = []
    old.each do |old_f|
      i = fetched.find_index { |f| old_f.duplicate_attrs?(f) }
      if i.nil?
        unfollowed << old_f
      else
        fetched.delete_at(i)
      end
    end
    # the remaining fetched are new followers over the week
    fetched.each { |nu_f| create_or_associate_follower(nu_f) }
    # delete the unfollowed associations
    followers.destroy(unfollowed)
    # create the weekly report
    report = reports.create!(date: Date.today, total: unfollowed.length)
    report.followers << unfollowed
  end

  # This is run by a worker the first time a User is created. It
  # populates the DB with Followers and creates associations.
  def load_followers
    get_followers.each { |f| create_or_associate_follower(f) }
  end

  # This fetches the current followers of the User from the
  # Twitter API 
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

  # expects attributes - twitterid and handle
  def create_or_associate_follower(attrs)
    f_record = Follower.find_by twitterid: attrs[:twitterid]
    if f_record 
      unless followers.include?(f_record)
        followers << f_record
      end
    else
      followers.create!(attrs)
    end
  end
end
