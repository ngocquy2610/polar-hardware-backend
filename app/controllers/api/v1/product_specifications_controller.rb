module Api
  module V1
    class ProductSpecificationsController < ApplicationController
      before_action :set_product_specification, only: [:update, :destroy]
      def create
        authorize ProductSpecification

        product_specification = ProductSpecification.new(specification_params)
        if product_specification.save
          render json: {
            message: "Product Specification created successfully",
            product_specification: product_specification
          }, status: :created
        else
          render json: {
            message: "Fail to create Product Specification",
            error: product_specification.errors.full_messages
          }, status: :unprocessable_entity
        end
      end

      def update
        authorize @product_specification

        if @product_specification.update(specification_params)
          render json: {
            message: "Product Specification updated successfully",
            product_specification: @product_specification
          }, status: :ok
        else
          render json: {
            message: "Fail to update Product Specification",
            error: @product_specification.errors.full_messages
          }, status: :unprocessable_entity
        end
      end

      def destroy
        authorize @product_specification

        if @product_specification.destroy
          render json: {
            message: "Product Specification deleted seccessfully"
          }, status: :ok
        else
          render json: {
            message: "Fail to delete Product Specification",
            error: @product_specification.errors.full_messages
          }, status: :unprocessable_entity
        end
      end

      private

      def set_product_specification
        @product_specification = ProductSpecification.find_by(id: id)

        if @product_specification.nil?
          render json: {
            message: "Product Specification not found"
          }, status: :not_found
          return
        end
      end

      def specification_params
        params.require(:product_specification).permit(
          :product_id, :category_attribute_id, :value_string, :value_number, :value_string
        )
      end
    end
  end
end