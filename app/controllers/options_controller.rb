class OptionsController < ApplicationController
  before_action :set_option, only: [:show, :edit, :update, :destroy]

  def index
    @options = Option.all
  end


  def show
  end


  def new
    @option = Option.new
  end


  def edit
  end


  def create
    @preference = Preference.first
    @option = Option.new(option_params)
    if @option.save!
      redirect_to preference_path(@preference)
    end
  end


  def update
    @preference = params["preference"]
    @option.update(option_params)
    redirect_to preference_path(@preference)

  end


  def destroy
    @preference = Preference.first
    @option.destroy
    respond_to do |format|
      format.html { redirect_to preference_path(@preference), notice: 'Option was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    def set_option
      @option = Option.find(params[:id])
    end


    def option_params
      params.require(:option).permit(:key, :value)
    end
end
