class ThirdPartyTypesController < ApplicationController
    def index
      @q = ThirdPartyType.ransack(params[:q])
      @pagy, @third_party_types = pagy(@q.result, items: 1)

      respond_to do |format|
        format.html
        format.turbo_stream
      end
    end
      
      def new
        @third_party_type = ThirdPartyType.new
        respond_to do |format|
          format.turbo_stream
        end
      end
      
      def edit
        @third_party_type = ThirdPartyType.find(params[:id])
        respond_to do |format|
          format.turbo_stream
        end
      end
      
      def create
        @third_party_type = ThirdPartyType.new(third_party_type_params)
        if @third_party_type.save
          redirect_to third_party_types_path, notice: "Modulo creada exitosamente"
        else
          render :new, status: :unprocessable_entity, formats: [:turbo_stream]
        end
      end
      
      def update
        @third_party_type = ThirdPartyType.find(params[:id])
        if @third_party_type.update(third_party_type_params)
          redirect_to third_party_types_path, notice: "Modulo actualizada exitosamente"
        else
          render :edit, status: :unprocessable_entity, formats: [:turbo_stream]
        end
    end
        
      private
        
        def third_party_type_params
          params.require(:third_party_type).permit(:name)
        end
end
