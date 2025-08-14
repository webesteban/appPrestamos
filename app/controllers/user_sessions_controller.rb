class UserSessionsController < ApplicationController
    #skip_before_action :require_login, only: [:new, :create]

    layout "base"

    def new
    @user_session = UserSession.new
    end

    def create
    @user_session = UserSession.new(user_session_params.to_h)
    if @user_session.save
        redirect_to sections_path, notice: "Inicio de sesión exitoso"
    else
        render :new, status: :unprocessable_entity
    end
    end

    def destroy
    current_user_session&.destroy
    redirect_to login_path, notice: "Sesión cerrada"
    end

    private

    def user_session_params
    params.require(:user_session).permit(:username, :password)
    end
end
