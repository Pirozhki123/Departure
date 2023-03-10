class Place < ApplicationRecord
  has_many :posts, dependent: :destroy

  validates :place_name, presence: true, uniqueness: true
end
