class Public::CustomersController < ApplicationController
  def show
    @customer = Customer.find(params[:id])
  end

  def edit
    @customer = Customer.find(params[:id])
  end

  def update
    @customer = Customer.find(params[:id])
    @customer.update(customer_params)
    redirect_to public_customer_path(@customer)
  end

  def favorite_posts
    #ユーザーがいいねした投稿一覧
    @customer = Customer.find(params[:id])
    favorites = Favorite.where(customer_id: @customer.id).pluck(:post_id) #Favoriteモデルから表示しているユーザーがいいねしたものを配列で取得
    @posts = Post.find(favorites)

    @post = Post.new
  end

  def followings
    customer = Customer.find(params[:id])
    @customer = customer.followings #customerに結びついているフォロー全員を取得
  end

  def followers
    customer = Customer.find(params[:id])
    @customer = customer.followers #customerに結びついているフォロワー全員を取得
  end

  private

  def customer_params
    params.require(:customer).permit(:name, :email, :introduction, :private, :image)
  end

end
