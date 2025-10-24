# app/controllers/api/client/loans_controller.rb
module Api
    module Client
      class LoansController < BaseController
        def index
          loans = @current_client.loans.includes(:payments)
  
          render json: loans.as_json(
            only: [:id, :amount, :interest_rate, :status, :created_at, :due_date],
            include: {
              payments: {
                only: [:id, :amount, :paid_at, :source]
              }
            }
          )
        end
  
        def show
          loan = @current_client.loans.find_by(id: params[:id])
  
          if loan
            render json: loan.as_json(
              only: [:id, :amount, :interest_rate, :status, :created_at, :due_date],
              include: {
                payments: {
                  only: [:id, :amount, :paid_at, :source]
                }
              }
            )
          else
            render json: { error: "Préstamo no encontrado" }, status: :not_found
          end
        end
      end
    end
  end
  