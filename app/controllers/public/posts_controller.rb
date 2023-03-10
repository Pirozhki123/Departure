class Public::PostsController < ApplicationController
  def index
  end

  def show
  end

  def edit
    # @post = Post.find(params[:id])
    # @tag_list = @post.tags.pluck(:tag).join(',')
  end

  def update
    # @post = Post.find(params[:id])
    # place_present = Place.where(place_name: :place)
    # if place_present.blank?
    #   plase = Place.new(place_params)
    #   plase.place_name = params[:post][:place]
    # end
    # @post.place_id = place.id
    # #タグの保存処理
    # tag_list = params[:post][:tag].delete(' ').delete('　').split(',')#送られたtag情報を「,」で区切ってスペースを削除
    # if @post.update(post_params)
    #   @post.save_tags(tag_list) #save_tagsメソッドを実行（モデルに記載）
    #   redirect_to root_path, notice: "編集が完了しました"
    # end
  end

  def create
    @post = Post.new(post_params)
    @post.customer_id = current_customer.id
    @post.place_id = '1'#これがエラーの原因。Placeに対応したデータがないとエラーが出る
    #場所の保存処理
    # place_present = Place.where(place_name: :place)
    # if place_present.blank?
    #   @post.place = Place.new
    #   place.place_name = params[:post][:place]
    # end
    # @post.place_id = place.id
    # #タグの保存処理
    tag_list = params[:post][:tag].delete(' ').delete('　').split(',')#送られたtag情報を「,」で区切ってスペースを削除
    if @post.save
      @post.save_tags(tag_list) #save_tagsメソッドを実行（モデルに記載）
      redirect_to root_path, notice: "投稿が完了しました"
    end
  end

  private

  def post_params
    params.require(:post).permit(:image, :introduction)
  end

  def place_params
    params.require(:place).permit(:place_name)
  end

end
