module Api
  module V1
    class BrandsController < ApplicationController
      before_action :authenticate_user!, except: [:index, :show]
      before_action :set_brand, only: [:show, :update, :destroy]
      def index
        authorize Brand
        brands = policy_scope(Brand)
        
        render json: {
          brands: brands
        }, status: :ok
      end

      def show
        authorize @brand
        render json: {
          brand: @brand
        }, status: :ok
      end

      def update
        authorize @brand

        if @brand.update(brand_params)
          render json: {
            message: "Brand updated successfully",
            brand: @brand
          }, status: :ok
        else
          render json: {
            message: "Fail to update brand",
            error: @brand.errors.full_messages
          }, status: :unprocessable_entity
        end
      end

      def create
        authorize Brand

        brand = Brand.new(brand_params)
        if brand.save
          render json: {
            message: "Brand created successfully",
            brand: brand
          }, status: :created
        else
          render json: {
            message: "Fail to create brand",
            error: brand.errors.full_messages
          }, status: :unprocessable_entity
        end
      end

      def destroy
        authorize @brand

        if @brand.destroy
          render json: {
            message: "Brand deleted successfully",
          }, status: :ok
        else
          render json: {
            message: "Fail to delete brand",
            error: @brand.errors.full_messages
          }, status: :unprocessable_entity
        end
      end

      private

      def set_brand
        @brand = policy_scope(Brand).find_by(id: params[:id]) || policy_scope(Brand).find_by(slug: params[:id])

        if @brand.nil?
          render json: {
            error: "Brand not found"
          }, status: :not_found
          return
        end
      end

      def brand_params
        params.require(:brand).permit(
          :name,
          :description,
          :logo,
          :status
        )
      end
    end
  end
end