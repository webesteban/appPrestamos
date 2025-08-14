class Api::PaymentTermsController < Api::BaseController
  skip_forgery_protection

  def index
    render json: PaymentTerm.all
  end
end
