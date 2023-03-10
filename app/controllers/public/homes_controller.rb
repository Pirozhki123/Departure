class Public::HomesController < ApplicationController
  def top
    @post = Post.new
    @posts = Post.all
    @tag_list = @post.tags.pluck(:tag).join(',')
  end
end
