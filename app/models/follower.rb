class Follower < ApplicationRecord
  validates :handle, presence: true, uniqueness: true
  validates :twitterid, presence: true, uniqueness: true

  has_and_belongs_to_many :users
  has_and_belongs_to_many :reports

  def duplicate_attrs?(attrs)
    (twitterid == attrs[:twitterid]) && (handle == attrs[:handle])
  end
end
