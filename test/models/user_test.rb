require "test_helper"

class UserTest < ActiveSupport::TestCase
  def test_load_followers
    user = User.new(twitterid: "1", handle: "u")
    user.stub :get_followers, [
        { twitterid: "11", handle: "f1a" },
        { twitterid: "12", handle: "f2b" }
      ] do
      assert_includes user.followers, Follower.find_by(twitterid: "11"), "did not work"
    end
  end
end

# Notes: Check fixtures for undesirable test db values