class CollectionsController < ApplicationController
    before_action :set_collection, only: [:edit, :update]
  
    def new
      @collection = Collection.new
      @user_id = params[:user_id]
      respond_to do |format|
        format.turbo_stream
        format.html
      end
    end
  
    def create
      @collection = Collection.new(collection_params)
  
      if @collection.save
        CollectionUser.create(user_id: params[:user_id], collection: @collection) if params[:user_id]
        respond_to do |format|
          format.turbo_stream { redirect_to request.referer || root_path, notice: "Cobro creado exitosamente" }
          format.html { redirect_to request.referer || root_path, notice: "Cobro creado exitosamente" }
        end
      else
        render :new, status: :unprocessable_entity, formats: [:html, :turbo_stream]
      end
    end
  
    def edit
      @user_id = params[:user_id]
      respond_to do |format|
        format.turbo_stream
        format.html
      end
    end
  
    def update
      if @collection.update(collection_params)
        redirect_to request.referer || root_path, notice: "Cobro actualizado exitosamente"
      else
        render :edit, status: :unprocessable_entity, formats: [:html, :turbo_stream]
      end
    end
  
    private
  
    def set_collection
      @collection = Collection.find(params[:id])
    end
  
    def collection_params
      params.require(:collection).permit(
        :name, :description, :plate, :phone, :email, :city,
        :min_value, :max_value, :payment_method, :payment_term_id
      )
    end
  end
  