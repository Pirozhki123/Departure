class Message < ApplicationRecord
  belongs_to :customer
  belongs_to :room
end
