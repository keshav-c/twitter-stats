module ReportsHelper
  def twitter_link(handle)
    URI::HTTPS.build(host: "twitter.com", path: "/#{handle}").to_s
  end
end
