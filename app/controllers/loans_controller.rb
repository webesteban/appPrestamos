class LoansController < ApplicationController
  def index
    @loans = Loan.includes(:client, :payment_term).all
  end

  def new
    @loan = Loan.new
    respond_to do |format|
      format.turbo_stream
    end
  end

  def edit
    @loan = Loan.find(params[:id])
    respond_to do |format|
      format.turbo_stream
    end
  end

  def create
    @loan = Loan.new(loan_params)
    if @loan.save
      redirect_to loans_path, notice: "Préstamo creado exitosamente"
    else
      render :new, status: :unprocessable_entity, formats: [:turbo_stream]
    end
  end

  def update
    @loan = Loan.find(params[:id])
    if @loan.update(loan_params)
      redirect_to loans_path, notice: "Préstamo actualizado exitosamente"
    else
      render :edit, status: :unprocessable_entity, formats: [:turbo_stream]
    end
  end

  private

  def loan_params
    params.require(:loan).permit(:payment_term_id, :client_id, :installment_days, :amount, :details, :insurance_amount, :insurance)
  end
end
