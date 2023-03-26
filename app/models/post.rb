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

  # def get_recommend(post_id) #ポスト関連におすすめ表示する必要がある場合の記述（見た目の都合上導入見送り中

  #   post = Post.find(params[post_id])
  #   tags = post.tags #上の投稿からタグを取得
  #   recommend_posts = ""

  #   if tags.present?
  #     other_user_posts = Post.where.not(customer_id: current_customer.id) #自分以外の投稿一覧
  #     tags.each do |tag| #タグに紐づく投稿を最大4つずつ取得
  #       recommend = other_user_posts.left_joins(:tags).where("tags.tag LIKE?", "#{tag.tag}").order('random()').limit(4) #上記タグと一致する他ユーザーの投稿を１つ取得
  #       if recommend_posts.present?
  #         recommend_posts = recommend_posts + recommend
  #       else
  #         recommend_posts = recommend
  #       end
  #     end
  #     recommend_posts = recommend_posts.uniq #重複する投稿を削除
  #   end

  #   if recommend_posts.count <= 4 #タグに紐づく投稿が4つ以上取得出来なかった場合
  #     rand_posts_all = other_user_posts.where( 'id >= ?', rand(other_user_posts.first.id..other_user_posts.last.id) ).limit(4) #全体の投稿から4つランダムに取得
  #     recommend_posts = recommend_posts + rand_posts_all #タグに紐づいた投稿とランダム取得投稿を足す
  #     recommend_posts = recommend_posts.uniq #重複する投稿の削除
  #   end

  #   @recommends = recommend_posts.pop(4) #配列の先頭4つ以外を削除
  # end

  def favorited_by?(customer)
    favorites.exists?(customer_id: customer.id)
  end

end