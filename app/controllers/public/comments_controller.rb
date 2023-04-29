class Public::CommentsController < ApplicationController
  before_action :authenticate_customer!
  before_action :find_post, only: [:create, :destroy]

  def create
    # ログインIDに紐づいたコメントを作成
    comment = current_customer.comments.new(comment_params)
    comment.post_id = @post.id
    comment.save
  end

  def destroy
    Comment.find(params[:id]).destroy
  end

private

  def find_post
    @post = Post.find(params[:post_id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
