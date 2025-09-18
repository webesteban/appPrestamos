require "pagy/extras/array"

class ReportsController < ApplicationController
  include Pagy::Backend
  include ApplicationHelper

  def collections_progress
    @selected_date = params[:date].present? ? Date.parse(params[:date]) : Date.today

    loans_scope = Loan.includes(:payments, client: :collection)
                      .where(status: [:active, :overdue]) # 👈 Solo activos o en mora
                      .order(created_at: :desc)

    # --- Filtro de jerarquía obligatorio hasta ruta ---
    if params[:level] != "collection" || params[:hierarchy_id].blank?
      @loans = []
      @payments_count = 0
      @pagy, @loans = pagy_array([], items: 20) # 👈 Inicializar pagy vacío
      return
    end

    case params[:level]
    when "collection"
      loans_scope = loans_scope.joins(:client)
                               .where(clients: { collection_id: params[:hierarchy_id] })
    end

    # Filtro por rango de atraso
    if params[:overdue_range].present?
      range = case params[:overdue_range]
              when "0-10"   then 0..10
              when "11-20"  then 11..20
              when "21-30"  then 21..30
              when "31-40"  then 31..40
              when "41-50"  then 41..50
              when "51-60"  then 51..60
              when "60+"    then 61..Float::INFINITY
              end

      loans_scope = loans_scope.select { |l| range.include?(l.status_metrics[:overdue_days]) }
    end

    # Contar abonos del día
    @payments_count = Payment.where(created_at: @selected_date, loan_id: loans_scope.map(&:id)).count

    # Paginación
    if loans_scope.is_a?(Array)
      @pagy, @loans = pagy_array(loans_scope, items: 20)
    else
      @pagy, @loans = pagy(loans_scope, items: 20)
    end

    respond_to do |format|
      format.html
      format.csv { send_data generate_csv(@loans), filename: "collections-progress-#{Date.today}.csv" }
      format.xlsx { render xlsx: "collections_progress", filename: "collections-progress-#{Date.today}.xlsx" }
    end
  end

  def loans
    loans_scope = Loan.includes(client: :collection)
                      .where(status: [:active, :overdue])
                      .order(created_at: :desc)

    # --- Filtros por nombre ---
    if params[:full_name].present?
      loans_scope = loans_scope.joins(:client)
                               .where("clients.full_name LIKE ?", "%#{params[:full_name]}%")
    end

    # --- Filtro por jerarquía ---
    if params[:level].present? && params[:hierarchy_id].present?
      user = User.find_by_id(params[:hierarchy_id])
      case params[:level]
      when "owner"
        partner_ids   = User.where(parent_id: params[:hierarchy_id], hierarchy_level: :partner).pluck(:id)
        collector_ids = User.where(parent_id: partner_ids, hierarchy_level: :collector).pluck(:id)
        collection_ids = Collection.joins(:collection_users).where(collection_users: { user_id: collector_ids }).pluck(:id)
        loans_scope = loans_scope.joins(:client).where(clients: { collection_id: collection_ids })
        
        @selected_label = "#{user.full_name} (Dueño)"

      when "partner"
        collector_ids = User.where(parent_id: params[:hierarchy_id], hierarchy_level: :collector).pluck(:id)
        collection_ids = Collection.joins(:collection_users).where(collection_users: { user_id: collector_ids }).pluck(:id)
        loans_scope = loans_scope.joins(:client).where(clients: { collection_id: collection_ids })
        @selected_label = "#{user.full_name} (Socio)"

      when "collector"
        collection_ids = Collection.joins(:collection_users).where(collection_users: { user_id: params[:hierarchy_id] }).pluck(:id)
        loans_scope = loans_scope.joins(:client).where(clients: { collection_id: collection_ids })
        @selected_label = "#{user.full_name} (Cobrador)"

      when "collection"
        loans_scope = loans_scope.joins(:client).where(clients: { collection_id: params[:hierarchy_id] })

        @selected_label = "#{Collection.find(params[:hierarchy_id]).name} (Ruta)"
      end
    end

    # --- Filtro por rango de días de atraso ---
    if params[:overdue_range].present?
      range = case params[:overdue_range]
              when "0-10"   then 0..10
              when "11-20"  then 11..20
              when "21-30"  then 21..30
              when "31-40"  then 31..40
              when "41-50"  then 41..50
              when "51-60"  then 51..60
              when "60+"    then 61..Float::INFINITY
              end

      loans_scope = loans_scope.select { |l| range.include?(l.status_metrics[:overdue_days]) }
    end

    # --- Paginación ---
    if loans_scope.is_a?(Array)
      @pagy, @loans = pagy_array(loans_scope, items: 20)
    else
      @pagy, @loans = pagy(loans_scope, items: 20)
    end

    respond_to do |format|
      format.html
      format.csv { send_data generate_csv(@loans), filename: "loans-#{Date.today}.csv" }
      format.xlsx { render xlsx: "loans", filename: "loans-#{Date.today}.xlsx" }
    end
  end

  private

  def generate_csv(loans)
    CSV.generate(headers: true) do |csv|
      csv << ["Cliente", "Identificación", "Ruta", "Fecha Compra",
              "Fecha Finalización", "Monto", "Compra", "Abonado", "Saldo",
              "Días de atraso", "Días sin abonar", "Estado"]

      loans.each do |loan|
        status = loan.status_metrics
        csv << [
          loan.client.full_name,
          loan.client.identification,
          loan.client.collection&.name || "N/A",
          loan.created_at.to_date,
          loan.end_date,
          loan.amount,
          loan.total_with_interest,
          loan.total_paid,
          loan.remaining_balance,
          status[:overdue_days],
          status[:days_without_payment],
          loan.status_in_spanish
        ]
      end
    end
  end
end
