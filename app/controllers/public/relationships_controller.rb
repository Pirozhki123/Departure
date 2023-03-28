class Public::RelationshipsController < ApplicationController
  before_action :authenticate_customer!
  before_action :find_customer, only: [:create, :destroy, :followings, :followers]

  def create
    current_customer.follow(@customer)
  end

  def destroy
    current_customer.unfollow(@customer)
  end

  def followings
    @customers = @customer.followings.page(params[:page]).per(30)
  end

  def followers
    @customers = @customer.followers.page(params[:page]).per(30)
  end

private

  def find_customer
    @customer = Customer.find(params[:customer_id])
  end

end
