module Api
  module V1
    class ProductsController < ApplicationController
      def index
        products = Product.all
        brands = Brand.all
        categories = Category.all
        render json: {
          products: products,
          brands: brands,
          categories: categories
        }
      end
    end
  end
end