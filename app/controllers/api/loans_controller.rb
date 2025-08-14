class Api::LoansController < ApplicationController
  skip_forgery_protection

  def index
    render json: Loan.all
  end

  def show
    render json: Loan.find(params[:id])
  end

  def create
    loan = Loan.new(loan_params)
    if loan.save
      render json: loan, status: :created
    else
      render json: { errors: loan.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    loan = Loan.find(params[:id])
    if loan.update(loan_params)
      render json: loan
    else
      render json: { errors: loan.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    loan = Loan.find(params[:id])
    loan.destroy
    head :no_content
  end

  private

  def loan_params
    params.require(:loan).permit(
      :payment_term_id, :installment_days,
      :amount, :details, :insurance_amount,
      :insurance, :client_id, :latitude, :longitude
    )
  end
end
