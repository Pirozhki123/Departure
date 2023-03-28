class Admin::CustomerController < ApplicationController
  before_action :authenticate_admin!
  before_action :find_customer, only: [:show, :update]

  def index
    @customers = Customer.all
  end

  def show
    @posts = @customer.posts.page(params[:page])
  end

  def edit
  end

  def update
    if @customer.update(customer_params)
      redirect_to admin_customer_index_path(@customer), notice: "更新に成功しました"
    else
      render "admin/customer/edit", notice: "更新に失敗しました"
    end
  end

private

  def find_customer
    @customer = Customer.find(params[:id])
  end

  def customer_params
    params.require(:customer).permit(:is_deleted)
  end
end
