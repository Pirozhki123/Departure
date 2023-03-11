class Tag < ApplicationRecord
  has_many :tag_relations, dependent: :destroy
  has_many :books, through: :tag_relations, dependent: :destroy

  validates :tag, presence: true, uniqueness: true
end
