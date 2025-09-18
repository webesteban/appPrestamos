class SettlementWithdrawalsController < ApplicationController
    before_action :set_settlement
  
    def create
      @withdrawal = @settlement.withdrawals.create!(withdrawal_params)
      @settlement = Settlements::BuildForDay.call(
        collection: @settlement.collection,
        date: @settlement.settlement_date,
        created_by: current_user,
        base_override: @settlement.base_start,
        other_expenses: @settlement.other_expenses_total,
        other_note: @settlement.other_expenses_note,
        delivered_cash: @settlement.delivered_cash,
        persist: false
      )
      @settlement.save!
  
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @settlement, notice: "Retiro agregado." }
      end
    rescue => e
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("withdrawals_frame", partial: "settlement_withdrawals/list", locals: { settlement: @settlement, error: e.message }) }
        format.html { redirect_to @settlement, alert: "Error: #{e.message}" }
      end
    end
  
    def destroy
      withdrawal = @settlement.withdrawals.find(params[:id])
      withdrawal.destroy!
      @settlement = Settlements::BuildForDay.call(
        collection: @settlement.collection,
        date: @settlement.settlement_date,
        created_by: current_user,
        base_override: @settlement.base_start,
        other_expenses: @settlement.other_expenses_total,
        other_note: @settlement.other_expenses_note,
        delivered_cash: @settlement.delivered_cash,
        persist: false
      )
      @settlement.save!
  
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @settlement, notice: "Retiro eliminado." }
      end
    end
  
    private
  
    def set_settlement
      @settlement = Settlement.find(params[:settlement_id])
    end
  
    def withdrawal_params
      {
        amount: to_d(params.dig(:settlement_withdrawal, :amount)),
        destination: params.dig(:settlement_withdrawal, :destination),
        note: params.dig(:settlement_withdrawal, :note),
        user_id: current_user&.id,
        happened_at: params.dig(:settlement_withdrawal, :happened_at).presence || Time.current
      }
    end
  
    def to_d(x)
      BigDecimal(x.presence || 0)
    end
  end
  