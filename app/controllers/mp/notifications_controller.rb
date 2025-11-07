# app/controllers/mp/notifications_controller.rb
require 'mercadopago'
module Mp
    class NotificationsController < ActionController::API
      skip_before_action :verify_authenticity_token, raise: false
  
      def webhook
        payload = params.to_unsafe_h.deep_symbolize_keys
        topic   = payload[:topic].to_s
        log     = MpWebhookLog.create!(topic: topic, payload: payload, attempted: false)
      
        unless topic == 'payment'
          log.update!(message: "Ignored topic: #{topic}")
          return head :ok
        end
      
        payment_id = extract_payment_id(payload)
        unless payment_id.present?
          log.update!(message: "Missing payment_id in payload")
          return head :bad_request
        end
      
        access_token = PaymentCredential.where(status: :active).first.access_token
        sdk = Mercadopago::SDK.new(access_token)
        payment_data = sdk.payment.get(payment_id)&.dig(:response)
      
        unless payment_data
          log.update!(attempted: true, payment_id: payment_id, message: "Payment not found")
          return head :not_found
        end
      
        return head :ok unless payment_data["status"] == "approved"
      
        external_reference = payment_data["external_reference"]
        log.update!(attempted: true, payment_id: payment_id, external_reference: external_reference)
      
        match = external_reference.to_s.match(/loan_(\d+)_installment_(\d+)_client_(\d+)/)
        return head :bad_request unless match
      
        loan_id, installment_num, client_id = match[1..3].map(&:to_i)
        loan = Loan.find_by(id: loan_id, client_id: client_id)
        return head :not_found unless loan
      
        existing = loan.payments.where(source: 'mercado_pago', details: "Pago automático cuota ##{installment_num}").first
        unless existing
          loan.payments.create!(
            client_id: client_id,
            loan_id: loan.id,
            amount: loan.installment_value,
            paid_at: Date.today,
            source: 'mercado_pago',
            details: "Pago automático cuota ##{installment_num}"
          )
          loan.recalc_status!
          log.update!(message: "Payment recorded")
        else
          log.update!(message: "Payment already exists")
        end
      
        head :ok
      rescue => e
        log.update!(attempted: true, message: "Error: #{e.message}") if log
        Rails.logger.error("[MP::Webhook] #{e.class}: #{e.message}")
        head :internal_server_error
      end

      private

      def extract_payment_id(payload)
        payload[:id].to_s.presence || payload.dig(:notification, :resource).to_s[/\d+$/]
      end

    end
  end
  