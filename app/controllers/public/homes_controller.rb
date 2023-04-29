class Public::HomesController < ApplicationController
  before_action :authenticate_customer!, only: [:top]

  def top
    @post = Post.new
    #フォローしているユーザーidを取得
    customer_ids = current_customer.followings.pluck(:id)
    #customer_idsにcurrent_customer.idを追加
    customer_ids.push(current_customer.id)
    #取得したユーザーidの投稿を取得
    @posts = Post.where(customer_id: customer_ids).order(created_at: :desc).page(params[:page])

    #おすすめ取得処理
    recommendt_to_get_from_post
  end

private

  #おすすめ取得処理
  def recommendt_to_get_from_post
    #自投稿をランダムに1つ取得。環境によって記述方法を変更。
    if Rails.env.production?
      rand_post = Post.where(customer_id: current_customer.id).order("rand()").first
    else
      rand_post = Post.where(customer_id: current_customer.id).order("random()").first
    end
    #自分以外の投稿一覧を取得
    other_user_posts = Post.where.not(customer_id: current_customer.id)

    #自分の投稿がある場合、上の投稿からタグを取得
    if rand_post.present?
      recommend_posts = ""
      rand_tags = rand_post.tags

      #上の投稿のタグに紐づく他の投稿を最大4つずつ取得
      if rand_tags.present?
        rand_tags.each do |rand_tag|
          #環境によって記述方法を変更
          if Rails.env.production?
            recommend = other_user_posts.left_joins(:tags).where("tags.tag LIKE?", "#{rand_tag.tag}").order("rand()").limit(4)
          else
            recommend = other_user_posts.left_joins(:tags).where("tags.tag LIKE?", "#{rand_tag.tag}").order("random()").limit(4)
          end
          # 取得したタグをまとめる
          if recommend_posts.present?
            recommend_posts = recommend_posts + recommend
          else
            recommend_posts = recommend
          end
        end
        #重複する投稿を削除
        recommend_posts = recommend_posts.uniq
      end

      #タグに紐づく投稿が4つ以上取得出来なかった場合
      if recommend_posts.count <= 4
        # 全体の投稿から4つランダムに取得
        rand_posts_all = other_user_posts.where( "id >= ?", rand(other_user_posts.first.id..other_user_posts.last.id) ).limit(4)
        #タグに紐づいた投稿とランダム取得投稿を足す
        recommend_posts = recommend_posts + rand_posts_all
        #重複する投稿の削除
        recommend_posts = recommend_posts.uniq
      end

      #配列の先頭4つ以外を削除
      @recommends = recommend_posts.shift(4)

    #タイムラインに投稿がある場合、全体の投稿から4つランダムに取得
    elsif @posts.present?
      @recommends = other_user_posts.where( "id >= ?", rand(other_user_posts.first.id..other_user_posts.last.id) ).limit(4)
    else
     redirect_to about_path
    end
  end

end