class Public::PostsController < ApplicationController
  def index
  end

  def show
  end

  def edit
  end

  def create
    @post = Post.new(post_params)
    @post.customer_id = current_customer.id
    #場所が存在すればidを入れる。無ければ新規作成。
    place_present = Place.where(place_name: :place)
    if place_present.blank?
      @plase = Place.new(place_params)
      @plase.place_name = :place
    end
    @post.place_id = place.id
  end

  private

  def post_params
    params.require(:post).permit(:image, :introduction)
  end

  def place_params
    params.require(:place).permit(:place_name)
  end

end
