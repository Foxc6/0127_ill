class PreferencesController <  ApplicationController
  before_action :set_preference, only: [:show, :edit, :update, :destroy]

  def index
    @preference = Preference.first
    if @preference
      redirect_to action: 'show', id: @preference.id
    else
      redirect_to action: 'new'
    end
  end

  def new
    @preference = Preference.first
    if @preference.present?
      redirect_to action: 'show', id: @preference.id
    else
      @preference = Preference.new
    end
  end

  def create
    @preference = Preference.first
    if @preference.present?
      @preference.update(preference_params)
      redirect_to action: 'show', id: @preference.id
    else
      @preference = Preference.new(preference_params)
      respond_to do |format|
        if @preference.save
          format.html { redirect_to @preference, notice: 'Preferences were set.' }
          format.json { render :show, status: :created, location: @preference }
        else
          format.html { render :new }
          format.json { render json: @preference.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  def show
    @options = Option.all

    if @options.all? {|option| option[:value].present? }
      @preference.is_setup = true
      @preference.save
    end
  end

  def edit
  end

  def update
    @preference.update(preference_params)
  end

  private

  def set_preference
    if params[:id]
      @preference = Preference.find(params[:id])
    else
      redirect_to action: 'index'
    end
  end

  def preference_params
      params.require(:preference).permit(
        :name,
        :company,
        :url,
        :meta_description,
        :meta_keywords,
        :seo_title,
        :mail_from_address,
        :default,
        :logo,
        :default_country_code,
        :is_domestic,
        :is_setup
        )
  end
end
