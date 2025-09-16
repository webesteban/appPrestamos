class ClientsController < ApplicationController
  def index
    @q = Client.ransack(params[:q])
    @pagy, @clients = pagy(@q.result, items: 1)

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def new
    @client = Client.new
    respond_to do |format|
      format.turbo_stream
    end
  end

  def edit
    @client = Client.find(params[:id])
    respond_to do |format|
      format.turbo_stream
    end
  end

  def create
    @client = Client.new(client_params)
    if @client.save
      redirect_to clients_path, notice: "Cliente creado exitosamente"
    else
      render :new, status: :unprocessable_entity, formats: [:turbo_stream]
    end
  end

  def update
    @client = Client.find(params[:id])
    if @client.update(client_params)
      redirect_to clients_path, notice: "Cliente actualizado exitosamente"
    else
      render :edit, status: :unprocessable_entity, formats: [:turbo_stream]
    end
  end

  def summary
    @client = Client.find(params[:id])
  
    respond_to do |format|
      format.turbo_stream { render partial: "clients/modal", locals: { client: @client } }
      format.html { head :not_found } # o redirect, o render normal si querés
    end
  end

  private

  def client_params
    params.require(:client).permit(
      :collection_id,
      :identification, :identification_type, :full_name, :identification_issued_at, :birth_date,
      :sex, :address, :mobile_phone, :landline_phone, :billing_address, :occupation, :workplace,
      :income, :reference1_name, :reference1_identification, :reference1_address, :reference1_phone,
      :reference2_name, :reference2_identification, :reference2_address, :reference2_phone,
      :email, :latitude, :longitude
    )
  end
end
