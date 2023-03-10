class Public::HomesController < ApplicationController
  def top
    @post = Post.new
    @posts = Post.all
  end
end
