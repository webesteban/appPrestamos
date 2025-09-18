class SettlementsController < ApplicationController
  include Pagy::Backend

  before_action :set_settlement, only: [:edit, :update, :recalculate, :close, :destroy]
  before_action :set_settlement_collection, only: [:show]

  def index
    scope = Settlement.includes(:collection).order(settlement_date: :desc)
    scope = scope.where(collection_id: params[:collection_id]) if params[:collection_id].present?
    scope = scope.where(settlement_date: params[:date]) if params[:date].present?

    @pagy, @settlements = pagy(scope, items: 25)
  end

  # PREVIEW sin persistir (mismo layout que show)
  # Requiere params[:collection_id]; opcional params[:date]
  def new
  end

  # Guarda la liquidación (snapshot) con datos enviados en el form
  def create
    date = params[:settlement][:settlement_date]

    @settlement = Settlements::BuildForDay.call(
      collection: @collection,
      date: date,
      created_by: current_user,
      base_override: params[:settlement][:base_start],
      other_expenses: params[:settlement][:other_expenses_total],
      other_note: params[:settlement][:other_expenses_note],
      delivered_cash: params[:settlement][:delivered_cash],
      persist: true
    )

    redirect_to @settlement, notice: "✅ Liquidación guardada correctamente."
  rescue => e
    flash.now[:alert] = "Error: #{e.message}"
    render :new, status: :unprocessable_entity
  end

  # Vista para registro ya persistido
  def show
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
  end

  def edit
  end

  def update
    @settlement.assign_attributes(settlement_params)
    @settlement.recompute_expected!
    @settlement.updated_by_id = current_user&.id
    @settlement.save!
    redirect_to @settlement, notice: "Liquidación actualizada."
  rescue => e
    flash.now[:alert] = "Error: #{e.message}"
    render :edit, status: :unprocessable_entity
  end

  # Relee del dominio (pagos/compras/gastos) y actualiza (reliquidación)
  def recalculate
    s = Settlements::BuildForDay.call(
      collection: @settlement.collection,
      date: @settlement.settlement_date,
      created_by: current_user,
      base_override: @settlement.base_start,
      other_expenses: @settlement.other_expenses_total,
      other_note: @settlement.other_expenses_note,
      delivered_cash: @settlement.delivered_cash,
      persist: true
    )
    @settlement.update!(status: :reliquidated) if @settlement.id != s.id
    redirect_to s, notice: "Reliquidada con datos actualizados."
  end

  def close
    @settlement.update!(status: :closed, updated_by_id: current_user&.id)
    redirect_to @settlement, notice: "Liquidación cerrada."
  end

  def destroy
    @settlement.destroy!
    redirect_to settlements_path, notice: "Liquidación eliminada."
  end

  private

  def settlement_params
    params.require(:settlement).permit(
      :collection_id, :settlement_date, :base_start, :other_expenses_total,
      :other_expenses_note, :delivered_cash
    )
  end

  def set_settlement
    @settlement = Settlement.find(params[:id])
  end

  def set_settlement_collection
    date = params[:date].present? ? params[:date].to_date : Date.today
    @settlement = Settlements::FetchOrCreate.call(collection_id: params[:id], date: date)
  end

  def set_collection_for_new_create
    @collection = Collection.find(params[:collection_id])
  end
end
