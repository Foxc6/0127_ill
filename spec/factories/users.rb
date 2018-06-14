require 'faker'

FactoryGirl.define do
  factory :user do |f|
    f.first_name { Faker::Name.first_name }
    f.last_name { Faker::Name.last_name }
    f.email { Faker::Internet.safe_email }
    f.password "password"
    f.password_confirmation "password"
    f.locale_id 1
    f.role_id 1
  end

end
