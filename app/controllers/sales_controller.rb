class SalesController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]
  helper_method :sort_column, :sort_direction

  respond_to :html

  def index
    @cold_id = SaleCaseStatus.find_by(name: 'Cold').id
    @warm_id = SaleCaseStatus.find_by(name: 'Warm').id
    @hot_id = SaleCaseStatus.find_by(name: 'Hot').id
    @killed_id = SaleCaseStatus.find_by(name: 'Killed').id

    case params['filter']
    when "cold"
      @projects = Project.where(sale_case_status_id: @cold_id).sales_case_scope
    when "warm"
      @projects = Project.where(sale_case_status_id: @warm_id).sales_case_scope
    when "hot"
      @projects = Project.where(sale_case_status_id: @hot_id).sales_case_scope
    when "killed"
      @projects = Project.where(sale_case_status_id: @killed_id).sales_case_scope
    when "all"
      @projects = Project.where.not(sale_case_status_id: @killed_id).sales_case_scope
    else
      @projects = Project.where(sale_case_status_id: @hot_id).sales_case_scope
    end

    case params['sort']
      when "name"
        @projects = @projects.order("name #{sort_direction}").paginate(:page => params[:page])
      when "status"
        @projects = @projects.includes(:sale_case_status).order("sale_case_statuses.name #{sort_direction}").paginate(:page => params[:page])
      else
        @projects = @projects.order("name #{sort_direction}").paginate(:page => params[:page])
      end



    @total_records = Project.where(:project_state_id => @sales_id).count
    @total_records_goal = Option.find_by(:key=>'sales_case_count_goal').value.to_i
    @total_records_clr = @total_records >= @total_records_goal ? 'green' : 'red'
  end

  def show
    load_lists
    @project_contacts = Contact.joins(:project_contacts).where(project_contacts: {project_id:@project.id})
    respond_with(@project)
  end

  def new
    @project = Project.new
    load_lists
  end

  def edit
    load_lists
    respond_with(@project)
  end

  def create
    @project = Project.new(project_params)
    @sales_state = ProjectState.where(:name=>'Sales').first
    @project.project_state_id = @sales_state.id

    respond_to do |format|
      if @project.save
        format.html { redirect_to sale_path(@project), notice: 'Sales Case was successfully created.' }
        format.json { render :show, status: :created, location: @project }
      else
        flash[:error] = @contact.errors.full_messages
        @project = Proejct.new(project_params)
        load_lists
        format.html { render :new }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @project.update(project_params)
    redirect_to sale_path(@project.case_number)
  end

  def destroy
    @project.destroy
    respond_with(@project)
  end

  def payments
    @owed = PaymentSchedule.payments_owed_sum
    @paid = PaymentSchedule.paid_payments_sum
  end

  def payments_data
    @invoices = PaymentSchedule.where.not(invoice_date: nil).where.not(received_date: nil).order("project_id ASC")
    render :json=>{
              :data => @invoices.map{|invoice|{
                          :id => invoice.id,
                          :text => invoice.project.project_number,
                          :start_date => invoice.invoice_date.to_formatted_s(:db),
                          :duration => invoice.duration,
                          :progress => invoice.progress,
                          :sortorder => invoice.sortorder,
                          :parent => invoice.parent
                      }}
                    }
  end


  private
    def set_project
      if params[:case_number].present?
        @project = Project.find_by_case_number(params[:case_number])
        if !@project.present?
          redirect_to sales_path, :flash => { :error => "Sale: #{params[:case_number]} Not Found!" }
        end
      else
        @project = Project.find_by_id(params[:id])
      end
    end

    def load_lists
      @sale_case_statuses = SaleCaseStatus.all
      @team_id = ContactType.find_by(name: 'Teammate').id
      @active_id = ProjectState.find_by(name: 'Active').id
      @sales_id = ProjectState.find_by(name: 'Sales').id
      @archive_id = ProjectState.find_by(name: 'Archived').id
      @clients = Contact.company_scope().user_scope().full_name_order_scope()
      @agencies = Contact.company_scope().user_scope().full_name_order_scope()
      @teams = Contact.team_scope().user_scope().full_name_order_scope()
      @contacts = Contact.where.not(contact_type_id: @team_id).people_scope().user_scope().full_name_order_scope()
      @project_states = ProjectState.all().order('name ASC')
      @project_types = ProjectType.all().order('name ASC')
      @total_records = Project.all.count
    end

    def sort_column
      ['name', 'status'].include?(params[:sort]) ? params[:sort] : "name"
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
          :thumbnail_image,
          :sale_case_status_id,
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
