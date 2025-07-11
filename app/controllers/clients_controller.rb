# app/controllers/clients_controller.rb
class ClientsController < ApplicationController
    def index
      @clients = Client.all
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
  
    private
  
    def client_params
      params.require(:client).permit(
        :identification, :identification_type, :full_name, :identification_issued_at, :birth_date,
        :sex, :address, :mobile_phone, :landline_phone, :billing_address, :occupation, :workplace,
        :income, :reference1_name, :reference1_identification, :reference1_address, :reference1_phone,
        :reference2_name, :reference2_identification, :reference2_address, :reference2_phone,
        :email, :latitude, :longitude
      )
    end
  end
  