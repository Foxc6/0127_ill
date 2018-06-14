require 'rails_helper'

RSpec.describe ProjectsController, :type => :controller do
  include Devise::Test::ControllerHelpers

  before do
    sign_in FactoryGirl.create(:user)
  end

  describe "GET index" do
    it "renders index page" do
      get :index
      expect(response).to render_template("index")
    end

    it "assigns @total_records" do
      @total_records = Project.where.not(project_state_id: @sales_id).count
      get :index
      expect(assigns(:total_records)).to eq(@total_records)
    end

    it "assigns @total_records_goal" do
      @total_records_goal = Option.where(:key=>'projects_count_goal').first.value.to_i
      get :index
      expect(assigns(:total_records_goal)).to eq(@total_records_goal)
    end

    it "sorts by active projects" do
      get :index, :filter => 'active'
      filter_id = ProjectState.find_by(name: 'Active').id
      assigns(:projects).each do |project|
        expect(project.project_state_id).to eq(filter_id)
      end
    end

    it "sorts by complete projects" do
      get :index, :filter => 'complete'
      filter_id = ProjectState.find_by(name: 'Complete').id
      assigns(:projects).each do |project|
        expect(project.project_state_id).to eq(filter_id)
      end
    end

    it "sorts by paused projects" do
      get :index, :filter => 'paused'
      filter_id = ProjectState.find_by(name: 'Paused').id
      assigns(:projects).each do |project|
        expect(project.project_state_id).to eq(filter_id)
      end
    end

    it "sorts by archived projects" do
      get :index, :filter => 'archived'
      filter_id = ProjectState.find_by(name: 'Archived').id
      assigns(:projects).each do |project|
        expect(project.project_state_id).to eq(filter_id)
      end
    end
  end

  describe "GET show" do
    it "renders the show template" do
      project = Project.where(project_state_id: 1).first
      get :show, :project_number => project.project_number
      expect(response).to render_template("show")
    end

    it "calls load_list" do
      team_id = ContactType.find_by(name: 'Teammate').id
      active_id = ProjectState.find_by(name: 'Active').id
      sales_id = ProjectState.find_by(name: 'Sales').id
      archive_id = ProjectState.find_by(name: 'Archived').id
      clients = Contact.client_scope().user_scope().full_name_order_scope()
      agencies = Contact.client_scope().user_scope().full_name_order_scope()
      teams = Contact.team_scope().user_scope().full_name_order_scope()
      contacts = Contact.where.not(contact_type_id: @team_id).people_scope().user_scope().full_name_order_scope()
      project_states = ProjectState.where.not(name: "Sales").where.not(name: "Archived")
      project_types = ProjectType.all().order('name ASC')
      total_records = Project.all.count


      project = Project.where(project_state_id: 1).first
      get :show, :project_number => project.project_number
      expect(assigns(:team_id)).to eq(team_id)
      expect(assigns(:active_id)).to eq(active_id)
      expect(assigns(:sales_id)).to eq(sales_id)
      expect(assigns(:archive_id)).to eq(archive_id)
      expect(assigns(:clients)).to eq(clients)
      expect(assigns(:agencies)).to eq(agencies)
      expect(assigns(:teams)).to eq(teams)
      expect(assigns(:contacts)).to match_array(contacts)
      expect(assigns(:project_states)).to eq(project_states)
      expect(assigns(:project_types)).to eq(project_types)
      expect(assigns(:total_records)).to eq(total_records)
    end

    it "loads project team members" do
      project = Project.where(project_state_id: 1).first
      project_team_members = project.project_team_members
      get :show, :project_number => project.project_number
      expect(assigns(:project_team_members)).to eq(project_team_members)
    end

    it "loads project contacts" do
      project = Project.where(project_state_id: 1).first
      project_contacts = project.project_contacts
      get :show, :project_number => project.project_number
      expect(assigns(:project_contacts)).to eq(project_contacts)
    end
  end

  describe "GET new" do
    render_views;
    it "renders new project page" do
      get :new
      expect(response).to render_template("new")
    end

    it "renders form" do
      get :new
      expect(response).to render_template(partial: '_form')
    end
  end

  describe "POST create" do
    it 'creates a new project' do
      @project = FactoryGirl.attributes_for(:project)
      params = {}
      params["project"] = @project
      expect {
        post :create, params
      }.to change(Project, :count).by(1)
    end

    it 'redirects to project show page' do
      @project = FactoryGirl.attributes_for(:project)
      params = {}
      params["project"] = @project
      post :create, params
      expect(response).to redirect_to(project_path(assigns[:project]))
    end
  end

   describe "PUT update/:project_number" do
    it "redirects to project show page" do
      active_id = ProjectState.find_by(name: 'Active').id
      @project = Project.where(project_state_id: active_id).sample
      put :update, id: @project.project_number, project: {project_number: @project.project_number, name: "New Name"}
      @project.reload
      expect(response).to redirect_to(project_path(assigns[:project]))
      expect(@project.name).to eql("New Name")
    end

  end

  describe "Get edit" do
    render_views;
    it "renders form" do
      project = Project.where(project_state_id: 1).first
      get :edit, :project_number => project.project_number
      expect(response).to render_template(partial: '_form')
    end
  end

  describe "Destroy Project" do
    it "deletes the Project" do
      @project = Project.all.sample
      if @project.project_number.blank?
        @project.project_number = "TST123"
        @project.save
      end
      expect{
        delete :destroy, :id => @project.project_number
     }.to change(Project, :count).by(-1)
    end
  end

  describe "Archive Project" do
    it "archives project" do
      active_id = ProjectState.find_by(name: 'Active').id
      @project = Project.where(project_state_id: active_id).sample
      post :archive, :project_number => @project.project_number
      @project.reload
      expect(@project.project_state.name).to eql("Archived")
    end
  end

  describe "Activate Project" do
    it "activates project" do
      sale_id = ProjectState.find_by(name: 'Sales').id
      @project = Project.where(project_state_id: sale_id).sample
      post :activate_project, :project_number => @project.case_number
      @project.reload
      expect(@project.project_state.name).to eql("Active")
    end
  end
end
