class ExpenseTypesController < ApplicationController
    def index
        @expense_types = ExpenseType.all
      end
      
      def new
        @expense_type = ExpenseType.new
        respond_to do |format|
          format.turbo_stream
        end
      end
      
      def edit
        @expense_type = ExpenseType.find(params[:id])
        respond_to do |format|
          format.turbo_stream
        end
      end
      
      def create
        @expense_type = ExpenseType.new(expense_type_params)
        if @expense_type.save
          redirect_to expense_types_path, notice: "Modulo creada exitosamente"
        else
          render :new, status: :unprocessable_entity, formats: [:turbo_stream]
        end
      end
      
      def update
        @expense_type = ExpenseType.find(params[:id])
        if @expense_type.update(expense_type_params)
          redirect_to expense_types_path, notice: "Modulo actualizada exitosamente"
        else
          render :edit, status: :unprocessable_entity, formats: [:turbo_stream]
        end
      end
        
      private
        
        def expense_type_params
          params.require(:expense_type).permit(:name, :max_value)
        end
end
