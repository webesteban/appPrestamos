# app/controllers/api/base_controller.rb
module Api
    class BaseController < ApplicationController
      before_action :authenticate_api_user
      skip_before_action :verify_authenticity_token
  
      private
  
      def authenticate_api_user
        token = request.headers['Authorization']
        @current_user = User.find_by(api_token: token)
  
        render json: { error: "No autorizado" }, status: :unauthorized unless @current_user
      end
    end
  end
  