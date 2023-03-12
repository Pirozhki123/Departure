class Public::RelationshipsController < ApplicationController

  def create
    following = current_customer.follower.build(following_id: params[:customer_id]) #followingにログイン中のユーザーIDとフォローするユーザーIDを格納
    following.save! #保存
    redirect_to request.referrer || root_path #以前のパスを再度リクエスト。なければルートパスへ
  end

  def destroy
    following = current_customer.follower.find_by(following_id: params[:customer_id]) #followingにログイン中のユーザーIDとリムーブするユーザーIDを格納
    following.destroy #削除
    redirect_to request.referrer || root_path #以前のパスを再度リクエスト。なければルートパスへ
  end

end
