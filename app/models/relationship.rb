class Relationship < ApplicationRecord
  has_many :notifications, dependent: :destroy
end
