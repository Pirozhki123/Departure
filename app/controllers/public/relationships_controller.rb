class Public::RelationshipsController < ApplicationController
  before_action :authenticate_customer!

  def create
    customer = Customer.find(params[:customer_id]) #Userモデルからuser_idが一致するものを見つけてuserに代入
    current_customer.follow(customer) #ログイン中のユーザー情報とフォローするユーザーのidを関連付けてrelationshipモデルにクリエイト
    redirect_to request.referer #遷移元のURLを取得してリダイレクト
  end

  def destroy
    customer = Customer.find(params[:customer_id]) #Userモデルからuser_idが一致するものを見つけてuserに代入
    current_customer.unfollow(customer) #ログイン中のユーザー情報とフォローするユーザーのidが関連付いているデータを探して削除
    redirect_to request.referer #遷移元のURLを取得してリダイレクト
  end

  def followings
    customer = Customer.find(params[:customer_id]) #Userモデルからuser_idが一致するものを見つけてuserに代入
		@customers = customer.followings #userのフォローしている人一覧を@usersに代入
  end

  def followers
    customer = Customer.find(params[:customer_id]) #Userモデルからuser_idが一致するものを見つけてuserに代入
		@customers = customer.followers #userのフォローされている人一覧を@usersに代入
  end

end
