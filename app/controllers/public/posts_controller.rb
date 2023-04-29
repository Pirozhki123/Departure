class Public::PostsController < ApplicationController
  before_action :authenticate_customer!
  before_action :find_post, only: [:show, :edit, :update]

  def index
    @post = Post.new
    @posts = Post.all.order(updated_at: :desc).page(params[:page])
    #タグを","で区切って一つにまとめる
    @tag_list = @post.tags.pluck(:tag).join(",")
  end

  def new
    @post = Post.new
  end

  def show
    @comment = Comment.new
  end

  def edit
  end

  def update
    #送られたtag情報を「,」で区切ってスペースを削除
    tag_list = params[:post][:tag].delete(" ").delete("　").split(",")
    if @post.update(post_params)
      #save_tagsメソッドを実行（詳細はpostモデルに記載）
      @post.save_tags(tag_list)
      redirect_to post_path(@post), notice: "編集が完了しました"
    else
      render "public/homes/top"
    end
  end


  def create
    @post = Post.new(post_params)
    @posts = Post.all.page(params[:page])
    @post.customer_id = current_customer.id
    #場所の保存処理(処理内容は下にまとめてある)
    save_place
    #タグの保存処理。送られたtag情報を「,」で区切ってスペースを削除。
    tag_list = params[:post][:tag].delete(" ").delete("　").split(",")

    if @post.save
      #Vision APIを利用したタグ追加処理
      vision_tags = Vision.get_image_data(@post.image)
      if tag_list.present?
        tag_list = tag_list + vision_tags
      else
        tag_list = vision_tags
      end

      #save_tagsメソッドを実行（モデルに記載）
      @post.save_tags(tag_list)
      redirect_to root_path, notice: "投稿しました"
    else
      render "public/posts/new"
    end

  end

  def destroy
    post = Post.find(params[:id])
    post.destroy
    redirect_to root_path, notice: "投稿を削除しました"
  end

private

  def find_post
    @post = Post.find(params[:id])
  end

  #場所の保存処理
  def save_place
    # 入力された場所名が登録されていないか確認
    place_name = params[:post][:place]
    place_present = Place.where(place_name: place_name)
    #場所名が登録されていなければ新たに登録
    if place_present.blank?
      @post.place = Place.new
      @post.place.place_name = place_name
      @post.place.save
      place_id = @post.place.id
    #場所名が登録されていればIDを検索
    else
      place = Place.where(place_name: place_name).order("created_at DESC").first
      place_id = place.id
    end
    #投稿と場所IDを紐づける
    @post.place_id = place_id
  end

  def post_params
    params.require(:post).permit(:image, :introduction)
  end

  def place_params
    params.require(:place).permit(:place_name)
  end

end
