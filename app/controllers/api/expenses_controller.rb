class Api::ExpensesController < Api::BaseController
    before_action :set_expense, only: [:destroy]

    def index
    @expenses = Expense.where(active: true).includes(:expense_type, :user)
    render json: @expenses.as_json(
        only: [:id, :amount],
        include: {
        expense_type: { only: [:id, :name] }
        }
    )
    end

    def create
    @expense = Expense.new(expense_params)
    @expense.user = @current_user # viene de authenticate_api_user

    if @expense.save
        render json: @expense, status: :created
    else
        render json: { errors: @expense.errors.full_messages }, status: :unprocessable_entity
    end
    end

    def destroy
    if @expense.update(active: false)
        render json: { message: "Gasto desactivado" }
    else
        render json: { errors: @expense.errors.full_messages }, status: :unprocessable_entity
    end
    end

    private

    def set_expense
    @expense = Expense.find_by(id: params[:id], active: true)
    render json: { error: "No encontrado" }, status: :not_found unless @expense
    end

    def expense_params
    params.require(:expense).permit(:expense_type_id, :amount)
    end
end
