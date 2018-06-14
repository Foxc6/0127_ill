require 'rails_helper'

RSpec.describe Project, :type => :model do

  it "has a valid factory" do
    project = FactoryGirl.create(:project)
    expect(project).to be_instance_of(Project)
  end

end
