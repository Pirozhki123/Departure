class Post < ApplicationRecord
  belongs_to :customer
  belongs_to :place
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :tag_relations, dependent: :destroy
  has_many :tags, through: :tag_relations, dependent: :destroy
  has_one_attached :image

  validates :image, presence: true
  validates :customer_id, presence: true
  validates :place_id, presence: true
  validates :introduction, presence: true, length: { maximum: 150 }

  def save_tags(tags) #既存のタグが被らないようにデータベースに保存
    current_tags = self.tags.pluck(:tag) unless self.tags.nil? #:tagが空じゃなければ配列を取得
    old_tags = current_tags - tags
    new_tags = tags - current_tags

    old_tags.each do |old_tag| #古いタグの削除
      self.tags.delete Tag.find_by(tag: old_tag)
    end

    new_tags.each do |new_tag| #新しいタグの保存
      post_tag = Tag.find_or_create_by(tag: new_tag)
      self.tags << post_tag
    end
  end

  def get_image(width, height)
    unless image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    image.variant(resize_to_limit: [width, height]).processed
  end

  def self.looks(search, word)
    if search == "perfect_match"
      @post = Post.where("introduction LIKE?", "#{word}")
    elsif search == "forward_match"
      @post = Post.where("introduction LIKE?", "#{word}%")
    elsif search == "backward_match"
      @post = Post.where("introduction LIKE?", "%#{word}")
    elsif search == "partial_match"
      @post = Post.where("introduction LIKE?", "%#{word}%")
    else
      @post = Post.all
    end
  end

  def favorited_by?(customer)
    favorites.exists?(customer_id: customer.id)
  end

end