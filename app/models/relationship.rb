class Relationship < ApplicationRecord
  has_many :notifications, dependent: :destroy
  belongs_to :follower, class_name: "Customer", optional: true
  belongs_to :followed, class_name: "Customer", optional: true
end
