class Post < ApplicationRecord
  belongs_to :customer
  belongs_to :place
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :tag_relations, dependent: :destroy
end
