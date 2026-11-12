module Api
  module V1
    class PingsController < ApplicationController
      def index
        render json: {
          status: "ok",
          time: Time.current
        }
      end
    end
  end
end