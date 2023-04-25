class Public::HomesController < ApplicationController
  before_action :authenticate_customer!, only: [:top]

  def top
    @post = Post.new
    customer_ids = current_customer.followings.pluck(:id) #フォローしているユーザーidを取得
    customer_ids.push(current_customer.id) #customer_idsにcurrent_customer.idを追加
    @posts = Post.where(customer_id: customer_ids).order(created_at: :desc).page(params[:page]) #取得したユーザーidの投稿を取得

    #おすすめ取得処理
    recommendt_to_get_from_post
  end

  def about
  end

private

  def recommendt_to_get_from_post #おすすめ取得処理
    if Rails.env.production?
      rand_post = Post.where(customer_id: current_customer.id).order("rand()").first #自投稿をランダムに1つ取得
    else
      rand_post = Post.where(customer_id: current_customer.id).order("random()").first #自投稿をランダムに1つ取得
    end
    other_user_posts = Post.where.not(customer_id: current_customer.id) #自分以外の投稿一覧
    if rand_post.present? #自分の投稿がある場合
      recommend_posts = ""
      rand_tags = rand_post.tags #上の投稿からタグを取得

      if rand_tags.present?
        rand_tags.each do |rand_tag| #タグに紐づく投稿を最大4つずつ取得
          if Rails.env.production?
            recommend = other_user_posts.left_joins(:tags).where("tags.tag LIKE?", "#{rand_tag.tag}").order("rand()").limit(4) #上記タグと一致する他ユーザーの投稿を１つ取得
          else
            recommend = other_user_posts.left_joins(:tags).where("tags.tag LIKE?", "#{rand_tag.tag}").order("random()").limit(4) #上記タグと一致する他ユーザーの投稿を１つ取得
          end
          if recommend_posts.present?
            recommend_posts = recommend_posts + recommend
          else
            recommend_posts = recommend
          end
        end
        recommend_posts = recommend_posts.uniq #重複する投稿を削除
      end

      if recommend_posts.count <= 4 #タグに紐づく投稿が4つ以上取得出来なかった場合
        rand_posts_all = other_user_posts.where( "id >= ?", rand(other_user_posts.first.id..other_user_posts.last.id) ).limit(4) #全体の投稿から4つランダムに取得 ※SQQLightではrandom()、MySQLではrand()を使用
        recommend_posts = recommend_posts + rand_posts_all #タグに紐づいた投稿とランダム取得投稿を足す
        recommend_posts = recommend_posts.uniq #重複する投稿の削除
      end

      @recommends = recommend_posts.shift(4) #配列の先頭4つ以外を削除
    elsif @posts.present? #タイムラインに投稿がある場合
      @recommends = other_user_posts.where( "id >= ?", rand(other_user_posts.first.id..other_user_posts.last.id) ).limit(4)
    else
     redirect_to public_homes_about_path #aboutページへ移動
    end
  end

end