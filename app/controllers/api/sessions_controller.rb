# app/controllers/api/sessions_controller.rb
module Api
  class SessionsController < ApplicationController
    skip_before_action :verify_authenticity_token

    def create
      user_session = UserSession.new(username: params[:username], password: params[:password])

      if user_session.save
        user = user_session.user
        user.update(api_token: SecureRandom.hex(32)) # renovás el token por seguridad

        render json: {
          message: "Login exitoso",
          token: user.api_token,
          user: user.slice(:id, :username, :role_id, :hierarchy_level)
        }, status: :ok
      else
        render json: { error: "Credenciales inválidas" }, status: :unauthorized
      end
    end

    def destroy
      token = request.headers['Authorization']
      user = User.find_by(api_token: token)

      if user
        user.update(api_token: nil)
        render json: { message: "Logout exitoso" }, status: :ok
      else
        render json: { error: "Token inválido" }, status: :unauthorized
      end
    end
  end
end
