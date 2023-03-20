class Public::HomesController < ApplicationController
  before_action :authenticate_customer!

  def top
    @post = Post.new
    customer_ids = current_customer.followings.pluck(:id) #フォローしているユーザーidを取得
    customer_ids.push(current_customer.id) #customer_idsにcurrent_customer.idを追加
    @posts = Post.where(customer_id: customer_ids).order(created_at: :desc) #取得したユーザーidの投稿を取得

    not_my_post = Post.where.not(customer_id: current_customer.id)
    @recommend = not_my_post.where( 'id >= ?', rand(not_my_post.first.id..not_my_post.last.id) ).limit(2)

  end

  def about
  end
end