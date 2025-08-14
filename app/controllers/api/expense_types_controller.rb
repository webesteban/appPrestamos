class Api::ExpenseTypesController < Api::BaseController
  skip_forgery_protection

  def index
    render json: ExpenseType.all
  end
end
