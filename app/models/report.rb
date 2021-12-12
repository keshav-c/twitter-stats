class Report < ApplicationRecord
  validates :date, presence: true
  
  belongs_to :user
  has_and_belongs_to_many :followers
end
