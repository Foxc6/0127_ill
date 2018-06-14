class TeamsController < ApplicationController

  before_action :set_team, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!

  # GET /teams
  # GET /teams.json
  def index
    if params[:search]
      @contacts = Contact.team_scope().user_scope().search(params[:search]).order(:last_name).paginate(:page => params[:page])
    else
      @contacts = Contact.team_scope().user_scope().order(:last_name).paginate(:page => params[:page])
    end

    @total_records = @contacts.count
    @total_records_goal = 50
    @total_records_clr = @total_records >= @total_records_goal ? 'green' : 'red'
  end

  # GET /teams/1
  # GET /teams/1.json
  def show
    @emails = @contact.emails
    @addresses = @contact.addresses
    @phone_numbers = @contact.phone_numbers
    @website_urls = @contact.website_urls
    @contact_skills = @contact.contact_skills
    @projects = Project.where(:team_contact_id => @contact.id).order('project_number DESC')
    @agency_projects = Project.where(:agency_team_contact_id => @contact.id).order('project_number DESC')
  end

  # GET /teams/new
  def new
    @contact = Contact.new
    load_lists
  end

  # GET /teams/1/edit
  def edit
    load_lists
    a = Address.where(contact_id: @contact.id).first
    if a
      @state = State.where(id: a.state_id).first
    else
      @state = @states.first
    end
  end

  # POST /teams
  # POST /teams.json
  def create
    @contact = Contact.new(contact_params)
    @contact.locale_id = current_user.locale_id
    @contact.contact_type_id = 12
    @contact.is_team = true
    respond_to do |format|
      if @contact.save
        format.html { redirect_to team_path(@contact), notice: 'Contact was successfully created.' }
        format.json { render :show, status: :created, location: @contact }
      else
        flash[:error] = @contact.errors.full_messages
        @contact = Contact.new(contact_params)
        load_lists
        format.html { render :new }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /teams/1
  # PATCH/PUT /teams/1.json
  def update
    respond_to do |format|
      @contact.contact_type_id = 12

      if @contact.update(contact_params)
        format.html { redirect_to team_path(@contact), notice: 'Contact was successfully updated.' }
        format.json { render :show, status: :ok, location: @contact }
      else
        flash[:error] = @contact.errors.full_messages
        format.html { render :edit }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /teams/1
  # DELETE /teams/1.json
  def destroy
    @contact.destroy
    respond_to do |format|
      format.html { redirect_to contacts_url, notice: 'Contact was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_team
      @contact = Contact.user_scope().find_by(id: params[:id])
      if !@contact.present?
        redirect_to teams_path, :flash => { :error => "Team member Not Found!" }
      end
    end

    def load_lists
      @contact_types = ContactType.all
      @time_zones = TimeZone.all
      @social_networks = SocialNetwork.all
      @states = State.all.order('name ASC')
      @countries = Country.all.order('name ASC')
      @default_country = Option.where(:key=>'default_country_id').first.value
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def contact_params
      params.require(:contact).permit(
        :first_name,
        :last_name,
        :email,
        :about,
        :contact_type_id,
        :profile_image,
        :locale_id,
        :website_url,
        :contact_skill,
        :agenda,
        :wants_general,
        :wants_specifically,
        :values,
        :invisible,
        :slug,
        :company_name,
        :title,
        :time_zone_id,
        addresses_attributes: [:id, :name, :address1, :address2, :city, :state_id, :country_id, :postal_code, :_destroy],
        emails_attributes: [:id, :name, :email, :contact_id, :_destroy],
        website_urls_attributes: [:id, :name, :url, :contact_id, :_destroy],
        contact_skills_attributes: [:id, :name, :contact_id, :_destroy],
        phone_numbers_attributes: [:id, :name, :number, :contact_id, :_destroy],
        social_reaches_attributes: [:id, :total_reach, :username, :social_network_id, :contact_id, :_destroy]
      )
    end

end
