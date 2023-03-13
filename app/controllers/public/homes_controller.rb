class Public::HomesController < ApplicationController
  before_action :authenticate_customer!

  def top
    @post = Post.new
    customer_ids = current_customer.followings.pluck(:id)
    customer_ids.push(current_customer.id)
    @posts = Post.where(customer_id: customer_ids).order(created_at: :desc)
    @tag_list = @post.tags.pluck(:tag).join(',')
  end
end