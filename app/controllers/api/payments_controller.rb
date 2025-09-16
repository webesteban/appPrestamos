class Api::PaymentsController < Api::BaseController
  

  def index
    render json: Payment.all
  end

  def show
    render json: Payment.find(params[:id])
  end

  def create
    payment = Payment.new(payment_params)
    if payment.save
      render json: payment, status: :created
    else
      render json: { errors: payment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    payment = Payment.find(params[:id])
    if payment.update(payment_params)
      render json: payment
    else
      render json: { errors: payment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    payment = Payment.find(params[:id])
    payment.destroy
    head :no_content
  end

  private

  def payment_params
    params.require(:payment).permit(
      :client_id, :loan_id, :amount,
      :latitude, :longitude, :paid_at,
      :details, :user_id
    )
  end
end
