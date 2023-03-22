class Place < ApplicationRecord
  has_many :posts, dependent: :destroy

  validates :place_name, presence: true, uniqueness: true, length: { maximum: 50 }

  def self.looks(search, word)
    if search == "perfect_match"
      place = Post.left_joins(:place).where("places.place_name LIKE?", "#{word}")
    elsif search == "forward_match"
      place = Post.left_joins(:place).where("places.place_name LIKE?", "#{word}%")
    elsif search == "backward_match"
      place = Post.left_joins(:place).where("places.place_name LIKE?", "%#{word}")
    elsif search == "partial_match"
      place = Post.left_joins(:place).where("places.place_name LIKE?", "%#{word}%")
    else
      place = Post.left_joins(:place).all
    end

    # return place.inject(init = []) {|result, place| result + place.posts}

  end
end
