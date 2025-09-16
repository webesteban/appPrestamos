class Api::ExpenseTypesController < Api::BaseController

  def index
    render json: ExpenseType.all
  end
end
