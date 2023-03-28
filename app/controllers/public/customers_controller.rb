class Public::CustomersController < ApplicationController
  before_action :authenticate_customer!
  before_action :is_matching_login_customer, only: [:edit, :update]

  def show
    @customer = Customer.find(params[:id])
    @posts = @customer.posts.order("created_at DESC").page(params[:page])
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
    # favorites = Favorite.where(customer_id: @customer.id)
    # @posts = Post.where(id: favorites.post_id)
    @posts = Post.left_joins(:favorites).where("favorites.customer_id LIKE?", "%#{@customer.id}%").page(params[:page])
    # @posts = Post.left_joins(:favorites).where(customer_id: @customer.id).page(params[:page])
    @post = Post.new
  end

  private

  def customer_params
    params.require(:customer).permit(:name, :email, :introduction, :private, :profile_image)
  end

  def is_matching_login_customer
    customer = Customer.find(params[:id])
    unless customer.id == current_customer.id
      redirect_to root_path
    end
  end

end
