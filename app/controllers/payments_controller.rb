class PaymentsController < ApplicationController
  
  def index
    @payments = Payment.includes(:client, :loan, :user).all
  end

  def new
    @payment = Payment.new
    respond_to do |format|
      format.turbo_stream
    end
  end

  def edit
    @payment = Payment.find(params[:id])
    respond_to do |format|
      format.turbo_stream
    end
  end

  def create
    @payment = Payment.new(payment_params)
    if @payment.save
      redirect_to payments_path, notice: "Abono registrado exitosamente"
    else
      render :new, status: :unprocessable_entity, formats: [:turbo_stream]
    end
  end

  def update
    @payment = Payment.find(params[:id])
    if @payment.update(payment_params)
      redirect_to payments_path, notice: "Abono actualizado exitosamente"
    else
      render :edit, status: :unprocessable_entity, formats: [:turbo_stream]
    end
  end

  private

  def payload(status, message, redirect_url)
    {
      status: status,
      message: message,
      redirect_to: redirect_url
    }
  end

  def payment_params
    params.require(:payment).permit(:client_id, :loan_id, :user_id, :amount, :latitude, :longitude, :paid_at, :details)
  end

end
