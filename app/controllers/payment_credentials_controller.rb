class PaymentCredentialsController < ApplicationController
    def index
      @payment_credentials = PaymentCredential.all
  
      respond_to do |format|
        format.html
        format.turbo_stream
      end
    end
  
    def new
      @payment_credential = PaymentCredential.new
      respond_to do |format|
        format.turbo_stream
      end
    end
  
    def edit
      @payment_credential = PaymentCredential.find(params[:id])
      respond_to do |format|
        format.turbo_stream
      end
    end
  
    def create
      @payment_credential = PaymentCredential.new(payment_credential_params)
      if @payment_credential.save
        redirect_to payment_credentials_path, notice: "Credencial creada exitosamente"
      else
        render :new, status: :unprocessable_entity, formats: [:turbo_stream]
      end
    end
  
    def update
      @payment_credential = PaymentCredential.find(params[:id])
      if @payment_credential.update(payment_credential_params)
        redirect_to payment_credentials_path, notice: "Credencial actualizada exitosamente"
      else
        render :edit, status: :unprocessable_entity, formats: [:turbo_stream]
      end
    end
  
    private
  
    def payment_credential_params
      params.require(:payment_credential).permit(:name, :access_token, :country, :client_id, :client_secret, :status)
    end
  end
  