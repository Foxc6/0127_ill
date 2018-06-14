class ClientsController < ApplicationController

  before_action :set_client, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!
  helper_method :sort_column, :sort_direction
  require 'will_paginate/array'

  # GET /clients
  # GET /clients.json
  def index
    # Clients search query
    #@contacts = Contact.client_scope().user_scope().search(params[:search]).order(:company_name).paginate(:page => params[:page])

      #@contacts = Contact.client_scope().user_scope().order(:company_name).paginate(:page => params[:page])


    case params['filter']
      when "all"
        @contacts = Contact.client_scope().user_scope()
      when "positive"
        @contacts = Contact.client_scope().user_scope()
      when "negative"
        @contacts = Contact.client_scope().user_scope()
      else
        @contacts = Contact.client_scope().user_scope()
      end

    case params['sort']
      when "name"
        @contacts =  @contacts.full_name_order_scope(sort_direction).paginate(:page => params[:page])
      when "project-number"
        if params['direction'] == 'desc'

          @contacts = @contacts.sort_by {|contact| contact.projects_count}.reverse.paginate(:page => params[:page])
        else
          @contacts = @contacts.sort_by {|contact| contact.projects_count}.paginate(:page => params[:page])
        end

      else
        @contacts = @contacts.full_name_order_scope(sort_direction).paginate(:page => params[:page])
      end



    @total_records = @contacts.count
    @total_records_goal = Option.find_by(:key=>'client_count_goal').value.to_i
    @total_records_clr = @total_records >= @total_records_goal ? 'green' : 'red'
  end

  # GET /clients/1
  # GET /clients/1.json
  def show
    @company_contacts = @contact.company_contacts
    @emails = @contact.emails
    @addresses = @contact.addresses
    @phone_numbers = @contact.phone_numbers
    @website_urls = @contact.website_urls
    @contact_skills = @contact.contact_skills
    @projects = Project.project_scope.where(:client_contact_id => @contact.id).order('project_number DESC').paginate(:page => params[:project_page])
    @agency_projects = Project.project_scope.where(:agency_client_contact_id => @contact.id).order('project_number DESC')
    @sales_cases = Project.sales_case_scope.where(:client_contact_id => @contact.id).order('project_number DESC').paginate(:page => params[:project_page])
    load_lists
  end

  # GET /clients/new
  def new
    @contact = Contact.new
    load_lists
  end

  # GET /clients/1/edit
  def edit
    load_lists
  end

  # POST /clients
  # POST /clients.json
  def create
    @contact = Contact.new(contact_params)
    @contact.locale_id = current_user.locale_id
    @contact.contact_type_id = 32
    @contact.slug = @contact.slug.upcase
    @contact.is_client = true
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

  # PATCH/PUT /clients/1
  # PATCH/PUT /clients/1.json
  def update
    respond_to do |format|
    @contact.contact_type_id = 32

    contact_params[:slug] = contact_params[:slug].upcase
      if @contact.update(contact_params)
        format.html { redirect_to client_path(@contact), notice: 'Contact was successfully updated.' }
        format.json { render :show, status: :ok, location: @contact }
      else
        flash[:error] = @contact.errors.full_messages
        format.html { render :edit }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /clients/1
  # DELETE /clients/1.json
  def destroy
    @contact.destroy
    respond_to do |format|
      format.html { redirect_to contacts_url, notice: 'Contact was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_client
      @contact = Contact.user_scope().find_by_slug(params[:slug])
       if !@contact.present?
        redirect_to clients_path, :flash => { :error => "Client Not Found!" }
      end
    end

    def load_lists
      @companies = ContactType.find_by_name('Company').contacts.order('company_name ASC')
      @contact_types = ContactType.all
      @time_zones = TimeZone.all
      @social_networks = SocialNetwork.all
      @states = State.all.order('name ASC')
      @countries = Country.all.order('name ASC')
      @default_country = Option.where(:key=>'default_country_id').first.value
      @contacts = Contact.people_scope().general_scope()
    end

    def sort_column
      ['name', 'project-number'].include?(params[:sort]) ? params[:sort] : 'name'
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
        :payee_name,
        :company_contact_id,
        client_contacts_attributes: [:id, :name, :client_id, :contact_id, :_destroy],
        addresses_attributes: [:id, :name, :address1, :address2, :city, :state_id, :country_id, :postal_code, :_destroy],
        emails_attributes: [:id, :name, :email, :contact_id, :_destroy],
        website_urls_attributes: [:id, :name, :url, :contact_id, :_destroy],
        contact_skills_attributes: [:id, :name, :contact_id, :_destroy],
        phone_numbers_attributes: [:id, :name, :number, :contact_id, :_destroy],
        social_reaches_attributes: [:id, :total_reach, :username, :social_network_id, :contact_id, :_destroy]
      )
    end

end
