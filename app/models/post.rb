class Post < ApplicationRecord
  belongs_to :customer
  # belongs_to :place
  # has_many :comments, dependent: :destroy
  # has_many :favorites, dependent: :destroy
  # has_many :tag_relations, dependent: :destroy
  # has_many :tags, through: :tag_relations, dependent: :destroy
  has_one_attached :image

  # def save_tags(tags) #既存のタグが被らないようにデータベースに保存
  #   current_tags = self.tags.pluck(:tag) unless self.tags.nil?
  #   old_tags = current_tags - tags
  #   new_tags = tags - current_tags

  #   old_tags.each do |old_tag| #古いタグの削除
  #     self.tags.delete Tag.find_by(tag: old_tag)
  #   end
  #   new_tags.each do |new_tag| #新しいタグの保存
  #     post_tag = Tag.find_of_create_by(tag: new_tag)
  #     self.tags << post_tag
  #   end
  # end
end
