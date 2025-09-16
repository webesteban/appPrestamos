class SectionsController < ApplicationController
  def index
    @q = Section.ransack(params[:q])
    @pagy, @sections = pagy(@q.result, items: 10)

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end
  
  def new
    @section = Section.new
    respond_to do |format|
      format.turbo_stream
    end
  end
  
  def edit
    @section = Section.find(params[:id])
    respond_to do |format|
      format.turbo_stream
    end
  end
  
  def create
    @section = Section.new(section_params)
    if @section.save
      redirect_to sections_path, notice: "Modulo creada exitosamente"
    else
      render :new, status: :unprocessable_entity, formats: [:turbo_stream]
    end
  end
  
  def update
    @section = Section.find(params[:id])
    if @section.update(section_params)
      redirect_to sections_path, notice: "Modulo actualizada exitosamente"
    else
      render :edit, status: :unprocessable_entity, formats: [:turbo_stream]
    end
  end
  
  private
  
  def section_params
    params.require(:section).permit(:name, :code, :description)
  end
  
end
