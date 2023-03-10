class Public::SearchesController < ApplicationController
  before_action :authenticate_customer!

  def search
    @range = params[:range]
    @word = params[:word]
    if @range == "User"
      @customers = Customers.looks(params[:search], params[:word])
    elsif @range == "Post"
      @posts = Post.looks(params[:search], params[:word])
    end
  end
end
