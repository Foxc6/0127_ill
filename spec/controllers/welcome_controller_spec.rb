require 'rails_helper'

RSpec.describe WelcomeController, :type => :controller do
  include Devise::Test::ControllerHelpers
  active_id = ProjectState.find_by(name: 'Active').id
  active_count = Project.where(project_state_id: active_id).count
  render_views

  before do
    sign_in FactoryGirl.create(:user)
  end

  describe "GET index" do
    it "assigns variables and displays" do
      get :index
      expect(assigns(:active_projects).count).to eq(active_count)
    end
  end

  describe "GET data" do
    it "assigns project data" do
      get :data
      expect(JSON.parse(response.body)["data"].length).to eq(active_count)
    end
  end

  describe "GET help" do
    it "renders help view" do
      get :help
      expect(response).to render_template('help')
    end
  end
end
