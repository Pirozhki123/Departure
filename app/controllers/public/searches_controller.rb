class Public::SearchesController < ApplicationController
  before_action :authenticate_customer!

  def search
    @range = params[:range]
    @word = params[:word]
    if @range == "User"
      @customers = Customer.looks(params[:search], params[:word])
    elsif @range == "Word"
      @posts = Post.looks(params[:search], params[:word])
    else
      @posts = Tag.looks(params[:search], params[:word])
    end
  end
end
