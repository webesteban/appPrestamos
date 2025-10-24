# app/controllers/mp/notifications_controller.rb
require 'mercadopago'
module Mp
    class NotificationsController < ActionController::API
      skip_before_action :verify_authenticity_token, raise: false
  
      def webhook
        topic = params[:topic]
        id = params.dig(:data, :id) || params.dig(:data, :id).to_s
        return head :bad_request unless id.present?
  
        sdk = Mercadopago::SDK.new(ENV['MP_ACCESS_TOKEN'])
        payment_data = sdk.payment.get(id)&.dig(:response)
        return head :not_found unless payment_data
        return head :ok unless payment_data['status'] == 'approved'
  
        external_reference = payment_data['external_reference']
        match = external_reference.match(/loan_(\d+)_installment_(\d+)_client_(\d+)/)
        return head :bad_request unless match
  
        loan_id = match[1].to_i
        installment_number = match[2].to_i
        client_id = match[3].to_i
  
        loan = Loan.find_by(id: loan_id, client_id: client_id)
        return head :not_found unless loan
  
        existing = loan.payments.where(source: 'mercado_pago', details: "Pago automático cuota ##{installment_number}").first
        unless existing
          loan.payments.create!(
            client_id: client_id,
            loan_id: loan.id,
            amount: loan.installment_value,
            paid_at: Date.today,
            source: 'mercado_pago',
            details: "Pago automático cuota ##{installment_number}"
          )
          loan.recalc_status!
        end
  
        head :ok
      rescue => e
        Rails.logger.error("[MP::Webhook] Error processing payment: #{e.message}")
        head :internal_server_error
      end
    end
  end
  