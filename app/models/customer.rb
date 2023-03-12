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
  has_many :follower, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :followings, through: :follower, source: :followed
  has_many :followed, class_name: "Relationship", foreign_key: "following_id", dependent: :destroy
  has_many :followers, through: :followed, source: :follower
  has_one_attached :image

  validates :email, presence: true
  validates :name, presence: true

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

  def is_followed_by?(user)
    followed.find_by(follower_id: user.id).present?
  end

  def get_profile_image(width, height)
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    profile_image.variant(resize_to_limit: [width, height]).processed
  end

end
