class Customer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :comments, dependent: :destroy
  has_many :entries, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :rooms, dependent: :destroy
  has_one_attached :image

  def self.looks(search, word)
    if search == "perfect_match"
      @customer = Customer.where("name LIKE?", "#{word}")
    elsif search == "forward_match"
      @customer = Customer.where("name LIKE?", "#{word}%")
    elsif search == "backward_match"
      @customer = Customer.where("name LIKE?", "%#{word}")
    elsif search == "partial_match"
      @customer = Customer.where("name LIKE?", "%#{word}%")
    else
      @customer = User.all
    end
  end
end
