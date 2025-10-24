# app/controllers/api/client/sessions_controller.rb
module Api
    module Client
      class SessionsController < ActionController::API
        def create
          session = ClientSession.new(username: params[:username], password: params[:password])
  
          if session.save
            client = session.client
            client.update(api_token: SecureRandom.hex(32))
  
            render json: {
              message: "Login exitoso",
              token: client.api_token,
              client: client.slice(:id, :username, :full_name, :email)
            }, status: :ok
          else
            render json: { error: "Credenciales inválidas" }, status: :unauthorized
          end
        end
  
        def destroy
          token = request.headers['Authorization']
          client = ::Client.find_by(api_token: token)
  
          if client
            client.update(api_token: nil)
            render json: { message: "Logout exitoso" }, status: :ok
          else
            render json: { error: "Token inválido" }, status: :unauthorized
          end
        end
      end
    end
  end
  