class Public::HomesController < ApplicationController
  before_action :authenticate_customer!

  def top
    @post = Post.new
    @posts = Post.all
    @tag_list = @post.tags.pluck(:tag).join(',')
  end
end
