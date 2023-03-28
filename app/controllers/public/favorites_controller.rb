class Public::FavoritesController < ApplicationController
  before_action :authenticate_customer!
  before_action :find_post, only: [:create, :destroy]

  def create
    @post = Post.find(params[:post_id])
    favorite = current_customer.favorites.new(post_id: @post.id)
    favorite.save
  end

  def destroy
    @post = Post.find(params[:post_id])
    favorite = current_customer.favorites.find_by(post_id: @post.id)
    favorite.destroy
  end

private

  def find_post
    @post = Post.find(params[:post_id])
  end

end