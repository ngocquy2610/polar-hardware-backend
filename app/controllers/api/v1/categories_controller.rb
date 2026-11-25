module Api
  module V1
    class CategoriesController < ApplicationController
      before_action :authenticate_user!, except: [:index, :show]
      before_action :set_category, only: [:show, :update, :destroy]

      def index
        authorize Category

        categories = policy_scope(Category)
        render json: {
          categories: categories
        }, status: :ok
      end

      def update
        authorize @category

        if @category.update(category_params)
          render json: {
            message: "Category updated successfully",
            category: @category
          }, status: :ok
        else
          render json: {
            message: "Fail to update category",
            error: @category.errors.full_messages
          }, status: :unprocessable_entity
        end
      end

      def create
        authorize Category

        transaction do
          category = Category.new(category_params)
          category.category_attributes.build(attribute_params)
        end
        
        if category.save
          render json: {
            message: "Category created successfully",
            category: category,
            category_attribute: category.category_attributes
          }, status: :created
        else
          render json: {
            message: "Fail to create category",
            category_error: category.errors.full_messages
          }, status: :unprocessable_entity
        end
      end

      def destroy
        authorize @category

        if @category.destroy
          render json: {
            message: "Category deleted successfully"
          }, status: :ok
        else
          render json: {
            message: "Fail to delete category",
            error: @category.errors.full_messages
          }, status: :unprocessable_entity
        end
      end

      private

      def set_category
        @category = policy_scope(Category).find_by(id: id) ||
                    policy_scope(Category).find_by(slug: id)
        
        if @category.nil?
          render json: {
            error: "Category not found",
          }, status: :not_found
          return
        end
      end

      def category_params
        params.require(:category).permit(
          :name, :description, :status
        )
      end

      def attribute_params
        params.require(:category_attribute).permit(
          :name, :label, :data_type, :unit, :is_required, :is_filterable
        )
    end
  end
end