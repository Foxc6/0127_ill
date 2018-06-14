class EstimatesController < ApplicationController
  before_action :set_estimate, only: [:show, :edit, :update, :destroy]
  helper_method :sort_column, :sort_direction

  respond_to :html

  def index
    @estimates = Estimate.all
    respond_with(@estimates)

    case params['sort']
      when "number"
        @estimates = @estimates.order("number #{sort_direction}").paginate(:page => params[:page])
      when "client_id"
        @estimates = @estimates.includes(:client_id).order("client_id #{sort_direction}").paginate(:page => params[:page])
      when "total"
        @estimates = @estimates.order("total #{sort_direction}").paginate(:page => params[:page])
      when "date"
         @estimates = @estimates.order("date #{sort_direction}").paginate(:page => params[:page])
      else
        params[:direction] = 'desc'
        @estimates = @estimates.order("number desc").paginate(:page => params[:page])
      end
  end

  def show
    load_lists
    @client = @estimate.client
    @project = @estimate.project
    @company = Contact.find_by(id: @estimate.company_id)
    @client_address = Address.where(contact_id: @estimate.client_id).where(id: @estimate.client_address_id).first
    set_client_address_state
    @company_address = Address.where(contact_id: @estimate.company_id).first
    @company_state = State.where(id: @company_address.state_id).first
    @company_state_name = @company_state.name

    respond_to do |format|
      format.html
      format.pdf do
        pdf = EstimatePdf.new(@estimate, view_context)
        send_data pdf.render, filename: "estimate_#{@estimate.number}.pdf",
                              type: "application/pdf"
      end
    end
  end

  def new
    @states = State.all.order('name ASC')
    @projects = Project.all
    @clients = Contact.company_scope().user_scope().full_name_order_scope()
    @estimate = Estimate.new
    @parent_line_items = EstimateLineItem.where("parent_id IS ?", nil)
    @estimate_line_item = @estimate.estimate_line_items.build
    respond_with(@estimate)
  end

  def edit
    @estimate_line_item = @estimate.estimate_line_items.build
    @client = @estimate.client
    @projects = Project.where(client_contact_id: @client.id).order('name ASC')
    load_lists
  end

  def create
    @states = State.all.order('name ASC')
    @estimate = Estimate.new(estimate_params)
    @estimate.save
    respond_with(@estimate)
  end

  def update
    @client = @estimate.client
    @states = State.all.order('name ASC')
    @company = Contact.find_by(id: @estimate.company_id)
    if params[:contact]
      @client.update(client_params)
    end
    @estimate.update(estimate_params)
    respond_with(@estimate)
  end

  def destroy
    @estimate.destroy
    respond_with(@estimate)
  end

  private

  def set_client_address_state
    if @client_address.present?
       @client_state = State.where(id: @client_address.state_id).first
       @client_state_name = @client_state.name
    else
      @no_client_string = "There is currently no address for #{@client.company_name} saved on the Estimate form!"
    end
  end

  def load_lists
    @states = State.all.order('name ASC')
    @clients = Contact.company_scope().user_scope().full_name_order_scope()
    @agencies = Contact.company_scope().user_scope().full_name_order_scope()
    @company_addresses = Address.where(contact_id: @estimate.company_id).all
    @client_addresses = Address.where(contact_id: @estimate.client_id).order('city ASC')
  end

  def sort_column
      ['number', 'client_id', 'date', 'total'].include?(params[:sort]) ? params[:sort] : "number"
    end

  def sort_direction
    params[:direction] == "desc" ? params[:direction] : "asc"
  end

  def set_estimate
    @estimate = Estimate.find(params[:id])
  end

  def estimate_params
    params.require(:estimate).permit(
        :id,
        :company_id,
        :client_id,
        :date,
        :number,
        :total,
        :client_address_id,
        :project_id,
        :created_at,
        :updated_at,
        estimate_line_items_attributes: [:id, :description, :price, :parent_id, :estimate_id, :position, :_destroy],
        client: [:id, :company_name, :addresses],
        client_address: [:id, :name, :address1, :address2, :city, :state_id, :country_id, :postal_code, :_destroy]

    )
  end

  def estimate_line_item_params
    params.require(:estimate_line_item).permit(
        :id,
        :description,
        :price,
        :parent_id,
        :estimate_id,
        :position,
        :created_at,
        :updated_at,
        estimate_attributes: [:id, :company_id, :client_id, :date, :number, :total, :client_address_id, :project_id]
    )
  end

  def client_params
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
