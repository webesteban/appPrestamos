# app/controllers/api/client/base_controller.rb
module Api
    module Client
      class BaseController < ActionController::API
        before_action :authenticate_client
  
        private
  
        def authenticate_client
          token = request.headers['Authorization']
          @current_client = ::Client.find_by(api_token: token)
  
          render json: { error: "No autorizado" }, status: :unauthorized unless @current_client
        end
      end
    end
  end
  