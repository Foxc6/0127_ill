require 'open-uri'
require 'nokogiri'
class ContactsController < ApplicationController
  before_action :set_contact, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!
  helper_method :sort_column, :sort_direction


  # GET /contacts
  # GET /contacts.json
  def index
      # Contacts search query
      #@contacts = Contact.general_scope().user_scope().search(params[:search]).full_name_order_scope().paginate(:page => params[:page])

      @killed_id = SaleCaseStatus.find_by(name: 'Killed').id

      case params['filter']
        when "active"
          @contacts = Contact.people_not_team_scope().user_scope()
        when "people"
          @contacts = Contact.people_not_team_scope().user_scope()
        when "companies"
          @contacts = Contact.company_not_client_scope().user_scope()
        when "team"
          @contacts = Contact.team_scope().user_scope()
        else
          @contacts = Contact.people_not_team_scope().user_scope().where("EXISTS(SELECT 1 from projects where (contacts.id = projects.primary_contact_id or contacts.id = projects.sale_contact_id or contacts.id = projects.referral_contact_id) and (projects.project_state_id = 1 or projects.sale_case_status_id != #{@killed_id}))")

        end

      case params['sort']
        when "type"
          @contacts = @contacts.includes(:contact_type).order("contact_types.name #{sort_direction}").paginate(:page => params[:page])
        when "company"
          @contacts = @contacts.order("contacts.company_name #{sort_direction}").paginate(:page => params[:page])
        when "since"
          @contacts = @contacts.order("contacts.created_at #{sort_direction}").paginate(:page => params[:page])
        else
          @contacts = @contacts.full_name_order_scope(sort_direction).paginate(:page => params[:page])
        end

    @total_records = @contacts.count
    @total_records_goal = Option.find_by(:key=>'contact_count_goal').value.to_i
    @total_records_clr = @total_records >= @total_records_goal ? 'green' : 'red'
  end

  # GET /contacts/1
  # GET /contacts/1.json
  def show
    @emails = @contact.emails
    @addresses = @contact.addresses
    @phone_numbers = @contact.phone_numbers
    @website_urls = @contact.website_urls
    @contact_skills = @contact.contact_skills
    @activities = @contact.activities.order(created_at: :desc).limit(10)
    @tasks = @contact.tasks.where("completed_at > ?", Date.today.beginning_of_day).order(completed_at: :asc).limit(10)
    @referral_projects = Project.where(:referral_contact_id => @contact.id).order('project_number DESC').paginate(:page => params[:project_page])
    @projects = Project.project_scope.where(:primary_contact_id => @contact.id).order('project_number DESC').paginate(:page => params[:project_page])
    search = @contact.id
    Project.project_scope.where("primary_contact_id EQUALS ? OR agency_contact_id EQUALS ? OR client_contact_id EQUALS ? OR team_contact_id EQUALS ? OR sales_contact_id EQUALS ?", "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%")

    @activity = Activity.new
    @activity.contact_id = @contact.id
    @activity_types = ActivityType.all
    @activity_objects = ActivityObject.all

    @task = Task.new
    @task.contact_id = @contact.id
    @task_types = TaskType.all
    @contacts = Contact.user_scope().all
    load_lists
  end

  def activity
    id = params[:id]
    user_id= params[:user]
    @contact = Contact.user_scope().find(id)

    where_params = {
      contact_id: id,
    }

    @activities = Activity.user_scope().where(where_params).order(created_at: :desc).paginate(:page => params[:page])
    @activities = @activities.where(:user_id => user_id) if user_id.present?
  end

  def tasks
    id = params[:id]
    user_id= params[:user]
    @contact = Contact.user_scope().find(id)

    @tasks = Task.user_scope().where(:contact_id => id).order(created_at: :desc).paginate(:page => params[:page])
    @tasks = @tasks.where(:user_id => user_id) if user_id.present?
  end

  # GET /contacts/new
  def new
    @contact = Contact.new
    load_lists
  end

  # GET /contacts/1/edit
  def edit
    @contacts = Contact.people_not_team_scope().order(last_name: :asc)
    load_lists
  end

  # POST /contacts
  # POST /contacts.json
  def create
    @contact = Contact.new(contact_params)
    @contact.locale_id = current_user.locale_id
    respond_to do |format|
      if @contact.save!
        format.html { redirect_to @contact, notice: 'Contact was successfully created.' }
        format.json { render :show, status: :created, location: @contact }
      else
        load_lists
        format.html { render :new }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contacts/1
  # PATCH/PUT /contacts/1.json
  def update
    if (params[:contact][:is_client] == 'true')
      @contact.is_client = true
      @contact.save!
    end
    if (params[:contact][:is_team] == 'true')
      @contact.is_team = true
      @contact.save!
    end
    respond_to do |format|
      if @contact.update(contact_params)
        format.html { redirect_to @contact, notice: 'Contact was successfully updated.' }
        format.json { render :show, status: :ok, location: @contact }
      else
        load_lists
        format.html { render :edit }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contacts/1
  # DELETE /contacts/1.json
  def destroy
    @contact.destroy
    respond_to do |format|
      format.html { redirect_to contacts_url, notice: 'Contact was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def linkedin

  end

  def create_linkedin
     client = LinkedIn::Client.new(ENV['LINKEDIN_CONSUMER_KEY'], ENV['LINKEDIN_CONSUMER_SECRET'])
      if session[:auth_token].nil?
        pin = params[:oauth_verifier]
        auth_token, auth_secret = client.authorize_from_request(session[:rtoken], session[:rsecret], pin)
        session[:auth_token] = auth_token
        session[:auth_secret] = auth_secret
      else
        client.authorize_from_access(session[:auth_token], session[:auth_secret])
      end
      username = params['username']
      begin
        @profile = client.profile(:url => "http://www.linkedin.com/in/#{username}", :fields => ['first_name', 'last_name','num-connections','num-connections-capped','summary', 'email-address', 'headline','public-profile-url','site-standard-profile-request', 'positions', 'picture-urls::(original)'])
      rescue LinkedIn::Errors::NotFoundError => e
        redirect_to auth_settings_social_networks_linkedin_path, :flash => { :error => "User Not Found" } and return
      rescue LinkedIn::Errors::AccessDeniedError => e
        redirect_to auth_settings_social_networks_linkedin_path, :flash => { :error => "Permission denied: You don't have access to the profile" } and return
      ensure
        @profile
      end

        if @profile.first_name == "private"
          redirect_to auth_settings_social_networks_linkedin_path, :flash => { :error => "#{username} is a private User" } and return
        end
        @contact = Contact.new
        connections = {
          num_connections: @profile.num_connections,
          connections_capped: @profile.num_connections_capped,
          public_profile: @profile.public_profile_url,
          site_profile: @profile.site_standard_profile_request.url,
          username: username
        }
        if @profile.picture_urls.total > 0
          picture_url = @profile.picture_urls.all.first
          @contact.profile_img_from_url(picture_url)
        end
        @contact.first_name = @profile.first_name
        @contact.last_name = @profile.last_name
        @contact.about = @profile.summary
        @contact.title = @profile.headline
        if @profile.positions.total > 0
          @contact.company_name = @profile.positions.all.first.company.name
        end
        @contact.email = @profile.email_address
        @contact.locale_id = current_user.locale_id

        type = params['contact_type'].downcase
        case type
        when "client"
          @contact.contact_type = ContactType.find_by_name("Company")
            if @profile.positions.total > 0
              name = @profile.positions.all.first.company.name
              name = name.gsub(/[aeiou]/i, '')[0,3].upcase
              test_slug = Contact.find_by slug: name
              if test_slug.nil?
                @contact.slug = name
              else
                name << name.last.next
                name.slice!(2)
                @contact.slug = name
              end
            end
          @contact.is_client = true
          respond_to do |format|
            if @contact.save
              create_social_reach(@contact, connections)
              format.html { redirect_to client_path(@contact), notice: 'Client was successfully created.' }
              format.json { render :show, status: :created, location: @contact }
            else
              load_lists
              format.html { render :new }
              format.json { render json: @contact.errors, status: :unprocessable_entity }
            end
          end
        when "teammate"
          @contact.contact_type = ContactType.find_by_name("Teammate")
          @contact.is_team = true
          respond_to do |format|
            if @contact.save
              create_social_reach(@contact, connections)
              format.html { redirect_to @contact, notice: 'Contact was successfully created.' }
              format.json { render :show, status: :created, location: @contact }
            else
              load_lists
              format.html { render :new }
              format.json { render json: @contact.errors, status: :unprocessable_entity }
            end
          end
        when "customer"
          @contact.contact_type = ContactType.find_by_name("Customer")
          respond_to do |format|
            if @contact.save
              create_social_reach(@contact, connections)
              format.html { redirect_to @contact, notice: 'Contact was successfully created.' }
              format.json { render :show, status: :created, location: @contact }
            else
              load_lists
              format.html { render :new }
              format.json { render json: @contact.errors, status: :unprocessable_entity }
            end
          end
        when "company"
          @contact.contact_type = ContactType.find_by_name("Company")
          respond_to do |format|
            if @contact.save
              create_social_reach(@contact, connections)
              format.html { redirect_to @contact, notice: 'Company was successfully created.' }
              format.json { render :show, status: :created, location: @contact }
            else
              load_lists
              format.html { render :new }
              format.json { render json: @contact.errors, status: :unprocessable_entity }
            end
          end
        when "lead"
          @contact.contact_type = ContactType.find_by_name("Lead")
          respond_to do |format|
            if @contact.save
              create_social_reach(@contact, connections)
              format.html { redirect_to @contact, notice: 'Contact was successfully created.' }
              format.json { render :show, status: :created, location: @contact }
            else
              load_lists
              format.html { render :new }
              format.json { render json: @contact.errors, status: :unprocessable_entity }
            end
          end
        when "partner"
          @contact.contact_type = ContactType.find_by_name("Partner")
          respond_to do |format|
            if @contact.save
              create_social_reach(@contact, connections)
              format.html { redirect_to @contact, notice: 'Contact was successfully created.' }
              format.json { render :show, status: :created, location: @contact }
            else
              load_lists
              format.html { render :new }
              format.json { render json: @contact.errors, status: :unprocessable_entity }
            end
          end
        else
          @contact.contact_type = ContactType.find_by_name("Associate")
          respond_to do |format|
            if @contact.save
              create_social_reach(@contact, connections)
              format.html { redirect_to @contact, notice: 'Contact was successfully created.' }
              format.json { render :show, status: :created, location: @contact }
            else
              load_lists
              format.html { render :new }
              format.json { render json: @contact.errors, status: :unprocessable_entity }
            end
          end
        end
  end

  def create_social_reach(contact, connections)
    test_reach = SocialReach.where(social_network_id: 7).where(username: connections[:username]).first
    if test_reach.nil?
      reach = SocialReach.new
      reach.total_reach = connections[:num_connections]
      reach.username = connections[:username]
      reach.social_network_id = SocialNetwork.find_by_name('Linkedin').id
      reach.contact_id = contact.id
      reach.save
    else
      puts "Social Reach for #{contact.full_name} already exits"
    end
  end

  def become_client
    @contact = Contact.find_by(id: params['id'])
    @contact.is_client = true
    name = @contact.company_name
    name = name.gsub(/[aeiou]/i, '')[0,3].upcase
    test_slug = Contact.find_by slug: name
    if test_slug.nil?
      @contact.slug = name
    else
      name << name.last.next
      name.slice!(2)
      @contact.slug = name
    end
    respond_to do |format|
      if @contact.save
        format.html { redirect_to client_path(@contact), notice: 'Contact was successfully created.' }
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


  private


    # Use callbacks to share common setup or constraints between actions.
    def set_contact
      @contact = Contact.user_scope().find_by(id: params[:id])
      if !@contact.present?
        redirect_to contacts_path, :flash => { :error => "Contact Not Found!" }
      end
    end

    def load_lists
      if @contact.contact_type.present?
        if @contact.contact_type.name == "Teammate"
          @contact_types = ContactType.all
        else
          @contact_types = ContactType.where.not(name: 'Teammate').order('name ASC')
        end
      else
        @contact_types = ContactType.where.not(name: 'Teammate').order('name ASC')
      end
      @contacts = Contact.people_not_team_scope
      @connections = @contact.user_connections
      @companies = ContactType.find_by_name('Company').contacts.order('company_name ASC')
      @social_networks = SocialNetwork.all.order('name ASC')
      @time_zones = TimeZone.all
      @self_expression_types = SelfExpressionType.all.order('name ASC')
      @directional_motivations = DirectionalMotivation.all.order('name ASC')
      @states = State.all.order('name ASC')
      @countries = Country.all.order('name ASC')
      @default_country = Option.where(:key=>'default_country_id').first.value
    end

    def sort_column
      ['name', 'company', 'type', 'since', 'rating'].include?(params[:sort]) ? params[:sort] : 'name'
    end

    def sort_direction
      params[:direction] == "desc" ? params[:direction] : "asc"
    end


    # Never trust parameters from the scary internet, only allow the white list through.
    def contact_params
      params.require(:contact).permit(
        :first_name,
        :last_name,
        :email,
        :title,
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
        :title,
        :self_expression_type_id,
        :directional_motivation_id,
        :time_zone_id,
        :tag_list,
        :company_contact_id,
        :company_name,
        :score,
        addresses_attributes: [:id, :name, :address1, :address2, :city, :state_id, :country_id, :postal_code, :_destroy],
        emails_attributes: [:id, :name, :email, :contact_id, :_destroy],
        website_urls_attributes: [:id, :name, :url, :contact_id, :_destroy],
        contact_skills_attributes: [:id, :name, :contact_id, :_destroy],
        phone_numbers_attributes: [:id, :name, :number, :contact_id, :_destroy],
        social_reaches_attributes: [:id, :total_reach, :username, :social_network_id, :contact_id, :_destroy],
        user_connections_attributes: [:id, :name, :connector_id, :connectie_id, :_destroy]
      )
    end

end
