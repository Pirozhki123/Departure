class Admin::CustomerController < ApplicationController
  before_action :authenticate_admin!
  def index
    @customers = Customer.all
  end

  def show
    @customer = Customer.find(params[:id])
  end

  def edit
  end

  def update
    @customer = Customer.find(params[:id])
    if @customer.update(customer_params)
      redirect_to admin_customer_path(@customer), notice: "更新に成功しました"
    else
      render 'admin/customer/edit', notice: "更新に失敗しました"
    end
  end

  private

  def customer_params
    params.require(:customer).permit(:is_deleted)
  end
end
