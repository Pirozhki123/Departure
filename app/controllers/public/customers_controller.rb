class Public::CustomersController < ApplicationController
  def show
  end

  def edit
  end

  def favorite_posts
    #ユーザーがいいねした投稿一覧
    @customer = Customer.find(params[:id])
    favorites = Favorite.where(customer_id: @customer.id).pluck(:post_id) #Favoriteモデルから表示しているユーザーがいいねしたものを配列で取得
    @posts = Post.find(favorites)

    @post = Post.new
  end
end
