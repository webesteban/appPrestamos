class PaymentTermsController < ApplicationController
    def index
        @payment_terms = PaymentTerm.all
    end
    
    def new
        @payment_term = PaymentTerm.new
        respond_to do |format|
            format.turbo_stream
        end
    end
    
    def edit
        @payment_term = PaymentTerm.find(params[:id])
        respond_to do |format|
            format.turbo_stream
        end
    end
    
    def create
        @payment_term = PaymentTerm.new(payment_term_params)
        if @payment_term.save
            redirect_to payment_terms_path, notice: "Modulo creada exitosamente"
        else
            render :new, status: :unprocessable_entity, formats: [:turbo_stream]
        end
    end
    
    def update
        @payment_term = PaymentTerm.find(params[:id])
        if @payment_term.update(payment_term_params)
            redirect_to payment_terms_path, notice: "Modulo actualizada exitosamente"
        else
            render :edit, status: :unprocessable_entity, formats: [:turbo_stream]
        end
    end
        
    private
        
    def payment_term_params
        params.require(:payment_term).permit(:percentage, :quota_days, :payment_frequency, :payment_days, :monthly)
    end

end
