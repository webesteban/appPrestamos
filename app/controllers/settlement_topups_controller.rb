class SettlementTopupsController < ApplicationController
    before_action :set_settlement
  
    def create
      @topup = @settlement.topups.create!(topup_params)
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
      
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @settlement, notice: "Retanqueo agregado." }
      end
    rescue => e
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("topups_frame", partial: "settlement_topups/list", locals: { settlement: @settlement, error: e.message }) }
        format.html { redirect_to @settlement, alert: "Error: #{e.message}" }
      end
    end
  
    def destroy
      topup = @settlement.topups.find(params[:id])
      topup.destroy!
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
        format.html { redirect_to @settlement, notice: "Retanqueo eliminado." }
      end
    end
  
    private
  
    def set_settlement
      @settlement = Settlement.find(params[:settlement_id])
    end
  
    def topup_params
      {
        amount: to_d(params.dig(:settlement_topup, :amount)),
        note: params.dig(:settlement_topup, :note),
        user_id: current_user&.id,
        happened_at: params.dig(:settlement_topup, :happened_at).presence || Time.current
      }
    end
  
    def to_d(x)
      BigDecimal(x.presence || 0)
    end
  end
  