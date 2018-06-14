class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]
  helper_method :sort_column, :sort_direction

  respond_to :html


  def remove_tag
    @project = Project.find_by(project_number: params[:id])
    @project.tag_list.remove(params[:tag])
    @project.save
    redirect_to(request.env['HTTP_REFERER'])
  end

  def add_tag
    @project = Project.find_by(project_number: params[:id])
    if params[:tag].present?
      @project.tag_list.add(params[:tag])
    else
      @project.tag_list.add(params[:name])
    end
    @project.save
    redirect_to(request.env['HTTP_REFERER'])
  end

  def index
    @active_id = ProjectState.find_by(name: 'Active').id
    @complete_id = ProjectState.find_by(name: 'Complete').id
    @pause_id = ProjectState.find_by(name: 'Paused').id
    @archive_id = ProjectState.find_by(name: 'Archived').id
    @archive_id = ProjectState.find_by(name: 'Sales').id

    case params['filter']
      when "active"
        @projects = Project.where(project_state_id: @active_id)
      when "complete"
        @projects = Project.where(project_state_id: @complete_id)
      when "paused"
        @projects = Project.where(project_state_id: @pause_id)
      when "archived"
        @projects = Project.where(project_state_id: @archived_id)
      else
        @projects = Project.where(project_state_id: @active_id)
      end

    case params['sort']
      when "name"
        @projects = @projects.order("project_number #{sort_direction}").paginate(:page => params[:page])
      when "client"
        @projects = @projects.includes(:client).order("contacts.company_name #{sort_direction}").paginate(:page => params[:page])
      when "score"
        @projects = @projects.order("score #{sort_direction}").paginate(:page => params[:page])
      when "recieved"
         @projects = @projects.order("total #{sort_direction}").paginate(:page => params[:page])
      when "outstanding"
         @projects = @projects.order("estimated_total #{sort_direction}").paginate(:page => params[:page])
      else
        params[:direction] = 'desc'
        @projects = @projects.order("project_number desc").paginate(:page => params[:page])
      end
    if params[:q]
      @search = Project.search do
        keywords params[:q]
      end

      @projects = @search.results
    end

    @total_records = Project.where.not(project_state_id: @sales_id).count
    @total_records_goal = Option.find_by(:key=>'projects_count_goal').value.to_i
    @total_records_clr = @total_records >= @total_records_goal ? 'green' : 'red'
  end

  def show
    @payment_schedules = @project.payment_schedules.order('invoice_date ASC')
    @tags = ActsAsTaggableOn::Tag.all
    load_lists
    @project_team_members = @project.project_team_members
    @project_contacts = @project.project_contacts

    respond_with(@project)
  end

  def new
    @project = Project.new
    load_lists
  end

  def edit
    load_lists
  end

  def create
    @project = Project.new(project_params)
    respond_to do |format|
      if @project.save
        format.html { redirect_to @project, notice: 'Contact was successfully created.' }
        format.json { render :show, status: :created, location: @project }
      else
        load_lists
        format.html { render :new }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @project.update(project_params)
    respond_with(@project)
  end

  def destroy
    @project.destroy
    respond_with(@project)
  end

  def archive
    @project = Project.find_by(project_number: params['project_number'])
    @project.project_state = ProjectState.find_by(name: 'Archived')
    @project.save
    respond_with(@project)
  end

  def activate_project
    @project = Project.find_by(case_number: params['project_number'])
    if @project.start_date.nil? || @project.end_date.nil?
      redirect_to(request.env['HTTP_REFERER'], :flash => { :error => "A start date and end date must be set" })
    else
      client = @project.client
      if client.is_client?
        puts "#{client.company_name} is a client"
      else
        client.is_client = true
        name = client.company_name
        name = name.gsub(/[aeiou]/i, '')[0,3].upcase
        test_slug = Contact.find_by slug: name
          if test_slug.nil?
            client.slug = name
          else
            name << name.last.next
            name.slice!(2)
            client.slug = name
           end
        client.save!
      end
      @project.project_state = ProjectState.find_by(name: 'Active')
      @project.save!
      respond_with(@project)
    end
  end


  private
    def set_project
      @project = Project.where(:project_number => params[:id]).first
      if !@project.present?
        redirect_to projects_path, :flash => { :error => "Project Not Found!" }
      end
    end

    def load_lists
      @team_id = ContactType.find_by(name: 'Teammate').id
      @active_id = ProjectState.find_by(name: 'Active').id
      @sales_id = ProjectState.find_by(name: 'Sales').id
      @archive_id = ProjectState.find_by(name: 'Archived').id
      @clients = Contact.client_scope().user_scope().full_name_order_scope()
      @agencies = Contact.client_scope().user_scope().full_name_order_scope()
      @teams = Contact.team_scope().user_scope().full_name_order_scope()
      @contacts = Contact.where.not(contact_type_id: @team_id).people_scope().user_scope().full_name_order_scope()
      @project_states = ProjectState.where.not(name: "Sales").where.not(name: "Archived")
      @project_types = ProjectType.all().order('name ASC')
      @total_records = Project.all.count
    end

    def sort_column
      ['name', 'client', 'score', 'recieved', 'outstanding'].include?(params[:sort]) ? params[:sort] : "name"
    end

    def sort_direction
      params[:direction] == "desc" ? params[:direction] : "asc"
    end

    def project_params
      params.require(:project).permit(
          :id,
          :name,
          :project_state_id,
          :client_contact_id,
          :team_contact_id,
          :project_type_id,
          :tag_list,
          :url,
          :project_number,
          :referral_contact_id,
          :sale_contact_id,
          :agency_client_contact_id,
          :primary_contact_id,
          :start_date,
          :end_date,
          :sow_file_file_name,
          :sow_file_content_type,
          :sow_file_file_size,
          :sow_file_updated_at,
          :created_at,
          :updated_at,
          :score,
          :notes,
          :case_number,
          :thumbnail_image,
          project_images_attributes: [:id, :title, :image, :project_id],
          project_contacts_attributes: [:id, :name, :project_id, :contact_id, :_destroy],
          project_team_members_attributes: [:id, :name, :project_id, :contact_id, :_destroy],
          payment_schedules_attributes: [:id, :project_id, :received_date, :description, :payment_term_id, :invoice_date, :total, :duration, :payment_status_id, :contact_id, :invoice_number, :_destroy],
          urls_attributes: [:id, :name, :url, :_destroy]
      )
    end

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
        :tag_list,
        :title,
        :self_expression_type_id,
        :directional_motivation_id,
        :time_zone_id,
        :tag_list,
        :company_name,
        addresses_attributes: [:id, :name, :address1, :address2, :city, :state_id, :country_id, :postal_code, :_destroy],
        emails_attributes: [:id, :name, :email, :contact_id, :_destroy],
        website_urls_attributes: [:id, :name, :url, :contact_id, :_destroy],
        contact_skills_attributes: [:id, :name, :contact_id, :_destroy],
        phone_numbers_attributes: [:id, :name, :number, :contact_id, :_destroy],
        social_reaches_attributes: [:id, :total_reach, :username, :social_network_id, :contact_id, :_destroy]
      )
    end
end
