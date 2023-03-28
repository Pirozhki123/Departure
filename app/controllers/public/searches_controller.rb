class Public::SearchesController < ApplicationController
  before_action :authenticate_customer!

  def search

    @range = params[:range]

    @word = params[:word]

    if @range == "User"
      @customers = Customer.looks(params[:search], params[:word]).page(params[:page])
    elsif @range == "Word"
      @posts = Post.looks(params[:search], params[:word]).page(params[:page])
    elsif @range == "Tag"
      @posts = Tag.looks(params[:search], params[:word]).page(params[:page])
    elsif @range == "Place"
      @posts = Place.looks(params[:search], params[:word]).page(params[:page])
      @favorite_count = 0
      @posts.each do |post|
        @favorite_count = @favorite_count + post.favorites.count
      end
    end

  end

end
