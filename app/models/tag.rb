class Tag < ApplicationRecord
  has_many :tag_relations, dependent: :destroy
  has_many :posts, through: :tag_relations, dependent: :destroy

  validates :tag, presence: true, uniqueness: true

  def self.looks(search, word)
    if search == "perfect_match"
      tags = Post.left_joins(:tags).where("tags.tag LIKE?", "#{word}")
    elsif search == "forward_match"
      tags = Post.left_joins(:tags).where("tags.tag LIKE?", "#{word}%")
    elsif search == "backward_match"
      tags = Post.left_joins(:tags).where("tags.tag LIKE?", "%#{word}")
    elsif search == "partial_match"
      tags = Post.left_joins(:tags).where("tags.tag LIKE?", "%#{word}%")
    else
      tags = Post.left_joins(:tags).all
    end
    tags = tags.distinct
  end
end
