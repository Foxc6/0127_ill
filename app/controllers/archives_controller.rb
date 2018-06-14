class ArchivesController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]


  respond_to :html

  def index
     @archive_id = ProjectState.find_by(name: 'Archived').id
    if params[:search]
      @projects = Project.where(:project_state => @archive_id).search(params[:search]).paginate(:page => params[:page]).order('project_number DESC')
    else
      @projects = Project.where(:project_state_id => @archive_id).paginate(:page => params[:page]).order('project_number DESC')
    end

    @total_records = Project.where(:project_state_id => @archive_id).count
    @total_records_goal = 133
    @total_records_clr = @total_records >= @total_records_goal ? 'green' : 'red'
  end

  def show
    respond_with(@project)
  end

  def new
    @project = Project.new
    load_lists
    respond_with(@project)
  end

  def edit
    load_lists
    respond_with(@project)
  end

  def create
    @project = Project.new(project_params)
    @project.save
    respond_with(@project)
  end

  def update
    @project.update(project_params)
    respond_with(@project)
  end

  def destroy
    @project.destroy
    respond_with(@project)
  end


  private
    def set_project
      @project = Project.find(params[:id])
    end

    def load_lists
      @clients = Contact.client_scope().user_scope().full_name_order_scope()
      @agencies = Contact.client_scope().user_scope().full_name_order_scope()
      @teams = Contact.team_scope().user_scope().full_name_order_scope()
      @contacts = Contact.general_scope().user_scope().full_name_order_scope()
      @project_states = ProjectState.all().order('name ASC')
      @project_types = ProjectType.all().order('name ASC')
      @total_records = Project.all.count
    end

    def project_params
      params.require(:project).permit(
          :id,
          :name,
          :project_state_id,
          :client_contact_id,
          :team_contact_id,
          :project_type_id,
          :tags,
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
          :case_id,
          project_contacts_attributes: [:id, :name, :project_id, :contact_id, :_destroy]
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
