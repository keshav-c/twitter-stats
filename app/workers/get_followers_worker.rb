class GetFollowersWorker
  include Sidekiq::Worker

  def perform(twitterid)
    user = User.find_by(twitterid: twitterid)
    if user
      user.load_followers
    else
      # figure out how to delete this job
    end
  end
end
