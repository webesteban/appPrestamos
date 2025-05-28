class TracksController < ApplicationController
    def index
        @tracks = Track.all
    end
    
    def new
        @track = Track.new
        respond_to do |format|
            format.turbo_stream
        end
    end
    
    def edit
        @track = Track.find(params[:id])
        respond_to do |format|
            format.turbo_stream
        end
    end
    
    def create
        @track = Track.new(track_params)
        if @track.save
            redirect_to tracks_path, notice: "Modulo creada exitosamente"
        else
            render :new, status: :unprocessable_entity, formats: [:turbo_stream]
        end
    end
    
    def update
        @track = Track.find(params[:id])
        if @track.update(track_params)
            redirect_to tracks_path, notice: "Modulo actualizada exitosamente"
        else
            render :edit, status: :unprocessable_entity, formats: [:turbo_stream]
        end
    end
        
    private
        
    def track_params
        params.require(:track).permit(:name)
    end
end
