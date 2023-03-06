class Room < ApplicationRecord
  belongs_to :customer
  has_many :entries, dependent: :destroy
  has_many :messages, dependent: :destroy
end
