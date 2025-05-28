class ReasonsController < ApplicationController
    def index
        @reasons = Reason.all
    end
    
    def new
        @reason = Reason.new
        respond_to do |format|
            format.turbo_stream
        end
    end
    
    def edit
        @reason = Reason.find(params[:id])
        respond_to do |format|
            format.turbo_stream
        end
    end
    
    def create
        @reason = Reason.new(reason_params)
        if @reason.save
            redirect_to reasons_path, notice: "Modulo creada exitosamente"
        else
            render :new, status: :unprocessable_entity, formats: [:turbo_stream]
        end
    end
    
    def update
        @reason = Reason.find(params[:id])
        if @reason.update(reason_params)
            redirect_to reasons_path, notice: "Modulo actualizada exitosamente"
        else
            render :edit, status: :unprocessable_entity, formats: [:turbo_stream]
        end
    end
        
    private
        
    def reason_params
        params.require(:reason).permit(:name)
    end
end
