# app/controllers/mp/feedback_controller.rb
module Mp
    class FeedbackController < ApplicationController
      layout "payment_feedback"
      skip_before_action :require_login, raise: false
  
      def success
        render_feedback("success", "¡Pago aprobado!", "app://payment_success")
      end
  
      def failure
        render_feedback("failure", "El pago fue rechazado.", "app://payment_failure")
      end
  
      def pending
        render_feedback("pending", "Tu pago está en revisión.", "app://payment_pending")
      end
  
      private
  
      def render_feedback(status, message, redirect_url)
        respond_to do |format|
          format.html # uses views in mp/feedback
          format.json { render json: { status: status, message: message, redirect_to: redirect_url } }
        end
      end
    end
  end
  