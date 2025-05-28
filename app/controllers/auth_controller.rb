class AuthController < ApplicationController

  layout "base"

  def auth_2fa
    render template: "auth/2fa"
  end

  def account_deactivation
  end

  def confirm_mail
  end

  def create_password
  end

  def lock_screen
  end

  def login
  end

  def login_pin
  end

  def logout
  end

  def recover_password
  end

  def register
  end
end
