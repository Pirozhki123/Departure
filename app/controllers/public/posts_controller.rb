class Public::PostsController < ApplicationController
  before_action :authenticate_customer!
  before_action :find_post, only: [:show, :edit, :update]

  def index
    @post = Post.new
    @posts = Post.all.order(updated_at: :desc).page(params[:page])
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
    tag_list = params[:post][:tag].delete(" ").delete("　").split(",")#送られたtag情報を「,」で区切ってスペースを削除
    if @post.update(post_params)
      @post.save_tags(tag_list) #save_tagsメソッドを実行（モデルに記載）
      redirect_to public_post_path(@post), notice: "編集が完了しました"
    else
      render "public/homes/top"
    end
  end


  def create
    @post = Post.new(post_params)
    @posts = Post.all.page(params[:page])
    @post.customer_id = current_customer.id
    #場所の保存処理
    save_place
    #タグの保存処理
    tag_list = params[:post][:tag].delete(" ").delete("　").split(",")#送られたtag情報を「,」で区切ってスペースを削除

    if @post.save
      #Vision APIを利用したタグ追加処理
      vision_tags = Vision.get_image_data(@post.image)
      if tag_list.present?
        tag_list = tag_list + vision_tags
      else
        tag_list = vision_tags
      end

      @post.save_tags(tag_list) #save_tagsメソッドを実行（モデルに記載）
      redirect_to root_path, notice: "投稿しました #{vision_tags}"
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

  def save_place #場所の保存処理
    place_name = params[:post][:place]
    place_present = Place.where(place_name: place_name)
    if place_present.blank?
      @post.place = Place.new
      @post.place.place_name = place_name
      @post.place.save
      place_id = @post.place.id
    else
      place = Place.where(place_name: place_name).order("created_at DESC").first
      place_id = place.id
    end
    @post.place_id = place_id
  end

  def post_params
    params.require(:post).permit(:image, :introduction)
  end

  def place_params
    params.require(:place).permit(:place_name)
  end

end
