class Public::PostsController < ApplicationController
  before_action :authenticate_customer!

  def index
  end

  def show
    @post = Post.find(params[:id])
  end

  def edit
    @post = Post.find(params[:id])
    @tag_list = @post.tags.pluck(:tag).join(',')
  end

  def update
    place_name = params[:post][:place]
    place_present = Place.where(place_name: place_name)
    if place_present.blank?
      @post.place = Place.new
      @post.place.place_name = place_name
      @post.place.save
      place_id = @post.place.id
    else
      place = Place.where(place_name: place_name).order('created_at DESC').first
      place_id = place.id
    end
    @post.place_id = place_id
    # #タグの保存処理
    tag_list = params[:post][:tag].delete(' ').delete('　').split(',')#送られたtag情報を「,」で区切ってスペースを削除
    if @post.update(post_params)
      @post.save_tags(tag_list) #save_tagsメソッドを実行（モデルに記載）
      redirect_to root_path, notice: "投稿が完了しました"
    else
      render 'public/homes/top'
    end
  end

  def create
    @post = Post.new(post_params)
    @posts = Post.all
    @post.customer_id = current_customer.id
    #場所の保存処理
    place_name = params[:post][:place]
    place_present = Place.where(place_name: place_name)
    if place_present.blank?
      @post.place = Place.new
      @post.place.place_name = place_name
      @post.place.save
      place_id = @post.place.id
    else
      place = Place.where(place_name: place_name).order('created_at DESC').first
      place_id = place.id
    end
    @post.place_id = place_id
    # #タグの保存処理
    tag_list = params[:post][:tag].delete(' ').delete('　').split(',')#送られたtag情報を「,」で区切ってスペースを削除
    if @post.save
      @post.save_tags(tag_list) #save_tagsメソッドを実行（モデルに記載）
      redirect_to root_path, notice: "投稿が完了しました"
    else
      render 'public/homes/top', notice: "投稿に失敗しました"
    end
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy
    redirect_back(fallback_location: root_path)
  end

  def edit
    @post = Post.find(params[:id])
  end

  private

  def post_params
    params.require(:post).permit(:image, :introduction)
  end

  def place_params
    params.require(:place).permit(:place_name)
  end

end
