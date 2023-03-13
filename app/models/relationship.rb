class Relationship < ApplicationRecord
  has_many :notifications, dependent: :destroy
  belongs_to :follower, class_name: "Customer"
  belongs_to :followed, class_name: "Customer"
end
