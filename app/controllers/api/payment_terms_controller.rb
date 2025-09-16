class Api::PaymentTermsController < Api::BaseController
  

  def index
    render json: PaymentTerm.all
  end
end
