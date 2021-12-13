class CreateReportWorker
  include Sidekiq::Worker

  def perform(twitterid)
    user = User.find_by(twitterid: twitterid)
    if user
      user.generate_unfollow_report
    else
      # figure out how to delete this job
    end
  end
end
