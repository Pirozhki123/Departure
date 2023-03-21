class Public::SearchesController < ApplicationController
  before_action :authenticate_customer!

  def search
    @range = params[:range]
    @word = params[:word]
    if @range == "User"
      @customers = Customer.looks(params[:search], params[:word])
    elsif @range == "Word"
      @posts = Post.looks(params[:search], params[:word])
    elsif @range == "Tag"
      @posts = Tag.looks(params[:search], params[:word]).page(params[:page])
    elsif @range == "Place"
      @posts = Place.looks(params[:search], params[:word])
      @favorite_count = 0
      @posts.each do |post|
        @favorite_count = @favorite_count + post.favorites.count
      end
    else
      @posts = Post.all
    end
  end
end
