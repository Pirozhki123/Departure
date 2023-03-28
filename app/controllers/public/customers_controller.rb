class Public::CustomersController < ApplicationController
  before_action :authenticate_customer!
  before_action :find_customer, only: [:show, :edit, :favorite_posts]
  before_action :is_matching_login_customer, only: [:edit, :update]

  def show
    @posts = @customer.posts.order("created_at DESC").page(params[:page])
  end

  def edit
  end

  def index
    @customers = Customer.all.page(params[:page]).per(30)
  end

  def update
    @customer.update(customer_params)
    redirect_to public_customer_path(@customer)
  end

  def favorite_posts #ユーザーがいいねした投稿一覧
    @posts = Post.left_joins(:favorites).where("favorites.customer_id LIKE?", "%#{@customer.id}%").page(params[:page])
    @post = Post.new
  end

private

  def find_customer
    @customer = Customer.find(params[:id])
  end

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
