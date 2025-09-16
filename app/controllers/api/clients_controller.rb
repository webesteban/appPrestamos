class Api::ClientsController < Api::BaseController

  def index
    render json: Client.all
  end

  def show
    render json: Client.find(params[:id])
  end

  def create
    client = Client.new(client_params)
    collection = @current_user.collections.presence&.first || Collection.first
    client.collection_id = collection.id
    if client.save
      render json: client, status: :created
    else
      render json: { errors: client.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    client = Client.find(params[:id])
    if client.update(client_params)
      render json: client
    else
      render json: { errors: client.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    client = Client.find(params[:id])
    client.destroy
    head :no_content
  end

  private

  def client_params
    params.require(:client).permit(
      :identification, :identification_type, :full_name,
      :identification_issued_at, :birth_date, :sex,
      :address, :mobile_phone, :landline_phone,
      :billing_address, :occupation, :workplace,
      :income, :reference1_name, :reference1_identification,
      :reference1_address, :reference1_phone,
      :reference2_name, :reference2_identification,
      :reference2_address, :reference2_phone,
      :email, :latitude, :longitude
    )
  end
end
