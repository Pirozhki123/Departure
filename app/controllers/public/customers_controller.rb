class Public::CustomersController < ApplicationController
  before_action :authenticate_customer!

  def show
    @customer = Customer.find(params[:id])
    @posts = @customer.posts.page(params[:page])
  end

  def edit
    @customer = Customer.find(params[:id])
  end

  def index
    @customers = Customer.all.page(params[:page]).per(30)
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

  private

  def customer_params
    params.require(:customer).permit(:name, :email, :introduction, :private, :profile_image)
  end

end
