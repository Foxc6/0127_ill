require 'faker'
FactoryGirl.define do
  factory :project do |f|
    f.name { Faker::Company.name }
    f.project_state_id  { ProjectState.first.present? ? ProjectState.first.id : FactoryGirl.create(:project_state).id }
    f.client_contact_id { Contact.first.present? ? Contact.first.id : FactoryGirl.create(:contact).id }
    f.project_type_id { ProjectType.first.present? ? ProjectType.first.id : FactoryGirl.create(:project_type).id }
    f.url {Faker::Internet.url}
    f.start_date {Faker::Date.forward(1)}
    f.end_date {Faker::Date.forward(223)}
    f.notes {Faker::Lorem.paragraph}
    f.agency_client_contact_id { Contact.first.present? ? Contact.first.id : FactoryGirl.create(:contact).id }
    f.score 1
    f.team_contact_id  { Contact.where(contact_type_id: 3).first.present? ? Contact.first.id : FactoryGirl.create(:contact, contact_type_id: 3).id }
  end
end
