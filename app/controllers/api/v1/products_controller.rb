module Api
  module V1
    class ProductsController < ApplicationController
      include Paginatable

      before_action :authenticate_user!, except: [:index, :show]
      before_action :set_product, only: [:show, :update, :destroy]

      def index
        authorize Product

        products = paginate(policy_scope(Product).includes(:brand, :category, :product_specifications))
        brands = policy_scope(Brand)
        categories = policy_scope(Category)
        render json: {
          products: products,
          brands: brands,
          categories: categories,
          meta: pagination_meta(products)
        }
      end

      def show
        authorize @product

        render json: {
          product: @product
        }
      end

      def create
        authorize Product

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
        authorize @product

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
        authorize @product

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
        @product = policy_scope(Product).includes(:brand, :category, :product_specifications).find_by(id: params[:id]) ||
                   policy_scope(Product).includes(:brand, :category, :product_specifications).find_by(slug: params[:id])
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