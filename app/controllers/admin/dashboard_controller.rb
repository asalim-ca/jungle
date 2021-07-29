class Admin::DashboardController < AdminController

  def show
    @products = Product.all
    @categories = Category.all
  end
end
