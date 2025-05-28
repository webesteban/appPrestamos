class StatusesController < ApplicationController
    def index
        @statuses = Status.all
      end
      
      def new
        @status = Status.new
        respond_to do |format|
          format.turbo_stream
        end
      end
      
      def edit
        @status = Status.find(params[:id])
        respond_to do |format|
          format.turbo_stream
        end
      end
      
      def create
        @status = Status.new(status_params)
        if @status.save
          redirect_to statuses_path, notice: "Modulo creada exitosamente"
        else
          render :new, status: :unprocessable_entity, formats: [:turbo_stream]
        end
      end
      
      def update
        @status = Status.find(params[:id])
        if @status.update(status_params)
          redirect_to statuses_path, notice: "Modulo actualizada exitosamente"
        else
          render :edit, status: :unprocessable_entity, formats: [:turbo_stream]
        end
    end
        
      private
        
        def status_params
          params.require(:status).permit(:name)
        end
end
