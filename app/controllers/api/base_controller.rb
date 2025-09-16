# app/controllers/api/base_controller.rb
module Api
    class BaseController < ActionController::API
      before_action :authenticate_api_user
  
      private
  
      def authenticate_api_user
        token = request.headers['Authorization']
        @current_user = User.find_by(api_token: token)
  
        render json: { error: "No autorizado" }, status: :unauthorized unless @current_user
      end
    end
  end
  