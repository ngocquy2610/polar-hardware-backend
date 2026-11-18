module Api
  module V1
    class ProductsController < ApplicationController
      before_action :set_product, only: [:show, :update, :destroy]
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

      def show
        render json: {
          product: @product
        }
      end

      def create
        product = Product.new(product_params)
        if product.save
          # save is a function, call save, then model will send INSERT query to DB, check success
          render json: {
            message: "Product created successfully",
            product: product
          }, status: :created
        else
          render json: {
            message: "Fail to create product",
            error: product.errors.full_messages
          }, status: :unprocessable_entity
        end
      end

      def update
        if @product.update(product_params)
          render json: {
            message: "Product updated successfully",
            product: @product
          }, status: :ok
        else
          render json: {
            message: "Fail to update product",
            error: @product.errors.full_messages
          }, status: :unprocessable_entity
        end
      end

      def destroy
        if @product.destroy
          render json: {
            message: "Product destroyed successfully"
          }, status: :ok
        else
          render json: {
            message: "Fail to delete product",
            error: @product.errors.full_messages
          }, status: :unprocessable_entity
        end
      end

      private

      def set_product
        @product = Product.find_by(id: params[:id]) || Product.find_by(slug: params[:id])
        if @product.nil?
          render json: {
            error: "Product not found"
          }, status: :not_found
          return
        end
      end

      def product_params
        params.require(:product).permit(
          :name,
          :slug,
          :sku,
          :description,
          :price,
          :compare_at_price,
          :cost_price,
          :stock_status,
          :status,
          :brand_id,
          :category_id
        )
      end
    end
  end
end