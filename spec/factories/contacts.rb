require 'faker'

type = ContactType.first
FactoryGirl.define do
  factory :contact do |f|
    f.first_name { Faker::Name.first_name }
    f.last_name { Faker::Name.last_name }
    f.contact_type  type
  end
end
