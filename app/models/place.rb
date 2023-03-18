class Place < ApplicationRecord
  has_many :posts, dependent: :destroy

  validates :place_name, presence: true, uniqueness: true

  def self.looks(search, word)
    if search == "perfect_match"
      place = Place.where("place_name LIKE?", "#{word}")
    elsif search == "forward_match"
      place = Place.where("place_name LIKE?", "#{word}%")
    elsif search == "backward_match"
      place = Place.where("place_name LIKE?", "%#{word}")
    elsif search == "partial_match"
      place = Place.where("place_name LIKE?", "%#{word}%")
    else
      place = Place.all
    end

    return place.inject(init = []) {|result, place| result + place.posts} #@tagsの形に変換

  end
end
