require 'rails_helper'

RSpec.describe AccountController, :type => :controller do
  include Devise::Test::ControllerHelpers

  before :each do
    current_user = User.first
    sign_in current_user
  end

  describe "GET show" do
    it "assigns @activities" do
      @activities = Activity.all
      get :show

      expect(assigns(:activities).length).to eq(@activities.length)
    end

    it "renders the show template" do
      get :show
      expect(response).to render_template("show")
    end
  end

  describe "GET edit" do
    it "renders edit template" do
      get :edit
      expect(response).to render_template("edit")
    end

    it "assigns user" do
      current_user = User.first
      get :edit, current_user: current_user
      expect(assigns(:user)).to eql(current_user)
    end
  end

  describe "activities" do
    it "assigns the current user's activities" do
      current_user = User.first
      @activities = Activity.where({user_id:current_user.id})
      get :activities
      expect(assigns(:activities).any?).to eql(@activities.any?)
    end
  end
end
