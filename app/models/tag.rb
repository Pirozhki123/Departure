class Tag < ApplicationRecord
  has_many :tag_relations, dependent: :destroy
end
