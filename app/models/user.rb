class User < ApplicationRecord
  validates :handle, presence: true, uniqueness: true
  validates :twitterid, presence: true, uniqueness: true
end
