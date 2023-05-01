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
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :followers, through: :reverse_of_relationships, source: :follower
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :followings, through: :relationships, source: :followed

  has_one_attached :profile_image

  validates :email, presence: true
  validates :name, presence: true, length: { maximum: 30 }
  validates :name, length: { maximum: 150 }

  #ユーザー検索機能
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

  #フォロー機能
  def follow(customer)
    #渡されたユーザーのIDでフォローをfollowed_idをクリエイト
    relationships.create(followed_id: customer.id)
  end

  #フォロー解除機能
  def unfollow(customer)
    #渡されたユーザーのIDでfollowed_idを探して削除
    relationships.find_by(followed_id: customer.id).destroy
  end

  def following?(customer)
    followings.include?(customer) #自分がフォローしている人から渡されたユーザー情報を呼び出す？
  end

  #画像取得機能
  def get_profile_image(width, height)
    #画像が無ければデフォルトイメージを取得
    unless profile_image.attached?
      file_path = Rails.root.join("app/assets/images/no_image.jpg")
      profile_image.attach(io: File.open(file_path), filename: "default-image.jpg", content_type: "image/jpeg")
    end
    profile_image.variant(resize_to_limit: [width, height]).processed
  end

  #退会機能
  def active_for_authentication?
    super && (is_deleted == false)
  end

end
