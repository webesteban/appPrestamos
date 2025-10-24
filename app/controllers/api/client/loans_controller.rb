# app/controllers/api/client/loans_controller.rb
module Api
    module Client
      class LoansController < BaseController
        def index
          loans = @current_client.loans.includes(:payments)
        
          render json: loans.map { |loan|
            loan.as_json(
              only: [:id, :amount, :interest_rate, :status, :created_at, :due_date]
            ).merge(
              payment_status: loan.payment_status,
              payments: loan.payments.as_json(only: [:id, :amount, :paid_at, :source])
            )
          }
        end        
  
        def show
          loan = @current_client.loans.includes(:payments).find_by(id: params[:id])
        
          if loan
            render json: loan.as_json(
              only: [:id, :amount, :interest_rate, :status, :created_at, :due_date]
            ).merge(
              payment_status: loan.payment_status,
              payments: loan.payments.as_json(only: [:id, :amount, :paid_at, :source])
            )
          else
            render json: { error: "Préstamo no encontrado" }, status: :not_found
          end
        end
      end
    end
  end
  