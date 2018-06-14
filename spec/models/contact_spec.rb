require 'rails_helper'

RSpec.describe Contact, :type => :model do

  it "has a valid factory" do
    contact = FactoryGirl.create(:contact)
    expect(contact).to be_instance_of(Contact)
  end
  it "displays full name" do
    contact = FactoryGirl.create(:contact, first_name: "Andy", last_name: "Lindeman")
    expect(contact.full_name).to eq("Andy Lindeman")
  end

  it "has no company contacts when no company contacts are set" do
    contact = FactoryGirl.create(:contact)
    expect(contact.company_contacts.length).to eq(0)
  end

  it "has no projects when no projects are set" do
    contact = FactoryGirl.create(:contact)
    expect(contact.projects_count).to eq(0)
  end
end
