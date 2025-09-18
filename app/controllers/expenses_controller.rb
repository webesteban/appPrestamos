class ExpensesController < ApplicationController
    before_action :set_settlement
  
    def create
      @expense = @settlement.collection.expenses.new(expense_params)
  
      if @expense.save
        @settlement = Settlements::BuildForDay.call(
          collection: @settlement.collection,
          date: @settlement.settlement_date,
          created_by: current_user,
          base_override: @settlement.base_start,
          other_expenses: @settlement.other_expenses_total,
          other_note: @settlement.other_expenses_note,
          delivered_cash: @settlement.delivered_cash,
          persist: false
        ) # recalcula totales con este gasto
  
        respond_to do |format|
          format.turbo_stream
          format.html { redirect_to @settlement, notice: "✅ Gasto registrado." }
        end
      else
        render :new, status: :unprocessable_entity
      end
    end
  
    private
  
    def set_settlement
      @settlement = Settlement.find(params[:settlement_id])
    end
  
    def expense_params
      params.require(:expense).permit(:amount, :description, :created_at, :expense_type_id, :user_id)
    end
  end
  